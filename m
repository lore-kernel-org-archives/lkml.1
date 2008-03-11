Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbYCKJIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbYCKJIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYCKJIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:08:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33413 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYCKJIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:08:43 -0400
Date: Tue, 11 Mar 2008 10:08:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v5
Message-ID: <20080311090816.GF25110@elte.hu>
References: <20080310222955.565902000@linux-os.sc.intel.com> <20080310222955.703291000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310222955.703291000@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

>  asmlinkage void math_state_restore(void)
>  {
>  	struct task_struct *me = current;
> -	clts();			/* Allow maths ops (or we recurse) */
>  
> -	if (!used_math())
> -		init_fpu(me);
> +	if (!used_math()) {
> +		local_irq_enable();
> +		/*
> +		 * does a slab alloc which can sleep
> +		 */
> +		if (init_fpu(me)) {
> +			/*
> +			 * ran out of memory!
> +			 */
> +			do_group_exit(SIGKILL);
> +			return;
> +		}
> +		local_irq_disable();
> +	}
> +
> +	clts();			/* Allow maths ops (or we recurse) */
>  	restore_fpu_checking(&me->thread.xstate->fxsave);
>  	task_thread_info(me)->status |= TS_USEDFPU;
>  	me->fpu_counter++;

hm, three things:

firstly, the clts is now done _after_ fpu_init() - are you sure that's 
OK? We do it in this order so that FINIT [on older cpus] does not fault.

secondly, while i know you were responding to review feedback from 
others, but the do_group_exit(SIGKILL) looks quite bad. It's totally 
undebuggable to the user - not even a coredump will be generated AFAICS 
- and the user has no idea that this all happened due to out-of-memory. 
A (forced) SIGBUS is our usual answer to out-of-memory situations. [such 
as when a pagetable allocation fails] If you get review feedback that 
suggests a crappy solution then please resist it! :-)

thirdly, the irq enable/disable worries me. Can it ever trigger in 
kernel code that has irqs off? If it happens when kernel uses the FPU in 
irqs-off sections (to do SSE optimized routines, etc.) then enabling 
irqs is dangerous - the original callsite had it disabled for a reason. 
At minimum we should add a debug check to math_state_restore(), 
something like:

  WARN_ON_ONCE(!(regs->flags & X86_EFLAGS_IF))

(this means we need to pass regs to math_state_restore())

	Ingo
