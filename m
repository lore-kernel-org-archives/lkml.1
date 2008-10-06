Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbYJFUmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbYJFUmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 16:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYJFUmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 16:42:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55327 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbYJFUmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 16:42:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH -next] PM: Simplify the new suspend/hibernation framework for devices
Date: Mon, 6 Oct 2008 22:46:05 +0200
User-Agent: KMail/1.9.9
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Hannes Reinecke <hare@suse.de>
References: <200810060055.07601.rjw@sisk.pl>
In-Reply-To: <200810060055.07601.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810062246.06654.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 6 of October 2008, Rafael J. Wysocki wrote:
> Hi Greg,
> 
> I promised at the KS that I would simplify the new suspend/hibernation
> framework for devices to avoid the confusion with two types of PM
> operations and pointers to PM operations from too many places.
> 
> The appended patch is intended for this purpose.  Unfortunately, I can't
> split it into subsystem-related patches, because compilation would be broken
> between them.
> 
> The patch applies to linux-next, but it's trivial to make it apply to the
> mainline.  It's been compiled on x86 (both 32-bit and 64-bit) and tested
> on hp nx6325, doesn't appear to break anything.

This one had a checkpatch.pl problem, sorry for that.  Updated patch is
appended.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>

PM: Simplify the new suspend/hibernation framework for devices

Following the discussion at the Kernel Summit, simplify the new
device PM framework by merging 'struct pm_ops' and
'struct pm_ext_ops' and removing pointers to 'struct pm_ext_ops'
from 'struct platform_driver' and 'struct pci_driver'.

After this change, the suspend/hibernation callbacks will only
reside in 'struct device_driver' as well as at the bus type/
device class/device type level.  Accordingly, PCI and platform
device drivers are now expected to put their suspend/hibernation
callbacks into the 'struct device_driver' embedded in
'struct pci_driver' or 'struct platform_driver', respectively.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/platform.c         |  115 ++++++++++++++++++++--------------------
 drivers/base/power/main.c       |   19 +++---
 drivers/pci/pci-driver.c        |   46 ++++++----------
 drivers/usb/core/usb.c          |    4 -
 include/linux/device.h          |    8 +-
 include/linux/pci.h             |    1 
 include/linux/platform_device.h |    1 
 include/linux/pm.h              |   76 ++++++++------------------
 8 files changed, 119 insertions(+), 151 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -41,7 +41,7 @@ typedef struct pm_message {
 } pm_message_t;
 
 /**
- * struct pm_ops - device PM callbacks
+ * struct dev_pm_ops - device PM callbacks
  *
  * Several driver power state transitions are externally visible, affecting
  * the state of pending I/O queues and (for drivers that touch hardware)
@@ -126,46 +126,6 @@ typedef struct pm_message {
  *	On most platforms, there are no restrictions on availability of
  *	resources like clocks during @restore().
  *
- * All of the above callbacks, except for @complete(), return error codes.
- * However, the error codes returned by the resume operations, @resume(),
- * @thaw(), and @restore(), do not cause the PM core to abort the resume
- * transition during which they are returned.  The error codes returned in
- * that cases are only printed by the PM core to the system logs for debugging
- * purposes.  Still, it is recommended that drivers only return error codes
- * from their resume methods in case of an unrecoverable failure (i.e. when the
- * device being handled refuses to resume and becomes unusable) to allow us to
- * modify the PM core in the future, so that it can avoid attempting to handle
- * devices that failed to resume and their children.
- *
- * It is allowed to unregister devices while the above callbacks are being
- * executed.  However, it is not allowed to unregister a device from within any
- * of its own callbacks.
- */
-
-struct pm_ops {
-	int (*prepare)(struct device *dev);
-	void (*complete)(struct device *dev);
-	int (*suspend)(struct device *dev);
-	int (*resume)(struct device *dev);
-	int (*freeze)(struct device *dev);
-	int (*thaw)(struct device *dev);
-	int (*poweroff)(struct device *dev);
-	int (*restore)(struct device *dev);
-};
-
-/**
- * struct pm_ext_ops - extended device PM callbacks
- *
- * Some devices require certain operations related to suspend and hibernation
- * to be carried out with interrupts disabled.  Thus, 'struct pm_ext_ops' below
- * is defined, adding callbacks to be executed with interrupts disabled to
- * 'struct pm_ops'.
- *
- * The following callbacks included in 'struct pm_ext_ops' are executed with
- * the nonboot CPUs switched off and with interrupts disabled on the only
- * functional CPU.  They also are executed with the PM core list of devices
- * locked, so they must NOT unregister any devices.
- *
  * @suspend_noirq: Complete the operations of ->suspend() by carrying out any
  *	actions required for suspending the device that need interrupts to be
  *	disabled
@@ -190,18 +150,32 @@ struct pm_ops {
  *	actions required for restoring the operations of the device that need
  *	interrupts to be disabled
  *
- * All of the above callbacks return error codes, but the error codes returned
- * by the resume operations, @resume_noirq(), @thaw_noirq(), and
- * @restore_noirq(), do not cause the PM core to abort the resume transition
- * during which they are returned.  The error codes returned in that cases are
- * only printed by the PM core to the system logs for debugging purposes.
- * Still, as stated above, it is recommended that drivers only return error
- * codes from their resume methods if the device being handled fails to resume
- * and is not usable any more.
+ * All of the above callbacks, except for @complete(), return error codes.
+ * However, the error codes returned by the resume operations, @resume(),
+ * @thaw(), @restore(), @resume_noirq(), @thaw_noirq(), and @restore_noirq() do
+ * not cause the PM core to abort the resume transition during which they are
+ * returned.  The error codes returned in that cases are only printed by the PM
+ * core to the system logs for debugging purposes.  Still, it is recommended
+ * that drivers only return error codes from their resume methods in case of an
+ * unrecoverable failure (i.e. when the device being handled refuses to resume
+ * and becomes unusable) to allow us to modify the PM core in the future, so
+ * that it can avoid attempting to handle devices that failed to resume and
+ * their children.
+ *
+ * It is allowed to unregister devices while the above callbacks are being
+ * executed.  However, it is not allowed to unregister a device from within any
+ * of its own callbacks.
  */
 
