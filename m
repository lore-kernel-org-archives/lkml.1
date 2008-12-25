Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbYLYQIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbYLYQIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 11:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYLYQIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 11:08:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43029 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbYLYQIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 11:08:06 -0500
Date: Thu, 25 Dec 2008 17:07:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [git pull] sparseirq / irq updates for v2.6.29
Message-ID: <20081225160741.GA14486@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.3 required=5.9 tests=BAYES_00,FRT_LEVITRA autolearn=no SpamAssassin version=3.2.3
	1.8 FRT_LEVITRA            BODY: ReplaceTags: Levitra
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-core-for-linus

Most of the changes here are related to enable and implement sparseirq 
support on x86.

This feature changes the 'struct irq_desc irq_desc[NR_IRQS]' array into 
'struct irq_desc *irq_desc[NR_IRQS]' array, with full compatibility to 
architectures that have not implemented sparse IRQ support yet, or do not 
need (or want) this IRQ array layout.

This is done to allow distributions to set CONFIG_NR_CPUS to 4096 in their 
generic x86 kernels, without having the overhead of multi-megabyte static 
[NR_IRQS] dimensioned arrays in the kernel.

There's also performance advantage on NUMA (irq_desc / irq_cfg array 
entries are better separated between CPUs), and a bit of RAM savings on 
embedded systems. (which can now save a few bytes by not having an 
irq_desc allocated for IRQs that are not present)

Because NR_IRQS can now go up to a ridiculous upper limit, a weakness of 
MSI virtual IRQ numbering has become more pronounced and had to be fixed: 
the previous way of counting down from NR_IRQS downwards was confusing and 
ugly as well - resulting in very high IRQ numbers.

The new numbering scheme is more static and more human-compatible: it 
counts up from the end of the GSI IRQ range (which is at around ~256, 
slightly dependent on static factors such as the maximum # of IO-APICs 
supported). High IRQ numbers will only be seen in really large systems 
that have that many IRQ sources.

Jesse saw those changes to drivers/pci/ and tentatively agreed with them.

(This tree merges without conflicts with the x86 and tracing trees - in 
any ordering.)

Thanks,

	Ingo

------------------>
David Brownell (1):
      genirq: record IRQ_LEVEL in irq_desc[]

Ingo Molnar (5):
      sparseirq: fix typo in !CONFIG_IO_APIC case
      sparse irqs: handle !GENIRQ platforms
      sparse irqs: add irqnr.h to the user headers list
      x86: turn CONFIG_SPARSE_IRQ off by default
      x86, sparseirq: clean up Kconfig entry

Jeremy Fitzhardinge (1):
      sparseirq, xen: make sure irq_desc is allocated for interrupts

KOSAKI Motohiro (2):
      proc: enclose desc variable of show_stat() in CONFIG_SPARSE_IRQ
      locking, irq: enclose irq_desc_lock_class in CONFIG_LOCKDEP

Richard Kennedy (1):
      irq.h: remove padding from irq_desc on 64bits

Yinghai Lu (10):
      sparse irq_desc[] array: core kernel and x86 changes
      x86: use NR_IRQS_LEGACY
      x86: MSI start irq numbering from nr_irqs_gsi
      x86, MSI: pass irq_cfg and irq_desc
      sparseirq: fix Alpha build failure
      sparseirq: fix !SMP && !PCI_MSI && !HT_IRQ build
      x86, sparseirq: move irq_desc according to smp_affinity, v7
      sparseirq: fix !SMP building, #2
      sparseirq: add kernel-doc notation for new member in irq_desc, -v2
      sparseirq: fix numa_migrate_irq_desc dependency and comments


 arch/x86/Kconfig                   |   22 +
 arch/x86/include/asm/io_apic.h     |    9 +-
 arch/x86/include/asm/irq_vectors.h |   11 +
 arch/x86/kernel/io_apic.c          |  761 ++++++++++++++++++++++++------------
 arch/x86/kernel/irq.c              |    3 +
 arch/x86/kernel/irq_32.c           |    2 +
 arch/x86/kernel/irq_64.c           |    2 +
 arch/x86/kernel/irqinit_32.c       |    3 +-
 arch/x86/kernel/irqinit_64.c       |    3 +-
 arch/x86/kernel/setup.c            |    2 +-
 drivers/char/random.c              |   22 +-
 drivers/pci/intr_remapping.c       |   77 ++++-
 drivers/pci/msi.c                  |   55 ++-
 drivers/xen/events.c               |   17 +-
 fs/proc/stat.c                     |   16 +-
 include/linux/Kbuild               |    1 +
 include/linux/interrupt.h          |    2 +
 include/linux/irq.h                |   62 +++-
 include/linux/irqnr.h              |   26 +-
 include/linux/kernel_stat.h        |   14 +-
 include/linux/lockdep.h            |    2 +-
 include/linux/msi.h                |    3 +
 include/linux/random.h             |   51 +++
 init/main.c                        |   11 +
 kernel/irq/Makefile                |    1 +
 kernel/irq/autoprobe.c             |   15 +
 kernel/irq/chip.c                  |   16 +-
 kernel/irq/handle.c                |  189 +++++++++-
 kernel/irq/internals.h             |    5 +
 kernel/irq/manage.c                |   15 +-
 kernel/irq/numa_migrate.c          |  122 ++++++
 kernel/irq/proc.c                  |    6 +-
 kernel/irq/spurious.c              |    5 +
 33 files changed, 1221 insertions(+), 330 deletions(-)
 create mode 100644 kernel/irq/numa_migrate.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ac22bb7..e4c038a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -238,6 +238,28 @@ config X86_HAS_BOOT_CPU_ID
 	def_bool y
 	depends on X86_VOYAGER
 
+config SPARSE_IRQ
+	bool "Support sparse irq numbering"
+	depends on PCI_MSI || HT_IRQ
+	help
+	  This enables support for sparse irqs. This is useful for distro
+	  kernels that want to define a high CONFIG_NR_CPUS value but still
+	  want to have low kernel memory footprint on smaller machines.
+
+	  ( Sparse IRQs can also be beneficial on NUMA boxes, as they spread
+	    out the irq_desc[] array in a more NUMA-friendly way. )
+
+	  If you don't know what to do here, say N.
+
+config NUMA_MIGRATE_IRQ_DESC
+	bool "Move irq desc when changing irq smp_affinity"
+	depends on SPARSE_IRQ && NUMA
+	default n
+	help
+	  This enables moving irq_desc to cpu/node that irq will use handled.
+
+	  If you don't know what to do here, say N.
+
 config X86_FIND_SMP_CONFIG
 	def_bool y
 	depends on X86_MPPARSE || X86_VOYAGER
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 6afd993..25d527c 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -188,17 +188,14 @@ extern void restore_IO_APIC_setup(void);
 extern void reinit_intr_remapped_IO_APIC(int);
 #endif
 
