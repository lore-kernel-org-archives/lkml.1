Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbYKKG35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbYKKG35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 01:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYKKG3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 01:29:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:44034 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbYKKG3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 01:29:43 -0500
Message-ID: <4919262B.7030506@kernel.org>
Date: Mon, 10 Nov 2008 22:28:59 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] sparse_irq aka dyn_irq v11
References: <4913F9AA.80500@kernel.org> <20081107084240.GG4435@elte.hu> <491434FB.2050904@kernel.org> <20081107124957.GA21709@elte.hu> <49168BD3.5010204@kernel.org> <20081109073813.GA17180@elte.hu> <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com> <20081110094033.GL22392@elte.hu> <20081110015511.453a801e.akpm@linux-foundation.org> <4918065A.6050402@kernel.org> <20081110100329.GA19970@elte.hu>
In-Reply-To: <20081110100329.GA19970@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

done. please check it.
fix compiling problem on every config

---

From: Yinghai Lu <yinghai@kernel.org>
Subject: sparseirq v11

impact: new feature sparseirq

add some kind of hash table as Ingo suggesting.
remove dyna_array
when sparse_irq is used, use kzalloc_node to get irq_desc, irq_cfg
  use desc->chip_data for x86 to store irq_cfg
  make irq_desc to go with affinity aka irq_desc moving etc
  call move_irq_desc in irq_complete_move()
  need to add struct (irq_desc **descp) to ack_edge/level to make sure desc get updated
  try to pass desc cfg as more possible to avoid list look up.
  legacy irq_desc is not moved, because they are allocated via static array

  for logical apic mode, need to add move_desc_in_progress_in_same_domain. otherwise it will not get moved. ==> also could need two phase to get irq_desc moved.
	for example: 0xff is old affinity, and need to set 0xf, and then set to 0xf0.
	[ or we need to change domain definition to cpus on the same node ? ]

LBSuse:~ # cat /proc/irq/22/smp_affinity
00000000,00000000,00000000,000000ff
LBSuse:~ # echo f > /proc/irq/22/smp_affinity
LBSuse:~ # cat /proc/irq/22/smp_affinity
00000000,00000000,00000000,0000000f
LBSuse:~ # tail /var/log/messages
...
Oct 27 12:35:34 LBSuse kernel: klogd 1.4.1, log source = /proc/kmsg started.
Oct 27 12:35:34 LBSuse kernel: eth0: no IPv6 routers present
LBSuse:~ # echo f0 > /proc/irq/22/smp_affinity
LBSuse:~ # tail /var/log/messages
Oct 27 12:35:34 LBSuse kernel: klogd 1.4.1, log source = /proc/kmsg started.
Oct 27 12:35:34 LBSuse kernel: eth0: no IPv6 routers present
Oct 27 12:36:46 LBSuse kernel:   move irq_desc for 22 aka 0x16 to cpu 7 node 1
Oct 27 12:36:46 LBSuse kernel:   alloc kstat_irqs on cpu 7 node 1
Oct 27 12:36:46 LBSuse kernel:   alloc irq_cfg on cpu 7 node 1
Oct 27 12:36:46 LBSuse kernel:   alloc irq_2_pin on cpu 7 node 1

so assume the user space program should update /proc/irq/XX/smp_affinity to 03 or 0f at first on boot
or we change irq_default_affinity ?

  for physical apic is much simple
on 4 sockets 16 cores system
irq_desc is moving..
when
# echo 10 > /proc/irq/134483967/smp_affinity
# echo 100 > /proc/irq/134483967/smp_affinity
# echo 1000 > /proc/irq/134483967/smp_affinity
got
Nov  9 21:39:51 LBSuse kernel:   move irq_desc for 134483967 aka 0x8040fff to cpu 4 node 1
Nov  9 21:39:51 LBSuse kernel:   alloc kstat_irqs on cpu 4 node 1
Nov  9 21:39:51 LBSuse kernel:   alloc irq_cfg on cpu 4 node 1
Nov  9 21:40:05 LBSuse kernel:   move irq_desc for 134483967 aka 0x8040fff to cpu 8 node 2
Nov  9 21:40:05 LBSuse kernel:   alloc kstat_irqs on cpu 8 node 2
Nov  9 21:40:05 LBSuse kernel:   alloc irq_cfg on cpu 8 node 2
Nov  9 21:40:18 LBSuse kernel:   move irq_desc for 134483967 aka 0x8040fff to cpu 12 node 3
Nov  9 21:40:18 LBSuse kernel:   alloc kstat_irqs on cpu 12 node 3
Nov  9 21:40:18 LBSuse kernel:   alloc irq_cfg on cpu 12 node 3

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/Kconfig                   |   11 
 arch/x86/include/asm/hpet.h        |    5 
 arch/x86/include/asm/irq_vectors.h |    2 
 arch/x86/kernel/hpet.c             |    8 
 arch/x86/kernel/i8259.c            |   37 +-
 arch/x86/kernel/io_apic.c          |  665 ++++++++++++++++++++++++++-----------
 arch/x86/kernel/irq.c              |   24 +
 arch/x86/kernel/irq_32.c           |    2 
 arch/x86/kernel/irq_64.c           |   16 
 arch/x86/kernel/irqinit_32.c       |    3 
 arch/x86/kernel/irqinit_64.c       |    3 
 arch/x86/kernel/uv_irq.c           |   26 +
 arch/x86/mm/init_32.c              |    3 
 drivers/char/random.c              |   31 +
 drivers/pci/htirq.c                |   27 +
 drivers/pci/intel-iommu.c          |    8 
 drivers/pci/intr_remapping.c       |   62 +++
 drivers/pci/msi.c                  |   42 +-
 drivers/xen/events.c               |    9 
 fs/proc/interrupts.c               |   13 
 fs/proc/stat.c                     |   17 
 include/linux/dmar.h               |    5 
 include/linux/htirq.h              |    6 
 include/linux/interrupt.h          |    2 
 include/linux/irq.h                |   78 ++++
 include/linux/irqnr.h              |   15 
 include/linux/kernel_stat.h        |   14 
 include/linux/msi.h                |    6 
 init/main.c                        |    2 
 kernel/irq/autoprobe.c             |   10 
 kernel/irq/chip.c                  |   82 +++-
 kernel/irq/handle.c                |  388 ++++++++++++++++++++-
 kernel/irq/migration.c             |   18 +
 kernel/irq/proc.c                  |    3 
 kernel/irq/spurious.c              |    4 
 35 files changed, 1365 insertions(+), 282 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/arch/x86/Kconfig	2011-02-05 16:34:42.000000000 -0800
@@ -236,6 +236,17 @@
 	def_bool y
 	depends on X86_VOYAGER
 
+config SPARSE_IRQ
+	bool "Support sparse irq numbering"
+	depends on PCI_MSI || HT_IRQ
+	default y
+	help
+	  This enables support for sparse irq, esp for msi/msi-x. the irq
+	  number will be bus/dev/fn + 12bit. You may need if you have lots of
+	  cards supports msi-x installed.
+
+	  If you don't know what to do here, say Y.
+
 config X86_FIND_SMP_CONFIG
 	def_bool y
 	depends on X86_MPPARSE || X86_VOYAGER
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/arch/x86/kernel/io_apic.c	2011-02-05 17:16:28.000000000 -0800
@@ -108,94 +108,240 @@
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
 struct irq_cfg {
-	unsigned int irq;
 	struct irq_pin_list *irq_2_pin;
 	cpumask_t domain;
 	cpumask_t old_domain;
 	unsigned move_cleanup_count;
 	u8 vector;
 	u8 move_in_progress : 1;
+#ifdef CONFIG_SPARSE_IRQ
+	u8 move_desc_in_progress_in_same_domain : 1;
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
+void __init arch_early_irq_init_work(void)
+{
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
 
+	BUG_ON(count > count_desc);
+
+	for (i = 0; i < count; i++) {
+		desc = irq_to_desc(i);
+		desc->chip_data = &cfg[i];
+	}
+}
+
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
 
-/*
- * This is performance-critical, we want to do it O(1)
- *
- * the indexing order of this array favors 1:1 mappings
- * between pins and IRQs.
- */
+void arch_init_chip_data(struct irq_desc *desc, int cpu)
+{
+	struct irq_cfg *cfg;
 
-struct irq_pin_list {
-	int apic, pin;
-	struct irq_pin_list *next;
-};
+	cfg = desc->chip_data;
+	if (!cfg)
+		desc->chip_data = get_one_free_irq_cfg(cpu);
+}
 
-static struct irq_pin_list irq_2_pin_head[PIN_MAP_SIZE];
-static struct irq_pin_list *irq_2_pin_ptr;
+static void init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg,
+				 int cpu);
 
