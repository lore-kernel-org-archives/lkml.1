Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZBWRv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZBWRv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbZBWRvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:51:48 -0500
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:48806 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752331AbZBWRvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:51:47 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 4/6] PCI MSI: Use mask_pos instead of mask_base when appropriate
Date: Mon, 23 Feb 2009 12:28:00 -0500
Message-Id: <1235410082-5016-5-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1235410082-5016-1-git-send-email-matthew@wil.cx>
References: <1235410082-5016-1-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

MSI interrupts have a mask_pos where MSI-X have a mask_base.  Use a
transparent union to get rid of some ugly casts.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/pci/msi.c   |    5 ++---
 include/linux/msi.h |    5 ++++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index a658c0f..fcde04d 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -145,7 +145,7 @@ static int msi_set_mask_bits(struct irq_desc *desc, u32 mask, u32 flag)
 		if (!entry->msi_attrib.maskbit)
 			return 0;
 
-		pos = (long)entry->mask_base;
+		pos = entry->mask_pos;
 		pci_read_config_dword(entry->dev, pos, &mask_bits);
 		mask_bits &= ~mask;
 		mask_bits |= flag & mask;
@@ -363,8 +363,7 @@ static int msi_capability_init(struct pci_dev *dev)
 		unsigned int base, maskbits, temp;
 
 		base = msi_mask_bits_reg(pos, entry->msi_attrib.is_64);
-		entry->mask_base = (void __iomem *)(long)base;
-
+		entry->mask_pos = base;
 		/* All MSIs are unmasked by default, Mask them all */
 		pci_read_config_dword(dev, base, &maskbits);
 		temp = msi_mask((control & PCI_MSI_FLAGS_QMASK) >> 1);
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 9c5ce21..5025ca4 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -33,7 +33,10 @@ struct msi_desc {
 	unsigned int irq;
 	struct list_head list;
 
-	void __iomem *mask_base;
+	union {
+		void __iomem *mask_base;
+		u8 mask_pos;
+	};
 	struct pci_dev *dev;
 
 	/* Last set MSI message */
-- 
1.5.6.5

