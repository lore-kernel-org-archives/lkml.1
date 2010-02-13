Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab0BMM0M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 07:26:12 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55163 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab0BMM0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 07:26:06 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH  0/8] tip related: radix tree for spareseirq and logical flat clean up
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>
	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 13 Feb 2010 04:26:01 -0800
In-Reply-To: <4B7676BB.8030608@kernel.org> (Yinghai Lu's message of "Sat\, 13 Feb 2010 01\:54\:03 -0800")
Message-ID: <m16361pbja.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On 02/12/2010 07:44 PM, Eric W. Biederman wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>> 
>>> ---------spareirq radix tree related ----------------
>>> 94007e8: irq: remove not need bootmem code
>>> 4b0d3fa: radix: move radix init early
>>> 56af1a9: sparseirq: change irq_desc_ptrs to static
>>> b236235: sparseirq: use radix_tree instead of ptrs array
>>> 5918787: x86: remove arch_probe_nr_irqs
>>>
>>> so could reduce nr_irqs limitation for bunch ixgbe...
>>>
>>> ---------------x86 logical flat related -----------
>>> f5954c4: use nr_cpus= to set nr_cpu_ids early
>>> 7b8d6a9: x86: use num_processors for possible cpus
>>> d79d1de: x86: make 32bit apic flat to physflat switch like 64bit
>> 
>> Thanks for keeping this work alive.
>> 
>> I just skimmed through do_IRQ and I happened to notice that
>> we have an unnecessary inefficiency that using a radix tree for
>> irq_to_desc will magnify.
>> 
>> handle_irq should take an struct irq_desc * instead of a unsigned int irq.
>> 
>> and the per cpu vector_irq array should become a per cpu vector_desc array.
>> 
>> As soon as irq_to_desc is more than &irq_desc[irq] this saves us work
>> and cache line misses  at the cost of a simple code cleanup.
>> 
>
> please check
>
> Subject: [PATCH] x86: use vector_desc instead of vector_irq
>
> Eric pointed out that radix tree version of irq_to_desc will magnify delay on the path
> of handle_irq.
> use vector_desc to reduce the calling of irq_to_desc.
>
> next step: need to change all ack, mask, umask, eoi for all irq_chip to take irq_desc

Overall this looks good, and your next step sounds good.

Thanks,
Eric


> Index: linux-2.6/arch/x86/kernel/irq_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/irq_32.c
> +++ linux-2.6/arch/x86/kernel/irq_32.c
> @@ -192,17 +192,17 @@ static inline int
>  execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq) { return 0; }
>  #endif
>  
> -bool handle_irq(unsigned irq, struct pt_regs *regs)
> +bool handle_irq(struct irq_desc *desc, struct pt_regs *regs)
>  {
> -	struct irq_desc *desc;
>  	int overflow;
> +	int irq;

This should be:
	unsigned irq;

irq numbers are unsigned, and with sparse allocation we might even see irq
numbers large enough for that to matter.

>  	overflow = check_stack_overflow();
>  
> -	desc = irq_to_desc(irq);
>  	if (unlikely(!desc))
>  		return false;
>  
> +	irq = desc->irq;
>  	if (!execute_on_irq_stack(overflow, desc, irq)) {
>  		if (unlikely(overflow))
>  			print_stack_overflow();

> Index: linux-2.6/arch/x86/kernel/irqinit.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/irqinit.c
> +++ linux-2.6/arch/x86/kernel/irqinit.c
> @@ -83,16 +83,14 @@ static struct irqaction irq2 = {
>  	.name = "cascade",
>  };
>  
> -DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
> -	[0 ... NR_VECTORS - 1] = -1,
> -};
> +DEFINE_PER_CPU(vector_desc_t, vector_desc);
>  
>  int vector_used_by_percpu_irq(unsigned int vector)
>  {
>  	int cpu;
>  
>  	for_each_online_cpu(cpu) {
> -		if (per_cpu(vector_irq, cpu)[vector] != -1)
> +		if (per_cpu(vector_desc, cpu)[vector] != NULL)
>  			return 1;
>  	}
>  
> @@ -139,7 +137,7 @@ void __init init_IRQ(void)
>  	 * irq's migrate etc.
>  	 */
>  	for (i = 0; i < nr_legacy_irqs; i++)
> -		per_cpu(vector_irq, 0)[IRQ0_VECTOR + i] = i;
> +		per_cpu(vector_desc, 0)[IRQ0_VECTOR + i] = irq_to_desc(i);

I am not familiar with this hunk (it must be in the x86 tree).
Are you certain we have allocated the legacy irq desc here?

>  	x86_init.irqs.intr_init();
>  }
