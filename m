Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbYGKExz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbYGKExz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 00:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYGKExp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 00:53:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48687 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbYGKExn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 00:53:43 -0400
Message-ID: <4876E68F.3050200@jp.fujitsu.com>
Date: Fri, 11 Jul 2008 13:50:23 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] x86-64: Support for multiple MSIs
References: <20080711005719.GO14894@parisc-linux.org> <1215738002-4961-5-git-send-email-matthew@wil.cx>
In-Reply-To: <1215738002-4961-5-git-send-email-matthew@wil.cx>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm very sorry for very delayed comment, but I have a concern
about irq affinity code. Since I didn't have enough time to
look at your patch, I might be misunderstanding something...

In my understanding, when irq affinity is changed on one of
the IRQs corresponding to MSI, it will not completed until
interrupts occur on all the IRQs. Attempts to change irq
affinity before previous affinity change is finished will be
ignored. Here, suppose that device uses three MSI irqs. In
this case, your patch manages four irqs, but only three
interrupts are used. If irq affinity changed on this MSI
interrupts, will it be completed?

Thanks,
Kenji Kaneshige


Matthew Wilcox wrote:
> Implement the arch_setup_msi_irqs() interface.  Extend create_irq()
> into create_irq_block() and reimplement create_irq as a wrapper around
> it.  Create assign_irq_vector_block() based closely on
> assign_irq_vector().  Teach set_msi_irq_affinity() how to handle
> multiple MSIs.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  arch/x86/kernel/io_apic_64.c |  237 ++++++++++++++++++++++++++++++++++++------
>  1 files changed, 205 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
> index ef1a8df..6a00dca 100644
> --- a/arch/x86/kernel/io_apic_64.c
> +++ b/arch/x86/kernel/io_apic_64.c
> @@ -61,7 +61,7 @@ struct irq_cfg {
>  };
>  
>  /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
> -struct irq_cfg irq_cfg[NR_IRQS] __read_mostly = {
> +static struct irq_cfg irq_cfg[NR_IRQS] __read_mostly = {
>  	[0]  = { .domain = CPU_MASK_ALL, .vector = IRQ0_VECTOR,  },
>  	[1]  = { .domain = CPU_MASK_ALL, .vector = IRQ1_VECTOR,  },
>  	[2]  = { .domain = CPU_MASK_ALL, .vector = IRQ2_VECTOR,  },
> @@ -683,6 +683,8 @@ static int pin_2_irq(int idx, int apic, int pin)
>  	return irq;
>  }
>  
> +static int current_vector = FIRST_DEVICE_VECTOR;
> +
>  static int __assign_irq_vector(int irq, cpumask_t mask)
>  {
>  	/*
> @@ -696,7 +698,7 @@ static int __assign_irq_vector(int irq, cpumask_t mask)
>  	 * Also, we've got to be careful not to trash gate
>  	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
>  	 */
> -	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
> +	static int current_offset = 0;
>  	unsigned int old_vector;
>  	int cpu;
>  	struct irq_cfg *cfg;
> @@ -769,6 +771,97 @@ static int assign_irq_vector(int irq, cpumask_t mask)
>  	return err;
>  }
>  
> +static int __assign_irq_vector_block(int irq, int count, cpumask_t mask)
> +{
> +	unsigned int old_vector;
> +	int i, cpu;
> +	struct irq_cfg *cfg;
> +
> +	/*
> +	 * We've got to be careful not to trash gate 0x80,
> +	 * because int 0x80 is hm, kind of importantish. ;)
> +	 */
> +	BUG_ON((unsigned)irq + count > NR_IRQS);
> +
> +	/* Only try and allocate irqs on cpus that are present */
> +	cpus_and(mask, mask, cpu_online_map);
> +
> +	for (i = 0; i < count; i++) {
> +		cfg = &irq_cfg[irq + i];
> +		if ((cfg->move_in_progress) || cfg->move_cleanup_count)
> +			return -EBUSY;
> +	}
> +
> +	cfg = &irq_cfg[irq];
> +	old_vector = cfg->vector;
> +	if (old_vector) {
> +		cpumask_t tmp;
> +		cpus_and(tmp, cfg->domain, mask);
> +		if (!cpus_empty(tmp))
> +			return 0;
> +	}
> +
> +	for_each_cpu_mask(cpu, mask) {
> +		cpumask_t domain, new_mask;
> +		int new_cpu;
> +		int vector;
> +
> +		domain = vector_allocation_domain(cpu);
> +		cpus_and(new_mask, domain, cpu_online_map);
> +
> +		vector = current_vector & ~(count - 1);
> + next:
> +		vector += count;
> +		if (vector + count >= FIRST_SYSTEM_VECTOR) {
> +			vector = FIRST_DEVICE_VECTOR & ~(count - 1);
> +			if (vector < FIRST_DEVICE_VECTOR)
> +				vector += count;
> +		}
> +		if (unlikely(vector == (current_vector & ~(count - 1))))
> +			continue;
> +		if ((IA32_SYSCALL_VECTOR >= vector) &&
> +		    (IA32_SYSCALL_VECTOR < vector + count))
> +			goto next;
> +		for_each_cpu_mask(new_cpu, new_mask) {
> +			for (i = 0; i < count; i++) {
> +				if (per_cpu(vector_irq, new_cpu)[vector + i]
> +									!= -1)
> +					goto next;
> +			}
> +		}
> +		/* Found one! */
> +		current_vector = vector + count - 1;
> +		for (i = 0; i < count; i++) {
> +			cfg = &irq_cfg[irq + i];
> +			if (old_vector) {
> +				cfg->move_in_progress = 1;
> +				cfg->old_domain = cfg->domain;
> +			}
> +			for_each_cpu_mask(new_cpu, new_mask) {
> +				per_cpu(vector_irq, new_cpu)[vector + i] =
> +					irq + i;
> +			}
> +			cfg->vector = vector;
> +			cfg->domain = domain;
> +		}
> +		return 0;
> +	}
> +	return -ENOSPC;
> +}
> +
> +/* Assumes that count is a power of two and aligns to that power of two */
> +static int assign_irq_vector_block(int irq, int count, cpumask_t mask)
> +{
> +	int result;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&vector_lock, flags);
> +	result = __assign_irq_vector_block(irq, count, mask);
> +	spin_unlock_irqrestore(&vector_lock, flags);
> +
> +	return result;
> +}
> +
>  static void __clear_irq_vector(int irq)
>  {
>  	struct irq_cfg *cfg;
> @@ -788,6 +881,14 @@ static void __clear_irq_vector(int irq)
>  	cpus_clear(cfg->domain);
>  }
>  
> +static void __clear_irq_vector_block(int irq, int count)
> +{
> +	while (count > 0) {
> +		count--;
> +		__clear_irq_vector(irq + count);
> +	}
> +}
> +
>  void __setup_vector_irq(int cpu)
>  {
>  	/* Initialize vector_irq on a new cpu */
> @@ -1895,30 +1996,56 @@ device_initcall(ioapic_init_sysfs);
>  /*
>   * Dynamic irq allocate and deallocation
>   */
> -int create_irq(void)
> +
> +/*
> + * On success, returns the interrupt number of the lowest numbered irq
> + * in the block.  If it can't find a block of the right size, it returns
> + * -1 - (length of the longest run).
> + */
> +static int create_irq_block(int count)
>  {
> -	/* Allocate an unused irq */
> -	int irq;
> -	int new;
> +	/* Allocate 'count' consecutive unused irqs */
> +	int i, new, longest;
>  	unsigned long flags;
>  
> -	irq = -ENOSPC;
> +	longest = 0;
>  	spin_lock_irqsave(&vector_lock, flags);
>  	for (new = (NR_IRQS - 1); new >= 0; new--) {
>  		if (platform_legacy_irq(new))
> -			continue;
> +			goto clear;
>  		if (irq_cfg[new].vector != 0)
> +			goto clear;
> +		longest++;
> +		if (longest < count)
>  			continue;
> -		if (__assign_irq_vector(new, TARGET_CPUS) == 0)
> -			irq = new;
> +
> +		while (__assign_irq_vector_block(new, longest, TARGET_CPUS))
> +			longest /= 2;
> +		if (longest < count)
> +			__clear_irq_vector_block(new, longest);
>  		break;
> + clear:
> +		__clear_irq_vector_block(new + 1, longest);
> +		longest = 0;
>  	}
>  	spin_unlock_irqrestore(&vector_lock, flags);
>  
> -	if (irq >= 0) {
> -		dynamic_irq_init(irq);
> +	if (longest < count)
> +		return -1 - longest;
> +
> +	for (i = 0; i < count; i++) {
> +		dynamic_irq_init(new + i);
>  	}
> -	return irq;
> +
> +	return new;
> +}
> +
> +int create_irq(void)
> +{
> +	int ret = create_irq_block(1);
> +	if (ret < 0)
> +		return -ENOSPC;
> +	return ret;
>  }
>  
>  void destroy_irq(unsigned int irq)
> @@ -1936,7 +2063,8 @@ void destroy_irq(unsigned int irq)
>   * MSI message composition
>   */
>  #ifdef CONFIG_PCI_MSI
> -static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_msg *msg)
> +static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
> +				unsigned int count, struct msi_msg *msg)
>  {
>  	struct irq_cfg *cfg = irq_cfg + irq;
>  	int err;
> @@ -1944,7 +2072,10 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
>  	cpumask_t tmp;
>  
>  	tmp = TARGET_CPUS;
> -	err = assign_irq_vector(irq, tmp);
> +	if (count == 1)
> +		err = assign_irq_vector(irq, tmp);
> +	else
> +		err = assign_irq_vector_block(irq, count, tmp);
>  	if (!err) {
>  		cpus_and(tmp, cfg->domain, tmp);
>  		dest = cpu_mask_to_apicid(tmp);
> @@ -1975,6 +2106,8 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
>  static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
>  {
>  	struct irq_cfg *cfg = irq_cfg + irq;
> +	struct msi_desc *desc = get_irq_msi(irq);
> +	int i, count = 1 << desc->msi_attrib.multiple;
>  	struct msi_msg msg;
>  	unsigned int dest;
>  	cpumask_t tmp;
> @@ -1983,8 +2116,15 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
>  	if (cpus_empty(tmp))
>  		return;
>  
> -	if (assign_irq_vector(irq, mask))
> -		return;
> +	if (count > 1) {
> +		/* Multiple MSIs all go to the same destination */
> +		irq = desc->irq;
> +		if (assign_irq_vector_block(irq, count, mask))
> +			return;
> +	} else {
> +		if (assign_irq_vector(irq, mask))
> +			return;
> +	}
>  
>  	cpus_and(tmp, cfg->domain, mask);
>  	dest = cpu_mask_to_apicid(tmp);
> @@ -1997,7 +2137,9 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
>  	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
>  
>  	write_msi_msg(irq, &msg);
> -	irq_desc[irq].affinity = mask;
> +
> +	for (i = 0; i < count; i++)
> +		irq_desc[irq + i].affinity = mask;
>  }
>  #endif /* CONFIG_SMP */
>  
> @@ -2016,28 +2158,59 @@ static struct irq_chip msi_chip = {
>  	.retrigger	= ioapic_retrigger_irq,
>  };
>  
> -int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
> +static int x86_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc, int count)
>  {
>  	struct msi_msg msg;
> -	int irq, ret;
> -	irq = create_irq();
> -	if (irq < 0)
> -		return irq;
> -
> -	ret = msi_compose_msg(dev, irq, &msg);
> -	if (ret < 0) {
> -		destroy_irq(irq);
> -		return ret;
> +	int i, ret, base_irq, alloc;
> +
> +	/* MSI can only allocate a power-of-two */
> +	alloc = roundup_pow_of_two(count);
> +
> +	base_irq = create_irq_block(alloc);
> +	if (base_irq < 0) {
> +		if (alloc == 1)
> +			return -ENOSPC;
> +		return rounddown_pow_of_two(-base_irq - 1);
>  	}
>  
> -	set_irq_msi(irq, desc);
> -	write_msi_msg(irq, &msg);
> +	ret = msi_compose_msg(pdev, base_irq, alloc, &msg);
> +	if (ret)
> +		return ret;
> +
> +	desc->msi_attrib.multiple = order_base_2(alloc);
>  
> -	set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
> +	/* Do loop in reverse so set_irq_msi ends up setting
> +	 * desc->irq to base_irq
> +	 */
> +	for (i = count - 1; i >= 0; i--) {
> +		set_irq_msi(base_irq + i, desc);
> +		set_irq_chip_and_handler_name(base_irq + i, &msi_chip,
> +						handle_edge_irq, "edge");
> +	}
> +	write_msi_msg(base_irq, &msg);
>  
>  	return 0;
>  }
>  
> +int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
> +{
> +	struct msi_desc *desc;
> +	int ret;
> +
> +	if (type == PCI_CAP_ID_MSI) {
> +		desc = list_first_entry(&pdev->msi_list, struct msi_desc, list);
> +		ret = x86_setup_msi_irq(pdev, desc, nvec);
> +	} else {
> +		list_for_each_entry(desc, &pdev->msi_list, list) {
> +			ret = x86_setup_msi_irq(pdev, desc, 1);
> +			if (ret)
> +				break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
>  void arch_teardown_msi_irq(unsigned int irq)
>  {
>  	destroy_irq(irq);
> @@ -2090,7 +2263,7 @@ int arch_setup_dmar_msi(unsigned int irq)
>  	int ret;
>  	struct msi_msg msg;
>  
> -	ret = msi_compose_msg(NULL, irq, &msg);
> +	ret = msi_compose_msg(NULL, irq, 1, &msg);
>  	if (ret < 0)
>  		return ret;
>  	dmar_msi_write(irq, &msg);


