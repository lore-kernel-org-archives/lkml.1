Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZBUQ1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZBUQ1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 11:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZBUQ1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 11:27:09 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40999 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbZBUQ1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 11:27:08 -0500
Message-ID: <49A02A61.6060909@cs.helsinki.fi>
Date: Sat, 21 Feb 2009 18:22:57 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] kmemcheck: add hooks for page- and sg-dma-mappings
References: <1235223364-2097-1-git-send-email-vegard.nossum@gmail.com> <1235223364-2097-4-git-send-email-vegard.nossum@gmail.com>
In-Reply-To: <1235223364-2097-4-git-send-email-vegard.nossum@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> This is needed for page allocator support to prevent false positives
> when accessing pages which are dma-mapped.
> 
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  arch/x86/include/asm/dma-mapping.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
> index 830bb0e..713a002 100644
> --- a/arch/x86/include/asm/dma-mapping.h
> +++ b/arch/x86/include/asm/dma-mapping.h
> @@ -117,7 +117,12 @@ dma_map_sg(struct device *hwdev, struct scatterlist *sg,
>  {
>  	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
>  
> +	struct scatterlist *s;
> +	int i;
> +
>  	BUG_ON(!valid_dma_direction(direction));
> +	for_each_sg(sg, s, nents, i)
> +		kmemcheck_mark_initialized(sg_virt(s), s->length);
>  	return ops->map_sg(hwdev, sg, nents, direction);
>  }
>  
> @@ -215,6 +220,7 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
>  	struct dma_mapping_ops *ops = get_dma_ops(dev);
>  
>  	BUG_ON(!valid_dma_direction(direction));
> +	kmemcheck_mark_initialized(page_address(page) + offset, size);
>  	return ops->map_single(dev, page_to_phys(page) + offset,
>  			       size, direction);
>  }

What's with the new BUG_ON() calls here?
