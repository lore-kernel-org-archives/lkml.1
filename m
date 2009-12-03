Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbZLCUqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbZLCUqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 15:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbZLCUqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 15:46:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36482 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814AbZLCUqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 15:46:49 -0500
Date: Thu, 3 Dec 2009 21:46:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86/debug for v2.6.33
Message-ID: <20091203204646.GA26878@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-debug-for-linus

 Thanks,

	Ingo

------------------>
Arjan van de Ven (1):
      x86: Make sure we also print a Code: line for show_regs()

Borislav Petkov (1):
      x86, cpu: mv display_cacheinfo -> cpu_detect_cache_sizes

Dave Jones (2):
      x86: Remove the CPU cache size printk's
      x86: Minimise printk spew from per-vendor init code

Ingo Molnar (3):
      x86: Fix cpu_devs[] initialization in early_cpu_init()
      x86: dumpstack: Clean up the x86_stack_ids[][] initalization and other details
      x86: dumpstack, 64-bit: Disable preemption when walking the IRQ/exception stacks

Jan Beulich (1):
      x86: Suppress stack overrun message for init_task

Mike Travis (1):
      x86: Limit number of per cpu TSC sync messages

Roland Dreier (1):
      x86: Remove CPU cache size output for non-Intel too

Rusty Russell (1):
      cpumask: Avoid cpumask_t in arch/x86/kernel/apic/nmi.c


 arch/x86/kernel/apic/nmi.c            |   11 ++++---
 arch/x86/kernel/cpu/amd.c             |    2 +-
 arch/x86/kernel/cpu/centaur.c         |    2 +-
 arch/x86/kernel/cpu/common.c          |   30 +++++++++++----------
 arch/x86/kernel/cpu/cpu.h             |    2 +-
 arch/x86/kernel/cpu/cyrix.c           |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c |   16 -----------
 arch/x86/kernel/cpu/transmeta.c       |    2 +-
 arch/x86/kernel/dumpstack_32.c        |    9 +++---
 arch/x86/kernel/dumpstack_64.c        |   46 ++++++++++++++++++--------------
 arch/x86/kernel/process_32.c          |    2 +-
 arch/x86/kernel/process_64.c          |    3 +-
 arch/x86/kernel/tsc_sync.c            |   13 +++++----
 arch/x86/mm/fault.c                   |    2 +-
 14 files changed, 67 insertions(+), 75 deletions(-)

diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index 7ff61d6..6389432 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -39,7 +39,8 @@
 int unknown_nmi_panic;
 int nmi_watchdog_enabled;
 
-static cpumask_t backtrace_mask __read_mostly;
+/* For reliability, we're prepared to waste bits here. */
+static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
 
 /* nmi_active:
  * >0: the lapic NMI watchdog is active, but can be disabled
@@ -414,7 +415,7 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 	}
 
 	/* We can be called before check_nmi_watchdog, hence NULL check. */
-	if (cpumask_test_cpu(cpu, &backtrace_mask)) {
+	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
 		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
 
 		spin_lock(&lock);
@@ -422,7 +423,7 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 		show_regs(regs);
 		dump_stack();
 		spin_unlock(&lock);
-		cpumask_clear_cpu(cpu, &backtrace_mask);
+		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
 
 		rc = 1;
 	}
@@ -558,14 +559,14 @@ void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
 
-	cpumask_copy(&backtrace_mask, cpu_online_mask);
+	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
 
 	printk(KERN_INFO "sending NMI to all CPUs:\n");
 	apic->send_IPI_all(NMI_VECTOR);
 
 	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
 	for (i = 0; i < 10 * 1000; i++) {
-		if (cpumask_empty(&backtrace_mask))
+		if (cpumask_empty(to_cpumask(backtrace_mask)))
 			break;
 		mdelay(1);
 	}
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c910a71..7128b37 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -535,7 +535,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 
-	display_cacheinfo(c);
+	cpu_detect_cache_sizes(c);
 
 	/* Multi core CPU? */
 	if (c->extended_cpuid_level >= 0x80000008) {
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index c95e831..e58d978 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -294,7 +294,7 @@ static void __cpuinit init_c3(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 	}
 
-	display_cacheinfo(c);
+	cpu_detect_cache_sizes(c);
 }
 
 enum {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cc25c2b..9bf845d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -61,7 +61,7 @@ void __init setup_cpu_local_masks(void)
 static void __cpuinit default_init(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_64
-	display_cacheinfo(c);
+	cpu_detect_cache_sizes(c);
 #else
 	/* Not much we can do here... */
 	/* Check if at least it has cpuid */
@@ -383,7 +383,7 @@ static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	}
 }
 
