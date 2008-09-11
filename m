Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbYIKOQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbYIKOQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 10:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYIKOQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 10:16:35 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:20089 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYIKOQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:16:34 -0400
X-BigFish: VPS-24(z1346nz1432R98dR1805M936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K71BN0-03-LQ0-01
Date: Thu, 11 Sep 2008 16:16:14 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: gart alloc_coherent does virtual mapppings only when necessary
Message-ID: <20080911141613.GL24392@amd.com>
References: <1221142128-28350-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1221142128-28350-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1221142128-28350-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1221142128-28350-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 11 Sep 2008 14:16:14.0590 (UTC) FILETIME=[F30791E0:01C91418]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

On Thu, Sep 11, 2008 at 11:08:48PM +0900, FUJITA Tomonori wrote:
> gart alloc_coherent need to do virtual mapppings only when an
> allocated buffer is not DMA-capable for a device.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Joerg Roedel <joerg.roedel@amd.com>

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

> ---
>  arch/x86/kernel/pci-gart_64.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index 1b0c412..47abe43 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -488,15 +488,23 @@ gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
>  		    gfp_t flag)
>  {
>  	void *vaddr;
> +	dma_addr_t paddr;
>  	unsigned long align_mask;
> +	u64 dma_mask = dma_alloc_coherent_mask(dev, flag);
>  
>  	vaddr = (void *)__get_free_pages(flag | __GFP_ZERO, get_order(size));
>  	if (!vaddr)
>  		return NULL;
>  
> +	paddr = virt_to_phys(vaddr);
> +	if (is_buffer_dma_capable(dma_mask, paddr, size)) {
> +		*dma_addr = paddr;
> +		return vaddr;
> +	}
> +
>  	align_mask = (1UL << get_order(size)) - 1;
>  
> -	*dma_addr = dma_map_area(dev, __pa(vaddr), size, DMA_BIDIRECTIONAL,
> +	*dma_addr = dma_map_area(dev, paddr, size, DMA_BIDIRECTIONAL,
>  				 align_mask);
>  	flush_gart();
>  
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

