Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbYGVFic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbYGVFic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757383AbYGVFZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:25:05 -0400
Received: from ns.suse.de ([195.135.220.2]:53941 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757452AbYGVFZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:25:02 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dave Young <hidave.darkstar@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 50/79] class: change internal semaphore to a mutex
Date: Mon, 21 Jul 2008 22:19:14 -0700
Message-Id: <1216703983-21448-50-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>

Now that the lockdep infrastructure in the class core is in place, we
should be able to properly change the internal class semaphore to be a
mutex.

David wrote the original patch, and Greg fixed it up to apply properly
due to all of the recent changes in this area.

From: Dave Young <hidave.darkstar@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h  |    4 ++--
 drivers/base/class.c |   23 ++++++++++++-----------
 drivers/base/core.c  |    9 +++++----
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index c035dc2..31dc0cd 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -44,7 +44,7 @@ struct driver_private {
  * @class_devices - list of devices associated with this class
  * @class_interfaces - list of class_interfaces associated with this class
  * @class_dirs - "glue" directory for virtual devices associated with this class
- * @class_sem - semaphore to protect the children, devices, and interfaces lists.
+ * @class_mutex - mutex to protect the children, devices, and interfaces lists.
  * @class - pointer back to the struct class that this structure is associated
  * with.
  *
@@ -57,7 +57,7 @@ struct class_private {
 	struct list_head class_devices;
 	struct list_head class_interfaces;
 	struct kset class_dirs;
-	struct semaphore class_sem;
+	struct mutex class_mutex;
 	struct class *class;
 };
 #define to_class(obj)	\
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 8900056..839d27c 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -18,6 +18,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/genhd.h>
+#include <linux/mutex.h>
 #include "base.h"
 
 #define to_class_attr(_attr) container_of(_attr, struct class_attribute, attr)
@@ -147,7 +148,7 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 	INIT_LIST_HEAD(&cp->class_devices);
 	INIT_LIST_HEAD(&cp->class_interfaces);
 	kset_init(&cp->class_dirs);
-	init_MUTEX(&cp->class_sem);
+	__mutex_init(&cp->class_mutex, "struct class mutex", key);
 	error = kobject_set_name(&cp->class_subsys.kobj, "%s", cls->name);
 	if (error) {
 		kfree(cp);
@@ -281,7 +282,7 @@ char *make_class_name(const char *name, struct kobject *kobj)
  * We check the return of @fn each time. If it returns anything
  * other than 0, we break out and return that value.
  *
- * Note, we hold class->class_sem in this function, so it can not be
+ * Note, we hold class->class_mutex in this function, so it can not be
  * re-acquired in @fn, otherwise it will self-deadlocking. For
  * example, calls to add or remove class members would be verboten.
  */
@@ -293,7 +294,7 @@ int class_for_each_device(struct class *class, struct device *start,
 
 	if (!class)
 		return -EINVAL;
-	down(&class->p->class_sem);
+	mutex_lock(&class->p->class_mutex);
 	list_for_each_entry(dev, &class->p->class_devices, node) {
 		if (start) {
 			if (start == dev)
@@ -306,7 +307,7 @@ int class_for_each_device(struct class *class, struct device *start,
 		if (error)
 			break;
 	}
-	up(&class->p->class_sem);
+	mutex_unlock(&class->p->class_mutex);
 
 	return error;
 }
@@ -329,7 +330,7 @@ EXPORT_SYMBOL_GPL(class_for_each_device);
  *
  * Note, you will need to drop the reference with put_device() after use.
  *
- * We hold class->class_sem in this function, so it can not be
+ * We hold class->class_mutex in this function, so it can not be
  * re-acquired in @match, otherwise it will self-deadlocking. For
  * example, calls to add or remove class members would be verboten.
  */
@@ -343,7 +344,7 @@ struct device *class_find_device(struct class *class, struct device *start,
 	if (!class)
 		return NULL;
 
-	down(&class->p->class_sem);
+	mutex_lock(&class->p->class_mutex);
 	list_for_each_entry(dev, &class->p->class_devices, node) {
 		if (start) {
 			if (start == dev)
@@ -357,7 +358,7 @@ struct device *class_find_device(struct class *class, struct device *start,
 		} else
 			put_device(dev);
 	}
-	up(&class->p->class_sem);
+	mutex_unlock(&class->p->class_mutex);
 
 	return found ? dev : NULL;
 }
@@ -375,13 +376,13 @@ int class_interface_register(struct class_interface *class_intf)
 	if (!parent)
 		return -EINVAL;
 
-	down(&parent->p->class_sem);
+	mutex_lock(&parent->p->class_mutex);
 	list_add_tail(&class_intf->node, &parent->p->class_interfaces);
 	if (class_intf->add_dev) {
 		list_for_each_entry(dev, &parent->p->class_devices, node)
 			class_intf->add_dev(dev, class_intf);
 	}
-	up(&parent->p->class_sem);
+	mutex_unlock(&parent->p->class_mutex);
 
 	return 0;
 }
@@ -394,13 +395,13 @@ void class_interface_unregister(struct class_interface *class_intf)
 	if (!parent)
 		return;
 
-	down(&parent->p->class_sem);
+	mutex_lock(&parent->p->class_mutex);
 	list_del_init(&class_intf->node);
 	if (class_intf->remove_dev) {
 		list_for_each_entry(dev, &parent->p->class_devices, node)
 			class_intf->remove_dev(dev, class_intf);
 	}
-	up(&parent->p->class_sem);
+	mutex_unlock(&parent->p->class_mutex);
 
 	class_put(parent);
 }
diff --git a/drivers/base/core.c b/drivers/base/core.c
index b90ae6f..c05b115 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -21,6 +21,7 @@
 #include <linux/genhd.h>
 #include <linux/kallsyms.h>
 #include <linux/semaphore.h>
+#include <linux/mutex.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -907,7 +908,7 @@ int device_add(struct device *dev)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
 	if (dev->class) {
-		down(&dev->class->p->class_sem);
+		mutex_lock(&dev->class->p->class_mutex);
 		/* tie the class to the device */
 		list_add_tail(&dev->node, &dev->class->p->class_devices);
 
@@ -916,7 +917,7 @@ int device_add(struct device *dev)
 				    &dev->class->p->class_interfaces, node)
 			if (class_intf->add_dev)
 				class_intf->add_dev(dev, class_intf);
-		up(&dev->class->p->class_sem);
+		mutex_unlock(&dev->class->p->class_mutex);
 	}
  Done:
 	put_device(dev);
@@ -1017,7 +1018,7 @@ void device_del(struct device *dev)
 	if (dev->class) {
 		device_remove_class_symlinks(dev);
 
-		down(&dev->class->p->class_sem);
+		mutex_lock(&dev->class->p->class_mutex);
 		/* notify any interfaces that the device is now gone */
 		list_for_each_entry(class_intf,
 				    &dev->class->p->class_interfaces, node)
@@ -1025,7 +1026,7 @@ void device_del(struct device *dev)
 				class_intf->remove_dev(dev, class_intf);
 		/* remove the device from the class list */
 		list_del_init(&dev->node);
-		up(&dev->class->p->class_sem);
+		mutex_unlock(&dev->class->p->class_mutex);
 	}
 	device_remove_file(dev, &uevent_attr);
 	device_remove_attrs(dev);
-- 
1.5.6.3

