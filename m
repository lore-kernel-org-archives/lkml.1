Return-Path: <linux-kernel-owner+w=401wt.eu-S1758418AbZFAPgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbZFAPgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 11:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbZFAPdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 11:33:40 -0400
Received: from smtp.citrix.com ([66.165.176.89]:62354 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548AbZFAPdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 11:33:39 -0400
X-IronPort-AV: E=Sophos;i="4.41,284,1241409600"; 
   d="scan'208";a="4484699"
From: Ian Campbell <ian.campbell@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Ian Campbell <ian.campbell@citrix.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Olaf Kirch <okir@suse.de>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 11/11] swiotlb: allow initialisation with pre-allocated bounce-buffer
Date: Mon, 1 Jun 2009 16:33:03 +0100
Message-ID: <1243870383-12954-12-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
References: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the generic swiotlb code to be used by users with unusual
requirements for the buffer allocation by allowing them to provide
their own swiotlb buffer.

Also:
- swiotlb_init_with_default_size is unused so collapse into
  swiotlb_init.
- move declarations of swiotlb_late_init_with_default_size out of *.c
  into linux/swiotlb.h where they belong
- Make io_tlb_nslabs and io_tlb_overflow non-static since callers of the
  new interface will want to access them.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Olaf Kirch <okir@suse.de>
Cc: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/ia64/hp/common/hwsw_iommu.c |    3 --
 arch/ia64/hp/common/sba_iommu.c  |    2 -
 include/linux/swiotlb.h          |   14 ++++++++
 lib/swiotlb.c                    |   64 +++++++++++++++++++++----------------
 4 files changed, 50 insertions(+), 33 deletions(-)

diff --git a/arch/ia64/hp/common/hwsw_iommu.c b/arch/ia64/hp/common/hwsw_iommu.c
index e4a80d8..d557779 100644
--- a/arch/ia64/hp/common/hwsw_iommu.c
+++ b/arch/ia64/hp/common/hwsw_iommu.c
@@ -19,9 +19,6 @@
 
 extern struct dma_map_ops sba_dma_ops, swiotlb_dma_ops;
 
-/* swiotlb declarations & definitions: */
-extern int swiotlb_late_init_with_default_size (size_t size);
-
 /*
  * Note: we need to make the determination of whether or not to use
  * the sw I/O TLB based purely on the device structure.  Anything else
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 56ceb68..eeb5b49 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -46,8 +46,6 @@
 
 #include <asm/acpi-ext.h>
 
-extern int swiotlb_late_init_with_default_size (size_t size);
-
 #define PFX "IOC: "
 
 /*
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index b5b2245..7c6f4c1 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -21,8 +21,22 @@ struct scatterlist;
  */
 #define IO_TLB_SHIFT 11
 
+/*
+ * number of IO TLB slabs.
+ */
+extern unsigned long io_tlb_nslabs;
+
+/*
+ * size of emergency overflow buffer.
+ */
+extern unsigned long io_tlb_overflow;
+
 extern void
 swiotlb_init(void);
+extern void
+swiotlb_init_with_buffer(unsigned long bytes, void *buffer, void *emergency);
+extern int
+swiotlb_late_init_with_default_size(size_t size);
 
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 6076bb7..2449669 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -70,14 +70,14 @@ static char *io_tlb_start, *io_tlb_end;
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
 
-void *io_tlb_overflow_buffer;
+static void *io_tlb_overflow_buffer;
 
 /*
  * This is a free list describing the number of free entries available from
@@ -148,14 +148,40 @@ static void swiotlb_print_info(unsigned long bytes)
 	       (unsigned long long)pend);
 }
 
+void __init
+swiotlb_init_with_buffer(unsigned long bytes, void *buffer, void *overflow)
+{
+	unsigned long i;
+
+	io_tlb_start = buffer;
+	io_tlb_end = io_tlb_start + bytes;
+
+	io_tlb_overflow_buffer = overflow;
+
+	/*
+	 * Allocate and initialize the free list array.  This array is used
+	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
+	 * between io_tlb_start and io_tlb_end.
+	 */
+	io_tlb_list = alloc_bootmem(io_tlb_nslabs * sizeof(int));
+	for (i = 0; i < io_tlb_nslabs; i++)
+		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
+	io_tlb_index = 0;
+	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(phys_addr_t));
+
+	swiotlb_print_info(bytes);
+}
+
 /*
  * Statically reserve bounce buffer space and initialize bounce buffer data
  * structures for the software IO TLB used to implement the DMA API.
  */
 void __init
-swiotlb_init_with_default_size(size_t default_size)
+swiotlb_init(void)
 {
-	unsigned long i, bytes;
+	unsigned long bytes;
+	void *buffer, *overflow;
+	size_t default_size = 64 * (1<<20);	/* default to 64MB */
 
 	if (!io_tlb_nslabs) {
 		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
@@ -167,36 +193,18 @@ swiotlb_init_with_default_size(size_t default_size)
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	io_tlb_start = alloc_bootmem_low_pages(bytes);
-	if (!io_tlb_start)
+	buffer = alloc_bootmem_low_pages(bytes);
+	if (!buffer)
 		panic("Cannot allocate SWIOTLB buffer");
-	io_tlb_end = io_tlb_start + bytes;
-
-	/*
-	 * Allocate and initialize the free list array.  This array is used
-	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
-	 * between io_tlb_start and io_tlb_end.
-	 */
-	io_tlb_list = alloc_bootmem(io_tlb_nslabs * sizeof(int));
-	for (i = 0; i < io_tlb_nslabs; i++)
- 		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
-	io_tlb_index = 0;
-	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(phys_addr_t));
 
 	/*
 	 * Get the overflow emergency buffer
 	 */
-	io_tlb_overflow_buffer = alloc_bootmem_low(io_tlb_overflow);
-	if (!io_tlb_overflow_buffer)
+	overflow = alloc_bootmem_low(io_tlb_overflow);
+	if (!overflow)
 		panic("Cannot allocate SWIOTLB overflow buffer!\n");
 
-	swiotlb_print_info(bytes);
-}
-
-void __init
-swiotlb_init(void)
-{
-	swiotlb_init_with_default_size(64 * (1<<20));	/* default to 64MB */
+	swiotlb_init_with_buffer(bytes, buffer, overflow);
 }
 
 /*
-- 
1.5.6.5

