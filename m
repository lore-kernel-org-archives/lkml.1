Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYCPX1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYCPX1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbYCPX0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:26:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37741 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711AbYCPX0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:26:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 3/3] PM: New suspend and hibernation callbacks for PCI bus type
Date: Mon, 17 Mar 2008 00:25:15 +0100
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
Message-Id: <200803170025.16149.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Implement new suspend and hibernation callbacks for the PCI busi type.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |  497 ++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/pci.h      |    2 
 2 files changed, 453 insertions(+), 46 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -271,45 +271,78 @@ static int pci_device_remove(struct devi
 	return 0;
 }
 
-static int pci_device_suspend(struct device * dev, pm_message_t state)
+static void pci_device_shutdown(struct device *dev)
 {
-	struct pci_dev * pci_dev = to_pci_dev(dev);
-	struct pci_driver * drv = pci_dev->driver;
-	int i = 0;
-
-	if (drv && drv->suspend) {
-		i = drv->suspend(pci_dev, state);
-		suspend_report_result(drv->suspend, i);
-	} else {
-		pci_save_state(pci_dev);
-		/*
-		 * mark its power state as "unknown", since we don't know if
-		 * e.g. the BIOS will change its device state when we suspend.
-		 */
-		if (pci_dev->current_state == PCI_D0)
-			pci_dev->current_state = PCI_UNKNOWN;
-	}
-	return i;
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+
+	if (drv && drv->shutdown)
+		drv->shutdown(pci_dev);
 }
 