-extern int probe_nr_irqs(void);
+extern void probe_nr_irqs_gsi(void);
 
 #else  /* !CONFIG_X86_IO_APIC */
 #define io_apic_assign_pci_irqs 0
 static const int timer_through_8259 = 0;
-static inline void ioapic_init_mappings(void) { }
+static inline void ioapic_init_mappings(void)	{ }
 
-static inline int probe_nr_irqs(void)
-{
-	return NR_IRQS;
-}
+static inline void probe_nr_irqs_gsi(void)	{ }
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 0005adb..f7ff650 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
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
 
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 9043251..a74887b 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -108,93 +108,252 @@ static int __init parse_noapic(char *str)
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
 	unsigned move_cleanup_count;
 	u8 vector;
 	u8 move_in_progress : 1;
+#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
+	u8 move_desc_pending : 1;
+#endif
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
+void __init arch_early_irq_init(void)
+{
+	struct irq_cfg *cfg;
+	struct irq_desc *desc;
+	int count;
+	int i;
+
+	cfg = irq_cfgx;
+	count = ARRAY_SIZE(irq_cfgx);
+
+	for (i = 0; i < count; i++) {
+		desc = irq_to_desc(i);
+		desc->chip_data = &cfg[i];
+	}
+}
 
+#ifdef CONFIG_SPARSE_IRQ
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
+	node = cpu_to_node(cpu);
+
+	cfg = kzalloc_node(sizeof(*cfg), GFP_ATOMIC, node);
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
+void arch_init_chip_data(struct irq_desc *desc, int cpu)
+{
+	struct irq_cfg *cfg;
 
-/*
- * This is performance-critical, we want to do it O(1)
- *
- * the indexing order of this array favors 1:1 mappings
- * between pins and IRQs.
- */
+	cfg = desc->chip_data;
+	if (!cfg) {
+		desc->chip_data = get_one_free_irq_cfg(cpu);
+		if (!desc->chip_data) {
+			printk(KERN_ERR "can not alloc irq_cfg\n");
+			BUG_ON(1);
+		}
+	}
+}
 
-struct irq_pin_list {
-	int apic, pin;
-	struct irq_pin_list *next;
-};
+#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
+
+static void
+init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int cpu)
+{
+	struct irq_pin_list *old_entry, *head, *tail, *entry;
+
+	cfg->irq_2_pin = NULL;
+	old_entry = old_cfg->irq_2_pin;
+	if (!old_entry)
+		return;
 
-static struct irq_pin_list irq_2_pin_head[PIN_MAP_SIZE];
-static struct irq_pin_list *irq_2_pin_ptr;
+	entry = get_one_free_irq_2_pin(cpu);
+	if (!entry)
+		return;
 
-static void __init irq_2_pin_init(void)
+	entry->apic	= old_entry->apic;
+	entry->pin	= old_entry->pin;
+	head		= entry;
+	tail		= entry;
+	old_entry	= old_entry->next;
+	while (old_entry) {
+		entry = get_one_free_irq_2_pin(cpu);
+		if (!entry) {
+			entry = head;
+			while (entry) {
+				head = entry->next;
+				kfree(entry);
+				entry = head;
+			}
+			/* still use the old one */
+			return;
+		}
+		entry->apic	= old_entry->apic;
+		entry->pin	= old_entry->pin;
+		tail->next	= entry;
+		tail		= entry;
+		old_entry	= old_entry->next;
+	}
+
+	tail->next = NULL;
+	cfg->irq_2_pin = head;
+}
+
+static void free_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg)
 {
-	struct irq_pin_list *pin = irq_2_pin_head;
-	int i;
+	struct irq_pin_list *entry, *next;
 
-	for (i = 1; i < PIN_MAP_SIZE; i++)
-		pin[i-1].next = &pin[i];
+	if (old_cfg->irq_2_pin == cfg->irq_2_pin)
+		return;
+
+	entry = old_cfg->irq_2_pin;
 
-	irq_2_pin_ptr = &pin[0];
+	while (entry) {
+		next = entry->next;
+		kfree(entry);
+		entry = next;
+	}
+	old_cfg->irq_2_pin = NULL;
 }
 
-static struct irq_pin_list *get_one_free_irq_2_pin(void)
+void arch_init_copy_chip_data(struct irq_desc *old_desc,
+				 struct irq_desc *desc, int cpu)
 {
-	struct irq_pin_list *pin = irq_2_pin_ptr;
+	struct irq_cfg *cfg;
+	struct irq_cfg *old_cfg;
 
-	if (!pin)
-		panic("can not get more irq_2_pin\n");
+	cfg = get_one_free_irq_cfg(cpu);
 
-	irq_2_pin_ptr = pin->next;
-	pin->next = NULL;
-	return pin;
+	if (!cfg)
+		return;
+
+	desc->chip_data = cfg;
+
+	old_cfg = old_desc->chip_data;
+
+	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
+
+	init_copy_irq_2_pin(old_cfg, cfg, cpu);
+}
+
+static void free_irq_cfg(struct irq_cfg *old_cfg)
+{
+	kfree(old_cfg);
+}
+
+void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
+{
+	struct irq_cfg *old_cfg, *cfg;
+
+	old_cfg = old_desc->chip_data;
+	cfg = desc->chip_data;
+
+	if (old_cfg == cfg)
+		return;
+
+	if (old_cfg) {
+		free_irq_2_pin(old_cfg, cfg);
+		free_irq_cfg(old_cfg);
+		old_desc->chip_data = NULL;
+	}
+}
+
+static void set_extra_move_desc(struct irq_desc *desc, cpumask_t mask)
+{
+	struct irq_cfg *cfg = desc->chip_data;
+
+	if (!cfg->move_in_progress) {
+		/* it means that domain is not changed */
+		if (!cpus_intersects(desc->affinity, mask))
+			cfg->move_desc_pending = 1;
+	}
 }
