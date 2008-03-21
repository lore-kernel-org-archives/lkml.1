Return-Path: <linux-kernel-owner+w=401wt.eu-S1761977AbYCUUhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761977AbYCUUhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761841AbYCUUhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:37:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49310 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761372AbYCUUhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:37:38 -0400
Date: Fri, 21 Mar 2008 16:37:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt] rt-slab: fix cpu inconsistency case
In-Reply-To: <47E2C4CC.5050401@ct.jp.nec.com>
Message-ID: <Pine.LNX.4.58.0803211635160.3220@gandalf.stny.rr.com>
References: <47E2A63B.4020003@ct.jp.nec.com> <Pine.LNX.4.58.0803201519160.21990@gandalf.stny.rr.com>
 <47E2C4CC.5050401@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Mar 2008, Hiroshi Shimamoto wrote:

>
> mm/slab.c:cache_alloc_refill()
> 	if (unlikely(!ac->avail)) {
> 		int x;
> 		x = cache_grow(cachep, flags | GFP_THISNODE, cpu_to_node(*this_cpu), NULL, this_cpu);
>
> 		/* cache_grow can reenable interrupts, then ac could change. */
> 		ac = cpu_cache_get(cachep, *this_cpu);
>
> The comment says, "ac could change", but it never if *this_cpu is same.
>
> In cache_alloc_refill(), cpu_cache_get() should called with the valid cpu id
> after cache_grow(). Because on !PREEMPT_RT, the array_cache is protected by
> disabling irqs, so array_cache of other cpu shouldn't be accessed.

Ah, sorry I missed the !PREEMPT_RT part.

>
> >
> >>  # define slab_irq_disable_rt(flags)	do { (void)(flags); } while (0)
> >>  # define slab_irq_enable_rt(flags)	do { (void)(flags); } while (0)
> >>  # define slab_spin_lock_irq(lock, cpu) \
> >> @@ -160,8 +160,8 @@ DEFINE_PER_CPU_LOCKED(int, slab_irq_locks) = { 0, };
> >>  	do { slab_irq_enable(cpu); (void) (flags); } while (0)
> >>  # define slab_irq_disable_rt(cpu)	slab_irq_disable(cpu)
> >>  # define slab_irq_enable_rt(cpu)	slab_irq_enable(cpu)
> >> -# define slab_irq_disable_nort()	do { } while (0)
> >> -# define slab_irq_enable_nort()		do { } while (0)
> >> +# define slab_irq_disable_nort(cpu)	do { } while (0)
> >> +# define slab_irq_enable_nort(cpu)	do { } while (0)
> >
> > And these are the PREEMPT_RT version. So basically, this patch is a nop
> > for PREEMPT_RT. I doubt it will solve your bug ;-)
>
> yes, it's nop. I'm sorry, I didn't show .config.
> My kernel config is !PREEMPT_RT, it's same as the deadlock report.
> I guess it's a problem only !PREEMPT_RT.

Hmm, I'll have to look deeper into this on Monday (I'm off today -
Friday).

Is this a bug in mainline? The !PREEMPT_RT case should be as close to
mainline as possible, with no actual changes in object code. If this is
not the case, then we need to fix that.

I'll try to remember to take a look at this on Monday.

Thanks,

-- Steve

