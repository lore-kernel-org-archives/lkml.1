Return-Path: <linux-kernel-owner+w=401wt.eu-S1759127AbZDOKYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127AbZDOKYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZDOKYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:24:14 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37603 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbZDOKYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:24:08 -0400
Date: Wed, 15 Apr 2009 12:24:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] block/io bits for 2.6.30-rc2
Message-ID: <20090415102404.GW5178@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Somewhat bigger than expected, but it should be safe. Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Christoph Hellwig (1):
      block: move bio list helpers into bio.h

FUJITA Tomonori (1):
      block: fix SG_IO to return a proper error value

Jens Axboe (13):
      block: fix bad spelling of quiesce
      Document and move the various READ/WRITE types
      cfq-iosched: use rw_is_sync() to see if rw flags are sync or not
      cfq-iosched: get rid of private SYNC/ASYNC defines
      as-iosched: get rid of private REQ_SYNC/REQ_ASYNC defines
      block: update biodoc.txt on plugging
      buffer: switch do_emergency_thaw() away from pdflush_operation()
      cfq-iosched: don't delay queue kick for a merged request
      bio: add documentation to bio_alloc()
      cfq-iosched: no need to save interrupts in cfq_kick_queue()
      cfq-iosched: tweak kick logic a bit more
      cfq-iosched: log responsible 'cfqq' in idle timer arm
      cfq-iosched: add close cooperator code

Miklos Szeredi (6):
      splice: split up __splice_from_pipe()
      splice: remove i_mutex locking in splice_from_pipe()
      splice: fix i_mutex locking in generic_splice_write()
      ocfs2: fix i_mutex locking in ocfs2_splice_to_file()
      splice: remove generic_file_splice_write_nolock()
      splice: add helpers for locking pipe inode

Nick Piggin (2):
      brd: support barriers
      brd: fix cacheflushing

Nikanth Karthikesan (5):
      block: Remove code handling bio_alloc failure with __GFP_WAIT
      dio: Remove code handling bio_alloc failure with __GFP_WAIT
      ext4: Remove code handling bio_alloc failure with __GFP_WAIT
      gfs2: Remove code handling bio_alloc failure with __GFP_WAIT
      swap: Remove code handling bio_alloc failure with __GFP_WAIT

 Documentation/block/biodoc.txt |   19 +--
 block/as-iosched.c             |  116 ++++++-------
 block/blk-barrier.c            |    3 -
 block/blk-sysfs.c              |    4 +-
 block/blk.h                    |    4 +-
 block/cfq-iosched.c            |  270 ++++++++++++++++++++++++-----
 block/elevator.c               |    8 +-
 block/ioctl.c                  |    2 -
 block/scsi_ioctl.c             |    6 +-
 drivers/block/brd.c            |    5 +-
 drivers/md/dm-bio-list.h       |  117 -------------
 drivers/md/dm-delay.c          |    2 -
 drivers/md/dm-mpath.c          |    1 -
 drivers/md/dm-raid1.c          |    1 -
 drivers/md/dm-region-hash.c    |    1 -
 drivers/md/dm-snap.c           |    1 -
 drivers/md/dm.c                |    1 -
 drivers/md/raid1.c             |    1 -
 drivers/md/raid10.c            |    1 -
 fs/bio.c                       |   18 ++
 fs/buffer.c                    |   11 +-
 fs/direct-io.c                 |    2 -
 fs/ext4/extents.c              |    2 -
 fs/gfs2/ops_fstype.c           |    5 -
 fs/inode.c                     |   36 ----
 fs/ocfs2/file.c                |   94 ++++++++---
 fs/pipe.c                      |   42 ++++-
 fs/splice.c                    |  371 ++++++++++++++++++++--------------------
 include/linux/bio.h            |  109 ++++++++++++
 include/linux/fs.h             |   64 +++++++-
 include/linux/pipe_fs_i.h      |    5 +
 include/linux/splice.h         |   12 ++
 kernel/power/swap.c            |    2 -
 33 files changed, 814 insertions(+), 522 deletions(-)
 delete mode 100644 drivers/md/dm-bio-list.h

---

diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index ecad6ee..6fab97e 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -1040,23 +1040,21 @@ Front merges are handled by the binary trees in AS and deadline schedulers.
 iii. Plugging the queue to batch requests in anticipation of opportunities for
      merge/sort optimizations
 
-This is just the same as in 2.4 so far, though per-device unplugging
-support is anticipated for 2.5. Also with a priority-based i/o scheduler,
-such decisions could be based on request priorities.
-
 Plugging is an approach that the current i/o scheduling algorithm resorts to so
 that it collects up enough requests in the queue to be able to take
 advantage of the sorting/merging logic in the elevator. If the
 queue is empty when a request comes in, then it plugs the request queue
-(sort of like plugging the bottom of a vessel to get fluid to build up)
+(sort of like plugging the bath tub of a vessel to get fluid to build up)
 till it fills up with a few more requests, before starting to service
 the requests. This provides an opportunity to merge/sort the requests before
 passing them down to the device. There are various conditions when the queue is
 unplugged (to open up the flow again), either through a scheduled task or
 could be on demand. For example wait_on_buffer sets the unplugging going
-(by running tq_disk) so the read gets satisfied soon. So in the read case,
-the queue gets explicitly unplugged as part of waiting for completion,
-in fact all queues get unplugged as a side-effect.
+through sync_buffer() running blk_run_address_space(mapping). Or the caller
+can do it explicity through blk_unplug(bdev). So in the read case,
+the queue gets explicitly unplugged as part of waiting for completion on that
+buffer. For page driven IO, the address space ->sync_page() takes care of
+doing the blk_run_address_space().
 
 Aside:
   This is kind of controversial territory, as it's not clear if plugging is
@@ -1067,11 +1065,6 @@ Aside:
   multi-page bios being queued in one shot, we may not need to wait to merge
   a big request from the broken up pieces coming by.
 
