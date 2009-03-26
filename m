Return-Path: <linux-kernel-owner+w=401wt.eu-S1759755AbZCZPyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbZCZPyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZCZPyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:54:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37896 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179AbZCZPyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:54:37 -0400
Message-ID: <49CBA4F4.5040409@redhat.com>
Date: Thu, 26 Mar 2009 16:53:24 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] block: fix inconsistency in I/O stat accounting code
References: <49CBA46E.6050306@redhat.com>
In-Reply-To: <49CBA46E.6050306@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This forces in_flight to be zero when turning off or on the I/O stat
accounting and stops updating I/O stats in attempt_merge() when
accounting is turned off.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 block/blk-core.c         |   13 ++++---------
 block/blk-merge.c        |   29 +++++++++++++++++------------
 block/blk-sysfs.c        |    4 ++++
 block/blk.h              |   10 ++++++----
 block/elevator.c         |    2 +-
 include/linux/elevator.h |    1 +
 6 files changed, 33 insertions(+), 26 deletions(-)

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c
+++ linux-2.6/block/blk-core.c
@@ -64,12 +64,11 @@ static struct workqueue_struct *kblockd_

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
@@ -1665,9 +1664,7 @@ EXPORT_SYMBOL(blkdev_dequeue_request);

 static void blk_account_io_completion(struct request *req, unsigned int
bytes)
 {
-	struct gendisk *disk = req->rq_disk;
-
-	if (!disk || !blk_do_io_stat(disk->queue))
+	if (!blk_do_io_stat(req))
 		return;

 	if (blk_fs_request(req)) {
@@ -1684,9 +1681,7 @@ static void blk_account_io_completion(st

 static void blk_account_io_done(struct request *req)
 {
-	struct gendisk *disk = req->rq_disk;
-
-	if (!disk || !blk_do_io_stat(disk->queue))
+	if (!blk_do_io_stat(req))
 		return;

 	/*
@@ -1701,7 +1696,7 @@ static void blk_account_io_done(struct r
 		int cpu;

 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(disk, req->sector);
+		part = disk_map_sector_rcu(req->rq_disk, req->sector);

 		part_stat_inc(cpu, part, ios[rw]);
 		part_stat_add(cpu, part, ticks[rw], duration);
Index: linux-2.6/block/blk-merge.c
===================================================================
--- linux-2.6.orig/block/blk-merge.c
+++ linux-2.6/block/blk-merge.c
@@ -338,6 +338,22 @@ static int ll_merge_requests_fn(struct r
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
@@ -386,18 +402,7 @@ static int attempt_merge(struct request_

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
Index: linux-2.6/block/blk-sysfs.c
===================================================================
--- linux-2.6.orig/block/blk-sysfs.c
+++ linux-2.6/block/blk-sysfs.c
@@ -209,10 +209,14 @@ static ssize_t queue_iostats_store(struc
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
Index: linux-2.6/block/blk.h
===================================================================
--- linux-2.6.orig/block/blk.h
+++ linux-2.6/block/blk.h
@@ -112,12 +112,14 @@ static inline int blk_cpu_to_group(int c
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
Index: linux-2.6/block/elevator.c
===================================================================
--- linux-2.6.orig/block/elevator.c
+++ linux-2.6/block/elevator.c
@@ -573,7 +573,7 @@ void elv_requeue_request(struct request_
 	elv_insert(q, rq, ELEVATOR_INSERT_REQUEUE);
 }

-static void elv_drain_elevator(struct request_queue *q)
+void elv_drain_elevator(struct request_queue *q)
 {
 	static int printed;
 	while (q->elevator->ops->elevator_dispatch_fn(q, 1))
Index: linux-2.6/include/linux/elevator.h
===================================================================
--- linux-2.6.orig/include/linux/elevator.h
+++ linux-2.6/include/linux/elevator.h
@@ -116,6 +116,7 @@ extern void elv_abort_queue(struct reque
 extern void elv_completed_request(struct request_queue *, struct
request *);
 extern int elv_set_request(struct request_queue *, struct request *,
gfp_t);
 extern void elv_put_request(struct request_queue *, struct request *);
+extern void elv_drain_elevator(struct request_queue *);

 /*
  * io scheduler registration
