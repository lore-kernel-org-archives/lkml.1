Return-Path: <linux-kernel-owner+w=401wt.eu-S1763112AbXK3Xgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763112AbXK3Xgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759817AbXK3Xgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:36:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759816AbXK3Xgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:36:31 -0500
Date: Fri, 30 Nov 2007 18:34:26 -0500 (EST)
Message-Id: <20071130.183426.107256509.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 25/28] blk_end_request: add callback feature (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a variant of the interface, blk_end_request_callback(),
which has driver callback feature.

There are 2 drivers which need to do special works between
end_that_request_first() and end_that_request_last():
ide-cd and scsi bidi.

For such drivers, blk_end_request_callback() allows it to pass
a callback function which is called between end_that_request_first()
and end_that_request_last().

This interface should/will be removed, after the drivers remove
such tricky behaviors.

o ide-cd (cdrom_newpc_intr())
  cdrom_newpc_intr() needs to:
    1. call post_transform_command() to modify request contents
    2. wait completing request until DRQ_STAT is cleared
  after end_that_request_first() and before end_that_request_last().

  As for the second one, ide-cd will wait for the interrupt from device.
  So end_that_request_first() and end_that_request_last() are called
  separately in ide-cd.
  This means blk_end_request_callback() has to return without
  completing request even if no leftover in the request.
  To satisfy the requirement, callback function has return value
  so that drivers can tell blk_end_request_callback() to return
  without completing request.

o scsi mid-layer for bidi request (scsi_end_bidi_request())
  Bidi sets its specific value to rq->data_len before the request is
  completed so that upper-layer can read it.
  This setting must be between end_that_request_chunk() and
  end_that_request_last(), because rq->data_len may be used
  in end_that_request_chunk() by blk_trace and so on.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c      |   50 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    3 ++
 2 files changed, 53 insertions(+)

Index: 2.6.24-rc3-mm2/block/ll_rw_blk.c
===================================================================
--- 2.6.24-rc3-mm2.orig/block/ll_rw_blk.c
+++ 2.6.24-rc3-mm2/block/ll_rw_blk.c
@@ -3850,6 +3850,56 @@ int __blk_end_request(struct request *rq
 }
 EXPORT_SYMBOL_GPL(__blk_end_request);
 
+/**
+ * blk_end_request_callback - Special helper function for tricky drivers
+ * @rq:           the request being processed
+ * @uptodate:     1 for success, 0 for I/O error, < 0 for specific error
+ * @nr_bytes:     number of bytes to complete
+ * @drv_callback: function called between completion of bios in the request
+ *                and completion of the request.
+ *                If the callback returns non 0, this helper returns without
+ *                completion of the request.
+ *
+ * Description:
+ *     Ends I/O on a number of bytes attached to @rq.
+ *     If @rq has leftover, sets it up for the next range of segments.
+ *
+ *     This special helper function is used only for existing tricky drivers.
+ *     (e.g. cdrom_newpc_intr() of ide-cd)
+ *     This interface will be removed when such drivers are rewritten.
+ *     Don't use this interface in other places anymore.
+ *
+ * Return:
+ *     0 - we are done with this request
+ *     1 - this request is not freed yet.
+ *         this request still has pending buffers or
+ *         the driver doesn't want to finish this request yet.
+ **/
+int blk_end_request_callback(struct request *rq, int uptodate, int nr_bytes,
+			     int (drv_callback)(struct request *))
+{
+	struct request_queue *q = rq->q;
+	unsigned long flags = 0UL;
+
+	if (blk_fs_request(rq) || blk_pc_request(rq)) {
+		if (__end_that_request_first(rq, uptodate, nr_bytes))
+			return 1;
+	}
+
+	/* Special feature for tricky drivers */
+	if (drv_callback && drv_callback(rq))
+		return 1;
+
+	add_disk_randomness(rq->rq_disk);
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	complete_request(rq, uptodate);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(blk_end_request_callback);
+
 static void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			    struct bio *bio)
 {
Index: 2.6.24-rc3-mm2/include/linux/blkdev.h
===================================================================
--- 2.6.24-rc3-mm2.orig/include/linux/blkdev.h
+++ 2.6.24-rc3-mm2/include/linux/blkdev.h
@@ -733,6 +733,9 @@ extern void end_that_request_last(struct
 extern void end_request(struct request *, int);
 extern void end_queued_request(struct request *, int);
 extern void end_dequeued_request(struct request *, int);
+extern int blk_end_request_callback(struct request *rq, int uptodate,
+				    int nr_bytes,
+				    int (drv_callback)(struct request *));
 extern void blk_complete_request(struct request *);
 
 /*
