Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZLBJ7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZLBJ7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 04:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbZLBJ7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 04:59:42 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:60668 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbZLBJ7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 04:59:39 -0500
Date: Wed, 2 Dec 2009 15:29:40 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [v10 PATCH 4/9]: x86: refactor x86 idle power management code,
 remove all instances of pm_idle
Message-ID: <20091202095940.GE27251@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091202095427.GA27251@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091202095427.GA27251@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-12-02 15:24:27]:

This patch cleans up x86 of all instances of pm_idle.

pm_idle which was earlier called from cpu_idle() idle loop
is replaced by cpuidle_idle_call.

x86 also registers to cpuidle when the idle routine is selected,
by populating the cpuidle_device data structure for each cpu.

This is replicated for apm module and for xen, which also used pm_idle.


Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/x86/kernel/apm_32.c      |   46 +++++++++++++++++++++++-
 arch/x86/kernel/process.c     |   78 +++++++++++++++++++++++++++++++-----------
 arch/x86/kernel/process_32.c  |    3 +
 arch/x86/kernel/process_64.c  |    3 +
 arch/x86/xen/setup.c          |   30 +++++++++++++++-
 drivers/acpi/processor_core.c |    9 +++-
 drivers/acpi/processor_idle.c |   44 ++++++++++-------------
 7 files changed, 160 insertions(+), 53 deletions(-)

Index: linux.trees.git/arch/x86/kernel/process.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/process.c
+++ linux.trees.git/arch/x86/kernel/process.c
@@ -10,6 +10,7 @@
 #include <linux/clockchips.h>
 #include <linux/random.h>
 #include <linux/user-return-notifier.h>
+#include <linux/cpuidle.h>
 #include <trace/events/power.h>
 #include <linux/hw_breakpoint.h>
 #include <asm/system.h>
@@ -241,12 +242,6 @@ int sys_vfork(struct pt_regs *regs)
 unsigned long boot_option_idle_override = 0;
 EXPORT_SYMBOL(boot_option_idle_override);
 
