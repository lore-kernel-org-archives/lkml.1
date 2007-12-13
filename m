Return-Path: <linux-kernel-owner+w=401wt.eu-S1762499AbXLMQTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762499AbXLMQTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762113AbXLMQSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:18:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760361AbXLMQSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:18:35 -0500
Message-ID: <47615B1F.7030603@redhat.com>
Date: Thu, 13 Dec 2007 17:17:35 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk
Subject: [Patch 2/8] Enhanced partition statistics: update partition statitics
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates the enhanced partition statistics in generic block layer besides the disk statistics.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 block/ll_rw_blk.c     |   40 ++++++++++++++++++++++++++++++++++++----
 fs/partitions/check.c |    7 +++++++
 include/linux/genhd.h |    1 +
 3 files changed, 44 insertions(+), 4 deletions(-)
diff -urNp -X linux-2.6/Documentation/dontdiff linux-2.6.orig/block/ll_rw_blk.c linux-2.6/block/ll_rw_blk.c
--- linux-2.6.orig/block/ll_rw_blk.c	2007-12-04 17:37:31.000000000 +0100
+++ linux-2.6/block/ll_rw_blk.c	2007-12-05 12:18:49.000000000 +0100
@@ -2734,10 +2734,15 @@ static void drive_stat_acct(struct reque
 		return;
 
 	if (!new_io) {
-		__disk_stat_inc(rq->rq_disk, merges[rw]);
+		__all_stat_inc(rq->rq_disk, merges[rw], rq->sector);
 	} else {
+		struct hd_struct *part = get_part(rq->rq_disk, rq->sector);
 		disk_round_stats(rq->rq_disk);
 		rq->rq_disk->in_flight++;
+		if (part) {
+			part_round_stats(part);
+			part->in_flight++;
+		}
 	}
 }
 
@@ -2789,6 +2794,21 @@ void disk_round_stats(struct gendisk *di
 
 EXPORT_SYMBOL_GPL(disk_round_stats);
 
+void part_round_stats(struct hd_struct *part)
+{
+	unsigned long now = jiffies;
+
+	if (now == part->stamp)
+		return;
+
+	if (part->in_flight) {
+		__part_stat_add(part, time_in_queue,
+				part->in_flight * (now - part->stamp));
+		__part_stat_add(part, io_ticks, (now - part->stamp));
+	}
+	part->stamp = now;
+}
+
 /*
  * queue lock must be held
  */
@@ -2903,8 +2923,14 @@ static int attempt_merge(struct request_
 	elv_merge_requests(q, req, next);
 
 	if (req->rq_disk) {
+		struct hd_struct *part
+			= get_part(req->rq_disk, req->sector);
 		disk_round_stats(req->rq_disk);
 		req->rq_disk->in_flight--;
+		if (part) {
+			part_round_stats(part);
+			part->in_flight--;
+		}
 	}
 
 	req->ioprio = ioprio_best(req->ioprio, next->ioprio);
@@ -3447,7 +3473,8 @@ static int __end_that_request_first(stru
 	if (blk_fs_request(req) && req->rq_disk) {
 		const int rw = rq_data_dir(req);
 
-		disk_stat_add(req->rq_disk, sectors[rw], nr_bytes >> 9);
+		all_stat_add(req->rq_disk, sectors[rw],
+			     nr_bytes >> 9, req->sector);
 	}
 
 	total_bytes = bio_nbytes = 0;
@@ -3676,11 +3703,16 @@ void end_that_request_last(struct reques
 	if (disk && blk_fs_request(req) && req != &req->q->bar_rq) {
 		unsigned long duration = jiffies - req->start_time;
 		const int rw = rq_data_dir(req);
+		struct hd_struct *part = get_part(disk, req->sector);
 
-		__disk_stat_inc(disk, ios[rw]);
-		__disk_stat_add(disk, ticks[rw], duration);
+		__all_stat_inc(disk, ios[rw], req->sector);
+		__all_stat_add(disk, ticks[rw], duration, req->sector);
 		disk_round_stats(disk);
 		disk->in_flight--;
+		if (part) {
+			part_round_stats(part);
+			part->in_flight--;
+		}
 	}
 	if (req->end_io)
 		req->end_io(req, error);
diff -urNp -X linux-2.6/Documentation/dontdiff linux-2.6.orig/fs/partitions/check.c linux-2.6/fs/partitions/check.c
--- linux-2.6.orig/fs/partitions/check.c	2007-12-04 17:36:20.000000000 +0100
+++ linux-2.6/fs/partitions/check.c	2007-12-05 12:18:49.000000000 +0100
@@ -18,6 +18,7 @@
 #include <linux/fs.h>
 #include <linux/kmod.h>
 #include <linux/ctype.h>
+#include <linux/genhd.h>
 
 #include "check.h"
 
@@ -321,6 +322,7 @@ extern struct kset block_subsys;
 static void part_release(struct kobject *kobj)
 {
 	struct hd_struct * p = container_of(kobj,struct hd_struct,kobj);
+	free_part_stats(p);
 	kfree(p);
 }
 
@@ -361,6 +363,7 @@ void delete_partition(struct gendisk *di
 	p->nr_sects = 0;
 	p->ios[0] = p->ios[1] = 0;
 	p->sectors[0] = p->sectors[1] = 0;
+	part_stat_set_all(p, 0);
 	sysfs_remove_link(&p->kobj, "subsystem");
 	kobject_unregister(p->holder_dir);
 	kobject_uevent(&p->kobj, KOBJ_REMOVE);
@@ -376,6 +379,10 @@ void add_partition(struct gendisk *disk,
 	if (!p)
 		return;
 	
+	if (!init_part_stats(p)) {
+		kfree(p);
+		return;
+	}
 	p->start_sect = start;
 	p->nr_sects = len;
 	p->partno = part;
diff -urNp -X linux-2.6/Documentation/dontdiff linux-2.6.orig/include/linux/genhd.h linux-2.6/include/linux/genhd.h
--- linux-2.6.orig/include/linux/genhd.h	2007-12-05 12:18:33.000000000 +0100
+++ linux-2.6/include/linux/genhd.h	2007-12-05 12:18:49.000000000 +0100
@@ -359,6 +359,7 @@ static inline void free_part_stats(struc
 
 /* drivers/block/ll_rw_blk.c */
 extern void disk_round_stats(struct gendisk *disk);
+extern void part_round_stats(struct hd_struct *part);
 
 /* drivers/block/genhd.c */
 extern int get_blkdev_list(char *, int);

