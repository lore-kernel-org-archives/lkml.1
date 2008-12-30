Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYL3WwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYL3WwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 17:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYL3WuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 17:50:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57670 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbYL3WuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 17:50:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [RFC][PATCH 1/10] PCI PM: Fix poweroff and restore callbacks
Date: Tue, 30 Dec 2008 23:35:53 +0100
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
Message-Id: <200812302335.54463.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


pci_fixup_device() is called too early in pci_pm_poweroff() and too
late in pci_pm_restore().  Moreover, pci_pm_restore_noirq() calls
pci_fixup_device() twice and in a wrong way.  Fix that.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -597,8 +597,6 @@ static int pci_pm_poweroff(struct device
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
-	pci_fixup_device(pci_fixup_suspend, pci_dev);
-
 	if (drv && drv->pm) {
 		if (drv->pm->poweroff) {
 			error = drv->pm->poweroff(dev);
@@ -608,6 +606,8 @@ static int pci_pm_poweroff(struct device
 		error = pci_legacy_suspend(dev, PMSG_HIBERNATE);
 	}
 
+	pci_fixup_device(pci_fixup_suspend, pci_dev);
+
 	return error;
 }
 
@@ -634,6 +634,8 @@ static int pci_pm_restore(struct device 
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
+	pci_fixup_device(pci_fixup_resume, pci_dev);
+
 	if (drv && drv->pm) {
 		if (drv->pm->restore)
 			error = drv->pm->restore(dev);
@@ -642,7 +644,6 @@ static int pci_pm_restore(struct device 
 	} else {
 		error = pci_default_pm_resume_late(pci_dev);
 	}
-	pci_fixup_device(pci_fixup_resume, pci_dev);
 
 	return error;
 }
@@ -653,7 +654,7 @@ static int pci_pm_restore_noirq(struct d
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
-	pci_fixup_device(pci_fixup_resume, pci_dev);
+	pci_fixup_device(pci_fixup_resume_early, pci_dev);
 
 	if (drv && drv->pm) {
 		if (drv->pm->restore_noirq)
@@ -663,7 +664,6 @@ static int pci_pm_restore_noirq(struct d
 	} else {
 		pci_default_pm_resume_early(pci_dev);
 	}
-	pci_fixup_device(pci_fixup_resume_early, pci_dev);
 
 	return error;
 }

