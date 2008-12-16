Return-Path: <linux-kernel-owner+w=401wt.eu-S1759823AbYLPUXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823AbYLPUXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbYLPUSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:18:55 -0500
Received: from gw.goop.org ([64.81.55.164]:45929 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913AbYLPUSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:18:51 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 09 of 14] swiotlb: support bouncing of HighMem pages
X-Mercurial-Node: bd02109486de2ce1622ea007353a4e42039052cf
Message-Id: <bd02109486de2ce1622e.1229458653@abulafia.goop.org>
In-Reply-To: <patchbomb.1229458644@abulafia.goop.org>
Date: Tue, 16 Dec 2008 12:17:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jan Beulich <jbeulich@novell.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This requires us to treat DMA regions in terms of page+offset rather
than virtual addressing since a HighMem page may not have a mapping.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 lib/swiotlb.c |  120 +++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 88 insertions(+), 32 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -26,6 +26,7 @@
 #include <linux/swiotlb.h>
 #include <linux/types.h>
 #include <linux/ctype.h>
+#include <linux/highmem.h>
 
 #include <asm/io.h>
 #include <asm/dma.h>
@@ -38,9 +39,6 @@
 #define OFFSET(val,align) ((unsigned long)	\
 	                   ( (val) & ( (align) - 1)))
 
-#define SG_ENT_VIRT_ADDRESS(sg)	(sg_virt((sg)))
-#define SG_ENT_PHYS_ADDRESS(sg)	virt_to_bus(SG_ENT_VIRT_ADDRESS(sg))
-
 #define SLABS_PER_PAGE (1 << (PAGE_SHIFT - IO_TLB_SHIFT))
 
 /*
@@ -91,7 +89,10 @@
  * We need to save away the original address corresponding to a mapped entry
  * for the sync operations.
  */
-static unsigned char **io_tlb_orig_addr;
+static struct swiotlb_phys_addr {
+	struct page *page;
+	unsigned int offset;
+} *io_tlb_orig_addr;
 
 /*
  * Protect the above data structures in the map and unmap calls
@@ -150,6 +151,11 @@
 	return 0;
 }
 
+static dma_addr_t swiotlb_sg_to_bus(struct scatterlist *sg)
+{
+	return swiotlb_phys_to_bus(page_to_phys(sg_page(sg)) + sg->offset);
+}
+
 /*
  * Statically reserve bounce buffer space and initialize bounce buffer data
  * structures for the software IO TLB used to implement the DMA API.
@@ -183,7 +189,7 @@
 	for (i = 0; i < io_tlb_nslabs; i++)
  		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
-	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(char *));
+	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(struct swiotlb_phys_addr));
 
 	/*
 	 * Get the overflow emergency buffer
@@ -258,12 +264,12 @@
  		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
 
-	io_tlb_orig_addr = (unsigned char **)__get_free_pages(GFP_KERNEL,
-	                           get_order(io_tlb_nslabs * sizeof(char *)));
+	io_tlb_orig_addr = (struct swiotlb_phys_addr *)__get_free_pages(GFP_KERNEL,
+	                           get_order(io_tlb_nslabs * sizeof(struct swiotlb_phys_addr)));
 	if (!io_tlb_orig_addr)
 		goto cleanup3;
 
-	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(char *));
+	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(struct swiotlb_phys_addr));
 
 	/*
 	 * Get the overflow emergency buffer
@@ -312,20 +318,59 @@
 	return addr >= io_tlb_start && addr < io_tlb_end;
 }
 
+static struct swiotlb_phys_addr swiotlb_bus_to_phys_addr(char *dma_addr)
+{
+	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	struct swiotlb_phys_addr buffer = io_tlb_orig_addr[index];
+	buffer.offset += (long)dma_addr & ((1 << IO_TLB_SHIFT) - 1);
+	buffer.page += buffer.offset >> PAGE_SHIFT;
+	buffer.offset &= PAGE_SIZE - 1;
+	return buffer;
+}
+
 static void
-__sync_single(char *buffer, char *dma_addr, size_t size, int dir)
+__sync_single(struct swiotlb_phys_addr buffer, char *dma_addr, size_t size, int dir)
 {
-	if (dir == DMA_TO_DEVICE)
-		memcpy(dma_addr, buffer, size);
-	else
-		memcpy(buffer, dma_addr, size);
+	if (PageHighMem(buffer.page)) {
+		size_t len, bytes;
+		char *dev, *host, *kmp;
+
+		len = size;
+		while (len != 0) {
+			unsigned long flags;
+
+			bytes = len;
+			if ((bytes + buffer.offset) > PAGE_SIZE)
+				bytes = PAGE_SIZE - buffer.offset;
+			local_irq_save(flags); /* protects KM_BOUNCE_READ */
+			kmp  = kmap_atomic(buffer.page, KM_BOUNCE_READ);
+			dev  = dma_addr + size - len;
+			host = kmp + buffer.offset;
+			if (dir == DMA_FROM_DEVICE)
+				memcpy(host, dev, bytes);
+			else
+				memcpy(dev, host, bytes);
+			kunmap_atomic(kmp, KM_BOUNCE_READ);
+			local_irq_restore(flags);
+			len -= bytes;
+			buffer.page++;
+			buffer.offset = 0;
+		}
+	} else {
+		void *v = page_address(buffer.page) + buffer.offset;
+
+		if (dir == DMA_TO_DEVICE)
+			memcpy(dma_addr, v, size);
+		else
+			memcpy(v, dma_addr, size);
+	}
 }
 
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
  */
 static void *