-static int pci_device_suspend_late(struct device * dev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int pci_pm_prepare(struct device *dev)
 {
-	struct pci_dev * pci_dev = to_pci_dev(dev);
-	struct pci_driver * drv = pci_dev->driver;
-	int i = 0;
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+	int error = 0;
 
-	if (drv && drv->suspend_late) {
-		i = drv->suspend_late(pci_dev, state);
-		suspend_report_result(drv->suspend_late, i);
-	}
-	return i;
+	if (drv && drv->pm && drv->pm->prepare)
+		error = drv->pm->prepare(dev);
+
+	return error;
+}
+
+static int pci_pm_prepare_noirq(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+	int error = 0;
+
+	if (drv && drv->pm_noirq && drv->pm_noirq->prepare)
+		error = drv->pm_noirq->prepare(dev);
+
+	return error;
+}
+
+static void pci_pm_complete(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+
+	if (drv && drv->pm && drv->pm->complete)
+		drv->pm->complete(dev);
+}
+
+static void pci_pm_complete_noirq(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+
+	if (drv && drv->pm_noirq && drv->pm_noirq->complete)
+		drv->pm_noirq->complete(dev);
 }
 
 /*
- * Default resume method for devices that have no driver provided resume,
+ * Default "suspend" method for devices that have no driver provided suspend,
  * or not even a driver at all.
  */
-static int pci_default_resume(struct pci_dev *pci_dev)
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
 {
 	int retval = 0;
 
@@ -324,40 +357,376 @@ static int pci_default_resume(struct pci
 	return retval;
 }
 
-static int pci_device_resume(struct device * dev)
+#ifdef CONFIG_SUSPEND
+static int pci_pm_suspend(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+	int error = 0;
+
+	if (!drv) {
+		pci_default_pm_suspend(pci_dev);
+		return 0;
+	}
+
+	if (drv->pm) {
+		if (drv->pm->suspend) {
+			error = drv->pm->suspend(dev);
+			suspend_report_result(drv->pm->suspend, error);
+		} else {
+			pci_default_pm_suspend(pci_dev);
+		}
+	} else {
+		/* Legacy mechanism */
+		if (drv->suspend) {
+			error = drv->suspend(pci_dev, PMSG_SUSPEND);
+			suspend_report_result(drv->suspend, error);
+		} else {
+			pci_default_pm_suspend(pci_dev);
+		}
+	}
+
+	return error;
+}
+
+static int pci_pm_suspend_noirq(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+	int error = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->suspend) {
+			error = drv->pm_noirq->suspend(dev);
+			suspend_report_result(drv->pm_noirq->suspend, error);
+		}
+	} else if (drv->suspend_late) {
+		/* Legacy mechanism */
+		error = drv->suspend_late(pci_dev, PMSG_SUSPEND);
+		suspend_report_result(drv->suspend_late, error);
+	}
+
+	return error;
+}
+
+static int pci_pm_resume(struct device *dev)
 {
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
 	int error;
-	struct pci_dev * pci_dev = to_pci_dev(dev);
-	struct pci_driver * drv = pci_dev->driver;
 
-	if (drv && drv->resume)
+	if (!drv)
+		return pci_default_pm_resume(pci_dev);
+
+	if (drv->pm) {
+		error = drv->pm->resume ?
+			drv->pm->resume(dev) : pci_default_pm_resume(pci_dev);
+	} else {
+		/* Legacy mechanism */
+		error = drv->resume ?
+			drv->resume(pci_dev) : pci_default_pm_resume(pci_dev);
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
+	if (!drv)
+		return 0;
+
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->resume)
+			error = drv->pm_noirq->resume(dev);
+	} else if (drv->resume_early) {
+		/* Legacy mechanism */
+		error = drv->resume_early(pci_dev);
+	}
+
+	return error;
+}
+#endif /* CONFIG_SUSPEND */
+
+#ifdef CONFIG_HIBERNATION
+static int pci_pm_freeze(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+	int error = 0;
+
+	if (!drv) {
+		pci_default_pm_suspend(pci_dev);
+		return 0;
+	}
+
+	if (drv->pm) {
+		if (drv->pm->freeze) {
+			error = drv->pm->freeze(dev);
+			suspend_report_result(drv->pm->freeze, error);
+		} else {
+			pci_default_pm_suspend(pci_dev);
+		}
+	} else {
+		/* Legacy mechanism */
+		if (drv->suspend) {
+			error = drv->suspend(pci_dev, PMSG_FREEZE);
+			suspend_report_result(drv->suspend, error);
+		} else {
+			pci_default_pm_suspend(pci_dev);
+		}
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
+	if (!drv)
+		return 0;
+
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->freeze) {
+			error = drv->pm_noirq->freeze(dev);
+			suspend_report_result(drv->pm_noirq->freeze, error);
+		}
+	} else if (drv->suspend_late) {
+		/* Legacy mechanism */
+		error = drv->suspend_late(pci_dev, PMSG_FREEZE);
+		suspend_report_result(drv->suspend_late, error);
+	}
+
+	return error;
+}
+
+static int pci_pm_thaw(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+	int error = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->thaw)
+			error =  drv->pm->thaw(dev);
+	} else if (drv->resume) {
+		/* Legacy mechanism */
 		error = drv->resume(pci_dev);
-	else
-		error = pci_default_resume(pci_dev);
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
+	if (!drv)
+		return 0;
+
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->thaw)
+			error = drv->pm_noirq->thaw(dev);
+	} else if (drv->resume_early) {
+		/* Legacy mechanism */
+		error = drv->resume_early(pci_dev);
+	}
+
+	return error;
+}
+
+static int pci_pm_poweroff(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+	int error = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->poweroff) {
+			error = drv->pm->poweroff(dev);
+			suspend_report_result(drv->pm->poweroff, error);
+		}
+	} else if (drv->suspend) {
+		/* Legacy mechanism */
+		error = drv->suspend(pci_dev, PMSG_HIBERNATE);
+		suspend_report_result(drv->suspend, error);
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
+	if (!drv)
+		return 0;
+
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->poweroff) {
+			error = drv->pm_noirq->poweroff(dev);
+			suspend_report_result(drv->pm_noirq->poweroff, error);
+		}
+	} else if (drv->suspend_late) {
+		/* Legacy mechanism */
+		error = drv->suspend_late(pci_dev, PMSG_HIBERNATE);
+		suspend_report_result(drv->suspend_late, error);
+	}
+
+	return error;
+}
+
+static int pci_pm_quiesce(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+	int error = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->quiesce) {
+			error = drv->pm->quiesce(dev);
+			suspend_report_result(drv->pm->quiesce, error);
+		}
+	} else if (drv->suspend) {
+		/* Legacy mechanism */
+		error = drv->suspend(pci_dev, PMSG_QUIESCE);
+		suspend_report_result(drv->suspend, error);
+	}
+
+	return error;
+}
+
+static int pci_pm_quiesce_noirq(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+	int error = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->quiesce) {
+			error = drv->pm_noirq->quiesce(dev);
+			suspend_report_result(drv->pm_noirq->quiesce, error);
+		}
+	} else if (drv->suspend_late) {
+		/* Legacy mechanism */
+		error = drv->suspend_late(pci_dev, PMSG_QUIESCE);
+		suspend_report_result(drv->suspend_late, error);
+	}
+
+	return error;
+}
+
+static int pci_pm_restore(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+	int error;
+
+	if (!drv)
+		return pci_default_pm_resume(pci_dev);
+
+	if (drv->pm) {
+		error = drv->pm->restore ?
+			drv->pm->restore(dev) : pci_default_pm_resume(pci_dev);
+	} else {
+		/* Legacy mechanism */
+		error = drv->resume ?
+			drv->resume(pci_dev) : pci_default_pm_resume(pci_dev);
+	}
+
 	return error;
 }
 
