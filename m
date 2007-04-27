Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbXD0Iko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbXD0Iko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 04:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbXD0Iko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 04:40:44 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:46351
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755472AbXD0Ikb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 04:40:31 -0400
Date: Fri, 27 Apr 2007 10:43:22 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/5] Power Management: use mutexes instead of semaphores
Message-ID: <20070427084322.GC4213@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	gregkh@suse.de, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070427083857.GB4213@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427083857.GB4213@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the Power Management code uses semaphores as mutexes. use the mutex
API instead of the (binary) semaphores

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index bbbb973..297061c 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -26,8 +26,8 @@ LIST_HEAD(dpm_active);
 LIST_HEAD(dpm_off);
 LIST_HEAD(dpm_off_irq);
 
-DECLARE_MUTEX(dpm_sem);
-DECLARE_MUTEX(dpm_list_sem);
+DEFINE_MUTEX(dpm_mtx);
+DEFINE_MUTEX(dpm_list_mtx);
 
 /**
  *	device_pm_set_parent - Specify power dependency.
@@ -56,12 +56,12 @@ int device_pm_add(struct device * dev)
 	pr_debug("PM: Adding info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
-	down(&dpm_list_sem);
+	mutex_lock(&dpm_list_mtx);
 	list_add_tail(&dev->power.entry, &dpm_active);
 	device_pm_set_parent(dev, dev->parent);
 	if ((error = dpm_sysfs_add(dev)))
 		list_del(&dev->power.entry);
-	up(&dpm_list_sem);
+	mutex_unlock(&dpm_list_mtx);
 	return error;
 }
 
@@ -70,11 +70,11 @@ void device_pm_remove(struct device * dev)
 	pr_debug("PM: Removing info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
-	down(&dpm_list_sem);
+	mutex_lock(&dpm_list_mtx);
 	dpm_sysfs_remove(dev);
 	put_device(dev->power.pm_parent);
 	list_del_init(&dev->power.entry);
-	up(&dpm_list_sem);
+	mutex_unlock(&dpm_list_mtx);
 }
 
 
diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
index fb3d35a..2760f25 100644
--- a/drivers/base/power/power.h
+++ b/drivers/base/power/power.h
@@ -14,12 +14,12 @@ extern void device_shutdown(void);
 /*
  * Used to synchronize global power management operations.
  */
-extern struct semaphore dpm_sem;
+extern struct mutex dpm_mtx;
 
 /*
  * Used to serialize changes to the dpm_* lists.
  */
-extern struct semaphore dpm_list_sem;
+extern struct mutex dpm_list_mtx;
 
 /*
  * The PM lists.
diff --git a/drivers/base/power/resume.c b/drivers/base/power/resume.c
index 020be36..fb75760 100644
--- a/drivers/base/power/resume.c
+++ b/drivers/base/power/resume.c
@@ -69,7 +69,7 @@ static int resume_device_early(struct device * dev)
  */
 void dpm_resume(void)
 {
-	down(&dpm_list_sem);
+	mutex_lock(&dpm_list_mtx);
 	while(!list_empty(&dpm_off)) {
 		struct list_head * entry = dpm_off.next;
 		struct device * dev = to_device(entry);
@@ -77,13 +77,13 @@ void dpm_resume(void)
 		get_device(dev);
 		list_move_tail(entry, &dpm_active);
 
-		up(&dpm_list_sem);
+		mutex_unlock(&dpm_list_mtx);
 		if (!dev->power.prev_state.event)
 			resume_device(dev);
-		down(&dpm_list_sem);
+		mutex_lock(&dpm_list_mtx);
 		put_device(dev);
 	}
-	up(&dpm_list_sem);
+	mutex_unlock(&dpm_list_mtx);
 }
 
 
@@ -97,9 +97,9 @@ void dpm_resume(void)
 void device_resume(void)
 {
 	might_sleep();
-	down(&dpm_sem);
+	mutex_lock(&dpm_mtx);
 	dpm_resume();
-	up(&dpm_sem);
+	mutex_unlock(&dpm_mtx);
 }
 
 EXPORT_SYMBOL_GPL(device_resume);
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 96370ec..df6174d 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -32,9 +32,9 @@ static void runtime_resume(struct device * dev)
 
 void dpm_runtime_resume(struct device * dev)
 {
-	down(&dpm_sem);
+	mutex_lock(&dpm_mtx);
 	runtime_resume(dev);
-	up(&dpm_sem);
+	mutex_unlock(&dpm_mtx);
 }
 EXPORT_SYMBOL(dpm_runtime_resume);
 
@@ -49,7 +49,7 @@ int dpm_runtime_suspend(struct device * dev, pm_message_t state)
 {
 	int error = 0;
 
-	down(&dpm_sem);
+	mutex_lock(&dpm_mtx);
 	if (dev->power.power_state.event == state.event)
 		goto Done;
 
@@ -59,7 +59,7 @@ int dpm_runtime_suspend(struct device * dev, pm_message_t state)
 	if (!(error = suspend_device(dev, state)))
 		dev->power.power_state = state;
  Done:
-	up(&dpm_sem);
+	mutex_unlock(&dpm_mtx);
 	return error;
 }
 EXPORT_SYMBOL(dpm_runtime_suspend);
@@ -78,8 +78,8 @@ EXPORT_SYMBOL(dpm_runtime_suspend);
  */
 void dpm_set_power_state(struct device * dev, pm_message_t state)
 {
-	down(&dpm_sem);
+	mutex_lock(&dpm_mtx);
 	dev->power.power_state = state;
-	up(&dpm_sem);
+	mutex_unlock(&dpm_mtx);
 }
 #endif  /*  0  */
diff --git a/drivers/base/power/suspend.c b/drivers/base/power/suspend.c
index ece136b..0a2fc61 100644
--- a/drivers/base/power/suspend.c
+++ b/drivers/base/power/suspend.c
@@ -96,7 +96,7 @@ int suspend_device(struct device * dev, pm_message_t state)
 
 /*
  * This is called with interrupts off, only a single CPU
- * running. We can't do down() on a semaphore (and we don't
+ * running. We can't acquire a mutex or semaphore (and we don't
  * need the protection)
  */
 static int suspend_device_late(struct device *dev, pm_message_t state)
@@ -141,18 +141,18 @@ int device_suspend(pm_message_t state)
 	int error = 0;
 
 	might_sleep();
-	down(&dpm_sem);
-	down(&dpm_list_sem);
+	mutex_lock(&dpm_mtx);
+	mutex_lock(&dpm_list_mtx);
 	while (!list_empty(&dpm_active) && error == 0) {
 		struct list_head * entry = dpm_active.prev;
 		struct device * dev = to_device(entry);
 
 		get_device(dev);
-		up(&dpm_list_sem);
+		mutex_unlock(&dpm_list_mtx);
 
 		error = suspend_device(dev, state);
 
-		down(&dpm_list_sem);
+		mutex_lock(&dpm_list_mtx);
 
 		/* Check if the device got removed */
 		if (!list_empty(&dev->power.entry)) {
@@ -167,11 +167,11 @@ int device_suspend(pm_message_t state)
 				error == -EAGAIN ? " (please convert to suspend_late)" : "");
 		put_device(dev);
 	}
-	up(&dpm_list_sem);
+	mutex_unlock(&dpm_list_mtx);
 	if (error)
 		dpm_resume();
 
-	up(&dpm_sem);
+	mutex_unlock(&dpm_mtx);
 	return error;
 }
 

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

             You must have a plan. If you don't have a plan,
               you'll become part of somebody else's plan
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
