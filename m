Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbYDZWJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbYDZWJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 18:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbYDZWJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 18:09:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47416 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439AbYDZWJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 18:09:38 -0400
Date: Sun, 27 Apr 2008 00:09:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: [git pull] idle fix
Message-ID: <20080426220921.GA5542@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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


Linus, please pull the following fix:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-idle-fix.git for-linus

i'd normally wait for Len/Venki to ack the ACPI bits but this seems more 
urgent as people are seeing lockups via the ACPI-idle route, as per:

  http://lkml.org/lkml/2008/4/26/235

Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      fix idle (arch, acpi and apm) and lockdep

 arch/x86/kernel/apm_32.c      |    3 +
 arch/x86/kernel/process.c     |  117 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/process_32.c  |  118 +--------------------------------------
 arch/x86/kernel/process_64.c  |  123 +----------------------------------------
 drivers/acpi/processor_idle.c |   19 +++---
 include/asm-x86/processor.h   |    1 +
 6 files changed, 137 insertions(+), 244 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index f0030a0..e4ea362 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -904,6 +904,7 @@ recalc:
 			original_pm_idle();
 		else
 			default_idle();
+		local_irq_disable();
 		jiffies_since_last_check = jiffies - last_jiffies;
 		if (jiffies_since_last_check > idle_period)
 			goto recalc;
@@ -911,6 +912,8 @@ recalc:
 
 	if (apm_idle_done)
 		apm_do_busy();
+
+	local_irq_enable();
 }
 
 /**
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 3004d71..67e9b4a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -4,6 +4,8 @@
 #include <linux/smp.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/pm.h>
 
 struct kmem_cache *task_xstate_cachep;
 
@@ -42,3 +44,118 @@ void arch_task_cache_init(void)
 				  __alignof__(union thread_xstate),
 				  SLAB_PANIC, NULL);
 }
+
+static void do_nothing(void *unused)
+{
+}
+
+/*
+ * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
+ * pm_idle and update to new pm_idle value. Required while changing pm_idle
+ * handler on SMP systems.
+ *
+ * Caller must have changed pm_idle to the new value before the call. Old
+ * pm_idle value will not be used by any CPU after the return of this function.
+ */
+void cpu_idle_wait(void)
+{
+	smp_mb();
+	/* kick all the CPUs so that they exit out of pm_idle */
+	smp_call_function(do_nothing, NULL, 0, 1);
+}
+EXPORT_SYMBOL_GPL(cpu_idle_wait);
+
+/*
+ * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
+ * which can obviate IPI to trigger checking of need_resched.
+ * We execute MONITOR against need_resched and enter optimized wait state
+ * through MWAIT. Whenever someone changes need_resched, we would be woken
+ * up from MWAIT (without an IPI).
+ *
+ * New with Core Duo processors, MWAIT can take some hints based on CPU
+ * capability.
+ */
+void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
+{
+	if (!need_resched()) {
+		__monitor((void *)&current_thread_info()->flags, 0, 0);
+		smp_mb();
+		if (!need_resched())
+			__mwait(ax, cx);
+	}
+}
+
+/* Default MONITOR/MWAIT with no hints, used for default C1 state */
+static void mwait_idle(void)
+{
+	if (!need_resched()) {
+		__monitor((void *)&current_thread_info()->flags, 0, 0);
+		smp_mb();
+		if (!need_resched())
+			__sti_mwait(0, 0);
+		else
+			local_irq_enable();
+	} else
+		local_irq_enable();
+}
+
+
+static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
+{
+	if (force_mwait)
+		return 1;
+	/* Any C1 states supported? */
+	return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
+}
+
+/*
+ * On SMP it's slightly faster (but much more power-consuming!)
+ * to poll the ->work.need_resched flag instead of waiting for the
+ * cross-CPU IPI to arrive. Use this option with caution.
+ */
+static void poll_idle(void)
+{
+	local_irq_enable();
+	cpu_relax();
+}
+
+void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
+{
+	static int selected;
+
+	if (selected)
+		return;
+#ifdef CONFIG_X86_SMP
+	if (pm_idle == poll_idle && smp_num_siblings > 1) {
+		printk(KERN_WARNING "WARNING: polling idle and HT enabled,"
+			" performance may degrade.\n");
+	}
+#endif
+	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
+		/*
+		 * Skip, if setup has overridden idle.
+		 * One CPU supports mwait => All CPUs supports mwait
+		 */
+		if (!pm_idle) {
+			printk(KERN_INFO "using mwait in idle threads.\n");
+			pm_idle = mwait_idle;
+		}
+	}
+	selected = 1;
+}
+
+static int __init idle_setup(char *str)
+{
+	if (!strcmp(str, "poll")) {
+		printk("using polling idle threads.\n");
+		pm_idle = poll_idle;
+	} else if (!strcmp(str, "mwait"))
+		force_mwait = 1;
+	else
+		return -1;
+
+	boot_option_idle_override = 1;
+	return 0;
+}
+early_param("idle", idle_setup);
+
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 77de848..f8476df 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -111,12 +111,10 @@ void default_idle(void)
 		 */
 		smp_mb();
 