-  Per-queue granularity unplugging (still a Todo) may help reduce some of the
-  concerns with just a single tq_disk flush approach. Something like
-  blk_kick_queue() to unplug a specific queue (right away ?)
-  or optionally, all queues, is in the plan.
-
 4.4 I/O contexts
 I/O contexts provide a dynamically allocated per process data area. They may
 be used in I/O schedulers, and in the block layer (could be used for IO statis,
diff --git a/block/as-iosched.c b/block/as-iosched.c
index 631f6f4..c48fa67 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -17,9 +17,6 @@
 #include <linux/rbtree.h>
 #include <linux/interrupt.h>
 
-#define REQ_SYNC	1
-#define REQ_ASYNC	0
-
 /*
  * See Documentation/block/as-iosched.txt
  */
@@ -93,7 +90,7 @@ struct as_data {
 	struct list_head fifo_list[2];
 
 	struct request *next_rq[2];	/* next in sort order */
-	sector_t last_sector[2];	/* last REQ_SYNC & REQ_ASYNC sectors */
+	sector_t last_sector[2];	/* last SYNC & ASYNC sectors */
 
 	unsigned long exit_prob;	/* probability a task will exit while
 					   being waited on */
@@ -109,7 +106,7 @@ struct as_data {
 	unsigned long last_check_fifo[2];
 	int changed_batch;		/* 1: waiting for old batch to end */
 	int new_batch;			/* 1: waiting on first read complete */
-	int batch_data_dir;		/* current batch REQ_SYNC / REQ_ASYNC */
+	int batch_data_dir;		/* current batch SYNC / ASYNC */
 	int write_batch_count;		/* max # of reqs in a write batch */
 	int current_write_count;	/* how many requests left this batch */
 	int write_batch_idled;		/* has the write batch gone idle? */
@@ -554,7 +551,7 @@ static void as_update_iohist(struct as_data *ad, struct as_io_context *aic,
 	if (aic == NULL)
 		return;
 
-	if (data_dir == REQ_SYNC) {
+	if (data_dir == BLK_RW_SYNC) {
 		unsigned long in_flight = atomic_read(&aic->nr_queued)
 					+ atomic_read(&aic->nr_dispatched);
 		spin_lock(&aic->lock);
@@ -811,7 +808,7 @@ static void as_update_rq(struct as_data *ad, struct request *rq)
  */
 static void update_write_batch(struct as_data *ad)
 {
-	unsigned long batch = ad->batch_expire[REQ_ASYNC];
+	unsigned long batch = ad->batch_expire[BLK_RW_ASYNC];
 	long write_time;
 
 	write_time = (jiffies - ad->current_batch_expires) + batch;
@@ -855,7 +852,7 @@ static void as_completed_request(struct request_queue *q, struct request *rq)
 		kblockd_schedule_work(q, &ad->antic_work);
 		ad->changed_batch = 0;
 
-		if (ad->batch_data_dir == REQ_SYNC)
+		if (ad->batch_data_dir == BLK_RW_SYNC)
 			ad->new_batch = 1;
 	}
 	WARN_ON(ad->nr_dispatched == 0);
@@ -869,7 +866,7 @@ static void as_completed_request(struct request_queue *q, struct request *rq)
 	if (ad->new_batch && ad->batch_data_dir == rq_is_sync(rq)) {
 		update_write_batch(ad);
 		ad->current_batch_expires = jiffies +
-				ad->batch_expire[REQ_SYNC];
+				ad->batch_expire[BLK_RW_SYNC];
 		ad->new_batch = 0;
 	}
 
@@ -960,7 +957,7 @@ static inline int as_batch_expired(struct as_data *ad)
 	if (ad->changed_batch || ad->new_batch)
 		return 0;
 
-	if (ad->batch_data_dir == REQ_SYNC)
+	if (ad->batch_data_dir == BLK_RW_SYNC)
 		/* TODO! add a check so a complete fifo gets written? */
 		return time_after(jiffies, ad->current_batch_expires);
 
@@ -986,7 +983,7 @@ static void as_move_to_dispatch(struct as_data *ad, struct request *rq)
 	 */
 	ad->last_sector[data_dir] = rq->sector + rq->nr_sectors;
 
-	if (data_dir == REQ_SYNC) {
+	if (data_dir == BLK_RW_SYNC) {
 		struct io_context *ioc = RQ_IOC(rq);
 		/* In case we have to anticipate after this */
 		copy_io_context(&ad->io_context, &ioc);
@@ -1025,41 +1022,41 @@ static void as_move_to_dispatch(struct as_data *ad, struct request *rq)
 static int as_dispatch_request(struct request_queue *q, int force)
 {
 	struct as_data *ad = q->elevator->elevator_data;
-	const int reads = !list_empty(&ad->fifo_list[REQ_SYNC]);
-	const int writes = !list_empty(&ad->fifo_list[REQ_ASYNC]);
+	const int reads = !list_empty(&ad->fifo_list[BLK_RW_SYNC]);
+	const int writes = !list_empty(&ad->fifo_list[BLK_RW_ASYNC]);
 	struct request *rq;
 
 	if (unlikely(force)) {
 		/*
 		 * Forced dispatch, accounting is useless.  Reset
 		 * accounting states and dump fifo_lists.  Note that
-		 * batch_data_dir is reset to REQ_SYNC to avoid
+		 * batch_data_dir is reset to BLK_RW_SYNC to avoid
 		 * screwing write batch accounting as write batch
 		 * accounting occurs on W->R transition.
 		 */
 		int dispatched = 0;
 
-		ad->batch_data_dir = REQ_SYNC;
+		ad->batch_data_dir = BLK_RW_SYNC;
 		ad->changed_batch = 0;
 		ad->new_batch = 0;
 
-		while (ad->next_rq[REQ_SYNC]) {
-			as_move_to_dispatch(ad, ad->next_rq[REQ_SYNC]);
+		while (ad->next_rq[BLK_RW_SYNC]) {
+			as_move_to_dispatch(ad, ad->next_rq[BLK_RW_SYNC]);
 			dispatched++;
 		}
-		ad->last_check_fifo[REQ_SYNC] = jiffies;
+		ad->last_check_fifo[BLK_RW_SYNC] = jiffies;
 
-		while (ad->next_rq[REQ_ASYNC]) {
-			as_move_to_dispatch(ad, ad->next_rq[REQ_ASYNC]);
+		while (ad->next_rq[BLK_RW_ASYNC]) {
+			as_move_to_dispatch(ad, ad->next_rq[BLK_RW_ASYNC]);
 			dispatched++;
 		}
-		ad->last_check_fifo[REQ_ASYNC] = jiffies;
+		ad->last_check_fifo[BLK_RW_ASYNC] = jiffies;
 
 		return dispatched;
 	}
 
 	/* Signal that the write batch was uncontended, so we can't time it */
-	if (ad->batch_data_dir == REQ_ASYNC && !reads) {
+	if (ad->batch_data_dir == BLK_RW_ASYNC && !reads) {
 		if (ad->current_write_count == 0 || !writes)
 			ad->write_batch_idled = 1;
 	}
@@ -1076,8 +1073,8 @@ static int as_dispatch_request(struct request_queue *q, int force)
 		 */
 		rq = ad->next_rq[ad->batch_data_dir];
 
-		if (ad->batch_data_dir == REQ_SYNC && ad->antic_expire) {
-			if (as_fifo_expired(ad, REQ_SYNC))
+		if (ad->batch_data_dir == BLK_RW_SYNC && ad->antic_expire) {
+			if (as_fifo_expired(ad, BLK_RW_SYNC))
 				goto fifo_expired;
 
 			if (as_can_anticipate(ad, rq)) {
@@ -1090,7 +1087,7 @@ static int as_dispatch_request(struct request_queue *q, int force)
 			/* we have a "next request" */
 			if (reads && !writes)
 				ad->current_batch_expires =
-					jiffies + ad->batch_expire[REQ_SYNC];
+					jiffies + ad->batch_expire[BLK_RW_SYNC];
 			goto dispatch_request;
 		}
 	}
@@ -1101,20 +1098,20 @@ static int as_dispatch_request(struct request_queue *q, int force)
 	 */
 
 	if (reads) {
-		BUG_ON(RB_EMPTY_ROOT(&ad->sort_list[REQ_SYNC]));
+		BUG_ON(RB_EMPTY_ROOT(&ad->sort_list[BLK_RW_SYNC]));
 
-		if (writes && ad->batch_data_dir == REQ_SYNC)
+		if (writes && ad->batch_data_dir == BLK_RW_SYNC)
 			/*
 			 * Last batch was a read, switch to writes
 			 */
 			goto dispatch_writes;
 
-		if (ad->batch_data_dir == REQ_ASYNC) {
+		if (ad->batch_data_dir == BLK_RW_ASYNC) {
 			WARN_ON(ad->new_batch);
 			ad->changed_batch = 1;
 		}
-		ad->batch_data_dir = REQ_SYNC;
-		rq = rq_entry_fifo(ad->fifo_list[REQ_SYNC].next);
+		ad->batch_data_dir = BLK_RW_SYNC;
+		rq = rq_entry_fifo(ad->fifo_list[BLK_RW_SYNC].next);
 		ad->last_check_fifo[ad->batch_data_dir] = jiffies;
 		goto dispatch_request;
 	}
@@ -1125,9 +1122,9 @@ static int as_dispatch_request(struct request_queue *q, int force)
 
 	if (writes) {
 dispatch_writes:
-		BUG_ON(RB_EMPTY_ROOT(&ad->sort_list[REQ_ASYNC]));
+		BUG_ON(RB_EMPTY_ROOT(&ad->sort_list[BLK_RW_ASYNC]));
 
-		if (ad->batch_data_dir == REQ_SYNC) {
+		if (ad->batch_data_dir == BLK_RW_SYNC) {
 			ad->changed_batch = 1;
 
 			/*
@@ -1137,11 +1134,11 @@ dispatch_writes:
 			 */
 			ad->new_batch = 0;
 		}
-		ad->batch_data_dir = REQ_ASYNC;
+		ad->batch_data_dir = BLK_RW_ASYNC;
 		ad->current_write_count = ad->write_batch_count;
 		ad->write_batch_idled = 0;
-		rq = rq_entry_fifo(ad->fifo_list[REQ_ASYNC].next);
-		ad->last_check_fifo[REQ_ASYNC] = jiffies;
+		rq = rq_entry_fifo(ad->fifo_list[BLK_RW_ASYNC].next);
+		ad->last_check_fifo[BLK_RW_ASYNC] = jiffies;
 		goto dispatch_request;
 	}
 
@@ -1164,9 +1161,9 @@ fifo_expired:
 		if (ad->nr_dispatched)
 			return 0;
 
-		if (ad->batch_data_dir == REQ_ASYNC)
+		if (ad->batch_data_dir == BLK_RW_ASYNC)
 			ad->current_batch_expires = jiffies +
-					ad->batch_expire[REQ_ASYNC];
+					ad->batch_expire[BLK_RW_ASYNC];
 		else
 			ad->new_batch = 1;
 
@@ -1238,8 +1235,8 @@ static int as_queue_empty(struct request_queue *q)
 {
 	struct as_data *ad = q->elevator->elevator_data;
 
-	return list_empty(&ad->fifo_list[REQ_ASYNC])
-		&& list_empty(&ad->fifo_list[REQ_SYNC]);
+	return list_empty(&ad->fifo_list[BLK_RW_ASYNC])
+		&& list_empty(&ad->fifo_list[BLK_RW_SYNC]);
 }
 
 static int
@@ -1346,8 +1343,8 @@ static void as_exit_queue(struct elevator_queue *e)
 	del_timer_sync(&ad->antic_timer);
 	cancel_work_sync(&ad->antic_work);
 
-	BUG_ON(!list_empty(&ad->fifo_list[REQ_SYNC]));
-	BUG_ON(!list_empty(&ad->fifo_list[REQ_ASYNC]));
+	BUG_ON(!list_empty(&ad->fifo_list[BLK_RW_SYNC]));
+	BUG_ON(!list_empty(&ad->fifo_list[BLK_RW_ASYNC]));
 
 	put_io_context(ad->io_context);
 	kfree(ad);
@@ -1372,18 +1369,18 @@ static void *as_init_queue(struct request_queue *q)
 	init_timer(&ad->antic_timer);
 	INIT_WORK(&ad->antic_work, as_work_handler);
 
-	INIT_LIST_HEAD(&ad->fifo_list[REQ_SYNC]);
-	INIT_LIST_HEAD(&ad->fifo_list[REQ_ASYNC]);
-	ad->sort_list[REQ_SYNC] = RB_ROOT;
-	ad->sort_list[REQ_ASYNC] = RB_ROOT;
-	ad->fifo_expire[REQ_SYNC] = default_read_expire;
-	ad->fifo_expire[REQ_ASYNC] = default_write_expire;
+	INIT_LIST_HEAD(&ad->fifo_list[BLK_RW_SYNC]);
+	INIT_LIST_HEAD(&ad->fifo_list[BLK_RW_ASYNC]);
+	ad->sort_list[BLK_RW_SYNC] = RB_ROOT;
+	ad->sort_list[BLK_RW_ASYNC] = RB_ROOT;
+	ad->fifo_expire[BLK_RW_SYNC] = default_read_expire;
+	ad->fifo_expire[BLK_RW_ASYNC] = default_write_expire;
 	ad->antic_expire = default_antic_expire;
-	ad->batch_expire[REQ_SYNC] = default_read_batch_expire;
-	ad->batch_expire[REQ_ASYNC] = default_write_batch_expire;
+	ad->batch_expire[BLK_RW_SYNC] = default_read_batch_expire;
+	ad->batch_expire[BLK_RW_ASYNC] = default_write_batch_expire;
 
-	ad->current_batch_expires = jiffies + ad->batch_expire[REQ_SYNC];
-	ad->write_batch_count = ad->batch_expire[REQ_ASYNC] / 10;
+	ad->current_batch_expires = jiffies + ad->batch_expire[BLK_RW_SYNC];
+	ad->write_batch_count = ad->batch_expire[BLK_RW_ASYNC] / 10;
 	if (ad->write_batch_count < 2)
 		ad->write_batch_count = 2;
 
@@ -1432,11 +1429,11 @@ static ssize_t __FUNC(struct elevator_queue *e, char *page)	\
 	struct as_data *ad = e->elevator_data;			\
 	return as_var_show(jiffies_to_msecs((__VAR)), (page));	\
 }
-SHOW_FUNCTION(as_read_expire_show, ad->fifo_expire[REQ_SYNC]);
-SHOW_FUNCTION(as_write_expire_show, ad->fifo_expire[REQ_ASYNC]);
+SHOW_FUNCTION(as_read_expire_show, ad->fifo_expire[BLK_RW_SYNC]);
+SHOW_FUNCTION(as_write_expire_show, ad->fifo_expire[BLK_RW_ASYNC]);
 SHOW_FUNCTION(as_antic_expire_show, ad->antic_expire);
-SHOW_FUNCTION(as_read_batch_expire_show, ad->batch_expire[REQ_SYNC]);
-SHOW_FUNCTION(as_write_batch_expire_show, ad->batch_expire[REQ_ASYNC]);
+SHOW_FUNCTION(as_read_batch_expire_show, ad->batch_expire[BLK_RW_SYNC]);
+SHOW_FUNCTION(as_write_batch_expire_show, ad->batch_expire[BLK_RW_ASYNC]);
 #undef SHOW_FUNCTION
 
 #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX)				\
@@ -1451,13 +1448,14 @@ static ssize_t __FUNC(struct elevator_queue *e, const char *page, size_t count)
 	*(__PTR) = msecs_to_jiffies(*(__PTR));				\
 	return ret;							\
 }
-STORE_FUNCTION(as_read_expire_store, &ad->fifo_expire[REQ_SYNC], 0, INT_MAX);
-STORE_FUNCTION(as_write_expire_store, &ad->fifo_expire[REQ_ASYNC], 0, INT_MAX);
+STORE_FUNCTION(as_read_expire_store, &ad->fifo_expire[BLK_RW_SYNC], 0, INT_MAX);
+STORE_FUNCTION(as_write_expire_store,
+			&ad->fifo_expire[BLK_RW_ASYNC], 0, INT_MAX);
 STORE_FUNCTION(as_antic_expire_store, &ad->antic_expire, 0, INT_MAX);
 STORE_FUNCTION(as_read_batch_expire_store,
-			&ad->batch_expire[REQ_SYNC], 0, INT_MAX);
+			&ad->batch_expire[BLK_RW_SYNC], 0, INT_MAX);
 STORE_FUNCTION(as_write_batch_expire_store,
-			&ad->batch_expire[REQ_ASYNC], 0, INT_MAX);
+			&ad->batch_expire[BLK_RW_ASYNC], 0, INT_MAX);
 #undef STORE_FUNCTION
 
 #define AS_ATTR(name) \
diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index f7dae57..20b4111 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -319,9 +319,6 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 		return -ENXIO;
 
 	bio = bio_alloc(GFP_KERNEL, 0);
-	if (!bio)
-		return -ENOMEM;
-
 	bio->bi_end_io = bio_end_empty_barrier;
 	bio->bi_private = &wait;
 	bio->bi_bdev = bdev;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 73f36be..cac4e9f 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -209,14 +209,14 @@ static ssize_t queue_iostats_store(struct request_queue *q, const char *page,
 	ssize_t ret = queue_var_store(&stats, page, count);
 
 	spin_lock_irq(q->queue_lock);
-	elv_quisce_start(q);
+	elv_quiesce_start(q);
 
 	if (stats)
 		queue_flag_set(QUEUE_FLAG_IO_STAT, q);
 	else
 		queue_flag_clear(QUEUE_FLAG_IO_STAT, q);
 
-	elv_quisce_end(q);
+	elv_quiesce_end(q);
 	spin_unlock_irq(q->queue_lock);
 
 	return ret;
diff --git a/block/blk.h b/block/blk.h
index 24fcaee..5dfc412 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -70,8 +70,8 @@ void blk_queue_congestion_threshold(struct request_queue *q);
 
 int blk_dev_init(void);
 
-void elv_quisce_start(struct request_queue *q);
-void elv_quisce_end(struct request_queue *q);
+void elv_quiesce_start(struct request_queue *q);
+void elv_quiesce_end(struct request_queue *q);
 
 
 /*
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a4809de..0d3b70d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -56,9 +56,6 @@ static DEFINE_SPINLOCK(ioc_gone_lock);
 #define cfq_class_idle(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_IDLE)
 #define cfq_class_rt(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_RT)
 
-#define ASYNC			(0)
-#define SYNC			(1)
-
 #define sample_valid(samples)	((samples) > 80)
 
 /*
@@ -83,6 +80,14 @@ struct cfq_data {
 	 * rr list of queues with requests and the count of them
 	 */
 	struct cfq_rb_root service_tree;
+
+	/*
+	 * Each priority tree is sorted by next_request position.  These
+	 * trees are used when determining if two or more queues are
+	 * interleaving requests (see cfq_close_cooperator).
+	 */
+	struct rb_root prio_trees[CFQ_PRIO_LISTS];
+
 	unsigned int busy_queues;
 	/*
 	 * Used to track any pending rt requests so we can pre-empt current
@@ -147,6 +152,8 @@ struct cfq_queue {
 	struct rb_node rb_node;
 	/* service_tree key */
 	unsigned long rb_key;
+	/* prio tree member */
+	struct rb_node p_node;
 	/* sorted list of pending requests */
 	struct rb_root sort_list;
 	/* if fifo isn't expired, next request to serve */
@@ -185,6 +192,7 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_prio_changed,	/* task priority has changed */
 	CFQ_CFQQ_FLAG_slice_new,	/* no requests dispatched in slice */
 	CFQ_CFQQ_FLAG_sync,		/* synchronous queue */
+	CFQ_CFQQ_FLAG_coop,		/* has done a coop jump of the queue */
 };
 
 #define CFQ_CFQQ_FNS(name)						\
@@ -211,6 +219,7 @@ CFQ_CFQQ_FNS(idle_window);
 CFQ_CFQQ_FNS(prio_changed);
 CFQ_CFQQ_FNS(slice_new);
 CFQ_CFQQ_FNS(sync);
+CFQ_CFQQ_FNS(coop);
 #undef CFQ_CFQQ_FNS
 
 #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
@@ -419,13 +428,17 @@ static struct cfq_queue *cfq_rb_first(struct cfq_rb_root *root)
 	return NULL;
 }
 
+static void rb_erase_init(struct rb_node *n, struct rb_root *root)
+{
+	rb_erase(n, root);
+	RB_CLEAR_NODE(n);
+}
+
 static void cfq_rb_erase(struct rb_node *n, struct cfq_rb_root *root)
 {
 	if (root->left == n)
 		root->left = NULL;
-
-	rb_erase(n, &root->rb);
-	RB_CLEAR_NODE(n);
+	rb_erase_init(n, &root->rb);
 }
 
 /*
@@ -470,8 +483,8 @@ static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
  * requests waiting to be processed. It is sorted in the order that
  * we will service the queues.
  */
-static void cfq_service_tree_add(struct cfq_data *cfqd,
-				    struct cfq_queue *cfqq, int add_front)
+static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
+				 int add_front)
 {
 	struct rb_node **p, *parent;
 	struct cfq_queue *__cfqq;
@@ -544,6 +557,63 @@ static void cfq_service_tree_add(struct cfq_data *cfqd,
 	rb_insert_color(&cfqq->rb_node, &cfqd->service_tree.rb);
 }
 
+static struct cfq_queue *
+cfq_prio_tree_lookup(struct cfq_data *cfqd, int ioprio, sector_t sector,
+		     struct rb_node **ret_parent, struct rb_node ***rb_link)
+{
+	struct rb_root *root = &cfqd->prio_trees[ioprio];
+	struct rb_node **p, *parent;
+	struct cfq_queue *cfqq = NULL;
+
+	parent = NULL;
+	p = &root->rb_node;
+	while (*p) {
+		struct rb_node **n;
+
+		parent = *p;
+		cfqq = rb_entry(parent, struct cfq_queue, p_node);
+
+		/*
+		 * Sort strictly based on sector.  Smallest to the left,
+		 * largest to the right.
+		 */
+		if (sector > cfqq->next_rq->sector)
+			n = &(*p)->rb_right;
+		else if (sector < cfqq->next_rq->sector)
+			n = &(*p)->rb_left;
+		else
+			break;
+		p = n;
+	}
+
+	*ret_parent = parent;
+	if (rb_link)
+		*rb_link = p;
+	return NULL;
+}
+
+static void cfq_prio_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+{
+	struct rb_root *root = &cfqd->prio_trees[cfqq->ioprio];
+	struct rb_node **p, *parent;
+	struct cfq_queue *__cfqq;
+
+	if (!RB_EMPTY_NODE(&cfqq->p_node))
+		rb_erase_init(&cfqq->p_node, root);
+
+	if (cfq_class_idle(cfqq))
+		return;
+	if (!cfqq->next_rq)
+		return;
+
+	__cfqq = cfq_prio_tree_lookup(cfqd, cfqq->ioprio, cfqq->next_rq->sector,
+					 &parent, &p);
+	BUG_ON(__cfqq);
+
+	rb_link_node(&cfqq->p_node, parent, p);
+	rb_insert_color(&cfqq->p_node, root);
+}
+
 /*
  * Update cfqq's position in the service tree.
  */
@@ -552,8 +622,10 @@ static void cfq_resort_rr_list(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	/*
 	 * Resorting requires the cfqq to be on the RR list already.
 	 */
-	if (cfq_cfqq_on_rr(cfqq))
+	if (cfq_cfqq_on_rr(cfqq)) {
 		cfq_service_tree_add(cfqd, cfqq, 0);
+		cfq_prio_tree_add(cfqd, cfqq);
+	}
 }
 
 /*
@@ -584,6 +656,8 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 
 	if (!RB_EMPTY_NODE(&cfqq->rb_node))
 		cfq_rb_erase(&cfqq->rb_node, &cfqd->service_tree);
+	if (!RB_EMPTY_NODE(&cfqq->p_node))
+		rb_erase_init(&cfqq->p_node, &cfqd->prio_trees[cfqq->ioprio]);
 
 	BUG_ON(!cfqd->busy_queues);
 	cfqd->busy_queues--;
@@ -613,7 +687,7 @@ static void cfq_add_rq_rb(struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 	struct cfq_data *cfqd = cfqq->cfqd;
-	struct request *__alias;
+	struct request *__alias, *prev;
 
 	cfqq->queued[rq_is_sync(rq)]++;
 
@@ -630,7 +704,15 @@ static void cfq_add_rq_rb(struct request *rq)
 	/*
 	 * check if this request is a better next-serve candidate
 	 */
+	prev = cfqq->next_rq;
 	cfqq->next_rq = cfq_choose_req(cfqd, cfqq->next_rq, rq);
+
+	/*
+	 * adjust priority tree position, if ->next_rq changes
+	 */
+	if (prev != cfqq->next_rq)
+		cfq_prio_tree_add(cfqd, cfqq);
+
 	BUG_ON(!cfqq->next_rq);
 }
 
@@ -843,11 +925,15 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 /*
  * Get and set a new active queue for service.
  */
-static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd)
+static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd,
+					      struct cfq_queue *cfqq)
 {
-	struct cfq_queue *cfqq;
+	if (!cfqq) {
+		cfqq = cfq_get_next_queue(cfqd);
+		if (cfqq)
+			cfq_clear_cfqq_coop(cfqq);
+	}
 
-	cfqq = cfq_get_next_queue(cfqd);
 	__cfq_set_active_queue(cfqd, cfqq);
 	return cfqq;
 }
@@ -871,17 +957,89 @@ static inline int cfq_rq_close(struct cfq_data *cfqd, struct request *rq)
 	return cfq_dist_from_last(cfqd, rq) <= cic->seek_mean;
 }
 
-static int cfq_close_cooperator(struct cfq_data *cfq_data,
-				struct cfq_queue *cfqq)
+static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
+				    struct cfq_queue *cur_cfqq)
+{
+	struct rb_root *root = &cfqd->prio_trees[cur_cfqq->ioprio];
+	struct rb_node *parent, *node;
+	struct cfq_queue *__cfqq;
+	sector_t sector = cfqd->last_position;
+
+	if (RB_EMPTY_ROOT(root))
+		return NULL;
+
+	/*
+	 * First, if we find a request starting at the end of the last
+	 * request, choose it.
+	 */
+	__cfqq = cfq_prio_tree_lookup(cfqd, cur_cfqq->ioprio,
+				      sector, &parent, NULL);
+	if (__cfqq)
+		return __cfqq;
+
+	/*
+	 * If the exact sector wasn't found, the parent of the NULL leaf
+	 * will contain the closest sector.
+	 */
+	__cfqq = rb_entry(parent, struct cfq_queue, p_node);
+	if (cfq_rq_close(cfqd, __cfqq->next_rq))
+		return __cfqq;
+
+	if (__cfqq->next_rq->sector < sector)
+		node = rb_next(&__cfqq->p_node);
+	else
+		node = rb_prev(&__cfqq->p_node);
+	if (!node)
+		return NULL;
+
+	__cfqq = rb_entry(node, struct cfq_queue, p_node);
+	if (cfq_rq_close(cfqd, __cfqq->next_rq))
+		return __cfqq;
+
+	return NULL;
+}
+
+/*
+ * cfqd - obvious
+ * cur_cfqq - passed in so that we don't decide that the current queue is
+ * 	      closely cooperating with itself.
+ *
+ * So, basically we're assuming that that cur_cfqq has dispatched at least
+ * one request, and that cfqd->last_position reflects a position on the disk
+ * associated with the I/O issued by cur_cfqq.  I'm not sure this is a valid
+ * assumption.
+ */
+static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
+					      struct cfq_queue *cur_cfqq,
+					      int probe)
 {
+	struct cfq_queue *cfqq;
+
+	/*
+	 * A valid cfq_io_context is necessary to compare requests against
+	 * the seek_mean of the current cfqq.
+	 */
+	if (!cfqd->active_cic)
+		return NULL;
+
 	/*
 	 * We should notice if some of the queues are cooperating, eg
 	 * working closely on the same area of the disk. In that case,
 	 * we can group them together and don't waste time idling.
 	 */
-	return 0;
+	cfqq = cfqq_close(cfqd, cur_cfqq);
+	if (!cfqq)
+		return NULL;
+
+	if (cfq_cfqq_coop(cfqq))
+		return NULL;
+
+	if (!probe)
+		cfq_mark_cfqq_coop(cfqq);
+	return cfqq;
 }
 
+
 #define CIC_SEEKY(cic) ((cic)->seek_mean > (8 * 1024))
 
 static void cfq_arm_slice_timer(struct cfq_data *cfqd)
@@ -920,13 +1078,6 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	if (!cic || !atomic_read(&cic->ioc->nr_tasks))
 		return;
 
-	/*
-	 * See if this prio level has a good candidate
-	 */
-	if (cfq_close_cooperator(cfqd, cfqq) &&
-	    (sample_valid(cic->ttime_samples) && cic->ttime_mean > 2))
-		return;
-
 	cfq_mark_cfqq_wait_request(cfqq);
 
 	/*
@@ -939,7 +1090,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 		sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));
 
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
-	cfq_log(cfqd, "arm_idle: %lu", sl);
+	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu", sl);
 }
 
 /*
@@ -1003,7 +1154,7 @@ cfq_prio_to_maxrq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
  */
 static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 {
-	struct cfq_queue *cfqq;
+	struct cfq_queue *cfqq, *new_cfqq = NULL;
 
 	cfqq = cfqd->active_queue;
 	if (!cfqq)
@@ -1037,6 +1188,16 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 		goto keep_queue;
 
 	/*
+	 * If another queue has a request waiting within our mean seek
+	 * distance, let it run.  The expire code will check for close
+	 * cooperators and put the close queue at the front of the service
+	 * tree.
+	 */
+	new_cfqq = cfq_close_cooperator(cfqd, cfqq, 0);
+	if (new_cfqq)
+		goto expire;
+
+	/*
 	 * No requests pending. If the active queue still has requests in
 	 * flight or is idling for a new request, allow either of these
 	 * conditions to happen (or time out) before selecting a new queue.
@@ -1050,7 +1211,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 expire:
 	cfq_slice_expired(cfqd, 0);
 new_queue:
-	cfqq = cfq_set_active_queue(cfqd);
+	cfqq = cfq_set_active_queue(cfqd, new_cfqq);
 keep_queue:
 	return cfqq;
 }
@@ -1333,14 +1494,14 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
 	if (ioc->ioc_data == cic)
 		rcu_assign_pointer(ioc->ioc_data, NULL);
 
-	if (cic->cfqq[ASYNC]) {
-		cfq_exit_cfqq(cfqd, cic->cfqq[ASYNC]);
-		cic->cfqq[ASYNC] = NULL;
+	if (cic->cfqq[BLK_RW_ASYNC]) {
+		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_ASYNC]);
+		cic->cfqq[BLK_RW_ASYNC] = NULL;
 	}
 
-	if (cic->cfqq[SYNC]) {
-		cfq_exit_cfqq(cfqd, cic->cfqq[SYNC]);
-		cic->cfqq[SYNC] = NULL;
+	if (cic->cfqq[BLK_RW_SYNC]) {
+		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_SYNC]);
+		cic->cfqq[BLK_RW_SYNC] = NULL;
 	}
 }
 
@@ -1449,17 +1610,18 @@ static void changed_ioprio(struct io_context *ioc, struct cfq_io_context *cic)
 
 	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
 
-	cfqq = cic->cfqq[ASYNC];
+	cfqq = cic->cfqq[BLK_RW_ASYNC];
 	if (cfqq) {
 		struct cfq_queue *new_cfqq;
-		new_cfqq = cfq_get_queue(cfqd, ASYNC, cic->ioc, GFP_ATOMIC);
+		new_cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic->ioc,
+						GFP_ATOMIC);
 		if (new_cfqq) {
-			cic->cfqq[ASYNC] = new_cfqq;
+			cic->cfqq[BLK_RW_ASYNC] = new_cfqq;
 			cfq_put_queue(cfqq);
 		}
 	}
 
-	cfqq = cic->cfqq[SYNC];
+	cfqq = cic->cfqq[BLK_RW_SYNC];
 	if (cfqq)
 		cfq_mark_cfqq_prio_changed(cfqq);
 
@@ -1510,6 +1672,7 @@ retry:
 		}
 
 		RB_CLEAR_NODE(&cfqq->rb_node);
+		RB_CLEAR_NODE(&cfqq->p_node);
 		INIT_LIST_HEAD(&cfqq->fifo);
 
 		atomic_set(&cfqq->ref, 0);
@@ -1905,10 +2068,20 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		 * Remember that we saw a request from this process, but
 		 * don't start queuing just yet. Otherwise we risk seeing lots
 		 * of tiny requests, because we disrupt the normal plugging
-		 * and merging.
+		 * and merging. If the request is already larger than a single
+		 * page, let it rip immediately. For that case we assume that
+		 * merging is already done. Ditto for a busy system that
+		 * has other work pending, don't risk delaying until the
+		 * idle timer unplug to continue working.
 		 */
-		if (cfq_cfqq_wait_request(cfqq))
+		if (cfq_cfqq_wait_request(cfqq)) {
+			if (blk_rq_bytes(rq) > PAGE_CACHE_SIZE ||
+			    cfqd->busy_queues > 1) {
+				del_timer(&cfqd->idle_slice_timer);
+				blk_start_queueing(cfqd->queue);
+			}
 			cfq_mark_cfqq_must_dispatch(cfqq);
+		}
 	} else if (cfq_should_preempt(cfqd, cfqq, rq)) {
 		/*
 		 * not the active queue - expire current slice if it is
@@ -1992,16 +2165,24 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	 * or if we want to idle in case it has no pending requests.
 	 */
 	if (cfqd->active_queue == cfqq) {
+		const bool cfqq_empty = RB_EMPTY_ROOT(&cfqq->sort_list);
+
 		if (cfq_cfqq_slice_new(cfqq)) {
 			cfq_set_prio_slice(cfqd, cfqq);
 			cfq_clear_cfqq_slice_new(cfqq);
 		}
+		/*
+		 * If there are no requests waiting in this queue, and
+		 * there are other queues ready to issue requests, AND
+		 * those other queues are issuing requests within our
+		 * mean seek distance, give them a chance to run instead
+		 * of idling.
+		 */
 		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
 			cfq_slice_expired(cfqd, 1);
-		else if (sync && !rq_noidle(rq) &&
-			 RB_EMPTY_ROOT(&cfqq->sort_list)) {
+		else if (cfqq_empty && !cfq_close_cooperator(cfqd, cfqq, 1) &&
+			 sync && !rq_noidle(rq))
 			cfq_arm_slice_timer(cfqd);
-		}
 	}
 
 	if (!cfqd->rq_in_driver)
@@ -2062,7 +2243,7 @@ static int cfq_may_queue(struct request_queue *q, int rw)
 	if (!cic)
 		return ELV_MQUEUE_MAY;
 
-	cfqq = cic_to_cfqq(cic, rw & REQ_RW_SYNC);
+	cfqq = cic_to_cfqq(cic, rw_is_sync(rw));
 	if (cfqq) {
 		cfq_init_prio_data(cfqq, cic->ioc);
 		cfq_prio_boost(cfqq);
@@ -2152,11 +2333,10 @@ static void cfq_kick_queue(struct work_struct *work)
 	struct cfq_data *cfqd =
 		container_of(work, struct cfq_data, unplug_work);
 	struct request_queue *q = cfqd->queue;
-	unsigned long flags;
 
-	spin_lock_irqsave(q->queue_lock, flags);
+	spin_lock_irq(q->queue_lock);
 	blk_start_queueing(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	spin_unlock_irq(q->queue_lock);
 }
 
 /*
diff --git a/block/elevator.c b/block/elevator.c
index fb81bcc..7073a90 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -590,7 +590,7 @@ void elv_drain_elevator(struct request_queue *q)
 /*
  * Call with queue lock held, interrupts disabled
  */
-void elv_quisce_start(struct request_queue *q)
+void elv_quiesce_start(struct request_queue *q)
 {
 	queue_flag_set(QUEUE_FLAG_ELVSWITCH, q);
 
@@ -607,7 +607,7 @@ void elv_quisce_start(struct request_queue *q)
 	}
 }
 
-void elv_quisce_end(struct request_queue *q)
+void elv_quiesce_end(struct request_queue *q)
 {
 	queue_flag_clear(QUEUE_FLAG_ELVSWITCH, q);
 }
@@ -1126,7 +1126,7 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	 * Turn on BYPASS and drain all requests w/ elevator private data
 	 */
 	spin_lock_irq(q->queue_lock);
-	elv_quisce_start(q);
+	elv_quiesce_start(q);
 
 	/*
 	 * Remember old elevator.
@@ -1150,7 +1150,7 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	 */
 	elevator_exit(old_elevator);
 	spin_lock_irq(q->queue_lock);
-	elv_quisce_end(q);
+	elv_quiesce_end(q);
 	spin_unlock_irq(q->queue_lock);
 
 	blk_add_trace_msg(q, "elv switch: %s", e->elevator_type->elevator_name);
diff --git a/block/ioctl.c b/block/ioctl.c
index 0f22e62..ad474d4 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -146,8 +146,6 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 		struct bio *bio;
 
 		bio = bio_alloc(GFP_KERNEL, 0);
-		if (!bio)
-			return -ENOMEM;
 
 		bio->bi_end_io = blk_ioc_discard_endio;
 		bio->bi_bdev = bdev;
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 626ee27..84b7f87 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -217,7 +217,7 @@ static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 				 struct bio *bio)
 {
-	int ret = 0;
+	int r, ret = 0;
 
 	/*
 	 * fill in all the output members
@@ -242,7 +242,9 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 			ret = -EFAULT;
 	}
 
-	blk_rq_unmap_user(bio);
+	r = blk_rq_unmap_user(bio);
+	if (!ret)
+		ret = r;
 	blk_put_request(rq);
 
 	return ret;
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index bdd4f5f..5f7e64b 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -275,8 +275,10 @@ static int brd_do_bvec(struct brd_device *brd, struct page *page,
 	if (rw == READ) {
 		copy_from_brd(mem + off, brd, sector, len);
 		flush_dcache_page(page);
-	} else
+	} else {
+		flush_dcache_page(page);
 		copy_to_brd(brd, mem + off, sector, len);
+	}
 	kunmap_atomic(mem, KM_USER0);
 
 out:
@@ -436,6 +438,7 @@ static struct brd_device *brd_alloc(int i)
 	if (!brd->brd_queue)
 		goto out_free_dev;
 	blk_queue_make_request(brd->brd_queue, brd_make_request);
+	blk_queue_ordered(brd->brd_queue, QUEUE_ORDERED_TAG, NULL);
 	blk_queue_max_sectors(brd->brd_queue, 1024);
 	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
 
diff --git a/drivers/md/dm-bio-list.h b/drivers/md/dm-bio-list.h
deleted file mode 100644
index 345098b..0000000
--- a/drivers/md/dm-bio-list.h
+++ /dev/null
@@ -1,117 +0,0 @@
-/*
- * Copyright (C) 2004 Red Hat UK Ltd.
- *
- * This file is released under the GPL.
- */
-
-#ifndef DM_BIO_LIST_H
-#define DM_BIO_LIST_H
-
-#include <linux/bio.h>
-
-#ifdef CONFIG_BLOCK
-
-struct bio_list {
-	struct bio *head;
-	struct bio *tail;
-};
-
-static inline int bio_list_empty(const struct bio_list *bl)
-{
-	return bl->head == NULL;
-}
-
-static inline void bio_list_init(struct bio_list *bl)
-{
-	bl->head = bl->tail = NULL;
-}
-
-#define bio_list_for_each(bio, bl) \
-	for (bio = (bl)->head; bio; bio = bio->bi_next)
-
-static inline unsigned bio_list_size(const struct bio_list *bl)
-{
-	unsigned sz = 0;
-	struct bio *bio;
-
-	bio_list_for_each(bio, bl)
-		sz++;
-
-	return sz;
-}
-
-static inline void bio_list_add(struct bio_list *bl, struct bio *bio)
-{
-	bio->bi_next = NULL;
-
-	if (bl->tail)
-		bl->tail->bi_next = bio;
-	else
-		bl->head = bio;
-
-	bl->tail = bio;
-}
-
-static inline void bio_list_add_head(struct bio_list *bl, struct bio *bio)
-{
-	bio->bi_next = bl->head;
-
-	bl->head = bio;
-
-	if (!bl->tail)
-		bl->tail = bio;
-}
-
-static inline void bio_list_merge(struct bio_list *bl, struct bio_list *bl2)
-{
-	if (!bl2->head)
-		return;
-
-	if (bl->tail)
-		bl->tail->bi_next = bl2->head;
-	else
-		bl->head = bl2->head;
-
-	bl->tail = bl2->tail;
-}
-
-static inline void bio_list_merge_head(struct bio_list *bl,
-				       struct bio_list *bl2)
-{
-	if (!bl2->head)
-		return;
-
-	if (bl->head)
-		bl2->tail->bi_next = bl->head;
-	else
-		bl->tail = bl2->tail;
-
-	bl->head = bl2->head;
-}
-
-static inline struct bio *bio_list_pop(struct bio_list *bl)
-{
-	struct bio *bio = bl->head;
-
-	if (bio) {
-		bl->head = bl->head->bi_next;
-		if (!bl->head)
-			bl->tail = NULL;
-
-		bio->bi_next = NULL;
-	}
-
-	return bio;
-}
-
-static inline struct bio *bio_list_get(struct bio_list *bl)
-{
-	struct bio *bio = bl->head;
-
-	bl->head = bl->tail = NULL;
-
-	return bio;
-}
-
-#endif /* CONFIG_BLOCK */
-#endif
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 59ee1b0..559dbb5 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -15,8 +15,6 @@
 
 #include <linux/device-mapper.h>
 
-#include "dm-bio-list.h"
-
 #define DM_MSG_PREFIX "delay"
 
 struct delay_c {
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 095f77b..6a386ab 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -8,7 +8,6 @@
 #include <linux/device-mapper.h>
 
 #include "dm-path-selector.h"
-#include "dm-bio-list.h"
 #include "dm-bio-record.h"
 #include "dm-uevent.h"
 
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 536ef0b..076fbb4 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -5,7 +5,6 @@
  * This file is released under the GPL.
  */
 
-#include "dm-bio-list.h"
 #include "dm-bio-record.h"
 
 #include <linux/init.h>
diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index 59f8d9d..7b899be 100644
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -14,7 +14,6 @@
 #include <linux/vmalloc.h>
 
 #include "dm.h"
-#include "dm-bio-list.h"
 
 #define	DM_MSG_PREFIX	"region hash"
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 981a041..d73f17f 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -22,7 +22,6 @@
 #include <linux/workqueue.h>
 
 #include "dm-exception-store.h"
-#include "dm-bio-list.h"
 
 #define DM_MSG_PREFIX "snapshots"
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8a994be..424f7b0 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -6,7 +6,6 @@
  */
 
 #include "dm.h"
-#include "dm-bio-list.h"
 #include "dm-uevent.h"
 
 #include <linux/init.h>
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 274b491..36df910 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -35,7 +35,6 @@
 #include <linux/blkdev.h>
 #include <linux/seq_file.h>
 #include "md.h"
-#include "dm-bio-list.h"
 #include "raid1.h"
 #include "bitmap.h"
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e293d92..81a54f1 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -22,7 +22,6 @@
 #include <linux/blkdev.h>
 #include <linux/seq_file.h>
 #include "md.h"
-#include "dm-bio-list.h"
 #include "raid10.h"
 #include "bitmap.h"
 
diff --git a/fs/bio.c b/fs/bio.c
index e0c9e54..cd42bb8 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -348,6 +348,24 @@ err:
 	return NULL;
 }
 
+/**
+ * bio_alloc - allocate a bio for I/O
+ * @gfp_mask:   the GFP_ mask given to the slab allocator
+ * @nr_iovecs:	number of iovecs to pre-allocate
+ *
+ * Description:
+ *   bio_alloc will allocate a bio and associated bio_vec array that can hold
+ *   at least @nr_iovecs entries. Allocations will be done from the
+ *   fs_bio_set. Also see @bio_alloc_bioset.
+ *
+ *   If %__GFP_WAIT is set, then bio_alloc will always be able to allocate
+ *   a bio. This is due to the mempool guarantees. To make this work, callers
+ *   must never allocate more than 1 bio at the time from this pool. Callers
+ *   that need to allocate more than 1 bio must always submit the previously
+ *   allocate bio for IO before attempting to allocate a new one. Failure to
+ *   do so can cause livelocks under memory pressure.
+ *
+ **/
 struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs)
 {
 	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
diff --git a/fs/buffer.c b/fs/buffer.c
index 13edf7a..ff8bb1f 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -547,7 +547,7 @@ repeat:
 	return err;
 }
 
-void do_thaw_all(unsigned long unused)
+void do_thaw_all(struct work_struct *work)
 {
 	struct super_block *sb;
 	char b[BDEVNAME_SIZE];
@@ -567,6 +567,7 @@ restart:
 			goto restart;
 	}
 	spin_unlock(&sb_lock);
+	kfree(work);
 	printk(KERN_WARNING "Emergency Thaw complete\n");
 }
 
@@ -577,7 +578,13 @@ restart:
  */
 void emergency_thaw_all(void)
 {
-	pdflush_operation(do_thaw_all, 0);
+	struct work_struct *work;
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (work) {
+		INIT_WORK(work, do_thaw_all);
+		schedule_work(work);
+	}
 }
 
 /**
diff --git a/fs/direct-io.c b/fs/direct-io.c
index da258e7..05763bb 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -307,8 +307,6 @@ dio_bio_alloc(struct dio *dio, struct block_device *bdev,
 	struct bio *bio;
 
 	bio = bio_alloc(GFP_KERNEL, nr_vecs);
-	if (bio == NULL)
-		return -ENOMEM;
 
 	bio->bi_bdev = bdev;
 	bio->bi_sector = first_sector;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6132353..2a1cb09 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2416,8 +2416,6 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 			len = ee_len;
 
 		bio = bio_alloc(GFP_NOIO, len);
-		if (!bio)
-			return -ENOMEM;
 		bio->bi_sector = ee_pblock;
 		bio->bi_bdev   = inode->i_sb->s_bdev;
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 51883b3..650a730 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -272,11 +272,6 @@ static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector)
 	lock_page(page);
 
 	bio = bio_alloc(GFP_NOFS, 1);
-	if (unlikely(!bio)) {
-		__free_page(page);
-		return -ENOBUFS;
-	}
-
 	bio->bi_sector = sector * (sb->s_blocksize >> 9);
 	bio->bi_bdev = sb->s_bdev;
 	bio_add_page(bio, page, PAGE_SIZE, 0);
diff --git a/fs/inode.c b/fs/inode.c
index d06d6d2..6ad14a1 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1470,42 +1470,6 @@ static void __wait_on_freeing_inode(struct inode *inode)
 	spin_lock(&inode_lock);
 }
 
-/*
- * We rarely want to lock two inodes that do not have a parent/child
- * relationship (such as directory, child inode) simultaneously. The
- * vast majority of file systems should be able to get along fine
- * without this. Do not use these functions except as a last resort.
- */
-void inode_double_lock(struct inode *inode1, struct inode *inode2)
-{
-	if (inode1 == NULL || inode2 == NULL || inode1 == inode2) {
-		if (inode1)
-			mutex_lock(&inode1->i_mutex);
-		else if (inode2)
-			mutex_lock(&inode2->i_mutex);
-		return;
-	}
-
-	if (inode1 < inode2) {
-		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_PARENT);
-		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_CHILD);
-	} else {
-		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_PARENT);
-		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_CHILD);
-	}
-}
-EXPORT_SYMBOL(inode_double_lock);
-
-void inode_double_unlock(struct inode *inode1, struct inode *inode2)
-{
-	if (inode1)
-		mutex_unlock(&inode1->i_mutex);
-
-	if (inode2 && inode2 != inode1)
-		mutex_unlock(&inode2->i_mutex);
-}
-EXPORT_SYMBOL(inode_double_unlock);
-
 static __initdata unsigned long ihash_entries;
 static int __init set_ihash_entries(char *str)
 {
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 8672b95..c2a87c8 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1912,6 +1912,22 @@ out_sems:
 	return written ? written : ret;
 }
 
