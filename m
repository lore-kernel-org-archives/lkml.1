Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbXEUGdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbXEUGdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 02:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbXEUGdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 02:33:32 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:51431 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbXEUGdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 02:33:32 -0400
Date: Mon, 21 May 2007 08:32:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/12] x86-64: update iommu/dma mapping functions to sg  helpers
Message-ID: <20070521063249.GE14746@kernel.dk>
References: <11787972373654-git-send-email-jens.axboe@oracle.com> <11787972373765-git-send-email-jens.axboe@oracle.com> <464322BC.50101@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464322BC.50101@panasas.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10 2007, Benny Halevy wrote:
> @@ -411,12 +406,13 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
>  			   boundary and the new one doesn't have an offset. */
>  			if (!iommu_merge || !nextneed || !need || s->offset ||
>  			    (ps->offset + ps->length) % PAGE_SIZE) { 
> -				if (dma_map_cont(sg, start, i, sg+out, pages,
> -						 need) < 0)
> +				if (dma_map_cont(start_sg, i - start, sg+out,
> +						  pages, need) < 0)
>  					goto error;
>  				out++;
>  				pages = 0;
> -				start = i;	
> +				start = i;
> +				start_sg = s;
>  			}
>  		}
>  
> @@ -424,7 +420,7 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
>  		pages += to_pages(s->offset, s->length);
>  		ps = s;
>  	}
> -	if (dma_map_cont(sg, start, i, sg+out, pages, need) < 0)
> +	if (dma_map_cont(start_sg, i - start, sg+out, pages, need) < 0)
>  		goto error;
>  	out++;
>  	flush_gart();

Your patch is (very) buggy, the whole premise of doing chained sg
entries makes sg + int illegal!

-- 
Jens Axboe

