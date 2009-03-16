Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbZCPCel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbZCPCel (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 22:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbZCPC3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 22:29:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:44310 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627AbZCPC3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 22:29:48 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>, Russell King <rmk@arm.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Mike Miller <mike.miller@hp.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Alex Dubov <oakad@yahoo.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 14/17] block: implement and use [__]blk_end_request_all()
Date: Mon, 16 Mar 2009 11:28:57 +0900
Message-Id: <1237170540-19130-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237170540-19130-1-git-send-email-tj@kernel.org>
References: <1237170540-19130-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 02:29:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

There are many [__]blk_end_request() call sites which call it with
full request length and expect full completion.  Many of them ensure
that the request actually completes by doing BUG_ON() the return
value, which is awkward and error-prone.

This patch adds [__]blk_end_request_all() which takes @rq and @error
and fully completes the request.  BUG_ON() is added to
blk_update_request() to ensure that this actually happens.

Most conversions are simple but there are a few noteworthy ones.

* cdrom/viocd: viocd_end_request() replaced with direct calls to
  __blk_end_request_all().

* s390/block/dasd: dasd_end_request() replaced with direct calls to
  __blk_end_request_all().

* s390/char/tape_block: tapeblock_end_request() replaced with direct
  calls to blk_end_request_all().

IDE needs non-trivial changes and will be updated later.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mike Miller <mike.miller@hp.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/arm/plat-omap/mailbox.c        |   11 +++--------
 block/blk-barrier.c                 |    9 ++-------
 block/blk-core.c                    |    2 +-
 block/elevator.c                    |    2 +-
 drivers/block/cciss.c               |    3 +--
 drivers/block/cpqarray.c            |    3 +--
 drivers/block/sx8.c                 |    3 +--
 drivers/block/virtio_blk.c          |    2 +-
 drivers/block/xen-blkfront.c        |    4 +---
 drivers/cdrom/gdrom.c               |    2 +-
 drivers/cdrom/viocd.c               |   25 ++++---------------------
 drivers/memstick/core/mspro_block.c |    2 +-
 drivers/s390/block/dasd.c           |   17 ++++-------------
 drivers/s390/char/tape_block.c      |   15 ++++-----------
 drivers/scsi/scsi_lib.c             |    2 +-
 include/linux/blkdev.h              |   32 ++++++++++++++++++++++++++++++++
 16 files changed, 59 insertions(+), 75 deletions(-)

diff --git a/arch/arm/plat-omap/mailbox.c b/arch/arm/plat-omap/mailbox.c
index b52ce05..bb83e84 100644
--- a/arch/arm/plat-omap/mailbox.c
+++ b/arch/arm/plat-omap/mailbox.c
@@ -116,8 +116,7 @@ static void mbox_tx_work(struct work_struct *work)
 		}
 
 		spin_lock(q->queue_lock);
-		if (__blk_end_request(rq, 0, 0))
-			BUG();
+		__blk_end_request_all(rq, 0);
 		spin_unlock(q->queue_lock);
 	}
 }
@@ -148,10 +147,7 @@ static void mbox_rx_work(struct work_struct *work)
 			break;
 
 		msg = (mbox_msg_t) rq->data;
-
-		if (blk_end_request(rq, 0, 0))
-			BUG();
-
+		blk_end_request_all(rq, 0);
 		mbox->rxq->callback((void *)msg);
 	}
 }
@@ -261,8 +257,7 @@ omap_mbox_read(struct device *dev, struct device_attribute *attr, char *buf)
 
 		*p = (mbox_msg_t) rq->data;
 
-		if (blk_end_request(rq, 0, 0))
-			BUG();
+		blk_end_request_all(rq, 0);
 
 		if (unlikely(mbox_seq_test(mbox, *p))) {
 			pr_info("mbox: Illegal seq bit!(%08x) ignored\n", *p);
diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index f7dae57..bac1de1 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -106,10 +106,7 @@ bool blk_ordered_complete_seq(struct request_queue *q, unsigned seq, int error)
 	 */
 	q->ordseq = 0;
 	rq = q->orig_bar_rq;
-
-	if (__blk_end_request(rq, q->orderr, blk_rq_bytes(rq)))
-		BUG();
-
+	__blk_end_request_all(rq, q->orderr);
 	return true;
 }
 
