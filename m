Return-Path: <linux-kernel-owner+w=401wt.eu-S932621AbXBSUZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbXBSUZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 15:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932624AbXBSUZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 15:25:00 -0500
Received: from mail.screens.ru ([213.234.233.54]:54965 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932621AbXBSUY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 15:24:59 -0500
Date: Mon, 19 Feb 2007 23:23:49 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: freezer problems
Message-ID: <20070219202349.GA87@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <200702181956.11273.rjw@sisk.pl> <20070218220134.GA4243@tv-sign.ru> <200702190019.23215.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702190019.23215.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, Rafael J. Wysocki wrote:
>
> On Sunday, 18 February 2007 23:01, Oleg Nesterov wrote:
> > > --- linux-2.6.20-mm2.orig/include/asm-i386/thread_info.h	2007-02-18 19:49:34.000000000 +0100
> > > +++ linux-2.6.20-mm2/include/asm-i386/thread_info.h	2007-02-18 19:50:37.000000000 +0100
> > > @@ -135,6 +135,7 @@ static inline struct thread_info *curren
> > >  #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
> > >  #define TIF_FREEZE		19	/* is freezing for suspend */
> > >  #define TIF_FORCED_TF		20	/* true if TF in eflags artificially */
> > > +#define TIF_FREEZER_SKIP	21	/* task freezer should not count us */
> > 
> > Do we need to put this flag into thread_info? It is always modified by
> > "current", so it could live in task_struct->flags instead.
> 
> I thought we were running low on the task_struct->flags bits. :-)

Didn't think about that :)

> Apart from this, we may need to set it from somewhere else in the future.

I doubt. In any case, since you provided the nice helpers, it would be very
easy to convert from thread to process flags. My main concern is that we
have 24 include/asm-*/thread_info.h files, but only 1 include/linux/sched.h.
It seems more easy to start with PF_ flags at first.

> @@ -1393,7 +1394,10 @@ long do_fork(unsigned long clone_flags,
>
> 		if (clone_flags & CLONE_VFORK) {
> +                       freezer_do_not_count(current);
> 			  wait_for_completion(&vfork);
> +                       try_to_freeze();
> +                       freezer_count(current);

freezer_do_not_count() implies that we must do try_to_freeze() later, I'd
suggest to shift try_to_freeze() into freezer_count(). Actually, I think that
freezer_do_not_count/freezer_count should be "(void)", like try_to_freeze().
IOW,

	freezer_do_not_count()
	... sleep in 'D' state ...
	freezer_count()

means that current doesn't hold any "important" locks, may be considered as
frozen, it can do nothing except enter refrigerator if it gets CPU.

(Please feel free to ignore, this is a matter of taste of course).

> @@ -199,6 +189,10 @@ static void thaw_tasks(int thaw_user_spa
>
>         read_lock(&tasklist_lock);
>         do_each_thread(g, p) {
> +               if (freezer_should_skip(p))
> +                       cancel_freezing(p);
> +       } while_each_thread(g, p);
> +       do_each_thread(g, p) {
>                 if (!freezeable(p))
>                         continue;

Any reason for 2 separate do_each_thread() loops ?

I think this patch is correct, but I still can't convince myself I really
understand freezer :)

Btw,

On 02/18, Some Idiot wrote:
>
> On 02/18, Rafael J. Wysocki wrote:
> >
> > +   /* The parent is uninterruptible and will stay so until this task exits,
> > +    * so we can mark it as frozen.
> > +    */
> > +   if (current->vfork_done)
> > +           frozen_process(current->parent);
>
> This is not safe. task->flags is not atomic, we can change ->flags only
> if we know the task won't touch it itself (ptrace, thaw_process).
> The parent could be interrupted, irq may play with current->flags (slab,
> for example).

Irq only does atomic allocations, so the slab won't play with task->flags.
Still I believe the concern was valid in general and I personally think
the new patch is better (and more generic).

Oleg.

