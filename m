Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbYIIPud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbYIIPud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbYIIPt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:49:59 -0400
Received: from mx.hit.edu.cn ([202.118.224.153]:34364 "EHLO hit.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753393AbYIIPt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:49:58 -0400
From: Jike Song <albcamus@gmail.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jike Song <albcamus@gmail.com>
Subject: [PATCH] PCI: utilize calculated results when detecting MSI features
Date: Tue,  9 Sep 2008 23:42:03 +0800
Message-Id: <1220974923-5863-2-git-send-email-albcamus@gmail.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1220974923-5863-1-git-send-email-albcamus@gmail.com>
References: <1220974923-5863-1-git-send-email-albcamus@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in function msi_capability_init, we can make use of the calculated
results instead of calling is_mask_bit_support and is_64bit_address
twice, in spite of the fact that they are macros.

Signed-off-by: Jike Song <albcamus@gmail.com>
---
 drivers/pci/msi.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 4a10b56..d281201 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -378,23 +378,21 @@ static int msi_capability_init(struct pci_dev *dev)
 	entry->msi_attrib.masked = 1;
 	entry->msi_attrib.default_irq = dev->irq;	/* Save IOAPIC IRQ */
 	entry->msi_attrib.pos = pos;
-	if (is_mask_bit_support(control)) {
+	if (entry->msi_attrib.maskbit) {
 		entry->mask_base = (void __iomem *)(long)msi_mask_bits_reg(pos,
-				is_64bit_address(control));
+				entry->msi_attrib.is_64);
 	}
 	entry->dev = dev;
 	if (entry->msi_attrib.maskbit) {
 		unsigned int maskbits, temp;
 		/* All MSIs are unmasked by default, Mask them all */
 		pci_read_config_dword(dev,
-			msi_mask_bits_reg(pos, is_64bit_address(control)),
+			msi_mask_bits_reg(pos, entry->msi_attrib.is_64),
 			&maskbits);
 		temp = (1 << multi_msi_capable(control));
 		temp = ((temp - 1) & ~temp);
 		maskbits |= temp;
-		pci_write_config_dword(dev,
-			msi_mask_bits_reg(pos, is_64bit_address(control)),
-			maskbits);
+		pci_write_config_dword(dev, entry->msi_attrib.is_64, maskbits);
 		entry->msi_attrib.maskbits_mask = temp;
 	}
 	list_add_tail(&entry->list, &dev->msi_list);
-- 
1.5.6

