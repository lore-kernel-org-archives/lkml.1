Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbZCWKIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbZCWKIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZCWKIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:08:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:49621 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344AbZCWKII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:08:08 -0400
Subject: Re: [git-pull -tip] x86: cleanup patches 20090322
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200903231845.05394.rusty@rustcorp.com.au>
References: <1237755176.5417.16.camel@ht.satnam>
	 <200903231845.05394.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 15:37:00 +0530
Message-Id: <1237802820.2630.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-23 at 18:45 +1030, Rusty Russell wrote:
> On Monday 23 March 2009 07:22:56 Jaswinder Singh Rajput wrote:
> >       x86: e820.h fix various signedness issues in setup.c and e820.c
> 
> Wouldn't fixing the users be better than changing the header?  Esp. since
> it could well now cause similar warnings in userspace programs.
> 
> >  struct e820map {
> > -	__u32 nr_map;
> > +	__s32 nr_map;
> >  	struct e820entry map[E820_X_MAX];
> >  };
> 
> This number can't be negative!
> 

Here is new pull request:
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
      x86: e820 fix various signedness issues in setup.c and e820.c

 arch/x86/include/asm/e820.h    |    2 +-
 arch/x86/kernel/apic/io_apic.c |    9 ++++-----
 arch/x86/kernel/cpu/cpu.h      |   20 ++++++++++----------
 arch/x86/kernel/e820.c         |   10 +++++-----
 arch/x86/kernel/irq.c          |   23 ++++++-----------------
 5 files changed, 26 insertions(+), 38 deletions(-)

Complete diff:
diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 00d41ce..7ecba4d 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -72,7 +72,7 @@ extern int e820_all_mapped(u64 start, u64 end, unsigned type);
 extern void e820_add_region(u64 start, u64 size, int type);
 extern void e820_print_map(char *who);
 extern int
-sanitize_e820_map(struct e820entry *biosmap, int max_nr_map, int *pnr_map);
+sanitize_e820_map(struct e820entry *biosmap, int max_nr_map, u32 *pnr_map);
 extern u64 e820_update_range(u64 start, u64 size, unsigned old_type,
 			       unsigned new_type);
 extern u64 e820_remove_range(u64 start, u64 size, unsigned old_type,
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
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index fb638d9..ef2c356 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -233,7 +233,7 @@ void __init e820_print_map(char *who)
  */
 
 int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
-				int *pnr_map)
+			     u32 *pnr_map)
 {
 	struct change_member {
 		struct e820entry *pbios; /* pointer to original bios entry */
@@ -552,7 +552,7 @@ u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
 
 void __init update_e820(void)
 {
-	int nr_map;
+	u32 nr_map;
 
 	nr_map = e820.nr_map;
 	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
@@ -563,7 +563,7 @@ void __init update_e820(void)
 }
 static void __init update_e820_saved(void)
 {
-	int nr_map;
+	u32 nr_map;
 
 	nr_map = e820_saved.nr_map;
 	if (sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map), &nr_map))
@@ -1303,7 +1303,7 @@ early_param("memmap", parse_memmap_opt);
 void __init finish_e820_parsing(void)
 {
 	if (userdef) {
-		int nr = e820.nr_map;
+		u32 nr = e820.nr_map;
 
 		if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
 			early_panic("Invalid user supplied memory map");
@@ -1386,7 +1386,7 @@ void __init e820_reserve_resources_late(void)
 char *__init default_machine_specific_memory_setup(void)
 {
 	char *who = "BIOS-e820";
-	int new_nr;
+	u32 new_nr;
 	/*
 	 * Try to copy the BIOS-supplied E820-map.
 	 *
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
 


