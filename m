Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbYEIHWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbYEIHWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 03:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYEIHWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 03:22:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:5621 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbYEIHWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 03:22:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=HjvvqN+zA8Vcmb957uYqgt8vme/dMoF/skGY3x8+OU9HAY9hoWWh+b7Gcr79CoJfcxJr7GdW8GAMHV0mATP5EMzNQ84d+qi+sGzmRviRcJMj3on3vMrXTJ+8YZ4fq1J66zDILnBWliYaOe9uuZa1uvhY2Gp2gaWcVoLEL2XbCLg=
Date: Fri, 9 May 2008 15:22:31 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] struct class sem to mutex converting
Message-ID: <20080509072231.GB2740@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The class_device is already removed, so do the class->sem to mutex converting.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
drivers/base/class.c   |   22 +++++++++++-----------
drivers/base/core.c    |    9 ++++-----
include/linux/device.h |    3 ++-
3 files changed, 17 insertions(+), 17 deletions(-)

diff -upr linux/drivers/base/class.c linux.new/drivers/base/class.c
--- linux/drivers/base/class.c	2008-05-09 12:53:35.000000000 +0800
+++ linux.new/drivers/base/class.c	2008-05-09 13:03:48.000000000 +0800
@@ -144,7 +144,7 @@ int class_register(struct class *cls)
 	INIT_LIST_HEAD(&cls->devices);
 	INIT_LIST_HEAD(&cls->interfaces);
 	kset_init(&cls->class_dirs);
-	init_MUTEX(&cls->sem);
+	mutex_init(&cls->mutex);
 	error = kobject_set_name(&cls->subsys.kobj, "%s", cls->name);
 	if (error)
 		return error;
@@ -262,7 +262,7 @@ char *make_class_name(const char *name, 
  * We check the return of @fn each time. If it returns anything
  * other than 0, we break out and return that value.
  *
- * Note, we hold class->sem in this function, so it can not be
+ * Note, we hold class->mutex in this function, so it can not be
  * re-acquired in @fn, otherwise it will self-deadlocking. For
  * example, calls to add or remove class members would be verboten.
  */
@@ -274,7 +274,7 @@ int class_for_each_device(struct class *
 
 	if (!class)
 		return -EINVAL;
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev, &class->devices, node) {
 		dev = get_device(dev);
 		if (dev) {
@@ -285,7 +285,7 @@ int class_for_each_device(struct class *
 		if (error)
 			break;
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return error;
 }
@@ -307,7 +307,7 @@ EXPORT_SYMBOL_GPL(class_for_each_device)
  *
  * Note, you will need to drop the reference with put_device() after use.
  *
- * We hold class->sem in this function, so it can not be
+ * We hold class->mutex in this function, so it can not be
  * re-acquired in @match, otherwise it will self-deadlocking. For
  * example, calls to add or remove class members would be verboten.
  */
@@ -320,7 +320,7 @@ struct device *class_find_device(struct 
 	if (!class)
 		return NULL;
 
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev, &class->devices, node) {
 		dev = get_device(dev);
 		if (dev) {
@@ -332,7 +332,7 @@ struct device *class_find_device(struct 
 		} else
 			break;
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return found ? dev : NULL;
 }
@@ -350,13 +350,13 @@ int class_interface_register(struct clas
 	if (!parent)
 		return -EINVAL;
 
-	down(&parent->sem);
+	mutex_lock(&parent->mutex);
 	list_add_tail(&class_intf->node, &parent->interfaces);
 	if (class_intf->add_dev) {
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->add_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	return 0;
 }
@@ -369,13 +369,13 @@ void class_interface_unregister(struct c
 	if (!parent)
 		return;
 
-	down(&parent->sem);
+	mutex_lock(&parent->mutex);
 	list_del_init(&class_intf->node);
 	if (class_intf->remove_dev) {
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->remove_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	class_put(parent);
 }
diff -upr linux/drivers/base/core.c linux.new/drivers/base/core.c
--- linux/drivers/base/core.c	2008-05-09 12:53:35.000000000 +0800
+++ linux.new/drivers/base/core.c	2008-05-09 12:59:41.000000000 +0800
@@ -20,7 +20,6 @@
 #include <linux/notifier.h>
 #include <linux/genhd.h>
 #include <linux/kallsyms.h>
-#include <linux/semaphore.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -833,7 +832,7 @@ int device_add(struct device *dev)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
 	if (dev->class) {
-		down(&dev->class->sem);
+		mutex_lock(&dev->class->mutex);
 		/* tie the class to the device */
 		list_add_tail(&dev->node, &dev->class->devices);
 
@@ -841,7 +840,7 @@ int device_add(struct device *dev)
 		list_for_each_entry(class_intf, &dev->class->interfaces, node)
 			if (class_intf->add_dev)
 				class_intf->add_dev(dev, class_intf);
-		up(&dev->class->sem);
+		mutex_unlock(&dev->class->mutex);
 	}
  Done:
 	put_device(dev);
@@ -937,14 +936,14 @@ void device_del(struct device *dev)
 	if (dev->class) {
 		device_remove_class_symlinks(dev);
 
-		down(&dev->class->sem);
+		mutex_lock(&dev->class->mutex);
 		/* notify any interfaces that the device is now gone */
 		list_for_each_entry(class_intf, &dev->class->interfaces, node)
 			if (class_intf->remove_dev)
 				class_intf->remove_dev(dev, class_intf);
 		/* remove the device from the class list */
 		list_del_init(&dev->node);
-		up(&dev->class->sem);
+		mutex_unlock(&dev->class->mutex);
 	}
 	device_remove_file(dev, &uevent_attr);
 	device_remove_attrs(dev);
diff -upr linux/include/linux/device.h linux.new/include/linux/device.h
--- linux/include/linux/device.h	2008-05-09 12:53:17.000000000 +0800
+++ linux.new/include/linux/device.h	2008-05-09 12:56:08.000000000 +0800
@@ -20,6 +20,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pm.h>
+#include <linux/mutex.h>
 #include <linux/semaphore.h>
 #include <asm/atomic.h>
 #include <asm/device.h>
@@ -187,7 +188,7 @@ struct class {
 	struct list_head	devices;
 	struct list_head	interfaces;
 	struct kset		class_dirs;
-	struct semaphore	sem; /* locks children, devices, interfaces */
+	struct mutex		mutex; /* locks devices, interfaces */
 	struct class_attribute		*class_attrs;
 	struct device_attribute		*dev_attrs;
 
