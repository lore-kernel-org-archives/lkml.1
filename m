Return-Path: <linux-kernel-owner+w=401wt.eu-S1758516AbYGVFhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbYGVFhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757023AbYGVFYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:24:47 -0400
Received: from ns.suse.de ([195.135.220.2]:53928 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393AbYGVFYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:24:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 47/79] class: rename "sem" to "class_sem" in internal class structure
Date: Mon, 21 Jul 2008 22:19:11 -0700
Message-Id: <1216703983-21448-47-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This renames the struct class "sem" field to be "class_sem" to make
things easier when struct bus_type and struct class merge in the future.
It also makes grepping for fields easier as well.

Based on an idea from Kay.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h  |    4 ++--
 drivers/base/class.c |   22 +++++++++++-----------
 drivers/base/core.c  |    8 ++++----
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index a77d4bd..4435732 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -45,7 +45,7 @@ struct driver_private {
  * @class_devices - list of devices associated with this class
  * @class_interfaces - list of class_interfaces associated with this class
  * @class_dirs -
- * @sem - semaphore to protect the children, devices, and interfaces lists.
+ * @class_sem - semaphore to protect the children, devices, and interfaces lists.
  * @class - pointer back to the struct class that this structure is associated
  * with.
  *
@@ -58,7 +58,7 @@ struct class_private {
 	struct list_head class_devices;
 	struct list_head class_interfaces;
 	struct kset class_dirs;
-	struct semaphore sem;
+	struct semaphore class_sem;
 	struct class *class;
 };
 #define to_class(obj)	\
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 86778b8..d24d211 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -147,7 +147,7 @@ int class_register(struct class *cls)
 	INIT_LIST_HEAD(&cp->class_devices);
 	INIT_LIST_HEAD(&cp->class_interfaces);
 	kset_init(&cp->class_dirs);
-	init_MUTEX(&cp->sem);
+	init_MUTEX(&cp->class_sem);
 	error = kobject_set_name(&cp->class_subsys.kobj, "%s", cls->name);
 	if (error) {
 		kfree(cp);
@@ -278,7 +278,7 @@ char *make_class_name(const char *name, struct kobject *kobj)
  * We check the return of @fn each time. If it returns anything
  * other than 0, we break out and return that value.
  *
- * Note, we hold class->sem in this function, so it can not be
+ * Note, we hold class->class_sem in this function, so it can not be
  * re-acquired in @fn, otherwise it will self-deadlocking. For
  * example, calls to add or remove class members would be verboten.
  */
@@ -290,7 +290,7 @@ int class_for_each_device(struct class *class, struct device *start,
 
 	if (!class)
 		return -EINVAL;
-	down(&class->p->sem);
+	down(&class->p->class_sem);
 	list_for_each_entry(dev, &class->p->class_devices, node) {
 		if (start) {
 			if (start == dev)
@@ -303,7 +303,7 @@ int class_for_each_device(struct class *class, struct device *start,
 		if (error)
 			break;
 	}
-	up(&class->p->sem);
+	up(&class->p->class_sem);
 
 	return error;
 }
@@ -326,7 +326,7 @@ EXPORT_SYMBOL_GPL(class_for_each_device);
  *
  * Note, you will need to drop the reference with put_device() after use.
  *
- * We hold class->sem in this function, so it can not be
+ * We hold class->class_sem in this function, so it can not be
  * re-acquired in @match, otherwise it will self-deadlocking. For
  * example, calls to add or remove class members would be verboten.
  */
@@ -340,7 +340,7 @@ struct device *class_find_device(struct class *class, struct device *start,
 	if (!class)
 		return NULL;
 
-	down(&class->p->sem);
+	down(&class->p->class_sem);
 	list_for_each_entry(dev, &class->p->class_devices, node) {
 		if (start) {
 			if (start == dev)
@@ -354,7 +354,7 @@ struct device *class_find_device(struct class *class, struct device *start,
 		} else
 			put_device(dev);
 	}
-	up(&class->p->sem);
+	up(&class->p->class_sem);
 
 	return found ? dev : NULL;
 }
@@ -372,13 +372,13 @@ int class_interface_register(struct class_interface *class_intf)
 	if (!parent)
 		return -EINVAL;
 
-	down(&parent->p->sem);
+	down(&parent->p->class_sem);
 	list_add_tail(&class_intf->node, &parent->p->class_interfaces);
 	if (class_intf->add_dev) {
 		list_for_each_entry(dev, &parent->p->class_devices, node)
 			class_intf->add_dev(dev, class_intf);
 	}
-	up(&parent->p->sem);
+	up(&parent->p->class_sem);
 
 	return 0;
 }
@@ -391,13 +391,13 @@ void class_interface_unregister(struct class_interface *class_intf)
 	if (!parent)
 		return;
 
-	down(&parent->p->sem);
+	down(&parent->p->class_sem);
 	list_del_init(&class_intf->node);
 	if (class_intf->remove_dev) {
 		list_for_each_entry(dev, &parent->p->class_devices, node)
 			class_intf->remove_dev(dev, class_intf);
 	}
-	up(&parent->p->sem);
+	up(&parent->p->class_sem);
 
 	class_put(parent);
 }
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6e1cff2..b90ae6f 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -907,7 +907,7 @@ int device_add(struct device *dev)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
 	if (dev->class) {
-		down(&dev->class->p->sem);
+		down(&dev->class->p->class_sem);
 		/* tie the class to the device */
 		list_add_tail(&dev->node, &dev->class->p->class_devices);
 
@@ -916,7 +916,7 @@ int device_add(struct device *dev)
 				    &dev->class->p->class_interfaces, node)
 			if (class_intf->add_dev)
 				class_intf->add_dev(dev, class_intf);
-		up(&dev->class->p->sem);
+		up(&dev->class->p->class_sem);
 	}
  Done:
 	put_device(dev);
@@ -1017,7 +1017,7 @@ void device_del(struct device *dev)
 	if (dev->class) {
 		device_remove_class_symlinks(dev);
 
-		down(&dev->class->p->sem);
+		down(&dev->class->p->class_sem);
 		/* notify any interfaces that the device is now gone */
 		list_for_each_entry(class_intf,
 				    &dev->class->p->class_interfaces, node)
@@ -1025,7 +1025,7 @@ void device_del(struct device *dev)
 				class_intf->remove_dev(dev, class_intf);
 		/* remove the device from the class list */
 		list_del_init(&dev->node);
-		up(&dev->class->p->sem);
+		up(&dev->class->p->class_sem);
 	}
 	device_remove_file(dev, &uevent_attr);
 	device_remove_attrs(dev);
-- 
1.5.6.3

