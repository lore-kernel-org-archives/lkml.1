Return-Path: <linux-kernel-owner+w=401wt.eu-S1762857AbYD3MKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762857AbYD3MKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 08:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759639AbYD3MJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 08:09:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43851 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758207AbYD3MJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 08:09:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: PM: New suspend and hibernation callbacks for PCI bus type
Date: Wed, 30 Apr 2008 14:09:24 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200804131534.52548.rjw@sisk.pl> <20080429222658.GA5437@kroah.com>
In-Reply-To: <20080429222658.GA5437@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804301409.26554.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 30 of April 2008, Greg KH wrote:
> On Sun, Apr 13, 2008 at 03:34:51PM +0200, Rafael J. Wysocki wrote:
> > 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Implement new suspend and hibernation callbacks for the PCI bus type.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> > Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Changes in Linus's tree broke merging this one really badly, so much so
> that I can't see what should be done with a quick scan.
> 
> I'll drop this from my tree for now, can you regenerate it?

I've already had regenerated it.  The version below applies to the current -git.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Implement new suspend and hibernation callbacks for the PCI bus type.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/pci-driver.c |  376 ++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/pci.h      |    2 
 2 files changed, 337 insertions(+), 41 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -274,7 +274,57 @@ static int pci_device_remove(struct devi
 	return 0;
 }
 
-static int pci_device_suspend(struct device * dev, pm_message_t state)
+static void pci_device_shutdown(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+
+	if (drv && drv->shutdown)
+		drv->shutdown(pci_dev);
+	pci_msi_shutdown(pci_dev);
+	pci_msix_shutdown(pci_dev);
+}
+
+#ifdef CONFIG_PM_SLEEP
+
+/*
+ * Default "suspend" method for devices that have no driver provided suspend,
+ * or not even a driver at all.
+ */
+static void pci_default_pm_suspend(struct pci_dev *pci_dev)
+{
+	pci_save_state(pci_dev);
+	/*
+	 * mark its power state as "unknown", since we don't know if
+	 * e.g. the BIOS will change its device state when we suspend.
+	 */
+	if (pci_dev->current_state == PCI_D0)
+		pci_dev->current_state = PCI_UNKNOWN;
+}
+
+/*
+ * Default "resume" method for devices that have no driver provided resume,
+ * or not even a driver at all.
+ */
+static int pci_default_pm_resume(struct pci_dev *pci_dev)
+{
+	int retval = 0;
+
+	/* restore the PCI config space */
+	pci_restore_state(pci_dev);
+	/* if the device was enabled before suspend, reenable */
+	retval = pci_reenable_device(pci_dev);
+	/*
+	 * if the device was busmaster before the suspend, make it busmaster
+	 * again
+	 */
+	if (pci_dev->is_busmaster)
+		pci_set_master(pci_dev);
+
+	return retval;
+}
+
+static int pci_legacy_suspend(struct device *dev, pm_message_t state)
 {
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
@@ -284,18 +334,12 @@ static int pci_device_suspend(struct dev
 		i = drv->suspend(pci_dev, state);
 		suspend_report_result(drv->suspend, i);
 	} else {
-		pci_save_state(pci_dev);
-		/*
-		 * mark its power state as "unknown", since we don't know if
-		 * e.g. the BIOS will change its device state when we suspend.
-		 */
-		if (pci_dev->current_state == PCI_D0)
-			pci_dev->current_state = PCI_UNKNOWN;
+		pci_default_pm_suspend(pci_dev);
 	}
 	return i;
 }
 