+#endif
+
+#else
+static struct irq_cfg *irq_cfg(unsigned int irq)
+{
+	return irq < nr_irqs ? irq_cfgx + irq : NULL;
+}
+
+#endif
+
+#ifndef CONFIG_NUMA_MIGRATE_IRQ_DESC
+static inline void set_extra_move_desc(struct irq_desc *desc, cpumask_t mask)
+{
+}
+#endif
 
 struct io_apic {
 	unsigned int index;
@@ -237,11 +396,10 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
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
@@ -323,13 +481,12 @@ static void ioapic_mask_entry(int apic, int pin)
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
@@ -359,24 +516,27 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, u8 vector)
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
@@ -384,12 +544,20 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
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
@@ -397,16 +565,18 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
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
@@ -421,7 +591,7 @@ static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 		entry = entry->next;
 	}
 
-	entry->next = get_one_free_irq_2_pin();
+	entry->next = get_one_free_irq_2_pin(cpu);
 	entry = entry->next;
 	entry->apic = apic;
 	entry->pin = pin;
@@ -430,11 +600,10 @@ static void add_pin_to_irq(unsigned int irq, int apic, int pin)
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
 
@@ -451,18 +620,16 @@ static void __init replace_pin_at_irq(unsigned int irq,
 
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
@@ -475,9 +642,9 @@ static inline void io_apic_modify_irq(unsigned int irq,
 	}
 }
 
-static void __unmask_IO_APIC_irq(unsigned int irq)
+static void __unmask_IO_APIC_irq(struct irq_cfg *cfg)
 {
-	io_apic_modify_irq(irq, ~IO_APIC_REDIR_MASKED, 0, NULL);
+	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED, 0, NULL);
 }
 
 #ifdef CONFIG_X86_64
@@ -492,47 +659,64 @@ void io_apic_sync(struct irq_pin_list *entry)
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
@@ -809,7 +993,7 @@ EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
  */
 static int EISA_ELCR(unsigned int irq)
 {
-	if (irq < 16) {
+	if (irq < NR_IRQS_LEGACY) {
 		unsigned int port = 0x4d0 + (irq >> 3);
 		return (inb(port) >> (irq & 7)) & 1;
 	}
@@ -1034,7 +1218,7 @@ void unlock_vector_lock(void)
 	spin_unlock(&vector_lock);
 }
 
-static int __assign_irq_vector(int irq, cpumask_t mask)
+static int __assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1050,16 +1234,13 @@ static int __assign_irq_vector(int irq, cpumask_t mask)
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
@@ -1113,24 +1294,22 @@ next:
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
@@ -1162,9 +1341,13 @@ void __setup_vector_irq(int cpu)
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
@@ -1215,11 +1398,8 @@ static inline int IO_APIC_irq_trigger(int irq)
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
@@ -1311,7 +1491,7 @@ static int setup_ioapic_entry(int apic, int irq,
 	return 0;
 }
 
-static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
+static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq, struct irq_desc *desc,
 			      int trigger, int polarity)
 {
 	struct irq_cfg *cfg;
@@ -1321,10 +1501,10 @@ static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
 	if (!IO_APIC_IRQ(irq))
 		return;
 
-	cfg = irq_cfg(irq);
+	cfg = desc->chip_data;
 
 	mask = TARGET_CPUS;
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
 	cpus_and(mask, cfg->domain, mask);
@@ -1341,12 +1521,12 @@ static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
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
@@ -1356,6 +1536,9 @@ static void __init setup_IO_APIC_irqs(void)
 {
 	int apic, pin, idx, irq;
 	int notcon = 0;
+	struct irq_desc *desc;
+	struct irq_cfg *cfg;
+	int cpu = boot_cpu_id;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
@@ -1387,9 +1570,15 @@ static void __init setup_IO_APIC_irqs(void)
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
@@ -1448,6 +1637,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	union IO_APIC_reg_03 reg_03;
 	unsigned long flags;
 	struct irq_cfg *cfg;
+	struct irq_desc *desc;
 	unsigned int irq;
 
 	if (apic_verbosity == APIC_QUIET)
@@ -1537,8 +1727,13 @@ __apicdebuginit(void) print_IO_APIC(void)
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
@@ -2022,14 +2217,16 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
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
@@ -2092,35 +2289,37 @@ static DECLARE_DELAYED_WORK(ir_migration_work, ir_irq_migration);
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
 
@@ -2142,14 +2341,14 @@ static void migrate_ioapic_irq(int irq, cpumask_t mask)
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
@@ -2161,14 +2360,15 @@ static int migrate_irq_remapped_level(int irq)
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
 
@@ -2178,6 +2378,9 @@ static void ir_irq_migration(struct work_struct *work)
 	struct irq_desc *desc;
 
 	for_each_irq_desc(irq, desc) {
+		if (!desc)
+			continue;
+
 		if (desc->status & IRQ_MOVE_PENDING) {
 			unsigned long flags;
 
@@ -2198,18 +2401,22 @@ static void ir_irq_migration(struct work_struct *work)
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
 
@@ -2229,6 +2436,9 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 		struct irq_cfg *cfg;
 		irq = __get_cpu_var(vector_irq)[vector];
 
+		if (irq == -1)
+			continue;
+
 		desc = irq_to_desc(irq);
 		if (!desc)
 			continue;
@@ -2250,19 +2460,40 @@ unlock:
 	irq_exit();
 }
 
-static void irq_complete_move(unsigned int irq)
+static void irq_complete_move(struct irq_desc **descp)
 {
-	struct irq_cfg *cfg = irq_cfg(irq);
+	struct irq_desc *desc = *descp;
+	struct irq_cfg *cfg = desc->chip_data;
 	unsigned vector, me;
 
-	if (likely(!cfg->move_in_progress))
+	if (likely(!cfg->move_in_progress)) {
+#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
+		if (likely(!cfg->move_desc_pending))
+			return;
+
+		/* domain has not changed, but affinity did */
+		me = smp_processor_id();
+		if (cpu_isset(me, desc->affinity)) {
+			*descp = desc = move_irq_desc(desc, me);
+			/* get the new one */
+			cfg = desc->chip_data;
+			cfg->move_desc_pending = 0;
+		}
+#endif
 		return;
+	}
 
 	vector = ~get_irq_regs()->orig_ax;
 	me = smp_processor_id();
 	if ((vector == cfg->vector) && cpu_isset(me, cfg->domain)) {
 		cpumask_t cleanup_mask;
 
+#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
+		*descp = desc = move_irq_desc(desc, me);
+		/* get the new one */
+		cfg = desc->chip_data;
+#endif
+
 		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
 		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
 		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
@@ -2270,8 +2501,9 @@ static void irq_complete_move(unsigned int irq)
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
@@ -2282,11 +2514,14 @@ static void ack_x2apic_edge(unsigned int irq)
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
@@ -2295,18 +2530,21 @@ atomic_t irq_mis_count;
 
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
 
@@ -2330,7 +2568,8 @@ static void ack_apic_level(unsigned int irq)
 	* operation to prevent an edge-triggered interrupt escaping meanwhile.
 	* The idea is from Manfred Spraul.  --macro
 	*/
-	i = irq_cfg(irq)->vector;
+	cfg = desc->chip_data;
+	i = cfg->vector;
 
 	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
 #endif
@@ -2369,17 +2608,18 @@ static void ack_apic_level(unsigned int irq)
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
@@ -2430,20 +2670,22 @@ static inline void init_IO_APIC_traps(void)
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
 	}
 }
@@ -2468,7 +2710,7 @@ static void unmask_lapic_irq(unsigned int irq)
 	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
 }
 
-static void ack_lapic_irq (unsigned int irq)
+static void ack_lapic_irq(unsigned int irq)
 {
 	ack_APIC_irq();
 }
@@ -2480,11 +2722,8 @@ static struct irq_chip lapic_chip __read_mostly = {
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
@@ -2588,7 +2827,9 @@ int timer_through_8259 __initdata;
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
@@ -2603,7 +2844,7 @@ static inline void __init check_timer(void)
 	 * get/set the timer IRQ vector:
 	 */
 	disable_8259A_irq(0);
-	assign_irq_vector(0, TARGET_CPUS);
+	assign_irq_vector(0, cfg, TARGET_CPUS);
 
 	/*
 	 * As IRQ0 is to be enabled in the 8259A, the virtual
@@ -2654,10 +2895,10 @@ static inline void __init check_timer(void)
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
@@ -2683,9 +2924,9 @@ static inline void __init check_timer(void)
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
@@ -2717,7 +2958,7 @@ static inline void __init check_timer(void)
 	apic_printk(APIC_QUIET, KERN_INFO
 		    "...trying to set up timer as Virtual Wire IRQ...\n");
 
-	lapic_register_intr(0);
+	lapic_register_intr(0, desc);
 	apic_write(APIC_LVT0, APIC_DM_FIXED | cfg->vector);	/* Fixed mode */
 	enable_8259A_irq(0);
 
@@ -2902,22 +3143,26 @@ unsigned int create_irq_nr(unsigned int irq_want)
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
 			continue;
-		/* check if need to create one */
-		if (!cfg_new)
-			cfg_new = irq_cfg_alloc(new);
-		if (__assign_irq_vector(new, TARGET_CPUS) == 0)
+		}
+		cfg_new = desc_new->chip_data;
+
+		if (cfg_new->vector != 0)
+			continue;
+		if (__assign_irq_vector(new, cfg_new, TARGET_CPUS) == 0)
 			irq = new;
 		break;
 	}
@@ -2925,15 +3170,21 @@ unsigned int create_irq_nr(unsigned int irq_want)
 
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
@@ -2944,14 +3195,22 @@ int create_irq(void)
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
 
@@ -2966,12 +3225,12 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
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
 
@@ -3029,35 +3288,35 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
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
@@ -3065,11 +3324,11 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
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
@@ -3078,10 +3337,12 @@ static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
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
 
@@ -3105,9 +3366,9 @@ static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 		cfg->move_in_progress = 0;
 	}
 
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
+
 #endif
 #endif /* CONFIG_SMP */
 
