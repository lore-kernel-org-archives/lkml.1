Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbYKOUPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbYKOUPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 15:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYKOUPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 15:15:34 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:46912 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbYKOUPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 15:15:33 -0500
Date: Sat, 15 Nov 2008 20:15:15 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org, htejun@gmail.com, akpm@linux-foundation.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] Fix kunmap() argument in sg_miter_stop
In-Reply-To: <20081115112751.1d38c072@infradead.org>
Message-ID: <Pine.LNX.4.64.0811152003360.1618@blonde.site>
References: <20081115112751.1d38c072@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Nov 2008, Arjan van de Ven wrote:
> >From fd5530ac75a919a20bf7951e90a2b12323e9c0a0 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sat, 15 Nov 2008 11:23:58 -0800
> Subject: [PATCH] Fix kunmap() argument in sg_miter_stop
> 
> kunmap() takes as argument the struct page that orginally got kmap()'d,
> however the sg_miter_stop() function passed it the kernel virtual address
> instead, resulting in "kernel BUG at arch/x86/mm/highmem_32.c:115!"

Your patch looks like a good fix to me, but I don't get how its bug
would manifest as highmem_32.c:115 - that's a check in kunmap_atomic(),
whereas you're fixing a bad address to kunmap().

I'd expect what you're fixing to manifest as an mm/highmem.c:207 -
the BUG_ON(!vaddr) in kunmap_high().  Or have I just got in a
terrible muddle?

Of course, I'd love it to explain mm/highmem.c:319,
but I can't see that either.

Hugh

> 
> This is moderately popular on kerneloops.org, mostly in interaction with the MMC layer.
> 
> Reported-by: kerneloops.org
> CC: htejun@gmail.com
> CC: stable@kernel.org
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  lib/scatterlist.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index 8d2688f..b7b449d 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -395,7 +395,7 @@ void sg_miter_stop(struct sg_mapping_iter *miter)
>  			WARN_ON(!irqs_disabled());
>  			kunmap_atomic(miter->addr, KM_BIO_SRC_IRQ);
>  		} else
> -			kunmap(miter->addr);
> +			kunmap(miter->page);
>  
>  		miter->page = NULL;
>  		miter->addr = NULL;
> -- 
> 1.6.0.3