-/*
- * Powermanagement idle function, if any..
- */
-void (*pm_idle)(void);
-EXPORT_SYMBOL(pm_idle);
-
 #ifdef CONFIG_X86_32
 /*
  * This halt magic was a workaround for ancient floppy DMA
@@ -326,17 +321,15 @@ static void do_nothing(void *unused)
 }
 
 /*
- * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
- * pm_idle and update to new pm_idle value. Required while changing pm_idle
- * handler on SMP systems.
+ * cpu_idle_wait - Required while changing idle routine handler on SMP systems.
  *
- * Caller must have changed pm_idle to the new value before the call. Old
- * pm_idle value will not be used by any CPU after the return of this function.
+ * Caller must have changed idle routine to the new value before the call. Old
+ * value will not be used by any CPU after the return of this function.
  */
 void cpu_idle_wait(void)
 {
 	smp_mb();
-	/* kick all the CPUs so that they exit out of pm_idle */
+	/* kick all the CPUs so that they exit out of idle loop */
 	smp_call_function(do_nothing, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(cpu_idle_wait);
@@ -515,15 +508,58 @@ static void c1e_idle(void)
 		default_idle();
 }
 
+static void (*local_idle)(void);
+
+#ifndef CONFIG_CPU_IDLE
+void cpuidle_idle_call(void)
+{
+	if (local_idle)
+		local_idle();
+	else
+		default_idle();
+}
+#endif
+
+DEFINE_PER_CPU(struct cpuidle_device, idle_devices);
+
+struct cpuidle_driver cpuidle_default_driver = {
+	.name =         "cpuidle_default",
+};
+
+static void local_idle_loop(struct cpuidle_device *dev,
+				struct cpuidle_state *st)
+{
+	local_idle();
+}
+
+static int setup_cpuidle_simple(void)
+{
+	struct cpuidle_device *dev;
+	int cpu;
+
+	if (!cpuidle_curr_driver)
+		cpuidle_register_driver(&cpuidle_default_driver);
+
+	for_each_online_cpu(cpu) {
+		dev = &per_cpu(idle_devices, cpu);
+		dev->cpu = cpu;
+		dev->states[0].enter = local_idle_loop;
+		dev->state_count = 1;
+		cpuidle_register_device(dev);
+	}
+	return 0;
+}
+device_initcall(setup_cpuidle_simple);
+
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
-	if (pm_idle == poll_idle && smp_num_siblings > 1) {
+	if (local_idle == poll_idle && smp_num_siblings > 1) {
 		printk(KERN_WARNING "WARNING: polling idle and HT enabled,"
 			" performance may degrade.\n");
 	}
 #endif
-	if (pm_idle)
+	if (local_idle)
 		return;
 
 	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
@@ -531,18 +567,20 @@ void __cpuinit select_idle_routine(const
 		 * One CPU supports mwait => All CPUs supports mwait
 		 */
 		printk(KERN_INFO "using mwait in idle threads.\n");
-		pm_idle = mwait_idle;
+		local_idle = mwait_idle;
 	} else if (check_c1e_idle(c)) {
 		printk(KERN_INFO "using C1E aware idle routine\n");
-		pm_idle = c1e_idle;
+		local_idle = c1e_idle;
 	} else
-		pm_idle = default_idle;
+		local_idle = default_idle;
+
+	return;
 }
 
 void __init init_c1e_mask(void)
 {
 	/* If we're using c1e_idle, we need to allocate c1e_mask. */
-	if (pm_idle == c1e_idle)
+	if (local_idle == c1e_idle)
 		zalloc_cpumask_var(&c1e_mask, GFP_KERNEL);
 }
 
@@ -553,7 +591,7 @@ static int __init idle_setup(char *str)
 
 	if (!strcmp(str, "poll")) {
 		printk("using polling idle threads.\n");
-		pm_idle = poll_idle;
+		local_idle = poll_idle;
 	} else if (!strcmp(str, "mwait"))
 		force_mwait = 1;
 	else if (!strcmp(str, "halt")) {
@@ -564,7 +602,7 @@ static int __init idle_setup(char *str)
 		 * To continue to load the CPU idle driver, don't touch
 		 * the boot_option_idle_override.
 		 */
-		pm_idle = default_idle;
+		local_idle = default_idle;
 		idle_halt = 1;
 		return 0;
 	} else if (!strcmp(str, "nomwait")) {
Index: linux.trees.git/arch/x86/kernel/process_32.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/process_32.c
+++ linux.trees.git/arch/x86/kernel/process_32.c
@@ -40,6 +40,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/kdebug.h>
+#include <linux/cpuidle.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -112,7 +113,7 @@ void cpu_idle(void)
 			local_irq_disable();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
-			pm_idle();
+			cpuidle_idle_call();
 			start_critical_timings();
 		}
 		tick_nohz_restart_sched_tick();
Index: linux.trees.git/arch/x86/kernel/process_64.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/process_64.c
+++ linux.trees.git/arch/x86/kernel/process_64.c
@@ -39,6 +39,7 @@
 #include <linux/io.h>
 #include <linux/ftrace.h>
 #include <linux/dmi.h>
+#include <linux/cpuidle.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -141,7 +142,7 @@ void cpu_idle(void)
 			enter_idle();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
-			pm_idle();
+			cpuidle_idle_call();
 			start_critical_timings();
 			/* In many cases the interrupt that ended idle
 			   has already called exit_idle. But some idle
Index: linux.trees.git/arch/x86/kernel/apm_32.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/apm_32.c
+++ linux.trees.git/arch/x86/kernel/apm_32.c
@@ -227,6 +227,7 @@
 #include <linux/suspend.h>
 #include <linux/kthread.h>
 #include <linux/jiffies.h>
+#include <linux/cpuidle.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -2255,6 +2256,46 @@ static struct dmi_system_id __initdata a
 	{ }
 };
 
+DEFINE_PER_CPU(struct cpuidle_device, apm_idle_devices);
+
+struct cpuidle_driver cpuidle_apm_driver = {
+	.name =         "cpuidle_apm",
+};
+
+static void apm_idle_loop(struct cpuidle_device *dev, struct cpuidle_state *st)
+{
+	apm_cpu_idle();
+}
+
+static void setup_cpuidle_apm(void)
+{
+	struct cpuidle_device *dev;
+	int cpu;
+
+	if (!cpuidle_curr_driver)
+		cpuidle_register_driver(&cpuidle_apm_driver);
+
+	for_each_online_cpu(cpu) {
+		dev = &per_cpu(apm_idle_devices, cpu);
+		dev->cpu = cpu;
+		dev->states[0].enter = apm_idle_loop;
+		dev->state_count = 1;
+		cpuidle_register_device(dev);
+	}
+}
+
+void exit_cpuidle_apm(void)
+{
+	struct cpuidle_device *dev;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		dev = &per_cpu(apm_idle_devices, cpu);
+		cpuidle_unregister_device(dev);
+	}
+}
+
+
 /*
  * Just start the APM thread. We do NOT want to do APM BIOS
  * calls from anything but the APM thread, if for no other reason
@@ -2392,8 +2433,7 @@ static int __init apm_init(void)
 	if (HZ != 100)
 		idle_period = (idle_period * HZ) / 100;
 	if (idle_threshold < 100) {
-		original_pm_idle = pm_idle;
-		pm_idle  = apm_cpu_idle;
+		setup_cpuidle_apm();
 		set_pm_idle = 1;
 	}
 
@@ -2405,7 +2445,7 @@ static void __exit apm_exit(void)
 	int error;
 
 	if (set_pm_idle) {
-		pm_idle = original_pm_idle;
+		exit_cpuidle_apm();
 		/*
 		 * We are about to unload the current idle thread pm callback
 		 * (pm_idle), Wait for all processors to update cached/local
Index: linux.trees.git/arch/x86/xen/setup.c
===================================================================
--- linux.trees.git.orig/arch/x86/xen/setup.c
+++ linux.trees.git/arch/x86/xen/setup.c
@@ -8,6 +8,7 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/pm.h>
+#include <linux/cpuidle.h>
 
 #include <asm/elf.h>
 #include <asm/vdso.h>
@@ -151,6 +152,33 @@ void __cpuinit xen_enable_syscall(void)
 #endif /* CONFIG_X86_64 */
 }
 
