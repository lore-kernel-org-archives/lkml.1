Return-Path: <linux-kernel-owner+w=401wt.eu-S938564AbYCSXgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938564AbYCSXgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938739AbYCSWGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:06:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939528AbYCSWGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:06:50 -0400
Date: Wed, 19 Mar 2008 18:07:06 -0500 (EST)
Message-Id: <20080319.180706.35658194.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, michaelc@cs.wisc.edu, hare@suse.de, agk@redhat.com,
       linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [RFC PATCH 01/13] block: add request update interface
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an interface to update request information so that
request stacking drivers can complete only data part of a request
without completing the request.
Request stacking drivers can use it for partial completion.

Request stacking drivers like request-based dm need to complete
clone requests from bottom to top on the device stack in that order.
If request stacking drivers use blk_end_request() to updatethe original
request during partial completion (in bio->bi_end_io() hook),
the original request will be completed before the clone request when
all bios are completed.  It breaks the ordering.

blk_update_request() just completes only data part of a request and
updates information of the request, but doesn't complete the request.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/blk-core.c       |   59 +++++++++++++++++++++++++++++++++++++++++--------
 include/linux/blkdev.h |    2 +
 2 files changed, 52 insertions(+), 9 deletions(-)

Index: 2.6.25-rc5/block/blk-core.c
===================================================================
--- 2.6.25-rc5.orig/block/blk-core.c
+++ 2.6.25-rc5/block/blk-core.c
@@ -1853,6 +1853,22 @@ void end_request(struct request *req, in
 }
 EXPORT_SYMBOL(end_request);
 
+static int end_that_request_data(struct request *rq, int error,
+				 unsigned int nr_bytes, unsigned int bidi_bytes)
+{
+	if (blk_fs_request(rq) || blk_pc_request(rq)) {
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
 /**
  * blk_end_io - Generic end_io function to complete a request.
  * @rq:           the request being processed
@@ -1879,15 +1895,8 @@ static int blk_end_io(struct request *rq
 	struct request_queue *q = rq->q;
 	unsigned long flags = 0UL;
 
-	if (blk_fs_request(rq) || blk_pc_request(rq)) {
-		if (__end_that_request_first(rq, error, nr_bytes))
-			return 1;
-
-		/* Bidi request must be completed as a whole */
-		if (blk_bidi_rq(rq) &&
-		    __end_that_request_first(rq->next_rq, error, bidi_bytes))
-			return 1;
-	}
+	if (end_that_request_data(rq, error, nr_bytes, bidi_bytes))
+		return 1;
 
 	/* Special feature for tricky drivers */
 	if (drv_callback && drv_callback(rq))
@@ -1972,6 +1981,38 @@ int blk_end_bidi_request(struct request 
 EXPORT_SYMBOL_GPL(blk_end_bidi_request);
 
 /**
+ * blk_update_request - Special helper function for request stacking drivers
+ * @rq:           the request being processed
+ * @error:        0 for success, < 0 for error
+ * @nr_bytes:     number of bytes to complete @rq
+ *
+ * Description:
+ *     Ends I/O on a number of bytes attached to @rq, but doesn't complete
+ *     the request structure even if @rq doesn't have leftover.
+ *     If @rq has leftover, sets it up for the next range of segments.
+ *
+ *     This special helper function is only for request stacking drivers
+ *     (e.g. request-based dm) so that they can handle partial completion.
+ *     Actual device drivers should use blk_end_request instead.
+ **/
+void blk_update_request(struct request *rq, int error, unsigned int nr_bytes)
+{
+	if (!end_that_request_data(rq, error, nr_bytes, 0)) {
+		/*
+		 * All bios in the request have been completed.
+		 * Then, members of the request are not updated.
+		 * Update those members to avoid double charge of diskstat
+		 * when the stacking driver calls blk_end_request()
+		 * to complete the request actually.
+		 */
+		rq->nr_sectors = rq->hard_nr_sectors = 0;
+		rq->current_nr_sectors = rq->hard_cur_sectors = 0;
+		rq->nr_phys_segments = rq->nr_hw_segments = 0;
+	}
+}
+EXPORT_SYMBOL_GPL(blk_update_request);
+
+/**
  * blk_end_request_callback - Special helper function for tricky drivers
  * @rq:           the request being processed
  * @error:        0 for success, < 0 for error
Index: 2.6.25-rc5/include/linux/blkdev.h
===================================================================
--- 2.6.25-rc5.orig/include/linux/blkdev.h
+++ 2.6.25-rc5/include/linux/blkdev.h
@@ -673,6 +673,8 @@ extern int blk_end_request_callback(stru
 				unsigned int nr_bytes,
 				int (drv_callback)(struct request *));
 extern void blk_complete_request(struct request *);
+extern void blk_update_request(struct request *rq, int error,
+			       unsigned int nr_bytes);
 
 /*
  * blk_end_request() takes bytes instead of sectors as a complete size.
