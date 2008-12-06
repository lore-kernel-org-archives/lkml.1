Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbYLFC7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbYLFC7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 21:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYLFC66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 21:58:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:51310 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbYLFC64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 21:58:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=M8spbwtvKB51ozhtbpqhTMqq6KTk8u1YZaic+iTgDY+yJzLEa+AVQXjQf5JhSE/5Yl
         H9v1TWb8Wz/57G3evcKd6vo9YVXV2fID5TOUgfMWPLbuloVJmS8gJPI1kv3wpNSqRrND
         kqihffV2+GUGFaBGO+99N+270RqoJEKmrfNWc=
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/5] sparse irq enabling v5
Date: Fri,  5 Dec 2008 18:58:31 -0800
Message-Id: <1228532315-28799-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

impact: new feature sparseirq

add pointers array as Ingo suggesting.
remove dyna_array

when sparse_irq is used (CONFIG_SPARSE_IRQ), use kzalloc_node to get irq_desc, irq_cfg
  use desc->chip_data for x86 to store irq_cfg

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/Kconfig                   |   10 +
 arch/x86/include/asm/irq_vectors.h |    9 +
 arch/x86/kernel/io_apic.c          |  301 +++++++++++++++++++++++--------------
 arch/x86/kernel/irq.c              |    3 
 arch/x86/kernel/irq_32.c           |    2 
 arch/x86/kernel/irq_64.c           |    2 
 arch/x86/kernel/irqinit_32.c       |    1 
 arch/x86/kernel/irqinit_64.c       |    1 
 drivers/char/random.c              |   22 --
 drivers/pci/intr_remapping.c       |   76 +++++++++
 drivers/xen/events.c               |   12 -
 fs/proc/stat.c                     |   17 +-
 include/linux/interrupt.h          |    2 
 include/linux/irq.h                |   54 ++++++
 include/linux/irqnr.h              |   14 -
 include/linux/kernel_stat.h        |   14 +
 include/linux/random.h             |   51 ++++++
 init/main.c                        |   11 +
 kernel/irq/autoprobe.c             |   15 +
 kernel/irq/chip.c                  |    3 
 kernel/irq/handle.c                |  181 +++++++++++++++++++++-
 kernel/irq/proc.c                  |    6 
 kernel/irq/spurious.c              |    5 
 23 files changed, 649 insertions(+), 163 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -243,6 +243,16 @@ config X86_HAS_BOOT_CPU_ID
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
Index: linux-2.6/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq_vectors.h
+++ linux-2.6/arch/x86/include/asm/irq_vectors.h
@@ -102,11 +102,20 @@
 #define invalid_vm86_irq(irq)	((irq) < 3 || (irq) > 15)
 
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
@@ -119,83 +144,93 @@ struct irq_cfg {
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
-}
+	struct irq_cfg *cfg;
+	struct irq_desc *desc;
+	int count;
+	int i;
 
-static struct irq_cfg *irq_cfg_alloc(unsigned int irq)
-{
-	return irq_cfg(irq);
-}
+	cfg = irq_cfgx;
+	count = ARRAY_SIZE(irq_cfgx);
 
-/*
- * Rough estimation of how many shared IRQs there are, can be changed
- * anytime.
- */
-#define MAX_PLUS_SHARED_IRQS NR_IRQS
-#define PIN_MAP_SIZE (MAX_PLUS_SHARED_IRQS + NR_IRQS)
+	for (i = 0; i < count; i++) {
+		desc = irq_to_desc(i);
+		desc->chip_data = &cfg[i];
+	}
+}
 
-/*
- * This is performance-critical, we want to do it O(1)
- *
- * the indexing order of this array favors 1:1 mappings
- * between pins and IRQs.
- */
+#ifdef CONFIG_SPARSE_IRQ
+static struct irq_cfg *irq_cfg(unsigned int irq)
+{
+	struct irq_cfg *cfg = NULL;
+	struct irq_desc *desc;
 
-struct irq_pin_list {
-	int apic, pin;
-	struct irq_pin_list *next;
-};
+	desc = irq_to_desc(irq);
+	if (desc)
+		cfg = desc->chip_data;
 
-static struct irq_pin_list irq_2_pin_head[PIN_MAP_SIZE];
-static struct irq_pin_list *irq_2_pin_ptr;
+	return cfg;
+}
 
