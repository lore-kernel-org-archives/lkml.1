Return-Path: <linux-kernel-owner+w=401wt.eu-S1764856AbXJZSmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764856AbXJZSmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758305AbXJZSmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:42:38 -0400
Received: from outbound-mail-65.bluehost.com ([69.89.21.25]:46103 "HELO
	outbound-mail-65.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753388AbXJZSmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:42:37 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: fixing up DRM device model usage
Date: Fri, 26 Oct 2007 11:40:39 -0700
User-Agent: KMail/1.9.7
Cc: "Greg KH" <gregkh@suse.de>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pavel Machek" <pavel@ucw.cz>
References: <200710181401.50470.jbarnes@virtuousgeek.org> <200710260957.15137.jbarnes@virtuousgeek.org> <3ae72650710261010p195e2228h91c9cb11829c2a77@mail.gmail.com>
In-Reply-To: <3ae72650710261010p195e2228h91c9cb11829c2a77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710261140.41016.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 26, 2007 10:10 am Kay Sievers wrote:
> On 10/26/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Thursday, October 25, 2007 9:59 pm Greg KH wrote:
> > > On Thu, Oct 25, 2007 at 04:53:18PM -0700, Jesse Barnes wrote:
> > > > Ok, here's yet another version that uses the device model for
> > > > the suspend/resume, rather than pci hooks.
> > > >
> > > > Greg, DRM desperately needs review of its device model usage,
> > > > can you take a look at this patch and the current drm_sysfs.c
> > > > code? Right now, we're mixing class_devices and regular devices
> > > > (the latter seem to be required for suspend/resume to work
> > > > correctly), but this seems wrong. Any ideas?  Should we just
> > > > rip out the class_device stuff and create full-on DRM device
> > > > nodes?
> > >
> > > The class_device stuff is already ripped out in the latest -mm
> > > trees and I will be forwarding that change on for 2.6.25 after
> > > 2.6.24 is out.  So yes, it should be taken away :)
> > >
> > > But converting from class_device to struct device does not mean
> > > you use a "device node".  But you could if you want to :)
> >
> > Yeah, bad choice of words. :)
> >
> > To retain compatibility, we need to have directories under the DRM
> > class dir (/sys/class/drm) for each card (e.g. card0) that contains
> > a file describing which graphics driver is bound to the device. 
> > For class devices, we could just add an attributes structure to the
> > device.  Can we do the same with regular, non-class devices?
>
> The conversion is already queued in Greg's tree, and in -mm:
> http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f
>=driver/drm-convert-from-class_device-to-device-in-drivers-char-drm.pa
>tch;h=f993183d1cb017f981cc2232d17930af40459bd8;hb=HEAD
>
> /sys/class/drm will look the same as with the class_device's, only if
> !CONFIG_SYSFS_DEPRECATED, there will be symlinks instead of
> directories, otherwise the same pathes, like for all other
> (converted) classes too.

How does this conversion look?  It retains directory compatibility with
the old scheme, but I'm not sure about the dev->dev.parent value.  I'm
using the PCI device corresponding to the DRM device as the parent, but
maybe I don't need one at all?

Dave, the drm_head stuff is a bit funky; it seems like a partially
implemented feature?  I wonder if we should rip that out too, just to
keep things simple...

Thanks,
Jesse

diff --git a/linux-core/Kconfig b/linux-core/Kconfig
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
index cf4349b..b63929a 100644
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
@@ -63,94 +105,95 @@ err_out:
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
+ * this function can just return and hope for the best.
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
  *
- * A struct class_device will be created in sysfs, registered to the specified
- * class.  A "dev" file will be created, showing the dev_t for the device.  The
- * pointer to the struct class_device will be returned from the call.  Any further
- * sysfs files that might be required can be created using this pointer.
- * Note: the struct class passed to this function must have previously been
- * created with a call to drm_sysfs_create().
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