-void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
+void __cpuinit cpu_detect_cache_sizes(struct cpuinfo_x86 *c)
 {
 	unsigned int n, dummy, ebx, ecx, edx, l2size;
 
@@ -391,8 +391,6 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 
 	if (n >= 0x80000005) {
 		cpuid(0x80000005, &dummy, &ebx, &ecx, &edx);
-		printk(KERN_INFO "CPU: L1 I Cache: %dK (%d bytes/line), D cache %dK (%d bytes/line)\n",
-				edx>>24, edx&0xFF, ecx>>24, ecx&0xFF);
 		c->x86_cache_size = (ecx>>24) + (edx>>24);
 #ifdef CONFIG_X86_64
 		/* On K8 L1 TLB is inclusive, so don't count it */
@@ -422,9 +420,6 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 #endif
 
 	c->x86_cache_size = l2size;
-
-	printk(KERN_INFO "CPU: L2 Cache: %dK (%d bytes/line)\n",
-			l2size, ecx & 0xFF);
 }
 
 void __cpuinit detect_ht(struct cpuinfo_x86 *c)
@@ -659,24 +654,31 @@ void __init early_cpu_init(void)
 	const struct cpu_dev *const *cdev;
 	int count = 0;
 
+#ifdef PROCESSOR_SELECT
 	printk(KERN_INFO "KERNEL supported cpus:\n");
+#endif
+
 	for (cdev = __x86_cpu_dev_start; cdev < __x86_cpu_dev_end; cdev++) {
 		const struct cpu_dev *cpudev = *cdev;
-		unsigned int j;
 
 		if (count >= X86_VENDOR_NUM)
 			break;
 		cpu_devs[count] = cpudev;
 		count++;
 
-		for (j = 0; j < 2; j++) {
-			if (!cpudev->c_ident[j])
-				continue;
-			printk(KERN_INFO "  %s %s\n", cpudev->c_vendor,
-				cpudev->c_ident[j]);
+#ifdef PROCESSOR_SELECT
+		{
+			unsigned int j;
+
+			for (j = 0; j < 2; j++) {
+				if (!cpudev->c_ident[j])
+					continue;
+				printk(KERN_INFO "  %s %s\n", cpudev->c_vendor,
+					cpudev->c_ident[j]);
+			}
 		}
+#endif
 	}
-
 	early_identify_cpu(&boot_cpu_data);
 }
 
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 6de9a90..3624e8a 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -32,6 +32,6 @@ struct cpu_dev {
 extern const struct cpu_dev *const __x86_cpu_dev_start[],
 			    *const __x86_cpu_dev_end[];
 
-extern void display_cacheinfo(struct cpuinfo_x86 *c);
+extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
 
 #endif
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 19807b8..4fbd384 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -373,7 +373,7 @@ static void __cpuinit init_nsc(struct cpuinfo_x86 *c)
 	/* Handle the GX (Formally known as the GX2) */
 
 	if (c->x86 == 5 && c->x86_model == 5)
-		display_cacheinfo(c);
+		cpu_detect_cache_sizes(c);
 	else
 		init_cyrix(c);
 }
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 804c40e..0df4c2b 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -488,22 +488,6 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 #endif
 	}
 
-	if (trace)
-		printk(KERN_INFO "CPU: Trace cache: %dK uops", trace);
-	else if (l1i)
-		printk(KERN_INFO "CPU: L1 I cache: %dK", l1i);
-
-	if (l1d)
-		printk(KERN_CONT ", L1 D cache: %dK\n", l1d);
-	else
-		printk(KERN_CONT "\n");
-
-	if (l2)
-		printk(KERN_INFO "CPU: L2 cache: %dK\n", l2);
-
-	if (l3)
-		printk(KERN_INFO "CPU: L3 cache: %dK\n", l3);
-
 	c->x86_cache_size = l3 ? l3 : (l2 ? l2 : (l1i+l1d));
 
 	return l2;
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index bb62b3e..2800074 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -26,7 +26,7 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 
 	early_init_transmeta(c);
 
