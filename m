Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZDUR7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZDUR7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZDUR7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:59:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37313 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZDUR7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:59:21 -0400
Date: Tue, 21 Apr 2009 13:59:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Subject: Re: [PATCH 09/14] block: clean up request completion API
Message-ID: <20090421175919.GA11671@infradead.org>
References: <1240331881-28218-1-git-send-email-tj@kernel.org> <1240331881-28218-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240331881-28218-10-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  /**
> + * __blk_end_io - Generic end_io function to complete a request.
>   * @rq:           the request being processed
>   * @error:        %0 for success, < %0 for error
>   * @nr_bytes:     number of bytes to complete @rq
>   * @bidi_bytes:   number of bytes to complete @rq->next_rq
> + * @locked:	  whether rq->q->queue_lock is held on entry
>   *
>   * Description:
>   *     Ends I/O on a number of bytes attached to @rq and @rq->next_rq.
>   *     If @rq has leftover, sets it up for the next range of segments.
>   *
>   * Return:
> + *     %false - we are done with this request
> + *     %true  - this request is not freed yet, it still has pending buffers.
>   **/
> +bool __blk_end_io(struct request *rq, int error, unsigned int nr_bytes,
> +		  unsigned int bidi_bytes, bool locked)
>  {
>  	struct request_queue *q = rq->q;
>  	unsigned long flags = 0UL;
>  
> +	if (blk_update_request(rq, error, nr_bytes))
> +		return true;
>  
> +	/* Bidi request must be completed as a whole */
> +	if (unlikely(blk_bidi_rq(rq)) &&
> +	    blk_update_request(rq->next_rq, error, bidi_bytes))
> +		return true;
>  
>  	add_disk_randomness(rq->rq_disk);
>  
> +	if (!locked) {
> +		spin_lock_irqsave(q->queue_lock, flags);
> +		finish_request(rq, error);
> +		spin_unlock_irqrestore(q->queue_lock, flags);
> +	} else
> +		finish_request(rq, error);
>  
> +	return false;
>  }
> +EXPORT_SYMBOL_GPL(__blk_end_io);

That's really ugly code due to the locked argument.  Just make a helper
for all code down to add_disk_randomness, and have two different
functions call that and finish_request +/- the locking.

