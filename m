Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZBAVkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZBAVkc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 16:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZBAVjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 16:39:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57855 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbZBAVjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 16:39:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 2/3] PCI PM: Let the core be more careful with respect to drivers using new framework
Date: Sun, 1 Feb 2009 22:33:17 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200902012229.27517.rjw@sisk.pl>
In-Reply-To: <200902012229.27517.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902012233.17790.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Currently, the PM core always attempts to manage devices with drivers
that use the new PM framework.  In particular, it attempts to disable
the devices (which is unnecessary), to save their state (which may be
undesirable if the driver has done that already) and to put them into
low power states (again, this may be undesirable if the driver has
already put the device into a low power state).  That need not be
the right thing to do, so make the core be more careful in this
respect.

Generally, there are the following categories of devices to consider:
* bridge devices without drivers
* non-bridge devices without drivers
* bridge devices with drivers
* non-bridge devices with drivers
and each of them should be handled differently.

For bridge devices without drivers the PCI PM core will save their
state on suspend and restore it (early) during resume, after putting
them into D0 if necessary.  It will not attepmt to do anything else
to these devices.

For non-bridge devices without drivers the PCI PM core will disable
them and save their state on suspend.  During resume, it will put
them into D0, if necessary, restore their state (early) and reenable
them.

For bridge devices without drivers the PCI PM core will only save
their state on suspend if the driver hasn't done that already.
Still, the core will restore their state (early) during resume,
after putting them into D0, if necessary.

For non-bridge devices with drivers the PCI PM core will only save
their state on suspend if the driver hasn't done that already.  Also,
if the state of the device hasn't been saved by the driver, the core
will attempt to put the device into a low power state.  During
resume the core will restore the state of the device (early), after
putting it into D0, if necessary.

For all devices the core will disable wake-up during resume.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |  138 ++++++++++++++++++++++++++++-------------------
 1 file changed, 85 insertions(+), 53 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -370,7 +370,6 @@ static int pci_legacy_suspend(struct dev
 	}
 
 	pci_save_state(pci_dev);
-	pci_dev->state_saved = true;
 	/*
 	 * This is for compatibility with existing code with legacy PM support.
 	 */
@@ -424,39 +423,22 @@ static void pci_pm_default_resume_noirq(
 	pci_fixup_device(pci_fixup_resume_early, pci_dev);
 }
 
-static int pci_pm_default_resume(struct pci_dev *pci_dev)
+static void pci_pm_default_resume(struct pci_dev *pci_dev)
 {
 	pci_fixup_device(pci_fixup_resume, pci_dev);
 
-	if (pci_is_bridge(pci_dev))
-		return 0;
-
-	pci_enable_wake(pci_dev, PCI_D0, false);
-	return pci_pm_reenable_device(pci_dev);
+	if (!pci_is_bridge(pci_dev))
+		pci_enable_wake(pci_dev, PCI_D0, false);
 }
 
-static void pci_pm_default_suspend_generic(struct pci_dev *pci_dev)
+static void pci_pm_default_suspend(struct pci_dev *pci_dev)
 {
-	/* If a non-bridge device is enabled at this point, disable it */
+	/* Disable non-bridge devices without PM support */
 	if (!pci_is_bridge(pci_dev))
 		pci_disable_enabled_device(pci_dev);
-	/*
-	 * Save state with interrupts enabled, because in principle the bus the
-	 * device is on may be put into a low power state after this code runs.
-	 */
 	pci_save_state(pci_dev);
 }
 
