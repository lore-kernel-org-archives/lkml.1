Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbYCPX1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbYCPX1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbYCPX0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:26:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37738 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554AbYCPX0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:26:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 2/3] PM: New suspend and hibernation callbacks for platform bus type
Date: Mon, 17 Mar 2008 00:24:22 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>
References: <200803170020.55473.rjw@sisk.pl>
In-Reply-To: <200803170020.55473.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803170024.23451.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Implement new suspend and hibernation callbacks for the platform bus
type.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/platform.c         |  444 ++++++++++++++++++++++++++++++++++++++--
 include/linux/platform_device.h |    2 
 2 files changed, 425 insertions(+), 21 deletions(-)

Index: linux-2.6/include/linux/platform_device.h
===================================================================
--- linux-2.6.orig/include/linux/platform_device.h
+++ linux-2.6/include/linux/platform_device.h
@@ -53,6 +53,8 @@ struct platform_driver {
 	int (*suspend_late)(struct platform_device *, pm_message_t state);
 	int (*resume_early)(struct platform_device *);
 	int (*resume)(struct platform_device *);
+	struct pm_ops *pm;
+	struct pm_ops *pm_noirq;
 	struct device_driver driver;
 };
 
Index: linux-2.6/drivers/base/platform.c
===================================================================
--- linux-2.6.orig/drivers/base/platform.c
+++ linux-2.6/drivers/base/platform.c
@@ -560,61 +560,463 @@ static int platform_match(struct device 
 	return (strncmp(pdev->name, drv->name, BUS_ID_SIZE) == 0);
 }
 
-static int platform_suspend(struct device *dev, pm_message_t mesg)
+#ifdef CONFIG_PM_SLEEP
+static int platform_pm_prepare(struct device *dev)
 {
+	struct platform_driver *drv;
 	int ret = 0;
 
-	if (dev->driver && dev->driver->suspend)
-		ret = dev->driver->suspend(dev, mesg);
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm && drv->pm->prepare)
+		ret = drv->pm->prepare(dev);
+
+	return ret;
+}
+
+static int platform_pm_prepare_noirq(struct device *dev)
+{
+	struct platform_driver *drv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm_noirq && drv->pm_noirq->prepare)
+		ret = drv->pm_noirq->prepare(dev);
+
+	return ret;
+}
+
+static void platform_pm_complete(struct device *dev)
+{
+	struct platform_driver *drv;
+
+	if (!dev->driver)
+		return;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm && drv->pm->complete)
+		drv->pm->complete(dev);
+}
+
+static void platform_pm_complete_noirq(struct device *dev)
+{
+	struct platform_driver *drv;
+
+	if (!dev->driver)
+		return;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm_noirq && drv->pm_noirq->complete)
+		drv->pm_noirq->complete(dev);
+}
+
+#ifdef CONFIG_SUSPEND
+static int platform_pm_suspend(struct device *dev)
+{
+	struct platform_driver *drv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm) {
+		if (drv->pm->suspend)
+			ret = drv->pm->suspend(dev);
+	} else if (dev->driver->suspend) {
+		/* Legacy mechanism */
+		ret = dev->driver->suspend(dev, PMSG_SUSPEND);
+	}
+
+	return ret;
+}
+
+static int platform_pm_suspend_noirq(struct device *dev)
+{
+	struct platform_driver *drv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->suspend)
+			ret = drv->pm_noirq->suspend(dev);
+	} else {
+		/* Legacy mechanism */
+		struct platform_device *pdev;
+
+		pdev = container_of(dev, struct platform_device, dev);
+		if (drv->suspend_late)
+			ret = drv->suspend_late(pdev, PMSG_SUSPEND);
+	}
+
+	return ret;
+}
+
+static int platform_pm_resume(struct device *dev)
+{
+	struct platform_driver *drv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm) {
+		if (drv->pm->resume)
+			ret = drv->pm->resume(dev);
+	} else if (dev->driver->resume) {
+		/* Legacy mechanism */
+		ret = dev->driver->resume(dev);
+	}
 
 	return ret;
 }
 