@@ -252,9 +249,7 @@ bool blk_do_ordered(struct request_queue *q, struct request **rqp)
 			 * with prejudice.
 			 */
 			elv_dequeue_request(q, rq);
-			if (__blk_end_request(rq, -EOPNOTSUPP,
-					      blk_rq_bytes(rq)))
-				BUG();
+			__blk_end_request_all(rq, -EOPNOTSUPP);
 			*rqp = NULL;
 			return false;
 		}
diff --git a/block/blk-core.c b/block/blk-core.c
index 7d0ab48..f9118c0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1770,7 +1770,7 @@ struct request *elv_next_request(struct request_queue *q)
 			break;
 		} else if (ret == BLKPREP_KILL) {
 			rq->cmd_flags |= REQ_QUIET;
-			__blk_end_request(rq, -EIO, blk_rq_bytes(rq));
+			__blk_end_request_all(rq, -EIO);
 		} else {
 			printk(KERN_ERR "%s: bad return=%d\n", __func__, ret);
 			break;
diff --git a/block/elevator.c b/block/elevator.c
index fd17605..54d01b8 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -785,7 +785,7 @@ void elv_abort_queue(struct request_queue *q)
 		rq = list_entry_rq(q->queue_head.next);
 		rq->cmd_flags |= REQ_QUIET;
 		trace_block_rq_abort(q, rq);
-		__blk_end_request(rq, -EIO, blk_rq_bytes(rq));
+		__blk_end_request_all(rq, -EIO);
 	}
 }
 EXPORT_SYMBOL(elv_abort_queue);
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 5d0e135..b78339f 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1308,8 +1308,7 @@ static void cciss_softirq_done(struct request *rq)
 	printk("Done with %p\n", rq);
 #endif				/* CCISS_DEBUG */
 
-	if (blk_end_request(rq, (rq->errors == 0) ? 0 : -EIO, blk_rq_bytes(rq)))
-		BUG();
+	blk_end_request_all(rq, (rq->errors == 0) ? 0 : -EIO);
 
 	spin_lock_irqsave(&h->lock, flags);
 	cmd_free(h, cmd, 1);
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 5d39df1..473af67 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -1023,8 +1023,7 @@ static inline void complete_command(cmdlist_t *cmd, int timeout)
 				cmd->req.sg[i].size, ddir);
 
 	DBGPX(printk("Done with %p\n", rq););
-	if (__blk_end_request(rq, error, blk_rq_bytes(rq)))
-		BUG();
+	__blk_end_request_all(rq, error);
 }
 
 /*
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index a18e1ca..3ba4437 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -749,8 +749,7 @@ static inline void carm_end_request_queued(struct carm_host *host,
 	struct request *req = crq->rq;
 	int rc;
 
-	rc = __blk_end_request(req, error, blk_rq_bytes(req));
-	assert(rc == 0);
+	__blk_end_request_all(req, error);
 
 	rc = carm_put_request(host, crq);
 	assert(rc == 0);
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 5d34764..50745e6 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -62,7 +62,7 @@ static void blk_done(struct virtqueue *vq)
 			break;
 		}
 
-		__blk_end_request(vbr->req, error, blk_rq_bytes(vbr->req));
+		__blk_end_request_all(vbr->req, error);
 		list_del(&vbr->list);
 		mempool_free(vbr, vblk->pool);
 	}
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 8f90508..cd6cfe3 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -551,7 +551,6 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 
 	for (i = info->ring.rsp_cons; i != rp; i++) {
 		unsigned long id;
-		int ret;
 
 		bret = RING_GET_RESPONSE(&info->ring, i);
 		id   = bret->id;
@@ -578,8 +577,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 				dev_dbg(&info->xbdev->dev, "Bad return from blkdev data "
 					"request: %x\n", bret->status);
 
-			ret = __blk_end_request(req, error, blk_rq_bytes(req));
-			BUG_ON(ret);
+			__blk_end_request_all(req, error);
 			break;
 		default:
 			BUG();
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 2eecb77..fee9a9e 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -632,7 +632,7 @@ static void gdrom_readdisk_dma(struct work_struct *work)
 		* before handling ending the request */
 		spin_lock(&gdrom_lock);
 		list_del_init(&req->queuelist);
