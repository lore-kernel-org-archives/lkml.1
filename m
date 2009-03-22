Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZCVVNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZCVVNy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 17:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbZCVVNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 17:13:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54602 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbZCVVNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 17:13:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [RFC][PATCH 1/2] PCI PM: Introduce __pci_set_power_state()
Date: Sun, 22 Mar 2009 22:11:49 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200903210003.55161.rjw@sisk.pl> <200903222208.22434.rjw@sisk.pl>
In-Reply-To: <200903222208.22434.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903222211.50930.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The story in http://bugzilla.kernel.org/show_bug.cgi?id=12846 shows
that setting the power state of a PCI device may sometimes require
multiple attempts to program the device's PMCSR and and/or an delay
longer than the default one.  For this reason, introduce
__pci_set_power_state() that will take two additional arguments, the
number of attempts to program the power state of the device to be
made and the delay after writing a new value to the device's PMCSR.
Redefine pci_set_power_state() as __pci_set_power_state() using the
default values of the new arguments.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c   |   63 +++++++++++++++++++++++++++++++++++++++-------------
 include/linux/pci.h |    7 ++++-
 2 files changed, 54 insertions(+), 16 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -426,6 +426,9 @@ static inline int platform_pci_sleep_wak
  *                           given PCI device
  * @dev: PCI device to handle.
  * @state: PCI power state (D0, D1, D2, D3hot) to put the device into.
+ * @attempts: How many times to try to change the power state of the device
+ * @delay: Delay after programming the new power state, in miliseconds (0 means
+ * use default)
  *
  * RETURN VALUE:
  * -EINVAL if the requested state is invalid.
@@ -434,9 +437,13 @@ static inline int platform_pci_sleep_wak
  * 0 if device already is in the requested state.
  * 0 if device's power state has been successfully changed.
  */
-static int pci_raw_set_power_state(struct pci_dev *dev, pci_power_t state)
+static int pci_raw_set_power_state(
+	struct pci_dev *dev,
+	pci_power_t state,
+	unsigned int attempts,
+	unsigned int delay)
 {
-	u16 pmcsr;
+	u16 pmcsr, new_pmcsr;
 	bool need_restore = false;
 
 	/* Check if we're already there */
@@ -488,17 +495,36 @@ static int pci_raw_set_power_state(struc
 		break;
 	}
 
-	/* enter specified state */
-	pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, pmcsr);
+	do {
+		/* Program the requested state */
+		pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, pmcsr);
 
-	/* Mandatory power management transition delays */
-	/* see PCI PM 1.1 5.6.1 table 18 */
-	if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
-		msleep(pci_pm_d3_delay);
-	else if (state == PCI_D2 || dev->current_state == PCI_D2)
-		udelay(PCI_PM_D2_DELAY);
+		/*
+		 * If delay has not been specified, use mandatory PCI power
+		 * management transition delays (see PCI PM 1.1 5.6.1 table 18).
+		 */
+		if (delay)
+			msleep(delay);
+		else if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
+			msleep(pci_pm_d3_delay);
+		else if (state == PCI_D2 || dev->current_state == PCI_D2)
+			udelay(PCI_PM_D2_DELAY);
+
+		/* Check if the power state has actually changed */
+		pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL,
+					&new_pmcsr);
+		if (pmcsr == new_pmcsr) {
+			dev->current_state = state;
+			break;
+		}
+	} while (--attempts);
 
-	dev->current_state = state;
+	if (pmcsr != new_pmcsr) {
+		dev->current_state = (new_pmcsr & PCI_PM_CTRL_STATE_MASK);
+		dev_warn(&dev->dev,
+			"failed to set power state to D%d, is D%d\n", state,
+			dev->current_state);
+	}
 
 	/* According to section 5.4.1 of the "PCI BUS POWER MANAGEMENT
 	 * INTERFACE SPECIFICATION, REV. 1.2", a device transitioning
@@ -540,9 +566,12 @@ void pci_update_current_state(struct pci
 }
 
 /**
- * pci_set_power_state - Set the power state of a PCI device
+ * __pci_set_power_state - Set the power state of a PCI device
  * @dev: PCI device to handle.
  * @state: PCI power state (D0, D1, D2, D3hot) to put the device into.
+ * @attempts: How many times to try to change the power state of the device.
+ * @delay: Delay after programming the new power state, in miliseconds (0 means
+ * use default).
  *
  * Transition a device to a new power state, using the platform formware and/or
  * the device's PCI PM registers.
@@ -554,7 +583,11 @@ void pci_update_current_state(struct pci
  * 0 if device already is in the requested state.
  * 0 if device's power state has been successfully changed.
  */
-int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
+int __pci_set_power_state(
+	struct pci_dev *dev,
+	pci_power_t state,
+	unsigned int attempts,
+	unsigned int delay)
 {
 	int error;
 
@@ -590,7 +623,7 @@ int pci_set_power_state(struct pci_dev *
 	if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
 		return 0;
 
-	error = pci_raw_set_power_state(dev, state);
+	error = pci_raw_set_power_state(dev, state, attempts, delay);
 
 	if (state > PCI_D0 && platform_pci_power_manageable(dev)) {
 		/* Allow the platform to finalize the transition */
@@ -603,6 +636,7 @@ int pci_set_power_state(struct pci_dev *
 
 	return error;
 }
+EXPORT_SYMBOL(__pci_set_power_state);
 
 /**
  * pci_choose_state - Choose the power state of a PCI device
@@ -2409,7 +2443,6 @@ EXPORT_SYMBOL(pci_assign_resource);
 EXPORT_SYMBOL(pci_find_parent_resource);
 EXPORT_SYMBOL(pci_select_bars);
 
-EXPORT_SYMBOL(pci_set_power_state);
 EXPORT_SYMBOL(pci_save_state);
 EXPORT_SYMBOL(pci_restore_state);
 EXPORT_SYMBOL(pci_pme_capable);
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -689,7 +689,12 @@ size_t pci_get_rom_size(struct pci_dev *
 /* Power management related routines */
 int pci_save_state(struct pci_dev *dev);
 int pci_restore_state(struct pci_dev *dev);
-int pci_set_power_state(struct pci_dev *dev, pci_power_t state);
+int __pci_set_power_state(struct pci_dev *dev, pci_power_t state,
+				unsigned int attempts, unsigned int delay);
+static inline int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
+{
+	return __pci_set_power_state(dev, state, 1, 0);
+}
 pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state);
 bool pci_pme_capable(struct pci_dev *dev, pci_power_t state);
 void pci_pme_active(struct pci_dev *dev, bool enable);
