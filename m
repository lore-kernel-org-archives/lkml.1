Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbXLKWku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbXLKWku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbXLKWkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:40:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbXLKWki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:40:38 -0500
Date: Tue, 11 Dec 2007 17:40:30 -0500 (EST)
Message-Id: <20071211.174030.10291764.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 01/30] blk_end_request: add new request completion
 interface (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds 2 new interfaces for request completion:
  o blk_end_request()   : called without queue lock
  o __blk_end_request() : called with queue lock held

blk_end_request takes 'error' as an argument instead of 'uptodate',
which current end_that_request_* take.
The meanings of values are below and the value is used when bio is
completed.
    0 : success
  < 0 : error

Some device drivers call some generic functions below between
end_that_request_{first/chunk} and end_that_request_last().
  o add_disk_randomness()
  o blk_queue_end_tag()
  o blkdev_dequeue_request()
These are called in the blk_end_request interfaces as a part of
generic request completion.
So all device drivers become to call above functions.
To decide whether to call blkdev_dequeue_request(), blk_end_request
uses list_empty(&rq->queuelist) (blk_queued_rq() macro is added for it).
So drivers must re-initialize it using list_init() or so before calling
blk_end_request if drivers use it for its specific purpose.
(Currently, there is no driver which completes request without
 re-initializing the queuelist after used it.  So rq->queuelist
 can be used for the purpose above.)

"Normal" drivers can be converted to use blk_end_request()
in a standard way shown below.

 a) end_that_request_{chunk/first}
    spin_lock_irqsave()
    (add_disk_randomness(), blk_queue_end_tag(), blkdev_dequeue_request())
    end_that_request_last()
    spin_unlock_irqrestore()
    => blk_end_request()

 b) spin_lock_irqsave()
    end_that_request_{chunk/first}
    (add_disk_randomness(), blk_queue_end_tag(), blkdev_dequeue_request())
    end_that_request_last()
    spin_unlock_irqrestore()
    => spin_lock_irqsave()
       __blk_end_request()
       spin_unlock_irqsave()

 c) spin_lock_irqsave()
    (add_disk_randomness(), blk_queue_end_tag(), blkdev_dequeue_request())
    end_that_request_last()
    spin_unlock_irqrestore()
    => blk_end_request()   or   spin_lock_irqsave()
                                __blk_end_request()
                                spin_unlock_irqrestore()

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c      |   96 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    4 ++
 2 files changed, 100 insertions(+)

Index: 2.6.24-rc4/block/ll_rw_blk.c
===================================================================
--- 2.6.24-rc4.orig/block/ll_rw_blk.c
+++ 2.6.24-rc4/block/ll_rw_blk.c
@@ -3769,6 +3769,102 @@ void end_request(struct request *req, in
 }
 EXPORT_SYMBOL(end_request);
 
+static void complete_request(struct request *rq, int error)
+{
+	/*
+	 * REMOVEME: This conversion is transitional and will be removed
+	 *           when old end_that_request_* are unexported.
+	 */
+	int uptodate = 1;
+	if (error)
+		uptodate = (error == -EIO) ? 0 : error;
+
+	if (blk_rq_tagged(rq))
+		blk_queue_end_tag(rq->q, rq);
+
+	if (blk_queued_rq(rq))
+		blkdev_dequeue_request(rq);
+
+	end_that_request_last(rq, uptodate);
+}
+
+/**
+ * blk_end_request - Helper function for drivers to complete the request.
+ * @rq:       the request being processed
+ * @error:    0 for success, < 0 for error
+ * @nr_bytes: number of bytes to complete
+ *
+ * Description:
+ *     Ends I/O on a number of bytes attached to @rq.
+ *     If @rq has leftover, sets it up for the next range of segments.
+ *
+ * Return:
+ *     0 - we are done with this request
+ *     1 - still buffers pending for this request
+ **/
+int blk_end_request(struct request *rq, int error, int nr_bytes)
+{
+	struct request_queue *q = rq->q;
+	unsigned long flags = 0UL;
+	/*
+	 * REMOVEME: This conversion is transitional and will be removed
+	 *           when old end_that_request_* are unexported.
+	 */
+	int uptodate = 1;
+	if (error)
+		uptodate = (error == -EIO) ? 0 : error;
+
+	if (blk_fs_request(rq) || blk_pc_request(rq)) {
+		if (__end_that_request_first(rq, uptodate, nr_bytes))
+			return 1;
+	}
+
+	add_disk_randomness(rq->rq_disk);
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	complete_request(rq, error);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(blk_end_request);
+
+/**
+ * __blk_end_request - Helper function for drivers to complete the request.
+ * @rq:       the request being processed
+ * @error:    0 for success, < 0 for error
+ * @nr_bytes: number of bytes to complete
+ *
+ * Description:
+ *     Must be called with queue lock held unlike blk_end_request().
+ *
+ * Return:
+ *     0 - we are done with this request
+ *     1 - still buffers pending for this request
+ **/
+int __blk_end_request(struct request *rq, int error, int nr_bytes)
+{
+	/*
+	 * REMOVEME: This conversion is transitional and will be removed
+	 *           when old end_that_request_* are unexported.
+	 */
+	int uptodate = 1;
+	if (error)
+		uptodate = (error == -EIO) ? 0 : error;
+
+	if (blk_fs_request(rq) || blk_pc_request(rq)) {
+		if (__end_that_request_first(rq, uptodate, nr_bytes))
+			return 1;
+	}
+
+	add_disk_randomness(rq->rq_disk);
+
+	complete_request(rq, error);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__blk_end_request);
+
 static void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			    struct bio *bio)
 {
Index: 2.6.24-rc4/include/linux/blkdev.h
===================================================================
--- 2.6.24-rc4.orig/include/linux/blkdev.h
+++ 2.6.24-rc4/include/linux/blkdev.h
@@ -539,6 +539,8 @@ enum {
 #define blk_fua_rq(rq)		((rq)->cmd_flags & REQ_FUA)
 #define blk_bidi_rq(rq)		((rq)->next_rq != NULL)
 #define blk_empty_barrier(rq)	(blk_barrier_rq(rq) && blk_fs_request(rq) && !(rq)->hard_nr_sectors)
+/* rq->queuelist of dequeued request must be list_empty() */
+#define blk_queued_rq(rq)	(!list_empty(&(rq)->queuelist))
 
 #define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)
 
@@ -726,6 +728,8 @@ static inline void blk_run_address_space
  * for parts of the original function. This prevents
  * code duplication in drivers.
  */
+extern int blk_end_request(struct request *rq, int error, int nr_bytes);
+extern int __blk_end_request(struct request *rq, int error, int nr_bytes);
 extern int end_that_request_first(struct request *, int, int);
 extern int end_that_request_chunk(struct request *, int, int);
 extern void end_that_request_last(struct request *, int);
