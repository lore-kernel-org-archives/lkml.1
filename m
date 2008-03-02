Return-Path: <linux-kernel-owner+w=401wt.eu-S1751946AbYCBGVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbYCBGVQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 01:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYCBGUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 01:20:18 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:34155 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbYCBGUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 01:20:15 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-parisc@vger.kernel.org, tomof@acm.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 3/3] parisc: make the IOMMUs respect the segment boundary limits
Date: Sun,  2 Mar 2008 15:10:28 +0900
Message-Id: <1204438228-4564-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1204438228-4564-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1204438228-4564-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1204438228-4564-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1204438228-4564-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes PARISC's two IOMMU implementations not allocate a
memory area spanning LLD's segment boundary.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/parisc/Kconfig     |    5 ++++
 drivers/parisc/ccio-dma.c  |   13 ++++++++++-
 drivers/parisc/sba_iommu.c |   48 +++++++++++++++++++++++++++++++++----------
 3 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/drivers/parisc/Kconfig b/drivers/parisc/Kconfig
index 1d3b84b..553a990 100644
--- a/drivers/parisc/Kconfig
+++ b/drivers/parisc/Kconfig
@@ -103,6 +103,11 @@ config IOMMU_SBA
 	depends on PCI_LBA
 	default PCI_LBA
 
+config IOMMU_HELPER
+	bool
+	depends on IOMMU_SBA || IOMMU_CCIO
+	default y
+
 #config PCI_EPIC
 #	bool "EPIC/SAGA PCI support"
 #	depends on PCI
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 1695fac..2f3b364 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -43,6 +43,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/scatterlist.h>
+#include <linux/iommu-helper.h>
 
 #include <asm/byteorder.h>
 #include <asm/cache.h>		/* for L1_CACHE_BYTES */
