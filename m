Return-Path: <linux-kernel-owner+w=401wt.eu-S1752899AbYLSRqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbYLSRqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYLSRqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:46:32 -0500
Received: from gw.goop.org ([64.81.55.164]:50336 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbYLSRqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:46:31 -0500
Message-ID: <494BDDF5.1090304@goop.org>
Date: Fri, 19 Dec 2008 09:46:29 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Becky Bruce <beckyb@kernel.crashing.org>
CC: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       ian.campbell@citrix.com, jbeulich@novell.com, joerg.roedel@amd.com,
       benh@kernel.crashing.org
Subject: Re: [PATCH 07/11] swiotlb: Add support for systems with highmem
References: <20081218210231.GB24271@elte.hu> <1229663480-10757-8-git-send-email-beckyb@kernel.crashing.org>
In-Reply-To: <1229663480-10757-8-git-send-email-beckyb@kernel.crashing.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Becky Bruce wrote:
> On highmem systems, the original dma buffer might not
> have a virtual mapping - we need to kmap it in to perform
> the bounce.  Extract the code that does the actual
> copy into a function that does the kmap if highmem
> is enabled, and defaults to the normal swiotlb memcpy
> if not.
>
> Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
> ---
>  lib/swiotlb.c |   53 +++++++++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 45 insertions(+), 8 deletions(-)
>
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index e9d5bf6..ab5d3d7 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -14,6 +14,7 @@
>   * 04/07/.. ak		Better overflow handling. Assorted fixes.
>   * 05/09/10 linville	Add support for syncing ranges, support syncing for
>   *			DMA_BIDIRECTIONAL mappings, miscellaneous cleanup.
> + * 08/12/11 beckyb	Add highmem support
>   */
>  
>  #include <linux/cache.h>
> @@ -24,6 +25,7 @@
>  #include <linux/string.h>
>  #include <linux/types.h>
>  #include <linux/ctype.h>
> +#include <linux/highmem.h>
>  
>  #include <asm/io.h>
>  #include <asm/dma.h>
> @@ -306,6 +308,45 @@ static int is_swiotlb_buffer(char *addr)
>  }
>  
>  /*
> + * Bounce: copy the swiotlb buffer back to the original dma location
> + */
> +void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
> +		  enum dma_data_direction dir)
> +{
> +#ifdef CONFIG_HIGHMEM
>   

Rather than using #ifdef CONFIG_HIGHMEM, I think it would be better to 
use something like:

	if (PageHighMem(phys_to_page(phys))) {
		/* handle high page */
	} else {
		/* simple path */
	}

This will still exclude all the highmem code on non-highmem systems, and 
will use the fast-path for lowmem pages too.

> +	/* The buffer may not have a mapping.  Map it in and copy */
> +	unsigned int offset = ((unsigned long)phys &
> +			       ((1 << PAGE_SHIFT) - 1));
> +	char *buffer;
> +	unsigned int sz = 0;
> +	unsigned long flags;
> +
> +	while (size) {
> +		sz = ((PAGE_SIZE - offset) > size) ? size :
> +			PAGE_SIZE - offset;
>   
sz = min(size, PAGE_SIZE - offset)?
> +		local_irq_save(flags);
> +		buffer = kmap_atomic(pfn_to_page(phys >> PAGE_SHIFT),
>   
phys_to_page() does this for you.
> +				     KM_BOUNCE_READ);
> +		if (dir == DMA_TO_DEVICE)
> +			memcpy(dma_addr, buffer + offset, sz);
> +		else
> +			memcpy(buffer + offset, dma_addr, sz);
> +		kunmap_atomic(buffer, KM_BOUNCE_READ);
> +		local_irq_restore(flags);
> +		size -= sz;
> +		phys += sz;
> +		dma_addr += sz;
> +		offset = 0;
> +	}
> +#else
> +	if (dir == DMA_TO_DEVICE)
> +		memcpy(dma_addr, phys_to_virt(phys), size);
> +	else
> +		memcpy(phys_to_virt(phys), dma_addr, size);
> +#endif
> +}
>   

    J
