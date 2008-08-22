Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbYHVUHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbYHVUHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbYHVUHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:07:24 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:40727 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbYHVUHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:07:22 -0400
X-Greylist: delayed 2084 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Aug 2008 16:07:22 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <48AF143E.9080502@cam.ac.uk>
Date: Fri, 22 Aug 2008 20:32:14 +0100
From: Alex Nixon <an307@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Ingo Molnar <mingo@elte.hu>, Alex Nixon <alex.nixon@citrix.com>
Subject: [PATCH 5/5] Xen:  Implement CPU hotplugging
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note the changes from 2.6.18-xen CPU hotplugging:

A vcpu_down request from the remote admin via Xenbus both hotunplugs the CPU, and disables it by removing it from the cpu_present map, and removing its entry in /sys

A vcpu_up request from the remote admin only re-enables the CPU, and does not immediately bring the CPU up.  A udev event is emitted, which can be caught by the user if he wishes to automatically re-up CPUs when available, or implement a more complex policy.

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/xen/smp.c        |   60 ++++++++++++++++++++++++------
 arch/x86/xen/spinlock.c   |    5 ++
 arch/x86/xen/time.c       |    8 ++++
 arch/x86/xen/xen-ops.h    |    6 +++
 drivers/xen/Makefile      |    2 +-
 drivers/xen/cpu_hotplug.c |   90 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/xen/events.c      |    4 ++
 7 files changed, 162 insertions(+), 13 deletions(-)
 create mode 100644 drivers/xen/cpu_hotplug.c

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index baca7f2..be5cbb2 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -11,8 +11,6 @@
  * useful topology information for the kernel to make use of.  As a
  * result, all CPUs are treated as if they're single-core and
  * single-threaded.
- *
- * This does not handle HOTPLUG_CPU yet.
  */
 #include <linux/sched.h>
 #include <linux/err.h>
@@ -61,11 +59,12 @@ static irqreturn_t xen_reschedule_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static __cpuinit void cpu_bringup_and_idle(void)
+static __cpuinit void cpu_bringup(void)
 {
 	int cpu = smp_processor_id();
 
 	cpu_init();
+	touch_softlockup_watchdog();
 	preempt_disable();
 
 	xen_enable_sysenter();
@@ -86,6 +85,11 @@ static __cpuinit void cpu_bringup_and_idle(void)
 	local_irq_enable();
 
 	wmb();			/* make sure everything is out */
+}
+
+static __cpuinit void cpu_bringup_and_idle(void)
+{
+	cpu_bringup();
 	cpu_idle();
 }
 
@@ -209,8 +213,6 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 
 		cpu_set(cpu, cpu_present_map);
 	}
-
-	//init_xenbus_allowed_cpumask();
 }
 
 static __cpuinit int
@@ -278,12 +280,6 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
 	struct task_struct *idle = idle_task(cpu);
 	int rc;
 
-#if 0
-	rc = cpu_up_check(cpu);
-	if (rc)
-		return rc;
-#endif
-
 #ifdef CONFIG_X86_64
 	/* Allocate node local memory for AP pdas */
 	WARN_ON(cpu == 0);
@@ -336,6 +332,42 @@ static void xen_smp_cpus_done(unsigned int max_cpus)
 {
 }
 
