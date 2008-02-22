Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbYBVVMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbYBVVMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758516AbYBVVJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:09:40 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47253 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbYBVVJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:09:33 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5236"; a="773381"
From: Max Krasnyansky <maxk@qualcomm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pj@sgi.com,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH sched-devel 1/7] cpuisol: Make cpu isolation configrable and export isolated map
Date: Fri, 22 Feb 2008 13:09:12 -0800
Message-Id: <1203714558-20904-1-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simple patch introduces new config option for CPU isolation.
The reason I created the separate Kconfig file here is because more
options will be added by the following patches.

The patch also exports cpu_isolated_map, provides cpu_isolated()
accessor macro and provides access to the isolation bit via sysfs.
In other words cpu_isolated_map is exposed to the rest of the kernel
and the user-space in much the same way cpu_online_map is exposed today.

While at it I also moved cpu_*_map from kernel/sched.c into kernel/cpu.c
Those maps have very little to do with the scheduler these days and
therefor seem out of place in the scheduler code.

This patch does not change/affect any existing scheduler functionality.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
---
 arch/x86/Kconfig        |    1 +
 drivers/base/cpu.c      |   48 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cpumask.h |    3 ++
 kernel/Kconfig.cpuisol  |   15 ++++++++++++++
 kernel/Makefile         |    4 +-
 kernel/cpu.c            |   49 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched.c          |   36 ----------------------------------
 7 files changed, 118 insertions(+), 38 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3be2305..d228488 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -526,6 +526,7 @@ config SCHED_MC
 	  increased overhead in some places. If unsure say N here.
 
 source "kernel/Kconfig.preempt"
+source "kernel/Kconfig.cpuisol"
 
 config X86_UP_APIC
 	bool "Local APIC support on uniprocessors"
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 499b003..b6c5e0f 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -55,10 +55,58 @@ static ssize_t store_online(struct sys_device *dev, const char *buf,
 }
 static SYSDEV_ATTR(online, 0644, show_online, store_online);
 