-static void __init irq_2_pin_init(void)
+void arch_init_copy_chip_data(struct irq_desc *old_desc,
+				 struct irq_desc *desc, int cpu)
 {
-	struct irq_pin_list *pin = irq_2_pin_head;
-	int i;
+	struct irq_cfg *cfg;
+	struct irq_cfg *old_cfg;
+
+	cfg = get_one_free_irq_cfg(cpu);
+	desc->chip_data = cfg;
 
-	for (i = 1; i < PIN_MAP_SIZE; i++)
-		pin[i-1].next = &pin[i];
+	old_cfg = old_desc->chip_data;
 
-	irq_2_pin_ptr = &pin[0];
+	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
+
+	init_copy_irq_2_pin(old_cfg, cfg, cpu);
 }
 
-static struct irq_pin_list *get_one_free_irq_2_pin(void)
+static void free_irq_2_pin(struct irq_cfg *cfg);
+
+void arch_free_chip_data(struct irq_desc *desc)
 {
-	struct irq_pin_list *pin = irq_2_pin_ptr;
+	struct irq_cfg *cfg;
 
-	if (!pin)
-		panic("can not get more irq_2_pin\n");
+	cfg = desc->chip_data;
+	if (cfg) {
+		free_irq_2_pin(cfg);
+		free_irq_cfg(cfg);
+		desc->chip_data = NULL;
+	}
+}
 
-	irq_2_pin_ptr = pin->next;
-	pin->next = NULL;
-	return pin;
+static void init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg,
+				 int cpu)
+{
+	struct irq_pin_list *old_entry, *tail, *entry;
+
+	cfg->irq_2_pin = NULL;
+	old_entry = old_cfg->irq_2_pin;
+	if (!old_entry)
+		return;
+
+	entry = get_one_free_irq_2_pin(cpu);
+	entry->apic = old_entry->apic;
+	entry->pin = old_entry->pin;
+	cfg->irq_2_pin = entry;
+	tail = entry;
+	old_entry = old_entry->next;
+
+	while (old_entry) {
+		entry = get_one_free_irq_2_pin(cpu);
+		entry->apic = old_entry->apic;
+		entry->pin = old_entry->pin;
+		tail->next = entry;
+		tail = entry;
+		old_entry = old_entry->next;
+	}
+
+	tail->next = NULL;
+}
+
+static void free_irq_2_pin(struct irq_cfg *cfg)
+{
+	struct irq_pin_list *entry, *next;
+
+	entry = cfg->irq_2_pin;
+
+	while (entry) {
+		next = entry->next;
+		kfree(entry);
+		entry = next;
+	}
+	cfg->irq_2_pin = NULL;
+}
+
+
+static void set_extra_move_desc(struct irq_desc *desc, cpumask_t mask)
+{
+#ifdef CONFIG_SMP
+	struct irq_cfg *cfg = desc->chip_data;
+
+	if (!cfg->move_in_progress) {
+		/* it means domain is not changed */
+		cpumask_t tmp;
+
+		cpus_and(tmp, desc->affinity, mask);
+		if (cpus_empty(tmp))
+			cfg->move_desc_in_progress_in_same_domain = 1;
+	}
+#endif
+}
+
+#else
+static struct irq_cfg *irq_cfg(unsigned int irq)
+{
+	return irq < nr_irqs ? irq_cfgx + irq : NULL;
 }
 
+static inline void set_extra_move_desc(struct irq_desc *desc, cpumask_t mask)
+{
+}
+
+#endif
+
 struct io_apic {
 	unsigned int index;
 	unsigned int unused[3];
@@ -237,11 +383,10 @@
 	writel(value, &io_apic->data);
 }
 
-static bool io_apic_level_ack_pending(unsigned int irq)
+static bool io_apic_level_ack_pending(unsigned int irq, struct irq_cfg *cfg)
 {
 	struct irq_pin_list *entry;
 	unsigned long flags;
-	struct irq_cfg *cfg = irq_cfg(irq);
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	entry = cfg->irq_2_pin;
@@ -323,13 +468,12 @@
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
@@ -359,7 +503,7 @@
 	}
 }
 
-static int assign_irq_vector(int irq, cpumask_t mask);
+static int assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask);
 
 static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 {
@@ -373,10 +517,13 @@
 	if (cpus_empty(tmp))
 		return;
 
-	cfg = irq_cfg(irq);
-	if (assign_irq_vector(irq, mask))
+	desc = irq_to_desc(irq);
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 	/*
@@ -384,9 +531,8 @@
 	 */
 	dest = SET_APIC_LOGICAL_ID(dest);
 
-	desc = irq_to_desc(irq);
 	spin_lock_irqsave(&ioapic_lock, flags);
-	__target_IO_APIC_irq(irq, dest, cfg->vector);
+	__target_IO_APIC_irq(irq, dest, cfg);
 	desc->affinity = mask;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
@@ -397,16 +543,13 @@
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
@@ -421,20 +564,31 @@
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
+	struct irq_cfg *cfg;
+	struct irq_desc *desc;
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
 
@@ -451,18 +605,16 @@
 
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
@@ -475,9 +627,9 @@
 	}
 }
 
-static void __unmask_IO_APIC_irq(unsigned int irq)
+static void __unmask_IO_APIC_irq(struct irq_cfg *cfg)
 {
-	io_apic_modify_irq(irq, ~IO_APIC_REDIR_MASKED, 0, NULL);
+	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED, 0, NULL);
 }
 
 #ifdef CONFIG_X86_64
@@ -492,44 +644,62 @@
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
+#ifdef CONFIG_SPARSE_IRQ
+static void mask_IO_APIC_irq(unsigned int irq, struct irq_desc **descp)
+{
+#else
+static void mask_IO_APIC_irq(unsigned int irq)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc **descp = &desc;
+#endif
+	struct irq_cfg *cfg = (*descp)->chip_data;
 	unsigned long flags;
 
+	BUG_ON(!cfg);
+
 	spin_lock_irqsave(&ioapic_lock, flags);
-	__mask_IO_APIC_irq(irq);
+	__mask_IO_APIC_irq(cfg);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void unmask_IO_APIC_irq (unsigned int irq)
+#ifdef CONFIG_SPARSE_IRQ
+static void unmask_IO_APIC_irq(unsigned int irq, struct irq_desc **descp)
 {
+#else
+static void unmask_IO_APIC_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc **descp = &desc;
+#endif
+	struct irq_cfg *cfg = (*descp)->chip_data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	__unmask_IO_APIC_irq(irq);
+	__unmask_IO_APIC_irq(cfg);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
@@ -809,7 +979,7 @@
  */
 static int EISA_ELCR(unsigned int irq)
 {
-	if (irq < 16) {
+	if (irq < NR_IRQS_LEGACY) {
 		unsigned int port = 0x4d0 + (irq >> 3);
 		return (inb(port) >> (irq & 7)) & 1;
 	}
@@ -1034,7 +1204,7 @@
 	spin_unlock(&vector_lock);
 }
 
-static int __assign_irq_vector(int irq, cpumask_t mask)
+static int __assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1050,16 +1220,13 @@
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
@@ -1113,24 +1280,22 @@
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
@@ -1148,14 +1313,16 @@
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
@@ -1205,7 +1372,8 @@
 {
 	struct irq_desc *desc;
 
-	desc = irq_to_desc(irq);
+	/* could be first time to use this irq_desc */
+	desc = irq_to_desc_alloc(irq);
 
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
 	    trigger == IOAPIC_LEVEL)
@@ -1310,7 +1478,7 @@
 	cfg = irq_cfg(irq);
 
 	mask = TARGET_CPUS;
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
 	cpus_and(mask, cfg->domain, mask);
@@ -1327,12 +1495,12 @@
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
@@ -1434,6 +1602,7 @@
 	union IO_APIC_reg_03 reg_03;
 	unsigned long flags;
 	struct irq_cfg *cfg;
+	struct irq_desc *desc;
 	unsigned int irq;
 
 	if (apic_verbosity == APIC_QUIET)
@@ -1523,8 +1692,10 @@
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
@@ -1535,7 +1706,7 @@
 			entry = entry->next;
 		}
 		printk("\n");
-	}
+	} end_for_each_irq_desc();
 
 	printk(KERN_INFO ".................................... done.\n");
 
@@ -2008,14 +2179,16 @@
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
@@ -2078,10 +2251,9 @@
  * as simple as edge triggered migration and we can do the irq migration
  * with a simple atomic update to IO-APIC RTE.
  */
-static void migrate_ioapic_irq(int irq, cpumask_t mask)
+static void migrate_ioapic_irq(int irq, struct irq_desc *desc, cpumask_t mask)
 {
 	struct irq_cfg *cfg;
-	struct irq_desc *desc;
 	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
 	int modify_ioapic_rte;
@@ -2095,18 +2267,19 @@
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
 
@@ -2128,14 +2301,18 @@
 	desc->affinity = mask;
 }
 
