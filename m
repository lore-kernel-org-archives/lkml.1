Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbYLVSbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbYLVSbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbYLVS26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:28:58 -0500
Received: from gw.goop.org ([64.81.55.164]:44724 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753036AbYLVS2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:28:55 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 6 of 9] swiotlb: Store phys address in io_tlb_orig_addr array
X-Mercurial-Node: a3a9f1ed9597dc2093bf2ad1dbe6ce91cb25a70b
Message-Id: <a3a9f1ed9597dc2093bf.1229970368@abulafia.goop.org>
In-Reply-To: <patchbomb.1229970362@abulafia.goop.org>
Date: Mon, 22 Dec 2008 10:26:08 -0800
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

From: Becky Bruce <beckyb@kernel.crashing.org>

When we enable swiotlb for platforms that support HIGHMEM, we
can no longer store the virtual address of the original dma
buffer, because that buffer might not have a permament mapping.
Change the iotlb code to instead store the physical address of
the original buffer.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 lib/swiotlb.c |   47 ++++++++++++++++++++++++-----------------------
 1 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -90,7 +90,7 @@
  * We need to save away the original address corresponding to a mapped entry
  * for the sync operations.
  */
-static unsigned char **io_tlb_orig_addr;
+static phys_addr_t *io_tlb_orig_addr;
 
 /*
  * Protect the above data structures in the map and unmap calls
@@ -197,7 +197,7 @@
 	for (i = 0; i < io_tlb_nslabs; i++)
  		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
-	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(char *));
+	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(phys_addr_t));
 
 	/*
 	 * Get the overflow emergency buffer
@@ -271,12 +271,14 @@
  		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
 
-	io_tlb_orig_addr = (unsigned char **)__get_free_pages(GFP_KERNEL,
-	                           get_order(io_tlb_nslabs * sizeof(char *)));
+	io_tlb_orig_addr = (phys_addr_t *)
+		__get_free_pages(GFP_KERNEL,
+				 get_order(io_tlb_nslabs *
+					   sizeof(phys_addr_t)));
 	if (!io_tlb_orig_addr)
 		goto cleanup3;
 
-	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(char *));
+	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(phys_addr_t));
 
 	/*
 	 * Get the overflow emergency buffer
@@ -291,8 +293,8 @@
 	return 0;
 
 cleanup4:
-	free_pages((unsigned long)io_tlb_orig_addr, get_order(io_tlb_nslabs *
-	                                                      sizeof(char *)));
+	free_pages((unsigned long)io_tlb_orig_addr,
+		   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
 	io_tlb_orig_addr = NULL;
 cleanup3:
 	free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
@@ -327,7 +329,7 @@
  * Allocates bounce buffer and returns its kernel virtual address.
  */
 static void *
-map_single(struct device *hwdev, char *buffer, size_t size, int dir)
+map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
 {
 	unsigned long flags;
 	char *dma_addr;
@@ -422,9 +424,9 @@
 	 * needed.
 	 */
 	for (i = 0; i < nslots; i++)
-		io_tlb_orig_addr[index+i] = buffer + (i << IO_TLB_SHIFT);
+		io_tlb_orig_addr[index+i] = phys + (i << IO_TLB_SHIFT);
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
-		memcpy(dma_addr, buffer, size);
+		memcpy(dma_addr, phys_to_virt(phys), size);
 
 	return dma_addr;
 }
@@ -438,17 +440,17 @@
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
-	char *buffer = io_tlb_orig_addr[index];
+	phys_addr_t phys = io_tlb_orig_addr[index];
 
 	/*
 	 * First, sync the memory before unmapping the entry
 	 */
-	if (buffer && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
+	if (phys && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
 		/*
 		 * bounce... copy the data back into the original buffer * and
 		 * delete the bounce buffer.
 		 */
-		memcpy(buffer, dma_addr, size);
+		memcpy(phys_to_virt(phys), dma_addr, size);
 
 	/*
 	 * Return the buffer to the free list by setting the corresponding
@@ -481,20 +483,20 @@
 	    int dir, int target)
 {
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
-	char *buffer = io_tlb_orig_addr[index];
+	phys_addr_t phys = io_tlb_orig_addr[index];
 
-	buffer += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));
+	phys += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));
 
 	switch (target) {
 	case SYNC_FOR_CPU:
 		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL))
-			memcpy(buffer, dma_addr, size);
+			memcpy(phys_to_virt(phys), dma_addr, size);
 		else
 			BUG_ON(dir != DMA_TO_DEVICE);
 		break;
 	case SYNC_FOR_DEVICE:
 		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
-			memcpy(dma_addr, buffer, size);
+			memcpy(dma_addr, phys_to_virt(phys), size);
 		else
 			BUG_ON(dir != DMA_FROM_DEVICE);
 		break;
@@ -533,7 +535,7 @@
 		 * swiotlb_map_single(), which will grab memory from
 		 * the lowest available address range.
 		 */
-		ret = map_single(hwdev, NULL, size, DMA_FROM_DEVICE);
+		ret = map_single(hwdev, 0, size, DMA_FROM_DEVICE);
 		if (!ret)
 			return NULL;
 	}
@@ -615,7 +617,7 @@
 	/*
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
-	map = map_single(hwdev, ptr, size, dir);
+	map = map_single(hwdev, virt_to_phys(ptr), size, dir);
 	if (!map) {
 		swiotlb_full(hwdev, size, dir, 1);
 		map = io_tlb_overflow_buffer;
@@ -760,18 +762,18 @@
 		     int dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
-	void *addr;
-	dma_addr_t dev_addr;
 	int i;
 
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		addr = sg_virt(sg);
-		dev_addr = swiotlb_virt_to_bus(hwdev, addr);
+		void *addr = sg_virt(sg);
+		dma_addr_t dev_addr = swiotlb_virt_to_bus(hwdev, addr);
+
 		if (range_needs_mapping(addr, sg->length) ||
 		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
-			void *map = map_single(hwdev, addr, sg->length, dir);
+			void *map = map_single(hwdev, sg_phys(sg),
+					       sg->length, dir);
 			if (!map) {
 				/* Don't panic here, we expect map_sg users
 				   to do proper error handling. */