-static int pci_device_suspend_late(struct device * dev, pm_message_t state)
+static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
 {
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
@@ -308,26 +352,7 @@ static int pci_device_suspend_late(struc
 	return i;
 }
 
-/*
- * Default resume method for devices that have no driver provided resume,
- * or not even a driver at all.
- */
-static int pci_default_resume(struct pci_dev *pci_dev)
-{
-	int retval = 0;
-
-	/* restore the PCI config space */
-	pci_restore_state(pci_dev);
-	/* if the device was enabled before suspend, reenable */
-	retval = pci_reenable_device(pci_dev);
-	/* if the device was busmaster before the suspend, make it busmaster again */
-	if (pci_dev->is_busmaster)
-		pci_set_master(pci_dev);
-
-	return retval;
-}
-
-static int pci_device_resume(struct device * dev)
+static int pci_legacy_resume(struct device *dev)
 {
 	int error;
 	struct pci_dev * pci_dev = to_pci_dev(dev);
@@ -336,11 +361,11 @@ static int pci_device_resume(struct devi
 	if (drv && drv->resume)
 		error = drv->resume(pci_dev);
 	else
-		error = pci_default_resume(pci_dev);
+		error = pci_default_pm_resume(pci_dev);
 	return error;
 }
 
-static int pci_device_resume_early(struct device * dev)
+static int pci_legacy_resume_early(struct device *dev)
 {
 	int error = 0;
 	struct pci_dev * pci_dev = to_pci_dev(dev);
@@ -353,17 +378,288 @@ static int pci_device_resume_early(struc
 	return error;
 }
 
-static void pci_device_shutdown(struct device *dev)
+static int pci_pm_prepare(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int error = 0;
+
+	if (drv && drv->pm && drv->pm->prepare)
+		error = drv->pm->prepare(dev);
+
+	return error;
+}
+
+static void pci_pm_complete(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+
+	if (drv && drv->pm && drv->pm->complete)
+		drv->pm->complete(dev);
+}
+
+#ifdef CONFIG_SUSPEND
+
+static int pci_pm_suspend(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct device_driver *drv = dev->driver;
+	int error = 0;
+
+	if (drv && drv->pm) {
+		if (drv->pm->suspend) {
+			error = drv->pm->suspend(dev);
+			suspend_report_result(drv->pm->suspend, error);
+		} else {
+			pci_default_pm_suspend(pci_dev);
+		}
+	} else {
+		error = pci_legacy_suspend(dev, PMSG_SUSPEND);
+	}
+
+	return error;
+}
+
+static int pci_pm_suspend_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *drv = pci_dev->driver;
+	int error = 0;
 
-	if (drv && drv->shutdown)
-		drv->shutdown(pci_dev);
-	pci_msi_shutdown(pci_dev);
-	pci_msix_shutdown(pci_dev);
+	if (drv && drv->pm) {
+		if (drv->pm->suspend_noirq) {
+			error = drv->pm->suspend_noirq(dev);
+			suspend_report_result(drv->pm->suspend_noirq, error);
+		}
+	} else {
+		error = pci_legacy_suspend_late(dev, PMSG_SUSPEND);
+	}
+
+	return error;
 }
 
+static int pci_pm_resume(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct device_driver *drv = dev->driver;
+	int error;
+
+	if (drv && drv->pm) {
+		error = drv->pm->resume ? drv->pm->resume(dev) :
+			pci_default_pm_resume(pci_dev);
+	} else {
+		error = pci_legacy_resume(dev);
+	}
+
+	return error;
+}
+
+static int pci_pm_resume_noirq(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+	int error = 0;
+
+	pci_fixup_device(pci_fixup_resume, pci_dev);
+
+	if (drv && drv->pm) {
+		if (drv->pm->resume_noirq)
+			error = drv->pm->resume_noirq(dev);
+	} else {
+		error = pci_legacy_resume_early(dev);
+	}
+
+	return error;
+}
+
+#else /* !CONFIG_SUSPEND */
+
+#define pci_pm_suspend		NULL
+#define pci_pm_suspend_noirq	NULL
+#define pci_pm_resume		NULL
+#define pci_pm_resume_noirq	NULL
+
+#endif /* !CONFIG_SUSPEND */
+
+#ifdef CONFIG_HIBERNATION
+
+static int pci_pm_freeze(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct device_driver *drv = dev->driver;
+	int error = 0;
+
+	if (drv && drv->pm) {
+		if (drv->pm->freeze) {
+			error = drv->pm->freeze(dev);
+			suspend_report_result(drv->pm->freeze, error);
+		} else {
+			pci_default_pm_suspend(pci_dev);
+		}
+	} else {
+		error = pci_legacy_suspend(dev, PMSG_FREEZE);
+	}
+
+	return error;
+}
+
+static int pci_pm_freeze_noirq(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+	int error = 0;
+
+	if (drv && drv->pm) {
+		if (drv->pm->freeze_noirq) {
+			error = drv->pm->freeze_noirq(dev);
+			suspend_report_result(drv->pm->freeze_noirq, error);
+		}
+	} else {
+		error = pci_legacy_suspend_late(dev, PMSG_FREEZE);
+	}
+
+	return error;
+}
+
+static int pci_pm_thaw(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int error = 0;
+
+	if (drv && drv->pm) {
+		if (drv->pm->thaw)
+			error =  drv->pm->thaw(dev);
+	} else {
+		error = pci_legacy_resume(dev);
+	}
+
+	return error;
+}
+
+static int pci_pm_thaw_noirq(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+	int error = 0;
+
+	if (drv && drv->pm) {
+		if (drv->pm->thaw_noirq)
+			error = drv->pm->thaw_noirq(dev);
+	} else {
+		error = pci_legacy_resume_early(dev);
+	}
+
+	return error;
+}
+
+static int pci_pm_poweroff(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	int error = 0;
+
+	if (drv && drv->pm) {
+		if (drv->pm->poweroff) {
+			error = drv->pm->poweroff(dev);
+			suspend_report_result(drv->pm->poweroff, error);
+		}
+	} else {
+		error = pci_legacy_suspend(dev, PMSG_HIBERNATE);
+	}
+
+	return error;
+}
+
+static int pci_pm_poweroff_noirq(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+	int error = 0;
+
+	if (drv && drv->pm) {
+		if (drv->pm->poweroff_noirq) {
+			error = drv->pm->poweroff_noirq(dev);
+			suspend_report_result(drv->pm->poweroff_noirq, error);
+		}
+	} else {
+		error = pci_legacy_suspend_late(dev, PMSG_HIBERNATE);
+	}
+
+	return error;
+}
+
+static int pci_pm_restore(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct device_driver *drv = dev->driver;
+	int error;
+
+	if (drv && drv->pm) {
+		error = drv->pm->restore ? drv->pm->restore(dev) :
+			pci_default_pm_resume(pci_dev);
+	} else {
+		error = pci_legacy_resume(dev);
+	}
+
+	return error;
+}
+
+static int pci_pm_restore_noirq(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+	int error = 0;
+
+	pci_fixup_device(pci_fixup_resume, pci_dev);
+
+	if (drv && drv->pm) {
+		if (drv->pm->restore_noirq)
+			error = drv->pm->restore_noirq(dev);
+	} else {
+		error = pci_legacy_resume_early(dev);
+	}
+
+	return error;
+}
+
+#else /* !CONFIG_HIBERNATION */
+
+#define pci_pm_freeze		NULL
+#define pci_pm_freeze_noirq	NULL
+#define pci_pm_thaw		NULL
+#define pci_pm_thaw_noirq	NULL
+#define pci_pm_poweroff		NULL
+#define pci_pm_poweroff_noirq	NULL
+#define pci_pm_restore		NULL
+#define pci_pm_restore_noirq	NULL
+
+#endif /* !CONFIG_HIBERNATION */
+
+struct pm_ext_ops pci_pm_ops = {
+	.base = {
+		.prepare = pci_pm_prepare,
+		.complete = pci_pm_complete,
+		.suspend = pci_pm_suspend,
+		.resume = pci_pm_resume,
+		.freeze = pci_pm_freeze,
+		.thaw = pci_pm_thaw,
+		.poweroff = pci_pm_poweroff,
+		.restore = pci_pm_restore,
+	},
+	.suspend_noirq = pci_pm_suspend_noirq,
+	.resume_noirq = pci_pm_resume_noirq,
+	.freeze_noirq = pci_pm_freeze_noirq,
+	.thaw_noirq = pci_pm_thaw_noirq,
+	.poweroff_noirq = pci_pm_poweroff_noirq,
+	.restore_noirq = pci_pm_restore_noirq,
+};
+
+#define PCI_PM_OPS_PTR	&pci_pm_ops
+
+#else /* !CONFIG_PM_SLEEP */
+
+#define PCI_PM_OPS_PTR	NULL
+
+#endif /* !CONFIG_PM_SLEEP */
+
 /**
  * __pci_register_driver - register a new pci driver
  * @drv: the driver structure to register
@@ -386,6 +682,9 @@ int __pci_register_driver(struct pci_dri
 	drv->driver.owner = owner;
 	drv->driver.mod_name = mod_name;
 
+	if (drv->pm)
+		drv->driver.pm = &drv->pm->base;
+
 	spin_lock_init(&drv->dynids.lock);
 	INIT_LIST_HEAD(&drv->dynids.list);
 
@@ -511,12 +810,9 @@ struct bus_type pci_bus_type = {
 	.uevent		= pci_uevent,
 	.probe		= pci_device_probe,
 	.remove		= pci_device_remove,
-	.suspend	= pci_device_suspend,
-	.suspend_late	= pci_device_suspend_late,
-	.resume_early	= pci_device_resume_early,
-	.resume		= pci_device_resume,
 	.shutdown	= pci_device_shutdown,
 	.dev_attrs	= pci_dev_attrs,
+	.pm		= PCI_PM_OPS_PTR,
 };
 
 static int __init pci_driver_init(void)
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -388,7 +388,7 @@ struct pci_driver {
 	int  (*resume_early) (struct pci_dev *dev);
 	int  (*resume) (struct pci_dev *dev);	                /* Device woken up */
 	void (*shutdown) (struct pci_dev *dev);
-
+	struct pm_ext_ops *pm;
 	struct pci_error_handlers *err_handler;
 	struct device_driver	driver;
 	struct pci_dynids dynids;