-static int migrate_irq_remapped_level(int irq)
+static int migrate_irq_remapped_level(int irq, struct irq_desc *desc)
 {
 	int ret = -1;
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_cfg *cfg = desc->chip_data;
 
+#ifdef CONFIG_SPARSE_IRQ
+	mask_IO_APIC_irq(irq, &desc);
+#else
 	mask_IO_APIC_irq(irq);
+#endif
 
-	if (io_apic_level_ack_pending(irq)) {
+	if (io_apic_level_ack_pending(irq, cfg)) {
 		/*
 		 * Interrupt in progress. Migrating irq now will change the
 		 * vector information in the IO-APIC RTE and that will confuse
@@ -2147,14 +2324,19 @@
 	}
 
 	/* everthing is clear. we have right of way */
-	migrate_ioapic_irq(irq, desc->pending_mask);
+	migrate_ioapic_irq(irq, desc, desc->pending_mask);
 
 	ret = 0;
 	desc->status &= ~IRQ_MOVE_PENDING;
 	cpus_clear(desc->pending_mask);
 
 unmask:
+#ifdef CONFIG_SPARSE_IRQ
+	unmask_IO_APIC_irq(irq, &desc);
+#else
 	unmask_IO_APIC_irq(irq);
+#endif
+
 	return ret;
 }
 
@@ -2178,7 +2360,7 @@
 			desc->chip->set_affinity(irq, desc->pending_mask);
 			spin_unlock_irqrestore(&desc->lock, flags);
 		}
-	}
+	} end_for_each_irq_desc();
 }
 
 /*
@@ -2191,11 +2373,11 @@
 	if (desc->status & IRQ_LEVEL) {
 		desc->status |= IRQ_MOVE_PENDING;
 		desc->pending_mask = mask;
-		migrate_irq_remapped_level(irq);
+		migrate_irq_remapped_level(irq, desc);
 		return;
 	}
 
-	migrate_ioapic_irq(irq, mask);
+	migrate_ioapic_irq(irq, desc, mask);
 }
 #endif
 
@@ -2236,19 +2418,40 @@
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
+#ifdef CONFIG_SPARSE_IRQ
+		if (likely(!cfg->move_desc_in_progress_in_same_domain))
+			return;
+
+		/* domain is not change, but affinity is changed */
+		me = smp_processor_id();
+		if (cpu_isset(me, desc->affinity)) {
+			*descp = desc = move_irq_desc(desc, me);
+			/* get the new one */
+			cfg = desc->chip_data;
+			cfg->move_desc_in_progress_in_same_domain = 0;
+		}
+#endif
 		return;
+	}
 
 	vector = ~get_irq_regs()->orig_ax;
 	me = smp_processor_id();
 	if ((vector == cfg->vector) && cpu_isset(me, cfg->domain)) {
 		cpumask_t cleanup_mask;
 
+#ifdef CONFIG_SPARSE_IRQ
+		*descp = desc = move_irq_desc(desc, me);
+		/* get the new one */
+		cfg = desc->chip_data;
+#endif
+
 		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
 		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
 		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
@@ -2256,43 +2459,76 @@
 	}
 }
 #else
-static inline void irq_complete_move(unsigned int irq) {}
+static inline void irq_complete_move(struct irq_desc **descp) {}
 #endif
 #ifdef CONFIG_INTR_REMAP
+#ifdef CONFIG_SPARSE_IRQ
+static void ack_x2apic_level(unsigned int irq, struct irq_desc **descp)
+#else
 static void ack_x2apic_level(unsigned int irq)
