Return-Path: <linux-kernel-owner+w=401wt.eu-S1760175AbYA1EfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbYA1EfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 23:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbYA1Edj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 23:33:39 -0500
Received: from warlock.qualcomm.com ([129.46.50.49]:41107 "EHLO
	warlock.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbYA1Edb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 23:33:31 -0500
X-Greylist: delayed 666 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 23:33:28 EST
From: maxk@qualcomm.com
To: linux-kernel@vger.kernel.org
Cc: Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH] [CPUISOL] Export CPU isolation bits
Date: Sun, 27 Jan 2008 20:09:39 -0800
Message-Id: <1201493382-29804-3-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201493382-29804-2-git-send-email-maxk@qualcomm.com>
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>
 <1201493382-29804-2-git-send-email-maxk@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Krasnyansky <maxk@qualcomm.com>

Here we're just exporting CPU isolation bitmap so that it can
be used outside the scheduler code.
Helper functions like cpu_isolated() are provided for easy access.
This is very similar to cpu_online() and friends.

The patch also exports 'isolated' bit via sysfs in very much the
same way 'online' bit is exposed today.

CPUs can be isolated either via command line isolcpu= option or
by doing something like this:
   echo 0 > /sys/devices/system/cpu/cpu1/online
   echo 1 > /sys/devices/system/cpu/cpu1/isolated
   echo 1 > /sys/devices/system/cpu/cpu1/online

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
---
 drivers/base/cpu.c      |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cpumask.h |    3 +++
 kernel/sched.c          |   12 ++++++++----
 3 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index c5885f5..f59c719 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -55,10 +55,57 @@ static ssize_t store_online(struct sys_device *dev, const char *buf,
 }
 static SYSDEV_ATTR(online, 0644, show_online, store_online);
 
+#ifdef CONFIG_CPUISOL
+/*
+ * This is under config hotplug is because in order to 
+ * dynamically isolate a CPU it needs to be brought down.
+ * In other words the sequence should be
+ *   echo 0 > /sys/device/system/cpuN/online
+ *   echo 1 > /sys/device/system/cpuN/isolated
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
index 85bd790..84d1561 100644
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
diff --git a/kernel/sched.c b/kernel/sched.c
index 524285e..2fc942e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4815,10 +4815,17 @@ asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
  * as new cpu's are detected in the system via any platform specific
  * method, such as ACPI for e.g.
  */
-
 cpumask_t cpu_present_map __read_mostly;
 EXPORT_SYMBOL(cpu_present_map);
 
+/*
+ * Represents isolated cpu's.
+ * These cpu's have isolated scheduling domains. In general any 
+ * kernel activity should be avoided as much as possible on them.
+ */
+cpumask_t cpu_isolated_map __read_mostly = CPU_MASK_NONE;
+EXPORT_SYMBOL(cpu_isolated_map);
+
 #ifndef CONFIG_SMP
 cpumask_t cpu_online_map __read_mostly = CPU_MASK_ALL;
 EXPORT_SYMBOL(cpu_online_map);
@@ -6186,9 +6193,6 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	rcu_assign_pointer(rq->sd, sd);
 }
 
-/* cpus with isolated domains */
-static cpumask_t cpu_isolated_map = CPU_MASK_NONE;
-
 /* Setup the mask of cpus configured for isolated domains */
 static int __init isolated_cpu_setup(char *str)
 {
-- 
1.5.3.7

