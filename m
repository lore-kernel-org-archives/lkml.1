Return-Path: <linux-kernel-owner+w=401wt.eu-S1752096AbZDGLj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbZDGLj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 07:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbZDGLjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 07:39:16 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38306 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbZDGLjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 07:39:12 -0400
Date: Tue, 7 Apr 2009 13:39:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, gentuu@gmail.com
Subject: [GIT PULL] block updates for 2.6.30-rc1
Message-ID: <20090407113909.GS5178@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the collected set of small updates in the block area, as well as
the CFQ update you tested yesterday. It's essentially the same, but
allows for a bit more queuing for a solitary IO issuer. If it ends up
interferring too much with new IO, I'll augment that check with a time
based one as well. Looks good here, though.

There's also a fix for a long standing CFQ problem that caused slowdowns
with CFQ on streamed IO due to CFQ being too eager to restart IO
queuing.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Jens Axboe (6):
      block: elevator quiescing helpers
      cciss: fix residual count for block pc requests
      cfq-iosched: change dispatch logic to deal with single requests at the time
      cfq-iosched: kill two unused cfqq flags
      block: remove unused REQ_UNPLUG
      cfq-iosched: don't let idling interfere with plugging

Jerome Marchand (1):
      block: fix inconsistency in I/O stat accounting code

Mike Miller (2):
      cciss: kernel scan thread for MSA2012
      cciss: change to discover first memory BAR

unsik Kim (1):
      mflash: initial support

 Documentation/blockdev/00-INDEX   |    2 +
 Documentation/blockdev/mflash.txt |   84 +++
 block/blk-core.c                  |   15 +-
 block/blk-merge.c                 |   29 +-
 block/blk-sysfs.c                 |    4 +
 block/blk.h                       |   14 +-
 block/cfq-iosched.c               |  202 ++++----
 block/elevator.c                  |   42 +-
 drivers/block/Kconfig             |   17 +
 drivers/block/Makefile            |    1 +
 drivers/block/cciss.c             |  117 ++++-
 drivers/block/cciss.h             |    2 +
 drivers/block/cciss_cmd.h         |   23 +
 drivers/block/mg_disk.c           | 1005 +++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h            |    2 -
 include/linux/elevator.h          |    1 +
 include/linux/mg_disk.h           |  206 ++++++++
 17 files changed, 1619 insertions(+), 147 deletions(-)
 create mode 100644 Documentation/blockdev/mflash.txt
 create mode 100644 drivers/block/mg_disk.c
 create mode 100644 include/linux/mg_disk.h

---

diff --git a/Documentation/blockdev/00-INDEX b/Documentation/blockdev/00-INDEX
index 86f054c..c08df56 100644
--- a/Documentation/blockdev/00-INDEX
+++ b/Documentation/blockdev/00-INDEX
@@ -8,6 +8,8 @@ cpqarray.txt
 	- info on using Compaq's SMART2 Intelligent Disk Array Controllers.
 floppy.txt
 	- notes and driver options for the floppy disk driver.
+mflash.txt
+	- info on mGine m(g)flash driver for linux.
 nbd.txt
 	- info on a TCP implementation of a network block device.
 paride.txt
