Return-Path: <linux-kernel-owner+w=401wt.eu-S1759910AbZCTXEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910AbZCTXEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZCTXEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:04:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49784 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbZCTXEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:04:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [RFC][PATCH] PCI PM: Be extra careful when changing power states of devices
Date: Sat, 21 Mar 2009 00:03:54 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903210003.55161.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The story in http://bugzilla.kernel.org/show_bug.cgi?id=12846 shows
that setting the power state of a PCI device by
pci_raw_set_power_state() may sometimes fail.  For this reason,
pci_raw_set_power_state() should not assume that the power state of
the device has actually changed after writing into its PMCSR.
Instead, it should read the value from there and use it to update
dev->current_state.  It also is useful to print a warning if the
device's power state hasn't changed as expected.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -436,7 +436,7 @@ static inline int platform_pci_sleep_wak
  */
 static int pci_raw_set_power_state(struct pci_dev *dev, pci_power_t state)
 {
-	u16 pmcsr;
+	u16 pmcsr, new_pmcsr;
 	bool need_restore = false;
 
 	/* Check if we're already there */
@@ -498,7 +498,15 @@ static int pci_raw_set_power_state(struc
 	else if (state == PCI_D2 || dev->current_state == PCI_D2)
 		udelay(PCI_PM_D2_DELAY);
 
-	dev->current_state = state;
+	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &new_pmcsr);
+	if (new_pmcsr == pmcsr) {
+		dev->current_state = state;
+	} else {
+		dev->current_state = (new_pmcsr & PCI_PM_CTRL_STATE_MASK);
+		dev_warn(&dev->dev,
+			"failed to set power state to D%d, is D%d\n", state,
+			dev->current_state);
+	}
 
 	/* According to section 5.4.1 of the "PCI BUS POWER MANAGEMENT
 	 * INTERFACE SPECIFICATION, REV. 1.2", a device transitioning
