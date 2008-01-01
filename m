Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbYAAXl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbYAAXl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbYAAXlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:41:01 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38111 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995AbYAAXk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:40:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/4] PM: Introduce destroy_suspended_device()
Date: Wed, 2 Jan 2008 00:34:59 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>
References: <200801020032.45529.rjw@sisk.pl>
In-Reply-To: <200801020032.45529.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801020035.00301.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

It sometimes is necessary to destroy a device object during a suspend or
hibernation, but the PM core is supposed to control all device objects in that
cases.  For this reason, it is necessary to introduce a mechanism allowing one
to ask the PM core to remove a device object corresponding to a suspended
device on one's behalf.

Define function destroy_suspended_device() that will schedule the removal of
a device object corresponding to a suspended device by the PM core during the
subsequent resume.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/core.c        |   44 +++++++++++++++++++++++++++++++++++++++-----
 drivers/base/power/main.c  |   36 +++++++++++++++++++++++++++---------
 drivers/base/power/power.h |    1 +
 include/linux/device.h     |    8 ++++++++
 4 files changed, 75 insertions(+), 14 deletions(-)

Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -1156,14 +1156,11 @@ error:
 EXPORT_SYMBOL_GPL(device_create);
 
 /**
- * device_destroy - removes a device that was created with device_create()
+ * find_device - finds a device that was created with device_create()
  * @class: pointer to the struct class that this device was registered with
  * @devt: the dev_t of the device that was previously registered
- *
- * This call unregisters and cleans up a device that was created with a
- * call to device_create().
  */
-void device_destroy(struct class *class, dev_t devt)
+static struct device *find_device(struct class *class, dev_t devt)
 {
 	struct device *dev = NULL;
 	struct device *dev_tmp;
@@ -1176,12 +1173,49 @@ void device_destroy(struct class *class,
 		}
 	}
 	up(&class->sem);
+	return dev;
+}
 
+/**
+ * device_destroy - removes a device that was created with device_create()
+ * @class: pointer to the struct class that this device was registered with
+ * @devt: the dev_t of the device that was previously registered
+ *
+ * This call unregisters and cleans up a device that was created with a
+ * call to device_create().
+ */
+void device_destroy(struct class *class, dev_t devt)
+{
+	struct device *dev;
+
+	dev = find_device(class, devt);
 	if (dev)
 		device_unregister(dev);
 }
 EXPORT_SYMBOL_GPL(device_destroy);
 
+#ifdef CONFIG_PM_SLEEP
+/**
+ * destroy_suspended_device - schedules the removal of a suspended device
+ * @class: pointer to the struct class that this device was registered with
+ * @devt: the dev_t of the device that was previously registered
+ *
+ * This call notifies the PM core of the necessity to unregister a suspended
+ * device created with a call to device_create() (devices cannot be
+ * unregistered directly while suspended, since the PM core controls them in
+ * that cases).
+ */
+void destroy_suspended_device(struct class *class, dev_t devt)
+{
+	struct device *dev;
+
+	dev = find_device(class, devt);
+	if (dev)
+		device_pm_schedule_removal(dev);
+}
+EXPORT_SYMBOL_GPL(destroy_suspended_device);
+#endif /* CONFIG_PM_SLEEP */
+
 /**
  * device_rename - renames a device
  * @dev: the pointer to the struct device to be renamed
Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h
+++ linux-2.6/include/linux/device.h
@@ -521,6 +521,14 @@ extern struct device *device_create(stru
 				    dev_t devt, const char *fmt, ...)
 				    __attribute__((format(printf,4,5)));
 extern void device_destroy(struct class *cls, dev_t devt);
+#ifdef CONFIG_PM_SLEEP
+extern void destroy_suspended_device(struct class *cls, dev_t devt);
+#else /* !CONFIG_PM_SLEEP */
+static inline void destroy_suspended_device(struct class *cls, dev_t devt)
+{
+	device_destroy(cls, devt);
+}
+#endif /* !CONFIG_PM_SLEEP */
 
 /*
  * Platform "fixup" functions - allow the platform to have their say
Index: linux-2.6/drivers/base/power/power.h
===================================================================
--- linux-2.6.orig/drivers/base/power/power.h
+++ linux-2.6/drivers/base/power/power.h
@@ -20,6 +20,7 @@ static inline struct device *to_device(s
 
 extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
+extern void device_pm_schedule_removal(struct device *);
 
 #else /* CONFIG_PM_SLEEP */
 
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -31,6 +31,7 @@
 LIST_HEAD(dpm_active);
 static LIST_HEAD(dpm_off);
 static LIST_HEAD(dpm_off_irq);
+static LIST_HEAD(dpm_destroy);
 
 static DEFINE_MUTEX(dpm_mtx);
 static DEFINE_MUTEX(dpm_list_mtx);
@@ -59,6 +60,17 @@ void device_pm_remove(struct device *dev
 	mutex_unlock(&dpm_list_mtx);
 }
 
+void device_pm_schedule_removal(struct device *dev)
+{
+	pr_debug("PM: Removing info for %s:%s\n",
+		 dev->bus ? dev->bus->name : "No Bus",
+		 kobject_name(&dev->kobj));
+	mutex_lock(&dpm_list_mtx);
+	dpm_sysfs_remove(dev);
+	list_move_tail(&dev->power.entry, &dpm_destroy);
+	mutex_unlock(&dpm_list_mtx);
+}
+
 
 /*------------------------- Resume routines -------------------------*/
 
@@ -113,11 +125,14 @@ static int resume_device_early(struct de
 	return error;
 }
 
-/*
- * Resume the devices that have either not gone through
- * the late suspend, or that did go through it but also
- * went through the early resume
+/**
+ *	dpm_resume - Restore state of each device in system.
+ *
+ *	Walk the dpm_off list, remove each entry, resume the device,
+ *	then add it to the dpm_active list.  Unregister devices scheduled for
+ *	removal.
  */
+
 static void dpm_resume(void)
 {
 	mutex_lock(&dpm_list_mtx);
@@ -134,14 +149,17 @@ static void dpm_resume(void)
 		put_device(dev);
 	}
 	mutex_unlock(&dpm_list_mtx);
-}
+	/* Unregister devices scheduled for removal */
+	while (!list_empty(&dpm_destroy)) {
+		struct list_head *entry = dpm_destroy.next;
+		struct device *dev = to_device(entry);
 
+		device_unregister(dev);
+	}
+}
 
 /**
- *	device_resume - Restore state of each device in system.
- *
- *	Walk the dpm_off list, remove each entry, resume the device,
- *	then add it to the dpm_active list.
+ *	device_resume - Invoke dpm_resume() under dpm_mtx.
  */
 
 void device_resume(void)

