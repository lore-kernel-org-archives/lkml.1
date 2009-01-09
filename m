Return-Path: <linux-kernel-owner+w=401wt.eu-S932232AbZAIXW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbZAIXW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760391AbZAIXWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:22:03 -0500
Received: from kroah.org ([198.145.64.141]:54592 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754862AbZAIXWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:22:00 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 3/4] Revert "driver core: move klist_children into private structure"
Date: Fri,  9 Jan 2009 15:20:56 -0800
Message-Id: <1231543257-10047-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090109232021.GA10007@kroah.com>
References: <20090109232021.GA10007@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 11c3b5c3e08f4d855cbef52883c266b9ab9df879.

Turns out that device_initialize shouldn't fail silently.
This series needs to be reworked in order to get into proper
shape.

Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h    |    6 ------
 drivers/base/core.c    |   37 +++++++++++++------------------------
 include/linux/device.h |    2 ++
 3 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index f5cf31c..6b20809 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -66,20 +66,14 @@ struct class_private {
 /**
  * struct device_private - structure to hold the private to the driver core portions of the device structure.
  *
- * @klist_children - klist containing all children of this device
- * @knode_parent - node in sibling list
  * @device - pointer back to the struct class that this structure is
  * associated with.
  *
  * Nothing outside of the driver core should ever touch these fields.
  */
 struct device_private {
-	struct klist klist_children;
-	struct klist_node knode_parent;
 	struct device *device;
 };
-#define to_device_private_parent(obj)	\
-	container_of(obj, struct device_private, knode_parent)
 
 /* initialisation functions */
 extern int devices_init(void);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 61df508..5c2acf7 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -509,16 +509,14 @@ EXPORT_SYMBOL_GPL(device_schedule_callback_owner);
 
 static void klist_children_get(struct klist_node *n)
 {
-	struct device_private *p = to_device_private_parent(n);
-	struct device *dev = p->device;
+	struct device *dev = container_of(n, struct device, knode_parent);
 
 	get_device(dev);
 }
 
 static void klist_children_put(struct klist_node *n)
 {
-	struct device_private *p = to_device_private_parent(n);
-	struct device *dev = p->device;
+	struct device *dev = container_of(n, struct device, knode_parent);
 
 	put_device(dev);
 }
@@ -548,7 +546,7 @@ void device_initialize(struct device *dev)
 	dev->p->device = dev;
 	dev->kobj.kset = devices_kset;
 	kobject_init(&dev->kobj, &device_ktype);
-	klist_init(&dev->p->klist_children, klist_children_get,
+	klist_init(&dev->klist_children, klist_children_get,
 		   klist_children_put);
 	INIT_LIST_HEAD(&dev->dma_pools);
 	init_MUTEX(&dev->sem);
@@ -932,8 +930,7 @@ int device_add(struct device *dev)
 	kobject_uevent(&dev->kobj, KOBJ_ADD);
 	bus_attach_device(dev);
 	if (parent)
-		klist_add_tail(&dev->p->knode_parent,
-			       &parent->p->klist_children);
+		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
 	if (dev->class) {
 		mutex_lock(&dev->class->p->class_mutex);
@@ -1047,7 +1044,7 @@ void device_del(struct device *dev)
 	device_pm_remove(dev);
 	dpm_sysfs_remove(dev);
 	if (parent)
-		klist_del(&dev->p->knode_parent);
+		klist_del(&dev->knode_parent);
 	if (MAJOR(dev->devt)) {
 		device_remove_sys_dev_entry(dev);
 		device_remove_file(dev, &devt_attr);
@@ -1108,14 +1105,7 @@ void device_unregister(struct device *dev)
 static struct device *next_device(struct klist_iter *i)
 {
 	struct klist_node *n = klist_next(i);
-	struct device *dev = NULL;
-	struct device_private *p;
-
-	if (n) {
-		p = to_device_private_parent(n);
-		dev = p->device;
-	}
-	return dev;
+	return n ? container_of(n, struct device, knode_parent) : NULL;
 }
 
 /**
@@ -1137,7 +1127,7 @@ int device_for_each_child(struct device *parent, void *data,
 	struct device *child;
 	int error = 0;
 
-	klist_iter_init(&parent->p->klist_children, &i);
+	klist_iter_init(&parent->klist_children, &i);
 	while ((child = next_device(&i)) && !error)
 		error = fn(child, data);
 	klist_iter_exit(&i);
@@ -1168,7 +1158,7 @@ struct device *device_find_child(struct device *parent, void *data,
 	if (!parent)
 		return NULL;
 
-	klist_iter_init(&parent->p->klist_children, &i);
+	klist_iter_init(&parent->klist_children, &i);
 	while ((child = next_device(&i)))
 		if (match(child, data) && get_device(child))
 			break;
@@ -1582,10 +1572,9 @@ int device_move(struct device *dev, struct device *new_parent)
 	old_parent = dev->parent;
 	dev->parent = new_parent;
 	if (old_parent)
-		klist_remove(&dev->p->knode_parent);
+		klist_remove(&dev->knode_parent);
 	if (new_parent) {
-		klist_add_tail(&dev->p->knode_parent,
-			       &new_parent->p->klist_children);
+		klist_add_tail(&dev->knode_parent, &new_parent->klist_children);
 		set_dev_node(dev, dev_to_node(new_parent));
 	}
 
@@ -1597,11 +1586,11 @@ int device_move(struct device *dev, struct device *new_parent)
 		device_move_class_links(dev, new_parent, old_parent);
 		if (!kobject_move(&dev->kobj, &old_parent->kobj)) {
 			if (new_parent)
-				klist_remove(&dev->p->knode_parent);
+				klist_remove(&dev->knode_parent);
 			dev->parent = old_parent;
 			if (old_parent) {
-				klist_add_tail(&dev->p->knode_parent,
-					       &old_parent->p->klist_children);
+				klist_add_tail(&dev->knode_parent,
+					       &old_parent->klist_children);
 				set_dev_node(dev, dev_to_node(old_parent));
 			}
 		}
diff --git a/include/linux/device.h b/include/linux/device.h
index c66ceb1..2975351 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -366,6 +366,8 @@ struct device_dma_parameters {
 };
 
 struct device {
+	struct klist		klist_children;
+	struct klist_node	knode_parent;	/* node in sibling list */
 	struct klist_node	knode_driver;
 	struct klist_node	knode_bus;
 	struct device		*parent;
-- 
1.6.0.4

