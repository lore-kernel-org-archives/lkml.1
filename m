Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbYILOxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbYILOxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 10:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYILOwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 10:52:53 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:4784 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbYILOww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 10:52:52 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K737ZF-03-0BC-01
Date: Fri, 12 Sep 2008 16:52:27 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: make GART to respect device's dma_mask about virtual mappings
Message-ID: <20080912145227.GA24945@amd.com>
References: <1221216155-17640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1221216155-17640-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1221216155-17640-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1221216155-17640-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1221216155-17640-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 12 Sep 2008 14:52:28.0058 (UTC) FILETIME=[2CEE37A0:01C914E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 07:42:35PM +0900, FUJITA Tomonori wrote:
> Currently, GART IOMMU ingores device's dma_mask when it does virtual
> mappings. So it could give a device a virtual address that the device
> can't access to.
> 
> This patch fixes the above problem.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/x86/kernel/pci-gart_64.c |   39 ++++++++++++++++++++++++++++-----------
>  1 files changed, 28 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index 47abe43..9739d56 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -83,23 +83,34 @@ static unsigned long next_bit;  /* protected by iommu_bitmap_lock */
>  static int need_flush;		/* global flush state. set for each gart wrap */
>  
>  static unsigned long alloc_iommu(struct device *dev, int size,
> -				 unsigned long align_mask)
> +				 unsigned long align_mask, u64 dma_mask)

You can calculate the dma_mask in this function from the dev parameter.
There is no need to pass it two levels down to this function extending
various parameter lists.

>  {
>  	unsigned long offset, flags;
>  	unsigned long boundary_size;
>  	unsigned long base_index;
> +	unsigned long limit;
>  
>  	base_index = ALIGN(iommu_bus_base & dma_get_seg_boundary(dev),
>  			   PAGE_SIZE) >> PAGE_SHIFT;
>  	boundary_size = ALIGN((unsigned long long)dma_get_seg_boundary(dev) + 1,
>  			      PAGE_SIZE) >> PAGE_SHIFT;
>  
> +	limit = iommu_device_max_index(iommu_pages,
> +				       DIV_ROUND_UP(iommu_bus_base, PAGE_SIZE),
> +				       dma_mask >> PAGE_SHIFT);
> +
>  	spin_lock_irqsave(&iommu_bitmap_lock, flags);
> -	offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, next_bit,
> +
> +	if (limit <= next_bit) {
> +		need_flush = 1;
> +		next_bit = 0;
> +	}
> +
> +	offset = iommu_area_alloc(iommu_gart_bitmap, limit, next_bit,
>  				  size, base_index, boundary_size, align_mask);
> -	if (offset == -1) {
> +	if (offset == -1 && next_bit) {
>  		need_flush = 1;
> -		offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, 0,
> +		offset = iommu_area_alloc(iommu_gart_bitmap, limit, 0,
>  					  size, base_index, boundary_size,
>  					  align_mask);
>  	}
> @@ -228,12 +239,14 @@ nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
>   * Caller needs to check if the iommu is needed and flush.
>   */
>  static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
> -				size_t size, int dir, unsigned long align_mask)
> +			       size_t size, int dir, unsigned long align_mask,
> +			       u64 dma_mask)
>  {
>  	unsigned long npages = iommu_num_pages(phys_mem, size);
> -	unsigned long iommu_page = alloc_iommu(dev, npages, align_mask);
> +	unsigned long iommu_page;
>  	int i;
>  
> +	iommu_page = alloc_iommu(dev, npages, align_mask, dma_mask);
>  	if (iommu_page == -1) {
>  		if (!nonforced_iommu(dev, phys_mem, size))
>  			return phys_mem;
> @@ -263,7 +276,7 @@ gart_map_single(struct device *dev, phys_addr_t paddr, size_t size, int dir)
>  	if (!need_iommu(dev, paddr, size))
>  		return paddr;
>  
> -	bus = dma_map_area(dev, paddr, size, dir, 0);
> +	bus = dma_map_area(dev, paddr, size, dir, 0, dma_get_mask(dev));
>  	flush_gart();
>  
>  	return bus;
> @@ -314,6 +327,7 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
>  {
>  	struct scatterlist *s;
>  	int i;
> +	u64 dma_mask = dma_get_mask(dev);
>  
>  #ifdef CONFIG_IOMMU_DEBUG
>  	printk(KERN_DEBUG "dma_map_sg overflow\n");
> @@ -323,7 +337,8 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
>  		unsigned long addr = sg_phys(s);
>  
>  		if (nonforced_iommu(dev, addr, s->length)) {
> -			addr = dma_map_area(dev, addr, s->length, dir, 0);
> +			addr = dma_map_area(dev, addr, s->length, dir, 0,
> +					    dma_mask);
>  			if (addr == bad_dma_address) {
>  				if (i > 0)
>  					gart_unmap_sg(dev, sg, i, dir);
> @@ -345,14 +360,16 @@ static int __dma_map_cont(struct device *dev, struct scatterlist *start,
>  			  int nelems, struct scatterlist *sout,
>  			  unsigned long pages)
>  {
> -	unsigned long iommu_start = alloc_iommu(dev, pages, 0);
> -	unsigned long iommu_page = iommu_start;
> +	unsigned long iommu_start;
> +	unsigned long iommu_page;
>  	struct scatterlist *s;
>  	int i;
>  
> +	iommu_start = alloc_iommu(dev, pages, 0, dma_get_mask(dev));
>  	if (iommu_start == -1)
>  		return -1;
>  
> +	iommu_page = iommu_start;
>  	for_each_sg(start, s, nelems, i) {
>  		unsigned long pages, addr;
>  		unsigned long phys_addr = s->dma_address;
> @@ -505,7 +522,7 @@ gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
>  	align_mask = (1UL << get_order(size)) - 1;
>  
>  	*dma_addr = dma_map_area(dev, paddr, size, DMA_BIDIRECTIONAL,
> -				 align_mask);
> +				 align_mask, dma_mask);
>  	flush_gart();
>  
>  	if (*dma_addr != bad_dma_address)
> -- 
> 1.5.5.GIT
> 
> 

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

