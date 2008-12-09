Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbYLIDmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbYLIDmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 22:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYLIDmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 22:42:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49078 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbYLIDmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 22:42:09 -0500
Date: Tue, 9 Dec 2008 04:41:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: move irq_desc according to smp_affinity v6
Message-ID: <20081209034149.GB9809@elte.hu>
References: <1228532430-28958-1-git-send-email-yinghai@kernel.org> <20081208134219.GC29965@elte.hu> <493D9A8E.7070107@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493D9A8E.7070107@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> for physical apic is much simple
> on 4 sockets 16 cores system
> irq_desc is moving..
> when
> # echo 10 > /proc/irq/134483967/smp_affinity
> # echo 100 > /proc/irq/134483967/smp_affinity
> # echo 1000 > /proc/irq/134483967/smp_affinity
> got
> Nov  9 21:39:51 LBSuse kernel:   move irq_desc for 134483967 aka 0x8040fff to cpu 4 node 1
> Nov  9 21:39:51 LBSuse kernel:   alloc kstat_irqs on cpu 4 node 1
> Nov  9 21:39:51 LBSuse kernel:   alloc irq_cfg on cpu 4 node 1
> Nov  9 21:40:05 LBSuse kernel:   move irq_desc for 134483967 aka 0x8040fff to cpu 8 node 2
> Nov  9 21:40:05 LBSuse kernel:   alloc kstat_irqs on cpu 8 node 2
> Nov  9 21:40:05 LBSuse kernel:   alloc irq_cfg on cpu 8 node 2
> Nov  9 21:40:18 LBSuse kernel:   move irq_desc for 134483967 aka 0x8040fff to cpu 12 node 3
> Nov  9 21:40:18 LBSuse kernel:   alloc kstat_irqs on cpu 12 node 3
> Nov  9 21:40:18 LBSuse kernel:   alloc irq_cfg on cpu 12 node 3
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Neat feature!

i'm wondering, have you tried to characterise the cost savings of moving 
the irq desc? It will certainly save three heavy cross-NUMA cachemisses 
on x86 per rare irq source.

A way to attempt to measure this would be to write some quick debug hack 
that prints the cycle count of one specific IRQ source, in do_IRQ(), from 
the entry of do_IRQ() to the exit of do_IRQ(), using rdtscl(). Pick an 
IRQ that you can trigger arbitrarily, and printk the cycle cost at the 
end of do_IRQ(). [if irq == your_debug_irq - otherwise you can get a lot 
of printks and not too good measurements].

