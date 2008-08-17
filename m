Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbYHQPsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbYHQPsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 11:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYHQPsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 11:48:35 -0400
Received: from sh.osrg.net ([192.16.179.4]:56975 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbYHQPse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 11:48:34 -0400
Date: Mon, 18 Aug 2008 00:48:05 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, prarit@redhat.com, jbarnes@virtuousgeek.org,
       joro@8bytes.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080817154213.GB6411@elte.hu>
References: <20080817125614.GA31875@elte.hu>
	<20080818003648M.fujita.tomonori@lab.ntt.co.jp>
	<20080817154213.GB6411@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080818004844G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2008 17:42:13 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > The above commit log of Prarit's patch is completely wrong (so I wrote 
> > this patch). To avoid misunderstanding, can you apply this patch with 
> > a proper description like this:
> 
> sure, i've created the commit below - is that fine?
> 
> 	Ingo

I think that 'v2' in the subject is unnecessary. The rest looks fine.

Thanks,


> --------------->
> From 3f18931be15856db01a216995670412e4421f3c9 Mon Sep 17 00:00:00 2001
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Mon, 18 Aug 2008 00:36:18 +0900
> Subject: [PATCH] x86 gart: allocate size-aligned address for alloc_coherent, v2
> 
> This patch changes GART IOMMU to return a size aligned address wrt
> dma_alloc_coherent, as DMA-mapping.txt defines:
> 
> The cpu return address and the DMA bus master address are both
> guaranteed to be aligned to the smallest PAGE_SIZE order which
> is greater than or equal to the requested size.  This invariant
> exists (for example) to guarantee that if you allocate a chunk
> which is smaller than or equal to 64 kilobytes, the extent of the
> buffer you receive will not cross a 64K boundary.
> 
> But it is very unlikely that this matters. As DMA-mapping.txt
> explains, This invariant is to avoid the boundary problem (such as
> 64K). Now the majority of IOMMUs including GART (except for Intel
> IOMMU) don't allocate a buffer that crosses a 64K boundary wrt all the
> DMA mapping interfaces (dma_alloc_coherent, dma_map_sg, and
> dma_map_single) because of segment_boundary_mask in struct
> device_dma_parameters.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/pci-gart_64.c |   25 ++++++++++++++++---------
>  1 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index cdab678..4d8efb0 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -82,7 +82,8 @@ AGPEXTERN __u32 *agp_gatt_table;
>  static unsigned long next_bit;  /* protected by iommu_bitmap_lock */
>  static int need_flush;		/* global flush state. set for each gart wrap */
>  
> -static unsigned long alloc_iommu(struct device *dev, int size)
> +static unsigned long alloc_iommu(struct device *dev, int size,
> +				 unsigned long align_mask)
>  {
>  	unsigned long offset, flags;
>  	unsigned long boundary_size;
> @@ -95,11 +96,12 @@ static unsigned long alloc_iommu(struct device *dev, int size)
>  
>  	spin_lock_irqsave(&iommu_bitmap_lock, flags);
>  	offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, next_bit,
> -				  size, base_index, boundary_size, 0);
> +				  size, base_index, boundary_size, align_mask);
>  	if (offset == -1) {
>  		need_flush = 1;
>  		offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, 0,
> -					  size, base_index, boundary_size, 0);
> +					  size, base_index, boundary_size,
> +					  align_mask);
>  	}
>  	if (offset != -1) {
>  		next_bit = offset+size;
> @@ -236,10 +238,10 @@ nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
>   * Caller needs to check if the iommu is needed and flush.
>   */
>  static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
> -				size_t size, int dir)
> +				size_t size, int dir, unsigned long align_mask)
>  {
>  	unsigned long npages = iommu_num_pages(phys_mem, size);
> -	unsigned long iommu_page = alloc_iommu(dev, npages);
> +	unsigned long iommu_page = alloc_iommu(dev, npages, align_mask);
>  	int i;
>  
>  	if (iommu_page == -1) {
> @@ -262,7 +264,11 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
>  static dma_addr_t
>  gart_map_simple(struct device *dev, phys_addr_t paddr, size_t size, int dir)
>  {
> -	dma_addr_t map = dma_map_area(dev, paddr, size, dir);
> +	dma_addr_t map;
> +	unsigned long align_mask;
> +
> +	align_mask = (1UL << get_order(size)) - 1;
> +	map = dma_map_area(dev, paddr, size, dir, align_mask);
>  
>  	flush_gart();
>  
> @@ -281,7 +287,8 @@ gart_map_single(struct device *dev, phys_addr_t paddr, size_t size, int dir)
>  	if (!need_iommu(dev, paddr, size))
>  		return paddr;
>  
> -	bus = gart_map_simple(dev, paddr, size, dir);
> +	bus = dma_map_area(dev, paddr, size, dir, 0);
> +	flush_gart();
>  
>  	return bus;
>  }
> @@ -340,7 +347,7 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
>  		unsigned long addr = sg_phys(s);
>  
>  		if (nonforced_iommu(dev, addr, s->length)) {
> -			addr = dma_map_area(dev, addr, s->length, dir);
> +			addr = dma_map_area(dev, addr, s->length, dir, 0);
>  			if (addr == bad_dma_address) {
>  				if (i > 0)
>  					gart_unmap_sg(dev, sg, i, dir);
> @@ -362,7 +369,7 @@ static int __dma_map_cont(struct device *dev, struct scatterlist *start,
>  			  int nelems, struct scatterlist *sout,
>  			  unsigned long pages)
>  {
> -	unsigned long iommu_start = alloc_iommu(dev, pages);
> +	unsigned long iommu_start = alloc_iommu(dev, pages, 0);
>  	unsigned long iommu_page = iommu_start;
>  	struct scatterlist *s;
>  	int i;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