@@ -3166,7 +3427,7 @@ static int msi_alloc_irte(struct pci_dev *dev, int irq, int nvec)
 }
 #endif
 
-static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc, int irq)
+static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 {
 	int ret;
 	struct msi_msg msg;
@@ -3175,7 +3436,7 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc, int irq)
 	if (ret < 0)
 		return ret;
 
-	set_irq_msi(irq, desc);
+	set_irq_msi(irq, msidesc);
 	write_msi_msg(irq, &msg);
 
 #ifdef CONFIG_INTR_REMAP
@@ -3195,26 +3456,13 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc, int irq)
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
@@ -3228,7 +3476,7 @@ int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 		goto error;
 no_ir:
 #endif
-	ret = setup_msi_irq(dev, desc, irq);
+	ret = setup_msi_irq(dev, msidesc, irq);
 	if (ret < 0) {
 		destroy_irq(irq);
 		return ret;
@@ -3246,7 +3494,7 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	unsigned int irq;
 	int ret, sub_handle;
-	struct msi_desc *desc;
+	struct msi_desc *msidesc;
 	unsigned int irq_want;
 
 #ifdef CONFIG_INTR_REMAP
@@ -3254,10 +3502,11 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
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
@@ -3289,7 +3538,7 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		}
 no_ir:
 #endif
-		ret = setup_msi_irq(dev, desc, irq);
+		ret = setup_msi_irq(dev, msidesc, irq);
 		if (ret < 0)
 			goto error;
 		sub_handle++;
@@ -3310,20 +3559,22 @@ void arch_teardown_msi_irq(unsigned int irq)
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
 
