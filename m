Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbZAFWNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbZAFWNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZAFWNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:19 -0500
Received: from kroah.org ([198.145.64.141]:51160 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750980AbZAFWNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:16 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/60] PM: Simplify the new suspend/hibernation framework for devices
Date: Tue,  6 Jan 2009 14:11:20 -0800
Message-Id: <1231279939-32728-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Acked-by: Pavel Machek <pavel@suse.cz>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c         |  115 ++++++++++++++++++++-------------------
 drivers/base/power/main.c       |   19 ++++---
 drivers/pci/pci-driver.c        |   46 ++++++----------
 drivers/usb/core/usb.c          |    4 +-
 include/linux/device.h          |    8 ++--
 include/linux/pci.h             |    1 -
 include/linux/platform_device.h |    1 -
 include/linux/pm.h              |   76 +++++++++-----------------
 8 files changed, 119 insertions(+), 151 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index dfcbfe5..6c743b6 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -503,8 +503,6 @@ int platform_driver_register(struct platform_driver *drv)
 		drv->driver.suspend = platform_drv_suspend;
 	if (drv->resume)
 		drv->driver.resume = platform_drv_resume;
-	if (drv->pm)
-		drv->driver.pm = &drv->pm->base;
 	return driver_register(&drv->driver);
 }
 EXPORT_SYMBOL_GPL(platform_driver_register);
@@ -686,7 +684,10 @@ static int platform_pm_suspend(struct device *dev)
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
@@ -698,16 +699,15 @@ static int platform_pm_suspend(struct device *dev)
 
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
@@ -720,7 +720,10 @@ static int platform_pm_resume(struct device *dev)
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
@@ -732,16 +735,15 @@ static int platform_pm_resume(struct device *dev)
 
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
@@ -780,16 +782,15 @@ static int platform_pm_freeze(struct device *dev)
 
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
@@ -802,7 +803,10 @@ static int platform_pm_thaw(struct device *dev)
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
@@ -814,16 +818,15 @@ static int platform_pm_thaw(struct device *dev)
 
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
@@ -836,7 +839,10 @@ static int platform_pm_poweroff(struct device *dev)
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
@@ -848,16 +854,15 @@ static int platform_pm_poweroff(struct device *dev)
 
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
@@ -870,7 +875,10 @@ static int platform_pm_restore(struct device *dev)
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
@@ -882,16 +890,15 @@ static int platform_pm_restore(struct device *dev)
 
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
@@ -912,17 +919,15 @@ static int platform_pm_restore_noirq(struct device *dev)
 
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
@@ -931,7 +936,7 @@ static struct pm_ext_ops platform_pm_ops = {
 	.restore_noirq = platform_pm_restore_noirq,
 };
 
-#define PLATFORM_PM_OPS_PTR	&platform_pm_ops
+#define PLATFORM_PM_OPS_PTR	(&platform_dev_pm_ops)
 
 #else /* !CONFIG_PM_SLEEP */
 
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 692c20b..a8e4dcb 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -112,7 +112,8 @@ void device_pm_remove(struct device *dev)
  *	@ops:	PM operations to choose from.
  *	@state:	PM transition of the system being carried out.
  */
