Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbYGQD7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbYGQD7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 23:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYGQD7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 23:59:30 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:50778 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750942AbYGQD71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 23:59:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEAK9ffkhMRKxB/2dsb2JhbACBWq5d
Date: Wed, 16 Jul 2008 23:59:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jens Axboe <axboe@kernel.dk>, "'Peter Zijlstra'" <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH linux-next] Blktrace port to tracepoints
Message-ID: <20080717035924.GA26035@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:52:13 up 42 days,  8:33,  4 users,  load average: 0.64, 0.54,
	0.52
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port blktrace to the tracepoint infrastructure. It's just like markers, but
without the format strings. Type checking of probes and call sites is done at
probe registration. A reference count of blktrace users is kept. As soon
as it is higher than 0, the probes are connected, which means that the
branch is activated to enable the function calls and that the function
addresses are added to the list of function to call for these
tracepoints.

By the way, I think something is silly with the current blk_trace_remove logic :
if a remove is done on a running trace, a memory leak will potentially occur
because the "bt" ressource will never be freed, but the pointer will not be in
the request queue anymore. There is no attempt to fix this already existing bug
here.

This patch depends on the "Tracepoints" patch.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jens Axboe <axboe@kernel.dk>
CC: 'Peter Zijlstra' <peterz@infradead.org>
---
 block/Kconfig                |    1 
 block/blk-core.c             |   27 +++---
 block/blktrace.c             |  188 ++++++++++++++++++++++++++++++++++++++++++-
 block/elevator.c             |    5 -
 drivers/md/dm.c              |    5 -
 fs/bio.c                     |    3 
 include/linux/blktrace_api.h |  132 ------------------------------
 include/trace/block.h        |   25 +++++
 mm/bounce.c                  |    3 
 9 files changed, 235 insertions(+), 154 deletions(-)

Index: linux-2.6-lttng/include/trace/block.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/trace/block.h	2008-07-16 23:56:58.000000000 -0400
@@ -0,0 +1,25 @@
+#ifndef _TRACE_BLOCK_H
+#define _TRACE_BLOCK_H
+
+#include <linux/blkdev.h>
+#include <linux/tracepoint.h>
+
+DEFINE_TRACE(block_rq,
+	TPPROTO(struct request_queue *q, struct request *rq, u32 what),
+	TPARGS(q, rq, what));
+DEFINE_TRACE(block_bio,
+	TPPROTO(struct request_queue *q, struct bio *bio, u32 what),
+	TPARGS(q, bio, what));
+DEFINE_TRACE(block_generic,
+	TPPROTO(struct request_queue *q, struct bio *bio, int rw, u32 what),
+	TPARGS(q, bio, rw, what));
+DEFINE_TRACE(block_pdu_int,
+	TPPROTO(struct request_queue *q, u32 what, struct bio *bio,
+		unsigned int pdu),
+	TPARGS(q, what, bio, pdu));
+DEFINE_TRACE(block_remap,
+	TPPROTO(struct request_queue *q, struct bio *bio, dev_t dev,
+		sector_t from, sector_t to),
+	TPARGS(q, bio, dev, from, to));
+
+#endif
Index: linux-2.6-lttng/block/blk-core.c
===================================================================
--- linux-2.6-lttng.orig/block/blk-core.c	2008-07-16 23:56:53.000000000 -0400
+++ linux-2.6-lttng/block/blk-core.c	2008-07-16 23:56:58.000000000 -0400
@@ -30,6 +30,7 @@
 #include <linux/cpu.h>
 #include <linux/blktrace_api.h>
 #include <linux/fault-inject.h>
+#include <trace/block.h>
 
 #include "blk.h"
 
@@ -207,7 +208,7 @@ void blk_plug_device(struct request_queu
 
 	if (!queue_flag_test_and_set(QUEUE_FLAG_PLUGGED, q)) {
 		mod_timer(&q->unplug_timer, jiffies + q->unplug_delay);
-		blk_add_trace_generic(q, NULL, 0, BLK_TA_PLUG);
+		trace_block_generic(q, NULL, 0, BLK_TA_PLUG);
 	}
 }
 EXPORT_SYMBOL(blk_plug_device);