-		local_irq_disable();
-		if (!need_resched()) {
+		if (!need_resched())
 			safe_halt();	/* enables interrupts racelessly */
-			local_irq_disable();
-		}
-		local_irq_enable();
+		else
+			local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
 	} else {
 		local_irq_enable();
@@ -128,17 +126,6 @@ void default_idle(void)
 EXPORT_SYMBOL(default_idle);
 #endif
 
-/*
- * On SMP it's slightly faster (but much more power-consuming!)
- * to poll the ->work.need_resched flag instead of waiting for the
- * cross-CPU IPI to arrive. Use this option with caution.
- */
-static void poll_idle(void)
-{
-	local_irq_enable();
-	cpu_relax();
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 #include <asm/nmi.h>
 /* We don't actually take CPU down, just spin without interrupts. */
@@ -196,6 +183,7 @@ void cpu_idle(void)
 			if (cpu_is_offline(cpu))
 				play_dead();
 
+			local_irq_disable();
 			__get_cpu_var(irq_stat).idle_timestamp = jiffies;
 			idle();
 		}
@@ -206,104 +194,6 @@ void cpu_idle(void)
 	}
 }
 
-static void do_nothing(void *unused)
-{
-}
-
-/*
- * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
- * pm_idle and update to new pm_idle value. Required while changing pm_idle
- * handler on SMP systems.
- *
- * Caller must have changed pm_idle to the new value before the call. Old
- * pm_idle value will not be used by any CPU after the return of this function.
- */
-void cpu_idle_wait(void)
-{
-	smp_mb();
-	/* kick all the CPUs so that they exit out of pm_idle */
-	smp_call_function(do_nothing, NULL, 0, 1);
-}
-EXPORT_SYMBOL_GPL(cpu_idle_wait);
-
-/*
- * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
- * which can obviate IPI to trigger checking of need_resched.
- * We execute MONITOR against need_resched and enter optimized wait state
- * through MWAIT. Whenever someone changes need_resched, we would be woken
- * up from MWAIT (without an IPI).
- *
- * New with Core Duo processors, MWAIT can take some hints based on CPU
- * capability.
- */
-void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
-{
-	if (!need_resched()) {
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
-		if (!need_resched())
-			__sti_mwait(ax, cx);
-		else
-			local_irq_enable();
-	} else
-		local_irq_enable();
-}
-
-/* Default MONITOR/MWAIT with no hints, used for default C1 state */
-static void mwait_idle(void)
-{
-	local_irq_enable();
-	mwait_idle_with_hints(0, 0);
-}
-
-static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
-{
-	if (force_mwait)
-		return 1;
-	/* Any C1 states supported? */
-	return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
-}
-
-void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
-{
-	static int selected;
-
-	if (selected)
-		return;
-#ifdef CONFIG_X86_SMP
-	if (pm_idle == poll_idle && smp_num_siblings > 1) {
-		printk(KERN_WARNING "WARNING: polling idle and HT enabled,"
-			" performance may degrade.\n");
-	}
-#endif
-	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
-		/*
-		 * Skip, if setup has overridden idle.
-		 * One CPU supports mwait => All CPUs supports mwait
-		 */
-		if (!pm_idle) {
-			printk(KERN_INFO "using mwait in idle threads.\n");
-			pm_idle = mwait_idle;
-		}
-	}
-	selected = 1;
-}
-
-static int __init idle_setup(char *str)
-{
-	if (!strcmp(str, "poll")) {
-		printk("using polling idle threads.\n");
-		pm_idle = poll_idle;
-	} else if (!strcmp(str, "mwait"))
-		force_mwait = 1;
-	else
-		return -1;
-
-	boot_option_idle_override = 1;
-	return 0;
-}
-early_param("idle", idle_setup);
-
 void __show_registers(struct pt_regs *regs, int all)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 131c2ee..e2319f3 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -106,26 +106,13 @@ void default_idle(void)
 	 * test NEED_RESCHED:
 	 */
 	smp_mb();
-	local_irq_disable();
-	if (!need_resched()) {
+	if (!need_resched())
 		safe_halt();	/* enables interrupts racelessly */
-		local_irq_disable();
-	}
-	local_irq_enable();
+	else
+		local_irq_enable();
 	current_thread_info()->status |= TS_POLLING;
 }
 
