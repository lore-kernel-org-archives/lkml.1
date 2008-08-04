Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbYHDQFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbYHDQFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbYHDQFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:05:05 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:50499 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753505AbYHDQFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:05:03 -0400
X-BigFish: VPS7(zz19c2kzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K533C1-04-0UD-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, rth@twiddle.net,
       paulus@samba.org, benh@kernel.crashing.org, davem@davemloft.net,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Muli Ben-Yehuda <muli@il.ibm.com>, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/10] powerpc: use iommu_num_pages function in IOMMU code
Date: Mon, 4 Aug 2008 18:04:48 +0200
Message-ID: <1217865890-3593-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
References: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Aug 2008 16:04:51.0730 (UTC) FILETIME=[D3D9B720:01C8F64B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/powerpc/kernel/iommu.c |   23 +++++++----------------
 1 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index e2cf632..ea1ba89 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -51,17 +51,6 @@ static int protect4gb = 1;
 
 static void __iommu_free(struct iommu_table *, dma_addr_t, unsigned int);
 
-static inline unsigned long iommu_nr_pages(unsigned long vaddr,
-					    unsigned long slen)
-{
-	unsigned long npages;
-
-	npages = IOMMU_PAGE_ALIGN(vaddr + slen) - (vaddr & IOMMU_PAGE_MASK);
-	npages >>= IOMMU_PAGE_SHIFT;
-
-	return npages;
-}
-
 static int __init setup_protect4gb(char *str)
 {
 	if (strcmp(str, "on") == 0)
@@ -325,7 +314,7 @@ int iommu_map_sg(struct device *dev, struct iommu_table *tbl,
 		}
 		/* Allocate iommu entries for that segment */
 		vaddr = (unsigned long) sg_virt(s);
-		npages = iommu_nr_pages(vaddr, slen);
+		npages = iommu_num_pages(vaddr, slen, IOMMU_PAGE_SIZE);
 		align = 0;
 		if (IOMMU_PAGE_SHIFT < PAGE_SHIFT && slen >= PAGE_SIZE &&
 		    (vaddr & ~PAGE_MASK) == 0)
@@ -418,7 +407,8 @@ int iommu_map_sg(struct device *dev, struct iommu_table *tbl,
 			unsigned long vaddr, npages;
 
 			vaddr = s->dma_address & IOMMU_PAGE_MASK;
-			npages = iommu_nr_pages(s->dma_address, s->dma_length);
+			npages = iommu_num_pages(s->dma_address, s->dma_length,
+						 IOMMU_PAGE_SIZE);
 			__iommu_free(tbl, vaddr, npages);
 			s->dma_address = DMA_ERROR_CODE;
 			s->dma_length = 0;
@@ -452,7 +442,8 @@ void iommu_unmap_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 
 		if (sg->dma_length == 0)
 			break;
-		npages = iommu_nr_pages(dma_handle, sg->dma_length);
+		npages = iommu_num_pages(dma_handle, sg->dma_length,
+					 IOMMU_PAGE_SIZE);
 		__iommu_free(tbl, dma_handle, npages);
 		sg = sg_next(sg);
 	}
@@ -584,7 +575,7 @@ dma_addr_t iommu_map_single(struct device *dev, struct iommu_table *tbl,
 	BUG_ON(direction == DMA_NONE);
 
 	uaddr = (unsigned long)vaddr;
-	npages = iommu_nr_pages(uaddr, size);
+	npages = iommu_num_pages(uaddr, size, IOMMU_PAGE_SIZE);
 
 	if (tbl) {
 		align = 0;
@@ -617,7 +608,7 @@ void iommu_unmap_single(struct iommu_table *tbl, dma_addr_t dma_handle,
 	BUG_ON(direction == DMA_NONE);
 
 	if (tbl) {
-		npages = iommu_nr_pages(dma_handle, size);
+		npages = iommu_num_pages(dma_handle, size, IOMMU_PAGE_SIZE);
 		iommu_free(tbl, dma_handle, npages);
 	}
 }
-- 
1.5.3.7


