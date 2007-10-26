Return-Path: <linux-kernel-owner+w=401wt.eu-S1763785AbXJZVe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763785AbXJZVe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbXJZVeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:34:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:54042 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbXJZVeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:34:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,335,1188802800"; 
   d="scan'208";a="306271482"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: fixing up DRM device model usage
Date: Fri, 26 Oct 2007 14:31:47 -0700
User-Agent: KMail/1.9.7
Cc: Greg KH <gregkh@suse.de>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, jbarnes@virtuousgeek.org
References: <200710181401.50470.jbarnes@virtuousgeek.org> <200710261140.41016.jbarnes@virtuousgeek.org> <1193425738.2190.45.camel@lov.site>
In-Reply-To: <1193425738.2190.45.camel@lov.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710261431.48589.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 26, 2007 12:08 pm Kay Sievers wrote:
> > How does this conversion look?
>
> Seems fine, at a first look. You moved the device structure into the
> object where it belongs, instead of allocating one, and saving the
> pointer. You should really considering changing the core to do the
> free()ing of your object with the embedded devices release function,
> that is called when the last reference to the object is gone, instead
> of "hoping the best". :) But if the drm core does that properly, it
> might work, sure.

Yeah, but that'll require other changes to the DRM.  Maybe I can tackle
that as part of the refactoring I'm doing for some other work.

> The open coded: device_create_file(&dev->dev, &device_attrs[i])
> should probably replaced by passing the array to the class, and the
> core will do that for you.

You mean just set drm_class->dev_attrs = device_attrs?  I didn't see in
the core device model code where that would create the files...

> Do you assign the dev_t: MKDEV(DRM_MAJOR, head->minor) somewhere? You
> need to put it in dev->devt, if you want a device node created by
> userspace.

Yeah, that's part of the drm_head structure.  I'll go ahead and assign
it to dev->devt too.

> > It retains directory compatibility with
> > the old scheme, but I'm not sure about the dev->dev.parent value.
>
> You should use the same value as the old code:
>   &(head->dev->pdev)->dev
> and assign it as the parent, seems right..
>
> > I'm using the PCI device corresponding to the DRM device as the
> > parent, but maybe I don't need one at all?
>
> Keep it, you want to express the relationship in sysfs, so that a
> "device" link is created, or that the device directory lives as a
> child below the parent device. Seems fine so far.

Ok, sounds good.

>
> > Dave, the drm_head stuff is a bit funky; it seems like a partially
> > implemented feature?  I wonder if we should rip that out too, just
> > to keep things simple...
>
> Hehe, that's always a solution. :)

Yeah, removing code is nearly always a win. :)

Thanks,
Jesse

