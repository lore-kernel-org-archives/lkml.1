Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbYFUTnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbYFUTnS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbYFUTnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:43:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbYFUTm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:42:59 -0400
Date: Sat, 21 Jun 2008 15:42:56 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: stack overflow on Sparc64
In-Reply-To: <20080620.215139.218732028.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0806211542050.21474@engineering.redhat.com>
References: <20080620.133721.95818057.davem@davemloft.net>
 <Pine.LNX.4.64.0806201717190.14221@engineering.redhat.com>
 <20080620.144128.32005196.davem@davemloft.net> <20080620.215139.218732028.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 Jun 2008, David Miller wrote:

> From: David Miller <davem@davemloft.net>
> Date: Fri, 20 Jun 2008 14:41:28 -0700 (PDT)
>
>> Next week I'll make one of my primary projects the implementation of
>> IRQ stacks for sparc64.
>
> Next week came real fast :-)
>
> Amazingly this patch worked the first time I booted it up on my
> dual-cpu workstation (using SMP + PREEMPT).  I'm worried that maybe
> gcc can do some clever things and not allow my extremely simple
> approach to work, but anyways it might work for you and it's worth
> giving a try.
>
> sparc64: Implement support for IRQ stacks.

For me it doesn't work. Locked up after "console: colour dummy device 
80x25".

Mikulas

> Signed-off-by: David S. Miller <davem@davemloft.net>
>
> diff --git a/arch/sparc64/Kconfig.debug b/arch/sparc64/Kconfig.debug
> index 6a4d28a..df80962 100644
> --- a/arch/sparc64/Kconfig.debug
> +++ b/arch/sparc64/Kconfig.debug
> @@ -41,4 +41,11 @@ config FRAME_POINTER
> 	depends on MCOUNT
> 	default y
>
> +config IRQSTACKS
> +	bool "Use separate kernel stacks when processing interrupts"
> +	help
> +	  If you say Y here the kernel will use separate kernel stacks
> +	  for handling hard and soft interrupts.  This can help avoid
> +	  overflowing the process kernel stacks.
> +
> endmenu
> diff --git a/arch/sparc64/kernel/irq.c b/arch/sparc64/kernel/irq.c
> index b441a26..24820fa 100644
> --- a/arch/sparc64/kernel/irq.c
> +++ b/arch/sparc64/kernel/irq.c
> @@ -674,10 +674,42 @@ void ack_bad_irq(unsigned int virt_irq)
> 	       ino, virt_irq);
> }
>
> +#ifdef CONFIG_IRQSTACKS
> +void *hardirq_stack[NR_CPUS];
> +void *softirq_stack[NR_CPUS];
> +
> +static void *set_hardirq_stack(void)
> +{
> +	void *orig_sp, *sp = hardirq_stack[smp_processor_id()];
> +
> +	__asm__ __volatile__("mov %%sp, %0" : "=r" (orig_sp));
> +	if (orig_sp < sp ||
> +	    orig_sp > (sp + THREAD_SIZE)) {
> +		sp += THREAD_SIZE - 192 - STACK_BIAS;
> +		__asm__ __volatile__("mov %0, %%sp" : : "r" (sp));
> +	}
> +
> +	return orig_sp;
> +}
> +static void restore_hardirq_stack(void *orig_sp)
> +{
> +	__asm__ __volatile__("mov %0, %%sp" : : "r" (orig_sp));
> +}
> +#else
> +static void *set_hardirq_stack(void)
> +{
> +	return NULL;
> +}
> +static void restore_hardirq_stack(void *orig_sp)
> +{
> +}
> +#endif
> +
> void handler_irq(int irq, struct pt_regs *regs)
> {
> 	unsigned long pstate, bucket_pa;
> 	struct pt_regs *old_regs;
> +	void *orig_sp;
>
> 	clear_softint(1 << irq);
>
> @@ -695,6 +727,8 @@ void handler_irq(int irq, struct pt_regs *regs)
> 			       "i" (PSTATE_IE)
> 			     : "memory");
>
> +	orig_sp = set_hardirq_stack();
> +
> 	while (bucket_pa) {
> 		struct irq_desc *desc;
> 		unsigned long next_pa;
> @@ -711,10 +745,40 @@ void handler_irq(int irq, struct pt_regs *regs)
> 		bucket_pa = next_pa;
> 	}
>
> +	restore_hardirq_stack(orig_sp);
> +
> 	irq_exit();
> 	set_irq_regs(old_regs);
> }
>
> +#ifdef CONFIG_IRQSTACKS
> +void do_softirq(void)
> +{
> +	unsigned long flags;
> +
> +	if (in_interrupt())
> +		return;
> +
> +	local_irq_save(flags);
> +
> +	if (local_softirq_pending()) {
> +		void *orig_sp, *sp = softirq_stack[smp_processor_id()];
> +
> +		sp += THREAD_SIZE - 192 - STACK_BIAS;
> +
> +		__asm__ __volatile__("mov %%sp, %0\n\t"
> +				     "mov %1, %%sp"
> +				     : "=&r" (orig_sp)
> +				     : "r" (sp));
> +		__do_softirq();
> +		__asm__ __volatile__("mov %0, %%sp"
> +				     : : "r" (orig_sp));
> +	}
> +
> +	local_irq_restore(flags);
> +}
> +#endif
> +
> #ifdef CONFIG_HOTPLUG_CPU
> void fixup_irqs(void)
> {
> diff --git a/arch/sparc64/mm/init.c b/arch/sparc64/mm/init.c
> index 84898c4..56e22f4 100644
> --- a/arch/sparc64/mm/init.c
> +++ b/arch/sparc64/mm/init.c
> @@ -49,6 +49,7 @@
> #include <asm/sstate.h>
> #include <asm/mdesc.h>
> #include <asm/cpudata.h>
> +#include <asm/irq.h>
>
> #define MAX_PHYS_ADDRESS	(1UL << 42UL)
> #define KPTE_BITMAP_CHUNK_SZ	(256UL * 1024UL * 1024UL)
> @@ -1817,6 +1818,18 @@ void __init paging_init(void)
> 	if (tlb_type == hypervisor)
> 		sun4v_mdesc_init();
>
> +#ifdef CONFIG_IRQSTACKS
> +	/* Once the OF device tree and MDESC have been setup, we know
> +	 * the list of possible cpus.  Therefore we can allocate the
> +	 * IRQ stacks.
> +	 */
> +	for_each_possible_cpu(i) {
> +		/* XXX Use node local allocations... XXX */
> +		softirq_stack[i] = __va(lmb_alloc(THREAD_SIZE, THREAD_SIZE));
> +		hardirq_stack[i] = __va(lmb_alloc(THREAD_SIZE, THREAD_SIZE));
> +	}
> +#endif
> +
> 	/* Setup bootmem... */
> 	last_valid_pfn = end_pfn = bootmem_init(phys_base);
>
> diff --git a/include/asm-sparc64/irq.h b/include/asm-sparc64/irq.h
> index 0bb9bf5..d71b5ff 100644
> --- a/include/asm-sparc64/irq.h
> +++ b/include/asm-sparc64/irq.h
> @@ -90,4 +90,10 @@ static inline unsigned long get_softint(void)
> 	return retval;
> }
>
> +#ifdef CONFIG_IRQSTACKS
> +extern void *hardirq_stack[NR_CPUS];
> +extern void *softirq_stack[NR_CPUS];
> +#define __ARCH_HAS_DO_SOFTIRQ
> +#endif
> +
> #endif
>