diff --git a/Documentation/blockdev/mflash.txt b/Documentation/blockdev/mflash.txt
new file mode 100644
index 0000000..1f610ec
--- /dev/null
+++ b/Documentation/blockdev/mflash.txt
@@ -0,0 +1,84 @@
+This document describes m[g]flash support in linux.
+
+Contents
+  1. Overview
+  2. Reserved area configuration
+  3. Example of mflash platform driver registration
+
+1. Overview
+
+Mflash and gflash are embedded flash drive. The only difference is mflash is
+MCP(Multi Chip Package) device. These two device operate exactly same way.
+So the rest mflash repersents mflash and gflash altogether.
+
+Internally, mflash has nand flash and other hardware logics and supports
+2 different operation (ATA, IO) modes. ATA mode doesn't need any new
+driver and currently works well under standard IDE subsystem. Actually it's
+one chip SSD. IO mode is ATA-like custom mode for the host that doesn't have
+IDE interface.
+
+Followings are brief descriptions about IO mode.
+A. IO mode based on ATA protocol and uses some custom command. (read confirm,
+write confirm)
+B. IO mode uses SRAM bus interface.
+C. IO mode supports 4kB boot area, so host can boot from mflash.
+
+2. Reserved area configuration
+If host boot from mflash, usually needs raw area for boot loader image. All of
+the mflash's block device operation will be taken this value as start offset.
+Note that boot loader's size of reserved area and kernel configuration value
+must be same.
+
+3. Example of mflash platform driver registration
+Working mflash is very straight forward. Adding platform device stuff to board
+configuration file is all. Here is some pseudo example.
+
+static struct mg_drv_data mflash_drv_data = {
+	/* If you want to polling driver set to 1 */
+	.use_polling = 0,
+	/* device attribution */
+	.dev_attr = MG_BOOT_DEV
+};
+
+static struct resource mg_mflash_rsc[] = {
+	/* Base address of mflash */
+	[0] = {
+		.start = 0x08000000,
+		.end = 0x08000000 + SZ_64K - 1,
+		.flags = IORESOURCE_MEM
+	},
+	/* mflash interrupt pin */
+	[1] = {
+		.start = IRQ_GPIO(84),
+		.end = IRQ_GPIO(84),
+		.flags = IORESOURCE_IRQ
+	},
+	/* mflash reset pin */
+	[2] = {
+		.start = 43,
+		.end = 43,
+		.name = MG_RST_PIN,
+		.flags = IORESOURCE_IO
+	},
+	/* mflash reset-out pin
+	 * If you use mflash as storage device (i.e. other than MG_BOOT_DEV),
+	 * should assign this */
+	[3] = {
+		.start = 51,
+		.end = 51,
+		.name = MG_RSTOUT_PIN,
+		.flags = IORESOURCE_IO
+	}
+};
+
+static struct platform_device mflash_dev = {
+	.name = MG_DEV_NAME,
+	.id = -1,
+	.dev = {
+		.platform_data = &mflash_drv_data,
+	},
+	.num_resources = ARRAY_SIZE(mg_mflash_rsc),
+	.resource = mg_mflash_rsc
+};
+
+platform_device_register(&mflash_dev);
diff --git a/block/blk-core.c b/block/blk-core.c
index 2557280..43fdedc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -64,12 +64,11 @@ static struct workqueue_struct *kblockd_workqueue;
 
 static void drive_stat_acct(struct request *rq, int new_io)
 {
-	struct gendisk *disk = rq->rq_disk;
 	struct hd_struct *part;
 	int rw = rq_data_dir(rq);
 	int cpu;
 
-	if (!blk_fs_request(rq) || !disk || !blk_do_io_stat(disk->queue))
+	if (!blk_fs_request(rq) || !blk_do_io_stat(rq))
 		return;
 
 	cpu = part_stat_lock();
@@ -1124,8 +1123,6 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 
 	if (bio_sync(bio))
 		req->cmd_flags |= REQ_RW_SYNC;
-	if (bio_unplug(bio))
-		req->cmd_flags |= REQ_UNPLUG;
 	if (bio_rw_meta(bio))
 		req->cmd_flags |= REQ_RW_META;
 	if (bio_noidle(bio))
@@ -1675,9 +1672,7 @@ EXPORT_SYMBOL(blkdev_dequeue_request);
 
 static void blk_account_io_completion(struct request *req, unsigned int bytes)
 {
-	struct gendisk *disk = req->rq_disk;
-
-	if (!disk || !blk_do_io_stat(disk->queue))
+	if (!blk_do_io_stat(req))
 		return;
 
 	if (blk_fs_request(req)) {
@@ -1694,9 +1689,7 @@ static void blk_account_io_completion(struct request *req, unsigned int bytes)
 
 static void blk_account_io_done(struct request *req)
 {
-	struct gendisk *disk = req->rq_disk;
-
-	if (!disk || !blk_do_io_stat(disk->queue))
+	if (!blk_do_io_stat(req))
 		return;
 
 	/*
@@ -1711,7 +1704,7 @@ static void blk_account_io_done(struct request *req)
 		int cpu;
 
 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(disk, req->sector);
+		part = disk_map_sector_rcu(req->rq_disk, req->sector);
 
 		part_stat_inc(cpu, part, ios[rw]);
 		part_stat_add(cpu, part, ticks[rw], duration);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index e39cb24..63760ca 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -338,6 +338,22 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 	return 1;
 }
 
+static void blk_account_io_merge(struct request *req)
+{
+	if (blk_do_io_stat(req)) {
+		struct hd_struct *part;
+		int cpu;
+
+		cpu = part_stat_lock();
+		part = disk_map_sector_rcu(req->rq_disk, req->sector);
+
+		part_round_stats(cpu, part);
+		part_dec_in_flight(part);
+
+		part_stat_unlock();
+	}
+}
+
 /*
  * Has to be called with the request spinlock acquired
  */
@@ -386,18 +402,7 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 
 	elv_merge_requests(q, req, next);
 
-	if (req->rq_disk) {
-		struct hd_struct *part;
-		int cpu;
-
-		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, req->sector);
-
-		part_round_stats(cpu, part);
-		part_dec_in_flight(part);
-
-		part_stat_unlock();
-	}
+	blk_account_io_merge(req);
 
 	req->ioprio = ioprio_best(req->ioprio, next->ioprio);
 	if (blk_rq_cpu_valid(next))
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 3ff9bba..73f36be 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -209,10 +209,14 @@ static ssize_t queue_iostats_store(struct request_queue *q, const char *page,
 	ssize_t ret = queue_var_store(&stats, page, count);
 
 	spin_lock_irq(q->queue_lock);
+	elv_quisce_start(q);
+
 	if (stats)
 		queue_flag_set(QUEUE_FLAG_IO_STAT, q);
 	else
 		queue_flag_clear(QUEUE_FLAG_IO_STAT, q);
+
+	elv_quisce_end(q);
 	spin_unlock_irq(q->queue_lock);
 
 	return ret;
diff --git a/block/blk.h b/block/blk.h
index 3ee9435..24fcaee 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -70,6 +70,10 @@ void blk_queue_congestion_threshold(struct request_queue *q);
 
 int blk_dev_init(void);
 
+void elv_quisce_start(struct request_queue *q);
+void elv_quisce_end(struct request_queue *q);
+
+
 /*
  * Return the threshold (number of used requests) at which the queue is
  * considered to be congested.  It include a little hysteresis to keep the
@@ -108,12 +112,14 @@ static inline int blk_cpu_to_group(int cpu)
 #endif
 }
 
-static inline int blk_do_io_stat(struct request_queue *q)
+static inline int blk_do_io_stat(struct request *rq)
 {
-	if (q)
-		return blk_queue_io_stat(q);
+	struct gendisk *disk = rq->rq_disk;
 
-	return 0;
+	if (!disk || !disk->queue)
+		return 0;
+
+	return blk_queue_io_stat(disk->queue) && (rq->cmd_flags & REQ_ELVPRIV);
 }
 
 #endif
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9e80934..a4809de 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -160,6 +160,7 @@ struct cfq_queue {
 
 	unsigned long slice_end;
 	long slice_resid;
+	unsigned int slice_dispatch;
 
 	/* pending metadata requests */
 	int meta_pending;
@@ -176,13 +177,12 @@ struct cfq_queue {
 enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_on_rr = 0,	/* on round-robin busy list */
 	CFQ_CFQQ_FLAG_wait_request,	/* waiting for a request */
+	CFQ_CFQQ_FLAG_must_dispatch,	/* must be allowed a dispatch */
 	CFQ_CFQQ_FLAG_must_alloc,	/* must be allowed rq alloc */
 	CFQ_CFQQ_FLAG_must_alloc_slice,	/* per-slice must_alloc flag */
-	CFQ_CFQQ_FLAG_must_dispatch,	/* must dispatch, even if expired */
 	CFQ_CFQQ_FLAG_fifo_expire,	/* FIFO checked in this slice */
 	CFQ_CFQQ_FLAG_idle_window,	/* slice idling enabled */
 	CFQ_CFQQ_FLAG_prio_changed,	/* task priority has changed */
-	CFQ_CFQQ_FLAG_queue_new,	/* queue never been serviced */
 	CFQ_CFQQ_FLAG_slice_new,	/* no requests dispatched in slice */
 	CFQ_CFQQ_FLAG_sync,		/* synchronous queue */
 };
@@ -203,13 +203,12 @@ static inline int cfq_cfqq_##name(const struct cfq_queue *cfqq)		\
 
 CFQ_CFQQ_FNS(on_rr);
 CFQ_CFQQ_FNS(wait_request);
+CFQ_CFQQ_FNS(must_dispatch);
 CFQ_CFQQ_FNS(must_alloc);
 CFQ_CFQQ_FNS(must_alloc_slice);
-CFQ_CFQQ_FNS(must_dispatch);
 CFQ_CFQQ_FNS(fifo_expire);
 CFQ_CFQQ_FNS(idle_window);
 CFQ_CFQQ_FNS(prio_changed);
-CFQ_CFQQ_FNS(queue_new);
 CFQ_CFQQ_FNS(slice_new);
 CFQ_CFQQ_FNS(sync);
 #undef CFQ_CFQQ_FNS
@@ -774,10 +773,15 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 	if (cfqq) {
 		cfq_log_cfqq(cfqd, cfqq, "set_active");
 		cfqq->slice_end = 0;
+		cfqq->slice_dispatch = 0;
+
+		cfq_clear_cfqq_wait_request(cfqq);
+		cfq_clear_cfqq_must_dispatch(cfqq);
 		cfq_clear_cfqq_must_alloc_slice(cfqq);
 		cfq_clear_cfqq_fifo_expire(cfqq);
 		cfq_mark_cfqq_slice_new(cfqq);
-		cfq_clear_cfqq_queue_new(cfqq);
+
+		del_timer(&cfqd->idle_slice_timer);
 	}
 
 	cfqd->active_queue = cfqq;
@@ -795,7 +799,6 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (cfq_cfqq_wait_request(cfqq))
 		del_timer(&cfqd->idle_slice_timer);
 
-	cfq_clear_cfqq_must_dispatch(cfqq);
 	cfq_clear_cfqq_wait_request(cfqq);
 
 	/*
@@ -924,7 +927,6 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	    (sample_valid(cic->ttime_samples) && cic->ttime_mean > 2))
 		return;
 
-	cfq_mark_cfqq_must_dispatch(cfqq);
 	cfq_mark_cfqq_wait_request(cfqq);
 
 	/*
@@ -1010,7 +1012,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	/*
 	 * The active queue has run out of time, expire it and select new.
 	 */
-	if (cfq_slice_used(cfqq))
+	if (cfq_slice_used(cfqq) && !cfq_cfqq_must_dispatch(cfqq))
 		goto expire;
 
 	/*
@@ -1053,66 +1055,6 @@ keep_queue:
 	return cfqq;
 }
 
-/*
- * Dispatch some requests from cfqq, moving them to the request queue
- * dispatch list.
- */
-static int
-__cfq_dispatch_requests(struct cfq_data *cfqd, struct cfq_queue *cfqq,
-			int max_dispatch)
-{
-	int dispatched = 0;
-
-	BUG_ON(RB_EMPTY_ROOT(&cfqq->sort_list));
-
-	do {
-		struct request *rq;
-
-		/*
-		 * follow expired path, else get first next available
-		 */
-		rq = cfq_check_fifo(cfqq);
-		if (rq == NULL)
-			rq = cfqq->next_rq;
-
-		/*
-		 * finally, insert request into driver dispatch list
-		 */
-		cfq_dispatch_insert(cfqd->queue, rq);
-
-		dispatched++;
-
-		if (!cfqd->active_cic) {
-			atomic_inc(&RQ_CIC(rq)->ioc->refcount);
-			cfqd->active_cic = RQ_CIC(rq);
-		}
-
-		if (RB_EMPTY_ROOT(&cfqq->sort_list))
-			break;
-
-		/*
-		 * If there is a non-empty RT cfqq waiting for current
-		 * cfqq's timeslice to complete, pre-empt this cfqq
-		 */
-		if (!cfq_class_rt(cfqq) && cfqd->busy_rt_queues)
-			break;
-
-	} while (dispatched < max_dispatch);
-
-	/*
-	 * expire an async queue immediately if it has used up its slice. idle
-	 * queue always expire after 1 dispatch round.
-	 */
-	if (cfqd->busy_queues > 1 && ((!cfq_cfqq_sync(cfqq) &&
-	    dispatched >= cfq_prio_to_maxrq(cfqd, cfqq)) ||
-	    cfq_class_idle(cfqq))) {
-		cfqq->slice_end = jiffies + 1;
-		cfq_slice_expired(cfqd, 0);
-	}
-
-	return dispatched;
-}
-
 static int __cfq_forced_dispatch_cfqq(struct cfq_queue *cfqq)
 {
 	int dispatched = 0;
@@ -1146,11 +1088,45 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 	return dispatched;
 }
 
+/*
+ * Dispatch a request from cfqq, moving them to the request queue
+ * dispatch list.
+ */
+static void cfq_dispatch_request(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+{
+	struct request *rq;
+
+	BUG_ON(RB_EMPTY_ROOT(&cfqq->sort_list));
+
+	/*
+	 * follow expired path, else get first next available
+	 */
+	rq = cfq_check_fifo(cfqq);
+	if (!rq)
+		rq = cfqq->next_rq;
+
+	/*
+	 * insert request into driver dispatch list
+	 */
+	cfq_dispatch_insert(cfqd->queue, rq);
+
+	if (!cfqd->active_cic) {
+		struct cfq_io_context *cic = RQ_CIC(rq);
+
+		atomic_inc(&cic->ioc->refcount);
+		cfqd->active_cic = cic;
+	}
+}
+
+/*
+ * Find the cfqq that we need to service and move a request from that to the
+ * dispatch list
+ */
 static int cfq_dispatch_requests(struct request_queue *q, int force)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_queue *cfqq;
-	int dispatched;
+	unsigned int max_dispatch;
 
 	if (!cfqd->busy_queues)
 		return 0;
@@ -1158,29 +1134,63 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
 	if (unlikely(force))
 		return cfq_forced_dispatch(cfqd);
 
-	dispatched = 0;
-	while ((cfqq = cfq_select_queue(cfqd)) != NULL) {
-		int max_dispatch;
+	cfqq = cfq_select_queue(cfqd);
+	if (!cfqq)
+		return 0;
+
+	/*
+	 * If this is an async queue and we have sync IO in flight, let it wait
+	 */
+	if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
+		return 0;
+
+	max_dispatch = cfqd->cfq_quantum;
+	if (cfq_class_idle(cfqq))
+		max_dispatch = 1;
 
-		max_dispatch = cfqd->cfq_quantum;
+	/*
+	 * Does this cfqq already have too much IO in flight?
+	 */
+	if (cfqq->dispatched >= max_dispatch) {
+		/*
+		 * idle queue must always only have a single IO in flight
+		 */
 		if (cfq_class_idle(cfqq))
-			max_dispatch = 1;
+			return 0;
 
-		if (cfqq->dispatched >= max_dispatch && cfqd->busy_queues > 1)
-			break;
+		/*
+		 * We have other queues, don't allow more IO from this one
+		 */
+		if (cfqd->busy_queues > 1)
+			return 0;
 
-		if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
-			break;
+		/*
+		 * we are the only queue, allow up to 4 times of 'quantum'
+		 */
+		if (cfqq->dispatched >= 4 * max_dispatch)
+			return 0;
+	}
 
-		cfq_clear_cfqq_must_dispatch(cfqq);
-		cfq_clear_cfqq_wait_request(cfqq);
-		del_timer(&cfqd->idle_slice_timer);
+	/*
+	 * Dispatch a request from this cfqq
+	 */
+	cfq_dispatch_request(cfqd, cfqq);
+	cfqq->slice_dispatch++;
+	cfq_clear_cfqq_must_dispatch(cfqq);
 
-		dispatched += __cfq_dispatch_requests(cfqd, cfqq, max_dispatch);
+	/*
+	 * expire an async queue immediately if it has used up its slice. idle
+	 * queue always expire after 1 dispatch round.
+	 */
+	if (cfqd->busy_queues > 1 && ((!cfq_cfqq_sync(cfqq) &&
+	    cfqq->slice_dispatch >= cfq_prio_to_maxrq(cfqd, cfqq)) ||
+	    cfq_class_idle(cfqq))) {
+		cfqq->slice_end = jiffies + 1;
+		cfq_slice_expired(cfqd, 0);
 	}
 
-	cfq_log(cfqd, "dispatched=%d", dispatched);
-	return dispatched;
+	cfq_log(cfqd, "dispatched a request");
+	return 1;
 }
 
 /*
@@ -1506,7 +1516,6 @@ retry:
 		cfqq->cfqd = cfqd;
 
 		cfq_mark_cfqq_prio_changed(cfqq);
-		cfq_mark_cfqq_queue_new(cfqq);
 
 		cfq_init_prio_data(cfqq, ioc);
 
@@ -1893,15 +1902,13 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	if (cfqq == cfqd->active_queue) {
 		/*
-		 * if we are waiting for a request for this queue, let it rip
-		 * immediately and flag that we must not expire this queue
-		 * just now
+		 * Remember that we saw a request from this process, but
+		 * don't start queuing just yet. Otherwise we risk seeing lots
+		 * of tiny requests, because we disrupt the normal plugging
+		 * and merging.
 		 */
-		if (cfq_cfqq_wait_request(cfqq)) {
+		if (cfq_cfqq_wait_request(cfqq))
 			cfq_mark_cfqq_must_dispatch(cfqq);
-			del_timer(&cfqd->idle_slice_timer);
-			blk_start_queueing(cfqd->queue);
-		}
 	} else if (cfq_should_preempt(cfqd, cfqq, rq)) {
 		/*
 		 * not the active queue - expire current slice if it is
@@ -1910,7 +1917,6 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		 * this new queue is RT and the current one is BE
 		 */
 		cfq_preempt_queue(cfqd, cfqq);
-		cfq_mark_cfqq_must_dispatch(cfqq);
 		blk_start_queueing(cfqd->queue);
 	}
 }
@@ -2172,6 +2178,12 @@ static void cfq_idle_slice_timer(unsigned long data)
 		timed_out = 0;
 
 		/*
+		 * We saw a request before the queue expired, let it through
+		 */
+		if (cfq_cfqq_must_dispatch(cfqq))
+			goto out_kick;
+
+		/*
 		 * expired
 		 */
 		if (cfq_slice_used(cfqq))
@@ -2187,10 +2199,8 @@ static void cfq_idle_slice_timer(unsigned long data)
 		/*
 		 * not expired and it has a request pending, let it dispatch
 		 */
-		if (!RB_EMPTY_ROOT(&cfqq->sort_list)) {
-			cfq_mark_cfqq_must_dispatch(cfqq);
+		if (!RB_EMPTY_ROOT(&cfqq->sort_list))
 			goto out_kick;
-		}
 	}
 expire:
 	cfq_slice_expired(cfqd, timed_out);
diff --git a/block/elevator.c b/block/elevator.c
index ca6788a..fb81bcc 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -573,7 +573,7 @@ void elv_requeue_request(struct request_queue *q, struct request *rq)
 	elv_insert(q, rq, ELEVATOR_INSERT_REQUEUE);
 }
 
-static void elv_drain_elevator(struct request_queue *q)
+void elv_drain_elevator(struct request_queue *q)
 {
 	static int printed;
 	while (q->elevator->ops->elevator_dispatch_fn(q, 1))
@@ -587,6 +587,31 @@ static void elv_drain_elevator(struct request_queue *q)
 	}
 }
 
