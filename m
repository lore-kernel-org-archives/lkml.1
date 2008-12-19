Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbYLSRkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbYLSRkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYLSRkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:40:01 -0500
Received: from gw.goop.org ([64.81.55.164]:34439 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbYLSRkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:40:00 -0500
Message-ID: <494BDC6E.8050509@goop.org>
Date: Fri, 19 Dec 2008 09:39:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Becky Bruce <beckyb@kernel.crashing.org>
CC: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       ian.campbell@citrix.com, jbeulich@novell.com, joerg.roedel@amd.com,
       benh@kernel.crashing.org
Subject: Re: [PATCH 06/11] swiotlb: Store phys address in io_tlb_orig_addr
 array
References: <20081218210231.GB24271@elte.hu> <1229663480-10757-7-git-send-email-beckyb@kernel.crashing.org>
In-Reply-To: <1229663480-10757-7-git-send-email-beckyb@kernel.crashing.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Becky Bruce wrote:
> When we enable swiotlb for platforms that support HIGHMEM, we
> can no longer store the virtual address of the original dma
> buffer, because that buffer might not have a permament mapping.
> Change the iotlb code to instead store the physical address of
> the original buffer.
>   

Hm, yes, I think using a phys_addr_t may end up being cleaner than using 
struct page *+offset.

    J

> Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
> ---
>  lib/swiotlb.c |   47 ++++++++++++++++++++++++-----------------------
>  1 files changed, 24 insertions(+), 23 deletions(-)
>
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index ed4f44a..e9d5bf6 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -118,7 +118,7 @@ static unsigned int io_tlb_index;
>   * We need to save away the original address corresponding to a mapped entry
>   * for the sync operations.
>   */
> -static unsigned char **io_tlb_orig_addr;
> +static phys_addr_t *io_tlb_orig_addr;
>  
>  /*
>   * Protect the above data structures in the map and unmap calls
> @@ -175,7 +175,7 @@ swiotlb_init_with_default_size(size_t default_size)
>  	for (i = 0; i < io_tlb_nslabs; i++)
>   		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
>  	io_tlb_index = 0;
> -	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(char *));
> +	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(phys_addr_t));
>  
>  	/*
>  	 * Get the overflow emergency buffer
> @@ -253,12 +253,14 @@ swiotlb_late_init_with_default_size(size_t default_size)
>   		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
>  	io_tlb_index = 0;
>  
> -	io_tlb_orig_addr = (unsigned char **)__get_free_pages(GFP_KERNEL,
> -	                           get_order(io_tlb_nslabs * sizeof(char *)));
> +	io_tlb_orig_addr = (phys_addr_t *)
> +		__get_free_pages(GFP_KERNEL,
> +				 get_order(io_tlb_nslabs *
> +					   sizeof(phys_addr_t)));
>  	if (!io_tlb_orig_addr)
>  		goto cleanup3;
>  
> -	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(char *));
> +	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(phys_addr_t));
>  
>  	/*
>  	 * Get the overflow emergency buffer
> @@ -276,8 +278,8 @@ swiotlb_late_init_with_default_size(size_t default_size)
>  	return 0;
>  
>  cleanup4:
> -	free_pages((unsigned long)io_tlb_orig_addr, get_order(io_tlb_nslabs *
> -	                                                      sizeof(char *)));
> +	free_pages((unsigned long)io_tlb_orig_addr,
> +		   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
>  	io_tlb_orig_addr = NULL;
>  cleanup3:
>  	free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
> @@ -307,7 +309,7 @@ static int is_swiotlb_buffer(char *addr)
>   * Allocates bounce buffer and returns its kernel virtual address.
>   */
>  static void *
> -map_single(struct device *hwdev, char *buffer, size_t size, int dir)
> +map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
>  {
>  	unsigned long flags;
>  	char *dma_addr;
> @@ -398,9 +400,9 @@ found:
>  	 * needed.
>  	 */
>  	for (i = 0; i < nslots; i++)
> -		io_tlb_orig_addr[index+i] = buffer + (i << IO_TLB_SHIFT);
> +		io_tlb_orig_addr[index+i] = phys + (i << IO_TLB_SHIFT);
>  	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
> -		memcpy(dma_addr, buffer, size);
> +		memcpy(dma_addr, phys_to_virt(phys), size);
>  
>  	return dma_addr;
>  }
> @@ -414,17 +416,17 @@ unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
>  	unsigned long flags;
>  	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
>  	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
> -	char *buffer = io_tlb_orig_addr[index];
> +	phys_addr_t phys = io_tlb_orig_addr[index];
>  
>  	/*
>  	 * First, sync the memory before unmapping the entry
>  	 */
> -	if (buffer && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
> +	if (phys && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
>  		/*
>  		 * bounce... copy the data back into the original buffer * and
>  		 * delete the bounce buffer.
>  		 */
> -		memcpy(buffer, dma_addr, size);
> +		memcpy(phys_to_virt(phys), dma_addr, size);
>  
>  	/*
>  	 * Return the buffer to the free list by setting the corresponding
> @@ -457,20 +459,20 @@ sync_single(struct device *hwdev, char *dma_addr, size_t size,
>  	    int dir, int target)
>  {
>  	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
> -	char *buffer = io_tlb_orig_addr[index];
> +	phys_addr_t phys = io_tlb_orig_addr[index];
>  
> -	buffer += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));
> +	phys += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));
>  
>  	switch (target) {
>  	case SYNC_FOR_CPU:
>  		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL))
> -			memcpy(buffer, dma_addr, size);
> +			memcpy(phys_to_virt(phys), dma_addr, size);
>  		else
>  			BUG_ON(dir != DMA_TO_DEVICE);
>  		break;
>  	case SYNC_FOR_DEVICE:
>  		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
> -			memcpy(dma_addr, buffer, size);
> +			memcpy(dma_addr, phys_to_virt(phys), size);
>  		else
>  			BUG_ON(dir != DMA_FROM_DEVICE);
>  		break;
> @@ -509,7 +511,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  		 * swiotlb_map_single(), which will grab memory from
>  		 * the lowest available address range.
>  		 */
> -		ret = map_single(hwdev, NULL, size, DMA_FROM_DEVICE);
> +		ret = map_single(hwdev, 0, size, DMA_FROM_DEVICE);
>  		if (!ret)
>  			return NULL;
>  	}
> @@ -591,7 +593,7 @@ swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
>  	/*
>  	 * Oh well, have to allocate and map a bounce buffer.
>  	 */
> -	map = map_single(hwdev, ptr, size, dir);
> +	map = map_single(hwdev, virt_to_phys(ptr), size, dir);
>  	if (!map) {
>  		swiotlb_full(hwdev, size, dir, 1);
>  		map = io_tlb_overflow_buffer;
> @@ -736,18 +738,17 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
>  		     int dir, struct dma_attrs *attrs)
>  {
>  	struct scatterlist *sg;
> -	void *addr;
>  	dma_addr_t dev_addr;
>  	int i;
>  
>  	BUG_ON(dir == DMA_NONE);
>  
>  	for_each_sg(sgl, sg, nelems, i) {
> -		addr = sg_virt(sg);
> -		dev_addr = virt_to_dma_addr(hwdev, addr);
> +		dev_addr = SG_ENT_BUS_ADDRESS(hwdev, sg);
>  		if (swiotlb_force ||
>  		    swiotlb_addr_needs_mapping(hwdev, dev_addr, sg->length)) {
> -			void *map = map_single(hwdev, addr, sg->length, dir);
> +			void *map = map_single(hwdev, sg_phys(sg), sg->length,
> +					       dir);
>  			if (!map) {
>  				/* Don't panic here, we expect map_sg users
>  				   to do proper error handling. */
>   