+#endif
 {
 	ack_x2APIC_irq();
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+static void ack_x2apic_edge(unsigned int irq, struct irq_desc **descp)
+#else
 static void ack_x2apic_edge(unsigned int irq)
+#endif
 {
 	ack_x2APIC_irq();
 }
 #endif
 
+#ifdef CONFIG_SPARSE_IRQ
+static void ack_apic_edge(unsigned int irq, struct irq_desc **descp)
+{
+	irq_complete_move(descp);
+#ifdef CONFIG_SMP
+	move_native_irq(irq, descp);
+#endif
+	ack_APIC_irq();
+}
+#else
 static void ack_apic_edge(unsigned int irq)
 {
-	irq_complete_move(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	irq_complete_move(&desc);
 	move_native_irq(irq);
 	ack_APIC_irq();
 }
+#endif
 
 atomic_t irq_mis_count;
 
+#ifdef CONFIG_SPARSE_IRQ
+static void ack_apic_level(unsigned int irq, struct irq_desc **descp)
+{
+#else
 static void ack_apic_level(unsigned int irq)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc **descp = &desc;
+#endif
 #ifdef CONFIG_X86_32
 	unsigned long v;
 	int i;
 #endif
+	struct irq_cfg *cfg;
 	int do_unmask_irq = 0;
 
-	irq_complete_move(irq);
+	irq_complete_move(descp);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
-	if (unlikely(irq_to_desc(irq)->status & IRQ_MOVE_PENDING)) {
+	if (unlikely((*descp)->status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
+#ifdef CONFIG_SPARSE_IRQ
+		mask_IO_APIC_irq(irq, descp);
+#else
 		mask_IO_APIC_irq(irq);
+#endif
 	}
 #endif
 
@@ -2316,7 +2552,8 @@
 	* operation to prevent an edge-triggered interrupt escaping meanwhile.
 	* The idea is from Manfred Spraul.  --macro
 	*/
-	i = irq_cfg(irq)->vector;
+	cfg = (*descp)->chip_data;
+	i = cfg->vector;
 
 	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
 #endif
@@ -2355,17 +2592,27 @@
 		 * accurate and is causing problems then it is a hardware bug
 		 * and you can go talk to the chipset vendor about it.
 		 */
-		if (!io_apic_level_ack_pending(irq))
+		cfg = (*descp)->chip_data;
+#ifdef CONFIG_SPARSE_IRQ
+		if (!io_apic_level_ack_pending(irq, cfg)) {
+# ifdef CONFIG_SMP
+			move_masked_irq(irq, descp);
+# endif
+		}
+		unmask_IO_APIC_irq(irq, descp);
+#else
+		if (!io_apic_level_ack_pending(irq, cfg))
 			move_masked_irq(irq);
 		unmask_IO_APIC_irq(irq);
+#endif
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
@@ -2416,29 +2663,32 @@
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
  * The local APIC irq-chip implementation:
  */
 
-static void mask_lapic_irq(unsigned int irq)
+#ifdef CONFIG_SPARSE_IRQ
+static void mask_lapic_irq (unsigned int irq, struct irq_desc **descp)
+#else
+static void mask_lapic_irq (unsigned int irq)
+#endif
 {
 	unsigned long v;
 
@@ -2446,7 +2696,11 @@
 	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
 }
 
-static void unmask_lapic_irq(unsigned int irq)
+#ifdef CONFIG_SPARSE_IRQ
+static void unmask_lapic_irq (unsigned int irq, struct irq_desc **descp)
+#else
+static void unmask_lapic_irq (unsigned int irq)
+#endif
 {
 	unsigned long v;
 
@@ -2454,7 +2708,11 @@
 	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+static void ack_lapic_irq (unsigned int irq, struct irq_desc **descp)
+#else
 static void ack_lapic_irq (unsigned int irq)
+#endif
 {
 	ack_APIC_irq();
 }
@@ -2574,7 +2832,11 @@
  */
 static inline void __init check_timer(void)
 {
+#ifdef CONFIG_SPARSE_IRQ
+	struct irq_desc *desc = irq_to_desc(0);
+#endif
 	struct irq_cfg *cfg = irq_cfg(0);
+	int cpu = smp_processor_id();
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
 	unsigned int ver;
@@ -2589,7 +2851,7 @@
 	 * get/set the timer IRQ vector:
 	 */
 	disable_8259A_irq(0);
-	assign_irq_vector(0, TARGET_CPUS);
+	assign_irq_vector(0, cfg, TARGET_CPUS);
 
 	/*
 	 * As IRQ0 is to be enabled in the 8259A, the virtual
@@ -2640,10 +2902,14 @@
 		 * Ok, does IRQ0 through the IOAPIC work?
 		 */
 		if (no_pin1) {
-			add_pin_to_irq(0, apic1, pin1);
+			add_pin_to_irq_cpu(cfg, cpu, apic1, pin1);
 			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
 		}
+#ifdef CONFIG_SPARSE_IRQ
+		unmask_IO_APIC_irq(0, &desc);
+#else
 		unmask_IO_APIC_irq(0);
+#endif
 		if (timer_irq_works()) {
 			if (nmi_watchdog == NMI_IO_APIC) {
 				setup_nmi();
@@ -2669,9 +2935,13 @@
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
-		replace_pin_at_irq(0, apic1, pin1, apic2, pin2);
+		replace_pin_at_irq_cpu(cfg, cpu, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
+#ifdef CONFIG_SPARSE_IRQ
+		unmask_IO_APIC_irq(0, &desc);
+#else
 		unmask_IO_APIC_irq(0);
+#endif
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
@@ -2888,22 +3158,27 @@
 	unsigned int irq;
 	unsigned int new;
 	unsigned long flags;
-	struct irq_cfg *cfg_new;
+	struct irq_cfg *cfg_new = NULL;
+	int cpu;
+	struct irq_desc *desc_new = NULL;
 
+#ifndef CONFIG_SPARSE_IRQ
 	irq_want = nr_irqs - 1;
+#endif
 
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
@@ -2911,6 +3186,9 @@
 
 	if (irq > 0) {
 		dynamic_irq_init(irq);
+		/* restore it, in case dynamic_irq_init clear it */
+		if (desc_new)
+			desc_new->chip_data = cfg_new;
 	}
 	return irq;
 }
@@ -2930,14 +3208,22 @@
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
 
@@ -2952,12 +3238,12 @@
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
 
@@ -3025,10 +3311,13 @@
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	desc = irq_to_desc(irq);
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -3040,7 +3329,6 @@
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg(irq, &msg);
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
 
@@ -3064,10 +3352,13 @@
 	if (get_irte(irq, &irte))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	desc = irq_to_desc(irq);
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -3091,7 +3382,6 @@
 		cfg->move_in_progress = 0;
 	}
 
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
 #endif
@@ -3176,7 +3466,7 @@
 #endif
 		set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
 
-	dev_printk(KERN_DEBUG, &dev->dev, "irq %d for MSI/MSI-X\n", irq);
+	dev_printk(KERN_DEBUG, &dev->dev, "irq %d aka 0x%08x for MSI/MSI-X\n", irq, irq);
 
 	return 0;
 }
@@ -3185,6 +3475,7 @@
 {
 	unsigned int irq;
 
+	/* use 8bits (bus) + 8bits (devfn) + 12 bits */
 	irq = dev->bus->number;
 	irq <<= 8;
 	irq |= dev->devfn;
@@ -3199,7 +3490,7 @@
 	int ret;
 	unsigned int irq_want;
 
-	irq_want = build_irq_for_pci_dev(dev) + 0x100;
+	irq_want = build_irq_for_pci_dev(dev) + 0xfff;
 
 	irq = create_irq_nr(irq_want);
 	if (irq == 0)
@@ -3240,7 +3531,8 @@
 	int index = 0;
 #endif
 
-	irq_want = build_irq_for_pci_dev(dev) + 0x100;
+	/* count from the top 0xfff in 12 bits range */
+	irq_want = build_irq_for_pci_dev(dev) + 0xfff;
 	sub_handle = 0;
 	list_for_each_entry(desc, &dev->msi_list, list) {
 		irq = create_irq_nr(irq_want--);
@@ -3306,10 +3598,13 @@
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	desc = irq_to_desc(irq);
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -3321,7 +3616,6 @@
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
 #endif /* CONFIG_SMP */
@@ -3367,10 +3661,13 @@
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	desc = irq_to_desc(irq);
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -3382,7 +3679,6 @@
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	hpet_msi_write(irq, &msg);
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
 #endif /* CONFIG_SMP */
@@ -3448,15 +3744,17 @@
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	desc = irq_to_desc(irq);
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
 #endif
@@ -3478,13 +3776,13 @@
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
 
@@ -3508,7 +3806,8 @@
 		set_irq_chip_and_handler_name(irq, &ht_irq_chip,
 					      handle_edge_irq, "edge");
 
-		dev_printk(KERN_DEBUG, &dev->dev, "irq %d for HT\n", irq);
+		dev_printk(KERN_DEBUG, &dev->dev, "irq %d aka 0x%08x for HT\n",
+				 irq, irq);
 	}
 	return err;
 }
@@ -3530,7 +3829,9 @@
 	unsigned long flags;
 	int err;
 
-	err = assign_irq_vector(irq, *eligible_cpu);
+	cfg = irq_cfg(irq);
+
+	err = assign_irq_vector(irq, cfg, *eligible_cpu);
 	if (err != 0)
 		return err;
 
@@ -3539,8 +3840,6 @@
 				      irq_name);
 	spin_unlock_irqrestore(&vector_lock, flags);
 
-	cfg = irq_cfg(irq);
-
 	mmr_value = 0;
 	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
 	BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
@@ -3594,6 +3893,7 @@
 
 int __init probe_nr_irqs(void)
 {
+#ifdef CONFIG_SPARSE_IRQ
 	int idx;
 	int nr = 0;
 #ifndef CONFIG_XEN
@@ -3611,10 +3911,11 @@
 	/* something wrong ? */
 	if (nr < nr_min)
 		nr = nr_min;
-	if (WARN_ON(nr > NR_IRQS))
-		nr = NR_IRQS;
 
 	return nr;
+#else
+	return NR_IRQS;
+#endif
 }
 
 /* --------------------------------------------------------------------------
@@ -3722,7 +4023,7 @@
 	/*
 	 * IRQs < 16 are already in the irq_2_pin[] map
 	 */
-	if (irq >= 16)
+	if (irq >= NR_IRQS_LEGACY)
 		add_pin_to_irq(irq, ioapic, pin);
 
 	setup_IO_APIC_irq(ioapic, pin, irq, triggering, polarity);
@@ -3852,7 +4153,6 @@
 	struct resource *ioapic_res;
 	int i;
 
-	irq_2_pin_init();
 	ioapic_res = ioapic_setup_resources();
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
Index: linux-2.6/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit_32.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/arch/x86/kernel/irqinit_32.c	2011-02-05 16:34:42.000000000 -0800
@@ -68,8 +68,7 @@
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
--- linux-2.6.orig/arch/x86/kernel/irqinit_64.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/arch/x86/kernel/irqinit_64.c	2011-02-05 16:34:42.000000000 -0800
@@ -142,8 +142,7 @@
 	init_bsp_APIC();
 	init_8259A(0);
 
-	for (i = 0; i < 16; i++) {
-		/* first time call this irq_desc */
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
 		struct irq_desc *desc = irq_to_desc(i);
 
 		desc->status = IRQ_DISABLED;
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/arch/x86/mm/init_32.c	2011-02-05 16:34:42.000000000 -0800
@@ -66,6 +66,7 @@
 static unsigned long __meminitdata table_top;
 
 static int __initdata after_init_bootmem;
+int after_bootmem;
 
 static __init void *alloc_low_page(unsigned long *phys)
 {
@@ -987,6 +988,8 @@
 
 	set_highmem_pages_init();
 
+	after_bootmem = 1;
+
 	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
Index: linux-2.6/drivers/char/random.c
===================================================================
--- linux-2.6.orig/drivers/char/random.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/drivers/char/random.c	2011-02-05 16:34:42.000000000 -0800
@@ -558,6 +558,8 @@
 	unsigned dont_count_entropy:1;
 };
 
+#ifndef CONFIG_SPARSE_IRQ
+
 static struct timer_rand_state *irq_timer_state[NR_IRQS];
 
 static struct timer_rand_state *get_timer_rand_state(unsigned int irq)
@@ -576,6 +578,33 @@
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
@@ -933,8 +962,10 @@
 {
 	struct timer_rand_state *state;
 
+#ifndef CONFIG_SPARSE_IRQ
 	if (irq >= nr_irqs)
 		return;
+#endif
 
 	state = get_timer_rand_state(irq);
 
Index: linux-2.6/drivers/pci/htirq.c
===================================================================
--- linux-2.6.orig/drivers/pci/htirq.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/drivers/pci/htirq.c	2011-02-05 16:34:42.000000000 -0800
@@ -58,7 +58,11 @@
 	*msg = cfg->msg;
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+void mask_ht_irq(unsigned int irq, struct irq_desc **descp)
+#else
 void mask_ht_irq(unsigned int irq)
+#endif
 {
 	struct ht_irq_cfg *cfg;
 	struct ht_irq_msg msg;
@@ -70,7 +74,11 @@
 	write_ht_irq_msg(irq, &msg);
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+void unmask_ht_irq(unsigned int irq, struct irq_desc **descp)
+#else
 void unmask_ht_irq(unsigned int irq)
+#endif
 {
 	struct ht_irq_cfg *cfg;
 	struct ht_irq_msg msg;
@@ -82,6 +90,19 @@
 	write_ht_irq_msg(irq, &msg);
 }
 
+static unsigned int build_irq_for_pci_dev(struct pci_dev *dev)
+{
+	unsigned int irq;
+
+	/* use 8bits (bus) + 8bits (devfn) + 12 bits */
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
@@ -98,6 +119,7 @@
 	int max_irq;
 	int pos;
 	int irq;
+	unsigned int irq_want;
 
 	pos = pci_find_ht_capability(dev, HT_CAPTYPE_IRQ);
 	if (!pos)
@@ -125,7 +147,12 @@
 	cfg->msg.address_lo = 0xffffffff;
 	cfg->msg.address_hi = 0xffffffff;
 
+	irq_want = build_irq_for_pci_dev(dev);
+#ifdef CONFIG_SPARSE_IRQ
+	irq = create_irq_nr(irq_want + idx);
+#else
 	irq = create_irq();
+#endif
 
 	if (irq <= 0) {
 		kfree(cfg);
Index: linux-2.6/drivers/pci/intr_remapping.c
===================================================================
--- linux-2.6.orig/drivers/pci/intr_remapping.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/drivers/pci/intr_remapping.c	2011-02-05 16:34:42.000000000 -0800
@@ -19,17 +19,73 @@
 	u8  irte_mask;
 };
 
-static struct irq_2_iommu irq_2_iommuX[NR_IRQS];
+#ifdef CONFIG_SPARSE_IRQ
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
+	if (WARN_ON_ONCE(!desc))
+		return NULL;
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
 
@@ -86,9 +142,11 @@
 	if (!count)
 		return -1;
 
+#ifndef CONFIG_SPARSE_IRQ
 	/* protect irq_2_iommu_alloc later */
 	if (irq >= nr_irqs)
 		return -1;
+#endif
 
 	/*
 	 * start the IRTE search from index 0.
Index: linux-2.6/drivers/xen/events.c
===================================================================
--- linux-2.6.orig/drivers/xen/events.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/drivers/xen/events.c	2011-02-05 16:34:42.000000000 -0800
@@ -141,8 +141,9 @@
 	int i;
 
 	/* By default all event channels notify CPU#0. */
-	for_each_irq_desc(i, desc)
+	for_each_irq_desc(i, desc) {
 		desc->affinity = cpumask_of_cpu(0);
+	} end_for_each_irq_desc();
 #endif
 
 	memset(cpu_evtchn, 0, sizeof(cpu_evtchn));
@@ -231,7 +232,7 @@
 	int irq;
 
 	/* Only allocate from dynirq range */
-	for_each_irq_nr(irq)
+	for (irq = 0; irq < nr_irqs; irq++)
 		if (irq_bindcount[irq] == 0)
 			break;
 
@@ -792,7 +793,7 @@
 		mask_evtchn(evtchn);
 
 	/* No IRQ <-> event-channel mappings. */
-	for_each_irq_nr(irq)
+	for (irq = 0; irq < nr_irqs; irq++)
 		irq_info[irq].evtchn = 0; /* zap event-channel binding */
 
 	for (evtchn = 0; evtchn < NR_EVENT_CHANNELS; evtchn++)
@@ -824,7 +825,7 @@
 		mask_evtchn(i);
 
 	/* Dynamic IRQ space is currently unbound. Zero the refcnts. */
-	for_each_irq_nr(i)
+	for (i = 0; i < nr_irqs; i++)
 		irq_bindcount[i] = 0;
 
 	irq_ctx_init(smp_processor_id());
Index: linux-2.6/fs/proc/stat.c
===================================================================
--- linux-2.6.orig/fs/proc/stat.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/fs/proc/stat.c	2011-02-05 16:34:42.000000000 -0800
@@ -27,6 +27,9 @@
 	u64 sum = 0;
 	struct timespec boottime;
 	unsigned int per_irq_sum;
+#ifdef CONFIG_GENERIC_HARDIRQS
+	struct irq_desc *desc;
+#endif
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
@@ -44,10 +47,9 @@
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
@@ -90,14 +92,17 @@
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
 	/* sum again ? it could be updated? */
-	for_each_irq_nr(j) {
+	for_each_irq_desc(j, desc) {
 		per_irq_sum = 0;
-
 		for_each_possible_cpu(i)
 			per_irq_sum += kstat_irqs_cpu(j, i);
 
+#ifdef CONFIG_SPARSE_IRQ
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
--- linux-2.6.orig/fs/proc/interrupts.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/fs/proc/interrupts.c	2011-02-05 16:34:42.000000000 -0800
@@ -10,20 +10,31 @@
  */
 static void *int_seq_start(struct seq_file *f, loff_t *pos)
 {
+#ifdef CONFIG_SPARSE_IRQ
+	rcu_read_lock();
+	return seq_list_start(&sparse_irqs_head, *pos);
+#else
 	return (*pos <= nr_irqs) ? pos : NULL;
+#endif
 }
 
 static void *int_seq_next(struct seq_file *f, void *v, loff_t *pos)
 {
+#ifdef CONFIG_SPARSE_IRQ
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
+#ifdef CONFIG_SPARSE_IRQ
+	rcu_read_unlock();
+#endif
 }
 
 static const struct seq_operations int_seq_ops = {
Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/include/linux/interrupt.h	2011-02-05 16:34:42.000000000 -0800
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
--- linux-2.6.orig/include/linux/irq.h	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/include/linux/irq.h	2011-02-05 17:04:19.000000000 -0800
@@ -106,11 +106,19 @@
 	void		(*enable)(unsigned int irq);
 	void		(*disable)(unsigned int irq);
 
-	void		(*ack)(unsigned int irq);
+#ifdef CONFIG_SPARSE_IRQ
+	void		(*mask)(unsigned int irq, struct irq_desc **descp);
+	void		(*unmask)(unsigned int irq, struct irq_desc **descp);
+	void		(*ack)(unsigned int irq, struct irq_desc **descp);
+	void		(*mask_ack)(unsigned int irq, struct irq_desc **descp);
+	void		(*eoi)(unsigned int irq, struct irq_desc **descp);
+#else
 	void		(*mask)(unsigned int irq);
-	void		(*mask_ack)(unsigned int irq);
 	void		(*unmask)(unsigned int irq);
+	void		(*ack)(unsigned int irq);
+	void		(*mask_ack)(unsigned int irq);
 	void		(*eoi)(unsigned int irq);
+#endif
 
 	void		(*end)(unsigned int irq);
 	void		(*set_affinity)(unsigned int irq, cpumask_t dest);
@@ -129,6 +137,8 @@
 	const char	*typename;
 };
 
+struct timer_rand_state;
+struct irq_2_iommu;
 /**
  * struct irq_desc - interrupt descriptor
  *
@@ -155,6 +165,15 @@
  */
 struct irq_desc {
 	unsigned int		irq;
+#ifdef CONFIG_SPARSE_IRQ
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
@@ -182,13 +201,54 @@
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
+extern struct irq_desc *irq_to_desc(unsigned int irq);
+extern struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu);
+extern struct irq_desc *irq_to_desc_alloc(unsigned int irq);
+extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int cpu);
+extern void arch_early_irq_init_work(void);
+extern void arch_init_chip_data(struct irq_desc *desc, int cpu);
+extern void arch_init_copy_chip_data(struct irq_desc *old_desc,
+					struct irq_desc *desc, int cpu);
+extern void arch_free_chip_data(struct irq_desc *desc);
+
+#ifndef CONFIG_SPARSE_IRQ
 
+/* could be removed if we get rid of all irq_desc reference */
 extern struct irq_desc irq_desc[NR_IRQS];
 
-static inline struct irq_desc *irq_to_desc(unsigned int irq)
-{
-	return (irq < nr_irqs) ? irq_desc + irq : NULL;
-}
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
+void early_irq_init_work(void);
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
 
 /*
  * Migration helpers for obsolete names, they will go away:
@@ -211,8 +271,13 @@
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 
+#ifdef CONFIG_SPARSE_IRQ
+void move_native_irq(int irq, struct irq_desc **descp);
+void move_masked_irq(int irq, struct irq_desc **descp);
+#else
 void move_native_irq(int irq);
 void move_masked_irq(int irq);
+#endif
 
 #else /* CONFIG_GENERIC_PENDING_IRQ */
 
Index: linux-2.6/include/linux/kernel_stat.h
===================================================================
--- linux-2.6.orig/include/linux/kernel_stat.h	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/include/linux/kernel_stat.h	2011-02-05 16:34:42.000000000 -0800
@@ -28,7 +28,9 @@
 
 struct kernel_stat {
 	struct cpu_usage_stat	cpustat;
-	unsigned int irqs[NR_IRQS];
+#ifndef CONFIG_SPARSE_IRQ
+       unsigned int irqs[NR_IRQS];
+#endif
 };
 
 DECLARE_PER_CPU(struct kernel_stat, kstat);
@@ -39,6 +41,10 @@
 
 extern unsigned long long nr_context_switches(void);
 
+#ifndef CONFIG_SPARSE_IRQ
+#define kstat_irqs_this_cpu(irq) \
+	(kstat_this_cpu.irqs[irq])
+
 struct irq_desc;
 
 static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
@@ -46,11 +52,17 @@
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
--- linux-2.6.orig/kernel/irq/autoprobe.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/kernel/irq/autoprobe.c	2011-02-05 16:34:42.000000000 -0800
@@ -57,7 +57,7 @@
 			desc->chip->startup(i);
 		}
 		spin_unlock_irq(&desc->lock);
-	}
+	} end_for_each_irq_desc();
 
 	/* Wait for longstanding interrupts to trigger. */
 	msleep(20);
@@ -75,7 +75,7 @@
 				desc->status |= IRQ_PENDING;
 		}
 		spin_unlock_irq(&desc->lock);
-	}
+	} end_for_each_irq_desc();
 
 	/*
 	 * Wait for spurious interrupts to trigger
@@ -99,7 +99,7 @@
 					mask |= 1 << i;
 		}
 		spin_unlock_irq(&desc->lock);
-	}
+	} end_for_each_irq_desc();
 
 	return mask;
 }
@@ -135,7 +135,7 @@
 			desc->chip->shutdown(i);
 		}
 		spin_unlock_irq(&desc->lock);
-	}
+	} end_for_each_irq_desc();
 	mutex_unlock(&probing_active);
 
 	return mask & val;
@@ -179,7 +179,7 @@
 			desc->chip->shutdown(i);
 		}
 		spin_unlock_irq(&desc->lock);
-	}
+	} end_for_each_irq_desc();
 	mutex_unlock(&probing_active);
 
 	if (nr_of_irqs > 1)
Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/kernel/irq/chip.c	2011-02-05 16:34:42.000000000 -0800
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
@@ -223,7 +225,11 @@
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
+#ifdef CONFIG_SPARSE_IRQ
+	desc->chip->unmask(irq, &desc);
+#else
 	desc->chip->unmask(irq);
+#endif
 	desc->status &= ~IRQ_MASKED;
 }
 
@@ -252,7 +258,11 @@
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
+#ifdef CONFIG_SPARSE_IRQ
+	desc->chip->mask(irq, &desc);
+#else
 	desc->chip->mask(irq);
+#endif
 	desc->status |= IRQ_MASKED;
 }
 
@@ -282,13 +292,24 @@
 		chip->end = dummy_irq_chip.end;
 }
 
-static inline void mask_ack_irq(struct irq_desc *desc, int irq)
+static inline void mask_ack_irq(struct irq_desc **descp, int irq)
 {
-	if (desc->chip->mask_ack)
+	struct irq_desc *desc = *descp;
+
+	if (desc->chip->mask_ack) {
+#ifdef CONFIG_SPARSE_IRQ
+		desc->chip->mask_ack(irq, descp);
+#else
 		desc->chip->mask_ack(irq);
-	else {
+#endif
+	} else {
+#ifdef CONFIG_SPARSE_IRQ
+		desc->chip->mask(irq, descp);
+		desc->chip->ack(irq, descp);
+#else
 		desc->chip->mask(irq);
 		desc->chip->ack(irq);
+#endif
 	}
 }
 
@@ -351,7 +372,7 @@
 	irqreturn_t action_ret;
 
 	spin_lock(&desc->lock);
-	mask_ack_irq(desc, irq);
+	mask_ack_irq(&desc, irq);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
@@ -375,8 +396,13 @@
 
 	spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
-	if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
+	if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask) {
+#ifdef CONFIG_SPARSE_IRQ
+		desc->chip->unmask(irq, &desc);
+#else
 		desc->chip->unmask(irq);
+#endif
+	}
 out_unlock:
 	spin_unlock(&desc->lock);
 }
@@ -412,8 +438,13 @@
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
 		desc->status |= IRQ_PENDING;
-		if (desc->chip->mask)
+		if (desc->chip->mask) {
+#ifdef CONFIG_SPARSE_IRQ
+			desc->chip->mask(irq, &desc);
+#else
 			desc->chip->mask(irq);
+#endif
+		}
 		goto out;
 	}
 
@@ -428,7 +459,11 @@
 	spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 out:
+#ifdef CONFIG_SPARSE_IRQ
+	desc->chip->eoi(irq, &desc);
+#else
 	desc->chip->eoi(irq);
+#endif
 
 	spin_unlock(&desc->lock);
 }
@@ -464,13 +499,17 @@
 	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
 		    !desc->action)) {
 		desc->status |= (IRQ_PENDING | IRQ_MASKED);
-		mask_ack_irq(desc, irq);
+		mask_ack_irq(&desc, irq);
 		goto out_unlock;
 	}
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
+#ifdef CONFIG_SPARSE_IRQ
+	desc->chip->ack(irq, &desc);
+#else
 	desc->chip->ack(irq);
+#endif
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
@@ -480,7 +519,11 @@
 		irqreturn_t action_ret;
 
 		if (unlikely(!action)) {
+#ifdef CONFIG_SPARSE_IRQ
+			desc->chip->mask(irq, &desc);
+#else
 			desc->chip->mask(irq);
+#endif
 			goto out_unlock;
 		}
 
@@ -492,7 +535,11 @@
 		if (unlikely((desc->status &
 			       (IRQ_PENDING | IRQ_MASKED | IRQ_DISABLED)) ==
 			      (IRQ_PENDING | IRQ_MASKED))) {
+#ifdef CONFIG_SPARSE_IRQ
+			desc->chip->unmask(irq, &desc);
+#else
 			desc->chip->unmask(irq);
+#endif
 			desc->status &= ~IRQ_MASKED;
 		}
 
@@ -524,15 +571,25 @@
 
 	kstat_incr_irqs_this_cpu(irq, desc);
 
-	if (desc->chip->ack)
+	if (desc->chip->ack) {
+#ifdef CONFIG_SPARSE_IRQ
+		desc->chip->ack(irq, &desc);
+#else
 		desc->chip->ack(irq);
+#endif
+	}
 
 	action_ret = handle_IRQ_event(irq, desc->action);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	if (desc->chip->eoi)
+	if (desc->chip->eoi) {
+#ifdef CONFIG_SPARSE_IRQ
+		desc->chip->eoi(irq, &desc);
+#else
 		desc->chip->eoi(irq);
+#endif
+	}
 }
 
 void
@@ -567,8 +624,9 @@
 
 	/* Uninstall? */
 	if (handle == handle_bad_irq) {
-		if (desc->chip != &no_irq_chip)
-			mask_ack_irq(desc, irq);
+		if (desc->chip != &no_irq_chip) {
+			mask_ack_irq(&desc, irq);
+		}
 		desc->status |= IRQ_DISABLED;
 		desc->depth = 1;
 	}
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/kernel/irq/handle.c	2011-02-05 17:00:31.000000000 -0800
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
@@ -49,6 +56,299 @@
 int nr_irqs = NR_IRQS;
 EXPORT_SYMBOL_GPL(nr_irqs);
 
+void __init __attribute__((weak)) arch_early_irq_init_work(void)
+{
+}
+
+#ifdef CONFIG_SPARSE_IRQ
+static struct irq_desc irq_desc_init = {
+	.irq	    = -1U,
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
+		.irq	    = -1U,
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
+void __init early_irq_init_work(void)
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
+	arch_early_irq_init_work();
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
+	list_replace_rcu(&old_desc->hash_entry, &desc->hash_entry);
+	list_replace_rcu(&old_desc->list, &desc->list);
+
+	/* free the old one */
+	free_one_irq_desc(old_desc);
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
+	printk(KERN_DEBUG "try to move irq_desc from cpu %d to %d\n", old_cpu, cpu);
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
@@ -62,18 +362,49 @@
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
  */
-static void ack_bad(unsigned int irq)
+static void ack_bad_desc(unsigned int irq, struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	print_irq_desc(irq, desc);
 	ack_bad_irq(irq);
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+static void ack_bad_wrapper(unsigned int irq, struct irq_desc **descp)
+{
+	ack_bad_desc(irq, *descp);
+}
+#else
+static void ack_bad_wrapper(unsigned int irq)
+{
+	ack_bad_desc(irq, irq_to_desc(irq));
+}
+#endif
+
 /*
  * NOP functions
  */
@@ -81,6 +412,15 @@
 {
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+static void noop_wrapper(unsigned int irq, struct irq_desc **descp)
+#else
+static void noop_wrapper(unsigned int irq)
+#endif
+{
+	noop(irq);
+}
+
 static unsigned int noop_ret(unsigned int irq)
 {
 	return 0;
@@ -95,7 +435,7 @@
 	.shutdown	= noop,
 	.enable		= noop,
 	.disable	= noop,
-	.ack		= ack_bad,
+	.ack		= ack_bad_wrapper,
 	.end		= noop,
 };
 
@@ -109,9 +449,9 @@
 	.shutdown	= noop,
 	.enable		= noop,
 	.disable	= noop,
-	.ack		= noop,
-	.mask		= noop,
-	.unmask		= noop,
+	.ack		= noop_wrapper,
+	.mask		= noop_wrapper,
+	.unmask		= noop_wrapper,
 	.end		= noop,
 };
 
@@ -179,8 +519,13 @@
 		/*
 		 * No locking required for CPU-local interrupts:
 		 */
-		if (desc->chip->ack)
+		if (desc->chip->ack) {
+#ifdef CONFIG_SPARSE_IRQ
+			desc->chip->ack(irq, &desc);
+#else
 			desc->chip->ack(irq);
+#endif
+		}
 		if (likely(!(desc->status & IRQ_DISABLED))) {
 			action_ret = handle_IRQ_event(irq, desc->action);
 			if (!noirqdebug)
@@ -191,8 +536,13 @@
 	}
 
 	spin_lock(&desc->lock);
-	if (desc->chip->ack)
+	if (desc->chip->ack) {
+#ifdef CONFIG_SPARSE_IRQ
+		desc->chip->ack(irq, &desc);
+#else
 		desc->chip->ack(irq);
+#endif
+	}
 	/*
 	 * REPLAY is when Linux resends an IRQ that was dropped earlier
 	 * WAITING is used by probe to mark irqs that are being tested
@@ -261,17 +611,25 @@
 
 
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
--- linux-2.6.orig/arch/x86/kernel/irq.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/arch/x86/kernel/irq.c	2011-02-05 16:34:42.000000000 -0800
@@ -99,25 +99,37 @@
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
@@ -148,6 +160,12 @@
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
--- linux-2.6.orig/include/linux/irqnr.h	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/include/linux/irqnr.h	2011-02-05 16:34:42.000000000 -0800
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
--- linux-2.6.orig/arch/x86/kernel/irq_32.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/arch/x86/kernel/irq_32.c	2011-02-05 16:34:42.000000000 -0800
@@ -254,7 +254,7 @@
 			desc->chip->set_affinity(irq, mask);
 		else if (desc->action && !(warned++))
 			printk("Cannot set affinity for irq %i\n", irq);
-	}
+	} end_for_each_irq_desc();
 
 #if 0
 	barrier();
Index: linux-2.6/arch/x86/kernel/irq_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq_64.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/arch/x86/kernel/irq_64.c	2011-02-05 16:34:42.000000000 -0800
@@ -112,16 +112,26 @@
 			mask = map;
 		}
 
-		if (desc->chip->mask)
+		if (desc->chip->mask) {
+#ifdef CONFIG_SPARSE_IRQ
+			desc->chip->mask(irq, &desc);
+#else
 			desc->chip->mask(irq);
+#endif
+		}
 
 		if (desc->chip->set_affinity)
 			desc->chip->set_affinity(irq, mask);
 		else if (!(warned++))
 			set_affinity = 0;
 
-		if (desc->chip->unmask)
+		if (desc->chip->unmask) {
+#ifdef CONFIG_SPARSE_IRQ
+			desc->chip->unmask(irq, &desc);
+#else
 			desc->chip->unmask(irq);
+#endif
+		}
 
 		spin_unlock(&desc->lock);
 
@@ -129,7 +139,7 @@
 			printk("Broke affinity for irq %i\n", irq);
 		else if (!set_affinity)
 			printk("Cannot set affinity for irq %i\n", irq);
-	}
+	} end_for_each_irq_desc();
 
 	/* That doesn't seem sufficient.  Give it 1ms. */
 	local_irq_enable();
Index: linux-2.6/kernel/irq/proc.c
===================================================================
--- linux-2.6.orig/kernel/irq/proc.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/kernel/irq/proc.c	2011-02-05 16:34:42.000000000 -0800
@@ -243,7 +243,8 @@
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
--- linux-2.6.orig/kernel/irq/spurious.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/kernel/irq/spurious.c	2011-02-05 16:34:42.000000000 -0800
@@ -99,7 +99,7 @@
 
 		if (try_one_irq(i, desc))
 			ok = 1;
-	}
+	} end_for_each_irq_desc();
 	/* So the caller can adjust the irq error counts */
 	return ok;
 }
@@ -122,7 +122,7 @@
 			continue;
 
 		try_one_irq(i, desc);
-	}
+	} end_for_each_irq_desc();
 
 	mod_timer(&poll_spurious_irq_timer,
 		  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/init/main.c	2011-02-05 17:04:54.000000000 -0800
@@ -541,6 +541,15 @@
 {
 }
 
+void __init __attribute__((weak)) arch_early_irq_init_work(void)
+{
+}
+
+void __init __attribute__((weak)) early_irq_init_work(void)
+{
+	arch_early_irq_init_work();
+}
+
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
@@ -611,6 +620,8 @@
 	sort_main_extable();
 	trap_init();
 	rcu_init();
+	/* init some links before init_ISA_irqs() */
+	early_irq_init_work();
 	init_IRQ();
 	pidhash_init();
 	init_timers();
Index: linux-2.6/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq_vectors.h	2011-02-05 16:33:24.000000000 -0800
+++ linux-2.6/arch/x86/include/asm/irq_vectors.h	2011-02-05 16:34:42.000000000 -0800
@@ -101,6 +101,8 @@
 #define LAST_VM86_IRQ		15
 #define invalid_vm86_irq(irq)	((irq) < 3 || (irq) > 15)
 
+#define NR_IRQS_LEGACY		16
+
 #if defined(CONFIG_X86_IO_APIC) && !defined(CONFIG_X86_VOYAGER)
 # if NR_CPUS < MAX_IO_APICS
 #  define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
Index: linux-2.6/arch/x86/kernel/i8259.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/i8259.c	2011-01-26 18:47:17.000000000 -0800
+++ linux-2.6/arch/x86/kernel/i8259.c	2011-02-05 16:34:42.000000000 -0800
@@ -36,12 +36,39 @@
 DEFINE_SPINLOCK(i8259A_lock);
 static void mask_and_ack_8259A(unsigned int);
 
+#ifdef CONFIG_SPARSE_IRQ
+static void mask_and_ack_8259A_wrapper(unsigned int irq, struct irq_desc **descp)
+#else
+static void mask_and_ack_8259A_wrapper(unsigned int irq)
+#endif
+{
+	mask_and_ack_8259A(irq);
+}
+
+#ifdef CONFIG_SPARSE_IRQ
+static void disable_8259A_irq_wrapper(unsigned int irq, struct irq_desc **descp)
+#else
+static void disable_8259A_irq_wrapper(unsigned int irq)
+#endif
+{
+	disable_8259A_irq(irq);
+}
+
+#ifdef CONFIG_SPARSE_IRQ
+static void enable_8259A_irq_wrapper(unsigned int irq, struct irq_desc **descp)
+#else
+static void enable_8259A_irq_wrapper(unsigned int irq)
+#endif
+{
+	enable_8259A_irq(irq);
+}
+
 struct irq_chip i8259A_chip = {
 	.name		= "XT-PIC",
-	.mask		= disable_8259A_irq,
+	.mask		= disable_8259A_irq_wrapper,
 	.disable	= disable_8259A_irq,
-	.unmask		= enable_8259A_irq,
-	.mask_ack	= mask_and_ack_8259A,
+	.unmask		= enable_8259A_irq_wrapper,
+	.mask_ack	= mask_and_ack_8259A_wrapper,
 };
 
 /*
@@ -348,9 +375,9 @@
 		 * In AEOI mode we just have to mask the interrupt
 		 * when acking.
 		 */
-		i8259A_chip.mask_ack = disable_8259A_irq;
+		i8259A_chip.mask_ack = disable_8259A_irq_wrapper;
 	else
-		i8259A_chip.mask_ack = mask_and_ack_8259A;
+		i8259A_chip.mask_ack = mask_and_ack_8259A_wrapper;
 
 	udelay(100);		/* wait for 8259A to initialize */
 
Index: linux-2.6/arch/x86/kernel/uv_irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/uv_irq.c	2011-01-26 18:47:17.000000000 -0800
+++ linux-2.6/arch/x86/kernel/uv_irq.c	2011-02-05 16:34:42.000000000 -0800
@@ -18,6 +18,15 @@
 {
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+static void uv_noop_wrapper(unsigned int irq, struct irq_desc **descp)
+#else
+static void uv_noop_wrapper(unsigned int irq)
+#endif
+{
+	uv_noop(irq);
+}
+
 static unsigned int uv_noop_ret(unsigned int irq)
 {
 	return 0;
@@ -28,16 +37,25 @@
 	ack_APIC_irq();
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+static void uv_ack_apic_wrapper(unsigned int irq, struct irq_desc **descp)
+#else
+static void uv_ack_apic_wrapper(unsigned int irq)
+#endif
+{
+	uv_ack_apic(irq);
+}
+
 struct irq_chip uv_irq_chip = {
 	.name		= "UV-CORE",
 	.startup	= uv_noop_ret,
 	.shutdown	= uv_noop,
 	.enable		= uv_noop,
 	.disable	= uv_noop,
-	.ack		= uv_noop,
-	.mask		= uv_noop,
-	.unmask		= uv_noop,
-	.eoi		= uv_ack_apic,
+	.ack		= uv_noop_wrapper,
+	.mask		= uv_noop_wrapper,
+	.unmask		= uv_noop_wrapper,
+	.eoi		= uv_ack_apic_wrapper,
 	.end		= uv_noop,
 };
 
Index: linux-2.6/drivers/pci/msi.c
===================================================================
--- linux-2.6.orig/drivers/pci/msi.c	2011-01-26 18:47:18.000000000 -0800
+++ linux-2.6/drivers/pci/msi.c	2011-02-05 16:34:42.000000000 -0800
@@ -103,11 +103,11 @@
 	}
 }
 
-static void msix_flush_writes(unsigned int irq)
+static void msix_flush_writes(struct irq_desc *desc)
 {
 	struct msi_desc *entry;
 
-	entry = get_irq_msi(irq);
+	entry = desc->msi_desc;
 	BUG_ON(!entry || !entry->dev);
 	switch (entry->msi_attrib.type) {
 	case PCI_CAP_ID_MSI:
@@ -135,11 +135,11 @@
  * Returns 1 if it succeeded in masking the interrupt and 0 if the device
  * doesn't support MSI masking.
  */
-static int msi_set_mask_bits(unsigned int irq, u32 mask, u32 flag)
+static int msi_set_mask_bits(struct irq_desc *desc, u32 mask, u32 flag)
 {
 	struct msi_desc *entry;
 
-	entry = get_irq_msi(irq);
+	entry = desc->msi_desc;
 	BUG_ON(!entry || !entry->dev);
 	switch (entry->msi_attrib.type) {
 	case PCI_CAP_ID_MSI:
@@ -252,16 +252,30 @@
 	entry->msg = *msg;
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+void mask_msi_irq(unsigned int irq, struct irq_desc **descp)
+{
+	struct irq_desc *desc = *descp;
+#else
 void mask_msi_irq(unsigned int irq)
 {
-	msi_set_mask_bits(irq, 1, 1);
-	msix_flush_writes(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+#endif
+	msi_set_mask_bits(desc, 1, 1);
+	msix_flush_writes(desc);
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+void unmask_msi_irq(unsigned int irq, struct irq_desc **descp)
+{
+	struct irq_desc *desc = *descp;
+#else
 void unmask_msi_irq(unsigned int irq)
 {
-	msi_set_mask_bits(irq, 1, 0);
-	msix_flush_writes(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+#endif
+	msi_set_mask_bits(desc, 1, 0);
+	msix_flush_writes(desc);
 }
 
 static int msi_free_irqs(struct pci_dev* dev);
@@ -303,9 +317,11 @@
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
@@ -327,8 +343,9 @@
 	msix_set_enable(dev, 0);
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
+		struct irq_desc *desc = irq_to_desc(entry->irq);
 		write_msi_msg(entry->irq, &entry->msg);
-		msi_set_mask_bits(entry->irq, 1, entry->msi_attrib.masked);
+		msi_set_mask_bits(desc, 1, entry->msi_attrib.masked);
 	}
 
 	BUG_ON(list_empty(&dev->msi_list));
@@ -596,7 +613,8 @@
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
--- linux-2.6.orig/include/linux/msi.h	2011-01-26 18:47:20.000000000 -0800
+++ linux-2.6/include/linux/msi.h	2011-02-05 16:34:42.000000000 -0800
@@ -10,8 +10,14 @@
 };
 
 /* Helper functions */
+#ifdef CONFIG_SPARSE_IRQ
+struct irq_desc;
+extern void mask_msi_irq(unsigned int irq, struct irq_desc **descp);
+extern void unmask_msi_irq(unsigned int irq, struct irq_desc **descp);
+#else
 extern void mask_msi_irq(unsigned int irq);
 extern void unmask_msi_irq(unsigned int irq);
+#endif
 extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
 extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
 
Index: linux-2.6/arch/x86/include/asm/hpet.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hpet.h	2011-01-26 18:47:17.000000000 -0800
+++ linux-2.6/arch/x86/include/asm/hpet.h	2011-02-05 16:34:42.000000000 -0800
@@ -72,8 +72,13 @@
 extern unsigned long hpet_readl(unsigned long a);
 extern void force_hpet_resume(void);
 
+#ifdef CONFIG_SPARSE_IRQ
+extern void hpet_msi_unmask(unsigned int irq, struct irq_desc **descp);
+extern void hpet_msi_mask(unsigned int irq, struct irq_desc **descp);
+#else
 extern void hpet_msi_unmask(unsigned int irq);
 extern void hpet_msi_mask(unsigned int irq);
+#endif
 extern void hpet_msi_write(unsigned int irq, struct msi_msg *msg);
 extern void hpet_msi_read(unsigned int irq, struct msi_msg *msg);
 
Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c	2011-02-05 16:33:53.000000000 -0800
+++ linux-2.6/arch/x86/kernel/hpet.c	2011-02-05 16:34:42.000000000 -0800
@@ -347,7 +347,11 @@
 static DEFINE_PER_CPU(struct hpet_dev *, cpu_hpet_dev);
 static struct hpet_dev	*hpet_devs;
 
+#ifdef CONFIG_SPARSE_IRQ
+void hpet_msi_unmask(unsigned int irq, struct irq_desc **descp)
+#else
 void hpet_msi_unmask(unsigned int irq)
+#endif
 {
 	struct hpet_dev *hdev = get_irq_data(irq);
 	unsigned long cfg;
@@ -358,7 +362,11 @@
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+void hpet_msi_mask(unsigned int irq, struct irq_desc **descp)
+#else
 void hpet_msi_mask(unsigned int irq)
+#endif
 {
 	unsigned long cfg;
 	struct hpet_dev *hdev = get_irq_data(irq);
Index: linux-2.6/include/linux/htirq.h
===================================================================
--- linux-2.6.orig/include/linux/htirq.h	2011-01-26 18:47:20.000000000 -0800
+++ linux-2.6/include/linux/htirq.h	2011-02-05 16:34:42.000000000 -0800
@@ -9,8 +9,14 @@
 /* Helper functions.. */
 void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
 void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
+#ifdef CONFIG_SPARSE_IRQ
+struct irq_desc;
+void mask_ht_irq(unsigned int irq, struct irq_desc **descp);
+void unmask_ht_irq(unsigned int irq, struct irq_desc **descp);
+#else
 void mask_ht_irq(unsigned int irq);
 void unmask_ht_irq(unsigned int irq);
+#endif
 
 /* The arch hook for getting things started */
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev);
Index: linux-2.6/kernel/irq/migration.c
===================================================================
--- linux-2.6.orig/kernel/irq/migration.c	2011-02-04 11:27:22.000000000 -0800
+++ linux-2.6/kernel/irq/migration.c	2011-02-05 16:34:42.000000000 -0800
@@ -1,9 +1,15 @@
 
 #include <linux/irq.h>
 
+#ifdef CONFIG_SPARSE_IRQ
+void move_masked_irq(int irq, struct irq_desc **descp)
+{
+	struct irq_desc *desc = *descp;
+#else
 void move_masked_irq(int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
+#endif
 	cpumask_t tmp;
 
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
@@ -47,9 +53,15 @@
 	cpus_clear(desc->pending_mask);
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+void move_native_irq(int irq, struct irq_desc **descp)
+{
+	struct irq_desc *desc = *descp;
+#else
 void move_native_irq(int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
+#endif
 
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
@@ -57,8 +69,14 @@
 	if (unlikely(desc->status & IRQ_DISABLED))
 		return;
 
+#ifdef CONFIG_SPARSE_IRQ
+	desc->chip->mask(irq, descp);
+	move_masked_irq(irq, descp);
+	desc->chip->unmask(irq, descp);
+#else
 	desc->chip->mask(irq);
 	move_masked_irq(irq);
 	desc->chip->unmask(irq);
+#endif
 }
 
Index: linux-2.6/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.orig/drivers/pci/intel-iommu.c	2011-01-26 18:47:18.000000000 -0800
+++ linux-2.6/drivers/pci/intel-iommu.c	2011-02-05 16:34:42.000000000 -0800
@@ -751,7 +751,11 @@
 		return fault_reason_strings[fault_reason];
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+void dmar_msi_unmask(unsigned int irq, struct irq_desc **descp)
+#else
 void dmar_msi_unmask(unsigned int irq)
+#endif
 {
 	struct intel_iommu *iommu = get_irq_data(irq);
 	unsigned long flag;
@@ -764,7 +768,11 @@
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
+#ifdef CONFIG_SPARSE_IRQ
+void dmar_msi_mask(unsigned int irq, struct irq_desc **descp)
+#else
 void dmar_msi_mask(unsigned int irq)
+#endif
 {
 	unsigned long flag;
 	struct intel_iommu *iommu = get_irq_data(irq);
Index: linux-2.6/include/linux/dmar.h
===================================================================
--- linux-2.6.orig/include/linux/dmar.h	2011-01-26 18:47:20.000000000 -0800
+++ linux-2.6/include/linux/dmar.h	2011-02-05 16:34:42.000000000 -0800
@@ -122,8 +122,13 @@
 /* Can't use the common MSI interrupt functions
  * since DMAR is not a pci device
  */
+#ifdef CONFIG_SPARSE_IRQ
+extern void dmar_msi_unmask(unsigned int irq, struct irq_desc **descp);
+extern void dmar_msi_mask(unsigned int irq, struct irq_desc **descp);
+#else
 extern void dmar_msi_unmask(unsigned int irq);
 extern void dmar_msi_mask(unsigned int irq);
+#endif
 extern void dmar_msi_read(int irq, struct msi_msg *msg);
 extern void dmar_msi_write(int irq, struct msi_msg *msg);
 extern int dmar_set_interrupt(struct intel_iommu *iommu);

