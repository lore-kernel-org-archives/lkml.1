Return-Path: <linux-kernel-owner+w=401wt.eu-S1763482AbZEARLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763482AbZEARLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764141AbZEARKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:10:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:43340 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764143AbZEARKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:10:33 -0400
Date: Fri, 1 May 2009 17:07:14 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       jeremy@goop.org, akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       jeremy@goop.org, akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49F65536.2020300@kernel.org>
References: <49F65536.2020300@kernel.org>
Subject: [tip:irq/numa] x86/irq: change irq_desc_alloc() to take node instead of cpu
Message-ID: <tip-85ac16d033370caf6f48d743c8dc8103700f5cc5@git.kernel.org>
Git-Commit-ID: 85ac16d033370caf6f48d743c8dc8103700f5cc5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 01 May 2009 17:07:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85ac16d033370caf6f48d743c8dc8103700f5cc5
Gitweb:     http://git.kernel.org/tip/85ac16d033370caf6f48d743c8dc8103700f5cc5
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 27 Apr 2009 18:00:38 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 28 Apr 2009 12:21:17 +0200

x86/irq: change irq_desc_alloc() to take node instead of cpu

This simplifies the node awareness of the code. All our allocators
only deal with a NUMA node ID locality not with CPU ids anyway - so
there's no need to maintain (and transform) a CPU id all across the
IRq layer.

v2: keep move_irq_desc related

[ Impact: cleanup, prepare IRQ code to be NUMA-aware ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
LKML-Reference: <49F65536.2020300@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |   58 ++++++++++++++++++----------------------
 arch/x86/lguest/boot.c         |    2 +-
 drivers/pci/intr_remapping.c   |   15 ++++------
 drivers/xen/events.c           |    2 +-
 include/linux/interrupt.h      |    2 +-
 include/linux/irq.h            |   16 ++++-------
 kernel/irq/handle.c            |   28 +++++++-----------
 kernel/irq/internals.h         |    2 +-
 kernel/irq/numa_migrate.c      |   36 ++++++++----------------
 kernel/softirq.c               |    2 +-
 10 files changed, 66 insertions(+), 97 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 5c7630b..560b887 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -129,12 +129,9 @@ struct irq_pin_list {
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
 
@@ -209,12 +206,9 @@ static struct irq_cfg *irq_cfg(unsigned int irq)
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
@@ -235,13 +229,13 @@ static struct irq_cfg *get_one_free_irq_cfg(int cpu)
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
@@ -253,7 +247,7 @@ int arch_init_chip_data(struct irq_desc *desc, int cpu)
 
 /* for move_irq_desc */
 static void
-init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int cpu)
+init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int node)
 {
 	struct irq_pin_list *old_entry, *head, *tail, *entry;
 
@@ -262,7 +256,7 @@ init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int cpu)
 	if (!old_entry)
 		return;
 
-	entry = get_one_free_irq_2_pin(cpu);
+	entry = get_one_free_irq_2_pin(node);
 	if (!entry)
 		return;
 
