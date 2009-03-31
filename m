Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZCaIg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZCaIg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZCaIgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:36:48 -0400
Received: from sh.osrg.net ([192.16.179.4]:51099 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbZCaIgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:36:47 -0400
Date: Tue, 31 Mar 2009 17:26:24 +0900
To: jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH] swiotlb: use swiotlb_alloc_boot to allocate emergency
 pool
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49D16916.5000103@goop.org>
References: <49D16916.5000103@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090331172554E.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 31 Mar 2009 17:26:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009 17:51:34 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Impact: bugfix
> 
> Also fix xen_swiotlb_fixup() to deal with sub-slab-sized allocations.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index 0de836d..e8df499 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -202,7 +202,8 @@ swiotlb_init_with_default_size(size_t default_size)
>  	/*
>  	 * Get the overflow emergency buffer
>  	 */
> -	io_tlb_overflow_buffer = alloc_bootmem_low(io_tlb_overflow);
> +	io_tlb_overflow_buffer = swiotlb_alloc_boot(io_tlb_overflow,
> +						    io_tlb_overflow >> IO_TLB_SHIFT);
>  	if (!io_tlb_overflow_buffer)
>  		panic("Cannot allocate SWIOTLB overflow buffer!\n");
>  
> diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
> index 9ce1599..5775691 100644
> --- a/drivers/pci/xen-iommu.c
> +++ b/drivers/pci/xen-iommu.c
> @@ -47,16 +47,22 @@ void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
>  		buf, size);
>  
>  	dma_bits = get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT) + PAGE_SHIFT;
> -	for (i = 0; i < nslabs; i += IO_TLB_SEGSIZE) {
> +
> +	i = 0;
> +	do {
> +		int slabs = min(nslabs - i, (unsigned long)IO_TLB_SEGSIZE);
> +
>  		do {
>  			rc = xen_create_contiguous_region(
>  				(unsigned long)buf + (i << IO_TLB_SHIFT),
> -				get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT),
> +				get_order(slabs << IO_TLB_SHIFT),
>  				dma_bits);
>  		} while (rc && dma_bits++ < max_dma_bits);
>  		if (rc)
>  			panic(KERN_ERR "xen_create_contiguous_region failed\n");
> -	}
> +
> +		i += slabs;
> +	} while(i < nslabs);
>  }
>  
>  int xen_wants_swiotlb(void)

This is a patch for a tree for dom0? I have no idea what xen-iommu.c
is doing (I don't know if dom0 support will be merged into mainline or
not). But the change to lib/swiotlb.c is fine by me.