-map_single(struct device *hwdev, char *buffer, size_t size, int dir)
+map_single(struct device *hwdev, struct swiotlb_phys_addr buffer, size_t size, int dir)
 {
 	unsigned long flags;
 	char *dma_addr;
@@ -335,6 +380,7 @@
 	unsigned long mask;
 	unsigned long offset_slots;
 	unsigned long max_slots;
+	struct swiotlb_phys_addr slot_buf;
 
 	mask = dma_get_seg_boundary(hwdev);
 	start_dma_addr = swiotlb_virt_to_bus(io_tlb_start) & mask;
@@ -419,8 +465,13 @@
 	 * This is needed when we sync the memory.  Then we sync the buffer if
 	 * needed.
 	 */
-	for (i = 0; i < nslots; i++)
-		io_tlb_orig_addr[index+i] = buffer + (i << IO_TLB_SHIFT);
+	slot_buf = buffer;
+	for (i = 0; i < nslots; i++) {
+		slot_buf.page += slot_buf.offset >> PAGE_SHIFT;
+		slot_buf.offset &= PAGE_SIZE - 1;
+		io_tlb_orig_addr[index+i] = slot_buf;
+		slot_buf.offset += 1 << IO_TLB_SHIFT;
+	}
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
 		__sync_single(buffer, dma_addr, size, DMA_TO_DEVICE);
 
@@ -436,12 +487,12 @@
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
-	char *buffer = io_tlb_orig_addr[index];
+	struct swiotlb_phys_addr buffer = swiotlb_bus_to_phys_addr(dma_addr);
 
 	/*
 	 * First, sync the memory before unmapping the entry
 	 */
-	if (buffer && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
+	if ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL))
 		/*
 		 * bounce... copy the data back into the original buffer * and
 		 * delete the bounce buffer.
@@ -478,10 +529,7 @@
 sync_single(struct device *hwdev, char *dma_addr, size_t size,
 	    int dir, int target)
 {
-	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
-	char *buffer = io_tlb_orig_addr[index];
-
-	buffer += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));
+	struct swiotlb_phys_addr buffer = swiotlb_bus_to_phys_addr(dma_addr);
 
 	switch (target) {
 	case SYNC_FOR_CPU:
@@ -525,7 +573,10 @@
 		 * swiotlb_map_single(), which will grab memory from
 		 * the lowest available address range.
 		 */
-		ret = map_single(hwdev, NULL, size, DMA_FROM_DEVICE);
+		struct swiotlb_phys_addr buffer;
+		buffer.page = virt_to_page(NULL);
+		buffer.offset = 0;
+		ret = map_single(hwdev, buffer, size, DMA_FROM_DEVICE);
 		if (!ret)
 			return NULL;
 	}
@@ -593,6 +644,7 @@
 {
 	dma_addr_t dev_addr = swiotlb_virt_to_bus(ptr);
 	void *map;
+	struct swiotlb_phys_addr buffer;
 
 	BUG_ON(dir == DMA_NONE);
 	/*
@@ -607,7 +659,9 @@
 	/*
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
-	map = map_single(hwdev, ptr, size, dir);
+	buffer.page   = virt_to_page(ptr);
+	buffer.offset = (unsigned long)ptr & ~PAGE_MASK;
+	map = map_single(hwdev, buffer, size, dir);
 	if (!map) {
 		swiotlb_full(hwdev, size, dir, 1);
 		map = io_tlb_overflow_buffer;
@@ -752,18 +806,20 @@
 		     int dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
-	void *addr;
+	struct swiotlb_phys_addr buffer;
 	dma_addr_t dev_addr;
 	int i;
 
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		addr = SG_ENT_VIRT_ADDRESS(sg);
-		dev_addr = swiotlb_virt_to_bus(addr);
+		dev_addr = swiotlb_sg_to_bus(sg);
 		if (range_needs_mapping(sg_virt(sg), sg->length) ||
 		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
-			void *map = map_single(hwdev, addr, sg->length, dir);
+			void *map;
+			buffer.page   = sg_page(sg);
+			buffer.offset = sg->offset;
+			map = map_single(hwdev, buffer, sg->length, dir);
 			if (!map) {
 				/* Don't panic here, we expect map_sg users
 				   to do proper error handling. */
@@ -803,11 +859,11 @@
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
+		if (sg->dma_address != swiotlb_sg_to_bus(sg))
 			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				     sg->dma_length, dir);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
+			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
 	}
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
@@ -836,11 +892,11 @@
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
+		if (sg->dma_address != swiotlb_sg_to_bus(sg))
 			sync_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
+			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
 	}
 }
 


