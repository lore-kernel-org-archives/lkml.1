Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbZCNFub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbZCNFub (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 01:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbZCNFuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 01:50:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:38120 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbZCNFuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 01:50:19 -0400
Subject: [git-pull -tip] x86: cpu/common.c cleanup patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 11:19:49 +0530
Message-Id: <1237009789.4387.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 82434c275bbc2f4ab22518004a897126c79f6bf4:
  Ingo Molnar (1):
        Merge branch 'irq/genirq'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git master

Jaswinder Singh Rajput (4):
      x86: cpu/common.c fix various style problems
      x86: cpu/common.c declare varibles before they get used
      x86: cpu/common.c introduced clear_all_debug_regs
      x86: cpu/common.c fix header files issues

 arch/x86/include/asm/processor.h |    3 +
 arch/x86/kernel/cpu/common.c     |  132 +++++++++++++++++++-------------------
 2 files changed, 70 insertions(+), 65 deletions(-)

Complete diff:
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index bd3406d..ae85a8d 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -391,6 +391,9 @@ DECLARE_PER_CPU(union irq_stack_union, irq_stack_union);
 DECLARE_INIT_PER_CPU(irq_stack_union);
 
 DECLARE_PER_CPU(char *, irq_stack_ptr);
+DECLARE_PER_CPU(unsigned int, irq_count);
+extern unsigned long kernel_eflags;
+extern asmlinkage void ignore_sysret(void);
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
 DECLARE_PER_CPU(unsigned long, stack_canary);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a110a55..a37dd5a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1,53 +1,54 @@
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/string.h>
+#include <linux/perf_counter.h>
+#include <linux/topology.h>
 #include <linux/bootmem.h>
+#include <linux/linkage.h>
 #include <linux/bitops.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/kgdb.h>
-#include <linux/topology.h>
+#include <linux/percpu.h>
+#include <linux/string.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/kgdb.h>
 #include <linux/smp.h>
-#include <linux/percpu.h>
-#include <asm/i387.h>
-#include <asm/msr.h>
-#include <asm/io.h>
-#include <asm/linkage.h>
+#include <linux/io.h>
+
+#include <asm/stackprotector.h>
+#include <asm/perf_counter.h>
 #include <asm/mmu_context.h>
+#include <asm/hypervisor.h>
+#include <asm/processor.h>
+#include <asm/sections.h>
+#include <asm/cpumask.h>
+#include <asm/pgtable.h>
+#include <asm/atomic.h>
+#include <asm/proto.h>
+#include <asm/setup.h>
+#include <asm/apic.h>
+#include <asm/desc.h>
+#include <asm/i387.h>
 #include <asm/mtrr.h>
+#include <asm/numa.h>
+#include <asm/asm.h>
+#include <asm/cpu.h>
 #include <asm/mce.h>
-#include <asm/perf_counter.h>
+#include <asm/msr.h>
 #include <asm/pat.h>
-#include <asm/asm.h>
-#include <asm/numa.h>
 #include <asm/smp.h>
-#include <asm/cpu.h>
-#include <asm/cpumask.h>
-#include <asm/apic.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/uv/uv.h>
 #endif
 
-#include <asm/pgtable.h>
-#include <asm/processor.h>
-#include <asm/desc.h>
-#include <asm/atomic.h>
-#include <asm/proto.h>
-#include <asm/sections.h>
-#include <asm/setup.h>
-#include <asm/hypervisor.h>
-#include <asm/stackprotector.h>
-
 #include "cpu.h"
 
 #ifdef CONFIG_X86_64
 
 /* all of these masks are initialized in setup_cpu_local_masks() */
-cpumask_var_t cpu_callin_mask;
-cpumask_var_t cpu_callout_mask;
 cpumask_var_t cpu_initialized_mask;
+cpumask_var_t cpu_callout_mask;
+cpumask_var_t cpu_callin_mask;
 
 /* representing cpus for which sibling maps can be computed */
 cpumask_var_t cpu_sibling_setup_mask;
@@ -63,10 +64,10 @@ void __init setup_cpu_local_masks(void)
 
 #else /* CONFIG_X86_32 */
 
-cpumask_t cpu_callin_map;
+cpumask_t cpu_sibling_setup_map;
 cpumask_t cpu_callout_map;
 cpumask_t cpu_initialized;
-cpumask_t cpu_sibling_setup_map;
+cpumask_t cpu_callin_map;
 
 #endif /* CONFIG_X86_32 */
 
@@ -80,7 +81,7 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	 * IRET will check the segment types  kkeil 2000/10/28
 	 * Also sysret mandates a special GDT layout
 	 *
-	 * The TLS descriptors are currently at a different place compared to i386.
+	 * TLS descriptors are currently at a different place compared to i386.
 	 * Hopefully nobody expects them at a fixed place (Wine?)
 	 */
 	[GDT_ENTRY_KERNEL32_CS] = { { { 0x0000ffff, 0x00cf9b00 } } },
@@ -244,6 +245,7 @@ cpuid_dependent_features[] = {
 static void __cpuinit filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
 {
 	const struct cpuid_dependent_feature *df;
+
 	for (df = cpuid_dependent_features; df->feature; df++) {
 		/*
 		 * Note: cpuid_level is set to -1 if unavailable, but
@@ -365,12 +367,12 @@ static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	   undo that brain damage */
 	p = q = &c->x86_model_id[0];
 	while (*p == ' ')
-	     p++;
+		p++;
 	if (p != q) {
-	     while (*p)
-		  *q++ = *p++;
-	     while (q <= &c->x86_model_id[48])
-		  *q++ = '\0';	/* Zero-pad the rest */
+		while (*p)
+			*q++ = *p++;
+		while (q <= &c->x86_model_id[48])
+			*q++ = '\0';	/* Zero-pad the rest */
 	}
 }
 
@@ -442,14 +444,15 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 	} else if (smp_num_siblings > 1) {
 
 		if (smp_num_siblings > nr_cpu_ids) {
-			printk(KERN_WARNING "CPU: Unsupported number of siblings %d",
-					smp_num_siblings);
+			pr_warning("CPU: Unsupported number of siblings %d",
+				   smp_num_siblings);
 			smp_num_siblings = 1;
 			return;
 		}
 
 		index_msb = get_count_order(smp_num_siblings);
-		c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid, index_msb);
+		c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid,
+						    index_msb);
 
 		smp_num_siblings = smp_num_siblings / c->x86_max_cores;
 
@@ -492,7 +495,8 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 
 	if (!printed) {
 		printed++;
-		printk(KERN_ERR "CPU: vendor_id '%s' unknown, using generic init.\n", v);
+		printk(KERN_ERR "CPU: vendor_id '%s'"
+			"unknown, using generic init.\n", v);
 		printk(KERN_ERR "CPU: Your system may be unstable.\n");
 	}
 
@@ -644,7 +648,7 @@ void __init early_cpu_init(void)
 	const struct cpu_dev *const *cdev;
 	int count = 0;
 
-	printk("KERNEL supported cpus:\n");
+	printk(KERN_INFO "KERNEL supported cpus:\n");
 	for (cdev = __x86_cpu_dev_start; cdev < __x86_cpu_dev_end; cdev++) {
 		const struct cpu_dev *cpudev = *cdev;
 		unsigned int j;
@@ -657,7 +661,7 @@ void __init early_cpu_init(void)
 		for (j = 0; j < 2; j++) {
 			if (!cpudev->c_ident[j])
 				continue;
-			printk("  %s %s\n", cpudev->c_vendor,
+			printk(KERN_INFO "  %s %s\n", cpudev->c_vendor,
 				cpudev->c_ident[j]);
 		}
 	}
@@ -964,8 +968,6 @@ static DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
 	[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ])
 	__aligned(PAGE_SIZE);
 
-extern asmlinkage void ignore_sysret(void);
-
 /* May not be marked __init: used by software suspend */
 void syscall_init(void)
 {
@@ -1012,6 +1014,22 @@ struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 #endif	/* x86_64 */
 
 /*
+ * Clear all 6 debug registers:
+ */
+static void clear_all_debug_regs(void)
+{
+	int i;
+
+	for (i = 0; i < 8; i++) {
+		/* Ignore db4, db5 */
+		if ((i == 4) || (i == 5))
+			continue;
+
+		set_debugreg(0, i);
+	}
+}
+
+/*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
  * and IDT. We reload them nevertheless, this function acts as a
@@ -1109,17 +1127,7 @@ void __cpuinit cpu_init(void)
 		arch_kgdb_ops.correct_hw_break();
 	else
 #endif
-	{
-		/*
-		 * Clear all 6 debug registers:
-		 */
-		set_debugreg(0UL, 0);
-		set_debugreg(0UL, 1);
-		set_debugreg(0UL, 2);
-		set_debugreg(0UL, 3);
-		set_debugreg(0UL, 6);
-		set_debugreg(0UL, 7);
-	}
+		clear_all_debug_regs();
 
 	fpu_init();
 
@@ -1140,7 +1148,8 @@ void __cpuinit cpu_init(void)
 
 	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask)) {
 		printk(KERN_WARNING "CPU#%d already initialized!\n", cpu);
-		for (;;) local_irq_enable();
+		for (;;)
+			local_irq_enable();
 	}
 
 	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
@@ -1169,13 +1178,7 @@ void __cpuinit cpu_init(void)
 	__set_tss_desc(cpu, GDT_ENTRY_DOUBLEFAULT_TSS, &doublefault_tss);
 #endif
 
-	/* Clear all 6 debug registers: */
-	set_debugreg(0, 0);
-	set_debugreg(0, 1);
-	set_debugreg(0, 2);
-	set_debugreg(0, 3);
-	set_debugreg(0, 6);
-	set_debugreg(0, 7);
+	clear_all_debug_regs();
 
 	/*
 	 * Force FPU initialization:
@@ -1196,5 +1199,4 @@ void __cpuinit cpu_init(void)
 	xsave_init();
 }
 
-
 #endif


