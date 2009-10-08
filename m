Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbZJHJwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbZJHJwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 05:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757195AbZJHJwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 05:52:12 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:51876 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104AbZJHJwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 05:52:09 -0400
Date: Thu, 8 Oct 2009 15:21:27 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [v8 PATCH 3/8]: x86: refactor x86 idle power management code and
	remove all instances of pm_idle.
Message-ID: <20091008095127.GD20595@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091008094828.GA20595@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091008094828.GA20595@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-10-08 15:18:28]:

This patch cleans up x86 of all instances of pm_idle.

pm_idle which was earlier called from cpu_idle() idle loop
is replaced by cpuidle_idle_call.

x86 also registers to cpuidle when the idle routine is selected,
by populating the cpuidle_device data structure for each cpu.

This is replicated for apm module and for xen, which also used pm_idle.


Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/x86/kernel/apm_32.c      |   55 +++++++++++++++++++++++-
 arch/x86/kernel/process.c     |   93 ++++++++++++++++++++++++++----------------
 arch/x86/kernel/process_32.c  |    3 -
 arch/x86/kernel/process_64.c  |    3 -
 arch/x86/xen/setup.c          |   40 +++++++++++++++++-
 drivers/acpi/processor_core.c |    9 ++--
 drivers/cpuidle/cpuidle.c     |   16 ++++---
 include/linux/cpuidle.h       |    1 
 8 files changed, 172 insertions(+), 48 deletions(-)

Index: linux.trees.git/arch/x86/kernel/process.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/process.c
+++ linux.trees.git/arch/x86/kernel/process.c
@@ -9,6 +9,7 @@
 #include <linux/pm.h>
 #include <linux/clockchips.h>
 #include <linux/random.h>
+#include <linux/cpuidle.h>
 #include <trace/events/power.h>
 #include <asm/system.h>
 #include <asm/apic.h>
@@ -244,12 +245,6 @@ int sys_vfork(struct pt_regs *regs)
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
@@ -329,17 +324,15 @@ static void do_nothing(void *unused)
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
@@ -387,20 +380,6 @@ static void mwait_idle(void)
 }
 
 /*
- * On SMP it's slightly faster (but much more power-consuming!)
- * to poll the ->work.need_resched flag instead of waiting for the
- * cross-CPU IPI to arrive. Use this option with caution.
- */
-static void poll_idle(void)
-{
-	trace_power_start(POWER_CSTATE, 0);
-	local_irq_enable();
-	while (!need_resched())
-		cpu_relax();
-	trace_power_end(0);
-}
-
-/*
  * mwait selection logic:
  *
  * It depends on the CPU. For AMD CPUs that support MWAIT this is
@@ -518,15 +497,59 @@ static void c1e_idle(void)
 		default_idle();
 }
 
+static void (*local_idle)(void);
+DEFINE_PER_CPU(struct cpuidle_device, idle_devices);
+
+struct cpuidle_driver cpuidle_default_driver = {
+	.name =         "cpuidle_default",
+};
+
+static int local_idle_loop(struct cpuidle_device *dev, struct cpuidle_state *st)
+{
+	ktime_t t1, t2;
+	s64 diff;
+	int ret;
+
+	t1 = ktime_get();
+	local_idle();
+	t2 = ktime_get();
+
+	diff = ktime_to_us(ktime_sub(t2, t1));
+	if (diff > INT_MAX)
+		diff = INT_MAX;
+	ret = (int) diff;
+
+	return ret;
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
@@ -534,18 +557,20 @@ void __cpuinit select_idle_routine(const
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
 
@@ -556,7 +581,7 @@ static int __init idle_setup(char *str)
 
 	if (!strcmp(str, "poll")) {
 		printk("using polling idle threads.\n");
-		pm_idle = poll_idle;
+		local_idle = poll_idle;
 	} else if (!strcmp(str, "mwait"))
 		force_mwait = 1;
 	else if (!strcmp(str, "halt")) {
@@ -567,7 +592,7 @@ static int __init idle_setup(char *str)
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
@@ -113,7 +114,7 @@ void cpu_idle(void)
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
@@ -142,7 +143,7 @@ void cpu_idle(void)
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
@@ -2257,6 +2257,56 @@ static struct dmi_system_id __initdata a
 	{ }
 };
 
+DEFINE_PER_CPU(struct cpuidle_device, apm_idle_devices);
+
+struct cpuidle_driver cpuidle_apm_driver = {
+	.name =         "cpuidle_apm",
+};
+
+static int apm_idle_loop(struct cpuidle_device *dev, struct cpuidle_state *st)
+{
+	ktime_t t1, t2;
+	s64 diff;
+	int ret;
+
+	t1 = ktime_get();
+	apm_cpu_idle();
+	t2 = ktime_get();
+
+	diff = ktime_to_us(ktime_sub(t2, t1));
+	if (diff > INT_MAX)
+		diff = INT_MAX;
+	ret = (int) diff;
+
+	return ret;
+}
+
+void __cpuinit setup_cpuidle_apm(void)
+{
+	struct cpuidle_device *dev;
+
+	if (!cpuidle_curr_driver)
+		cpuidle_register_driver(&cpuidle_apm_driver);
+
+	dev = &per_cpu(apm_idle_devices, smp_processor_id());
+	dev->cpu = smp_processor_id();
+	dev->states[0].enter = apm_idle_loop;
+	dev->state_count = 1;
+	cpuidle_register_device(dev);
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
@@ -2394,8 +2444,7 @@ static int __init apm_init(void)
 	if (HZ != 100)
 		idle_period = (idle_period * HZ) / 100;
 	if (idle_threshold < 100) {
-		original_pm_idle = pm_idle;
-		pm_idle  = apm_cpu_idle;
+		setup_cpuidle_apm();
 		set_pm_idle = 1;
 	}
 
@@ -2407,7 +2456,7 @@ static void __exit apm_exit(void)
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
@@ -151,6 +152,43 @@ void __cpuinit xen_enable_syscall(void)
 #endif /* CONFIG_X86_64 */
 }
 
