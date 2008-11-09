Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbYKIHik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbYKIHik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 02:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYKIHib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 02:38:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54340 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYKIHia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 02:38:30 -0500
Date: Sun, 9 Nov 2008 08:38:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] sparse_irq aka dyn_irq
Message-ID: <20081109073813.GA17180@elte.hu>
References: <20081027164135.GD19476@elte.hu> <4912B2FE.7030804@kernel.org> <20081106101715.GA4022@elte.hu> <4913B45C.1000009@kernel.org> <20081107081249.GB4435@elte.hu> <4913F9AA.80500@kernel.org> <20081107084240.GG4435@elte.hu> <491434FB.2050904@kernel.org> <20081107124957.GA21709@elte.hu> <49168BD3.5010204@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49168BD3.5010204@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


General impression: very nice patch!

A lot of the structural problems have been addressed: the descriptor 
lookup is now hashed, the dynarray stuff got cleaned up / eliminated, 
the irq_desc->chip_data binding is very nice as well.

(And the patch needs to be split up like it was in the past, once all 
review feedback has been seen and addressed.)

> +config HAVE_SPARSE_IRQ
> +	bool
> +	default y

i think it should be made user-configurable - at least initially. It 
should not cause extra complications, right?

> +	if (irq < NR_IRQS_LEGACY) {

please s/NR_IRQS_LEGACY/NR_IRQS_X86_LEGACY - this is never used 
outside of x86 code.

> +		cfg_new = desc_new->chip_data;

the chip_data binding is a nice touch.

> -	irq_want = build_irq_for_pci_dev(dev) + 0x100;
> +	irq_want = build_irq_for_pci_dev(dev) + 0xfff;

please replace magic constant with a properly named constant.

> -	if (WARN_ON(nr > NR_IRQS))
> -		nr = NR_IRQS;

this will have to stay for the !SPARSE_IRQ case.

> +++ linux-2.6/arch/x86/mm/init_32.c
> @@ -66,6 +66,7 @@ static unsigned long __meminitdata table
>  static unsigned long __meminitdata table_top;
>  
>  static int __initdata after_init_bootmem;
> +int after_bootmem;
>  
>  static __init void *alloc_low_page(unsigned long *phys)
>  {
> @@ -987,6 +988,8 @@ void __init mem_init(void)
>  
>  	set_highmem_pages_init();
>  
> +	after_bootmem = 1;

this hack can go away once we have a proper percpu_alloc() that can be 
used early enough.

> +#ifndef CONFIG_HAVE_SPARSE_IRQ

i'd suggest s/HAVE_SPARSE_IRQ/SPARSE_IRQ - as the HAVE_* flags are for 
architecture code to signal the presence of a facility.

> +#ifndef CONFIG_HAVE_SPARSE_IRQ
>  	if (irq >= nr_irqs)
>  		return;
> +#endif

we should hide as many ugly #ifdefs as possible, and define nr_irqs to 
NR_IRQS in the !SPARSE_IRQ case.

> +++ linux-2.6/drivers/pci/htirq.c
> @@ -82,6 +82,18 @@ void unmask_ht_irq(unsigned int irq)
>  	write_ht_irq_msg(irq, &msg);
>  }
>  
> +static unsigned int build_irq_for_pci_dev(struct pci_dev *dev)
> +{
> +	unsigned int irq;
> +
> +	irq = dev->bus->number;
> +	irq <<= 8;
> +	irq |= dev->devfn;
> +	irq <<= 12;
> +
> +	return irq;

magic constants should be named.

> +#ifdef CONFIG_HAVE_SPARSE_IRQ
> +	irq = create_irq_nr(irq_want + idx);
> +#else
>  	irq = create_irq();
> +#endif

please eliminate this #ifdef by adding one new API: 
create_irq_nr(idx), which just maps to the create_irq() API in the 
!SPARSE_IRQ case.

>  static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
>  {
> -	return (irq < nr_irqs) ? irq_2_iommuX + irq : NULL;
> +	struct irq_desc *desc;
> +
> +	desc = irq_to_desc(irq);
> +
> +	BUG_ON(!desc);
> +
> +	return desc->irq_2_iommu;

the BUG_ON() is not too friendly, please do something like this 
instead:

	if (WARN_ON_ONCE(!desc))
		return NULL;

> +#ifndef CONFIG_HAVE_SPARSE_IRQ
>  	/* protect irq_2_iommu_alloc later */
>  	if (irq >= nr_irqs)
>  		return -1;
> +#endif

this #ifdef can be eliminated too and turned into straight code via 
the #define nr_irqs NR_IRQS trick in the !SPARSE_IRQ case.

> -	for_each_irq_desc(i, desc)
> +	for_each_irq_desc(i, desc) {
>  		desc->affinity = cpumask_of_cpu(0);
> +	} end_for_each_irq_desc();

Sidenote: later on, once the patch is upstream, we should do a global 
rename:

 s/for_each_irq_desc/do_each_irq_desc
 s/end_for_each_irq_desc/while_each_irq_desc

as it's much harder to miss the "while" in a "do ..." loop, than it is 
to miss the "end" in a "for" loop.

> +#ifdef CONFIG_HAVE_SPARSE_IRQ
> +static struct irq_desc irq_desc_init = {
> +	.irq = -1U,
> +	.status = IRQ_DISABLED,
> +	.chip = &no_irq_chip,
> +	.handle_irq = handle_bad_irq,
> +	.depth = 1,
> +	.lock = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
> +#ifdef CONFIG_SMP
> +	.affinity = CPU_MASK_ALL
> +#endif
> +};

please align structure fields vertically.

> +static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
> +	[0 ... NR_IRQS_LEGACY-1] = {
> +		.irq = -1U,
> +		.status = IRQ_DISABLED,
> +		.chip = &no_irq_chip,
> +		.handle_irq = handle_bad_irq,
> +		.depth = 1,
> +		.lock = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
> +#ifdef CONFIG_SMP
> +		.affinity = CPU_MASK_ALL
> +#endif
> +	}
> +};

same here.

> @@ -199,7 +200,6 @@ extern void reinit_intr_remapped_IO_APIC
>  #endif
>  
>  extern int probe_nr_irqs(void);
> -
>  #else  /* !CONFIG_X86_IO_APIC */
>  #define io_apic_assign_pci_irqs 0
>  static const int timer_through_8259 = 0;

that's a spurious removal of a newline.

all in one, i cannot see fundamental problems in this patch.

	Ingo
