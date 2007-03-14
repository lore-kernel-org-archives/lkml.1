Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbXCNQMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbXCNQMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 12:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932238AbXCNQMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 12:12:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44710 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932280AbXCNQMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 12:12:39 -0400
Date: Wed, 14 Mar 2007 12:12:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       <gregkh@suse.de>, Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
In-Reply-To: <Pine.LNX.4.64.0703131418300.9690@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0703141048530.3112-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007, Linus Torvalds wrote:

> Could we please make this easier to use by having some common sysfs helper 
> routine for this kind of "delayed_store()" functionality.
> 
> I'm not a huge fan of delayed work at all, but if we have to have it, at 
> least make it one generic function rather than having multiple functions 
> all doing their own workqueue logic for it.

This seems more elegant (not yet tested).  Cornelia, does it look okay to 
you?

Alan Stern


Index: usb-2.6/include/linux/sysfs.h
===================================================================
--- usb-2.6.orig/include/linux/sysfs.h
+++ usb-2.6/include/linux/sysfs.h
@@ -78,6 +78,9 @@ struct sysfs_ops {
 
 #ifdef CONFIG_SYSFS
 
+extern int sysfs_access_in_other_task(struct kobject *kobj,
+		void (*func)(void *), void *data);
+
 extern int __must_check
 sysfs_create_dir(struct kobject *, struct dentry *);
 
@@ -133,6 +136,12 @@ extern int __must_check sysfs_init(void)
 
 #else /* CONFIG_SYSFS */
 
+static inline int sysfs_access_in_other_task(struct kobject *kobj,
+		void (*func)(void *), void *data)
+{
+	return -ENOSYS;
+}
+
 static inline int sysfs_create_dir(struct kobject * k, struct dentry *shadow)
 {
 	return 0;
Index: usb-2.6/fs/sysfs/file.c
===================================================================
--- usb-2.6.orig/fs/sysfs/file.c
+++ usb-2.6/fs/sysfs/file.c
@@ -643,6 +643,59 @@ void sysfs_remove_file_from_group(struct
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_file_from_group);
 
+struct other_task_struct {
+	struct kobject 		*kobj;
+	void			(*func)(void *);
+	void			*data;
+	struct work_struct	work;
+};
+
+static void other_task_work(struct work_struct *work)
+{
+	struct other_task_struct *ots = container_of(work,
+			struct other_task_struct, work);
+
+	(ots->func)(ots->data);
+	kobject_put(ots->kobj);
+	kfree(ots);
+}
+
+/**
+ * sysfs_access_in_other_task - delay access from an attribute method.
+ * @kobj: object we're acting for.
+ * @func: callback function to invoke later.
+ * @data: argument to pass to @func.
+ *
+ * sysfs attribute methods must not unregister themselves or their parent
+ * kobject (which would amount to the same thing).  Attempts to do so will
+ * deadlock, since unregistration is mutually exclusive with driver
+ * callbacks.
+ *
+ * Instead methods can call this routine, which will attempt to allocate
+ * and schedule a workqueue request to carry out the requested function
+ * in the workqueue's process context.
+ *
+ * Returns 0 if the request was submitted, -ENOMEM if storage could not
+ * be allocated.
+ */
+int sysfs_access_in_other_task(struct kobject *kobj, void (*func)(void *),
+		void *data)
+{
+	struct other_task_struct *ots;
+
+	ots = kmalloc(sizeof(*ots), GFP_KERNEL);
+	if (!ots)
+		return -ENOMEM;
+	kobject_get(kobj);
+	ots->kobj = kobj;
+	ots->func = func;
+	ots->data = data;
+	INIT_WORK(&ots->work, other_task_work);
+	schedule_work(&ots->work);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sysfs_access_in_other_task);
+
 
 EXPORT_SYMBOL_GPL(sysfs_create_file);
 EXPORT_SYMBOL_GPL(sysfs_remove_file);
Index: usb-2.6/include/linux/device.h
===================================================================
--- usb-2.6.orig/include/linux/device.h
+++ usb-2.6/include/linux/device.h
@@ -356,6 +356,8 @@ extern int __must_check device_create_bi
 					       struct bin_attribute *attr);
 extern void device_remove_bin_file(struct device *dev,
 				   struct bin_attribute *attr);
+extern int device_access_in_other_task(struct device *dev,
+		void (*func)(struct device *));
 
 /* device resource management */
 typedef void (*dr_release_t)(struct device *dev, void *res);
Index: usb-2.6/drivers/base/core.c
===================================================================
--- usb-2.6.orig/drivers/base/core.c
+++ usb-2.6/drivers/base/core.c
@@ -407,6 +407,30 @@ void device_remove_bin_file(struct devic
 }
 EXPORT_SYMBOL_GPL(device_remove_bin_file);
 
+/**
+ * device_access_in_other_task - delay access from an attribute method.
+ * @dev: device.
+ * @func: callback function to invoke later.
+ *
+ * Attribute methods must not unregister themselves or their parent device
+ * (which would amount to the same thing).  Attempts to do so will deadlock,
+ * since unregistration is mutually exclusive with driver callbacks.
+ *
+ * Instead methods can call this routine, which will attempt to allocate
+ * and schedule a workqueue request to carry out the requested function
+ * in the workqueue's process context.
+ *
+ * Returns 0 if the request was submitted, -ENOMEM if storage could not
+ * be allocated.
+ */
+int device_access_in_other_task(struct device *dev,
+		void (*func)(struct device *))
+{
+	return sysfs_access_in_other_task(&dev->kobj,
+			(void (*)(void *)) func, dev);
+}
+EXPORT_SYMBOL_GPL(device_access_in_other_task);
+
 static void klist_children_get(struct klist_node *n)
 {
 	struct device *dev = container_of(n, struct device, knode_parent);
Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -452,10 +452,22 @@ store_rescan_field (struct device *dev, 
 }
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, store_rescan_field);
 
+static void sdev_store_delete_callback(struct device *dev)
+{
+	scsi_remove_device(to_scsi_device(dev));
+}
+
 static ssize_t sdev_store_delete(struct device *dev, struct device_attribute *attr, const char *buf,
 				 size_t count)
 {
-	scsi_remove_device(to_scsi_device(dev));
+	int rc;
+
+	/* An attribute cannot be unregistered by one of its own methods,
+	 * so we have to use device_access_in_other_task().
+	 */
+	rc = device_access_in_other_task(dev, sdev_store_delete_callback);
+	if (rc)
+		count = rc;
 	return count;
 };
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
Index: usb-2.6/drivers/s390/cio/ccwgroup.c
===================================================================
--- usb-2.6.orig/drivers/s390/cio/ccwgroup.c
+++ usb-2.6/drivers/s390/cio/ccwgroup.c
@@ -71,19 +71,31 @@ __ccwgroup_remove_symlinks(struct ccwgro
  * Provide an 'ungroup' attribute so the user can remove group devices no
  * longer needed or accidentially created. Saves memory :)
  */
+static void ccwgroup_ungroup_callback(struct device *dev)
+{
+	struct ccwgroup_device *gdev = to_ccwgroupdev(dev);
+
+	__ccwgroup_remove_symlinks(gdev);
+	device_unregister(dev);
+}
+
 static ssize_t
 ccwgroup_ungroup_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct ccwgroup_device *gdev;
+	int rc;
 
 	gdev = to_ccwgroupdev(dev);
 
 	if (gdev->state != CCWGROUP_OFFLINE)
 		return -EINVAL;
 
-	__ccwgroup_remove_symlinks(gdev);
-	device_unregister(dev);
-
+	/* Note that we cannot unregister the device from one of its
+	 * attribute methods, so we have to delay it.
+	 */
+	rc = device_access_in_other_task(dev, ccwgroup_ungroup_callback);
+	if (rc)
+		count = rc;
 	return count;
 }
 

