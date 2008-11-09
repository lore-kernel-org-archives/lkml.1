Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbYKIHHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbYKIHHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 02:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYKIHHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 02:07:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:39798 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbYKIHHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 02:07:13 -0500
Message-ID: <49168BD3.5010204@kernel.org>
Date: Sat, 08 Nov 2008 23:05:55 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] sparse_irq aka dyn_irq
References: <20081023143721.GA25783@elte.hu> <49012399.4010100@kernel.org> <20081027164135.GD19476@elte.hu> <4912B2FE.7030804@kernel.org> <20081106101715.GA4022@elte.hu> <4913B45C.1000009@kernel.org> <20081107081249.GB4435@elte.hu> <4913F9AA.80500@kernel.org> <20081107084240.GG4435@elte.hu> <491434FB.2050904@kernel.org> <20081107124957.GA21709@elte.hu>
In-Reply-To: <20081107124957.GA21709@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


impact: new feature sparseirq

for sparse_irq, irq_desc, and irq_cfg is not using list_head to chain up
also not add per_cpu_dyn_array... no user now

add some kind of hash table as Ingo suggesting.
remove dyna_array, and enable sparse_irq by default, use kzalloc_node to get it
use desc->chip_data for x86 to store irq_cfg
make irq_desc to go with affinity aka irq_desc moving etc
only call move_irq_desc in irq_complete_move() --- but it seems not trigger that moving.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/Kconfig                   |    4 
 arch/x86/include/asm/io_apic.h     |    2 
 arch/x86/include/asm/irq_vectors.h |    2 
 arch/x86/kernel/io_apic.c          |  384 ++++++++++++++++++++++++-------------
 arch/x86/kernel/irq.c              |   19 -
 arch/x86/kernel/irq_32.c           |    2 
 arch/x86/kernel/irq_64.c           |    2 
 arch/x86/kernel/irqinit_32.c       |    3 
 arch/x86/kernel/irqinit_64.c       |    3 
 arch/x86/mm/init_32.c              |    3 
 drivers/char/random.c              |   31 ++
 drivers/pci/htirq.c                |   18 +
 drivers/pci/intr_remapping.c       |   65 ++++++
 drivers/xen/events.c               |    9 
 fs/proc/interrupts.c               |   13 +
 fs/proc/stat.c                     |   17 +
 include/linux/interrupt.h          |    2 
 include/linux/irq.h                |   60 +++++
 include/linux/irqnr.h              |   15 -
 include/linux/kernel_stat.h        |   14 +
 init/main.c                        |    2 
 kernel/irq/autoprobe.c             |   10 
 kernel/irq/chip.c                  |    4 
 kernel/irq/handle.c                |  338 +++++++++++++++++++++++++++++++-
 kernel/irq/proc.c                  |    3 
 kernel/irq/spurious.c              |    4 
 26 files changed, 839 insertions(+), 190 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -236,6 +236,10 @@ config X86_HAS_BOOT_CPU_ID
 	def_bool y
 	depends on X86_VOYAGER
 
