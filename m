Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbZD1BCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbZD1BCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 21:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZD1BCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 21:02:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:56766 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbZD1BC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 21:02:29 -0400
Message-ID: <49F65536.2020300@kernel.org>
Date: Mon, 27 Apr 2009 18:00:38 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/9] x86/irq: change irq_desc_alloc to take node instead cpu
 -v2
References: <49E68C41.4020801@kernel.org> <20090416090315.GF9813@elte.hu> <49E802CE.5030406@kernel.org> <49E803D7.7060307@kernel.org>
In-Reply-To: <49E803D7.7060307@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: prepare to make irq_desc_alloc to numa aware

so could make irq_desc_alloc use node pass down

v2: keep move_irq_desc related

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |   58 ++++++++++++++++++-----------------------
 arch/x86/lguest/boot.c         |    2 -
 drivers/pci/intr_remapping.c   |   15 ++++------
 drivers/xen/events.c           |    2 -
 include/linux/interrupt.h      |    2 -
 include/linux/irq.h            |   16 ++++-------
 kernel/irq/handle.c            |   28 +++++++------------
 kernel/irq/internals.h         |    2 -
 kernel/irq/numa_migrate.c      |   36 ++++++++-----------------
 kernel/softirq.c               |    2 -
 10 files changed, 66 insertions(+), 97 deletions(-)

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
@@ -254,7 +248,7 @@ int arch_init_chip_data(struct irq_desc
 
 /* for move_irq_desc */
 static void
-init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int cpu)
+init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int node)
 {
 	struct irq_pin_list *old_entry, *head, *tail, *entry;
 
@@ -263,7 +257,7 @@ init_copy_irq_2_pin(struct irq_cfg *old_
 	if (!old_entry)
 		return;
 
-	entry = get_one_free_irq_2_pin(cpu);
+	entry = get_one_free_irq_2_pin(node);
 	if (!entry)
 		return;
 
@@ -273,7 +267,7 @@ init_copy_irq_2_pin(struct irq_cfg *old_
 	tail		= entry;
 	old_entry	= old_entry->next;
 	while (old_entry) {
-		entry = get_one_free_irq_2_pin(cpu);
+		entry = get_one_free_irq_2_pin(node);
 		if (!entry) {
 			entry = head;
 			while (entry) {
@@ -313,12 +307,12 @@ static void free_irq_2_pin(struct irq_cf
 }
 
 void arch_init_copy_chip_data(struct irq_desc *old_desc,
-				 struct irq_desc *desc, int cpu)
+				 struct irq_desc *desc, int node)
 {
 	struct irq_cfg *cfg;
 	struct irq_cfg *old_cfg;
 
-	cfg = get_one_free_irq_cfg(cpu);
+	cfg = get_one_free_irq_cfg(node);
 
 	if (!cfg)
 		return;
@@ -329,7 +323,7 @@ void arch_init_copy_chip_data(struct irq
 
 	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
 
-	init_copy_irq_2_pin(old_cfg, cfg, cpu);
+	init_copy_irq_2_pin(old_cfg, cfg, node);
 }
 
 static void free_irq_cfg(struct irq_cfg *old_cfg)
@@ -501,13 +495,13 @@ static void ioapic_mask_entry(int apic,
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
@@ -527,7 +521,7 @@ static void add_pin_to_irq_cpu(struct ir
 		entry = entry->next;
 	}
 
-	entry->next = get_one_free_irq_2_pin(cpu);
+	entry->next = get_one_free_irq_2_pin(node);
 	entry = entry->next;
 	entry->apic = apic;
 	entry->pin = pin;
@@ -536,7 +530,7 @@ static void add_pin_to_irq_cpu(struct ir
 /*
  * Reroute an IRQ to a different pin.
  */
-static void __init replace_pin_at_irq_cpu(struct irq_cfg *cfg, int cpu,
+static void __init replace_pin_at_irq_node(struct irq_cfg *cfg, int node,
 				      int oldapic, int oldpin,
 				      int newapic, int newpin)
 {
@@ -556,7 +550,7 @@ static void __init replace_pin_at_irq_cp
 
 	/* why? call replace before add? */
 	if (!replaced)
-		add_pin_to_irq_cpu(cfg, cpu, newapic, newpin);
+		add_pin_to_irq_node(cfg, node, newapic, newpin);
 }
 
 static inline void io_apic_modify_irq(struct irq_cfg *cfg,
@@ -1482,7 +1476,7 @@ static void __init setup_IO_APIC_irqs(vo
 	int notcon = 0;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
-	int cpu = boot_cpu_id;
+	int node = cpu_to_node(boot_cpu_id);
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
@@ -1517,13 +1511,13 @@ static void __init setup_IO_APIC_irqs(vo
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
@@ -2821,7 +2815,7 @@ static inline void __init check_timer(vo
 {
 	struct irq_desc *desc = irq_to_desc(0);
 	struct irq_cfg *cfg = desc->chip_data;
-	int cpu = boot_cpu_id;
+	int node = cpu_to_node(boot_cpu_id);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
 	int no_pin1 = 0;
@@ -2887,7 +2881,7 @@ static inline void __init check_timer(vo
 		 * Ok, does IRQ0 through the IOAPIC work?
 		 */
 		if (no_pin1) {
-			add_pin_to_irq_cpu(cfg, cpu, apic1, pin1);
+			add_pin_to_irq_node(cfg, node, apic1, pin1);
 			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
 		} else {
 			/* for edge trigger, setup_IO_APIC_irq already
@@ -2924,7 +2918,7 @@ static inline void __init check_timer(vo
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
-		replace_pin_at_irq_cpu(cfg, cpu, apic1, pin1, apic2, pin2);
+		replace_pin_at_irq_node(cfg, node, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
@@ -3143,7 +3137,7 @@ unsigned int create_irq_nr(unsigned int
 	unsigned int new;
 	unsigned long flags;
 	struct irq_cfg *cfg_new = NULL;
-	int cpu = boot_cpu_id;
+	int node = cpu_to_node(boot_cpu_id);
 	struct irq_desc *desc_new = NULL;
 
 	irq = 0;
@@ -3152,7 +3146,7 @@ unsigned int create_irq_nr(unsigned int
 
 	spin_lock_irqsave(&vector_lock, flags);
 	for (new = irq_want; new < nr_irqs; new++) {
-		desc_new = irq_to_desc_alloc_cpu(new, cpu);
+		desc_new = irq_to_desc_alloc_node(new, node);
 		if (!desc_new) {
 			printk(KERN_INFO "can not get irq_desc for %d\n", new);
 			continue;
@@ -3926,7 +3920,7 @@ int io_apic_set_pci_routing (int ioapic,
 {
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
-	int cpu = boot_cpu_id;
+	int node = cpu_to_node(boot_cpu_id);
 
 	if (!IO_APIC_IRQ(irq)) {
 		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
@@ -3934,7 +3928,7 @@ int io_apic_set_pci_routing (int ioapic,
 		return -EINVAL;
 	}
 
-	desc = irq_to_desc_alloc_cpu(irq, cpu);
+	desc = irq_to_desc_alloc_node(irq, node);
 	if (!desc) {
 		printk(KERN_INFO "can not get irq_desc %d\n", irq);
 		return 0;
@@ -3945,7 +3939,7 @@ int io_apic_set_pci_routing (int ioapic,
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
@@ -642,7 +642,7 @@ static void __init lguest_init_IRQ(void)
 
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
@@ -31,15 +31,12 @@ struct irq_2_iommu {
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
@@ -56,7 +53,7 @@ static struct irq_2_iommu *irq_2_iommu(u
 	return desc->irq_2_iommu;
 }
 
-static struct irq_2_iommu *irq_2_iommu_alloc_cpu(unsigned int irq, int cpu)
+static struct irq_2_iommu *irq_2_iommu_alloc_node(unsigned int irq, int node)
 {
 	struct irq_desc *desc;
 	struct irq_2_iommu *irq_iommu;
@@ -64,7 +61,7 @@ static struct irq_2_iommu *irq_2_iommu_a
 	/*
 	 * alloc irq desc if not allocated already.
 	 */
-	desc = irq_to_desc_alloc_cpu(irq, cpu);
+	desc = irq_to_desc_alloc_node(irq, node);
 	if (!desc) {
 		printk(KERN_INFO "can not get irq_desc for %d\n", irq);
 		return NULL;
@@ -73,14 +70,14 @@ static struct irq_2_iommu *irq_2_iommu_a
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
@@ -201,16 +201,16 @@ struct irq_desc {
 } ____cacheline_internodealigned_in_smp;
 
 extern void arch_init_copy_chip_data(struct irq_desc *old_desc,
-					struct irq_desc *desc, int cpu);
+					struct irq_desc *desc, int node);
 extern void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc);
 
 #ifndef CONFIG_SPARSE_IRQ
 extern struct irq_desc irq_desc[NR_IRQS];
 #else /* CONFIG_SPARSE_IRQ */
-extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int cpu);
+extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int node);
 #endif /* CONFIG_SPARSE_IRQ */
 
-extern struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu);
+extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node);
 
 /*
  * Migration helpers for obsolete names, they will go away:
@@ -422,12 +422,10 @@ extern int set_irq_msi(unsigned int irq,
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
 
@@ -437,8 +435,6 @@ static inline bool alloc_desc_masks(stru
 		return true;
 	}
 
-	node = cpu_to_node(cpu);
-
 	if (!alloc_cpumask_var_node(&desc->affinity, GFP_ATOMIC, node))
 		return false;
 
@@ -494,7 +490,7 @@ static inline void free_desc_masks(struc
 
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
Index: linux-2.6/kernel/irq/numa_migrate.c
===================================================================
--- linux-2.6.orig/kernel/irq/numa_migrate.c
+++ linux-2.6/kernel/irq/numa_migrate.c
@@ -15,9 +15,9 @@
 
 static void init_copy_kstat_irqs(struct irq_desc *old_desc,
 				 struct irq_desc *desc,
-				 int cpu, int nr)
+				 int node, int nr)
 {
-	init_kstat_irqs(desc, cpu, nr);
+	init_kstat_irqs(desc, node, nr);
 
 	if (desc->kstat_irqs != old_desc->kstat_irqs)
 		memcpy(desc->kstat_irqs, old_desc->kstat_irqs,
@@ -34,20 +34,20 @@ static void free_kstat_irqs(struct irq_d
 }
 
 static bool init_copy_one_irq_desc(int irq, struct irq_desc *old_desc,
-		 struct irq_desc *desc, int cpu)
+		 struct irq_desc *desc, int node)
 {
 	memcpy(desc, old_desc, sizeof(struct irq_desc));
-	if (!alloc_desc_masks(desc, cpu, false)) {
+	if (!alloc_desc_masks(desc, node, false)) {
 		printk(KERN_ERR "irq %d: can not get new irq_desc cpumask "
 				"for migration.\n", irq);
 		return false;
 	}
 	spin_lock_init(&desc->lock);
-	desc->cpu = cpu;
+	desc->node = node;
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
-	init_copy_kstat_irqs(old_desc, desc, cpu, nr_cpu_ids);
+	init_copy_kstat_irqs(old_desc, desc, node, nr_cpu_ids);
 	init_copy_desc_masks(old_desc, desc);
-	arch_init_copy_chip_data(old_desc, desc, cpu);
+	arch_init_copy_chip_data(old_desc, desc, node);
 	return true;
 }
 
@@ -59,12 +59,11 @@ static void free_one_irq_desc(struct irq
 }
 
 static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
-						int cpu)
+						int node)
 {
 	struct irq_desc *desc;
 	unsigned int irq;
 	unsigned long flags;
-	int node;
 
 	irq = old_desc->irq;
 
@@ -76,7 +75,6 @@ static struct irq_desc *__real_move_irq_
 	if (desc && old_desc != desc)
 		goto out_unlock;
 
-	node = cpu_to_node(cpu);
 	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
 	if (!desc) {
 		printk(KERN_ERR "irq %d: can not get new irq_desc "
@@ -85,7 +83,7 @@ static struct irq_desc *__real_move_irq_
 		desc = old_desc;
 		goto out_unlock;
 	}
-	if (!init_copy_one_irq_desc(irq, old_desc, desc, cpu)) {
+	if (!init_copy_one_irq_desc(irq, old_desc, desc, node)) {
 		/* still use old one */
 		kfree(desc);
 		desc = old_desc;
@@ -107,24 +105,14 @@ out_unlock:
 	return desc;
 }
 
-struct irq_desc *move_irq_desc(struct irq_desc *desc, int cpu)
+struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
 {
-	int old_cpu;
-	int node, old_node;
-
 	/* those all static, do move them */
 	if (desc->irq < NR_IRQS_LEGACY)
 		return desc;
 
-	old_cpu = desc->cpu;
-	if (old_cpu != cpu) {
-		node = cpu_to_node(cpu);
-		old_node = cpu_to_node(old_cpu);
-		if (old_node != node)
-			desc = __real_move_irq_desc(desc, cpu);
-		else
-			desc->cpu = cpu;
-	}
+	if (desc->node != node)
+		desc = __real_move_irq_desc(desc, node);
 
 	return desc;
 }
