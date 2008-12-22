Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYLVSaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYLVSaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYLVS2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:28:55 -0500
Received: from gw.goop.org ([64.81.55.164]:44701 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751842AbYLVS2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:28:51 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 9] revert "swiotlb: support bouncing of HighMem pages."
X-Mercurial-Node: 8e1a2f49f27b521a46dc948ee7db59979b33bae6
Message-Id: <8e1a2f49f27b521a46dc.1229970363@abulafia.goop.org>
In-Reply-To: <patchbomb.1229970362@abulafia.goop.org>
Date: Mon, 22 Dec 2008 10:26:03 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Becky Bruce <beckyb@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git commit ef9b189352f2eb78f14e52996f4780a523b04a49

---
 lib/swiotlb.c |  122 +++++++++++++++------------------------------------------
 1 file changed, 33 insertions(+), 89 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -26,7 +26,6 @@
 #include <linux/swiotlb.h>
 #include <linux/types.h>
 #include <linux/ctype.h>
-#include <linux/highmem.h>
 
 #include <asm/io.h>
 #include <asm/dma.h>
@@ -39,6 +38,9 @@
 #define OFFSET(val,align) ((unsigned long)	\
 	                   ( (val) & ( (align) - 1)))
 
+#define SG_ENT_VIRT_ADDRESS(sg)	(sg_virt((sg)))
+#define SG_ENT_PHYS_ADDRESS(sg)	virt_to_bus(SG_ENT_VIRT_ADDRESS(sg))
+
 #define SLABS_PER_PAGE (1 << (PAGE_SHIFT - IO_TLB_SHIFT))
 
 /*
@@ -89,10 +91,7 @@
  * We need to save away the original address corresponding to a mapped entry
  * for the sync operations.
  */
-static struct swiotlb_phys_addr {
-	struct page *page;
-	unsigned int offset;
-} *io_tlb_orig_addr;
+static unsigned char **io_tlb_orig_addr;
 
 /*
  * Protect the above data structures in the map and unmap calls
@@ -151,11 +150,6 @@
 	return 0;
 }
 
-static dma_addr_t swiotlb_sg_to_bus(struct scatterlist *sg)
-{
-	return swiotlb_phys_to_bus(page_to_phys(sg_page(sg)) + sg->offset);
-}
-
 static void swiotlb_print_info(unsigned long bytes)
 {
 	phys_addr_t pstart, pend;
@@ -215,7 +209,7 @@
 	for (i = 0; i < io_tlb_nslabs; i++)
  		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
-	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(struct swiotlb_phys_addr));
+	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(char *));
 
 	/*
 	 * Get the overflow emergency buffer
@@ -289,12 +283,12 @@
  		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
 
-	io_tlb_orig_addr = (struct swiotlb_phys_addr *)__get_free_pages(GFP_KERNEL,
-	                           get_order(io_tlb_nslabs * sizeof(struct swiotlb_phys_addr)));
+	io_tlb_orig_addr = (unsigned char **)__get_free_pages(GFP_KERNEL,
+	                           get_order(io_tlb_nslabs * sizeof(char *)));
 	if (!io_tlb_orig_addr)
 		goto cleanup3;
 
-	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(struct swiotlb_phys_addr));
+	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(char *));
 
 	/*
 	 * Get the overflow emergency buffer
@@ -341,59 +335,20 @@
 	return addr >= io_tlb_start && addr < io_tlb_end;
 }
 
-static struct swiotlb_phys_addr swiotlb_bus_to_phys_addr(char *dma_addr)
+static void
+__sync_single(char *buffer, char *dma_addr, size_t size, int dir)
 {
-	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
-	struct swiotlb_phys_addr buffer = io_tlb_orig_addr[index];
-	buffer.offset += (long)dma_addr & ((1 << IO_TLB_SHIFT) - 1);
-	buffer.page += buffer.offset >> PAGE_SHIFT;
-	buffer.offset &= PAGE_SIZE - 1;
-	return buffer;
-}
-
-static void
-__sync_single(struct swiotlb_phys_addr buffer, char *dma_addr, size_t size, int dir)
-{
-	if (PageHighMem(buffer.page)) {
-		size_t len, bytes;
-		char *dev, *host, *kmp;
-
-		len = size;
-		while (len != 0) {
-			unsigned long flags;
-
-			bytes = len;
-			if ((bytes + buffer.offset) > PAGE_SIZE)
-				bytes = PAGE_SIZE - buffer.offset;
-			local_irq_save(flags); /* protects KM_BOUNCE_READ */
-			kmp  = kmap_atomic(buffer.page, KM_BOUNCE_READ);
-			dev  = dma_addr + size - len;
-			host = kmp + buffer.offset;
-			if (dir == DMA_FROM_DEVICE)
-				memcpy(host, dev, bytes);
-			else
-				memcpy(dev, host, bytes);
-			kunmap_atomic(kmp, KM_BOUNCE_READ);
-			local_irq_restore(flags);
-			len -= bytes;
-			buffer.page++;
-			buffer.offset = 0;
-		}
-	} else {
-		void *v = page_address(buffer.page) + buffer.offset;
-
-		if (dir == DMA_TO_DEVICE)
-			memcpy(dma_addr, v, size);
-		else
-			memcpy(v, dma_addr, size);
-	}
+	if (dir == DMA_TO_DEVICE)
+		memcpy(dma_addr, buffer, size);
+	else
+		memcpy(buffer, dma_addr, size);
 }
 
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
  */
 static void *
