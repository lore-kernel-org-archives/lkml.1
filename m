Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYLSNCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYLSNCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 08:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYLSNCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 08:02:44 -0500
Received: from cmpxchg.org ([85.214.51.133]:52357 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbYLSNCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 08:02:43 -0500
Date: Fri, 19 Dec 2008 14:02:11 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Guennadi Liakhovetski <lg@denx.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] bitmap: fix bitmap_find_free_region()
Message-ID: <20081219130211.GA1560@cmpxchg.org>
References: <Pine.LNX.4.64.0812191202130.4536@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812191202130.4536@axis700.grange>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 12:26:41PM +0100, Guennadi Liakhovetski wrote:
> Currently bitmap_find_free_region() assumes, that the requested region 
> size is smaller than the entire bitmap. If this is not the case it fails 
> to detect it and returns success, while pointing at a position outside of 
> the region.
> 
> Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
> It is hard to believe, that this is a bug, last time this code was touched 
> in 2006... Or should the caller guarantee, that the requested region is 
> not larger than the bitmap? Then dma_alloc_from_coherent() is buggy, which 
> is where I hit this bug. But it seems to me bitmap_find_free_region() 
> should be fixed.
> 
> diff --git a/lib/bitmap.c b/lib/bitmap.c
> index 1338469..079c5e3 100644
> --- a/lib/bitmap.c
> +++ b/lib/bitmap.c
> @@ -950,6 +950,9 @@ int bitmap_find_free_region(unsigned long *bitmap, int bits, int order)
>  {
>  	int pos;		/* scans bitmap by regions of size order */
>  
> +	if (bits < 1 << order)
> +		return -ENOMEM;

I think this is an error on the callsite, so a WARN_ON() might be good
to spot these.  I would be interested in the callpath that triggered
this bug for you.

And return -ENOSPC?

	Hannes