plus perhaps add some quick hack that makes the 
irq_desc/chip_data/kstat_irqs migration dependent on a sysctl, such as 
'panic_timeout' (tunable via 'echo 1 > /proc/sys/kernel/panic'). Then you 
could try to trigger your debug IRQ and the cycle cost printk in two 
modes:

  echo 0 > /proc/sys/kernel/panic

  [ migrate the IRQ to another domain and trigger the IRQ - wait for the 
    cycle printout. Both cache-cold and cache-hot numbers are 
    interesting. ]

  echo 1 > /proc/sys/kernel/panic

  [ re-migrate the debug IRQ via /proc/irq/*/smp_affinity to make sure 
    it's NUMA-local, then trigger the debug IRQ and record cache-cold and 
    cache-hot cycle counts. ]

it's hard to measure this reliably, as on x86 the numa factor is usually 
pretty low, so the local versus remote cachemiss cost is hard to 
separate.

A few comments about the patch too:

> +config MOVE_IRQ_DESC
> +	bool "Move irq desc when changing irq smp_affinity"
> +	depends on SPARSE_IRQ && SMP
> +	default y

new feature - should be default-no.

> +	help
> +	  This enables moving irq_desc to cpu/node that irq will use handled.
> +
> +	  If you don't know what to do here, say Y.

Later on i think we should just select this in the NUMA case, instead of 
complicating the user's selection. It's OK to have it configurable now - 
should it cause problems.

> +
>  config X86_FIND_SMP_CONFIG
>  	def_bool y
>  	depends on X86_MPPARSE || X86_VOYAGER
> Index: linux-2.6/arch/x86/kernel/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/io_apic.c
> +++ linux-2.6/arch/x86/kernel/io_apic.c
> @@ -141,6 +141,9 @@ struct irq_cfg {
>  	unsigned move_cleanup_count;
>  	u8 vector;
>  	u8 move_in_progress : 1;
> +#ifdef CONFIG_MOVE_IRQ_DESC
> +	u8 move_desc_in_progress_in_same_domain : 1;
> +#endif

way too long field name - please rename to move_desc_pending or so.

> @@ -223,6 +226,122 @@ void arch_init_chip_data(struct irq_desc
>  	}
>  }
>  
> +#ifdef CONFIG_MOVE_IRQ_DESC
> +
> +static void init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg,
> +				 int cpu)
> +{

small style nit, it's a tiny bit tidier to break the line the following 
way:

static void
init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int cpu)

[ as this way we have all the parameters on a single line, and the return 
  type stands out on a separate line. ]

> +	struct irq_pin_list *old_entry, *head, *tail, *entry;
> +
> +	cfg->irq_2_pin = NULL;
> +	old_entry = old_cfg->irq_2_pin;
> +	if (!old_entry)
> +		return;
> +
> +	entry = get_one_free_irq_2_pin(cpu);
> +	if (!entry)
> +		return;
> +
> +	entry->apic = old_entry->apic;
> +	entry->pin = old_entry->pin;
> +	head = entry;
> +	tail = entry;
> +	old_entry = old_entry->next;

for mass-initialization please try to structure it a bit:

> +	entry->apic	= old_entry->apic;
> +	entry->pin	= old_entry->pin;
> +	head		= entry;
> +	tail		= entry;
> +
> +	old_entry	= old_entry->next;

it's much easier to validate such constructs. For example, once 
vertically aligned, i immediately saw an oddity in it - why is 
'old_entry' initialized twice?

> +
> +	while (old_entry) {
> +		entry = get_one_free_irq_2_pin(cpu);
> +		if (!entry) {
> +			entry = head;
> +			while (entry) {
> +				head = entry->next;
> +				kfree(entry);
> +				entry = head;
> +			}
> +			/* still use the old one */
> +			return;
> +		}

same here:

