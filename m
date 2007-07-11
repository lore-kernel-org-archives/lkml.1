Return-Path: <linux-kernel-owner+w=401wt.eu-S935131AbXGKXfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935131AbXGKXfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933910AbXGKXdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:33:12 -0400
Received: from mail.suse.de ([195.135.220.2]:33569 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933920AbXGKXdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:33:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/61] Power Management: use mutexes instead of semaphores
Date: Wed, 11 Jul 2007 16:31:25 -0700
Message-Id: <11841967674155-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841967633087-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The Power Management code uses semaphores as mutexes.  Use the mutex API
instead of the (binary) semaphores.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/main.c    |   14 ++++++++------
 drivers/base/power/power.h   |    4 ++--
 drivers/base/power/resume.c  |   12 ++++++------
 drivers/base/power/runtime.c |   12 ++++++------
 drivers/base/power/suspend.c |   14 +++++++-------
 5 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 05dc876..7b3cc3c 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -20,14 +20,16 @@
  */
 
 #include <linux/device.h>
+#include <linux/mutex.h>
+
 #include "power.h"
 
 LIST_HEAD(dpm_active);
 LIST_HEAD(dpm_off);
 LIST_HEAD(dpm_off_irq);
 
-DECLARE_MUTEX(dpm_sem);
-DECLARE_MUTEX(dpm_list_sem);
+DEFINE_MUTEX(dpm_mtx);
+DEFINE_MUTEX(dpm_list_mtx);
 
 int (*platform_enable_wakeup)(struct device *dev, int is_on);
 
@@ -59,12 +61,12 @@ int device_pm_add(struct device * dev)
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
 
@@ -73,11 +75,11 @@ void device_pm_remove(struct device * dev)
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
index a2c6418..f6cfea4 100644
--- a/drivers/base/power/resume.c
+++ b/drivers/base/power/resume.c
@@ -80,7 +80,7 @@ static int resume_device_early(struct device * dev)
  */
 void dpm_resume(void)
 {
-	down(&dpm_list_sem);
+	mutex_lock(&dpm_list_mtx);
 	while(!list_empty(&dpm_off)) {
 		struct list_head * entry = dpm_off.next;
 		struct device * dev = to_device(entry);
@@ -88,13 +88,13 @@ void dpm_resume(void)
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
 
 
@@ -108,9 +108,9 @@ void dpm_resume(void)
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
index 42d2b86..9d6701c 100644
--- a/drivers/base/power/suspend.c
+++ b/drivers/base/power/suspend.c
@@ -108,7 +108,7 @@ int suspend_device(struct device * dev, pm_message_t state)
 
 /*
  * This is called with interrupts off, only a single CPU
- * running. We can't do down() on a semaphore (and we don't
+ * running. We can't acquire a mutex or semaphore (and we don't
  * need the protection)
  */
 static int suspend_device_late(struct device *dev, pm_message_t state)
@@ -153,18 +153,18 @@ int device_suspend(pm_message_t state)
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
@@ -179,11 +179,11 @@ int device_suspend(pm_message_t state)
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
1.5.2.2