@@ -3335,9 +3586,9 @@ static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
+
 #endif /* CONFIG_SMP */
 
 struct irq_chip dmar_msi_type = {
@@ -3371,8 +3622,8 @@ int arch_setup_dmar_msi(unsigned int irq)
 #ifdef CONFIG_SMP
 static void hpet_msi_set_affinity(unsigned int irq, cpumask_t mask)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
-	struct irq_desc *desc;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
@@ -3381,10 +3632,12 @@ static void hpet_msi_set_affinity(unsigned int irq, cpumask_t mask)
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
 
@@ -3396,9 +3649,9 @@ static void hpet_msi_set_affinity(unsigned int irq, cpumask_t mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	hpet_msi_write(irq, &msg);
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
+
 #endif /* CONFIG_SMP */
 
 struct irq_chip hpet_msi_type = {
@@ -3453,26 +3706,28 @@ static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
 
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
@@ -3492,13 +3747,13 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
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
 
@@ -3544,7 +3799,9 @@ int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	unsigned long flags;
 	int err;
 
-	err = assign_irq_vector(irq, *eligible_cpu);
+	cfg = irq_cfg(irq);
+
+	err = assign_irq_vector(irq, cfg, *eligible_cpu);
 	if (err != 0)
 		return err;
 
@@ -3553,8 +3810,6 @@ int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 				      irq_name);
 	spin_unlock_irqrestore(&vector_lock, flags);
 
-	cfg = irq_cfg(irq);
-
 	mmr_value = 0;
 	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
 	BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
@@ -3606,9 +3861,16 @@ int __init io_apic_get_redir_entries (int ioapic)
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
@@ -3707,19 +3969,31 @@ int __init io_apic_get_version(int ioapic)
 
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
@@ -3773,9 +4047,10 @@ void __init setup_ioapic_dest(void)
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
@@ -3785,7 +4060,6 @@ void __init setup_ioapic_dest(void)
 			/*
 			 * Honour affinities which have been set in early boot
 			 */
-			desc = irq_to_desc(irq);
 			if (desc->status &
 			    (IRQ_NO_BALANCING | IRQ_AFFINITY_SET))
 				mask = desc->affinity;
@@ -3794,10 +4068,10 @@ void __init setup_ioapic_dest(void)
 
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
@@ -3846,7 +4120,6 @@ void __init ioapic_init_mappings(void)
 	struct resource *ioapic_res;
 	int i;
 
-	irq_2_pin_init();
 	ioapic_res = ioapic_setup_resources();
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index d1d4dc5..3f1d9d1 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -118,6 +118,9 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	desc = irq_to_desc(i);
+	if (!desc)
+		return 0;
+
 	spin_lock_irqsave(&desc->lock, flags);
 #ifndef CONFIG_SMP
 	any_count = kstat_irqs(i);
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index a513826..119fc9c 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -242,6 +242,8 @@ void fixup_irqs(cpumask_t map)
 	for_each_irq_desc(irq, desc) {
 		cpumask_t mask;
 
+		if (!desc)
+			continue;
 		if (irq == 2)
 			continue;
 
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 60eb84e..900009c 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -94,6 +94,8 @@ void fixup_irqs(cpumask_t map)
 		int break_affinity = 0;
 		int set_affinity = 1;
 
+		if (!desc)
+			continue;
 		if (irq == 2)
 			continue;
 
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 845aa98..6a92f47 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -68,8 +68,7 @@ void __init init_ISA_irqs (void)
 	/*
 	 * 16 old-style INTA-cycle interrupts:
 	 */
-	for (i = 0; i < 16; i++) {
-		/* first time call this irq_desc */
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
 		struct irq_desc *desc = irq_to_desc(i);
 
 		desc->status = IRQ_DISABLED;
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index ff02353..40c1e62 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -142,8 +142,7 @@ void __init init_ISA_irqs(void)
 	init_bsp_APIC();
 	init_8259A(0);
 
-	for (i = 0; i < 16; i++) {
-		/* first time call this irq_desc */
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
 		struct irq_desc *desc = irq_to_desc(i);
 
 		desc->status = IRQ_DISABLED;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index bdec76e..5e028e1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1080,7 +1080,7 @@ void __init setup_arch(char **cmdline_p)
 	ioapic_init_mappings();
 
 	/* need to wait for io_apic is mapped */
-	nr_irqs = probe_nr_irqs();
+	probe_nr_irqs_gsi();
 
 	kvm_guest_init();
 
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 675076f..d26891b 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
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
 
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 2de5a32..f78371b 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -5,6 +5,7 @@
 #include <linux/pci.h>
 #include <linux/irq.h>
 #include <asm/io_apic.h>
+#include <asm/smp.h>
 #include <linux/intel-iommu.h>
 #include "intr_remapping.h"
 
@@ -19,17 +20,75 @@ struct irq_2_iommu {
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
 }
 
 static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
 {
+	return irq_2_iommu_alloc_cpu(irq, boot_cpu_id);
+}
+
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
+static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
+{
 	return irq_2_iommu(irq);
 }
+#endif
 
 static DEFINE_SPINLOCK(irq_2_ir_lock);
 
@@ -86,9 +145,11 @@ int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 	if (!count)
 		return -1;
 
+#ifndef CONFIG_SPARSE_IRQ
 	/* protect irq_2_iommu_alloc later */
 	if (irq >= nr_irqs)
 		return -1;
+#endif
 
 	/*
 	 * start the IRTE search from index 0.
@@ -130,6 +191,12 @@ int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
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
@@ -177,6 +244,12 @@ int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 
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
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 74801f7..11a51f8 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -103,11 +103,11 @@ static void msix_set_enable(struct pci_dev *dev, int enable)
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
@@ -135,11 +135,11 @@ static void msix_flush_writes(unsigned int irq)
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
@@ -172,9 +172,9 @@ static int msi_set_mask_bits(unsigned int irq, u32 mask, u32 flag)
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
@@ -211,9 +211,16 @@ void read_msi_msg(unsigned int irq, struct msi_msg *msg)
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
@@ -252,21 +259,31 @@ void write_msi_msg(unsigned int irq, struct msi_msg *msg)
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
@@ -303,9 +320,11 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
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
@@ -327,8 +346,9 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
 	msix_set_enable(dev, 0);
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
+		struct irq_desc *desc = irq_to_desc(entry->irq);
 		write_msi_msg(entry->irq, &entry->msg);
-		msi_set_mask_bits(entry->irq, 1, entry->msi_attrib.masked);
+		msi_set_mask_bits(desc, 1, entry->msi_attrib.masked);
 	}
 
 	BUG_ON(list_empty(&dev->msi_list));
@@ -596,7 +616,8 @@ void pci_msi_shutdown(struct pci_dev* dev)
 	/* Return the the pci reset with msi irqs unmasked */
 	if (entry->msi_attrib.maskbit) {
 		u32 mask = entry->msi_attrib.maskbits_mask;
-		msi_set_mask_bits(dev->irq, mask, ~mask);
+		struct irq_desc *desc = irq_to_desc(dev->irq);
+		msi_set_mask_bits(desc, mask, ~mask);
 	}
 	if (!entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI)
 		return;
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 1e3b934..46625cd 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -141,8 +141,12 @@ static void init_evtchn_cpu_bindings(void)
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
@@ -229,15 +233,20 @@ static void unmask_evtchn(int port)
 static int find_unbound_irq(void)
 {
 	int irq;
+	struct irq_desc *desc;
 
 	/* Only allocate from dynirq range */
-	for_each_irq_nr(irq)
+	for (irq = 0; irq < nr_irqs; irq++)
 		if (irq_bindcount[irq] == 0)
 			break;
 
 	if (irq == nr_irqs)
 		panic("No available IRQ to bind to: increase nr_irqs!\n");
 
+	desc = irq_to_desc_alloc_cpu(irq, 0);
+	if (WARN_ON(desc == NULL))
+		return -1;
+
 	return irq;
 }
 
@@ -792,7 +801,7 @@ void xen_irq_resume(void)
 		mask_evtchn(evtchn);
 
 	/* No IRQ <-> event-channel mappings. */
-	for_each_irq_nr(irq)
+	for (irq = 0; irq < nr_irqs; irq++)
 		irq_info[irq].evtchn = 0; /* zap event-channel binding */
 
 	for (evtchn = 0; evtchn < NR_EVENT_CHANNELS; evtchn++)
@@ -824,7 +833,7 @@ void __init xen_init_IRQ(void)
 		mask_evtchn(i);
 
 	/* Dynamic IRQ space is currently unbound. Zero the refcnts. */
-	for_each_irq_nr(i)
+	for (i = 0; i < nr_irqs; i++)
 		irq_bindcount[i] = 0;
 
 	irq_ctx_init(smp_processor_id());
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 81904f0..3bb1cf1 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -44,10 +44,13 @@ static int show_stat(struct seq_file *p, void *v)
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-
-		for_each_irq_nr(j)
+		for_each_irq_nr(j) {
+#ifdef CONFIG_SPARSE_IRQ
+			if (!irq_to_desc(j))
+				continue;
+#endif
 			sum += kstat_irqs_cpu(j, i);
-
+		}
 		sum += arch_irq_stat_cpu(i);
 	}
 	sum += arch_irq_stat();
@@ -92,7 +95,12 @@ static int show_stat(struct seq_file *p, void *v)
 	/* sum again ? it could be updated? */
 	for_each_irq_nr(j) {
 		per_irq_sum = 0;
-
+#ifdef CONFIG_SPARSE_IRQ
+		if (!irq_to_desc(j)) {
+			seq_printf(p, " %u", per_irq_sum);
+			continue;
+		}
+#endif
 		for_each_possible_cpu(i)
 			per_irq_sum += kstat_irqs_cpu(j, i);
 
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index e531783..95ac823 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -313,6 +313,7 @@ unifdef-y += ptrace.h
 unifdef-y += qnx4_fs.h
 unifdef-y += quota.h
 unifdef-y += random.h
+unifdef-y += irqnr.h
 unifdef-y += reboot.h
 unifdef-y += reiserfs_fs.h
 unifdef-y += reiserfs_xattr.h
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index f58a0cf..777f89e 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -14,6 +14,8 @@
 #include <linux/irqflags.h>
 #include <linux/smp.h>
 #include <linux/percpu.h>
+#include <linux/irqnr.h>
+
 #include <asm/atomic.h>
 #include <asm/ptrace.h>
 #include <asm/system.h>
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 3dddfa7..98564dc 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -129,9 +129,14 @@ struct irq_chip {
 	const char	*typename;
 };
 
+struct timer_rand_state;
+struct irq_2_iommu;
 /**
  * struct irq_desc - interrupt descriptor
  * @irq:		interrupt number for this descriptor
+ * @timer_rand_state:	pointer to timer rand state struct
+ * @kstat_irqs:		irq stats per cpu
+ * @irq_2_iommu:	iommu with this irq
  * @handle_irq:		highlevel irq-events handler [if NULL, __do_IRQ()]
  * @chip:		low level interrupt hardware access
  * @msi_desc:		MSI descriptor
@@ -143,8 +148,8 @@ struct irq_chip {
  * @depth:		disable-depth, for nested irq_disable() calls
  * @wake_depth:		enable depth, for multiple set_irq_wake() callers
  * @irq_count:		stats field to detect stalled irqs
- * @irqs_unhandled:	stats field for spurious unhandled interrupts
  * @last_unhandled:	aging timer for unhandled count
+ * @irqs_unhandled:	stats field for spurious unhandled interrupts
  * @lock:		locking for SMP
  * @affinity:		IRQ affinity on SMP
  * @cpu:		cpu index useful for balancing
@@ -154,6 +159,13 @@ struct irq_chip {
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
@@ -165,8 +177,8 @@ struct irq_desc {
 	unsigned int		depth;		/* nested irq disables */
 	unsigned int		wake_depth;	/* nested wake enables */
 	unsigned int		irq_count;	/* For detecting broken IRQs */
-	unsigned int		irqs_unhandled;
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
+	unsigned int		irqs_unhandled;
 	spinlock_t		lock;
 #ifdef CONFIG_SMP
 	cpumask_t		affinity;
@@ -181,12 +193,51 @@ struct irq_desc {
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
+extern void early_irq_init(void);
+extern void arch_early_irq_init(void);
+extern void arch_init_chip_data(struct irq_desc *desc, int cpu);
+extern void arch_init_copy_chip_data(struct irq_desc *old_desc,
+					struct irq_desc *desc, int cpu);
+extern void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc);
 
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
+}
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
+static inline struct irq_desc *
+irq_remap_to_desc(unsigned int irq, struct irq_desc *desc)
+{
+#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
+	return irq_to_desc(irq);
+#else
+	return desc;
+#endif
 }
 
 /*
@@ -380,6 +431,11 @@ extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
 #define get_irq_data(irq)	(irq_to_desc(irq)->handler_data)
 #define get_irq_msi(irq)	(irq_to_desc(irq)->msi_desc)
 
+#define get_irq_desc_chip(desc)		((desc)->chip)
+#define get_irq_desc_chip_data(desc)	((desc)->chip_data)
+#define get_irq_desc_data(desc)		((desc)->handler_data)
+#define get_irq_desc_msi(desc)		((desc)->msi_desc)
+
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
 #endif /* !CONFIG_S390 */
diff --git a/include/linux/irqnr.h b/include/linux/irqnr.h
index 452c280..95d2b74 100644
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -1,24 +1,38 @@
 #ifndef _LINUX_IRQNR_H
 #define _LINUX_IRQNR_H
 
+/*
+ * Generic irq_desc iterators:
+ */
+#ifdef __KERNEL__
+
 #ifndef CONFIG_GENERIC_HARDIRQS
 #include <asm/irq.h>
 # define nr_irqs		NR_IRQS
 
 # define for_each_irq_desc(irq, desc)		\
 	for (irq = 0; irq < nr_irqs; irq++)
+
+# define for_each_irq_desc_reverse(irq, desc)                          \
+	for (irq = nr_irqs - 1; irq >= 0; irq--)
 #else
+
 extern int nr_irqs;
 
+#ifndef CONFIG_SPARSE_IRQ
+
+struct irq_desc;
 # define for_each_irq_desc(irq, desc)		\
 	for (irq = 0, desc = irq_desc; irq < nr_irqs; irq++, desc++)
-
-# define for_each_irq_desc_reverse(irq, desc)				\
-	for (irq = nr_irqs - 1, desc = irq_desc + (nr_irqs - 1);	\
-	     irq >= 0; irq--, desc--)
+# define for_each_irq_desc_reverse(irq, desc)                          \
+	for (irq = nr_irqs - 1, desc = irq_desc + (nr_irqs - 1);        \
+	    irq >= 0; irq--, desc--)
+#endif
 #endif
 
-#define for_each_irq_nr(irq)			\
-	for (irq = 0; irq < nr_irqs; irq++)
+#define for_each_irq_nr(irq)                   \
+       for (irq = 0; irq < nr_irqs; irq++)
+
+#endif /* __KERNEL__ */
 
 #endif
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 4a145ca..4ee4b3d 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -28,7 +28,9 @@ struct cpu_usage_stat {
 
 struct kernel_stat {
 	struct cpu_usage_stat	cpustat;
-	unsigned int irqs[NR_IRQS];
+#ifndef CONFIG_SPARSE_IRQ
+       unsigned int irqs[NR_IRQS];
+#endif
 };
 
 DECLARE_PER_CPU(struct kernel_stat, kstat);
@@ -39,6 +41,10 @@ DECLARE_PER_CPU(struct kernel_stat, kstat);
 
 extern unsigned long long nr_context_switches(void);
 
+#ifndef CONFIG_SPARSE_IRQ
+#define kstat_irqs_this_cpu(irq) \
+	(kstat_this_cpu.irqs[irq])
+
 struct irq_desc;
 
 static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
@@ -46,11 +52,17 @@ static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
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
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 29aec6e..9dba554 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -377,7 +377,7 @@ do {								\
 
 #endif /* CONFIG_LOCK_STAT */
 
-#if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_GENERIC_HARDIRQS)
+#ifdef CONFIG_GENERIC_HARDIRQS
 extern void early_init_irq_lock_class(void);
 #else
 static inline void early_init_irq_lock_class(void)
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 8f29392..d2b8a1e 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
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
 
diff --git a/include/linux/random.h b/include/linux/random.h
index 36f125c..adbf3bd 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -8,6 +8,7 @@
 #define _LINUX_RANDOM_H
 
 #include <linux/ioctl.h>
+#include <linux/irqnr.h>
 
 /* ioctl()'s for the random number generator */
 
@@ -44,6 +45,56 @@ struct rand_pool_info {
 
 extern void rand_initialize_irq(int irq);
 
+struct timer_rand_state;
+#ifndef CONFIG_SPARSE_IRQ
+
+extern struct timer_rand_state *irq_timer_state[];
+
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
diff --git a/init/main.c b/init/main.c
index 7e117a2..c1f999a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -539,6 +539,15 @@ void __init __weak thread_info_cache_init(void)
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
@@ -603,6 +612,8 @@ asmlinkage void __init start_kernel(void)
 	sort_main_extable();
 	trap_init();
 	rcu_init();
+	/* init some links before init_ISA_irqs() */
+	early_irq_init();
 	init_IRQ();
 	pidhash_init();
 	init_timers();
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index 681c52d..4dd5b1e 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -3,3 +3,4 @@ obj-y := handle.o manage.o spurious.o resend.o chip.o devres.o
 obj-$(CONFIG_GENERIC_IRQ_PROBE) += autoprobe.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
+obj-$(CONFIG_NUMA_MIGRATE_IRQ_DESC) += numa_migrate.o
diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index cc0f732..650ce41 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
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
 
@@ -124,6 +133,9 @@ unsigned int probe_irq_mask(unsigned long val)
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
 
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 10b5092..6eb3c79 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
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
@@ -124,6 +125,7 @@ int set_irq_type(unsigned int irq, unsigned int type)
 		return -ENODEV;
 	}
 
+	type &= IRQ_TYPE_SENSE_MASK;
 	if (type == IRQ_TYPE_NONE)
 		return 0;
 
@@ -352,6 +354,7 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 
 	spin_lock(&desc->lock);
 	mask_ack_irq(desc, irq);
+	desc = irq_remap_to_desc(irq, desc);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
@@ -429,6 +432,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	desc->status &= ~IRQ_INPROGRESS;
 out:
 	desc->chip->eoi(irq);
+	desc = irq_remap_to_desc(irq, desc);
 
 	spin_unlock(&desc->lock);
 }
@@ -465,12 +469,14 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		    !desc->action)) {
 		desc->status |= (IRQ_PENDING | IRQ_MASKED);
 		mask_ack_irq(desc, irq);
+		desc = irq_remap_to_desc(irq, desc);
 		goto out_unlock;
 	}
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
 	desc->chip->ack(irq);
+	desc = irq_remap_to_desc(irq, desc);
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
@@ -531,8 +537,10 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	if (desc->chip->eoi)
+	if (desc->chip->eoi) {
 		desc->chip->eoi(irq);
+		desc = irq_remap_to_desc(irq, desc);
+	}
 }
 
 void
@@ -567,8 +575,10 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 
 	/* Uninstall? */
 	if (handle == handle_bad_irq) {
-		if (desc->chip != &no_irq_chip)
+		if (desc->chip != &no_irq_chip) {
 			mask_ack_irq(desc, irq);
+			desc = irq_remap_to_desc(irq, desc);
+		}
 		desc->status |= IRQ_DISABLED;
 		desc->depth = 1;
 	}
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index c815b42..6492400 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
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
+struct lock_class_key irq_desc_lock_class;
+
 /**
  * handle_bad_irq - handle spurious and unhandled irqs
  * @irq:       the interrupt number
@@ -49,6 +56,155 @@ void handle_bad_irq(unsigned int irq, struct irq_desc *desc)
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
+void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
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
+DEFINE_SPINLOCK(sparse_irq_lock);
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
@@ -62,6 +218,8 @@ struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	}
 };
 
+#endif
+
 /*
  * What should we do if we get a hw irq event on an illegal vector?
  * Each architecture has to answer this themself.
@@ -179,8 +337,11 @@ unsigned int __do_IRQ(unsigned int irq)
 		/*
 		 * No locking required for CPU-local interrupts:
 		 */
-		if (desc->chip->ack)
+		if (desc->chip->ack) {
 			desc->chip->ack(irq);
+			/* get new one */
+			desc = irq_remap_to_desc(irq, desc);
+		}
 		if (likely(!(desc->status & IRQ_DISABLED))) {
 			action_ret = handle_IRQ_event(irq, desc->action);
 			if (!noirqdebug)
@@ -191,8 +352,10 @@ unsigned int __do_IRQ(unsigned int irq)
 	}
 
 	spin_lock(&desc->lock);
-	if (desc->chip->ack)
+	if (desc->chip->ack) {
 		desc->chip->ack(irq);
+		desc = irq_remap_to_desc(irq, desc);
+	}
 	/*
 	 * REPLAY is when Linux resends an IRQ that was dropped earlier
 	 * WAITING is used by probe to mark irqs that are being tested
@@ -259,19 +422,25 @@ out:
 }
 #endif
 
-
-#ifdef CONFIG_TRACE_IRQFLAGS
-/*
- * lockdep: we want to handle all irq_desc locks as a single lock-class:
- */
-static struct lock_class_key irq_desc_lock_class;
-
 void early_init_irq_lock_class(void)
 {
 	struct irq_desc *desc;
 	int i;
 
-	for_each_irq_desc(i, desc)
+	for_each_irq_desc(i, desc) {
+		if (!desc)
+			continue;
+
 		lockdep_set_class(&desc->lock, &irq_desc_lock_class);
+	}
+}
+
+#ifdef CONFIG_SPARSE_IRQ
+unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	return desc->kstat_irqs[cpu];
 }
 #endif
+EXPORT_SYMBOL(kstat_irqs_cpu);
+
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 64c1c72..e6d0a43 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -13,6 +13,11 @@ extern void compat_irq_chip_set_default_handler(struct irq_desc *desc);
 extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		unsigned long flags);
 