+/*
+ * Call with queue lock held, interrupts disabled
+ */
+void elv_quisce_start(struct request_queue *q)
+{
+	queue_flag_set(QUEUE_FLAG_ELVSWITCH, q);
+
+	/*
+	 * make sure we don't have any requests in flight
+	 */
+	elv_drain_elevator(q);
+	while (q->rq.elvpriv) {
+		blk_start_queueing(q);
+		spin_unlock_irq(q->queue_lock);
+		msleep(10);
+		spin_lock_irq(q->queue_lock);
+		elv_drain_elevator(q);
+	}
+}
+
+void elv_quisce_end(struct request_queue *q)
+{
+	queue_flag_clear(QUEUE_FLAG_ELVSWITCH, q);
+}
+
 void elv_insert(struct request_queue *q, struct request *rq, int where)
 {
 	struct list_head *pos;
@@ -1101,18 +1126,7 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	 * Turn on BYPASS and drain all requests w/ elevator private data
 	 */
 	spin_lock_irq(q->queue_lock);
-
-	queue_flag_set(QUEUE_FLAG_ELVSWITCH, q);
-
-	elv_drain_elevator(q);
-
-	while (q->rq.elvpriv) {
-		blk_start_queueing(q);
-		spin_unlock_irq(q->queue_lock);
-		msleep(10);
-		spin_lock_irq(q->queue_lock);
-		elv_drain_elevator(q);
-	}
+	elv_quisce_start(q);
 
 	/*
 	 * Remember old elevator.
@@ -1136,7 +1150,7 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	 */
 	elevator_exit(old_elevator);
 	spin_lock_irq(q->queue_lock);
-	queue_flag_clear(QUEUE_FLAG_ELVSWITCH, q);
+	elv_quisce_end(q);
 	spin_unlock_irq(q->queue_lock);
 
 	blk_add_trace_msg(q, "elv switch: %s", e->elevator_type->elevator_name);
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index e7b8aa0..ddea8e4 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -410,6 +410,23 @@ config ATA_OVER_ETH
 	This driver provides Support for ATA over Ethernet block
 	devices like the Coraid EtherDrive (R) Storage Blade.
 
+config MG_DISK
+	tristate "mGine mflash, gflash support"
+	depends on ARM && ATA && GPIOLIB
+	help
+	  mGine mFlash(gFlash) block device driver
+
+config MG_DISK_RES
+	int "Size of reserved area before MBR"
+	depends on MG_DISK
+	default 0
+	help
+	  Define size of reserved area that usually used for boot. Unit is KB.
+	  All of the block device operation will be taken this value as start
+	  offset
+	  Examples:
+			1024 => 1 MB
+
 config SUNVDC
 	tristate "Sun Virtual Disk Client support"
 	depends on SUN_LDOMS
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 3145141..7755a5e 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_BLK_CPQ_CISS_DA)  += cciss.o
 obj-$(CONFIG_BLK_DEV_DAC960)	+= DAC960.o
 obj-$(CONFIG_XILINX_SYSACE)	+= xsysace.o
 obj-$(CONFIG_CDROM_PKTCDVD)	+= pktcdvd.o
+obj-$(CONFIG_MG_DISK)		+= mg_disk.o
 obj-$(CONFIG_SUNVDC)		+= sunvdc.o
 
 obj-$(CONFIG_BLK_DEV_UMEM)	+= umem.o
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 5d0e135..219c530 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -51,6 +51,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <linux/cdrom.h>
 #include <linux/scatterlist.h>
+#include <linux/kthread.h>
 
 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
 #define DRIVER_NAME "HP CISS Driver (v 3.6.20)"
@@ -186,6 +187,8 @@ static int sendcmd_withirq(__u8 cmd, int ctlr, void *buff, size_t size,
 			   __u8 page_code, int cmd_type);
 
 static void fail_all_cmds(unsigned long ctlr);
+static int scan_thread(void *data);
+static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c);
 
 #ifdef CONFIG_PROC_FS
 static void cciss_procinit(int i);
@@ -735,6 +738,12 @@ static int cciss_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
+static void check_ioctl_unit_attention(ctlr_info_t *host, CommandList_struct *c)
+{
+	if (c->err_info->CommandStatus == CMD_TARGET_STATUS &&
+			c->err_info->ScsiStatus != SAM_STAT_CHECK_CONDITION)
+		(void)check_for_unit_attention(host, c);
+}
 /*
  * ioctl
  */
@@ -1029,6 +1038,8 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 					 iocommand.buf_size,
 					 PCI_DMA_BIDIRECTIONAL);
 
+			check_ioctl_unit_attention(host, c);
+
 			/* Copy the error information out */
 			iocommand.error_info = *(c->err_info);
 			if (copy_to_user
@@ -1180,6 +1191,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 					(dma_addr_t) temp64.val, buff_size[i],
 					PCI_DMA_BIDIRECTIONAL);
 			}
