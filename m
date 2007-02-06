Return-Path: <linux-kernel-owner+w=401wt.eu-S1751263AbXBFOQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbXBFOQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 09:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbXBFOQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 09:16:27 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:32819 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbXBFOQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 09:16:26 -0500
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org, muli@il.ibm.com,
       jdmason@kudzu.us
Subject: [PATCH 1/1] x86-64 Calgary: robustify bad_dma_address handling
Reply-To: muli@il.ibm.com
Date: Tue, 06 Feb 2007 16:16:19 +0200
Message-Id: <11707713793983-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.1
In-Reply-To: <11707713793756-git-send-email-muli@il.ibm.com>
References: <11707713793756-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

- set bad_dma_address explicitly to 0x0
- reserve 32 pages from bad_dma_address and up
- WARN_ON() a driver feeding us bad_dma_address

Thanks to Leo Duran <leo.duran@amd.com> for the suggestion.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Leo Duran <leo.duran@amd.com>
Cc: Job Mason <jdmason@kudzu.us>
---
 arch/x86_64/kernel/pci-calgary.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index 3d65b1d..04480c3 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -138,6 +138,8 @@ static const unsigned long phb_debug_off
 
 #define PHB_DEBUG_STUFF_OFFSET	0x0020
 
+#define EMERGENCY_PAGES 32 /* = 128KB */
+
 unsigned int specified_table_size = TCE_TABLE_SIZE_UNSPECIFIED;
 static int translate_empty_slots __read_mostly = 0;
 static int calgary_detected __read_mostly = 0;
@@ -296,6 +298,16 @@ static void __iommu_free(struct iommu_ta
 {
 	unsigned long entry;
 	unsigned long badbit;
+	unsigned long badend;
+
+	/* were we called with bad_dma_address? */
+	badend = bad_dma_address + (EMERGENCY_PAGES * PAGE_SIZE);
+	if (unlikely((dma_addr >= bad_dma_address) && (dma_addr < badend))) {
+		printk(KERN_ERR "Calgary: driver tried unmapping bad DMA "
+		       "address 0x%Lx\n", dma_addr);
+		WARN_ON(1);
+		return;
+	}
 
 	entry = dma_addr >> PAGE_SHIFT;
 
@@ -656,8 +668,8 @@ static void __init calgary_reserve_regio
 	u64 start;
 	struct iommu_table *tbl = dev->sysdata;
 
-	/* reserve bad_dma_address in case it's a legal address */
-	iommu_range_reserve(tbl, bad_dma_address, 1);
+	/* reserve EMERGENCY_PAGES from bad_dma_address and up */
+	iommu_range_reserve(tbl, bad_dma_address, EMERGENCY_PAGES);
 
 	/* avoid the BIOS/VGA first 640KB-1MB region */
 	start = (640 * 1024);
@@ -1176,6 +1188,7 @@ int __init calgary_iommu_init(void)
 	}
 
 	force_iommu = 1;
+	bad_dma_address = 0x0;
 	dma_ops = &calgary_dma_ops;
 
 	return 0;
-- 
1.4.1

