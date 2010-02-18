Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692Ab0BRQy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:54:29 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:52558 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758521Ab0BRQyY (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 18 Feb 2010 11:54:24 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@ORACLE.COM>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       dwmw2@infradead.org, alex.williamson@hp.com
Cc: jeremy@goop.org, Ian.Campbell@eu.citrix.com,
       Konrad Rzeszutek Wilk <konrad.wilk@ORACLE.COM>
Subject: [PATCH 09/10] swiotlb: Make swiotlb bookkeeping functions visible in the header file.
Date: Thu, 18 Feb 2010 11:27:05 -0500
Message-Id: <1266510426-6815-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266510426-6815-9-git-send-email-konrad.wilk@oracle.com>
References: <1266510426-6815-1-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-2-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-3-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-4-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-5-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-6-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-7-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-8-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-9-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B7D6E9F.021E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We put the init, free, and functions dealing with the operations on the
SWIOTLB buffer at the top of the header. Also we export some of the variables
that are used by the dma_ops functions.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/swiotlb.h |   31 ++++++++++++++++++++++++++++++-
 lib/swiotlb.c           |   26 +++++++++-----------------
 2 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 84e7a53..af66473 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -30,8 +30,37 @@ static inline void swiotlb_free(void) { }
 #endif
 extern void swiotlb_print_info(void);
 
+/* Internal book-keeping functions. Must be linked against the library
+ * to take advantage of them.*/
+#ifdef CONFIG_SWIOTLB
+/*
+ * Enumeration for sync targets
+ */
+enum dma_sync_target {
+	SYNC_FOR_CPU = 0,
+	SYNC_FOR_DEVICE = 1,
+};
+extern char *io_tlb_start;
+extern char *io_tlb_end;
+extern unsigned long io_tlb_nslabs;
+extern void *io_tlb_overflow_buffer;
+extern unsigned long io_tlb_overflow;
+extern int is_swiotlb_buffer(phys_addr_t paddr);
+extern void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
+			   enum dma_data_direction dir);
+extern void *do_map_single(struct device *hwdev, phys_addr_t phys,
+			    unsigned long start_dma_addr, size_t size, int dir);
+
+extern void do_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
+			     int dir);
+
+extern void do_sync_single(struct device *hwdev, char *dma_addr, size_t size,
+			   int dir, int target);
+extern void swiotlb_full(struct device *dev, size_t size, int dir, int do_panic);
+extern void __init swiotlb_init_early(size_t default_size, int verbose);
+#endif
 
-/* IOMMU functions. */
+/* swiotlb.c: dma_ops functions. */
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 80a2306..674d025 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -48,14 +48,6 @@
  */
 #define IO_TLB_MIN_SLABS ((1<<20) >> IO_TLB_SHIFT)
 
-/*
- * Enumeration for sync targets
- */
-enum dma_sync_target {
-	SYNC_FOR_CPU = 0,
-	SYNC_FOR_DEVICE = 1,
-};
-
 int swiotlb_force;
 
 /*
@@ -63,18 +55,18 @@ int swiotlb_force;
  * do_sync_single_*, to see if the memory was in fact allocated by this
  * API.
  */
-static char *io_tlb_start, *io_tlb_end;
+char *io_tlb_start, *io_tlb_end;
 
 /*
  * The number of IO TLB blocks (in groups of 64) betweeen io_tlb_start and
  * io_tlb_end.  This is command line adjustable via setup_io_tlb_npages.
  */
-static unsigned long io_tlb_nslabs;
+unsigned long io_tlb_nslabs;
 
 /*
  * When the IOMMU overflows we return a fallback buffer. This sets the size.
  */
-static unsigned long io_tlb_overflow = 32*1024;
+unsigned long io_tlb_overflow = 32*1024;
 
 void *io_tlb_overflow_buffer;
 
@@ -340,7 +332,7 @@ void __init swiotlb_free(void)
 	}
 }
 
-static int is_swiotlb_buffer(phys_addr_t paddr)
+int is_swiotlb_buffer(phys_addr_t paddr)
 {
 	return paddr >= virt_to_phys(io_tlb_start) &&
 		paddr < virt_to_phys(io_tlb_end);
@@ -349,7 +341,7 @@ static int is_swiotlb_buffer(phys_addr_t paddr)
 /*
  * Bounce: copy the swiotlb buffer back to the original dma location
  */
-static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
+void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 			   enum dma_data_direction dir)
 {
 	unsigned long pfn = PFN_DOWN(phys);
@@ -390,7 +382,7 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
  */
-static void *
+void *
 do_map_single(struct device *hwdev, phys_addr_t phys,
 	       unsigned long start_dma_addr, size_t size, int dir)
 {
@@ -496,7 +488,7 @@ found:
 /*
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
-static void
+void
 do_unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 {
 	unsigned long flags;
@@ -537,7 +529,7 @@ do_unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
 }
 
-static void
+void
 do_sync_single(struct device *hwdev, char *dma_addr, size_t size,
 	    int dir, int target)
 {
@@ -632,7 +624,7 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 }
 EXPORT_SYMBOL(swiotlb_free_coherent);
 
-static void
+void
 swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
 {
 	/*
-- 
1.6.2.5

