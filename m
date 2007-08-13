Return-Path: <linux-kernel-owner+w=401wt.eu-S947355AbXHMPiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947355AbXHMPiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943484AbXHMNqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:46:22 -0400
Received: from web36612.mail.mud.yahoo.com ([209.191.85.29]:45369 "HELO
	web36612.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S973307AbXHMNqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:46:19 -0400
X-YMail-OSG: .zaIZQkVM1nuHKRtssTWK7RPoAmAiz0WqoeNaDl5SGcJPjHSAevTcqkRmtCAe_fh58DIm9bB1g--
X-RocketYMMF: rancidfat
Date: Mon, 13 Aug 2007 06:46:15 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 00/16] Permit filesystem local caching [try #3]
To: David Howells <dhowells@redhat.com>, casey@schaufler-ca.com
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <24171.1187002441@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <353795.27307.qm@web36612.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Casey Schaufler <casey@schaufler-ca.com> wrote:
> 
> > Sigh. So it's not only SELinux specific, but RedHat specific as well.
> 
> *Blink*.  How did you come to that conclusion?
> 
> > >   (3) The cache driver wants to access the files in the cache, but it's
> > >       running in the security context of either the aforementioned random
> > >       process, or one of FS-Cache's thread pool.
> > 
> > I think that this is the point you should attack. Control the security
> > characteristics of the cache driver properly and you shouldn't need the
> > complexity that you're asking to introduce.
> 
> How?  The cache driver acts on behalf of someone else.  That someone else has
> one security context, but the cache itself has to have a different context so
> that the cache can be shared.
> 
> Furthermore, the cache driver doesn't have a security context per se.
> 
> > >       This security context, however, doesn't necessarily give it the
> > >       rights to access what's in the cache, so the driver has to be
> > >       permitted to act as a context appropriate to accessing the cache,
> > >       without changing the overall security context of the random process
> > >       (which would impact things trying to act on that process - kill()
> > >       for example).
> > 
> > Can you run the cache as an independent thread and send it messages
> > rather than trying to do things in the context of the calling process?
> > I know that that involves extra bookkeeppingg, but it's lots safer.
> 
> It introduces more complexity, which I believe you were just arguing against
> above...  It also incurs more kernel threads - which I really really want to
> avoid.
> 
> I would rank the complexity and resource overhead of the act-as stuff in LSM
> (or at least in SELinux) as much less than what you're suggesting.
> 
> As it stands, the FS-Cache layer has a pool of threads that CacheFiles makes
> use of, but this can't be bound to the security of a specific cache because
> there may be more than one cache of more than one cache driver type.
> 
> > Yes, and the SELinux semantics for what label to give a file don't
> > help much, either. The problem with the "act_as" interfaces is that
> > I wouldn't expect them to be any more reliable than the old access()
> > system call, which never really gave you a helpful answer.
> 
> I don't see how act_as compares to access().
> 
> > Ideally you want to be running in the right context to create the
> > new file so that no one can use it and then label it "correctly"
> > and make it available.
> 
> That sounds like it'd be the complexity thing again...
> 
> > > Part of the problem is that the VFS does not pass around the security
> > > context as which the VFS routines act, but rather gets them from the
> > > task_struct.
> > 
> > That's by design. 
> 
> I suspect that's more by the fact that security wasn't particularly thought
> about when these interfaces were first written.  As with everything in the
> kernel, it might be negotiable.
> 
> > The cache driver is a unique case with an unusual function. It's pretty
> > obvious that the kernel architecture, the VFS architecture, LSM, SELinux,
> > NFS and pretty much everyone else has given no thought whatever to the
> > implications of their designs on file system cacheing. For all concerned,
> > I'll say "sorry 'bout that".
> 
> Meaning you think I should just give up on this?

No, sorry, sometimes I sound meaner than I really am. I meant that
sympathetically, honest. I don't think you should give up.

> How about I reduce the interface I'm proposing to two functions:
> 
>   (1) int security_act_as(struct task_struct *context)
> 
> 	Temporarily make the current process act as the given task, including,
> 	for example, for SELinux, the security ID with which this task acts on
> 	things, and the security ID with which this task creates files.
> 
>   (2) int security_act_as_self(void);
> 
> 	Restore the context as which we're asking.
> 
> This would mean that the task's security context would have to be able to
> store
> acting security IDs for everything, but I don't think that's too much of a
> stretch resourcewise.

I haven't looked into the issues at all and I bet there are plenty,
maybe in audit and places outside of the security realm, but this
looks like a clean approach from the LSM interface standpoint. Do
you want the entire task or just task->security? I could see it
either way, but I suspect the task is your best bet. If you call
security_act_as() twice, then security_act_as_self() do you pop a
stack, or return to the initial state? How about security_act_as(NULL)
returning you to the initial state, and dropping security_act_as_self()?

Thank you for taking the effort to address the issues I raised.
I appreciate your willingness to accommodate my concerns even after
I'd flamed you.


Casey Schaufler
casey@schaufler-ca.com
