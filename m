Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbYL3Wud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbYL3Wud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 17:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYL3WuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 17:50:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57626 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbYL3WuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 17:50:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [RFC][PATCH 3/10] PCI PM: Power-manage devices without drivers during suspend-resume
Date: Tue, 30 Dec 2008 23:38:41 +0100
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
Message-Id: <200812302338.42915.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


PCI devices without drivers can be put into low power states during
suspend with the help of pci_prepare_to_sleep() and prevented from
generating wake-up events during resume with the help of
pci_enable_wake().  However, it's better not to put bridges into
low power states during suspend, because that might result in entire
bus segments being powered off.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -421,6 +421,31 @@ static int pci_legacy_resume_early(struc
 	return error;
 }
 
+/* Auxiliary functions used by the new power management framework */
+
+static bool pci_is_bridge(struct pci_dev *pci_dev)
+{
+	return !!(pci_dev->subordinate);
+}
+
+static int pci_pm_default_resume(struct pci_dev *pci_dev)
+{
+	if (!pci_is_bridge(pci_dev))
+		pci_enable_wake(pci_dev, PCI_D0, false);
+
+	return pci_default_pm_resume_late(pci_dev);
+}
+
+static void pci_pm_default_suspend(struct pci_dev *pci_dev)
+{
+	pci_default_pm_suspend_early(pci_dev);
+
+	if (!pci_is_bridge(pci_dev))
+		pci_prepare_to_sleep(pci_dev);
+}
+
+/* New power management framework */
+
 static int pci_pm_prepare(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
@@ -456,7 +481,7 @@ static int pci_pm_suspend(struct device 
 	} else if (pci_has_legacy_pm_support(pci_dev)) {
 		error = pci_legacy_suspend(dev, PMSG_SUSPEND);
 	} else {
-		pci_default_pm_suspend_early(pci_dev);
+		pci_pm_default_suspend(pci_dev);
 	}
 
 	pci_fixup_device(pci_fixup_suspend, pci_dev);
@@ -498,7 +523,7 @@ static int pci_pm_resume(struct device *
 	} else if (pci_has_legacy_pm_support(pci_dev)) {
 		error = pci_legacy_resume(dev);
 	} else {
-		error = pci_default_pm_resume_late(pci_dev);
+		error = pci_pm_default_resume(pci_dev);
 	}
 
 	return error;
@@ -628,7 +653,7 @@ static int pci_pm_poweroff(struct device
 	} else if (pci_has_legacy_pm_support(pci_dev)) {
 		error = pci_legacy_suspend(dev, PMSG_HIBERNATE);
 	} else {
-		pci_default_pm_suspend_early(pci_dev);
+		pci_pm_default_suspend(pci_dev);
 	}
 
 	pci_fixup_device(pci_fixup_suspend, pci_dev);
@@ -667,7 +692,7 @@ static int pci_pm_restore(struct device 
 	} else if (pci_has_legacy_pm_support(pci_dev)) {
 		error = pci_legacy_resume(dev);
 	} else {
-		error = pci_default_pm_resume_late(pci_dev);
+		error = pci_pm_default_resume(pci_dev);
 	}
 
 	return error;