+config HAVE_SPARSE_IRQ
+	bool
+	default y
+
 config X86_FIND_SMP_CONFIG
 	def_bool y
 	depends on X86_MPPARSE || X86_VOYAGER
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -108,8 +108,8 @@ static int __init parse_noapic(char *str
 early_param("noapic", parse_noapic);
 
 struct irq_pin_list;
+
 struct irq_cfg {
-	unsigned int irq;
 	struct irq_pin_list *irq_2_pin;
 	cpumask_t domain;
 	cpumask_t old_domain;
@@ -119,44 +119,117 @@ struct irq_cfg {
 };
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
-static struct irq_cfg irq_cfgx[NR_IRQS] = {
-	[0]  = { .irq =  0, .domain = CPU_MASK_ALL, .vector = IRQ0_VECTOR,  },
-	[1]  = { .irq =  1, .domain = CPU_MASK_ALL, .vector = IRQ1_VECTOR,  },
-	[2]  = { .irq =  2, .domain = CPU_MASK_ALL, .vector = IRQ2_VECTOR,  },
-	[3]  = { .irq =  3, .domain = CPU_MASK_ALL, .vector = IRQ3_VECTOR,  },
-	[4]  = { .irq =  4, .domain = CPU_MASK_ALL, .vector = IRQ4_VECTOR,  },
-	[5]  = { .irq =  5, .domain = CPU_MASK_ALL, .vector = IRQ5_VECTOR,  },
-	[6]  = { .irq =  6, .domain = CPU_MASK_ALL, .vector = IRQ6_VECTOR,  },
-	[7]  = { .irq =  7, .domain = CPU_MASK_ALL, .vector = IRQ7_VECTOR,  },
-	[8]  = { .irq =  8, .domain = CPU_MASK_ALL, .vector = IRQ8_VECTOR,  },
-	[9]  = { .irq =  9, .domain = CPU_MASK_ALL, .vector = IRQ9_VECTOR,  },
-	[10] = { .irq = 10, .domain = CPU_MASK_ALL, .vector = IRQ10_VECTOR, },
-	[11] = { .irq = 11, .domain = CPU_MASK_ALL, .vector = IRQ11_VECTOR, },
-	[12] = { .irq = 12, .domain = CPU_MASK_ALL, .vector = IRQ12_VECTOR, },
-	[13] = { .irq = 13, .domain = CPU_MASK_ALL, .vector = IRQ13_VECTOR, },
-	[14] = { .irq = 14, .domain = CPU_MASK_ALL, .vector = IRQ14_VECTOR, },
-	[15] = { .irq = 15, .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
+static struct irq_cfg irq_cfg_legacy[] = {
+	[0]  = { .domain = CPU_MASK_ALL, .vector = IRQ0_VECTOR,  },
+	[1]  = { .domain = CPU_MASK_ALL, .vector = IRQ1_VECTOR,  },
+	[2]  = { .domain = CPU_MASK_ALL, .vector = IRQ2_VECTOR,  },
+	[3]  = { .domain = CPU_MASK_ALL, .vector = IRQ3_VECTOR,  },
+	[4]  = { .domain = CPU_MASK_ALL, .vector = IRQ4_VECTOR,  },
+	[5]  = { .domain = CPU_MASK_ALL, .vector = IRQ5_VECTOR,  },
+	[6]  = { .domain = CPU_MASK_ALL, .vector = IRQ6_VECTOR,  },
+	[7]  = { .domain = CPU_MASK_ALL, .vector = IRQ7_VECTOR,  },
+	[8]  = { .domain = CPU_MASK_ALL, .vector = IRQ8_VECTOR,  },
+	[9]  = { .domain = CPU_MASK_ALL, .vector = IRQ9_VECTOR,  },
+	[10] = { .domain = CPU_MASK_ALL, .vector = IRQ10_VECTOR, },
+	[11] = { .domain = CPU_MASK_ALL, .vector = IRQ11_VECTOR, },
+	[12] = { .domain = CPU_MASK_ALL, .vector = IRQ12_VECTOR, },
+	[13] = { .domain = CPU_MASK_ALL, .vector = IRQ13_VECTOR, },
+	[14] = { .domain = CPU_MASK_ALL, .vector = IRQ14_VECTOR, },
+	[15] = { .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
 };
 
-#define for_each_irq_cfg(irq, cfg)		\
-	for (irq = 0, cfg = irq_cfgx; irq < nr_irqs; irq++, cfg++)
+void __init arch_sparse_irq_init_work(void)
+{
+	struct irq_cfg *cfg;
+	struct irq_desc *desc;
+	int legacy_count;
+	int i;
+
+	cfg = irq_cfg_legacy;
+	legacy_count = ARRAY_SIZE(irq_cfg_legacy);
+
+	BUG_ON(legacy_count > NR_IRQS_LEGACY);
+
+	for (i = 0; i < legacy_count; i++) {
+		desc = irq_to_desc(i);
+		desc->chip_data = &cfg[i];
+	}
+}
 
 static struct irq_cfg *irq_cfg(unsigned int irq)
 {
-	return irq < nr_irqs ? irq_cfgx + irq : NULL;
+	struct irq_cfg *cfg = NULL;
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+	if (desc)
+		cfg = desc->chip_data;
+
+	return cfg;
 }
 
-static struct irq_cfg *irq_cfg_alloc(unsigned int irq)
+static struct irq_cfg *get_one_free_irq_cfg(int cpu)
 {
-	return irq_cfg(irq);
+	struct irq_cfg *cfg;
+	int node;
+
+	if (cpu < 0)
+		cpu = smp_processor_id();
+	node = cpu_to_node(cpu);
+
+	cfg = kzalloc_node(sizeof(*cfg), GFP_KERNEL, node);
+	printk(KERN_DEBUG "  alloc irq_cfg on cpu %d node %d\n", cpu, node);
+
+	return cfg;
 }
 
-/*
- * Rough estimation of how many shared IRQs there are, can be changed
- * anytime.
- */
-#define MAX_PLUS_SHARED_IRQS NR_IRQS
-#define PIN_MAP_SIZE (MAX_PLUS_SHARED_IRQS + NR_IRQS)
+static void free_irq_cfg(struct irq_cfg *cfg)
+{
+	kfree(cfg);
+}
+
+void arch_init_chip_data(struct irq_desc *desc, int cpu)
+{
+	struct irq_cfg *cfg;
+
+	cfg = desc->chip_data;
+	if (!cfg)
+		desc->chip_data = get_one_free_irq_cfg(cpu);
+}
+
+static void init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg,
+				 int cpu);
+
+void arch_init_copy_chip_data(struct irq_desc *old_desc,
+				 struct irq_desc *desc, int cpu)
+{
+	struct irq_cfg *cfg;
+	struct irq_cfg *old_cfg;
+
+	cfg = get_one_free_irq_cfg(cpu);
+	desc->chip_data = cfg;
+
+	old_cfg = old_desc->chip_data;
+
+	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
+
+	init_copy_irq_2_pin(old_cfg, cfg, cpu);
+}
+
+static void free_irq_2_pin(struct irq_cfg *cfg);
+
+void arch_free_chip_data(struct irq_desc *desc)
+{
+	struct irq_cfg *cfg;
+
+	cfg = desc->chip_data;
+	if (cfg) {
+		free_irq_2_pin(cfg);
+		if (desc->irq >= NR_IRQS_LEGACY)
+			free_irq_cfg(cfg);
+		desc->chip_data = NULL;
+	}
+}
 
 /*
  * This is performance-critical, we want to do it O(1)
@@ -170,30 +243,48 @@ struct irq_pin_list {
 	struct irq_pin_list *next;
 };
 
-static struct irq_pin_list irq_2_pin_head[PIN_MAP_SIZE];
-static struct irq_pin_list *irq_2_pin_ptr;
+static struct irq_pin_list *get_one_free_irq_2_pin(int cpu)
+{
+	struct irq_pin_list *pin;
+	int node;
+
+	if (cpu < 0)
+		cpu = smp_processor_id();
+	node = cpu_to_node(cpu);
+
+	pin = kzalloc_node(sizeof(*pin), GFP_KERNEL, node);
+	printk(KERN_DEBUG "  alloc irq_2_pin on cpu %d node %d\n", cpu, node);
+
+	return pin;
+}
+
+static void add_pin_to_irq_cpu(struct irq_cfg *cfg, int cpu, int apic, int pin);
 
-static void __init irq_2_pin_init(void)
+static void init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg,
+				 int cpu)
 {
-	struct irq_pin_list *pin = irq_2_pin_head;
-	int i;
+	struct irq_pin_list *old_entry;
 
-	for (i = 1; i < PIN_MAP_SIZE; i++)
-		pin[i-1].next = &pin[i];
+	old_entry = old_cfg->irq_2_pin;
 
-	irq_2_pin_ptr = &pin[0];
+	while (old_entry) {
+		add_pin_to_irq_cpu(cfg, cpu, old_entry->apic, old_entry->pin);
+		old_entry = old_entry->next;
+	}
 }
 
-static struct irq_pin_list *get_one_free_irq_2_pin(void)
+static void free_irq_2_pin(struct irq_cfg *cfg)
 {
-	struct irq_pin_list *pin = irq_2_pin_ptr;
+	struct irq_pin_list *entry, *next;
 
-	if (!pin)
-		panic("can not get more irq_2_pin\n");
+	entry = cfg->irq_2_pin;
 
-	irq_2_pin_ptr = pin->next;
-	pin->next = NULL;
-	return pin;
+	while (entry) {
+		next = entry->next;
+		kfree(entry);
+		entry = next;
+	}
+	cfg->irq_2_pin = NULL;
 }
 
 struct io_apic {
@@ -359,7 +450,12 @@ static void __target_IO_APIC_irq(unsigne
 	}
 }
 
-static int assign_irq_vector(int irq, cpumask_t mask);
+static int assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask);
+
+static void __set_desc_affinity(struct irq_desc *desc, cpumask_t mask)
+{
+	desc->affinity = mask;
+}
 
 static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 {
@@ -374,7 +470,7 @@ static void set_ioapic_affinity_irq(unsi
 		return;
 
 	cfg = irq_cfg(irq);
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
 	cpus_and(tmp, cfg->domain, mask);
@@ -387,7 +483,7 @@ static void set_ioapic_affinity_irq(unsi
 	desc = irq_to_desc(irq);
 	spin_lock_irqsave(&ioapic_lock, flags);
 	__target_IO_APIC_irq(irq, dest, cfg->vector);
-	desc->affinity = mask;
+	__set_desc_affinity(desc, mask);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 #endif /* CONFIG_SMP */
@@ -397,16 +493,13 @@ static void set_ioapic_affinity_irq(unsi
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
-static void add_pin_to_irq(unsigned int irq, int apic, int pin)
+static void add_pin_to_irq_cpu(struct irq_cfg *cfg, int cpu, int apic, int pin)
 {
-	struct irq_cfg *cfg;
 	struct irq_pin_list *entry;
 
-	/* first time to refer irq_cfg, so with new */
-	cfg = irq_cfg_alloc(irq);
 	entry = cfg->irq_2_pin;
 	if (!entry) {
-		entry = get_one_free_irq_2_pin();
+		entry = get_one_free_irq_2_pin(cpu);
 		cfg->irq_2_pin = entry;
 		entry->apic = apic;
 		entry->pin = pin;
@@ -421,20 +514,31 @@ static void add_pin_to_irq(unsigned int
 		entry = entry->next;
 	}
 
-	entry->next = get_one_free_irq_2_pin();
+	entry->next = get_one_free_irq_2_pin(cpu);
 	entry = entry->next;
 	entry->apic = apic;
 	entry->pin = pin;
 }
 
+static void add_pin_to_irq(unsigned int irq, int apic, int pin)
+{
+	struct irq_desc *desc;
+	struct irq_cfg *cfg;
+	int cpu = smp_processor_id();
+
+	/* first time to refer irq_cfg, so with new */
+	desc = irq_to_desc_alloc_cpu(irq, cpu);
+	cfg = desc->chip_data;
+	add_pin_to_irq_cpu(cfg, cpu, apic, pin);
+}
+
 /*
  * Reroute an IRQ to a different pin.
  */
-static void __init replace_pin_at_irq(unsigned int irq,
+static void __init replace_pin_at_irq_cpu(struct irq_cfg *cfg, int cpu,
 				      int oldapic, int oldpin,
 				      int newapic, int newpin)
 {
-	struct irq_cfg *cfg = irq_cfg(irq);
 	struct irq_pin_list *entry = cfg->irq_2_pin;
 	int replaced = 0;
 
@@ -451,7 +555,7 @@ static void __init replace_pin_at_irq(un
 
 	/* why? call replace before add? */
 	if (!replaced)
-		add_pin_to_irq(irq, newapic, newpin);
+		add_pin_to_irq_cpu(cfg, cpu, newapic, newpin);
 }
 
 static inline void io_apic_modify_irq(unsigned int irq,
@@ -809,7 +913,7 @@ EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector
  */
 static int EISA_ELCR(unsigned int irq)
 {
-	if (irq < 16) {
+	if (irq < NR_IRQS_LEGACY) {
 		unsigned int port = 0x4d0 + (irq >> 3);
 		return (inb(port) >> (irq & 7)) & 1;
 	}
@@ -1034,7 +1138,7 @@ void unlock_vector_lock(void)
 	spin_unlock(&vector_lock);
 }
 
-static int __assign_irq_vector(int irq, cpumask_t mask)
+static int __assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1050,9 +1154,6 @@ static int __assign_irq_vector(int irq,
 	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
 	unsigned int old_vector;
 	int cpu;
-	struct irq_cfg *cfg;
-
-	cfg = irq_cfg(irq);
 
 	/* Only try and allocate irqs on cpus that are present */
 	cpus_and(mask, mask, cpu_online_map);
@@ -1113,24 +1214,22 @@ next:
 	return -ENOSPC;
 }
 
-static int assign_irq_vector(int irq, cpumask_t mask)
+static int assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask)
 {
 	int err;
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
-	err = __assign_irq_vector(irq, mask);
+	err = __assign_irq_vector(irq, cfg, mask);
 	spin_unlock_irqrestore(&vector_lock, flags);
 	return err;
 }
 
-static void __clear_irq_vector(int irq)
+static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 {
-	struct irq_cfg *cfg;
 	cpumask_t mask;
 	int cpu, vector;
 
-	cfg = irq_cfg(irq);
 	BUG_ON(!cfg->vector);
 
 	vector = cfg->vector;
@@ -1148,14 +1247,16 @@ void __setup_vector_irq(int cpu)
 	/* This function must be called with vector_lock held */
 	int irq, vector;
 	struct irq_cfg *cfg;
+	struct irq_desc *desc;
 
 	/* Mark the inuse vectors */
-	for_each_irq_cfg(irq, cfg) {
+	for_each_irq_desc(irq, desc) {
+		cfg = desc->chip_data;
 		if (!cpu_isset(cpu, cfg->domain))
 			continue;
 		vector = cfg->vector;
 		per_cpu(vector_irq, cpu)[vector] = irq;
-	}
+	} end_for_each_irq_desc();
 	/* Mark the free vectors */
 	for (vector = 0; vector < NR_VECTORS; ++vector) {
 		irq = per_cpu(vector_irq, cpu)[vector];
@@ -1205,7 +1306,8 @@ static void ioapic_register_intr(int irq
 {
 	struct irq_desc *desc;
 
-	desc = irq_to_desc(irq);
+	/* could be first time to use this irq_desc */
+	desc = irq_to_desc_alloc(irq);
 
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
 	    trigger == IOAPIC_LEVEL)
@@ -1310,7 +1412,7 @@ static void setup_IO_APIC_irq(int apic,
 	cfg = irq_cfg(irq);
 
 	mask = TARGET_CPUS;
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
 	cpus_and(mask, cfg->domain, mask);
@@ -1327,12 +1429,12 @@ static void setup_IO_APIC_irq(int apic,
 			       cfg->vector)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic].mp_apicid, pin);
-		__clear_irq_vector(irq);
+		__clear_irq_vector(irq, cfg);
 		return;
 	}
 
 	ioapic_register_intr(irq, trigger);
-	if (irq < 16)
+	if (irq < NR_IRQS_LEGACY)
 		disable_8259A_irq(irq);
 
 	ioapic_write_entry(apic, pin, entry);
@@ -1434,6 +1536,7 @@ __apicdebuginit(void) print_IO_APIC(void
 	union IO_APIC_reg_03 reg_03;
 	unsigned long flags;
 	struct irq_cfg *cfg;
+	struct irq_desc *desc;
 	unsigned int irq;
 
 	if (apic_verbosity == APIC_QUIET)
@@ -1523,8 +1626,11 @@ __apicdebuginit(void) print_IO_APIC(void
 	}
 	}
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
-	for_each_irq_cfg(irq, cfg) {
-		struct irq_pin_list *entry = cfg->irq_2_pin;
+	for_each_irq_desc(irq, desc) {
+		struct irq_pin_list *entry;
+
+		cfg = desc->chip_data;
+		entry = cfg->irq_2_pin;
 		if (!entry)
 			continue;
 		printk(KERN_DEBUG "IRQ%d ", irq);
@@ -1535,7 +1641,7 @@ __apicdebuginit(void) print_IO_APIC(void
 			entry = entry->next;
 		}
 		printk("\n");
-	}
+	} end_for_each_irq_desc();
 
 	printk(KERN_INFO ".................................... done.\n");
 
@@ -2010,7 +2116,7 @@ static unsigned int startup_ioapic_irq(u
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	if (irq < 16) {
+	if (irq < NR_IRQS_LEGACY) {
 		disable_8259A_irq(irq);
 		if (i8259A_irq_pending(irq))
 			was_pending = 1;
@@ -2095,10 +2201,10 @@ static void migrate_ioapic_irq(int irq,
 	if (get_irte(irq, &irte))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = irq_cfg(irq);
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -2125,7 +2231,7 @@ static void migrate_ioapic_irq(int irq,
 		cfg->move_in_progress = 0;
 	}
 
-	desc->affinity = mask;
+	__set_desc_affinity(desc, mask);
 }
 
 static int migrate_irq_remapped_level(int irq)
@@ -2178,7 +2284,7 @@ static void ir_irq_migration(struct work
 			desc->chip->set_affinity(irq, desc->pending_mask);
 			spin_unlock_irqrestore(&desc->lock, flags);
 		}
-	}
+	} end_for_each_irq_desc();
 }
 
 /*
@@ -2238,7 +2344,8 @@ unlock:
 
 static void irq_complete_move(unsigned int irq)
 {
-	struct irq_cfg *cfg = irq_cfg(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_cfg *cfg = desc->chip_data;
 	unsigned vector, me;
 
 	if (likely(!cfg->move_in_progress))
@@ -2249,6 +2356,11 @@ static void irq_complete_move(unsigned i
 	if ((vector == cfg->vector) && cpu_isset(me, cfg->domain)) {
 		cpumask_t cleanup_mask;
 
+		move_irq_desc(desc, me);
+		desc = NULL;
+
+		/* get the new one */
+		cfg = irq_cfg(irq);
 		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
 		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
 		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
@@ -2416,22 +2528,21 @@ static inline void init_IO_APIC_traps(vo
 	 * Also, we've got to be careful not to trash gate
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
-	for_each_irq_cfg(irq, cfg) {
-		if (IO_APIC_IRQ(irq) && !cfg->vector) {
+	for_each_irq_desc(irq, desc) {
+		cfg = desc->chip_data;
+		if (IO_APIC_IRQ(irq) && cfg && !cfg->vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
 			 * so default to an old-fashioned 8259
 			 * interrupt if we can..
 			 */
-			if (irq < 16)
+			if (irq < NR_IRQS_LEGACY)
 				make_8259A_irq(irq);
-			else {
-				desc = irq_to_desc(irq);
+			else
 				/* Strange. Oh, well.. */
 				desc->chip = &no_irq_chip;
-			}
 		}
-	}
+	} end_for_each_irq_desc();
 }
 
 /*
@@ -2575,6 +2686,7 @@ int timer_through_8259 __initdata;
 static inline void __init check_timer(void)
 {
 	struct irq_cfg *cfg = irq_cfg(0);
+	int cpu = smp_processor_id();
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
 	unsigned int ver;
@@ -2589,7 +2701,7 @@ static inline void __init check_timer(vo
 	 * get/set the timer IRQ vector:
 	 */
 	disable_8259A_irq(0);
-	assign_irq_vector(0, TARGET_CPUS);
+	assign_irq_vector(0, cfg, TARGET_CPUS);
 
 	/*
 	 * As IRQ0 is to be enabled in the 8259A, the virtual
@@ -2640,7 +2752,7 @@ static inline void __init check_timer(vo
 		 * Ok, does IRQ0 through the IOAPIC work?
 		 */
 		if (no_pin1) {
-			add_pin_to_irq(0, apic1, pin1);
+			add_pin_to_irq_cpu(cfg, cpu, apic1, pin1);
 			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
 		}
 		unmask_IO_APIC_irq(0);
@@ -2669,7 +2781,7 @@ static inline void __init check_timer(vo
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
-		replace_pin_at_irq(0, apic1, pin1, apic2, pin2);
+		replace_pin_at_irq_cpu(cfg, cpu, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
 		unmask_IO_APIC_irq(0);
 		enable_8259A_irq(0);
@@ -2888,22 +3000,23 @@ unsigned int create_irq_nr(unsigned int
 	unsigned int irq;
 	unsigned int new;
 	unsigned long flags;
-	struct irq_cfg *cfg_new;
-
-	irq_want = nr_irqs - 1;
+	struct irq_cfg *cfg_new = NULL;
+	struct irq_desc *desc_new = NULL;
+	int cpu;
 
 	irq = 0;
 	spin_lock_irqsave(&vector_lock, flags);
+	cpu = smp_processor_id();
 	for (new = irq_want; new > 0; new--) {
 		if (platform_legacy_irq(new))
 			continue;
-		cfg_new = irq_cfg(new);
-		if (cfg_new && cfg_new->vector != 0)
+
+		desc_new = irq_to_desc_alloc_cpu(new, cpu);
+		cfg_new = desc_new->chip_data;
+
+		if (cfg_new->vector != 0)
 			continue;
-		/* check if need to create one */
-		if (!cfg_new)
-			cfg_new = irq_cfg_alloc(new);
-		if (__assign_irq_vector(new, TARGET_CPUS) == 0)
+		if (__assign_irq_vector(new, cfg_new, TARGET_CPUS) == 0)
 			irq = new;
 		break;
 	}
@@ -2911,6 +3024,9 @@ unsigned int create_irq_nr(unsigned int
 
 	if (irq > 0) {
 		dynamic_irq_init(irq);
+		/* restore it, in case dynamic_irq_init clear it */
+		if (desc_new)
+			desc_new->chip_data = cfg_new;
 	}
 	return irq;
 }
@@ -2930,14 +3046,22 @@ int create_irq(void)
 void destroy_irq(unsigned int irq)
 {
 	unsigned long flags;
+	struct irq_cfg *cfg;
+	struct irq_desc *desc;
 
+	/* store it, in case dynamic_irq_cleanup clear it */
+	desc = irq_to_desc(irq);
+	cfg = desc->chip_data;
 	dynamic_irq_cleanup(irq);
+	/* connect back irq_cfg */
+	if (desc)
+		desc->chip_data = cfg;
 
 #ifdef CONFIG_INTR_REMAP
 	free_irte(irq);
 #endif
 	spin_lock_irqsave(&vector_lock, flags);
-	__clear_irq_vector(irq);
+	__clear_irq_vector(irq, cfg);
 	spin_unlock_irqrestore(&vector_lock, flags);
 }
 
@@ -2952,12 +3076,12 @@ static int msi_compose_msg(struct pci_de
 	unsigned dest;
 	cpumask_t tmp;
 
+	cfg = irq_cfg(irq);
 	tmp = TARGET_CPUS;
-	err = assign_irq_vector(irq, tmp);
+	err = assign_irq_vector(irq, cfg, tmp);
 	if (err)
 		return err;
 
-	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, tmp);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -3025,10 +3149,10 @@ static void set_msi_irq_affinity(unsigne
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = irq_cfg(irq);
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -3041,7 +3165,7 @@ static void set_msi_irq_affinity(unsigne
 
 	write_msi_msg(irq, &msg);
 	desc = irq_to_desc(irq);
-	desc->affinity = mask;
+	__set_desc_affinity(desc, mask);
 }
 
 #ifdef CONFIG_INTR_REMAP
@@ -3064,10 +3188,10 @@ static void ir_set_msi_irq_affinity(unsi
 	if (get_irte(irq, &irte))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = irq_cfg(irq);
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -3092,7 +3216,7 @@ static void ir_set_msi_irq_affinity(unsi
 	}
 
 	desc = irq_to_desc(irq);
-	desc->affinity = mask;
+	__set_desc_affinity(desc, mask);
 }
 #endif
 #endif /* CONFIG_SMP */
@@ -3176,7 +3300,7 @@ static int setup_msi_irq(struct pci_dev
 #endif
 		set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
 
-	dev_printk(KERN_DEBUG, &dev->dev, "irq %d for MSI/MSI-X\n", irq);
+	dev_printk(KERN_DEBUG, &dev->dev, "irq %d aka 0x%08x for MSI/MSI-X\n", irq, irq);
 
 	return 0;
 }
@@ -3199,7 +3323,7 @@ int arch_setup_msi_irq(struct pci_dev *d
 	int ret;
 	unsigned int irq_want;
 
-	irq_want = build_irq_for_pci_dev(dev) + 0x100;
+	irq_want = build_irq_for_pci_dev(dev) + 0xfff;
 
 	irq = create_irq_nr(irq_want);
 	if (irq == 0)
@@ -3240,7 +3364,7 @@ int arch_setup_msi_irqs(struct pci_dev *
 	int index = 0;
 #endif
 
-	irq_want = build_irq_for_pci_dev(dev) + 0x100;
+	irq_want = build_irq_for_pci_dev(dev) + 0xfff;
 	sub_handle = 0;
 	list_for_each_entry(desc, &dev->msi_list, list) {
 		irq = create_irq_nr(irq_want--);
@@ -3306,10 +3430,10 @@ static void dmar_msi_set_affinity(unsign
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = irq_cfg(irq);
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -3322,7 +3446,7 @@ static void dmar_msi_set_affinity(unsign
 
 	dmar_msi_write(irq, &msg);
 	desc = irq_to_desc(irq);
-	desc->affinity = mask;
+	__set_desc_affinity(desc, mask);
 }
 #endif /* CONFIG_SMP */
 
@@ -3367,10 +3491,10 @@ static void hpet_msi_set_affinity(unsign
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = irq_cfg(irq);
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -3383,7 +3507,7 @@ static void hpet_msi_set_affinity(unsign
 
 	hpet_msi_write(irq, &msg);
 	desc = irq_to_desc(irq);
-	desc->affinity = mask;
+	__set_desc_affinity(desc, mask);
 }
 #endif /* CONFIG_SMP */
 
@@ -3448,16 +3572,16 @@ static void set_ht_irq_affinity(unsigned
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = irq_cfg(irq);
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
 	target_ht_irq(irq, dest, cfg->vector);
 	desc = irq_to_desc(irq);
-	desc->affinity = mask;
+	__set_desc_affinity(desc, mask);
 }
 #endif
 
@@ -3478,13 +3602,13 @@ int arch_setup_ht_irq(unsigned int irq,
 	int err;
 	cpumask_t tmp;
 
+	cfg = irq_cfg(irq);
 	tmp = TARGET_CPUS;
-	err = assign_irq_vector(irq, tmp);
+	err = assign_irq_vector(irq, cfg, tmp);
 	if (!err) {
 		struct ht_irq_msg msg;
 		unsigned dest;
 
-		cfg = irq_cfg(irq);
 		cpus_and(tmp, cfg->domain, tmp);
 		dest = cpu_mask_to_apicid(tmp);
 
@@ -3508,7 +3632,8 @@ int arch_setup_ht_irq(unsigned int irq,
 		set_irq_chip_and_handler_name(irq, &ht_irq_chip,
 					      handle_edge_irq, "edge");
 
-		dev_printk(KERN_DEBUG, &dev->dev, "irq %d for HT\n", irq);
+		dev_printk(KERN_DEBUG, &dev->dev, "irq %d aka 0x%08x for HT\n",
+				 irq, irq);
 	}
 	return err;
 }
@@ -3530,7 +3655,9 @@ int arch_enable_uv_irq(char *irq_name, u
 	unsigned long flags;
 	int err;
 
-	err = assign_irq_vector(irq, *eligible_cpu);
+	cfg = irq_cfg(irq);
+
+	err = assign_irq_vector(irq, cfg, *eligible_cpu);
 	if (err != 0)
 		return err;
 
@@ -3539,8 +3666,6 @@ int arch_enable_uv_irq(char *irq_name, u
 				      irq_name);
 	spin_unlock_irqrestore(&vector_lock, flags);
 
-	cfg = irq_cfg(irq);
-
 	mmr_value = 0;
 	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
 	BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
@@ -3611,8 +3736,6 @@ int __init probe_nr_irqs(void)
 	/* something wrong ? */
 	if (nr < nr_min)
 		nr = nr_min;
-	if (WARN_ON(nr > NR_IRQS))
-		nr = NR_IRQS;
 
 	return nr;
 }
@@ -3722,7 +3845,7 @@ int io_apic_set_pci_routing (int ioapic,
 	/*
 	 * IRQs < 16 are already in the irq_2_pin[] map
 	 */
-	if (irq >= 16)
+	if (irq >= NR_IRQS_LEGACY)
 		add_pin_to_irq(irq, ioapic, pin);
 
 	setup_IO_APIC_irq(ioapic, pin, irq, triggering, polarity);
@@ -3852,7 +3975,6 @@ void __init ioapic_init_mappings(void)
 	struct resource *ioapic_res;
 	int i;
 
-	irq_2_pin_init();
 	ioapic_res = ioapic_setup_resources();
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
Index: linux-2.6/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_32.c
+++ linux-2.6/arch/x86/kernel/irqinit_32.c
@@ -68,8 +68,7 @@ void __init init_ISA_irqs (void)
 	/*
 	 * 16 old-style INTA-cycle interrupts:
 	 */
-	for (i = 0; i < 16; i++) {
-		/* first time call this irq_desc */
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
 		struct irq_desc *desc = irq_to_desc(i);
 
 		desc->status = IRQ_DISABLED;
Index: linux-2.6/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_64.c
+++ linux-2.6/arch/x86/kernel/irqinit_64.c
@@ -142,8 +142,7 @@ void __init init_ISA_irqs(void)
 	init_bsp_APIC();
 	init_8259A(0);
 
-	for (i = 0; i < 16; i++) {
-		/* first time call this irq_desc */
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
 		struct irq_desc *desc = irq_to_desc(i);
 
 		desc->status = IRQ_DISABLED;
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -66,6 +66,7 @@ static unsigned long __meminitdata table
 static unsigned long __meminitdata table_top;
 
 static int __initdata after_init_bootmem;
+int after_bootmem;
 
 static __init void *alloc_low_page(unsigned long *phys)
 {
@@ -987,6 +988,8 @@ void __init mem_init(void)
 
 	set_highmem_pages_init();
 
+	after_bootmem = 1;
+
 	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
Index: linux-2.6/drivers/char/random.c
===================================================================
--- linux-2.6.orig/drivers/char/random.c
+++ linux-2.6/drivers/char/random.c
@@ -558,6 +558,8 @@ struct timer_rand_state {
 	unsigned dont_count_entropy:1;
 };
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
+
 static struct timer_rand_state *irq_timer_state[NR_IRQS];
 
 static struct timer_rand_state *get_timer_rand_state(unsigned int irq)
@@ -576,6 +578,33 @@ static void set_timer_rand_state(unsigne
 	irq_timer_state[irq] = state;
 }
 
+#else
+
+static struct timer_rand_state *get_timer_rand_state(unsigned int irq)
+{
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+
+	if (!desc)
+		return NULL;
+
+	return desc->timer_rand_state;
+}
+
+static void set_timer_rand_state(unsigned int irq, struct timer_rand_state *state)
+{
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+
+	if (!desc)
+		return;
+
+	desc->timer_rand_state = state;
+}
+#endif
+
 static struct timer_rand_state input_timer_state;
 
 /*
@@ -933,8 +962,10 @@ void rand_initialize_irq(int irq)
 {
 	struct timer_rand_state *state;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs)
 		return;
+#endif
 
 	state = get_timer_rand_state(irq);
 
Index: linux-2.6/drivers/pci/htirq.c
===================================================================
--- linux-2.6.orig/drivers/pci/htirq.c
+++ linux-2.6/drivers/pci/htirq.c
@@ -82,6 +82,18 @@ void unmask_ht_irq(unsigned int irq)
 	write_ht_irq_msg(irq, &msg);
 }
 
+static unsigned int build_irq_for_pci_dev(struct pci_dev *dev)
+{
+	unsigned int irq;
+
+	irq = dev->bus->number;
+	irq <<= 8;
+	irq |= dev->devfn;
+	irq <<= 12;
+
+	return irq;
+}
+
 /**
  * __ht_create_irq - create an irq and attach it to a device.
  * @dev: The hypertransport device to find the irq capability on.
@@ -98,6 +110,7 @@ int __ht_create_irq(struct pci_dev *dev,
 	int max_irq;
 	int pos;
 	int irq;
+	unsigned int irq_want;
 
 	pos = pci_find_ht_capability(dev, HT_CAPTYPE_IRQ);
 	if (!pos)
@@ -125,7 +138,12 @@ int __ht_create_irq(struct pci_dev *dev,
 	cfg->msg.address_lo = 0xffffffff;
 	cfg->msg.address_hi = 0xffffffff;
 
+	irq_want = build_irq_for_pci_dev(dev);
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	irq = create_irq_nr(irq_want + idx);
+#else
 	irq = create_irq();
+#endif
 
 	if (irq <= 0) {
 		kfree(cfg);
Index: linux-2.6/drivers/pci/intr_remapping.c
===================================================================
--- linux-2.6.orig/drivers/pci/intr_remapping.c
+++ linux-2.6/drivers/pci/intr_remapping.c
@@ -19,17 +19,76 @@ struct irq_2_iommu {
 	u8  irte_mask;
 };
 
-static struct irq_2_iommu irq_2_iommuX[NR_IRQS];
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+static struct irq_2_iommu *get_one_free_irq_2_iommu(int cpu)
+{
+	struct irq_2_iommu *iommu;
+	int node;
+
+	if (cpu < 0)
+		cpu = smp_processor_id();
+	node = cpu_to_node(cpu);
+
+	iommu = kzalloc_node(sizeof(*iommu), GFP_KERNEL, node);
+	printk(KERN_DEBUG "alloc irq_2_iommu on cpu %d node %d\n", cpu, node);
+
+	return iommu;
+}
 
 static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
 {
-	return (irq < nr_irqs) ? irq_2_iommuX + irq : NULL;
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+
+	BUG_ON(!desc);
+
+	return desc->irq_2_iommu;
 }
 
+static struct irq_2_iommu *irq_2_iommu_alloc_cpu(unsigned int irq, int cpu)
+{
+	struct irq_desc *desc;
+	struct irq_2_iommu *irq_iommu;
+
+	/*
+	 * alloc irq desc if not allocated already.
+	 */
+	desc = irq_to_desc_alloc_cpu(irq, cpu);
+
+	irq_iommu = desc->irq_2_iommu;
+
+	if (!irq_iommu)
+		desc->irq_2_iommu = get_one_free_irq_2_iommu(cpu);
+
+	return desc->irq_2_iommu;
+}
+
+static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
+{
+	return irq_2_iommu_alloc_cpu(irq, -1);
+}
+
+#else /* !CONFIG_HAVE_SPARSE_IRQ */
+
+static struct irq_2_iommu irq_2_iommuX[NR_IRQS];
+
+static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
+{
+	if (irq < nr_irqs)
+		return &irq_2_iommuX[irq];
+
+	return NULL;
+}
+static struct irq_2_iommu *irq_2_iommu_alloc_cpu(unsigned int irq, int cpu)
+{
+	return irq_2_iommu(irq);
+}
 static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
 {
 	return irq_2_iommu(irq);
 }
+#endif
 
 static DEFINE_SPINLOCK(irq_2_ir_lock);
 
@@ -86,9 +145,11 @@ int alloc_irte(struct intel_iommu *iommu
 	if (!count)
 		return -1;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	/* protect irq_2_iommu_alloc later */
 	if (irq >= nr_irqs)
 		return -1;
+#endif
 
 	/*
 	 * start the IRTE search from index 0.
Index: linux-2.6/drivers/xen/events.c
===================================================================
--- linux-2.6.orig/drivers/xen/events.c
+++ linux-2.6/drivers/xen/events.c
@@ -141,8 +141,9 @@ static void init_evtchn_cpu_bindings(voi
 	int i;
 
 	/* By default all event channels notify CPU#0. */
-	for_each_irq_desc(i, desc)
+	for_each_irq_desc(i, desc) {
 		desc->affinity = cpumask_of_cpu(0);
+	} end_for_each_irq_desc();
 #endif
 
 	memset(cpu_evtchn, 0, sizeof(cpu_evtchn));
@@ -231,7 +232,7 @@ static int find_unbound_irq(void)
 	int irq;
 
 	/* Only allocate from dynirq range */
-	for_each_irq_nr(irq)
+	for (irq = 0; irq < nr_irqs; irq++)
 		if (irq_bindcount[irq] == 0)
 			break;
 
@@ -792,7 +793,7 @@ void xen_irq_resume(void)
 		mask_evtchn(evtchn);
 
 	/* No IRQ <-> event-channel mappings. */
-	for_each_irq_nr(irq)
+	for (irq = 0; irq < nr_irqs; irq++)
 		irq_info[irq].evtchn = 0; /* zap event-channel binding */
 
 	for (evtchn = 0; evtchn < NR_EVENT_CHANNELS; evtchn++)
@@ -824,7 +825,7 @@ void __init xen_init_IRQ(void)
 		mask_evtchn(i);
 
 	/* Dynamic IRQ space is currently unbound. Zero the refcnts. */
-	for_each_irq_nr(i)
+	for (i = 0; i < nr_irqs; i++)
 		irq_bindcount[i] = 0;
 
 	irq_ctx_init(smp_processor_id());
Index: linux-2.6/fs/proc/stat.c
===================================================================
--- linux-2.6.orig/fs/proc/stat.c
+++ linux-2.6/fs/proc/stat.c
@@ -27,6 +27,9 @@ static int show_stat(struct seq_file *p,
 	u64 sum = 0;
 	struct timespec boottime;
 	unsigned int per_irq_sum;
+#ifdef CONFIG_GENERIC_HARDIRQS
+	struct irq_desc *desc;
+#endif
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
@@ -44,10 +47,9 @@ static int show_stat(struct seq_file *p,
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-
-		for_each_irq_nr(j)
+		for_each_irq_desc(j, desc) {
 			sum += kstat_irqs_cpu(j, i);
-
+		} end_for_each_irq_desc();
 		sum += arch_irq_stat_cpu(i);
 	}
 	sum += arch_irq_stat();
@@ -90,14 +92,17 @@ static int show_stat(struct seq_file *p,
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
 	/* sum again ? it could be updated? */
-	for_each_irq_nr(j) {
+	for_each_irq_desc(j, desc) {
 		per_irq_sum = 0;
-
 		for_each_possible_cpu(i)
 			per_irq_sum += kstat_irqs_cpu(j, i);
 
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+		seq_printf(p, " %#x:%u", j, per_irq_sum);
+#else
 		seq_printf(p, " %u", per_irq_sum);
-	}
+#endif
+	} end_for_each_irq_desc();
 
 	seq_printf(p,
 		"\nctxt %llu\n"
Index: linux-2.6/fs/proc/interrupts.c
===================================================================
--- linux-2.6.orig/fs/proc/interrupts.c
+++ linux-2.6/fs/proc/interrupts.c
@@ -10,20 +10,31 @@
  */
 static void *int_seq_start(struct seq_file *f, loff_t *pos)
 {
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	rcu_read_lock();
+	return seq_list_start(&sparse_irqs_head, *pos);
+#else
 	return (*pos <= nr_irqs) ? pos : NULL;
+#endif
 }
 
 static void *int_seq_next(struct seq_file *f, void *v, loff_t *pos)
 {
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	return seq_list_next(v, &sparse_irqs_head, pos);
+#else
 	(*pos)++;
 	if (*pos > nr_irqs)
 		return NULL;
 	return pos;
+#endif
 }
 
 static void int_seq_stop(struct seq_file *f, void *v)
 {
-	/* Nothing to do */
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	rcu_read_unlock();
+#endif
 }
 
 static const struct seq_operations int_seq_ops = {
Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -18,6 +18,8 @@
 #include <asm/ptrace.h>
 #include <asm/system.h>
 
+extern int nr_irqs;
+
 /*
  * These correspond to the IORESOURCE_IRQ_* defines in
  * linux/ioport.h to select the interrupt line behaviour.  When
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -129,6 +129,8 @@ struct irq_chip {
 	const char	*typename;
 };
 
+struct timer_rand_state;
+struct irq_2_iommu;
 /**
  * struct irq_desc - interrupt descriptor
  *
@@ -155,6 +157,15 @@ struct irq_chip {
  */
 struct irq_desc {
 	unsigned int		irq;
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	struct list_head	list;
+	struct list_head	hash_entry;
+	struct timer_rand_state *timer_rand_state;
+	unsigned int            *kstat_irqs;
+# ifdef CONFIG_INTR_REMAP
+	struct irq_2_iommu      *irq_2_iommu;
+# endif
+#endif
 	irq_flow_handler_t	handle_irq;
 	struct irq_chip		*chip;
 	struct msi_desc		*msi_desc;
@@ -182,14 +193,59 @@ struct irq_desc {
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
+extern struct irq_desc *irq_to_desc(unsigned int irq);
+extern struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu);
+extern struct irq_desc *irq_to_desc_alloc(unsigned int irq);
+extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int cpu);
+extern void arch_sparse_irq_init_work(void);
+extern void arch_init_chip_data(struct irq_desc *desc, int cpu);
+extern void arch_init_copy_chip_data(struct irq_desc *old_desc,
+					struct irq_desc *desc, int cpu);
+extern void arch_free_chip_data(struct irq_desc *desc);
+
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 
+/* could be removed if we get rid of all irq_desc reference */
 extern struct irq_desc irq_desc[NR_IRQS];
 
-static inline struct irq_desc *irq_to_desc(unsigned int irq)
+#ifdef CONFIG_GENERIC_HARDIRQS
+# define for_each_irq_desc(irq, desc)		\
+	for (irq = 0, desc = irq_desc; irq < nr_irqs; irq++, desc++)
+# define for_each_irq_desc_reverse(irq, desc)                          \
+	for (irq = nr_irqs - 1, desc = irq_desc + (nr_irqs - 1);        \
+	    irq >= 0; irq--, desc--)
+
+#define end_for_each_irq_desc()
+#endif
+
+static inline early_sparse_irq_init_work(void)
 {
-	return (irq < nr_irqs) ? irq_desc + irq : NULL;
 }
 
+#else
+
+void early_sparse_irq_init_work(void);
+extern struct list_head sparse_irqs_head;
+#define for_each_irq_desc(irqX, desc)					\
+	rcu_read_lock();						\
+	for (desc = list_entry(rcu_dereference(sparse_irqs_head.next), typeof(*desc), list), irqX = desc->irq; \
+		prefetch(desc->list.next), &desc->list != &sparse_irqs_head; \
+		desc = list_entry(rcu_dereference(desc->list.next), typeof(*desc), list), irqX = desc ? desc->irq : -1U)
+
+#define for_each_irq_desc_reverse(irqX, desc)				\
+	rcu_read_lock();						\
+	for (desc = list_entry(rcu_dereference(sparse_irqs_head.prev), typeof(*desc), list), irqX = desc->irq; \
+		prefetch(desc->list.prev), &desc->list != &sparse_irqs_head; \
+		desc = list_entry(rcu_dereference(desc->list.prev), typeof(*desc), list), irqX = desc ? desc->irq : -1U)
+
+#define end_for_each_irq_desc() rcu_read_unlock()
+
+#define kstat_irqs_this_cpu(DESC) \
+	((DESC)->kstat_irqs[smp_processor_id()])
+#define kstat_incr_irqs_this_cpu(irqno, DESC) \
+	((DESC)->kstat_irqs[smp_processor_id()]++)
+#endif
+
 /*
  * Migration helpers for obsolete names, they will go away:
  */
Index: linux-2.6/include/linux/kernel_stat.h
===================================================================
--- linux-2.6.orig/include/linux/kernel_stat.h
+++ linux-2.6/include/linux/kernel_stat.h
@@ -28,7 +28,9 @@ struct cpu_usage_stat {
 
 struct kernel_stat {
 	struct cpu_usage_stat	cpustat;
-	unsigned int irqs[NR_IRQS];
+#ifndef CONFIG_HAVE_SPARSE_IRQ
+       unsigned int irqs[NR_IRQS];
+#endif
 };
 
 DECLARE_PER_CPU(struct kernel_stat, kstat);
@@ -39,6 +41,10 @@ DECLARE_PER_CPU(struct kernel_stat, ksta
 
 extern unsigned long long nr_context_switches(void);
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
+#define kstat_irqs_this_cpu(irq) \
+	(kstat_this_cpu.irqs[irq])
+
 struct irq_desc;
 
 static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
@@ -46,11 +52,17 @@ static inline void kstat_incr_irqs_this_
 {
 	kstat_this_cpu.irqs[irq]++;
 }
+#endif
+
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
        return kstat_cpu(cpu).irqs[irq];
 }
+#else
+extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
+#endif
 
 /*
  * Number of interrupts per specific IRQ source, since bootup
Index: linux-2.6/kernel/irq/autoprobe.c
===================================================================
--- linux-2.6.orig/kernel/irq/autoprobe.c
+++ linux-2.6/kernel/irq/autoprobe.c
@@ -57,7 +57,7 @@ unsigned long probe_irq_on(void)
 			desc->chip->startup(i);
 		}
 		spin_unlock_irq(&desc->lock);
-	}
+	} end_for_each_irq_desc();
 
 	/* Wait for longstanding interrupts to trigger. */
 	msleep(20);
@@ -75,7 +75,7 @@ unsigned long probe_irq_on(void)
 				desc->status |= IRQ_PENDING;
 		}
 		spin_unlock_irq(&desc->lock);
-	}
+	} end_for_each_irq_desc();
 
 	/*
 	 * Wait for spurious interrupts to trigger
@@ -99,7 +99,7 @@ unsigned long probe_irq_on(void)
 					mask |= 1 << i;
 		}
 		spin_unlock_irq(&desc->lock);
-	}
+	} end_for_each_irq_desc();
 
 	return mask;
 }
@@ -135,7 +135,7 @@ unsigned int probe_irq_mask(unsigned lon
 			desc->chip->shutdown(i);
 		}
 		spin_unlock_irq(&desc->lock);
-	}
+	} end_for_each_irq_desc();
 	mutex_unlock(&probing_active);
 
 	return mask & val;
@@ -179,7 +179,7 @@ int probe_irq_off(unsigned long val)
 			desc->chip->shutdown(i);
 		}
 		spin_unlock_irq(&desc->lock);
-	}
+	} end_for_each_irq_desc();
 	mutex_unlock(&probing_active);
 
 	if (nr_of_irqs > 1)
Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c
+++ linux-2.6/kernel/irq/chip.c
@@ -24,9 +24,11 @@
  */
 void dynamic_irq_init(unsigned int irq)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc *desc;
 	unsigned long flags;
 
+	/* first time to use this irq_desc */
+	desc = irq_to_desc_alloc(irq);
 	if (!desc) {
 		WARN(1, KERN_ERR "Trying to initialize invalid IRQ%d\n", irq);
 		return;
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -15,9 +15,16 @@
 #include <linux/random.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
+#include <linux/rculist.h>
+#include <linux/hash.h>
 
 #include "internals.h"
 
+/*
+ * lockdep: we want to handle all irq_desc locks as a single lock-class:
+ */
+static struct lock_class_key irq_desc_lock_class;
+
 /**
  * handle_bad_irq - handle spurious and unhandled irqs
  * @irq:       the interrupt number
@@ -49,6 +56,296 @@ void handle_bad_irq(unsigned int irq, st
 int nr_irqs = NR_IRQS;
 EXPORT_SYMBOL_GPL(nr_irqs);
 
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+static struct irq_desc irq_desc_init = {
+	.irq = -1U,
+	.status = IRQ_DISABLED,
+	.chip = &no_irq_chip,
+	.handle_irq = handle_bad_irq,
+	.depth = 1,
+	.lock = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
+#ifdef CONFIG_SMP
+	.affinity = CPU_MASK_ALL
+#endif
+};
+
+static void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
+{
+	unsigned long bytes;
+	char *ptr;
+	int node;
+
+	/* Compute how many bytes we need per irq and allocate them */
+	bytes = nr * sizeof(unsigned int);
+
+	if (cpu < 0)
+		cpu = smp_processor_id();
+
+	node = cpu_to_node(cpu);
+	ptr = kzalloc_node(bytes, GFP_KERNEL, node);
+	printk(KERN_DEBUG "  alloc kstat_irqs on cpu %d node %d\n", cpu, node);
+
+	desc->kstat_irqs = (unsigned int *)ptr;
+}
+
+#ifdef CONFIG_SMP
+static void init_copy_kstat_irqs(struct irq_desc *old_desc, struct irq_desc *desc,
+				 int cpu, int nr)
+{
+	unsigned long bytes;
+
+	init_kstat_irqs(desc, cpu, nr);
+
+	/* Compute how many bytes we need per irq and allocate them */
+	bytes = nr * sizeof(unsigned int);
+
+	memcpy(desc->kstat_irqs, old_desc->kstat_irqs, bytes);
+}
+
+static void free_kstat_irqs(struct irq_desc *desc)
+{
+	kfree(desc->kstat_irqs);
+	desc->kstat_irqs = NULL;
+}
+#endif
+
+void __attribute__((weak)) arch_init_chip_data(struct irq_desc *desc, int cpu)
+{
+}
+
+static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
+{
+	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
+	desc->irq = irq;
+#ifdef CONFIG_SMP
+	desc->cpu = cpu;
+#endif
+	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
+	init_kstat_irqs(desc, cpu, nr_cpu_ids);
+	arch_init_chip_data(desc, cpu);
+}
+
+#ifdef CONFIG_SMP
+static void init_copy_one_irq_desc(int irq, struct irq_desc *old_desc,
+		 struct irq_desc *desc, int cpu)
+{
+	memcpy(desc, old_desc, sizeof(struct irq_desc));
+	desc->cpu = cpu;
+	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
+	init_copy_kstat_irqs(old_desc, desc, cpu, nr_cpu_ids);
+	arch_init_copy_chip_data(old_desc, desc, cpu);
+}
+
+static void free_one_irq_desc(struct irq_desc *desc)
+{
+	free_kstat_irqs(desc);
+	arch_free_chip_data(desc);
+}
+#endif
+/*
+ * Protect the sparse_irqs_free freelist:
+ */
+static DEFINE_SPINLOCK(sparse_irq_lock);
+LIST_HEAD(sparse_irqs_head);
+
+/*
+ * The sparse irqs are in a hash-table as well, for fast lookup:
+ */
+#define SPARSEIRQHASH_BITS          (13 - 1)
+#define SPARSEIRQHASH_SIZE          (1UL << SPARSEIRQHASH_BITS)
+#define __sparseirqhashfn(key)      hash_long((unsigned long)key, SPARSEIRQHASH_BITS)
+#define sparseirqhashentry(key)     (sparseirqhash_table + __sparseirqhashfn((key)))
+
+static struct list_head sparseirqhash_table[SPARSEIRQHASH_SIZE];
+
+static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
+	[0 ... NR_IRQS_LEGACY-1] = {
+		.irq = -1U,
+		.status = IRQ_DISABLED,
+		.chip = &no_irq_chip,
+		.handle_irq = handle_bad_irq,
+		.depth = 1,
+		.lock = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
+#ifdef CONFIG_SMP
+		.affinity = CPU_MASK_ALL
+#endif
+	}
+};
+
+/* FIXME: use bootmem alloc ...*/
+static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
+
+void __init __attribute__((weak)) arch_sparse_irq_init_work(void)
+{
+}
+
+void __init early_sparse_irq_init_work(void)
+{
+	struct irq_desc *desc;
+	int legacy_count;
+	int i;
+
+	/* init_work to init list for sparseirq */
+	for (i = 0; i < SPARSEIRQHASH_SIZE; i++)
+		INIT_LIST_HEAD(sparseirqhash_table + i);
+
+	desc = irq_desc_legacy;
+	legacy_count = ARRAY_SIZE(irq_desc_legacy);
+
+	for (i = 0; i < legacy_count; i++) {
+		struct list_head *hash_head;
+
+		hash_head = sparseirqhashentry(i);
+		desc[i].irq = i;
+		desc[i].kstat_irqs = kstat_irqs_legacy[i];
+		list_add_tail(&desc[i].hash_entry, hash_head);
+		list_add_tail(&desc[i].list, &sparse_irqs_head);
+	}
+
+	arch_sparse_irq_init_work();
+}
+
+struct irq_desc *irq_to_desc(unsigned int irq)
+{
+	struct irq_desc *desc;
+	struct list_head *hash_head;
+
+	hash_head = sparseirqhashentry(irq);
+
+	/*
+	 * We can walk the hash lockfree, because the hash only
+	 * grows, and we are careful when adding entries to the end:
+	 */
+	list_for_each_entry(desc, hash_head, hash_entry) {
+		if (desc->irq == irq)
+			return desc;
+	}
+
+	return NULL;
+}
+
+struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
+{
+	struct irq_desc *desc;
+	struct list_head *hash_head;
+	unsigned long flags;
+	int node;
+
+	desc = irq_to_desc(irq);
+	if (desc)
+		return desc;
+
+	hash_head = sparseirqhashentry(irq);
+
+	spin_lock_irqsave(&sparse_irq_lock, flags);
+
+	/*
+	 * We have to do the hash-walk again, to avoid races
+	 * with another CPU:
+	 */
+	list_for_each_entry(desc, hash_head, hash_entry)
+		if (desc->irq == irq)
+			goto out_unlock;
+
+	if (cpu < 0)
+		cpu = smp_processor_id();
+
+	node = cpu_to_node(cpu);
+	desc = kzalloc_node(sizeof(*desc), GFP_KERNEL, node);
+	printk(KERN_DEBUG "  alloc irq_desc for %d aka %#x on cpu %d node %d\n",
+		 irq, irq, cpu, node);
+	init_one_irq_desc(irq, desc, cpu);
+
+	/*
+	 * We use RCU's safe list-add method to make
+	 * parallel walking of the hash-list safe:
+	 */
+	list_add_tail_rcu(&desc->hash_entry, hash_head);
+	/*
+	 * Add it to the global list:
+	 */
+	list_add_tail_rcu(&desc->list, &sparse_irqs_head);
+
+out_unlock:
+	spin_unlock_irqrestore(&sparse_irq_lock, flags);
+
+	return desc;
+}
+
+struct irq_desc *irq_to_desc_alloc(unsigned int irq)
+{
+	return irq_to_desc_alloc_cpu(irq, -1);
+}
+
+#ifdef CONFIG_SMP
+static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
+						int cpu)
+{
+	struct irq_desc *desc;
+	unsigned int irq;
+	struct list_head *hash_head;
+	unsigned long flags;
+	int node;
+
+	irq = old_desc->irq;
+
+	hash_head = sparseirqhashentry(irq);
+
+	spin_lock_irqsave(&sparse_irq_lock, flags);
+	/*
+	 * We have to do the hash-walk again, to avoid races
+	 * with another CPU:
+	 */
+	list_for_each_entry(desc, hash_head, hash_entry)
+		if (desc->irq == irq && old_desc != desc)
+			goto out_unlock;
+
+	if (cpu < 0)
+		cpu = smp_processor_id();
+
+	node = cpu_to_node(cpu);
+	desc = kzalloc_node(sizeof(*desc), GFP_KERNEL, node);
+	printk(KERN_DEBUG "  move irq_desc for %d aka %#x to cpu %d node %d\n",
+		 irq, irq, cpu, node);
+
+	init_copy_one_irq_desc(irq, old_desc, desc, cpu);
+
+	list_replace_rcu(&desc->hash_entry, &desc->hash_entry);
+	list_replace_rcu(&desc->list, &desc->list);
+
+	/* free the old one */
+	free_one_irq_desc(old_desc);
+	if (irq >= NR_IRQS_LEGACY)
+		kfree(old_desc);
+
+out_unlock:
+	spin_unlock_irqrestore(&sparse_irq_lock, flags);
+
+	return desc;
+}
+
+struct irq_desc *move_irq_desc(struct irq_desc *desc, int cpu)
+{
+	int old_cpu;
+	int node, old_node;
+
+	old_cpu = desc->cpu;
+
+	if (old_cpu != cpu) {
+		node = cpu_to_node(cpu);
+		old_node = cpu_to_node(old_cpu);
+		if (old_node != node)
+			desc = __real_move_irq_desc(desc, cpu);
+		else
+			desc->cpu = cpu;
+	}
+
+	return desc;
+}
+#endif
+
+#else
+
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
 		.status = IRQ_DISABLED,
@@ -62,6 +359,27 @@ struct irq_desc irq_desc[NR_IRQS] __cach
 	}
 };
 
+struct irq_desc *irq_to_desc(unsigned int irq)
+{
+	if (irq < nr_irqs)
+		return &irq_desc[irq];
+
+	return NULL;
+}
+struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
+{
+	return irq_to_desc(irq);
+}
+struct irq_desc *irq_to_desc_alloc(unsigned int irq)
+{
+	return irq_to_desc(irq);
+}
+struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int cpu)
+{
+	return old_desc;
+}
+#endif
+
 /*
  * What should we do if we get a hw irq event on an illegal vector?
  * Each architecture has to answer this themself.
@@ -261,17 +579,25 @@ out:
 
 
 #ifdef CONFIG_TRACE_IRQFLAGS
-/*
- * lockdep: we want to handle all irq_desc locks as a single lock-class:
- */
-static struct lock_class_key irq_desc_lock_class;
-
 void early_init_irq_lock_class(void)
 {
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	struct irq_desc *desc;
 	int i;
 
-	for_each_irq_desc(i, desc)
+	for_each_irq_desc(i, desc) {
 		lockdep_set_class(&desc->lock, &irq_desc_lock_class);
+	} end_for_each_irq_desc();
+#endif
 }
 #endif
+
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	return desc->kstat_irqs[cpu];
+}
+#endif
+EXPORT_SYMBOL(kstat_irqs_cpu);
+
Index: linux-2.6/arch/x86/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq.c
+++ linux-2.6/arch/x86/kernel/irq.c
@@ -99,25 +99,20 @@ static int show_other_interrupts(struct
 int show_interrupts(struct seq_file *p, void *v)
 {
 	unsigned long flags, any_count = 0;
-	int i = *(loff_t *) v, j;
+	int i, j;
 	struct irqaction *action;
 	struct irq_desc *desc;
 
-	if (i > nr_irqs)
-		return 0;
-
-	if (i == nr_irqs)
-		return show_other_interrupts(p);
-
-	/* print header */
-	if (i == 0) {
+	desc = list_entry(v, struct irq_desc, list);
+	i = desc->irq;
+	if (&desc->list == sparse_irqs_head.next) {
+		/* print header */
 		seq_printf(p, "           ");
 		for_each_online_cpu(j)
 			seq_printf(p, "CPU%-8d", j);
 		seq_putc(p, '\n');
 	}
 
-	desc = irq_to_desc(i);
 	spin_lock_irqsave(&desc->lock, flags);
 #ifndef CONFIG_SMP
 	any_count = kstat_irqs(i);
@@ -148,6 +143,10 @@ int show_interrupts(struct seq_file *p,
 	seq_putc(p, '\n');
 out:
 	spin_unlock_irqrestore(&desc->lock, flags);
+
+	if (&desc->list == sparse_irqs_head.prev)
+		show_other_interrupts(p);
+
 	return 0;
 }
 
Index: linux-2.6/include/linux/irqnr.h
===================================================================
--- linux-2.6.orig/include/linux/irqnr.h
+++ linux-2.6/include/linux/irqnr.h
@@ -7,18 +7,11 @@
 
 # define for_each_irq_desc(irq, desc)		\
 	for (irq = 0; irq < nr_irqs; irq++)
-#else
-extern int nr_irqs;
+# define end_for_each_irq_desc()
 
-# define for_each_irq_desc(irq, desc)		\
-	for (irq = 0, desc = irq_desc; irq < nr_irqs; irq++, desc++)
-
-# define for_each_irq_desc_reverse(irq, desc)				\
-	for (irq = nr_irqs - 1, desc = irq_desc + (nr_irqs - 1);	\
-	     irq >= 0; irq--, desc--)
+static inline early_sparse_irq_init_work(void)
+{
+}
 #endif
 
-#define for_each_irq_nr(irq)			\
-	for (irq = 0; irq < nr_irqs; irq++)
-
 #endif
Index: linux-2.6/arch/x86/kernel/irq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq_32.c
+++ linux-2.6/arch/x86/kernel/irq_32.c
@@ -254,7 +254,7 @@ void fixup_irqs(cpumask_t map)
 			desc->chip->set_affinity(irq, mask);
 		else if (desc->action && !(warned++))
 			printk("Cannot set affinity for irq %i\n", irq);
-	}
+	} end_for_each_irq_desc();
 
 #if 0
 	barrier();
Index: linux-2.6/arch/x86/kernel/irq_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq_64.c
+++ linux-2.6/arch/x86/kernel/irq_64.c
@@ -129,7 +129,7 @@ void fixup_irqs(cpumask_t map)
 			printk("Broke affinity for irq %i\n", irq);
 		else if (!set_affinity)
 			printk("Cannot set affinity for irq %i\n", irq);
-	}
+	} end_for_each_irq_desc();
 
 	/* That doesn't seem sufficient.  Give it 1ms. */
 	local_irq_enable();
Index: linux-2.6/kernel/irq/proc.c
===================================================================
--- linux-2.6.orig/kernel/irq/proc.c
+++ linux-2.6/kernel/irq/proc.c
@@ -243,7 +243,8 @@ void init_irq_proc(void)
 	/*
 	 * Create entries for all existing IRQs.
 	 */
-	for_each_irq_desc(irq, desc)
+	for_each_irq_desc(irq, desc) {
 		register_irq_proc(irq, desc);
+	} end_for_each_irq_desc();
 }
 
Index: linux-2.6/kernel/irq/spurious.c
===================================================================
--- linux-2.6.orig/kernel/irq/spurious.c
+++ linux-2.6/kernel/irq/spurious.c
@@ -99,7 +99,7 @@ static int misrouted_irq(int irq)
 
 		if (try_one_irq(i, desc))
 			ok = 1;
-	}
+	} end_for_each_irq_desc();
 	/* So the caller can adjust the irq error counts */
 	return ok;
 }
@@ -122,7 +122,7 @@ static void poll_spurious_irqs(unsigned
 			continue;
 
 		try_one_irq(i, desc);
-	}
+	} end_for_each_irq_desc();
 
 	mod_timer(&poll_spurious_irq_timer,
 		  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -611,6 +611,8 @@ asmlinkage void __init start_kernel(void
 	sort_main_extable();
 	trap_init();
 	rcu_init();
+	/* init some list before init_ISA_irqs() */
+	early_sparse_irq_init_work();
 	init_IRQ();
 	pidhash_init();
 	init_timers();
Index: linux-2.6/arch/x86/include/asm/io_apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/io_apic.h
+++ linux-2.6/arch/x86/include/asm/io_apic.h
@@ -192,6 +192,7 @@ extern int io_apic_set_pci_routing(int i
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 
+struct irq_desc;
 #ifdef CONFIG_X86_64
 extern int save_mask_IO_APIC_setup(void);
 extern void restore_IO_APIC_setup(void);
@@ -199,7 +200,6 @@ extern void reinit_intr_remapped_IO_APIC
 #endif
 
 extern int probe_nr_irqs(void);
-
 #else  /* !CONFIG_X86_IO_APIC */
 #define io_apic_assign_pci_irqs 0
 static const int timer_through_8259 = 0;
Index: linux-2.6/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq_vectors.h
+++ linux-2.6/arch/x86/include/asm/irq_vectors.h
@@ -101,6 +101,8 @@
 #define LAST_VM86_IRQ		15
 #define invalid_vm86_irq(irq)	((irq) < 3 || (irq) > 15)
 
+#define NR_IRQS_LEGACY		16
+
 #if defined(CONFIG_X86_IO_APIC) && !defined(CONFIG_X86_VOYAGER)
 # if NR_CPUS < MAX_IO_APICS
 #  define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))

