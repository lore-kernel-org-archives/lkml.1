Return-Path: <linux-kernel-owner+w=401wt.eu-S1762054AbXK1Wxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054AbXK1Wxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761964AbXK1WxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:53:24 -0500
Received: from ns1.suse.de ([195.135.220.2]:57383 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761950AbXK1WxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:53:22 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Drake <dsd@gentoo.org>, Alan Stern <stern@rowland.harvard.edu>,
       Kay Sievers <kay.sievers@vrfy.org>, stable <stable@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/6] create /sys/.../power when CONFIG_PM is set
Date: Wed, 28 Nov 2007 14:52:16 -0800
Message-Id: <1196290340-28828-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071128224746.GA28410@kroah.com>
References: <20071128224746.GA28410@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Drake <dsd@gentoo.org>

The CONFIG_SUSPEND changes in 2.6.23 caused a regression under certain
configuration conditions (SUSPEND=n, USB_AUTOSUSPEND=y) where all USB
device attributes in sysfs (idVendor, idProduct, ...) silently disappeared,
causing udev breakage and more.

The cause of this is that the /sys/.../power subdirectory is now only
created when CONFIG_PM_SLEEP is set, however, it should be created whenever
CONFIG_PM is set to handle the above situation.  The following patch fixes
the regression.

Signed-off-by: Daniel Drake <dsd@gentoo.org>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: stable <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c         |    4 +++-
 drivers/base/power/Makefile |    3 ++-
 drivers/base/power/main.c   |    8 +-------
 drivers/base/power/power.h  |   28 +++++++++++++++++++++-------
 4 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 3f4d6aa..2683eac 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -770,9 +770,10 @@ int device_add(struct device *dev)
 	error = device_add_attrs(dev);
 	if (error)
 		goto AttrsError;
-	error = device_pm_add(dev);
+	error = dpm_sysfs_add(dev);
 	if (error)
 		goto PMError;
+	device_pm_add(dev);
 	error = bus_add_device(dev);
 	if (error)
 		goto BusError;
@@ -797,6 +798,7 @@ int device_add(struct device *dev)
 	return error;
  BusError:
 	device_pm_remove(dev);
+	dpm_sysfs_remove(dev);
  PMError:
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->bus_notifier,
diff --git a/drivers/base/power/Makefile b/drivers/base/power/Makefile
index a803733..44504e6 100644
--- a/drivers/base/power/Makefile
+++ b/drivers/base/power/Makefile
@@ -1,5 +1,6 @@
 obj-y			:= shutdown.o
-obj-$(CONFIG_PM_SLEEP)	+= main.o sysfs.o
+obj-$(CONFIG_PM)	+= sysfs.o
+obj-$(CONFIG_PM_SLEEP)	+= main.o
 obj-$(CONFIG_PM_TRACE)	+= trace.o
 
 ifeq ($(CONFIG_DEBUG_DRIVER),y)
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 0ab4ab2..691ffb6 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -38,20 +38,14 @@ static DEFINE_MUTEX(dpm_list_mtx);
 int (*platform_enable_wakeup)(struct device *dev, int is_on);
 
 
-int device_pm_add(struct device *dev)
+void device_pm_add(struct device *dev)
 {
-	int error;
-
 	pr_debug("PM: Adding info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
 	mutex_lock(&dpm_list_mtx);
 	list_add_tail(&dev->power.entry, &dpm_active);
-	error = dpm_sysfs_add(dev);
-	if (error)
-		list_del(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
-	return error;
 }
 
 void device_pm_remove(struct device *dev)
diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
index 5c4efd4..379da4e 100644
--- a/drivers/base/power/power.h
+++ b/drivers/base/power/power.h
@@ -13,14 +13,29 @@ extern void device_shutdown(void);
 
 extern struct list_head dpm_active;	/* The active device list */
 
-static inline struct device * to_device(struct list_head * entry)
+static inline struct device *to_device(struct list_head *entry)
 {
 	return container_of(entry, struct device, power.entry);
 }
 
-extern int device_pm_add(struct device *);
+extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
 
+#else /* CONFIG_PM_SLEEP */
+
+
+static inline void device_pm_add(struct device *dev)
+{
+}
+
+static inline void device_pm_remove(struct device *dev)
+{
+}
+
+#endif
+
+#ifdef CONFIG_PM
+
 /*
  * sysfs.c
  */
@@ -28,16 +43,15 @@ extern void device_pm_remove(struct device *);
 extern int dpm_sysfs_add(struct device *);
 extern void dpm_sysfs_remove(struct device *);
 
-#else /* CONFIG_PM_SLEEP */
-
+#else /* CONFIG_PM */
 
-static inline int device_pm_add(struct device * dev)
+static inline int dpm_sysfs_add(struct device *dev)
 {
 	return 0;
 }
-static inline void device_pm_remove(struct device * dev)
-{
 
+static inline void dpm_sysfs_remove(struct device *dev)
+{
 }
 
 #endif
-- 
1.5.3.4

