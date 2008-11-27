Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbYK0C1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbYK0C1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 21:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYK0C1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 21:27:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:60587 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbYK0C1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 21:27:04 -0500
Message-ID: <492E0540.9010009@kernel.org>
Date: Wed, 26 Nov 2008 18:26:08 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] irq: sparseirq enabling v3
References: <492A1877.4090304@kernel.org> <20081124144007.GA30725@elte.hu> <492B77C5.2050502@kernel.org> <20081126074826.GI26036@elte.hu> <492D02A4.4030206@kernel.org> <20081126081724.GK26036@elte.hu>
In-Reply-To: <20081126081724.GK26036@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


impact: new feature sparseirq

add some kind of hash table as Ingo suggesting.
remove dyna_array

when sparse_irq is used (CONFIG_SPARSE_IRQ), use kzalloc_node to get irq_desc, irq_cfg
  use desc->chip_data for x86 to store irq_cfg

also prepare
  need to add struct (irq_desc **descp) to ack_edge/level to make sure desc get updated
try to pass desc cfg as more as possible to avoid list looking up.

seperate move_irq_desc to another patch

v2: use pointer array instead of hash
v3: remove code for passing desc

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/Kconfig                   |   10 
 arch/x86/include/asm/io_apic.h     |    2 
 arch/x86/include/asm/irq_vectors.h |   11 
 arch/x86/kernel/io_apic.c          |  634 ++++++++++++++++++++++---------------
 arch/x86/kernel/irq.c              |   24 +
 arch/x86/kernel/irq_32.c           |    2 
 arch/x86/kernel/irq_64.c           |    2 
 arch/x86/kernel/irqinit_32.c       |    3 
 arch/x86/kernel/irqinit_64.c       |    3 
 arch/x86/kernel/setup.c            |    2 
 drivers/char/random.c              |   31 +
 drivers/pci/intr_remapping.c       |   76 ++++
 drivers/pci/msi.c                  |   55 ++-
 drivers/xen/events.c               |    9 
 fs/proc/interrupts.c               |   18 +
 fs/proc/stat.c                     |   17 
 include/linux/interrupt.h          |    2 
 include/linux/irq.h                |   67 +++
 include/linux/irqnr.h              |   15 
 include/linux/kernel_stat.h        |   14 
 include/linux/msi.h                |    3 
 init/main.c                        |   11 
 kernel/irq/autoprobe.c             |   10 
 kernel/irq/chip.c                  |    3 
 kernel/irq/handle.c                |  187 ++++++++++
 kernel/irq/proc.c                  |    3 
 kernel/irq/spurious.c              |    4 
 27 files changed, 900 insertions(+), 318 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -241,6 +241,16 @@ config X86_HAS_BOOT_CPU_ID
 	def_bool y
 	depends on X86_VOYAGER
 