-static int pci_device_resume_early(struct device * dev)
+static int pci_pm_restore_noirq(struct device *dev)
 {
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
 	int error = 0;
-	struct pci_dev * pci_dev = to_pci_dev(dev);
-	struct pci_driver * drv = pci_dev->driver;
 
 	pci_fixup_device(pci_fixup_resume, pci_dev);
 
-	if (drv && drv->resume_early)
+	if (!drv)
+		return 0;
+
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->restore)
+			error = drv->pm_noirq->restore(dev);
+	} else if (drv->resume_early) {
+		/* Legacy mechanism */
 		error = drv->resume_early(pci_dev);
+	}
+
 	return error;
 }
 
-static void pci_device_shutdown(struct device *dev)
+static int pci_pm_recover(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *drv = pci_dev->driver;
+	int error = 0;
 
-	if (drv && drv->shutdown)
-		drv->shutdown(pci_dev);
+	if (!drv)
+		return 0;
+
+	if (drv->pm) {
+		if (drv->pm->recover)
+			error = drv->pm->recover(dev);
+	} else if (drv->resume) {
+		/* Legacy mechanism */
+		error = drv->resume(pci_dev);
+	}
+
+	return error;
+}
+
+static int pci_pm_recover_noirq(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_driver *drv = pci_dev->driver;
+	int error = 0;
+
+	if (!drv)
+		return 0;
+
+	if (drv->pm_noirq) {
+		if (drv->pm_noirq->recover)
+			error = drv->pm_noirq->recover(dev);
+	} else if (drv->resume_early) {
+		/* Legacy mechanism */
+		error = drv->resume_early(pci_dev);
+	}
+
+	return error;
 }
+#endif /* CONFIG_HIBERNATION */
+#endif /* CONFIG_PM_SLEEP */
 
 /**
  * __pci_register_driver - register a new pci driver
@@ -500,18 +869,54 @@ int pci_uevent(struct device *dev, struc
 }
 #endif
 
+struct pm_ops pci_pm_ops = {
+#ifdef CONFIG_PM_SLEEP
+	.prepare = pci_pm_prepare,
+	.complete = pci_pm_complete,
+#endif
+#ifdef CONFIG_SUSPEND
+	.suspend = pci_pm_suspend,
+	.resume = pci_pm_resume,
+#endif
+#ifdef CONFIG_HIBERNATION
+	.freeze = pci_pm_freeze,
+	.thaw = pci_pm_thaw,
+	.poweroff = pci_pm_poweroff,
+	.quiesce = pci_pm_quiesce,
+	.restore = pci_pm_restore,
+	.recover = pci_pm_recover,
+#endif
+};
+
+struct pm_ops pci_pm_ops_noirq = {
+#ifdef CONFIG_PM_SLEEP
+	.prepare = pci_pm_prepare_noirq,
+	.complete = pci_pm_complete_noirq,
+#endif
+#ifdef CONFIG_SUSPEND
+	.suspend = pci_pm_suspend_noirq,
+	.resume = pci_pm_resume_noirq,
+#endif
+#ifdef CONFIG_HIBERNATION
+	.freeze = pci_pm_freeze_noirq,
+	.thaw = pci_pm_thaw_noirq,
+	.poweroff = pci_pm_poweroff_noirq,
+	.quiesce = pci_pm_quiesce_noirq,
+	.restore = pci_pm_restore_noirq,
+	.recover = pci_pm_recover_noirq,
+#endif
+};
+
 struct bus_type pci_bus_type = {
 	.name		= "pci",
 	.match		= pci_bus_match,
 	.uevent		= pci_uevent,
 	.probe		= pci_device_probe,
 	.remove		= pci_device_remove,
-	.suspend	= pci_device_suspend,
-	.suspend_late	= pci_device_suspend_late,
-	.resume_early	= pci_device_resume_early,
-	.resume		= pci_device_resume,
 	.shutdown	= pci_device_shutdown,
 	.dev_attrs	= pci_dev_attrs,
+	.pm		= &pci_pm_ops,
+	.pm_noirq	= &pci_pm_ops_noirq,
 };
 
 static int __init pci_driver_init(void)
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -382,6 +382,8 @@ struct pci_driver {
 	int  (*resume) (struct pci_dev *dev);	                /* Device woken up */
 	void (*shutdown) (struct pci_dev *dev);
 
+	struct pm_ops *pm;
+	struct pm_ops *pm_noirq;
 	struct pci_error_handlers *err_handler;
 	struct device_driver	driver;
 	struct pci_dynids dynids;
