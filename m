Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbZEYHit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbZEYHit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758213AbZEYHea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:34:30 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38677 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbZEYHbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:31:13 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 10/13] block: add function for waiting for a specific free tag
Date: Mon, 25 May 2009 09:31:02 +0200
Message-Id: <1243236668-3398-20-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need this in libata to ensure that we don't race between internal
tag usage and the block layer usage.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-tag.c           |   99 ++++++++++++++++++++++++++++++++-------------
 drivers/ata/libata-core.c |   29 +++++++++----
 include/linux/blkdev.h    |    3 +
 3 files changed, 95 insertions(+), 36 deletions(-)

diff --git a/block/blk-tag.c b/block/blk-tag.c
index e9a7501..208468b 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -149,6 +149,7 @@ static struct blk_queue_tag *__blk_queue_init_tags(struct request_queue *q,
 		goto fail;
 
 	atomic_set(&tags->refcnt, 1);
+	init_waitqueue_head(&tags->waitq);
 	return tags;
 fail:
 	kfree(tags);
@@ -264,6 +265,65 @@ int blk_queue_resize_tags(struct request_queue *q, int new_depth)
 }
 EXPORT_SYMBOL(blk_queue_resize_tags);
 
+void blk_queue_acquire_tag(struct request_queue *q, int tag)
+{
+	struct blk_queue_tag *bqt;
+
+	if (!blk_queue_tagged(q) || !q->queue_tags)
+		return;
+
+	bqt = q->queue_tags;
+	do {
+		DEFINE_WAIT(wait);
+
+		if (!test_and_set_bit_lock(tag, bqt->tag_map))
+			break;
+
+		prepare_to_wait(&bqt->waitq, &wait, TASK_UNINTERRUPTIBLE);
+		if (test_and_set_bit_lock(tag, bqt->tag_map)) {
+			spin_unlock_irq(q->queue_lock);
+			schedule();
+			spin_lock_irq(q->queue_lock);
+		}
+		finish_wait(&bqt->waitq, &wait);
+	} while (1);
+}
+
+void blk_queue_release_tag(struct request_queue *q, int tag)
+{
+	struct blk_queue_tag *bqt = q->queue_tags;
+
+	if (!blk_queue_tagged(q))
+		return;
+
+	/*
+	 * Normally we store a request pointer in the tag index, but for
+	 * blk_queue_acquire_tag() usage, we may not have something specific
+	 * assigned to the tag slot. In any case, be safe and clear it.
+	 */
+	bqt->tag_index[tag] = NULL;
+
+	if (unlikely(!test_bit(tag, bqt->tag_map))) {
+		printk(KERN_ERR "%s: attempt to clear non-busy tag (%d)\n",
+		       __func__, tag);
+		return;
+	}
+	/*
+	 * The tag_map bit acts as a lock for tag_index[bit], so we need
+	 * unlock memory barrier semantics.
+	 */
+	clear_bit_unlock(tag, bqt->tag_map);
+
+	/*
+	 * We don't need a memory barrier here, since we have the bit lock
+	 * ordering above. Otherwise it would need an smp_mb();
+	 */
+	if (waitqueue_active(&bqt->waitq))
+		wake_up(&bqt->waitq);
+
+}
+EXPORT_SYMBOL(blk_queue_release_tag);
+
 /**
  * blk_queue_end_tag - end tag operations for a request
  * @q:  the request queue for the device
@@ -285,33 +345,17 @@ void blk_queue_end_tag(struct request_queue *q, struct request *rq)
 
 	BUG_ON(tag == -1);
 
-	if (unlikely(tag >= bqt->real_max_depth))
-		/*
-		 * This can happen after tag depth has been reduced.
-		 * FIXME: how about a warning or info message here?
-		 */
-		return;
-
-	list_del_init(&rq->queuelist);
-	rq->cmd_flags &= ~REQ_QUEUED;
-	rq->tag = -1;
-
-	if (unlikely(bqt->tag_index[tag] == NULL))
-		printk(KERN_ERR "%s: tag %d is missing\n",
-		       __func__, tag);
-
-	bqt->tag_index[tag] = NULL;
-
-	if (unlikely(!test_bit(tag, bqt->tag_map))) {
-		printk(KERN_ERR "%s: attempt to clear non-busy tag (%d)\n",
-		       __func__, tag);
-		return;
-	}
 	/*
-	 * The tag_map bit acts as a lock for tag_index[bit], so we need
-	 * unlock memory barrier semantics.
+	 * When the tag depth is being reduced, we don't wait for higher tags
+	 * to finish. So we could see this triggering without it being an error.
 	 */
-	clear_bit_unlock(tag, bqt->tag_map);
+	if (tag < bqt->real_max_depth) {
+		list_del_init(&rq->queuelist);
+		rq->cmd_flags &= ~REQ_QUEUED;
+		rq->tag = -1;
+
+		blk_queue_release_tag(q, tag);
+	}
 }
 EXPORT_SYMBOL(blk_queue_end_tag);
 