-static int pm_op(struct device *dev, struct pm_ops *ops, pm_message_t state)
+static int pm_op(struct device *dev, struct dev_pm_ops *ops,
+			pm_message_t state)
 {
 	int error = 0;
 
@@ -174,7 +175,7 @@ static int pm_op(struct device *dev, struct pm_ops *ops, pm_message_t state)
  *	The operation is executed with interrupts disabled by the only remaining
  *	functional CPU in the system.
  */
-static int pm_noirq_op(struct device *dev, struct pm_ext_ops *ops,
+static int pm_noirq_op(struct device *dev, struct dev_pm_ops *ops,
 			pm_message_t state)
 {
 	int error = 0;
@@ -354,7 +355,7 @@ static int resume_device(struct device *dev, pm_message_t state)
 	if (dev->bus) {
 		if (dev->bus->pm) {
 			pm_dev_dbg(dev, state, "");
-			error = pm_op(dev, &dev->bus->pm->base, state);
+			error = pm_op(dev, dev->bus->pm, state);
 		} else if (dev->bus->resume) {
 			pm_dev_dbg(dev, state, "legacy ");
 			error = dev->bus->resume(dev);
@@ -451,9 +452,9 @@ static void complete_device(struct device *dev, pm_message_t state)
 		dev->type->pm->complete(dev);
 	}
 
-	if (dev->bus && dev->bus->pm && dev->bus->pm->base.complete) {
+	if (dev->bus && dev->bus->pm && dev->bus->pm->complete) {
 		pm_dev_dbg(dev, state, "completing ");
-		dev->bus->pm->base.complete(dev);
+		dev->bus->pm->complete(dev);
 	}
 
 	up(&dev->sem);
@@ -624,7 +625,7 @@ static int suspend_device(struct device *dev, pm_message_t state)
 	if (dev->bus) {
 		if (dev->bus->pm) {
 			pm_dev_dbg(dev, state, "");
-			error = pm_op(dev, &dev->bus->pm->base, state);
+			error = pm_op(dev, dev->bus->pm, state);
 		} else if (dev->bus->suspend) {
 			pm_dev_dbg(dev, state, "legacy ");
 			error = dev->bus->suspend(dev, state);
@@ -685,10 +686,10 @@ static int prepare_device(struct device *dev, pm_message_t state)
 
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
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index b4cdd69..4042d21 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -433,8 +433,7 @@ static int pci_pm_suspend(struct device *dev)
 
 static int pci_pm_suspend_noirq(struct device *dev)
 {
-	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct pci_driver *drv = pci_dev->driver;
+	struct device_driver *drv = dev->driver;
 	int error = 0;
 
 	if (drv && drv->pm) {
@@ -469,11 +468,10 @@ static int pci_pm_resume(struct device *dev)
 
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
@@ -519,8 +517,7 @@ static int pci_pm_freeze(struct device *dev)
 
 static int pci_pm_freeze_noirq(struct device *dev)
 {
-	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct pci_driver *drv = pci_dev->driver;
+	struct device_driver *drv = dev->driver;
 	int error = 0;
 
 	if (drv && drv->pm) {
@@ -553,15 +550,14 @@ static int pci_pm_thaw(struct device *dev)
 
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
 
@@ -589,8 +585,7 @@ static int pci_pm_poweroff(struct device *dev)
 
 static int pci_pm_poweroff_noirq(struct device *dev)
 {
-	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct pci_driver *drv = pci_dev->driver;
+	struct device_driver *drv = dev->driver;
 	int error = 0;
 
 	if (drv && drv->pm) {
@@ -625,7 +620,7 @@ static int pci_pm_restore(struct device *dev)
 static int pci_pm_restore_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct pci_driver *drv = pci_dev->driver;
+	struct device_driver *drv = dev->driver;
 	int error = 0;
 
 	pci_fixup_device(pci_fixup_resume, pci_dev);
@@ -654,17 +649,15 @@ static int pci_pm_restore_noirq(struct device *dev)
 
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
 
@@ -703,9 +696,6 @@ int __pci_register_driver(struct pci_driver *drv, struct module *owner,
 	drv->driver.owner = owner;
 	drv->driver.mod_name = mod_name;
 
-	if (drv->pm)
-		drv->driver.pm = &drv->pm->base;
-
 	spin_lock_init(&drv->dynids.lock);
 	INIT_LIST_HEAD(&drv->dynids.list);
 
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index be1fa07..399e15f 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -286,7 +286,7 @@ static int usb_dev_restore(struct device *dev)
 	return usb_resume(dev);
 }
 
-static struct pm_ops usb_device_pm_ops = {
+static struct dev_pm_ops usb_device_pm_ops = {
 	.prepare =	usb_dev_prepare,
 	.complete =	usb_dev_complete,
 	.suspend =	usb_dev_suspend,
@@ -301,7 +301,7 @@ static struct pm_ops usb_device_pm_ops = {
 
 #define ksuspend_usb_init()	0
 #define ksuspend_usb_cleanup()	do {} while (0)
-#define usb_device_pm_ops	(*(struct pm_ops *)0)
+#define usb_device_pm_ops	(*(struct dev_pm_ops *)0)
 
 #endif	/* CONFIG_PM */
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 1a3686d..4a52005 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
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
@@ -198,7 +198,7 @@ struct class {
 	int (*suspend)(struct device *dev, pm_message_t state);
 	int (*resume)(struct device *dev);
 
-	struct pm_ops *pm;
+	struct dev_pm_ops *pm;
 	struct class_private *p;
 };
 
@@ -291,7 +291,7 @@ struct device_type {
 	int (*suspend)(struct device *dev, pm_message_t state);
 	int (*resume)(struct device *dev);
 
-	struct pm_ops *pm;
+	struct dev_pm_ops *pm;
 };
 
 /* interface for exporting device attributes */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 03b0b8c..4bb156b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -421,7 +421,6 @@ struct pci_driver {
 	int  (*resume_early) (struct pci_dev *dev);
 	int  (*resume) (struct pci_dev *dev);	                /* Device woken up */
 	void (*shutdown) (struct pci_dev *dev);
-	struct pm_ext_ops *pm;
 	struct pci_error_handlers *err_handler;
 	struct device_driver	driver;
 	struct pci_dynids dynids;
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 4b8cc6a..9a34269 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -55,7 +55,6 @@ struct platform_driver {
 	int (*suspend_late)(struct platform_device *, pm_message_t state);
 	int (*resume_early)(struct platform_device *);
 	int (*resume)(struct platform_device *);
-	struct pm_ext_ops *pm;
 	struct device_driver driver;
 };
 
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 42de400..5785666 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
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
-- 
1.6.0.4

