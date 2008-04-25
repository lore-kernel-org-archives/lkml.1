Return-Path: <linux-kernel-owner+w=401wt.eu-S1762243AbYDYPjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762243AbYDYPjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 11:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbYDYPjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 11:39:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52038 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbYDYPjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 11:39:37 -0400
Subject: [PATCH] idle (arch, acpi and apm) and lockdep
From: Peter Zijlstra <peterz@infradead.org>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       "Brown, Len" <len.brown@intel.com>
In-Reply-To: <1209135549.32291.5.camel@lappy>
References: <dd18b0c30804241724t2dcc044dvab4a5ad506255d8d@mail.gmail.com>
	 <1209125470.24931.10.camel@lappy>
	 <dd18b0c30804250747u4168bafsccc6feec0ba78c26@mail.gmail.com>
	 <1209135549.32291.5.camel@lappy>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 17:39:01 +0200
Message-Id: <1209137941.32291.10.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-25 at 16:59 +0200, Peter Zijlstra wrote:
> On Fri, 2008-04-25 at 14:47 +0000, Justin Mattock wrote:
> > On Fri, Apr 25, 2008 at 12:11 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > On Fri, 2008-04-25 at 00:24 +0000, Justin Mattock wrote:
> > >
> > >  > [   13.269763] =================================
> > >  > [   13.270954] [ INFO: inconsistent lock state ]
> > >  > [   13.271865] 2.6.25-04569-gb69d398 #3
> > >  > [   13.272614] ---------------------------------
> > >  > [   13.273521] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
> > >  > [   13.274745] swapper/0 [HC0[0]:SC0[0]:HE1:SE1] takes:
> > >  > [   13.275787]  (&rq->rq_lock_key){++..}, at: [<c01208e9>] sched_clock_idle_wakeup_event+0x43/0x74
> > >  > [   13.276859] {in-hardirq-W} state was registered at:
> > >  > [   13.276859]   [<c01423d8>] __lock_acquire+0x419/0xb70
> > >  > [   13.276859]   [<c0142bae>] lock_acquire+0x7f/0xa6
> > >  > [   13.280188]   [<c0394132>] _spin_lock+0x1c/0x49
> > >  > [   13.280188]   [<c0121c44>] scheduler_tick+0x43/0x1bd
> > >  > [   13.280188]   [<c012d99f>] update_process_times+0x3d/0x49
> > >  > [   13.283524]   [<c013daf6>] tick_periodic+0x66/0x72
> > >  > [   13.283524]   [<c013db1b>] tick_handle_periodic+0x19/0x6a
> > >  > [   13.283524]   [<c0105a87>] timer_interrupt+0x47/0x4e
> > >  > [   13.286855]   [<c015cf64>] handle_IRQ_event+0x1a/0x4f
> > >  > [   13.286855]   [<c015e3e9>] handle_level_irq+0x7f/0xca
> > >  > [   13.286855]   [<c0105a27>] do_IRQ+0x71/0x8a
> > >  > [   13.290190]   [<c01043fe>] common_interrupt+0x2e/0x34
> > >  > [   13.290190]   [<c038bd6f>] calibrate_delay+0x8f/0x276
> > >  > [   13.290190]   [<c04f0883>] start_kernel+0x27c/0x2f8
> > >  > [   13.293520]   [<c04f0008>] __init_begin+0x8/0xa
> > >  > [   13.293520]   [<ffffffff>] 0xffffffff
> > >  > [   13.293520] irq event stamp: 253965
> > >  > [   13.296856] hardirqs last  enabled at (253965): [<c0108069>] native_sched_clock+0xe7/0xff
> > >  > [   13.296856] hardirqs last disabled at (253964): [<c0107fef>] native_sched_clock+0x6d/0xff
> > >  > [   13.300190] softirqs last  enabled at (253958): [<c0129cea>] __do_softirq+0xf9/0xff
> > >  > [   13.300190] softirqs last disabled at (253953): [<c0129d3d>] do_softirq+0x4d/0x79
> > >  > [   13.303522]
> > >  > [   13.303522] other info that might help us debug this:
> > >  > [   13.303522] no locks held by swapper/0.
> > >  > [   13.303522]
> > >  > [   13.303522] stack backtrace:
> > >  > [   13.306852] Pid: 0, comm: swapper Not tainted 2.6.25-04569-gb69d398 #3
> > >  > [   13.336851]  [<c01409f9>] print_usage_bug+0x106/0x113
> > >  > [   13.340185]  [<c0141823>] mark_lock+0x1ed/0x3a5
> > >  > [   13.343519]  [<c014244d>] __lock_acquire+0x48e/0xb70
> > >  > [   13.346852]  [<c0142bae>] lock_acquire+0x7f/0xa6
> > >  > [   13.350185]  [<c01208e9>] ? sched_clock_idle_wakeup_event+0x43/0x74
> > >  > [   13.353519]  [<c0394132>] _spin_lock+0x1c/0x49
> > >  > [   13.360185]  [<c01208e9>] ? sched_clock_idle_wakeup_event+0x43/0x74
> > >  > [   13.363518]  [<c01208e9>] sched_clock_idle_wakeup_event+0x43/0x74
> 
> Got it:
> 
>   acpi_idle_do_entry()
>     acpi_processor_ffh_cstate_enter()
>       mwait_idle_with_hints() (32 bit)
>         local_irq_enable()
> 
>   sched_clock_idle_wakeup_event()
> 
> 
> I think my recent idle patches should address this, no?
> 
> > >  > [   13.366851]  [<f883919b>] acpi_idle_enter_bm+0x2b3/0x333 [processor]
> > >  > [   13.370184]  [<c02e5ec1>] cpuidle_idle_call+0x63/0x92
> > >  > [   13.373517]  [<c02e5e5e>] ? cpuidle_idle_call+0x0/0x92
> > >  > [   13.380184]  [<c010257d>] cpu_idle+0xb6/0xd6
> > >  > [   13.383517]  [<c0387071>] rest_init+0x49/0x4b
> > >  > [   13.386850]  =======================

