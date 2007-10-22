Return-Path: <linux-kernel-owner+w=401wt.eu-S1751438AbXJVVLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbXJVVLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 17:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750713AbXJVVK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 17:10:56 -0400
Received: from sa15.bezeqint.net ([192.115.104.30]:35896 "EHLO
	sa15.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbXJVVK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 17:10:56 -0400
Message-ID: <471D11DC.20007@panasas.com>
Date: Mon, 22 Oct 2007 23:10:52 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 08/10] [SG] Update arch/ to use sg helpers
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-9-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1193076664-13652-9-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like it could be nice to define and use a helper for
page_address(sg_page(sg)) (although 11 call sites could use it
after this patch)

#define sg_pgaddr(sg) page_address(sg_page(sg))

Note that mips sg_{un,}map_sg checked for page_address(sg->page) != 0
before calling __dma_sync(addr + sg->offset, sg->length, direction)
and you changed it to addr = (unsigned long) sg_virt(sg) which
takes sg->offset into account.  That said I'm not sure if the original
code was correct for the (page_address(sg->page) == 0 && sg->offset != 0)
case...


On Oct. 22, 2007, 20:11 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
<snip>

> diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
> index 98b5e5b..b0b034c 100644
> --- a/arch/mips/mm/dma-default.c
> +++ b/arch/mips/mm/dma-default.c
> @@ -165,12 +165,11 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
>  	for (i = 0; i < nents; i++, sg++) {
>  		unsigned long addr;
>  
> -		addr = (unsigned long) page_address(sg->page);
> +		addr = (unsigned long) sg_virt(sg);
>  		if (!plat_device_is_coherent(dev) && addr)
> -			__dma_sync(addr + sg->offset, sg->length, direction);
> +			__dma_sync(addr, sg->length, direction);
>  		sg->dma_address = plat_map_dma_mem(dev,
> -				                   (void *)(addr + sg->offset),
> -						   sg->length);
> +				                   (void *)addr, sg->length);
>  	}
>  
>  	return nents;
> @@ -223,10 +222,9 @@ void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
>  	for (i = 0; i < nhwentries; i++, sg++) {
>  		if (!plat_device_is_coherent(dev) &&
>  		    direction != DMA_TO_DEVICE) {
> -			addr = (unsigned long) page_address(sg->page);
> +			addr = (unsigned long) sg_virt(sg);
>  			if (addr)
> -				__dma_sync(addr + sg->offset, sg->length,
> -				           direction);
> +				__dma_sync(addr, sg->length, direction);
>  		}
>  		plat_unmap_dma_mem(sg->dma_address);
>  	}

<snip>

> diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
> index 5098f58..1a20fe3 100644
> --- a/arch/x86/kernel/pci-calgary_64.c
> +++ b/arch/x86/kernel/pci-calgary_64.c
> @@ -411,8 +411,10 @@ static int calgary_nontranslate_map_sg(struct device* dev,
>  	int i;
>  
>  	for_each_sg(sg, s, nelems, i) {
> -		BUG_ON(!s->page);
> -		s->dma_address = virt_to_bus(page_address(s->page) +s->offset);
> +		struct page *p = sg_page(s);
> +
> +		BUG_ON(!p);

why not just BUG_ON(!sg_page(s))?

> +		s->dma_address = virt_to_bus(sg_virt(s));
>  		s->dma_length = s->length;
>  	}
>  	return nelems;