+			check_ioctl_unit_attention(host, c);
 			/* Copy the error information out */
 			ioc->error_info = *(c->err_info);
 			if (copy_to_user(argp, ioc, sizeof(*ioc))) {
@@ -1287,6 +1299,7 @@ static void cciss_softirq_done(struct request *rq)
 {
 	CommandList_struct *cmd = rq->completion_data;
 	ctlr_info_t *h = hba[cmd->ctlr];
+	unsigned int nr_bytes;
 	unsigned long flags;
 	u64bit temp64;
 	int i, ddir;
@@ -1308,7 +1321,14 @@ static void cciss_softirq_done(struct request *rq)
 	printk("Done with %p\n", rq);
 #endif				/* CCISS_DEBUG */
 
-	if (blk_end_request(rq, (rq->errors == 0) ? 0 : -EIO, blk_rq_bytes(rq)))
+	/*
+	 * Store the full size and set the residual count for pc requests
+	 */
+	nr_bytes = blk_rq_bytes(rq);
+	if (blk_pc_request(rq))
+		rq->data_len = cmd->err_info->ResidualCnt;
+
+	if (blk_end_request(rq, (rq->errors == 0) ? 0 : -EIO, nr_bytes))
 		BUG();
 
 	spin_lock_irqsave(&h->lock, flags);
@@ -2585,12 +2605,14 @@ static inline unsigned int make_status_bytes(unsigned int scsi_status_byte,
 		((driver_byte & 0xff) << 24);
 }
 
-static inline int evaluate_target_status(CommandList_struct *cmd)
+static inline int evaluate_target_status(ctlr_info_t *h,
+			CommandList_struct *cmd, int *retry_cmd)
 {
 	unsigned char sense_key;
 	unsigned char status_byte, msg_byte, host_byte, driver_byte;
 	int error_value;
 
+	*retry_cmd = 0;
 	/* If we get in here, it means we got "target status", that is, scsi status */
 	status_byte = cmd->err_info->ScsiStatus;
 	driver_byte = DRIVER_OK;
@@ -2618,6 +2640,11 @@ static inline int evaluate_target_status(CommandList_struct *cmd)
 	if (((sense_key == 0x0) || (sense_key == 0x1)) && !blk_pc_request(cmd->rq))
 		error_value = 0;
 
+	if (check_for_unit_attention(h, cmd)) {
+		*retry_cmd = !blk_pc_request(cmd->rq);
+		return 0;
+	}
+
 	if (!blk_pc_request(cmd->rq)) { /* Not SG_IO or similar? */
 		if (error_value != 0)
 			printk(KERN_WARNING "cciss: cmd %p has CHECK CONDITION"
@@ -2657,7 +2684,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 
 	switch (cmd->err_info->CommandStatus) {
 	case CMD_TARGET_STATUS:
-		rq->errors = evaluate_target_status(cmd);
+		rq->errors = evaluate_target_status(h, cmd, &retry_cmd);
 		break;
 	case CMD_DATA_UNDERRUN:
 		if (blk_fs_request(cmd->rq)) {
@@ -3008,6 +3035,63 @@ static irqreturn_t do_cciss_intr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static int scan_thread(void *data)
+{
+	ctlr_info_t *h = data;
+	int rc;
+	DECLARE_COMPLETION_ONSTACK(wait);
+	h->rescan_wait = &wait;
+
+	for (;;) {
+		rc = wait_for_completion_interruptible(&wait);
+		if (kthread_should_stop())
+			break;
+		if (!rc)
+			rebuild_lun_table(h, 0);
+	}
+	return 0;
+}
+
+static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c)
+{
+	if (c->err_info->SenseInfo[2] != UNIT_ATTENTION)
+		return 0;
+
+	switch (c->err_info->SenseInfo[12]) {
+	case STATE_CHANGED:
+		printk(KERN_WARNING "cciss%d: a state change "
+			"detected, command retried\n", h->ctlr);
+		return 1;
+	break;
+	case LUN_FAILED:
+		printk(KERN_WARNING "cciss%d: LUN failure "
+			"detected, action required\n", h->ctlr);
+		return 1;
+	break;
+	case REPORT_LUNS_CHANGED:
+		printk(KERN_WARNING "cciss%d: report LUN data "
+			"changed\n", h->ctlr);
+		if (h->rescan_wait)
+			complete(h->rescan_wait);
+		return 1;
+	break;
+	case POWER_OR_RESET:
+		printk(KERN_WARNING "cciss%d: a power on "
+			"or device reset detected\n", h->ctlr);
+		return 1;
+	break;
+	case UNIT_ATTENTION_CLEARED:
+		printk(KERN_WARNING "cciss%d: unit attention "
+		    "cleared by another initiator\n", h->ctlr);
+		return 1;
+	break;
+	default:
+		printk(KERN_WARNING "cciss%d: unknown "
+			"unit attention detected\n", h->ctlr);
+				return 1;
+	}
+}
+
 /*
  *  We cannot read the structure directly, for portability we must use
  *   the io functions.
@@ -3181,12 +3265,21 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
  */
 	cciss_interrupt_mode(c, pdev, board_id);
 
-	/*
-	 * Memory base addr is first addr , the second points to the config
-	 *   table
-	 */
+	/* find the memory BAR */
+	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+		if (pci_resource_flags(pdev, i) & IORESOURCE_MEM)
+			break;
+	}
+	if (i == DEVICE_COUNT_RESOURCE) {
+		printk(KERN_WARNING "cciss: No memory BAR found\n");
+		err = -ENODEV;
+		goto err_out_free_res;
+	}
+
+	c->paddr = pci_resource_start(pdev, i); /* addressing mode bits
+						 * already removed
+						 */
 
-	c->paddr = pci_resource_start(pdev, 0);	/* addressing mode bits already removed */
 #ifdef CCISS_DEBUG
 	printk("address 0 = %lx\n", c->paddr);
 #endif				/* CCISS_DEBUG */
@@ -3753,6 +3846,11 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	hba[i]->busy_initializing = 0;
 
 	rebuild_lun_table(hba[i], 1);
+	hba[i]->cciss_scan_thread = kthread_run(scan_thread, hba[i],
+				"cciss_scan%02d", i);
+	if (IS_ERR(hba[i]->cciss_scan_thread))
+		return PTR_ERR(hba[i]->cciss_scan_thread);
+
 	return 1;
 
 clean4:
@@ -3828,6 +3926,7 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 		printk(KERN_ERR "cciss: Unable to remove device \n");
 		return;
 	}
+
 	tmp_ptr = pci_get_drvdata(pdev);
 	i = tmp_ptr->ctlr;
 	if (hba[i] == NULL) {
@@ -3836,6 +3935,8 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 		return;
 	}
 
+	kthread_stop(hba[i]->cciss_scan_thread);
+
 	remove_proc_entry(hba[i]->devname, proc_cciss);
 	unregister_blkdev(hba[i]->major, hba[i]->devname);
 
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 15e2b84..703e080 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -121,6 +121,8 @@ struct ctlr_info
 	struct sendcmd_reject_list scsi_rejects;
 #endif
 	unsigned char alive;
+	struct completion *rescan_wait;
+	struct task_struct *cciss_scan_thread;
 };
 
 /*  Defining the diffent access_menthods */
diff --git a/drivers/block/cciss_cmd.h b/drivers/block/cciss_cmd.h
index 24e22de..40b1b92 100644
--- a/drivers/block/cciss_cmd.h
+++ b/drivers/block/cciss_cmd.h
@@ -25,6 +25,29 @@
 #define CMD_TIMEOUT             0x000B
 #define CMD_UNABORTABLE		0x000C
 
+/* Unit Attentions ASC's as defined for the MSA2012sa */
+#define POWER_OR_RESET			0x29
+#define STATE_CHANGED			0x2a
+#define UNIT_ATTENTION_CLEARED		0x2f
+#define LUN_FAILED			0x3e
+#define REPORT_LUNS_CHANGED		0x3f
+
+/* Unit Attentions ASCQ's as defined for the MSA2012sa */
+
+	/* These ASCQ's defined for ASC = POWER_OR_RESET */
+#define POWER_ON_RESET			0x00
+#define POWER_ON_REBOOT			0x01
+#define SCSI_BUS_RESET			0x02
+#define MSA_TARGET_RESET		0x03
+#define CONTROLLER_FAILOVER		0x04
+#define TRANSCEIVER_SE			0x05
+#define TRANSCEIVER_LVD			0x06
+
+	/* These ASCQ's defined for ASC = STATE_CHANGED */
+#define RESERVATION_PREEMPTED		0x03
+#define ASYM_ACCESS_CHANGED		0x06
+#define LUN_CAPACITY_CHANGED		0x09
+
 //transfer direction
 #define XFER_NONE               0x00
 #define XFER_WRITE              0x01
diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
new file mode 100644
index 0000000..fb39d9a
--- /dev/null
+++ b/drivers/block/mg_disk.c
@@ -0,0 +1,1005 @@
+/*
+ *  drivers/block/mg_disk.c
+ *
+ *  Support for the mGine m[g]flash IO mode.
+ *  Based on legacy hd.c
+ *
+ * (c) 2008 mGine Co.,LTD
+ * (c) 2008 unsik Kim <donari75@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/blkdev.h>
+#include <linux/hdreg.h>
+#include <linux/libata.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/mg_disk.h>
+
+#define MG_RES_SEC (CONFIG_MG_DISK_RES << 1)
+
+static void mg_request(struct request_queue *);
+
+static void mg_dump_status(const char *msg, unsigned int stat,
+		struct mg_host *host)
+{
+	char *name = MG_DISK_NAME;
+	struct request *req;
+
+	if (host->breq) {
+		req = elv_next_request(host->breq);
+		if (req)
+			name = req->rq_disk->disk_name;
+	}
+
+	printk(KERN_ERR "%s: %s: status=0x%02x { ", name, msg, stat & 0xff);
+	if (stat & MG_REG_STATUS_BIT_BUSY)
+		printk("Busy ");
+	if (stat & MG_REG_STATUS_BIT_READY)
+		printk("DriveReady ");
+	if (stat & MG_REG_STATUS_BIT_WRITE_FAULT)
+		printk("WriteFault ");
+	if (stat & MG_REG_STATUS_BIT_SEEK_DONE)
+		printk("SeekComplete ");
+	if (stat & MG_REG_STATUS_BIT_DATA_REQ)
+		printk("DataRequest ");
+	if (stat & MG_REG_STATUS_BIT_CORRECTED_ERROR)
+		printk("CorrectedError ");
+	if (stat & MG_REG_STATUS_BIT_ERROR)
+		printk("Error ");
+	printk("}\n");
+	if ((stat & MG_REG_STATUS_BIT_ERROR) == 0) {
+		host->error = 0;
+	} else {
+		host->error = inb((unsigned long)host->dev_base + MG_REG_ERROR);
+		printk(KERN_ERR "%s: %s: error=0x%02x { ", name, msg,
+				host->error & 0xff);
+		if (host->error & MG_REG_ERR_BBK)
+			printk("BadSector ");
+		if (host->error & MG_REG_ERR_UNC)
+			printk("UncorrectableError ");
+		if (host->error & MG_REG_ERR_IDNF)
+			printk("SectorIdNotFound ");
+		if (host->error & MG_REG_ERR_ABRT)
+			printk("DriveStatusError ");
+		if (host->error & MG_REG_ERR_AMNF)
+			printk("AddrMarkNotFound ");
+		printk("}");
+		if (host->error &
+				(MG_REG_ERR_BBK | MG_REG_ERR_UNC |
+				 MG_REG_ERR_IDNF | MG_REG_ERR_AMNF)) {
+			if (host->breq) {
+				req = elv_next_request(host->breq);
+				if (req)
+					printk(", sector=%ld", req->sector);
+			}
+
+		}
+		printk("\n");
+	}
+}
+
+static unsigned int mg_wait(struct mg_host *host, u32 expect, u32 msec)
+{
+	u8 status;
+	unsigned long expire, cur_jiffies;
+	struct mg_drv_data *prv_data = host->dev->platform_data;
+
+	host->error = MG_ERR_NONE;
+	expire = jiffies + msecs_to_jiffies(msec);
+
+	status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+
+	do {
+		cur_jiffies = jiffies;
+		if (status & MG_REG_STATUS_BIT_BUSY) {
+			if (expect == MG_REG_STATUS_BIT_BUSY)
+				break;
+		} else {
+			/* Check the error condition! */
+			if (status & MG_REG_STATUS_BIT_ERROR) {
+				mg_dump_status("mg_wait", status, host);
+				break;
+			}
+
+			if (expect == MG_STAT_READY)
+				if (MG_READY_OK(status))
+					break;
+
+			if (expect == MG_REG_STATUS_BIT_DATA_REQ)
+				if (status & MG_REG_STATUS_BIT_DATA_REQ)
+					break;
+		}
+		if (!msec) {
+			mg_dump_status("not ready", status, host);
+			return MG_ERR_INV_STAT;
+		}
+		if (prv_data->use_polling)
+			msleep(1);
+
+		status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+	} while (time_before(cur_jiffies, expire));
+
+	if (time_after_eq(cur_jiffies, expire) && msec)
+		host->error = MG_ERR_TIMEOUT;
+
+	return host->error;
+}
+
+static unsigned int mg_wait_rstout(u32 rstout, u32 msec)
+{
+	unsigned long expire;
+
+	expire = jiffies + msecs_to_jiffies(msec);
+	while (time_before(jiffies, expire)) {
+		if (gpio_get_value(rstout) == 1)
+			return MG_ERR_NONE;
+		msleep(10);
+	}
+
+	return MG_ERR_RSTOUT;
+}
+
+static void mg_unexpected_intr(struct mg_host *host)
+{
+	u32 status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+
+	mg_dump_status("mg_unexpected_intr", status, host);
+}
+
+static irqreturn_t mg_irq(int irq, void *dev_id)
+{
+	struct mg_host *host = dev_id;
+	void (*handler)(struct mg_host *) = host->mg_do_intr;
+
+	host->mg_do_intr = 0;
+	del_timer(&host->timer);
+	if (!handler)
+		handler = mg_unexpected_intr;
+	handler(host);
+	return IRQ_HANDLED;
+}
+
+static int mg_get_disk_id(struct mg_host *host)
+{
+	u32 i;
+	s32 err;
+	const u16 *id = host->id;
+	struct mg_drv_data *prv_data = host->dev->platform_data;
+	char fwrev[ATA_ID_FW_REV_LEN + 1];
+	char model[ATA_ID_PROD_LEN + 1];
+	char serial[ATA_ID_SERNO_LEN + 1];
+
+	if (!prv_data->use_polling)
+		outb(MG_REG_CTRL_INTR_DISABLE,
+				(unsigned long)host->dev_base +
+				MG_REG_DRV_CTRL);
+
+	outb(MG_CMD_ID, (unsigned long)host->dev_base + MG_REG_COMMAND);
+	err = mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ, MG_TMAX_WAIT_RD_DRQ);
+	if (err)
+		return err;
+
+	for (i = 0; i < (MG_SECTOR_SIZE >> 1); i++)
+		host->id[i] = le16_to_cpu(inw((unsigned long)host->dev_base +
+					MG_BUFF_OFFSET + i * 2));
+
+	outb(MG_CMD_RD_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
+	err = mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD);
+	if (err)
+		return err;
+
+	if ((id[ATA_ID_FIELD_VALID] & 1) == 0)
+		return MG_ERR_TRANSLATION;
+
+	host->n_sectors = ata_id_u32(id, ATA_ID_LBA_CAPACITY);
+	host->cyls = id[ATA_ID_CYLS];
+	host->heads = id[ATA_ID_HEADS];
+	host->sectors = id[ATA_ID_SECTORS];
+
+	if (MG_RES_SEC && host->heads && host->sectors) {
+		/* modify cyls, n_sectors */
+		host->cyls = (host->n_sectors - MG_RES_SEC) /
+			host->heads / host->sectors;
+		host->nres_sectors = host->n_sectors - host->cyls *
+			host->heads * host->sectors;
+		host->n_sectors -= host->nres_sectors;
+	}
+
+	ata_id_c_string(id, fwrev, ATA_ID_FW_REV, sizeof(fwrev));
+	ata_id_c_string(id, model, ATA_ID_PROD, sizeof(model));
+	ata_id_c_string(id, serial, ATA_ID_SERNO, sizeof(serial));
+	printk(KERN_INFO "mg_disk: model: %s\n", model);
+	printk(KERN_INFO "mg_disk: firm: %.8s\n", fwrev);
+	printk(KERN_INFO "mg_disk: serial: %s\n", serial);
+	printk(KERN_INFO "mg_disk: %d + reserved %d sectors\n",
+			host->n_sectors, host->nres_sectors);
+
+	if (!prv_data->use_polling)
+		outb(MG_REG_CTRL_INTR_ENABLE, (unsigned long)host->dev_base +
+				MG_REG_DRV_CTRL);
+
+	return err;
+}
+
+
+static int mg_disk_init(struct mg_host *host)
+{
+	struct mg_drv_data *prv_data = host->dev->platform_data;
+	s32 err;
+	u8 init_status;
+
+	/* hdd rst low */
+	gpio_set_value(host->rst, 0);
+	err = mg_wait(host, MG_REG_STATUS_BIT_BUSY, MG_TMAX_RST_TO_BUSY);
+	if (err)
+		return err;
+
+	/* hdd rst high */
+	gpio_set_value(host->rst, 1);
+	err = mg_wait(host, MG_STAT_READY, MG_TMAX_HDRST_TO_RDY);
+	if (err)
+		return err;
+
+	/* soft reset on */
+	outb(MG_REG_CTRL_RESET |
+			(prv_data->use_polling ? MG_REG_CTRL_INTR_DISABLE :
+			 MG_REG_CTRL_INTR_ENABLE),
+			(unsigned long)host->dev_base + MG_REG_DRV_CTRL);
+	err = mg_wait(host, MG_REG_STATUS_BIT_BUSY, MG_TMAX_RST_TO_BUSY);
+	if (err)
+		return err;
+
+	/* soft reset off */
+	outb(prv_data->use_polling ? MG_REG_CTRL_INTR_DISABLE :
+			MG_REG_CTRL_INTR_ENABLE,
+			(unsigned long)host->dev_base + MG_REG_DRV_CTRL);
+	err = mg_wait(host, MG_STAT_READY, MG_TMAX_SWRST_TO_RDY);
+	if (err)
+		return err;
+
+	init_status = inb((unsigned long)host->dev_base + MG_REG_STATUS) & 0xf;
+
+	if (init_status == 0xf)
+		return MG_ERR_INIT_STAT;
+
+	return err;
+}
+
+static void mg_bad_rw_intr(struct mg_host *host)
+{
+	struct request *req = elv_next_request(host->breq);
+	if (req != NULL)
+		if (++req->errors >= MG_MAX_ERRORS ||
+				host->error == MG_ERR_TIMEOUT)
+			end_request(req, 0);
+}
+
+static unsigned int mg_out(struct mg_host *host,
+		unsigned int sect_num,
+		unsigned int sect_cnt,
+		unsigned int cmd,
+		void (*intr_addr)(struct mg_host *))
+{
+	struct mg_drv_data *prv_data = host->dev->platform_data;
+
+	if (mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD))
+		return host->error;
+
+	if (!prv_data->use_polling) {
+		host->mg_do_intr = intr_addr;
+		mod_timer(&host->timer, jiffies + 3 * HZ);
+	}
+	if (MG_RES_SEC)
+		sect_num += MG_RES_SEC;
+	outb((u8)sect_cnt, (unsigned long)host->dev_base + MG_REG_SECT_CNT);
+	outb((u8)sect_num, (unsigned long)host->dev_base + MG_REG_SECT_NUM);
+	outb((u8)(sect_num >> 8), (unsigned long)host->dev_base +
+			MG_REG_CYL_LOW);
+	outb((u8)(sect_num >> 16), (unsigned long)host->dev_base +
+			MG_REG_CYL_HIGH);
+	outb((u8)((sect_num >> 24) | MG_REG_HEAD_LBA_MODE),
+			(unsigned long)host->dev_base + MG_REG_DRV_HEAD);
+	outb(cmd, (unsigned long)host->dev_base + MG_REG_COMMAND);
+	return MG_ERR_NONE;
+}
+
+static void mg_read(struct request *req)
+{
+	u32 remains, j;
+	struct mg_host *host = req->rq_disk->private_data;
+
+	remains = req->nr_sectors;
+
+	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_RD, 0) !=
+			MG_ERR_NONE)
+		mg_bad_rw_intr(host);
+
+	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
+			remains, req->sector, req->buffer);
+
+	while (remains) {
+		if (mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ,
+					MG_TMAX_WAIT_RD_DRQ) != MG_ERR_NONE) {
+			mg_bad_rw_intr(host);
+			return;
+		}
+		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++) {
+			*(u16 *)req->buffer =
+				inw((unsigned long)host->dev_base +
+						MG_BUFF_OFFSET + (j << 1));
+			req->buffer += 2;
+		}
+
+		req->sector++;
+		req->errors = 0;
+		remains = --req->nr_sectors;
+		--req->current_nr_sectors;
+
+		if (req->current_nr_sectors <= 0) {
+			MG_DBG("remain : %d sects\n", remains);
+			end_request(req, 1);
+			if (remains > 0)
+				req = elv_next_request(host->breq);
+		}
+
+		outb(MG_CMD_RD_CONF, (unsigned long)host->dev_base +
+				MG_REG_COMMAND);
+	}
+}
+
+static void mg_write(struct request *req)
+{
+	u32 remains, j;
+	struct mg_host *host = req->rq_disk->private_data;
+
+	remains = req->nr_sectors;
+
+	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_WR, 0) !=
+			MG_ERR_NONE) {
+		mg_bad_rw_intr(host);
+		return;
+	}
+
+
+	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
+			remains, req->sector, req->buffer);
+	while (remains) {
+		if (mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ,
+					MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
+			mg_bad_rw_intr(host);
+			return;
+		}
+		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++) {
+			outw(*(u16 *)req->buffer,
+					(unsigned long)host->dev_base +
+					MG_BUFF_OFFSET + (j << 1));
+			req->buffer += 2;
+		}
+		req->sector++;
+		remains = --req->nr_sectors;
+		--req->current_nr_sectors;
+
+		if (req->current_nr_sectors <= 0) {
+			MG_DBG("remain : %d sects\n", remains);
+			end_request(req, 1);
+			if (remains > 0)
+				req = elv_next_request(host->breq);
+		}
+
+		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
+				MG_REG_COMMAND);
+	}
+}
+
+static void mg_read_intr(struct mg_host *host)
+{
+	u32 i;
+	struct request *req;
+
+	/* check status */
+	do {
+		i = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+		if (i & MG_REG_STATUS_BIT_BUSY)
+			break;
+		if (!MG_READY_OK(i))
+			break;
+		if (i & MG_REG_STATUS_BIT_DATA_REQ)
+			goto ok_to_read;
+	} while (0);
+	mg_dump_status("mg_read_intr", i, host);
+	mg_bad_rw_intr(host);
+	mg_request(host->breq);
+	return;
+
+ok_to_read:
+	/* get current segment of request */
+	req = elv_next_request(host->breq);
+
+	/* read 1 sector */
+	for (i = 0; i < MG_SECTOR_SIZE >> 1; i++) {
+		*(u16 *)req->buffer =
+			inw((unsigned long)host->dev_base + MG_BUFF_OFFSET +
+					(i << 1));
+		req->buffer += 2;
+	}
+
+	/* manipulate request */
+	MG_DBG("sector %ld, remaining=%ld, buffer=0x%p\n",
+			req->sector, req->nr_sectors - 1, req->buffer);
+
+	req->sector++;
+	req->errors = 0;
+	i = --req->nr_sectors;
+	--req->current_nr_sectors;
+
+	/* let know if current segment done */
+	if (req->current_nr_sectors <= 0)
+		end_request(req, 1);
+
+	/* set handler if read remains */
+	if (i > 0) {
+		host->mg_do_intr = mg_read_intr;
+		mod_timer(&host->timer, jiffies + 3 * HZ);
+	}
+
+	/* send read confirm */
+	outb(MG_CMD_RD_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
+
+	/* goto next request */
+	if (!i)
+		mg_request(host->breq);
+}
+
+static void mg_write_intr(struct mg_host *host)
+{
+	u32 i, j;
+	u16 *buff;
+	struct request *req;
+
+	/* get current segment of request */
+	req = elv_next_request(host->breq);
+
+	/* check status */
+	do {
+		i = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+		if (i & MG_REG_STATUS_BIT_BUSY)
+			break;
+		if (!MG_READY_OK(i))
+			break;
+		if ((req->nr_sectors <= 1) || (i & MG_REG_STATUS_BIT_DATA_REQ))
+			goto ok_to_write;
+	} while (0);
+	mg_dump_status("mg_write_intr", i, host);
+	mg_bad_rw_intr(host);
+	mg_request(host->breq);
+	return;
+
+ok_to_write:
+	/* manipulate request */
+	req->sector++;
+	i = --req->nr_sectors;
+	--req->current_nr_sectors;
+	req->buffer += MG_SECTOR_SIZE;
+
+	/* let know if current segment or all done */
+	if (!i || (req->bio && req->current_nr_sectors <= 0))
+		end_request(req, 1);
+
+	/* write 1 sector and set handler if remains */
+	if (i > 0) {
+		buff = (u16 *)req->buffer;
+		for (j = 0; j < MG_STORAGE_BUFFER_SIZE >> 1; j++) {
+			outw(*buff, (unsigned long)host->dev_base +
+					MG_BUFF_OFFSET + (j << 1));
+			buff++;
+		}
+		MG_DBG("sector %ld, remaining=%ld, buffer=0x%p\n",
+				req->sector, req->nr_sectors, req->buffer);
+		host->mg_do_intr = mg_write_intr;
+		mod_timer(&host->timer, jiffies + 3 * HZ);
+	}
+
+	/* send write confirm */
+	outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
+
+	if (!i)
+		mg_request(host->breq);
+}
+
+void mg_times_out(unsigned long data)
+{
+	struct mg_host *host = (struct mg_host *)data;
+	char *name;
+	struct request *req;
+
+	req = elv_next_request(host->breq);
+	if (!req)
+		return;
+
+	host->mg_do_intr = NULL;
+
+	name = req->rq_disk->disk_name;
+	printk(KERN_DEBUG "%s: timeout\n", name);
+
+	host->error = MG_ERR_TIMEOUT;
+	mg_bad_rw_intr(host);
+
+	mg_request(host->breq);
+}
+
+static void mg_request_poll(struct request_queue *q)
+{
+	struct request *req;
+	struct mg_host *host;
+
+	while ((req = elv_next_request(q)) != NULL) {
+		host = req->rq_disk->private_data;
+		if (blk_fs_request(req)) {
+			switch (rq_data_dir(req)) {
+			case READ:
+				mg_read(req);
+				break;
+			case WRITE:
+				mg_write(req);
+				break;
+			default:
+				printk(KERN_WARNING "%s:%d unknown command\n",
+						__func__, __LINE__);
+				end_request(req, 0);
+				break;
+			}
+		}
+	}
+}
+
+static unsigned int mg_issue_req(struct request *req,
+		struct mg_host *host,
+		unsigned int sect_num,
+		unsigned int sect_cnt)
+{
+	u16 *buff;
+	u32 i;
+
+	switch (rq_data_dir(req)) {
+	case READ:
+		if (mg_out(host, sect_num, sect_cnt, MG_CMD_RD, &mg_read_intr)
+				!= MG_ERR_NONE) {
+			mg_bad_rw_intr(host);
+			return host->error;
+		}
+		break;
+	case WRITE:
+		/* TODO : handler */
+		outb(MG_REG_CTRL_INTR_DISABLE,
+				(unsigned long)host->dev_base +
+				MG_REG_DRV_CTRL);
+		if (mg_out(host, sect_num, sect_cnt, MG_CMD_WR, &mg_write_intr)
+				!= MG_ERR_NONE) {
+			mg_bad_rw_intr(host);
+			return host->error;
+		}
+		del_timer(&host->timer);
+		mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ, MG_TMAX_WAIT_WR_DRQ);
+		outb(MG_REG_CTRL_INTR_ENABLE, (unsigned long)host->dev_base +
+				MG_REG_DRV_CTRL);
+		if (host->error) {
+			mg_bad_rw_intr(host);
+			return host->error;
+		}
+		buff = (u16 *)req->buffer;
+		for (i = 0; i < MG_SECTOR_SIZE >> 1; i++) {
+			outw(*buff, (unsigned long)host->dev_base +
+					MG_BUFF_OFFSET + (i << 1));
+			buff++;
+		}
+		mod_timer(&host->timer, jiffies + 3 * HZ);
+		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
+				MG_REG_COMMAND);
+		break;
+	default:
+		printk(KERN_WARNING "%s:%d unknown command\n",
+				__func__, __LINE__);
+		end_request(req, 0);
+		break;
+	}
+	return MG_ERR_NONE;
+}
+
+/* This function also called from IRQ context */
+static void mg_request(struct request_queue *q)
+{
+	struct request *req;
+	struct mg_host *host;
+	u32 sect_num, sect_cnt;
+
+	while (1) {
+		req = elv_next_request(q);
+		if (!req)
+			return;
+
+		host = req->rq_disk->private_data;
+
+		/* check unwanted request call */
+		if (host->mg_do_intr)
+			return;
+
+		del_timer(&host->timer);
+
+		sect_num = req->sector;
+		/* deal whole segments */
+		sect_cnt = req->nr_sectors;
+
+		/* sanity check */
+		if (sect_num >= get_capacity(req->rq_disk) ||
+				((sect_num + sect_cnt) >
+				 get_capacity(req->rq_disk))) {
+			printk(KERN_WARNING
+					"%s: bad access: sector=%d, count=%d\n",
+					req->rq_disk->disk_name,
+					sect_num, sect_cnt);
+			end_request(req, 0);
+			continue;
+		}
+
+		if (!blk_fs_request(req))
+			return;
+
+		if (!mg_issue_req(req, host, sect_num, sect_cnt))
+			return;
+	}
+}
+
+static int mg_getgeo(struct block_device *bdev, struct hd_geometry *geo)
+{
+	struct mg_host *host = bdev->bd_disk->private_data;
+
+	geo->cylinders = (unsigned short)host->cyls;
+	geo->heads = (unsigned char)host->heads;
+	geo->sectors = (unsigned char)host->sectors;
+	return 0;
+}
+
+static struct block_device_operations mg_disk_ops = {
+	.getgeo = mg_getgeo
+};
+
+static int mg_suspend(struct platform_device *plat_dev, pm_message_t state)
+{
+	struct mg_drv_data *prv_data = plat_dev->dev.platform_data;
+	struct mg_host *host = prv_data->host;
+
+	if (mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD))
+		return -EIO;
+
+	if (!prv_data->use_polling)
+		outb(MG_REG_CTRL_INTR_DISABLE,
+				(unsigned long)host->dev_base +
+				MG_REG_DRV_CTRL);
+
+	outb(MG_CMD_SLEEP, (unsigned long)host->dev_base + MG_REG_COMMAND);
+	/* wait until mflash deep sleep */
+	msleep(1);
+
+	if (mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD)) {
+		if (!prv_data->use_polling)
+			outb(MG_REG_CTRL_INTR_ENABLE,
+					(unsigned long)host->dev_base +
+					MG_REG_DRV_CTRL);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int mg_resume(struct platform_device *plat_dev)
+{
+	struct mg_drv_data *prv_data = plat_dev->dev.platform_data;
+	struct mg_host *host = prv_data->host;
+
+	if (mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD))
+		return -EIO;
+
+	outb(MG_CMD_WAKEUP, (unsigned long)host->dev_base + MG_REG_COMMAND);
+	/* wait until mflash wakeup */
+	msleep(1);
+
+	if (mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD))
+		return -EIO;
+
+	if (!prv_data->use_polling)
+		outb(MG_REG_CTRL_INTR_ENABLE, (unsigned long)host->dev_base +
+				MG_REG_DRV_CTRL);
+
+	return 0;
+}
+
+static int mg_probe(struct platform_device *plat_dev)
+{
+	struct mg_host *host;
+	struct resource *rsc;
+	struct mg_drv_data *prv_data = plat_dev->dev.platform_data;
+	int err = 0;
+
+	if (!prv_data) {
+		printk(KERN_ERR	"%s:%d fail (no driver_data)\n",
+				__func__, __LINE__);
+		err = -EINVAL;
+		goto probe_err;
+	}
+
+	/* alloc mg_host */
+	host = kzalloc(sizeof(struct mg_host), GFP_KERNEL);
+	if (!host) {
+		printk(KERN_ERR "%s:%d fail (no memory for mg_host)\n",
+				__func__, __LINE__);
+		err = -ENOMEM;
+		goto probe_err;
+	}
+	host->major = MG_DISK_MAJ;
+
+	/* link each other */
+	prv_data->host = host;
+	host->dev = &plat_dev->dev;
+
+	/* io remap */
+	rsc = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
+	if (!rsc) {
+		printk(KERN_ERR "%s:%d platform_get_resource fail\n",
+				__func__, __LINE__);
+		err = -EINVAL;
+		goto probe_err_2;
+	}
+	host->dev_base = ioremap(rsc->start , rsc->end + 1);
+	if (!host->dev_base) {
+		printk(KERN_ERR "%s:%d ioremap fail\n",
+				__func__, __LINE__);
+		err = -EIO;
+		goto probe_err_2;
+	}
+	MG_DBG("dev_base = 0x%x\n", (u32)host->dev_base);
+
+	/* get reset pin */
+	rsc = platform_get_resource_byname(plat_dev, IORESOURCE_IO,
+			MG_RST_PIN);
+	if (!rsc) {
+		printk(KERN_ERR "%s:%d get reset pin fail\n",
+				__func__, __LINE__);
+		err = -EIO;
+		goto probe_err_3;
+	}
+	host->rst = rsc->start;
+
+	/* init rst pin */
+	err = gpio_request(host->rst, MG_RST_PIN);
+	if (err)
+		goto probe_err_3;
+	gpio_direction_output(host->rst, 1);
+
+	/* reset out pin */
+	if (!(prv_data->dev_attr & MG_DEV_MASK))
+		goto probe_err_3a;
+
+	if (prv_data->dev_attr != MG_BOOT_DEV) {
+		rsc = platform_get_resource_byname(plat_dev, IORESOURCE_IO,
+				MG_RSTOUT_PIN);
+		if (!rsc) {
+			printk(KERN_ERR "%s:%d get reset-out pin fail\n",
+					__func__, __LINE__);
+			err = -EIO;
+			goto probe_err_3a;
+		}
+		host->rstout = rsc->start;
+		err = gpio_request(host->rstout, MG_RSTOUT_PIN);
+		if (err)
+			goto probe_err_3a;
+		gpio_direction_input(host->rstout);
+	}
+
+	/* disk reset */
+	if (prv_data->dev_attr == MG_STORAGE_DEV) {
+		/* If POR seq. not yet finised, wait */
+		err = mg_wait_rstout(host->rstout, MG_TMAX_RSTOUT);
+		if (err)
+			goto probe_err_3b;
+		err = mg_disk_init(host);
+		if (err) {
+			printk(KERN_ERR "%s:%d fail (err code : %d)\n",
+					__func__, __LINE__, err);
+			err = -EIO;
+			goto probe_err_3b;
+		}
+	}
+
+	/* get irq resource */
+	if (!prv_data->use_polling) {
+		host->irq = platform_get_irq(plat_dev, 0);
+		if (host->irq == -ENXIO) {
+			err = host->irq;
+			goto probe_err_3b;
+		}
+		err = request_irq(host->irq, mg_irq,
+				IRQF_DISABLED | IRQF_TRIGGER_RISING,
+				MG_DEV_NAME, host);
+		if (err) {
+			printk(KERN_ERR "%s:%d fail (request_irq err=%d)\n",
+					__func__, __LINE__, err);
+			goto probe_err_3b;
+		}
+
+	}
+
+	/* get disk id */
+	err = mg_get_disk_id(host);
+	if (err) {
+		printk(KERN_ERR "%s:%d fail (err code : %d)\n",
+				__func__, __LINE__, err);
+		err = -EIO;
+		goto probe_err_4;
+	}
+
+	err = register_blkdev(host->major, MG_DISK_NAME);
+	if (err < 0) {
+		printk(KERN_ERR "%s:%d register_blkdev fail (err code : %d)\n",
+				__func__, __LINE__, err);
+		goto probe_err_4;
+	}
+	if (!host->major)
+		host->major = err;
+
+	spin_lock_init(&host->lock);
+
+	if (prv_data->use_polling)
+		host->breq = blk_init_queue(mg_request_poll, &host->lock);
+	else
+		host->breq = blk_init_queue(mg_request, &host->lock);
+
+	if (!host->breq) {
+		err = -ENOMEM;
+		printk(KERN_ERR "%s:%d (blk_init_queue) fail\n",
+				__func__, __LINE__);
+		goto probe_err_5;
+	}
+
+	/* mflash is random device, thanx for the noop */
+	elevator_exit(host->breq->elevator);
+	err = elevator_init(host->breq, "noop");
+	if (err) {
+		printk(KERN_ERR "%s:%d (elevator_init) fail\n",
+				__func__, __LINE__);
+		goto probe_err_6;
+	}
+	blk_queue_max_sectors(host->breq, MG_MAX_SECTS);
+	blk_queue_hardsect_size(host->breq, MG_SECTOR_SIZE);
+
+	init_timer(&host->timer);
+	host->timer.function = mg_times_out;
+	host->timer.data = (unsigned long)host;
+
+	host->gd = alloc_disk(MG_DISK_MAX_PART);
+	if (!host->gd) {
+		printk(KERN_ERR "%s:%d (alloc_disk) fail\n",
+				__func__, __LINE__);
+		err = -ENOMEM;
+		goto probe_err_7;
+	}
+	host->gd->major = host->major;
+	host->gd->first_minor = 0;
+	host->gd->fops = &mg_disk_ops;
+	host->gd->queue = host->breq;
+	host->gd->private_data = host;
+	sprintf(host->gd->disk_name, MG_DISK_NAME"a");
+
+	set_capacity(host->gd, host->n_sectors);
+
+	add_disk(host->gd);
+
+	return err;
+
+probe_err_7:
+	del_timer_sync(&host->timer);
+probe_err_6:
+	blk_cleanup_queue(host->breq);
+probe_err_5:
+	unregister_blkdev(MG_DISK_MAJ, MG_DISK_NAME);
+probe_err_4:
+	if (!prv_data->use_polling)
+		free_irq(host->irq, host);
+probe_err_3b:
+	gpio_free(host->rstout);
+probe_err_3a:
+	gpio_free(host->rst);
+probe_err_3:
+	iounmap(host->dev_base);
+probe_err_2:
+	kfree(host);
+probe_err:
+	return err;
+}
+
+static int mg_remove(struct platform_device *plat_dev)
+{
+	struct mg_drv_data *prv_data = plat_dev->dev.platform_data;
+	struct mg_host *host = prv_data->host;
+	int err = 0;
+
+	/* delete timer */
+	del_timer_sync(&host->timer);
+
+	/* remove disk */
+	if (host->gd) {
+		del_gendisk(host->gd);
+		put_disk(host->gd);
+	}
+	/* remove queue */
+	if (host->breq)
+		blk_cleanup_queue(host->breq);
+
+	/* unregister blk device */
+	unregister_blkdev(host->major, MG_DISK_NAME);
+
+	/* free irq */
+	if (!prv_data->use_polling)
+		free_irq(host->irq, host);
+
+	/* free reset-out pin */
+	if (prv_data->dev_attr != MG_BOOT_DEV)
+		gpio_free(host->rstout);
+
+	/* free rst pin */
+	if (host->rst)
+		gpio_free(host->rst);
+
+	/* unmap io */
+	if (host->dev_base)
+		iounmap(host->dev_base);
+
+	/* free mg_host */
+	kfree(host);
+
+	return err;
+}
+
+static struct platform_driver mg_disk_driver = {
+	.probe = mg_probe,
+	.remove = mg_remove,
+	.suspend = mg_suspend,
+	.resume = mg_resume,
+	.driver = {
+		.name = MG_DEV_NAME,
+		.owner = THIS_MODULE,
+	}
+};
+
+/****************************************************************************
+ *
+ * Module stuff
+ *
+ ****************************************************************************/
+
+static int __init mg_init(void)
+{
+	printk(KERN_INFO "mGine mflash driver, (c) 2008 mGine Co.\n");
+	return platform_driver_register(&mg_disk_driver);
+}
+
+static void __exit mg_exit(void)
+{
+	printk(KERN_INFO "mflash driver : bye bye\n");
+	platform_driver_unregister(&mg_disk_driver);
+}
+
+module_init(mg_init);
+module_exit(mg_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("unsik Kim <donari75@gmail.com>");
+MODULE_DESCRIPTION("mGine m[g]flash device driver");
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e036609..ba54c83 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -117,7 +117,6 @@ enum rq_flag_bits {
 	__REQ_RW_META,		/* metadata io request */
 	__REQ_COPY_USER,	/* contains copies of user pages */
 	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
-	__REQ_UNPLUG,		/* unplug queue on submission */
 	__REQ_NOIDLE,		/* Don't anticipate more IO after this one */
 	__REQ_NR_BITS,		/* stops here */
 };
@@ -145,7 +144,6 @@ enum rq_flag_bits {
 #define REQ_RW_META	(1 << __REQ_RW_META)
 #define REQ_COPY_USER	(1 << __REQ_COPY_USER)
 #define REQ_INTEGRITY	(1 << __REQ_INTEGRITY)
-#define REQ_UNPLUG	(1 << __REQ_UNPLUG)
 #define REQ_NOIDLE	(1 << __REQ_NOIDLE)
 
 #define BLK_MAX_CDB	16
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 7a20425..c59b769 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -116,6 +116,7 @@ extern void elv_abort_queue(struct request_queue *);
 extern void elv_completed_request(struct request_queue *, struct request *);
 extern int elv_set_request(struct request_queue *, struct request *, gfp_t);
 extern void elv_put_request(struct request_queue *, struct request *);
+extern void elv_drain_elevator(struct request_queue *);
 
 /*
  * io scheduler registration
diff --git a/include/linux/mg_disk.h b/include/linux/mg_disk.h
new file mode 100644
index 0000000..1f76b1e
--- /dev/null
+++ b/include/linux/mg_disk.h
@@ -0,0 +1,206 @@
+/*
+ *  include/linux/mg_disk.c
+ *
+ *  Support for the mGine m[g]flash IO mode.
+ *  Based on legacy hd.c
+ *
+ * (c) 2008 mGine Co.,LTD
+ * (c) 2008 unsik Kim <donari75@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#ifndef __MG_DISK_H__
+#define __MG_DISK_H__
+
+#include <linux/blkdev.h>
+#include <linux/ata.h>
+
+/* name for block device */
+#define MG_DISK_NAME "mgd"
+/* name for platform device */
+#define MG_DEV_NAME "mg_disk"
+
+#define MG_DISK_MAJ 0
+#define MG_DISK_MAX_PART 16
+#define MG_SECTOR_SIZE 512
+#define MG_MAX_SECTS 256
+
+/* Register offsets */
+#define MG_BUFF_OFFSET			0x8000
+#define MG_STORAGE_BUFFER_SIZE		0x200
+#define MG_REG_OFFSET			0xC000
+#define MG_REG_FEATURE			(MG_REG_OFFSET + 2)	/* write case */
+#define MG_REG_ERROR			(MG_REG_OFFSET + 2)	/* read case */
+#define MG_REG_SECT_CNT			(MG_REG_OFFSET + 4)
+#define MG_REG_SECT_NUM			(MG_REG_OFFSET + 6)
+#define MG_REG_CYL_LOW			(MG_REG_OFFSET + 8)
+#define MG_REG_CYL_HIGH			(MG_REG_OFFSET + 0xA)
+#define MG_REG_DRV_HEAD			(MG_REG_OFFSET + 0xC)
+#define MG_REG_COMMAND			(MG_REG_OFFSET + 0xE)	/* write case */
+#define MG_REG_STATUS			(MG_REG_OFFSET + 0xE)	/* read  case */
+#define MG_REG_DRV_CTRL			(MG_REG_OFFSET + 0x10)
+#define MG_REG_BURST_CTRL		(MG_REG_OFFSET + 0x12)
+
+/* "Drive Select/Head Register" bit values */
+#define MG_REG_HEAD_MUST_BE_ON		0xA0 /* These 2 bits are always on */
+#define MG_REG_HEAD_DRIVE_MASTER	(0x00 | MG_REG_HEAD_MUST_BE_ON)
+#define MG_REG_HEAD_DRIVE_SLAVE		(0x10 | MG_REG_HEAD_MUST_BE_ON)
+#define MG_REG_HEAD_LBA_MODE		(0x40 | MG_REG_HEAD_MUST_BE_ON)
+
+
+/* "Device Control Register" bit values */
+#define MG_REG_CTRL_INTR_ENABLE			0x0
+#define MG_REG_CTRL_INTR_DISABLE		(0x1<<1)
+#define MG_REG_CTRL_RESET			(0x1<<2)
+#define MG_REG_CTRL_INTR_POLA_ACTIVE_HIGH	0x0
+#define MG_REG_CTRL_INTR_POLA_ACTIVE_LOW	(0x1<<4)
+#define MG_REG_CTRL_DPD_POLA_ACTIVE_LOW		0x0
+#define MG_REG_CTRL_DPD_POLA_ACTIVE_HIGH	(0x1<<5)
+#define MG_REG_CTRL_DPD_DISABLE			0x0
+#define MG_REG_CTRL_DPD_ENABLE			(0x1<<6)
+
+/* Status register bit */
+/* error bit in status register */
+#define MG_REG_STATUS_BIT_ERROR			0x01
+/* corrected error in status register */
+#define MG_REG_STATUS_BIT_CORRECTED_ERROR	0x04
+/* data request bit in status register */
+#define MG_REG_STATUS_BIT_DATA_REQ		0x08
+/* DSC - Drive Seek Complete */
+#define MG_REG_STATUS_BIT_SEEK_DONE		0x10
+/* DWF - Drive Write Fault */
+#define MG_REG_STATUS_BIT_WRITE_FAULT		0x20
+#define MG_REG_STATUS_BIT_READY			0x40
+#define MG_REG_STATUS_BIT_BUSY			0x80
+
+/* handy status */
+#define MG_STAT_READY	(MG_REG_STATUS_BIT_READY | MG_REG_STATUS_BIT_SEEK_DONE)
+#define MG_READY_OK(s)	(((s) & (MG_STAT_READY | \
+				(MG_REG_STATUS_BIT_BUSY | \
+				 MG_REG_STATUS_BIT_WRITE_FAULT | \
+				 MG_REG_STATUS_BIT_ERROR))) == MG_STAT_READY)
+
+/* Error register */
+#define MG_REG_ERR_AMNF		0x01
+#define MG_REG_ERR_ABRT		0x04
+#define MG_REG_ERR_IDNF		0x10
+#define MG_REG_ERR_UNC		0x40
+#define MG_REG_ERR_BBK		0x80
+
+/* error code for others */
+#define MG_ERR_NONE		0
+#define MG_ERR_TIMEOUT		0x100
+#define MG_ERR_INIT_STAT	0x101
+#define MG_ERR_TRANSLATION	0x102
+#define MG_ERR_CTRL_RST		0x103
+#define MG_ERR_INV_STAT		0x104
+#define MG_ERR_RSTOUT		0x105
+
+#define MG_MAX_ERRORS	6	/* Max read/write errors */
+
+/* command */
+#define MG_CMD_RD 0x20
+#define MG_CMD_WR 0x30
+#define MG_CMD_SLEEP 0x99
+#define MG_CMD_WAKEUP 0xC3
+#define MG_CMD_ID 0xEC
+#define MG_CMD_WR_CONF 0x3C
+#define MG_CMD_RD_CONF 0x40
+
+/* operation mode */
+#define MG_OP_CASCADE (1 << 0)
+#define MG_OP_CASCADE_SYNC_RD (1 << 1)
+#define MG_OP_CASCADE_SYNC_WR (1 << 2)
+#define MG_OP_INTERLEAVE (1 << 3)
+
+/* synchronous */
+#define MG_BURST_LAT_4 (3 << 4)
+#define MG_BURST_LAT_5 (4 << 4)
+#define MG_BURST_LAT_6 (5 << 4)
+#define MG_BURST_LAT_7 (6 << 4)
+#define MG_BURST_LAT_8 (7 << 4)
+#define MG_BURST_LEN_4 (1 << 1)
+#define MG_BURST_LEN_8 (2 << 1)
+#define MG_BURST_LEN_16 (3 << 1)
+#define MG_BURST_LEN_32 (4 << 1)
+#define MG_BURST_LEN_CONT (0 << 1)
+
+/* timeout value (unit: ms) */
+#define MG_TMAX_CONF_TO_CMD	1
+#define MG_TMAX_WAIT_RD_DRQ	10
+#define MG_TMAX_WAIT_WR_DRQ	500
+#define MG_TMAX_RST_TO_BUSY	10
+#define MG_TMAX_HDRST_TO_RDY	500
+#define MG_TMAX_SWRST_TO_RDY	500
+#define MG_TMAX_RSTOUT		3000
+
+/* device attribution */
+/* use mflash as boot device */
+#define MG_BOOT_DEV		(1 << 0)
+/* use mflash as storage device */
+#define MG_STORAGE_DEV		(1 << 1)
+/* same as MG_STORAGE_DEV, but bootloader already done reset sequence */
+#define MG_STORAGE_DEV_SKIP_RST	(1 << 2)
+
+#define MG_DEV_MASK (MG_BOOT_DEV | MG_STORAGE_DEV | MG_STORAGE_DEV_SKIP_RST)
+
+/* names of GPIO resource */
+#define MG_RST_PIN	"mg_rst"
+/* except MG_BOOT_DEV, reset-out pin should be assigned */
+#define MG_RSTOUT_PIN	"mg_rstout"
+
+/* private driver data */
+struct mg_drv_data {
+	/* disk resource */
+	u32 use_polling;
+
+	/* device attribution */
+	u32 dev_attr;
+
+	/* internally used */
+	struct mg_host *host;
+};
+
+/* main structure for mflash driver */
+struct mg_host {
+	struct device *dev;
+
+	struct request_queue *breq;
+	spinlock_t lock;
+	struct gendisk *gd;
+
+	struct timer_list timer;
+	void (*mg_do_intr) (struct mg_host *);
+
+	u16 id[ATA_ID_WORDS];
+
+	u16 cyls;
+	u16 heads;
+	u16 sectors;
+	u32 n_sectors;
+	u32 nres_sectors;
+
+	void __iomem *dev_base;
+	unsigned int irq;
+	unsigned int rst;
+	unsigned int rstout;
+
+	u32 major;
+	u32 error;
+};
+
+/*
+ * Debugging macro and defines
+ */
+#undef DO_MG_DEBUG
+#ifdef DO_MG_DEBUG
+#  define MG_DBG(fmt, args...) \
+	printk(KERN_DEBUG "%s:%d "fmt, __func__, __LINE__, ##args)
+#else /* CONFIG_MG_DEBUG */
+#  define MG_DBG(fmt, args...) do { } while (0)
+#endif /* CONFIG_MG_DEBUG */
+
+#endif

-- 
Jens Axboe

