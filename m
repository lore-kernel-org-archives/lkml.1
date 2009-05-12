Return-Path: <linux-kernel-owner+w=401wt.eu-S1760759AbZELL1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760759AbZELL1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbZELL1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:27:30 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60397 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbZELL13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:27:29 -0400
Date: Tue, 12 May 2009 13:27:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Kazuhisa Ichikawa <ki@epsilou.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix the bio_vec array index out-of-bounds test
Message-ID: <20090512112729.GI4140@kernel.dk>
References: <4A03D4F2.1070904@epsilou.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A03D4F2.1070904@epsilou.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08 2009, Kazuhisa Ichikawa wrote:
> From: Kazuhisa Ichikawa <ki@epsilou.com>
> 
> Current bio_vec array index out-of-bounds test within 
> __end_that_request_first() does not seem correct. 
> It checks bio->bi_idx against bio->bi_vcnt, but the subsequent code 
> uses idx (which is, bio->bi_idx + next_idx) as the array index into 
> bio_vec array. This means that the test really make sense only at 
> the first iteration of !(nr_bytes >=bio->bi_size) case (when next_idx 
> == zero). Fix this by replacing bio->bi_idx with idx.
> (This patch applies to 2.6.30-rc4.)
> 
> Signed-off-by: Kazuhisa Ichikawa <ki@epsilou.com>
> ---
> 
> --- linux-2.6.30-rc4/block/blk-core.c.ORIG	2009-05-08 00:00:10.000000000 +0900
> +++ linux-2.6.30-rc4/block/blk-core.c	2009-05-08 00:00:10.000000000 +0900
> @@ -1768,10 +1768,10 @@ static int __end_that_request_first(stru
>  		} else {
>  			int idx = bio->bi_idx + next_idx;
>  
> -			if (unlikely(bio->bi_idx >= bio->bi_vcnt)) {
> +			if (unlikely(idx >= bio->bi_vcnt)) {
>  				blk_dump_rq_flags(req, "__end_that");
>  				printk(KERN_ERR "%s: bio idx %d >= vcnt %d\n",
> -				       __func__, bio->bi_idx, bio->bi_vcnt);
> +				       __func__, idx, bio->bi_vcnt);
>  				break;
>  			}

Thanks!

-- 
Jens Axboe

