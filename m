Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbZDWCIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbZDWCIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 22:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZDWCIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 22:08:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:46378 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbZDWCII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 22:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=WidFuNdCRCI6LSU9AddxN5L8WmSu6t4XQifDIHrvM/h53wZhB0OTc3AxffzO5kl5nR
         YA01+Os4vem9KBsV7GkFqjUkQoz2CzYv/ms5iM9TYRglMGGiBYJBYWdtHGVEXDQ9ic5Z
         R2d834OJASEJs55h5hXOexPvrXfY2WD94UbIU=
Message-ID: <49EFCD82.4050000@gmail.com>
Date: Thu, 23 Apr 2009 11:08:02 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Subject: [PATCH UPDATED 09/14] block: clean up request completion API
References: <1240331881-28218-1-git-send-email-tj@kernel.org> <1240331881-28218-10-git-send-email-tj@kernel.org> <20090421175919.GA11671@infradead.org> <49EFC360.3010109@kernel.org>
In-Reply-To: <49EFC360.3010109@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request completion has gone through several changes and became a bit
messy over the time.  Clean it up.

1. end_that_request_data() is a thin wrapper around
   end_that_request_data_first() which checks whether bio is NULL
   before doing anything and handles bidi completion.
   blk_update_request() is a thin wrapper around
   end_that_request_data() which clears nr_sectors on the last
   iteration but doesn't use the bidi completion.

   Clean it up by moving the initial bio NULL check and nr_sectors
   clearing on the last iteration into end_that_request_data() and
   renaming it to blk_update_request(), which makes blk_end_io() the
   only user of end_that_request_data().  Collapse
   end_that_request_data() into blk_end_io().

2. There are four visible completion variants - blk_end_request(),
   __blk_end_request(), blk_end_bidi_request() and end_request().
   blk_end_request() and blk_end_bidi_request() uses blk_end_request()
   as the backend but __blk_end_request() and end_request() use
   separate implementation in __blk_end_request() due to different
   locking rules.

   blk_end_bidi_request() is identical to blk_end_io().  Collapse
   blk_end_io() into blk_end_bidi_request(), separate out request
   update into internal helper blk_update_bidi_request() and add
   __blk_end_bidi_request().  Redefine [__]blk_end_request() as thin
   inline wrappers around [__]blk_end_bidi_request().

3. As the whole request issue/completion usages are about to be
   modified and audited, it's a good chance to convert completion
   functions return bool which better indicates the intended meaning
   of return values.

4. The function name end_that_request_last() is from the days when it
   was a public interface and slighly confusing.  Give it a proper
   internal name - blk_finish_request().

5. Add description explaning that blk_end_bidi_request() can be safely
   used for uni requests as suggested by Boaz Harrosh.

The only visible behavior change is from #1.  nr_sectors counts are
cleared after the final iteration no matter which function is used to
complete the request.  I couldn't find any place where the code
assumes those nr_sectors counters contain the values for the last
segment and this change is good as it makes the API much more
consistent as the end result is now same whether a request is
completed using [__]blk_end_request() alone or in combination with
blk_update_request().

API further cleaned up per Christoph's suggestion.

