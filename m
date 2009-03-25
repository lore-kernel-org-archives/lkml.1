Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbZCYAqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbZCYAqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756917AbZCYAac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:32 -0400
Received: from kroah.org ([198.145.64.141]:54176 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756849AbZCYAaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:20 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 46/61] driver core: move knode_driver into private structure
Date: Tue, 24 Mar 2009 17:26:50 -0700
Message-Id: <1237940825-22904-46-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of the driver core should ever touch knode_driver, so
move it out of the public eye.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h    |    4 ++++
 drivers/base/dd.c      |   13 ++++++++-----
 drivers/base/driver.c  |   13 ++++++++++---
 include/linux/device.h |    1 -
 4 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 7c4fafc..4fc5fd3 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -68,6 +68,7 @@ struct class_private {
  *
  * @klist_children - klist containing all children of this device
  * @knode_parent - node in sibling list
+ * @knode_driver - node in driver list
  * @device - pointer back to the struct class that this structure is
  * associated with.
  *
@@ -76,10 +77,13 @@ struct class_private {
 struct device_private {
 	struct klist klist_children;
 	struct klist_node knode_parent;
+	struct klist_node knode_driver;
 	struct device *device;
 };
 #define to_device_private_parent(obj)	\
 	container_of(obj, struct device_private, knode_parent)
+#define to_device_private_driver(obj)	\
+	container_of(obj, struct device_private, knode_driver)
 
 /* initialisation functions */
 extern int devices_init(void);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 0dfd08c..f17c326 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -30,7 +30,7 @@
 
 static void driver_bound(struct device *dev)
 {
-	if (klist_node_attached(&dev->knode_driver)) {
+	if (klist_node_attached(&dev->p->knode_driver)) {
 		printk(KERN_WARNING "%s: device %s already bound\n",
 			__func__, kobject_name(&dev->kobj));
 		return;
@@ -43,7 +43,7 @@ static void driver_bound(struct device *dev)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_BOUND_DRIVER, dev);
 
-	klist_add_tail(&dev->knode_driver, &dev->driver->p->klist_devices);
+	klist_add_tail(&dev->p->knode_driver, &dev->driver->p->klist_devices);
 }
 
 static int driver_sysfs_add(struct device *dev)
@@ -318,7 +318,7 @@ static void __device_release_driver(struct device *dev)
 			drv->remove(dev);
 		devres_release_all(dev);
 		dev->driver = NULL;
-		klist_remove(&dev->knode_driver);
+		klist_remove(&dev->p->knode_driver);
 	}
 }
 
@@ -348,6 +348,7 @@ EXPORT_SYMBOL_GPL(device_release_driver);
  */
 void driver_detach(struct device_driver *drv)
 {
+	struct device_private *dev_prv;
 	struct device *dev;
 
 	for (;;) {
@@ -356,8 +357,10 @@ void driver_detach(struct device_driver *drv)
 			spin_unlock(&drv->p->klist_devices.k_lock);
 			break;
 		}
-		dev = list_entry(drv->p->klist_devices.k_list.prev,
-				struct device, knode_driver.n_node);
+		dev_prv = list_entry(drv->p->klist_devices.k_list.prev,
+				     struct device_private,
+				     knode_driver.n_node);
+		dev = dev_prv->device;
 		get_device(dev);
 		spin_unlock(&drv->p->klist_devices.k_lock);
 
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 2889ad5..c51f11b 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -19,7 +19,14 @@
 static struct device *next_device(struct klist_iter *i)
 {
 	struct klist_node *n = klist_next(i);
-	return n ? container_of(n, struct device, knode_driver) : NULL;
+	struct device *dev = NULL;
+	struct device_private *dev_prv;
+
+	if (n) {
+		dev_prv = to_device_private_driver(n);
+		dev = dev_prv->device;
+	}
+	return dev;
 }
 
 /**
@@ -42,7 +49,7 @@ int driver_for_each_device(struct device_driver *drv, struct device *start,
 		return -EINVAL;
 
 	klist_iter_init_node(&drv->p->klist_devices, &i,
-			     start ? &start->knode_driver : NULL);
+			     start ? &start->p->knode_driver : NULL);
 	while ((dev = next_device(&i)) && !error)
 		error = fn(dev, data);
 	klist_iter_exit(&i);
@@ -76,7 +83,7 @@ struct device *driver_find_device(struct device_driver *drv,
 		return NULL;
 
 	klist_iter_init_node(&drv->p->klist_devices, &i,
-			     (start ? &start->knode_driver : NULL));
+			     (start ? &start->p->knode_driver : NULL));
 	while ((dev = next_device(&i)))
 		if (match(dev, data) && get_device(dev))
 			break;
diff --git a/include/linux/device.h b/include/linux/device.h
index 808d808..83e241f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -368,7 +368,6 @@ struct device_dma_parameters {
 };
 
 struct device {
-	struct klist_node	knode_driver;
 	struct klist_node	knode_bus;
 	struct device		*parent;
 
-- 
1.6.2

