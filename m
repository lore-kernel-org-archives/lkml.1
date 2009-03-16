Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbZCPJOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbZCPJOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 05:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZCPJNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 05:13:51 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:51351 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbZCPJNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 05:13:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pIk9p39beSWSfMnh5ZgRTmWnpVr5CdvtuX36jIIhNb60I3YM8vAmU3cYD7E91iv4Dg
         P490+Fsva7OZoqeKnZEczAhNWjItKR6UDDHiL3gVDkapGo6tdPwIaU3lupHYMzsoy7Kd
         NMockgTTlo8J8Ub54HXXPx9OwxZ7gscC2rwQ4=
Message-ID: <49BE180A.7010904@panasas.com>
Date: Mon, 16 Mar 2009 11:12:42 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/14] block: clean up request completion API
References: <1236920578-2179-1-git-send-email-tj@kernel.org> <1236920578-2179-10-git-send-email-tj@kernel.org>
In-Reply-To: <1236920578-2179-10-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Impact: cleanup, rq->*nr_sectors always updated after req completion
> 
> Request completion has gone through several changes and became a bit
> messy over the time.  Clean it up.
> 
> 1. end_that_request_data() is a thin wrapper around
>    end_that_request_data_first() which checks whether bio is NULL
>    before doing anything and handles bidi completion.
>    blk_update_request() is a thin wrapper around
>    end_that_request_data() which clears nr_sectors on the last
>    iteration but doesn't use the bidi completion.
> 
>    Clean it up by moving the initial bio NULL check and nr_sectors
>    clearing on the last iteration into end_that_request_data() and
>    renaming it to blk_update_request(), which makes blk_end_io() the
>    only user of end_that_request_data().  Collapse
>    end_that_request_data() into blk_end_io().
> 
> 2. There are four visible completion variants - blk_end_request(),
>    __blk_end_request(), blk_end_bidi_request() and end_request().
>    blk_end_request() and blk_end_bidi_request() uses blk_end_request()
>    as the backend but __blk_end_request() and end_request() use
>    separate implementation in __blk_end_request() due to different
>    locking rules.
> 
>    Make blk_end_io() handle both cases thus all four public completion
>    functions are thin wrappers around blk_end_io().  Rename
>    blk_end_io() to __blk_end_io() and export it and inline all public
>    completion functions.
> 
> 3. As the whole request issue/completion usages are about to be
>    modified and audited, it's a good chance to convert completion
>    functions return bool which better indicates the intended meaning
>    of return values.
> 
> 4. The function name end_that_request_last() is from the days when it
>    was a public interface and slighly confusing.  Give it a proper
>    internal name - finish_request().
> 
> The only visible behavior change is from #1.  nr_sectors counts are
> cleared after the final iteration no matter which function is used to
> complete the request.  I couldn't find any place where the code
> assumes those nr_sectors counters contain the values for the last
> segment and this change is good as it makes the API much more
> consistent as the end result is now same whether a request is
> completed using [__]blk_end_request() alone or in combination with
> blk_update_request().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>

Amen! this patch brings light to my life ;) thanks

I have ran with these patches and they work as expected, perfectly.

I have a small request below, if it's OK?

