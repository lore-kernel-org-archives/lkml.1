Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbZCNLjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbZCNLjJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbZCNLgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:36:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40266 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494AbZCNLfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:35:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 7/11] PCI PM: Use pci_set_power_state during early resume
Date: Sat, 14 Mar 2009 12:31:18 +0100
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
Message-Id: <200903141231.20024.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Once we have allowed timer interrupts to be enabled during the early
phase of resuming devices, we are now able to use the generic
pci_set_power_state() to put PCI devices into D0 at that time.  Then,
the platform-specific PM code will have a chance to handle devices
that don't implement the native PCI PM or that require some
additional, platform-specific operations to be carried out to power
them up.  Also, by doing this we can simplify the code quite a bit.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c |   48 +++++++++---------------------------------------
 1 file changed, 9 insertions(+), 39 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -426,7 +426,6 @@ static inline int platform_pci_sleep_wak
  *                           given PCI device
  * @dev: PCI device to handle.
  * @state: PCI power state (D0, D1, D2, D3hot) to put the device into.
- * @wait: If 'true', wait for the device to change its power state
  *
  * RETURN VALUE:
  * -EINVAL if the requested state is invalid.
@@ -435,8 +434,7 @@ static inline int platform_pci_sleep_wak
  * 0 if device already is in the requested state.
  * 0 if device's power state has been successfully changed.
  */
-static int
-pci_raw_set_power_state(struct pci_dev *dev, pci_power_t state, bool wait)
+static int pci_raw_set_power_state(struct pci_dev *dev, pci_power_t state)
 {
 	u16 pmcsr;
 	bool need_restore = false;
@@ -481,10 +479,8 @@ pci_raw_set_power_state(struct pci_dev *
 		break;
 	case PCI_UNKNOWN: /* Boot-up */
 		if ((pmcsr & PCI_PM_CTRL_STATE_MASK) == PCI_D3hot
-		 && !(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET)) {
+		 && !(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET))
 			need_restore = true;
-			wait = true;
-		}
 		/* Fall-through: force to D0 */
 	default:
 		pmcsr = 0;
@@ -494,9 +490,6 @@ pci_raw_set_power_state(struct pci_dev *
 	/* enter specified state */
 	pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, pmcsr);
 
-	if (!wait)
-		return 0;
-
 	/* Mandatory power management transition delays */
 	/* see PCI PM 1.1 5.6.1 table 18 */
 	if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
@@ -521,7 +514,7 @@ pci_raw_set_power_state(struct pci_dev *
 	if (need_restore)
 		pci_restore_bars(dev);
 
-	if (wait && dev->bus->self)
+	if (dev->bus->self)
 		pcie_aspm_pm_state_change(dev->bus->self);
 
 	return 0;
@@ -591,7 +584,7 @@ int pci_set_power_state(struct pci_dev *
 	if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
 		return 0;
 
-	error = pci_raw_set_power_state(dev, state, true);
+	error = pci_raw_set_power_state(dev, state);
 
 	if (state > PCI_D0 && platform_pci_power_manageable(dev)) {
 		/* Allow the platform to finalize the transition */
@@ -1390,37 +1383,14 @@ void pci_allocate_cap_save_buffers(struc
  */
 int pci_restore_standard_config(struct pci_dev *dev)
 {
-	pci_power_t prev_state;
-	int error;
-
-	pci_update_current_state(dev, PCI_D0);
-
-	prev_state = dev->current_state;
-	if (prev_state == PCI_D0)
-		goto Restore;
-
-	error = pci_raw_set_power_state(dev, PCI_D0, false);
-	if (error)
-		return error;
+	pci_update_current_state(dev, PCI_UNKNOWN);
 
-	/*
-	 * This assumes that we won't get a bus in B2 or B3 from the BIOS, but
-	 * we've made this assumption forever and it appears to be universally
-	 * satisfied.
-	 */
-	switch(prev_state) {
-	case PCI_D3cold:
-	case PCI_D3hot:
-		mdelay(pci_pm_d3_delay);
-		break;
-	case PCI_D2:
-		udelay(PCI_PM_D2_DELAY);
-		break;
+	if (dev->current_state != PCI_D0) {
+		int error = pci_set_power_state(dev, PCI_D0);
+		if (error)
+			return error;
 	}
 
-	pci_update_current_state(dev, PCI_D0);
-
- Restore:
 	return dev->state_saved ? pci_restore_state(dev) : 0;
 }
 
