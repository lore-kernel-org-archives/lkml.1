Return-Path: <linux-kernel-owner+w=401wt.eu-S1751467AbZFINu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbZFINu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761545AbZFINtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:49:41 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:7944
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756954AbZFINtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:49:40 -0400
Message-ID: <4A2E6872.5080102@panasas.com>
Date: Tue, 09 Jun 2009 16:49:38 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone interface
References: <4A2E1490.7060902@ct.jp.nec.com>
In-Reply-To: <4A2E1490.7060902@ct.jp.nec.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2009 13:49:40.0147 (UTC) FILETIME=[229D2030:01C9E909]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2009 10:51 AM, Kiyoshi Ueda wrote:
> Hi Jens,
> 
> Recently, I posted an updated version of request-based dm patch-set
> (http://marc.info/?l=dm-devel&m=124392590507004&w=2) which was made
> on top of block#for-2.6.31.
> In block#for-2.6.31, __sector and __data_len of struct request are
> commented as 'internal, NEVER access directly'.
> However, since request-based dm needs to copy the latest status of
> the original request to clone, those fields are still accessed
> directly in the request-based dm patch-set.
> 
> I'd like to solve this issue without breaking the new block-layer policy.
> If those fields should not be accessed directly, I need a helper
> function to copy the original request.
> What do you think about the following patch which adds request cloning
> interface to the block-layer?
> Please apply if you have no problem.
> 
> 
> 
> This patch adds the following 2 interfaces for request-stacking drivers:
> 
>   - blk_rq_prep_clone(struct request *clone, struct request *orig,
> 		      struct bio_set *bs, gfp_t gfp_mask,
> 		      int (*bio_ctr)(struct bio *, struct bio*, void *),
> 		      void *data)
>       * Clones bios in the original request to the clone request
>         (bio_ctr is called for each cloned bios.)
>       * Copies the clone-related information of the original request
>         to the clone request.
> 
>   - blk_rq_unprep_clone(struct request *clone)
>       * Frees cloned bios from the clone request.
> 
> Request stacking drivers (e.g. request-based dm) need to make a clone
> request for a submitted request and dispatch it to other devices.
> 
> To allocate request for the clone, request stacking drivers may not
> be able to use blk_get_request() because the allocation may be done
> in an irq-disabled context.
> So blk_rq_prep_clone() takes a request allocated by the caller
> as an argument.
> 
> For each clone bio in the clone request, request stacking drivers
> should be able to set up their own completion handler.
> So blk_rq_prep_clone() takes a callback function which is called
> for each clone bio, and a pointer for private data which is passed
> to the callback.
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>

Cc: Boaz Harrosh <bharrosh@panasas.com>

Please CC me on this patch. I have use of it also for stacking
block driver. Once/if it hits mainline I would like to use this
function.

(Have not tested it yet)

Thanks

> ---
>  block/blk-core.c       |   98 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/blkdev.h |    5 ++
>  2 files changed, 103 insertions(+)
> 
> Index: linux-2.6-block/block/blk-core.c
> ===================================================================
> --- linux-2.6-block.orig/block/blk-core.c
> +++ linux-2.6-block/block/blk-core.c
> @@ -2295,6 +2295,104 @@ int blk_lld_busy(struct request_queue *q
>  }
>  EXPORT_SYMBOL_GPL(blk_lld_busy);
>  
> +/**
> + * blk_rq_unprep_clone - Helper function to free all bios in a cloned request
> + * @rq: the clone request to be cleaned up
> + *
> + * Description:
> + *     Free all bios in @rq for a cloned request.
> + */
> +void blk_rq_unprep_clone(struct request *rq)
> +{
> +	struct bio *bio;
> +
> +	while ((bio = rq->bio) != NULL) {
> +		rq->bio = bio->bi_next;
> +
> +		bio_put(bio);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
> +
> +/*
> + * Copy request information of the original request to the clone request.
> + */
> +static void __blk_rq_prep_clone(struct request *dst, struct request *src)
> +{
> +	dst->cpu = src->cpu;
> +	dst->cmd_flags = (rq_data_dir(src) | REQ_NOMERGE);
> +	dst->cmd_type = src->cmd_type;
> +	dst->__sector = blk_rq_pos(src);
> +	dst->__data_len = blk_rq_bytes(src);
> +	dst->nr_phys_segments = src->nr_phys_segments;
> +	dst->ioprio = src->ioprio;
> +	dst->buffer = src->buffer;
> +	dst->cmd_len = src->cmd_len;
> +	dst->cmd = src->cmd;
> +	dst->extra_len = src->extra_len;
> +	dst->sense = src->sense;
> +}
> +
> +/**
> + * blk_rq_prep_clone - Helper function to setup clone request
> + * @rq: the request to be setup
> + * @rq_src: original request to be cloned
> + * @bs: bio_set that bios for clone are allocated from
> + * @gfp_mask: memory allocation mask for bio
> + * @bio_ctr: setup function to be called for each clone bio.
> + *           Returns %0 for success, non %0 for failure.
> + * @data: private data to be passed to @bio_ctr
> + *
> + * Description:
> + *     Clones bios in @rq_src to @rq, and copies clone-related information
> + *     of @rq_src to @rq.
> + */
> +int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
> +		      struct bio_set *bs, gfp_t gfp_mask,
> +		      int (*bio_ctr)(struct bio *, struct bio *, void *),
> +		      void *data)
> +{
> +	struct bio *bio, *bio_src;
> +
> +	if (!bs)
> +		bs = fs_bio_set;
> +
> +	blk_rq_init(NULL, rq);
> +
> +	__rq_for_each_bio(bio_src, rq_src) {
> +		bio = bio_alloc_bioset(gfp_mask, bio_src->bi_max_vecs, bs);
> +		if (!bio)
> +			goto free_and_out;
> +
> +		__bio_clone(bio, bio_src);
> +
> +		if (bio_integrity(bio_src) &&
> +		    bio_integrity_clone(bio, bio_src, gfp_mask))
> +			goto free_and_out;
> +
> +		if (bio_ctr && bio_ctr(bio, bio_src, data))
> +			goto free_and_out;
> +
> +		if (rq->bio) {
> +			rq->biotail->bi_next = bio;
> +			rq->biotail = bio;
> +		} else
> +			rq->bio = rq->biotail = bio;
> +	}
> +
> +	__blk_rq_prep_clone(rq, rq_src);
> +
> +	return 0;
> +
> +free_and_out:
> +	if (bio)
> +		bio_free(bio, bs);
> +	blk_rq_unprep_clone(rq);
> +
> +	return -ENOMEM;
> +}
> +EXPORT_SYMBOL_GPL(blk_rq_prep_clone);
> +
>  int kblockd_schedule_work(struct request_queue *q, struct work_struct *work)
>  {
>  	return queue_work(kblockd_workqueue, work);
> Index: linux-2.6-block/include/linux/blkdev.h
> ===================================================================
> --- linux-2.6-block.orig/include/linux/blkdev.h
> +++ linux-2.6-block/include/linux/blkdev.h
> @@ -765,6 +765,11 @@ extern void blk_insert_request(struct re
>  extern void blk_requeue_request(struct request_queue *, struct request *);
>  extern int blk_rq_check_limits(struct request_queue *q, struct request *rq);
>  extern int blk_lld_busy(struct request_queue *q);
> +extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
> +			     struct bio_set *bs, gfp_t gfp_mask,
> +			     int (*bio_ctr)(struct bio *, struct bio *, void *),
> +			     void *data);
> +extern void blk_rq_unprep_clone(struct request *rq);
>  extern int blk_insert_cloned_request(struct request_queue *q,
>  				     struct request *rq);
>  extern void blk_plug_device(struct request_queue *);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