+DEFINE_PER_CPU(struct cpuidle_device, xen_idle_devices);
+struct cpuidle_driver cpuidle_xen_driver = {
+	.name =         "cpuidle_xen",
+};
+
+static void xen_idle_loop(struct cpuidle_device *dev, struct cpuidle_state *st)
+{
+	xen_idle();
+}
+
+static void setup_cpuidle_xen(void)
+{
+	struct cpuidle_device *dev;
+	int cpu;
+
+	if (!cpuidle_curr_driver)
+		cpuidle_register_driver(&cpuidle_xen_driver);
+
+	for_each_online_cpu(cpu) {
+		dev = &per_cpu(xen_idle_devices, cpu);
+		dev->cpu = cpu;
+		dev->states[0].enter = xen_idle_loop;
+		dev->state_count = 1;
+		cpuidle_register_device(dev);
+	}
+}
+
 void __init xen_arch_setup(void)
 {
 	struct physdev_set_iopl set_iopl;
@@ -186,7 +214,7 @@ void __init xen_arch_setup(void)
 	       MAX_GUEST_CMDLINE > COMMAND_LINE_SIZE ?
 	       COMMAND_LINE_SIZE : MAX_GUEST_CMDLINE);
 
-	pm_idle = xen_idle;
+	setup_cpuidle_xen();
 
 	paravirt_disable_iospace();
 