-static void __init irq_2_pin_init(void)
+static struct irq_cfg *get_one_free_irq_cfg(int cpu)
 {
-	struct irq_pin_list *pin = irq_2_pin_head;
-	int i;
+	struct irq_cfg *cfg;
+	int node;
+
+	node = cpu_to_node(cpu);
 
-	for (i = 1; i < PIN_MAP_SIZE; i++)
-		pin[i-1].next = &pin[i];
+	cfg = kzalloc_node(sizeof(*cfg), GFP_ATOMIC, node);
+	printk(KERN_DEBUG "  alloc irq_cfg on cpu %d node %d\n", cpu, node);
 
-	irq_2_pin_ptr = &pin[0];
+	return cfg;
 }
 
-static struct irq_pin_list *get_one_free_irq_2_pin(void)
+void arch_init_chip_data(struct irq_desc *desc, int cpu)
 {
-	struct irq_pin_list *pin = irq_2_pin_ptr;
+	struct irq_cfg *cfg;
 
-	if (!pin)
-		panic("can not get more irq_2_pin\n");
+	cfg = desc->chip_data;
+	if (!cfg) {
+		desc->chip_data = get_one_free_irq_cfg(cpu);
+		if (!desc->chip_data) {
+			printk(KERN_ERR "can not alloc irq_cfg\n");
+			BUG_ON(1);
+		}
+	}
+}
 
-	irq_2_pin_ptr = pin->next;
-	pin->next = NULL;
-	return pin;
+#else
+static struct irq_cfg *irq_cfg(unsigned int irq)
+{
+	return irq < nr_irqs ? irq_cfgx + irq : NULL;
 }
 
