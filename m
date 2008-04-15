Return-Path: <linux-kernel-owner+w=401wt.eu-S1764154AbYDOT3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764154AbYDOT3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760695AbYDOT2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:28:23 -0400
Received: from ns1.suse.de ([195.135.220.2]:55852 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779AbYDOT2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:28:20 -0400
Subject: patch pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type.patch added to gregkh-2.6 tree
To: rjw@sisk.pl, akpm@linux-foundation.org, astarikovskiy@suse.de,
       benh@kernel.crashing.org, david-b@pacbell.net, greg@kroah.com,
       gregkh@suse.de, jbarnes@virtuousgeek.org, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, ncunningham@crca.org.au,
       oliver@neukum.org, pavel@ucw.cz, stern@rowland.harvard.edu
From: <gregkh@suse.de>
Date: Tue, 15 Apr 2008 12:27:31 -0700
In-Reply-To: <200804131533.50967.rjw@sisk.pl>
Message-ID: <12082876511507@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: PM: New suspend and hibernation callbacks for platform bus type

to my gregkh-2.6 tree.  Its filename is

     pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From rjw@sisk.pl  Tue Apr 15 12:21:10 2008
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sun, 13 Apr 2008 15:33:49 +0200
Subject: PM: New suspend and hibernation callbacks for platform bus type
To: Greg KH <greg@kroah.com>
Cc: pm list <linux-pm@lists.linux-foundation.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Alexey Starikovskiy <astarikovskiy@suse.de>, David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Oliver Neukum <oliver@neukum.org>, Nigel Cunningham <ncunningham@crca.org.au>, Jesse Barnes <jbarnes@virtuousgeek.org>, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <200804131533.50967.rjw@sisk.pl>
Content-Disposition: inline


From: Rafael J. Wysocki <rjw@sisk.pl>

Implement new suspend and hibernation callbacks for the platform bus
type.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/platform.c         |  296 ++++++++++++++++++++++++++++++++++++++--
 include/linux/platform_device.h |    1 
 2 files changed, 289 insertions(+), 8 deletions(-)

--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -453,6 +453,8 @@ int platform_driver_register(struct plat
 		drv->driver.suspend = platform_drv_suspend;
 	if (drv->resume)
 		drv->driver.resume = platform_drv_resume;
+	if (drv->pm)
+		drv->driver.pm = &drv->pm->base;
 	return driver_register(&drv->driver);
 }
 EXPORT_SYMBOL_GPL(platform_driver_register);
@@ -560,7 +562,9 @@ static int platform_match(struct device 
 	return (strncmp(pdev->name, drv->name, BUS_ID_SIZE) == 0);
 }
 
-static int platform_suspend(struct device *dev, pm_message_t mesg)
+#ifdef CONFIG_PM_SLEEP
+
+static int platform_legacy_suspend(struct device *dev, pm_message_t mesg)
 {
 	int ret = 0;
 
@@ -570,7 +574,7 @@ static int platform_suspend(struct devic
 	return ret;
 }
 
-static int platform_suspend_late(struct device *dev, pm_message_t mesg)
+static int platform_legacy_suspend_late(struct device *dev, pm_message_t mesg)
 {
 	struct platform_driver *drv = to_platform_driver(dev->driver);
 	struct platform_device *pdev;
@@ -583,7 +587,7 @@ static int platform_suspend_late(struct 
 	return ret;
 }
 
-static int platform_resume_early(struct device *dev)
+static int platform_legacy_resume_early(struct device *dev)
 {
 	struct platform_driver *drv = to_platform_driver(dev->driver);
 	struct platform_device *pdev;
@@ -596,7 +600,7 @@ static int platform_resume_early(struct 
 	return ret;
 }
 
-static int platform_resume(struct device *dev)
+static int platform_legacy_resume(struct device *dev)
 {
 	int ret = 0;
 
@@ -606,15 +610,291 @@ static int platform_resume(struct device
 	return ret;
 }
 
+static int platform_pm_prepare(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (drv && drv->pm && drv->pm->prepare)
+		ret = drv->pm->prepare(dev);
+
+	return ret;
+}
+
+static void platform_pm_complete(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+
+	if (drv && drv->pm && drv->pm->complete)
+		drv->pm->complete(dev);
+}
+
+#ifdef CONFIG_SUSPEND
+
+static int platform_pm_suspend(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (drv && drv->pm) {
+		if (drv->pm->suspend)
+			ret = drv->pm->suspend(dev);
+	} else {
+		ret = platform_legacy_suspend(dev, PMSG_SUSPEND);
+	}
+
+	return ret;
+}
+
+static int platform_pm_suspend_noirq(struct device *dev)
+{
+	struct platform_driver *pdrv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	pdrv = to_platform_driver(dev->driver);
+	if (pdrv->pm) {
+		if (pdrv->pm->suspend_noirq)
+			ret = pdrv->pm->suspend_noirq(dev);
+	} else {
+		ret = platform_legacy_suspend_late(dev, PMSG_SUSPEND);
+	}
+
+	return ret;
+}
+
+static int platform_pm_resume(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (drv && drv->pm) {
+		if (drv->pm->resume)
+			ret = drv->pm->resume(dev);
+	} else {
+		ret = platform_legacy_resume(dev);
+	}
+
+	return ret;
+}
+
+static int platform_pm_resume_noirq(struct device *dev)
+{
+	struct platform_driver *pdrv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	pdrv = to_platform_driver(dev->driver);
+	if (pdrv->pm) {
+		if (pdrv->pm->resume_noirq)
+			ret = pdrv->pm->resume_noirq(dev);
+	} else {
+		ret = platform_legacy_resume_early(dev);
+	}
+
+	return ret;
+}
+
+#else /* !CONFIG_SUSPEND */
+
+#define platform_pm_suspend		NULL
+#define platform_pm_resume		NULL
+#define platform_pm_suspend_noirq	NULL
+#define platform_pm_resume_noirq	NULL
+
+#endif /* !CONFIG_SUSPEND */
+
+#ifdef CONFIG_HIBERNATION
+
+static int platform_pm_freeze(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->freeze)
+			ret = drv->pm->freeze(dev);
+	} else {
+		ret = platform_legacy_suspend(dev, PMSG_FREEZE);
+	}
+
+	return ret;
+}
+
+static int platform_pm_freeze_noirq(struct device *dev)
+{
+	struct platform_driver *pdrv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	pdrv = to_platform_driver(dev->driver);
+	if (pdrv->pm) {
+		if (pdrv->pm->freeze_noirq)
+			ret = pdrv->pm->freeze_noirq(dev);
+	} else {
+		ret = platform_legacy_suspend_late(dev, PMSG_FREEZE);
+	}
+
+	return ret;
+}
+
+static int platform_pm_thaw(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (drv && drv->pm) {
+		if (drv->pm->thaw)
+			ret = drv->pm->thaw(dev);
+	} else {
+		ret = platform_legacy_resume(dev);
+	}
+
+	return ret;
+}
+
+static int platform_pm_thaw_noirq(struct device *dev)
+{
+	struct platform_driver *pdrv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	pdrv = to_platform_driver(dev->driver);
+	if (pdrv->pm) {
+		if (pdrv->pm->thaw_noirq)
+			ret = pdrv->pm->thaw_noirq(dev);
+	} else {
+		ret = platform_legacy_resume_early(dev);
+	}
+
+	return ret;
+}
+
+static int platform_pm_poweroff(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (drv && drv->pm) {
+		if (drv->pm->poweroff)
+			ret = drv->pm->poweroff(dev);
+	} else {
+		ret = platform_legacy_suspend(dev, PMSG_HIBERNATE);
+	}
+
+	return ret;
+}
+
+static int platform_pm_poweroff_noirq(struct device *dev)
+{
+	struct platform_driver *pdrv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	pdrv = to_platform_driver(dev->driver);
+	if (pdrv->pm) {
+		if (pdrv->pm->poweroff_noirq)
+			ret = pdrv->pm->poweroff_noirq(dev);
+	} else {
+		ret = platform_legacy_suspend_late(dev, PMSG_HIBERNATE);
+	}
+
+	return ret;
+}
+
+static int platform_pm_restore(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int ret = 0;
+
+	if (drv && drv->pm) {
+		if (drv->pm->restore)
+			ret = drv->pm->restore(dev);
+	} else {
+		ret = platform_legacy_resume(dev);
+	}
+
+	return ret;
+}
+
+static int platform_pm_restore_noirq(struct device *dev)
+{
+	struct platform_driver *pdrv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	pdrv = to_platform_driver(dev->driver);
+	if (pdrv->pm) {
+		if (pdrv->pm->restore_noirq)
+			ret = pdrv->pm->restore_noirq(dev);
+	} else {
+		ret = platform_legacy_resume_early(dev);
+	}
+
+	return ret;
+}
+
+#else /* !CONFIG_HIBERNATION */
+
+#define platform_pm_freeze		NULL
+#define platform_pm_thaw		NULL
+#define platform_pm_poweroff		NULL
+#define platform_pm_restore		NULL
+#define platform_pm_freeze_noirq	NULL
+#define platform_pm_thaw_noirq		NULL
+#define platform_pm_poweroff_noirq	NULL
+#define platform_pm_restore_noirq	NULL
+
+#endif /* !CONFIG_HIBERNATION */
+
+struct pm_ext_ops platform_pm_ops = {
+	.base = {
+		.prepare = platform_pm_prepare,
+		.complete = platform_pm_complete,
+		.suspend = platform_pm_suspend,
+		.resume = platform_pm_resume,
+		.freeze = platform_pm_freeze,
+		.thaw = platform_pm_thaw,
+		.poweroff = platform_pm_poweroff,
+		.restore = platform_pm_restore,
+	},
+	.suspend_noirq = platform_pm_suspend_noirq,
+	.resume_noirq = platform_pm_resume_noirq,
+	.freeze_noirq = platform_pm_freeze_noirq,
+	.thaw_noirq = platform_pm_thaw_noirq,
+	.poweroff_noirq = platform_pm_poweroff_noirq,
+	.restore_noirq = platform_pm_restore_noirq,
+};
+
+#define PLATFORM_PM_OPS_PTR	&platform_pm_ops
+
+#else /* !CONFIG_PM_SLEEP */
+
+#define PLATFORM_PM_OPS_PTR	NULL
+
+#endif /* !CONFIG_PM_SLEEP */
+
 struct bus_type platform_bus_type = {
 	.name		= "platform",
 	.dev_attrs	= platform_dev_attrs,
 	.match		= platform_match,
 	.uevent		= platform_uevent,
-	.suspend	= platform_suspend,
-	.suspend_late	= platform_suspend_late,
-	.resume_early	= platform_resume_early,
-	.resume		= platform_resume,
+	.pm		= PLATFORM_PM_OPS_PTR,
 };
 EXPORT_SYMBOL_GPL(platform_bus_type);
 
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -53,6 +53,7 @@ struct platform_driver {
 	int (*suspend_late)(struct platform_device *, pm_message_t state);
 	int (*resume_early)(struct platform_device *);
 	int (*resume)(struct platform_device *);
+	struct pm_ext_ops *pm;
 	struct device_driver driver;
 };
 


Patches currently in gregkh-2.6 which might be from rjw@sisk.pl are

driver-core/pm-remove-legacy-pm.patch
driver-core/power_state-remove-it-from-driver-core.patch
driver-core/pm-handle-device-registrations-during-suspend-resume.patch
driver-core/pm-convert-wakeup-flag-accessors-to-inline-functions.patch
driver-core/driver-core-call-device_pm_add-after-bus_add_device-in-device_add.patch
driver-core/pm-remove-destroy_suspended_device.patch
driver-core/pm-fix-misuse-of-wakeup-flag-accessors-in-serial-core.patch
driver-core/pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
driver-core/pm-introduce-new-top-level-suspend-and-hibernation-callbacks.patch
driver-core/pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type.patch
driver-core/pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type.patch
