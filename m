Return-Path: <linux-kernel-owner+w=401wt.eu-S1763142AbYALJoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763142AbYALJoq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 04:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759362AbYALJok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 04:44:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:3570 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311AbYALJoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 04:44:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=gMDqtBk9Wx/XLbT3YpVLJOIs6Lj9ldLWINDlKxi9Kk5gEkDPZ9KDCSZvVSqLr8g5OB1MwHz35gKPBjCAZltxZMnViBTKH+uEUfWdV6iA/c1BkG/y5ku8gWTB9CBa3026ejGEicPbdeDbmVAFS9L58yeHjvHM8ZJerV1ekddRlik=
Date: Sat, 12 Jan 2008 17:47:54 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: stefanr@s5r6.in-berlin.de, James.Bottomley@hansenpartnership.com,
       a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       krh@redhat.com, stern@rowland.harvard.edu, dwmw2@infradead.org,
       davem@davemloft.net, jarkao2@gmail.com
Subject: [PATCH 1/7] driver-core : add class iteration api
Message-ID: <20080112094754.GA2893@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the following class iteration functions for driver use:
class_for_each_device
class_find_device
class_for_each_child
class_find_child

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
 drivers/base/class.c   |  159 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |    8 ++
 2 files changed, 167 insertions(+)

diff -upr linux/drivers/base/class.c linux.new/drivers/base/class.c
--- linux/drivers/base/class.c	2008-01-12 14:42:24.000000000 +0800
+++ linux.new/drivers/base/class.c	2008-01-12 14:42:24.000000000 +0800
@@ -798,6 +798,165 @@ void class_device_put(struct class_devic
 		kobject_put(&class_dev->kobj);
 }
 
+/**
+ *	class_for_each_device - device iterator
+ *	@class:	the class we're iterating
+ *	@data: data for the callback
+ *	@fn: function to be called for each device
+ *
+ *	Iterate over @class's list of devices, and call @fn for each,
+ *	passing it @data.
+ *
+ *	We check the return of @fn each time. If it returns anything
+ *	other than 0, we break out and return that value.
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
+ */
+struct device *class_find_device(struct class *class, void *data,
+				   int (*match)(struct device *, void *))
+{
+	struct device *dev;
+	int error = 1;
+
+	if (!class)
+		return NULL;
+
+	down(&class->sem);
+	list_for_each_entry(dev, &class->devices, node) {
+		dev = get_device(dev);
+		if (dev) {
+			if (match(dev, data)) {
+				error = 0;
+				break;
+			} else
+				put_device(dev);
+		} else
+			break;
+	}
+	up(&class->sem);
+
+	if (error)
+		return NULL;
+	return dev;
+}
+EXPORT_SYMBOL_GPL(class_find_device);
+
+/**
+ *	class_for_each_child - class child iterator
+ *	@class:	the class we're iterating
+ *	@data: data for the callback
+ *	@fn: function to be called for each child of the class
+ *
+ *	Iterate over @class's list of children, and call @fn for each,
+ *	passing it @data.
+ *
+ *	We check the return of @fn each time. If it returns anything
+ *	other than 0, we break out and return that value.
+ */
+int class_for_each_child(struct class *class, void *data,
+			   int (*fn)(struct class_device *, void *))
+{
+	struct class_device *dev;
+	int error = 0;
+
+	if (!class)
+		return -EINVAL;
+	down(&class->sem);
+	list_for_each_entry(dev, &class->children, node) {
+		dev = class_device_get(dev);
+		if (dev) {
+			error = fn(dev, data);
+			class_device_put(dev);
+		} else
+			error = -ENODEV;
+		if (error)
+			break;
+	}
+	up(&class->sem);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(class_for_each_child);
+
+/**
+ * class_find_child - device iterator for locating a particular class_device
+ * @class: the class we're iterating
+ * @data: data for the match function
+ * @match: function to check class_device
+ *
+ * This is similar to the class_for_each_child() function above, but it
+ * returns a reference to a class_device that is 'found' for later use, as
+ * determined by the @match callback.
+ *
+ * The callback should return 0 if the class_device doesn't match and non-zero
+ * if it does.  If the callback returns non-zero, this function will
+ * return to the caller and not iterate over any more class_devices.
+ */
+struct class_device *class_find_child(struct class *class, void *data,
+				   int (*match)(struct class_device *, void *))
+{
+	struct class_device *dev;
+	int error = 1;
+
+	if (!class)
+		return NULL;
+
+	down(&class->sem);
+	list_for_each_entry(dev, &class->children, node) {
+		dev = class_device_get(dev);
+		if (dev) {
+			if (match(dev, data)) {
+				error = 0;
+				break;
+			} else
+				class_device_put(dev);
+		} else
+			break;
+	}
+	up(&class->sem);
+
+	if (error)
+		return NULL;
+	return dev;
+}
+EXPORT_SYMBOL_GPL(class_find_child);
 
 int class_interface_register(struct class_interface *class_intf)
 {
diff -upr linux/include/linux/device.h linux.new/include/linux/device.h
--- linux/include/linux/device.h	2008-01-12 14:42:24.000000000 +0800
+++ linux.new/include/linux/device.h	2008-01-12 14:42:24.000000000 +0800
@@ -199,6 +199,14 @@ struct class {
 
 extern int __must_check class_register(struct class *);
 extern void class_unregister(struct class *);
+extern int class_for_each_device(struct class *class, void *data,
+				int (*fn)(struct device *dev, void *data));
+extern struct device *class_find_device(struct class *class, void *data,
+				   int (*match)(struct device *, void *));
+extern int class_for_each_child(struct class *class, void *data,
+			   int (*fn)(struct class_device *, void *));
+extern struct class_device *class_find_child(struct class *class, void *data,
+				   int (*match)(struct class_device *, void *));
 
 
 struct class_attribute {
