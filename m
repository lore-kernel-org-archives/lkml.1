Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab0BIIad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 03:30:33 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:54422 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab0BIIab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 03:30:31 -0500
Date: Tue, 9 Feb 2010 14:00:23 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel@vger.kernel.org, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: [v11 PATCH 2/9]: cpuidle: cleanup drivers/cpuidle/cpuidle.c
Message-ID: <20100209083023.GC29988@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20100209082815.GA29988@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100209082815.GA29988@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2010-02-09 13:58:16]:

This patch cleans up drivers/cpuidle/cpuidle.c
Earlier cpuidle assumed pm_idle as the default idle loop. Break that
assumption and make it more generic. cpuidle_idle_call() which is the
main idle loop of cpuidle is to be called by architectures which have
registered to cpuidle.

Remove routines cpuidle_install/uninstall_idle_handler() and
cpuidle_kick_cpus() which are not needed anymore.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle.c  |   93 +++++++++++----------------------------------
 drivers/cpuidle/cpuidle.h  |    6 --
 drivers/cpuidle/driver.c   |    7 ---
 drivers/cpuidle/governor.c |   13 ++----
 drivers/cpuidle/sysfs.c    |   34 +++++++++-------
 include/linux/cpuidle.h    |    6 +-
 6 files changed, 56 insertions(+), 103 deletions(-)

Index: linux.trees.git/drivers/cpuidle/cpuidle.c
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/cpuidle.c
+++ linux.trees.git/drivers/cpuidle/cpuidle.c
@@ -24,10 +24,6 @@
 DEFINE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
 
 DEFINE_MUTEX(cpuidle_lock);
-LIST_HEAD(cpuidle_detected_devices);
-static void (*pm_idle_old)(void);
-
-static int enabled_devices;
 
 #if defined(CONFIG_ARCH_HAS_CPU_IDLE_WAIT)
 static void cpuidle_kick_cpus(void)
