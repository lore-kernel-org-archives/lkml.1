Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbZCYAqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbZCYAqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756881AbZCYAab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:31 -0400
Received: from kroah.org ([198.145.64.141]:54172 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754705AbZCYAaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:19 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 45/61] driver core: move klist_children into private structure
Date: Tue, 24 Mar 2009 17:26:49 -0700
Message-Id: <1237940825-22904-45-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of the driver core should ever touch klist_children, or
knode_parent, so move them out of the public eye.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h    |    6 ++++++
 drivers/base/core.c    |   39 +++++++++++++++++++++++++--------------
 include/linux/device.h |    2 --
 3 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 62a2cb5..7c4fafc 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -66,14 +66,20 @@ struct class_private {
 /**
  * struct device_private - structure to hold the private to the driver core portions of the device structure.
  *
+ * @klist_children - klist containing all children of this device
+ * @knode_parent - node in sibling list
  * @device - pointer back to the struct class that this structure is
  * associated with.
  *
  * Nothing outside of the driver core should ever touch these fields.
  */
 struct device_private {
+	struct klist klist_children;
+	struct klist_node knode_parent;
 	struct device *device;
 };
+#define to_device_private_parent(obj)	\
+	container_of(obj, struct device_private, knode_parent)
 
 /* initialisation functions */
 extern int devices_init(void);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 16d8599..a90f56f 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -509,14 +509,16 @@ EXPORT_SYMBOL_GPL(device_schedule_callback_owner);
 
 static void klist_children_get(struct klist_node *n)
 {
-	struct device *dev = container_of(n, struct device, knode_parent);
+	struct device_private *p = to_device_private_parent(n);
+	struct device *dev = p->device;
 
 	get_device(dev);
 }
 
 static void klist_children_put(struct klist_node *n)
 {
-	struct device *dev = container_of(n, struct device, knode_parent);
+	struct device_private *p = to_device_private_parent(n);
+	struct device *dev = p->device;
 
 	put_device(dev);
 }
@@ -540,8 +542,6 @@ void device_initialize(struct device *dev)
 {
 	dev->kobj.kset = devices_kset;
 	kobject_init(&dev->kobj, &device_ktype);
-	klist_init(&dev->klist_children, klist_children_get,
-		   klist_children_put);
 	INIT_LIST_HEAD(&dev->dma_pools);
 	init_MUTEX(&dev->sem);
 	spin_lock_init(&dev->devres_lock);
@@ -867,6 +867,8 @@ int device_add(struct device *dev)
 		goto done;
 	}
 	dev->p->device = dev;
+	klist_init(&dev->p->klist_children, klist_children_get,
+		   klist_children_put);
 
 	/*
 	 * for statically allocated devices, which should all be converted
@@ -937,7 +939,8 @@ int device_add(struct device *dev)
 	kobject_uevent(&dev->kobj, KOBJ_ADD);
 	bus_attach_device(dev);
 	if (parent)
-		klist_add_tail(&dev->knode_parent, &parent->klist_children);
+		klist_add_tail(&dev->p->knode_parent,
+			       &parent->p->klist_children);
 
 	if (dev->class) {
 		mutex_lock(&dev->class->p->class_mutex);
@@ -1051,7 +1054,7 @@ void device_del(struct device *dev)
 	device_pm_remove(dev);
 	dpm_sysfs_remove(dev);
 	if (parent)
-		klist_del(&dev->knode_parent);
+		klist_del(&dev->p->knode_parent);
 	if (MAJOR(dev->devt)) {
 		device_remove_sys_dev_entry(dev);
 		device_remove_file(dev, &devt_attr);
@@ -1112,7 +1115,14 @@ void device_unregister(struct device *dev)
 static struct device *next_device(struct klist_iter *i)
 {
 	struct klist_node *n = klist_next(i);
-	return n ? container_of(n, struct device, knode_parent) : NULL;
+	struct device *dev = NULL;
+	struct device_private *p;
+
+	if (n) {
+		p = to_device_private_parent(n);
+		dev = p->device;
+	}
+	return dev;
 }
 
 /**
@@ -1134,7 +1144,7 @@ int device_for_each_child(struct device *parent, void *data,
 	struct device *child;
 	int error = 0;
 
-	klist_iter_init(&parent->klist_children, &i);
+	klist_iter_init(&parent->p->klist_children, &i);
 	while ((child = next_device(&i)) && !error)
 		error = fn(child, data);
 	klist_iter_exit(&i);
@@ -1165,7 +1175,7 @@ struct device *device_find_child(struct device *parent, void *data,
 	if (!parent)
 		return NULL;
 
-	klist_iter_init(&parent->klist_children, &i);
+	klist_iter_init(&parent->p->klist_children, &i);
 	while ((child = next_device(&i)))
 		if (match(child, data) && get_device(child))
 			break;
@@ -1578,9 +1588,10 @@ int device_move(struct device *dev, struct device *new_parent)
 	old_parent = dev->parent;
 	dev->parent = new_parent;
 	if (old_parent)
-		klist_remove(&dev->knode_parent);
+		klist_remove(&dev->p->knode_parent);
 	if (new_parent) {
-		klist_add_tail(&dev->knode_parent, &new_parent->klist_children);
+		klist_add_tail(&dev->p->knode_parent,
+			       &new_parent->p->klist_children);
 		set_dev_node(dev, dev_to_node(new_parent));
 	}
 
@@ -1592,11 +1603,11 @@ int device_move(struct device *dev, struct device *new_parent)
 		device_move_class_links(dev, new_parent, old_parent);
 		if (!kobject_move(&dev->kobj, &old_parent->kobj)) {
 			if (new_parent)
-				klist_remove(&dev->knode_parent);
+				klist_remove(&dev->p->knode_parent);
 			dev->parent = old_parent;
 			if (old_parent) {
-				klist_add_tail(&dev->knode_parent,
-					       &old_parent->klist_children);
+				klist_add_tail(&dev->p->knode_parent,
+					       &old_parent->p->klist_children);
 				set_dev_node(dev, dev_to_node(old_parent));
 			}
 		}
diff --git a/include/linux/device.h b/include/linux/device.h
index 4cf063f..808d808 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -368,8 +368,6 @@ struct device_dma_parameters {
 };
 
 struct device {
-	struct klist		klist_children;
-	struct klist_node	knode_parent;	/* node in sibling list */
 	struct klist_node	knode_driver;
 	struct klist_node	knode_bus;
 	struct device		*parent;
-- 
1.6.2