[ Impact: cleanup, rq->*nr_sectors always updated after req completion ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
I killed blk_end_io(), added __blk_end_bidi_request() and made others
wrappers around [__]blk_end_bidi_request().

Thanks.

 block/blk-core.c       |  230 ++++++++++++++++---------------------------------
 include/linux/blkdev.h |   94 +++++++++++++++++---
 2 files changed, 159 insertions(+), 165 deletions(-)

Index: block/block/blk-core.c
===================================================================
--- block.orig/block/blk-core.c
+++ block/block/blk-core.c
@@ -1806,25 +1806,35 @@ void elv_dequeue_request(struct request_
 }
 
 /**
- * __end_that_request_first - end I/O on a request
- * @req:      the request being processed
+ * blk_update_request - Special helper function for request stacking drivers
+ * @rq:	      the request being processed
  * @error:    %0 for success, < %0 for error
- * @nr_bytes: number of bytes to complete
+ * @nr_bytes: number of bytes to complete @rq
  *
  * Description:
- *     Ends I/O on a number of bytes attached to @req, and sets it up
- *     for the next range of segments (if any) in the cluster.
+ *     Ends I/O on a number of bytes attached to @rq, but doesn't complete
+ *     the request structure even if @rq doesn't have leftover.
+ *     If @rq has leftover, sets it up for the next range of segments.
+ *
+ *     This special helper function is only for request stacking drivers
+ *     (e.g. request-based dm) so that they can handle partial completion.
+ *     Actual device drivers should use blk_end_request instead.
+ *
+ *     Passing the result of blk_rq_bytes() as @nr_bytes guarantees
+ *     %false return from this function.
  *
  * Return:
- *     %0 - we are done with this request, call end_that_request_last()
- *     %1 - still buffers pending for this request
+ *     %false - this request doesn't have any more data
+ *     %true  - this request has more data
  **/
-static int __end_that_request_first(struct request *req, int error,
-				    int nr_bytes)
+bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 {
 	int total_bytes, bio_nbytes, next_idx = 0;
 	struct bio *bio;
 
+	if (!req->bio)
+		return false;
+
 	trace_block_rq_complete(req->q, req);
 
 	/*
@@ -1901,8 +1911,16 @@ static int __end_that_request_first(stru
 	/*
 	 * completely done
 	 */
-	if (!req->bio)
-		return 0;
+	if (!req->bio) {
+		/*
+		 * Reset counters so that the request stacking driver
+		 * can find how many bytes remain in the request
+		 * later.
+		 */
+		req->nr_sectors = req->hard_nr_sectors = 0;
+		req->current_nr_sectors = req->hard_cur_sectors = 0;
+		return false;
+	}
 
 	/*
 	 * if the request wasn't completed, update state
@@ -1916,29 +1934,31 @@ static int __end_that_request_first(stru
 
 	blk_recalc_rq_sectors(req, total_bytes >> 9);
 	blk_recalc_rq_segments(req);
-	return 1;
+	return true;
 }
+EXPORT_SYMBOL_GPL(blk_update_request);
 
-static int end_that_request_data(struct request *rq, int error,
-				 unsigned int nr_bytes, unsigned int bidi_bytes)
-{
-	if (rq->bio) {
-		if (__end_that_request_first(rq, error, nr_bytes))
-			return 1;
-
-		/* Bidi request must be completed as a whole */
-		if (blk_bidi_rq(rq) &&
-		    __end_that_request_first(rq->next_rq, error, bidi_bytes))
-			return 1;
-	}
+static bool blk_update_bidi_request(struct request *rq, int error,
+				    unsigned int nr_bytes,
+				    unsigned int bidi_bytes)
+{
+	if (blk_update_request(rq, error, nr_bytes))
+		return true;
+
+	/* Bidi request must be completed as a whole */
+	if (unlikely(blk_bidi_rq(rq)) &&
+	    blk_update_request(rq->next_rq, error, bidi_bytes))
+		return true;
 
-	return 0;
+	add_disk_randomness(rq->rq_disk);
+
+	return false;
 }
 
 /*
  * queue lock must be held
  */
-static void end_that_request_last(struct request *req, int error)
+static void blk_finish_request(struct request *req, int error)
 {
 	if (blk_rq_tagged(req))
 		blk_queue_end_tag(req->q, req);
@@ -1964,161 +1984,65 @@ static void end_that_request_last(struct
 }
 
 /**
- * blk_end_io - Generic end_io function to complete a request.
- * @rq:           the request being processed
- * @error:        %0 for success, < %0 for error
- * @nr_bytes:     number of bytes to complete @rq
- * @bidi_bytes:   number of bytes to complete @rq->next_rq
+ * blk_end_bidi_request - Complete a bidi request
+ * @rq:         the request to complete
+ * @error:      %0 for success, < %0 for error
+ * @nr_bytes:   number of bytes to complete @rq
+ * @bidi_bytes: number of bytes to complete @rq->next_rq
  *
  * Description:
  *     Ends I/O on a number of bytes attached to @rq and @rq->next_rq.
- *     If @rq has leftover, sets it up for the next range of segments.
+ *     Drivers that supports bidi can safely call this member for any
+ *     type of request, bidi or uni.  In the later case @bidi_bytes is
+ *     just ignored.
  *
  * Return:
- *     %0 - we are done with this request
- *     %1 - this request is not freed yet, it still has pending buffers.
+ *     %false - we are done with this request
+ *     %true  - still buffers pending for this request
  **/
-static int blk_end_io(struct request *rq, int error, unsigned int nr_bytes,
-		      unsigned int bidi_bytes)
+bool blk_end_bidi_request(struct request *rq, int error,
+			  unsigned int nr_bytes, unsigned int bidi_bytes)
 {
 	struct request_queue *q = rq->q;
-	unsigned long flags = 0UL;
+	unsigned long flags;
 
-	if (end_that_request_data(rq, error, nr_bytes, bidi_bytes))
-		return 1;
-
-	add_disk_randomness(rq->rq_disk);
+	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes))
+		return true;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	end_that_request_last(rq, error);
+	blk_finish_request(rq, error);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	return 0;
-}
-
-/**
- * blk_end_request - Helper function for drivers to complete the request.
- * @rq:       the request being processed
- * @error:    %0 for success, < %0 for error
- * @nr_bytes: number of bytes to complete
- *
- * Description:
- *     Ends I/O on a number of bytes attached to @rq.
- *     If @rq has leftover, sets it up for the next range of segments.
- *
- * Return:
- *     %0 - we are done with this request
- *     %1 - still buffers pending for this request
- **/
-int blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
-{
-	return blk_end_io(rq, error, nr_bytes, 0);
+	return false;
 }
