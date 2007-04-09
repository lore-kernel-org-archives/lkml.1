Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbXDIPHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbXDIPHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbXDIPHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:07:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38208 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752055AbXDIPHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 11:07:23 -0400
Date: Mon, 9 Apr 2007 11:07:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>
cc: Neil Brown <neilb@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH (revised)] device_schedule_callback needs a module reference
In-Reply-To: <a781481a0704090752u27140ee8vc93bd344c5005549@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0704091104490.3561-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This revised patch (as896b) fixes an oversight in the design of
device_schedule_callback().  It is necessary to acquire a reference to
the module owning the callback routine, to prevent the module from
being unloaded before the callback can run.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/base/core.c
===================================================================
--- usb-2.6.orig/drivers/base/core.c
+++ usb-2.6/drivers/base/core.c
@@ -431,9 +431,10 @@ void device_remove_bin_file(struct devic
 EXPORT_SYMBOL_GPL(device_remove_bin_file);
 
 /**
- * device_schedule_callback - helper to schedule a callback for a device
+ * device_schedule_callback_owner - helper to schedule a callback for a device
  * @dev: device.
  * @func: callback function to invoke later.
+ * @owner: module owning the callback routine
  *
  * Attribute methods must not unregister themselves or their parent device
  * (which would amount to the same thing).  Attempts to do so will deadlock,
@@ -444,20 +445,23 @@ EXPORT_SYMBOL_GPL(device_remove_bin_file
  * argument in the workqueue's process context.  @dev will be pinned until
  * @func returns.
  *
+ * This routine is usually called via the inline device_schedule_callback(),
+ * which automatically sets @owner to THIS_MODULE.
+ *
  * Returns 0 if the request was submitted, -ENOMEM if storage could not
- * be allocated.
+ * be allocated, -ENODEV if a reference to @owner isn't available.
  *
  * NOTE: This routine won't work if CONFIG_SYSFS isn't set!  It uses an
  * underlying sysfs routine (since it is intended for use by attribute
  * methods), and if sysfs isn't available you'll get nothing but -ENOSYS.
  */
-int device_schedule_callback(struct device *dev,
-		void (*func)(struct device *))
+int device_schedule_callback_owner(struct device *dev,
+		void (*func)(struct device *), struct module *owner)
 {
 	return sysfs_schedule_callback(&dev->kobj,
-			(void (*)(void *)) func, dev);
+			(void (*)(void *)) func, dev, owner);
 }
-EXPORT_SYMBOL_GPL(device_schedule_callback);
+EXPORT_SYMBOL_GPL(device_schedule_callback_owner);
 
 static void klist_children_get(struct klist_node *n)
 {
Index: usb-2.6/fs/sysfs/file.c
===================================================================
--- usb-2.6.orig/fs/sysfs/file.c
+++ usb-2.6/fs/sysfs/file.c
@@ -647,6 +647,7 @@ struct sysfs_schedule_callback_struct {
 	struct kobject 		*kobj;
 	void			(*func)(void *);
 	void			*data;
+	struct module		*owner;
 	struct work_struct	work;
 };
 
@@ -657,6 +658,7 @@ static void sysfs_schedule_callback_work
 
 	(ss->func)(ss->data);
 	kobject_put(ss->kobj);
+	module_put(ss->owner);
 	kfree(ss);
 }
 
@@ -665,6 +667,7 @@ static void sysfs_schedule_callback_work
  * @kobj: object we're acting for.
  * @func: callback function to invoke later.
  * @data: argument to pass to @func.
+ * @owner: module owning the callback code
  *
  * sysfs attribute methods must not unregister themselves or their parent
  * kobject (which would amount to the same thing).  Attempts to do so will
@@ -677,20 +680,25 @@ static void sysfs_schedule_callback_work
  * until @func returns.
  *
  * Returns 0 if the request was submitted, -ENOMEM if storage could not
- * be allocated.
+ * be allocated, -ENODEV if a reference to @owner isn't available.
  */
 int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
-		void *data)
+		void *data, struct module *owner)
 {
 	struct sysfs_schedule_callback_struct *ss;
 
+	if (!try_module_get(owner))
+		return -ENODEV;
 	ss = kmalloc(sizeof(*ss), GFP_KERNEL);
-	if (!ss)
+	if (!ss) {
+		module_put(owner);
 		return -ENOMEM;
+	}
 	kobject_get(kobj);
 	ss->kobj = kobj;
 	ss->func = func;
 	ss->data = data;
+	ss->owner = owner;
 	INIT_WORK(&ss->work, sysfs_schedule_callback_work);
 	schedule_work(&ss->work);
 	return 0;
Index: usb-2.6/include/linux/device.h
===================================================================
--- usb-2.6.orig/include/linux/device.h
+++ usb-2.6/include/linux/device.h
@@ -369,8 +369,14 @@ extern int __must_check device_create_bi
 					       struct bin_attribute *attr);
 extern void device_remove_bin_file(struct device *dev,
 				   struct bin_attribute *attr);
-extern int device_schedule_callback(struct device *dev,
-		void (*func)(struct device *));
+extern int device_schedule_callback_owner(struct device *dev,
+		void (*func)(struct device *), struct module *owner);
+
+static inline int device_schedule_callback(struct device *dev,
+		void (*func)(struct device *))
+{
+	return device_schedule_callback_owner(dev, func, THIS_MODULE);
+}
 
 /* device resource management */
 typedef void (*dr_release_t)(struct device *dev, void *res);
Index: usb-2.6/include/linux/sysfs.h
===================================================================
--- usb-2.6.orig/include/linux/sysfs.h
+++ usb-2.6/include/linux/sysfs.h
@@ -80,7 +80,7 @@ struct sysfs_ops {
 #ifdef CONFIG_SYSFS
 
 extern int sysfs_schedule_callback(struct kobject *kobj,
-		void (*func)(void *), void *data);
+		void (*func)(void *), void *data, struct module *owner);
 
 extern int __must_check
 sysfs_create_dir(struct kobject *, struct dentry *);
@@ -138,7 +138,7 @@ extern int __must_check sysfs_init(void)
 #else /* CONFIG_SYSFS */
 
 static inline int sysfs_schedule_callback(struct kobject *kobj,
-		void (*func)(void *), void *data)
+		void (*func)(void *), void *data, struct module *owner)
 {
 	return -ENOSYS;
 }