-map_single(struct device *hwdev, struct swiotlb_phys_addr buffer, size_t size, int dir)
+map_single(struct device *hwdev, char *buffer, size_t size, int dir)
 {
 	unsigned long flags;
 	char *dma_addr;
@@ -403,7 +358,6 @@
 	unsigned long mask;
 	unsigned long offset_slots;
 	unsigned long max_slots;
-	struct swiotlb_phys_addr slot_buf;
 
 	mask = dma_get_seg_boundary(hwdev);
 	start_dma_addr = swiotlb_virt_to_bus(io_tlb_start) & mask;
@@ -488,13 +442,8 @@
 	 * This is needed when we sync the memory.  Then we sync the buffer if
 	 * needed.
 	 */
-	slot_buf = buffer;
-	for (i = 0; i < nslots; i++) {
-		slot_buf.page += slot_buf.offset >> PAGE_SHIFT;
-		slot_buf.offset &= PAGE_SIZE - 1;
-		io_tlb_orig_addr[index+i] = slot_buf;
-		slot_buf.offset += 1 << IO_TLB_SHIFT;
-	}
+	for (i = 0; i < nslots; i++)
+		io_tlb_orig_addr[index+i] = buffer + (i << IO_TLB_SHIFT);
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
 		__sync_single(buffer, dma_addr, size, DMA_TO_DEVICE);
 
@@ -510,12 +459,12 @@
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
-	struct swiotlb_phys_addr buffer = swiotlb_bus_to_phys_addr(dma_addr);
+	char *buffer = io_tlb_orig_addr[index];
 
 	/*
 	 * First, sync the memory before unmapping the entry
 	 */
-	if ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL))
+	if (buffer && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
 		/*
 		 * bounce... copy the data back into the original buffer * and
 		 * delete the bounce buffer.
@@ -552,7 +501,10 @@
 sync_single(struct device *hwdev, char *dma_addr, size_t size,
 	    int dir, int target)
 {
-	struct swiotlb_phys_addr buffer = swiotlb_bus_to_phys_addr(dma_addr);
+	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	char *buffer = io_tlb_orig_addr[index];
+
+	buffer += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));
 
 	switch (target) {
 	case SYNC_FOR_CPU:
@@ -600,10 +552,7 @@
 		 * swiotlb_map_single(), which will grab memory from
 		 * the lowest available address range.
 		 */
-		struct swiotlb_phys_addr buffer;
-		buffer.page = virt_to_page(NULL);
-		buffer.offset = 0;
-		ret = map_single(hwdev, buffer, size, DMA_FROM_DEVICE);
+		ret = map_single(hwdev, NULL, size, DMA_FROM_DEVICE);
 		if (!ret)
 			return NULL;
 	}
@@ -671,7 +620,6 @@
 {
 	dma_addr_t dev_addr = swiotlb_virt_to_bus(ptr);
 	void *map;
-	struct swiotlb_phys_addr buffer;
 
 	BUG_ON(dir == DMA_NONE);
 	/*
@@ -686,9 +634,7 @@
 	/*
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
-	buffer.page   = virt_to_page(ptr);
-	buffer.offset = (unsigned long)ptr & ~PAGE_MASK;
-	map = map_single(hwdev, buffer, size, dir);
+	map = map_single(hwdev, ptr, size, dir);
 	if (!map) {
 		swiotlb_full(hwdev, size, dir, 1);
 		map = io_tlb_overflow_buffer;
@@ -833,20 +779,18 @@
 		     int dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
-	struct swiotlb_phys_addr buffer;
+	void *addr;
 	dma_addr_t dev_addr;
 	int i;
 
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		dev_addr = swiotlb_sg_to_bus(sg);
+		addr = SG_ENT_VIRT_ADDRESS(sg);
+		dev_addr = swiotlb_virt_to_bus(addr);
 		if (range_needs_mapping(sg_virt(sg), sg->length) ||
 		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
-			void *map;
-			buffer.page   = sg_page(sg);
-			buffer.offset = sg->offset;
-			map = map_single(hwdev, buffer, sg->length, dir);
+			void *map = map_single(hwdev, addr, sg->length, dir);
 			if (!map) {
 				/* Don't panic here, we expect map_sg users
 				   to do proper error handling. */
@@ -886,11 +830,11 @@
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != swiotlb_sg_to_bus(sg))
+		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
 			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				     sg->dma_length, dir);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
+			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
 	}
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
@@ -919,11 +863,11 @@
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != swiotlb_sg_to_bus(sg))
+		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
 			sync_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
+			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
 	}
 }
 