-	display_cacheinfo(c);
+	cpu_detect_cache_sizes(c);
 
 	/* Print CMS and CPU revision */
 	max = cpuid_eax(0x80860000);
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index f7dd2a7..e0ed4c7 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -10,9 +10,9 @@
 #include <linux/module.h>
 #include <linux/ptrace.h>
 #include <linux/kexec.h>
+#include <linux/sysfs.h>
 #include <linux/bug.h>
 #include <linux/nmi.h>
-#include <linux/sysfs.h>
 
 #include <asm/stacktrace.h>
 
@@ -35,6 +35,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 
 	if (!stack) {
 		unsigned long dummy;
+
 		stack = &dummy;
 		if (task && task != current)
 			stack = (unsigned long *)task->thread.sp;
@@ -57,8 +58,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 
 		context = (struct thread_info *)
 			((unsigned long)stack & (~(THREAD_SIZE - 1)));
-		bp = print_context_stack(context, stack, bp, ops,
-					 data, NULL, &graph);
+		bp = print_context_stack(context, stack, bp, ops, data, NULL, &graph);
 
 		stack = (unsigned long *)context->previous_esp;
 		if (!stack)
@@ -72,7 +72,7 @@ EXPORT_SYMBOL(dump_trace);
 
 void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *sp, unsigned long bp, char *log_lvl)
+		   unsigned long *sp, unsigned long bp, char *log_lvl)
 {
 	unsigned long *stack;
 	int i;
@@ -156,4 +156,3 @@ int is_valid_bugaddr(unsigned long ip)
 
 	return ud2 == 0x0b0f;
 }
-
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index a071e6b..8e74093 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -10,26 +10,28 @@
 #include <linux/module.h>
 #include <linux/ptrace.h>
 #include <linux/kexec.h>
+#include <linux/sysfs.h>
 #include <linux/bug.h>
 #include <linux/nmi.h>
-#include <linux/sysfs.h>
 
 #include <asm/stacktrace.h>
 
 #include "dumpstack.h"
 
+#define N_EXCEPTION_STACKS_END \
+		(N_EXCEPTION_STACKS + DEBUG_STKSZ/EXCEPTION_STKSZ - 2)
 
 static char x86_stack_ids[][8] = {
-		[DEBUG_STACK - 1] = "#DB",
-		[NMI_STACK - 1] = "NMI",
-		[DOUBLEFAULT_STACK - 1] = "#DF",
-		[STACKFAULT_STACK - 1] = "#SS",
-		[MCE_STACK - 1] = "#MC",
+		[ DEBUG_STACK-1			]	= "#DB",
+		[ NMI_STACK-1			]	= "NMI",
+		[ DOUBLEFAULT_STACK-1		]	= "#DF",
+		[ STACKFAULT_STACK-1		]	= "#SS",
+		[ MCE_STACK-1			]	= "#MC",
 #if DEBUG_STKSZ > EXCEPTION_STKSZ
-		[N_EXCEPTION_STACKS ...
-			N_EXCEPTION_STACKS + DEBUG_STKSZ / EXCEPTION_STKSZ - 2] = "#DB[?]"
+		[ N_EXCEPTION_STACKS ...
+		  N_EXCEPTION_STACKS_END	]	= "#DB[?]"
 #endif
-	};
+};
 
 int x86_is_stack_id(int id, char *name)
 {
@@ -37,7 +39,7 @@ int x86_is_stack_id(int id, char *name)
 }
 
 static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
-					unsigned *usedp, char **idp)
+					 unsigned *usedp, char **idp)
 {
 	unsigned k;
 
@@ -202,21 +204,24 @@ EXPORT_SYMBOL(dump_trace);
 
 void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *sp, unsigned long bp, char *log_lvl)
