Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbYHURia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbYHURia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbYHURiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:38:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:47873 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760399AbYHURiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:38:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/15] PM: don't skip device PM init when CONFIG_PM_SLEEP isn't set and CONFIG_PM is set
Date: Thu, 21 Aug 2008 10:32:55 -0700
Message-Id: <1219339983-9634-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080821173036.GB7974@suse.de>
References: <20080821173036.GB7974@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1124) fixes a couple of bugs in the PM core.  The new
dev->power.status field should be initialized regardless of whether
CONFIG_PM_SLEEP is enabled, and similarly dpm_sysfs_add() should be
called whenever CONFIG_PM is enabled.

The patch separates out the call to dpm_sysfs_add() from the call to
device_pm_add().  As a result device_pm_add() can no longer return an
error, so its return type is changed to void.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Romit Dasgupta <romit@ti.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c        |    9 ++++++---
 drivers/base/power/main.c  |   13 +++----------
 drivers/base/power/power.h |    9 +++++++--
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 44bad73..4004131 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -541,6 +541,7 @@ void device_initialize(struct device *dev)
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
 	device_init_wakeup(dev, 0);
+	device_pm_init(dev);
 	set_dev_node(dev, -1);
 }
 
@@ -897,9 +898,10 @@ int device_add(struct device *dev)
 	error = bus_add_device(dev);
 	if (error)
 		goto BusError;
-	error = device_pm_add(dev);
+	error = dpm_sysfs_add(dev);
 	if (error)
-		goto PMError;
+		goto DPMError;
+	device_pm_add(dev);
 	kobject_uevent(&dev->kobj, KOBJ_ADD);
 	bus_attach_device(dev);
 	if (parent)
@@ -920,7 +922,7 @@ int device_add(struct device *dev)
  Done:
 	put_device(dev);
 	return error;
- PMError:
+ DPMError:
 	bus_remove_device(dev);
  BusError:
 	if (dev->bus)
@@ -1007,6 +1009,7 @@ void device_del(struct device *dev)
 	struct class_interface *class_intf;
 
 	device_pm_remove(dev);
+	dpm_sysfs_remove(dev);
 	if (parent)
 		klist_del(&dev->knode_parent);
 	if (MAJOR(dev->devt)) {
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 3250c52..284f564 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -67,10 +67,8 @@ void device_pm_unlock(void)
  *	device_pm_add - add a device to the list of active devices
  *	@dev:	Device to be added to the list
  */
-int device_pm_add(struct device *dev)
+void device_pm_add(struct device *dev)
 {
-	int error;
-
 	pr_debug("PM: Adding info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
@@ -89,13 +87,9 @@ int device_pm_add(struct device *dev)
 		 */
 		WARN_ON(true);
 	}
-	error = dpm_sysfs_add(dev);
-	if (!error) {
-		dev->power.status = DPM_ON;
-		list_add_tail(&dev->power.entry, &dpm_list);
-	}
+
+	list_add_tail(&dev->power.entry, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
-	return error;
 }
 
 /**
@@ -110,7 +104,6 @@ void device_pm_remove(struct device *dev)
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
 	mutex_lock(&dpm_list_mtx);
-	dpm_sysfs_remove(dev);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
 }
diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
index a3252c0..41f51fa 100644
--- a/drivers/base/power/power.h
+++ b/drivers/base/power/power.h
@@ -1,3 +1,8 @@
+static inline void device_pm_init(struct device *dev)
+{
+	dev->power.status = DPM_ON;
+}
+
 #ifdef CONFIG_PM_SLEEP
 
 /*
@@ -11,12 +16,12 @@ static inline struct device *to_device(struct list_head *entry)
 	return container_of(entry, struct device, power.entry);
 }
 
-extern int device_pm_add(struct device *);
+extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
 
 #else /* CONFIG_PM_SLEEP */
 
-static inline int device_pm_add(struct device *dev) { return 0; }
+static inline void device_pm_add(struct device *dev) {}
 static inline void device_pm_remove(struct device *dev) {}
 
 #endif
-- 
1.5.6.5

