Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbZCNLj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbZCNLj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755748AbZCNLgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:36:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40257 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268AbZCNLfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:35:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 9/11] PCI PM: Put devices into low power states during late suspend (rev. 2)
Date: Sat, 14 Mar 2009 12:32:54 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200902221837.49396.rjw@sisk.pl> <200903141224.29591.rjw@sisk.pl>
In-Reply-To: <200903141224.29591.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903141232.55346.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Once we have allowed timer interrupts to be enabled during the late
phase of suspending devices, we are now able to use the generic
pci_set_power_state() to put PCI devices into low power states at
that time.  We can also use some related platform callbacks, like the
ones preparing devices for wake-up, during the late suspend.

Doing this will allow us to avoid the race condition where a device
using shared interrupts is put into a low power state with interrupts
enabled and then an interrupt (for another device) comes in and
confuses its driver.  At the same time, devices that don't support
the native PCI PM or that require some additional, platform-specific
operations to be carried out to put them into low power states will
be handled as appropriate.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |  134 ++++++++++++++++++++++++++++-------------------
 1 file changed, 81 insertions(+), 53 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -352,53 +352,60 @@ static int pci_legacy_suspend(struct dev
 {
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
-	int error = 0;
+
+	pci_dev->state_saved = false;
 
 	if (drv && drv->suspend) {
 		pci_power_t prev = pci_dev->current_state;
-
-		pci_dev->state_saved = false;
+		int error;
 
 		error = drv->suspend(pci_dev, state);
 		suspend_report_result(drv->suspend, error);
 		if (error)
 			return error;
 
-		if (pci_dev->state_saved)
-			goto Fixup;
-
-		if (pci_dev->current_state != PCI_D0
+		if (!pci_dev->state_saved && pci_dev->current_state != PCI_D0
 		    && pci_dev->current_state != PCI_UNKNOWN) {
 			WARN_ONCE(pci_dev->current_state != prev,
 				"PCI PM: Device state not saved by %pF\n",
 				drv->suspend);
-			goto Fixup;
 		}
 	}
 
-	pci_save_state(pci_dev);
-	/*
-	 * This is for compatibility with existing code with legacy PM support.
-	 */
-	pci_pm_set_unknown_state(pci_dev);
-
- Fixup:
 	pci_fixup_device(pci_fixup_suspend, pci_dev);
 
-	return error;
+	return 0;
 }
 
 static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
 {
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
-	int error = 0;
 
 	if (drv && drv->suspend_late) {
+		pci_power_t prev = pci_dev->current_state;
+		int error;
+
 		error = drv->suspend_late(pci_dev, state);
 		suspend_report_result(drv->suspend_late, error);
+		if (error)
+			return error;
+
+		if (!pci_dev->state_saved && pci_dev->current_state != PCI_D0
+		    && pci_dev->current_state != PCI_UNKNOWN) {
+			WARN_ONCE(pci_dev->current_state != prev,
+				"PCI PM: Device state not saved by %pF\n",
+				drv->suspend_late);
+			return 0;
+		}
 	}
-	return error;
+
+	if (!pci_dev->state_saved)
+		pci_save_state(pci_dev);
+
+	pci_pm_set_unknown_state(pci_dev);
+
+	return 0;
 }
 
 static int pci_legacy_resume_early(struct device *dev)
@@ -460,7 +467,6 @@ static void pci_pm_default_suspend(struc
 	/* Disable non-bridge devices without PM support */
 	if (!pci_is_bridge(pci_dev))
 		pci_disable_enabled_device(pci_dev);
-	pci_save_state(pci_dev);
 }
 
 static bool pci_has_legacy_pm_support(struct pci_dev *pci_dev)
@@ -526,24 +532,14 @@ static int pci_pm_suspend(struct device 
 		if (error)
 			return error;
 
-		if (pci_dev->state_saved)
-			goto Fixup;
-
-		if (pci_dev->current_state != PCI_D0
+		if (!pci_dev->state_saved && pci_dev->current_state != PCI_D0
 		    && pci_dev->current_state != PCI_UNKNOWN) {
 			WARN_ONCE(pci_dev->current_state != prev,
 				"PCI PM: State of device not saved by %pF\n",
 				pm->suspend);
-			goto Fixup;
 		}
 	}
 
-	if (!pci_dev->state_saved) {
-		pci_save_state(pci_dev);
-		if (!pci_is_bridge(pci_dev))
-			pci_prepare_to_sleep(pci_dev);
-	}
-
  Fixup:
 	pci_fixup_device(pci_fixup_suspend, pci_dev);
 
@@ -553,21 +549,41 @@ static int pci_pm_suspend(struct device 
 static int pci_pm_suspend_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct device_driver *drv = dev->driver;
-	int error = 0;
+	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend_late(dev, PMSG_SUSPEND);
 
-	if (drv && drv->pm && drv->pm->suspend_noirq) {
-		error = drv->pm->suspend_noirq(dev);
-		suspend_report_result(drv->pm->suspend_noirq, error);
+	if (!pm)
+		return 0;
+
+	if (pm->suspend_noirq) {
+		pci_power_t prev = pci_dev->current_state;
+		int error;
+
+		error = pm->suspend_noirq(dev);
+		suspend_report_result(pm->suspend_noirq, error);
+		if (error)
+			return error;
+
+		if (!pci_dev->state_saved && pci_dev->current_state != PCI_D0
+		    && pci_dev->current_state != PCI_UNKNOWN) {
+			WARN_ONCE(pci_dev->current_state != prev,
+				"PCI PM: State of device not saved by %pF\n",
+				pm->suspend_noirq);
+			return 0;
+		}
 	}
 
-	if (!error)
-		pci_pm_set_unknown_state(pci_dev);
+	if (!pci_dev->state_saved) {
+		pci_save_state(pci_dev);
+		if (!pci_is_bridge(pci_dev))
+			pci_prepare_to_sleep(pci_dev);
+	}
 
-	return error;
+	pci_pm_set_unknown_state(pci_dev);
+
+	return 0;
 }
 
 static int pci_pm_resume_noirq(struct device *dev)
@@ -650,9 +666,6 @@ static int pci_pm_freeze(struct device *
 			return error;
 	}
 
-	if (!pci_dev->state_saved)
-		pci_save_state(pci_dev);
-
 	return 0;
 }
 
@@ -660,20 +673,25 @@ static int pci_pm_freeze_noirq(struct de
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct device_driver *drv = dev->driver;
-	int error = 0;
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend_late(dev, PMSG_FREEZE);
 
 	if (drv && drv->pm && drv->pm->freeze_noirq) {
+		int error;
+
 		error = drv->pm->freeze_noirq(dev);
 		suspend_report_result(drv->pm->freeze_noirq, error);
+		if (error)
+			return error;
 	}
 
-	if (!error)
-		pci_pm_set_unknown_state(pci_dev);
+	if (!pci_dev->state_saved)
+		pci_save_state(pci_dev);
 
-	return error;
+	pci_pm_set_unknown_state(pci_dev);
+
+	return 0;
 }
 
 static int pci_pm_thaw_noirq(struct device *dev)
@@ -716,7 +734,6 @@ static int pci_pm_poweroff(struct device
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-	int error = 0;
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend(dev, PMSG_HIBERNATE);
@@ -729,33 +746,44 @@ static int pci_pm_poweroff(struct device
 	pci_dev->state_saved = false;
 
 	if (pm->poweroff) {
+		int error;
+
 		error = pm->poweroff(dev);
 		suspend_report_result(pm->poweroff, error);
+		if (error)
+			return error;
 	}
 
-	if (!pci_dev->state_saved && !pci_is_bridge(pci_dev))
-		pci_prepare_to_sleep(pci_dev);
-
  Fixup:
 	pci_fixup_device(pci_fixup_suspend, pci_dev);
 
-	return error;
+	return 0;
 }
 
 static int pci_pm_poweroff_noirq(struct device *dev)
 {
+	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct device_driver *drv = dev->driver;
-	int error = 0;
 
 	if (pci_has_legacy_pm_support(to_pci_dev(dev)))
 		return pci_legacy_suspend_late(dev, PMSG_HIBERNATE);
 
-	if (drv && drv->pm && drv->pm->poweroff_noirq) {
+	if (!drv || !drv->pm)
+		return 0;
+
+	if (drv->pm->poweroff_noirq) {
+		int error;
+
 		error = drv->pm->poweroff_noirq(dev);
 		suspend_report_result(drv->pm->poweroff_noirq, error);
+		if (error)
+			return error;
 	}
 
-	return error;
+	if (!pci_dev->state_saved && !pci_is_bridge(pci_dev))
+		pci_prepare_to_sleep(pci_dev);
+
+	return 0;
 }
 
 static int pci_pm_restore_noirq(struct device *dev)
