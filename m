Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbYGROpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbYGROpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 10:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbYGROpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 10:45:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693AbYGROpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 10:45:44 -0400
Message-ID: <4880AC7D.5060708@redhat.com>
Date: Fri, 18 Jul 2008 09:45:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] i386: Execute stack overflow warning on interrupt stack
 v2
References: <20080505103637.GA16419@basil.nowhere.org>
In-Reply-To: <20080505103637.GA16419@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> i386: Execute stack overflow warning on interrupt stack v2
> 
> [Found the problem that caused the warnings on some configs now]
> 
> Previously the reporting printk would run on the process stack, which risks 
> overflow an already low stack. Instead execute it on the interrupt stack.
> This makes it more likely for the printk to make it actually out.
> 
> It adds one not taken test/branch more to the interrupt path when
> stack overflow checking is enabled. We could avoid that by duplicating
> more code, but that seemed not worth it.
> 
> Based on an observation by Eric Sandeen.
> 
> v2: Fix warnings in some configs

Did this patch get lost?  I'd sure like to see it go in, the stack
overflow warning + heavy dump_stack on the original stack makes the
warning do much more harm than good.

Thanks,
-Eric

> Signed-off-by: Andi Kleen <andi@firstfloor.org>
> 
> ---
>  arch/x86/kernel/irq_32.c |   51 +++++++++++++++++++++++++++++++----------------
>  1 file changed, 34 insertions(+), 17 deletions(-)
> 
> Index: linux/arch/x86/kernel/irq_32.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/irq_32.c
> +++ linux/arch/x86/kernel/irq_32.c
> @@ -61,6 +61,26 @@ static union irq_ctx *hardirq_ctx[NR_CPU
>  static union irq_ctx *softirq_ctx[NR_CPUS] __read_mostly;
>  #endif
>  
> +static void stack_overflow(void)
> +{
> +	printk("low stack detected by irq handler\n");
> +	dump_stack();
> +}
> +
> +static inline void call_on_stack2(void *func, void *stack,
> +			   unsigned long arg1, unsigned long arg2)
> +{
> +	unsigned long bx;
> +	asm volatile(
> +			"	xchgl  %%ebx,%%esp    \n"
> +			"	call   *%%edi	      \n"
> +			"	movl   %%ebx,%%esp    \n"
> +			: "=a" (arg1), "=d" (arg2), "=b" (bx)
> +			:  "0" (arg1),	 "1" (arg2),  "2" (stack),
> +			   "D" (func)
> +			: "memory", "cc", "ecx");
> +}
> +
>  /*
>   * do_IRQ handles all normal device IRQ's (the special
>   * SMP cross-CPU interrupts have their own specific
> @@ -76,6 +96,7 @@ unsigned int do_IRQ(struct pt_regs *regs
>  	union irq_ctx *curctx, *irqctx;
>  	u32 *isp;
>  #endif
> +	int overflow = 0;
>  
>  	if (unlikely((unsigned)irq >= NR_IRQS)) {
>  		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
> @@ -92,11 +113,8 @@ unsigned int do_IRQ(struct pt_regs *regs
>  
>  		__asm__ __volatile__("andl %%esp,%0" :
>  					"=r" (sp) : "0" (THREAD_SIZE - 1));
> -		if (unlikely(sp < (sizeof(struct thread_info) + STACK_WARN))) {
> -			printk("do_IRQ: stack overflow: %ld\n",
> -				sp - sizeof(struct thread_info));
> -			dump_stack();
> -		}
> +		if (unlikely(sp < (sizeof(struct thread_info) + STACK_WARN)))
> +			overflow = 1;
>  	}
>  #endif
>  
> @@ -112,8 +130,6 @@ unsigned int do_IRQ(struct pt_regs *regs
>  	 * current stack (which is the irq stack already after all)
>  	 */
>  	if (curctx != irqctx) {
> -		int arg1, arg2, bx;
> -
>  		/* build the stack frame on the IRQ stack */
>  		isp = (u32*) ((char*)irqctx + sizeof(*irqctx));
>  		irqctx->tinfo.task = curctx->tinfo.task;
> @@ -127,18 +143,19 @@ unsigned int do_IRQ(struct pt_regs *regs
>  			(irqctx->tinfo.preempt_count & ~SOFTIRQ_MASK) |
>  			(curctx->tinfo.preempt_count & SOFTIRQ_MASK);
>  
> -		asm volatile(
> -			"       xchgl  %%ebx,%%esp    \n"
> -			"       call   *%%edi         \n"
> -			"       movl   %%ebx,%%esp    \n"
> -			: "=a" (arg1), "=d" (arg2), "=b" (bx)
> -			:  "0" (irq),   "1" (desc),  "2" (isp),
> -			   "D" (desc->handle_irq)
> -			: "memory", "cc", "ecx"
> -		);
> +		/* Execute warning on interrupt stack */
> +		if (unlikely(overflow))
> +			call_on_stack2(stack_overflow, isp, 0, 0);
> +
> +		call_on_stack2(desc->handle_irq, isp, irq, (unsigned long)desc);
>  	} else
>  #endif
> +	{
> +		/* AK: Slightly bogus here */
> +		if (overflow)
> +			stack_overflow();
>  		desc->handle_irq(irq, desc);
> +	}
>  
>  	irq_exit();
>  	set_irq_regs(old_regs);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