+DEFINE_PER_CPU(struct cpuidle_device, xen_idle_devices);
+struct cpuidle_driver cpuidle_xen_driver = {
+	.name =         "cpuidle_xen",
+};
+
+static int xen_idle_loop(struct cpuidle_device *dev, struct cpuidle_state *st)
+{
+	ktime_t t1, t2;
+	s64 diff;
+	int ret;
+
+	t1 = ktime_get();
+	xen_idle();
+	t2 = ktime_get();
+
+	diff = ktime_to_us(ktime_sub(t2, t1));
+	if (diff > INT_MAX)
+		diff = INT_MAX;
+	ret = (int) diff;
+
+	return ret;
+}
+
+void __cpuinit setup_cpuidle_xen(void)
+{
+	struct cpuidle_device *dev;
+
+	if (!cpuidle_curr_driver)
+		cpuidle_register_driver(&cpuidle_xen_driver);
+
+	dev = &per_cpu(xen_idle_devices, smp_processor_id());
+	dev->cpu = smp_processor_id();
+	dev->states[0].enter = xen_idle_loop;
+	dev->state_count = 1;
+	cpuidle_register_device(dev);
+}
+
 void __init xen_arch_setup(void)
 {
 	struct physdev_set_iopl set_iopl;
@@ -186,7 +224,7 @@ void __init xen_arch_setup(void)
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
Index: linux.trees.git/drivers/cpuidle/cpuidle.c
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/cpuidle.c
+++ linux.trees.git/drivers/cpuidle/cpuidle.c
@@ -224,16 +224,22 @@ void cpuidle_disable_device(struct cpuid
 EXPORT_SYMBOL_GPL(cpuidle_disable_device);
 
 #ifdef CONFIG_ARCH_HAS_CPU_RELAX
-static int poll_idle(struct cpuidle_device *dev, struct cpuidle_state *st)
+void poll_idle(void)
+{
+	local_irq_enable();
+	while (!need_resched())
+		cpu_relax();
+}
+
+static int poll_idle_loop(struct cpuidle_device *dev, struct cpuidle_state *st)
 {
 	ktime_t	t1, t2;
 	s64 diff;
 	int ret;
 
 	t1 = ktime_get();
-	local_irq_enable();
-	while (!need_resched())
-		cpu_relax();
+
+	poll_idle();
 
 	t2 = ktime_get();
 	diff = ktime_to_us(ktime_sub(t2, t1));
@@ -256,7 +262,7 @@ static void poll_idle_init(struct cpuidl
 	state->target_residency = 0;
 	state->power_usage = -1;
 	state->flags = CPUIDLE_FLAG_POLL;
-	state->enter = poll_idle;
+	state->enter = poll_idle_loop;
 }
 #else
 static void poll_idle_init(struct cpuidle_device *dev) {}
Index: linux.trees.git/include/linux/cpuidle.h
===================================================================
--- linux.trees.git.orig/include/linux/cpuidle.h
+++ linux.trees.git/include/linux/cpuidle.h
@@ -187,6 +187,7 @@ static inline void cpuidle_unregister_go
 
 #ifdef CONFIG_ARCH_HAS_CPU_RELAX
 #define CPUIDLE_DRIVER_STATE_START	1
+extern void poll_idle(void);
 #else
 #define CPUIDLE_DRIVER_STATE_START	0
 #endif
