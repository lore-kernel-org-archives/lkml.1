Return-Path: <linux-kernel-owner+w=401wt.eu-S1761920AbXHMQYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761920AbXHMQYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S945321AbXHMPK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:10:58 -0400
Received: from web36607.mail.mud.yahoo.com ([209.191.85.24]:22639 "HELO
	web36607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S948064AbXHMPKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:10:54 -0400
X-YMail-OSG: TAiMnYsVM1ksfNFi_Zir8TO4zJ0efYg4M65oD6V2JIryzbd7KW7CKPbwFbzjtxgg9DKhnFkIPQ--
X-RocketYMMF: rancidfat
Date: Mon, 13 Aug 2007 08:10:53 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 00/16] Permit filesystem local caching [try #3]
To: Stephen Smalley <sds@tycho.nsa.gov>, David Howells <dhowells@redhat.com>
Cc: casey@schaufler-ca.com, torvalds@osdl.org, akpm@osdl.org,
       steved@redhat.com, trond.myklebust@fys.uio.no,
       linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1187013057.26008.46.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <287532.48750.qm@web36607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> On Mon, 2007-08-13 at 11:54 +0100, David Howells wrote:
> > Casey Schaufler <casey@schaufler-ca.com> wrote:
> > 
> > > Sigh. So it's not only SELinux specific, but RedHat specific as well.
> > 
> > *Blink*.  How did you come to that conclusion?
> > 
> > > >   (3) The cache driver wants to access the files in the cache, but it's
> > > >       running in the security context of either the aforementioned
> random
> > > >       process, or one of FS-Cache's thread pool.
> > > 
> > > I think that this is the point you should attack. Control the security
> > > characteristics of the cache driver properly and you shouldn't need the
> > > complexity that you're asking to introduce.
> > 
> > How?  The cache driver acts on behalf of someone else.  That someone else
> has
> > one security context, but the cache itself has to have a different context
> so
> > that the cache can be shared.
> > 
> > Furthermore, the cache driver doesn't have a security context per se.
> > 
> > > >       This security context, however, doesn't necessarily give it the
> > > >       rights to access what's in the cache, so the driver has to be
> > > >       permitted to act as a context appropriate to accessing the cache,
> > > >       without changing the overall security context of the random
> process
> > > >       (which would impact things trying to act on that process - kill()
> > > >       for example).
> > > 
> > > Can you run the cache as an independent thread and send it messages
> > > rather than trying to do things in the context of the calling process?
> > > I know that that involves extra bookkeeppingg, but it's lots safer.
> > 
> > It introduces more complexity, which I believe you were just arguing
> against
> > above...  It also incurs more kernel threads - which I really really want
> to
> > avoid.
> > 
> > I would rank the complexity and resource overhead of the act-as stuff in
> LSM
> > (or at least in SELinux) as much less than what you're suggesting.
> > 
> > As it stands, the FS-Cache layer has a pool of threads that CacheFiles
> makes
> > use of, but this can't be bound to the security of a specific cache because
> > there may be more than one cache of more than one cache driver type.
> > 
> > > Yes, and the SELinux semantics for what label to give a file don't
> > > help much, either. The problem with the "act_as" interfaces is that
> > > I wouldn't expect them to be any more reliable than the old access()
> > > system call, which never really gave you a helpful answer.
> > 
> > I don't see how act_as compares to access().
> > 
> > > Ideally you want to be running in the right context to create the
> > > new file so that no one can use it and then label it "correctly"
> > > and make it available.
> > 
> > That sounds like it'd be the complexity thing again...
> > 
> > > > Part of the problem is that the VFS does not pass around the security
> > > > context as which the VFS routines act, but rather gets them from the
> > > > task_struct.
> > > 
> > > That's by design. 
> > 
> > I suspect that's more by the fact that security wasn't particularly thought
> > about when these interfaces were first written.  As with everything in the
> > kernel, it might be negotiable.
> > 
> > > The cache driver is a unique case with an unusual function. It's pretty
> > > obvious that the kernel architecture, the VFS architecture, LSM, SELinux,
> > > NFS and pretty much everyone else has given no thought whatever to the
> > > implications of their designs on file system cacheing. For all concerned,
> > > I'll say "sorry 'bout that".
> > 
> > Meaning you think I should just give up on this?
> > 
> > How about I reduce the interface I'm proposing to two functions:
> > 
> >   (1) int security_act_as(struct task_struct *context)
> > 
> > 	Temporarily make the current process act as the given task, including,
> > 	for example, for SELinux, the security ID with which this task acts on
> > 	things, and the security ID with which this task creates files.
> 
> I don't see how that helps with nfsd assuming the label of a remote
> client process.

Well, assuming that nfsd assuming the label of a remote client is
a good idea ...

    newtask = taskstructdup(current);
    newtask->security = security_of_client;
    security_act_as(newtask);
    ... do interesting things ...
    security_act_as_self(); /* security_act_as(NULL); ? */
    cleanup_newtask(...)

... would be the basic flow. For what it's worth, and the whole
issue is being debated with gusto elsewhere, there are enough
problems with nfsd using this approach that it may not be worth
holding anything up for. 

> > 
> >   (2) int security_act_as_self(void);
> > 
> > 	Restore the context as which we're asking.
> > 
> > This would mean that the task's security context would have to be able to
> store
> > acting security IDs for everything, but I don't think that's too much of a
> > stretch resourcewise.
> 
> -- 
> Stephen Smalley
> National Security Agency
> 
> 
> --
> This message was distributed to subscribers of the selinux mailing list.
> If you no longer wish to subscribe, send mail to majordomo@tycho.nsa.gov with
> the words "unsubscribe selinux" without quotes as the message.
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
