Return-Path: <linux-kernel-owner+w=401wt.eu-S1762861AbXEJO0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762861AbXEJO0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759082AbXEJO0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:26:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:18738 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759541AbXEJO0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:26:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=cMHzS/3JkQjOR9qJCndkzJ7YkL+7bUFgLM3a+ZSfhPK1ghDTE7CoUvhHnGMiHSSMFTN2t6mzVMkwMJfSGBGMvjqmDW+bCCUdSOoq4l1aAxXwj6S/DSuXZI43wHDqDilCWYb6U1u51B34XaGpXPXXZPlafPWD9sPwVTvfKHKZCGk=
Message-ID: <46432B6C.6040905@gmail.com>
Date: Thu, 10 May 2007 16:25:48 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Chris Rankin <rankincj@yahoo.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6.21-mm2] driver-core: make devt_attr and uevent_attr static
References: <602729.80444.qm@web52910.mail.re2.yahoo.com> <4641CD01.6010309@gmail.com> <20070509145747.GA27259@kroah.com>
In-Reply-To: <20070509145747.GA27259@kroah.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

devt_attr and uevent_attr are either allocated dynamically with or
embedded in device and class_device as they needed their owner field
set to the module implementing the driver.  Now that sysfs implements
immediate disconnect and owner field removed from struct attribute,
there is no reason to do this.  Remove these attributes from
[class_]device and use static attribute structures instead.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 drivers/base/class.c   |   44 ++++++++++++++++----------------------------
 drivers/base/core.c    |   45 +++++++++++++++------------------------------
 include/linux/device.h |    5 -----
 3 files changed, 31 insertions(+), 63 deletions(-)

Index: tree0/drivers/base/class.c
===================================================================
--- tree0.orig/drivers/base/class.c
+++ tree0/drivers/base/class.c
@@ -312,9 +312,6 @@ static void class_dev_release(struct kob
 
 	pr_debug("device class '%s': release.\n", cd->class_id);
 
-	kfree(cd->devt_attr);
-	cd->devt_attr = NULL;
-
 	if (cd->release)
 		cd->release(cd);
 	else if (cls->release)
@@ -564,6 +561,9 @@ static ssize_t show_dev(struct class_dev
 	return print_dev_t(buf, class_dev->devt);
 }
 
+static struct class_device_attribute class_devt_attr =
+	__ATTR(dev, S_IRUGO, show_dev, NULL);
+
 static ssize_t store_uevent(struct class_device *class_dev,
 			    const char *buf, size_t count)
 {
@@ -571,6 +571,9 @@ static ssize_t store_uevent(struct class
 	return count;
 }
 
+static struct class_device_attribute class_uevent_attr =
+	__ATTR(uevent, S_IWUSR, NULL, store_uevent);
+
 void class_device_initialize(struct class_device *class_dev)
 {
 	kobj_set_kset_s(class_dev, class_obj_subsys);
@@ -620,30 +623,15 @@ int class_device_add(struct class_device
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
@@ -686,10 +674,10 @@ int class_device_add(struct class_device
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
@@ -789,9 +777,9 @@ void class_device_del(struct class_devic
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
 
Index: tree0/drivers/base/core.c
===================================================================
--- tree0.orig/drivers/base/core.c
+++ tree0/drivers/base/core.c
@@ -308,6 +308,9 @@ static ssize_t store_uevent(struct devic
 	return count;
 }
 
+static struct device_attribute uevent_attr =
+	__ATTR(uevent, S_IRUGO | S_IWUSR, show_uevent, store_uevent);
+
 static int device_add_attributes(struct device *dev,
 				 struct device_attribute *attrs)
 {
@@ -421,6 +424,9 @@ static ssize_t show_dev(struct device *d
 	return print_dev_t(buf, dev->devt);
 }
 
+static struct device_attribute devt_attr =
+	__ATTR(dev, S_IRUGO, show_dev, NULL);
+
 /*
  *	devices_subsys - structure to be registered with kobject core.
  */
@@ -679,31 +685,14 @@ int device_add(struct device *dev)
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
@@ -761,10 +750,8 @@ int device_add(struct device *dev)
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
@@ -786,7 +773,7 @@ int device_add(struct device *dev)
 		}
 	}
  ueventattrError:
-	device_remove_file(dev, &dev->uevent_attr);
+	device_remove_file(dev, &uevent_attr);
  attrError:
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
 	kobject_del(&dev->kobj);
@@ -864,10 +851,8 @@ void device_del(struct device * dev)
 
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
@@ -921,7 +906,7 @@ void device_del(struct device * dev)
 			up(&dev->class->sem);
 		}
 	}
-	device_remove_file(dev, &dev->uevent_attr);
+	device_remove_file(dev, &uevent_attr);
 	device_remove_attrs(dev);
 	bus_remove_device(dev);
 
Index: tree0/include/linux/device.h
===================================================================
--- tree0.orig/include/linux/device.h
+++ tree0/include/linux/device.h
@@ -240,7 +240,6 @@ extern int __must_check class_device_cre
  * @devt: for internal use by the driver core only.
  * @node: for internal use by the driver core only.
  * @kobj: for internal use by the driver core only.
- * @devt_attr: for internal use by the driver core only.
  * @groups: optional additional groups to be created
  * @dev: if set, a symlink to the struct device is created in the sysfs
  * directory for this struct class device.
@@ -265,8 +264,6 @@ struct class_device {
 	struct kobject		kobj;
 	struct class		* class;	/* required */
 	dev_t			devt;		/* dev_t, creates the sysfs "dev" */
-	struct class_device_attribute *devt_attr;
-	struct class_device_attribute uevent_attr;
 	struct device		* dev;		/* not necessary, but nice to have */
 	void			* class_data;	/* class-specific data */
 	struct class_device	*parent;	/* parent of this child device, if there is one */
@@ -421,8 +418,6 @@ struct device {
 	struct device_type	*type;
 	unsigned		is_registered:1;
 	unsigned		uevent_suppress:1;
-	struct device_attribute uevent_attr;
-	struct device_attribute *devt_attr;
 
 	struct semaphore	sem;	/* semaphore to synchronize calls to
 					 * its driver.
