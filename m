Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbZIOTQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbZIOTQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758470AbZIOTPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:15:31 -0400
Received: from kroah.org ([198.145.64.141]:33062 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758529AbZIOTPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:15:02 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 10/20] Driver core: Add support for compatibility classes
Date: Tue, 15 Sep 2009 12:12:46 -0700
Message-Id: <1253041976-1111-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090915181247.GA32167@kroah.com>
References: <20090915181247.GA32167@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

When turning class devices into bus devices, we may need to
temporarily add links in sysfs so that user-space applications
are not confused. This is done by adding the following API:

* Functions to register and unregister compatibility classes.
  These appear in sysfs at the same location as regular classes, but
  instead of class devices, they contain links to bus devices.
* Functions to create and delete such links. Additionally, the caller
  can optionally pass a target device to which a "device" link should
  point (typically that would be the device's parent), to fully emulate
  the original class device.

The i2c subsystem will be the first user of this API, as i2c adapters
are being converted from class devices to bus devices.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/base/class.c   |   87 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |    8 ++++
 2 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index eb85e43..161746d 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -488,6 +488,93 @@ void class_interface_unregister(struct class_interface *class_intf)
 	class_put(parent);
 }
 
+struct class_compat {
+	struct kobject *kobj;
+};
+
+/**
+ * class_compat_register - register a compatibility class
+ * @name: the name of the class
+ *
+ * Compatibility class are meant as a temporary user-space compatibility
+ * workaround when converting a family of class devices to a bus devices.
+ */
+struct class_compat *class_compat_register(const char *name)
+{
+	struct class_compat *cls;
+
+	cls = kmalloc(sizeof(struct class_compat), GFP_KERNEL);
+	if (!cls)
+		return NULL;
+	cls->kobj = kobject_create_and_add(name, &class_kset->kobj);
+	if (!cls->kobj) {
+		kfree(cls);
+		return NULL;
+	}
+	return cls;
+}
+EXPORT_SYMBOL_GPL(class_compat_register);
+
+/**
+ * class_compat_unregister - unregister a compatibility class
+ * @cls: the class to unregister
+ */
+void class_compat_unregister(struct class_compat *cls)
+{
+	kobject_put(cls->kobj);
+	kfree(cls);
+}
+EXPORT_SYMBOL_GPL(class_compat_unregister);
+
+/**
+ * class_compat_create_link - create a compatibility class device link to
+ *			      a bus device
+ * @cls: the compatibility class
+ * @dev: the target bus device
+ * @device_link: an optional device to which a "device" link should be created
+ */
+int class_compat_create_link(struct class_compat *cls, struct device *dev,
+			     struct device *device_link)
+{
+	int error;
+
+	error = sysfs_create_link(cls->kobj, &dev->kobj, dev_name(dev));
+	if (error)
+		return error;
+
+	/*
+	 * Optionally add a "device" link (typically to the parent), as a
+	 * class device would have one and we want to provide as much
+	 * backwards compatibility as possible.
+	 */
+	if (device_link) {
+		error = sysfs_create_link(&dev->kobj, &device_link->kobj,
+					  "device");
+		if (error)
+			sysfs_remove_link(cls->kobj, dev_name(dev));
+	}
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(class_compat_create_link);
+
+/**
+ * class_compat_remove_link - remove a compatibility class device link to
+ *			      a bus device
+ * @cls: the compatibility class
+ * @dev: the target bus device
+ * @device_link: an optional device to which a "device" link was previously
+ * 		 created
+ */
+void class_compat_remove_link(struct class_compat *cls, struct device *dev,
+			      struct device *device_link)
+{
+	if (device_link)
+		sysfs_remove_link(&dev->kobj, "device");
+	sysfs_remove_link(cls->kobj, dev_name(dev));
+}
+EXPORT_SYMBOL_GPL(class_compat_remove_link);
+
 int __init classes_init(void)
 {
 	class_kset = kset_create_and_add("class", NULL, NULL);
diff --git a/include/linux/device.h b/include/linux/device.h
index e19e40a..62ff53a 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -225,6 +225,14 @@ extern void class_unregister(struct class *class);
 	__class_register(class, &__key);	\
 })
 
+struct class_compat;
+struct class_compat *class_compat_register(const char *name);
+void class_compat_unregister(struct class_compat *cls);
+int class_compat_create_link(struct class_compat *cls, struct device *dev,
+			     struct device *device_link);
+void class_compat_remove_link(struct class_compat *cls, struct device *dev,
+			      struct device *device_link);
+
 extern void class_dev_iter_init(struct class_dev_iter *iter,
 				struct class *class,
 				struct device *start,
-- 
1.6.4.2