-struct pm_ext_ops {
-	struct pm_ops base;
+struct dev_pm_ops {
+	int (*prepare)(struct device *dev);
+	void (*complete)(struct device *dev);
+	int (*suspend)(struct device *dev);
+	int (*resume)(struct device *dev);
+	int (*freeze)(struct device *dev);
+	int (*thaw)(struct device *dev);
+	int (*poweroff)(struct device *dev);
+	int (*restore)(struct device *dev);
 	int (*suspend_noirq)(struct device *dev);
 	int (*resume_noirq)(struct device *dev);
 	int (*freeze_noirq)(struct device *dev);
Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h
+++ linux-2.6/include/linux/device.h
@@ -65,7 +65,7 @@ struct bus_type {
 	int (*resume_early)(struct device *dev);
 	int (*resume)(struct device *dev);
 
-	struct pm_ext_ops *pm;
+	struct dev_pm_ops *pm;
 
 	struct bus_type_private *p;
 };
@@ -133,7 +133,7 @@ struct device_driver {
 	int (*resume) (struct device *dev);
 	struct attribute_group **groups;
 
-	struct pm_ops *pm;
+	struct dev_pm_ops *pm;
 
 	struct driver_private *p;
 };
@@ -201,7 +201,7 @@ struct class {
 	enum sysfs_tag_type tag_type;
 	const void *(*sysfs_tag)(struct device *dev);
 
-	struct pm_ops *pm;
+	struct dev_pm_ops *pm;
 	struct class_private *p;
 };
 
@@ -291,7 +291,7 @@ struct device_type {
 	int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
 	void (*release)(struct device *dev);
 
-	struct pm_ops *pm;
+	struct dev_pm_ops *pm;
 };
 
 /* interface for exporting device attributes */
Index: linux-2.6/include/linux/platform_device.h
===================================================================
--- linux-2.6.orig/include/linux/platform_device.h
+++ linux-2.6/include/linux/platform_device.h
@@ -53,7 +53,6 @@ struct platform_driver {
 	int (*suspend_late)(struct platform_device *, pm_message_t state);
 	int (*resume_early)(struct platform_device *);
 	int (*resume)(struct platform_device *);
-	struct pm_ext_ops *pm;
 	struct device_driver driver;
 };
 
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -414,7 +414,6 @@ struct pci_driver {
 	int  (*resume_early) (struct pci_dev *dev);
 	int  (*resume) (struct pci_dev *dev);	                /* Device woken up */
 	void (*shutdown) (struct pci_dev *dev);
-	struct pm_ext_ops *pm;
 	struct pci_error_handlers *err_handler;
 	struct device_driver	driver;
 	struct pci_dynids dynids;
Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -433,8 +433,7 @@ static int pci_pm_suspend(struct device 
 
 static int pci_pm_suspend_noirq(struct device *dev)
 {
-	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct pci_driver *drv = pci_dev->driver;
+	struct device_driver *drv = dev->driver;
 	int error = 0;
 
 	if (drv && drv->pm) {
@@ -469,11 +468,10 @@ static int pci_pm_resume(struct device *
 
 static int pci_pm_resume_noirq(struct device *dev)
 {
-	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct pci_driver *drv = pci_dev->driver;
+	struct device_driver *drv = dev->driver;
 	int error = 0;
 
-	pci_fixup_device(pci_fixup_resume_early, pci_dev);
+	pci_fixup_device(pci_fixup_resume_early, to_pci_dev(dev));
 
 	if (drv && drv->pm) {
 		if (drv->pm->resume_noirq)
@@ -519,8 +517,7 @@ static int pci_pm_freeze(struct device *
 
 static int pci_pm_freeze_noirq(struct device *dev)
 {
-	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct pci_driver *drv = pci_dev->driver;
+	struct device_driver *drv = dev->driver;
 	int error = 0;
 
 	if (drv && drv->pm) {
@@ -553,15 +550,14 @@ static int pci_pm_thaw(struct device *de
 
 static int pci_pm_thaw_noirq(struct device *dev)
 {
-	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct pci_driver *drv = pci_dev->driver;
+	struct device_driver *drv = dev->driver;
 	int error = 0;
 
 	if (drv && drv->pm) {
 		if (drv->pm->thaw_noirq)
 			error = drv->pm->thaw_noirq(dev);
 	} else {
-		pci_fixup_device(pci_fixup_resume_early, pci_dev);
+		pci_fixup_device(pci_fixup_resume_early, to_pci_dev(dev));
 		error = pci_legacy_resume_early(dev);
 	}
 
@@ -589,8 +585,7 @@ static int pci_pm_poweroff(struct device
 
 static int pci_pm_poweroff_noirq(struct device *dev)
 {
-	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct pci_driver *drv = pci_dev->driver;
+	struct device_driver *drv = dev->driver;
 	int error = 0;
 
 	if (drv && drv->pm) {
@@ -625,7 +620,7 @@ static int pci_pm_restore(struct device 
 static int pci_pm_restore_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct pci_driver *drv = pci_dev->driver;
+	struct device_driver *drv = dev->driver;
 	int error = 0;
 
 	pci_fixup_device(pci_fixup_resume, pci_dev);
@@ -654,17 +649,15 @@ static int pci_pm_restore_noirq(struct d
 
 #endif /* !CONFIG_HIBERNATION */
 
-struct pm_ext_ops pci_pm_ops = {
-	.base = {
-		.prepare = pci_pm_prepare,
-		.complete = pci_pm_complete,
-		.suspend = pci_pm_suspend,
-		.resume = pci_pm_resume,
-		.freeze = pci_pm_freeze,
-		.thaw = pci_pm_thaw,
-		.poweroff = pci_pm_poweroff,
-		.restore = pci_pm_restore,
-	},
+struct dev_pm_ops pci_dev_pm_ops = {
+	.prepare = pci_pm_prepare,
+	.complete = pci_pm_complete,
+	.suspend = pci_pm_suspend,
+	.resume = pci_pm_resume,
+	.freeze = pci_pm_freeze,
+	.thaw = pci_pm_thaw,
+	.poweroff = pci_pm_poweroff,
+	.restore = pci_pm_restore,
 	.suspend_noirq = pci_pm_suspend_noirq,
 	.resume_noirq = pci_pm_resume_noirq,
 	.freeze_noirq = pci_pm_freeze_noirq,
@@ -673,7 +666,7 @@ struct pm_ext_ops pci_pm_ops = {
 	.restore_noirq = pci_pm_restore_noirq,
 };
 
-#define PCI_PM_OPS_PTR	&pci_pm_ops
+#define PCI_PM_OPS_PTR	(&pci_dev_pm_ops)
 
 #else /* !CONFIG_PM_SLEEP */
 
@@ -703,9 +696,6 @@ int __pci_register_driver(struct pci_dri
 	drv->driver.owner = owner;
 	drv->driver.mod_name = mod_name;
 
-	if (drv->pm)
-		drv->driver.pm = &drv->pm->base;
-
 	spin_lock_init(&drv->dynids.lock);
 	INIT_LIST_HEAD(&drv->dynids.list);
 
Index: linux-2.6/drivers/base/platform.c
===================================================================
--- linux-2.6.orig/drivers/base/platform.c
+++ linux-2.6/drivers/base/platform.c
@@ -453,8 +453,6 @@ int platform_driver_register(struct plat
 		drv->driver.suspend = platform_drv_suspend;
 	if (drv->resume)
 		drv->driver.resume = platform_drv_resume;
-	if (drv->pm)
-		drv->driver.pm = &drv->pm->base;
 	return driver_register(&drv->driver);
 }
 EXPORT_SYMBOL_GPL(platform_driver_register);
@@ -636,7 +634,10 @@ static int platform_pm_suspend(struct de
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
 
-	if (drv && drv->pm) {
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
 		if (drv->pm->suspend)
 			ret = drv->pm->suspend(dev);
 	} else {
@@ -648,16 +649,15 @@ static int platform_pm_suspend(struct de
 
 static int platform_pm_suspend_noirq(struct device *dev)
 {
-	struct platform_driver *pdrv;
+	struct device_driver *drv = dev->driver;
 	int ret = 0;
 
-	if (!dev->driver)
+	if (!drv)
 		return 0;
 
-	pdrv = to_platform_driver(dev->driver);
-	if (pdrv->pm) {
-		if (pdrv->pm->suspend_noirq)
-			ret = pdrv->pm->suspend_noirq(dev);
+	if (drv->pm) {
+		if (drv->pm->suspend_noirq)
+			ret = drv->pm->suspend_noirq(dev);
 	} else {
 		ret = platform_legacy_suspend_late(dev, PMSG_SUSPEND);
 	}
@@ -670,7 +670,10 @@ static int platform_pm_resume(struct dev
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
 
-	if (drv && drv->pm) {
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
 		if (drv->pm->resume)
 			ret = drv->pm->resume(dev);
 	} else {
@@ -682,16 +685,15 @@ static int platform_pm_resume(struct dev
 
 static int platform_pm_resume_noirq(struct device *dev)
 {
-	struct platform_driver *pdrv;
+	struct device_driver *drv = dev->driver;
 	int ret = 0;
 
-	if (!dev->driver)
+	if (!drv)
 		return 0;
 
-	pdrv = to_platform_driver(dev->driver);
-	if (pdrv->pm) {
-		if (pdrv->pm->resume_noirq)
-			ret = pdrv->pm->resume_noirq(dev);
+	if (drv->pm) {
+		if (drv->pm->resume_noirq)
+			ret = drv->pm->resume_noirq(dev);
 	} else {
 		ret = platform_legacy_resume_early(dev);
 	}
@@ -730,16 +732,15 @@ static int platform_pm_freeze(struct dev
 
 static int platform_pm_freeze_noirq(struct device *dev)
 {
-	struct platform_driver *pdrv;
+	struct device_driver *drv = dev->driver;
 	int ret = 0;
 
-	if (!dev->driver)
+	if (!drv)
 		return 0;
 
-	pdrv = to_platform_driver(dev->driver);
-	if (pdrv->pm) {
-		if (pdrv->pm->freeze_noirq)
-			ret = pdrv->pm->freeze_noirq(dev);
+	if (drv->pm) {
+		if (drv->pm->freeze_noirq)
+			ret = drv->pm->freeze_noirq(dev);
 	} else {
 		ret = platform_legacy_suspend_late(dev, PMSG_FREEZE);
 	}
@@ -752,7 +753,10 @@ static int platform_pm_thaw(struct devic
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
 
-	if (drv && drv->pm) {
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
 		if (drv->pm->thaw)
 			ret = drv->pm->thaw(dev);
 	} else {
@@ -764,16 +768,15 @@ static int platform_pm_thaw(struct devic
 
 static int platform_pm_thaw_noirq(struct device *dev)
 {
-	struct platform_driver *pdrv;
+	struct device_driver *drv = dev->driver;
 	int ret = 0;
 
-	if (!dev->driver)
+	if (!drv)
 		return 0;
 
-	pdrv = to_platform_driver(dev->driver);
-	if (pdrv->pm) {
-		if (pdrv->pm->thaw_noirq)
-			ret = pdrv->pm->thaw_noirq(dev);
+	if (drv->pm) {
+		if (drv->pm->thaw_noirq)
+			ret = drv->pm->thaw_noirq(dev);
 	} else {
 		ret = platform_legacy_resume_early(dev);
 	}
@@ -786,7 +789,10 @@ static int platform_pm_poweroff(struct d
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
 
-	if (drv && drv->pm) {
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
 		if (drv->pm->poweroff)
 			ret = drv->pm->poweroff(dev);
 	} else {
@@ -798,16 +804,15 @@ static int platform_pm_poweroff(struct d
 
 static int platform_pm_poweroff_noirq(struct device *dev)
 {
-	struct platform_driver *pdrv;
+	struct device_driver *drv = dev->driver;
 	int ret = 0;
 
-	if (!dev->driver)
+	if (!drv)
 		return 0;
 
-	pdrv = to_platform_driver(dev->driver);
-	if (pdrv->pm) {
-		if (pdrv->pm->poweroff_noirq)
-			ret = pdrv->pm->poweroff_noirq(dev);
+	if (drv->pm) {
+		if (drv->pm->poweroff_noirq)
+			ret = drv->pm->poweroff_noirq(dev);
 	} else {
 		ret = platform_legacy_suspend_late(dev, PMSG_HIBERNATE);
 	}
@@ -820,7 +825,10 @@ static int platform_pm_restore(struct de
 	struct device_driver *drv = dev->driver;
 	int ret = 0;
 
-	if (drv && drv->pm) {
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
 		if (drv->pm->restore)
 			ret = drv->pm->restore(dev);
 	} else {
@@ -832,16 +840,15 @@ static int platform_pm_restore(struct de
 
 static int platform_pm_restore_noirq(struct device *dev)
 {
-	struct platform_driver *pdrv;
+	struct device_driver *drv = dev->driver;
 	int ret = 0;
 
-	if (!dev->driver)
+	if (!drv)
 		return 0;
 
-	pdrv = to_platform_driver(dev->driver);
-	if (pdrv->pm) {
-		if (pdrv->pm->restore_noirq)
-			ret = pdrv->pm->restore_noirq(dev);
+	if (drv->pm) {
+		if (drv->pm->restore_noirq)
+			ret = drv->pm->restore_noirq(dev);
 	} else {
 		ret = platform_legacy_resume_early(dev);
 	}
@@ -862,17 +869,15 @@ static int platform_pm_restore_noirq(str
 
 #endif /* !CONFIG_HIBERNATION */
 
-static struct pm_ext_ops platform_pm_ops = {
-	.base = {
-		.prepare = platform_pm_prepare,
-		.complete = platform_pm_complete,
-		.suspend = platform_pm_suspend,
-		.resume = platform_pm_resume,
-		.freeze = platform_pm_freeze,
-		.thaw = platform_pm_thaw,
-		.poweroff = platform_pm_poweroff,
-		.restore = platform_pm_restore,
-	},
+static struct dev_pm_ops platform_dev_pm_ops = {
+	.prepare = platform_pm_prepare,
+	.complete = platform_pm_complete,
+	.suspend = platform_pm_suspend,
+	.resume = platform_pm_resume,
+	.freeze = platform_pm_freeze,
+	.thaw = platform_pm_thaw,
+	.poweroff = platform_pm_poweroff,
+	.restore = platform_pm_restore,
 	.suspend_noirq = platform_pm_suspend_noirq,
 	.resume_noirq = platform_pm_resume_noirq,
 	.freeze_noirq = platform_pm_freeze_noirq,
@@ -881,7 +886,7 @@ static struct pm_ext_ops platform_pm_ops
 	.restore_noirq = platform_pm_restore_noirq,
 };
 
-#define PLATFORM_PM_OPS_PTR	&platform_pm_ops
+#define PLATFORM_PM_OPS_PTR	(&platform_dev_pm_ops)
 
 #else /* !CONFIG_PM_SLEEP */
 
Index: linux-2.6/drivers/usb/core/usb.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/usb.c
+++ linux-2.6/drivers/usb/core/usb.c
@@ -286,7 +286,7 @@ static int usb_dev_restore(struct device
 	return usb_resume(dev);
 }
 
-static struct pm_ops usb_device_pm_ops = {
+static struct dev_pm_ops usb_device_pm_ops = {
 	.prepare =	usb_dev_prepare,
 	.complete =	usb_dev_complete,
 	.suspend =	usb_dev_suspend,
@@ -301,7 +301,7 @@ static struct pm_ops usb_device_pm_ops =
 
 #define ksuspend_usb_init()	0
 #define ksuspend_usb_cleanup()	do {} while (0)
-#define usb_device_pm_ops	(*(struct pm_ops *)0)
+#define usb_device_pm_ops	(*(struct dev_pm_ops *)0)
 
 #endif	/* CONFIG_PM */
 
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -112,7 +112,8 @@ void device_pm_remove(struct device *dev
  *	@ops:	PM operations to choose from.
  *	@state:	PM transition of the system being carried out.
  */
-static int pm_op(struct device *dev, struct pm_ops *ops, pm_message_t state)
+static int pm_op(struct device *dev, struct dev_pm_ops *ops,
+			pm_message_t state)
 {
 	int error = 0;
 
@@ -174,7 +175,7 @@ static int pm_op(struct device *dev, str
  *	The operation is executed with interrupts disabled by the only remaining
  *	functional CPU in the system.
  */
-static int pm_noirq_op(struct device *dev, struct pm_ext_ops *ops,
+static int pm_noirq_op(struct device *dev, struct dev_pm_ops *ops,
 			pm_message_t state)
 {
 	int error = 0;
@@ -355,7 +356,7 @@ static int resume_device(struct device *
 	if (dev->bus) {
 		if (dev->bus->pm) {
 			pm_dev_dbg(dev, state, "");
-			error = pm_op(dev, &dev->bus->pm->base, state);
+			error = pm_op(dev, dev->bus->pm, state);
 		} else if (dev->bus->resume) {
 			pm_dev_dbg(dev, state, "legacy ");
 			error = dev->bus->resume(dev);
@@ -440,9 +441,9 @@ static void complete_device(struct devic
 		dev->type->pm->complete(dev);
 	}
 
-	if (dev->bus && dev->bus->pm && dev->bus->pm->base.complete) {
+	if (dev->bus && dev->bus->pm && dev->bus->pm->complete) {
 		pm_dev_dbg(dev, state, "completing ");
-		dev->bus->pm->base.complete(dev);
+		dev->bus->pm->complete(dev);
 	}
 
 	up(&dev->sem);
@@ -600,7 +601,7 @@ static int suspend_device(struct device 
 	if (dev->bus) {
 		if (dev->bus->pm) {
 			pm_dev_dbg(dev, state, "");
-			error = pm_op(dev, &dev->bus->pm->base, state);
+			error = pm_op(dev, dev->bus->pm, state);
 		} else if (dev->bus->suspend) {
 			pm_dev_dbg(dev, state, "legacy ");
 			error = dev->bus->suspend(dev, state);
@@ -661,10 +662,10 @@ static int prepare_device(struct device 
 
 	down(&dev->sem);
 
-	if (dev->bus && dev->bus->pm && dev->bus->pm->base.prepare) {
+	if (dev->bus && dev->bus->pm && dev->bus->pm->prepare) {
 		pm_dev_dbg(dev, state, "preparing ");
-		error = dev->bus->pm->base.prepare(dev);
-		suspend_report_result(dev->bus->pm->base.prepare, error);
+		error = dev->bus->pm->prepare(dev);
+		suspend_report_result(dev->bus->pm->prepare, error);
 		if (error)
 			goto End;
 	}
