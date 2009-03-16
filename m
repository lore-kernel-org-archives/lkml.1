Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbZCPCdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbZCPCdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 22:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZCPC3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 22:29:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:44313 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbZCPC3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 22:29:21 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/17] block: kill blk_end_request_callback()
Date: Mon, 16 Mar 2009 11:28:54 +0900
Message-Id: <1237170540-19130-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237170540-19130-1-git-send-email-tj@kernel.org>
References: <1237170540-19130-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 02:29:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: removal of unused convoluted interface

With recent IDE updates, blk_end_request_callback() doesn't have any
user now.  Kill it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c       |   48 +++---------------------------------------------
 include/linux/blkdev.h |    3 ---
 2 files changed, 3 insertions(+), 48 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 0d97fbe..9595c4f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1957,10 +1957,6 @@ static void end_that_request_last(struct request *req, int error)
  * @error:        %0 for success, < %0 for error
  * @nr_bytes:     number of bytes to complete @rq
  * @bidi_bytes:   number of bytes to complete @rq->next_rq
- * @drv_callback: function called between completion of bios in the request
- *                and completion of the request.
- *                If the callback returns non %0, this helper returns without
- *                completion of the request.
  *
  * Description:
  *     Ends I/O on a number of bytes attached to @rq and @rq->next_rq.
@@ -1971,8 +1967,7 @@ static void end_that_request_last(struct request *req, int error)
  *     %1 - this request is not freed yet, it still has pending buffers.
  **/
 static int blk_end_io(struct request *rq, int error, unsigned int nr_bytes,
-		      unsigned int bidi_bytes,
-		      int (drv_callback)(struct request *))
+		      unsigned int bidi_bytes)
 {
 	struct request_queue *q = rq->q;
 	unsigned long flags = 0UL;
@@ -1980,10 +1975,6 @@ static int blk_end_io(struct request *rq, int error, unsigned int nr_bytes,
 	if (end_that_request_data(rq, error, nr_bytes, bidi_bytes))
 		return 1;
 
-	/* Special feature for tricky drivers */
-	if (drv_callback && drv_callback(rq))
-		return 1;
-
 	add_disk_randomness(rq->rq_disk);
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -2009,7 +2000,7 @@ static int blk_end_io(struct request *rq, int error, unsigned int nr_bytes,
  **/
 int blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
 {
-	return blk_end_io(rq, error, nr_bytes, 0, NULL);
+	return blk_end_io(rq, error, nr_bytes, 0);
 }
 EXPORT_SYMBOL_GPL(blk_end_request);
 
@@ -2056,7 +2047,7 @@ EXPORT_SYMBOL_GPL(__blk_end_request);
 int blk_end_bidi_request(struct request *rq, int error, unsigned int nr_bytes,
 			 unsigned int bidi_bytes)
 {
-	return blk_end_io(rq, error, nr_bytes, bidi_bytes, NULL);
+	return blk_end_io(rq, error, nr_bytes, bidi_bytes);
 }
 EXPORT_SYMBOL_GPL(blk_end_bidi_request);
 
@@ -2117,39 +2108,6 @@ void blk_update_request(struct request *rq, int error, unsigned int nr_bytes)
 }
 EXPORT_SYMBOL_GPL(blk_update_request);
 
-/**
- * blk_end_request_callback - Special helper function for tricky drivers
- * @rq:           the request being processed
- * @error:        %0 for success, < %0 for error
- * @nr_bytes:     number of bytes to complete
- * @drv_callback: function called between completion of bios in the request
- *                and completion of the request.
- *                If the callback returns non %0, this helper returns without
- *                completion of the request.
- *
- * Description:
- *     Ends I/O on a number of bytes attached to @rq.
- *     If @rq has leftover, sets it up for the next range of segments.
- *
- *     This special helper function is used only for existing tricky drivers.
- *     (e.g. cdrom_newpc_intr() of ide-cd)
- *     This interface will be removed when such drivers are rewritten.
- *     Don't use this interface in other places anymore.
- *
- * Return:
- *     %0 - we are done with this request
- *     %1 - this request is not freed yet.
- *          this request still has pending buffers or
- *          the driver doesn't want to finish this request yet.
- **/
-int blk_end_request_callback(struct request *rq, int error,
-			     unsigned int nr_bytes,
-			     int (drv_callback)(struct request *))
-{
-	return blk_end_io(rq, error, nr_bytes, 0, drv_callback);
-}
-EXPORT_SYMBOL_GPL(blk_end_request_callback);
-
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 		     struct bio *bio)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index cdfac4f..e8175c8 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -833,9 +833,6 @@ extern int __blk_end_request(struct request *rq, int error,
 extern int blk_end_bidi_request(struct request *rq, int error,
 				unsigned int nr_bytes, unsigned int bidi_bytes);
 extern void end_request(struct request *, int);
-extern int blk_end_request_callback(struct request *rq, int error,
-				unsigned int nr_bytes,
-				int (drv_callback)(struct request *));
 extern void blk_complete_request(struct request *);
 extern void __blk_complete_request(struct request *);
 extern void blk_abort_request(struct request *);
-- 
1.6.0.2

