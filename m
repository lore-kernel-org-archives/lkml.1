Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZIVFfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZIVFfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbZIVFfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:35:13 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39626 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385AbZIVFfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:35:12 -0400
Date: Tue, 22 Sep 2009 11:05:02 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [v5 RFC PATCH 1/7]: cpuidle: cleanup drivers/cpuidle/cpuidle.c
Message-ID: <20090922053502.GB6417@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090922053314.GA6417@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090922053314.GA6417@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-09-22 11:03:14]:

This patch cleans up drivers/cpuidle/cpuidle.c
Earlier cpuidle assumed pm_idle as the default idle loop. Break that
assumption and make it more generic. cpuidle_idle_call() which is the
main idle loop of cpuidle is to be called by architectures which have
registered to cpuidle.

Remove routines cpuidle_install/uninstall_idle_handler() and
cpuidle_kick_cpus() which are not needed anymore.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle.c  |   59 ++++++---------------------------------------
 drivers/cpuidle/cpuidle.h  |    1 
 drivers/cpuidle/governor.c |    3 --
 include/linux/cpuidle.h    |    3 ++
 4 files changed, 11 insertions(+), 55 deletions(-)

Index: linux.trees.git/drivers/cpuidle/cpuidle.c
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/cpuidle.c
+++ linux.trees.git/drivers/cpuidle/cpuidle.c
@@ -24,20 +24,6 @@ DEFINE_PER_CPU(struct cpuidle_device *, 
 
 DEFINE_MUTEX(cpuidle_lock);
 LIST_HEAD(cpuidle_detected_devices);
-static void (*pm_idle_old)(void);
-
-static int enabled_devices;
-
-#if defined(CONFIG_ARCH_HAS_CPU_IDLE_WAIT)
-static void cpuidle_kick_cpus(void)
-{
-	cpu_idle_wait();
-}
-#elif defined(CONFIG_SMP)
-# error "Arch needs cpu_idle_wait() equivalent here"
-#else /* !CONFIG_ARCH_HAS_CPU_IDLE_WAIT && !CONFIG_SMP */
-static void cpuidle_kick_cpus(void) {}
-#endif
 
 static int __cpuidle_register_device(struct cpuidle_device *dev);
 
@@ -46,7 +32,7 @@ static int __cpuidle_register_device(str
  *
  * NOTE: no locks or semaphores should be used here
  */
-static void cpuidle_idle_call(void)
+void cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __get_cpu_var(cpuidle_devices);
 	struct cpuidle_state *target_state;
@@ -54,13 +40,10 @@ static void cpuidle_idle_call(void)
 
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
@@ -74,7 +57,11 @@ static void cpuidle_idle_call(void)
 	hrtimer_peek_ahead_timers();
 #endif
 	/* ask the governor for the next state */
-	next_state = cpuidle_curr_governor->select(dev);
+	if (dev->state_count > 1)
+		next_state = cpuidle_curr_governor->select(dev);
+	else
+		next_state = 0;
+
 	if (need_resched())
 		return;
 	target_state = &dev->states[next_state];
@@ -94,35 +81,11 @@ static void cpuidle_idle_call(void)
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
 }
 
 EXPORT_SYMBOL_GPL(cpuidle_pause_and_lock);
@@ -132,7 +95,6 @@ EXPORT_SYMBOL_GPL(cpuidle_pause_and_lock
  */
 void cpuidle_resume_and_unlock(void)
 {
-	cpuidle_install_idle_handler();
 	mutex_unlock(&cpuidle_lock);
 }
 
@@ -180,7 +142,6 @@ int cpuidle_enable_device(struct cpuidle
 
 	dev->enabled = 1;
 
-	enabled_devices++;
 	return 0;
 
 fail_sysfs:
@@ -211,7 +172,6 @@ void cpuidle_disable_device(struct cpuid
 		cpuidle_curr_governor->disable(dev);
 
 	cpuidle_remove_state_sysfs(dev);
-	enabled_devices--;
 }
 
 EXPORT_SYMBOL_GPL(cpuidle_disable_device);
@@ -303,7 +263,6 @@ int cpuidle_register_device(struct cpuid
 	}
 
 	cpuidle_enable_device(dev);
-	cpuidle_install_idle_handler();
 
 	mutex_unlock(&cpuidle_lock);
 
@@ -382,8 +341,6 @@ static int __init cpuidle_init(void)
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
@@ -48,8 +48,6 @@ int cpuidle_switch_governor(struct cpuid
 	if (gov == cpuidle_curr_governor)
 		return 0;
 
-	cpuidle_uninstall_idle_handler();
-
 	if (cpuidle_curr_governor) {
 		list_for_each_entry(dev, &cpuidle_detected_devices, device_list)
 			cpuidle_disable_device(dev);
@@ -63,7 +61,6 @@ int cpuidle_switch_governor(struct cpuid
 			return -EINVAL;
 		list_for_each_entry(dev, &cpuidle_detected_devices, device_list)
 			cpuidle_enable_device(dev);
-		cpuidle_install_idle_handler();
 		printk(KERN_INFO "cpuidle: using governor %s\n", gov->name);
 	}
 
Index: linux.trees.git/include/linux/cpuidle.h
===================================================================
--- linux.trees.git.orig/include/linux/cpuidle.h
+++ linux.trees.git/include/linux/cpuidle.h
@@ -112,6 +112,9 @@ static inline int cpuidle_get_last_resid
 	return dev->last_residency;
 }
 
+extern void cpuidle_idle_call(void);
+extern struct cpuidle_driver *cpuidle_curr_driver;
+
 
 /****************************
  * CPUIDLE DRIVER INTERFACE *
Index: linux.trees.git/drivers/cpuidle/cpuidle.h
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/cpuidle.h
+++ linux.trees.git/drivers/cpuidle/cpuidle.h
@@ -9,7 +9,6 @@
 
 /* For internal use only */
 extern struct cpuidle_governor *cpuidle_curr_governor;
-extern struct cpuidle_driver *cpuidle_curr_driver;
 extern struct list_head cpuidle_governors;
 extern struct list_head cpuidle_detected_devices;
 extern struct mutex cpuidle_lock;
