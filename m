Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbZKOMXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbZKOMXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 07:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZKOMXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 07:23:10 -0500
Received: from sh.osrg.net ([192.16.179.4]:46555 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbZKOMXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 07:23:06 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, muli@il.ibm.com,
       joerg.roedel@amd.com
Subject: [PATCH 3/3] Calgary: remove unnecessary DMA_ERROR_CODE usage
Date: Sun, 15 Nov 2009 21:19:54 +0900
Message-Id: <1258287594-8777-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1258287594-8777-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1258287594-8777-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 15 Nov 2009 21:22:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up iommu_alloc() a bit and removes unnecessary
DMA_ERROR_CODE usage.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-calgary_64.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index af9f436..849a099 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -261,12 +261,15 @@ static dma_addr_t iommu_alloc(struct device *dev, struct iommu_table *tbl,
 			      void *vaddr, unsigned int npages, int direction)
 {
 	unsigned long entry;
-	dma_addr_t ret = DMA_ERROR_CODE;
+	dma_addr_t ret;
 
 	entry = iommu_range_alloc(dev, tbl, npages);
 
-	if (unlikely(entry == DMA_ERROR_CODE))
-		goto error;
+	if (unlikely(entry == DMA_ERROR_CODE)) {
+		printk(KERN_WARNING "Calgary: failed to allocate %u pages in "
+		       "iommu %p\n", npages, tbl);
+		return DMA_ERROR_CODE;
+	}
 
 	/* set the return dma address */
 	ret = (entry << PAGE_SHIFT) | ((unsigned long)vaddr & ~PAGE_MASK);
@@ -274,13 +277,7 @@ static dma_addr_t iommu_alloc(struct device *dev, struct iommu_table *tbl,
 	/* put the TCEs in the HW table */
 	tce_build(tbl, entry, npages, (unsigned long)vaddr & PAGE_MASK,
 		  direction);
-
 	return ret;
-
-error:
-	printk(KERN_WARNING "Calgary: failed to allocate %u pages in "
-	       "iommu %p\n", npages, tbl);
-	return DMA_ERROR_CODE;
 }
 
 static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
-- 
1.5.6.5

