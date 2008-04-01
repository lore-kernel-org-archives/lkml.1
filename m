Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbYDAL1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbYDAL1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbYDAL1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:27:35 -0400
Received: from mail.windriver.com ([147.11.1.11]:60063 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710AbYDAL1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:27:34 -0400
Message-ID: <47F21C06.7070809@windriver.com>
Date: Tue, 01 Apr 2008 19:27:02 +0800
From: yshi <yang.shi@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@qumranet.com>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net, Jens Axboe <axboe@kernel.dk>
Subject: Re: regression breaks lowmem reserved RAM
References: <20080328194909.GA10617@duo.random> <20080401105331.GH12427@duo.random>
In-Reply-To: <20080401105331.GH12427@duo.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2008 11:26:50.0166 (UTC) FILETIME=[473A4D60:01C893EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea,

This patch works well on my machine. Thanks.

Best Regards,
Yang

Andrea Arcangeli ??:
> Looking a bit closer into this regression the reason this can't be
> right is that dma_addr common default is BLK_BOUNCE_HIGH and most
> machines have less than 4G. So if you do:
>
>     if (b_pfn <= (min_t(u64, 0xffffffff, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
> 	dma = 1
>
> that will translate to:
>
>      if (BLK_BOUNCE_HIGH <= BLK_BOUNCE_HIGH)
>      	dma = 1
>
> So for 99% of hardware this will trigger unnecessary GFP_DMA
> allocations and isa pooling operations.
>
> Also note how the 32bit code still does b_pfn < blk_max_low_pfn.
>
> I guess this is what you were looking after. I didn't verify but as
> far as I can tell, this will stop the regression with isa dma
> operations at boot for 99% of blkdev/memory combinations out there and
> I guess this fixes the setups with >4G of ram and 32bit pci cards as
> well (this also retains symmetry with the 32bit code).
>
> Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>
>
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 1344a0e..5713f7e 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -140,7 +140,7 @@ void blk_queue_bounce_limit(struct request_queue *q, u64 dma_addr)
>  	/* Assume anything <= 4GB can be handled by IOMMU.
>  	   Actually some IOMMUs can handle everything, but I don't
>  	   know of a way to test this here. */
> -	if (b_pfn <= (min_t(u64, 0xffffffff, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
> +	if (b_pfn < (min_t(u64, 0x100000000UL, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
>  		dma = 1;
>  	q->bounce_pfn = max_low_pfn;
>  #else
>
>   

