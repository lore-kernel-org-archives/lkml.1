Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbXJWFH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbXJWFH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 01:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbXJWFHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 01:07:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:54876 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbXJWFHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 01:07:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,314,1188802800"; 
   d="scan'208";a="183032406"
Date: Mon, 22 Oct 2007 21:58:41 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, torvalds@linux-foundation.org,
       anil.s.keshavamurthy@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: fix sg_page()
Message-ID: <20071023045841.GB18751@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20071023135926A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023135926A.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 01:59:26PM +0900, FUJITA Tomonori wrote:
> drivers/pci/intel-iommu.c: In function 'intel_unmap_sg':
> drivers/pci/intel-iommu.c:1987: error: 'struct scatterlist' has no member named 'page'
> drivers/pci/intel-iommu.c: In function 'intel_nontranslate_map_sg':
> drivers/pci/intel-iommu.c:2013: error: 'struct scatterlist' has no member named 'page'
> drivers/pci/intel-iommu.c:2014: error: 'struct scatterlist' has no member named 'page'
> drivers/pci/intel-iommu.c: In function 'intel_map_sg':
> drivers/pci/intel-iommu.c:2044: error: 'struct scatterlist' has no member named 'page'
> drivers/pci/intel-iommu.c:2068: error: 'struct scatterlist' has no member named 'page'
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

> ---
>  drivers/pci/intel-iommu.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index b3d7031..0f6e528 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -1962,7 +1962,6 @@ static void intel_free_coherent(struct device *hwdev, size_t size,
>  	free_pages((unsigned long)vaddr, order);
>  }
>  
> -#define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)
>  static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
>  	int nelems, int dir)
>  {
> @@ -1984,7 +1983,7 @@ static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
>  	if (!iova)
>  		return;
>  	for_each_sg(sglist, sg, nelems, i) {
> -		addr = SG_ENT_VIRT_ADDRESS(sg);
> +		addr = sg_virt(sg);
>  		size += aligned_size((u64)addr, sg->length);
>  	}
>  
> @@ -2010,8 +2009,8 @@ static int intel_nontranslate_map_sg(struct device *hddev,
>  	struct scatterlist *sg;
>  
>  	for_each_sg(sglist, sg, nelems, i) {
> -		BUG_ON(!sg->page);
> -		sg->dma_address = virt_to_bus(SG_ENT_VIRT_ADDRESS(sg));
> +		BUG_ON(!sg_page(sg));
> +		sg->dma_address = virt_to_bus(sg_virt(sg));
>  		sg->dma_length = sg->length;
>  	}
>  	return nelems;
> @@ -2041,7 +2040,7 @@ static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist,
>  		return 0;
>  
>  	for_each_sg(sglist, sg, nelems, i) {
> -		addr = SG_ENT_VIRT_ADDRESS(sg);
> +		addr = sg_virt(sg);
>  		addr = (void *)virt_to_phys(addr);
>  		size += aligned_size((u64)addr, sg->length);
>  	}
> @@ -2065,7 +2064,7 @@ static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist,
>  	start_addr = iova->pfn_lo << PAGE_SHIFT_4K;
>  	offset = 0;
>  	for_each_sg(sglist, sg, nelems, i) {
> -		addr = SG_ENT_VIRT_ADDRESS(sg);
> +		addr = sg_virt(sg);
>  		addr = (void *)virt_to_phys(addr);
>  		size = aligned_size((u64)addr, sg->length);
>  		ret = domain_page_mapping(domain, start_addr + offset,
> -- 
> 1.5.2.4
