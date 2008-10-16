Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYJPCwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYJPCwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 22:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbYJPCwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 22:52:25 -0400
Received: from colo.lackof.org ([198.49.126.79]:34616 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbYJPCwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 22:52:24 -0400
Date: Wed, 15 Oct 2008 20:52:11 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dwmw2@infradead.org, mgross@linux.intel.com, mingo@elte.hu,
       grundler@parisc-linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: use coherent_dma_mask in alloc_coherent
Message-ID: <20081016025211.GB31457@colo.lackof.org>
References: <20081015160732K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015160732K.fujita.tomonori@lab.ntt.co.jp>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 04:08:28PM +0900, FUJITA Tomonori wrote:
> This patch fixes intel-iommu to use dev->coherent_dma_mask in
> alloc_coherent. Currently, intel-iommu uses dev->dma_mask in
> alloc_coherent but alloc_coherent is supposed to use
> coherent_dma_mask. It could break drivers that uses smaller
> coherent_dma_mask than dma_mask (though the current code works for the
> majority that use the same mask for coherent_dma_mask and dma_mask).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Reviewed-by: Grant Grundler <grundler@parisc-linux.org>

Thanks!
grant


> ---
>  drivers/pci/intel-iommu.c |   30 ++++++++++++++++++++----------
>  1 files changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index 389fdd6..68a97bc 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -1759,14 +1759,14 @@ iommu_alloc_iova(struct dmar_domain *domain, size_t size, u64 end)
>  
>  static struct iova *
>  __intel_alloc_iova(struct device *dev, struct dmar_domain *domain,
> -		size_t size)
> +		   size_t size, unsigned long dma_mask)
>  {
>  	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct iova *iova = NULL;
>  
> -	if ((pdev->dma_mask <= DMA_32BIT_MASK) || (dmar_forcedac)) {
> -		iova = iommu_alloc_iova(domain, size, pdev->dma_mask);
> -	} else  {
> +	if (dma_mask <= DMA_32BIT_MASK || dmar_forcedac)
> +		iova = iommu_alloc_iova(domain, size, dma_mask);
> +	else {
>  		/*
>  		 * First try to allocate an io virtual address in
>  		 * DMA_32BIT_MASK and if that fails then try allocating
> @@ -1774,7 +1774,7 @@ __intel_alloc_iova(struct device *dev, struct dmar_domain *domain,
>  		 */
>  		iova = iommu_alloc_iova(domain, size, DMA_32BIT_MASK);
>  		if (!iova)
> -			iova = iommu_alloc_iova(domain, size, pdev->dma_mask);
> +			iova = iommu_alloc_iova(domain, size, dma_mask);
>  	}
>  
>  	if (!iova) {
> @@ -1813,8 +1813,9 @@ get_valid_domain_for_dev(struct pci_dev *pdev)
>  	return domain;
>  }
>  
> -static dma_addr_t
> -intel_map_single(struct device *hwdev, phys_addr_t paddr, size_t size, int dir)
> +static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
> +				     size_t size, int dir,
> +				     unsigned long dma_mask)
>  {
>  	struct pci_dev *pdev = to_pci_dev(hwdev);
>  	struct dmar_domain *domain;
> @@ -1833,7 +1834,7 @@ intel_map_single(struct device *hwdev, phys_addr_t paddr, size_t size, int dir)
>  
>  	size = aligned_size((u64)paddr, size);
>  
> -	iova = __intel_alloc_iova(hwdev, domain, size);
> +	iova = __intel_alloc_iova(hwdev, domain, size, pdev->dma_mask);
>  	if (!iova)
>  		goto error;
>  
> @@ -1879,6 +1880,13 @@ error:
>  	return 0;
>  }
>  
> +static dma_addr_t
> +intel_map_single(struct device *hwdev, phys_addr_t paddr, size_t size, int dir)
> +{
> +	return __intel_map_single(hwdev, paddr, size, dir,
> +				  to_pci_dev(hwdev)->dma_mask);
> +}
> +
>  static void flush_unmaps(void)
>  {
>  	int i, j;
> @@ -1993,7 +2001,9 @@ static void * intel_alloc_coherent(struct device *hwdev, size_t size,
>  		return NULL;
>  	memset(vaddr, 0, size);
>  
> -	*dma_handle = intel_map_single(hwdev, virt_to_bus(vaddr), size, DMA_BIDIRECTIONAL);
> +	*dma_handle = __intel_map_single(hwdev, virt_to_bus(vaddr), size,
> +					 DMA_BIDIRECTIONAL,
> +					 hwdev->coherent_dma_mask);
>  	if (*dma_handle)
>  		return vaddr;
>  	free_pages((unsigned long)vaddr, order);
> @@ -2096,7 +2106,7 @@ static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist,
>  		size += aligned_size((u64)addr, sg->length);
>  	}
>  
> -	iova = __intel_alloc_iova(hwdev, domain, size);
> +	iova = __intel_alloc_iova(hwdev, domain, size, pdev->dma_mask);
>  	if (!iova) {
>  		sglist->dma_length = 0;
>  		return 0;
> -- 
> 1.5.5.GIT
