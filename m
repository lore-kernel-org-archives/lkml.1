Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbYL1XKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbYL1XKy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 18:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYL1XKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 18:10:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56236 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbYL1XKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 18:10:44 -0500
Date: Mon, 29 Dec 2008 00:10:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [git pull] sparseirq / irq fixes
Message-ID: <20081228231025.GA31953@elte.hu>
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227133240.GA8716@elte.hu>
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


Linus,

Please pull the latest irq-fixes-for-linus-2 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus-2

these are the latest updates/fixes for the irq-core-for-linus tree.

 Thanks,

	Ingo

------------------>
Ingo Molnar (2):
      sparseirq: do not printk when migrating IRQ descriptors
      sparseirq: fix desc->lock init

KOSAKI Motohiro (4):
      hrtimer: remove #include <linux/irq.h>
      irq: for_each_irq_desc() move to irqnr.h
      proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
      irq: simplify for_each_irq_desc() usage

Yinghai Lu (4):
      sparseirq: remove duplicated arch_early_irq_init()
      sparseirq: work around compiler optimizing away __weak functions
      sparseirq: set lock_class for legacy irq when sparse_irq is selected
      sparseirq: fix hang with !SPARSE_IRQ


 arch/x86/kernel/io_apic.c |   18 +++++-----------
 drivers/xen/events.c      |    3 --
 fs/proc/stat.c            |   11 +---------
 include/linux/irq.h       |   30 ++++++----------------------
 include/linux/irqnr.h     |   23 ++++++++++++---------
 init/main.c               |    7 +++--
 kernel/hrtimer.c          |    1 -
 kernel/irq/autoprobe.c    |   15 --------------
 kernel/irq/handle.c       |   47 ++++++++++++++++++++++++++++++++------------
 kernel/irq/numa_migrate.c |    7 +----
 kernel/irq/spurious.c     |    5 ----
 11 files changed, 67 insertions(+), 100 deletions(-)

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index a74887b..9760393 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -170,7 +170,7 @@ static struct irq_cfg irq_cfgx[NR_IRQS] = {
 	[15] = { .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
 };
 
-void __init arch_early_irq_init(void)
+int __init arch_early_irq_init(void)
 {
 	struct irq_cfg *cfg;
 	struct irq_desc *desc;
@@ -184,6 +184,8 @@ void __init arch_early_irq_init(void)
 		desc = irq_to_desc(i);
 		desc->chip_data = &cfg[i];
 	}
+
+	return 0;
 }
 
 #ifdef CONFIG_SPARSE_IRQ
@@ -212,7 +214,7 @@ static struct irq_cfg *get_one_free_irq_cfg(int cpu)
 	return cfg;
 }
 
-void arch_init_chip_data(struct irq_desc *desc, int cpu)
+int arch_init_chip_data(struct irq_desc *desc, int cpu)
 {
 	struct irq_cfg *cfg;
 
@@ -224,6 +226,8 @@ void arch_init_chip_data(struct irq_desc *desc, int cpu)
 			BUG_ON(1);
 		}
 	}
+
+	return 0;
 }
 
 #ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