+config SPARSE_IRQ
+	bool "Support sparse irq numbering"
+	depends on PCI_MSI || HT_IRQ
+	default y
+	help
+	  This enables support for sparse irq, esp for msi/msi-x. You may need
+	  if you have lots of cards supports msi-x installed.
+
+	  If you don't know what to do here, say Y.
+
 config X86_FIND_SMP_CONFIG
 	def_bool y
 	depends on X86_MPPARSE || X86_VOYAGER
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -108,8 +108,33 @@ static int __init parse_noapic(char *str
 early_param("noapic", parse_noapic);
 
 struct irq_pin_list;
+
+/*
+ * This is performance-critical, we want to do it O(1)
+ *
+ * the indexing order of this array favors 1:1 mappings
+ * between pins and IRQs.
+ */
+
+struct irq_pin_list {
+	int apic, pin;
+	struct irq_pin_list *next;
+};
+
+static struct irq_pin_list *get_one_free_irq_2_pin(int cpu)
+{
+	struct irq_pin_list *pin;
+	int node;
+
+	node = cpu_to_node(cpu);
+
+	pin = kzalloc_node(sizeof(*pin), GFP_ATOMIC, node);
+	printk(KERN_DEBUG "  alloc irq_2_pin on cpu %d node %d\n", cpu, node);
+
+	return pin;
+}
+
 struct irq_cfg {
-	unsigned int irq;
 	struct irq_pin_list *irq_2_pin;
 	cpumask_t domain;
 	cpumask_t old_domain;
@@ -119,81 +144,102 @@ struct irq_cfg {
 };
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
+#ifdef CONFIG_SPARSE_IRQ
+static struct irq_cfg irq_cfgx[] = {
+#else
 static struct irq_cfg irq_cfgx[NR_IRQS] = {
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
+#endif
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
-
-static struct irq_cfg *irq_cfg(unsigned int irq)
+void __init arch_early_irq_init(void)
 {
-	return irq < nr_irqs ? irq_cfgx + irq : NULL;
+	struct irq_cfg *cfg;
+	struct irq_desc *desc;
+	int count;
+	int i;
+#ifdef CONFIG_SPARSE_IRQ
+	int count_desc = NR_IRQS_LEGACY;
+#else
+	int count_desc = NR_IRQS;
+#endif
+
+	cfg = irq_cfgx;
+	count = ARRAY_SIZE(irq_cfgx);
+
+	BUG_ON(count > count_desc);
+
+	for (i = 0; i < count; i++) {
+		desc = irq_to_desc(i);
+		desc->chip_data = &cfg[i];
+	}
 }
 
-static struct irq_cfg *irq_cfg_alloc(unsigned int irq)
+#ifdef CONFIG_SPARSE_IRQ
+static struct irq_cfg *irq_cfg(unsigned int irq)
 {
-	return irq_cfg(irq);
+	struct irq_cfg *cfg = NULL;
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+	if (desc)
+		cfg = desc->chip_data;
+
+	return cfg;
 }
 
-/*
- * Rough estimation of how many shared IRQs there are, can be changed
- * anytime.
- */
-#define MAX_PLUS_SHARED_IRQS NR_IRQS
-#define PIN_MAP_SIZE (MAX_PLUS_SHARED_IRQS + NR_IRQS)
+static struct irq_cfg *get_one_free_irq_cfg(int cpu)
+{
+	struct irq_cfg *cfg;
+	int node;
 
-/*
- * This is performance-critical, we want to do it O(1)
- *
- * the indexing order of this array favors 1:1 mappings
- * between pins and IRQs.
- */
+	node = cpu_to_node(cpu);
 
-struct irq_pin_list {
-	int apic, pin;
-	struct irq_pin_list *next;
-};
+	cfg = kzalloc_node(sizeof(*cfg), GFP_ATOMIC, node);
+	printk(KERN_DEBUG "  alloc irq_cfg on cpu %d node %d\n", cpu, node);
 
-static struct irq_pin_list irq_2_pin_head[PIN_MAP_SIZE];
-static struct irq_pin_list *irq_2_pin_ptr;
+	return cfg;
+}
 
-static void __init irq_2_pin_init(void)
+void arch_init_chip_data(struct irq_desc *desc, int cpu)
 {
-	struct irq_pin_list *pin = irq_2_pin_head;
-	int i;
-
-	for (i = 1; i < PIN_MAP_SIZE; i++)
-		pin[i-1].next = &pin[i];
+	struct irq_cfg *cfg;
 
-	irq_2_pin_ptr = &pin[0];
+	cfg = desc->chip_data;
+	if (!cfg) {
+		desc->chip_data = get_one_free_irq_cfg(cpu);
+		if (!desc->chip_data) {
+			printk(KERN_ERR "can not alloc irq_cfg\n");
+			BUG_ON(1);
+		}
+	}
 }
 
-static struct irq_pin_list *get_one_free_irq_2_pin(void)
+#else
+static struct irq_cfg *irq_cfg(unsigned int irq)
 {
-	struct irq_pin_list *pin = irq_2_pin_ptr;
+	return irq < nr_irqs ? irq_cfgx + irq : NULL;
+}
 
-	if (!pin)
-		panic("can not get more irq_2_pin\n");
+#endif
 
-	irq_2_pin_ptr = pin->next;
-	pin->next = NULL;
-	return pin;
+static inline void set_extra_move_desc(struct irq_desc *desc, cpumask_t mask)
+{
 }
 
 struct io_apic {
@@ -237,11 +283,10 @@ static inline void io_apic_modify(unsign
 	writel(value, &io_apic->data);
 }
 
-static bool io_apic_level_ack_pending(unsigned int irq)
+static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
 {
 	struct irq_pin_list *entry;
 	unsigned long flags;
-	struct irq_cfg *cfg = irq_cfg(irq);
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	entry = cfg->irq_2_pin;
@@ -323,13 +368,12 @@ static void ioapic_mask_entry(int apic,
 }
 
 #ifdef CONFIG_SMP
-static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, u8 vector)
+static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq_cfg *cfg)
 {
 	int apic, pin;
-	struct irq_cfg *cfg;
 	struct irq_pin_list *entry;
+	u8 vector = cfg->vector;
 
-	cfg = irq_cfg(irq);
 	entry = cfg->irq_2_pin;
 	for (;;) {
 		unsigned int reg;
@@ -359,24 +403,27 @@ static void __target_IO_APIC_irq(unsigne
 	}
 }
 
-static int assign_irq_vector(int irq, cpumask_t mask);
+static int assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask);
 
-static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+static void set_ioapic_affinity_irq_desc(struct irq_desc *desc, cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	unsigned long flags;
 	unsigned int dest;
 	cpumask_t tmp;
-	struct irq_desc *desc;
+	unsigned int irq;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
-	cfg = irq_cfg(irq);
-	if (assign_irq_vector(irq, mask))
+	irq = desc->irq;
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 	/*
@@ -384,12 +431,20 @@ static void set_ioapic_affinity_irq(unsi
 	 */
 	dest = SET_APIC_LOGICAL_ID(dest);
 
-	desc = irq_to_desc(irq);
 	spin_lock_irqsave(&ioapic_lock, flags);
-	__target_IO_APIC_irq(irq, dest, cfg->vector);
+	__target_IO_APIC_irq(irq, dest, cfg);
 	desc->affinity = mask;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
+
+static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+{
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+
+	set_ioapic_affinity_irq_desc(desc, mask);
+}
 #endif /* CONFIG_SMP */
 
 /*
@@ -397,16 +452,18 @@ static void set_ioapic_affinity_irq(unsi
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
+		if (!entry) {
+			printk(KERN_ERR "can not alloc irq_2_pin to add %d - %d\n",
+					apic, pin);
+			return;
+		}
 		cfg->irq_2_pin = entry;
 		entry->apic = apic;
 		entry->pin = pin;
@@ -421,7 +478,7 @@ static void add_pin_to_irq(unsigned int
 		entry = entry->next;
 	}
 
-	entry->next = get_one_free_irq_2_pin();
+	entry->next = get_one_free_irq_2_pin(cpu);
 	entry = entry->next;
 	entry->apic = apic;
 	entry->pin = pin;
@@ -430,11 +487,10 @@ static void add_pin_to_irq(unsigned int
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
 
@@ -451,18 +507,16 @@ static void __init replace_pin_at_irq(un
 
 	/* why? call replace before add? */
 	if (!replaced)
-		add_pin_to_irq(irq, newapic, newpin);
+		add_pin_to_irq_cpu(cfg, cpu, newapic, newpin);
 }
 
-static inline void io_apic_modify_irq(unsigned int irq,
+static inline void io_apic_modify_irq(struct irq_cfg *cfg,
 				int mask_and, int mask_or,
 				void (*final)(struct irq_pin_list *entry))
 {
 	int pin;
-	struct irq_cfg *cfg;
 	struct irq_pin_list *entry;
 
-	cfg = irq_cfg(irq);
 	for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
 		unsigned int reg;
 		pin = entry->pin;
@@ -475,9 +529,9 @@ static inline void io_apic_modify_irq(un
 	}
 }
 
-static void __unmask_IO_APIC_irq(unsigned int irq)
+static void __unmask_IO_APIC_irq(struct irq_cfg *cfg)
 {
-	io_apic_modify_irq(irq, ~IO_APIC_REDIR_MASKED, 0, NULL);
+	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED, 0, NULL);
 }
 
 #ifdef CONFIG_X86_64
@@ -492,47 +546,64 @@ void io_apic_sync(struct irq_pin_list *e
 	readl(&io_apic->data);
 }
 
-static void __mask_IO_APIC_irq(unsigned int irq)
+static void __mask_IO_APIC_irq(struct irq_cfg *cfg)
 {
-	io_apic_modify_irq(irq, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
+	io_apic_modify_irq(cfg, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
 }
 #else /* CONFIG_X86_32 */
-static void __mask_IO_APIC_irq(unsigned int irq)
+static void __mask_IO_APIC_irq(struct irq_cfg *cfg)
 {
-	io_apic_modify_irq(irq, ~0, IO_APIC_REDIR_MASKED, NULL);
+	io_apic_modify_irq(cfg, ~0, IO_APIC_REDIR_MASKED, NULL);
 }
 
-static void __mask_and_edge_IO_APIC_irq(unsigned int irq)
+static void __mask_and_edge_IO_APIC_irq(struct irq_cfg *cfg)
 {
-	io_apic_modify_irq(irq, ~IO_APIC_REDIR_LEVEL_TRIGGER,
+	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_LEVEL_TRIGGER,
 			IO_APIC_REDIR_MASKED, NULL);
 }
 
-static void __unmask_and_level_IO_APIC_irq(unsigned int irq)
+static void __unmask_and_level_IO_APIC_irq(struct irq_cfg *cfg)
 {
-	io_apic_modify_irq(irq, ~IO_APIC_REDIR_MASKED,
+	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED,
 			IO_APIC_REDIR_LEVEL_TRIGGER, NULL);
 }
 #endif /* CONFIG_X86_32 */
 
-static void mask_IO_APIC_irq (unsigned int irq)
+static void mask_IO_APIC_irq_desc(struct irq_desc *desc)
 {
+	struct irq_cfg *cfg = desc->chip_data;
 	unsigned long flags;
 
+	BUG_ON(!cfg);
+
 	spin_lock_irqsave(&ioapic_lock, flags);
-	__mask_IO_APIC_irq(irq);
+	__mask_IO_APIC_irq(cfg);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void unmask_IO_APIC_irq (unsigned int irq)
+static void unmask_IO_APIC_irq_desc(struct irq_desc *desc)
 {
+	struct irq_cfg *cfg = desc->chip_data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	__unmask_IO_APIC_irq(irq);
+	__unmask_IO_APIC_irq(cfg);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
+static void mask_IO_APIC_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	mask_IO_APIC_irq_desc(desc);
+}
+static void unmask_IO_APIC_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	unmask_IO_APIC_irq_desc(desc);
+}
+
 static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 {
 	struct IO_APIC_route_entry entry;
@@ -809,7 +880,7 @@ EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector
  */
 static int EISA_ELCR(unsigned int irq)
 {
-	if (irq < 16) {
+	if (irq < NR_IRQS_LEGACY) {
 		unsigned int port = 0x4d0 + (irq >> 3);
 		return (inb(port) >> (irq & 7)) & 1;
 	}
@@ -1034,7 +1105,7 @@ void unlock_vector_lock(void)
 	spin_unlock(&vector_lock);
 }
 
-static int __assign_irq_vector(int irq, cpumask_t mask)
+static int __assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1050,16 +1121,13 @@ static int __assign_irq_vector(int irq,
 	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
 	unsigned int old_vector;
 	int cpu;
-	struct irq_cfg *cfg;
 
-	cfg = irq_cfg(irq);
+	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
+		return -EBUSY;
 
 	/* Only try and allocate irqs on cpus that are present */
 	cpus_and(mask, mask, cpu_online_map);
 
-	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
-		return -EBUSY;
-
 	old_vector = cfg->vector;
 	if (old_vector) {
 		cpumask_t tmp;
@@ -1113,24 +1181,22 @@ next:
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
@@ -1162,14 +1228,16 @@ void __setup_vector_irq(int cpu)
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
@@ -1215,11 +1283,8 @@ static inline int IO_APIC_irq_trigger(in
 }
 #endif
 
-static void ioapic_register_intr(int irq, unsigned long trigger)
+static void ioapic_register_intr(int irq, struct irq_desc *desc, unsigned long trigger)
 {
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
 
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
 	    trigger == IOAPIC_LEVEL)
@@ -1311,7 +1376,7 @@ static int setup_ioapic_entry(int apic,
 	return 0;
 }
 
-static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
+static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq, struct irq_desc *desc,
 			      int trigger, int polarity)
 {
 	struct irq_cfg *cfg;
@@ -1321,10 +1386,10 @@ static void setup_IO_APIC_irq(int apic,
 	if (!IO_APIC_IRQ(irq))
 		return;
 
-	cfg = irq_cfg(irq);
+	cfg = desc->chip_data;
 
 	mask = TARGET_CPUS;
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
 	cpus_and(mask, cfg->domain, mask);
@@ -1341,12 +1406,12 @@ static void setup_IO_APIC_irq(int apic,
 			       cfg->vector)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic].mp_apicid, pin);
-		__clear_irq_vector(irq);
+		__clear_irq_vector(irq, cfg);
 		return;
 	}
 
-	ioapic_register_intr(irq, trigger);
-	if (irq < 16)
+	ioapic_register_intr(irq, desc, trigger);
+	if (irq < NR_IRQS_LEGACY)
 		disable_8259A_irq(irq);
 
 	ioapic_write_entry(apic, pin, entry);
@@ -1356,6 +1421,9 @@ static void __init setup_IO_APIC_irqs(vo
 {
 	int apic, pin, idx, irq;
 	int notcon = 0;
+	struct irq_desc *desc;
+	struct irq_cfg *cfg;
+	int cpu = boot_cpu_id;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
@@ -1387,9 +1455,15 @@ static void __init setup_IO_APIC_irqs(vo
 			if (multi_timer_check(apic, irq))
 				continue;
 #endif
-			add_pin_to_irq(irq, apic, pin);
+			desc = irq_to_desc_alloc_cpu(irq, cpu);
+			if (!desc) {
+				printk(KERN_INFO "can not get irq_desc for %d\n", irq);
+				continue;
+			}
+			cfg = desc->chip_data;
+			add_pin_to_irq_cpu(cfg, cpu, apic, pin);
 
-			setup_IO_APIC_irq(apic, pin, irq,
+			setup_IO_APIC_irq(apic, pin, irq, desc,
 					irq_trigger(idx), irq_polarity(idx));
 		}
 	}
@@ -1448,6 +1522,7 @@ __apicdebuginit(void) print_IO_APIC(void
 	union IO_APIC_reg_03 reg_03;
 	unsigned long flags;
 	struct irq_cfg *cfg;
+	struct irq_desc *desc;
 	unsigned int irq;
 
 	if (apic_verbosity == APIC_QUIET)
@@ -1537,8 +1612,10 @@ __apicdebuginit(void) print_IO_APIC(void
 	}
 	}
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
-	for_each_irq_cfg(irq, cfg) {
-		struct irq_pin_list *entry = cfg->irq_2_pin;
+	for_each_irq_desc(irq, desc) {
+		struct irq_pin_list *entry;
+		cfg = desc->chip_data;
+		entry = cfg->irq_2_pin;
 		if (!entry)
 			continue;
 		printk(KERN_DEBUG "IRQ%d ", irq);
@@ -1549,7 +1626,7 @@ __apicdebuginit(void) print_IO_APIC(void
 			entry = entry->next;
 		}
 		printk("\n");
-	}
+	} end_for_each_irq_desc();
 
 	printk(KERN_INFO ".................................... done.\n");
 
@@ -2022,14 +2099,16 @@ static unsigned int startup_ioapic_irq(u
 {
 	int was_pending = 0;
 	unsigned long flags;
+	struct irq_cfg *cfg;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	if (irq < 16) {
+	if (irq < NR_IRQS_LEGACY) {
 		disable_8259A_irq(irq);
 		if (i8259A_irq_pending(irq))
 			was_pending = 1;
 	}
-	__unmask_IO_APIC_irq(irq);
+	cfg = irq_cfg(irq);
+	__unmask_IO_APIC_irq(cfg);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return was_pending;
@@ -2092,35 +2171,37 @@ static DECLARE_DELAYED_WORK(ir_migration
  * as simple as edge triggered migration and we can do the irq migration
  * with a simple atomic update to IO-APIC RTE.
  */
-static void migrate_ioapic_irq(int irq, cpumask_t mask)
+static void migrate_ioapic_irq_desc(struct irq_desc *desc, cpumask_t mask)
 {
 	struct irq_cfg *cfg;
-	struct irq_desc *desc;
 	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
 	int modify_ioapic_rte;
 	unsigned int dest;
 	unsigned long flags;
+	unsigned int irq;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
+	irq = desc->irq;
 	if (get_irte(irq, &irte))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
-	desc = irq_to_desc(irq);
 	modify_ioapic_rte = desc->status & IRQ_LEVEL;
 	if (modify_ioapic_rte) {
 		spin_lock_irqsave(&ioapic_lock, flags);
-		__target_IO_APIC_irq(irq, dest, cfg->vector);
+		__target_IO_APIC_irq(irq, dest, cfg);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 	}
 
@@ -2142,14 +2223,14 @@ static void migrate_ioapic_irq(int irq,
 	desc->affinity = mask;
 }
 
-static int migrate_irq_remapped_level(int irq)
+static int migrate_irq_remapped_level_desc(struct irq_desc *desc)
 {
 	int ret = -1;
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_cfg *cfg = desc->chip_data;
 
-	mask_IO_APIC_irq(irq);
+	mask_IO_APIC_irq_desc(desc);
 
-	if (io_apic_level_ack_pending(irq)) {
+	if (io_apic_level_ack_pending(cfg)) {
 		/*
 		 * Interrupt in progress. Migrating irq now will change the
 		 * vector information in the IO-APIC RTE and that will confuse
@@ -2161,14 +2242,15 @@ static int migrate_irq_remapped_level(in
 	}
 
 	/* everthing is clear. we have right of way */
-	migrate_ioapic_irq(irq, desc->pending_mask);
+	migrate_ioapic_irq_desc(desc, desc->pending_mask);
 
 	ret = 0;
 	desc->status &= ~IRQ_MOVE_PENDING;
 	cpus_clear(desc->pending_mask);
 
 unmask:
-	unmask_IO_APIC_irq(irq);
+	unmask_IO_APIC_irq_desc(desc);
+
 	return ret;
 }
 
@@ -2192,24 +2274,28 @@ static void ir_irq_migration(struct work
 			desc->chip->set_affinity(irq, desc->pending_mask);
 			spin_unlock_irqrestore(&desc->lock, flags);
 		}
-	}
+	} end_for_each_irq_desc();
 }
 
 /*
  * Migrates the IRQ destination in the process context.
  */
-static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+static void set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc, cpumask_t mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	if (desc->status & IRQ_LEVEL) {
 		desc->status |= IRQ_MOVE_PENDING;
 		desc->pending_mask = mask;
-		migrate_irq_remapped_level(irq);
+		migrate_irq_remapped_level_desc(desc);
 		return;
 	}
 
-	migrate_ioapic_irq(irq, mask);
+	migrate_ioapic_irq_desc(desc, mask);
+}
+static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	set_ir_ioapic_affinity_irq_desc(desc, mask);
 }
 #endif
 
@@ -2229,6 +2315,9 @@ asmlinkage void smp_irq_move_cleanup_int
 		struct irq_cfg *cfg;
 		irq = __get_cpu_var(vector_irq)[vector];
 
+		if (irq == -1)
+			continue;
+
 		desc = irq_to_desc(irq);
 		if (!desc)
 			continue;
@@ -2250,9 +2339,10 @@ unlock:
 	irq_exit();
 }
 
-static void irq_complete_move(unsigned int irq)
+static void irq_complete_move(struct irq_desc **descp)
 {
-	struct irq_cfg *cfg = irq_cfg(irq);
+	struct irq_desc *desc = *descp;
+	struct irq_cfg *cfg = desc->chip_data;
 	unsigned vector, me;
 
 	if (likely(!cfg->move_in_progress))
@@ -2270,8 +2360,9 @@ static void irq_complete_move(unsigned i
 	}
 }
 #else
-static inline void irq_complete_move(unsigned int irq) {}
+static inline void irq_complete_move(struct irq_desc **descp) {}
 #endif
+
 #ifdef CONFIG_INTR_REMAP
 static void ack_x2apic_level(unsigned int irq)
 {
@@ -2282,11 +2373,14 @@ static void ack_x2apic_edge(unsigned int
 {
 	ack_x2APIC_irq();
 }
+
 #endif
 
 static void ack_apic_edge(unsigned int irq)
 {
-	irq_complete_move(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	irq_complete_move(&desc);
 	move_native_irq(irq);
 	ack_APIC_irq();
 }
@@ -2295,18 +2389,21 @@ atomic_t irq_mis_count;
 
 static void ack_apic_level(unsigned int irq)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
+
 #ifdef CONFIG_X86_32
 	unsigned long v;
 	int i;
 #endif
+	struct irq_cfg *cfg;
 	int do_unmask_irq = 0;
 
-	irq_complete_move(irq);
+	irq_complete_move(&desc);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
-	if (unlikely(irq_to_desc(irq)->status & IRQ_MOVE_PENDING)) {
+	if (unlikely(desc->status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
-		mask_IO_APIC_irq(irq);
+		mask_IO_APIC_irq_desc(desc);
 	}
 #endif
 
@@ -2330,7 +2427,8 @@ static void ack_apic_level(unsigned int
 	* operation to prevent an edge-triggered interrupt escaping meanwhile.
 	* The idea is from Manfred Spraul.  --macro
 	*/
-	i = irq_cfg(irq)->vector;
+	cfg = desc->chip_data;
+	i = cfg->vector;
 
 	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
 #endif
@@ -2369,17 +2467,18 @@ static void ack_apic_level(unsigned int
 		 * accurate and is causing problems then it is a hardware bug
 		 * and you can go talk to the chipset vendor about it.
 		 */
-		if (!io_apic_level_ack_pending(irq))
+		cfg = desc->chip_data;
+		if (!io_apic_level_ack_pending(cfg))
 			move_masked_irq(irq);
-		unmask_IO_APIC_irq(irq);
+		unmask_IO_APIC_irq_desc(desc);
 	}
 
 #ifdef CONFIG_X86_32
 	if (!(v & (1 << (i & 0x1f)))) {
 		atomic_inc(&irq_mis_count);
 		spin_lock(&ioapic_lock);
-		__mask_and_edge_IO_APIC_irq(irq);
-		__unmask_and_level_IO_APIC_irq(irq);
+		__mask_and_edge_IO_APIC_irq(cfg);
+		__unmask_and_level_IO_APIC_irq(cfg);
 		spin_unlock(&ioapic_lock);
 	}
 #endif
@@ -2430,22 +2529,21 @@ static inline void init_IO_APIC_traps(vo
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
@@ -2468,7 +2566,7 @@ static void unmask_lapic_irq(unsigned in
 	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
 }
 
-static void ack_lapic_irq (unsigned int irq)
+static void ack_lapic_irq(unsigned int irq)
 {
 	ack_APIC_irq();
 }
@@ -2480,11 +2578,8 @@ static struct irq_chip lapic_chip __read
 	.ack		= ack_lapic_irq,
 };
 
-static void lapic_register_intr(int irq)
+static void lapic_register_intr(int irq, struct irq_desc *desc)
 {
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
 	desc->status &= ~IRQ_LEVEL;
 	set_irq_chip_and_handler_name(irq, &lapic_chip, handle_edge_irq,
 				      "edge");
@@ -2588,7 +2683,9 @@ int timer_through_8259 __initdata;
  */
 static inline void __init check_timer(void)
 {
-	struct irq_cfg *cfg = irq_cfg(0);
+	struct irq_desc *desc = irq_to_desc(0);
+	struct irq_cfg *cfg = desc->chip_data;
+	int cpu = boot_cpu_id;
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
 	unsigned int ver;
@@ -2603,7 +2700,7 @@ static inline void __init check_timer(vo
 	 * get/set the timer IRQ vector:
 	 */
 	disable_8259A_irq(0);
-	assign_irq_vector(0, TARGET_CPUS);
+	assign_irq_vector(0, cfg, TARGET_CPUS);
 
 	/*
 	 * As IRQ0 is to be enabled in the 8259A, the virtual
@@ -2654,10 +2751,10 @@ static inline void __init check_timer(vo
 		 * Ok, does IRQ0 through the IOAPIC work?
 		 */
 		if (no_pin1) {
-			add_pin_to_irq(0, apic1, pin1);
+			add_pin_to_irq_cpu(cfg, cpu, apic1, pin1);
 			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
 		}
-		unmask_IO_APIC_irq(0);
+		unmask_IO_APIC_irq_desc(desc);
 		if (timer_irq_works()) {
 			if (nmi_watchdog == NMI_IO_APIC) {
 				setup_nmi();
@@ -2683,9 +2780,9 @@ static inline void __init check_timer(vo
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
-		replace_pin_at_irq(0, apic1, pin1, apic2, pin2);
+		replace_pin_at_irq_cpu(cfg, cpu, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
-		unmask_IO_APIC_irq(0);
+		unmask_IO_APIC_irq_desc(desc);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
@@ -2717,7 +2814,7 @@ static inline void __init check_timer(vo
 	apic_printk(APIC_QUIET, KERN_INFO
 		    "...trying to set up timer as Virtual Wire IRQ...\n");
 
-	lapic_register_intr(0);
+	lapic_register_intr(0, desc);
 	apic_write(APIC_LVT0, APIC_DM_FIXED | cfg->vector);	/* Fixed mode */
 	enable_8259A_irq(0);
 
@@ -2902,22 +2999,26 @@ unsigned int create_irq_nr(unsigned int
 	unsigned int irq;
 	unsigned int new;
 	unsigned long flags;
-	struct irq_cfg *cfg_new;
-
-	irq_want = nr_irqs - 1;
+	struct irq_cfg *cfg_new = NULL;
+	int cpu = boot_cpu_id;
+	struct irq_desc *desc_new = NULL;
 
 	irq = 0;
 	spin_lock_irqsave(&vector_lock, flags);
-	for (new = irq_want; new > 0; new--) {
+	for (new = irq_want; new < NR_IRQS; new++) {
 		if (platform_legacy_irq(new))
 			continue;
-		cfg_new = irq_cfg(new);
-		if (cfg_new && cfg_new->vector != 0)
+
+		desc_new = irq_to_desc_alloc_cpu(new, cpu);
+		if (!desc_new) {
+			printk(KERN_INFO "can not get irq_desc for %d\n", new);
+			continue;
+		}
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
@@ -2925,15 +3026,21 @@ unsigned int create_irq_nr(unsigned int
 
 	if (irq > 0) {
 		dynamic_irq_init(irq);
+		/* restore it, in case dynamic_irq_init clear it */
+		if (desc_new)
+			desc_new->chip_data = cfg_new;
 	}
 	return irq;
 }
 
+static int nr_irqs_gsi = NR_IRQS_LEGACY;
 int create_irq(void)
 {
+	unsigned int irq_want;
 	int irq;
 
-	irq = create_irq_nr(nr_irqs - 1);
+	irq_want = nr_irqs_gsi;
+	irq = create_irq_nr(irq_want);
 
 	if (irq == 0)
 		irq = -1;
@@ -2944,14 +3051,22 @@ int create_irq(void)
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
 
@@ -2966,12 +3081,12 @@ static int msi_compose_msg(struct pci_de
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
 
@@ -3029,35 +3144,35 @@ static int msi_compose_msg(struct pci_de
 #ifdef CONFIG_SMP
 static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
-	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
-	read_msi_msg(irq, &msg);
+	read_msi_msg_desc(desc, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
-	write_msi_msg(irq, &msg);
-	desc = irq_to_desc(irq);
+	write_msi_msg_desc(desc, &msg);
 	desc->affinity = mask;
 }
-
 #ifdef CONFIG_INTR_REMAP
 /*
  * Migrate the MSI irq to another cpumask. This migration is
@@ -3065,11 +3180,11 @@ static void set_msi_irq_affinity(unsigne
  */
 static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	unsigned int dest;
 	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
-	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -3078,10 +3193,12 @@ static void ir_set_msi_irq_affinity(unsi
 	if (get_irte(irq, &irte))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -3105,9 +3222,9 @@ static void ir_set_msi_irq_affinity(unsi
 		cfg->move_in_progress = 0;
 	}
 
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
+
 #endif
 #endif /* CONFIG_SMP */
 
@@ -3166,7 +3283,7 @@ static int msi_alloc_irte(struct pci_dev
 }
 #endif
 
-static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc, int irq)
+static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 {
 	int ret;
 	struct msi_msg msg;
@@ -3175,7 +3292,7 @@ static int setup_msi_irq(struct pci_dev
 	if (ret < 0)
 		return ret;
 
-	set_irq_msi(irq, desc);
+	set_irq_msi(irq, msidesc);
 	write_msi_msg(irq, &msg);
 
 #ifdef CONFIG_INTR_REMAP
@@ -3195,26 +3312,13 @@ static int setup_msi_irq(struct pci_dev
 	return 0;
 }
 
-static unsigned int build_irq_for_pci_dev(struct pci_dev *dev)
-{
-	unsigned int irq;
-
-	irq = dev->bus->number;
-	irq <<= 8;
-	irq |= dev->devfn;
-	irq <<= 12;
-
-	return irq;
-}
-
-int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
+int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc)
 {
 	unsigned int irq;
 	int ret;
 	unsigned int irq_want;
 
-	irq_want = build_irq_for_pci_dev(dev) + 0x100;
-
+	irq_want = nr_irqs_gsi;
 	irq = create_irq_nr(irq_want);
 	if (irq == 0)
 		return -1;
@@ -3228,7 +3332,7 @@ int arch_setup_msi_irq(struct pci_dev *d
 		goto error;
 no_ir:
 #endif
-	ret = setup_msi_irq(dev, desc, irq);
+	ret = setup_msi_irq(dev, msidesc, irq);
 	if (ret < 0) {
 		destroy_irq(irq);
 		return ret;
@@ -3246,7 +3350,7 @@ int arch_setup_msi_irqs(struct pci_dev *
 {
 	unsigned int irq;
 	int ret, sub_handle;
-	struct msi_desc *desc;
+	struct msi_desc *msidesc;
 	unsigned int irq_want;
 
 #ifdef CONFIG_INTR_REMAP
@@ -3254,10 +3358,11 @@ int arch_setup_msi_irqs(struct pci_dev *
 	int index = 0;
 #endif
 
-	irq_want = build_irq_for_pci_dev(dev) + 0x100;
+	irq_want = nr_irqs_gsi;
 	sub_handle = 0;
-	list_for_each_entry(desc, &dev->msi_list, list) {
-		irq = create_irq_nr(irq_want--);
+	list_for_each_entry(msidesc, &dev->msi_list, list) {
+		irq = create_irq_nr(irq_want);
+		irq_want++;
 		if (irq == 0)
 			return -1;
 #ifdef CONFIG_INTR_REMAP
@@ -3289,7 +3394,7 @@ int arch_setup_msi_irqs(struct pci_dev *
 		}
 no_ir:
 #endif
-		ret = setup_msi_irq(dev, desc, irq);
+		ret = setup_msi_irq(dev, msidesc, irq);
 		if (ret < 0)
 			goto error;
 		sub_handle++;
@@ -3310,20 +3415,22 @@ void arch_teardown_msi_irq(unsigned int
 #ifdef CONFIG_SMP
 static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
-	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -3335,9 +3442,9 @@ static void dmar_msi_set_affinity(unsign
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
+
 #endif /* CONFIG_SMP */
 
 struct irq_chip dmar_msi_type = {
@@ -3371,8 +3478,8 @@ int arch_setup_dmar_msi(unsigned int irq
 #ifdef CONFIG_SMP
 static void hpet_msi_set_affinity(unsigned int irq, cpumask_t mask)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
-	struct irq_desc *desc;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
@@ -3381,10 +3488,12 @@ static void hpet_msi_set_affinity(unsign
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -3396,9 +3505,9 @@ static void hpet_msi_set_affinity(unsign
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	hpet_msi_write(irq, &msg);
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
+
 #endif /* CONFIG_SMP */
 
 struct irq_chip hpet_msi_type = {
@@ -3453,26 +3562,28 @@ static void target_ht_irq(unsigned int i
 
 static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	unsigned int dest;
 	cpumask_t tmp;
-	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
 	target_ht_irq(irq, dest, cfg->vector);
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
+
 #endif
 
 static struct irq_chip ht_irq_chip = {
@@ -3492,13 +3603,13 @@ int arch_setup_ht_irq(unsigned int irq,
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
 
@@ -3544,7 +3655,9 @@ int arch_enable_uv_irq(char *irq_name, u
 	unsigned long flags;
 	int err;
 
-	err = assign_irq_vector(irq, *eligible_cpu);
+	cfg = irq_cfg(irq);
+
+	err = assign_irq_vector(irq, cfg, *eligible_cpu);
 	if (err != 0)
 		return err;
 
@@ -3553,8 +3666,6 @@ int arch_enable_uv_irq(char *irq_name, u
 				      irq_name);
 	spin_unlock_irqrestore(&vector_lock, flags);
 
-	cfg = irq_cfg(irq);
-
 	mmr_value = 0;
 	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
 	BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
@@ -3606,9 +3717,16 @@ int __init io_apic_get_redir_entries (in
 	return reg_01.bits.entries;
 }
 
-int __init probe_nr_irqs(void)
+void __init probe_nr_irqs_gsi(void)
 {
-	return NR_IRQS;
+	int idx;
+	int nr = 0;
+
+	for (idx = 0; idx < nr_ioapics; idx++)
+		nr += io_apic_get_redir_entries(idx) + 1;
+
+	if (nr > nr_irqs_gsi)
+		nr_irqs_gsi = nr;
 }
 
 /* --------------------------------------------------------------------------
@@ -3707,19 +3825,31 @@ int __init io_apic_get_version(int ioapi
 
 int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int polarity)
 {
+	struct irq_desc *desc;
+	struct irq_cfg *cfg;
+	int cpu = boot_cpu_id;
+
 	if (!IO_APIC_IRQ(irq)) {
 		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
 			ioapic);
 		return -EINVAL;
 	}
 
+	desc = irq_to_desc_alloc_cpu(irq, cpu);
+	if (!desc) {
+		printk(KERN_INFO "can not get irq_desc %d\n", irq);
+		return 0;
+	}
+
 	/*
 	 * IRQs < 16 are already in the irq_2_pin[] map
 	 */
-	if (irq >= 16)
-		add_pin_to_irq(irq, ioapic, pin);
+	if (irq >= NR_IRQS_LEGACY) {
+		cfg = desc->chip_data;
+		add_pin_to_irq_cpu(cfg, cpu, ioapic, pin);
+	}
 
-	setup_IO_APIC_irq(ioapic, pin, irq, triggering, polarity);
+	setup_IO_APIC_irq(ioapic, pin, irq, desc, triggering, polarity);
 
 	return 0;
 }
@@ -3773,9 +3903,10 @@ void __init setup_ioapic_dest(void)
 			 * when you have too many devices, because at that time only boot
 			 * cpu is online.
 			 */
-			cfg = irq_cfg(irq);
+			desc = irq_to_desc(irq);
+			cfg = desc->chip_data;
 			if (!cfg->vector) {
-				setup_IO_APIC_irq(ioapic, pin, irq,
+				setup_IO_APIC_irq(ioapic, pin, irq, desc,
 						  irq_trigger(irq_entry),
 						  irq_polarity(irq_entry));
 				continue;
@@ -3785,7 +3916,6 @@ void __init setup_ioapic_dest(void)
 			/*
 			 * Honour affinities which have been set in early boot
 			 */
-			desc = irq_to_desc(irq);
 			if (desc->status &
 			    (IRQ_NO_BALANCING | IRQ_AFFINITY_SET))
 				mask = desc->affinity;
@@ -3794,10 +3924,10 @@ void __init setup_ioapic_dest(void)
 
 #ifdef CONFIG_INTR_REMAP
 			if (intr_remapping_enabled)
-				set_ir_ioapic_affinity_irq(irq, mask);
+				set_ir_ioapic_affinity_irq_desc(desc, mask);
 			else
 #endif
-				set_ioapic_affinity_irq(irq, mask);
+				set_ioapic_affinity_irq_desc(desc, mask);
 		}
 
 	}
@@ -3846,7 +3976,6 @@ void __init ioapic_init_mappings(void)
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
@@ -76,8 +76,7 @@ void __init init_ISA_irqs(void)
 	init_bsp_APIC();
 	init_8259A(0);
 
-	for (i = 0; i < 16; i++) {
-		/* first time call this irq_desc */
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
 		struct irq_desc *desc = irq_to_desc(i);
 
 		desc->status = IRQ_DISABLED;
Index: linux-2.6/drivers/char/random.c
===================================================================
--- linux-2.6.orig/drivers/char/random.c
+++ linux-2.6/drivers/char/random.c
@@ -558,6 +558,8 @@ struct timer_rand_state {
 	unsigned dont_count_entropy:1;
 };
 
+#ifndef CONFIG_SPARSE_IRQ
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
 
+#ifndef CONFIG_SPARSE_IRQ
 	if (irq >= nr_irqs)
 		return;
+#endif
 
 	state = get_timer_rand_state(irq);
 
Index: linux-2.6/drivers/pci/intr_remapping.c
===================================================================
--- linux-2.6.orig/drivers/pci/intr_remapping.c
+++ linux-2.6/drivers/pci/intr_remapping.c
@@ -19,17 +19,75 @@ struct irq_2_iommu {
 	u8  irte_mask;
 };
 
-static struct irq_2_iommu irq_2_iommuX[NR_IRQS];
+#ifdef CONFIG_SPARSE_IRQ
+static struct irq_2_iommu *get_one_free_irq_2_iommu(int cpu)
+{
+	struct irq_2_iommu *iommu;
+	int node;
+
+	node = cpu_to_node(cpu);
+
+	iommu = kzalloc_node(sizeof(*iommu), GFP_ATOMIC, node);
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
+	if (WARN_ON_ONCE(!desc))
+		return NULL;
+
+	return desc->irq_2_iommu;
+}
+
+static struct irq_2_iommu *irq_2_iommu_alloc_cpu(unsigned int irq, int cpu)
+{
+	struct irq_desc *desc;
+	struct irq_2_iommu *irq_iommu;
+
+	/*
+	 * alloc irq desc if not allocated already.
+	 */
+	desc = irq_to_desc_alloc_cpu(irq, cpu);
+	if (!desc) {
+		printk(KERN_INFO "can not get irq_desc for %d\n", irq);
+		return NULL;
+	}
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
+	return irq_2_iommu_alloc_cpu(irq, boot_cpu_id);
 }
 
+#else /* !CONFIG_SPARSE_IRQ */
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
 static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
 {
 	return irq_2_iommu(irq);
 }
+#endif
 
 static DEFINE_SPINLOCK(irq_2_ir_lock);
 
@@ -86,9 +144,11 @@ int alloc_irte(struct intel_iommu *iommu
 	if (!count)
 		return -1;
 
+#ifndef CONFIG_SPARSE_IRQ
 	/* protect irq_2_iommu_alloc later */
 	if (irq >= nr_irqs)
 		return -1;
+#endif
 
 	/*
 	 * start the IRTE search from index 0.
@@ -130,6 +190,12 @@ int alloc_irte(struct intel_iommu *iommu
 		table->base[i].present = 1;
 
 	irq_iommu = irq_2_iommu_alloc(irq);
+	if (!irq_iommu) {
+		spin_unlock(&irq_2_ir_lock);
+		printk(KERN_ERR "can't allocate irq_2_iommu\n");
+		return -1;
+	}
+
 	irq_iommu->iommu = iommu;
 	irq_iommu->irte_index =  index;
 	irq_iommu->sub_handle = 0;
@@ -177,6 +243,12 @@ int set_irte_irq(int irq, struct intel_i
 
 	irq_iommu = irq_2_iommu_alloc(irq);
 
+	if (!irq_iommu) {
+		spin_unlock(&irq_2_ir_lock);
+		printk(KERN_ERR "can't allocate irq_2_iommu\n");
+		return -1;
+	}
+
 	irq_iommu->iommu = iommu;
 	irq_iommu->irte_index = index;
 	irq_iommu->sub_handle = subhandle;
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
 
+#ifdef CONFIG_SPARSE_IRQ
+		seq_printf(p, " %d:%u", j, per_irq_sum);
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
@@ -8,6 +8,23 @@
 /*
  * /proc/interrupts
  */
+#ifdef CONFIG_SPARSE_IRQ
+static void *int_seq_start(struct seq_file *f, loff_t *pos)
+{
+	rcu_read_lock();
+	return seq_list_start(&sparse_irqs_head, *pos);
+}
+
+static void *int_seq_next(struct seq_file *f, void *v, loff_t *pos)
+{
+	return seq_list_next(v, &sparse_irqs_head, pos);
+}
+
+static void int_seq_stop(struct seq_file *f, void *v)
+{
+	rcu_read_unlock();
+}
+#else
 static void *int_seq_start(struct seq_file *f, loff_t *pos)
 {
 	return (*pos <= nr_irqs) ? pos : NULL;
@@ -25,6 +42,7 @@ static void int_seq_stop(struct seq_file
 {
 	/* Nothing to do */
 }
+#endif
 
 static const struct seq_operations int_seq_ops = {
 	.start = int_seq_start,
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
  * @irq:		interrupt number for this descriptor
@@ -154,6 +156,14 @@ struct irq_chip {
  */
 struct irq_desc {
 	unsigned int		irq;
+#ifdef CONFIG_SPARSE_IRQ
+	struct list_head	list;
+	struct timer_rand_state *timer_rand_state;
+	unsigned int            *kstat_irqs;
+# ifdef CONFIG_INTR_REMAP
+	struct irq_2_iommu      *irq_2_iommu;
+# endif
+#endif
 	irq_flow_handler_t	handle_irq;
 	struct irq_chip		*chip;
 	struct msi_desc		*msi_desc;
@@ -181,14 +191,64 @@ struct irq_desc {
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
+extern void early_irq_init(void);
+extern void arch_early_irq_init(void);
+extern void arch_init_chip_data(struct irq_desc *desc, int cpu);
+extern void arch_init_copy_chip_data(struct irq_desc *old_desc,
+					struct irq_desc *desc, int cpu);
+extern void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc);
+
+#ifndef CONFIG_SPARSE_IRQ
 
 extern struct irq_desc irq_desc[NR_IRQS];
 
 static inline struct irq_desc *irq_to_desc(unsigned int irq)
 {
-	return (irq < nr_irqs) ? irq_desc + irq : NULL;
+	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
+}
+static inline struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
+{
+	return irq_to_desc(irq);
 }
 
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
+#else
+
+extern struct irq_desc *irq_to_desc(unsigned int irq);
+extern struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu);
+extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int cpu);
+
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
+
+#endif
+
 /*
  * Migration helpers for obsolete names, they will go away:
  */
@@ -380,6 +440,11 @@ extern int set_irq_msi(unsigned int irq,
 #define get_irq_data(irq)	(irq_to_desc(irq)->handler_data)
 #define get_irq_msi(irq)	(irq_to_desc(irq)->msi_desc)
 
+#define get_irq_desc_chip(desc)		((desc)->chip)
+#define get_irq_desc_chip_data(desc)	((desc)->chip_data)
+#define get_irq_desc_data(desc)		((desc)->handler_data)
+#define get_irq_desc_msi(desc)		((desc)->msi_desc)
+
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
 #endif /* !CONFIG_S390 */
Index: linux-2.6/include/linux/kernel_stat.h
===================================================================
--- linux-2.6.orig/include/linux/kernel_stat.h
+++ linux-2.6/include/linux/kernel_stat.h
@@ -28,7 +28,9 @@ struct cpu_usage_stat {
 
 struct kernel_stat {
 	struct cpu_usage_stat	cpustat;
-	unsigned int irqs[NR_IRQS];
+#ifndef CONFIG_SPARSE_IRQ
+       unsigned int irqs[NR_IRQS];
+#endif
 };
 
 DECLARE_PER_CPU(struct kernel_stat, kstat);
@@ -39,6 +41,10 @@ DECLARE_PER_CPU(struct kernel_stat, ksta
 
 extern unsigned long long nr_context_switches(void);
 
+#ifndef CONFIG_SPARSE_IRQ
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
 
+#ifndef CONFIG_SPARSE_IRQ
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
@@ -24,9 +24,10 @@
  */
 void dynamic_irq_init(unsigned int irq)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc *desc;
 	unsigned long flags;
 
+	desc = irq_to_desc(irq);
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
@@ -49,6 +56,164 @@ void handle_bad_irq(unsigned int irq, st
 int nr_irqs = NR_IRQS;
 EXPORT_SYMBOL_GPL(nr_irqs);
 
+void __init __attribute__((weak)) arch_early_irq_init(void)
+{
+}
+
+#ifdef CONFIG_SPARSE_IRQ
+static struct irq_desc irq_desc_init = {
+	.irq	    = -1,
+	.status	    = IRQ_DISABLED,
+	.chip	    = &no_irq_chip,
+	.handle_irq = handle_bad_irq,
+	.depth      = 1,
+	.lock       = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
+#ifdef CONFIG_SMP
+	.affinity   = CPU_MASK_ALL
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
+	node = cpu_to_node(cpu);
+	ptr = kzalloc_node(bytes, GFP_ATOMIC, node);
+	printk(KERN_DEBUG "  alloc kstat_irqs on cpu %d node %d\n", cpu, node);
+
+	if (ptr)
+		desc->kstat_irqs = (unsigned int *)ptr;
+}
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
+	if (!desc->kstat_irqs) {
+		printk(KERN_ERR "can not alloc kstat_irqs\n");
+		BUG_ON(1);
+	}
+	arch_init_chip_data(desc, cpu);
+}
+
+/*
+ * Protect the sparse_irqs:
+ */
+static DEFINE_SPINLOCK(sparse_irq_lock);
+LIST_HEAD(sparse_irqs_head);
+
+struct irq_desc *irq_desc_ptrs[NR_IRQS] __read_mostly;
+
+static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
+	[0 ... NR_IRQS_LEGACY-1] = {
+		.irq	    = -1,
+		.status	    = IRQ_DISABLED,
+		.chip	    = &no_irq_chip,
+		.handle_irq = handle_bad_irq,
+		.depth	    = 1,
+		.lock	    = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
+#ifdef CONFIG_SMP
+		.affinity   = CPU_MASK_ALL
+#endif
+	}
+};
+
+/* FIXME: use bootmem alloc ...*/
+static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
+
+void __init early_irq_init(void)
+{
+	struct irq_desc *desc;
+	int legacy_count;
+	int i;
+
+	desc = irq_desc_legacy;
+	legacy_count = ARRAY_SIZE(irq_desc_legacy);
+
+	for (i = 0; i < legacy_count; i++) {
+		desc[i].irq = i;
+		desc[i].kstat_irqs = kstat_irqs_legacy[i];
+
+		irq_desc_ptrs[i] = desc + i;
+		list_add_tail(&desc[i].list, &sparse_irqs_head);
+	}
+
+	for (i = legacy_count; i < NR_IRQS; i++)
+		irq_desc_ptrs[i] = NULL;
+
+	arch_early_irq_init();
+}
+
+struct irq_desc *irq_to_desc(unsigned int irq)
+{
+	if (irq >= NR_IRQS) {
+		printk(KERN_WARNING "irq >= NR_IRQS in irq_to_desc: %d %d\n",
+				irq, NR_IRQS);
+		WARN_ON(1);
+		return NULL;
+	}
+	return irq_desc_ptrs[irq];
+}
+
+struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
+{
+	struct irq_desc *desc;
+	unsigned long flags;
+	int node;
+
+	if (irq >= NR_IRQS) {
+		printk(KERN_WARNING "irq >= NR_IRQS in irq_to_desc_alloc: %d %d\n",
+				irq, NR_IRQS);
+		WARN_ON(1);
+		return NULL;
+	}
+
+	desc = irq_desc_ptrs[irq];
+	if (desc)
+		return desc;
+
+	spin_lock_irqsave(&sparse_irq_lock, flags);
+
+	/* We have to check it to avoid races with another CPU */
+	desc = irq_desc_ptrs[irq];
+	if (desc)
+		goto out_unlock;
+
+	node = cpu_to_node(cpu);
+	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
+	printk(KERN_DEBUG "  alloc irq_desc for %d on cpu %d node %d\n",
+		 irq, cpu, node);
+	if (!desc) {
+		printk(KERN_ERR "can not alloc irq_desc\n");
+		BUG_ON(1);
+	}
+	init_one_irq_desc(irq, desc, cpu);
+
+	irq_desc_ptrs[irq] = desc;
+	list_add_tail_rcu(&desc->list, &sparse_irqs_head);
+
+out_unlock:
+	spin_unlock_irqrestore(&sparse_irq_lock, flags);
+
+	return desc;
+}
+
+#else
+
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
 		.status = IRQ_DISABLED,
@@ -62,6 +227,8 @@ struct irq_desc irq_desc[NR_IRQS] __cach
 	}
 };
 
+#endif
+
 /*
  * What should we do if we get a hw irq event on an illegal vector?
  * Each architecture has to answer this themself.
@@ -261,17 +428,25 @@ out:
 
 
 #ifdef CONFIG_TRACE_IRQFLAGS
-/*
- * lockdep: we want to handle all irq_desc locks as a single lock-class:
- */
-static struct lock_class_key irq_desc_lock_class;
-
 void early_init_irq_lock_class(void)
 {
+#ifndef CONFIG_SPARSE_IRQ
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
+#ifdef CONFIG_SPARSE_IRQ
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
@@ -99,25 +99,37 @@ static int show_other_interrupts(struct
 int show_interrupts(struct seq_file *p, void *v)
 {
 	unsigned long flags, any_count = 0;
-	int i = *(loff_t *) v, j;
+	int i, j;
 	struct irqaction *action;
 	struct irq_desc *desc;
+	int head = 0;
 
+#ifdef CONFIG_SPARSE_IRQ
+	desc = list_entry(v, struct irq_desc, list);
+	i = desc->irq;
+	if (&desc->list == sparse_irqs_head.next)
+		head = 1;
+#else
+	i = *(loff_t *) v;
 	if (i > nr_irqs)
 		return 0;
 
 	if (i == nr_irqs)
 		return show_other_interrupts(p);
+	if (i == 0)
+		head = 1;
+
+	desc = irq_to_desc(i);
+#endif
 
 	/* print header */
-	if (i == 0) {
+	if (head) {
 		seq_printf(p, "           ");
 		for_each_online_cpu(j)
 			seq_printf(p, "CPU%-8d", j);
 		seq_putc(p, '\n');
 	}
 
-	desc = irq_to_desc(i);
 	spin_lock_irqsave(&desc->lock, flags);
 #ifndef CONFIG_SMP
 	any_count = kstat_irqs(i);
@@ -148,6 +160,12 @@ int show_interrupts(struct seq_file *p,
 	seq_putc(p, '\n');
 out:
 	spin_unlock_irqrestore(&desc->lock, flags);
+
+#ifdef CONFIG_SPARSE_IRQ
+	if (&desc->list == sparse_irqs_head.prev)
+		show_other_interrupts(p);
+#endif
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
+static inline early_sparse_irq_init(void)
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
@@ -125,7 +125,7 @@ void fixup_irqs(cpumask_t map)
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
@@ -542,6 +542,15 @@ void __init __weak thread_info_cache_ini
 {
 }
 
+void __init __weak arch_early_irq_init(void)
+{
+}
+
+void __init __weak early_irq_init(void)
+{
+	arch_early_irq_init();
+}
+
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
@@ -612,6 +621,8 @@ asmlinkage void __init start_kernel(void
 	sort_main_extable();
 	trap_init();
 	rcu_init();
+	/* init some links before init_ISA_irqs() */
+	early_irq_init();
 	init_IRQ();
 	pidhash_init();
 	init_timers();
Index: linux-2.6/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq_vectors.h
+++ linux-2.6/arch/x86/include/asm/irq_vectors.h
@@ -101,12 +101,23 @@
 #define LAST_VM86_IRQ		15
 #define invalid_vm86_irq(irq)	((irq) < 3 || (irq) > 15)
 
+#define NR_IRQS_LEGACY		16
+
 #if defined(CONFIG_X86_IO_APIC) && !defined(CONFIG_X86_VOYAGER)
+
+#ifndef CONFIG_SPARSE_IRQ
 # if NR_CPUS < MAX_IO_APICS
 #  define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
 # else
 #  define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS))
 # endif
+#else
+# if (8 * NR_CPUS) > (32 * MAX_IO_APICS)
+#  define NR_IRQS (NR_VECTORS + (8 * NR_CPUS))
+# else
+#  define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS))
+# endif
+#endif
 
 #elif defined(CONFIG_X86_VOYAGER)
 
Index: linux-2.6/drivers/pci/msi.c
===================================================================
--- linux-2.6.orig/drivers/pci/msi.c
+++ linux-2.6/drivers/pci/msi.c
@@ -103,11 +103,11 @@ static void msix_set_enable(struct pci_d
 	}
 }
 
-static void msix_flush_writes(unsigned int irq)
+static void msix_flush_writes(struct irq_desc *desc)
 {
 	struct msi_desc *entry;
 
-	entry = get_irq_msi(irq);
+	entry = get_irq_desc_msi(desc);
 	BUG_ON(!entry || !entry->dev);
 	switch (entry->msi_attrib.type) {
 	case PCI_CAP_ID_MSI:
@@ -135,11 +135,11 @@ static void msix_flush_writes(unsigned i
  * Returns 1 if it succeeded in masking the interrupt and 0 if the device
  * doesn't support MSI masking.
  */
-static int msi_set_mask_bits(unsigned int irq, u32 mask, u32 flag)
+static int msi_set_mask_bits(struct irq_desc *desc, u32 mask, u32 flag)
 {
 	struct msi_desc *entry;
 
-	entry = get_irq_msi(irq);
+	entry = get_irq_desc_msi(desc);
 	BUG_ON(!entry || !entry->dev);
 	switch (entry->msi_attrib.type) {
 	case PCI_CAP_ID_MSI:
@@ -172,9 +172,9 @@ static int msi_set_mask_bits(unsigned in
 	return 1;
 }
 
-void read_msi_msg(unsigned int irq, struct msi_msg *msg)
+void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
 {
-	struct msi_desc *entry = get_irq_msi(irq);
+	struct msi_desc *entry = get_irq_desc_msi(desc);
 	switch(entry->msi_attrib.type) {
 	case PCI_CAP_ID_MSI:
 	{
@@ -211,9 +211,16 @@ void read_msi_msg(unsigned int irq, stru
 	}
 }
 
-void write_msi_msg(unsigned int irq, struct msi_msg *msg)
+void read_msi_msg(unsigned int irq, struct msi_msg *msg)
 {
-	struct msi_desc *entry = get_irq_msi(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	read_msi_msg_desc(desc, msg);
+}
+
+void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
+{
+	struct msi_desc *entry = get_irq_desc_msi(desc);
 	switch (entry->msi_attrib.type) {
 	case PCI_CAP_ID_MSI:
 	{
@@ -252,21 +259,31 @@ void write_msi_msg(unsigned int irq, str
 	entry->msg = *msg;
 }
 
+void write_msi_msg(unsigned int irq, struct msi_msg *msg)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	write_msi_msg_desc(desc, msg);
+}
+
 void mask_msi_irq(unsigned int irq)
 {
-	msi_set_mask_bits(irq, 1, 1);
-	msix_flush_writes(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	msi_set_mask_bits(desc, 1, 1);
+	msix_flush_writes(desc);
 }
 
 void unmask_msi_irq(unsigned int irq)
 {
-	msi_set_mask_bits(irq, 1, 0);
-	msix_flush_writes(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	msi_set_mask_bits(desc, 1, 0);
+	msix_flush_writes(desc);
 }
 
 static int msi_free_irqs(struct pci_dev* dev);
 
-
 static struct msi_desc* alloc_msi_entry(void)
 {
 	struct msi_desc *entry;
@@ -303,9 +320,11 @@ static void __pci_restore_msi_state(stru
 	pci_intx_for_msi(dev, 0);
 	msi_set_enable(dev, 0);
 	write_msi_msg(dev->irq, &entry->msg);
-	if (entry->msi_attrib.maskbit)
-		msi_set_mask_bits(dev->irq, entry->msi_attrib.maskbits_mask,
+	if (entry->msi_attrib.maskbit) {
+		struct irq_desc *desc = irq_to_desc(dev->irq);
+		msi_set_mask_bits(desc, entry->msi_attrib.maskbits_mask,
 				  entry->msi_attrib.masked);
+	}
 
 	pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &control);
 	control &= ~PCI_MSI_FLAGS_QSIZE;
@@ -327,8 +346,9 @@ static void __pci_restore_msix_state(str
 	msix_set_enable(dev, 0);
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
+		struct irq_desc *desc = irq_to_desc(entry->irq);
 		write_msi_msg(entry->irq, &entry->msg);
-		msi_set_mask_bits(entry->irq, 1, entry->msi_attrib.masked);
+		msi_set_mask_bits(desc, 1, entry->msi_attrib.masked);
 	}
 
 	BUG_ON(list_empty(&dev->msi_list));
@@ -596,7 +616,8 @@ void pci_msi_shutdown(struct pci_dev* de
 	/* Return the the pci reset with msi irqs unmasked */
 	if (entry->msi_attrib.maskbit) {
 		u32 mask = entry->msi_attrib.maskbits_mask;
-		msi_set_mask_bits(dev->irq, mask, ~mask);
+		struct irq_desc *desc = irq_to_desc(dev->irq);
+		msi_set_mask_bits(desc, mask, ~mask);
 	}
 	if (!entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI)
 		return;
Index: linux-2.6/include/linux/msi.h
===================================================================
--- linux-2.6.orig/include/linux/msi.h
+++ linux-2.6/include/linux/msi.h
@@ -10,8 +10,11 @@ struct msi_msg {
 };
 
 /* Helper functions */
+struct irq_desc;
 extern void mask_msi_irq(unsigned int irq);
 extern void unmask_msi_irq(unsigned int irq);
+extern void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
+extern void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
 extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
 
Index: linux-2.6/arch/x86/include/asm/io_apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/io_apic.h
+++ linux-2.6/arch/x86/include/asm/io_apic.h
@@ -198,7 +198,7 @@ extern void restore_IO_APIC_setup(void);
 extern void reinit_intr_remapped_IO_APIC(int);
 #endif
 
-extern int probe_nr_irqs(void);
+extern void probe_nr_irqs_gsi(void);
 
 #else  /* !CONFIG_X86_IO_APIC */
 #define io_apic_assign_pci_irqs 0
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -953,7 +953,7 @@ void __init setup_arch(char **cmdline_p)
 	ioapic_init_mappings();
 
 	/* need to wait for io_apic is mapped */
-	nr_irqs = probe_nr_irqs();
+	probe_nr_irqs_gsi();
 
 	kvm_guest_init();
 

