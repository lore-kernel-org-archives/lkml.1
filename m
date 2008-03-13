Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbYCMDum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbYCMDum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 23:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYCMDuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 23:50:04 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:40110 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbYCMDuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 23:50:02 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org, linux-sparc@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: [PATCH -mm 1/2] SPARC64: add the segment boundary checking to IOMMUs while merging SG entries
Date: Thu, 13 Mar 2008 12:47:06 +0900
Message-Id: <1205380027-28230-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some IOMMUs allocate memory areas spanning LLD's segment boundary
limit. It forces low level drivers to have a workaround to adjust
scatter lists that the IOMMU builds. We are in the process of making
all the IOMMUs respect the segment boundary limits to remove such work
around in LLDs.

SPARC64 IOMMUs were rewritten to use the IOMMU helper functions and
the commit 89c94f2f70d093f59b55d3ea8042d13889169346 made the IOMMUs
not allocate memory areas spanning the segment boundary limit.

However, SPARC64 IOMMUs allocate memory areas first then try to merge
them (while some IOMMUs walk through all the sg entries to see how
they can be merged first and allocate memory areas). So SPARC64 IOMMUs
also need the boundary limit checking when they try to merge sg
entries.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>
---
 arch/sparc64/kernel/iommu.c        |   12 ++++++++++--
 arch/sparc64/kernel/iommu_common.h |   13 +++++++++++++
 arch/sparc64/kernel/pci_sun4v.c    |   12 ++++++++++--
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/arch/sparc64/kernel/iommu.c b/arch/sparc64/kernel/iommu.c
index fbaab34..e009a14 100644
--- a/arch/sparc64/kernel/iommu.c
+++ b/arch/sparc64/kernel/iommu.c
@@ -516,9 +516,11 @@ static int dma_4u_map_sg(struct device *dev, struct scatterlist *sglist,
 	unsigned long flags, handle, prot, ctx;
 	dma_addr_t dma_next = 0, dma_addr;
 	unsigned int max_seg_size;
+	unsigned long seg_boundary_size;
 	int outcount, incount, i;
 	struct strbuf *strbuf;
 	struct iommu *iommu;
+	unsigned long base_shift;
 
 	BUG_ON(direction == DMA_NONE);
 
@@ -549,8 +551,11 @@ static int dma_4u_map_sg(struct device *dev, struct scatterlist *sglist,
 	outs->dma_length = 0;
 
 	max_seg_size = dma_get_max_seg_size(dev);
+	seg_boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
+				  IO_PAGE_SIZE) >> IO_PAGE_SHIFT;
+	base_shift = iommu->page_table_map_base >> IO_PAGE_SHIFT;
 	for_each_sg(sglist, s, nelems, i) {
-		unsigned long paddr, npages, entry, slen;
+		unsigned long paddr, npages, entry, out_entry = 0, slen;
 		iopte_t *base;
 
 		slen = s->length;
@@ -593,7 +598,9 @@ static int dma_4u_map_sg(struct device *dev, struct scatterlist *sglist,
 			 * - allocated dma_addr isn't contiguous to previous allocation
 			 */
 			if ((dma_addr != dma_next) ||
-			    (outs->dma_length + s->length > max_seg_size)) {
+			    (outs->dma_length + s->length > max_seg_size) ||
+			    (is_span_boundary(out_entry, base_shift,
+					      seg_boundary_size, outs, s))) {
 				/* Can't merge: create a new segment */
 				segstart = s;
 				outcount++;
@@ -607,6 +614,7 @@ static int dma_4u_map_sg(struct device *dev, struct scatterlist *sglist,
 			/* This is a new segment, fill entries */
 			outs->dma_address = dma_addr;
 			outs->dma_length = slen;
+			out_entry = entry;
 		}
 
 		/* Calculate next page pointer for contiguous check */
diff --git a/arch/sparc64/kernel/iommu_common.h b/arch/sparc64/kernel/iommu_common.h
index 0713bd5..87ace49 100644
--- a/arch/sparc64/kernel/iommu_common.h
+++ b/arch/sparc64/kernel/iommu_common.h
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
 #include <linux/device.h>
+#include <linux/iommu-helper.h>
 
 #include <asm/iommu.h>
 #include <asm/scatterlist.h>
@@ -58,6 +59,18 @@ static inline unsigned long calc_npages(struct scatterlist *sglist, int nelems)
 	return npages;
 }
 
+static inline int is_span_boundary(unsigned long entry,
+				   unsigned long shift,
+				   unsigned long boundary_size,
+				   struct scatterlist *outs,
+				   struct scatterlist *sg)
+{
+	unsigned long paddr = SG_ENT_PHYS_ADDRESS(outs);
+	int nr = iommu_num_pages(paddr, outs->dma_length + sg->length);
+
+	return iommu_is_span_boundary(entry, nr, shift, boundary_size);
+}
+
 extern unsigned long iommu_range_alloc(struct device *dev,
 				       struct iommu *iommu,
 				       unsigned long npages,
diff --git a/arch/sparc64/kernel/pci_sun4v.c b/arch/sparc64/kernel/pci_sun4v.c
index ddca6c6..0183970 100644
--- a/arch/sparc64/kernel/pci_sun4v.c
+++ b/arch/sparc64/kernel/pci_sun4v.c
@@ -335,8 +335,10 @@ static int dma_4v_map_sg(struct device *dev, struct scatterlist *sglist,
 	unsigned long flags, handle, prot;
 	dma_addr_t dma_next = 0, dma_addr;
 	unsigned int max_seg_size;
+	unsigned long seg_boundary_size;
 	int outcount, incount, i;
 	struct iommu *iommu;
+	unsigned long base_shift;
 	long err;
 
 	BUG_ON(direction == DMA_NONE);
@@ -362,8 +364,11 @@ static int dma_4v_map_sg(struct device *dev, struct scatterlist *sglist,
 	iommu_batch_start(dev, prot, ~0UL);
 
 	max_seg_size = dma_get_max_seg_size(dev);
+	seg_boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
+				  IO_PAGE_SIZE) >> IO_PAGE_SHIFT;
+	base_shift = iommu->page_table_map_base >> IO_PAGE_SHIFT;
 	for_each_sg(sglist, s, nelems, i) {
-		unsigned long paddr, npages, entry, slen;
+		unsigned long paddr, npages, entry, out_entry = 0, slen;
 
 		slen = s->length;
 		/* Sanity check */
@@ -406,7 +411,9 @@ static int dma_4v_map_sg(struct device *dev, struct scatterlist *sglist,
 			 * - allocated dma_addr isn't contiguous to previous allocation
 			 */
 			if ((dma_addr != dma_next) ||
-			    (outs->dma_length + s->length > max_seg_size)) {
+			    (outs->dma_length + s->length > max_seg_size) ||
+			    (is_span_boundary(out_entry, base_shift,
+					      seg_boundary_size, outs, s))) {
 				/* Can't merge: create a new segment */
 				segstart = s;
 				outcount++;
@@ -420,6 +427,7 @@ static int dma_4v_map_sg(struct device *dev, struct scatterlist *sglist,
 			/* This is a new segment, fill entries */
 			outs->dma_address = dma_addr;
 			outs->dma_length = slen;
+			out_entry = entry;
 		}
 
 		/* Calculate next page pointer for contiguous check */
-- 
1.5.3.6

