Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbYIJMEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbYIJMEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYIJMEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:04:13 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:4988 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbYIJMEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:04:12 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K6ZATD-04-7B2-01
Date: Wed, 10 Sep 2008 14:03:10 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: avoid unnecessary low zone allocation in AMD IOMMU's alloc_coherent
Message-ID: <20080910120310.GD6329@amd.com>
References: <20080910201851R.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080910201851R.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Sep 2008 12:03:10.0299 (UTC) FILETIME=[319BB2B0:01C9133D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 08:19:40PM +0900, FUJITA Tomonori wrote:
> This is for tip/iommu.
> 
> btw, Joery, what happens if map_sg (or map_single) gets
> not-DMA-capable buffer in the case of !iommu || !domain?

It blows up :-)
I know it but currently it is no problem because this will never happen
in any real AMD IOMMU system (because the hardware just remaps every
device in the system). It needs a fix anyway and the
right solution here is to fall back to one of the software iommu
implementations. The stackable dma_ops patches I have currently in work
will do exactly that.

> 
> 
> ==
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] x86: avoid unnecessary low zone allocation in AMD IOMMU's alloc_coherent
> 
> x86's common alloc_coherent (dma_alloc_coherent in dma-mapping.h) sets
> up the gfp flag according to the device dma_mask but AMD IOMMU doesn't
> need it for devices that the IOMMU can do virtual mappings for. This
> patch avoids unnecessary low zone allocation.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/x86/kernel/amd_iommu.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> index 01c68c3..8efd249 100644
> --- a/arch/x86/kernel/amd_iommu.c
> +++ b/arch/x86/kernel/amd_iommu.c
> @@ -999,6 +999,11 @@ static void *alloc_coherent(struct device *dev, size_t size,
>  	u16 devid;
>  	phys_addr_t paddr;
>  
> +	get_device_resources(dev, &iommu, &domain, &devid);
> +
> +	if (iommu && domain)
> +		flag &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
> +

These flags are already removed in the dma_alloc_coherent function which
calls this one. Further I think in the case of a remapping IOMMU like
this one we should avoid implementing any gfp hacks and just trust the
caller.

>  	virt_addr = (void *)__get_free_pages(flag, get_order(size));
>  	if (!virt_addr)
>  		return 0;
> @@ -1006,8 +1011,6 @@ static void *alloc_coherent(struct device *dev, size_t size,
>  	memset(virt_addr, 0, size);
>  	paddr = virt_to_phys(virt_addr);
>  
> -	get_device_resources(dev, &iommu, &domain, &devid);
> -
>  	if (!iommu || !domain) {
>  		*dma_addr = (dma_addr_t)paddr;
>  		return virt_addr;
> -- 
> 1.5.4.2
> 
> 

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

