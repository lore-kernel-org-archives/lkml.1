Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbZCTNfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbZCTNfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbZCTNfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:35:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43759 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbZCTNfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:35:42 -0400
Message-Id: <200903201335.n2KDZaLu023877@dhcp-0-152.brq.redhat.com>
From: Jerome Marchand <jmarchan@redhat.com>
Date: Thu, 19 Mar 2009 11:54:17 +0100
Subject: [PATCH] block: allows to turn off disk I/O stat accounting completely
Cc: Jens Axboe <axboe@kernel.dk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some stat updates are still executed when disk I/O stat accounting is
turned off. This patch allows to turn them off too.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 block/blk-merge.c     |   31 +++++++++++++++++++------------
 block/genhd.c         |    8 +++++---
 fs/partitions/check.c |    9 ++++++---
 3 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5a244f0..6841c3f 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -338,6 +338,24 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 	return 1;
 }
 
+static void blk_account_io_merge(struct request *req)
+{
+	struct gendisk *disk = req->rq_disk;
+
+	if (disk && blk_do_io_stat(disk->queue)) {
+		struct hd_struct *part;
+		int cpu;
+
+		cpu = part_stat_lock();
+		part = disk_map_sector_rcu(disk, req->sector);
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
@@ -386,18 +404,7 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 
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
diff --git a/block/genhd.c b/block/genhd.c
index a9ec910..d527f10 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1013,9 +1013,11 @@ static int diskstats_show(struct seq_file *seqf, void *v)
  
 	disk_part_iter_init(&piter, gp, DISK_PITER_INCL_PART0);
 	while ((hd = disk_part_iter_next(&piter))) {
-		cpu = part_stat_lock();
-		part_round_stats(cpu, hd);
-		part_stat_unlock();
+		if (blk_do_io_stat(gp->queue)) {
+			cpu = part_stat_lock();
+			part_round_stats(cpu, hd);
+			part_stat_unlock();
+		}
 		seq_printf(seqf, "%4d %7d %s %lu %lu %llu "
 			   "%u %lu %lu %llu %u %u %u %u\n",
 			   MAJOR(part_devt(hd)), MINOR(part_devt(hd)),
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 6d72024..5f773cd 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -21,6 +21,7 @@
 #include <linux/genhd.h>
 
 #include "check.h"
+#include "../block/blk.h"
 
 #include "acorn.h"
 #include "amiga.h"
@@ -224,9 +225,11 @@ ssize_t part_stat_show(struct device *dev,
 	struct hd_struct *p = dev_to_part(dev);
 	int cpu;
 
-	cpu = part_stat_lock();
-	part_round_stats(cpu, p);
-	part_stat_unlock();
+	if (blk_do_io_stat(dev_to_disk(dev)->queue)) {
+		cpu = part_stat_lock();
+		part_round_stats(cpu, p);
+		part_stat_unlock();
+	}
 	return sprintf(buf,
 		"%8lu %8lu %8llu %8u "
 		"%8lu %8lu %8llu %8u "
-- 
1.5.5.1

