Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbZCVUxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbZCVUxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 16:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbZCVUxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 16:53:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:42995 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbZCVUxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 16:53:38 -0400
Subject: [git-pull -tip] x86: cleanup patches 20090322
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 02:22:56 +0530
Message-Id: <1237755176.5417.16.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7f00a2495bf5b98b097c47be5d6e2d4114ec39bf:
  Ingo Molnar (1):
        Merge branches 'x86/cleanups', 'x86/mm', 'x86/setup' and 'linus' into x86/core

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git x86/core

Jaswinder Singh Rajput (5):
      x86: cpu/cpu.h cleanup
      x86: irq.c use same path for show_interrupts
      x86: irq.c keep CONFIG_X86_LOCAL_APIC interrupts together
      x86: apic/io_apic.c define msi_ir_chip and ir_ioapic_chip all the time
      x86: e820.h fix various signedness issues in setup.c and e820.c

 arch/x86/include/asm/e820.h    |    2 +-
 arch/x86/kernel/apic/io_apic.c |    9 ++++-----
 arch/x86/kernel/cpu/cpu.h      |   20 ++++++++++----------
 arch/x86/kernel/irq.c          |   23 ++++++-----------------
 4 files changed, 21 insertions(+), 33 deletions(-)

Complete diff:
diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 00d41ce..991ac17 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -57,7 +57,7 @@ struct e820entry {
 } __attribute__((packed));
 
 struct e820map {
-	__u32 nr_map;
+	__s32 nr_map;
 	struct e820entry map[E820_X_MAX];
 };
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 42cdc78..d36e3d8 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1428,7 +1428,6 @@ void __setup_vector_irq(int cpu)
 
 static struct irq_chip ioapic_chip;
 static struct irq_chip ir_ioapic_chip;
-static struct irq_chip msi_ir_chip;
 
 #define IOAPIC_AUTO     -1
 #define IOAPIC_EDGE     0
@@ -2663,20 +2662,20 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.retrigger	= ioapic_retrigger_irq,
 };
 
-#ifdef CONFIG_INTR_REMAP
 static struct irq_chip ir_ioapic_chip __read_mostly = {
 	.name		= "IR-IO-APIC",
 	.startup	= startup_ioapic_irq,
 	.mask		= mask_IO_APIC_irq,
 	.unmask		= unmask_IO_APIC_irq,
+#ifdef CONFIG_INTR_REMAP
 	.ack		= ack_x2apic_edge,
 	.eoi		= ack_x2apic_level,
 #ifdef CONFIG_SMP
 	.set_affinity	= set_ir_ioapic_affinity_irq,
 #endif
+#endif
 	.retrigger	= ioapic_retrigger_irq,
 };
-#endif
 
 static inline void init_IO_APIC_traps(void)
 {
@@ -3391,18 +3390,18 @@ static struct irq_chip msi_chip = {
 	.retrigger	= ioapic_retrigger_irq,
 };
 
-#ifdef CONFIG_INTR_REMAP
 static struct irq_chip msi_ir_chip = {
 	.name		= "IR-PCI-MSI",
 	.unmask		= unmask_msi_irq,
 	.mask		= mask_msi_irq,
+#ifdef CONFIG_INTR_REMAP
 	.ack		= ack_x2apic_edge,
 #ifdef CONFIG_SMP
 	.set_affinity	= ir_set_msi_irq_affinity,
 #endif
+#endif
 	.retrigger	= ioapic_retrigger_irq,
 };
-#endif
 
 /*
  * Map the PCI dev to the corresponding remapping hardware unit
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 9469ecb..6de9a90 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -3,25 +3,25 @@
 #define ARCH_X86_CPU_H
 
 struct cpu_model_info {
-	int vendor;
-	int family;
-	const char *model_names[16];
+	int		vendor;
+	int		family;
+	const char	*model_names[16];
 };
 
 /* attempt to consolidate cpu attributes */
 struct cpu_dev {
-	const char	* c_vendor;
+	const char	*c_vendor;
 
 	/* some have two possibilities for cpuid string */
-	const char	* c_ident[2];
+	const char	*c_ident[2];
 
 	struct		cpu_model_info c_models[4];
 
-	void            (*c_early_init)(struct cpuinfo_x86 *c);
-	void		(*c_init)(struct cpuinfo_x86 * c);
-	void		(*c_identify)(struct cpuinfo_x86 * c);
-	unsigned int	(*c_size_cache)(struct cpuinfo_x86 * c, unsigned int size);
-	int	c_x86_vendor;
+	void            (*c_early_init)(struct cpuinfo_x86 *);
+	void		(*c_init)(struct cpuinfo_x86 *);
+	void		(*c_identify)(struct cpuinfo_x86 *);
+	unsigned int	(*c_size_cache)(struct cpuinfo_x86 *, unsigned int);
+	int		c_x86_vendor;
 };
 
 #define cpu_dev_register(cpu_devX) \
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index b8ac3b6..3aaf7b9 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -58,6 +58,11 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_timer_irqs);
 	seq_printf(p, "  Local timer interrupts\n");
+
+	seq_printf(p, "%*s: ", prec, "SPU");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", irq_stats(j)->irq_spurious_count);
+	seq_printf(p, "  Spurious interrupts\n");
 #endif
 	if (generic_interrupt_extension) {
 		seq_printf(p, "PLT: ");
@@ -91,12 +96,6 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	seq_printf(p, "  Threshold APIC interrupts\n");
 # endif
 #endif
-#ifdef CONFIG_X86_LOCAL_APIC
-	seq_printf(p, "%*s: ", prec, "SPU");
-	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->irq_spurious_count);
-	seq_printf(p, "  Spurious interrupts\n");
-#endif
 	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
 	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read(&irq_mis_count));
@@ -133,23 +132,15 @@ int show_interrupts(struct seq_file *p, void *v)
 		return 0;
 
 	spin_lock_irqsave(&desc->lock, flags);
-#ifndef CONFIG_SMP
-	any_count = kstat_irqs(i);
-#else
 	for_each_online_cpu(j)
 		any_count |= kstat_irqs_cpu(i, j);
-#endif
 	action = desc->action;
 	if (!action && !any_count)
 		goto out;
 
 	seq_printf(p, "%*d: ", prec, i);
-#ifndef CONFIG_SMP
-	seq_printf(p, "%10u ", kstat_irqs(i));
-#else
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
-#endif
 	seq_printf(p, " %8s", desc->chip->name);
 	seq_printf(p, "-%-8s", desc->name);
 
@@ -174,6 +165,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	sum += irq_stats(cpu)->apic_timer_irqs;
+	sum += irq_stats(cpu)->irq_spurious_count;
 #endif
 	if (generic_interrupt_extension)
 		sum += irq_stats(cpu)->generic_irqs;
@@ -188,9 +180,6 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 	sum += irq_stats(cpu)->irq_threshold_count;
 #endif
 #endif
-#ifdef CONFIG_X86_LOCAL_APIC
-	sum += irq_stats(cpu)->irq_spurious_count;
-#endif
 	return sum;
 }
 