-		__blk_end_request(req, err, blk_rq_bytes(req));
+		__blk_end_request_all(req, err);
 	}
 	spin_unlock(&gdrom_lock);
 	kfree(read_command);
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index 1392935..cc3efa0 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -291,23 +291,6 @@ static int send_request(struct request *req)
 	return 0;
 }
 
-static void viocd_end_request(struct request *req, int error)
-{
-	int nsectors = req->hard_nr_sectors;
-
-	/*
-	 * Make sure it's fully ended, and ensure that we process
-	 * at least one sector.
-	 */
-	if (blk_pc_request(req))
-		nsectors = (req->data_len + 511) >> 9;
-	if (!nsectors)
-		nsectors = 1;
-
-	if (__blk_end_request(req, error, nsectors << 9))
-		BUG();
-}
-
 static int rwreq;
 
 static void do_viocd_request(struct request_queue *q)
@@ -316,11 +299,11 @@ static void do_viocd_request(struct request_queue *q)
 
 	while ((rwreq == 0) && ((req = elv_next_request(q)) != NULL)) {
 		if (!blk_fs_request(req))
-			viocd_end_request(req, -EIO);
+			__blk_end_request_all(req, -EIO);
 		else if (send_request(req) < 0) {
 			printk(VIOCD_KERN_WARNING
 					"unable to send message to OS/400!");
-			viocd_end_request(req, -EIO);
+			__blk_end_request_all(req, -EIO);
 		} else
 			rwreq++;
 	}
@@ -531,9 +514,9 @@ return_complete:
 					"with rc %d:0x%04X: %s\n",
 					req, event->xRc,
 					bevent->sub_result, err->msg);
-			viocd_end_request(req, -EIO);
+			__blk_end_request_all(req, -EIO);
 		} else
-			viocd_end_request(req, 0);
+			__blk_end_request_all(req, 0);
 
 		/* restart handling of incoming requests */
 		spin_unlock_irqrestore(&viocd_reqlock, flags);
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index de143de..a416346 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -826,7 +826,7 @@ static void mspro_block_submit_req(struct request_queue *q)
 
 	if (msb->eject) {
 		while ((req = elv_next_request(q)) != NULL)
-			__blk_end_request(req, -ENODEV, blk_rq_bytes(req));
+			__blk_end_request_all(req, -ENODEV);
 
 		return;
 	}
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 08c23a9..bc172ee 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -1597,15 +1597,6 @@ void dasd_block_clear_timer(struct dasd_block *block)
 }
 
 /*
- * posts the buffer_cache about a finalized request
- */
-static inline void dasd_end_request(struct request *req, int error)
-{
-	if (__blk_end_request(req, error, blk_rq_bytes(req)))
-		BUG();
-}
-
-/*
  * Process finished error recovery ccw.
  */
 static inline void __dasd_block_process_erp(struct dasd_block *block,
@@ -1659,7 +1650,7 @@ static void __dasd_process_request_queue(struct dasd_block *block)
 				      "Rejecting write request %p",
 				      req);
 			blkdev_dequeue_request(req);
-			dasd_end_request(req, -EIO);
+			__blk_end_request_all(req, -EIO);
 			continue;
 		}
 		cqr = basedev->discipline->build_cp(basedev, block, req);
@@ -1688,7 +1679,7 @@ static void __dasd_process_request_queue(struct dasd_block *block)
 				      "on request %p",
 				      PTR_ERR(cqr), req);
 			blkdev_dequeue_request(req);
-			dasd_end_request(req, -EIO);
+			__blk_end_request_all(req, -EIO);
 			continue;
 		}
 		/*
@@ -1714,7 +1705,7 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
 	status = cqr->block->base->discipline->free_cp(cqr, req);
 	if (status <= 0)
 		error = status ? status : -EIO;
-	dasd_end_request(req, error);
+	__blk_end_request_all(req, error);
 }
 
 /*
@@ -2020,7 +2011,7 @@ static void dasd_flush_request_queue(struct dasd_block *block)
 	spin_lock_irq(&block->request_queue_lock);
 	while ((req = elv_next_request(block->request_queue))) {
 		blkdev_dequeue_request(req);
-		dasd_end_request(req, -EIO);
+		__blk_end_request_all(req, -EIO);
 	}
 	spin_unlock_irq(&block->request_queue_lock);
 }
diff --git a/drivers/s390/char/tape_block.c b/drivers/s390/char/tape_block.c
index ae18baf..2736291 100644
--- a/drivers/s390/char/tape_block.c
+++ b/drivers/s390/char/tape_block.c
@@ -74,13 +74,6 @@ tapeblock_trigger_requeue(struct tape_device *device)
  * Post finished request.
  */
 static void