@@ -47,21 +43,20 @@ static int __cpuidle_register_device(str
  *
  * NOTE: no locks or semaphores should be used here
  */
-static void cpuidle_idle_call(void)
+void cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __get_cpu_var(cpuidle_devices);
 	struct cpuidle_state *target_state;
 	int next_state;
+	ktime_t	t1, t2;
+	s64 diff;
 
 	/* check if the device is ready */
 	if (!dev || !dev->enabled) {
-		if (pm_idle_old)
-			pm_idle_old();
-		else
 #if defined(CONFIG_ARCH_HAS_DEFAULT_IDLE)
-			default_idle();
+		default_idle();
 #else
-			local_irq_enable();
+		local_irq_enable();
 #endif
 		return;
 	}
@@ -75,7 +70,11 @@ static void cpuidle_idle_call(void)
 	hrtimer_peek_ahead_timers();
 #endif
 	/* ask the governor for the next state */
-	next_state = cpuidle_curr_governor->select(dev);
+	if (dev->state_count > 1)
+		next_state = cpuidle_curr_governor->select(dev);
+	else
+		next_state = 0;
+
 	if (need_resched()) {
 		local_irq_enable();
 		return;
@@ -85,7 +84,18 @@ static void cpuidle_idle_call(void)
 
 	/* enter the state and update stats */
 	dev->last_state = target_state;
-	dev->last_residency = target_state->enter(dev, target_state);
+
+	t1 = ktime_get();
+
+	target_state->enter(dev, target_state);
+
+	t2 = ktime_get();
+	diff = ktime_to_us(ktime_sub(t2, t1));
+	if (diff > INT_MAX)
+		diff = INT_MAX;
+
+	dev->last_residency = (int) diff;
+
 	if (dev->last_state)
 		target_state = dev->last_state;
 
@@ -99,35 +109,12 @@ static void cpuidle_idle_call(void)
 }
 
 /**
- * cpuidle_install_idle_handler - installs the cpuidle idle loop handler
- */
-void cpuidle_install_idle_handler(void)
-{
-	if (enabled_devices && (pm_idle != cpuidle_idle_call)) {
-		/* Make sure all changes finished before we switch to new idle */
-		smp_wmb();
-		pm_idle = cpuidle_idle_call;
-	}
-}
-
-/**
- * cpuidle_uninstall_idle_handler - uninstalls the cpuidle idle loop handler
- */
-void cpuidle_uninstall_idle_handler(void)
-{
-	if (enabled_devices && pm_idle_old && (pm_idle != pm_idle_old)) {
-		pm_idle = pm_idle_old;
-		cpuidle_kick_cpus();
-	}
-}
-
-/**
  * cpuidle_pause_and_lock - temporarily disables CPUIDLE
  */
 void cpuidle_pause_and_lock(void)
 {
 	mutex_lock(&cpuidle_lock);
-	cpuidle_uninstall_idle_handler();
+	cpuidle_kick_cpus();
 }
 
 EXPORT_SYMBOL_GPL(cpuidle_pause_and_lock);
@@ -137,7 +124,6 @@ EXPORT_SYMBOL_GPL(cpuidle_pause_and_lock
  */
 void cpuidle_resume_and_unlock(void)
 {
-	cpuidle_install_idle_handler();
 	mutex_unlock(&cpuidle_lock);
 }
 
@@ -185,7 +171,6 @@ int cpuidle_enable_device(struct cpuidle
 
 	dev->enabled = 1;
 
-	enabled_devices++;
 	return 0;
 
 fail_sysfs:
@@ -216,30 +201,16 @@ void cpuidle_disable_device(struct cpuid
 		cpuidle_curr_governor->disable(dev);
 
 	cpuidle_remove_state_sysfs(dev);
-	enabled_devices--;
 }
 
 EXPORT_SYMBOL_GPL(cpuidle_disable_device);
 
 #ifdef CONFIG_ARCH_HAS_CPU_RELAX
-static int poll_idle(struct cpuidle_device *dev, struct cpuidle_state *st)
+static void poll_idle(struct cpuidle_device *dev, struct cpuidle_state *st)
 {
-	ktime_t	t1, t2;
-	s64 diff;
-	int ret;
-
-	t1 = ktime_get();
 	local_irq_enable();
 	while (!need_resched())
 		cpu_relax();
-
-	t2 = ktime_get();
-	diff = ktime_to_us(ktime_sub(t2, t1));
-	if (diff > INT_MAX)
-		diff = INT_MAX;
-
-	ret = (int) diff;
-	return ret;
 }
 
 static void poll_idle_init(struct cpuidle_device *dev)
@@ -269,7 +240,6 @@ static void poll_idle_init(struct cpuidl
  */
 static int __cpuidle_register_device(struct cpuidle_device *dev)
 {
-	int ret;
 	struct sys_device *sys_dev = get_cpu_sysdev((unsigned long)dev->cpu);
 
 	if (!sys_dev)
@@ -277,16 +247,9 @@ static int __cpuidle_register_device(str
 	if (!try_module_get(cpuidle_curr_driver->owner))
 		return -EINVAL;
 
-	init_completion(&dev->kobj_unregister);
-
 	poll_idle_init(dev);
 
 	per_cpu(cpuidle_devices, dev->cpu) = dev;
-	list_add(&dev->device_list, &cpuidle_detected_devices);
-	if ((ret = cpuidle_add_sysfs(sys_dev))) {
-		module_put(cpuidle_curr_driver->owner);
-		return ret;
-	}
 
 	dev->registered = 1;
 	return 0;
@@ -308,7 +271,6 @@ int cpuidle_register_device(struct cpuid
 	}
 
 	cpuidle_enable_device(dev);
-	cpuidle_install_idle_handler();
 
 	mutex_unlock(&cpuidle_lock);
 
@@ -324,8 +286,6 @@ EXPORT_SYMBOL_GPL(cpuidle_register_devic
  */
 void cpuidle_unregister_device(struct cpuidle_device *dev)
 {
-	struct sys_device *sys_dev = get_cpu_sysdev((unsigned long)dev->cpu);
-
 	if (dev->registered == 0)
 		return;
 
@@ -333,9 +293,6 @@ void cpuidle_unregister_device(struct cp
 
 	cpuidle_disable_device(dev);
 
-	cpuidle_remove_sysfs(sys_dev);
-	list_del(&dev->device_list);
-	wait_for_completion(&dev->kobj_unregister);
 	per_cpu(cpuidle_devices, dev->cpu) = NULL;
 
 	cpuidle_resume_and_unlock();
@@ -387,8 +344,6 @@ static int __init cpuidle_init(void)
 {
 	int ret;
 
-	pm_idle_old = pm_idle;
-
 	ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
 	if (ret)
 		return ret;
Index: linux.trees.git/drivers/cpuidle/governor.c
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/governor.c
+++ linux.trees.git/drivers/cpuidle/governor.c
@@ -43,16 +43,14 @@ static struct cpuidle_governor * __cpuid
  */
 int cpuidle_switch_governor(struct cpuidle_governor *gov)
 {
-	struct cpuidle_device *dev;
+	int cpu;
 
 	if (gov == cpuidle_curr_governor)
 		return 0;
 
-	cpuidle_uninstall_idle_handler();
-
 	if (cpuidle_curr_governor) {
-		list_for_each_entry(dev, &cpuidle_detected_devices, device_list)
-			cpuidle_disable_device(dev);
+		for_each_online_cpu(cpu)
+			cpuidle_disable_device(per_cpu(cpuidle_devices, cpu));
 		module_put(cpuidle_curr_governor->owner);
 	}
 
@@ -61,9 +59,8 @@ int cpuidle_switch_governor(struct cpuid
 	if (gov) {
 		if (!try_module_get(cpuidle_curr_governor->owner))
 			return -EINVAL;
-		list_for_each_entry(dev, &cpuidle_detected_devices, device_list)
-			cpuidle_enable_device(dev);
-		cpuidle_install_idle_handler();
+		for_each_online_cpu(cpu)
+			cpuidle_enable_device(per_cpu(cpuidle_devices, cpu));
 		printk(KERN_INFO "cpuidle: using governor %s\n", gov->name);
 	}
 
Index: linux.trees.git/include/linux/cpuidle.h
===================================================================
--- linux.trees.git.orig/include/linux/cpuidle.h
+++ linux.trees.git/include/linux/cpuidle.h
@@ -41,7 +41,7 @@ struct cpuidle_state {
 	unsigned long long	usage;
 	unsigned long long	time; /* in US */
 
-	int (*enter)	(struct cpuidle_device *dev,
+	void (*enter)	(struct cpuidle_device *dev,
 			 struct cpuidle_state *state);
 };
 
@@ -92,7 +92,6 @@ struct cpuidle_device {
 	struct cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
 	struct cpuidle_state	*last_state;
 
-	struct list_head 	device_list;
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
 	void			*governor_data;
@@ -112,6 +111,9 @@ static inline int cpuidle_get_last_resid
 	return dev->last_residency;
 }
 
+extern struct cpuidle_driver *cpuidle_curr_driver;
+extern void cpuidle_idle_call(void);
+
 
 /****************************
  * CPUIDLE DRIVER INTERFACE *
Index: linux.trees.git/drivers/cpuidle/cpuidle.h
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/cpuidle.h
+++ linux.trees.git/drivers/cpuidle/cpuidle.h
@@ -9,9 +9,7 @@
 
 /* For internal use only */
 extern struct cpuidle_governor *cpuidle_curr_governor;
-extern struct cpuidle_driver *cpuidle_curr_driver;
 extern struct list_head cpuidle_governors;
-extern struct list_head cpuidle_detected_devices;
 extern struct mutex cpuidle_lock;
 extern spinlock_t cpuidle_driver_lock;
 
@@ -27,7 +25,7 @@ extern int cpuidle_add_class_sysfs(struc
 extern void cpuidle_remove_class_sysfs(struct sysdev_class *cls);
 extern int cpuidle_add_state_sysfs(struct cpuidle_device *device);
 extern void cpuidle_remove_state_sysfs(struct cpuidle_device *device);
-extern int cpuidle_add_sysfs(struct sys_device *sysdev);
-extern void cpuidle_remove_sysfs(struct sys_device *sysdev);
+extern int cpuidle_add_sysfs(struct cpuidle_device *device);
+extern void cpuidle_remove_sysfs(struct cpuidle_device *device);
 
 #endif /* __DRIVER_CPUIDLE_H */
Index: linux.trees.git/drivers/cpuidle/sysfs.c
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/sysfs.c
+++ linux.trees.git/drivers/cpuidle/sysfs.c
@@ -311,6 +311,13 @@ int cpuidle_add_state_sysfs(struct cpuid
 	int i, ret = -ENOMEM;
 	struct cpuidle_state_kobj *kobj;
 
+	init_completion(&device->kobj_unregister);
+
+	ret = cpuidle_add_sysfs(device);
+	if (ret) {
+		module_put(cpuidle_curr_driver->owner);
+		return ret;
+	}
 	/* state statistics */
 	for (i = 0; i < device->state_count; i++) {
 		kobj = kzalloc(sizeof(struct cpuidle_state_kobj), GFP_KERNEL);
@@ -347,35 +354,32 @@ void cpuidle_remove_state_sysfs(struct c
 
 	for (i = 0; i < device->state_count; i++)
 		cpuidle_free_state_kobj(device, i);
+
+	cpuidle_remove_sysfs(device);
 }
 
 /**
  * cpuidle_add_sysfs - creates a sysfs instance for the target device
- * @sysdev: the target device
+ * @device: the target device
  */
-int cpuidle_add_sysfs(struct sys_device *sysdev)
+int cpuidle_add_sysfs(struct cpuidle_device *device)
 {
-	int cpu = sysdev->id;
-	struct cpuidle_device *dev;
 	int error;
+	struct sys_device *sysdev = get_cpu_sysdev((unsigned long)device->cpu);
 
-	dev = per_cpu(cpuidle_devices, cpu);
-	error = kobject_init_and_add(&dev->kobj, &ktype_cpuidle, &sysdev->kobj,
-				     "cpuidle");
+	error = kobject_init_and_add(&device->kobj, &ktype_cpuidle,
+				&sysdev->kobj, "cpuidle");
 	if (!error)
-		kobject_uevent(&dev->kobj, KOBJ_ADD);
+		kobject_uevent(&device->kobj, KOBJ_ADD);
 	return error;
 }
 
 /**
  * cpuidle_remove_sysfs - deletes a sysfs instance on the target device
- * @sysdev: the target device
+ * @device: the target device
  */
-void cpuidle_remove_sysfs(struct sys_device *sysdev)
+void cpuidle_remove_sysfs(struct cpuidle_device *device)
 {
-	int cpu = sysdev->id;
-	struct cpuidle_device *dev;
-
-	dev = per_cpu(cpuidle_devices, cpu);
-	kobject_put(&dev->kobj);
+	kobject_put(&device->kobj);
+	wait_for_completion(&device->kobj_unregister);
 }
Index: linux.trees.git/drivers/cpuidle/driver.c
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/driver.c
+++ linux.trees.git/drivers/cpuidle/driver.c
@@ -27,11 +27,8 @@ int cpuidle_register_driver(struct cpuid
 		return -EINVAL;
 
 	spin_lock(&cpuidle_driver_lock);
-	if (cpuidle_curr_driver) {
-		spin_unlock(&cpuidle_driver_lock);
-		return -EBUSY;
-	}
-	cpuidle_curr_driver = drv;
+	if (!cpuidle_curr_driver)
+		cpuidle_curr_driver = drv;
 	spin_unlock(&cpuidle_driver_lock);
 
 	return 0;
