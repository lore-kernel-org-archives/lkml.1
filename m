Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbZCYAtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbZCYAtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756965AbZCYAao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:44 -0400
Received: from kroah.org ([198.145.64.141]:54204 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756900AbZCYAa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:28 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 54/61] Driver core: Fix device_move() vs. dpm list ordering, v2
Date: Tue, 24 Mar 2009 17:26:58 -0700
Message-Id: <1237940825-22904-54-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

dpm_list currently relies on the fact that child devices will
be registered after their parents to get a correct suspend
order. Using device_move() however destroys this assumption, as
an already registered device may be moved under a newly registered
one.

This patch adds a new argument to device_move(), allowing callers
to specify how dpm_list should be adapted.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c        |   19 ++++++++++++++++++-
 drivers/base/power/main.c  |   44 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/base/power/power.h |    8 ++++++++
 drivers/s390/cio/device.c  |    9 +++++----
 include/linux/device.h     |    3 ++-
 include/linux/pm.h         |   11 +++++++++++
 net/bluetooth/hci_sysfs.c  |    2 +-
 net/bluetooth/rfcomm/tty.c |    5 +++--
 8 files changed, 92 insertions(+), 9 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 95c67ff..e73c92d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1561,8 +1561,10 @@ out:
  * device_move - moves a device to a new parent
  * @dev: the pointer to the struct device to be moved
  * @new_parent: the new parent of the device (can by NULL)
+ * @dpm_order: how to reorder the dpm_list
  */
-int device_move(struct device *dev, struct device *new_parent)
+int device_move(struct device *dev, struct device *new_parent,
+		enum dpm_order dpm_order)
 {
 	int error;
 	struct device *old_parent;
@@ -1572,6 +1574,7 @@ int device_move(struct device *dev, struct device *new_parent)
 	if (!dev)
 		return -EINVAL;
 
+	device_pm_lock();
 	new_parent = get_device(new_parent);
 	new_parent_kobj = get_device_parent(dev, new_parent);
 
@@ -1613,9 +1616,23 @@ int device_move(struct device *dev, struct device *new_parent)
 		put_device(new_parent);
 		goto out;
 	}
+	switch (dpm_order) {
+	case DPM_ORDER_NONE:
+		break;
+	case DPM_ORDER_DEV_AFTER_PARENT:
+		device_pm_move_after(dev, new_parent);
+		break;
+	case DPM_ORDER_PARENT_BEFORE_DEV:
+		device_pm_move_before(new_parent, dev);
+		break;
+	case DPM_ORDER_DEV_LAST:
+		device_pm_move_last(dev);
+		break;
+	}
 out_put:
 	put_device(old_parent);
 out:
+	device_pm_unlock();
 	put_device(dev);
 	return error;
 }
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 2d14f4a..e255341 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -107,6 +107,50 @@ void device_pm_remove(struct device *dev)
 }
 
 /**
+ *	device_pm_move_before - move device in dpm_list
+ *	@deva:  Device to move in dpm_list
+ *	@devb:  Device @deva should come before
+ */
+void device_pm_move_before(struct device *deva, struct device *devb)
+{
+	pr_debug("PM: Moving %s:%s before %s:%s\n",
+		 deva->bus ? deva->bus->name : "No Bus",
+		 kobject_name(&deva->kobj),
+		 devb->bus ? devb->bus->name : "No Bus",
+		 kobject_name(&devb->kobj));
+	/* Delete deva from dpm_list and reinsert before devb. */
+	list_move_tail(&deva->power.entry, &devb->power.entry);
+}
+
+/**
+ *	device_pm_move_after - move device in dpm_list
+ *	@deva:  Device to move in dpm_list
+ *	@devb:  Device @deva should come after
+ */
+void device_pm_move_after(struct device *deva, struct device *devb)
+{
+	pr_debug("PM: Moving %s:%s after %s:%s\n",
+		 deva->bus ? deva->bus->name : "No Bus",
+		 kobject_name(&deva->kobj),
+		 devb->bus ? devb->bus->name : "No Bus",
+		 kobject_name(&devb->kobj));
+	/* Delete deva from dpm_list and reinsert after devb. */
+	list_move(&deva->power.entry, &devb->power.entry);
+}
+
+/**
+ * 	device_pm_move_last - move device to end of dpm_list
+ * 	@dev:   Device to move in dpm_list
+ */
+void device_pm_move_last(struct device *dev)
+{
+	pr_debug("PM: Moving %s:%s to end of list\n",
+		 dev->bus ? dev->bus->name : "No Bus",
+		 kobject_name(&dev->kobj));
+	list_move_tail(&dev->power.entry, &dpm_list);
+}
+
+/**
  *	pm_op - execute the PM operation appropiate for given PM event
  *	@dev:	Device.
  *	@ops:	PM operations to choose from.
diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
index 41f51fa..c7cb4fc 100644
--- a/drivers/base/power/power.h
+++ b/drivers/base/power/power.h
@@ -18,11 +18,19 @@ static inline struct device *to_device(struct list_head *entry)
 
 extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
+extern void device_pm_move_before(struct device *, struct device *);
+extern void device_pm_move_after(struct device *, struct device *);
+extern void device_pm_move_last(struct device *);
 
 #else /* CONFIG_PM_SLEEP */
 
 static inline void device_pm_add(struct device *dev) {}
 static inline void device_pm_remove(struct device *dev) {}