@@ -302,9 +303,13 @@ static int ioc_count;
 */
 #define CCIO_SEARCH_LOOP(ioc, res_idx, mask, size)  \
        for(; res_ptr < res_end; ++res_ptr) { \
-               if(0 == (*res_ptr & mask)) { \
+               int ret;\
+               unsigned int idx;\
+               idx = (unsigned int)((unsigned long)res_ptr - (unsigned long)ioc->res_map); \
+		ret = iommu_is_span_boundary(idx << 3, pages_needed, 0, boundary_size);\
+               if((0 == (*res_ptr & mask)) && !ret) { \
                        *res_ptr |= mask; \
-                       res_idx = (unsigned int)((unsigned long)res_ptr - (unsigned long)ioc->res_map); \
+                       res_idx = idx;\
                        ioc->res_hint = res_idx + (size >> 3); \
                        goto resource_found; \
                } \
@@ -345,6 +350,7 @@ ccio_alloc_range(struct ioc *ioc, struct device *dev, size_t size)
 {
 	unsigned int pages_needed = size >> IOVP_SHIFT;
 	unsigned int res_idx;
+	unsigned long boundary_size;
 #ifdef CCIO_SEARCH_TIME
 	unsigned long cr_start = mfctl(16);
 #endif
@@ -360,6 +366,9 @@ ccio_alloc_range(struct ioc *ioc, struct device *dev, size_t size)
 	** ggg sacrifices another 710 to the computer gods.
 	*/
 
+	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1, 1 << IOVP_SHIFT);
+	boundary_size >>= IOVP_SHIFT;
+
 	if (pages_needed <= 8) {
 		/*
 		 * LAN traffic will not thrash the TLB IFF the same NIC
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index 7d58bd2..e834127 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -29,6 +29,7 @@
 #include <linux/string.h>
 #include <linux/pci.h>
 #include <linux/scatterlist.h>
+#include <linux/iommu-helper.h>
 
 #include <asm/byteorder.h>
 #include <asm/io.h>
@@ -313,6 +314,12 @@ sba_dump_sg( struct ioc *ioc, struct scatterlist *startsg, int nents)
 #define RESMAP_MASK(n)    (~0UL << (BITS_PER_LONG - (n)))
 #define RESMAP_IDX_MASK   (sizeof(unsigned long) - 1)
 
+unsigned long ptr_to_pide(struct ioc *ioc, unsigned long *res_ptr,
+			  unsigned int bitshiftcnt)
+{
+	return (((unsigned long)res_ptr - (unsigned long)ioc->res_map) << 3)
+		+ bitshiftcnt;
+}
 
 /**
  * sba_search_bitmap - find free space in IO PDIR resource bitmap
@@ -324,19 +331,36 @@ sba_dump_sg( struct ioc *ioc, struct scatterlist *startsg, int nents)
  * Cool perf optimization: search for log2(size) bits at a time.
  */
 static SBA_INLINE unsigned long
-sba_search_bitmap(struct ioc *ioc, unsigned long bits_wanted)
+sba_search_bitmap(struct ioc *ioc, struct device *dev,
+		  unsigned long bits_wanted)
 {
 	unsigned long *res_ptr = ioc->res_hint;
 	unsigned long *res_end = (unsigned long *) &(ioc->res_map[ioc->res_size]);
-	unsigned long pide = ~0UL;
+	unsigned long pide = ~0UL, tpide;
+	unsigned long boundary_size;
+	unsigned long shift;
+	int ret;
+
+	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1, 1 << IOVP_SHIFT);
+	boundary_size >>= IOVP_SHIFT;
+
+#if defined(ZX1_SUPPORT)
+	BUG_ON(ioc->ibase & ~IOVP_MASK);
+	shift = ioc->ibase >> IOVP_SHIFT;
+#else
+	shift = 0;
+#endif
 
 	if (bits_wanted > (BITS_PER_LONG/2)) {
 		/* Search word at a time - no mask needed */
 		for(; res_ptr < res_end; ++res_ptr) {
-			if (*res_ptr == 0) {
+			tpide = ptr_to_pide(ioc, res_ptr, 0);
+			ret = iommu_is_span_boundary(tpide, bits_wanted,
+						     shift,
+						     boundary_size);
+			if ((*res_ptr == 0) && !ret) {
 				*res_ptr = RESMAP_MASK(bits_wanted);
-				pide = ((unsigned long)res_ptr - (unsigned long)ioc->res_map);
-				pide <<= 3;	/* convert to bit address */
+				pide = tpide;
 				break;
 			}
 		}
@@ -365,11 +389,13 @@ sba_search_bitmap(struct ioc *ioc, unsigned long bits_wanted)
 		{ 
 			DBG_RES("    %p %lx %lx\n", res_ptr, mask, *res_ptr);
 			WARN_ON(mask == 0);
-			if(((*res_ptr) & mask) == 0) {
+			tpide = ptr_to_pide(ioc, res_ptr, bitshiftcnt);
+			ret = iommu_is_span_boundary(tpide, bits_wanted,
+						     shift,
+						     boundary_size);
+			if ((((*res_ptr) & mask) == 0) && !ret) {
 				*res_ptr |= mask;     /* mark resources busy! */
-				pide = ((unsigned long)res_ptr - (unsigned long)ioc->res_map);
-				pide <<= 3;	/* convert to bit address */
-				pide += bitshiftcnt;
+				pide = tpide;
 				break;
 			}
 			mask >>= o;
@@ -412,9 +438,9 @@ sba_alloc_range(struct ioc *ioc, struct device *dev, size_t size)
 #endif
 	unsigned long pide;
 
-	pide = sba_search_bitmap(ioc, pages_needed);
+	pide = sba_search_bitmap(ioc, dev, pages_needed);
 	if (pide >= (ioc->res_size << 3)) {
-		pide = sba_search_bitmap(ioc, pages_needed);
+		pide = sba_search_bitmap(ioc, dev, pages_needed);
 		if (pide >= (ioc->res_size << 3))
 			panic("%s: I/O MMU @ %p is out of mapping resources\n",
 			      __FILE__, ioc->ioc_hpa);
-- 
1.5.3.7