> ---
>  block/blk-core.c       |  215 ++++++++++++------------------------------------
>  include/linux/blkdev.h |  114 +++++++++++++++++++++++---
>  2 files changed, 154 insertions(+), 175 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 9595c4f..b1781dd 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1798,25 +1798,35 @@ void elv_dequeue_request(struct request_queue *q, struct request *rq)
>  }
>  
>  /**
> - * __end_that_request_first - end I/O on a request
> - * @req:      the request being processed
> + * blk_update_request - Special helper function for request stacking drivers
> + * @rq:	      the request being processed
>   * @error:    %0 for success, < %0 for error
> - * @nr_bytes: number of bytes to complete
> + * @nr_bytes: number of bytes to complete @rq
>   *
>   * Description:
> - *     Ends I/O on a number of bytes attached to @req, and sets it up
> - *     for the next range of segments (if any) in the cluster.
> + *     Ends I/O on a number of bytes attached to @rq, but doesn't complete
> + *     the request structure even if @rq doesn't have leftover.
> + *     If @rq has leftover, sets it up for the next range of segments.
> + *
> + *     This special helper function is only for request stacking drivers
> + *     (e.g. request-based dm) so that they can handle partial completion.
> + *     Actual device drivers should use blk_end_request instead.
> + *
> + *     Passing the result of blk_rq_bytes() as @nr_bytes guarantees
> + *     %false return from this function.
>   *
>   * Return:
> - *     %0 - we are done with this request, call end_that_request_last()
> - *     %1 - still buffers pending for this request
> + *     %false - this request doesn't have any more data
> + *     %true  - this request has more data
>   **/
> -static int __end_that_request_first(struct request *req, int error,
> -				    int nr_bytes)
> +bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
>  {
>  	int total_bytes, bio_nbytes, next_idx = 0;
>  	struct bio *bio;
>  
> +	if (!req->bio)
> +		return false;
> +
>  	trace_block_rq_complete(req->q, req);
>  
>  	/*
> @@ -1889,8 +1899,16 @@ static int __end_that_request_first(struct request *req, int error,
>  	/*
>  	 * completely done
>  	 */
> -	if (!req->bio)
> -		return 0;
> +	if (!req->bio) {
> +		/*
> +		 * Reset counters so that the request stacking driver
> +		 * can find how many bytes remain in the request
> +		 * later.
> +		 */
> +		req->nr_sectors = req->hard_nr_sectors = 0;
> +		req->current_nr_sectors = req->hard_cur_sectors = 0;
> +		return false;
> +	}
>  
>  	/*
>  	 * if the request wasn't completed, update state
> @@ -1904,29 +1922,14 @@ static int __end_that_request_first(struct request *req, int error,
>  
>  	blk_recalc_rq_sectors(req, total_bytes >> 9);
>  	blk_recalc_rq_segments(req);
> -	return 1;
> -}
> -
> -static int end_that_request_data(struct request *rq, int error,
> -				 unsigned int nr_bytes, unsigned int bidi_bytes)
> -{
> -	if (rq->bio) {
> -		if (__end_that_request_first(rq, error, nr_bytes))
> -			return 1;
> -
> -		/* Bidi request must be completed as a whole */
> -		if (blk_bidi_rq(rq) &&
> -		    __end_that_request_first(rq->next_rq, error, bidi_bytes))
> -			return 1;
> -	}
> -
> -	return 0;
> +	return true;
>  }
> +EXPORT_SYMBOL_GPL(blk_update_request);
>  
>  /*
>   * queue lock must be held
>   */
> -static void end_that_request_last(struct request *req, int error)
> +static void finish_request(struct request *req, int error)
>  {
>  	if (blk_rq_tagged(req))
>  		blk_queue_end_tag(req->q, req);
> @@ -1952,161 +1955,47 @@ static void end_that_request_last(struct request *req, int error)
>  }
>  
>  /**
> - * blk_end_io - Generic end_io function to complete a request.
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
> - *     %0 - we are done with this request
> - *     %1 - this request is not freed yet, it still has pending buffers.
> + *     %false - we are done with this request
> + *     %true  - this request is not freed yet, it still has pending buffers.
>   **/
> -static int blk_end_io(struct request *rq, int error, unsigned int nr_bytes,
> -		      unsigned int bidi_bytes)
> +bool __blk_end_io(struct request *rq, int error, unsigned int nr_bytes,
> +		  unsigned int bidi_bytes, bool locked)
>  {
>  	struct request_queue *q = rq->q;
>  	unsigned long flags = 0UL;
>  
> -	if (end_that_request_data(rq, error, nr_bytes, bidi_bytes))
> -		return 1;
> -
> -	add_disk_randomness(rq->rq_disk);
> -
> -	spin_lock_irqsave(q->queue_lock, flags);
> -	end_that_request_last(rq, error);
> -	spin_unlock_irqrestore(q->queue_lock, flags);
> -
> -	return 0;
> -}
> +	if (blk_update_request(rq, error, nr_bytes))
> +		return true;
>  
> -/**
> - * blk_end_request - Helper function for drivers to complete the request.
> - * @rq:       the request being processed
> - * @error:    %0 for success, < %0 for error
> - * @nr_bytes: number of bytes to complete
> - *
> - * Description:
> - *     Ends I/O on a number of bytes attached to @rq.
> - *     If @rq has leftover, sets it up for the next range of segments.
> - *
> - * Return:
> - *     %0 - we are done with this request
> - *     %1 - still buffers pending for this request
> - **/
> -int blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
> -{
> -	return blk_end_io(rq, error, nr_bytes, 0);
> -}
> -EXPORT_SYMBOL_GPL(blk_end_request);
> -
> -/**
> - * __blk_end_request - Helper function for drivers to complete the request.
> - * @rq:       the request being processed
> - * @error:    %0 for success, < %0 for error
> - * @nr_bytes: number of bytes to complete
> - *
> - * Description:
> - *     Must be called with queue lock held unlike blk_end_request().
> - *
> - * Return:
> - *     %0 - we are done with this request
> - *     %1 - still buffers pending for this request
> - **/
> -int __blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
> -{
> -	if (rq->bio && __end_that_request_first(rq, error, nr_bytes))
> -		return 1;
> +	/* Bidi request must be completed as a whole */
> +	if (unlikely(blk_bidi_rq(rq)) &&
> +	    blk_update_request(rq->next_rq, error, bidi_bytes))
> +		return true;
>  
>  	add_disk_randomness(rq->rq_disk);
>  
> -	end_that_request_last(rq, error);
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(__blk_end_request);
> -
> -/**
> - * blk_end_bidi_request - Helper function for drivers to complete bidi request.
> - * @rq:         the bidi request being processed
> - * @error:      %0 for success, < %0 for error
> - * @nr_bytes:   number of bytes to complete @rq
> - * @bidi_bytes: number of bytes to complete @rq->next_rq
> - *
> - * Description:
> - *     Ends I/O on a number of bytes attached to @rq and @rq->next_rq.
> - *
> - * Return:
> - *     %0 - we are done with this request
> - *     %1 - still buffers pending for this request
> - **/
> -int blk_end_bidi_request(struct request *rq, int error, unsigned int nr_bytes,
> -			 unsigned int bidi_bytes)
> -{
> -	return blk_end_io(rq, error, nr_bytes, bidi_bytes);
> -}
> -EXPORT_SYMBOL_GPL(blk_end_bidi_request);
> -
> -/**
> - * end_request - end I/O on the current segment of the request
> - * @req:	the request being processed
> - * @uptodate:	error value or %0/%1 uptodate flag
> - *
> - * Description:
> - *     Ends I/O on the current segment of a request. If that is the only
> - *     remaining segment, the request is also completed and freed.
> - *
> - *     This is a remnant of how older block drivers handled I/O completions.
> - *     Modern drivers typically end I/O on the full request in one go, unless
> - *     they have a residual value to account for. For that case this function
> - *     isn't really useful, unless the residual just happens to be the
> - *     full current segment. In other words, don't use this function in new
> - *     code. Use blk_end_request() or __blk_end_request() to end a request.
> - **/
> -void end_request(struct request *req, int uptodate)
> -{
> -	int error = 0;
> -
> -	if (uptodate <= 0)
> -		error = uptodate ? uptodate : -EIO;
> -
> -	__blk_end_request(req, error, req->hard_cur_sectors << 9);
> -}
> -EXPORT_SYMBOL(end_request);
> +	if (!locked) {
> +		spin_lock_irqsave(q->queue_lock, flags);
> +		finish_request(rq, error);
> +		spin_unlock_irqrestore(q->queue_lock, flags);
> +	} else
> +		finish_request(rq, error);
>  
> -/**
> - * blk_update_request - Special helper function for request stacking drivers
> - * @rq:           the request being processed
> - * @error:        %0 for success, < %0 for error
> - * @nr_bytes:     number of bytes to complete @rq
> - *
> - * Description:
> - *     Ends I/O on a number of bytes attached to @rq, but doesn't complete
> - *     the request structure even if @rq doesn't have leftover.
> - *     If @rq has leftover, sets it up for the next range of segments.
> - *
> - *     This special helper function is only for request stacking drivers
> - *     (e.g. request-based dm) so that they can handle partial completion.
> - *     Actual device drivers should use blk_end_request instead.
> - */
> -void blk_update_request(struct request *rq, int error, unsigned int nr_bytes)
> -{
> -	if (!end_that_request_data(rq, error, nr_bytes, 0)) {
> -		/*
> -		 * These members are not updated in end_that_request_data()
> -		 * when all bios are completed.
> -		 * Update them so that the request stacking driver can find
> -		 * how many bytes remain in the request later.
> -		 */
> -		rq->nr_sectors = rq->hard_nr_sectors = 0;
> -		rq->current_nr_sectors = rq->hard_cur_sectors = 0;
> -	}
> +	return false;
>  }
> -EXPORT_SYMBOL_GPL(blk_update_request);
> +EXPORT_SYMBOL_GPL(__blk_end_io);
>  
>  void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
>  		     struct bio *bio)
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index e8175c8..cb2f9ae 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -818,27 +818,117 @@ extern unsigned int blk_rq_bytes(struct request *rq);
>  extern unsigned int blk_rq_cur_bytes(struct request *rq);
>  
>  /*
> - * blk_end_request() and friends.
> - * __blk_end_request() and end_request() must be called with
> - * the request queue spinlock acquired.
> + * Request completion related functions.
> + *
> + * blk_update_request() completes given number of bytes and updates
> + * the request without completing it.
> + *
> + * blk_end_request() and friends.  __blk_end_request() and
> + * end_request() must be called with the request queue spinlock
> + * acquired.
>   *
>   * Several drivers define their own end_request and call
>   * blk_end_request() for parts of the original function.
>   * This prevents code duplication in drivers.
>   */
> -extern int blk_end_request(struct request *rq, int error,
> -				unsigned int nr_bytes);
> -extern int __blk_end_request(struct request *rq, int error,
> -				unsigned int nr_bytes);
> -extern int blk_end_bidi_request(struct request *rq, int error,
> -				unsigned int nr_bytes, unsigned int bidi_bytes);
> -extern void end_request(struct request *, int);
> +extern bool blk_update_request(struct request *rq, int error,
> +			       unsigned int nr_bytes);
> +
> +/* internal function, subject to change, don't ever use directly */
> +extern bool __blk_end_io(struct request *rq, int error,
> +			 unsigned int nr_bytes, unsigned int bidi_bytes,
> +			 bool locked);
> +
> +/**
> + * blk_end_request - Helper function for drivers to complete the request.
> + * @rq:       the request being processed
> + * @error:    %0 for success, < %0 for error
> + * @nr_bytes: number of bytes to complete
> + *
> + * Description:
> + *     Ends I/O on a number of bytes attached to @rq.
> + *     If @rq has leftover, sets it up for the next range of segments.
> + *
> + * Return:
> + *     %false - we are done with this request
> + *     %true  - still buffers pending for this request
> + **/
> +static inline bool blk_end_request(struct request *rq, int error,
> +				   unsigned int nr_bytes)
> +{
> +	return __blk_end_io(rq, error, nr_bytes, 0, false);
> +}
> +
> +/**
> + * __blk_end_request - Helper function for drivers to complete the request.
> + * @rq:       the request being processed
> + * @error:    %0 for success, < %0 for error
> + * @nr_bytes: number of bytes to complete
> + *
> + * Description:
> + *     Must be called with queue lock held unlike blk_end_request().
> + *
> + * Return:
> + *     %false - we are done with this request
> + *     %true  - still buffers pending for this request
> + **/
> +static inline bool __blk_end_request(struct request *rq, int error,
> +				     unsigned int nr_bytes)
> +{
> +	return __blk_end_io(rq, error, nr_bytes, 0, true);
> +}
> +
> +/**
> + * blk_end_bidi_request - Helper function for drivers to complete bidi request.
> + * @rq:         the bidi request being processed
> + * @error:      %0 for success, < %0 for error
> + * @nr_bytes:   number of bytes to complete @rq
> + * @bidi_bytes: number of bytes to complete @rq->next_rq
> + *
> + * Description:
> + *     Ends I/O on a number of bytes attached to @rq and @rq->next_rq.

+ *     Drivers that supports bidi can safely call this member for any type
+ *     of request, bidi or uni. In the later case @bidi_bytes is just
+ *     ignored.

Please add some comment like above, the subject arose a few times before
where programmers thought they need to do an if() and call this or above
blk_end_request.

(I have such a documentation change in my Q)
> + *
> + * Return:
> + *     %false - we are done with this request
> + *     %true  - still buffers pending for this request
> + **/
> +static inline bool blk_end_bidi_request(struct request *rq, int error,
> +					unsigned int nr_bytes,
> +					unsigned int bidi_bytes)
> +{
> +	return __blk_end_io(rq, error, nr_bytes, bidi_bytes, false);
> +}
> +
> +/**
> + * end_request - end I/O on the current segment of the request
> + * @rq:		the request being processed
> + * @uptodate:	error value or %0/%1 uptodate flag
> + *
> + * Description:
> + *     Ends I/O on the current segment of a request. If that is the only
> + *     remaining segment, the request is also completed and freed.
> + *
> + *     This is a remnant of how older block drivers handled I/O completions.
> + *     Modern drivers typically end I/O on the full request in one go, unless
> + *     they have a residual value to account for. For that case this function
> + *     isn't really useful, unless the residual just happens to be the
> + *     full current segment. In other words, don't use this function in new
> + *     code. Use blk_end_request() or __blk_end_request() to end a request.
> + **/
> +static inline void end_request(struct request *rq, int uptodate)
> +{
> +	int error = 0;
> +
> +	if (uptodate <= 0)
> +		error = uptodate ? uptodate : -EIO;
> +
> +	__blk_end_io(rq, error, rq->hard_cur_sectors << 9, 0, true);
> +}
> +
>  extern void blk_complete_request(struct request *);
>  extern void __blk_complete_request(struct request *);
>  extern void blk_abort_request(struct request *);
>  extern void blk_abort_queue(struct request_queue *);
> -extern void blk_update_request(struct request *rq, int error,
> -			       unsigned int nr_bytes);
>  
>  /*
>   * Access functions for manipulating queue properties