-static int platform_suspend_late(struct device *dev, pm_message_t mesg)
+static int platform_pm_resume_noirq(struct device *dev)
 {
-	struct platform_driver *drv = to_platform_driver(dev->driver);
-	struct platform_device *pdev;
+	struct platform_driver *drv;
 	int ret = 0;
 
-	pdev = container_of(dev, struct platform_device, dev);
-	if (dev->driver && drv->suspend_late)
-		ret = drv->suspend_late(pdev, mesg);
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->resume)
+			ret = drv->pm_noirq->resume(dev);
+	} else {
+		/* Legacy mechanism */
+		struct platform_device *pdev;
+
+		pdev = container_of(dev, struct platform_device, dev);
+		if (drv->resume_early)
+			ret = drv->resume_early(pdev);
+	}
 
 	return ret;
 }
+#endif /* CONFIG_SUSPEND */
 
-static int platform_resume_early(struct device *dev)
+#ifdef CONFIG_HIBERNATION
+static int platform_pm_freeze(struct device *dev)
 {
-	struct platform_driver *drv = to_platform_driver(dev->driver);
-	struct platform_device *pdev;
+	struct platform_driver *drv;
 	int ret = 0;
 
-	pdev = container_of(dev, struct platform_device, dev);
-	if (dev->driver && drv->resume_early)
-		ret = drv->resume_early(pdev);
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm) {
+		if (drv->pm->freeze)
+			ret = drv->pm->freeze(dev);
+	} else if (dev->driver->suspend) {
+		/* Legacy mechanism */
+		ret = dev->driver->suspend(dev, PMSG_FREEZE);
+	}
 
 	return ret;
 }
 
-static int platform_resume(struct device *dev)
+static int platform_pm_freeze_noirq(struct device *dev)
 {
+	struct platform_driver *drv;
 	int ret = 0;
 
-	if (dev->driver && dev->driver->resume)
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->freeze)
+			ret = drv->pm_noirq->freeze(dev);
+	} else {
+		/* Legacy mechanism */
+		struct platform_device *pdev;
+
+		pdev = container_of(dev, struct platform_device, dev);
+		if (drv->suspend_late)
+			ret = drv->suspend_late(pdev, PMSG_FREEZE);
+	}
+
+	return ret;
+}
+
+static int platform_pm_thaw(struct device *dev)
+{
+	struct platform_driver *drv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm) {
+		if (drv->pm->thaw)
+			ret = drv->pm->thaw(dev);
+	} else if (dev->driver->resume) {
+		/* Legacy mechanism */
 		ret = dev->driver->resume(dev);
+	}
 
 	return ret;
 }
 