-EXPORT_SYMBOL_GPL(blk_end_request);
-
-/**
- * __blk_end_request - Helper function for drivers to complete the request.
- * @rq:       the request being processed
- * @error:    %0 for success, < %0 for error
- * @nr_bytes: number of bytes to complete
- *
- * Description:
- *     Must be called with queue lock held unlike blk_end_request().
- *
- * Return:
- *     %0 - we are done with this request
- *     %1 - still buffers pending for this request
- **/
-int __blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
-{
-	if (rq->bio && __end_that_request_first(rq, error, nr_bytes))
-		return 1;
-
-	add_disk_randomness(rq->rq_disk);
-
-	end_that_request_last(rq, error);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(__blk_end_request);
+EXPORT_SYMBOL_GPL(blk_end_bidi_request);
 
 /**
- * blk_end_bidi_request - Helper function for drivers to complete bidi request.
- * @rq:         the bidi request being processed
+ * __blk_end_bidi_request - Complete a bidi request with queue lock held
+ * @rq:         the request to complete
  * @error:      %0 for success, < %0 for error
  * @nr_bytes:   number of bytes to complete @rq
  * @bidi_bytes: number of bytes to complete @rq->next_rq
  *
  * Description:
- *     Ends I/O on a number of bytes attached to @rq and @rq->next_rq.
+ *     Identical to blk_end_bidi_request() except that queue lock is
+ *     assumed to be locked on entry and remains so on return.
  *
  * Return:
- *     %0 - we are done with this request
- *     %1 - still buffers pending for this request
- **/
-int blk_end_bidi_request(struct request *rq, int error, unsigned int nr_bytes,
-			 unsigned int bidi_bytes)
-{
-	return blk_end_io(rq, error, nr_bytes, bidi_bytes);
-}
-EXPORT_SYMBOL_GPL(blk_end_bidi_request);
-
-/**
- * end_request - end I/O on the current segment of the request
- * @req:	the request being processed
- * @uptodate:	error value or %0/%1 uptodate flag
- *
- * Description:
- *     Ends I/O on the current segment of a request. If that is the only
- *     remaining segment, the request is also completed and freed.
- *
- *     This is a remnant of how older block drivers handled I/O completions.
- *     Modern drivers typically end I/O on the full request in one go, unless
- *     they have a residual value to account for. For that case this function
- *     isn't really useful, unless the residual just happens to be the
- *     full current segment. In other words, don't use this function in new
- *     code. Use blk_end_request() or __blk_end_request() to end a request.
+ *     %false - we are done with this request
+ *     %true  - still buffers pending for this request
  **/
-void end_request(struct request *req, int uptodate)
+bool __blk_end_bidi_request(struct request *rq, int error,
+			    unsigned int nr_bytes, unsigned int bidi_bytes)
 {
-	int error = 0;
-
-	if (uptodate <= 0)
-		error = uptodate ? uptodate : -EIO;
+	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes))
+		return true;
 
-	__blk_end_request(req, error, req->hard_cur_sectors << 9);
-}
-EXPORT_SYMBOL(end_request);
+	blk_finish_request(rq, error);
 
-/**
- * blk_update_request - Special helper function for request stacking drivers
- * @rq:           the request being processed
- * @error:        %0 for success, < %0 for error
- * @nr_bytes:     number of bytes to complete @rq
- *
- * Description:
- *     Ends I/O on a number of bytes attached to @rq, but doesn't complete
- *     the request structure even if @rq doesn't have leftover.
- *     If @rq has leftover, sets it up for the next range of segments.
- *
- *     This special helper function is only for request stacking drivers
- *     (e.g. request-based dm) so that they can handle partial completion.
- *     Actual device drivers should use blk_end_request instead.
- */
-void blk_update_request(struct request *rq, int error, unsigned int nr_bytes)
-{
-	if (!end_that_request_data(rq, error, nr_bytes, 0)) {
-		/*
-		 * These members are not updated in end_that_request_data()
-		 * when all bios are completed.
-		 * Update them so that the request stacking driver can find
-		 * how many bytes remain in the request later.
-		 */
-		rq->nr_sectors = rq->hard_nr_sectors = 0;
-		rq->current_nr_sectors = rq->hard_cur_sectors = 0;
-	}
+	return false;
 }
