Return-Path: <linux-kernel-owner+w=401wt.eu-S1763224AbYAKVwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763224AbYAKVwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761709AbYAKVwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:52:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760884AbYAKVwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:52:33 -0500
Date: Fri, 11 Jan 2008 16:51:27 -0500 (EST)
Message-Id: <20080111.165127.70224812.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 3/3] block: remove end_{queued|dequeued}_request()
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes end_queued_request() and end_dequeued_request(),
which are no longer used.

As a results, users of __end_request() became only end_request().
So the actual code in __end_request() is moved to end_request()
and __end_request() is removed.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c |   57 ++++++------------------------------------------------
 1 files changed, 7 insertions(+), 50 deletions(-)

Index: 2.6.24-rc7/block/ll_rw_blk.c
===================================================================
--- 2.6.24-rc7.orig/block/ll_rw_blk.c
+++ 2.6.24-rc7/block/ll_rw_blk.c
@@ -3650,17 +3650,6 @@ static void end_that_request_last(struct
 	}
 }
 
-static inline void __end_request(struct request *rq, int uptodate,
-				 unsigned int nr_bytes)
-{
-	int error = 0;
-
-	if (uptodate <= 0)
-		error = uptodate ? uptodate : -EIO;
-
-	__blk_end_request(rq, error, nr_bytes);
-}
-
 /**
  * blk_rq_bytes - Returns bytes left to complete in the entire request
  **/
@@ -3689,41 +3678,6 @@ unsigned int blk_rq_cur_bytes(struct req
 EXPORT_SYMBOL_GPL(blk_rq_cur_bytes);
 
 /**
- * end_queued_request - end all I/O on a queued request
- * @rq:		the request being processed
- * @uptodate:	error value or 0/1 uptodate flag
- *
- * Description:
- *     Ends all I/O on a request, and removes it from the block layer queues.
- *     Not suitable for normal IO completion, unless the driver still has
- *     the request attached to the block layer.
- *
- **/
-void end_queued_request(struct request *rq, int uptodate)
-{
-	__end_request(rq, uptodate, blk_rq_bytes(rq));
-}
-EXPORT_SYMBOL(end_queued_request);
-
-/**
- * end_dequeued_request - end all I/O on a dequeued request
- * @rq:		the request being processed
- * @uptodate:	error value or 0/1 uptodate flag
- *
- * Description:
- *     Ends all I/O on a request. The request must already have been
- *     dequeued using blkdev_dequeue_request(), as is normally the case
- *     for most drivers.
- *
- **/
-void end_dequeued_request(struct request *rq, int uptodate)
-{
-	__end_request(rq, uptodate, blk_rq_bytes(rq));
-}
-EXPORT_SYMBOL(end_dequeued_request);
-
-
-/**
  * end_request - end I/O on the current segment of the request
  * @req:	the request being processed
  * @uptodate:	error value or 0/1 uptodate flag
@@ -3737,14 +3691,17 @@ EXPORT_SYMBOL(end_dequeued_request);
  *     they have a residual value to account for. For that case this function
  *     isn't really useful, unless the residual just happens to be the
  *     full current segment. In other words, don't use this function in new
- *     code. Either use end_request_completely(), or the
- *     end_that_request_chunk() (along with end_that_request_last()) for
- *     partial completions.
+ *     code. Instead, use blk_end_request() for entire or partial completion.
  *
  **/
 void end_request(struct request *req, int uptodate)
 {
-	__end_request(req, uptodate, req->hard_cur_sectors << 9);
+	int error = 0;
+
+	if (uptodate <= 0)
+		error = uptodate ? uptodate : -EIO;
+
+	__blk_end_request(req, error, req->hard_cur_sectors << 9);
 }
 EXPORT_SYMBOL(end_request);
 
