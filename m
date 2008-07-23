Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbYGWXzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbYGWXzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 19:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYGWXz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:55:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbYGWXz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:55:27 -0400
Date: Wed, 23 Jul 2008 19:55:25 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, fujita.tomonori@lab.ntt.co.jp,
       joro@8bytes.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20080723235512.18162.67088.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: PCI: GART iommu alignment fixes [v3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_alloc_consistent/dma_alloc_coherent does not return size aligned
addresses.

>From Documentation/DMA-mapping.txt:

"pci_alloc_consistent returns two values: the virtual address which you
can use to access it from the CPU and dma_handle which you pass to the
card.

The cpu return address and the DMA bus master address are both
guaranteed to be aligned to the smallest PAGE_SIZE order which
is greater than or equal to the requested size.  This invariant
exists (for example) to guarantee that if you allocate a chunk
which is smaller than or equal to 64 kilobytes, the extent of the
buffer you receive will not cross a 64K boundary."

1.  Modify alloc_iommu to allow for an alignment mask
2.  Modify pci_gart_simple to return size-aligned values.
3.  Fix possible overflow in alloc_iommu's boundary_size calculation.
    (It is possible that alloc_iommu()'s boundary_size overflows as
     dma_get_seg_boundary can return 0xffffffff.  In that case, further usage of
     boundary_size triggers a BUG_ON() in the iommu code.)

End result: When allocating from IOMMU, pci_alloc_consistent/dma_alloc_coherent
will now return a size aligned value.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index faf3229..717ae64 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -83,7 +83,8 @@ AGPEXTERN __u32 *agp_gatt_table;
 static unsigned long next_bit;  /* protected by iommu_bitmap_lock */
 static int need_flush;		/* global flush state. set for each gart wrap */
 
-static unsigned long alloc_iommu(struct device *dev, int size)
+static unsigned long alloc_iommu(struct device *dev, int size,
+				 unsigned long mask)
 {
 	unsigned long offset, flags;
 	unsigned long boundary_size;
@@ -91,16 +92,17 @@ static unsigned long alloc_iommu(struct device *dev, int size)
 
 	base_index = ALIGN(iommu_bus_base & dma_get_seg_boundary(dev),
 			   PAGE_SIZE) >> PAGE_SHIFT;
-	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
+	boundary_size = ALIGN((unsigned long long)dma_get_seg_boundary(dev) + 1,
 			      PAGE_SIZE) >> PAGE_SHIFT;
 
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
 	offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, next_bit,
-				  size, base_index, boundary_size, 0);
+				  size, base_index, boundary_size, mask);
 	if (offset == -1) {
 		need_flush = 1;
 		offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, 0,
-					  size, base_index, boundary_size, 0);
+					  size, base_index, boundary_size,
+					  mask);
 	}
 	if (offset != -1) {
 		set_bit_string(iommu_gart_bitmap, offset, size);
@@ -240,10 +242,11 @@ nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
  * Caller needs to check if the iommu is needed and flush.
  */
 static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
-				size_t size, int dir)
+				size_t size, int dir, u64 align_mask)
 {
 	unsigned long npages = to_pages(phys_mem, size);
-	unsigned long iommu_page = alloc_iommu(dev, npages);
+	unsigned long palign_mask = align_mask >> PAGE_SHIFT;
+	unsigned long iommu_page = alloc_iommu(dev, npages, palign_mask);
 	int i;
 
 	if (iommu_page == -1) {
@@ -266,7 +269,8 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 static dma_addr_t
 gart_map_simple(struct device *dev, char *buf, size_t size, int dir)
 {
-	dma_addr_t map = dma_map_area(dev, virt_to_bus(buf), size, dir);
+	dma_addr_t map = dma_map_area(dev, virt_to_bus(buf), size, dir,
+				      size - 1);
 
 	flush_gart();
 
@@ -286,7 +290,8 @@ gart_map_single(struct device *dev, void *addr, size_t size, int dir)
 	if (!need_iommu(dev, phys_mem, size))
 		return phys_mem;
 
-	bus = gart_map_simple(dev, addr, size, dir);
+	dma_addr_t map = dma_map_area(dev, virt_to_bus(addr), size, dir, 0);
+	flush_gart();
 
 	return bus;
 }
@@ -345,7 +350,7 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 		unsigned long addr = sg_phys(s);
 
 		if (nonforced_iommu(dev, addr, s->length)) {
-			addr = dma_map_area(dev, addr, s->length, dir);
+			addr = dma_map_area(dev, addr, s->length, dir, 0);
 			if (addr == bad_dma_address) {
 				if (i > 0)
 					gart_unmap_sg(dev, sg, i, dir);
@@ -367,7 +372,7 @@ static int __dma_map_cont(struct device *dev, struct scatterlist *start,
 			  int nelems, struct scatterlist *sout,
 			  unsigned long pages)
 {
-	unsigned long iommu_start = alloc_iommu(dev, pages);
+	unsigned long iommu_start = alloc_iommu(dev, pages, 0);
 	unsigned long iommu_page = iommu_start;
 	struct scatterlist *s;
 	int i;
