Return-Path: <linux-kernel-owner+w=401wt.eu-S1758884AbXFAGMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884AbXFAGMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 02:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbXFAGL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 02:11:59 -0400
Received: from il.qumranet.com ([82.166.9.18]:37221 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbXFAGL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 02:11:58 -0400
Message-ID: <465FB8AA.6050504@qumranet.com>
Date: Fri, 01 Jun 2007 09:11:54 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [GIT PULL][RESEND] KVM cpu hotplug fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Fri, 01 Jun 2007 09:11:54 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the repository and branch

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git hotplug-linus

to receive a patchset which makes cpu hotplug (and therefore, suspend
and resume) more robust when running virtual machines.  The core issue
is that we need a notification about a cpu going away at a point in time
where it's still alive, but not running any user processes.  Such a
notification does not exist today, so the patchset adds it as a new
CPU_DYING notification.

The patchset is against 2.6.22-rc3.

Shortlog:

Avi Kivity (7):
      HOTPLUG: Add CPU_DYING notifier
      HOTPLUG: Adapt cpuset hotplug callback to CPU_DYING
      HOTPLUG: Adapt thermal throttle to CPU_DYING
      SMP: Implement on_cpu()
      KVM: Keep track of which cpus have virtualization enabled
      KVM: Tune hotplug/suspend IPIs
      KVM: Use CPU_DYING for disabling virtualization

 arch/i386/kernel/cpu/mcheck/therm_throt.c |    6 ++-
 drivers/kvm/kvm_main.c                    |   50
+++++++++++++++++++++--------
 include/linux/notifier.h                  |    3 ++
 include/linux/smp.h                       |   16 +++++++++
 kernel/cpu.c                              |   16 ++++++++-
 kernel/cpuset.c                           |    3 ++
 kernel/softirq.c                          |   24 ++++++++++++++
 7 files changed, 100 insertions(+), 18 deletions(-)

And the patch in all its glory:

diff --git a/arch/i386/kernel/cpu/mcheck/therm_throt.c
b/arch/i386/kernel/cpu/mcheck/therm_throt.c
index 7ba7c3a..1203dc5 100644
--- a/arch/i386/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/i386/kernel/cpu/mcheck/therm_throt.c
@@ -134,19 +134,21 @@ static __cpuinit int
thermal_throttle_cpu_callback(struct notifier_block *nfb,
 	int err;

 	sys_dev = get_cpu_sysdev(cpu);
-	mutex_lock(&therm_cpu_lock);
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
+		mutex_lock(&therm_cpu_lock);
 		err = thermal_throttle_add_dev(sys_dev);
+		mutex_unlock(&therm_cpu_lock);
 		WARN_ON(err);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
+		mutex_lock(&therm_cpu_lock);
 		thermal_throttle_remove_dev(sys_dev);
+		mutex_unlock(&therm_cpu_lock);
 		break;
 	}
-	mutex_unlock(&therm_cpu_lock);
 	return NOTIFY_OK;
 }

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index da985b3..1ad5ea1 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -41,6 +41,7 @@
 #include <linux/fs.h>
 #include <linux/mount.h>
 #include <linux/sched.h>
+#include <linux/cpumask.h>

 #include "x86_emulate.h"
 #include "segment_descriptor.h"
@@ -51,8 +52,12 @@ MODULE_LICENSE("GPL");
 static DEFINE_SPINLOCK(kvm_lock);
 static LIST_HEAD(vm_list);

+static cpumask_t cpus_hardware_enabled;
+
 struct kvm_arch_ops *kvm_arch_ops;

+static void hardware_disable(void *ignored);
+
 #define STAT_OFFSET(x) offsetof(struct kvm_vcpu, stat.x)

 static struct kvm_stats_debugfs_item {
@@ -2840,7 +2845,7 @@ static int kvm_reboot(struct notifier_block
*notifier, unsigned long val,
 		 * in vmx root mode.
 		 */
 		printk(KERN_INFO "kvm: exiting hardware virtualization\n");
-		on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
+		on_each_cpu(hardware_disable, NULL, 0, 1);
 	}
 	return NOTIFY_OK;
 }
