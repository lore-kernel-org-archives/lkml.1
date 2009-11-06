Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbZKFCmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbZKFCmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 21:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZKFCmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 21:42:06 -0500
Received: from sh.osrg.net ([192.16.179.4]:42261 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014AbZKFCmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 21:42:04 -0500
Date: Fri, 6 Nov 2009 11:41:49 +0900
To: alex.williamson@hp.com
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] intel-iommu: Obey coherent_dma_mask for alloc_coherent
 on	passthrough
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091104225359.2720.91502.stgit@nehalem.aw>
References: <20091104225359.2720.91502.stgit@nehalem.aw>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091106114130J.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 06 Nov 2009 11:41:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Nov 2009 15:59:34 -0700
Alex Williamson <alex.williamson@hp.com> wrote:

> intel_alloc_coherent() needs to follow DMA mapping convention and
> make use of the coherent_dma_mask of the device for identity mappings.
> Without this, devices may get buffers they can't use.  This patch
> provides best effort allocations and fails the request if the mask
> requirements are not met rather than returning an unusable buffer.
> 
> Signed-off-by: Alex Williamson <alex.williamson@hp.com>
> ---
> 
> This patch fixes a regression introduced since 2.6.31 that prevents
> devices with a restricted coherent_dma_mask from working in passthrough
> mode.
> 
>  drivers/pci/intel-iommu.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index b1e97e6..8283df9 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -2582,7 +2582,7 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
>  	BUG_ON(dir == DMA_NONE);
>  
>  	if (iommu_no_mapping(hwdev))
> -		return paddr;
> +		return paddr + size > dma_mask ? 0 : paddr;

You can use dma_capable(hwdev, paddr, size) here.


>  	domain = get_valid_domain_for_dev(pdev);
>  	if (!domain)
> @@ -2767,7 +2767,15 @@ static void *intel_alloc_coherent(struct device *hwdev, size_t size,
>  
>  	size = PAGE_ALIGN(size);
>  	order = get_order(size);
> -	flags &= ~(GFP_DMA | GFP_DMA32);
> +
> +	if (!iommu_no_mapping(hwdev))
> +		flags &= ~(GFP_DMA | GFP_DMA32);
> +	else if (hwdev->coherent_dma_mask != DMA_BIT_MASK(64)) {
> +		if (hwdev->coherent_dma_mask < DMA_BIT_MASK(32))
> +			flags |= GFP_DMA;
> +		else
> +			flags |= GFP_DMA32;
> +	}

This is fine for 2.6.32 but we'll cleanly fix this by using
swiotlb_dma_ops later, right?
