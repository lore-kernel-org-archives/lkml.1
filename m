Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbYCZXKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbYCZXKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757027AbYCZXKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:10:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41712 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbYCZXKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:10:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 2/3] PM: New suspend and hibernation callbacks for platform bus type (rev. 2)
Date: Thu, 27 Mar 2008 00:05:53 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>
References: <200803262353.30566.rjw@sisk.pl>
In-Reply-To: <200803262353.30566.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803270005.54827.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Implement new suspend and hibernation callbacks for the platform bus
type.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/platform.c         |  321 +++++++++++++++++++++++++++++++++++++---
 include/linux/platform_device.h |    2 
 2 files changed, 302 insertions(+), 21 deletions(-)

Index: linux-2.6/include/linux/platform_device.h
===================================================================
--- linux-2.6.orig/include/linux/platform_device.h
+++ linux-2.6/include/linux/platform_device.h
@@ -53,6 +53,8 @@ struct platform_driver {
 	int (*suspend_late)(struct platform_device *, pm_message_t state);
 	int (*resume_early)(struct platform_device *);
 	int (*resume)(struct platform_device *);
+	struct pm_ops *pm;
+	struct pm_noirq_ops *pm_noirq;
 	struct device_driver driver;
 };
 
Index: linux-2.6/drivers/base/platform.c
===================================================================
--- linux-2.6.orig/drivers/base/platform.c
+++ linux-2.6/drivers/base/platform.c
@@ -560,61 +560,340 @@ static int platform_match(struct device 
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
+		if (drv->pm_noirq->suspend_noirq)
+			ret = drv->pm_noirq->suspend_noirq(dev);
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
+
+	return ret;
+}
+
+static int platform_pm_resume_noirq(struct device *dev)
+{
+	struct platform_driver *drv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->resume_noirq)
+			ret = drv->pm_noirq->resume_noirq(dev);
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
+#endif /* CONFIG_SUSPEND */
+
+#ifdef CONFIG_HIBERNATION
+static int platform_pm_freeze(struct device *dev)
+{
+	struct platform_driver *drv;
+	int ret = 0;
+
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
+
+	return ret;
+}
+
+static int platform_pm_freeze_noirq(struct device *dev)
+{
+	struct platform_driver *drv;
+	int ret = 0;
+
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->freeze_noirq)
+			ret = drv->pm_noirq->freeze_noirq(dev);
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
+		ret = dev->driver->resume(dev);
+	}
+
+	return ret;
+}
+
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
+		if (drv->pm_noirq->thaw_noirq)
+			ret = drv->pm_noirq->thaw_noirq(dev);
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
 
-static int platform_suspend_late(struct device *dev, pm_message_t mesg)
+static int platform_pm_poweroff(struct device *dev)
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
+	if (drv->pm) {
+		if (drv->pm->poweroff)
+			ret = drv->pm->poweroff(dev);
+	} else if (dev->driver->suspend) {
+		/* Legacy mechanism */
+		ret = dev->driver->suspend(dev, PMSG_HIBERNATE);
+	}
 
 	return ret;
 }
 
-static int platform_resume_early(struct device *dev)
+static int platform_pm_poweroff_noirq(struct device *dev)
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
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->poweroff_noirq)
+			ret = drv->pm_noirq->poweroff_noirq(dev);
+	} else {
+		/* Legacy mechanism */
+		struct platform_device *pdev;
+
+		pdev = container_of(dev, struct platform_device, dev);
+		if (drv->suspend_late)
+			ret = drv->suspend_late(pdev, PMSG_HIBERNATE);
+	}
 
 	return ret;
 }
 
-static int platform_resume(struct device *dev)
+static int platform_pm_restore(struct device *dev)
 {
+	struct platform_driver *drv;
 	int ret = 0;
 
-	if (dev->driver && dev->driver->resume)
+	if (!dev->driver)
+		return 0;
+
+	drv = to_platform_driver(dev->driver);
+	if (drv->pm) {
+		if (drv->pm->restore)
+			ret = drv->pm->restore(dev);
+	} else if (dev->driver->resume) {
+		/* Legacy mechanism */
 		ret = dev->driver->resume(dev);
+	}
 
 	return ret;
 }
 
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
+		if (drv->pm_noirq->restore_noirq)
+			ret = drv->pm_noirq->restore_noirq(dev);
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
+	.restore = platform_pm_restore,
+#endif
+};
+
+struct pm_noirq_ops platform_pm_noirq_ops = {
+#ifdef CONFIG_SUSPEND
+	.suspend_noirq = platform_pm_suspend_noirq,
+	.resume_noirq = platform_pm_resume_noirq,
+#endif
+#ifdef CONFIG_HIBERNATION
+	.freeze_noirq = platform_pm_freeze_noirq,
+	.thaw_noirq = platform_pm_thaw_noirq,
+	.poweroff_noirq = platform_pm_poweroff_noirq,
+	.restore_noirq = platform_pm_restore_noirq,
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
+	.pm_noirq	= &platform_pm_noirq_ops,
 };
 EXPORT_SYMBOL_GPL(platform_bus_type);
 

