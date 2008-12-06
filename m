Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbYLFOLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbYLFOLv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 09:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbYLFOKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 09:10:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59671 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756259AbYLFOKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 09:10:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/3] PCI: Rework default handling of suspend and resume
Date: Sat, 6 Dec 2008 15:07:05 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812061505.33815.rjw@sisk.pl>
In-Reply-To: <200812061505.33815.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812061507.06474.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PCI: Rework default handling of suspend and resume

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
---
 drivers/pci/pci-driver.c |   90 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 59 insertions(+), 31 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -300,6 +300,14 @@ static void pci_device_shutdown(struct d
 
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
@@ -317,14 +325,22 @@ static void pci_default_pm_suspend(struc
 
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
@@ -371,10 +387,12 @@ static int pci_legacy_resume(struct devi
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
 
@@ -420,10 +438,8 @@ static int pci_pm_suspend(struct device 
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
@@ -442,8 +458,10 @@ static int pci_pm_suspend_noirq(struct d
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
@@ -453,15 +471,17 @@ static int pci_pm_resume(struct device *
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
@@ -478,8 +498,10 @@ static int pci_pm_resume_noirq(struct de
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
@@ -506,10 +528,8 @@ static int pci_pm_freeze(struct device *
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
@@ -528,8 +548,10 @@ static int pci_pm_freeze_noirq(struct de
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
@@ -537,14 +559,15 @@ static int pci_pm_freeze_noirq(struct de
 
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
 
@@ -560,7 +583,7 @@ static int pci_pm_thaw_noirq(struct devi
 	if (drv && drv->pm) {
 		if (drv->pm->thaw_noirq)
 			error = drv->pm->thaw_noirq(dev);
-	} else {
+	} else if (pci_has_legacy_pm_support(pci_dev)) {
 		pci_fixup_device(pci_fixup_resume_early, pci_dev);
 		error = pci_legacy_resume_early(dev);
 	}
@@ -570,17 +593,18 @@ static int pci_pm_thaw_noirq(struct devi
 
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
 
@@ -598,7 +622,7 @@ static int pci_pm_poweroff_noirq(struct 
 			error = drv->pm->poweroff_noirq(dev);
 			suspend_report_result(drv->pm->poweroff_noirq, error);
 		}
-	} else {
+	} else if (pci_has_legacy_pm_support(pci_dev)) {
 		error = pci_legacy_suspend_late(dev, PMSG_HIBERNATE);
 	}
 
@@ -609,13 +633,15 @@ static int pci_pm_restore(struct device 
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
 
@@ -633,8 +659,10 @@ static int pci_pm_restore_noirq(struct d
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
 