+static int ocfs2_splice_to_file(struct pipe_inode_info *pipe,
+				struct file *out,
+				struct splice_desc *sd)
+{
+	int ret;
+
+	ret = ocfs2_prepare_inode_for_write(out->f_path.dentry,	&sd->pos,
+					    sd->total_len, 0, NULL);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return ret;
+	}
+
+	return splice_from_pipe_feed(pipe, sd, pipe_to_file);
+}
+
 static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 				       struct file *out,
 				       loff_t *ppos,
@@ -1919,38 +1935,76 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 				       unsigned int flags)
 {
 	int ret;
-	struct inode *inode = out->f_path.dentry->d_inode;
+	struct address_space *mapping = out->f_mapping;
+	struct inode *inode = mapping->host;
+	struct splice_desc sd = {
+		.total_len = len,
+		.flags = flags,
+		.pos = *ppos,
+		.u.file = out,
+	};
 
 	mlog_entry("(0x%p, 0x%p, %u, '%.*s')\n", out, pipe,
 		   (unsigned int)len,
 		   out->f_path.dentry->d_name.len,
 		   out->f_path.dentry->d_name.name);
 
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
+	if (pipe->inode)
+		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_PARENT);
 
-	ret = ocfs2_rw_lock(inode, 1);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out;
-	}
+	splice_from_pipe_begin(&sd);
+	do {
+		ret = splice_from_pipe_next(pipe, &sd);
+		if (ret <= 0)
+			break;
 
-	ret = ocfs2_prepare_inode_for_write(out->f_path.dentry, ppos, len, 0,
-					    NULL);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out_unlock;
-	}
+		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
+		ret = ocfs2_rw_lock(inode, 1);
+		if (ret < 0)
+			mlog_errno(ret);
+		else {
+			ret = ocfs2_splice_to_file(pipe, out, &sd);
+			ocfs2_rw_unlock(inode, 1);
+		}
+		mutex_unlock(&inode->i_mutex);
+	} while (ret > 0);
+	splice_from_pipe_end(pipe, &sd);
 
 	if (pipe->inode)