@@ -2883,28 +2888,46 @@ static void decache_vcpus_on_cpu(int cpu)
 	spin_unlock(&kvm_lock);
 }

+static void hardware_enable(void *junk)
+{
+	int cpu = raw_smp_processor_id();
+
+	if (cpu_isset(cpu, cpus_hardware_enabled))
+		return;
+	cpu_set(cpu, cpus_hardware_enabled);
+	kvm_arch_ops->hardware_enable(NULL);
+}
+
+static void hardware_disable(void *junk)
+{
+	int cpu = raw_smp_processor_id();
+
+	if (!cpu_isset(cpu, cpus_hardware_enabled))
+		return;
+	cpu_clear(cpu, cpus_hardware_enabled);
+	decache_vcpus_on_cpu(cpu);
+	kvm_arch_ops->hardware_disable(NULL);
+}
+
 static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned
long val,
 			   void *v)
 {
 	int cpu = (long)v;

 	switch (val) {
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
 		       cpu);
-		decache_vcpus_on_cpu(cpu);
-		smp_call_function_single(cpu, kvm_arch_ops->hardware_disable,
-					 NULL, 0, 1);
+		on_cpu(cpu, hardware_disable, NULL, 0, 1);
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);
-		smp_call_function_single(cpu, kvm_arch_ops->hardware_enable,
-					 NULL, 0, 1);
+		on_cpu(cpu, hardware_enable, NULL, 0, 1);
 		break;
 	}
 	return NOTIFY_OK;
@@ -2961,14 +2984,13 @@ static void kvm_exit_debug(void)

 static int kvm_suspend(struct sys_device *dev, pm_message_t state)
 {
-	decache_vcpus_on_cpu(raw_smp_processor_id());
-	on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
+	hardware_disable(NULL);
 	return 0;
 }

 static int kvm_resume(struct sys_device *dev)
 {
-	on_each_cpu(kvm_arch_ops->hardware_enable, NULL, 0, 1);
+	hardware_enable(NULL);
 	return 0;
 }

@@ -3021,7 +3043,7 @@ int kvm_init_arch(struct kvm_arch_ops *ops, struct
module *module)
 	if (r < 0)
 		goto out;

-	on_each_cpu(kvm_arch_ops->hardware_enable, NULL, 0, 1);
+	on_each_cpu(hardware_enable, NULL, 0, 1);
 	r = register_cpu_notifier(&kvm_cpu_notifier);
 	if (r)
 		goto out_free_1;
@@ -3053,7 +3075,7 @@ out_free_2:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 out_free_1:
-	on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
+	on_each_cpu(hardware_disable, NULL, 0, 1);
 	kvm_arch_ops->hardware_unsetup();
 out:
 	kvm_arch_ops = NULL;
@@ -3067,7 +3089,7 @@ void kvm_exit_arch(void)
 	sysdev_class_unregister(&kvm_sysdev_class);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
-	on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
+	on_each_cpu(hardware_disable, NULL, 0, 1);
 	kvm_arch_ops->hardware_unsetup();
 	kvm_arch_ops = NULL;
 }
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index 9431101..576f2bb 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -196,6 +196,8 @@ extern int __srcu_notifier_call_chain(struct
srcu_notifier_head *nh,
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
 #define CPU_LOCK_ACQUIRE	0x0008 /* Acquire all hotcpu locks */
 #define CPU_LOCK_RELEASE	0x0009 /* Release all hotcpu locks */
+#define CPU_DYING		0x000A /* CPU (unsigned)v not running any task,
+				        * not handling interrupts, soon dead */

 /* Used for CPU hotplug events occuring while tasks are frozen due to a
suspend
  * operation in progress
@@ -208,6 +210,7 @@ extern int __srcu_notifier_call_chain(struct
srcu_notifier_head *nh,
 #define CPU_DOWN_PREPARE_FROZEN	(CPU_DOWN_PREPARE | CPU_TASKS_FROZEN)
 #define CPU_DOWN_FAILED_FROZEN	(CPU_DOWN_FAILED | CPU_TASKS_FROZEN)
 #define CPU_DEAD_FROZEN		(CPU_DEAD | CPU_TASKS_FROZEN)
+#define CPU_DYING_FROZEN	(CPU_DYING | CPU_TASKS_FROZEN)

 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 96ac21f..613edd2 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -7,6 +7,7 @@
  */

 #include <linux/errno.h>
+#include <asm/system.h>

 extern void cpu_idle(void);

@@ -61,6 +62,11 @@ int smp_call_function_single(int cpuid, void (*func)
(void *info), void *info,
  * Call a function on all processors
  */
 int on_each_cpu(void (*func) (void *info), void *info, int retry, int
wait);
+/*
+ * Call a function on one processor
+ */
+int on_cpu(int cpu, void (*func)(void *info), void *info,
+	       int retry, int wait);

 #define MSG_ALL_BUT_SELF	0x8000	/* Assume <32768 CPU's */
 #define MSG_ALL			0x8001
@@ -96,6 +102,16 @@ static inline int up_smp_call_function(void)
 		local_irq_enable();		\
 		0;				\
 	})
