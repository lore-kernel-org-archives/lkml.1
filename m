Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbYHQM4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbYHQM4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYHQM4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:56:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37943 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbYHQM4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:56:35 -0400
Date: Sun, 17 Aug 2008 14:56:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: prarit@redhat.com, jbarnes@virtuousgeek.org, joro@8bytes.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
Message-ID: <20080817125614.GA31875@elte.hu>
References: <20080809125116H.fujita.tomonori@lab.ntt.co.jp> <20080815161629.GL27955@elte.hu> <20080815180048.GA26844@elte.hu> <20080816101601K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080816101601K.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> > Config is:
> > 
> >   http://redhat.com/~mingo/misc/config-Fri_Aug_15_18_30_56_CEST_2008.bad
> > 
> > Any idea why that is so? Apparently the alignment change wasnt as benign 
> > as assumed.
> 
> Ah, sorry,
> 
> @@ -262,7 +264,11 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
>  static dma_addr_t
>  gart_map_simple(struct device *dev, phys_addr_t paddr, size_t size, int dir)
>  {
> -	dma_addr_t map = dma_map_area(dev, paddr, size, dir);
> +	dma_addr_t map;
> +	unsigned long align_mask;
> +
> +	align_mask = (roundup_pow_of_two(size) >> PAGE_SHIFT) - 1;
> +	map = dma_map_area(dev, paddr, size, dir, align_mask);
> 
> This code doesn't work with the case size < PAGE_SIZE.
> 
> I think that dmam_alloc_consistent in libata-core fails due to this
> bug.
> 
> Can you try this?

ok - merged the commit below in tip/x86/iommu.

> BTW, I think that this is not urgent stuff at all.

ok - i've queued it up for v2.6.28.

	Ingo

-------------->
>From 4ae29849888f85a0cee12553995d47ec527ad049 Mon Sep 17 00:00:00 2001
From: Prarit Bhargava <prarit@redhat.com>
Date: Sat, 16 Aug 2008 10:15:32 +0900
Subject: [PATCH] x86 gart: allocate size-aligned address for alloc_coherent, v2

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
3.  Fixup the alignment calculation in the iommu-helper code.
4.  Fix possible overflow in alloc_iommu's boundary_size calculation.
    (It is possible that alloc_iommu()'s boundary_size overflows as
     dma_get_seg_boundary can return 0xffffffff.  In that case, further usage of
     boundary_size triggers a BUG_ON() in the iommu code.)

End result: When allocating from IOMMU, pci_alloc_consistent/dma_alloc_coherent
will now return a size aligned value.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
[ FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>: boot hang fix. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/pci-gart_64.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index cdab678..4d8efb0 100644
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
+	align_mask = (1UL << get_order(size)) - 1;
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
