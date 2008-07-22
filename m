Return-Path: <linux-kernel-owner+w=401wt.eu-S1759682AbYGVFg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682AbYGVFg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757373AbYGVFYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:24:43 -0400
Received: from ns.suse.de ([195.135.220.2]:53925 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757364AbYGVFYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:24:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 46/79] class: rename "subsys" to "class_subsys" in internal class structure
Date: Mon, 21 Jul 2008 22:19:10 -0700
Message-Id: <1216703983-21448-46-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This renames the struct class "subsys" field to be "class_subsys" to
make things easier when struct bus_type and struct class merge in the
future.  It also makes grepping for fields easier as well.

Based on an idea from Kay.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h  |    7 ++++---
 drivers/base/class.c |   23 ++++++++++++-----------
 drivers/base/core.c  |   31 +++++++++++++++++--------------
 3 files changed, 33 insertions(+), 28 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 670b95a..a77d4bd 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -40,7 +40,7 @@ struct driver_private {
 /**
  * struct class_private - structure to hold the private to the driver core portions of the class structure.
  *
- * @subsys - the struct kset that defines this class.  This is the main kobject
+ * @class_subsys - the struct kset that defines this class.  This is the main kobject
  * @children - list of class_devices associated with this class
  * @class_devices - list of devices associated with this class
  * @class_interfaces - list of class_interfaces associated with this class
@@ -54,14 +54,15 @@ struct driver_private {
  * core should ever touch these fields.
  */
 struct class_private {
-	struct kset subsys;
+	struct kset class_subsys;
 	struct list_head class_devices;
 	struct list_head class_interfaces;
 	struct kset class_dirs;
 	struct semaphore sem;
 	struct class *class;
 };
-#define to_class(obj) container_of(obj, struct class_private, subsys.kobj)
+#define to_class(obj)	\
+	container_of(obj, struct class_private, class_subsys.kobj)
 
 /* initialisation functions */
 extern int devices_init(void);
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 48b518e..86778b8 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -70,7 +70,7 @@ static struct kobj_type class_ktype = {
 	.release	= class_release,
 };
 
-/* Hotplug events for classes go to the class_obj subsys */
+/* Hotplug events for classes go to the class class_subsys */
 static struct kset *class_kset;
 
 
@@ -78,7 +78,8 @@ int class_create_file(struct class *cls, const struct class_attribute *attr)
 {
 	int error;
 	if (cls)
-		error = sysfs_create_file(&cls->p->subsys.kobj, &attr->attr);
+		error = sysfs_create_file(&cls->p->class_subsys.kobj,
+					  &attr->attr);
 	else
 		error = -EINVAL;
 	return error;
@@ -87,20 +88,20 @@ int class_create_file(struct class *cls, const struct class_attribute *attr)
 void class_remove_file(struct class *cls, const struct class_attribute *attr)
 {
 	if (cls)
-		sysfs_remove_file(&cls->p->subsys.kobj, &attr->attr);
+		sysfs_remove_file(&cls->p->class_subsys.kobj, &attr->attr);
 }
 
 static struct class *class_get(struct class *cls)
 {
 	if (cls)
-		kset_get(&cls->p->subsys);
+		kset_get(&cls->p->class_subsys);
 	return cls;
 }
 
 static void class_put(struct class *cls)
 {
 	if (cls)
-		kset_put(&cls->p->subsys);
+		kset_put(&cls->p->class_subsys);
 }
 
 static int add_class_attrs(struct class *cls)
@@ -147,7 +148,7 @@ int class_register(struct class *cls)
 	INIT_LIST_HEAD(&cp->class_interfaces);
 	kset_init(&cp->class_dirs);
 	init_MUTEX(&cp->sem);
-	error = kobject_set_name(&cp->subsys.kobj, "%s", cls->name);
+	error = kobject_set_name(&cp->class_subsys.kobj, "%s", cls->name);
 	if (error) {
 		kfree(cp);
 		return error;
@@ -160,15 +161,15 @@ int class_register(struct class *cls)
 #if defined(CONFIG_SYSFS_DEPRECATED) && defined(CONFIG_BLOCK)
 	/* let the block class directory show up in the root of sysfs */
 	if (cls != &block_class)
-		cp->subsys.kobj.kset = class_kset;
+		cp->class_subsys.kobj.kset = class_kset;
 #else
-	cp->subsys.kobj.kset = class_kset;
+	cp->class_subsys.kobj.kset = class_kset;
 #endif
-	cp->subsys.kobj.ktype = &class_ktype;
+	cp->class_subsys.kobj.ktype = &class_ktype;
 	cp->class = cls;
 	cls->p = cp;
 
-	error = kset_register(&cp->subsys);
+	error = kset_register(&cp->class_subsys);
 	if (error) {
 		kfree(cp);
 		return error;
@@ -182,7 +183,7 @@ void class_unregister(struct class *cls)
 {
 	pr_debug("device class '%s': unregistering\n", cls->name);
 	remove_class_attrs(cls);
-	kset_unregister(&cls->p->subsys);
+	kset_unregister(&cls->p->class_subsys);
 }
 
 static void class_create_release(struct class *cls)
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 76fdd41..6e1cff2 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -551,7 +551,7 @@ static struct kobject *get_device_parent(struct device *dev,
 {
 	/* class devices without a parent live in /sys/class/<classname>/ */
 	if (dev->class && (!parent || parent->class != dev->class))
-		return &dev->class->p->subsys.kobj;
+		return &dev->class->p->class_subsys.kobj;
 	/* all other devices keep their parent */
 	else if (parent)
 		return &parent->kobj;
@@ -657,16 +657,17 @@ static int device_add_class_symlinks(struct device *dev)
 	if (!dev->class)
 		return 0;
 
-	error = sysfs_create_link(&dev->kobj, &dev->class->p->subsys.kobj,
+	error = sysfs_create_link(&dev->kobj,
+				  &dev->class->p->class_subsys.kobj,
 				  "subsystem");
 	if (error)
 		goto out;
 
 #ifdef CONFIG_SYSFS_DEPRECATED
 	/* stacked class devices need a symlink in the class directory */
-	if (dev->kobj.parent != &dev->class->p->subsys.kobj &&
+	if (dev->kobj.parent != &dev->class->p->class_subsys.kobj &&
 	    device_is_not_partition(dev)) {
-		error = sysfs_create_link(&dev->class->p->subsys.kobj,
+		error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
 					  &dev->kobj, dev->bus_id);
 		if (error)
 			goto out_subsys;
@@ -704,13 +705,14 @@ out_device:
 	if (dev->parent && device_is_not_partition(dev))
 		sysfs_remove_link(&dev->kobj, "device");
 out_busid:
-	if (dev->kobj.parent != &dev->class->p->subsys.kobj &&
+	if (dev->kobj.parent != &dev->class->p->class_subsys.kobj &&
 	    device_is_not_partition(dev))
-		sysfs_remove_link(&dev->class->p->subsys.kobj, dev->bus_id);
+		sysfs_remove_link(&dev->class->p->class_subsys.kobj,
+				  dev->bus_id);
 #else
 	/* link in the class directory pointing to the device */
-	error = sysfs_create_link(&dev->class->p->subsys.kobj, &dev->kobj,
-				  dev->bus_id);
+	error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
+				  &dev->kobj, dev->bus_id);
 	if (error)
 		goto out_subsys;
 
@@ -723,7 +725,7 @@ out_busid:
 	return 0;
 
 out_busid:
-	sysfs_remove_link(&dev->class->p->subsys.kobj, dev->bus_id);
+	sysfs_remove_link(&dev->class->p->class_subsys.kobj, dev->bus_id);
 #endif
 
 out_subsys:
@@ -749,14 +751,15 @@ static void device_remove_class_symlinks(struct device *dev)
 		sysfs_remove_link(&dev->kobj, "device");
 	}
 
-	if (dev->kobj.parent != &dev->class->p->subsys.kobj &&
+	if (dev->kobj.parent != &dev->class->p->class_subsys.kobj &&
 	    device_is_not_partition(dev))
-		sysfs_remove_link(&dev->class->p->subsys.kobj, dev->bus_id);
+		sysfs_remove_link(&dev->class->p->class_subsys.kobj,
+				  dev->bus_id);
 #else
 	if (dev->parent && device_is_not_partition(dev))
 		sysfs_remove_link(&dev->kobj, "device");
 
-	sysfs_remove_link(&dev->class->p->subsys.kobj, dev->bus_id);
+	sysfs_remove_link(&dev->class->p->class_subsys.kobj, dev->bus_id);
 #endif
 
 	sysfs_remove_link(&dev->kobj, "subsystem");
@@ -1350,11 +1353,11 @@ int device_rename(struct device *dev, char *new_name)
 	}
 #else
 	if (dev->class) {
-		error = sysfs_create_link(&dev->class->p->subsys.kobj,
+		error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
 					  &dev->kobj, dev->bus_id);
 		if (error)
 			goto out;
-		sysfs_remove_link(&dev->class->p->subsys.kobj,
+		sysfs_remove_link(&dev->class->p->class_subsys.kobj,
 				  old_device_name);
 	}
 #endif
-- 
1.5.6.3

