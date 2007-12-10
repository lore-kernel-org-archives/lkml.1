Return-Path: <linux-kernel-owner+w=401wt.eu-S1752971AbXLJW0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbXLJW0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 17:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXLJW0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 17:26:22 -0500
Received: from web36615.mail.mud.yahoo.com ([209.191.85.32]:37995 "HELO
	web36615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751304AbXLJW0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 17:26:21 -0500
X-YMail-OSG: _LU2laIVM1mLB_bs9u7ba8a.M1iqfVOiVmRFVj_JrcbVwhhdl014pmmLIVRUYEKDqg--
X-RocketYMMF: rancidfat
Date: Mon, 10 Dec 2007 14:26:20 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
To: Stephen Smalley <sds@tycho.nsa.gov>, David Howells <dhowells@redhat.com>
Cc: Karl MacMillan <kmacmill@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <1197322068.18120.176.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <370690.53043.qm@web36615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> On Mon, 2007-12-10 at 21:08 +0000, David Howells wrote:
> > Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > 
> > > Otherwise, only other issue I have with this interface is it won't
> > > generalize to dealing with nfsd, where we want to set the acting context
> > > to a context we obtain from or determine based upon the client.
> > 
> > Are you speaking of security_kernel_act_as() and security_create_files_as()
> > specifically?  Or the task_struct::act_as override pointer in general?
> 
> security_kernel_act_as()
> 
> > I don't really know how nfsd wants to obtain and set its LSM context, so
> it's
> > a bit difficult for me to make something that works for nfsd as well as
> > cachefiles.
> 
> It would get a context from the client or from a local configuration
> that would map security-unaware clients to a default context, and then
> want to assume that context for the particular operation.  No transition
> involved.

I would expect that the operation would be more sophisticated
than that. You certainly aren't going to use what comes from
the other side without any processing, and I expect you'll have
some sort of operation on anything you pull from a config file
before you actually apply it.

> > > Why can't cachefilesd just push a context into the kernel and pass that
> > > into the hook as the acting context,
> > 
> > How does cachefilesd come up with such a context?  Grab it from
> > /etc/cachefilesd.conf?
> 
> >From a config file whose pathname would be provided by libselinux (ala
> the way in which dbusd imports contexts), or directly as a context
> returned by a libselinux function.  Has to be done that way so that it
> can be set differently for different policy types (strict, targeted,
> mls).

Unless you've got an LSM other than SELinux, of course. If
cachefilesd is going to be responsible for maintaining this
magic context there needs to be an LSM interface for it, not
just an SELinux interface.

> Naturally, cachefiles (the kernel module) would invoke a security hook
> to check whether the daemon is allowed to set the specified context.
> 
> > I use to do that, but someone objected...  Possibly Karl MacMillan.
> 
> Yes, but I think I disagreed then too.
> 
> > > and then nfsd can do likewise using the context provided by the client or
> > > obtained locally from exports for ordinary clients?  Avoids the
> transition
> > > SID computation altogether within the kernel and makes this more generic.
> > 
> > I seem to remember that I was told that it should be done this way,
> possibly
> > by Karl MacMillan, but I don't remember exactly.
> > 
> > Now it's configured by cachefilesd.te:
> > 
> > 	type_transition cachefilesd_t kernel_t : process cachefiles_kernel_t;
> 
> It doesn't fit with how other users of security_kernel_act_as() will
> likely want to work (they will want to just set the context to a
> specified value, whether one obtained from the client or from some local
> source), nor with how type transitions normally work (exec, with the
> program type as the second type field).  I think it will just cause
> confusion and subtle breakage.

I think that I agree with Stephen, although I could be mirely confused.
That happens to me when interfaces are described in SELinux terms. I
still don't care much for multiple contexts, and I don't have a good
grasp of how you'll deal with Smack, or any LSM other than SELinux.
Just as Stephen mentions, I also don't see the generality that a change
of this magnitude really ought to provide.



Casey Schaufler
casey@schaufler-ca.com
