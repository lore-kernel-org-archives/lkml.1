Return-Path: <linux-kernel-owner+w=401wt.eu-S935078AbXHGTEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935078AbXHGTEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 15:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbXHGTEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 15:04:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:50281 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbXHGTEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 15:04:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=oC5/1J0Pc56opUwZZiBkigwHRLMpPgFJrP3QN0wGy4AOPXIMVM3LkXeYR0el5Ay3V650xPtBMM59Y9qUzSGiF3Qg7Jw/8IJD9mkog5wnLsYyyOfHXGm+v6/mRXxE1Hd1hWenbEOlle5oco/O6ngm6DQrHavivq/OmqEVCEdZkIM=
Date: Tue, 7 Aug 2007 23:04:37 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ifdef struct task_struct::security
Message-ID: <20070807190437.GA5844@martell.zuzino.mipt.ru>
References: <20070806185514.GA5842@martell.zuzino.mipt.ru> <20070806203112.GA12726@vino.hallyn.com> <20070806220833.4040f861.akpm@linux-foundation.org> <20070807150529.GA22447@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070807150529.GA22447@vino.hallyn.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 10:05:29AM -0500, Serge E. Hallyn wrote:
> Quoting Andrew Morton (akpm@linux-foundation.org):
> > On Mon, 6 Aug 2007 15:31:12 -0500 "Serge E. Hallyn" <serge@hallyn.com> wrote:
> > 
> > > Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > > > For those who don't care about CONFIG_SECURITY.
> > > 
> > > I'm quite sure we started that way, but the ifdefs were considered
> > > too much of an eyesore.
> > 
> > argh, y'all stop top-posting at me.
> 
> (Hmm, I'm replying at the point in the email I'm replying to.  Is what
> I'm doing in this current email ok - i.e the one you replied to looked
> like pure top-posting - or do you actually want pure bottom posting?)
> 
> > > If this is now acceptable, then the same thing might be considered
> > > for inode->i_security, kern_ipc_perm.security, etc.  Getting rid of
> > > just the task->security seems overly half-hearted.
> > > 
> > > -serge
> > > 
> > > > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > > > ---
> > > > 
> > > >  include/linux/sched.h |    3 ++-
> > > >  kernel/fork.c         |    2 ++
> > > >  2 files changed, 4 insertions(+), 1 deletion(-)
> > > > 
> > > > --- a/include/linux/sched.h
> > > > +++ b/include/linux/sched.h
> > > > @@ -1086,8 +1086,9 @@ struct task_struct {
> > > >  	int (*notifier)(void *priv);
> > > >  	void *notifier_data;
> > > >  	sigset_t *notifier_mask;
> > > > -	
> > > > +#ifdef CONFIG_SECURITY
> > > >  	void *security;
> > > > +#endif
> > > >  	struct audit_context *audit_context;
> > > >  	seccomp_t seccomp;
> > > >  
> > > > --- a/kernel/fork.c
> > > > +++ b/kernel/fork.c
> > > > @@ -1066,7 +1066,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> > > >  	do_posix_clock_monotonic_gettime(&p->start_time);
> > > >  	p->real_start_time = p->start_time;
> > > >  	monotonic_to_bootbased(&p->real_start_time);
> > > > +#ifdef CONFIG_SECURITY
> > > >  	p->security = NULL;
> > > > +#endif
> > > >  	p->io_context = NULL;
> > > >  	p->io_wait = NULL;
> > > >  	p->audit_context = NULL;
> > > > 
> > 
> > I think it's OK.  Removing 4 or 8 bytes from the task_struct is a decent win,
> > and an ifdef at the definition site (unavoidable) and at a single
> > initialisation site where there are lots of other similar ifdefs is pretty
> > minimal hurt.
> 
> Then how about making it depend on CONFIG_SECURITY_SELINUX?  It's the
> only LSM actually using that field right now.  (As more come along, we
> can use a hidden CONFIG_SECURITY_ATTRS or somesuch bool select'ed by
> LSMs which need it)
> 
> Using CONFIG_SECURITY means that if you compile with SECURITY=n, you get
> the capability module but no task->security.  If you compile with
> SECURITY=y but no modules, you get the dummy module and a
> task->security field!

If I understood intent correctly CONFIG_SECURITY_ATTRS will be an overkill
because of one more compilation breaking option and small amount of
people benefitting from it.

How much people have such setup? Example: for more than 4 years nobody from
CONFIG_SECURITY=n camp cared about their inodes and struct files being bigger
than needed. Even more time for task_struct and fork being slower.

> > In fact, looking through all those "= 0" and "= NULL" statements in
> > copy_process() makes one wonder whether we should be memsetting that guy to
> > zero then selectively copying things out of current, rather than the
> > present vice-versa.
> > 
> > A possibly-neat way of doing this would be to move all the task_struct fields which
> > are zeroed in copy_process() into a separate anonymous struct in
> > task_struct, then wipe only that in copy_process().  One would need to be
> > careful about the hand-arranged grouping which has been done in the
> > task_struct however.

Interesting... I am sure this was tried in good old times when task_struct
was not so bloated, maybe now it will be net win now.