@@ -1345,8 +1349,6 @@ void __setup_vector_irq(int cpu)
 
 	/* Mark the inuse vectors */
 	for_each_irq_desc(irq, desc) {
-		if (!desc)
-			continue;
 		cfg = desc->chip_data;
 		if (!cpu_isset(cpu, cfg->domain))
 			continue;
@@ -1730,8 +1732,6 @@ __apicdebuginit(void) print_IO_APIC(void)
 	for_each_irq_desc(irq, desc) {
 		struct irq_pin_list *entry;
 
-		if (!desc)
-			continue;
 		cfg = desc->chip_data;
 		entry = cfg->irq_2_pin;
 		if (!entry)
@@ -2378,9 +2378,6 @@ static void ir_irq_migration(struct work_struct *work)
 	struct irq_desc *desc;
 
 	for_each_irq_desc(irq, desc) {
-		if (!desc)
-			continue;
-
 		if (desc->status & IRQ_MOVE_PENDING) {
 			unsigned long flags;
 
@@ -2671,9 +2668,6 @@ static inline void init_IO_APIC_traps(void)
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	for_each_irq_desc(irq, desc) {
-		if (!desc)
-			continue;
-
 		cfg = desc->chip_data;
 		if (IO_APIC_IRQ(irq) && cfg && !cfg->vector) {
 			/*
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 46625cd..e26733a 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -142,9 +142,6 @@ static void init_evtchn_cpu_bindings(void)
 
 	/* By default all event channels notify CPU#0. */
 	for_each_irq_desc(i, desc) {
-		if (!desc)
-			continue;
-
 		desc->affinity = cpumask_of_cpu(0);
 	}
 #endif
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 3bb1cf1..f75efa2 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -9,6 +9,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/time.h>
+#include <linux/irqnr.h>
 #include <asm/cputime.h>
 
 #ifndef arch_irq_stat_cpu
@@ -45,10 +46,6 @@ static int show_stat(struct seq_file *p, void *v)
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
 		for_each_irq_nr(j) {
-#ifdef CONFIG_SPARSE_IRQ
-			if (!irq_to_desc(j))
-				continue;
-#endif
 			sum += kstat_irqs_cpu(j, i);
 		}
 		sum += arch_irq_stat_cpu(i);
@@ -95,12 +92,6 @@ static int show_stat(struct seq_file *p, void *v)
 	/* sum again ? it could be updated? */
 	for_each_irq_nr(j) {
 		per_irq_sum = 0;
-#ifdef CONFIG_SPARSE_IRQ
-		if (!irq_to_desc(j)) {
-			seq_printf(p, " %u", per_irq_sum);
-			continue;
-		}
-#endif
 		for_each_possible_cpu(i)
 			per_irq_sum += kstat_irqs_cpu(j, i);
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 98564dc..0e40af4 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -193,42 +193,26 @@ struct irq_desc {
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
-extern void early_irq_init(void);
-extern void arch_early_irq_init(void);
-extern void arch_init_chip_data(struct irq_desc *desc, int cpu);
+extern int early_irq_init(void);
+extern int arch_early_irq_init(void);
+extern int arch_init_chip_data(struct irq_desc *desc, int cpu);
 extern void arch_init_copy_chip_data(struct irq_desc *old_desc,
 					struct irq_desc *desc, int cpu);
 extern void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc);
 
 #ifndef CONFIG_SPARSE_IRQ
 extern struct irq_desc irq_desc[NR_IRQS];
-
-static inline struct irq_desc *irq_to_desc(unsigned int irq)
-{
-	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
-}
-static inline struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
-{
-	return irq_to_desc(irq);
-}
-
-#else
-
-extern struct irq_desc *irq_to_desc(unsigned int irq);
-extern struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu);
+#else /* CONFIG_SPARSE_IRQ */
 extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int cpu);
 
-# define for_each_irq_desc(irq, desc)		\
-	for (irq = 0, desc = irq_to_desc(irq); irq < nr_irqs; irq++, desc = irq_to_desc(irq))
-# define for_each_irq_desc_reverse(irq, desc)                          \
-	for (irq = nr_irqs - 1, desc = irq_to_desc(irq); irq >= 0; irq--, desc = irq_to_desc(irq))
-
 #define kstat_irqs_this_cpu(DESC) \
 	((DESC)->kstat_irqs[smp_processor_id()])
 #define kstat_incr_irqs_this_cpu(irqno, DESC) \
 	((DESC)->kstat_irqs[smp_processor_id()]++)
 
-#endif
+#endif /* CONFIG_SPARSE_IRQ */
+
+extern struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu);
 
 static inline struct irq_desc *
 irq_remap_to_desc(unsigned int irq, struct irq_desc *desc)
diff --git a/include/linux/irqnr.h b/include/linux/irqnr.h
index 95d2b74..5504a5c 100644
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -15,20 +15,23 @@
 
 # define for_each_irq_desc_reverse(irq, desc)                          \
 	for (irq = nr_irqs - 1; irq >= 0; irq--)
-#else
+#else /* CONFIG_GENERIC_HARDIRQS */
 
 extern int nr_irqs;
+extern struct irq_desc *irq_to_desc(unsigned int irq);
 
-#ifndef CONFIG_SPARSE_IRQ
+# define for_each_irq_desc(irq, desc)					\
+	for (irq = 0, desc = irq_to_desc(irq); irq < nr_irqs;		\
+	     irq++, desc = irq_to_desc(irq))				\
+		if (desc)
 
-struct irq_desc;
-# define for_each_irq_desc(irq, desc)		\
-	for (irq = 0, desc = irq_desc; irq < nr_irqs; irq++, desc++)
-# define for_each_irq_desc_reverse(irq, desc)                          \
-	for (irq = nr_irqs - 1, desc = irq_desc + (nr_irqs - 1);        \
-	    irq >= 0; irq--, desc--)
-#endif
-#endif
+
+# define for_each_irq_desc_reverse(irq, desc)				\
+	for (irq = nr_irqs - 1, desc = irq_to_desc(irq); irq >= 0;	\
+	     irq--, desc = irq_to_desc(irq))				\
+		if (desc)
+
+#endif /* CONFIG_GENERIC_HARDIRQS */
 
 #define for_each_irq_nr(irq)                   \
        for (irq = 0; irq < nr_irqs; irq++)
diff --git a/init/main.c b/init/main.c
index c1f999a..c314aa1 100644
--- a/init/main.c
+++ b/init/main.c
@@ -539,13 +539,14 @@ void __init __weak thread_info_cache_init(void)
 {
 }
 
-void __init __weak arch_early_irq_init(void)
+int __init __weak arch_early_irq_init(void)
 {
+	return 0;
 }
 
-void __init __weak early_irq_init(void)
+int __init __weak early_irq_init(void)
 {
-	arch_early_irq_init();
+	return arch_early_irq_init();
 }
 
 asmlinkage void __init start_kernel(void)
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 47e6334..0ad3f3d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -32,7 +32,6 @@
  */
 
 #include <linux/cpu.h>
-#include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
 #include <linux/hrtimer.h>
diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index 650ce41..cc0f732 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -40,9 +40,6 @@ unsigned long probe_irq_on(void)
 	 * flush such a longstanding irq before considering it as spurious.
 	 */
 	for_each_irq_desc_reverse(i, desc) {
-		if (!desc)
-			continue;
-
 		spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			/*
@@ -71,9 +68,6 @@ unsigned long probe_irq_on(void)
 	 * happened in the previous stage, it may have masked itself)
 	 */
 	for_each_irq_desc_reverse(i, desc) {
-		if (!desc)
-			continue;
-
 		spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			desc->status |= IRQ_AUTODETECT | IRQ_WAITING;
@@ -92,9 +86,6 @@ unsigned long probe_irq_on(void)
 	 * Now filter out any obviously spurious interrupts
 	 */
 	for_each_irq_desc(i, desc) {
-		if (!desc)
-			continue;
-
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
@@ -133,9 +124,6 @@ unsigned int probe_irq_mask(unsigned long val)
 	int i;
 
 	for_each_irq_desc(i, desc) {
-		if (!desc)
-			continue;
-
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
@@ -178,9 +166,6 @@ int probe_irq_off(unsigned long val)
 	unsigned int status;
 
 	for_each_irq_desc(i, desc) {
-		if (!desc)
-			continue;
-
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 6492400..157c04c 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -56,10 +56,6 @@ void handle_bad_irq(unsigned int irq, struct irq_desc *desc)
 int nr_irqs = NR_IRQS;
 EXPORT_SYMBOL_GPL(nr_irqs);
 
-void __init __attribute__((weak)) arch_early_irq_init(void)
-{
-}
-
 #ifdef CONFIG_SPARSE_IRQ
 static struct irq_desc irq_desc_init = {
 	.irq	    = -1,
@@ -90,13 +86,16 @@ void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
 		desc->kstat_irqs = (unsigned int *)ptr;
 }
 
-void __attribute__((weak)) arch_init_chip_data(struct irq_desc *desc, int cpu)
+int __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
 {
+	return 0;
 }
 
 static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
 {
 	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
+
+	spin_lock_init(&desc->lock);
 	desc->irq = irq;
 #ifdef CONFIG_SMP
 	desc->cpu = cpu;
@@ -134,7 +133,7 @@ static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_sm
 /* FIXME: use bootmem alloc ...*/
 static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
 
-void __init early_irq_init(void)
+int __init early_irq_init(void)
 {
 	struct irq_desc *desc;
 	int legacy_count;
@@ -146,6 +145,7 @@ void __init early_irq_init(void)
 	for (i = 0; i < legacy_count; i++) {
 		desc[i].irq = i;
 		desc[i].kstat_irqs = kstat_irqs_legacy[i];
+		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 
 		irq_desc_ptrs[i] = desc + i;
 	}
@@ -153,7 +153,7 @@ void __init early_irq_init(void)
 	for (i = legacy_count; i < NR_IRQS; i++)
 		irq_desc_ptrs[i] = NULL;
 
-	arch_early_irq_init();
+	return arch_early_irq_init();
 }
 
 struct irq_desc *irq_to_desc(unsigned int irq)
@@ -203,7 +203,7 @@ out_unlock:
 	return desc;
 }
 
-#else
+#else /* !CONFIG_SPARSE_IRQ */
 
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
@@ -218,7 +218,31 @@ struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	}
 };
 
-#endif
+int __init early_irq_init(void)
+{
+	struct irq_desc *desc;
+	int count;
+	int i;
+
+	desc = irq_desc;
+	count = ARRAY_SIZE(irq_desc);
+
+	for (i = 0; i < count; i++)
+		desc[i].irq = i;
+
+	return arch_early_irq_init();
+}
+
+struct irq_desc *irq_to_desc(unsigned int irq)
+{
+	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
+}
+
+struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
+{
+	return irq_to_desc(irq);
+}
+#endif /* !CONFIG_SPARSE_IRQ */
 
 /*
  * What should we do if we get a hw irq event on an illegal vector?
@@ -428,9 +452,6 @@ void early_init_irq_lock_class(void)
 	int i;
 
 	for_each_irq_desc(i, desc) {
-		if (!desc)
-			continue;
-
 		lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 	}
 }
@@ -439,7 +460,7 @@ void early_init_irq_lock_class(void)
 unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	return desc->kstat_irqs[cpu];
+	return desc ? desc->kstat_irqs[cpu] : 0;
 }
 #endif
 EXPORT_SYMBOL(kstat_irqs_cpu);
diff --git a/kernel/irq/numa_migrate.c b/kernel/irq/numa_migrate.c
index 089c374..ecf765c 100644
--- a/kernel/irq/numa_migrate.c
+++ b/kernel/irq/numa_migrate.c
@@ -42,6 +42,7 @@ static void init_copy_one_irq_desc(int irq, struct irq_desc *old_desc,
 		 struct irq_desc *desc, int cpu)
 {
 	memcpy(desc, old_desc, sizeof(struct irq_desc));
+	spin_lock_init(&desc->lock);
 	desc->cpu = cpu;
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 	init_copy_kstat_irqs(old_desc, desc, cpu, nr_cpu_ids);
@@ -74,10 +75,8 @@ static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
 
 	node = cpu_to_node(cpu);
 	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
-	printk(KERN_DEBUG "  move irq_desc for %d to cpu %d node %d\n",
-		 irq, cpu, node);
 	if (!desc) {
-		printk(KERN_ERR "can not get new irq_desc for moving\n");
+		printk(KERN_ERR "irq %d: can not get new irq_desc for migration.\n", irq);
 		/* still use old one */
 		desc = old_desc;
 		goto out_unlock;
@@ -106,8 +105,6 @@ struct irq_desc *move_irq_desc(struct irq_desc *desc, int cpu)
 		return desc;
 
 	old_cpu = desc->cpu;
-	printk(KERN_DEBUG
-		 "try to move irq_desc from cpu %d to %d\n", old_cpu, cpu);
 	if (old_cpu != cpu) {
 		node = cpu_to_node(cpu);
 		old_node = cpu_to_node(old_cpu);
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 3738107..dd364c1 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -91,9 +91,6 @@ static int misrouted_irq(int irq)
 	int i, ok = 0;
 
 	for_each_irq_desc(i, desc) {
-		if (!desc)
-			continue;
-
 		if (!i)
 			 continue;
 
@@ -115,8 +112,6 @@ static void poll_spurious_irqs(unsigned long dummy)
 	for_each_irq_desc(i, desc) {
 		unsigned int status;
 
-		if (!desc)
-			continue;
 		if (!i)
 			 continue;
 