+
+static inline int on_cpu(int cpu, void (*func)(void *info), void *info,
+			     int retry, int wait)
+{
+	local_irq_disable();
+	func(info);
+	local_irq_enable();
+	return 0;
+}
+
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 208cf34..181ae70 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -103,11 +103,19 @@ static inline void check_for_tasks(int cpu)
 	write_unlock_irq(&tasklist_lock);
 }

+struct take_cpu_down_param {
+	unsigned long mod;
+	void *hcpu;
+};
+
 /* Take this CPU down. */
-static int take_cpu_down(void *unused)
+static int take_cpu_down(void *_param)
 {
+	struct take_cpu_down_param *param = _param;
 	int err;

+	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
+				param->hcpu);
 	/* Ensure this CPU doesn't handle any more interrupts. */
 	err = __cpu_disable();
 	if (err < 0)
@@ -127,6 +135,10 @@ static int _cpu_down(unsigned int cpu, int
tasks_frozen)
 	cpumask_t old_allowed, tmp;
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
+	struct take_cpu_down_param tcd_param = {
+		.mod = mod,
+		.hcpu = hcpu,
+	};

 	if (num_online_cpus() == 1)
 		return -EBUSY;
@@ -153,7 +165,7 @@ static int _cpu_down(unsigned int cpu, int tasks_frozen)
 	set_cpus_allowed(current, tmp);

 	mutex_lock(&cpu_bitmask_lock);
-	p = __stop_machine_run(take_cpu_down, NULL, cpu);
+	p = __stop_machine_run(take_cpu_down, &tcd_param, cpu);
 	mutex_unlock(&cpu_bitmask_lock);

 	if (IS_ERR(p) || cpu_online(cpu)) {
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index f57854b..584953a 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2138,6 +2138,9 @@ static void common_cpu_mem_hotplug_unplug(void)
 static int cpuset_handle_cpuhp(struct notifier_block *nb,
 				unsigned long phase, void *cpu)
 {
+	if (phase == CPU_DYING || phase == CPU_DYING_FROZEN)
+		return NOTIFY_DONE;
+
 	common_cpu_mem_hotplug_unplug();
 	return 0;
 }
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 0b9886a..11666f7 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -658,4 +658,28 @@ int on_each_cpu(void (*func) (void *info), void
*info, int retry, int wait)
 	return ret;
 }
 EXPORT_SYMBOL(on_each_cpu);
+
+/*
+ * Call a function on one processor, which might be the currently executing
+ * processor.
+ */
+int on_cpu(int cpu, void (*func) (void *info), void *info,
+	       int retry, int wait)
+{
+	int ret;
+	int this_cpu;
+
+	this_cpu = get_cpu();
+	if (this_cpu == cpu) {
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
+		ret = 0;
+	} else
+		ret = smp_call_function_single(cpu, func, info, retry, wait);
+	put_cpu();
+	return ret;
+}
+EXPORT_SYMBOL(on_cpu);
+
 #endif

-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
_______________________________________________
kvm-devel mailing list
kvm-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/kvm-devel