+#ifdef CONFIG_CPUISOL
+/*
+ * This is under config hotplug because in order to 
+ * dynamically isolate a CPU it needs to be brought off-line first.
+ * In other words the sequence is
+ *   echo 0 > /sys/device/system/cpuN/online
+ *   echo 1 > /sys/device/system/cpuN/isolated
+ *   echo 1 > /sys/device/system/cpuN/online
+ */
+static ssize_t show_isol(struct sys_device *dev, char *buf)
+{
+	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
+
+	return sprintf(buf, "%u\n", !!cpu_isolated(cpu->sysdev.id));
+}
+
+static ssize_t store_isol(struct sys_device *dev, const char *buf,
+			    size_t count)
+{
+	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
+	ssize_t ret = 0;
+
+	if (cpu_online(cpu->sysdev.id))
+		return -EBUSY;
+
+	switch (buf[0]) {
+	case '0':
+		cpu_clear(cpu->sysdev.id, cpu_isolated_map);
+		break;
+	case '1':
+		cpu_set(cpu->sysdev.id, cpu_isolated_map);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (ret >= 0)
+		ret = count;
+	return ret;
+}
+static SYSDEV_ATTR(isolated, 0600, show_isol, store_isol);
+#endif /* CONFIG_CPUISOL */
+
 static void __devinit register_cpu_control(struct cpu *cpu)
 {
 	sysdev_create_file(&cpu->sysdev, &attr_online);
+
+#ifdef CONFIG_CPUISOL
+	sysdev_create_file(&cpu->sysdev, &attr_isolated);
+#endif
 }
+
 void unregister_cpu(struct cpu *cpu)
 {
 	int logical_cpu = cpu->sysdev.id;
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 7047f58..cde2964 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -380,6 +380,7 @@ static inline void __cpus_remap(cpumask_t *dstp, const cpumask_t *srcp,
 extern cpumask_t cpu_possible_map;
 extern cpumask_t cpu_online_map;
 extern cpumask_t cpu_present_map;
+extern cpumask_t cpu_isolated_map;
 
 #if NR_CPUS > 1
 #define num_online_cpus()	cpus_weight(cpu_online_map)
@@ -388,6 +389,7 @@ extern cpumask_t cpu_present_map;
 #define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
 #define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
 #define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
+#define cpu_isolated(cpu)	cpu_isset((cpu), cpu_isolated_map)
 #else
 #define num_online_cpus()	1
 #define num_possible_cpus()	1
@@ -395,6 +397,7 @@ extern cpumask_t cpu_present_map;
 #define cpu_online(cpu)		((cpu) == 0)
 #define cpu_possible(cpu)	((cpu) == 0)
 #define cpu_present(cpu)	((cpu) == 0)
+#define cpu_isolated(cpu)	(0)
 #endif
 
 #define cpu_is_offline(cpu)	unlikely(!cpu_online(cpu))
diff --git a/kernel/Kconfig.cpuisol b/kernel/Kconfig.cpuisol
new file mode 100644
index 0000000..e606477
--- /dev/null
+++ b/kernel/Kconfig.cpuisol
@@ -0,0 +1,15 @@
+config CPUISOL
+	depends on SMP
+	bool "CPU isolation"
+	help
+	  This option enables support for CPU isolation.
+	  If enabled the kernel will try to avoid kernel activity on the isolated CPUs.
+	  By default user-space threads are not scheduled on the isolated CPUs unless 
+	  they explicitly request it (via sched_ and pthread_ affinity calls). Isolated
+	  CPUs are not subject to the scheduler load-balancing algorithms.
+	  
+	  CPUs can be marked as isolated using 'isolcpus=' command line option or by 
+	  writing '1' into /sys/devices/system/cpu/cpuN/isolated.
+	  
+	  This feature is useful for hard realtime and high performance applications.
+	  If unsure say 'N'.
diff --git a/kernel/Makefile b/kernel/Makefile
index 6c584c5..bb8da0a 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
-	    exit.o itimer.o time.o softirq.o resource.o \
+	    cpu.o exit.o itimer.o time.o softirq.o resource.o \
 	    sysctl.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
@@ -27,7 +27,7 @@ obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
-obj-$(CONFIG_SMP) += cpu.o spinlock.o
+obj-$(CONFIG_SMP) += spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 2eff3f6..a0ac386 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -15,6 +15,36 @@
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
 
+/*
+ * Represents all cpu's present in the system
+ * In systems capable of hotplug, this map could dynamically grow
+ * as new cpu's are detected in the system via any platform specific
+ * method, such as ACPI for e.g.
+ */
+
+cpumask_t cpu_present_map __read_mostly;
+EXPORT_SYMBOL(cpu_present_map);
+
+/*
+ * Represents isolated cpu's.
+ * In general any kernel activity should be avoided as much as possible
+ * on these cpu's. Isolated cpu's are not load balanced by the scheduler. 
+ */
+cpumask_t cpu_isolated_map __read_mostly = CPU_MASK_NONE;
+EXPORT_SYMBOL(cpu_isolated_map);
+
+#ifndef CONFIG_SMP
+
+cpumask_t cpu_online_map __read_mostly = CPU_MASK_ALL;
+EXPORT_SYMBOL(cpu_online_map);
+
+cpumask_t cpu_possible_map __read_mostly = CPU_MASK_ALL;
+EXPORT_SYMBOL(cpu_possible_map);
+
+#endif
+
+#ifdef CONFIG_SMP
+
 /* Serializes the updates to cpu_online_map, cpu_present_map */
 static DEFINE_MUTEX(cpu_add_remove_lock);
 
@@ -413,3 +443,22 @@ out:
 	cpu_maps_update_done();
 }
 #endif /* CONFIG_PM_SLEEP_SMP */
+
+#ifdef CONFIG_CPUISOL
+/* Setup the mask of isolated cpus */
+static int __init isolated_cpu_setup(char *str)
+{
+	int ints[NR_CPUS], i;
+
+	str = get_options(str, ARRAY_SIZE(ints), ints);
+	cpus_clear(cpu_isolated_map);
+	for (i = 1; i <= ints[0]; i++)
+		if (ints[i] < NR_CPUS)
+			cpu_set(ints[i], cpu_isolated_map);
+	return 1;
+}
+
+__setup("isolcpus=", isolated_cpu_setup);
+#endif
+
+#endif /* CONFIG_SMP */
diff --git a/kernel/sched.c b/kernel/sched.c
index f28f19e..10a533e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4839,24 +4839,6 @@ asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 	return sched_setaffinity(pid, new_mask);
 }
 
-/*
- * Represents all cpu's present in the system
- * In systems capable of hotplug, this map could dynamically grow
- * as new cpu's are detected in the system via any platform specific
- * method, such as ACPI for e.g.
- */
-
-cpumask_t cpu_present_map __read_mostly;
-EXPORT_SYMBOL(cpu_present_map);
-
-#ifndef CONFIG_SMP
-cpumask_t cpu_online_map __read_mostly = CPU_MASK_ALL;
-EXPORT_SYMBOL(cpu_online_map);
-
-cpumask_t cpu_possible_map __read_mostly = CPU_MASK_ALL;
-EXPORT_SYMBOL(cpu_possible_map);
-#endif
-
 long sched_getaffinity(pid_t pid, cpumask_t *mask)
 {
 	struct task_struct *p;
@@ -6212,24 +6194,6 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	rcu_assign_pointer(rq->sd, sd);
 }
 
-/* cpus with isolated domains */
-static cpumask_t cpu_isolated_map = CPU_MASK_NONE;
-
-/* Setup the mask of cpus configured for isolated domains */
-static int __init isolated_cpu_setup(char *str)
-{
-	int ints[NR_CPUS], i;
-
-	str = get_options(str, ARRAY_SIZE(ints), ints);
-	cpus_clear(cpu_isolated_map);
-	for (i = 1; i <= ints[0]; i++)
-		if (ints[i] < NR_CPUS)
-			cpu_set(ints[i], cpu_isolated_map);
-	return 1;
-}
-
-__setup("isolcpus=", isolated_cpu_setup);
-
 /*
  * init_sched_build_groups takes the cpumask we wish to span, and a pointer
  * to a function which identifies what group(along with sched group) a CPU
-- 
1.5.4.1

