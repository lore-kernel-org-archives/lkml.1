Return-Path: <linux-kernel-owner+w=401wt.eu-S1765562AbXLQVjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765562AbXLQVjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759464AbXLQVjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:39:00 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:34379 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159AbXLQVi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:38:59 -0500
Date: Tue, 18 Dec 2007 00:39:27 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [PATCH] PCI: fix for quirk_e100_interrupt()
Message-ID: <20071218003927.A3045@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check that the e100 is in the D0 power state. If it's not, it won't
respond to MMIO accesses and we end up with master-abort machine
checks on some platforms.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 drivers/pci/quirks.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 26cc4dc..c8b2b9d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1406,9 +1406,10 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NETMOS, PCI_ANY_ID, quirk_netmos);
 
 static void __devinit quirk_e100_interrupt(struct pci_dev *dev)
 {
-	u16 command;
+	u16 command, pmcsr;
 	u8 __iomem *csr;
 	u8 cmd_hi;
+	int pm;
 
 	switch (dev->device) {
 	/* PCI IDs taken from drivers/net/e100.c */
@@ -1442,6 +1443,17 @@ static void __devinit quirk_e100_interrupt(struct pci_dev *dev)
 	if (!(command & PCI_COMMAND_MEMORY) || !pci_resource_start(dev, 0))
 		return;
 
+	/*
+	 * Check that the device is in the D0 power state. If it's not,
+	 * there is no point to look any further.
+	 */
+	pm = pci_find_capability(dev, PCI_CAP_ID_PM);
+	if (pm) {
+		pci_read_config_word(dev, pm + PCI_PM_CTRL, &pmcsr);
+		if ((pmcsr & PCI_PM_CTRL_STATE_MASK) != PCI_D0)
+			return;
+	}
+
 	/* Convert from PCI bus to resource space.  */
 	csr = ioremap(pci_resource_start(dev, 0), 8);
 	if (!csr) {
