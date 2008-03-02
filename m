Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbYCBGU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbYCBGU3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 01:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYCBGUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 01:20:16 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:34154 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbYCBGUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 01:20:15 -0500
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Mar 2008 01:20:14 EST
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-parisc@vger.kernel.org, tomof@acm.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 2/3] parisc: pass struct device to iommu_alloc_range
Date: Sun,  2 Mar 2008 15:10:27 +0900
Message-Id: <1204438228-4564-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1204438228-4564-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1204438228-4564-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1204438228-4564-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds struct device argument to sba_alloc_range and
ccio_alloc_range, a preparation for modifications to fix the IOMMU
segment boundary problem. This change enables ccio_alloc_range to
access to LLD's segment boundary limits.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/parisc/ccio-dma.c      |    4 ++--
 drivers/parisc/iommu-helpers.h |    4 ++--
 drivers/parisc/sba_iommu.c     |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index d08b284..1695fac 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -341,7 +341,7 @@ static int ioc_count;
  * of available pages for the requested size.
  */
 static int
-ccio_alloc_range(struct ioc *ioc, size_t size)
+ccio_alloc_range(struct ioc *ioc, struct device *dev, size_t size)
 {
 	unsigned int pages_needed = size >> IOVP_SHIFT;
 	unsigned int res_idx;
@@ -760,7 +760,7 @@ ccio_map_single(struct device *dev, void *addr, size_t size,
 	ioc->msingle_pages += size >> IOVP_SHIFT;
 #endif
 
-	idx = ccio_alloc_range(ioc, size);
+	idx = ccio_alloc_range(ioc, dev, size);
 	iovp = (dma_addr_t)MKIOVP(idx);
 
 	pdir_start = &(ioc->pdir_base[idx]);
diff --git a/drivers/parisc/iommu-helpers.h b/drivers/parisc/iommu-helpers.h
index 97ba828..3cc6930 100644
--- a/drivers/parisc/iommu-helpers.h
+++ b/drivers/parisc/iommu-helpers.h
@@ -97,7 +97,7 @@ iommu_fill_pdir(struct ioc *ioc, struct scatterlist *startsg, int nents,
 static inline unsigned int
 iommu_coalesce_chunks(struct ioc *ioc, struct device *dev,
 		      struct scatterlist *startsg, int nents,
-		      int (*iommu_alloc_range)(struct ioc *, size_t))
+		      int (*iommu_alloc_range)(struct ioc *, struct device *, size_t))
 {
 	struct scatterlist *contig_sg;	   /* contig chunk head */
 	unsigned long dma_offset, dma_len; /* start/len of DMA stream */
@@ -166,7 +166,7 @@ iommu_coalesce_chunks(struct ioc *ioc, struct device *dev,
 		dma_len = ALIGN(dma_len + dma_offset, IOVP_SIZE);
 		sg_dma_address(contig_sg) =
 			PIDE_FLAG 
-			| (iommu_alloc_range(ioc, dma_len) << IOVP_SHIFT)
+			| (iommu_alloc_range(ioc, dev, dma_len) << IOVP_SHIFT)
 			| dma_offset;
 		n_mappings++;
 	}
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index d06627c..7d58bd2 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -404,7 +404,7 @@ sba_search_bitmap(struct ioc *ioc, unsigned long bits_wanted)
  * resource bit map.
  */
 static int
-sba_alloc_range(struct ioc *ioc, size_t size)
+sba_alloc_range(struct ioc *ioc, struct device *dev, size_t size)
 {
 	unsigned int pages_needed = size >> IOVP_SHIFT;
 #ifdef SBA_COLLECT_STATS
@@ -710,7 +710,7 @@ sba_map_single(struct device *dev, void *addr, size_t size,
 	ioc->msingle_calls++;
 	ioc->msingle_pages += size >> IOVP_SHIFT;
 #endif
-	pide = sba_alloc_range(ioc, size);
+	pide = sba_alloc_range(ioc, dev, size);
 	iovp = (dma_addr_t) pide << IOVP_SHIFT;
 
 	DBG_RUN("%s() 0x%p -> 0x%lx\n",
-- 
1.5.3.7

