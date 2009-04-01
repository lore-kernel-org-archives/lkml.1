Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbZDAQyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbZDAQyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761437AbZDAQyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:54:19 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:21775 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764360AbZDAQyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:54:17 -0400
Message-ID: <49D39B6C.7080707@panasas.com>
Date: Wed, 01 Apr 2009 19:50:52 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 13/17] blk-map: implement blk_rq_map_kern_sgl()
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-14-git-send-email-tj@kernel.org>
In-Reply-To: <1238593472-30360-14-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2009 16:52:53.0402 (UTC) FILETIME=[4C99F7A0:01C9B2EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2009 04:44 PM, Tejun Heo wrote:
> Impact: new API
> 
> Implement blk_rq_map_kern_sgl() using bio_copy_{map|kern}_sgl() and
> reimplement blk_rq_map_kern() in terms of it.  As the bio helpers
> already have all the necessary checks, all blk_rq_map_kern_sgl() has
> to do is wrap them and initialize rq accordingly.  The implementation
> closely resembles blk_rq_msp_user_iov().
> 
> This is an exported API and will be used to replace hack in scsi ioctl
> implementation.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  block/blk-map.c        |   54 ++++++++++++++++++++++++++++++-----------------
>  include/linux/blkdev.h |    2 +
>  2 files changed, 36 insertions(+), 20 deletions(-)
> 
> diff --git a/block/blk-map.c b/block/blk-map.c
> index eb206df..0474c09 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -161,47 +161,61 @@ int blk_rq_unmap_user(struct bio *bio)
>  EXPORT_SYMBOL(blk_rq_unmap_user);
>  
>  /**
> - * blk_rq_map_kern - map kernel data to a request, for REQ_TYPE_BLOCK_PC usage
> + * blk_rq_map_kern_sg - map kernel data to a request, for REQ_TYPE_BLOCK_PC
>   * @q:		request queue where request should be inserted
>   * @rq:		request to fill
> - * @kbuf:	the kernel buffer
> - * @len:	length of user data
> + * @sgl:	area to map
> + * @nents:	number of elements in @sgl
>   * @gfp:	memory allocation flags
>   *
>   * Description:
>   *    Data will be mapped directly if possible. Otherwise a bounce
>   *    buffer is used.
>   */
> -int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
> -		    unsigned int len, gfp_t gfp)
> +int blk_rq_map_kern_sg(struct request_queue *q, struct request *rq,
> +		       struct scatterlist *sgl, int nents, gfp_t gfp)
>  {
>  	int rw = rq_data_dir(rq);
> -	int do_copy = 0;
>  	struct bio *bio;
>  
> -	if (len > (q->max_hw_sectors << 9))
> -		return -EINVAL;
> -	if (!len || !kbuf)
> +	if (!sgl || nents <= 0)
>  		return -EINVAL;
>  
> -	do_copy = !blk_rq_aligned(q, kbuf, len) || object_is_on_stack(kbuf);
> -	if (do_copy)
> -		bio = bio_copy_kern(q, kbuf, len, gfp, rw);
> -	else
> -		bio = bio_map_kern(q, kbuf, len, gfp);
> -
> +	bio = bio_map_kern_sg(q, sgl, nents, rw, gfp);
> +	if (IS_ERR(bio))
> +		bio = bio_copy_kern_sg(q, sgl, nents, rw, gfp);
>  	if (IS_ERR(bio))
>  		return PTR_ERR(bio);

You might want to call bio_copy_kern_sg from within bio_map_kern_sg
and remove yet another export from bio layer

Same thing with bio_map_user_iov/bio_copy_user_iov

>  
> -	if (rq_data_dir(rq) == WRITE)
> -		bio->bi_rw |= (1 << BIO_RW);
> -
> -	if (do_copy)
> +	if (!bio_flagged(bio, BIO_USER_MAPPED))
>  		rq->cmd_flags |= REQ_COPY_USER;
>  
> +	blk_queue_bounce(q, &bio);
>  	blk_rq_bio_prep(q, rq, bio);

It could be nice to call blk_rq_append_bio() here
and support multiple calls to this member.
This will solve half of my problem with osd_initiator

Hmm .. but you wanted to drop multiple bio chaining
perhaps you would reconsider.

> -	blk_queue_bounce(q, &rq->bio);
>  	rq->buffer = rq->data = NULL;
>  	return 0;
>  }
> +EXPORT_SYMBOL(blk_rq_map_kern_sg);
> +
> +/**
> + * blk_rq_map_kern - map kernel data to a request, for REQ_TYPE_BLOCK_PC usage
> + * @q:		request queue where request should be inserted
> + * @rq:		request to fill
> + * @kbuf:	the kernel buffer
> + * @len:	length of user data
> + * @gfp:	memory allocation flags
> + *
> + * Description:
> + *    Data will be mapped directly if possible. Otherwise a bounce
> + *    buffer is used.
> + */
> +int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
> +		    unsigned int len, gfp_t gfp)
> +{
> +	struct scatterlist sg;
> +
> +	sg_init_one(&sg, kbuf, len);
> +
> +	return blk_rq_map_kern_sg(q, rq, &sg, 1, gfp);
> +}
>  EXPORT_SYMBOL(blk_rq_map_kern);

could be inline like with the end_request functions

> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index d04e118..58b41da 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -784,6 +784,8 @@ extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, uns
>  extern int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
>  			       struct rq_map_data *md, struct iovec *iov,
>  			       int count, unsigned int len, gfp_t gfp);
> +extern int blk_rq_map_kern_sg(struct request_queue *q, struct request *rq,
> +			      struct scatterlist *sgl, int nents, gfp_t gfp);
>  extern int blk_execute_rq(struct request_queue *, struct gendisk *,
>  			  struct request *, int);
>  extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,

