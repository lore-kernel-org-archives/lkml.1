Return-Path: <linux-kernel-owner+w=401wt.eu-S1758367AbZCSBlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbZCSBlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 21:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZCSBkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 21:40:55 -0400
Received: from sh.osrg.net ([192.16.179.4]:37713 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbZCSBky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 21:40:54 -0400
Date: Thu, 19 Mar 2009 10:39:30 +0900
To: joerg.roedel@amd.com
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 09/18] dma-debug: add checking for map/unmap_page/single
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1236346229-6618-10-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
	<1236346229-6618-10-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090319103716G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 19 Mar 2009 10:39:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Mar 2009 14:30:20 +0100
Joerg Roedel <joerg.roedel@amd.com> wrote:

> Impact: add debug callbacks for dma_{un}map_[page|single]
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  include/linux/dma-debug.h |   23 +++++++++++++++++++
>  lib/dma-debug.c           |   53 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 76 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
> index 345d538..65f7352 100644
> --- a/include/linux/dma-debug.h
> +++ b/include/linux/dma-debug.h
> @@ -28,12 +28,35 @@ struct device;
>  
>  extern void dma_debug_init(u32 num_entries);
>  
> +extern void debug_dma_map_page(struct device *dev, struct page *page,
> +			       size_t offset, size_t size,
> +			       int direction, dma_addr_t dma_addr,
> +			       bool map_single);
> +
> +extern void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
> +				 size_t size, int direction, bool map_single);
> +
> +
>  #else /* CONFIG_DMA_API_DEBUG */
>  
>  static inline void dma_debug_init(u32 num_entries)
>  {
>  }
>  
> +static inline void debug_dma_map_page(struct device *dev, struct page *page,
> +				      size_t offset, size_t size,
> +				      int direction, dma_addr_t dma_addr,
> +				      bool map_single)
> +{
> +}
> +
> +static inline void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
> +					size_t size, int direction,
> +					bool map_single)
> +{
> +}
> +
> +
>  #endif /* CONFIG_DMA_API_DEBUG */
>  
>  #endif /* __DMA_DEBUG_H */
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index d0cb47a..a2ed2b7 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -566,3 +566,56 @@ out:
>  
>  }
>  
> +void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
> +			size_t size, int direction, dma_addr_t dma_addr,
> +			bool map_single)
> +{
> +	struct dma_debug_entry *entry;
> +
> +	if (unlikely(global_disable))
> +		return;
> +
> +	if (unlikely(dma_mapping_error(dev, dma_addr)))
> +		return;
> +
> +	entry = dma_entry_alloc();
> +	if (!entry)
> +		return;
> +
> +	entry->dev       = dev;
> +	entry->type      = dma_debug_page;
> +	entry->paddr     = page_to_phys(page) + offset;
> +	entry->dev_addr  = dma_addr;
> +	entry->size      = size;
> +	entry->direction = direction;
> +
> +	if (map_single) {
> +		entry->type = dma_debug_single;
> +		check_for_stack(dev, page_address(page) + offset);

Why you don't call check_for_stack() for dma_map_page()?

page_address(page) could be invalid with dma_map_page() so the check
can be pointless. However, you call check_for_stack() with dma_map_sg,
which the check can be pointless too with; I think that you call
check_for_stack() in an inconsistent way.
