Return-Path: <linux-kernel-owner+w=401wt.eu-S1762069AbYHIDva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762069AbYHIDva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 23:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756423AbYHIDvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 23:51:20 -0400
Received: from sh.osrg.net ([192.16.179.4]:53035 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185AbYHIDvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 23:51:19 -0400
Date: Sat, 9 Aug 2008 12:50:59 +0900
To: prarit@redhat.com
Cc: jbarnes@virtuousgeek.org, fujita.tomonori@lab.ntt.co.jp, joro@8bytes.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <489B33D4.1080107@redhat.com>
References: <4899B611.4070408@redhat.com>
	<200808071003.47326.jbarnes@virtuousgeek.org>
	<489B33D4.1080107@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080809125116H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Aug 2008 13:41:40 -0400
Prarit Bhargava <prarit@redhat.com> wrote:

> In that case, I hit the BUG() check warning in iommu_is_span_boundary() 
> because boundary_size was calculated as (unsigned long) 0xffffffff + 1 = 0.
> 
> That's why we must cast to "unsigned long long".
> 
> ie) it is possible to hit this BUG() right now.

Wrong, it doesn't happen, as I said again and again.


> >>>> Maybe I'm missing something -- what implies  size has to be a power of
> >>>> two?
> >>>>         
> >>> Yes, see iommu_area_alloc().
> >>>       
> >> /me looks and still doesn't see where the size passed into
> >> gart_map_simple() must be a power of two.  ... and if that was the case,
> >> shouldn't we be failing all the time?  I mean, I've seen values passed
> >> into pci_alloc_consistent like 0x3820 -- clearly not a multiple of 2.
> >>
> >> iommu_area_alloc() deals with pages, not actual sizes as
> >> gart_map_simple() does.
> >>     
> 
> Tomonori-san, I think I understand where your confusion may lie.  The 
> size argument in the iommu-helper.c code is NOT the same size in 
> dma_alloc_coherent() and gart_map_simple().  In iommu-helper.c the size 
> is the # of pages, and the in the exported function calls it is an 
> actual size.  Is that what is confusing you?

I understand it. FYI, I wrote iommu-helper.c.

Again, you don't understand the code. Here's a patch to fix the GART
to allocate a size-aligned address for alloc_coherent.

But as I told you again and again, I doubt that this fixes something.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86 gart: allocate size-aligned address for alloc_coherent

This fixes GART to return a properly aligned address as
DMA-mapping.txt defines.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-gart_64.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 49285f8..8e64b49 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -82,7 +82,8 @@ AGPEXTERN __u32 *agp_gatt_table;
 static unsigned long next_bit;  /* protected by iommu_bitmap_lock */
 static int need_flush;		/* global flush state. set for each gart wrap */
 
-static unsigned long alloc_iommu(struct device *dev, int size)
+static unsigned long alloc_iommu(struct device *dev, int size,
+				 unsigned long align_mask)
 {
 	unsigned long offset, flags;
 	unsigned long boundary_size;
@@ -95,11 +96,12 @@ static unsigned long alloc_iommu(struct device *dev, int size)
 
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
 	offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, next_bit,
-				  size, base_index, boundary_size, 0);
+				  size, base_index, boundary_size, align_mask);
 	if (offset == -1) {
 		need_flush = 1;
 		offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, 0,
-					  size, base_index, boundary_size, 0);
+					  size, base_index, boundary_size,
+					  align_mask);
 	}
 	if (offset != -1) {
 		next_bit = offset+size;
@@ -236,10 +238,10 @@ nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
  * Caller needs to check if the iommu is needed and flush.
  */
 static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
-				size_t size, int dir)
+				size_t size, int dir, unsigned long align_mask)
 {
 	unsigned long npages = iommu_num_pages(phys_mem, size);
-	unsigned long iommu_page = alloc_iommu(dev, npages);
+	unsigned long iommu_page = alloc_iommu(dev, npages, align_mask);
 	int i;
 
 	if (iommu_page == -1) {
@@ -262,7 +264,11 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 static dma_addr_t
 gart_map_simple(struct device *dev, phys_addr_t paddr, size_t size, int dir)
 {
-	dma_addr_t map = dma_map_area(dev, paddr, size, dir);
+	dma_addr_t map;
+	unsigned long align_mask;
+
+	align_mask = (roundup_pow_of_two(size) >> PAGE_SHIFT) - 1;
+	map = dma_map_area(dev, paddr, size, dir, align_mask);
 
 	flush_gart();
 
@@ -281,7 +287,8 @@ gart_map_single(struct device *dev, phys_addr_t paddr, size_t size, int dir)
 	if (!need_iommu(dev, paddr, size))
 		return paddr;
 
-	bus = gart_map_simple(dev, paddr, size, dir);
+	bus = dma_map_area(dev, paddr, size, dir, 0);
+	flush_gart();
 
 	return bus;
 }
@@ -340,7 +347,7 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 		unsigned long addr = sg_phys(s);
 
 		if (nonforced_iommu(dev, addr, s->length)) {
-			addr = dma_map_area(dev, addr, s->length, dir);
+			addr = dma_map_area(dev, addr, s->length, dir, 0);
 			if (addr == bad_dma_address) {
 				if (i > 0)
 					gart_unmap_sg(dev, sg, i, dir);
@@ -362,7 +369,7 @@ static int __dma_map_cont(struct device *dev, struct scatterlist *start,
 			  int nelems, struct scatterlist *sout,
 			  unsigned long pages)
 {
-	unsigned long iommu_start = alloc_iommu(dev, pages);
+	unsigned long iommu_start = alloc_iommu(dev, pages, 0);
 	unsigned long iommu_page = iommu_start;
 	struct scatterlist *s;
 	int i;
-- 
1.5.5.GIT

