Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbYLHNjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbYLHNjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 08:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbYLHNja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 08:39:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44161 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbYLHNj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 08:39:27 -0500
Date: Mon, 8 Dec 2008 14:38:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] sparse irq enabling v5
Message-ID: <20081208133859.GB29965@elte.hu>
References: <1228532315-28799-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228532315-28799-1-git-send-email-yinghai@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> impact: new feature sparseirq
> 
> add pointers array as Ingo suggesting.
> remove dyna_array
> 
> when sparse_irq is used (CONFIG_SPARSE_IRQ), use kzalloc_node to get irq_desc, irq_cfg
>   use desc->chip_data for x86 to store irq_cfg
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

thanks Yinghai - i've applied your four patches to tip/irq/sparseirq, 
with the changelogs below.

Jesse, any objections to the MSI IRQ renumbering? It's a much saner 
static numbering scheme counting upwards, independent of NR_CPUS.

	Ingo

---------------->
commit 0b8f1efad30bd58f89961b82dfe68b9edf8fd2ac
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Fri Dec 5 18:58:31 2008 -0800

    sparse irq_desc[] array: core kernel and x86 changes
    
    Impact: new feature
    
    Problem on distro kernels: irq_desc[NR_IRQS] takes megabytes of RAM with
    NR_CPUS set to large values. The goal is to be able to scale up to much
    larger NR_IRQS value without impacting the (important) common case.
    
    To solve this, we generalize irq_desc[NR_IRQS] to an (optional) array of
    irq_desc pointers.
    
    When CONFIG_SPARSE_IRQ=y is used, we use kzalloc_node to get irq_desc,
    this also makes the IRQ descriptors NUMA-local (to the site that calls
    request_irq()).
    
    This gets rid of the irq_cfg[] static array on x86 as well: irq_cfg now
    uses desc->chip_data for x86 to store irq_cfg.
    
    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ac22bb7..48ac688 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -238,6 +238,16 @@ config X86_HAS_BOOT_CPU_ID
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
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 0005adb..bb6b69a 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
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
 
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 9043251..9de17f5 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -108,8 +108,33 @@ static int __init parse_noapic(char *str)
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
@@ -397,16 +432,19 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
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
@@ -421,7 +459,7 @@ static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 		entry = entry->next;
 	}
 
-	entry->next = get_one_free_irq_2_pin();
+	entry->next = get_one_free_irq_2_pin(cpu);
 	entry = entry->next;
 	entry->apic = apic;
 	entry->pin = pin;
@@ -430,7 +468,7 @@ static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 /*
  * Reroute an IRQ to a different pin.
  */
