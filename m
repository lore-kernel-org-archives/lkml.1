Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbZAFWQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbZAFWQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbZAFWN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:29 -0500
Received: from kroah.org ([198.145.64.141]:51192 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754911AbZAFWN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:26 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/60] PCI: Rework default handling of suspend and resume
Date: Tue,  6 Jan 2009 14:11:29 -0800
Message-Id: <1231279939-32728-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Rework the handling of suspend and resume of PCI devices which have
no drivers or the drivers of which do not provide any suspend-resume
callbacks in such a way that their standard PCI configuration
registers will be saved and restored with interrupts disabled.  This
should prevent such devices, including PCI bridges, from being
resumed too late to be able to function correctly during the resume
of the other PCI devices that may depend on them.

Also, to remove one possible source of future confusion, drop the
default handling of suspend and resume for PCI devices with drivers
providing the 'pm' object introduced by the new suspend-resume
framework (there are no such PCI drivers at the moment).

This patch addresses the regression from 2.6.26 tracked as
http://bugzilla.kernel.org/show_bug.cgi?id=12121 .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/pci-driver.c |   94 +++++++++++++++++++++++++++++++---------------
 1 files changed, 63 insertions(+), 31 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 4042d21..99d867b 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -300,6 +300,14 @@ static void pci_device_shutdown(struct device *dev)
 
 #ifdef CONFIG_PM_SLEEP
 
+static bool pci_has_legacy_pm_support(struct pci_dev *pci_dev)
+{
+	struct pci_driver *drv = pci_dev->driver;
+
+	return drv && (drv->suspend || drv->suspend_late || drv->resume
+		|| drv->resume_early);
+}
+
 /*
  * Default "suspend" method for devices that have no driver provided suspend,
  * or not even a driver at all.
@@ -317,14 +325,22 @@ static void pci_default_pm_suspend(struct pci_dev *pci_dev)
 
 /*
  * Default "resume" method for devices that have no driver provided resume,
- * or not even a driver at all.
+ * or not even a driver at all (first part).
  */