diff --git a/linux-core/drmP.h b/linux-core/drmP.h
index d0ab2c9..82a3a23 100644
--- a/linux-core/drmP.h
+++ b/linux-core/drmP.h
@@ -619,6 +619,8 @@ struct drm_driver {
 	void (*postclose) (struct drm_device *, struct drm_file *);
 	void (*lastclose) (struct drm_device *);
 	int (*unload) (struct drm_device *);
+	int (*suspend) (struct drm_device *);
+	int (*resume) (struct drm_device *);
 	int (*dma_ioctl) (struct drm_device *dev, void *data, struct drm_file *file_priv);
 	void (*dma_ready) (struct drm_device *);
 	int (*dma_quiescent) (struct drm_device *);
@@ -697,6 +699,7 @@ struct drm_head {
  * may contain multiple heads.
  */
 struct drm_device {
+	struct device dev;		/**< Linux device */
 	char *unique;			/**< Unique identifier: e.g., busid */
 	int unique_len;			/**< Length of unique field */
 	char *devname;			/**< For /proc/interrupts */
@@ -1163,10 +1166,9 @@ extern void drm_pci_free(struct drm_device *dev, drm_dma_handle_t *dmah);
 			       /* sysfs support (drm_sysfs.c) */
 struct drm_sysfs_class;
 extern struct class *drm_sysfs_create(struct module *owner, char *name);
-extern void drm_sysfs_destroy(struct class *cs);
-extern struct class_device *drm_sysfs_device_add(struct class *cs,
-						 struct drm_head * head);
-extern void drm_sysfs_device_remove(struct class_device *class_dev);
+extern void drm_sysfs_destroy(void);
+extern int drm_sysfs_device_add(struct drm_device *dev, struct drm_head * head);
+extern void drm_sysfs_device_remove(struct drm_device *dev);
 
 /*
  * Basic memory manager support (drm_mm.c)
diff --git a/linux-core/drm_drv.c b/linux-core/drm_drv.c
index fe2b120..47d1765 100644
--- a/linux-core/drm_drv.c
+++ b/linux-core/drm_drv.c
@@ -519,7 +519,7 @@ static int __init drm_core_init(void)
 		 CORE_MAJOR, CORE_MINOR, CORE_PATCHLEVEL, CORE_DATE);
 	return 0;
 err_p3:
-	drm_sysfs_destroy(drm_class);
+	drm_sysfs_destroy();
 err_p2:
 	unregister_chrdev(DRM_MAJOR, "drm");
 	drm_free(drm_heads, sizeof(*drm_heads) * drm_cards_limit, DRM_MEM_STUB);
@@ -530,7 +530,7 @@ err_p1:
 static void __exit drm_core_exit(void)
 {
 	remove_proc_entry("dri", NULL);
-	drm_sysfs_destroy(drm_class);
+	drm_sysfs_destroy();
 
 	unregister_chrdev(DRM_MAJOR, "drm");
 
diff --git a/linux-core/drm_stub.c b/linux-core/drm_stub.c
index 9e140ac..1d88d37 100644
--- a/linux-core/drm_stub.c
+++ b/linux-core/drm_stub.c
@@ -183,11 +183,10 @@ static int drm_get_head(struct drm_device * dev, struct drm_head * head)
 				goto err_g1;
 			}
 
-			head->dev_class = drm_sysfs_device_add(drm_class, head);
-			if (IS_ERR(head->dev_class)) {
+			ret = drm_sysfs_device_add(dev, head);
+			if (ret) {
 				printk(KERN_ERR
 				       "DRM: Error sysfs_device_add.\n");
-				ret = PTR_ERR(head->dev_class);
 				goto err_g2;
 			}
 			*heads = head;
@@ -316,7 +315,7 @@ int drm_put_head(struct drm_head * head)
 	DRM_DEBUG("release secondary minor %d\n", minor);
 
 	drm_proc_cleanup(minor, drm_proc_root, head->dev_root);
-	drm_sysfs_device_remove(head->dev_class);
+	drm_sysfs_device_remove(head->dev);
 
 	*head = (struct drm_head){.dev = NULL};
 
diff --git a/linux-core/drm_sysfs.c b/linux-core/drm_sysfs.c
index cf4349b..fa36153 100644
--- a/linux-core/drm_sysfs.c
+++ b/linux-core/drm_sysfs.c
@@ -19,6 +19,45 @@
 #include "drm_core.h"
 #include "drmP.h"
 
+#define to_drm_device(d) container_of(d, struct drm_device, dev)
+
+/**
+ * drm_sysfs_suspend - DRM class suspend hook
+ * @dev: Linux device to suspend
+ * @state: power state to enter
+ *
+ * Just figures out what the actual struct drm_device associated with
+ * @dev is and calls its suspend hook, if present.
+ */
+static int drm_sysfs_suspend(struct device *dev, pm_message_t state)
+{
+	struct drm_device *drm_dev = to_drm_device(dev);
+
+	printk(KERN_ERR "%s\n", __FUNCTION__);
+
+	if (drm_dev->driver->suspend)
+		return drm_dev->driver->suspend(drm_dev);
+
+	return 0;
+}
+
+/**
+ * drm_sysfs_resume - DRM class resume hook
+ * @dev: Linux device to resume
+ *
+ * Just figures out what the actual struct drm_device associated with
+ * @dev is and calls its resume hook, if present.
+ */
+static int drm_sysfs_resume(struct device *dev)
+{
+	struct drm_device *drm_dev = to_drm_device(dev);
+
+	if (drm_dev->driver->resume)
+		return drm_dev->driver->resume(drm_dev);
+
+	return 0;
+}
+
 /* Display the version of drm_core. This doesn't work right in current design */
 static ssize_t version_show(struct class *dev, char *buf)
 {
@@ -33,7 +72,7 @@ static CLASS_ATTR(version, S_IRUGO, version_show, NULL);
  * @owner: pointer to the module that is to "own" this struct drm_sysfs_class
  * @name: pointer to a string for the name of this class.
  *
- * This is used to create a struct drm_sysfs_class pointer that can then be used
+ * This is used to create DRM class pointer that can then be used
  * in calls to drm_sysfs_device_add().
  *
  * Note, the pointer created here is to be destroyed when finished by making a
@@ -50,6 +89,9 @@ struct class *drm_sysfs_create(struct module *owner, char *name)
 		goto err_out;
 	}
 
+	class->suspend = drm_sysfs_suspend;
+	class->resume = drm_sysfs_resume;
+
 	err = class_create_file(class, &class_attr_version);
 	if (err)
 		goto err_out_class;
@@ -63,94 +105,100 @@ err_out:
 }
 
 /**
- * drm_sysfs_destroy - destroys a struct drm_sysfs_class structure
- * @cs: pointer to the struct drm_sysfs_class that is to be destroyed
+ * drm_sysfs_destroy - destroys DRM class
  *
- * Note, the pointer to be destroyed must have been created with a call to
- * drm_sysfs_create().
+ * Destroy the DRM device class.
  */
-void drm_sysfs_destroy(struct class *class)
+void drm_sysfs_destroy(void)
 {
-	if ((class == NULL) || (IS_ERR(class)))
+	if ((drm_class == NULL) || (IS_ERR(drm_class)))
 		return;
-
-	class_remove_file(class, &class_attr_version);
-	class_destroy(class);
+	class_remove_file(drm_class, &class_attr_version);
+	class_destroy(drm_class);
 }
 
-static ssize_t show_dri(struct class_device *class_device, char *buf)
+static ssize_t show_dri(struct device *device, struct device_attribute *attr,
+			char *buf)
 {
-	struct drm_device * dev = ((struct drm_head *)class_get_devdata(class_device))->dev;
+	struct drm_device *dev = to_drm_device(device);
 	if (dev->driver->dri_library_name)
 		return dev->driver->dri_library_name(dev, buf);
 	return snprintf(buf, PAGE_SIZE, "%s\n", dev->driver->pci_driver.name);
 }
 
-static struct class_device_attribute class_device_attrs[] = {
+static struct device_attribute device_attrs[] = {
 	__ATTR(dri_library_name, S_IRUGO, show_dri, NULL),
 };
 
 /**
+ * drm_sysfs_device_release - do nothing
+ * @dev: Linux device
+ *
+ * Normally, this would free the DRM device associated with @dev, along
+ * with cleaning up any other stuff.  But we do that in the DRM core, so
+ * this function can just return and hope that the core does its job.
+ */
+static void drm_sysfs_device_release(struct device *dev)
+{
+	return;
+}
+
+/**
  * drm_sysfs_device_add - adds a class device to sysfs for a character driver
- * @cs: pointer to the struct class that this device should be registered to.
- * @dev: the dev_t for the device to be added.
- * @device: a pointer to a struct device that is assiociated with this class device.
- * @fmt: string for the class device's name
+ * @dev: DRM device to be added
+ * @head: DRM head in question
  *
- * A struct class_device will be created in sysfs, registered to the specified
- * class.  A "dev" file will be created, showing the dev_t for the device.  The
- * pointer to the struct class_device will be returned from the call.  Any further
- * sysfs files that might be required can be created using this pointer.
- * Note: the struct class passed to this function must have previously been
- * created with a call to drm_sysfs_create().
+ * Add a DRM device to the DRM's device model class.  We use @dev's PCI device
+ * as the parent for the Linux device, and make sure it has a file containing
+ * the driver we're using (for userspace compatibility).
  */
-struct class_device *drm_sysfs_device_add(struct class *cs, struct drm_head *head)
+int drm_sysfs_device_add(struct drm_device *dev, struct drm_head *head)
 {
-	struct class_device *class_dev;
-	int i, j, err;
-
-	class_dev = class_device_create(cs, NULL,
-					MKDEV(DRM_MAJOR, head->minor),
-					&(head->dev->pdev)->dev,
-					"card%d", head->minor);
-	if (IS_ERR(class_dev)) {
-		err = PTR_ERR(class_dev);
+	int err;
+	int i, j;
+
+	dev->dev.parent = &dev->pdev->dev;
+	dev->dev.class = drm_class;
+	dev->dev.release = drm_sysfs_device_release;
+	dev->dev.devt = head->device;
+	snprintf(dev->dev.bus_id, BUS_ID_SIZE, "card%d", head->minor);
+
+	err = device_register(&dev->dev);
+	if (err) {
+		DRM_ERROR("device add failed: %d\n", err);
 		goto err_out;
 	}
 
-	class_set_devdata(class_dev, head);
-
-	for (i = 0; i < ARRAY_SIZE(class_device_attrs); i++) {
-		err = class_device_create_file(class_dev,
-					       &class_device_attrs[i]);
+	for (i = 0; i < ARRAY_SIZE(device_attrs); i++) {
+		err = device_create_file(&dev->dev, &device_attrs[i]);
 		if (err)
 			goto err_out_files;
 	}
 
-	return class_dev;
+	return 0;
 
 err_out_files:
 	if (i > 0)
 		for (j = 0; j < i; j++)
-			class_device_remove_file(class_dev,
-						 &class_device_attrs[i]);
-	class_device_unregister(class_dev);
+			device_remove_file(&dev->dev, &device_attrs[i]);
+	device_unregister(&dev->dev);
 err_out:
-	return ERR_PTR(err);
+
+	return err;
 }
 
 /**
- * drm_sysfs_device_remove - removes a class device that was created with drm_sysfs_device_add()
- * @dev: the dev_t of the device that was previously registered.
+ * drm_sysfs_device_remove - remove DRM device
+ * @dev: DRM device to remove
  *
  * This call unregisters and cleans up a class device that was created with a
  * call to drm_sysfs_device_add()
  */
-void drm_sysfs_device_remove(struct class_device *class_dev)
+void drm_sysfs_device_remove(struct drm_device *dev)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(class_device_attrs); i++)
-		class_device_remove_file(class_dev, &class_device_attrs[i]);
-	class_device_unregister(class_dev);
+	for (i = 0; i < ARRAY_SIZE(device_attrs); i++)
+		device_remove_file(&dev->dev, &device_attrs[i]);
+	device_unregister(&dev->dev);
 }