-/*
- * On SMP it's slightly faster (but much more power-consuming!)
- * to poll the ->need_resched flag instead of waiting for the
- * cross-CPU IPI to arrive. Use this option with caution.
- */
-static void poll_idle(void)
-{
-	local_irq_enable();
-	cpu_relax();
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 DECLARE_PER_CPU(int, cpu_state);
 
@@ -192,110 +179,6 @@ void cpu_idle(void)
 	}
 }
 
-static void do_nothing(void *unused)
-{
-}
-
-/*
- * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
- * pm_idle and update to new pm_idle value. Required while changing pm_idle
- * handler on SMP systems.
- *
- * Caller must have changed pm_idle to the new value before the call. Old
- * pm_idle value will not be used by any CPU after the return of this function.
- */
-void cpu_idle_wait(void)
-{
-	smp_mb();
-	/* kick all the CPUs so that they exit out of pm_idle */
-	smp_call_function(do_nothing, NULL, 0, 1);
-}
-EXPORT_SYMBOL_GPL(cpu_idle_wait);
-
-/*
- * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
- * which can obviate IPI to trigger checking of need_resched.
- * We execute MONITOR against need_resched and enter optimized wait state
- * through MWAIT. Whenever someone changes need_resched, we would be woken
- * up from MWAIT (without an IPI).
- *
- * New with Core Duo processors, MWAIT can take some hints based on CPU
- * capability.
- */
-void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
-{
-	if (!need_resched()) {
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
-		if (!need_resched())
-			__mwait(ax, cx);
-	}
-}
-
-/* Default MONITOR/MWAIT with no hints, used for default C1 state */
-static void mwait_idle(void)
-{
-	if (!need_resched()) {
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
-		if (!need_resched())
-			__sti_mwait(0, 0);
-		else
-			local_irq_enable();
-	} else {
-		local_irq_enable();
-	}
-}
-
-
-static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
-{
-	if (force_mwait)
-		return 1;
-	/* Any C1 states supported? */
-	return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
-}
-
-void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
-{
-	static int selected;
-
-	if (selected)
-		return;
-#ifdef CONFIG_X86_SMP
-	if (pm_idle == poll_idle && smp_num_siblings > 1) {
-		printk(KERN_WARNING "WARNING: polling idle and HT enabled,"
-			" performance may degrade.\n");
-	}
-#endif
-	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
-		/*
-		 * Skip, if setup has overridden idle.
-		 * One CPU supports mwait => All CPUs supports mwait
-		 */
-		if (!pm_idle) {
-			printk(KERN_INFO "using mwait in idle threads.\n");
-			pm_idle = mwait_idle;
-		}
-	}
-	selected = 1;
-}
-
-static int __init idle_setup(char *str)
-{
-	if (!strcmp(str, "poll")) {
-		printk("using polling idle threads.\n");
-		pm_idle = poll_idle;
-	} else if (!strcmp(str, "mwait"))
-		force_mwait = 1;
-	else
-		return -1;
-
-	boot_option_idle_override = 1;
-	return 0;
-}
-early_param("idle", idle_setup);
-
 /* Prints also some state that isn't saved in the pt_regs */
 void __show_regs(struct pt_regs * regs)
 {
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 788da97..0d90ff5 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -418,13 +418,12 @@ static void acpi_processor_idle(void)
 
 	cx = pr->power.state;
 	if (!cx || acpi_idle_suspend) {
-		if (pm_idle_save)
-			pm_idle_save();
-		else
+		if (pm_idle_save) {
+			pm_idle_save(); /* enables IRQs */
+		} else {
 			acpi_safe_halt();
-
-		if (irqs_disabled())
 			local_irq_enable();
+		}
 
 		return;
 	}
@@ -520,10 +519,12 @@ static void acpi_processor_idle(void)
 		 * Use the appropriate idle routine, the one that would
 		 * be used without acpi C-states.
 		 */
-		if (pm_idle_save)
-			pm_idle_save();
-		else
+		if (pm_idle_save) {
+			pm_idle_save(); /* enables IRQs */
+		} else {
 			acpi_safe_halt();
+			local_irq_enable();
+		}
 
 		/*
 		 * TBD: Can't get time duration while in C1, as resumes
@@ -534,8 +535,6 @@ static void acpi_processor_idle(void)
 		 *       skew otherwise.
 		 */
 		sleep_ticks = 0xFFFFFFFF;
-		if (irqs_disabled())
-			local_irq_enable();
 
 		break;
 
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 117343b..2e7974e 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -722,6 +722,7 @@ static inline void __mwait(unsigned long eax, unsigned long ecx)
 
 static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 {
+	trace_hardirqs_on();
 	/* "mwait %eax, %ecx;" */
 	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
 		     :: "a" (eax), "c" (ecx));
