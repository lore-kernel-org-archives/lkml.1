Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbYDBANo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbYDBANo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 20:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758543AbYDBANP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 20:13:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49320 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393AbYDBANL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 20:13:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 3/3] PM: New suspend and hibernation callbacks for PCI bus type (rev. 3)
Date: Wed, 2 Apr 2008 02:11:42 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>
References: <200804020207.40278.rjw@sisk.pl>
In-Reply-To: <200804020207.40278.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804020211.43441.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Implement new suspend and hibernation callbacks for the PCI bus type.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |  371 ++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/pci.h      |    2 
 2 files changed, 334 insertions(+), 39 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -271,7 +271,52 @@ static int pci_device_remove(struct devi
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
+	/* if the device was busmaster before the suspend, make it busmaster again */
+	if (pci_dev->is_busmaster)
+		pci_set_master(pci_dev);
+
+	return retval;
+}
+
+static int pci_legacy_suspend(struct device * dev, pm_message_t state)
 {
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
@@ -281,18 +326,12 @@ static int pci_device_suspend(struct dev
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
+static int pci_legacy_suspend_late(struct device * dev, pm_message_t state)
 {
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
@@ -305,26 +344,7 @@ static int pci_device_suspend_late(struc
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
+static int pci_legacy_resume(struct device * dev)
 {
 	int error;
 	struct pci_dev * pci_dev = to_pci_dev(dev);
@@ -333,11 +353,11 @@ static int pci_device_resume(struct devi
 	if (drv && drv->resume)
 		error = drv->resume(pci_dev);
 	else
-		error = pci_default_resume(pci_dev);
+		error = pci_default_pm_resume(pci_dev);
 	return error;
 }
 
-static int pci_device_resume_early(struct device * dev)
+static int pci_legacy_resume_early(struct device * dev)
 {
 	int error = 0;
 	struct pci_dev * pci_dev = to_pci_dev(dev);
@@ -350,15 +370,290 @@ static int pci_device_resume_early(struc
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
+	struct pci_dev *pci_dev = to_pci_dev(dev);
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
+	struct pci_dev *pci_dev = to_pci_dev(dev);
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
@@ -381,6 +676,9 @@ int __pci_register_driver(struct pci_dri
 	drv->driver.owner = owner;
 	drv->driver.mod_name = mod_name;
 
+	if (drv->pm)
+		drv->driver.pm = &drv->pm->base;
+
 	spin_lock_init(&drv->dynids.lock);
 	INIT_LIST_HEAD(&drv->dynids.list);
 
@@ -506,12 +804,9 @@ struct bus_type pci_bus_type = {
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
@@ -381,7 +381,7 @@ struct pci_driver {
 	int  (*resume_early) (struct pci_dev *dev);
 	int  (*resume) (struct pci_dev *dev);	                /* Device woken up */
 	void (*shutdown) (struct pci_dev *dev);
-
+	struct pm_ext_ops *pm;
 	struct pci_error_handlers *err_handler;
 	struct device_driver	driver;
 	struct pci_dynids dynids;