@@ -336,8 +380,7 @@ EXPORT_SYMBOL(blk_queue_end_tag);
 int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 {
 	struct blk_queue_tag *bqt = q->queue_tags;
-	unsigned max_depth;
-	int tag;
+	int max_depth, tag;
 
 	if (unlikely((rq->cmd_flags & REQ_QUEUED))) {
 		printk(KERN_ERR
@@ -371,7 +414,7 @@ int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 	} while (test_and_set_bit_lock(tag, bqt->tag_map));
 	/*
 	 * We need lock ordering semantics given by test_and_set_bit_lock.
-	 * See blk_queue_end_tag for details.
+	 * See blk_queue_release_tag() for details.
 	 */
 
 	rq->cmd_flags |= REQ_QUEUED;
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 74c9055..5e43f2b 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -61,6 +61,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
 #include <linux/libata.h>
 #include <asm/byteorder.h>
 #include <linux/cdrom.h>
@@ -1765,15 +1766,14 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	u32 preempted_sactive, preempted_qc_active;
 	int preempted_nr_active_links;
 	DECLARE_COMPLETION_ONSTACK(wait);
-	unsigned long flags;
 	unsigned int err_mask;
 	int rc;
 
-	spin_lock_irqsave(ap->lock, flags);
+	spin_lock_irq(ap->lock);
 
 	/* no internal command while frozen */
 	if (ap->pflags & ATA_PFLAG_FROZEN) {
-		spin_unlock_irqrestore(ap->lock, flags);
+		spin_unlock_irq(ap->lock);
 		return AC_ERR_SYSTEM;
 	}
 
@@ -1789,6 +1789,16 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	else
 		tag = 0;
 
+	/*
+	 * We could be racing with the tag freeing in the block layer, so
+	 * we need to ensure that our tag is free.
+	 */
+	if (dev->sdev && dev->sdev->request_queue)
+		blk_queue_acquire_tag(dev->sdev->request_queue, tag);
+
+	/*
+	 * The tag is now ours
+	 */
 	qc = __ata_qc_from_tag(ap, tag);
 
 	qc->tag = tag;
@@ -1828,7 +1838,7 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 
 	ata_qc_issue(qc);
 
-	spin_unlock_irqrestore(ap->lock, flags);
+	spin_unlock_irq(ap->lock);
 
 	if (!timeout) {
 		if (ata_probe_timeout)
@@ -1844,7 +1854,7 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	ata_port_flush_task(ap);
 
 	if (!rc) {
-		spin_lock_irqsave(ap->lock, flags);
+		spin_lock_irq(ap->lock);
 
 		/* We're racing with irq here.  If we lose, the
 		 * following test prevents us from completing the qc
@@ -1864,7 +1874,7 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 					"qc timeout (cmd 0x%x)\n", command);
 		}
 
-		spin_unlock_irqrestore(ap->lock, flags);
+		spin_unlock_irq(ap->lock);
 	}
 
 	/* do post_internal_cmd */
@@ -1884,11 +1894,14 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	}
 
 	/* finish up */
-	spin_lock_irqsave(ap->lock, flags);
+	spin_lock_irq(ap->lock);
 
 	*tf = qc->result_tf;
 	err_mask = qc->err_mask;
 
+	if (dev->sdev && dev->sdev->request_queue)
+		blk_queue_release_tag(dev->sdev->request_queue, tag);
+
 	ata_qc_free(qc);
 	link->active_tag = preempted_tag;
 	link->sactive = preempted_sactive;
@@ -1911,7 +1924,7 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 		ata_port_probe(ap);
 	}
 
-	spin_unlock_irqrestore(ap->lock, flags);
+	spin_unlock_irq(ap->lock);
 
 	if ((err_mask & AC_ERR_TIMEOUT) && auto_timeout)
 		ata_internal_cmd_timed_out(dev, command);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ca322da..f2b6b92 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -307,6 +307,7 @@ struct blk_queue_tag {
 	int max_depth;			/* what we will send to device */
 	int real_max_depth;		/* what the array can hold */
 	atomic_t refcnt;		/* map can be shared */
+	wait_queue_head_t waitq;	/* for waiting on tags */
 };
 
 #define BLK_SCSI_MAX_CMDS	(256)
@@ -929,6 +930,8 @@ extern void blk_put_queue(struct request_queue *);
  * tag stuff
  */
 #define blk_rq_tagged(rq)		((rq)->cmd_flags & REQ_QUEUED)
+extern void blk_queue_acquire_tag(struct request_queue *, int);
+extern void blk_queue_release_tag(struct request_queue *, int);
 extern int blk_queue_start_tag(struct request_queue *, struct request *);
 extern struct request *blk_queue_find_tag(struct request_queue *, int);
 extern void blk_queue_end_tag(struct request_queue *, struct request *);
-- 
1.6.3.rc0.1.gf800

