Return-Path: <linux-kernel-owner+w=401wt.eu-S965881AbXIKNAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965881AbXIKNAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763121AbXIKNAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:00:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53249 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755AbXIKNAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:00:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 11 Sep 2007 14:59:17 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2.6.22.y] firewire: fw-ohci: ignore failure of
 pci_set_power_state (fix suspend regression)
To: stable@kernel.org
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.27649d5116b81d43@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Minor regression since 2.6.22-rc1:  If the experimental firewire-ohci
driver instead of ohci1394 was loaded, iBook G3 and older PowerBooks
refused to suspend.

Same as commit 5511142870046a7bed947d51ec9b320856ee120a plus format
string touch-ups from 8a8cea2734808522f02941ea16125810ee42c9c7,
"firewire: missing newline in printk".  Original patch description:

Fixes (papers over) "Sleep problems with kernels >= 2.6.21 on powerpc",
http://lkml.org/lkml/2007/8/25/155.  The issue is that the FireWire
controller's pci_dev.current_state of iBook G3 and presumably older
PowerBooks is still in PCI_UNKNOWN instead of PCI_D0 when the firewire
driver's .suspend method is called.

Like it was suggested earlier in http://lkml.org/lkml/2006/10/24/13, we
do not fail .suspend anymore if pci_set_power_state failed.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: linux-2.6.22.6/drivers/firewire/fw-ohci.c
===================================================================
--- linux-2.6.22.6.orig/drivers/firewire/fw-ohci.c
+++ linux-2.6.22.6/drivers/firewire/fw-ohci.c
@@ -1934,14 +1934,12 @@ static int pci_suspend(struct pci_dev *p
 	free_irq(pdev->irq, ohci);
 	err = pci_save_state(pdev);
 	if (err) {
-		fw_error("pci_save_state failed with %d", err);
+		fw_error("pci_save_state failed with %d\n", err);
 		return err;
 	}
 	err = pci_set_power_state(pdev, pci_choose_state(pdev, state));
-	if (err) {
-		fw_error("pci_set_power_state failed with %d", err);
-		return err;
-	}
+	if (err)
+		fw_error("pci_set_power_state failed with %d\n", err);
 
 	return 0;
 }
@@ -1955,7 +1953,7 @@ static int pci_resume(struct pci_dev *pd
 	pci_restore_state(pdev);
 	err = pci_enable_device(pdev);
 	if (err) {
-		fw_error("pci_enable_device failed with %d", err);
+		fw_error("pci_enable_device failed with %d\n", err);
 		return err;
 	}
 

-- 
Stefan Richter
-=====-=-=== =--= -=-==
http://arcgraph.de/sr/

