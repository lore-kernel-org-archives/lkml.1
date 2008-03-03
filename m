Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbYCCQZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbYCCQZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbYCCQY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:24:56 -0500
Received: from ns2.suse.de ([195.135.220.15]:47538 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbYCCQYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:24:55 -0500
Message-ID: <47CC2652.1080601@suse.de>
Date: Mon, 03 Mar 2008 17:24:50 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
Subject: Re: [RFC PATCH 1/3] block: add rq->complete_io hook for request stacking
References: <20080215.172727.39155014.k-ueda@ct.jp.nec.com>
In-Reply-To: <20080215.172727.39155014.k-ueda@ct.jp.nec.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kiyoshi,

Kiyoshi Ueda wrote:
> This patch adds ->complete_io() hook for request stacking.
> Request stacking drivers (such as request-based dm) can set
> a callback for completion.
> (The hook is not called in blk_end_io(), since request-based dm uses
>  it for clone completion in the following appendix patches.)
> 
[ .. ]
I would rather have rq->complete_io() to be pointing to blk_end_io in the
default case, this way rq->complete_io() would always be valid and we
would be saving us the if() clause.

> Index: 2.6.25-rc1/block/blk-core.c
> ===================================================================
> --- 2.6.25-rc1.orig/block/blk-core.c
> +++ 2.6.25-rc1/block/blk-core.c
> @@ -138,6 +138,7 @@ void rq_init(struct request_queue *q, st
>  	rq->data = NULL;
>  	rq->sense = NULL;
>  	rq->end_io = NULL;
> +	rq->complete_io = NULL;
rq->complete_io = blk_end_io;

>  	rq->end_io_data = NULL;
>  	rq->next_rq = NULL;
>  }
> @@ -1917,6 +1918,9 @@ static int blk_end_io(struct request *rq
>   **/
>  int blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
>  {
> +	if (rq->complete_io)
> +		return rq->complete_io(rq, error, nr_bytes, 0, NULL);
> +
>  	return blk_end_io(rq, error, nr_bytes, 0, NULL);
>  }
So when using my proposal this would just become:

{
    BUG_ON(!rq->complete_io);
    return rq->complete_io(rq, error, nr_bytes, 0, NULL);
}

>  EXPORT_SYMBOL_GPL(blk_end_request);
> @@ -1936,6 +1940,27 @@ EXPORT_SYMBOL_GPL(blk_end_request);
>   **/
>  int __blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
>  {
> +	if (unlikely(blk_queue_stackable(rq->q)))
> +		printk(KERN_WARNING "dev: %s: Not ready for request stacking, "
> +		       "but the device driver set it stackable. "
> +		       "Need to fix the device driver!\n",
> +		       rq->rq_disk ? rq->rq_disk->disk_name : "?");
> +
> +	if (unlikely(rq->complete_io)) {
> +		/*
> +		 * If we invoke the ->complete_io here, the request submitter's
> +		 * handler would get deadlock on the queue lock.
> +		 *
> +		 * This happens, when the request submitter didn't check
> +		 * whether the queue is stackable or the device driver marked
> +		 * the queue stackable.
> +		 * Need to fix the request submitter or the device driver.
> +		 */
> +		printk(KERN_ERR "The device driver isn't ready for "
> +		       "request stacking.\n");
> +		BUG();
> +	}
> +
This could be skipped entirely then.

>  	if (blk_fs_request(rq) || blk_pc_request(rq)) {
>  		if (__end_that_request_first(rq, error, nr_bytes))
>  			return 1;
> @@ -1966,6 +1991,9 @@ EXPORT_SYMBOL_GPL(__blk_end_request);
>  int blk_end_bidi_request(struct request *rq, int error, unsigned int nr_bytes,
>  			 unsigned int bidi_bytes)
>  {
> +	if (rq->complete_io)
> +		return rq->complete_io(rq, error, nr_bytes, bidi_bytes, NULL);
> +
>  	return blk_end_io(rq, error, nr_bytes, bidi_bytes, NULL);
>  }
return rq->complete_io(rq, error, nr_bytes, bidi_bytes, NULL);

>  EXPORT_SYMBOL_GPL(blk_end_bidi_request);
> @@ -1999,6 +2027,9 @@ int blk_end_request_callback(struct requ
>  			     unsigned int nr_bytes,
>  			     int (drv_callback)(struct request *))
>  {
> +	if (rq->complete_io)
> +		return rq->complete_io(rq, error, nr_bytes, 0, drv_callback);
> +
>  	return blk_end_io(rq, error, nr_bytes, 0, drv_callback);
return rq->complete_io(rq, error, nr_bytes, bidi_bytes, NULL);

>  }
>  EXPORT_SYMBOL_GPL(blk_end_request_callback);
> Index: 2.6.25-rc1/include/linux/blkdev.h
> ===================================================================
> --- 2.6.25-rc1.orig/include/linux/blkdev.h
> +++ 2.6.25-rc1/include/linux/blkdev.h
> @@ -42,6 +42,9 @@ void copy_io_context(struct io_context *
>  
>  struct request;
>  typedef void (rq_end_io_fn)(struct request *, int);
> +typedef int (rq_complete_io_fn)(struct request *rq, int error,
> +				unsigned int nr_bytes, unsigned int bidi_bytes,
> +				int (drv_callback)(struct request *));
>  
>  struct request_list {
>  	int count[2];
> @@ -228,6 +231,7 @@ struct request {
>  	 * completion callback.
>  	 */
>  	rq_end_io_fn *end_io;
> +	rq_complete_io_fn *complete_io;
>  	void *end_io_data;
>  
>  	/* for bidi */
> @@ -401,6 +405,7 @@ struct request_queue
>  #define QUEUE_FLAG_PLUGGED	7	/* queue is plugged */
>  #define QUEUE_FLAG_ELVSWITCH	8	/* don't use elevator, just do FIFO */
>  #define QUEUE_FLAG_BIDI		9	/* queue supports bidi requests */
> +#define QUEUE_FLAG_STACKABLE	10	/* queue supports request stacking */
>  
>  enum {
>  	/*
> @@ -446,6 +451,8 @@ enum {
>  #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
>  #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
>  #define blk_queue_flushing(q)	((q)->ordseq)
> +#define blk_queue_stackable(q)	\
> +		test_bit(QUEUE_FLAG_STACKABLE, &(q)->queue_flags)
>  
>  #define blk_fs_request(rq)	((rq)->cmd_type == REQ_TYPE_FS)
>  #define blk_pc_request(rq)	((rq)->cmd_type == REQ_TYPE_BLOCK_PC)
> Index: 2.6.25-rc1/drivers/scsi/scsi_lib.c
> ===================================================================
> --- 2.6.25-rc1.orig/drivers/scsi/scsi_lib.c
> +++ 2.6.25-rc1/drivers/scsi/scsi_lib.c
> @@ -1597,6 +1597,13 @@ struct request_queue *__scsi_alloc_queue
>  	 */
>  	blk_queue_dma_alignment(q, 0x03);
>  
> +	/*
> +	 * SCSI is ready for request stacking, since it doesn't hold
> +	 * queue lock when completing request.
> +	 * (It doesn't use __blk_end_request().)
> +	 */
> +	set_bit(QUEUE_FLAG_STACKABLE, &q->queue_flags);
> +
>  	return q;
>  }
>  EXPORT_SYMBOL(__scsi_alloc_queue);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Apart from this: Great work!

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
