Return-Path: <linux-kernel-owner+w=401wt.eu-S1763928AbZDALz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763928AbZDALz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761423AbZDALzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:55:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:56936 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760351AbZDALzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:55:07 -0400
Date: Wed, 1 Apr 2009 20:54:03 +0900
To: tj@kernel.org
Cc: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] blk-map: let blk_rq_map_user_iov() support null
 mapping
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1238583884-13517-8-git-send-email-tj@kernel.org>
References: <1238583884-13517-1-git-send-email-tj@kernel.org>
	<1238583884-13517-8-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090401205232C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 01 Apr 2009 20:54:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Apr 2009 20:04:43 +0900
Tejun Heo <tj@kernel.org> wrote:

> Impact: API expansion
> 
> Till now, only blk_rq_map() supported null mapping.  Add null mapping
> support to blk_rq_map_user_iov() by moving BIO_NULL_MAPPED setting to
> bio_copy_user_iov().

Why does blk_rq_map_user_iov() need to support the null mapping?


> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  block/blk-map.c |    3 ---
>  fs/bio.c        |    4 +++-
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-map.c b/block/blk-map.c
> index 6718021..ac1961d 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -63,9 +63,6 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
>  	if (IS_ERR(bio))
>  		return PTR_ERR(bio);
>  
> -	if (map_data && map_data->null_mapped)
> -		bio->bi_flags |= (1 << BIO_NULL_MAPPED);
> -
>  	orig_bio = bio;
>  	blk_queue_bounce(q, &bio);
>  
> diff --git a/fs/bio.c b/fs/bio.c
> index 8ad9784..728bef9 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -869,7 +869,9 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
>  	/*
>  	 * success
>  	 */
> -	if (!write_to_vm && (!map_data || !map_data->null_mapped)) {
> +	if (unlikely(map_data && map_data->null_mapped))
> +		bio->bi_flags |= (1 << BIO_NULL_MAPPED);
> +	else if (!write_to_vm) {
>  		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0, 0);
>  		if (ret)
>  			goto cleanup;
> -- 
> 1.6.0.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
