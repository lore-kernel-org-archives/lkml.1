Return-Path: <linux-kernel-owner+w=401wt.eu-S936235AbXGKXvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936235AbXGKXvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935225AbXGKXfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:35:54 -0400
Received: from ns1.suse.de ([195.135.220.2]:33980 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935054AbXGKXfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:35:51 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 40/61] driver-core: make devt_attr and uevent_attr static
Date: Wed, 11 Jul 2007 16:31:59 -0700
Message-Id: <118419692665-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841969191116-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
 <11841968271925-git-send-email-gregkh@suse.de>
 <11841968303508-git-send-email-gregkh@suse.de>
 <11841968352439-git-send-email-gregkh@suse.de>
 <11841968392043-git-send-email-gregkh@suse.de>
 <11841968431153-git-send-email-gregkh@suse.de>
 <11841968471598-git-send-email-gregkh@suse.de>
 <11841968512510-git-send-email-gregkh@suse.de>
 <1184196856662-git-send-email-gregkh@suse.de>
 <1184196860992-git-send-email-gregkh@suse.de>
 <11841968643630-git-send-email-gregkh@suse.de>
 <11841968683554-git-send-email-gregkh@suse.de>
 <11841968731843-git-send-email-gregkh@suse.de>
 <11841968773426-git-send-email-gregkh@suse.de>
 <118419688284-git-send-email-gregkh@suse.de>
 <11841968872456-git-send-email-gregkh@suse.de>
 <11841968903726-git-send-email-gregkh@suse.de>
 <11841968951572-git-send-email-gregkh@suse.de>
 <11841968992181-git-send-email-gregkh@suse.de>
 <1184196905515-git-send-email-gregkh@suse.de>
 <11841969101299-git-send-email-gregkh@suse.de>
 <11841969142368-git-send-email-gregkh@suse.de>
 <11841969191116-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

devt_attr and uevent_attr are either allocated dynamically with or
embedded in device and class_device as they needed their owner field
set to the module implementing the driver.  Now that sysfs implements
immediate disconnect and owner field removed from struct attribute,
there is no reason to do this.  Remove these attributes from
[class_]device and use static attribute structures instead.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c   |   44 ++++++++++++++++----------------------------
 drivers/base/core.c    |   45 +++++++++++++++------------------------------
 include/linux/device.h |    5 -----
 3 files changed, 31 insertions(+), 63 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 9cbfde2..4d22226 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -312,9 +312,6 @@ static void class_dev_release(struct kobject * kobj)
 
 	pr_debug("device class '%s': release.\n", cd->class_id);
 
-	kfree(cd->devt_attr);
-	cd->devt_attr = NULL;
-
 	if (cd->release)
 		cd->release(cd);
 	else if (cls->release)
@@ -547,6 +544,9 @@ static ssize_t show_dev(struct class_device *class_dev, char *buf)
 	return print_dev_t(buf, class_dev->devt);
 }
 
+static struct class_device_attribute class_devt_attr =
+	__ATTR(dev, S_IRUGO, show_dev, NULL);
+
 static ssize_t store_uevent(struct class_device *class_dev,
 			    const char *buf, size_t count)
 {
@@ -554,6 +554,9 @@ static ssize_t store_uevent(struct class_device *class_dev,
 	return count;
 }
 
+static struct class_device_attribute class_uevent_attr =
+	__ATTR(uevent, S_IWUSR, NULL, store_uevent);
+
 void class_device_initialize(struct class_device *class_dev)
 {
 	kobj_set_kset_s(class_dev, class_obj_subsys);
@@ -603,30 +606,15 @@ int class_device_add(struct class_device *class_dev)
 				  &parent_class->subsys.kobj, "subsystem");
 	if (error)
 		goto out3;
-	class_dev->uevent_attr.attr.name = "uevent";
-	class_dev->uevent_attr.attr.mode = S_IWUSR;
-	class_dev->uevent_attr.store = store_uevent;
-	error = class_device_create_file(class_dev, &class_dev->uevent_attr);
+
+	error = class_device_create_file(class_dev, &class_uevent_attr);
 	if (error)
 		goto out3;
 
 	if (MAJOR(class_dev->devt)) {
-		struct class_device_attribute *attr;
-		attr = kzalloc(sizeof(*attr), GFP_KERNEL);
-		if (!attr) {
-			error = -ENOMEM;
-			goto out4;
-		}
-		attr->attr.name = "dev";
-		attr->attr.mode = S_IRUGO;
-		attr->show = show_dev;
-		error = class_device_create_file(class_dev, attr);
-		if (error) {
-			kfree(attr);
+		error = class_device_create_file(class_dev, &class_devt_attr);
+		if (error)
 			goto out4;
-		}
-
-		class_dev->devt_attr = attr;
 	}
 
 	error = class_device_add_attrs(class_dev);
@@ -669,10 +657,10 @@ int class_device_add(struct class_device *class_dev)
  out6:
 	class_device_remove_attrs(class_dev);
  out5:
-	if (class_dev->devt_attr)
-		class_device_remove_file(class_dev, class_dev->devt_attr);
+	if (MAJOR(class_dev->devt))
+		class_device_remove_file(class_dev, &class_devt_attr);
  out4:
-	class_device_remove_file(class_dev, &class_dev->uevent_attr);
+	class_device_remove_file(class_dev, &class_uevent_attr);
  out3:
 	kobject_del(&class_dev->kobj);
  out2:
@@ -772,9 +760,9 @@ void class_device_del(struct class_device *class_dev)
 		sysfs_remove_link(&class_dev->kobj, "device");
 	}
 	sysfs_remove_link(&class_dev->kobj, "subsystem");