-		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_CHILD);
-	ret = generic_file_splice_write_nolock(pipe, out, ppos, len, flags);
-	if (pipe->inode)
 		mutex_unlock(&pipe->inode->i_mutex);
 
-out_unlock:
-	ocfs2_rw_unlock(inode, 1);
-out:
-	mutex_unlock(&inode->i_mutex);
+	if (sd.num_spliced)
+		ret = sd.num_spliced;
+
+	if (ret > 0) {
+		unsigned long nr_pages;
+
+		*ppos += ret;
+		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+
+		/*
+		 * If file or inode is SYNC and we actually wrote some data,
+		 * sync it.
+		 */
+		if (unlikely((out->f_flags & O_SYNC) || IS_SYNC(inode))) {
+			int err;
+
+			mutex_lock(&inode->i_mutex);
+			err = ocfs2_rw_lock(inode, 1);
+			if (err < 0) {
+				mlog_errno(err);
+			} else {
+				err = generic_osync_inode(inode, mapping,
+						  OSYNC_METADATA|OSYNC_DATA);
+				ocfs2_rw_unlock(inode, 1);
+			}
+			mutex_unlock(&inode->i_mutex);
+
+			if (err)
+				ret = err;
+		}
+		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
+	}
 
 	mlog_exit(ret);
 	return ret;
