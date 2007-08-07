Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbXHGFJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbXHGFJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 01:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbXHGFJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 01:09:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34325 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755055AbXHGFJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 01:09:16 -0400
Date: Mon, 6 Aug 2007 22:08:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ifdef struct task_struct::security
Message-Id: <20070806220833.4040f861.akpm@linux-foundation.org>
In-Reply-To: <20070806203112.GA12726@vino.hallyn.com>
References: <20070806185514.GA5842@martell.zuzino.mipt.ru>
	<20070806203112.GA12726@vino.hallyn.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007 15:31:12 -0500 "Serge E. Hallyn" <serge@hallyn.com> wrote:

> Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > For those who don't care about CONFIG_SECURITY.
> 
> I'm quite sure we started that way, but the ifdefs were considered
> too much of an eyesore.

argh, y'all stop top-posting at me.

> If this is now acceptable, then the same thing might be considered
> for inode->i_security, kern_ipc_perm.security, etc.  Getting rid of
> just the task->security seems overly half-hearted.
> 
> -serge
> 
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > ---
> > 
> >  include/linux/sched.h |    3 ++-
> >  kernel/fork.c         |    2 ++
> >  2 files changed, 4 insertions(+), 1 deletion(-)
> > 
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1086,8 +1086,9 @@ struct task_struct {
> >  	int (*notifier)(void *priv);
> >  	void *notifier_data;
> >  	sigset_t *notifier_mask;
> > -	
> > +#ifdef CONFIG_SECURITY
> >  	void *security;
> > +#endif
> >  	struct audit_context *audit_context;
> >  	seccomp_t seccomp;
> >  
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1066,7 +1066,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> >  	do_posix_clock_monotonic_gettime(&p->start_time);
> >  	p->real_start_time = p->start_time;
> >  	monotonic_to_bootbased(&p->real_start_time);
> > +#ifdef CONFIG_SECURITY
> >  	p->security = NULL;
> > +#endif
> >  	p->io_context = NULL;
> >  	p->io_wait = NULL;
> >  	p->audit_context = NULL;
> > 

I think it's OK.  Removing 4 or 8 bytes from the task_struct is a decent win,
and an ifdef at the definition site (unavoidable) and at a single
initialisation site where there are lots of other similar ifdefs is pretty
minimal hurt.



In fact, looking through all those "= 0" and "= NULL" statements in
copy_process() makes one wonder whether we should be memsetting that guy to
zero then selectively copying things out of current, rather than the
present vice-versa.

A possibly-neat way of doing this would be to move all the task_struct fields which
are zeroed in copy_process() into a separate anonymous struct in
task_struct, then wipe only that in copy_process().  One would need to be
careful about the hand-arranged grouping which has been done in the
task_struct however.

