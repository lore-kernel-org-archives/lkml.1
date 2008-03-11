Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbYCKU7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbYCKU7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbYCKU7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:59:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:10765 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbYCKU7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:59:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,482,1199692800"; 
   d="scan'208";a="217441035"
Date: Tue, 11 Mar 2008 13:57:39 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v5
Message-ID: <20080311205738.GG15909@linux-os.sc.intel.com>
References: <20080310222955.565902000@linux-os.sc.intel.com> <20080310222955.703291000@linux-os.sc.intel.com> <20080311090816.GF25110@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311090816.GF25110@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 10:08:16AM +0100, Ingo Molnar wrote:
> 
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> >  asmlinkage void math_state_restore(void)
> >  {
> >  	struct task_struct *me = current;
> > -	clts();			/* Allow maths ops (or we recurse) */
> >  
> > -	if (!used_math())
> > -		init_fpu(me);
> > +	if (!used_math()) {
> > +		local_irq_enable();
> > +		/*
> > +		 * does a slab alloc which can sleep
> > +		 */
> > +		if (init_fpu(me)) {
> > +			/*
> > +			 * ran out of memory!
> > +			 */
> > +			do_group_exit(SIGKILL);
> > +			return;
> > +		}
> > +		local_irq_disable();
> > +	}
> > +
> > +	clts();			/* Allow maths ops (or we recurse) */
> >  	restore_fpu_checking(&me->thread.xstate->fxsave);
> >  	task_thread_info(me)->status |= TS_USEDFPU;
> >  	me->fpu_counter++;
> 
> hm, three things:
> 
> firstly, the clts is now done _after_ fpu_init() - are you sure that's 
> OK? We do it in this order so that FINIT [on older cpus] does not fault.

init_fpu() is getting called only if !used_math() and in this case, we don't
do any FP operations in init_fpu()

> secondly, while i know you were responding to review feedback from 
> others, but the do_group_exit(SIGKILL) looks quite bad. It's totally 
> undebuggable to the user - not even a coredump will be generated AFAICS 
> - and the user has no idea that this all happened due to out-of-memory. 
> A (forced) SIGBUS is our usual answer to out-of-memory situations. [such 
> as when a pagetable allocation fails]

AFAICS, fault handler is doing do_group_exit(SIGKILL); under out-of-memory
conditions while handling page fault.

Just want to make sure that the user doesn't see this signal.

force_sig() with SIGKILL/SIGBUS along with
printk("out of memory! killing process") is fair enough, right?

> If you get review feedback that 
> suggests a crappy solution then please resist it! :-)

:) Didn't feel SIGKILL was completely crappy..

> 
> thirdly, the irq enable/disable worries me. Can it ever trigger in 
> kernel code that has irqs off? If it happens when kernel uses the FPU in 
> irqs-off sections (to do SSE optimized routines, etc.) then enabling 
> irqs is dangerous - the original callsite had it disabled for a reason. 

Good point. But math_state_restore() should never happen between
the kernel_fpu_begin() and end() sections. Otherwise, it will corrupt the
user's FPU data.

Today, we make sure that we don't get device not available (DNA) exceptions
in kernel_fpu_begin() by explicitly doing clts()

> At minimum we should add a debug check to math_state_restore(), 
> something like:
> 
>   WARN_ON_ONCE(!(regs->flags & X86_EFLAGS_IF))
> 
> (this means we need to pass regs to math_state_restore())

Based on above, do you think this is still needed? Even if it is needed,
the check should be

	BUG_ON(!user_mode(regs))

thanks,
suresh
