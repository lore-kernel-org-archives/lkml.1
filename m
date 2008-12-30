Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbYL3Wws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbYL3Wws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 17:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYL3Wu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 17:50:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57679 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbYL3WuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 17:50:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [RFC][PATCH 10/10] PCI PM: Put PM callbacks in the order of execution
Date: Tue, 30 Dec 2008 23:49:54 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200812190049.34343.rjw@sisk.pl> <200812281607.28007.rjw@sisk.pl> <200812302333.45560.rjw@sisk.pl>
In-Reply-To: <200812302333.45560.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812302349.55694.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Put PM callbacks in drivers/pci/pci-driver.c in the order in which
they are executed which makes it much easier to follow the code.

No functional changes should result from this.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |   86 +++++++++++++++++++++++------------------------
 1 file changed, 43 insertions(+), 43 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -370,6 +370,19 @@ static int pci_legacy_suspend_late(struc
 	return i;
 }
 
+static int pci_legacy_resume_early(struct device *dev)
+{
+	int error = 0;
+	struct pci_dev * pci_dev = to_pci_dev(dev);
+	struct pci_driver * drv = pci_dev->driver;
+
+	pci_fixup_device(pci_fixup_resume_early, pci_dev);
+
+	if (drv && drv->resume_early)
+		error = drv->resume_early(pci_dev);
+	return error;
+}
+
 static int pci_legacy_resume(struct device *dev)
 {
 	int error;
@@ -388,19 +401,6 @@ static int pci_legacy_resume(struct devi
 	return error;
 }
 
-static int pci_legacy_resume_early(struct device *dev)
-{
-	int error = 0;
-	struct pci_dev * pci_dev = to_pci_dev(dev);
-	struct pci_driver * drv = pci_dev->driver;
-
-	pci_fixup_device(pci_fixup_resume_early, pci_dev);
-
-	if (drv && drv->resume_early)
-		error = drv->resume_early(pci_dev);
-	return error;
-}
-
 /* Auxiliary functions used by the new power management framework */
 
 static int pci_restore_standard_config(struct pci_dev *pci_dev)
@@ -547,36 +547,36 @@ static int pci_pm_suspend_noirq(struct d
 	return error;
 }
 
-static int pci_pm_resume(struct device *dev)
+static int pci_pm_resume_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
 	if (pci_has_legacy_pm_support(pci_dev))
-		return pci_legacy_resume(dev);
+		return pci_legacy_resume_early(dev);
 
-	error = pci_pm_default_resume(pci_dev);
+	pci_pm_default_resume_noirq(pci_dev);
 
-	if (!error && drv && drv->pm && drv->pm->resume)
-		error = drv->pm->resume(dev);
+	if (drv && drv->pm && drv->pm->resume_noirq)
+		error = drv->pm->resume_noirq(dev);
 
 	return error;
 }
 
-static int pci_pm_resume_noirq(struct device *dev)
+static int pci_pm_resume(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
 	if (pci_has_legacy_pm_support(pci_dev))
-		return pci_legacy_resume_early(dev);
+		return pci_legacy_resume(dev);
 
-	pci_pm_default_resume_noirq(pci_dev);
+	error = pci_pm_default_resume(pci_dev);
 
-	if (drv && drv->pm && drv->pm->resume_noirq)
-		error = drv->pm->resume_noirq(dev);
+	if (!error && drv && drv->pm && drv->pm->resume)
+		error = drv->pm->resume(dev);
 
 	return error;
 }
@@ -632,36 +632,36 @@ static int pci_pm_freeze_noirq(struct de
 	return error;
 }
 
-static int pci_pm_thaw(struct device *dev)
+static int pci_pm_thaw_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
 	if (pci_has_legacy_pm_support(pci_dev))
-		return pci_legacy_resume(dev);
+		return pci_legacy_resume_early(dev);
 
-	pci_pm_reenable_device(pci_dev);
+	pci_update_current_state(pci_dev, PCI_D0);
 
-	if (drv && drv->pm && drv->pm->thaw)
-		error =  drv->pm->thaw(dev);
+	if (drv && drv->pm && drv->pm->thaw_noirq)
+		error = drv->pm->thaw_noirq(dev);
 
 	return error;
 }
 
-static int pci_pm_thaw_noirq(struct device *dev)
+static int pci_pm_thaw(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
 	if (pci_has_legacy_pm_support(pci_dev))
-		return pci_legacy_resume_early(dev);
+		return pci_legacy_resume(dev);
 
-	pci_update_current_state(pci_dev, PCI_D0);
+	pci_pm_reenable_device(pci_dev);
 
-	if (drv && drv->pm && drv->pm->thaw_noirq)
-		error = drv->pm->thaw_noirq(dev);
+	if (drv && drv->pm && drv->pm->thaw)
+		error =  drv->pm->thaw(dev);
 
 	return error;
 }
@@ -702,36 +702,36 @@ static int pci_pm_poweroff_noirq(struct 
 	return error;
 }
 
-static int pci_pm_restore(struct device *dev)
+static int pci_pm_restore_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
 	if (pci_has_legacy_pm_support(pci_dev))
-		return pci_legacy_resume(dev);
+		return pci_legacy_resume_early(dev);
 
-	error = pci_pm_default_resume(pci_dev);
+	pci_pm_default_resume_noirq(pci_dev);
 
-	if (!error && drv && drv->pm && drv->pm->restore)
-		error = drv->pm->restore(dev);
+	if (drv && drv->pm && drv->pm->restore_noirq)
+		error = drv->pm->restore_noirq(dev);
 
 	return error;
 }
 
-static int pci_pm_restore_noirq(struct device *dev)
+static int pci_pm_restore(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
 	if (pci_has_legacy_pm_support(pci_dev))
-		return pci_legacy_resume_early(dev);
+		return pci_legacy_resume(dev);
 
-	pci_pm_default_resume_noirq(pci_dev);
+	error = pci_pm_default_resume(pci_dev);
 
-	if (drv && drv->pm && drv->pm->restore_noirq)
-		error = drv->pm->restore_noirq(dev);
+	if (!error && drv && drv->pm && drv->pm->restore)
+		error = drv->pm->restore(dev);
 
 	return error;
 }

