Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbZAIXWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbZAIXWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759983AbZAIXWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:22:00 -0500
Received: from kroah.org ([198.145.64.141]:54589 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759911AbZAIXV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:21:59 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 2/4] Revert "driver core: move knode_driver into private structure"
Date: Fri,  9 Jan 2009 15:20:55 -0800
Message-Id: <1231543257-10047-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090109232021.GA10007@kroah.com>
References: <20090109232021.GA10007@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 93e746db183b3bdbbda67900f79b5835f9cb388f.

Turns out that device_initialize shouldn't fail silently.
This series needs to be reworked in order to get into proper
shape.

Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h    |    4 ----
 drivers/base/dd.c      |   13 +++++--------
 drivers/base/driver.c  |   13 +++----------
 include/linux/device.h |    1 +
 4 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 8af0bb2..f5cf31c 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -68,7 +68,6 @@ struct class_private {
  *
  * @klist_children - klist containing all children of this device
  * @knode_parent - node in sibling list
- * @knode_driver - node in driver list
  * @device - pointer back to the struct class that this structure is
  * associated with.
  *
@@ -77,13 +76,10 @@ struct class_private {
 struct device_private {
 	struct klist klist_children;
 	struct klist_node knode_parent;
-	struct klist_node knode_driver;
 	struct device *device;
 };
 #define to_device_private_parent(obj)	\
 	container_of(obj, struct device_private, knode_parent)
-#define to_device_private_driver(obj)	\
-	container_of(obj, struct device_private, knode_driver)
 
 /* initialisation functions */
 extern int devices_init(void);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 6fdaf76..315bed8 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -28,7 +28,7 @@
 
 static void driver_bound(struct device *dev)
 {
-	if (klist_node_attached(&dev->p->knode_driver)) {
+	if (klist_node_attached(&dev->knode_driver)) {
 		printk(KERN_WARNING "%s: device %s already bound\n",
 			__func__, kobject_name(&dev->kobj));
 		return;
@@ -41,7 +41,7 @@ static void driver_bound(struct device *dev)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_BOUND_DRIVER, dev);
 
-	klist_add_tail(&dev->p->knode_driver, &dev->driver->p->klist_devices);
+	klist_add_tail(&dev->knode_driver, &dev->driver->p->klist_devices);
 }
 
 static int driver_sysfs_add(struct device *dev)
@@ -310,7 +310,7 @@ static void __device_release_driver(struct device *dev)
 			drv->remove(dev);
 		devres_release_all(dev);
 		dev->driver = NULL;
-		klist_remove(&dev->p->knode_driver);
+		klist_remove(&dev->knode_driver);
 	}
 }
 
@@ -340,7 +340,6 @@ EXPORT_SYMBOL_GPL(device_release_driver);
  */
 void driver_detach(struct device_driver *drv)
 {
-	struct device_private *dev_prv;
 	struct device *dev;
 
 	for (;;) {
@@ -349,10 +348,8 @@ void driver_detach(struct device_driver *drv)
 			spin_unlock(&drv->p->klist_devices.k_lock);
 			break;
 		}
-		dev_prv = list_entry(drv->p->klist_devices.k_list.prev,
-				     struct device_private,
-				     knode_driver.n_node);
-		dev = dev_prv->device;
+		dev = list_entry(drv->p->klist_devices.k_list.prev,
+				struct device, knode_driver.n_node);
 		get_device(dev);
 		spin_unlock(&drv->p->klist_devices.k_lock);
 
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index b76cc69..1e2bda7 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -19,14 +19,7 @@
 static struct device *next_device(struct klist_iter *i)
 {
 	struct klist_node *n = klist_next(i);
-	struct device *dev = NULL;
-	struct device_private *dev_prv;
-
-	if (n) {
-		dev_prv = to_device_private_driver(n);
-		dev = dev_prv->device;
-	}
-	return dev;
+	return n ? container_of(n, struct device, knode_driver) : NULL;
 }
 
 /**
@@ -49,7 +42,7 @@ int driver_for_each_device(struct device_driver *drv, struct device *start,
 		return -EINVAL;
 
 	klist_iter_init_node(&drv->p->klist_devices, &i,
-			     start ? &start->p->knode_driver : NULL);
+			     start ? &start->knode_driver : NULL);
 	while ((dev = next_device(&i)) && !error)
 		error = fn(dev, data);
 	klist_iter_exit(&i);
@@ -83,7 +76,7 @@ struct device *driver_find_device(struct device_driver *drv,
 		return NULL;
 
 	klist_iter_init_node(&drv->p->klist_devices, &i,
-			     (start ? &start->p->knode_driver : NULL));
+			     (start ? &start->knode_driver : NULL));
 	while ((dev = next_device(&i)))
 		if (match(dev, data) && get_device(dev))
 			break;
diff --git a/include/linux/device.h b/include/linux/device.h
index 8987f47..c66ceb1 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -366,6 +366,7 @@ struct device_dma_parameters {
 };
 
 struct device {
+	struct klist_node	knode_driver;
 	struct klist_node	knode_bus;
 	struct device		*parent;
 
-- 
1.6.0.4