(I just found out I failed to copy LKML on the last discussion about
these patches)

---
Subject: [PATCH] idle (arch,acpi and apm) and lockdep
From: Peter Zijlstra <peterz@infradead.org>

OK, so 25-mm1 gave a lockdep error which made me look into this.

The first thing that I noticed was the horrible mess; the second thing I
saw was hacks like: 71e93d15612c61c2e26a169567becf088e71b8ff

The problem is that arch idle routines are somewhat inconsitent with
their IRQ state handling and instead of fixing _that_, we go paper over
the problem.

So the thing I've tried to do is set a standard for idle routines and
fix them all up to adhere to that. So the rules are:

  idle routines are entered with IRQs disabled
  idle routines will exit with IRQs enabled

Nearly all already did this in one form or another.

Merge the 32 and 64 bit bits so they no longer have different bugs.

As for the actual lockdep warning; __sti_mwait() did a plainly un-annotated
irq-enable.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/apm_32.c      |    3 +
 arch/x86/kernel/process.c     |  117 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/process_32.c  |  118 +---------------------------------------
 arch/x86/kernel/process_64.c  |  123 +-----------------------------------------
 drivers/acpi/processor_idle.c |   19 +++---
 include/asm-x86/processor.h   |    1 
 6 files changed, 137 insertions(+), 244 deletions(-)

Index: linux-2.6-2/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6-2.orig/arch/x86/kernel/process_32.c
+++ linux-2.6-2/arch/x86/kernel/process_32.c
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
Index: linux-2.6-2/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-2.orig/arch/x86/kernel/process_64.c
+++ linux-2.6-2/arch/x86/kernel/process_64.c
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
Index: linux-2.6-2/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6-2.orig/drivers/acpi/processor_idle.c
+++ linux-2.6-2/drivers/acpi/processor_idle.c
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
 
Index: linux-2.6-2/arch/x86/kernel/apm_32.c
===================================================================
--- linux-2.6-2.orig/arch/x86/kernel/apm_32.c
+++ linux-2.6-2/arch/x86/kernel/apm_32.c
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
Index: linux-2.6-2/include/asm-x86/processor.h
===================================================================
--- linux-2.6-2.orig/include/asm-x86/processor.h
+++ linux-2.6-2/include/asm-x86/processor.h
@@ -723,6 +723,7 @@ static inline void __mwait(unsigned long
 
 static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 {
+	trace_hardirqs_on();
 	/* "mwait %eax, %ecx;" */
 	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
 		     :: "a" (eax), "c" (ecx));
Index: linux-2.6-2/arch/x86/kernel/process.c
===================================================================
--- linux-2.6-2.orig/arch/x86/kernel/process.c
+++ linux-2.6-2/arch/x86/kernel/process.c
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