-EXPORT_SYMBOL_GPL(blk_update_request);
+EXPORT_SYMBOL_GPL(__blk_end_bidi_request);
 
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 		     struct bio *bio)
Index: block/include/linux/blkdev.h
===================================================================
--- block.orig/include/linux/blkdev.h
+++ block/include/linux/blkdev.h
@@ -837,27 +837,97 @@ extern unsigned int blk_rq_bytes(struct
 extern unsigned int blk_rq_cur_bytes(struct request *rq);
 
 /*
- * blk_end_request() and friends.
- * __blk_end_request() and end_request() must be called with
- * the request queue spinlock acquired.
+ * Request completion related functions.
+ *
+ * blk_update_request() completes given number of bytes and updates
+ * the request without completing it.
+ *
+ * blk_end_request() and friends.  __blk_end_request() and
+ * end_request() must be called with the request queue spinlock
+ * acquired.
  *
  * Several drivers define their own end_request and call
  * blk_end_request() for parts of the original function.
  * This prevents code duplication in drivers.
  */
-extern int blk_end_request(struct request *rq, int error,
-				unsigned int nr_bytes);
-extern int __blk_end_request(struct request *rq, int error,
-				unsigned int nr_bytes);
-extern int blk_end_bidi_request(struct request *rq, int error,
-				unsigned int nr_bytes, unsigned int bidi_bytes);
-extern void end_request(struct request *, int);
+extern bool blk_update_request(struct request *rq, int error,
+			       unsigned int nr_bytes);
+extern bool blk_end_bidi_request(struct request *rq, int error,
+				 unsigned int nr_bytes,
+				 unsigned int bidi_bytes);
+extern bool __blk_end_bidi_request(struct request *rq, int error,
+				   unsigned int nr_bytes,
+				   unsigned int bidi_bytes);
+
+/**
+ * blk_end_request - Helper function for drivers to complete the request.
+ * @rq:       the request being processed
+ * @error:    %0 for success, < %0 for error
+ * @nr_bytes: number of bytes to complete
+ *
+ * Description:
+ *     Ends I/O on a number of bytes attached to @rq.
+ *     If @rq has leftover, sets it up for the next range of segments.
+ *
+ * Return:
+ *     %false - we are done with this request
+ *     %true  - still buffers pending for this request
+ **/
+static inline bool blk_end_request(struct request *rq, int error,
+				   unsigned int nr_bytes)
+{
+	return blk_end_bidi_request(rq, error, nr_bytes, 0);
+}
+
+/**
+ * __blk_end_request - Helper function for drivers to complete the request.
+ * @rq:       the request being processed
+ * @error:    %0 for success, < %0 for error
+ * @nr_bytes: number of bytes to complete
+ *
+ * Description:
+ *     Must be called with queue lock held unlike blk_end_request().
+ *
+ * Return:
+ *     %false - we are done with this request
+ *     %true  - still buffers pending for this request
+ **/
+static inline bool __blk_end_request(struct request *rq, int error,
+				     unsigned int nr_bytes)
+{
+	return __blk_end_bidi_request(rq, error, nr_bytes, 0);
+}
+
+/**
+ * end_request - end I/O on the current segment of the request
+ * @rq:		the request being processed
+ * @uptodate:	error value or %0/%1 uptodate flag
+ *
+ * Description:
+ *     Ends I/O on the current segment of a request. If that is the only
+ *     remaining segment, the request is also completed and freed.
+ *
+ *     This is a remnant of how older block drivers handled I/O completions.
+ *     Modern drivers typically end I/O on the full request in one go, unless
+ *     they have a residual value to account for. For that case this function
+ *     isn't really useful, unless the residual just happens to be the
+ *     full current segment. In other words, don't use this function in new
+ *     code. Use blk_end_request() or __blk_end_request() to end a request.
+ **/
+static inline void end_request(struct request *rq, int uptodate)
+{
+	int error = 0;
+
+	if (uptodate <= 0)
+		error = uptodate ? uptodate : -EIO;
+
+	__blk_end_bidi_request(rq, error, rq->hard_cur_sectors << 9, 0);
+}
+
 extern void blk_complete_request(struct request *);
 extern void __blk_complete_request(struct request *);
 extern void blk_abort_request(struct request *);
 extern void blk_abort_queue(struct request_queue *);
-extern void blk_update_request(struct request *rq, int error,
-			       unsigned int nr_bytes);
 
 /*
  * Access functions for manipulating queue properties