@@ -277,7 +278,7 @@ void blk_unplug_work(struct work_struct 
 	struct request_queue *q =
 		container_of(work, struct request_queue, unplug_work);
 
-	blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_IO, NULL,
+	trace_block_pdu_int(q, BLK_TA_UNPLUG_IO, NULL,
 				q->rq.count[READ] + q->rq.count[WRITE]);
 
 	q->unplug_fn(q);
@@ -287,7 +288,7 @@ void blk_unplug_timeout(unsigned long da
 {
 	struct request_queue *q = (struct request_queue *)data;
 
-	blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_TIMER, NULL,
+	trace_block_pdu_int(q, BLK_TA_UNPLUG_TIMER, NULL,
 				q->rq.count[READ] + q->rq.count[WRITE]);
 
 	kblockd_schedule_work(&q->unplug_work);
@@ -299,7 +300,7 @@ void blk_unplug(struct request_queue *q)
 	 * devices don't necessarily have an ->unplug_fn defined
 	 */
 	if (q->unplug_fn) {
-		blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_IO, NULL,
+		trace_block_pdu_int(q, BLK_TA_UNPLUG_IO, NULL,
 					q->rq.count[READ] + q->rq.count[WRITE]);
 
 		q->unplug_fn(q);
@@ -786,7 +787,7 @@ rq_starved:
 	if (ioc_batching(q, ioc))
 		ioc->nr_batch_requests--;
 
-	blk_add_trace_generic(q, bio, rw, BLK_TA_GETRQ);
+	trace_block_generic(q, bio, rw, BLK_TA_GETRQ);
 out:
 	return rq;
 }
@@ -812,7 +813,7 @@ static struct request *get_request_wait(
 		prepare_to_wait_exclusive(&rl->wait[rw], &wait,
 				TASK_UNINTERRUPTIBLE);
 
-		blk_add_trace_generic(q, bio, rw, BLK_TA_SLEEPRQ);
+		trace_block_generic(q, bio, rw, BLK_TA_SLEEPRQ);
 
 		__generic_unplug_device(q);
 		spin_unlock_irq(q->queue_lock);
@@ -887,7 +888,7 @@ EXPORT_SYMBOL(blk_start_queueing);
  */
 void blk_requeue_request(struct request_queue *q, struct request *rq)
 {
-	blk_add_trace_rq(q, rq, BLK_TA_REQUEUE);
+	trace_block_rq(q, rq, BLK_TA_REQUEUE);
 
 	if (blk_rq_tagged(rq))
 		blk_queue_end_tag(q, rq);
@@ -1112,7 +1113,7 @@ static int __make_request(struct request
 		if (!ll_back_merge_fn(q, req, bio))
 			break;
 
-		blk_add_trace_bio(q, bio, BLK_TA_BACKMERGE);
+		trace_block_bio(q, bio, BLK_TA_BACKMERGE);
 
 		req->biotail->bi_next = bio;
 		req->biotail = bio;
@@ -1129,7 +1130,7 @@ static int __make_request(struct request
 		if (!ll_front_merge_fn(q, req, bio))
 			break;
 
-		blk_add_trace_bio(q, bio, BLK_TA_FRONTMERGE);
+		trace_block_bio(q, bio, BLK_TA_FRONTMERGE);
 
 		bio->bi_next = req->bio;
 		req->bio = bio;
@@ -1208,7 +1209,7 @@ static inline void blk_partition_remap(s
 		bio->bi_sector += p->start_sect;
 		bio->bi_bdev = bdev->bd_contains;
 
-		blk_add_trace_remap(bdev_get_queue(bio->bi_bdev), bio,
+		trace_block_remap(bdev_get_queue(bio->bi_bdev), bio,
 				    bdev->bd_dev, bio->bi_sector,
 				    bio->bi_sector - p->start_sect);
 	}
@@ -1379,10 +1380,10 @@ end_io:
 			goto end_io;
 
 		if (old_sector != -1)
-			blk_add_trace_remap(q, bio, old_dev, bio->bi_sector,
+			trace_block_remap(q, bio, old_dev, bio->bi_sector,
 					    old_sector);
 
-		blk_add_trace_bio(q, bio, BLK_TA_QUEUE);
+		trace_block_bio(q, bio, BLK_TA_QUEUE);
 
 		old_sector = bio->bi_sector;
 		old_dev = bio->bi_bdev->bd_dev;
@@ -1516,7 +1517,7 @@ static int __end_that_request_first(stru
 	int total_bytes, bio_nbytes, next_idx = 0;
 	struct bio *bio;
 
-	blk_add_trace_rq(req->q, req, BLK_TA_COMPLETE);
+	trace_block_rq(req->q, req, BLK_TA_COMPLETE);
 
 	/*
 	 * for a REQ_BLOCK_PC request, we want to carry any eventual
Index: linux-2.6-lttng/block/elevator.c
===================================================================
--- linux-2.6-lttng.orig/block/elevator.c	2008-07-16 23:56:53.000000000 -0400
+++ linux-2.6-lttng/block/elevator.c	2008-07-16 23:56:58.000000000 -0400
@@ -34,6 +34,7 @@
 #include <linux/delay.h>
 #include <linux/blktrace_api.h>
 #include <linux/hash.h>
+#include <trace/block.h>
 
 #include <asm/uaccess.h>
 
@@ -577,7 +578,7 @@ void elv_insert(struct request_queue *q,
 	unsigned ordseq;
 	int unplug_it = 1;
 
-	blk_add_trace_rq(q, rq, BLK_TA_INSERT);
+	trace_block_rq(q, rq, BLK_TA_INSERT);
 
 	rq->q = q;
 
@@ -763,7 +764,7 @@ struct request *elv_next_request(struct 
 			 * not be passed by new incoming requests
 			 */
 			rq->cmd_flags |= REQ_STARTED;
-			blk_add_trace_rq(q, rq, BLK_TA_ISSUE);
+			trace_block_rq(q, rq, BLK_TA_ISSUE);
 		}
 
 		if (!q->boundary_rq || q->boundary_rq == rq) {
Index: linux-2.6-lttng/fs/bio.c
===================================================================
--- linux-2.6-lttng.orig/fs/bio.c	2008-07-16 23:56:53.000000000 -0400
+++ linux-2.6-lttng/fs/bio.c	2008-07-16 23:56:58.000000000 -0400
@@ -26,6 +26,7 @@
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
 #include <linux/blktrace_api.h>
+#include <trace/block.h>
 #include <scsi/sg.h>		/* for struct sg_iovec */
 
 static struct kmem_cache *bio_slab __read_mostly;
@@ -1226,7 +1227,7 @@ struct bio_pair *bio_split(struct bio *b
 	if (!bp)
 		return bp;
 
-	blk_add_trace_pdu_int(bdev_get_queue(bi->bi_bdev), BLK_TA_SPLIT, bi,
+	trace_block_pdu_int(bdev_get_queue(bi->bi_bdev), BLK_TA_SPLIT, bi,
 				bi->bi_sector + first_sectors);
 
 	BUG_ON(bi->bi_vcnt != 1);
Index: linux-2.6-lttng/block/Kconfig
===================================================================
--- linux-2.6-lttng.orig/block/Kconfig	2008-07-16 23:56:53.000000000 -0400
+++ linux-2.6-lttng/block/Kconfig	2008-07-16 23:56:58.000000000 -0400
@@ -47,6 +47,7 @@ config BLK_DEV_IO_TRACE
 	depends on SYSFS
 	select RELAY
 	select DEBUG_FS
+	select TRACEPOINTS
 	help
 	  Say Y here if you want to be able to trace the block layer actions
 	  on a given queue. Tracing allows you to see any traffic happening
Index: linux-2.6-lttng/drivers/md/dm.c
===================================================================
--- linux-2.6-lttng.orig/drivers/md/dm.c	2008-07-16 23:56:53.000000000 -0400
+++ linux-2.6-lttng/drivers/md/dm.c	2008-07-16 23:56:58.000000000 -0400
@@ -22,6 +22,7 @@
 #include <linux/hdreg.h>
 #include <linux/blktrace_api.h>
 #include <linux/smp_lock.h>
+#include <trace/block.h>
 
 #define DM_MSG_PREFIX "core"
 
@@ -514,7 +515,7 @@ static void dec_pending(struct dm_io *io
 			wake_up(&io->md->wait);
 
 		if (io->error != DM_ENDIO_REQUEUE) {
-			blk_add_trace_bio(io->md->queue, io->bio,
+			trace_block_bio(io->md->queue, io->bio,
 					  BLK_TA_COMPLETE);
 
 			bio_endio(io->bio, io->error);
@@ -608,7 +609,7 @@ static void __map_bio(struct dm_target *
 	if (r == DM_MAPIO_REMAPPED) {
 		/* the bio has been remapped so dispatch it */
 
-		blk_add_trace_remap(bdev_get_queue(clone->bi_bdev), clone,
+		trace_block_remap(bdev_get_queue(clone->bi_bdev), clone,
 				    tio->io->bio->bi_bdev->bd_dev,
 				    clone->bi_sector, sector);
 
Index: linux-2.6-lttng/mm/bounce.c
===================================================================
--- linux-2.6-lttng.orig/mm/bounce.c	2008-07-16 23:56:53.000000000 -0400
+++ linux-2.6-lttng/mm/bounce.c	2008-07-16 23:56:58.000000000 -0400
@@ -14,6 +14,7 @@
 #include <linux/hash.h>
 #include <linux/highmem.h>
 #include <linux/blktrace_api.h>
+#include <trace/block.h>
 #include <asm/tlbflush.h>
 
 #define POOL_SIZE	64
@@ -222,7 +223,7 @@ static void __blk_queue_bounce(struct re
 	if (!bio)
 		return;
 
-	blk_add_trace_bio(q, *bio_orig, BLK_TA_BOUNCE);
+	trace_block_bio(q, *bio_orig, BLK_TA_BOUNCE);
 
 	/*
 	 * at least one page was bounced, fill in possible non-highmem
Index: linux-2.6-lttng/block/blktrace.c
===================================================================
--- linux-2.6-lttng.orig/block/blktrace.c	2008-07-16 23:56:53.000000000 -0400
+++ linux-2.6-lttng/block/blktrace.c	2008-07-16 23:56:58.000000000 -0400
@@ -23,10 +23,18 @@
 #include <linux/mutex.h>
 #include <linux/debugfs.h>
 #include <linux/time.h>
+#include <trace/block.h>
 #include <asm/uaccess.h>
 
 static unsigned int blktrace_seq __read_mostly = 1;
 
+/* Global reference count of probes */
+static DEFINE_MUTEX(blk_probe_mutex);
+static int blk_probes_ref;
+
+static int register_tracepoints(void);
+static void unregister_tracepoints(void);
+
 /*
  * Send out a notify message.
  */
@@ -133,7 +141,7 @@ static u32 bio_act[9] __read_mostly = { 
  * The worker for the various blk_add_trace*() types. Fills out a
  * blk_io_trace structure and places it in a per-cpu subbuffer.
  */
-void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
+static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 		     int rw, u32 what, int error, int pdu_len, void *pdu_data)
 {
 	struct task_struct *tsk = current;
@@ -190,8 +198,6 @@ void __blk_add_trace(struct blk_trace *b
 	local_irq_restore(flags);
 }
 
-EXPORT_SYMBOL_GPL(__blk_add_trace);
-
 static struct dentry *blk_tree_root;
 static DEFINE_MUTEX(blk_tree_mutex);
 static unsigned int root_users;
@@ -250,6 +256,10 @@ static void blk_trace_cleanup(struct blk
 	free_percpu(bt->sequence);
 	free_percpu(bt->msg_data);
 	kfree(bt);
+	mutex_lock(&blk_probe_mutex);
+	if (--blk_probes_ref == 0)
+		unregister_tracepoints();
+	mutex_unlock(&blk_probe_mutex);
 }
 
 int blk_trace_remove(struct request_queue *q)
@@ -440,6 +450,14 @@ int do_blk_trace_setup(struct request_qu
 	bt->pid = buts->pid;
 	bt->trace_state = Blktrace_setup;
 
+	mutex_lock(&blk_probe_mutex);
+	if (!blk_probes_ref++) {
+		ret = register_tracepoints();
+		if (ret)
+			goto probe_err;
+	}
+	mutex_unlock(&blk_probe_mutex);
+
 	ret = -EBUSY;
 	old_bt = xchg(&q->blk_trace, bt);
 	if (old_bt) {
@@ -448,6 +466,9 @@ int do_blk_trace_setup(struct request_qu
 	}
 
 	return 0;
+probe_err:
+	--blk_probes_ref;
+	mutex_unlock(&blk_probe_mutex);
 err:
 	if (dir)
 		blk_remove_tree(dir);
@@ -574,3 +595,164 @@ void blk_trace_shutdown(struct request_q
 		blk_trace_remove(q);
 	}
 }
+
+/*
+ * blktrace probes
+ */
+
+/**
+ * blk_add_trace_rq - Add a trace for a request oriented action
+ * @q:		queue the io is for
+ * @rq:		the source request
+ * @what:	the action
+ *
+ * Description:
+ *     Records an action against a request. Will log the bio offset + size.
+ *
+ **/
+static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
+				    u32 what)
+{
+	struct blk_trace *bt = q->blk_trace;
+	int rw = rq->cmd_flags & 0x03;
+
+	if (likely(!bt))
+		return;
+
+	if (blk_pc_request(rq)) {
+		what |= BLK_TC_ACT(BLK_TC_PC);
+		__blk_add_trace(bt, 0, rq->data_len, rw, what, rq->errors, sizeof(rq->cmd), rq->cmd);
+	} else  {
+		what |= BLK_TC_ACT(BLK_TC_FS);
+		__blk_add_trace(bt, rq->hard_sector, rq->hard_nr_sectors << 9, rw, what, rq->errors, 0, NULL);
+	}
+}
+
+/**
+ * blk_add_trace_bio - Add a trace for a bio oriented action
+ * @q:		queue the io is for
+ * @bio:	the source bio
+ * @what:	the action
+ *
+ * Description:
+ *     Records an action against a bio. Will log the bio offset + size.
+ *
+ **/
+static void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
+				     u32 what)
+{
+	struct blk_trace *bt = q->blk_trace;
+
+	if (likely(!bt))
+		return;
+
+	__blk_add_trace(bt, bio->bi_sector, bio->bi_size, bio->bi_rw, what, !bio_flagged(bio, BIO_UPTODATE), 0, NULL);
+}
+
+/**
+ * blk_add_trace_generic - Add a trace for a generic action
+ * @q:		queue the io is for
+ * @bio:	the source bio
+ * @rw:		the data direction
+ * @what:	the action
+ *
+ * Description:
+ *     Records a simple trace
+ *
+ **/
+static void blk_add_trace_generic(struct request_queue *q,
+					 struct bio *bio, int rw, u32 what)
+{
+	struct blk_trace *bt = q->blk_trace;
+
+	if (likely(!bt))
+		return;
+
+	if (bio)
+		blk_add_trace_bio(q, bio, what);
+	else
+		__blk_add_trace(bt, 0, 0, rw, what, 0, 0, NULL);
+}
+
+/**
+ * blk_add_trace_pdu_int - Add a trace for a bio with an integer payload
+ * @q:		queue the io is for
+ * @what:	the action
+ * @bio:	the source bio
+ * @pdu:	the integer payload
+ *
+ * Description:
+ *     Adds a trace with some integer payload. This might be an unplug
+ *     option given as the action, with the depth at unplug time given
+ *     as the payload
+ *
+ **/
+static void blk_add_trace_pdu_int(struct request_queue *q, u32 what,
+					 struct bio *bio, unsigned int pdu)
+{
+	struct blk_trace *bt = q->blk_trace;
+	__be64 rpdu = cpu_to_be64(pdu);
+
+	if (likely(!bt))
+		return;
+
+	if (bio)
+		__blk_add_trace(bt, bio->bi_sector, bio->bi_size, bio->bi_rw, what, !bio_flagged(bio, BIO_UPTODATE), sizeof(rpdu), &rpdu);
+	else
+		__blk_add_trace(bt, 0, 0, 0, what, 0, sizeof(rpdu), &rpdu);
+}
+
+/**
+ * blk_add_trace_remap - Add a trace for a remap operation
+ * @q:		queue the io is for
+ * @bio:	the source bio
+ * @dev:	target device
+ * @from:	source sector
+ * @to:		target sector
+ *
+ * Description:
+ *     Device mapper or raid target sometimes need to split a bio because
+ *     it spans a stripe (or similar). Add a trace for that action.
+ *
+ **/
+static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
+				       dev_t dev, sector_t from, sector_t to)
+{
+	struct blk_trace *bt = q->blk_trace;
+	struct blk_io_trace_remap r;
+
+	if (likely(!bt))
+		return;
+
+	r.device = cpu_to_be32(dev);
+	r.device_from = cpu_to_be32(bio->bi_bdev->bd_dev);
+	r.sector = cpu_to_be64(to);
+
+	__blk_add_trace(bt, from, bio->bi_size, bio->bi_rw, BLK_TA_REMAP, !bio_flagged(bio, BIO_UPTODATE), sizeof(r), &r);
+}
+
+static int register_tracepoints(void)
+{
+	int ret;
+
+	ret = register_trace_block_rq(blk_add_trace_rq);
+	WARN_ON(ret);
+	ret = register_trace_block_bio(blk_add_trace_bio);
+	WARN_ON(ret);
+	ret = register_trace_block_generic(blk_add_trace_generic);
+	WARN_ON(ret);
+	ret = register_trace_block_pdu_int(blk_add_trace_pdu_int);
+	WARN_ON(ret);
+	ret = register_trace_block_remap(blk_add_trace_remap);
+	WARN_ON(ret);
+	return 0;
+}
+
+static void unregister_tracepoints(void)
+{
+	unregister_trace_block_remap(blk_add_trace_remap);
+	unregister_trace_block_pdu_int(blk_add_trace_pdu_int);
+	unregister_trace_block_generic(blk_add_trace_generic);
+	unregister_trace_block_bio(blk_add_trace_bio);
+	unregister_trace_block_rq(blk_add_trace_rq);
+}
Index: linux-2.6-lttng/include/linux/blktrace_api.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/blktrace_api.h	2008-07-16 23:56:53.000000000 -0400
+++ linux-2.6-lttng/include/linux/blktrace_api.h	2008-07-16 23:56:58.000000000 -0400
@@ -150,7 +150,6 @@ struct blk_user_trace_setup {
 #if defined(CONFIG_BLK_DEV_IO_TRACE)
 extern int blk_trace_ioctl(struct block_device *, unsigned, char __user *);
 extern void blk_trace_shutdown(struct request_queue *);
-extern void __blk_add_trace(struct blk_trace *, sector_t, int, int, u32, int, int, void *);
 extern int do_blk_trace_setup(struct request_queue *q,
 	char *name, dev_t dev, struct blk_user_trace_setup *buts);
 extern void __trace_note_message(struct blk_trace *, const char *fmt, ...);
@@ -176,137 +175,6 @@ extern void __trace_note_message(struct 
 	} while (0)
 #define BLK_TN_MAX_MSG		128
 
-/**
- * blk_add_trace_rq - Add a trace for a request oriented action
- * @q:		queue the io is for
- * @rq:		the source request
- * @what:	the action
- *
- * Description:
- *     Records an action against a request. Will log the bio offset + size.
- *
- **/
-static inline void blk_add_trace_rq(struct request_queue *q, struct request *rq,
-				    u32 what)
-{
-	struct blk_trace *bt = q->blk_trace;
-	int rw = rq->cmd_flags & 0x03;
-
-	if (likely(!bt))
-		return;
-
-	if (blk_pc_request(rq)) {
-		what |= BLK_TC_ACT(BLK_TC_PC);
-		__blk_add_trace(bt, 0, rq->data_len, rw, what, rq->errors, sizeof(rq->cmd), rq->cmd);
-	} else  {
-		what |= BLK_TC_ACT(BLK_TC_FS);
-		__blk_add_trace(bt, rq->hard_sector, rq->hard_nr_sectors << 9, rw, what, rq->errors, 0, NULL);
-	}
-}
-
-/**
- * blk_add_trace_bio - Add a trace for a bio oriented action
- * @q:		queue the io is for
- * @bio:	the source bio
- * @what:	the action
- *
- * Description:
- *     Records an action against a bio. Will log the bio offset + size.
- *
- **/
-static inline void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
-				     u32 what)
-{
-	struct blk_trace *bt = q->blk_trace;
-
-	if (likely(!bt))
-		return;
-
-	__blk_add_trace(bt, bio->bi_sector, bio->bi_size, bio->bi_rw, what, !bio_flagged(bio, BIO_UPTODATE), 0, NULL);
-}
-
-/**
- * blk_add_trace_generic - Add a trace for a generic action
- * @q:		queue the io is for
- * @bio:	the source bio
- * @rw:		the data direction
- * @what:	the action
- *
- * Description:
- *     Records a simple trace
- *
- **/
-static inline void blk_add_trace_generic(struct request_queue *q,
-					 struct bio *bio, int rw, u32 what)
-{
-	struct blk_trace *bt = q->blk_trace;
-
-	if (likely(!bt))
-		return;
-
-	if (bio)
-		blk_add_trace_bio(q, bio, what);
-	else
-		__blk_add_trace(bt, 0, 0, rw, what, 0, 0, NULL);
-}
-
-/**
- * blk_add_trace_pdu_int - Add a trace for a bio with an integer payload
- * @q:		queue the io is for
- * @what:	the action
- * @bio:	the source bio
- * @pdu:	the integer payload
- *
- * Description:
- *     Adds a trace with some integer payload. This might be an unplug
- *     option given as the action, with the depth at unplug time given
- *     as the payload
- *
- **/
-static inline void blk_add_trace_pdu_int(struct request_queue *q, u32 what,
-					 struct bio *bio, unsigned int pdu)
-{
-	struct blk_trace *bt = q->blk_trace;
-	__be64 rpdu = cpu_to_be64(pdu);
-
-	if (likely(!bt))
-		return;
-
-	if (bio)
-		__blk_add_trace(bt, bio->bi_sector, bio->bi_size, bio->bi_rw, what, !bio_flagged(bio, BIO_UPTODATE), sizeof(rpdu), &rpdu);
-	else
-		__blk_add_trace(bt, 0, 0, 0, what, 0, sizeof(rpdu), &rpdu);
-}
-
-/**
- * blk_add_trace_remap - Add a trace for a remap operation
- * @q:		queue the io is for
- * @bio:	the source bio
- * @dev:	target device
- * @from:	source sector
- * @to:		target sector
- *
- * Description:
- *     Device mapper or raid target sometimes need to split a bio because
- *     it spans a stripe (or similar). Add a trace for that action.
- *
- **/
-static inline void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
-				       dev_t dev, sector_t from, sector_t to)
-{
-	struct blk_trace *bt = q->blk_trace;
-	struct blk_io_trace_remap r;
-
-	if (likely(!bt))
-		return;
-
-	r.device = cpu_to_be32(dev);
-	r.device_from = cpu_to_be32(bio->bi_bdev->bd_dev);
-	r.sector = cpu_to_be64(to);
-
-	__blk_add_trace(bt, from, bio->bi_size, bio->bi_rw, BLK_TA_REMAP, !bio_flagged(bio, BIO_UPTODATE), sizeof(r), &r);
-}
-
 extern int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 			   char __user *arg);
 extern int blk_trace_startstop(struct request_queue *q, int start);

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