> +		entry->apic = old_entry->apic;
> +		entry->pin = old_entry->pin;
> +		tail->next = entry;
> +		tail = entry;
> +		old_entry = old_entry->next;
> +	}
> +
> +	tail->next = NULL;
> +	cfg->irq_2_pin = head;
> +}
> +
> +static void free_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg)
> +{
> +	struct irq_pin_list *entry, *next;
> +
> +	if (old_cfg->irq_2_pin == cfg->irq_2_pin)
> +		return;
> +
> +	entry = old_cfg->irq_2_pin;
> +
> +	while (entry) {
> +		next = entry->next;
> +		kfree(entry);
> +		entry = next;
> +	}
> +	old_cfg->irq_2_pin = NULL;
> +}
> +
> +void arch_init_copy_chip_data(struct irq_desc *old_desc,
> +				 struct irq_desc *desc, int cpu)
> +{
> +	struct irq_cfg *cfg;
> +	struct irq_cfg *old_cfg;
> +
> +	cfg = get_one_free_irq_cfg(cpu);
> +
> +	if (!cfg)
> +		return;
> +
> +	desc->chip_data = cfg;
> +
> +	old_cfg = old_desc->chip_data;
> +
> +	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
> +
> +	init_copy_irq_2_pin(old_cfg, cfg, cpu);
> +}
> +
> +static void free_irq_cfg(struct irq_cfg *old_cfg)
> +{
> +	kfree(old_cfg);
> +}
> +
> +void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
> +{
> +	struct irq_cfg *old_cfg, *cfg;
> +
> +	old_cfg = old_desc->chip_data;
> +	cfg = desc->chip_data;
> +
> +	if (old_cfg == cfg)
> +		return;
> +
> +	if (old_cfg) {
> +		free_irq_2_pin(old_cfg, cfg);
> +		free_irq_cfg(old_cfg);
> +		old_desc->chip_data = NULL;
> +	}
> +}
> +
> +static void set_extra_move_desc(struct irq_desc *desc, cpumask_t mask)
> +{
> +	struct irq_cfg *cfg = desc->chip_data;
> +
> +	if (!cfg->move_in_progress) {
> +		/* it means that domain is not changed */
> +		if (!cpus_intersects(desc->affinity, mask))
> +			cfg->move_desc_in_progress_in_same_domain = 1;
> +	}
> +}
> +#endif
> +
>  #else
>  static struct irq_cfg *irq_cfg(unsigned int irq)
>  {
> @@ -231,9 +350,11 @@ static struct irq_cfg *irq_cfg(unsigned
>  
>  #endif
>  
> +#ifndef CONFIG_MOVE_IRQ_DESC
>  static inline void set_extra_move_desc(struct irq_desc *desc, cpumask_t mask)
>  {
>  }
> +#endif
>  
>  struct io_apic {
>  	unsigned int index;
> @@ -2346,14 +2467,34 @@ static void irq_complete_move(struct irq
>  	struct irq_cfg *cfg = desc->chip_data;
>  	unsigned vector, me;
>  
> -	if (likely(!cfg->move_in_progress))
> +	if (likely(!cfg->move_in_progress)) {
> +#ifdef CONFIG_MOVE_IRQ_DESC
> +		if (likely(!cfg->move_desc_in_progress_in_same_domain))
> +			return;
> +
> +		/* domain is not change, but affinity is changed */
> +		me = smp_processor_id();
> +		if (cpu_isset(me, desc->affinity)) {
> +			*descp = desc = move_irq_desc(desc, me);
> +			/* get the new one */
> +			cfg = desc->chip_data;
> +			cfg->move_desc_in_progress_in_same_domain = 0;
> +		}
> +#endif
>  		return;
> +	}
>  
>  	vector = ~get_irq_regs()->orig_ax;
>  	me = smp_processor_id();
>  	if ((vector == cfg->vector) && cpu_isset(me, cfg->domain)) {
>  		cpumask_t cleanup_mask;
>  
> +#ifdef CONFIG_MOVE_IRQ_DESC
> +		*descp = desc = move_irq_desc(desc, me);
> +		/* get the new one */
> +		cfg = desc->chip_data;
> +#endif
> +
>  		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
>  		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
>  		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
> Index: linux-2.6/kernel/irq/handle.c
> ===================================================================
> --- linux-2.6.orig/kernel/irq/handle.c
> +++ linux-2.6/kernel/irq/handle.c
> @@ -90,6 +90,32 @@ static void init_kstat_irqs(struct irq_d
>  		desc->kstat_irqs = (unsigned int *)ptr;
>  }
>  
> +#ifdef CONFIG_MOVE_IRQ_DESC
> +static void init_copy_kstat_irqs(struct irq_desc *old_desc, struct irq_desc *desc,
> +				 int cpu, int nr)
> +{
> +	unsigned long bytes;
> +
> +	init_kstat_irqs(desc, cpu, nr);
> +
> +	if (desc->kstat_irqs != old_desc->kstat_irqs) {
> +		/* Compute how many bytes we need per irq and allocate them */
> +		bytes = nr * sizeof(unsigned int);
> +
> +		memcpy(desc->kstat_irqs, old_desc->kstat_irqs, bytes);
> +	}
> +}
> +
> +static void free_kstat_irqs(struct irq_desc *old_desc, struct irq_desc *desc)
> +{
> +	if (old_desc->kstat_irqs == desc->kstat_irqs)
> +		return;
> +
> +	kfree(old_desc->kstat_irqs);
> +	old_desc->kstat_irqs = NULL;
> +}
> +#endif
> +
>  void __attribute__((weak)) arch_init_chip_data(struct irq_desc *desc, int cpu)
>  {
>  }
> @@ -110,6 +136,23 @@ static void init_one_irq_desc(int irq, s
>  	arch_init_chip_data(desc, cpu);
>  }
>  
> +#ifdef CONFIG_MOVE_IRQ_DESC
> +static void init_copy_one_irq_desc(int irq, struct irq_desc *old_desc,
> +		 struct irq_desc *desc, int cpu)
> +{
> +	memcpy(desc, old_desc, sizeof(struct irq_desc));
> +	desc->cpu = cpu;
> +	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
> +	init_copy_kstat_irqs(old_desc, desc, cpu, nr_cpu_ids);
> +	arch_init_copy_chip_data(old_desc, desc, cpu);
> +}
> +
> +static void free_one_irq_desc(struct irq_desc *old_desc, struct irq_desc *desc)
> +{
> +	free_kstat_irqs(old_desc, desc);
> +	arch_free_chip_data(old_desc, desc);
> +}
> +#endif
>  /*
>   * Protect the sparse_irqs:
>   */
> @@ -203,6 +246,73 @@ out_unlock:
>  	return desc;
>  }
>  
> +#ifdef CONFIG_MOVE_IRQ_DESC
> +static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
> +						int cpu)
> +{
> +	struct irq_desc *desc;
> +	unsigned int irq;
> +	unsigned long flags;
> +	int node;
> +
> +	irq = old_desc->irq;
> +
> +	spin_lock_irqsave(&sparse_irq_lock, flags);
> +
> +	/* We have to check it to avoid races with another CPU */
> +	desc = irq_desc_ptrs[irq];
> +
> +	if (desc && old_desc != desc)
> +			goto out_unlock;
> +
> +	node = cpu_to_node(cpu);
> +	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
> +	printk(KERN_DEBUG "  move irq_desc for %d to cpu %d node %d\n",
> +		 irq, cpu, node);
> +	if (!desc) {
> +		printk(KERN_ERR "can not get new irq_desc for moving\n");
> +		/* still use old one */
> +		desc = old_desc;
> +		goto out_unlock;
> +	}
> +	init_copy_one_irq_desc(irq, old_desc, desc, cpu);
> +
> +	irq_desc_ptrs[irq] = desc;
> +
> +	/* free the old one */
> +	free_one_irq_desc(old_desc, desc);
> +	kfree(old_desc);
> +
> +out_unlock:
> +	spin_unlock_irqrestore(&sparse_irq_lock, flags);
> +
> +	return desc;
> +}
> +
> +struct irq_desc *move_irq_desc(struct irq_desc *desc, int cpu)
> +{
> +	int old_cpu;
> +	int node, old_node;
> +
> +	/* those all static, do move them */
> +	if (desc->irq < NR_IRQS_LEGACY)
> +		return desc;
> +
> +	old_cpu = desc->cpu;
> +	printk(KERN_DEBUG "try to move irq_desc from cpu %d to %d\n", old_cpu, cpu);
> +	if (old_cpu != cpu) {
> +		node = cpu_to_node(cpu);
> +		old_node = cpu_to_node(old_cpu);
> +		if (old_node != node)
> +			desc = __real_move_irq_desc(desc, cpu);
> +		else
> +			desc->cpu = cpu;
> +	}
> +
> +	return desc;
> +}
> +#endif

Still a bit too much of #ifdeffery for my taste in kernel/irq/*.c, we 
tend to have higher maintenance costs in files that have a lot of
#ifdefs.

Wouldnt it look neater if you introduced a new kernel/irq/numa_migrate.c 
function that would provide these methods, with the prototypes being
#ifdef-ed to inlines in the !CONFIG_MOVE_IRQ_DESC case in
kernel/irq/internals.h?

i'd also suggest to rename the config option to the more descriptive: 
CONFIG_NUMA_MIGRATE_IRQ_DESC name.

>  		/*
>  		 * No locking required for CPU-local interrupts:
>  		 */
> -		if (desc->chip->ack)
> +		if (desc->chip->ack) {
>  			desc->chip->ack(irq);
> +			/* get new one */
> +			desc = irq_remap_to_desc(irq, desc);
> +		}

thanks for fixing this - it looks much nicer now!

	Ingo
