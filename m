Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbYL0Pbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbYL0Pbl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 10:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYL0PbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 10:31:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45869 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070AbYL0PbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 10:31:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 2/2] PCI PM: Fix pci_update_current_state
Date: Sat, 27 Dec 2008 16:30:52 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200812271627.32781.rjw@sisk.pl>
In-Reply-To: <200812271627.32781.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812271630.52948.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Currently, PCI devices without the PM capability that are power
manageable by the platform (eg. ACPI) are not handled correctly
by pci_set_power_state(), because their current_state field is not
updated to reflect the new power state of the device.  Fix this by
making pci_update_current_state() accept additional argument
representing the power state of the device as set by the platform.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -524,14 +524,17 @@ pci_raw_set_power_state(struct pci_dev *
  * pci_update_current_state - Read PCI power state of given device from its
  *                            PCI PM registers and cache it
  * @dev: PCI device to handle.
+ * @state: State to cache in case the device doesn't have the PM capability
  */
-static void pci_update_current_state(struct pci_dev *dev)
+static void pci_update_current_state(struct pci_dev *dev, pci_power_t state)
 {
 	if (dev->pm_cap) {
 		u16 pmcsr;
 
 		pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
 		dev->current_state = (pmcsr & PCI_PM_CTRL_STATE_MASK);
+	} else {
+		dev->current_state = state;
 	}
 }
 
@@ -574,7 +577,7 @@ int pci_set_power_state(struct pci_dev *
 		 */
 		int ret = platform_pci_set_power_state(dev, PCI_D0);
 		if (!ret)
-			pci_update_current_state(dev);
+			pci_update_current_state(dev, PCI_D0);
 	}
 	/* This device is quirked not to be put into D3, so
 	   don't put it in D3 */
@@ -587,7 +590,7 @@ int pci_set_power_state(struct pci_dev *
 		/* Allow the platform to finalize the transition */
 		int ret = platform_pci_set_power_state(dev, state);
 		if (!ret) {
-			pci_update_current_state(dev);
+			pci_update_current_state(dev, state);
 			error = 0;
 		}
 	}
