Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbYG2OYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbYG2OYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 10:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756886AbYG2OYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 10:24:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756313AbYG2OYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 10:24:39 -0400
Message-ID: <488F2819.2090303@redhat.com>
Date: Tue, 29 Jul 2008 10:24:25 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joro@8bytes.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
References: <20080723111928.15828.42561.sendpatchset@prarit.bos.redhat.com> <20080723221033.GD13662@8bytes.org> <20080724081528F.fujita.tomonori@lab.ntt.co.jp> <200807281523.35469.jbarnes@virtuousgeek.org>
In-Reply-To: <200807281523.35469.jbarnes@virtuousgeek.org>
Content-Type: multipart/mixed;
 boundary="------------070906020300050304070600"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070906020300050304070600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


>
> Prarit, what's the latest here?  The v3 patch I have from you doesn't apply to 
> my tree but it looks like a good fix.  Care to send me a new patch against my 
> for-linus branch?
>
>   

New patch.



--------------070906020300050304070600
Content-Type: text/plain;
 name="upstream3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="upstream3.patch"

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
index 744126e..d3eb527 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -85,7 +85,8 @@ AGPEXTERN __u32 *agp_gatt_table;
 static unsigned long next_bit;  /* protected by iommu_bitmap_lock */
 static int need_flush;		/* global flush state. set for each gart wrap */
 
-static unsigned long alloc_iommu(struct device *dev, int size)
+static unsigned long alloc_iommu(struct device *dev, int size,
+				 unsigned long mask)
 {
 	unsigned long offset, flags;
 	unsigned long boundary_size;
@@ -93,16 +94,17 @@ static unsigned long alloc_iommu(struct device *dev, int size)
 
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
 		next_bit = offset+size;
@@ -239,10 +241,11 @@ nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
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
@@ -265,7 +268,7 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 static dma_addr_t
 gart_map_simple(struct device *dev, phys_addr_t paddr, size_t size, int dir)
 {
-	dma_addr_t map = dma_map_area(dev, paddr, size, dir);
+	dma_addr_t map = dma_map_area(dev, paddr, size, dir, size - 1);
 
 	flush_gart();
 
@@ -284,7 +287,8 @@ gart_map_single(struct device *dev, phys_addr_t paddr, size_t size, int dir)
 	if (!need_iommu(dev, paddr, size))
 		return paddr;
 
-	bus = gart_map_simple(dev, paddr, size, dir);
+	bus = dma_map_area(dev, paddr, size, dir, 0);
+	flush_gart();
 
 	return bus;
 }
@@ -343,7 +347,7 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 		unsigned long addr = sg_phys(s);
 
 		if (nonforced_iommu(dev, addr, s->length)) {
-			addr = dma_map_area(dev, addr, s->length, dir);
+			addr = dma_map_area(dev, addr, s->length, dir, 0);
 			if (addr == bad_dma_address) {
 				if (i > 0)
 					gart_unmap_sg(dev, sg, i, dir);
@@ -365,7 +369,7 @@ static int __dma_map_cont(struct device *dev, struct scatterlist *start,
 			  int nelems, struct scatterlist *sout,
 			  unsigned long pages)
 {
-	unsigned long iommu_start = alloc_iommu(dev, pages);
+	unsigned long iommu_start = alloc_iommu(dev, pages, 0);
 	unsigned long iommu_page = iommu_start;
 	struct scatterlist *s;
 	int i;

--------------070906020300050304070600--
