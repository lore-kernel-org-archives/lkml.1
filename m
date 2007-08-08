Return-Path: <linux-kernel-owner+w=401wt.eu-S934856AbXHHAew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934856AbXHHAew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 20:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbXHHAen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 20:34:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57093 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754184AbXHHAem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 20:34:42 -0400
Date: Tue, 7 Aug 2007 17:34:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ifdef struct task_struct::security
Message-Id: <20070807173426.e0463947.akpm@linux-foundation.org>
In-Reply-To: <20070807161202.GA23135@vino.hallyn.com>
References: <20070807150529.GA22447@vino.hallyn.com>
	<716107.45286.qm@web36607.mail.mud.yahoo.com>
	<20070807161202.GA23135@vino.hallyn.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2007 11:12:02 -0500
"Serge E. Hallyn" <serge@hallyn.com> wrote:

> Quoting Casey Schaufler (casey@schaufler-ca.com):
> > 
> > --- "Serge E. Hallyn" <serge@hallyn.com> wrote:
> > 
> > > Quoting Andrew Morton (akpm@linux-foundation.org):
> > > > On Mon, 6 Aug 2007 15:31:12 -0500 "Serge E. Hallyn" <serge@hallyn.com>
> > > wrote:
> > > > 
> > > > > Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > > > > > For those who don't care about CONFIG_SECURITY.
> > > > > 
> > > > > I'm quite sure we started that way, but the ifdefs were considered
> > > > > too much of an eyesore.
> > > > 
> > > > argh, y'all stop top-posting at me.
> > > 
> > > (Hmm, I'm replying at the point in the email I'm replying to.  Is what
> > > I'm doing in this current email ok - i.e the one you replied to looked
> > > like pure top-posting - or do you actually want pure bottom posting?)
> > > 
> > > > > If this is now acceptable, then the same thing might be considered
> > > > > for inode->i_security, kern_ipc_perm.security, etc.  Getting rid of
> > > > > just the task->security seems overly half-hearted.
> > > > > 
> > > > > -serge
> > > > > 
> > > > > > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > > > > > ---
> > > > > > 
> > > > > >  include/linux/sched.h |    3 ++-
> > > > > >  kernel/fork.c         |    2 ++
> > > > > >  2 files changed, 4 insertions(+), 1 deletion(-)
> > > > > > 
> > > > > > --- a/include/linux/sched.h
> > > > > > +++ b/include/linux/sched.h
> > > > > > @@ -1086,8 +1086,9 @@ struct task_struct {
> > > > > >  	int (*notifier)(void *priv);
> > > > > >  	void *notifier_data;
> > > > > >  	sigset_t *notifier_mask;
> > > > > > -	
> > > > > > +#ifdef CONFIG_SECURITY
> > > > > >  	void *security;
> > > > > > +#endif
> > > > > >  	struct audit_context *audit_context;
> > > > > >  	seccomp_t seccomp;
> > > > > >  
> > > > > > --- a/kernel/fork.c
> > > > > > +++ b/kernel/fork.c
> > > > > > @@ -1066,7 +1066,9 @@ static struct task_struct *copy_process(unsigned
> > > long clone_flags,
> > > > > >  	do_posix_clock_monotonic_gettime(&p->start_time);
> > > > > >  	p->real_start_time = p->start_time;
> > > > > >  	monotonic_to_bootbased(&p->real_start_time);
> > > > > > +#ifdef CONFIG_SECURITY
> > > > > >  	p->security = NULL;
> > > > > > +#endif
> > > > > >  	p->io_context = NULL;
> > > > > >  	p->io_wait = NULL;
> > > > > >  	p->audit_context = NULL;
> > > > > > 
> > > > 
> > > > I think it's OK.  Removing 4 or 8 bytes from the task_struct is a decent
> > > win,
> > > > and an ifdef at the definition site (unavoidable) and at a single
> > > > initialisation site where there are lots of other similar ifdefs is pretty
> > > > minimal hurt.
> > > 
> > > Then how about making it depend on CONFIG_SECURITY_SELINUX?  It's the
> > > only LSM actually using that field right now.  (As more come along, we
> > > can use a hidden CONFIG_SECURITY_ATTRS or somesuch bool select'ed by
> > > LSMs which need it)
> > 
> > I would greatly appreciate it if you didn't add yet another place
> > that requires deselinuxifation by anyone wanting to try something else.
> > The question is whether there is any LSM, not whether there is selinux.
> > Yes, I know that there are no other LSMs upstream today. I hope to
> > change that before too long, and dealing with places where the code is
> > using the LSM==SELinux assumption is tiresome.
> 
> So jump straight to using CONFIG_SECURITY_USE_LABELS or whatever, as I
> mentioned.
> 

Well I've lost the plot here, but I'm all for shrinking task_struct on
small systems, so I'll trollmerge Alexey's original diff.

