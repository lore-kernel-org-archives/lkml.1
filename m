Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbYIHMBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbYIHMBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 08:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbYIHMBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 08:01:39 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:64681 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbYIHMBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 08:01:37 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K6VLEH-03-DGP-01
Date: Mon, 8 Sep 2008 14:01:29 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 3/5] x86: fix nommu_alloc_coherent allocation with NULL device argument
Message-ID: <20080908120129.GK3189@amd.com>
References: <1220865014-1169-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220865014-1169-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220865014-1169-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220865014-1169-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1220865014-1169-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 08 Sep 2008 12:01:30.0051 (UTC) FILETIME=[A1079130:01C911AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 06:10:12PM +0900, FUJITA Tomonori wrote:
> We need to use __GFP_DMA for NULL device argument (fallback_dev) with
> pci-nommu. It's a hack for ISA (and some old code) so we need to use
> GFP_DMA.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

> ---
>  arch/x86/kernel/pci-nommu.c   |    3 +--
>  include/asm-x86/dma-mapping.h |    2 ++
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
> index 0f51883..ada1c87 100644
> --- a/arch/x86/kernel/pci-nommu.c
> +++ b/arch/x86/kernel/pci-nommu.c
> @@ -80,7 +80,6 @@ nommu_alloc_coherent(struct device *hwdev, size_t size,
>  	int node;
>  	struct page *page;
>  
> -	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
>  	gfp |= __GFP_ZERO;
>  
>  	dma_mask = hwdev->coherent_dma_mask;
> @@ -93,7 +92,7 @@ nommu_alloc_coherent(struct device *hwdev, size_t size,
>  	node = dev_to_node(hwdev);
>  
>  #ifdef CONFIG_X86_64
> -	if (dma_mask <= DMA_32BIT_MASK)
> +	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA))
>  		gfp |= GFP_DMA32;
>  #endif
>  
> diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
> index 39d3641..9d6dcf4 100644
> --- a/include/asm-x86/dma-mapping.h
> +++ b/include/asm-x86/dma-mapping.h
> @@ -248,6 +248,8 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
>  	struct dma_mapping_ops *ops = get_dma_ops(dev);
>  	void *memory;
>  
> +	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
> +
>  	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
>  		return memory;
>  
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

