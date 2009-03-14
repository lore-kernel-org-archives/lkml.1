Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbZCNIz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbZCNIz2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 04:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZCNIzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 04:55:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:50471 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbZCNIzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 04:55:09 -0400
Date: Sat, 14 Mar 2009 08:54:26 GMT
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jaswinder@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237009789.4387.2.camel@localhost.localdomain>
References: <1237009789.4387.2.camel@localhost.localdomain>
Subject: [tip:x86/cleanups] x86: cpu/common.c cleanups
Message-ID: <tip-9766cdbcb260389669e9679b2aa87c11832f479f@git.kernel.org>
Git-Commit-ID: 9766cdbcb260389669e9679b2aa87c11832f479f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 14 Mar 2009 08:54:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9766cdbcb260389669e9679b2aa87c11832f479f
Gitweb:     http://git.kernel.org/tip/9766cdbcb260389669e9679b2aa87c11832f479f
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sat, 14 Mar 2009 11:19:49 +0530
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 14 Mar 2009 08:59:50 +0100

x86: cpu/common.c cleanups

- fix various style problems
 - declare varibles before they get used
 - introduced clear_all_debug_regs
 - fix header files issues

LKML-Reference: <1237009789.4387.2.camel@localhost.localdomain>
Signed-off-by: Jaswinder Singh Rajput <jaswinder@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/processor.h |    3 +
 arch/x86/kernel/cpu/common.c     |  129 +++++++++++++++++++-------------------
 2 files changed, 68 insertions(+), 64 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7613950..dccef5b 100644
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
index 826d5c8..cad6878 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1,52 +1,52 @@
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/string.h>
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
@@ -62,10 +62,10 @@ void __init setup_cpu_local_masks(void)
 
 #else /* CONFIG_X86_32 */
 
-cpumask_t cpu_callin_map;
+cpumask_t cpu_sibling_setup_map;
 cpumask_t cpu_callout_map;
 cpumask_t cpu_initialized;
-cpumask_t cpu_sibling_setup_map;
+cpumask_t cpu_callin_map;
 
 #endif /* CONFIG_X86_32 */
 
@@ -79,7 +79,7 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	 * IRET will check the segment types  kkeil 2000/10/28
 	 * Also sysret mandates a special GDT layout
 	 *
-	 * The TLS descriptors are currently at a different place compared to i386.
+	 * TLS descriptors are currently at a different place compared to i386.
 	 * Hopefully nobody expects them at a fixed place (Wine?)
 	 */
 	[GDT_ENTRY_KERNEL32_CS] = { { { 0x0000ffff, 0x00cf9b00 } } },
@@ -243,6 +243,7 @@ cpuid_dependent_features[] = {
 static void __cpuinit filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
 {
 	const struct cpuid_dependent_feature *df;
+
 	for (df = cpuid_dependent_features; df->feature; df++) {
 		/*
 		 * Note: cpuid_level is set to -1 if unavailable, but
@@ -364,12 +365,12 @@ static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
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
 
@@ -441,14 +442,15 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
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
 
@@ -491,7 +493,8 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 
 	if (!printed) {
 		printed++;
-		printk(KERN_ERR "CPU: vendor_id '%s' unknown, using generic init.\n", v);
+		printk(KERN_ERR "CPU: vendor_id '%s'"
+			"unknown, using generic init.\n", v);
 		printk(KERN_ERR "CPU: Your system may be unstable.\n");
 	}
 
@@ -637,7 +640,7 @@ void __init early_cpu_init(void)
 	struct cpu_dev **cdev;
 	int count = 0;
 
-	printk("KERNEL supported cpus:\n");
+	printk(KERN_INFO "KERNEL supported cpus:\n");
 	for (cdev = __x86_cpu_dev_start; cdev < __x86_cpu_dev_end; cdev++) {
 		struct cpu_dev *cpudev = *cdev;
 		unsigned int j;
@@ -650,7 +653,7 @@ void __init early_cpu_init(void)
 		for (j = 0; j < 2; j++) {
 			if (!cpudev->c_ident[j])
 				continue;
-			printk("  %s %s\n", cpudev->c_vendor,
+			printk(KERN_INFO "  %s %s\n", cpudev->c_vendor,
 				cpudev->c_ident[j]);
 		}
 	}
@@ -952,8 +955,6 @@ static DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
 	[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ])
 	__aligned(PAGE_SIZE);
 
-extern asmlinkage void ignore_sysret(void);
-
 /* May not be marked __init: used by software suspend */
 void syscall_init(void)
 {
@@ -1000,6 +1001,22 @@ struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
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
@@ -1098,17 +1115,7 @@ void __cpuinit cpu_init(void)
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
 
@@ -1129,7 +1136,8 @@ void __cpuinit cpu_init(void)
 
 	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask)) {
 		printk(KERN_WARNING "CPU#%d already initialized!\n", cpu);
-		for (;;) local_irq_enable();
+		for (;;)
+			local_irq_enable();
 	}
 
 	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
@@ -1159,13 +1167,7 @@ void __cpuinit cpu_init(void)
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
@@ -1186,5 +1188,4 @@ void __cpuinit cpu_init(void)
 	xsave_init();
 }
 
-
 #endif