-static int pci_default_pm_resume(struct pci_dev *pci_dev)
+static void pci_default_pm_resume_early(struct pci_dev *pci_dev)
 {
-	int retval = 0;
-
 	/* restore the PCI config space */
 	pci_restore_state(pci_dev);
+}
+
+/*
+ * Default "resume" method for devices that have no driver provided resume,
+ * or not even a driver at all (second part).
+ */
+static int pci_default_pm_resume_late(struct pci_dev *pci_dev)
+{
+	int retval;
+
 	/* if the device was enabled before suspend, reenable */
 	retval = pci_reenable_device(pci_dev);
 	/*
@@ -371,10 +387,12 @@ static int pci_legacy_resume(struct device *dev)
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
 
-	if (drv && drv->resume)
+	if (drv && drv->resume) {
 		error = drv->resume(pci_dev);
-	else
-		error = pci_default_pm_resume(pci_dev);
+	} else {
+		pci_default_pm_resume_early(pci_dev);
+		error = pci_default_pm_resume_late(pci_dev);
+	}
 	return error;
 }
 
@@ -420,10 +438,8 @@ static int pci_pm_suspend(struct device *dev)
 		if (drv->pm->suspend) {
 			error = drv->pm->suspend(dev);
 			suspend_report_result(drv->pm->suspend, error);
-		} else {
-			pci_default_pm_suspend(pci_dev);
 		}
-	} else {
+	} else if (pci_has_legacy_pm_support(pci_dev)) {
 		error = pci_legacy_suspend(dev, PMSG_SUSPEND);
 	}
 	pci_fixup_device(pci_fixup_suspend, pci_dev);
@@ -433,6 +449,7 @@ static int pci_pm_suspend(struct device *dev)
 
 static int pci_pm_suspend_noirq(struct device *dev)
 {
+	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
@@ -441,8 +458,10 @@ static int pci_pm_suspend_noirq(struct device *dev)
 			error = drv->pm->suspend_noirq(dev);
 			suspend_report_result(drv->pm->suspend_noirq, error);
 		}
-	} else {
+	} else if (pci_has_legacy_pm_support(pci_dev)) {
 		error = pci_legacy_suspend_late(dev, PMSG_SUSPEND);
+	} else {
+		pci_default_pm_suspend(pci_dev);
 	}
 
 	return error;
@@ -452,15 +471,17 @@ static int pci_pm_resume(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct device_driver *drv = dev->driver;
-	int error;
+	int error = 0;
 
 	pci_fixup_device(pci_fixup_resume, pci_dev);
 
 	if (drv && drv->pm) {
-		error = drv->pm->resume ? drv->pm->resume(dev) :
-			pci_default_pm_resume(pci_dev);
-	} else {
+		if (drv->pm->resume)
+			error = drv->pm->resume(dev);
+	} else if (pci_has_legacy_pm_support(pci_dev)) {
 		error = pci_legacy_resume(dev);
+	} else {
+		error = pci_default_pm_resume_late(pci_dev);
 	}
 
 	return error;
@@ -468,6 +489,7 @@ static int pci_pm_resume(struct device *dev)
 
 static int pci_pm_resume_noirq(struct device *dev)
 {
+	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
@@ -476,8 +498,10 @@ static int pci_pm_resume_noirq(struct device *dev)
 	if (drv && drv->pm) {
 		if (drv->pm->resume_noirq)
 			error = drv->pm->resume_noirq(dev);
-	} else {
+	} else if (pci_has_legacy_pm_support(pci_dev)) {
 		error = pci_legacy_resume_early(dev);
+	} else {
+		pci_default_pm_resume_early(pci_dev);
 	}
 
 	return error;
@@ -504,10 +528,8 @@ static int pci_pm_freeze(struct device *dev)
 		if (drv->pm->freeze) {
 			error = drv->pm->freeze(dev);
 			suspend_report_result(drv->pm->freeze, error);
-		} else {
-			pci_default_pm_suspend(pci_dev);
 		}
-	} else {
+	} else if (pci_has_legacy_pm_support(pci_dev)) {
 		error = pci_legacy_suspend(dev, PMSG_FREEZE);
 		pci_fixup_device(pci_fixup_suspend, pci_dev);
 	}
@@ -517,6 +539,7 @@ static int pci_pm_freeze(struct device *dev)
 
 static int pci_pm_freeze_noirq(struct device *dev)
 {
+	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
@@ -525,8 +548,10 @@ static int pci_pm_freeze_noirq(struct device *dev)
 			error = drv->pm->freeze_noirq(dev);
 			suspend_report_result(drv->pm->freeze_noirq, error);
 		}
-	} else {
+	} else if (pci_has_legacy_pm_support(pci_dev)) {
 		error = pci_legacy_suspend_late(dev, PMSG_FREEZE);
+	} else {
+		pci_default_pm_suspend(pci_dev);
 	}
 
 	return error;
@@ -534,14 +559,15 @@ static int pci_pm_freeze_noirq(struct device *dev)
 
 static int pci_pm_thaw(struct device *dev)
 {
+	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
 	if (drv && drv->pm) {
 		if (drv->pm->thaw)
 			error =  drv->pm->thaw(dev);
-	} else {
-		pci_fixup_device(pci_fixup_resume, to_pci_dev(dev));
+	} else if (pci_has_legacy_pm_support(pci_dev)) {
+		pci_fixup_device(pci_fixup_resume, pci_dev);
 		error = pci_legacy_resume(dev);
 	}
 
@@ -550,13 +576,14 @@ static int pci_pm_thaw(struct device *dev)
 
 static int pci_pm_thaw_noirq(struct device *dev)
 {
+	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
 	if (drv && drv->pm) {
 		if (drv->pm->thaw_noirq)
 			error = drv->pm->thaw_noirq(dev);
-	} else {
+	} else if (pci_has_legacy_pm_support(pci_dev)) {
 		pci_fixup_device(pci_fixup_resume_early, to_pci_dev(dev));
 		error = pci_legacy_resume_early(dev);
 	}
@@ -566,17 +593,18 @@ static int pci_pm_thaw_noirq(struct device *dev)
 
 static int pci_pm_poweroff(struct device *dev)
 {
+	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
-	pci_fixup_device(pci_fixup_suspend, to_pci_dev(dev));
+	pci_fixup_device(pci_fixup_suspend, pci_dev);
 
 	if (drv && drv->pm) {
 		if (drv->pm->poweroff) {
 			error = drv->pm->poweroff(dev);
 			suspend_report_result(drv->pm->poweroff, error);
 		}
-	} else {
+	} else if (pci_has_legacy_pm_support(pci_dev)) {
 		error = pci_legacy_suspend(dev, PMSG_HIBERNATE);
 	}
 
@@ -593,7 +621,7 @@ static int pci_pm_poweroff_noirq(struct device *dev)
 			error = drv->pm->poweroff_noirq(dev);
 			suspend_report_result(drv->pm->poweroff_noirq, error);
 		}
-	} else {
+	} else if (pci_has_legacy_pm_support(to_pci_dev(dev))) {
 		error = pci_legacy_suspend_late(dev, PMSG_HIBERNATE);
 	}
 
@@ -604,13 +632,15 @@ static int pci_pm_restore(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct device_driver *drv = dev->driver;
-	int error;
+	int error = 0;
 
 	if (drv && drv->pm) {
-		error = drv->pm->restore ? drv->pm->restore(dev) :
-			pci_default_pm_resume(pci_dev);
-	} else {
+		if (drv->pm->restore)
+			error = drv->pm->restore(dev);
+	} else if (pci_has_legacy_pm_support(pci_dev)) {
 		error = pci_legacy_resume(dev);
+	} else {
+		error = pci_default_pm_resume_late(pci_dev);
 	}
 	pci_fixup_device(pci_fixup_resume, pci_dev);
 
@@ -628,8 +658,10 @@ static int pci_pm_restore_noirq(struct device *dev)
 	if (drv && drv->pm) {
 		if (drv->pm->restore_noirq)
 			error = drv->pm->restore_noirq(dev);
-	} else {
+	} else if (pci_has_legacy_pm_support(pci_dev)) {
 		error = pci_legacy_resume_early(dev);
+	} else {
+		pci_default_pm_resume_early(pci_dev);
 	}
 	pci_fixup_device(pci_fixup_resume_early, pci_dev);
 
-- 
1.6.0.4

