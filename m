Return-Path: <linux-kernel-owner+w=401wt.eu-S1763471AbYF3UjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763471AbYF3UjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbYF3UjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:39:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752031AbYF3Ui7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:38:59 -0400
Date: Mon, 30 Jun 2008 13:37:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] fix bio_add_page for non trivial merge_bvec_fn case
Message-Id: <20080630133739.fc4effec.akpm@linux-foundation.org>
In-Reply-To: <m3y75gszgb.fsf@dmon-lap.sw.ru>
References: <m3y75gszgb.fsf@dmon-lap.sw.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Jun 2008 19:45:08 +0400
Dmitri Monakhov <dmonakhov@openvz.org> wrote:

> We have to properly decrease all related bio's counters, especially bi_size
> in order to merge_bvec_fn return right result. Usually this result in
> false merge rejects for two absolutely valid bio_vecs. This may cause 
> significant performance penalty for example Itanium: page_size == 16k,
> fs_block_size == 1k and block device is raid with small chunk_size.
> 

Please cc Jens on BIO changes.

> ---
>  fs/bio.c |   16 ++++++++++++----
>  1 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index 7856257..d713074 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -332,14 +332,21 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>  
>  		if (page == prev->bv_page &&
>  		    offset == prev->bv_offset + prev->bv_len) {
> +			/* Temprory detacth last bio_vec. */

whoa, drunken speling.

> +			bio->bi_size -= prev->bv_len;
> +			bio->bi_vcnt--;
> +			bio->bi_phys_segments--;
> +			bio->bi_hw_segments--;
> +
>  			prev->bv_len += len;
>  			if (q->merge_bvec_fn &&
>  			    q->merge_bvec_fn(q, bio, prev) < len) {
>  				prev->bv_len -= len;
> -				return 0;
> +				len = 0;
>  			}
>  
> -			goto done;
> +			bio->bi_size += prev->bv_len;
> +			goto out_add_bvec;
>  		}
>  	}
>  
> @@ -394,11 +401,12 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
>  	    BIOVEC_VIRT_MERGEABLE(bvec-1, bvec)))
>  		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
>  
> +	bio->bi_size += len;
> +out_add_bvec:
>  	bio->bi_vcnt++;
>  	bio->bi_phys_segments++;
>  	bio->bi_hw_segments++;
> - done:
> -	bio->bi_size += len;
>  	return len;
>  }

For some reason patch(1) claims this hunk was corrupted.  I typed it in
by hand.

