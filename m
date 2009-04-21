Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbZDUQkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbZDUQkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbZDUQiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:38:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:40118 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960AbZDUQiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:38:15 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/14] block: reorder request completion functions
Date: Wed, 22 Apr 2009 01:37:53 +0900
Message-Id: <1240331881-28218-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240331881-28218-1-git-send-email-tj@kernel.org>
References: <1240331881-28218-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 16:38:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder request completion functions such that

* All request completion functions are located together.

* Functions which are used by only one caller is put right above the
  caller.

* end_request() is put after other completion functions but before
  blk_update_request().

This change is for completion function cleanup which will follow.

[ Impact: cleanup, code reorganization ]

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c       |  144 ++++++++++++++++++++++++------------------------
 include/linux/blkdev.h |   16 +++---
 2 files changed, 80 insertions(+), 80 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c632e6d..08f09c5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1682,6 +1682,35 @@ static void blk_account_io_done(struct request *req)
 }
 
 /**
+ * blk_rq_bytes - Returns bytes left to complete in the entire request
+ * @rq: the request being processed
+ **/
+unsigned int blk_rq_bytes(struct request *rq)
+{
+	if (blk_fs_request(rq))
+		return rq->hard_nr_sectors << 9;
+
+	return rq->data_len;
+}
+EXPORT_SYMBOL_GPL(blk_rq_bytes);
+
+/**
+ * blk_rq_cur_bytes - Returns bytes left to complete in the current segment
+ * @rq: the request being processed
+ **/
+unsigned int blk_rq_cur_bytes(struct request *rq)
+{
+	if (blk_fs_request(rq))
+		return rq->current_nr_sectors << 9;
+
+	if (rq->bio)
+		return rq->bio->bi_size;
+
+	return rq->data_len;
+}
+EXPORT_SYMBOL_GPL(blk_rq_cur_bytes);
+
+/**
  * __end_that_request_first - end I/O on a request
  * @req:      the request being processed
  * @error:    %0 for success, < %0 for error
@@ -1795,6 +1824,22 @@ static int __end_that_request_first(struct request *req, int error,
 	return 1;
 }
 
+static int end_that_request_data(struct request *rq, int error,
+				 unsigned int nr_bytes, unsigned int bidi_bytes)
+{
+	if (rq->bio) {
+		if (__end_that_request_first(rq, error, nr_bytes))
+			return 1;
+
+		/* Bidi request must be completed as a whole */
+		if (blk_bidi_rq(rq) &&
+		    __end_that_request_first(rq->next_rq, error, bidi_bytes))
+			return 1;
+	}
+
+	return 0;
+}
+
 /*
  * queue lock must be held
  */
@@ -1824,78 +1869,6 @@ static void end_that_request_last(struct request *req, int error)
 }
 
 /**
- * blk_rq_bytes - Returns bytes left to complete in the entire request
- * @rq: the request being processed
- **/
-unsigned int blk_rq_bytes(struct request *rq)
-{
-	if (blk_fs_request(rq))
-		return rq->hard_nr_sectors << 9;
-
-	return rq->data_len;
-}
-EXPORT_SYMBOL_GPL(blk_rq_bytes);
-
-/**
- * blk_rq_cur_bytes - Returns bytes left to complete in the current segment
- * @rq: the request being processed
- **/
-unsigned int blk_rq_cur_bytes(struct request *rq)
-{
-	if (blk_fs_request(rq))
-		return rq->current_nr_sectors << 9;
-
-	if (rq->bio)
-		return rq->bio->bi_size;
-
-	return rq->data_len;
-}
-EXPORT_SYMBOL_GPL(blk_rq_cur_bytes);
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
- **/
-void end_request(struct request *req, int uptodate)
-{
-	int error = 0;
-
-	if (uptodate <= 0)
-		error = uptodate ? uptodate : -EIO;
-
-	__blk_end_request(req, error, req->hard_cur_sectors << 9);
-}
-EXPORT_SYMBOL(end_request);
-
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
-
-	return 0;
-}
-
-/**
  * blk_end_io - Generic end_io function to complete a request.
  * @rq:           the request being processed
  * @error:        %0 for success, < %0 for error
@@ -2005,6 +1978,33 @@ int blk_end_bidi_request(struct request *rq, int error, unsigned int nr_bytes,
 EXPORT_SYMBOL_GPL(blk_end_bidi_request);
 
 /**
+ * end_request - end I/O on the current segment of the request
+ * @req:	the request being processed
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
+void end_request(struct request *req, int uptodate)
+{
+	int error = 0;
+
+	if (uptodate <= 0)
+		error = uptodate ? uptodate : -EIO;
+
+	__blk_end_request(req, error, req->hard_cur_sectors << 9);
+}
+EXPORT_SYMBOL(end_request);
+
+/**
  * blk_update_request - Special helper function for request stacking drivers
  * @rq:           the request being processed
  * @error:        %0 for success, < %0 for error
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6e03aef..8d12dba 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -829,6 +829,14 @@ static inline void blk_run_address_space(struct address_space *mapping)
 extern void blkdev_dequeue_request(struct request *req);
 
 /*
+ * blk_end_request() takes bytes instead of sectors as a complete size.
+ * blk_rq_bytes() returns bytes left to complete in the entire request.
+ * blk_rq_cur_bytes() returns bytes left to complete in the current segment.
+ */
+extern unsigned int blk_rq_bytes(struct request *rq);
+extern unsigned int blk_rq_cur_bytes(struct request *rq);
+
+/*
  * blk_end_request() and friends.
  * __blk_end_request() and end_request() must be called with
  * the request queue spinlock acquired.
@@ -855,14 +863,6 @@ extern void blk_update_request(struct request *rq, int error,
 			       unsigned int nr_bytes);
 
 /*
- * blk_end_request() takes bytes instead of sectors as a complete size.
- * blk_rq_bytes() returns bytes left to complete in the entire request.
- * blk_rq_cur_bytes() returns bytes left to complete in the current segment.
- */
-extern unsigned int blk_rq_bytes(struct request *rq);
-extern unsigned int blk_rq_cur_bytes(struct request *rq);
-
-/*
  * Access functions for manipulating queue properties
  */
 extern struct request_queue *blk_init_queue_node(request_fn_proc *rfn,
-- 
1.6.0.2

