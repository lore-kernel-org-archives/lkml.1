Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZAZUoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZAZUoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 15:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbZAZUny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 15:43:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54437 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbZAZUnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 15:43:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI PM: Fix suspend error paths and testing facility breakage
Date: Mon, 26 Jan 2009 21:43:08 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901262143.10434.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If one of device drivers refuses to suspend by returning error code
from its ->suspend() callback, the devices that have already been
suspended are resumed by executing their drivers' ->resume()
callbacks.  Some of these callbacks expect the device's
configuration space to be restored if the device has been put into
D3 before they are called.  Unfortunately, this mechanism has been
broken by recent changes moving the restoration of config spaces
of some devices (most importantly, USB controllers and HDA Intel)
into the resume callbacks executed with interrupts off.  Obviously,
these callbacks are not invoked in the suspend error path and, as a
result, the system cannot be successfully brought back into the
working state in case of a suspend error.  The same thing happens
in the hibernation error path right before putting the system into
S4.

Similarly, the suspend testing facility associated with the
/sys/power/pm_test file is broken, because it uses the very same
mechanism that is used in the suspend and hibernation error paths.

Fix the breakage by making the PCI core restore the configuration
spaces of PCI devices that haven't been restored already before
pci_pm_resume() is called for those devices by the PM core.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -370,6 +370,7 @@ static int pci_legacy_suspend(struct dev
 	}
 
 	pci_save_state(pci_dev);
+	pci_dev->state_saved = true;
 	/*
 	 * This is for compatibility with existing code with legacy PM support.
 	 */
@@ -419,6 +420,7 @@ static int pci_legacy_resume(struct devi
 static void pci_pm_default_resume_noirq(struct pci_dev *pci_dev)
 {
 	pci_restore_standard_config(pci_dev);
+	pci_dev->state_saved = false;
 	pci_fixup_device(pci_fixup_resume_early, pci_dev);
 }
 
@@ -555,6 +557,13 @@ static int pci_pm_resume(struct device *
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
+	/*
+	 * This is necessary for the suspend error path in which resume is
+	 * called without restoring the standard config registers of the device.
+	 */
+	if (pci_dev->state_saved)
+		pci_restore_standard_config(pci_dev);
+
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume(dev);
 
@@ -713,6 +722,13 @@ static int pci_pm_restore(struct device 
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
+	/*
+	 * This is necessary for the hibernation error path in which restore is
+	 * called without restoring the standard config registers of the device.
+	 */
+	if (pci_dev->state_saved)
+		pci_restore_standard_config(pci_dev);
+
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume(dev);
 

