Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbXLKWni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbXLKWni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbXLKWmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:42:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532AbXLKWms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:42:48 -0500
Date: Tue, 11 Dec 2007 17:41:54 -0500 (EST)
Message-Id: <20071211.174154.64804815.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 03/30] blk_end_request: changing block layer core (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts core parts of block layer to use blk_end_request
interfaces.  Related 'uptodate' arguments are converted to 'error'.

'dequeue' argument was originally introduced for end_dequeued_request(),
where no attempt should be made to dequeue the request as it's already
dequeued.
However, it's not necessary as it can be checked with
list_empty(&rq->queuelist).
(Dequeued request has empty list and queued request doesn't.)
And it has been done in blk_end_request interfaces.

As a result of this patch, end_queued_request() and
end_dequeued_request() become identical.  A future patch will merge
and rename them and change users of those functions.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c |   35 +++++++++++++++--------------------
 1 files changed, 15 insertions(+), 20 deletions(-)

Index: 2.6.24-rc4/block/ll_rw_blk.c
===================================================================
--- 2.6.24-rc4.orig/block/ll_rw_blk.c
+++ 2.6.24-rc4/block/ll_rw_blk.c
@@ -347,7 +347,6 @@ unsigned blk_ordered_req_seq(struct requ
 void blk_ordered_complete_seq(struct request_queue *q, unsigned seq, int error)
 {
 	struct request *rq;
-	int uptodate;
 
 	if (error && !q->orderr)
 		q->orderr = error;
@@ -361,15 +360,11 @@ void blk_ordered_complete_seq(struct req
 	/*
 	 * Okay, sequence complete.
 	 */
-	uptodate = 1;
-	if (q->orderr)
-		uptodate = q->orderr;
-
 	q->ordseq = 0;
 	rq = q->orig_bar_rq;
 
-	end_that_request_first(rq, uptodate, rq->hard_nr_sectors);
-	end_that_request_last(rq, uptodate);
+	if (__blk_end_request(rq, q->orderr, blk_rq_bytes(rq)))
+		BUG();
 }
 
 static void pre_flush_end_io(struct request *rq, int error)
@@ -486,9 +481,9 @@ int blk_do_ordered(struct request_queue 
 			 * ORDERED_NONE while this request is on it.
 			 */
 			blkdev_dequeue_request(rq);
-			end_that_request_first(rq, -EOPNOTSUPP,
-					       rq->hard_nr_sectors);
-			end_that_request_last(rq, -EOPNOTSUPP);
+			if (__blk_end_request(rq, -EOPNOTSUPP,
+					      blk_rq_bytes(rq)))
+				BUG();
 			*rqp = NULL;
 			return 0;
 		}
@@ -3691,14 +3686,14 @@ void end_that_request_last(struct reques
 EXPORT_SYMBOL(end_that_request_last);
 
 static inline void __end_request(struct request *rq, int uptodate,
-				 unsigned int nr_bytes, int dequeue)
+				 unsigned int nr_bytes)
 {
-	if (!end_that_request_chunk(rq, uptodate, nr_bytes)) {
-		if (dequeue)
-			blkdev_dequeue_request(rq);
-		add_disk_randomness(rq->rq_disk);
-		end_that_request_last(rq, uptodate);
-	}
+	int error = 0;
+
+	if (uptodate <= 0)
+		error = uptodate ? uptodate : -EIO;
+
+	__blk_end_request(rq, error, nr_bytes);
 }
 
 /**
@@ -3741,7 +3736,7 @@ EXPORT_SYMBOL_GPL(blk_rq_cur_bytes);
  **/
 void end_queued_request(struct request *rq, int uptodate)
 {
-	__end_request(rq, uptodate, blk_rq_bytes(rq), 1);
+	__end_request(rq, uptodate, blk_rq_bytes(rq));
 }
 EXPORT_SYMBOL(end_queued_request);
 
@@ -3758,7 +3753,7 @@ EXPORT_SYMBOL(end_queued_request);
  **/
 void end_dequeued_request(struct request *rq, int uptodate)
 {
-	__end_request(rq, uptodate, blk_rq_bytes(rq), 0);
+	__end_request(rq, uptodate, blk_rq_bytes(rq));
 }
 EXPORT_SYMBOL(end_dequeued_request);
 
@@ -3784,7 +3779,7 @@ EXPORT_SYMBOL(end_dequeued_request);
  **/
 void end_request(struct request *req, int uptodate)
 {
-	__end_request(req, uptodate, req->hard_cur_sectors << 9, 1);
+	__end_request(req, uptodate, req->hard_cur_sectors << 9);
 }
 EXPORT_SYMBOL(end_request);
 
