Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbZAAVJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbZAAVJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 16:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZAAVJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 16:09:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35892 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbZAAVJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 16:09:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [RFC][PATCH 5/10] PCI PM: Avoid touching devices behind bridges in unknown state (rev. 2)
Date: Thu, 1 Jan 2009 22:09:46 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-tst; KDE/4.1.3; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200812190049.34343.rjw@sisk.pl> <200812302333.45560.rjw@sisk.pl> <200812302341.12959.rjw@sisk.pl>
In-Reply-To: <200812302341.12959.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901012209.47598.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 December 2008, Rafael J. Wysocki wrote:
> 
> It generally is better to avoid accessing devices behind bridges that
> may not be in the D0 power state, because in that case the bridges'
> secondary buses may not be accessible.  For this reason, during the
> early phase of resume (ie. with interrupts disabled), before
> restoring the standard config registers of a device, check the power
> state of the bridge the device is behind and postpone the restoration
> of the device's config space, as well as any other operations that
> would involve accessing the device, if that state is not D0.
> 
> In such cases the restoration of the device's config space will be
> retried during the "normal" phase of resume (ie. with interrupts
> enabled), so that the bridge can be put into D0 before that happens.
> 
> Also, save standard configuration registers of PCI devices during the
> "normal" phase of suspend (ie. with interrupts enabled), so that the
> bridges the devices are behind can be put into low power states (we
> don't put bridges into low power states at the moment, but we may
> want to do it in the future and it seems reasonable to design for
> that).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

