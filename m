Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbYLXI1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbYLXI1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 03:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYLXI1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 03:27:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44011 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYLXI1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 03:27:12 -0500
Message-ID: <4951F258.6040601@jp.fujitsu.com>
Date: Wed, 24 Dec 2008 17:27:04 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: linux-pci@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] PCI/MSI: bugfix/utilize for msi_capability_init()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix a following bug and does a cleanup.

bug:
	commit 5993760f7fc75b77e4701f1e56dc84c0d6cf18d5
	had a wrong change (since is_64 is boolean[0|1]):

-               pci_write_config_dword(dev,
-                       msi_mask_bits_reg(pos, is_64bit_address(control)),
-                       maskbits);
+               pci_write_config_dword(dev, entry->msi_attrib.is_64, maskbits);

utilize:
	Unify separated if (entry->msi_attrib.maskbit) statements.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 drivers/pci/msi.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 74801f7..5aee7ee 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -378,21 +378,19 @@ static int msi_capability_init(struct pci_dev *dev)
 	entry->msi_attrib.masked = 1;
 	entry->msi_attrib.default_irq = dev->irq;	/* Save IOAPIC IRQ */
 	entry->msi_attrib.pos = pos;
-	if (entry->msi_attrib.maskbit) {
-		entry->mask_base = (void __iomem *)(long)msi_mask_bits_reg(pos,
-				entry->msi_attrib.is_64);
-	}
 	entry->dev = dev;
 	if (entry->msi_attrib.maskbit) {
-		unsigned int maskbits, temp;
+		unsigned int base, maskbits, temp;
+
+		base = msi_mask_bits_reg(pos, entry->msi_attrib.is_64);
+		entry->mask_base = (void __iomem *)(long)base;
+
 		/* All MSIs are unmasked by default, Mask them all */
-		pci_read_config_dword(dev,
-			msi_mask_bits_reg(pos, entry->msi_attrib.is_64),
-			&maskbits);
+		pci_read_config_dword(dev, base, &maskbits);
 		temp = (1 << multi_msi_capable(control));
 		temp = ((temp - 1) & ~temp);
 		maskbits |= temp;
-		pci_write_config_dword(dev, entry->msi_attrib.is_64, maskbits);
+		pci_write_config_dword(dev, base, maskbits);
 		entry->msi_attrib.maskbits_mask = temp;
 	}
 	list_add_tail(&entry->list, &dev->msi_list);
-- 
1.6.1.rc4

