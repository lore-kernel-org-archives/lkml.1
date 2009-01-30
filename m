Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbZA3XnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbZA3XnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbZA3XnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:43:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50838 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbZA3XnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:43:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI PM: Fix handling of devices without drivers
Date: Sat, 31 Jan 2009 00:42:27 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Eric Sesterhenn <snakebyte@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901310042.28404.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PCI PM: Fix handling of devices without drivers

Suspend to RAM is reported to break on some machines as a result of
attempting to put one of driverless PCI devices into a low power
state.  Avoid that by not attepmting to power manage driverless
devices during suspend.

Fix up pci_pm_poweroff() after a previous incomplete fix for the same
thing during hibernation.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-and-tested-by: Eric Sesterhenn <snakebyte@gmx.de>
---
 drivers/pci/pci-driver.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -445,11 +445,11 @@ static void pci_pm_default_suspend_gener
 	pci_save_state(pci_dev);
 }
 
-static void pci_pm_default_suspend(struct pci_dev *pci_dev)
+static void pci_pm_default_suspend(struct pci_dev *pci_dev, bool prepare)
 {
 	pci_pm_default_suspend_generic(pci_dev);
 
-	if (!pci_is_bridge(pci_dev))
+	if (prepare && !pci_is_bridge(pci_dev))
 		pci_prepare_to_sleep(pci_dev);
 
 	pci_fixup_device(pci_fixup_suspend, pci_dev);
@@ -497,19 +497,19 @@ static void pci_pm_complete(struct devic
 static int pci_pm_suspend(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct device_driver *drv = dev->driver;
+	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int error = 0;
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend(dev, PMSG_SUSPEND);
 
-	if (drv && drv->pm && drv->pm->suspend) {
-		error = drv->pm->suspend(dev);
-		suspend_report_result(drv->pm->suspend, error);
+	if (pm && pm->suspend) {
+		error = pm->suspend(dev);
+		suspend_report_result(pm->suspend, error);
 	}
 
 	if (!error)
-		pci_pm_default_suspend(pci_dev);
+		pci_pm_default_suspend(pci_dev, !!pm);
 
 	return error;
 }
@@ -663,22 +663,19 @@ static int pci_pm_thaw(struct device *de
 static int pci_pm_poweroff(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct device_driver *drv = dev->driver;
+	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int error = 0;
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend(dev, PMSG_HIBERNATE);
 
-	if (!drv || !drv->pm)
-		return 0;
-
-	if (drv->pm->poweroff) {
-		error = drv->pm->poweroff(dev);
-		suspend_report_result(drv->pm->poweroff, error);
+	if (pm && pm->poweroff) {
+		error = pm->poweroff(dev);
+		suspend_report_result(pm->poweroff, error);
 	}
 
 	if (!error)
-		pci_pm_default_suspend(pci_dev);
+		pci_pm_default_suspend(pci_dev, !!pm);
 
 	return error;
 }