+int xen_cpu_disable(void)
+{
+	unsigned int cpu = smp_processor_id();
+	if (cpu == 0)
+		return -EBUSY;
+
+	cpu_disable_common();
+
+	load_cr3(swapper_pg_dir);
+	return 0;
+}
+
+void xen_cpu_die(unsigned int cpu)
+{
+	while (HYPERVISOR_vcpu_op(VCPUOP_is_up, cpu, NULL)) {
+		current->state = TASK_UNINTERRUPTIBLE;
+		schedule_timeout(HZ/10);
+	}
+	unbind_from_irqhandler(per_cpu(resched_irq, cpu), NULL);
+	unbind_from_irqhandler(per_cpu(callfunc_irq, cpu), NULL);
+	unbind_from_irqhandler(per_cpu(debug_irq, cpu), NULL);
+	unbind_from_irqhandler(per_cpu(callfuncsingle_irq, cpu), NULL);
+	xen_uninit_lock_cpu(cpu);
+	xen_teardown_timer(cpu);
+
+	if (num_online_cpus() == 1)
+		alternatives_smp_switch(0);
+}
+
+void xen_play_dead(void)
+{
+	play_dead_common();
+	HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
+	cpu_bringup();
+}
+
 static void stop_self(void *v)
 {
 	int cpu = smp_processor_id();
@@ -419,9 +451,13 @@ static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
 static const struct smp_ops xen_smp_ops __initdata = {
 	.smp_prepare_boot_cpu = xen_smp_prepare_boot_cpu,
 	.smp_prepare_cpus = xen_smp_prepare_cpus,
-	.cpu_up = xen_cpu_up,
 	.smp_cpus_done = xen_smp_cpus_done,
 
+	.cpu_up = xen_cpu_up,
+	.cpu_die = xen_cpu_die,
+	.cpu_disable = xen_cpu_disable,
+	.play_dead = xen_play_dead,
+
 	.smp_send_stop = xen_smp_send_stop,
 	.smp_send_reschedule = xen_smp_send_reschedule,
 
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index f8fea68..bb6bc72 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -357,6 +357,11 @@ void __cpuinit xen_init_lock_cpu(int cpu)
 	printk("cpu %d spinlock event irq %d\n", cpu, irq);
 }
 
+void xen_uninit_lock_cpu(int cpu)
+{
+	unbind_from_irqhandler(per_cpu(lock_kicker_irq, cpu), NULL);
+}
+
 void __init xen_init_spinlocks(void)
 {
 	pv_lock_ops.spin_is_locked = xen_spin_is_locked;
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 20182d9..004ba86 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -450,6 +450,14 @@ void xen_setup_timer(int cpu)
 	setup_runstate_info(cpu);
 }
 
+void xen_teardown_timer(int cpu)
+{
+	struct clock_event_device *evt;
+	BUG_ON(cpu == 0);
+	evt = &per_cpu(xen_clock_events, cpu);
+	unbind_from_irqhandler(evt->irq, NULL);
+}
+
 void xen_setup_cpu_clockevents(void)
 {
 	BUG_ON(preemptible());
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 1e8bfda..8dbd97f 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -34,6 +34,7 @@ void __init xen_build_dynamic_phys_to_machine(void);
 
 void xen_init_irq_ops(void);
 void xen_setup_timer(int cpu);
+void xen_teardown_timer(int cpu);
 cycle_t xen_clocksource_read(void);
 void xen_setup_cpu_clockevents(void);
 unsigned long xen_tsc_khz(void);
@@ -50,11 +51,16 @@ void xen_mark_init_mm_pinned(void);
 
 void __init xen_setup_vcpu_info_placement(void);
 
+void xen_play_dead(void);
+void xen_cpu_die(unsigned int cpu);
+int xen_cpu_disable(void);
+
 #ifdef CONFIG_SMP
 void xen_smp_init(void);
 
 void __init xen_init_spinlocks(void);
 __cpuinit void xen_init_lock_cpu(int cpu);
+void xen_uninit_lock_cpu(int cpu);
 
 extern cpumask_t xen_cpu_initialized_map;
 #else
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 363286c..f62d8df 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,4 +1,4 @@
-obj-y	+= grant-table.o features.o events.o manage.o
+obj-y	+= grant-table.o features.o events.o manage.o cpu_hotplug.o
 obj-y	+= xenbus/
 obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
 obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
new file mode 100644
index 0000000..1bc0035
--- /dev/null
+++ b/drivers/xen/cpu_hotplug.c
@@ -0,0 +1,90 @@
+#include <linux/notifier.h>
+
+#include <xen/xenbus.h>
+
+#include <asm-x86/xen/hypervisor.h>
+#include <asm/cpu.h>
+
+static void enable_hotplug_cpu(int cpu)
+{
+	if (!cpu_present(cpu))
+		arch_register_cpu(cpu);
+
+	cpu_set(cpu, cpu_present_map);
+}
+
+static void disable_hotplug_cpu(int cpu)
+{
+	if (cpu_present(cpu))
+		arch_unregister_cpu(cpu);
+
+	cpu_clear(cpu, cpu_present_map);
+}
+
+static void vcpu_hotplug(unsigned int cpu)
+{
+	int err;
+	char dir[32], state[32];
+
+	if (!cpu_possible(cpu))
+		return;
+
+	sprintf(dir, "cpu/%u", cpu);
+	err = xenbus_scanf(XBT_NIL, dir, "availability", "%s", state);
+	if (err != 1) {
+		printk(KERN_ERR "XENBUS: Unable to read cpu state\n");
+		return;
+	}
+
+	if (strcmp(state, "online") == 0) {
+		enable_hotplug_cpu(cpu);
+	} else if (strcmp(state, "offline") == 0) {
+		(void)cpu_down(cpu);
+		disable_hotplug_cpu(cpu);
+	} else {
+		printk(KERN_ERR "XENBUS: unknown state(%s) on CPU%d\n",
+		       state, cpu);
+	}
+}
+
+static void handle_vcpu_hotplug_event(struct xenbus_watch *watch,
+					const char **vec, unsigned int len)
+{
+	unsigned int cpu;
+	char *cpustr;
+	const char *node = vec[XS_WATCH_PATH];
+
+	cpustr = strstr(node, "cpu/");
+	if (cpustr != NULL) {
+		sscanf(cpustr, "cpu/%u", &cpu);
+		vcpu_hotplug(cpu);
+	}
+}
+
+static int setup_cpu_watcher(struct notifier_block *notifier,
+			      unsigned long event, void *data)
+{
+	static struct xenbus_watch cpu_watch = {
+		.node = "cpu",
+		.callback = handle_vcpu_hotplug_event};
+
+	(void)register_xenbus_watch(&cpu_watch);
+
+	return NOTIFY_DONE;
+}
+
+static int __init setup_vcpu_hotplug_event(void)
+{
+	static struct notifier_block xsn_cpu = {
+		.notifier_call = setup_cpu_watcher };
+
+	if (!is_running_on_xen())
+		return -ENODEV;
+
+	register_xenstore_notifier(&xsn_cpu);
+
+	return 0;
+}
+
+arch_initcall(setup_vcpu_hotplug_event);
+
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 792ca6e..e6d47e8 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -364,6 +364,10 @@ static void unbind_from_irq(unsigned int irq)
 			per_cpu(virq_to_irq, cpu_from_evtchn(evtchn))
 				[index_from_irq(irq)] = -1;
 			break;
+		case IRQT_IPI:
+			per_cpu(ipi_to_irq, cpu_from_evtchn(evtchn))
+				[index_from_irq(irq)] = -1;
+			break;
 		default:
 			break;
 		}
-- 1.5.4.3

