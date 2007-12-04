Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbXLDN75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbXLDN75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbXLDN5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:57:36 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:36709 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbXLDN5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:57:34 -0500
X-Greylist: delayed 1041 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Dec 2007 08:57:33 EST
Message-ID: <47555C90.2080609@panasas.com>
Date: Tue, 04 Dec 2007 15:56:32 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
CC: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com
Subject: Re: [PATCH 01/28] blk_end_request: add new request completion interface
 (take 3)
References: <20071130.182422.18574732.k-ueda@ct.jp.nec.com>
In-Reply-To: <20071130.182422.18574732.k-ueda@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01 2007 at 1:24 +0200, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> This patch adds 2 new interfaces for request completion:
>   o blk_end_request()   : called without queue lock
>   o __blk_end_request() : called with queue lock held
> 
> Some device drivers call some generic functions below between
> end_that_request_{first/chunk} and end_that_request_last().
>   o add_disk_randomness()
>   o blk_queue_end_tag()
>   o blkdev_dequeue_request()
> These are called in the blk_end_request() as a part of generic
> request completion.
> So all device drivers become to call above functions.
> 
> "Normal" drivers can be converted to use blk_end_request()
> in a standard way shown below.
> 
>  a) end_that_request_{chunk/first}
>     spin_lock_irqsave()
>     (add_disk_randomness(), blk_queue_end_tag(), blkdev_dequeue_request())
>     end_that_request_last()
>     spin_unlock_irqrestore()
>     => blk_end_request()
> 
>  b) spin_lock_irqsave()
>     end_that_request_{chunk/first}
>     (add_disk_randomness(), blk_queue_end_tag(), blkdev_dequeue_request())
>     end_that_request_last()
>     spin_unlock_irqrestore()
>     => spin_lock_irqsave()
>        __blk_end_request()
>        spin_unlock_irqsave()
> 
>  c) end_that_request_last()
>     => __blk_end_request()
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

comments in body

> ---
>  block/ll_rw_blk.c      |   67 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/blkdev.h |    2 +
>  2 files changed, 69 insertions(+)
> 
> Index: 2.6.24-rc3-mm2/block/ll_rw_blk.c
> ===================================================================
> --- 2.6.24-rc3-mm2.orig/block/ll_rw_blk.c
> +++ 2.6.24-rc3-mm2/block/ll_rw_blk.c
> @@ -3769,6 +3769,73 @@ void end_request(struct request *req, in
>  }
>  EXPORT_SYMBOL(end_request);
>  
> +static void complete_request(struct request *rq, int uptodate)
> +{
> +	if (blk_rq_tagged(rq))
> +		blk_queue_end_tag(rq->q, rq);
> +
> +	/* rq->queuelist of dequeued request should be list_empty() */
> +	if (!list_empty(&rq->queuelist))
> +		blkdev_dequeue_request(rq);
> +
> +	end_that_request_last(rq, uptodate);
> +}
> +
> +/**
> + * blk_end_request - Helper function for drivers to complete the request.
> + * @rq:       the request being processed
> + * @uptodate: 1 for success, 0 for I/O error, < 0 for specific error
> + * @nr_bytes: number of bytes to complete
> + *
> + * Description:
> + *     Ends I/O on a number of bytes attached to @rq.
> + *     If @rq has leftover, sets it up for the next range of segments.
> + *
> + * Return:
> + *     0 - we are done with this request
> + *     1 - still buffers pending for this request
> + **/
> +int blk_end_request(struct request *rq, int uptodate, int nr_bytes)

I always hated that uptodate boolean with possible negative error value.
I guess it was done for backward compatibility of then users of 
end_that_request_first(). But since you are introducing a new API then
this is not the case. Just have regular status int where 0 means ALL_OK
and negative value means error code. 
Just my $0.02.

> +{
> +	struct request_queue *q = rq->q;
> +	unsigned long flags = 0UL;
> +
> +	if (blk_fs_request(rq) || blk_pc_request(rq)) {
> +		if (__end_that_request_first(rq, uptodate, nr_bytes))
> +			return 1;
> +	}
> +
> +	add_disk_randomness(rq->rq_disk);
> +
> +	spin_lock_irqsave(q->queue_lock, flags);
> +	complete_request(rq, uptodate);
> +	spin_unlock_irqrestore(q->queue_lock, flags);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(blk_end_request);
> +
> +/**
> + * __blk_end_request - Helper function for drivers to complete the request.
> + *
> + * Description:
> + *     Must be called with queue lock held unlike blk_end_request().
> + **/
> +int __blk_end_request(struct request *rq, int uptodate, int nr_bytes)
> +{
> +	if (blk_fs_request(rq) || blk_pc_request(rq)) {
> +		if (__end_that_request_first(rq, uptodate, nr_bytes))
> +			return 1;
> +	}
> +
> +	add_disk_randomness(rq->rq_disk);
> +
> +	complete_request(rq, uptodate);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(__blk_end_request);
> +
>  static void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
>  			    struct bio *bio)
>  {
> Index: 2.6.24-rc3-mm2/include/linux/blkdev.h
> ===================================================================
> --- 2.6.24-rc3-mm2.orig/include/linux/blkdev.h
> +++ 2.6.24-rc3-mm2/include/linux/blkdev.h
> @@ -725,6 +725,8 @@ static inline void blk_run_address_space
>   * for parts of the original function. This prevents
>   * code duplication in drivers.
>   */
> +extern int blk_end_request(struct request *rq, int uptodate, int nr_bytes);
> +extern int __blk_end_request(struct request *rq, int uptodate, int nr_bytes);
>  extern int end_that_request_first(struct request *, int, int);
>  extern int end_that_request_chunk(struct request *, int, int);
>  extern void end_that_request_last(struct request *, int);

I don't like it that you have two Identical but slightly different implementations
I wish you would do an internal-with-flags implementation and then API ones can
call the internal one. Or maybe just hold the spin_lock just a bit longer and have
one call the other. To prove my case see how hard it is to add new code
like with the bidi patch, where you need to add exact same code in 3 places.
(OK only 2 places actually, if _callback is gone)

I want to say that this is grate work and thanks for doing this, I like this code
a lot.

Boaz