diff --git a/fs/pipe.c b/fs/pipe.c
index 4af7aa5..13414ec 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -37,6 +37,42 @@
  * -- Manfred Spraul <manfred@colorfullife.com> 2002-05-09
  */
 
+static void pipe_lock_nested(struct pipe_inode_info *pipe, int subclass)
+{
+	if (pipe->inode)
+		mutex_lock_nested(&pipe->inode->i_mutex, subclass);
+}
+
+void pipe_lock(struct pipe_inode_info *pipe)
+{
+	/*
+	 * pipe_lock() nests non-pipe inode locks (for writing to a file)
+	 */
+	pipe_lock_nested(pipe, I_MUTEX_PARENT);
+}
+EXPORT_SYMBOL(pipe_lock);
+
+void pipe_unlock(struct pipe_inode_info *pipe)
+{
+	if (pipe->inode)
+		mutex_unlock(&pipe->inode->i_mutex);
+}
+EXPORT_SYMBOL(pipe_unlock);
+
+void pipe_double_lock(struct pipe_inode_info *pipe1,
+		      struct pipe_inode_info *pipe2)
+{
+	BUG_ON(pipe1 == pipe2);
+
+	if (pipe1 < pipe2) {
+		pipe_lock_nested(pipe1, I_MUTEX_PARENT);
+		pipe_lock_nested(pipe2, I_MUTEX_CHILD);
+	} else {
+		pipe_lock_nested(pipe2, I_MUTEX_CHILD);
+		pipe_lock_nested(pipe1, I_MUTEX_PARENT);
+	}
+}
+
 /* Drop the inode semaphore and wait for a pipe event, atomically */
 void pipe_wait(struct pipe_inode_info *pipe)
 {
@@ -47,12 +83,10 @@ void pipe_wait(struct pipe_inode_info *pipe)
 	 * is considered a noninteractive wait:
 	 */
 	prepare_to_wait(&pipe->wait, &wait, TASK_INTERRUPTIBLE);
-	if (pipe->inode)
-		mutex_unlock(&pipe->inode->i_mutex);
+	pipe_unlock(pipe);
 	schedule();
 	finish_wait(&pipe->wait, &wait);
-	if (pipe->inode)
-		mutex_lock(&pipe->inode->i_mutex);
+	pipe_lock(pipe);
 }
 
 static int
