Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbYHPBQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbYHPBQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 21:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYHPBQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 21:16:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:59614 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbYHPBQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 21:16:08 -0400
Date: Sat, 16 Aug 2008 10:15:32 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, prarit@redhat.com, jbarnes@virtuousgeek.org,
       joro@8bytes.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080815180048.GA26844@elte.hu>
References: <20080809125116H.fujita.tomonori@lab.ntt.co.jp>
	<20080815161629.GL27955@elte.hu>
	<20080815180048.GA26844@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080816101601K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008 20:00:48 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > Subject: [PATCH] x86 gart: allocate size-aligned address for alloc_coherent
> > > 
> > > This fixes GART to return a properly aligned address as
> > > DMA-mapping.txt defines.
> > 
> > applied to tip/x86/gart, thanks! Any v2.6.27-urgency of this patch?
> 
> hm, -tip testing has found that this patch causes a hard hang during 
> bootup:
> 
>  initcall ali_init+0x0/0x1b returned 0 after 3 msecs
>  calling  amd_init+0x0/0x1b
>  bus: 'pci': add driver pata_amd
>  bus: 'pci': driver_probe_device: matched device 0000:00:06.0 with driver pata_amd
>  bus: 'pci': really_probe: probing driver pata_amd with device 0000:00:06.0
>  pata_amd 0000:00:06.0: version 0.3.10
>  pata_amd 0000:00:06.0: setting latency timer to 64
>  [hard hang]
> 
> should have continued with:
> 
>  scsi0 : pata_amd
>  device: 'host0': device_add
>  device: 'host0': device_add
>  scsi1 : pata_amd
>  [... etc. ... ]
> 
> on an AMD X2 testsystem. (Asus board) Can send more info on request. 
> Config is:
> 
>   http://redhat.com/~mingo/misc/config-Fri_Aug_15_18_30_56_CEST_2008.bad
> 
> Any idea why that is so? Apparently the alignment change wasnt as benign 
> as assumed.

Ah, sorry,

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

This code doesn't work with the case size < PAGE_SIZE.

I think that dmam_alloc_consistent in libata-core fails due to this
bug.

Can you try this?

BTW, I think that this is not urgent stuff at all.


diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 49285f8..045ae6f 100644
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