+static inline void device_pm_move_before(struct device *deva,
+					 struct device *devb) {}
+static inline void device_pm_move_after(struct device *deva,
+					struct device *devb) {}
+static inline void device_pm_move_last(struct device *dev) {}
 
 #endif
 
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 611d2e0..e28f8ae 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -799,7 +799,7 @@ static void sch_attach_disconnected_device(struct subchannel *sch,
 		return;
 	other_sch = to_subchannel(cdev->dev.parent);
 	/* Note: device_move() changes cdev->dev.parent */
-	ret = device_move(&cdev->dev, &sch->dev);
+	ret = device_move(&cdev->dev, &sch->dev, DPM_ORDER_PARENT_BEFORE_DEV);
 	if (ret) {
 		CIO_MSG_EVENT(0, "Moving disconnected device 0.%x.%04x failed "
 			      "(ret=%d)!\n", cdev->private->dev_id.ssid,
@@ -830,7 +830,7 @@ static void sch_attach_orphaned_device(struct subchannel *sch,
 	 * Try to move the ccw device to its new subchannel.
 	 * Note: device_move() changes cdev->dev.parent
 	 */
-	ret = device_move(&cdev->dev, &sch->dev);
+	ret = device_move(&cdev->dev, &sch->dev, DPM_ORDER_PARENT_BEFORE_DEV);
 	if (ret) {
 		CIO_MSG_EVENT(0, "Moving device 0.%x.%04x from orphanage "
 			      "failed (ret=%d)!\n",
@@ -897,7 +897,8 @@ void ccw_device_move_to_orphanage(struct work_struct *work)
 	 * ccw device can take its place on the subchannel.
 	 * Note: device_move() changes cdev->dev.parent
 	 */
-	ret = device_move(&cdev->dev, &css->pseudo_subchannel->dev);
+	ret = device_move(&cdev->dev, &css->pseudo_subchannel->dev,
+		DPM_ORDER_NONE);
 	if (ret) {
 		CIO_MSG_EVENT(0, "Moving device 0.%x.%04x to orphanage failed "
 			      "(ret=%d)!\n", cdev->private->dev_id.ssid,
@@ -1129,7 +1130,7 @@ static void ccw_device_move_to_sch(struct work_struct *work)
 	 * Try to move the ccw device to its new subchannel.
 	 * Note: device_move() changes cdev->dev.parent
 	 */
-	rc = device_move(&cdev->dev, &sch->dev);
+	rc = device_move(&cdev->dev, &sch->dev, DPM_ORDER_PARENT_BEFORE_DEV);
 	mutex_unlock(&sch->reg_mutex);
 	if (rc) {
 		CIO_MSG_EVENT(0, "Moving device 0.%x.%04x to subchannel "
diff --git a/include/linux/device.h b/include/linux/device.h
index 914c101..f98d0cf 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -494,7 +494,8 @@ extern int device_for_each_child(struct device *dev, void *data,
 extern struct device *device_find_child(struct device *dev, void *data,
 				int (*match)(struct device *dev, void *data));
 extern int device_rename(struct device *dev, char *new_name);
-extern int device_move(struct device *dev, struct device *new_parent);
+extern int device_move(struct device *dev, struct device *new_parent,
+		       enum dpm_order dpm_order);
 
 /*
  * Root device objects for grouping under /sys/devices
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 24ba5f6..1d4e2d2 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -400,6 +400,9 @@ extern void __suspend_report_result(const char *function, void *fn, int ret);
 
 #else /* !CONFIG_PM_SLEEP */
 
+#define device_pm_lock() do {} while (0)
+#define device_pm_unlock() do {} while (0)
+
 static inline int device_suspend(pm_message_t state)
 {
 	return 0;
@@ -409,6 +412,14 @@ static inline int device_suspend(pm_message_t state)
 
 #endif /* !CONFIG_PM_SLEEP */
 
+/* How to reorder dpm_list after device_move() */
+enum dpm_order {
+	DPM_ORDER_NONE,
+	DPM_ORDER_DEV_AFTER_PARENT,
+	DPM_ORDER_PARENT_BEFORE_DEV,
+	DPM_ORDER_DEV_LAST,
+};
+
 /*
  * Global Power Management flags
  * Used to keep APM and ACPI from both being active
diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index 1a1f916..ed82796 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -140,7 +140,7 @@ static void del_conn(struct work_struct *work)
 		dev = device_find_child(&conn->dev, NULL, __match_tty);
 		if (!dev)
 			break;
-		device_move(dev, NULL);
+		device_move(dev, NULL, DPM_ORDER_DEV_LAST);
 		put_device(dev);
 	}
 
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index d030c69..abdc703 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -731,7 +731,8 @@ static int rfcomm_tty_open(struct tty_struct *tty, struct file *filp)
 	remove_wait_queue(&dev->wait, &wait);
 
 	if (err == 0)
-		device_move(dev->tty_dev, rfcomm_get_device(dev));
+		device_move(dev->tty_dev, rfcomm_get_device(dev),
+			    DPM_ORDER_DEV_AFTER_PARENT);
 
 	rfcomm_tty_copy_pending(dev);
 
@@ -751,7 +752,7 @@ static void rfcomm_tty_close(struct tty_struct *tty, struct file *filp)
 
 	if (atomic_dec_and_test(&dev->opened)) {
 		if (dev->tty_dev->parent)
-			device_move(dev->tty_dev, NULL);
+			device_move(dev->tty_dev, NULL, DPM_ORDER_DEV_LAST);
 
 		/* Close DLC and dettach TTY */
 		rfcomm_dlc_close(dev->dlc, 0);
-- 
1.6.2