+static int platform_pm_thaw_noirq(struct device *dev)
+{
+	struct platform_driver *drv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->thaw)
+			ret = drv->pm_noirq->thaw(dev);
+	} else {
+		/* Legacy mechanism */
+		struct platform_device *pdev;
+
+		pdev = container_of(dev, struct platform_device, dev);
+		if (drv->resume_early)
+			ret = drv->resume_early(pdev);
+	}
+
+	return ret;
+}
+
+static int platform_pm_poweroff(struct device *dev)
+{
+	struct platform_driver *drv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm) {
+		if (drv->pm->poweroff)
+			ret = drv->pm->poweroff(dev);
+	} else if (dev->driver->suspend) {
+		/* Legacy mechanism */
+		ret = dev->driver->suspend(dev, PMSG_HIBERNATE);
+	}
+
+	return ret;
+}
+
+static int platform_pm_poweroff_noirq(struct device *dev)
+{
+	struct platform_driver *drv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->poweroff)
+			ret = drv->pm_noirq->poweroff(dev);
+	} else {
+		/* Legacy mechanism */
+		struct platform_device *pdev;
+
+		pdev = container_of(dev, struct platform_device, dev);
+		if (drv->suspend_late)
+			ret = drv->suspend_late(pdev, PMSG_HIBERNATE);
+	}
+
+	return ret;
+}
+
+static int platform_pm_quiesce(struct device *dev)
+{
+	struct platform_driver *drv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm) {
+		if (drv->pm->quiesce)
+			ret = drv->pm->quiesce(dev);
+	} else if (dev->driver->suspend) {
+		/* Legacy mechanism */
+		ret = dev->driver->suspend(dev, PMSG_QUIESCE);
+	}
+
+	return ret;
+}
+
+static int platform_pm_quiesce_noirq(struct device *dev)
+{
+	struct platform_driver *drv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->quiesce)
+			ret = drv->pm_noirq->quiesce(dev);
+	} else {
+		/* Legacy mechanism */
+		struct platform_device *pdev;
+
+		pdev = container_of(dev, struct platform_device, dev);
+		if (drv->suspend_late)
+			ret = drv->suspend_late(pdev, PMSG_QUIESCE);
+	}
+
+	return ret;
+}
+
+static int platform_pm_restore(struct device *dev)
+{
+	struct platform_driver *drv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm) {
+		if (drv->pm->restore)
+			ret = drv->pm->restore(dev);
+	} else if (dev->driver->resume) {
+		/* Legacy mechanism */
+		ret = dev->driver->resume(dev);
+	}
+
+	return ret;
+}
+
+static int platform_pm_restore_noirq(struct device *dev)
+{
+	struct platform_driver *drv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->restore)
+			ret = drv->pm_noirq->restore(dev);
+	} else {
+		/* Legacy mechanism */
+		struct platform_device *pdev;
+
+		pdev = container_of(dev, struct platform_device, dev);
+		if (drv->resume_early)
+			ret = drv->resume_early(pdev);
+	}
+
+	return ret;
+}
+
+static int platform_pm_recover(struct device *dev)
+{
+	struct platform_driver *drv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm) {
+		if (drv->pm->recover)
+			ret = drv->pm->recover(dev);
+	} else if (dev->driver->resume) {
+		/* Legacy mechanism */
+		ret = dev->driver->resume(dev);
+	}
+
+	return ret;
+}
+
+static int platform_pm_recover_noirq(struct device *dev)
+{
+	struct platform_driver *drv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->recover)
+			ret = drv->pm_noirq->recover(dev);
+	} else {
+		/* Legacy mechanism */
+		struct platform_device *pdev;
+
+		pdev = container_of(dev, struct platform_device, dev);
+		if (drv->resume_early)
+			ret = drv->resume_early(pdev);
+	}
+
+	return ret;
+}
+#endif /* CONFIG_HIBERNATION */
+#endif /* CONFIG_PM_SLEEP */
+
+struct pm_ops platform_pm_ops = {
+#ifdef CONFIG_PM_SLEEP
+	.prepare = platform_pm_prepare,
+	.complete = platform_pm_complete,
+#endif
+#ifdef CONFIG_SUSPEND
+	.suspend = platform_pm_suspend,
+	.resume = platform_pm_resume,
+#endif
+#ifdef CONFIG_HIBERNATION
+	.freeze = platform_pm_freeze,
+	.thaw = platform_pm_thaw,
+	.poweroff = platform_pm_poweroff,
+	.quiesce = platform_pm_quiesce,
+	.restore = platform_pm_restore,
+	.recover = platform_pm_recover,
+#endif
+};
+
+struct pm_ops platform_pm_ops_noirq = {
+#ifdef CONFIG_PM_SLEEP
+	.prepare = platform_pm_prepare_noirq,
+	.complete = platform_pm_complete_noirq,
+#endif
+#ifdef CONFIG_SUSPEND
+	.suspend = platform_pm_suspend_noirq,
+	.resume = platform_pm_resume_noirq,
+#endif
+#ifdef CONFIG_HIBERNATION
+	.freeze = platform_pm_freeze_noirq,
+	.thaw = platform_pm_thaw_noirq,
+	.poweroff = platform_pm_poweroff_noirq,
+	.quiesce = platform_pm_quiesce_noirq,
+	.restore = platform_pm_restore_noirq,
+	.recover = platform_pm_recover_noirq,
+#endif
+};
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
+	.pm		= &platform_pm_ops,
+	.pm_noirq	= &platform_pm_ops_noirq,
 };
 EXPORT_SYMBOL_GPL(platform_bus_type);
 

