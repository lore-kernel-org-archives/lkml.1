Return-Path: <linux-kernel-owner+w=401wt.eu-S933121AbXBLHlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbXBLHlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933118AbXBLHkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:40:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:49649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933089AbXBLHi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:29 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Muli Ben-Yehuda <muli@il.ibm.com>, Leo Duran <leo.duran@amd.com>,
       Job Mason <jdmason@kudzu.us>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [37/39] x86_64: robustify bad_dma_address handling
Message-Id: <20070212073825.BEB1213DA0@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Muli Ben-Yehuda <muli@il.ibm.com>

- set bad_dma_address explicitly to 0x0
- reserve 32 pages from bad_dma_address and up
- WARN_ON() a driver feeding us bad_dma_address

Thanks to Leo Duran <leo.duran@amd.com> for the suggestion.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Leo Duran <leo.duran@amd.com>
Cc: Job Mason <jdmason@kudzu.us>
---
 arch/x86_64/kernel/pci-calgary.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/kernel/pci-calgary.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-calgary.c
+++ linux/arch/x86_64/kernel/pci-calgary.c
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