diff --git a/fs/splice.c b/fs/splice.c
index c18aa7e..5384a90 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -182,8 +182,7 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 	do_wakeup = 0;
 	page_nr = 0;
 
-	if (pipe->inode)
-		mutex_lock(&pipe->inode->i_mutex);
+	pipe_lock(pipe);
 
 	for (;;) {
 		if (!pipe->readers) {
@@ -245,15 +244,13 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 		pipe->waiting_writers--;
 	}
 
-	if (pipe->inode) {
-		mutex_unlock(&pipe->inode->i_mutex);
+	pipe_unlock(pipe);
 
-		if (do_wakeup) {
-			smp_mb();
-			if (waitqueue_active(&pipe->wait))
-				wake_up_interruptible(&pipe->wait);
-			kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
-		}
+	if (do_wakeup) {
+		smp_mb();
+		if (waitqueue_active(&pipe->wait))
+			wake_up_interruptible(&pipe->wait);
+		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 	}
 
 	while (page_nr < spd_pages)
@@ -555,8 +552,8 @@ static int pipe_to_sendpage(struct pipe_inode_info *pipe,
  * SPLICE_F_MOVE isn't set, or we cannot move the page, we simply create
  * a new page in the output file page cache and fill/dirty that.
  */
-static int pipe_to_file(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
-			struct splice_desc *sd)
+int pipe_to_file(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
+		 struct splice_desc *sd)
 {
 	struct file *file = sd->u.file;
 	struct address_space *mapping = file->f_mapping;
@@ -600,108 +597,178 @@ static int pipe_to_file(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 out:
 	return ret;
 }
+EXPORT_SYMBOL(pipe_to_file);
+
+static void wakeup_pipe_writers(struct pipe_inode_info *pipe)
+{
+	smp_mb();
+	if (waitqueue_active(&pipe->wait))
+		wake_up_interruptible(&pipe->wait);
+	kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
+}
 
 /**
- * __splice_from_pipe - splice data from a pipe to given actor
+ * splice_from_pipe_feed - feed available data from a pipe to a file
  * @pipe:	pipe to splice from
  * @sd:		information to @actor
  * @actor:	handler that splices the data
  *
  * Description:
- *    This function does little more than loop over the pipe and call
- *    @actor to do the actual moving of a single struct pipe_buffer to
- *    the desired destination. See pipe_to_file, pipe_to_sendpage, or
- *    pipe_to_user.
+
+ *    This function loops over the pipe and calls @actor to do the
+ *    actual moving of a single struct pipe_buffer to the desired
+ *    destination.  It returns when there's no more buffers left in
+ *    the pipe or if the requested number of bytes (@sd->total_len)
+ *    have been copied.  It returns a positive number (one) if the
+ *    pipe needs to be filled with more data, zero if the required
+ *    number of bytes have been copied and -errno on error.
  *
+ *    This, together with splice_from_pipe_{begin,end,next}, may be
+ *    used to implement the functionality of __splice_from_pipe() when
+ *    locking is required around copying the pipe buffers to the
+ *    destination.
  */
-ssize_t __splice_from_pipe(struct pipe_inode_info *pipe, struct splice_desc *sd,
-			   splice_actor *actor)
+int splice_from_pipe_feed(struct pipe_inode_info *pipe, struct splice_desc *sd,
+			  splice_actor *actor)
 {
-	int ret, do_wakeup, err;
-
-	ret = 0;
-	do_wakeup = 0;
-
-	for (;;) {
-		if (pipe->nrbufs) {
-			struct pipe_buffer *buf = pipe->bufs + pipe->curbuf;
-			const struct pipe_buf_operations *ops = buf->ops;
+	int ret;
 
-			sd->len = buf->len;
-			if (sd->len > sd->total_len)
-				sd->len = sd->total_len;
+	while (pipe->nrbufs) {
+		struct pipe_buffer *buf = pipe->bufs + pipe->curbuf;
+		const struct pipe_buf_operations *ops = buf->ops;
 
-			err = actor(pipe, buf, sd);
-			if (err <= 0) {
-				if (!ret && err != -ENODATA)
-					ret = err;
+		sd->len = buf->len;
+		if (sd->len > sd->total_len)
+			sd->len = sd->total_len;
 
-				break;
-			}
+		ret = actor(pipe, buf, sd);
+		if (ret <= 0) {
+			if (ret == -ENODATA)
+				ret = 0;
+			return ret;
+		}
+		buf->offset += ret;
+		buf->len -= ret;
 
-			ret += err;
-			buf->offset += err;
-			buf->len -= err;
+		sd->num_spliced += ret;
+		sd->len -= ret;
+		sd->pos += ret;
+		sd->total_len -= ret;
 
-			sd->len -= err;
-			sd->pos += err;
-			sd->total_len -= err;
-			if (sd->len)
-				continue;
+		if (!buf->len) {
+			buf->ops = NULL;
+			ops->release(pipe, buf);
+			pipe->curbuf = (pipe->curbuf + 1) & (PIPE_BUFFERS - 1);
+			pipe->nrbufs--;
+			if (pipe->inode)
+				sd->need_wakeup = true;
+		}
 
-			if (!buf->len) {
-				buf->ops = NULL;
-				ops->release(pipe, buf);
-				pipe->curbuf = (pipe->curbuf + 1) & (PIPE_BUFFERS - 1);
-				pipe->nrbufs--;
-				if (pipe->inode)
-					do_wakeup = 1;
-			}
+		if (!sd->total_len)
+			return 0;
+	}
 
-			if (!sd->total_len)
-				break;
-		}
+	return 1;
+}
+EXPORT_SYMBOL(splice_from_pipe_feed);
 
-		if (pipe->nrbufs)
-			continue;
+/**
+ * splice_from_pipe_next - wait for some data to splice from
+ * @pipe:	pipe to splice from
+ * @sd:		information about the splice operation
+ *
+ * Description:
+ *    This function will wait for some data and return a positive
+ *    value (one) if pipe buffers are available.  It will return zero
+ *    or -errno if no more data needs to be spliced.
+ */
+int splice_from_pipe_next(struct pipe_inode_info *pipe, struct splice_desc *sd)
+{
+	while (!pipe->nrbufs) {
 		if (!pipe->writers)
-			break;
-		if (!pipe->waiting_writers) {
-			if (ret)
-				break;
-		}
+			return 0;
 
-		if (sd->flags & SPLICE_F_NONBLOCK) {
-			if (!ret)
-				ret = -EAGAIN;
-			break;
-		}
+		if (!pipe->waiting_writers && sd->num_spliced)
+			return 0;
 
-		if (signal_pending(current)) {
-			if (!ret)
-				ret = -ERESTARTSYS;
-			break;
-		}
+		if (sd->flags & SPLICE_F_NONBLOCK)
+			return -EAGAIN;
 
-		if (do_wakeup) {
-			smp_mb();
-			if (waitqueue_active(&pipe->wait))
-				wake_up_interruptible_sync(&pipe->wait);
-			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
-			do_wakeup = 0;
+		if (signal_pending(current))
+			return -ERESTARTSYS;
+
+		if (sd->need_wakeup) {
+			wakeup_pipe_writers(pipe);
+			sd->need_wakeup = false;
 		}
 
 		pipe_wait(pipe);
 	}
 
-	if (do_wakeup) {
-		smp_mb();
-		if (waitqueue_active(&pipe->wait))
-			wake_up_interruptible(&pipe->wait);
-		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
-	}
+	return 1;
+}
+EXPORT_SYMBOL(splice_from_pipe_next);
 
-	return ret;
+/**
+ * splice_from_pipe_begin - start splicing from pipe
+ * @pipe:	pipe to splice from
+ *
+ * Description:
+ *    This function should be called before a loop containing
+ *    splice_from_pipe_next() and splice_from_pipe_feed() to
+ *    initialize the necessary fields of @sd.
+ */
+void splice_from_pipe_begin(struct splice_desc *sd)
+{
+	sd->num_spliced = 0;
+	sd->need_wakeup = false;
+}
+EXPORT_SYMBOL(splice_from_pipe_begin);
+
+/**
+ * splice_from_pipe_end - finish splicing from pipe
+ * @pipe:	pipe to splice from
+ * @sd:		information about the splice operation
+ *
+ * Description:
+ *    This function will wake up pipe writers if necessary.  It should
+ *    be called after a loop containing splice_from_pipe_next() and
+ *    splice_from_pipe_feed().
+ */
+void splice_from_pipe_end(struct pipe_inode_info *pipe, struct splice_desc *sd)
+{
+	if (sd->need_wakeup)
+		wakeup_pipe_writers(pipe);
+}
+EXPORT_SYMBOL(splice_from_pipe_end);
+
+/**
+ * __splice_from_pipe - splice data from a pipe to given actor
+ * @pipe:	pipe to splice from
+ * @sd:		information to @actor
+ * @actor:	handler that splices the data
+ *
+ * Description:
+ *    This function does little more than loop over the pipe and call
+ *    @actor to do the actual moving of a single struct pipe_buffer to
+ *    the desired destination. See pipe_to_file, pipe_to_sendpage, or
+ *    pipe_to_user.
+ *
+ */
+ssize_t __splice_from_pipe(struct pipe_inode_info *pipe, struct splice_desc *sd,
+			   splice_actor *actor)
+{
+	int ret;
+
+	splice_from_pipe_begin(sd);
+	do {
+		ret = splice_from_pipe_next(pipe, sd);
+		if (ret > 0)
+			ret = splice_from_pipe_feed(pipe, sd, actor);
+	} while (ret > 0);
+	splice_from_pipe_end(pipe, sd);
+
+	return sd->num_spliced ? sd->num_spliced : ret;
 }
 EXPORT_SYMBOL(__splice_from_pipe);
 
@@ -715,7 +782,7 @@ EXPORT_SYMBOL(__splice_from_pipe);
  * @actor:	handler that splices the data
  *
  * Description:
- *    See __splice_from_pipe. This function locks the input and output inodes,
+ *    See __splice_from_pipe. This function locks the pipe inode,
  *    otherwise it's identical to __splice_from_pipe().
  *
  */
@@ -724,7 +791,6 @@ ssize_t splice_from_pipe(struct pipe_inode_info *pipe, struct file *out,
 			 splice_actor *actor)
 {
 	ssize_t ret;
-	struct inode *inode = out->f_mapping->host;
 	struct splice_desc sd = {
 		.total_len = len,
 		.flags = flags,
@@ -732,30 +798,15 @@ ssize_t splice_from_pipe(struct pipe_inode_info *pipe, struct file *out,
 		.u.file = out,
 	};
 
-	/*
-	 * The actor worker might be calling ->write_begin and
-	 * ->write_end. Most of the time, these expect i_mutex to
-	 * be held. Since this may result in an ABBA deadlock with
-	 * pipe->inode, we have to order lock acquiry here.
-	 *
-	 * Outer lock must be inode->i_mutex, as pipe_wait() will
-	 * release and reacquire pipe->inode->i_mutex, AND inode must
-	 * never be a pipe.
-	 */
-	WARN_ON(S_ISFIFO(inode->i_mode));
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
-	if (pipe->inode)
-		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_CHILD);
+	pipe_lock(pipe);
 	ret = __splice_from_pipe(pipe, &sd, actor);
-	if (pipe->inode)
-		mutex_unlock(&pipe->inode->i_mutex);
-	mutex_unlock(&inode->i_mutex);
+	pipe_unlock(pipe);
 
 	return ret;
 }
 
 /**
- * generic_file_splice_write_nolock - generic_file_splice_write without mutexes
+ * generic_file_splice_write - splice data from a pipe to a file
  * @pipe:	pipe info
  * @out:	file to write to
  * @ppos:	position in @out
@@ -764,13 +815,12 @@ ssize_t splice_from_pipe(struct pipe_inode_info *pipe, struct file *out,
  *
  * Description:
  *    Will either move or copy pages (determined by @flags options) from
- *    the given pipe inode to the given file. The caller is responsible
- *    for acquiring i_mutex on both inodes.
+ *    the given pipe inode to the given file.
  *
  */
 ssize_t
-generic_file_splice_write_nolock(struct pipe_inode_info *pipe, struct file *out,
-				 loff_t *ppos, size_t len, unsigned int flags)
+generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
+			  loff_t *ppos, size_t len, unsigned int flags)
 {
 	struct address_space *mapping = out->f_mapping;
 	struct inode *inode = mapping->host;
@@ -781,76 +831,28 @@ generic_file_splice_write_nolock(struct pipe_inode_info *pipe, struct file *out,
 		.u.file = out,
 	};
 	ssize_t ret;
-	int err;
-
-	err = file_remove_suid(out);
-	if (unlikely(err))
-		return err;
-
-	ret = __splice_from_pipe(pipe, &sd, pipe_to_file);
-	if (ret > 0) {
-		unsigned long nr_pages;
 
-		*ppos += ret;
-		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	pipe_lock(pipe);
 
-		/*
-		 * If file or inode is SYNC and we actually wrote some data,
-		 * sync it.
-		 */
-		if (unlikely((out->f_flags & O_SYNC) || IS_SYNC(inode))) {
-			err = generic_osync_inode(inode, mapping,
-						  OSYNC_METADATA|OSYNC_DATA);
-
-			if (err)
-				ret = err;
-		}
-		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
-	}
+	splice_from_pipe_begin(&sd);
+	do {
+		ret = splice_from_pipe_next(pipe, &sd);
+		if (ret <= 0)
+			break;
 
-	return ret;
-}
+		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
+		ret = file_remove_suid(out);
+		if (!ret)
+			ret = splice_from_pipe_feed(pipe, &sd, pipe_to_file);
+		mutex_unlock(&inode->i_mutex);
+	} while (ret > 0);
+	splice_from_pipe_end(pipe, &sd);
 
-EXPORT_SYMBOL(generic_file_splice_write_nolock);
+	pipe_unlock(pipe);
 
-/**
- * generic_file_splice_write - splice data from a pipe to a file
- * @pipe:	pipe info
- * @out:	file to write to
- * @ppos:	position in @out
- * @len:	number of bytes to splice
- * @flags:	splice modifier flags
- *
- * Description:
- *    Will either move or copy pages (determined by @flags options) from
- *    the given pipe inode to the given file.
- *
- */
-ssize_t
-generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
-			  loff_t *ppos, size_t len, unsigned int flags)
-{
-	struct address_space *mapping = out->f_mapping;
-	struct inode *inode = mapping->host;
-	struct splice_desc sd = {
-		.total_len = len,
-		.flags = flags,
-		.pos = *ppos,
-		.u.file = out,
-	};
-	ssize_t ret;
+	if (sd.num_spliced)
+		ret = sd.num_spliced;
 
-	WARN_ON(S_ISFIFO(inode->i_mode));
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
-	ret = file_remove_suid(out);
-	if (likely(!ret)) {
-		if (pipe->inode)
-			mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_CHILD);
-		ret = __splice_from_pipe(pipe, &sd, pipe_to_file);
-		if (pipe->inode)
-			mutex_unlock(&pipe->inode->i_mutex);
-	}
-	mutex_unlock(&inode->i_mutex);
 	if (ret > 0) {
 		unsigned long nr_pages;
 
@@ -1339,8 +1341,7 @@ static long vmsplice_to_user(struct file *file, const struct iovec __user *iov,
 	if (!pipe)
 		return -EBADF;
 
-	if (pipe->inode)
-		mutex_lock(&pipe->inode->i_mutex);
+	pipe_lock(pipe);
 
 	error = ret = 0;
 	while (nr_segs) {
@@ -1395,8 +1396,7 @@ static long vmsplice_to_user(struct file *file, const struct iovec __user *iov,
 		iov++;
 	}
 
-	if (pipe->inode)
-		mutex_unlock(&pipe->inode->i_mutex);
+	pipe_unlock(pipe);
 
 	if (!ret)
 		ret = error;
@@ -1524,7 +1524,7 @@ static int link_ipipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 		return 0;
 
 	ret = 0;
-	mutex_lock(&pipe->inode->i_mutex);
+	pipe_lock(pipe);
 
 	while (!pipe->nrbufs) {
 		if (signal_pending(current)) {
@@ -1542,7 +1542,7 @@ static int link_ipipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 		pipe_wait(pipe);
 	}
 
-	mutex_unlock(&pipe->inode->i_mutex);
+	pipe_unlock(pipe);
 	return ret;
 }
 
@@ -1562,7 +1562,7 @@ static int link_opipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 		return 0;
 
 	ret = 0;
-	mutex_lock(&pipe->inode->i_mutex);
+	pipe_lock(pipe);
 
 	while (pipe->nrbufs >= PIPE_BUFFERS) {
 		if (!pipe->readers) {
@@ -1583,7 +1583,7 @@ static int link_opipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 		pipe->waiting_writers--;
 	}
 
-	mutex_unlock(&pipe->inode->i_mutex);
+	pipe_unlock(pipe);
 	return ret;
 }
 
@@ -1599,10 +1599,10 @@ static int link_pipe(struct pipe_inode_info *ipipe,
 
 	/*
 	 * Potential ABBA deadlock, work around it by ordering lock
-	 * grabbing by inode address. Otherwise two different processes
+	 * grabbing by pipe info address. Otherwise two different processes
 	 * could deadlock (one doing tee from A -> B, the other from B -> A).
 	 */
-	inode_double_lock(ipipe->inode, opipe->inode);
+	pipe_double_lock(ipipe, opipe);
 
 	do {
 		if (!opipe->readers) {
@@ -1653,7 +1653,8 @@ static int link_pipe(struct pipe_inode_info *ipipe,
 	if (!ret && ipipe->waiting_writers && (flags & SPLICE_F_NONBLOCK))
 		ret = -EAGAIN;
 
-	inode_double_unlock(ipipe->inode, opipe->inode);
+	pipe_unlock(ipipe);
+	pipe_unlock(opipe);
 
 	/*
 	 * If we put data in the output pipe, wakeup any potential readers.
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b900d2c..b89cf2d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -504,6 +504,115 @@ static inline int bio_has_data(struct bio *bio)
 	return bio && bio->bi_io_vec != NULL;
 }
 
+/*
+ * BIO list managment for use by remapping drivers (e.g. DM or MD).
+ *
+ * A bio_list anchors a singly-linked list of bios chained through the bi_next
+ * member of the bio.  The bio_list also caches the last list member to allow
+ * fast access to the tail.
+ */
+struct bio_list {
+	struct bio *head;
+	struct bio *tail;
+};
+
+static inline int bio_list_empty(const struct bio_list *bl)
+{
+	return bl->head == NULL;
+}
+
+static inline void bio_list_init(struct bio_list *bl)
+{
+	bl->head = bl->tail = NULL;
+}
+
+#define bio_list_for_each(bio, bl) \
+	for (bio = (bl)->head; bio; bio = bio->bi_next)
+
+static inline unsigned bio_list_size(const struct bio_list *bl)
+{
+	unsigned sz = 0;
+	struct bio *bio;
+
+	bio_list_for_each(bio, bl)
+		sz++;
+
+	return sz;
+}
+
+static inline void bio_list_add(struct bio_list *bl, struct bio *bio)
+{
+	bio->bi_next = NULL;
+
+	if (bl->tail)
+		bl->tail->bi_next = bio;
+	else
+		bl->head = bio;
+
+	bl->tail = bio;
+}
+
+static inline void bio_list_add_head(struct bio_list *bl, struct bio *bio)
+{
+	bio->bi_next = bl->head;
+
+	bl->head = bio;
+
+	if (!bl->tail)
+		bl->tail = bio;
+}
+
+static inline void bio_list_merge(struct bio_list *bl, struct bio_list *bl2)
+{
+	if (!bl2->head)
+		return;
+
+	if (bl->tail)
+		bl->tail->bi_next = bl2->head;
+	else
+		bl->head = bl2->head;
+
+	bl->tail = bl2->tail;
+}
+
+static inline void bio_list_merge_head(struct bio_list *bl,
+				       struct bio_list *bl2)
+{
+	if (!bl2->head)
+		return;
+
+	if (bl->head)
+		bl2->tail->bi_next = bl->head;
+	else
+		bl->tail = bl2->tail;
+
+	bl->head = bl2->head;
+}
+
+static inline struct bio *bio_list_pop(struct bio_list *bl)
+{
+	struct bio *bio = bl->head;
+
+	if (bio) {
+		bl->head = bl->head->bi_next;
+		if (!bl->head)
+			bl->tail = NULL;
+
+		bio->bi_next = NULL;
+	}
+
+	return bio;
+}
+
+static inline struct bio *bio_list_get(struct bio_list *bl)
+{
+	struct bio *bio = bl->head;
+
+	bl->head = bl->tail = NULL;
+
+	return bio;
+}
+
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 
 #define bip_vec_idx(bip, idx)	(&(bip->bip_vec[(idx)]))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 562d285..e766be0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -87,6 +87,60 @@ struct inodes_stat_t {
  */
 #define FMODE_NOCMTIME		((__force fmode_t)2048)
 
+/*
+ * The below are the various read and write types that we support. Some of
+ * them include behavioral modifiers that send information down to the
+ * block layer and IO scheduler. Terminology:
+ *
+ *	The block layer uses device plugging to defer IO a little bit, in
+ *	the hope that we will see more IO very shortly. This increases
+ *	coalescing of adjacent IO and thus reduces the number of IOs we
+ *	have to send to the device. It also allows for better queuing,
+ *	if the IO isn't mergeable. If the caller is going to be waiting
+ *	for the IO, then he must ensure that the device is unplugged so
+ *	that the IO is dispatched to the driver.
+ *
+ *	All IO is handled async in Linux. This is fine for background
+ *	writes, but for reads or writes that someone waits for completion
+ *	on, we want to notify the block layer and IO scheduler so that they
+ *	know about it. That allows them to make better scheduling
+ *	decisions. So when the below references 'sync' and 'async', it
+ *	is referencing this priority hint.
+ *
+ * With that in mind, the available types are:
+ *
+ * READ			A normal read operation. Device will be plugged.
+ * READ_SYNC		A synchronous read. Device is not plugged, caller can
+ *			immediately wait on this read without caring about
+ *			unplugging.
+ * READA		Used for read-ahead operations. Lower priority, and the
+ *			 block layer could (in theory) choose to ignore this
+ *			request if it runs into resource problems.
+ * WRITE		A normal async write. Device will be plugged.
+ * SWRITE		Like WRITE, but a special case for ll_rw_block() that
+ *			tells it to lock the buffer first. Normally a buffer
+ *			must be locked before doing IO.
+ * WRITE_SYNC_PLUG	Synchronous write. Identical to WRITE, but passes down
+ *			the hint that someone will be waiting on this IO
+ *			shortly. The device must still be unplugged explicitly,
+ *			WRITE_SYNC_PLUG does not do this as we could be
+ *			submitting more writes before we actually wait on any
+ *			of them.
+ * WRITE_SYNC		Like WRITE_SYNC_PLUG, but also unplugs the device
+ *			immediately after submission. The write equivalent
+ *			of READ_SYNC.
+ * WRITE_ODIRECT	Special case write for O_DIRECT only.
+ * SWRITE_SYNC
+ * SWRITE_SYNC_PLUG	Like WRITE_SYNC/WRITE_SYNC_PLUG, but locks the buffer.
+ *			See SWRITE.
+ * WRITE_BARRIER	Like WRITE, but tells the block layer that all
+ *			previously submitted writes must be safely on storage
+ *			before this one is started. Also guarantees that when
+ *			this write is complete, it itself is also safely on
+ *			storage. Prevents reordering of writes on both sides
+ *			of this IO.
+ *
+ */
 #define RW_MASK		1
 #define RWA_MASK	2
 #define READ 0
@@ -102,6 +156,11 @@ struct inodes_stat_t {
 			(SWRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_NOIDLE))
 #define SWRITE_SYNC	(SWRITE_SYNC_PLUG | (1 << BIO_RW_UNPLUG))
 #define WRITE_BARRIER	(WRITE | (1 << BIO_RW_BARRIER))
+
+/*
+ * These aren't really reads or writes, they pass down information about
+ * parts of device that are now unused by the file system.
+ */
 #define DISCARD_NOBARRIER (1 << BIO_RW_DISCARD)
 #define DISCARD_BARRIER ((1 << BIO_RW_DISCARD) | (1 << BIO_RW_BARRIER))
 
@@ -738,9 +797,6 @@ enum inode_i_mutex_lock_class
 	I_MUTEX_QUOTA
 };
 
-extern void inode_double_lock(struct inode *inode1, struct inode *inode2);
-extern void inode_double_unlock(struct inode *inode1, struct inode *inode2);
-
 /*
  * NOTE: in a 32bit arch with a preemptable kernel and
  * an UP compile the i_size_read/write must be atomic
@@ -2150,8 +2206,6 @@ extern ssize_t generic_file_splice_read(struct file *, loff_t *,
 		struct pipe_inode_info *, size_t, unsigned int);
 extern ssize_t generic_file_splice_write(struct pipe_inode_info *,
 		struct file *, loff_t *, size_t, unsigned int);
-extern ssize_t generic_file_splice_write_nolock(struct pipe_inode_info *,
-		struct file *, loff_t *, size_t, unsigned int);
 extern ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
 		struct file *out, loff_t *, size_t len, unsigned int flags);
 extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 8e41202..c8f0385 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -134,6 +134,11 @@ struct pipe_buf_operations {
    memory allocation, whereas PIPE_BUF makes atomicity guarantees.  */
 #define PIPE_SIZE		PAGE_SIZE
 
+/* Pipe lock and unlock operations */
+void pipe_lock(struct pipe_inode_info *);
+void pipe_unlock(struct pipe_inode_info *);
+void pipe_double_lock(struct pipe_inode_info *, struct pipe_inode_info *);
+
 /* Drop the inode semaphore and wait for a pipe event, atomically */
 void pipe_wait(struct pipe_inode_info *pipe);
 
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 528dcb9..5f3faa9 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -36,6 +36,8 @@ struct splice_desc {
 		void *data;		/* cookie */
 	} u;
 	loff_t pos;			/* file position */
+	size_t num_spliced;		/* number of bytes already spliced */
+	bool need_wakeup;		/* need to wake up writer */
 };
 
 struct partial_page {
@@ -66,6 +68,16 @@ extern ssize_t splice_from_pipe(struct pipe_inode_info *, struct file *,
 				splice_actor *);
 extern ssize_t __splice_from_pipe(struct pipe_inode_info *,
 				  struct splice_desc *, splice_actor *);
+extern int splice_from_pipe_feed(struct pipe_inode_info *, struct splice_desc *,
+				 splice_actor *);
+extern int splice_from_pipe_next(struct pipe_inode_info *,
+				 struct splice_desc *);
+extern void splice_from_pipe_begin(struct splice_desc *);
+extern void splice_from_pipe_end(struct pipe_inode_info *,
+				 struct splice_desc *);
+extern int pipe_to_file(struct pipe_inode_info *, struct pipe_buffer *,
+			struct splice_desc *);
+
 extern ssize_t splice_to_pipe(struct pipe_inode_info *,
 			      struct splice_pipe_desc *);
 extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 505f319..8ba052c 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -64,8 +64,6 @@ static int submit(int rw, pgoff_t page_off, struct page *page,
 	struct bio *bio;
 
 	bio = bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
-	if (!bio)
-		return -ENOMEM;
 	bio->bi_sector = page_off * (PAGE_SIZE >> 9);
 	bio->bi_bdev = resume_bdev;
 	bio->bi_end_io = end_swap_bio_read;

-- 
Jens Axboe

