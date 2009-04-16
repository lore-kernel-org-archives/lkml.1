Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbZDPBnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbZDPBnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZDPBnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:43:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:49616 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbZDPBnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:43:42 -0400
Message-ID: <49E68D0D.30606@kernel.org>
Date: Wed, 15 Apr 2009 18:42:37 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/8] irq: change irq_desc_alloc to take node instead cpu
References: <49E68C41.4020801@kernel.org>
In-Reply-To: <49E68C41.4020801@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: prepare to make irq_desc_alloc to numa aware

so could make irq_desc_alloc use node pass down

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |   46 +++++++++++++++++------------------------
 arch/x86/lguest/boot.c         |    2 -
 drivers/pci/intr_remapping.c   |   15 +++++--------
 drivers/xen/events.c           |    2 -
 include/linux/interrupt.h      |    2 -
 include/linux/irq.h            |   12 +++-------
 kernel/irq/handle.c            |   28 +++++++++---------------
 kernel/irq/internals.h         |    2 -
 kernel/softirq.c               |    2 -
 9 files changed, 46 insertions(+), 65 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -130,12 +130,9 @@ struct irq_pin_list {
 	struct irq_pin_list *next;
 };
 
-static struct irq_pin_list *get_one_free_irq_2_pin(int cpu)
+static struct irq_pin_list *get_one_free_irq_2_pin(int node)
 {
 	struct irq_pin_list *pin;
-	int node;
-
-	node = cpu_to_node(cpu);
 
 	pin = kzalloc_node(sizeof(*pin), GFP_ATOMIC, node);
 
@@ -210,12 +207,9 @@ static struct irq_cfg *irq_cfg(unsigned
 	return cfg;
 }
 
-static struct irq_cfg *get_one_free_irq_cfg(int cpu)
+static struct irq_cfg *get_one_free_irq_cfg(int node)
 {
 	struct irq_cfg *cfg;
-	int node;
-
-	node = cpu_to_node(cpu);
 
 	cfg = kzalloc_node(sizeof(*cfg), GFP_ATOMIC, node);
 	if (cfg) {
@@ -236,13 +230,13 @@ static struct irq_cfg *get_one_free_irq_
 	return cfg;
 }
 
-int arch_init_chip_data(struct irq_desc *desc, int cpu)
+int arch_init_chip_data(struct irq_desc *desc, int node)
 {
 	struct irq_cfg *cfg;
 
 	cfg = desc->chip_data;
 	if (!cfg) {
-		desc->chip_data = get_one_free_irq_cfg(cpu);
+		desc->chip_data = get_one_free_irq_cfg(node);
 		if (!desc->chip_data) {
 			printk(KERN_ERR "can not alloc irq_cfg\n");
 			BUG_ON(1);
@@ -398,13 +392,13 @@ static void ioapic_mask_entry(int apic,
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
-static void add_pin_to_irq_cpu(struct irq_cfg *cfg, int cpu, int apic, int pin)
+static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
 {
 	struct irq_pin_list *entry;
 
 	entry = cfg->irq_2_pin;
 	if (!entry) {
-		entry = get_one_free_irq_2_pin(cpu);
+		entry = get_one_free_irq_2_pin(node);
 		if (!entry) {
 			printk(KERN_ERR "can not alloc irq_2_pin to add %d - %d\n",
 					apic, pin);
@@ -424,7 +418,7 @@ static void add_pin_to_irq_cpu(struct ir
 		entry = entry->next;
 	}
 
-	entry->next = get_one_free_irq_2_pin(cpu);
+	entry->next = get_one_free_irq_2_pin(node);
 	entry = entry->next;
 	entry->apic = apic;
 	entry->pin = pin;
@@ -433,7 +427,7 @@ static void add_pin_to_irq_cpu(struct ir
 /*
  * Reroute an IRQ to a different pin.
  */
-static void __init replace_pin_at_irq_cpu(struct irq_cfg *cfg, int cpu,
+static void __init replace_pin_at_irq_node(struct irq_cfg *cfg, int node,
 				      int oldapic, int oldpin,
 				      int newapic, int newpin)
 {
@@ -453,7 +447,7 @@ static void __init replace_pin_at_irq_cp
 
 	/* why? call replace before add? */
 	if (!replaced)
-		add_pin_to_irq_cpu(cfg, cpu, newapic, newpin);
+		add_pin_to_irq_node(cfg, node, newapic, newpin);
 }
 
 static inline void io_apic_modify_irq(struct irq_cfg *cfg,
@@ -1395,7 +1389,7 @@ static void __init setup_IO_APIC_irqs(vo
 	int notcon = 0;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
-	int cpu = boot_cpu_id;
+	int node = cpu_to_node(boot_cpu_id);
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
@@ -1430,13 +1424,13 @@ static void __init setup_IO_APIC_irqs(vo
 					apic->multi_timer_check(apic_id, irq))
 				continue;
 
-			desc = irq_to_desc_alloc_cpu(irq, cpu);
+			desc = irq_to_desc_alloc_node(irq, node);
 			if (!desc) {
 				printk(KERN_INFO "can not get irq_desc for %d\n", irq);
 				continue;
 			}
 			cfg = desc->chip_data;
-			add_pin_to_irq_cpu(cfg, cpu, apic_id, pin);
+			add_pin_to_irq_node(cfg, node, apic_id, pin);
 
 			setup_IO_APIC_irq(apic_id, pin, irq, desc,
 					irq_trigger(idx), irq_polarity(idx));
@@ -2756,7 +2750,7 @@ static inline void __init check_timer(vo
 {
 	struct irq_desc *desc = irq_to_desc(0);
 	struct irq_cfg *cfg = desc->chip_data;
-	int cpu = boot_cpu_id;
+	int node = cpu_to_node(boot_cpu_id);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
 	int no_pin1 = 0;
@@ -2822,7 +2816,7 @@ static inline void __init check_timer(vo
 		 * Ok, does IRQ0 through the IOAPIC work?
 		 */
 		if (no_pin1) {
-			add_pin_to_irq_cpu(cfg, cpu, apic1, pin1);
+			add_pin_to_irq_node(cfg, node, apic1, pin1);
 			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
 		} else {
 			/* for edge trigger, setup_IO_APIC_irq already
@@ -2859,7 +2853,7 @@ static inline void __init check_timer(vo
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
-		replace_pin_at_irq_cpu(cfg, cpu, apic1, pin1, apic2, pin2);
+		replace_pin_at_irq_node(cfg, node, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
@@ -3078,7 +3072,7 @@ unsigned int create_irq_nr(unsigned int
 	unsigned int new;
 	unsigned long flags;
 	struct irq_cfg *cfg_new = NULL;
-	int cpu = boot_cpu_id;
+	int node = cpu_to_node(boot_cpu_id);
 	struct irq_desc *desc_new = NULL;
 
 	irq = 0;
@@ -3087,7 +3081,7 @@ unsigned int create_irq_nr(unsigned int
 
 	spin_lock_irqsave(&vector_lock, flags);
 	for (new = irq_want; new < nr_irqs; new++) {
-		desc_new = irq_to_desc_alloc_cpu(new, cpu);
+		desc_new = irq_to_desc_alloc_node(new, node);
 		if (!desc_new) {
 			printk(KERN_INFO "can not get irq_desc for %d\n", new);
 			continue;
@@ -3861,7 +3855,7 @@ int io_apic_set_pci_routing (int ioapic,
 {
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
-	int cpu = boot_cpu_id;
+	int node = cpu_to_node(boot_cpu_id);
 
 	if (!IO_APIC_IRQ(irq)) {
 		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
@@ -3869,7 +3863,7 @@ int io_apic_set_pci_routing (int ioapic,
 		return -EINVAL;
 	}
 
-	desc = irq_to_desc_alloc_cpu(irq, cpu);
+	desc = irq_to_desc_alloc_node(irq, node);
 	if (!desc) {
 		printk(KERN_INFO "can not get irq_desc %d\n", irq);
 		return 0;
@@ -3880,7 +3874,7 @@ int io_apic_set_pci_routing (int ioapic,
 	 */
 	if (irq >= NR_IRQS_LEGACY) {
 		cfg = desc->chip_data;
-		add_pin_to_irq_cpu(cfg, cpu, ioapic, pin);
+		add_pin_to_irq_node(cfg, node, ioapic, pin);
 	}
 
 	setup_IO_APIC_irq(ioapic, pin, irq, desc, triggering, polarity);
Index: linux-2.6/arch/x86/lguest/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/lguest/boot.c
+++ linux-2.6/arch/x86/lguest/boot.c
@@ -640,7 +640,7 @@ static void __init lguest_init_IRQ(void)
 
 void lguest_setup_irq(unsigned int irq)
 {
-	irq_to_desc_alloc_cpu(irq, 0);
+	irq_to_desc_alloc_node(irq, 0);
 	set_irq_chip_and_handler_name(irq, &lguest_irq_controller,
 				      handle_level_irq, "level");
 }
Index: linux-2.6/drivers/pci/intr_remapping.c
===================================================================
--- linux-2.6.orig/drivers/pci/intr_remapping.c
+++ linux-2.6/drivers/pci/intr_remapping.c
@@ -23,15 +23,12 @@ struct irq_2_iommu {
 };
 
 #ifdef CONFIG_GENERIC_HARDIRQS
-static struct irq_2_iommu *get_one_free_irq_2_iommu(int cpu)
+static struct irq_2_iommu *get_one_free_irq_2_iommu(int node)
 {
 	struct irq_2_iommu *iommu;
-	int node;
-
-	node = cpu_to_node(cpu);
 
 	iommu = kzalloc_node(sizeof(*iommu), GFP_ATOMIC, node);
-	printk(KERN_DEBUG "alloc irq_2_iommu on cpu %d node %d\n", cpu, node);
+	printk(KERN_DEBUG "alloc irq_2_iommu on node %d\n", node);
 
 	return iommu;
 }
@@ -48,7 +45,7 @@ static struct irq_2_iommu *irq_2_iommu(u
 	return desc->irq_2_iommu;
 }
 
-static struct irq_2_iommu *irq_2_iommu_alloc_cpu(unsigned int irq, int cpu)
+static struct irq_2_iommu *irq_2_iommu_alloc_node(unsigned int irq, int node)
 {
 	struct irq_desc *desc;
 	struct irq_2_iommu *irq_iommu;
@@ -56,7 +53,7 @@ static struct irq_2_iommu *irq_2_iommu_a
 	/*
 	 * alloc irq desc if not allocated already.
 	 */
-	desc = irq_to_desc_alloc_cpu(irq, cpu);
+	desc = irq_to_desc_alloc_node(irq, node);
 	if (!desc) {
 		printk(KERN_INFO "can not get irq_desc for %d\n", irq);
 		return NULL;
@@ -65,14 +62,14 @@ static struct irq_2_iommu *irq_2_iommu_a
 	irq_iommu = desc->irq_2_iommu;
 
 	if (!irq_iommu)
-		desc->irq_2_iommu = get_one_free_irq_2_iommu(cpu);
+		desc->irq_2_iommu = get_one_free_irq_2_iommu(node);
 
 	return desc->irq_2_iommu;
 }
 
 static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
 {
-	return irq_2_iommu_alloc_cpu(irq, boot_cpu_id);
+	return irq_2_iommu_alloc_node(irq, cpu_to_node(boot_cpu_id));
 }
 
 #else /* !CONFIG_SPARSE_IRQ */
Index: linux-2.6/drivers/xen/events.c
===================================================================
--- linux-2.6.orig/drivers/xen/events.c
+++ linux-2.6/drivers/xen/events.c
@@ -341,7 +341,7 @@ static int find_unbound_irq(void)
 	if (irq == nr_irqs)
 		panic("No available IRQ to bind to: increase nr_irqs!\n");
 
-	desc = irq_to_desc_alloc_cpu(irq, 0);
+	desc = irq_to_desc_alloc_node(irq, 0);
 	if (WARN_ON(desc == NULL))
 		return -1;
 
Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -580,6 +580,6 @@ struct irq_desc;
 extern int early_irq_init(void);
 extern int arch_probe_nr_irqs(void);
 extern int arch_early_irq_init(void);
-extern int arch_init_chip_data(struct irq_desc *desc, int cpu);
+extern int arch_init_chip_data(struct irq_desc *desc, int node);
 
 #endif
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -187,7 +187,7 @@ struct irq_desc {
 	spinlock_t		lock;
 #ifdef CONFIG_SMP
 	cpumask_var_t		affinity;
-	unsigned int		cpu;
+	unsigned int		node;
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	cpumask_var_t		pending_mask;
 #endif
@@ -208,7 +208,7 @@ extern void arch_free_chip_data(struct i
 extern struct irq_desc irq_desc[NR_IRQS];
 #endif /* CONFIG_SPARSE_IRQ */
 
-extern struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu);
+extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node);
 
 /*
  * Migration helpers for obsolete names, they will go away:
@@ -420,12 +420,10 @@ extern int set_irq_msi(unsigned int irq,
  * Allocates affinity and pending_mask cpumask if required.
  * Returns true if successful (or not required).
  */
-static inline bool alloc_desc_masks(struct irq_desc *desc, int cpu,
+static inline bool alloc_desc_masks(struct irq_desc *desc, int node,
 								bool boot)
 {
 #ifdef CONFIG_CPUMASK_OFFSTACK
-	int node;
-
 	if (boot) {
 		alloc_bootmem_cpumask_var(&desc->affinity);
 
@@ -435,8 +433,6 @@ static inline bool alloc_desc_masks(stru
 		return true;
 	}
 
-	node = cpu_to_node(cpu);
-
 	if (!alloc_cpumask_var_node(&desc->affinity, GFP_ATOMIC, node))
 		return false;
 
@@ -492,7 +488,7 @@ static inline void free_desc_masks(struc
 
 #else /* !CONFIG_SMP */
 
-static inline bool alloc_desc_masks(struct irq_desc *desc, int cpu,
+static inline bool alloc_desc_masks(struct irq_desc *desc, int node,
 								bool boot)
 {
 	return true;
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -83,12 +83,10 @@ static struct irq_desc irq_desc_init = {
 	.lock       = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
 };
 
-void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
+void init_kstat_irqs(struct irq_desc *desc, int node, int nr)
 {
-	int node;
 	void *ptr;
 
-	node = cpu_to_node(cpu);
 	ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs), GFP_ATOMIC, node);
 
 	/*
@@ -96,33 +94,32 @@ void init_kstat_irqs(struct irq_desc *de
 	 * init_copy_kstat_irqs() could still use old one
 	 */
 	if (ptr) {
-		printk(KERN_DEBUG "  alloc kstat_irqs on cpu %d node %d\n",
-			 cpu, node);
+		printk(KERN_DEBUG "  alloc kstat_irqs on node %d\n", node);
 		desc->kstat_irqs = ptr;
 	}
 }
 
-static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
+static void init_one_irq_desc(int irq, struct irq_desc *desc, int node)
 {
 	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
 
 	spin_lock_init(&desc->lock);
 	desc->irq = irq;
 #ifdef CONFIG_SMP
-	desc->cpu = cpu;
+	desc->node = node;
 #endif
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
-	init_kstat_irqs(desc, cpu, nr_cpu_ids);
+	init_kstat_irqs(desc, node, nr_cpu_ids);
 	if (!desc->kstat_irqs) {
 		printk(KERN_ERR "can not alloc kstat_irqs\n");
 		BUG_ON(1);
 	}
-	if (!alloc_desc_masks(desc, cpu, false)) {
+	if (!alloc_desc_masks(desc, node, false)) {
 		printk(KERN_ERR "can not alloc irq_desc cpumasks\n");
 		BUG_ON(1);
 	}
 	init_desc_masks(desc);
-	arch_init_chip_data(desc, cpu);
+	arch_init_chip_data(desc, node);
 }
 
 /*
@@ -191,11 +188,10 @@ struct irq_desc *irq_to_desc(unsigned in
 	return NULL;
 }
 
-struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
+struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node)
 {
 	struct irq_desc *desc;
 	unsigned long flags;
-	int node;
 
 	if (irq >= nr_irqs) {
 		WARN(1, "irq (%d) >= nr_irqs (%d) in irq_to_desc_alloc\n",
@@ -214,15 +210,13 @@ struct irq_desc *irq_to_desc_alloc_cpu(u
 	if (desc)
 		goto out_unlock;
 
-	node = cpu_to_node(cpu);
 	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
-	printk(KERN_DEBUG "  alloc irq_desc for %d on cpu %d node %d\n",
-		 irq, cpu, node);
+	printk(KERN_DEBUG "  alloc irq_desc for %d on node %d\n", irq, node);
 	if (!desc) {
 		printk(KERN_ERR "can not alloc irq_desc\n");
 		BUG_ON(1);
 	}
-	init_one_irq_desc(irq, desc, cpu);
+	init_one_irq_desc(irq, desc, node);
 
 	irq_desc_ptrs[irq] = desc;
 
@@ -272,7 +266,7 @@ struct irq_desc *irq_to_desc(unsigned in
 	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
 }
 
-struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
+struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node)
 {
 	return irq_to_desc(irq);
 }
Index: linux-2.6/kernel/irq/internals.h
===================================================================
--- linux-2.6.orig/kernel/irq/internals.h
+++ linux-2.6/kernel/irq/internals.h
@@ -16,7 +16,7 @@ extern void __disable_irq(struct irq_des
 extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
 
 extern struct lock_class_key irq_desc_lock_class;
-extern void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr);
+extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 extern void clear_kstat_irqs(struct irq_desc *desc);
 extern spinlock_t sparse_irq_lock;
 
Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c
+++ linux-2.6/kernel/softirq.c
@@ -836,7 +836,7 @@ int __init __weak arch_early_irq_init(vo
 	return 0;
 }
 
-int __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
+int __weak arch_init_chip_data(struct irq_desc *desc, int node)
 {
 	return 0;
 }