-static void pci_pm_default_suspend(struct pci_dev *pci_dev, bool prepare)
-{
-	pci_pm_default_suspend_generic(pci_dev);
-
-	if (prepare && !pci_is_bridge(pci_dev))
-		pci_prepare_to_sleep(pci_dev);
-
-	pci_fixup_device(pci_fixup_suspend, pci_dev);
-}
-
 static bool pci_has_legacy_pm_support(struct pci_dev *pci_dev)
 {
 	struct pci_driver *drv = pci_dev->driver;
@@ -500,20 +482,40 @@ static int pci_pm_suspend(struct device 
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-	int error = 0;
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend(dev, PMSG_SUSPEND);
 
-	if (pm && pm->suspend) {
+	if (!pm) {
+		pci_pm_default_suspend(pci_dev);
+		goto Fixup;
+	}
+
+	pci_dev->state_saved = false;
+
+	if (pm->suspend) {
+		int error;
+
 		error = pm->suspend(dev);
 		suspend_report_result(pm->suspend, error);
+		if (error)
+			return error;
+		if (!pci_dev->state_saved)
+			WARN_ONCE(pci_dev->current_state != PCI_D0,
+				"PCI PM: State of device not saved by %pF\n",
+				pm->suspend);
 	}
 
-	if (!error)
-		pci_pm_default_suspend(pci_dev, !!pm);
+	if (!pci_dev->state_saved) {
+		pci_save_state(pci_dev);
+		if (!pci_is_bridge(pci_dev))
+			pci_prepare_to_sleep(pci_dev);
+	}
 
-	return error;
+ Fixup:
+	pci_fixup_device(pci_fixup_suspend, pci_dev);
+
+	return 0;
 }
 
 static int pci_pm_suspend_noirq(struct device *dev)
@@ -556,7 +558,7 @@ static int pci_pm_resume_noirq(struct de
 static int pci_pm_resume(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct device_driver *drv = dev->driver;
+	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int error = 0;
 
 	/*
@@ -569,12 +571,16 @@ static int pci_pm_resume(struct device *
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume(dev);
 
-	error = pci_pm_default_resume(pci_dev);
+	pci_pm_default_resume(pci_dev);
 
-	if (!error && drv && drv->pm && drv->pm->resume)
-		error = drv->pm->resume(dev);
+	if (pm) {
+		if (pm->resume)
+			error = pm->resume(dev);
+	} else {
+		pci_pm_reenable_device(pci_dev);
+	}
 
-	return error;
+	return 0;
 }
 
 #else /* !CONFIG_SUSPEND */
@@ -591,21 +597,31 @@ static int pci_pm_resume(struct device *
 static int pci_pm_freeze(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct device_driver *drv = dev->driver;
-	int error = 0;
+	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend(dev, PMSG_FREEZE);
 
-	if (drv && drv->pm && drv->pm->freeze) {
-		error = drv->pm->freeze(dev);
-		suspend_report_result(drv->pm->freeze, error);
+	if (!pm) {
+		pci_pm_default_suspend(pci_dev);
+		return 0;
 	}
 
-	if (!error)
-		pci_pm_default_suspend_generic(pci_dev);
+	pci_dev->state_saved = false;
 
-	return error;
+	if (pm->freeze) {
+		int error;
+
+		error = pm->freeze(dev);
+		suspend_report_result(pm->freeze, error);
+		if (error)
+			return error;
+	}
+
+	if (!pci_dev->state_saved)
+		pci_save_state(pci_dev);
+
+	return 0;
 }
 
 static int pci_pm_freeze_noirq(struct device *dev)
@@ -648,16 +664,18 @@ static int pci_pm_thaw_noirq(struct devi
 static int pci_pm_thaw(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct device_driver *drv = dev->driver;
+	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int error = 0;
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume(dev);
 
-	pci_pm_reenable_device(pci_dev);
-
-	if (drv && drv->pm && drv->pm->thaw)
-		error =  drv->pm->thaw(dev);
+	if (pm) {
+		if (pm->thaw)
+			error = pm->thaw(dev);
+	} else {
+		pci_pm_reenable_device(pci_dev);
+	}
 
 	return error;
 }
@@ -671,13 +689,23 @@ static int pci_pm_poweroff(struct device
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend(dev, PMSG_HIBERNATE);
 
-	if (pm && pm->poweroff) {
+	if (!pm) {
+		pci_pm_default_suspend(pci_dev);
+		goto Fixup;
+	}
+
+	pci_dev->state_saved = false;
+
+	if (pm->poweroff) {
 		error = pm->poweroff(dev);
 		suspend_report_result(pm->poweroff, error);
 	}
 
-	if (!error)
-		pci_pm_default_suspend(pci_dev, !!pm);
+	if (!pci_dev->state_saved && !pci_is_bridge(pci_dev))
+		pci_prepare_to_sleep(pci_dev);
+
+ Fixup:
+	pci_fixup_device(pci_fixup_suspend, pci_dev);
 
 	return error;
 }
@@ -718,7 +746,7 @@ static int pci_pm_restore_noirq(struct d
 static int pci_pm_restore(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct device_driver *drv = dev->driver;
+	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int error = 0;
 
 	/*
@@ -731,10 +759,14 @@ static int pci_pm_restore(struct device 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume(dev);
 
-	error = pci_pm_default_resume(pci_dev);
+	pci_pm_default_resume(pci_dev);
 
-	if (!error && drv && drv->pm && drv->pm->restore)
-		error = drv->pm->restore(dev);
+	if (pm) {
+		if (pm->restore)
+			error = pm->restore(dev);
+	} else {
+		pci_pm_reenable_device(pci_dev);
+	}
 
 	return error;
 }

