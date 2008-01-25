Return-Path: <linux-kernel-owner+w=401wt.eu-S1765985AbYAYIZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765985AbYAYIZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759939AbYAYIBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:05 -0500
Received: from ns1.suse.de ([195.135.220.2]:59459 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764080AbYAYH7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 187/196] Driver Core: add class iteration api
Date: Thu, 24 Jan 2008 23:33:36 -0800
Message-Id: <1201246425-5058-108-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>

Add the following class iteration functions for driver use:
	class_for_each_device
	class_find_device
	class_for_each_child
	class_find_child

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c   |  133 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |    9 +++-
 2 files changed, 140 insertions(+), 2 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index b962a76..9f737ff 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -809,6 +809,139 @@ void class_device_put(struct class_device *class_dev)
 		kobject_put(&class_dev->kobj);
 }
 
+/**
+ * class_for_each_device - device iterator
+ * @class: the class we're iterating
+ * @data: data for the callback
+ * @fn: function to be called for each device
+ *
+ * Iterate over @class's list of devices, and call @fn for each,
+ * passing it @data.
+ *
+ * We check the return of @fn each time. If it returns anything
+ * other than 0, we break out and return that value.
+ *
+ * Note, we hold class->sem in this function, so it can not be
+ * re-acquired in @fn, otherwise it will self-deadlocking. For
+ * example, calls to add or remove class members would be verboten.
+ */
+int class_for_each_device(struct class *class, void *data,
+			   int (*fn)(struct device *, void *))
+{
+	struct device *dev;
+	int error = 0;
+
+	if (!class)
+		return -EINVAL;
+	down(&class->sem);
+	list_for_each_entry(dev, &class->devices, node) {
+		dev = get_device(dev);
+		if (dev) {
+			error = fn(dev, data);
+			put_device(dev);
+		} else
+			error = -ENODEV;
+		if (error)
+			break;
+	}
+	up(&class->sem);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(class_for_each_device);
+
+/**
+ * class_find_device - device iterator for locating a particular device
+ * @class: the class we're iterating
+ * @data: data for the match function
+ * @match: function to check device
+ *
+ * This is similar to the class_for_each_dev() function above, but it
+ * returns a reference to a device that is 'found' for later use, as
+ * determined by the @match callback.
+ *
+ * The callback should return 0 if the device doesn't match and non-zero
+ * if it does.  If the callback returns non-zero, this function will
+ * return to the caller and not iterate over any more devices.
+
+ * Note, you will need to drop the reference with put_device() after use.
+ *
+ * We hold class->sem in this function, so it can not be
+ * re-acquired in @match, otherwise it will self-deadlocking. For
+ * example, calls to add or remove class members would be verboten.
+ */
+struct device *class_find_device(struct class *class, void *data,
+				   int (*match)(struct device *, void *))
+{
+	struct device *dev;
+	int found = 0;
+
+	if (!class)
+		return NULL;
+
+	down(&class->sem);
+	list_for_each_entry(dev, &class->devices, node) {
+		dev = get_device(dev);
+		if (dev) {
+			if (match(dev, data)) {
+				found = 1;
+				break;
+			} else
+				put_device(dev);
+		} else
+			break;
+	}
+	up(&class->sem);
+
+	return found ? dev : NULL;
+}
+EXPORT_SYMBOL_GPL(class_find_device);
+
+/**
+ * class_find_child - device iterator for locating a particular class_device
+ * @class: the class we're iterating
+ * @data: data for the match function
+ * @match: function to check class_device
+ *
+ * This function returns a reference to a class_device that is 'found' for
+ * later use, as determined by the @match callback.
+ *
+ * The callback should return 0 if the class_device doesn't match and non-zero
+ * if it does.  If the callback returns non-zero, this function will
+ * return to the caller and not iterate over any more class_devices.
+ *
+ * Note, you will need to drop the reference with class_device_put() after use.
+ *
+ * We hold class->sem in this function, so it can not be
+ * re-acquired in @match, otherwise it will self-deadlocking. For
+ * example, calls to add or remove class members would be verboten.
+ */
+struct class_device *class_find_child(struct class *class, void *data,
+				   int (*match)(struct class_device *, void *))
+{
+	struct class_device *dev;
+	int found = 0;
+
+	if (!class)
+		return NULL;
+
+	down(&class->sem);
+	list_for_each_entry(dev, &class->children, node) {
+		dev = class_device_get(dev);
+		if (dev) {
+			if (match(dev, data)) {
+				found = 1;
+				break;
+			} else
+				class_device_put(dev);
+		} else
+			break;
+	}
+	up(&class->sem);
+
+	return found ? dev : NULL;
+}
+EXPORT_SYMBOL_GPL(class_find_child);
 
 int class_interface_register(struct class_interface *class_intf)
 {
diff --git a/include/linux/device.h b/include/linux/device.h
index 92ba3a8..cdaf57b 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -177,8 +177,7 @@ struct class {
 	struct list_head	devices;
 	struct list_head	interfaces;
 	struct kset		class_dirs;
-	struct semaphore	sem;	/* locks both the children and interfaces lists */
-
+	struct semaphore	sem; /* locks children, devices, interfaces */
 	struct class_attribute		* class_attrs;
 	struct class_device_attribute	* class_dev_attrs;
 	struct device_attribute		* dev_attrs;
@@ -196,6 +195,12 @@ struct class {
 
 extern int __must_check class_register(struct class *);
 extern void class_unregister(struct class *);
+extern int class_for_each_device(struct class *class, void *data,
+				 int (*fn)(struct device *dev, void *data));
+extern struct device *class_find_device(struct class *class, void *data,
+					int (*match)(struct device *, void *));
+extern struct class_device *class_find_child(struct class *class, void *data,
+				   int (*match)(struct class_device *, void *));
 
 
 struct class_attribute {
-- 
1.5.3.8

