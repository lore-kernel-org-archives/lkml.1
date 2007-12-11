Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbXLKWm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbXLKWm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbXLKWmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:42:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbXLKWmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:42:10 -0500
Date: Tue, 11 Dec 2007 17:41:17 -0500 (EST)
Message-Id: <20071211.174117.32341968.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 02/30] blk_end_request: add/export functions to get request
 size (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds/exports functions to get the size of request in bytes.
They are useful because blk_end_request interfaces take bytes
as a completed I/O size instead of sectors.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c      |   25 ++++++++++++++++++++++---
 include/linux/blkdev.h |    8 ++++++++
 2 files changed, 30 insertions(+), 3 deletions(-)

Index: 2.6.24-rc4/include/linux/blkdev.h
===================================================================
--- 2.6.24-rc4.orig/include/linux/blkdev.h
+++ 2.6.24-rc4/include/linux/blkdev.h
@@ -739,6 +739,14 @@ extern void end_dequeued_request(struct 
 extern void blk_complete_request(struct request *);
 
 /*
+ * blk_end_request() takes bytes instead of sectors as a complete size.
+ * blk_rq_bytes() returns bytes left to complete in the entire request.
+ * blk_rq_cur_bytes() returns bytes left to complete in the current segment.
+ */
+extern unsigned int blk_rq_bytes(struct request *rq);
+extern unsigned int blk_rq_cur_bytes(struct request *rq);
+
+/*
  * end_that_request_first/chunk() takes an uptodate argument. we account
  * any value <= as an io error. 0 means -EIO for compatability reasons,
  * any other < 0 value is the direct error type. An uptodate value of
Index: 2.6.24-rc4/block/ll_rw_blk.c
===================================================================
--- 2.6.24-rc4.orig/block/ll_rw_blk.c
+++ 2.6.24-rc4/block/ll_rw_blk.c
@@ -3701,13 +3701,32 @@ static inline void __end_request(struct 
 	}
 }
 
-static unsigned int rq_byte_size(struct request *rq)
+/**
+ * blk_rq_bytes - Returns bytes left to complete in the entire request
+ **/
+unsigned int blk_rq_bytes(struct request *rq)
 {
 	if (blk_fs_request(rq))
 		return rq->hard_nr_sectors << 9;
 
 	return rq->data_len;
 }
+EXPORT_SYMBOL_GPL(blk_rq_bytes);
+
+/**
+ * blk_rq_cur_bytes - Returns bytes left to complete in the current segment
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
 
 /**
  * end_queued_request - end all I/O on a queued request
@@ -3722,7 +3741,7 @@ static unsigned int rq_byte_size(struct 
  **/
 void end_queued_request(struct request *rq, int uptodate)
 {
-	__end_request(rq, uptodate, rq_byte_size(rq), 1);
+	__end_request(rq, uptodate, blk_rq_bytes(rq), 1);
 }
 EXPORT_SYMBOL(end_queued_request);
 
@@ -3739,7 +3758,7 @@ EXPORT_SYMBOL(end_queued_request);
  **/
 void end_dequeued_request(struct request *rq, int uptodate)
 {
-	__end_request(rq, uptodate, rq_byte_size(rq), 0);
+	__end_request(rq, uptodate, blk_rq_bytes(rq), 0);
 }
 EXPORT_SYMBOL(end_dequeued_request);
 
