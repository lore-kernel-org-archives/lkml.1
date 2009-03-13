Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbZCMFF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbZCMFF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757064AbZCMFDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:03:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:59750 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757302AbZCMFDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:03:40 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/14] block: kill blk_end_request_callback()
Date: Fri, 13 Mar 2009 14:02:52 +0900
Message-Id: <1236920578-2179-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236920578-2179-1-git-send-email-tj@kernel.org>
References: <1236920578-2179-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 05:03:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: removal of unnecessary convoluted interface

The only user of blk_end_request_callback() is cdrom_newpc_intr()
which calls it with a dummy callback to update data completion without
actually completing the request, for which blk_update_request() can be
used.

Use blk_update_request() in cdrom_newpc_intr() and kill
blk_end_request_callback().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c       |   48 +++---------------------------------------------
 drivers/ide/ide-cd.c   |   16 ++--------------
 include/linux/blkdev.h |    3 ---
 3 files changed, 5 insertions(+), 62 deletions(-)

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
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index ddfbea4..f825d50 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -748,16 +748,6 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 	return (flags & REQ_FAILED) ? -EIO : 0;
 }
 
-/*
- * Called from blk_end_request_callback() after the data of the request is
- * completed and before the request itself is completed. By returning value '1',
- * blk_end_request_callback() returns immediately without completing it.
- */
-static int cdrom_newpc_intr_dummy_cb(struct request *rq)
-{
-	return 1;
-}
-
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -932,12 +922,10 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			/*
 			 * The request can't be completed until DRQ is cleared.
 			 * So complete the data, but don't complete the request
-			 * using the dummy function for the callback feature
-			 * of blk_end_request_callback().
+			 * using blk_update_request().
 			 */
 			if (rq->bio)
-				blk_end_request_callback(rq, 0, blen,
-						 cdrom_newpc_intr_dummy_cb);
+				blk_update_request(rq, 0, blen);
 			else
 				rq->data += blen;
 		}
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