+extern struct lock_class_key irq_desc_lock_class;
+extern void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr);
+extern spinlock_t sparse_irq_lock;
+extern struct irq_desc *irq_desc_ptrs[NR_IRQS];
+
 #ifdef CONFIG_PROC_FS
 extern void register_irq_proc(unsigned int irq, struct irq_desc *desc);
 extern void register_handler_proc(unsigned int irq, struct irqaction *action);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 801addd..46953a0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -370,16 +370,18 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		return 0;
 	}
 
-	ret = chip->set_type(irq, flags & IRQF_TRIGGER_MASK);
+	/* caller masked out all except trigger mode flags */
+	ret = chip->set_type(irq, flags);
 
 	if (ret)
 		pr_err("setting trigger mode %d for irq %u failed (%pF)\n",
-				(int)(flags & IRQF_TRIGGER_MASK),
-				irq, chip->set_type);
+				(int)flags, irq, chip->set_type);
 	else {
+		if (flags & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
+			flags |= IRQ_LEVEL;
 		/* note that IRQF_TRIGGER_MASK == IRQ_TYPE_SENSE_MASK */
-		desc->status &= ~IRQ_TYPE_SENSE_MASK;
-		desc->status |= flags & IRQ_TYPE_SENSE_MASK;
+		desc->status &= ~(IRQ_LEVEL | IRQ_TYPE_SENSE_MASK);
+		desc->status |= flags;
 	}
 
 	return ret;
@@ -459,7 +461,8 @@ __setup_irq(unsigned int irq, struct irq_desc * desc, struct irqaction *new)
 
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
-			ret = __irq_set_trigger(desc, irq, new->flags);
+			ret = __irq_set_trigger(desc, irq,
+					new->flags & IRQF_TRIGGER_MASK);
 
 			if (ret) {
 				spin_unlock_irqrestore(&desc->lock, flags);
diff --git a/kernel/irq/numa_migrate.c b/kernel/irq/numa_migrate.c
new file mode 100644
index 0000000..089c374
--- /dev/null
+++ b/kernel/irq/numa_migrate.c
@@ -0,0 +1,122 @@
+/*
+ * NUMA irq-desc migration code
+ *
+ * Migrate IRQ data structures (irq_desc, chip_data, etc.) over to
+ * the new "home node" of the IRQ.
+ */
+
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/interrupt.h>
+#include <linux/kernel_stat.h>
+
+#include "internals.h"
+
+static void init_copy_kstat_irqs(struct irq_desc *old_desc,
+				 struct irq_desc *desc,
+				 int cpu, int nr)
+{
+	unsigned long bytes;
+
+	init_kstat_irqs(desc, cpu, nr);
+
+	if (desc->kstat_irqs != old_desc->kstat_irqs) {
+		/* Compute how many bytes we need per irq and allocate them */
+		bytes = nr * sizeof(unsigned int);
+
+		memcpy(desc->kstat_irqs, old_desc->kstat_irqs, bytes);
+	}
+}
+
+static void free_kstat_irqs(struct irq_desc *old_desc, struct irq_desc *desc)
+{
+	if (old_desc->kstat_irqs == desc->kstat_irqs)
+		return;
+
+	kfree(old_desc->kstat_irqs);
+	old_desc->kstat_irqs = NULL;
+}
+
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
+static void free_one_irq_desc(struct irq_desc *old_desc, struct irq_desc *desc)
+{
+	free_kstat_irqs(old_desc, desc);
+	arch_free_chip_data(old_desc, desc);
+}
+
+static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
+						int cpu)
+{
+	struct irq_desc *desc;
+	unsigned int irq;
+	unsigned long flags;
+	int node;
+
+	irq = old_desc->irq;
+
+	spin_lock_irqsave(&sparse_irq_lock, flags);
+
+	/* We have to check it to avoid races with another CPU */
+	desc = irq_desc_ptrs[irq];
+
+	if (desc && old_desc != desc)
+			goto out_unlock;
+
+	node = cpu_to_node(cpu);
+	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
+	printk(KERN_DEBUG "  move irq_desc for %d to cpu %d node %d\n",
+		 irq, cpu, node);
+	if (!desc) {
+		printk(KERN_ERR "can not get new irq_desc for moving\n");
+		/* still use old one */
+		desc = old_desc;
+		goto out_unlock;
+	}
+	init_copy_one_irq_desc(irq, old_desc, desc, cpu);
+
+	irq_desc_ptrs[irq] = desc;
+
+	/* free the old one */
+	free_one_irq_desc(old_desc, desc);
+	kfree(old_desc);
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
+	/* those all static, do move them */
+	if (desc->irq < NR_IRQS_LEGACY)
+		return desc;
+
+	old_cpu = desc->cpu;
+	printk(KERN_DEBUG
+		 "try to move irq_desc from cpu %d to %d\n", old_cpu, cpu);
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
+
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index d257e7d..f6b3440 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
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
 
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index dd364c1..3738107 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -91,6 +91,9 @@ static int misrouted_irq(int irq)
 	int i, ok = 0;
 
 	for_each_irq_desc(i, desc) {
+		if (!desc)
+			continue;
+
 		if (!i)
 			 continue;
 
@@ -112,6 +115,8 @@ static void poll_spurious_irqs(unsigned long dummy)
 	for_each_irq_desc(i, desc) {
 		unsigned int status;
 
+		if (!desc)
+			continue;
 		if (!i)
 			 continue;
 