+		   unsigned long *sp, unsigned long bp, char *log_lvl)
 {
+	unsigned long *irq_stack_end;
+	unsigned long *irq_stack;
 	unsigned long *stack;
+	int cpu;
 	int i;
-	const int cpu = smp_processor_id();
-	unsigned long *irq_stack_end =
-		(unsigned long *)(per_cpu(irq_stack_ptr, cpu));
-	unsigned long *irq_stack =
-		(unsigned long *)(per_cpu(irq_stack_ptr, cpu) - IRQ_STACK_SIZE);
+
+	preempt_disable();
+	cpu = smp_processor_id();
+
+	irq_stack_end	= (unsigned long *)(per_cpu(irq_stack_ptr, cpu));
+	irq_stack	= (unsigned long *)(per_cpu(irq_stack_ptr, cpu) - IRQ_STACK_SIZE);
 
 	/*
-	 * debugging aid: "show_stack(NULL, NULL);" prints the
-	 * back trace for this cpu.
+	 * Debugging aid: "show_stack(NULL, NULL);" prints the
+	 * back trace for this cpu:
 	 */
-
 	if (sp == NULL) {
 		if (task)
 			sp = (unsigned long *)task->thread.sp;
@@ -240,6 +245,8 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		printk(" %016lx", *stack++);
 		touch_nmi_watchdog();
 	}
+	preempt_enable();
+
 	printk("\n");
 	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
@@ -303,4 +310,3 @@ int is_valid_bugaddr(unsigned long ip)
 
 	return ud2 == 0x0b0f;
 }
-
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 4cf7956..e658331 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -187,7 +187,7 @@ void __show_regs(struct pt_regs *regs, int all)
 
 void show_regs(struct pt_regs *regs)
 {
-	__show_regs(regs, 1);
+	show_registers(regs);
 	show_trace(NULL, regs, &regs->sp, regs->bp);
 }
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ad535b6..2386999 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -226,8 +226,7 @@ void __show_regs(struct pt_regs *regs, int all)
 
 void show_regs(struct pt_regs *regs)
 {
-	printk(KERN_INFO "CPU %d:", smp_processor_id());
-	__show_regs(regs, 1);
+	show_registers(regs);
 	show_trace(NULL, regs, (void *)(regs + 1), regs->bp);
 }
 
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index f379309..eed1568 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -114,13 +114,12 @@ void __cpuinit check_tsc_sync_source(int cpu)
 		return;
 
 	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE)) {
-		printk_once(KERN_INFO "Skipping synchronization checks as TSC is reliable.\n");
+		if (cpu == (nr_cpu_ids-1) || system_state != SYSTEM_BOOTING)
+			pr_info(
+			"Skipped synchronization checks as TSC is reliable.\n");
 		return;
 	}
 
-	pr_info("checking TSC synchronization [CPU#%d -> CPU#%d]:",
-		smp_processor_id(), cpu);
-
 	/*
 	 * Reset it - in case this is a second bootup:
 	 */
@@ -142,12 +141,14 @@ void __cpuinit check_tsc_sync_source(int cpu)
 		cpu_relax();
 
 	if (nr_warps) {
-		printk("\n");
+		pr_warning("TSC synchronization [CPU#%d -> CPU#%d]:\n",
+			smp_processor_id(), cpu);
 		pr_warning("Measured %Ld cycles TSC warp between CPUs, "
 			   "turning off TSC clock.\n", max_warp);
 		mark_tsc_unstable("check_tsc_sync_source failed");
 	} else {
-		printk(" passed.\n");
+		pr_debug("TSC synchronization [CPU#%d -> CPU#%d]: passed\n",
+			smp_processor_id(), cpu);
 	}
 
 	/*
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f4cee90..071eee6 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -658,7 +658,7 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 	show_fault_oops(regs, error_code, address);
 
 	stackend = end_of_stack(tsk);
-	if (*stackend != STACK_END_MAGIC)
+	if (tsk != &init_task && *stackend != STACK_END_MAGIC)
 		printk(KERN_ALERT "Thread overran stack, or stack corrupted\n");
 
 	tsk->thread.cr2		= address;
