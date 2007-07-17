Return-Path: <linux-kernel-owner+w=401wt.eu-S1764765AbXGQKRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764765AbXGQKRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 06:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbXGQKRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 06:17:23 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:14945 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbXGQKRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 06:17:22 -0400
Date: Tue, 17 Jul 2007 13:16:58 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: akepner@sgi.com
Cc: linux-kernel@vger.kernel.org, Roland Dreier <rdreier@cisco.com>,
       glebn@voltaire.com
Subject: Re: [RFC/PATCH] allow memory to be tagged "coherent" via dma_map_sg()
Message-ID: <20070717101658.GB18721@rhun.ibm.com>
References: <20070717021812.GH16538@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717021812.GH16538@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 07:18:12PM -0700, akepner@sgi.com wrote:

> diff --git a/include/asm-ia64/dma-mapping.h b/include/asm-ia64/dma-mapping.h
> index 6299b51..22af26b 100644
> --- a/include/asm-ia64/dma-mapping.h
> +++ b/include/asm-ia64/dma-mapping.h
> @@ -73,4 +73,26 @@ dma_cache_sync (struct device *dev, void *vaddr, size_t size,
>  
>  #define dma_is_consistent(d, h)	(1)	/* all we do is coherent memory... */
>  
> +#define ARCH_DOES_POSTED_DMA
> +#define DMA_ATTR_SHIFT	8	/* bottom 8 bits for direction, upper bits 
> +				 * for additional "attributes". For now the 
> +				 * only attribute is "flush in-flight dma 
> +				 * when writing to scatterlist" */
> +#define DMA_DIR_MASK	((1 << DMA_ATTR_SHIFT) - 1)
> +#define DMA_ATTR_MASK	~DMA_DIR_MASK
> +static inline int
> +dma_data_direction_set_dmaflush(enum dma_data_direction dir, int dmaflush) {
> +	return (dir | (dmaflush << DMA_ATTR_SHIFT));
> +}
> +
> +static inline int 
> +dma_data_direction_get_direction(enum dma_data_direction dir) {
> +	return (dir & DMA_DIR_MASK);
> +}
> +
> +static inline int 
> +dma_data_direction_get_dmaflush(enum dma_data_direction dir) {
> +	return ((dir & DMA_ATTR_MASK) >> DMA_ATTR_SHIFT);
> +}
> +
>  #endif /* _ASM_IA64_DMA_MAPPING_H */
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 9a663c6..885589a 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -95,4 +95,11 @@ static inline void dmam_release_declared_memory(struct device *dev)
>  }
>  #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
>  
> +#ifndef ARCH_DOES_POSTED_DMA
> +static inline int
> +dma_data_direction_set_dmaflush(enum dma_data_direction dir, int dmaflush) {
> +	return (dir);
> +}
> +#endif /* ARCH_DOES_POSTED_DMA */
> +
>  #endif

The generic bits look much better than the previous version,
thanks. Is the generic dma_data_direction_set_dmaflush really needed?
if yes, what about dma_data_direction_get_direction and
dma_data_direction_get_dmaflush?

Cheers,
Muli