+#endif
+
 struct io_apic {
 	unsigned int index;
 	unsigned int unused[3];
@@ -397,16 +432,19 @@ static void set_ioapic_affinity_irq(unsi
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
-static void add_pin_to_irq(unsigned int irq, int apic, int pin)
+static void add_pin_to_irq_cpu(unsigned int irq, int cpu, int apic, int pin)
 {
-	struct irq_cfg *cfg;
 	struct irq_pin_list *entry;
+	struct irq_cfg *cfg = irq_cfg(irq);
 
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
@@ -421,7 +459,7 @@ static void add_pin_to_irq(unsigned int
 		entry = entry->next;
 	}
 
-	entry->next = get_one_free_irq_2_pin();
+	entry->next = get_one_free_irq_2_pin(cpu);
 	entry = entry->next;
 	entry->apic = apic;
 	entry->pin = pin;
@@ -430,7 +468,7 @@ static void add_pin_to_irq(unsigned int
 /*
  * Reroute an IRQ to a different pin.
  */
-static void __init replace_pin_at_irq(unsigned int irq,
+static void __init replace_pin_at_irq(unsigned int irq, int cpu,
 				      int oldapic, int oldpin,
 				      int newapic, int newpin)
 {
@@ -451,7 +489,7 @@ static void __init replace_pin_at_irq(un
 
 	/* why? call replace before add? */
 	if (!replaced)
-		add_pin_to_irq(irq, newapic, newpin);
+		add_pin_to_irq_cpu(irq, cpu, newapic, newpin);
 }
 
 static inline void io_apic_modify_irq(unsigned int irq,
@@ -1162,9 +1200,13 @@ void __setup_vector_irq(int cpu)
 	/* This function must be called with vector_lock held */
 	int irq, vector;
 	struct irq_cfg *cfg;
+	struct irq_desc *desc;
 
 	/* Mark the inuse vectors */
-	for_each_irq_cfg(irq, cfg) {
+	for_each_irq_desc(irq, desc) {
+		if (!desc)
+			continue;
+		cfg = desc->chip_data;
 		if (!cpu_isset(cpu, cfg->domain))
 			continue;
 		vector = cfg->vector;
@@ -1356,6 +1398,8 @@ static void __init setup_IO_APIC_irqs(vo
 {
 	int apic, pin, idx, irq;
 	int notcon = 0;
+	struct irq_desc *desc;
+	int cpu = boot_cpu_id;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
@@ -1387,7 +1431,12 @@ static void __init setup_IO_APIC_irqs(vo
 			if (multi_timer_check(apic, irq))
 				continue;
 #endif
-			add_pin_to_irq(irq, apic, pin);
+			desc = irq_to_desc_alloc_cpu(irq, cpu);
+			if (!desc) {
+				printk(KERN_INFO "can not get irq_desc for %d\n", irq);
+				continue;
+			}
+			add_pin_to_irq_cpu(irq, cpu, apic, pin);
 
 			setup_IO_APIC_irq(apic, pin, irq,
 					irq_trigger(idx), irq_polarity(idx));
@@ -1448,6 +1497,7 @@ __apicdebuginit(void) print_IO_APIC(void
 	union IO_APIC_reg_03 reg_03;
 	unsigned long flags;
 	struct irq_cfg *cfg;
+	struct irq_desc *desc;
 	unsigned int irq;
 
 	if (apic_verbosity == APIC_QUIET)
@@ -1537,8 +1587,13 @@ __apicdebuginit(void) print_IO_APIC(void
 	}
 	}
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
-	for_each_irq_cfg(irq, cfg) {
-		struct irq_pin_list *entry = cfg->irq_2_pin;
+	for_each_irq_desc(irq, desc) {
+		struct irq_pin_list *entry;
+
+		if (!desc)
+			continue;
+		cfg = desc->chip_data;
+		entry = cfg->irq_2_pin;
 		if (!entry)
 			continue;
 		printk(KERN_DEBUG "IRQ%d ", irq);
@@ -2022,6 +2077,7 @@ static unsigned int startup_ioapic_irq(u
 {
 	int was_pending = 0;
 	unsigned long flags;
+	struct irq_cfg *cfg;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	if (irq < 16) {
@@ -2029,6 +2085,7 @@ static unsigned int startup_ioapic_irq(u
 		if (i8259A_irq_pending(irq))
 			was_pending = 1;
 	}
+	cfg = irq_cfg(irq);
 	__unmask_IO_APIC_irq(irq);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
@@ -2178,6 +2235,9 @@ static void ir_irq_migration(struct work
 	struct irq_desc *desc;
 
 	for_each_irq_desc(irq, desc) {
+		if (!desc)
+			continue;
+
 		if (desc->status & IRQ_MOVE_PENDING) {
 			unsigned long flags;
 
@@ -2229,6 +2289,9 @@ asmlinkage void smp_irq_move_cleanup_int
 		struct irq_cfg *cfg;
 		irq = __get_cpu_var(vector_irq)[vector];
 
+		if (irq == -1)
+			continue;
+
 		desc = irq_to_desc(irq);
 		if (!desc)
 			continue;
@@ -2430,8 +2493,12 @@ static inline void init_IO_APIC_traps(vo
 	 * Also, we've got to be careful not to trash gate
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
-	for_each_irq_cfg(irq, cfg) {
-		if (IO_APIC_IRQ(irq) && !cfg->vector) {
+	for_each_irq_desc(irq, desc) {
+		if (!desc)
+			continue;
+
+		cfg = desc->chip_data;
+		if (IO_APIC_IRQ(irq) && cfg && !cfg->vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
 			 * so default to an old-fashioned 8259
@@ -2439,11 +2506,9 @@ static inline void init_IO_APIC_traps(vo
 			 */
 			if (irq < 16)
 				make_8259A_irq(irq);
-			else {
-				desc = irq_to_desc(irq);
+			else
 				/* Strange. Oh, well.. */
 				desc->chip = &no_irq_chip;
-			}
 		}
 	}
 }
@@ -2654,7 +2719,7 @@ static inline void __init check_timer(vo
 		 * Ok, does IRQ0 through the IOAPIC work?
 		 */
 		if (no_pin1) {
-			add_pin_to_irq(0, apic1, pin1);
+			add_pin_to_irq_cpu(0, boot_cpu_id, apic1, pin1);
 			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
 		}
 		unmask_IO_APIC_irq(0);
@@ -2683,7 +2748,7 @@ static inline void __init check_timer(vo
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
-		replace_pin_at_irq(0, apic1, pin1, apic2, pin2);
+		replace_pin_at_irq(0, boot_cpu_id, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
 		unmask_IO_APIC_irq(0);
 		enable_8259A_irq(0);
@@ -2902,21 +2967,25 @@ unsigned int create_irq_nr(unsigned int
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
 	for (new = irq_want; new > 0; new--) {
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
 		if (__assign_irq_vector(new, TARGET_CPUS) == 0)
 			irq = new;
 		break;
@@ -2925,6 +2994,9 @@ unsigned int create_irq_nr(unsigned int
 
 	if (irq > 0) {
 		dynamic_irq_init(irq);
+		/* restore it, in case dynamic_irq_init clear it */
+		if (desc_new)
+			desc_new->chip_data = cfg_new;
 	}
 	return irq;
 }
@@ -2944,8 +3016,16 @@ int create_irq(void)
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
@@ -3195,26 +3275,13 @@ static int setup_msi_irq(struct pci_dev
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
+	irq_want = nr_irqs - 1;
 	irq = create_irq_nr(irq_want);
 	if (irq == 0)
 		return -1;
@@ -3228,7 +3295,7 @@ int arch_setup_msi_irq(struct pci_dev *d
 		goto error;
 no_ir:
 #endif
-	ret = setup_msi_irq(dev, desc, irq);
+	ret = setup_msi_irq(dev, msidesc, irq);
 	if (ret < 0) {
 		destroy_irq(irq);
 		return ret;
@@ -3246,7 +3313,7 @@ int arch_setup_msi_irqs(struct pci_dev *
 {
 	unsigned int irq;
 	int ret, sub_handle;
-	struct msi_desc *desc;
+	struct msi_desc *msidesc;
 	unsigned int irq_want;
 
 #ifdef CONFIG_INTR_REMAP
@@ -3254,10 +3321,11 @@ int arch_setup_msi_irqs(struct pci_dev *
 	int index = 0;
 #endif
 
-	irq_want = build_irq_for_pci_dev(dev) + 0x100;
+	irq_want = nr_irqs - 1;
 	sub_handle = 0;
-	list_for_each_entry(desc, &dev->msi_list, list) {
-		irq = create_irq_nr(irq_want--);
+	list_for_each_entry(msidesc, &dev->msi_list, list) {
+		irq = create_irq_nr(irq_want);
+		irq_want--;
 		if (irq == 0)
 			return -1;
 #ifdef CONFIG_INTR_REMAP
@@ -3289,7 +3357,7 @@ int arch_setup_msi_irqs(struct pci_dev *
 		}
 no_ir:
 #endif
-		ret = setup_msi_irq(dev, desc, irq);
+		ret = setup_msi_irq(dev, msidesc, irq);
 		if (ret < 0)
 			goto error;
 		sub_handle++;
@@ -3707,17 +3775,29 @@ int __init io_apic_get_version(int ioapi
 
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
+	if (irq >= 16) {
+		cfg = desc->chip_data;
+		add_pin_to_irq_cpu(irq, cpu, ioapic, pin);
+	}
 
 	setup_IO_APIC_irq(ioapic, pin, irq, triggering, polarity);
 
@@ -3773,7 +3853,8 @@ void __init setup_ioapic_dest(void)
 			 * when you have too many devices, because at that time only boot
 			 * cpu is online.
 			 */
-			cfg = irq_cfg(irq);
+			desc = irq_to_desc(irq);
+			cfg = desc->chip_data;
 			if (!cfg->vector) {
 				setup_IO_APIC_irq(ioapic, pin, irq,
 						  irq_trigger(irq_entry),
@@ -3785,7 +3866,6 @@ void __init setup_ioapic_dest(void)
 			/*
 			 * Honour affinities which have been set in early boot
 			 */
-			desc = irq_to_desc(irq);
 			if (desc->status &
 			    (IRQ_NO_BALANCING | IRQ_AFFINITY_SET))
 				mask = desc->affinity;
@@ -3846,7 +3926,6 @@ void __init ioapic_init_mappings(void)
 	struct resource *ioapic_res;
 	int i;
 
-	irq_2_pin_init();
 	ioapic_res = ioapic_setup_resources();
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
Index: linux-2.6/arch/x86/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq.c
+++ linux-2.6/arch/x86/kernel/irq.c
@@ -118,6 +118,9 @@ int show_interrupts(struct seq_file *p,
 	}
 
 	desc = irq_to_desc(i);
+	if (!desc)
+		return 0;
+
 	spin_lock_irqsave(&desc->lock, flags);
 #ifndef CONFIG_SMP
 	any_count = kstat_irqs(i);
Index: linux-2.6/arch/x86/kernel/irq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq_32.c
+++ linux-2.6/arch/x86/kernel/irq_32.c
@@ -242,6 +242,8 @@ void fixup_irqs(cpumask_t map)
 	for_each_irq_desc(irq, desc) {
 		cpumask_t mask;
 
+		if (!desc)
+			continue;
 		if (irq == 2)
 			continue;
 
Index: linux-2.6/arch/x86/kernel/irq_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq_64.c
+++ linux-2.6/arch/x86/kernel/irq_64.c
@@ -90,6 +90,8 @@ void fixup_irqs(cpumask_t map)
 		int break_affinity = 0;
 		int set_affinity = 1;
 
+		if (!desc)
+			continue;
 		if (irq == 2)
 			continue;
 
Index: linux-2.6/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_32.c
+++ linux-2.6/arch/x86/kernel/irqinit_32.c
@@ -69,7 +69,6 @@ void __init init_ISA_irqs (void)
 	 * 16 old-style INTA-cycle interrupts:
 	 */
 	for (i = 0; i < 16; i++) {
-		/* first time call this irq_desc */
 		struct irq_desc *desc = irq_to_desc(i);
 
 		desc->status = IRQ_DISABLED;
Index: linux-2.6/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_64.c
+++ linux-2.6/arch/x86/kernel/irqinit_64.c
@@ -77,7 +77,6 @@ void __init init_ISA_irqs(void)
 	init_8259A(0);
 
 	for (i = 0; i < 16; i++) {
-		/* first time call this irq_desc */
 		struct irq_desc *desc = irq_to_desc(i);
 
 		desc->status = IRQ_DISABLED;
Index: linux-2.6/drivers/char/random.c
===================================================================
--- linux-2.6.orig/drivers/char/random.c
+++ linux-2.6/drivers/char/random.c
@@ -558,23 +558,9 @@ struct timer_rand_state {
 	unsigned dont_count_entropy:1;
 };
 
-static struct timer_rand_state *irq_timer_state[NR_IRQS];
-
-static struct timer_rand_state *get_timer_rand_state(unsigned int irq)
-{
-	if (irq >= nr_irqs)
-		return NULL;
-
-	return irq_timer_state[irq];
-}
-
-static void set_timer_rand_state(unsigned int irq, struct timer_rand_state *state)
-{
-	if (irq >= nr_irqs)
-		return;
-
-	irq_timer_state[irq] = state;
-}
+#ifndef CONFIG_SPARSE_IRQ
+struct timer_rand_state *irq_timer_state[NR_IRQS];
+#endif
 
 static struct timer_rand_state input_timer_state;
 
@@ -933,8 +919,10 @@ void rand_initialize_irq(int irq)
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
@@ -141,8 +141,12 @@ static void init_evtchn_cpu_bindings(voi
 	int i;
 
 	/* By default all event channels notify CPU#0. */
-	for_each_irq_desc(i, desc)
+	for_each_irq_desc(i, desc) {
+		if (!desc)
+			continue;
+
 		desc->affinity = cpumask_of_cpu(0);
+	}
 #endif
 
 	memset(cpu_evtchn, 0, sizeof(cpu_evtchn));
@@ -231,7 +235,7 @@ static int find_unbound_irq(void)
 	int irq;
 
 	/* Only allocate from dynirq range */
-	for_each_irq_nr(irq)
+	for (irq = 0; irq < nr_irqs; irq++)
 		if (irq_bindcount[irq] == 0)
 			break;
 
@@ -792,7 +796,7 @@ void xen_irq_resume(void)
 		mask_evtchn(evtchn);
 
 	/* No IRQ <-> event-channel mappings. */
-	for_each_irq_nr(irq)
+	for (irq = 0; irq < nr_irqs; irq++)
 		irq_info[irq].evtchn = 0; /* zap event-channel binding */
 
 	for (evtchn = 0; evtchn < NR_EVENT_CHANNELS; evtchn++)
@@ -824,7 +828,7 @@ void __init xen_init_IRQ(void)
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
@@ -27,6 +27,7 @@ static int show_stat(struct seq_file *p,
 	u64 sum = 0;
 	struct timespec boottime;
 	unsigned int per_irq_sum;
+	struct irq_desc *desc;
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
@@ -44,10 +45,11 @@ static int show_stat(struct seq_file *p,
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-
-		for_each_irq_nr(j)
+		for_each_irq_desc(j, desc) {
+			if (!desc)
+				continue;
 			sum += kstat_irqs_cpu(j, i);
-
+		}
 		sum += arch_irq_stat_cpu(i);
 	}
 	sum += arch_irq_stat();
@@ -90,11 +92,14 @@ static int show_stat(struct seq_file *p,
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
 	/* sum again ? it could be updated? */
-	for_each_irq_nr(j) {
+	for (j = 0; j < NR_IRQS; j++) {
+		desc = irq_to_desc(j);
 		per_irq_sum = 0;
 
-		for_each_possible_cpu(i)
-			per_irq_sum += kstat_irqs_cpu(j, i);
+		if (desc) {
+			for_each_possible_cpu(i)
+				per_irq_sum += kstat_irqs_cpu(j, i);
+		}
 
 		seq_printf(p, " %u", per_irq_sum);
 	}
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
@@ -154,6 +156,13 @@ struct irq_chip {
  */
 struct irq_desc {
 	unsigned int		irq;
+#ifdef CONFIG_SPARSE_IRQ
+	struct timer_rand_state *timer_rand_state;
+	unsigned int            *kstat_irqs;
+# ifdef CONFIG_INTR_REMAP
+	struct irq_2_iommu      *irq_2_iommu;
+# endif
+#endif
 	irq_flow_handler_t	handle_irq;
 	struct irq_chip		*chip;
 	struct msi_desc		*msi_desc;
@@ -181,14 +190,52 @@ struct irq_desc {
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
+#endif
+
+#else
+
+extern struct irq_desc *irq_to_desc(unsigned int irq);
+extern struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu);
+extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int cpu);
+
+# define for_each_irq_desc(irq, desc)		\
+	for (irq = 0, desc = irq_to_desc(irq); irq < nr_irqs; irq++, desc = irq_to_desc(irq))
+# define for_each_irq_desc_reverse(irq, desc)                          \
+	for (irq = nr_irqs - 1, desc = irq_to_desc(irq); irq >= 0; irq--, desc = irq_to_desc(irq))
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
@@ -380,6 +427,11 @@ extern int set_irq_msi(unsigned int irq,
 #define get_irq_data(irq)	(irq_to_desc(irq)->handler_data)
 #define get_irq_msi(irq)	(irq_to_desc(irq)->msi_desc)
 
+#define get_irq_desc_chip(desc)		((desc)->chip)
+#define get_irq_desc_chip_data(desc)	((desc)->chip_data)
+#define get_irq_desc_data(desc)		((desc)->handler_data)
+#define get_irq_desc_msi(desc)		((desc)->msi_desc)
+
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
 #endif /* !CONFIG_S390 */
Index: linux-2.6/include/linux/irqnr.h
===================================================================
--- linux-2.6.orig/include/linux/irqnr.h
+++ linux-2.6/include/linux/irqnr.h
@@ -7,18 +7,10 @@
 
 # define for_each_irq_desc(irq, desc)		\
 	for (irq = 0; irq < nr_irqs; irq++)
-#else
-extern int nr_irqs;
 
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
Index: linux-2.6/include/linux/random.h
===================================================================
--- linux-2.6.orig/include/linux/random.h
+++ linux-2.6/include/linux/random.h
@@ -44,6 +44,57 @@ struct rand_pool_info {
 
 extern void rand_initialize_irq(int irq);
 
+struct timer_rand_state;
+#ifndef CONFIG_SPARSE_IRQ
+
+extern struct timer_rand_state *irq_timer_state[];
+
+extern int nr_irqs;
+static inline struct timer_rand_state *get_timer_rand_state(unsigned int irq)
+{
+	if (irq >= nr_irqs)
+		return NULL;
+
+	return irq_timer_state[irq];
+}
+
+static inline void set_timer_rand_state(unsigned int irq, struct timer_rand_state *state)
+{
+	if (irq >= nr_irqs)
+		return;
+
+	irq_timer_state[irq] = state;
+}
+
+#else
+
+#include <linux/irq.h>
+static inline struct timer_rand_state *get_timer_rand_state(unsigned int irq)
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
+static inline void set_timer_rand_state(unsigned int irq, struct timer_rand_state *state)
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
+
 extern void add_input_randomness(unsigned int type, unsigned int code,
 				 unsigned int value);
 extern void add_interrupt_randomness(int irq);
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
Index: linux-2.6/kernel/irq/autoprobe.c
===================================================================
--- linux-2.6.orig/kernel/irq/autoprobe.c
+++ linux-2.6/kernel/irq/autoprobe.c
@@ -40,6 +40,9 @@ unsigned long probe_irq_on(void)
 	 * flush such a longstanding irq before considering it as spurious.
 	 */
 	for_each_irq_desc_reverse(i, desc) {
+		if (!desc)
+			continue;
+
 		spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			/*
@@ -68,6 +71,9 @@ unsigned long probe_irq_on(void)
 	 * happened in the previous stage, it may have masked itself)
 	 */
 	for_each_irq_desc_reverse(i, desc) {
+		if (!desc)
+			continue;
+
 		spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			desc->status |= IRQ_AUTODETECT | IRQ_WAITING;
@@ -86,6 +92,9 @@ unsigned long probe_irq_on(void)
 	 * Now filter out any obviously spurious interrupts
 	 */
 	for_each_irq_desc(i, desc) {
+		if (!desc)
+			continue;
+
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
@@ -124,6 +133,9 @@ unsigned int probe_irq_mask(unsigned lon
 	int i;
 
 	for_each_irq_desc(i, desc) {
+		if (!desc)
+			continue;
+
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
@@ -166,6 +178,9 @@ int probe_irq_off(unsigned long val)
 	unsigned int status;
 
 	for_each_irq_desc(i, desc) {
+		if (!desc)
+			continue;
+
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
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
@@ -49,6 +56,155 @@ void handle_bad_irq(unsigned int irq, st
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
+
+struct irq_desc *irq_desc_ptrs[NR_IRQS] __read_mostly;
+
+static struct irq_desc irq_desc_legacy[16] __cacheline_aligned_in_smp = {
+	[0 ... 15] = {
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
+static unsigned int kstat_irqs_legacy[16][NR_CPUS];
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
+	return (irq < NR_IRQS) ? irq_desc_ptrs[irq] : NULL;
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
@@ -62,6 +218,8 @@ struct irq_desc irq_desc[NR_IRQS] __cach
 	}
 };
 
+#endif
+
 /*
  * What should we do if we get a hw irq event on an illegal vector?
  * Each architecture has to answer this themself.
@@ -261,17 +419,28 @@ out:
 
 
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
+		if (!desc)
+			continue;
+
 		lockdep_set_class(&desc->lock, &irq_desc_lock_class);
+	}
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
Index: linux-2.6/kernel/irq/proc.c
===================================================================
--- linux-2.6.orig/kernel/irq/proc.c
+++ linux-2.6/kernel/irq/proc.c
@@ -243,7 +243,11 @@ void init_irq_proc(void)
 	/*
 	 * Create entries for all existing IRQs.
 	 */
-	for_each_irq_desc(irq, desc)
+	for_each_irq_desc(irq, desc) {
+		if (!desc)
+			continue;
+
 		register_irq_proc(irq, desc);
+	}
 }
 
Index: linux-2.6/kernel/irq/spurious.c
===================================================================
--- linux-2.6.orig/kernel/irq/spurious.c
+++ linux-2.6/kernel/irq/spurious.c
@@ -91,6 +91,9 @@ static int misrouted_irq(int irq)
 	int i, ok = 0;
 
 	for_each_irq_desc(i, desc) {
+		if (!desc)
+			continue;
+
 		if (!i)
 			 continue;
 
@@ -112,6 +115,8 @@ static void poll_spurious_irqs(unsigned
 	for_each_irq_desc(i, desc) {
 		unsigned int status;
 
+		if (!desc)
+			continue;
 		if (!i)
 			 continue;
 