Index: linux.trees.git/drivers/acpi/processor_core.c
===================================================================
--- linux.trees.git.orig/drivers/acpi/processor_core.c
+++ linux.trees.git/drivers/acpi/processor_core.c
@@ -1150,9 +1150,12 @@ static int __init acpi_processor_init(vo
 	 * should not use mwait for CPU-states.
 	 */
 	dmi_check_system(processor_idle_dmi_table);
-	result = cpuidle_register_driver(&acpi_idle_driver);
-	if (result < 0)
-		goto out_proc;
+
+	if (!boot_option_idle_override) {
+		result = cpuidle_register_driver(&acpi_idle_driver);
+		if (result < 0)
+			goto out_proc;
+	}
 
 	result = acpi_bus_register_driver(&acpi_processor_driver);
 	if (result < 0)
Index: linux.trees.git/drivers/acpi/processor_idle.c
===================================================================
--- linux.trees.git.orig/drivers/acpi/processor_idle.c
+++ linux.trees.git/drivers/acpi/processor_idle.c
@@ -821,18 +821,16 @@ static inline void acpi_idle_do_entry(st
  *
  * This is equivalent to the HALT instruction.
  */
-static int acpi_idle_enter_c1(struct cpuidle_device *dev,
+static void acpi_idle_enter_c1(struct cpuidle_device *dev,
 			      struct cpuidle_state *state)
 {
-	ktime_t  kt1, kt2;
-	s64 idle_time;
 	struct acpi_processor *pr;
 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
 
 	pr = __get_cpu_var(processors);
 
 	if (unlikely(!pr))
-		return 0;
+		return;
 
 	local_irq_disable();
 
@@ -840,20 +838,15 @@ static int acpi_idle_enter_c1(struct cpu
 	if (acpi_idle_suspend) {
 		local_irq_enable();
 		cpu_relax();
-		return 0;
+		return;
 	}
 
 	lapic_timer_state_broadcast(pr, cx, 1);
-	kt1 = ktime_get_real();
 	acpi_idle_do_entry(cx);
-	kt2 = ktime_get_real();
-	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
 
 	local_irq_enable();
 	cx->usage++;
 	lapic_timer_state_broadcast(pr, cx, 0);
-
-	return idle_time;
 }
 
 /**
@@ -861,7 +854,7 @@ static int acpi_idle_enter_c1(struct cpu
  * @dev: the target CPU
  * @state: the state data
  */
-static int acpi_idle_enter_simple(struct cpuidle_device *dev,
+static void acpi_idle_enter_simple(struct cpuidle_device *dev,
 				  struct cpuidle_state *state)
 {
 	struct acpi_processor *pr;
@@ -873,10 +866,12 @@ static int acpi_idle_enter_simple(struct
 	pr = __get_cpu_var(processors);
 
 	if (unlikely(!pr))
-		return 0;
+		return;
 
-	if (acpi_idle_suspend)
-		return(acpi_idle_enter_c1(dev, state));
+	if (acpi_idle_suspend) {
+		acpi_idle_enter_c1(dev, state);
+		return;
+	}
 
 	local_irq_disable();
 	current_thread_info()->status &= ~TS_POLLING;
@@ -889,7 +884,7 @@ static int acpi_idle_enter_simple(struct
 	if (unlikely(need_resched())) {
 		current_thread_info()->status |= TS_POLLING;
 		local_irq_enable();
-		return 0;
+		return;
 	}
 
 	/*
@@ -920,7 +915,6 @@ static int acpi_idle_enter_simple(struct
 
 	lapic_timer_state_broadcast(pr, cx, 0);
 	cx->time += sleep_ticks;
-	return idle_time;
 }
 
 static int c3_cpu_count;
@@ -933,7 +927,7 @@ static DEFINE_SPINLOCK(c3_lock);
  *
  * If BM is detected, the deepest non-C3 idle state is entered instead.
  */
-static int acpi_idle_enter_bm(struct cpuidle_device *dev,
+static void acpi_idle_enter_bm(struct cpuidle_device *dev,
 			      struct cpuidle_state *state)
 {
 	struct acpi_processor *pr;
@@ -946,20 +940,23 @@ static int acpi_idle_enter_bm(struct cpu
 	pr = __get_cpu_var(processors);
 
 	if (unlikely(!pr))
-		return 0;
+		return;
 
-	if (acpi_idle_suspend)
-		return(acpi_idle_enter_c1(dev, state));
+	if (acpi_idle_suspend) {
+		acpi_idle_enter_c1(dev, state);
+		return;
+	}
 
 	if (acpi_idle_bm_check()) {
 		if (dev->safe_state) {
 			dev->last_state = dev->safe_state;
-			return dev->safe_state->enter(dev, dev->safe_state);
+			dev->safe_state->enter(dev, dev->safe_state);
+			return;
 		} else {
 			local_irq_disable();
 			acpi_safe_halt();
 			local_irq_enable();
-			return 0;
+			return;
 		}
 	}
 
@@ -974,7 +971,7 @@ static int acpi_idle_enter_bm(struct cpu
 	if (unlikely(need_resched())) {
 		current_thread_info()->status |= TS_POLLING;
 		local_irq_enable();
-		return 0;
+		return;
 	}
 
 	acpi_unlazy_tlb(smp_processor_id());
@@ -1032,7 +1029,6 @@ static int acpi_idle_enter_bm(struct cpu
 
 	lapic_timer_state_broadcast(pr, cx, 0);
 	cx->time += sleep_ticks;
-	return idle_time;
 }
 
 struct cpuidle_driver acpi_idle_driver = {