-tapeblock_end_request(struct request *req, int error)
-{
-	if (blk_end_request(req, error, blk_rq_bytes(req)))
-		BUG();
-}
-
-static void
 __tapeblock_end_request(struct tape_request *ccw_req, void *data)
 {
 	struct tape_device *device;
@@ -90,7 +83,7 @@ __tapeblock_end_request(struct tape_request *ccw_req, void *data)
 
 	device = ccw_req->device;
 	req = (struct request *) data;
-	tapeblock_end_request(req, (ccw_req->rc == 0) ? 0 : -EIO);
+	blk_end_request_all(req, (ccw_req->rc == 0) ? 0 : -EIO);
 	if (ccw_req->rc == 0)
 		/* Update position. */
 		device->blk_data.block_position =
@@ -118,7 +111,7 @@ tapeblock_start_request(struct tape_device *device, struct request *req)
 	ccw_req = device->discipline->bread(device, req);
 	if (IS_ERR(ccw_req)) {
 		DBF_EVENT(1, "TBLOCK: bread failed\n");
-		tapeblock_end_request(req, -EIO);
+		blk_end_request_all(req, -EIO);
 		return PTR_ERR(ccw_req);
 	}
 	ccw_req->callback = __tapeblock_end_request;
@@ -131,7 +124,7 @@ tapeblock_start_request(struct tape_device *device, struct request *req)
 		 * Start/enqueueing failed. No retries in
 		 * this case.
 		 */
-		tapeblock_end_request(req, -EIO);
+		blk_end_request_all(req, -EIO);
 		device->discipline->free_bread(ccw_req);
 	}
 
@@ -177,7 +170,7 @@ tapeblock_requeue(struct work_struct *work) {
 			DBF_EVENT(1, "TBLOCK: Rejecting write request\n");
 			blkdev_dequeue_request(req);
 			spin_unlock_irq(&device->blk_data.request_queue_lock);
-			tapeblock_end_request(req, -EIO);
+			blk_end_request_all(req, -EIO);
 			spin_lock_irq(&device->blk_data.request_queue_lock);
 			continue;
 		}
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b82ffd9..a4e84c6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1097,7 +1097,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			if (driver_byte(result) & DRIVER_SENSE)
 				scsi_print_sense("", cmd);
 		}
-		blk_end_request(req, -EIO, blk_rq_bytes(req));
+		blk_end_request_all(req, -EIO);
 		scsi_next_command(cmd);
 		break;
 	case ACTION_REPREP:
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index cb2f9ae..6ba7dbf 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -860,6 +860,22 @@ static inline bool blk_end_request(struct request *rq, int error,
 }
 
 /**
+ * blk_end_request_all - Helper function for drives to finish the request.
+ * @rq: the request to finish
+ * @err: %0 for success, < %0 for error
+ *
+ * Description:
+ *     Completely finish @rq.
+ */
+static inline void blk_end_request_all(struct request *rq, int error)
+{
+	bool pending;
+
+	pending = blk_end_request(rq, error, blk_rq_bytes(rq));
+	BUG_ON(pending);
+}
+
+/**
  * __blk_end_request - Helper function for drivers to complete the request.
  * @rq:       the request being processed
  * @error:    %0 for success, < %0 for error
@@ -879,6 +895,22 @@ static inline bool __blk_end_request(struct request *rq, int error,
 }
 
 /**
+ * __blk_end_request_all - Helper function for drives to finish the request.
+ * @rq: the request to finish
+ * @err: %0 for success, < %0 for error
+ *
+ * Description:
+ *     Completely finish @rq.  Must be called with queue lock held.
+ */
+static inline void __blk_end_request_all(struct request *rq, int error)
+{
+	bool pending;
+
+	pending = __blk_end_request(rq, error, blk_rq_bytes(rq));
+	BUG_ON(pending);
+}
+
+/**
  * blk_end_bidi_request - Helper function for drivers to complete bidi request.
  * @rq:         the bidi request being processed
  * @error:      %0 for success, < %0 for error
-- 
1.6.0.2