@@ -272,7 +266,7 @@ init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int cpu)
 	tail		= entry;
 	old_entry	= old_entry->next;
 	while (old_entry) {
-		entry = get_one_free_irq_2_pin(cpu);
+		entry = get_one_free_irq_2_pin(node);
 		if (!entry) {
 			entry = head;
 			while (entry) {
@@ -312,12 +306,12 @@ static void free_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg)
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
@@ -328,7 +322,7 @@ void arch_init_copy_chip_data(struct irq_desc *old_desc,
 
 	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
 
-	init_copy_irq_2_pin(old_cfg, cfg, cpu);
+	init_copy_irq_2_pin(old_cfg, cfg, node);
 }
 
 static void free_irq_cfg(struct irq_cfg *old_cfg)
@@ -615,13 +609,13 @@ set_ioapic_affinity_irq(unsigned int irq, const struct cpumask *mask)
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
@@ -641,7 +635,7 @@ static void add_pin_to_irq_cpu(struct irq_cfg *cfg, int cpu, int apic, int pin)
 		entry = entry->next;
 	}
 
-	entry->next = get_one_free_irq_2_pin(cpu);
+	entry->next = get_one_free_irq_2_pin(node);
 	entry = entry->next;
 	entry->apic = apic;
 	entry->pin = pin;
@@ -650,7 +644,7 @@ static void add_pin_to_irq_cpu(struct irq_cfg *cfg, int cpu, int apic, int pin)
 /*
  * Reroute an IRQ to a different pin.
  */
-static void __init replace_pin_at_irq_cpu(struct irq_cfg *cfg, int cpu,
+static void __init replace_pin_at_irq_node(struct irq_cfg *cfg, int node,
 				      int oldapic, int oldpin,
 				      int newapic, int newpin)
 {
@@ -670,7 +664,7 @@ static void __init replace_pin_at_irq_cpu(struct irq_cfg *cfg, int cpu,
 
 	/* why? call replace before add? */
 	if (!replaced)
-		add_pin_to_irq_cpu(cfg, cpu, newapic, newpin);
+		add_pin_to_irq_node(cfg, node, newapic, newpin);
 }
 
 static inline void io_apic_modify_irq(struct irq_cfg *cfg,
@@ -1612,7 +1606,7 @@ static void __init setup_IO_APIC_irqs(void)
 	int notcon = 0;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
-	int cpu = boot_cpu_id;
+	int node = cpu_to_node(boot_cpu_id);
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
@@ -1647,13 +1641,13 @@ static void __init setup_IO_APIC_irqs(void)
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
@@ -2863,7 +2857,7 @@ static inline void __init check_timer(void)
 {
 	struct irq_desc *desc = irq_to_desc(0);
 	struct irq_cfg *cfg = desc->chip_data;
-	int cpu = boot_cpu_id;
+	int node = cpu_to_node(boot_cpu_id);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
 	int no_pin1 = 0;
@@ -2929,7 +2923,7 @@ static inline void __init check_timer(void)
 		 * Ok, does IRQ0 through the IOAPIC work?
 		 */
 		if (no_pin1) {
-			add_pin_to_irq_cpu(cfg, cpu, apic1, pin1);
+			add_pin_to_irq_node(cfg, node, apic1, pin1);
 			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
 		} else {
 			/* for edge trigger, setup_IO_APIC_irq already
@@ -2966,7 +2960,7 @@ static inline void __init check_timer(void)
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
-		replace_pin_at_irq_cpu(cfg, cpu, apic1, pin1, apic2, pin2);
+		replace_pin_at_irq_node(cfg, node, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
@@ -3185,7 +3179,7 @@ unsigned int create_irq_nr(unsigned int irq_want)
 	unsigned int new;
 	unsigned long flags;
 	struct irq_cfg *cfg_new = NULL;
-	int cpu = boot_cpu_id;
+	int node = cpu_to_node(boot_cpu_id);
 	struct irq_desc *desc_new = NULL;
 
 	irq = 0;
@@ -3194,7 +3188,7 @@ unsigned int create_irq_nr(unsigned int irq_want)
 
 	spin_lock_irqsave(&vector_lock, flags);
 	for (new = irq_want; new < nr_irqs; new++) {
-		desc_new = irq_to_desc_alloc_cpu(new, cpu);
+		desc_new = irq_to_desc_alloc_node(new, node);
 		if (!desc_new) {
 			printk(KERN_INFO "can not get irq_desc for %d\n", new);
 			continue;
@@ -3968,7 +3962,7 @@ int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int p
 {
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
-	int cpu = boot_cpu_id;
+	int node = cpu_to_node(boot_cpu_id);
 
 	if (!IO_APIC_IRQ(irq)) {
 		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
@@ -3976,7 +3970,7 @@ int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int p
 		return -EINVAL;
 	}
 
-	desc = irq_to_desc_alloc_cpu(irq, cpu);
+	desc = irq_to_desc_alloc_node(irq, node);
 	if (!desc) {
 		printk(KERN_INFO "can not get irq_desc %d\n", irq);
 		return 0;
@@ -3987,7 +3981,7 @@ int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int p
 	 */
 	if (irq >= NR_IRQS_LEGACY) {
 		cfg = desc->chip_data;
-		add_pin_to_irq_cpu(cfg, cpu, ioapic, pin);
+		add_pin_to_irq_node(cfg, node, ioapic, pin);
 	}
 
 	setup_IO_APIC_irq(ioapic, pin, irq, desc, triggering, polarity);
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index ca7ec44..45acbcf 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -636,7 +636,7 @@ static void __init lguest_init_IRQ(void)
 
 void lguest_setup_irq(unsigned int irq)
 {
-	irq_to_desc_alloc_cpu(irq, 0);
+	irq_to_desc_alloc_node(irq, 0);
 	set_irq_chip_and_handler_name(irq, &lguest_irq_controller,
 				      handle_level_irq, "level");
 }
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index f5e0ea7..9eff36a 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
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
@@ -48,7 +45,7 @@ static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
 	return desc->irq_2_iommu;
 }
 
-static struct irq_2_iommu *irq_2_iommu_alloc_cpu(unsigned int irq, int cpu)
+static struct irq_2_iommu *irq_2_iommu_alloc_node(unsigned int irq, int node)
 {
 	struct irq_desc *desc;
 	struct irq_2_iommu *irq_iommu;
@@ -56,7 +53,7 @@ static struct irq_2_iommu *irq_2_iommu_alloc_cpu(unsigned int irq, int cpu)
 	/*
 	 * alloc irq desc if not allocated already.
 	 */
-	desc = irq_to_desc_alloc_cpu(irq, cpu);
+	desc = irq_to_desc_alloc_node(irq, node);
 	if (!desc) {
 		printk(KERN_INFO "can not get irq_desc for %d\n", irq);
 		return NULL;
@@ -65,14 +62,14 @@ static struct irq_2_iommu *irq_2_iommu_alloc_cpu(unsigned int irq, int cpu)
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
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 3338988..be437c2 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -335,7 +335,7 @@ static int find_unbound_irq(void)
 	if (irq == nr_irqs)
 		panic("No available IRQ to bind to: increase nr_irqs!\n");
 
-	desc = irq_to_desc_alloc_cpu(irq, 0);
+	desc = irq_to_desc_alloc_node(irq, 0);
 	if (WARN_ON(desc == NULL))
 		return -1;
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 91bb76f..ff374ce 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -566,6 +566,6 @@ struct irq_desc;
 extern int early_irq_init(void);
 extern int arch_probe_nr_irqs(void);
 extern int arch_early_irq_init(void);
-extern int arch_init_chip_data(struct irq_desc *desc, int cpu);
+extern int arch_init_chip_data(struct irq_desc *desc, int node);
 
 #endif
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 8e4c18b..a09baf8 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
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
@@ -422,12 +422,10 @@ extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
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
 
@@ -437,8 +435,6 @@ static inline bool alloc_desc_masks(struct irq_desc *desc, int cpu,
 		return true;
 	}
 
-	node = cpu_to_node(cpu);
-
 	if (!alloc_cpumask_var_node(&desc->affinity, GFP_ATOMIC, node))
 		return false;
 
@@ -494,7 +490,7 @@ static inline void free_desc_masks(struct irq_desc *old_desc,
 
 #else /* !CONFIG_SMP */
 
-static inline bool alloc_desc_masks(struct irq_desc *desc, int cpu,
+static inline bool alloc_desc_masks(struct irq_desc *desc, int node,
 								bool boot)
 {
 	return true;
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 3e0cbc4..a6368db 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -81,12 +81,10 @@ static struct irq_desc irq_desc_init = {
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
@@ -94,33 +92,32 @@ void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
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
@@ -189,11 +186,10 @@ struct irq_desc *irq_to_desc(unsigned int irq)
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
@@ -212,15 +208,13 @@ struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
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
 
@@ -270,7 +264,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
 }
 
-struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
+struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node)
 {
 	return irq_to_desc(irq);
 }
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index de5f412..7346825 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -16,7 +16,7 @@ extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
 extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
 
 extern struct lock_class_key irq_desc_lock_class;
-extern void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr);
+extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 extern void clear_kstat_irqs(struct irq_desc *desc);
 extern spinlock_t sparse_irq_lock;
 
diff --git a/kernel/irq/numa_migrate.c b/kernel/irq/numa_migrate.c
index ce72bc3..2f69bee 100644
--- a/kernel/irq/numa_migrate.c
+++ b/kernel/irq/numa_migrate.c
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
@@ -34,20 +34,20 @@ static void free_kstat_irqs(struct irq_desc *old_desc, struct irq_desc *desc)
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
 
@@ -59,12 +59,11 @@ static void free_one_irq_desc(struct irq_desc *old_desc, struct irq_desc *desc)
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
 
@@ -76,7 +75,6 @@ static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
 	if (desc && old_desc != desc)
 		goto out_unlock;
 
-	node = cpu_to_node(cpu);
 	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
 	if (!desc) {
 		printk(KERN_ERR "irq %d: can not get new irq_desc "
@@ -85,7 +83,7 @@ static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
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
diff --git a/kernel/softirq.c b/kernel/softirq.c
index b525dd3..f674f33 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -828,7 +828,7 @@ int __init __weak arch_early_irq_init(void)
 	return 0;
 }
 
-int __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
+int __weak arch_init_chip_data(struct irq_desc *desc, int node)
 {
 	return 0;
 }