-static void __init replace_pin_at_irq(unsigned int irq,
+static void __init replace_pin_at_irq(unsigned int irq, int cpu,
 				      int oldapic, int oldpin,
 				      int newapic, int newpin)
 {
@@ -451,7 +489,7 @@ static void __init replace_pin_at_irq(unsigned int irq,
 
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
@@ -1356,6 +1398,8 @@ static void __init setup_IO_APIC_irqs(void)
 {
 	int apic, pin, idx, irq;
 	int notcon = 0;
+	struct irq_desc *desc;
+	int cpu = boot_cpu_id;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
@@ -1387,7 +1431,12 @@ static void __init setup_IO_APIC_irqs(void)
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
@@ -1448,6 +1497,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	union IO_APIC_reg_03 reg_03;
 	unsigned long flags;
 	struct irq_cfg *cfg;
+	struct irq_desc *desc;
 	unsigned int irq;
 
 	if (apic_verbosity == APIC_QUIET)
@@ -1537,8 +1587,13 @@ __apicdebuginit(void) print_IO_APIC(void)
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
@@ -2022,6 +2077,7 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 {
 	int was_pending = 0;
 	unsigned long flags;
+	struct irq_cfg *cfg;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	if (irq < 16) {
@@ -2029,6 +2085,7 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 		if (i8259A_irq_pending(irq))
 			was_pending = 1;
 	}
+	cfg = irq_cfg(irq);
 	__unmask_IO_APIC_irq(irq);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
@@ -2178,6 +2235,9 @@ static void ir_irq_migration(struct work_struct *work)
 	struct irq_desc *desc;
 
 	for_each_irq_desc(irq, desc) {
+		if (!desc)
+			continue;
+
 		if (desc->status & IRQ_MOVE_PENDING) {
 			unsigned long flags;
 
@@ -2229,6 +2289,9 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 		struct irq_cfg *cfg;
 		irq = __get_cpu_var(vector_irq)[vector];
 
+		if (irq == -1)
+			continue;
+
 		desc = irq_to_desc(irq);
 		if (!desc)
 			continue;
@@ -2430,8 +2493,12 @@ static inline void init_IO_APIC_traps(void)
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
@@ -2439,11 +2506,9 @@ static inline void init_IO_APIC_traps(void)
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
@@ -2654,7 +2719,7 @@ static inline void __init check_timer(void)
 		 * Ok, does IRQ0 through the IOAPIC work?
 		 */
 		if (no_pin1) {
-			add_pin_to_irq(0, apic1, pin1);
+			add_pin_to_irq_cpu(0, boot_cpu_id, apic1, pin1);
 			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
 		}
 		unmask_IO_APIC_irq(0);
@@ -2683,7 +2748,7 @@ static inline void __init check_timer(void)
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
-		replace_pin_at_irq(0, apic1, pin1, apic2, pin2);
+		replace_pin_at_irq(0, boot_cpu_id, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
 		unmask_IO_APIC_irq(0);
 		enable_8259A_irq(0);
@@ -2902,21 +2967,25 @@ unsigned int create_irq_nr(unsigned int irq_want)
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
@@ -2925,6 +2994,9 @@ unsigned int create_irq_nr(unsigned int irq_want)
 
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
@@ -3195,26 +3275,13 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc, int irq)
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
@@ -3228,7 +3295,7 @@ int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 		goto error;
 no_ir:
 #endif
-	ret = setup_msi_irq(dev, desc, irq);
+	ret = setup_msi_irq(dev, msidesc, irq);
 	if (ret < 0) {
 		destroy_irq(irq);
 		return ret;
@@ -3246,7 +3313,7 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	unsigned int irq;
 	int ret, sub_handle;
-	struct msi_desc *desc;
+	struct msi_desc *msidesc;
 	unsigned int irq_want;
 
 #ifdef CONFIG_INTR_REMAP
@@ -3254,10 +3321,11 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
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
@@ -3289,7 +3357,7 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		}
 no_ir:
 #endif
-		ret = setup_msi_irq(dev, desc, irq);
+		ret = setup_msi_irq(dev, msidesc, irq);
 		if (ret < 0)
 			goto error;
 		sub_handle++;
@@ -3707,17 +3775,29 @@ int __init io_apic_get_version(int ioapic)
 
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
index 845aa98..5a5651b 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -69,7 +69,6 @@ void __init init_ISA_irqs (void)
 	 * 16 old-style INTA-cycle interrupts:
 	 */
 	for (i = 0; i < 16; i++) {
-		/* first time call this irq_desc */
 		struct irq_desc *desc = irq_to_desc(i);
 
 		desc->status = IRQ_DISABLED;
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index ff02353..cd9f42d 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -143,7 +143,6 @@ void __init init_ISA_irqs(void)
 	init_8259A(0);
 
 	for (i = 0; i < 16; i++) {
-		/* first time call this irq_desc */
 		struct irq_desc *desc = irq_to_desc(i);
 
 		desc->status = IRQ_DISABLED;
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
index 2de5a32..c9958ec 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
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
 
@@ -86,9 +144,11 @@ int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 	if (!count)
 		return -1;
 
+#ifndef CONFIG_SPARSE_IRQ
 	/* protect irq_2_iommu_alloc later */
 	if (irq >= nr_irqs)
 		return -1;
+#endif
 
 	/*
 	 * start the IRTE search from index 0.
@@ -130,6 +190,12 @@ int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
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
@@ -177,6 +243,12 @@ int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 
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
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 1e3b934..2924faa 100644
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
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 81904f0..a13431a 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -27,6 +27,7 @@ static int show_stat(struct seq_file *p, void *v)
 	u64 sum = 0;
 	struct timespec boottime;
 	unsigned int per_irq_sum;
+	struct irq_desc *desc;
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
@@ -44,10 +45,11 @@ static int show_stat(struct seq_file *p, void *v)
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
@@ -90,11 +92,14 @@ static int show_stat(struct seq_file *p, void *v)
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
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index f58a0cf..79e915e 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -18,6 +18,8 @@
 #include <asm/ptrace.h>
 #include <asm/system.h>
 
+extern int nr_irqs;
+
 /*
  * These correspond to the IORESOURCE_IRQ_* defines in
  * linux/ioport.h to select the interrupt line behaviour.  When
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 3dddfa7..63b0043 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
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
@@ -380,6 +427,11 @@ extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
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
index 452c280..7a299e9 100644
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
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
diff --git a/include/linux/random.h b/include/linux/random.h
index 36f125c..ad9daa2 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
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
index 10b5092..8e4fce4 100644
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
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index c815b42..96ca203 100644
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
+static struct lock_class_key irq_desc_lock_class;
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
@@ -62,6 +218,8 @@ struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
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
+}
+#endif
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
 

commit 99d093d12897562a253540a902bbf65ec16042ac
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Fri Dec 5 18:58:32 2008 -0800

    x86: use NR_IRQS_LEGACY
    
    Impact: cleanup
    
    Introduce NR_IRQS_LEGACY instead of hard coded number.
    
    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index bb6b69a..f7ff650 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -101,6 +101,8 @@
 #define LAST_VM86_IRQ		15
 #define invalid_vm86_irq(irq)	((irq) < 3 || (irq) > 15)
 
+#define NR_IRQS_LEGACY		16
+
 #if defined(CONFIG_X86_IO_APIC) && !defined(CONFIG_X86_VOYAGER)
 
 #ifndef CONFIG_SPARSE_IRQ
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 9de17f5..9870461 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -847,7 +847,7 @@ EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
  */
 static int EISA_ELCR(unsigned int irq)
 {
-	if (irq < 16) {
+	if (irq < NR_IRQS_LEGACY) {
 		unsigned int port = 0x4d0 + (irq >> 3);
 		return (inb(port) >> (irq & 7)) & 1;
 	}
@@ -1388,7 +1388,7 @@ static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
 	}
 
 	ioapic_register_intr(irq, trigger);
-	if (irq < 16)
+	if (irq < NR_IRQS_LEGACY)
 		disable_8259A_irq(irq);
 
 	ioapic_write_entry(apic, pin, entry);
@@ -2080,7 +2080,7 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 	struct irq_cfg *cfg;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	if (irq < 16) {
+	if (irq < NR_IRQS_LEGACY) {
 		disable_8259A_irq(irq);
 		if (i8259A_irq_pending(irq))
 			was_pending = 1;
@@ -2504,7 +2504,7 @@ static inline void init_IO_APIC_traps(void)
 			 * so default to an old-fashioned 8259
 			 * interrupt if we can..
 			 */
-			if (irq < 16)
+			if (irq < NR_IRQS_LEGACY)
 				make_8259A_irq(irq);
 			else
 				/* Strange. Oh, well.. */
@@ -3794,7 +3794,7 @@ int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int p
 	/*
 	 * IRQs < 16 are already in the irq_2_pin[] map
 	 */
-	if (irq >= 16) {
+	if (irq >= NR_IRQS_LEGACY) {
 		cfg = desc->chip_data;
 		add_pin_to_irq_cpu(irq, cpu, ioapic, pin);
 	}
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 5a5651b..6a92f47 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -68,7 +68,7 @@ void __init init_ISA_irqs (void)
 	/*
 	 * 16 old-style INTA-cycle interrupts:
 	 */
-	for (i = 0; i < 16; i++) {
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
 		struct irq_desc *desc = irq_to_desc(i);
 
 		desc->status = IRQ_DISABLED;
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index cd9f42d..40c1e62 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -142,7 +142,7 @@ void __init init_ISA_irqs(void)
 	init_bsp_APIC();
 	init_8259A(0);
 
-	for (i = 0; i < 16; i++) {
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
 		struct irq_desc *desc = irq_to_desc(i);
 
 		desc->status = IRQ_DISABLED;
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 96ca203..8aa0954 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -117,8 +117,8 @@ static DEFINE_SPINLOCK(sparse_irq_lock);
 
 struct irq_desc *irq_desc_ptrs[NR_IRQS] __read_mostly;
 
-static struct irq_desc irq_desc_legacy[16] __cacheline_aligned_in_smp = {
-	[0 ... 15] = {
+static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
+	[0 ... NR_IRQS_LEGACY-1] = {
 		.irq	    = -1,
 		.status	    = IRQ_DISABLED,
 		.chip	    = &no_irq_chip,
@@ -132,7 +132,7 @@ static struct irq_desc irq_desc_legacy[16] __cacheline_aligned_in_smp = {
 };
 
 /* FIXME: use bootmem alloc ...*/
-static unsigned int kstat_irqs_legacy[16][NR_CPUS];
+static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
 
 void __init early_irq_init(void)
 {

commit be5d5350a937cd8513b258739f1099420129e96f
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Fri Dec 5 18:58:33 2008 -0800

    x86: MSI start irq numbering from nr_irqs_gsi
    
    Impact: sanitize MSI irq number ordering from top-down to bottom-up
    
    Increase new MSI IRQs starting from nr_irqs_gsi (which is somewhere below
    256), instead of decreasing from NR_IRQS. (The latter method can result
    in confusingly high IRQ numbers - if NR_CPUS is set to a high value and
    NR_IRQS scales up to a high value.)
    
    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 6afd993..b35e94c 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -188,7 +188,7 @@ extern void restore_IO_APIC_setup(void);
 extern void reinit_intr_remapped_IO_APIC(int);
 #endif
 
-extern int probe_nr_irqs(void);
+extern void probe_nr_irqs_gsi(void);
 
 #else  /* !CONFIG_X86_IO_APIC */
 #define io_apic_assign_pci_irqs 0
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 9870461..0dcde74 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -2973,7 +2973,7 @@ unsigned int create_irq_nr(unsigned int irq_want)
 
 	irq = 0;
 	spin_lock_irqsave(&vector_lock, flags);
-	for (new = irq_want; new > 0; new--) {
+	for (new = irq_want; new < NR_IRQS; new++) {
 		if (platform_legacy_irq(new))
 			continue;
 
@@ -3001,11 +3001,14 @@ unsigned int create_irq_nr(unsigned int irq_want)
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
@@ -3281,7 +3284,7 @@ int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc)
 	int ret;
 	unsigned int irq_want;
 
-	irq_want = nr_irqs - 1;
+	irq_want = nr_irqs_gsi;
 	irq = create_irq_nr(irq_want);
 	if (irq == 0)
 		return -1;
@@ -3321,11 +3324,11 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	int index = 0;
 #endif
 
-	irq_want = nr_irqs - 1;
+	irq_want = nr_irqs_gsi;
 	sub_handle = 0;
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 		irq = create_irq_nr(irq_want);
-		irq_want--;
+		irq_want++;
 		if (irq == 0)
 			return -1;
 #ifdef CONFIG_INTR_REMAP
@@ -3674,9 +3677,16 @@ int __init io_apic_get_redir_entries (int ioapic)
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
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9d5674f..a3834f1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1082,7 +1082,7 @@ void __init setup_arch(char **cmdline_p)
 	ioapic_init_mappings();
 
 	/* need to wait for io_apic is mapped */
-	nr_irqs = probe_nr_irqs();
+	probe_nr_irqs_gsi();
 
 	kvm_guest_init();
 

commit 3145e941fcfe2548fa2270afb1a05bab3a6bc418
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Fri Dec 5 18:58:34 2008 -0800

    x86, MSI: pass irq_cfg and irq_desc
    
    Impact: simplify code
    
    Pass irq_desc and cfg around, instead of raw IRQ numbers - this way
    we dont have to look it up again and again.
    
    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 0dcde74..a1a2e07 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -231,6 +231,10 @@ static struct irq_cfg *irq_cfg(unsigned int irq)
 
 #endif
 
+static inline void set_extra_move_desc(struct irq_desc *desc, cpumask_t mask)
+{
+}
+
 struct io_apic {
 	unsigned int index;
 	unsigned int unused[3];
@@ -272,11 +276,10 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
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
@@ -358,13 +361,12 @@ static void ioapic_mask_entry(int apic, int pin)
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
@@ -394,24 +396,27 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, u8 vector)
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
@@ -419,12 +424,20 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
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
@@ -432,10 +445,9 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
-static void add_pin_to_irq_cpu(unsigned int irq, int cpu, int apic, int pin)
+static void add_pin_to_irq_cpu(struct irq_cfg *cfg, int cpu, int apic, int pin)
 {
 	struct irq_pin_list *entry;
-	struct irq_cfg *cfg = irq_cfg(irq);
 
 	entry = cfg->irq_2_pin;
 	if (!entry) {
@@ -468,11 +480,10 @@ static void add_pin_to_irq_cpu(unsigned int irq, int cpu, int apic, int pin)
 /*
  * Reroute an IRQ to a different pin.
  */
-static void __init replace_pin_at_irq(unsigned int irq, int cpu,
+static void __init replace_pin_at_irq_cpu(struct irq_cfg *cfg, int cpu,
 				      int oldapic, int oldpin,
 				      int newapic, int newpin)
 {
-	struct irq_cfg *cfg = irq_cfg(irq);
 	struct irq_pin_list *entry = cfg->irq_2_pin;
 	int replaced = 0;
 
@@ -489,18 +500,16 @@ static void __init replace_pin_at_irq(unsigned int irq, int cpu,
 
 	/* why? call replace before add? */
 	if (!replaced)
-		add_pin_to_irq_cpu(irq, cpu, newapic, newpin);
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
@@ -513,9 +522,9 @@ static inline void io_apic_modify_irq(unsigned int irq,
 	}
 }
 
-static void __unmask_IO_APIC_irq(unsigned int irq)
+static void __unmask_IO_APIC_irq(struct irq_cfg *cfg)
 {
-	io_apic_modify_irq(irq, ~IO_APIC_REDIR_MASKED, 0, NULL);
+	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED, 0, NULL);
 }
 
 #ifdef CONFIG_X86_64
@@ -530,47 +539,64 @@ void io_apic_sync(struct irq_pin_list *entry)
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
@@ -1072,7 +1098,7 @@ void unlock_vector_lock(void)
 	spin_unlock(&vector_lock);
 }
 
-static int __assign_irq_vector(int irq, cpumask_t mask)
+static int __assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1088,16 +1114,13 @@ static int __assign_irq_vector(int irq, cpumask_t mask)
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
@@ -1151,24 +1174,22 @@ next:
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
@@ -1257,11 +1278,8 @@ static inline int IO_APIC_irq_trigger(int irq)
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
@@ -1353,7 +1371,7 @@ static int setup_ioapic_entry(int apic, int irq,
 	return 0;
 }
 
-static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
+static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq, struct irq_desc *desc,
 			      int trigger, int polarity)
 {
 	struct irq_cfg *cfg;
@@ -1363,10 +1381,10 @@ static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
 	if (!IO_APIC_IRQ(irq))
 		return;
 
-	cfg = irq_cfg(irq);
+	cfg = desc->chip_data;
 
 	mask = TARGET_CPUS;
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
 	cpus_and(mask, cfg->domain, mask);
@@ -1383,11 +1401,11 @@ static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
 			       cfg->vector)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic].mp_apicid, pin);
-		__clear_irq_vector(irq);
+		__clear_irq_vector(irq, cfg);
 		return;
 	}
 
-	ioapic_register_intr(irq, trigger);
+	ioapic_register_intr(irq, desc, trigger);
 	if (irq < NR_IRQS_LEGACY)
 		disable_8259A_irq(irq);
 
@@ -1399,6 +1417,7 @@ static void __init setup_IO_APIC_irqs(void)
 	int apic, pin, idx, irq;
 	int notcon = 0;
 	struct irq_desc *desc;
+	struct irq_cfg *cfg;
 	int cpu = boot_cpu_id;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
@@ -1436,9 +1455,10 @@ static void __init setup_IO_APIC_irqs(void)
 				printk(KERN_INFO "can not get irq_desc for %d\n", irq);
 				continue;
 			}
-			add_pin_to_irq_cpu(irq, cpu, apic, pin);
+			cfg = desc->chip_data;
+			add_pin_to_irq_cpu(cfg, cpu, apic, pin);
 
-			setup_IO_APIC_irq(apic, pin, irq,
+			setup_IO_APIC_irq(apic, pin, irq, desc,
 					irq_trigger(idx), irq_polarity(idx));
 		}
 	}
@@ -2086,7 +2106,7 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 			was_pending = 1;
 	}
 	cfg = irq_cfg(irq);
-	__unmask_IO_APIC_irq(irq);
+	__unmask_IO_APIC_irq(cfg);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return was_pending;
@@ -2149,35 +2169,37 @@ static DECLARE_DELAYED_WORK(ir_migration_work, ir_irq_migration);
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
 
@@ -2199,14 +2221,14 @@ static void migrate_ioapic_irq(int irq, cpumask_t mask)
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
@@ -2218,14 +2240,15 @@ static int migrate_irq_remapped_level(int irq)
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
 
@@ -2258,18 +2281,22 @@ static void ir_irq_migration(struct work_struct *work)
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
 
@@ -2313,9 +2340,10 @@ unlock:
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
@@ -2333,8 +2361,9 @@ static void irq_complete_move(unsigned int irq)
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
@@ -2345,11 +2374,14 @@ static void ack_x2apic_edge(unsigned int irq)
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
@@ -2358,18 +2390,21 @@ atomic_t irq_mis_count;
 
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
 
@@ -2393,7 +2428,8 @@ static void ack_apic_level(unsigned int irq)
 	* operation to prevent an edge-triggered interrupt escaping meanwhile.
 	* The idea is from Manfred Spraul.  --macro
 	*/
-	i = irq_cfg(irq)->vector;
+	cfg = desc->chip_data;
+	i = cfg->vector;
 
 	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
 #endif
@@ -2432,17 +2468,18 @@ static void ack_apic_level(unsigned int irq)
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
@@ -2533,7 +2570,7 @@ static void unmask_lapic_irq(unsigned int irq)
 	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
 }
 
-static void ack_lapic_irq (unsigned int irq)
+static void ack_lapic_irq(unsigned int irq)
 {
 	ack_APIC_irq();
 }
@@ -2545,11 +2582,8 @@ static struct irq_chip lapic_chip __read_mostly = {
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
@@ -2653,7 +2687,9 @@ int timer_through_8259 __initdata;
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
@@ -2668,7 +2704,7 @@ static inline void __init check_timer(void)
 	 * get/set the timer IRQ vector:
 	 */
 	disable_8259A_irq(0);
-	assign_irq_vector(0, TARGET_CPUS);
+	assign_irq_vector(0, cfg, TARGET_CPUS);
 
 	/*
 	 * As IRQ0 is to be enabled in the 8259A, the virtual
@@ -2719,10 +2755,10 @@ static inline void __init check_timer(void)
 		 * Ok, does IRQ0 through the IOAPIC work?
 		 */
 		if (no_pin1) {
-			add_pin_to_irq_cpu(0, boot_cpu_id, apic1, pin1);
+			add_pin_to_irq_cpu(cfg, cpu, apic1, pin1);
 			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
 		}
-		unmask_IO_APIC_irq(0);
+		unmask_IO_APIC_irq_desc(desc);
 		if (timer_irq_works()) {
 			if (nmi_watchdog == NMI_IO_APIC) {
 				setup_nmi();
@@ -2748,9 +2784,9 @@ static inline void __init check_timer(void)
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
-		replace_pin_at_irq(0, boot_cpu_id, apic1, pin1, apic2, pin2);
+		replace_pin_at_irq_cpu(cfg, cpu, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
-		unmask_IO_APIC_irq(0);
+		unmask_IO_APIC_irq_desc(desc);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
@@ -2782,7 +2818,7 @@ static inline void __init check_timer(void)
 	apic_printk(APIC_QUIET, KERN_INFO
 		    "...trying to set up timer as Virtual Wire IRQ...\n");
 
-	lapic_register_intr(0);
+	lapic_register_intr(0, desc);
 	apic_write(APIC_LVT0, APIC_DM_FIXED | cfg->vector);	/* Fixed mode */
 	enable_8259A_irq(0);
 
@@ -2986,7 +3022,7 @@ unsigned int create_irq_nr(unsigned int irq_want)
 
 		if (cfg_new->vector != 0)
 			continue;
-		if (__assign_irq_vector(new, TARGET_CPUS) == 0)
+		if (__assign_irq_vector(new, cfg_new, TARGET_CPUS) == 0)
 			irq = new;
 		break;
 	}
@@ -3034,7 +3070,7 @@ void destroy_irq(unsigned int irq)
 	free_irte(irq);
 #endif
 	spin_lock_irqsave(&vector_lock, flags);
-	__clear_irq_vector(irq);
+	__clear_irq_vector(irq, cfg);
 	spin_unlock_irqrestore(&vector_lock, flags);
 }
 
@@ -3049,12 +3085,12 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
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
 
@@ -3112,35 +3148,35 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
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
@@ -3148,11 +3184,11 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
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
@@ -3161,10 +3197,12 @@ static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
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
 
@@ -3188,9 +3226,9 @@ static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 		cfg->move_in_progress = 0;
 	}
 
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
+
 #endif
 #endif /* CONFIG_SMP */
 
@@ -3249,7 +3287,7 @@ static int msi_alloc_irte(struct pci_dev *dev, int irq, int nvec)
 }
 #endif
 
-static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc, int irq)
+static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 {
 	int ret;
 	struct msi_msg msg;
@@ -3258,7 +3296,7 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc, int irq)
 	if (ret < 0)
 		return ret;
 
-	set_irq_msi(irq, desc);
+	set_irq_msi(irq, msidesc);
 	write_msi_msg(irq, &msg);
 
 #ifdef CONFIG_INTR_REMAP
@@ -3381,20 +3419,22 @@ void arch_teardown_msi_irq(unsigned int irq)
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
 
@@ -3406,9 +3446,9 @@ static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
+
 #endif /* CONFIG_SMP */
 
 struct irq_chip dmar_msi_type = {
@@ -3442,8 +3482,8 @@ int arch_setup_dmar_msi(unsigned int irq)
 #ifdef CONFIG_SMP
 static void hpet_msi_set_affinity(unsigned int irq, cpumask_t mask)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
-	struct irq_desc *desc;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
@@ -3452,10 +3492,12 @@ static void hpet_msi_set_affinity(unsigned int irq, cpumask_t mask)
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
 
@@ -3467,9 +3509,9 @@ static void hpet_msi_set_affinity(unsigned int irq, cpumask_t mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	hpet_msi_write(irq, &msg);
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
+
 #endif /* CONFIG_SMP */
 
 struct irq_chip hpet_msi_type = {
@@ -3524,26 +3566,28 @@ static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
 
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
@@ -3563,13 +3607,13 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
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
 
@@ -3615,7 +3659,9 @@ int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	unsigned long flags;
 	int err;
 
-	err = assign_irq_vector(irq, *eligible_cpu);
+	cfg = irq_cfg(irq);
+
+	err = assign_irq_vector(irq, cfg, *eligible_cpu);
 	if (err != 0)
 		return err;
 
@@ -3624,8 +3670,6 @@ int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 				      irq_name);
 	spin_unlock_irqrestore(&vector_lock, flags);
 
-	cfg = irq_cfg(irq);
-
 	mmr_value = 0;
 	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
 	BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
@@ -3806,10 +3850,10 @@ int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int p
 	 */
 	if (irq >= NR_IRQS_LEGACY) {
 		cfg = desc->chip_data;
-		add_pin_to_irq_cpu(irq, cpu, ioapic, pin);
+		add_pin_to_irq_cpu(cfg, cpu, ioapic, pin);
 	}
 
-	setup_IO_APIC_irq(ioapic, pin, irq, triggering, polarity);
+	setup_IO_APIC_irq(ioapic, pin, irq, desc, triggering, polarity);
 
 	return 0;
 }
@@ -3866,7 +3910,7 @@ void __init setup_ioapic_dest(void)
 			desc = irq_to_desc(irq);
 			cfg = desc->chip_data;
 			if (!cfg->vector) {
-				setup_IO_APIC_irq(ioapic, pin, irq,
+				setup_IO_APIC_irq(ioapic, pin, irq, desc,
 						  irq_trigger(irq_entry),
 						  irq_polarity(irq_entry));
 				continue;
@@ -3884,10 +3928,10 @@ void __init setup_ioapic_dest(void)
 
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
 
