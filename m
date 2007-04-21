Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144AbXDUVQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbXDUVQF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 17:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbXDUVPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 17:15:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54302 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbXDUVPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 17:15:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 2/2] microcode: use suspend-related CPU hotplug notifications
Date: Sat, 21 Apr 2007 23:18:34 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>
References: <200704212316.39381.rjw@sisk.pl>
In-Reply-To: <200704212316.39381.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704212318.34838.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the microcode driver use the suspend-related CPU hotplug notifications
to handle the CPU hotplug events occuring during system-wide suspend and
resume transitions.  Remove the global variable suspend_cpu_hotplug previously
used for this purpose.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/i386/kernel/microcode.c |   62 ++++++++++++++++++++++++-------------------
 kernel/cpu.c                 |   10 ------
 2 files changed, 36 insertions(+), 36 deletions(-)

Index: linux-2.6.21-rc6-mm1/arch/i386/kernel/microcode.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/arch/i386/kernel/microcode.c	2007-04-21 10:16:36.000000000 +0200
+++ linux-2.6.21-rc6-mm1/arch/i386/kernel/microcode.c	2007-04-21 11:03:30.000000000 +0200
@@ -567,7 +567,7 @@ static int cpu_request_microcode(int cpu
 	return error;
 }
 
-static int apply_microcode_on_cpu(int cpu)
+static int apply_microcode_check_cpu(int cpu)
 {
 	struct cpuinfo_x86 *c = cpu_data + cpu;
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
@@ -575,8 +575,9 @@ static int apply_microcode_on_cpu(int cp
 	unsigned int val[2];
 	int err = 0;
 
+	/* Check if the microcode is available */
 	if (!uci->mc)
-		return -EINVAL;
+		return 0;
 
 	old = current->cpus_allowed;
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
@@ -614,7 +615,7 @@ static int apply_microcode_on_cpu(int cp
 	return err;
 }
 
-static void microcode_init_cpu(int cpu)
+static void microcode_init_cpu(int cpu, int resume)
 {
 	cpumask_t old;
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
@@ -624,8 +625,7 @@ static void microcode_init_cpu(int cpu)
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	mutex_lock(&microcode_mutex);
 	collect_cpu_info(cpu);
-	if (uci->valid && system_state == SYSTEM_RUNNING &&
-	    !suspend_cpu_hotplug)
+	if (uci->valid && system_state == SYSTEM_RUNNING && !resume)
 		cpu_request_microcode(cpu);
 	mutex_unlock(&microcode_mutex);
 	set_cpus_allowed(current, old);
@@ -702,7 +702,7 @@ static struct attribute_group mc_attr_gr
 	.name = "microcode",
 };
 
-static int mc_sysdev_add(struct sys_device *sys_dev)
+static int __mc_sysdev_add(struct sys_device *sys_dev, int resume)
 {
 	int err, cpu = sys_dev->id;
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
@@ -711,39 +711,31 @@ static int mc_sysdev_add(struct sys_devi
 		return 0;
 
 	pr_debug("Microcode:CPU %d added\n", cpu);
-	/* If suspend_cpu_hotplug is set, the system is resuming and we should
-	 * use the data from before the suspend.
-	 */
-	if (suspend_cpu_hotplug) {
-		err = apply_microcode_on_cpu(cpu);
-		if (err)
-			microcode_fini_cpu(cpu);
-	}
-	if (!uci->valid)
-		memset(uci, 0, sizeof(*uci));
+	memset(uci, 0, sizeof(*uci));
 
 	err = sysfs_create_group(&sys_dev->kobj, &mc_attr_group);
 	if (err)
 		return err;
 
-	if (!uci->valid)
-		microcode_init_cpu(cpu);
+	microcode_init_cpu(cpu, resume);
 
 	return 0;
 }
 
+static int mc_sysdev_add(struct sys_device *sys_dev)
+{
+	return __mc_sysdev_add(sys_dev, 0);
+}
+
 static int mc_sysdev_remove(struct sys_device *sys_dev)
 {
 	int cpu = sys_dev->id;
 
 	if (!cpu_online(cpu))
 		return 0;
+
 	pr_debug("Microcode:CPU %d removed\n", cpu);
-	/* If suspend_cpu_hotplug is set, the system is suspending and we should
-	 * keep the microcode in memory for the resume.
-	 */
-	if (!suspend_cpu_hotplug)
-		microcode_fini_cpu(cpu);
+	microcode_fini_cpu(cpu);
 	sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
 	return 0;
 }
@@ -774,16 +766,34 @@ mc_cpu_callback(struct notifier_block *n
 
 	sys_dev = get_cpu_sysdev(cpu);
 	switch (action) {
+	case CPU_UP_CANCELED_FROZEN:
+		/* The CPU refused to come up during a system resume */
+		microcode_fini_cpu(cpu);
+		break;
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
 		mc_sysdev_add(sys_dev);
 		break;
+	case CPU_ONLINE_FROZEN:
+		/* System-wide resume is in progress, try to apply microcode */
+		if (apply_microcode_check_cpu(cpu)) {
+			/* The application of microcode failed */
+			microcode_fini_cpu(cpu);
+			__mc_sysdev_add(sys_dev, 1);
+			break;
+		}
+	case CPU_DOWN_FAILED_FROZEN:
+		if (sysfs_create_group(&sys_dev->kobj, &mc_attr_group))
+			printk(KERN_ERR "Microcode: Failed to create the sysfs "
+				"group for CPU%d\n", cpu);
+		break;
 	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
 		mc_sysdev_remove(sys_dev);
 		break;
+	case CPU_DOWN_PREPARE_FROZEN:
+		/* Suspend is in progress, only remove the interface */
+		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+		break;
 	}
 	return NOTIFY_OK;
 }
Index: linux-2.6.21-rc6-mm1/kernel/cpu.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/cpu.c	2007-04-21 10:16:36.000000000 +0200
+++ linux-2.6.21-rc6-mm1/kernel/cpu.c	2007-04-21 10:16:50.000000000 +0200
@@ -266,12 +266,6 @@ int __cpuinit cpu_up(unsigned int cpu)
 }
 
 #ifdef CONFIG_SUSPEND_SMP
-/* Needed to prevent the microcode driver from requesting firmware in its CPU
- * hotplug notifier during the suspend/resume.
- */
-int suspend_cpu_hotplug;
-EXPORT_SYMBOL(suspend_cpu_hotplug);
-
 static cpumask_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
@@ -279,7 +273,6 @@ int disable_nonboot_cpus(void)
 	int cpu, first_cpu, error = 0;
 
 	mutex_lock(&cpu_add_remove_lock);
-	suspend_cpu_hotplug = 1;
 	first_cpu = first_cpu(cpu_online_map);
 	/* We take down all of the non-boot CPUs in one shot to avoid races
 	 * with the userspace trying to use the CPU hotplug at the same time
@@ -306,7 +299,6 @@ int disable_nonboot_cpus(void)
 	} else {
 		printk(KERN_ERR "Non-boot CPUs are not disabled\n");
 	}
-	suspend_cpu_hotplug = 0;
 	mutex_unlock(&cpu_add_remove_lock);
 	return error;
 }
@@ -321,7 +313,6 @@ void enable_nonboot_cpus(void)
 	if (cpus_empty(frozen_cpus))
 		goto out;
 
-	suspend_cpu_hotplug = 1;
 	printk("Enabling non-boot CPUs ...\n");
 	for_each_cpu_mask(cpu, frozen_cpus) {
 		error = _cpu_up(cpu, 1);
@@ -332,7 +323,6 @@ void enable_nonboot_cpus(void)
 		printk(KERN_WARNING "Error taking CPU%d up: %d\n", cpu, error);
 	}
 	cpus_clear(frozen_cpus);
-	suspend_cpu_hotplug = 0;
 out:
 	mutex_unlock(&cpu_add_remove_lock);
 }