I found a small mistake in this patch.  Namely, the code in
pci_pm_default_resume doesn't follow the comment and the config spaces of
devices without drivers are restored twice in a row during resume (once with
interrupts enabled and once with interrupts disabled.  That shouldn't hurt, but
is not correct nevertheless.

Corrected patch follows.

Thanks,
Rafael

---
Subject: PCI PM: Avoid touching devices behind bridges in unknown state (rev. 2)
From: Rafael J. Wysocki <rjw@sisk.pl>

It generally is better to avoid accessing devices behind bridges that
may not be in the D0 power state, because in that case the bridges'
secondary buses may not be accessible.  For this reason, during the
early phase of resume (ie. with interrupts disabled), before
restoring the standard config registers of a device, check the power
state of the bridge the device is behind and postpone the restoration
of the device's config space, as well as any other operations that
would involve accessing the device, if that state is not D0.

In such cases the restoration of the device's config space will be
retried during the "normal" phase of resume (ie. with interrupts
enabled), so that the bridge can be put into D0 before that happens.

Also, save standard configuration registers of PCI devices during the
"normal" phase of suspend (ie. with interrupts enabled), so that the
bridges the devices are behind can be put into low power states (we
don't put bridges into low power states at the moment, but we may
want to do it in the future and it seems reasonable to design for
that).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |  109 +++++++++++++++++++++++++++++++----------------
 drivers/pci/pci.c        |    2 
 drivers/pci/pci.h        |    1 
 3 files changed, 74 insertions(+), 38 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -526,7 +526,7 @@ pci_raw_set_power_state(struct pci_dev *
  * @dev: PCI device to handle.
  * @state: State to cache in case the device doesn't have the PM capability
  */
-static void pci_update_current_state(struct pci_dev *dev, pci_power_t state)
+void pci_update_current_state(struct pci_dev *dev, pci_power_t state)
 {
 	if (dev->pm_cap) {
 		u16 pmcsr;
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -40,6 +40,7 @@ struct pci_platform_pm_ops {
 };
 
 extern int pci_set_platform_pm(struct pci_platform_pm_ops *ops);
+extern void pci_update_current_state(struct pci_dev *dev, pci_power_t state);
 extern void pci_disable_enabled_device(struct pci_dev *dev);
 extern void pci_pm_init(struct pci_dev *dev);
 extern void pci_allocate_cap_save_buffers(struct pci_dev *dev);
Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -302,21 +302,10 @@ static void pci_device_shutdown(struct d
 
 /*
  * Default "suspend" method for devices that have no driver provided suspend,
- * or not even a driver at all (first part).
- */
-static void pci_default_pm_suspend_early(struct pci_dev *pci_dev)
-{
-	/* If device is enabled at this point, disable it */
-	pci_disable_enabled_device(pci_dev);
-}
-
-/*
- * Default "suspend" method for devices that have no driver provided suspend,
  * or not even a driver at all (second part).
  */
 static void pci_default_pm_suspend_late(struct pci_dev *pci_dev)
 {
-	pci_save_state(pci_dev);
 	/*
 	 * mark its power state as "unknown", since we don't know if
 	 * e.g. the BIOS will change its device state when we suspend.
@@ -327,16 +316,6 @@ static void pci_default_pm_suspend_late(
 
 /*
  * Default "resume" method for devices that have no driver provided resume,
- * or not even a driver at all (first part).
- */
-static void pci_default_pm_resume_early(struct pci_dev *pci_dev)
-{
-	/* restore the PCI config space */
-	pci_restore_state(pci_dev);
-}
-
-/*
- * Default "resume" method for devices that have no driver provided resume,
  * or not even a driver at all (second part).
  */
 static int pci_default_pm_resume_late(struct pci_dev *pci_dev)
@@ -365,9 +344,10 @@ static int pci_legacy_suspend(struct dev
 		i = drv->suspend(pci_dev, state);
 		suspend_report_result(drv->suspend, i);
 	} else {
+		pci_save_state(pci_dev);
 		/*
-		 * For compatibility with existing code with legacy PM support
-		 * don't call pci_default_pm_suspend_early() here.
+		 * This is for compatibility with existing code with legacy PM
+		 * support.
 		 */
 		pci_default_pm_suspend_late(pci_dev);
 	}
@@ -396,7 +376,8 @@ static int pci_legacy_resume(struct devi
 	if (drv && drv->resume) {
 		error = drv->resume(pci_dev);
 	} else {
-		pci_default_pm_resume_early(pci_dev);
+		/* restore the PCI config space */
+		pci_restore_state(pci_dev);
 		error = pci_default_pm_resume_late(pci_dev);
 	}
 	return error;
@@ -415,22 +396,72 @@ static int pci_legacy_resume_early(struc
 
 /* Auxiliary functions used by the new power management framework */
 
+static int pci_restore_standard_config(struct pci_dev *pci_dev)
+{
+	struct pci_dev *parent = pci_dev->bus->self;
+	int error = 0;
+
+	/* Check if the device's bus is operational */
+	if (!parent || parent->current_state == PCI_D0) {
+		pci_restore_state(pci_dev);
+		pci_update_current_state(pci_dev, PCI_D0);
+	} else {
+		dev_warn(&pci_dev->dev, "unable to restore config, "
+			"bridge %s in low power state D%d\n", pci_name(parent),
+			parent->current_state);
+		pci_dev->current_state = PCI_UNKNOWN;
+		error = -EAGAIN;
+	}
+
+	return error;
+}
+
 static bool pci_is_bridge(struct pci_dev *pci_dev)
 {
 	return !!(pci_dev->subordinate);
 }
 
+static void pci_pm_default_resume_noirq(struct pci_dev *pci_dev)
+{
+	if (pci_restore_standard_config(pci_dev))
+		pci_fixup_device(pci_fixup_resume_early, pci_dev);
+}
+
 static int pci_pm_default_resume(struct pci_dev *pci_dev)
 {
+	/*
+	 * pci_restore_standard_config() should have been called once already,
+	 * but it would have failed if the device's parent bridge had not been
+	 * in power state D0 at that time.  Check it and try again if necessary.
+	 */
+	if (pci_dev->current_state == PCI_UNKNOWN) {
+		int error = pci_restore_standard_config(pci_dev);
+		if (error)
+			return error;
+	}
+
+	pci_fixup_device(pci_fixup_resume, pci_dev);
+
 	if (!pci_is_bridge(pci_dev))
 		pci_enable_wake(pci_dev, PCI_D0, false);
 
 	return pci_default_pm_resume_late(pci_dev);
 }
 
+static void pci_pm_default_suspend_generic(struct pci_dev *pci_dev)
+{
+	/* If device is enabled at this point, disable it */
+	pci_disable_enabled_device(pci_dev);
+	/*
+	 * Save state with interrupts enabled, because in principle the bus the
+	 * device is on may be put into a low power state after this code runs.
+	 */
+	pci_save_state(pci_dev);
+}
+
 static void pci_pm_default_suspend(struct pci_dev *pci_dev)
 {
-	pci_default_pm_suspend_early(pci_dev);
+	pci_pm_default_suspend_generic(pci_dev);
 
 	if (!pci_is_bridge(pci_dev))
 		pci_prepare_to_sleep(pci_dev);
@@ -515,12 +546,13 @@ static int pci_pm_resume(struct device *
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
-	pci_fixup_device(pci_fixup_resume, pci_dev);
-
 	if (drv && drv->pm) {
+		pci_fixup_device(pci_fixup_resume, pci_dev);
+
 		if (drv->pm->resume)
 			error = drv->pm->resume(dev);
 	} else if (pci_has_legacy_pm_support(pci_dev)) {
+		pci_fixup_device(pci_fixup_resume, pci_dev);
 		error = pci_legacy_resume(dev);
 	} else {
 		error = pci_pm_default_resume(pci_dev);
@@ -535,15 +567,16 @@ static int pci_pm_resume_noirq(struct de
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
-	pci_fixup_device(pci_fixup_resume_early, to_pci_dev(dev));
-
 	if (drv && drv->pm) {
+		pci_fixup_device(pci_fixup_resume_early, pci_dev);
+
 		if (drv->pm->resume_noirq)
 			error = drv->pm->resume_noirq(dev);
 	} else if (pci_has_legacy_pm_support(pci_dev)) {
+		pci_fixup_device(pci_fixup_resume_early, pci_dev);
 		error = pci_legacy_resume_early(dev);
 	} else {
-		pci_default_pm_resume_early(pci_dev);
+		pci_pm_default_resume_noirq(pci_dev);
 	}
 
 	return error;
@@ -575,7 +608,7 @@ static int pci_pm_freeze(struct device *
 		error = pci_legacy_suspend(dev, PMSG_FREEZE);
 		pci_fixup_device(pci_fixup_suspend, pci_dev);
 	} else {
-		pci_default_pm_suspend_early(pci_dev);
+		pci_pm_default_suspend_generic(pci_dev);
 	}
 
 	return error;
@@ -633,7 +666,7 @@ static int pci_pm_thaw_noirq(struct devi
 		pci_fixup_device(pci_fixup_resume_early, to_pci_dev(dev));
 		error = pci_legacy_resume_early(dev);
 	} else {
-		pci_default_pm_resume_early(pci_dev);
+		pci_update_current_state(pci_dev, PCI_D0);
 	}
 
 	return error;
@@ -684,12 +717,13 @@ static int pci_pm_restore(struct device 
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
-	pci_fixup_device(pci_fixup_resume, pci_dev);
-
 	if (drv && drv->pm) {
+		pci_fixup_device(pci_fixup_resume, pci_dev);
+
 		if (drv->pm->restore)
 			error = drv->pm->restore(dev);
 	} else if (pci_has_legacy_pm_support(pci_dev)) {
+		pci_fixup_device(pci_fixup_resume, pci_dev);
 		error = pci_legacy_resume(dev);
 	} else {
 		error = pci_pm_default_resume(pci_dev);
@@ -704,15 +738,16 @@ static int pci_pm_restore_noirq(struct d
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
-	pci_fixup_device(pci_fixup_resume_early, pci_dev);
-
 	if (drv && drv->pm) {
+		pci_fixup_device(pci_fixup_resume_early, pci_dev);
+
 		if (drv->pm->restore_noirq)
 			error = drv->pm->restore_noirq(dev);
 	} else if (pci_has_legacy_pm_support(pci_dev)) {
+		pci_fixup_device(pci_fixup_resume_early, pci_dev);
 		error = pci_legacy_resume_early(dev);
 	} else {
-		pci_default_pm_resume_early(pci_dev);
+		pci_pm_default_resume_noirq(pci_dev);
 	}
 
 	return error;