-	class_device_remove_file(class_dev, &class_dev->uevent_attr);
-	if (class_dev->devt_attr)
-		class_device_remove_file(class_dev, class_dev->devt_attr);
+	class_device_remove_file(class_dev, &class_uevent_attr);
+	if (MAJOR(class_dev->devt))
+		class_device_remove_file(class_dev, &class_devt_attr);
 	class_device_remove_attrs(class_dev);
 	class_device_remove_groups(class_dev);
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index e3fb87b..0455aa7 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -310,6 +310,9 @@ static ssize_t store_uevent(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
+static struct device_attribute uevent_attr =
+	__ATTR(uevent, S_IRUGO | S_IWUSR, show_uevent, store_uevent);
+
 static int device_add_attributes(struct device *dev,
 				 struct device_attribute *attrs)
 {
@@ -423,6 +426,9 @@ static ssize_t show_dev(struct device *dev, struct device_attribute *attr,
 	return print_dev_t(buf, dev->devt);
 }
 
+static struct device_attribute devt_attr =
+	__ATTR(dev, S_IRUGO, show_dev, NULL);
+
 /*
  *	devices_subsys - structure to be registered with kobject core.
  */
@@ -681,31 +687,14 @@ int device_add(struct device *dev)
 		blocking_notifier_call_chain(&dev->bus->bus_notifier,
 					     BUS_NOTIFY_ADD_DEVICE, dev);
 
-	dev->uevent_attr.attr.name = "uevent";
-	dev->uevent_attr.attr.mode = S_IRUGO | S_IWUSR;
-	dev->uevent_attr.store = store_uevent;
-	dev->uevent_attr.show = show_uevent;
-	error = device_create_file(dev, &dev->uevent_attr);
+	error = device_create_file(dev, &uevent_attr);
 	if (error)
 		goto attrError;
 
 	if (MAJOR(dev->devt)) {
-		struct device_attribute *attr;
-		attr = kzalloc(sizeof(*attr), GFP_KERNEL);
-		if (!attr) {
-			error = -ENOMEM;
-			goto ueventattrError;
-		}
-		attr->attr.name = "dev";
-		attr->attr.mode = S_IRUGO;
-		attr->show = show_dev;
-		error = device_create_file(dev, attr);
-		if (error) {
-			kfree(attr);
+		error = device_create_file(dev, &devt_attr);
+		if (error)
 			goto ueventattrError;
-		}
-
-		dev->devt_attr = attr;
 	}
 
 	if (dev->class) {
@@ -766,10 +755,8 @@ int device_add(struct device *dev)
 					     BUS_NOTIFY_DEL_DEVICE, dev);
 	device_remove_attrs(dev);
  AttrsError:
-	if (dev->devt_attr) {
-		device_remove_file(dev, dev->devt_attr);
-		kfree(dev->devt_attr);
-	}
+	if (MAJOR(dev->devt))
+		device_remove_file(dev, &devt_attr);
 
 	if (dev->class) {
 		sysfs_remove_link(&dev->kobj, "subsystem");
@@ -791,7 +778,7 @@ int device_add(struct device *dev)
 		}
 	}
  ueventattrError:
-	device_remove_file(dev, &dev->uevent_attr);
+	device_remove_file(dev, &uevent_attr);
  attrError:
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
 	kobject_del(&dev->kobj);
@@ -868,10 +855,8 @@ void device_del(struct device * dev)
 
 	if (parent)
 		klist_del(&dev->knode_parent);
-	if (dev->devt_attr) {
-		device_remove_file(dev, dev->devt_attr);
-		kfree(dev->devt_attr);
-	}
+	if (MAJOR(dev->devt))
+		device_remove_file(dev, &devt_attr);
 	if (dev->class) {
 		sysfs_remove_link(&dev->kobj, "subsystem");
 		/* If this is not a "fake" compatible device, remove the
@@ -925,7 +910,7 @@ void device_del(struct device * dev)
 			up(&dev->class->sem);
 		}
 	}
-	device_remove_file(dev, &dev->uevent_attr);
+	device_remove_file(dev, &uevent_attr);
 	device_remove_attrs(dev);
 	bus_remove_device(dev);
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 2e1a298..be2debe 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -238,7 +238,6 @@ extern int __must_check class_device_create_file(struct class_device *,
  * @devt: for internal use by the driver core only.
  * @node: for internal use by the driver core only.
  * @kobj: for internal use by the driver core only.
- * @devt_attr: for internal use by the driver core only.
  * @groups: optional additional groups to be created
  * @dev: if set, a symlink to the struct device is created in the sysfs
  * directory for this struct class device.
@@ -263,8 +262,6 @@ struct class_device {
 	struct kobject		kobj;
 	struct class		* class;	/* required */
 	dev_t			devt;		/* dev_t, creates the sysfs "dev" */
-	struct class_device_attribute *devt_attr;
-	struct class_device_attribute uevent_attr;
 	struct device		* dev;		/* not necessary, but nice to have */
 	void			* class_data;	/* class-specific data */
 	struct class_device	*parent;	/* parent of this child device, if there is one */
@@ -419,8 +416,6 @@ struct device {
 	struct device_type	*type;
 	unsigned		is_registered:1;
 	unsigned		uevent_suppress:1;
-	struct device_attribute uevent_attr;
-	struct device_attribute *devt_attr;
 
 	struct semaphore	sem;	/* semaphore to synchronize calls to
 					 * its driver.
-- 
1.5.2.2

