Return-Path: <linux-kernel-owner+w=401wt.eu-S1752170AbZHXKb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbZHXKb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 06:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbZHXKb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 06:31:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:45865 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbZHXKb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 06:31:26 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] Seperate read and write statistics of in_flight requests
Date: Mon, 24 Aug 2009 16:03:15 +0530
User-Agent: KMail/1.12.0 (Linux/2.6.27.23-0.1-default; KDE/4.3.0; x86_64; ; )
Cc: Mark Landis <mark.landis@teradata.com>, Alasdair G Kergon <agk@redhat.com>,
       dm-devel@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200908241603.15158.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there is a single in_flight counter measuring the number of
requests in the request_queue. But some monitoring tools would like to know
how many read requests and write requests are in progress. Split the current
in_flight counter into two seperate counters for read and write.

This patch is based on a patch from Mark Landis <mark.landis@teradata.com>

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/Documentation/iostats.txt b/Documentation/iostats.txt
index 59a69ec..e4dff73 100644
--- a/Documentation/iostats.txt
+++ b/Documentation/iostats.txt
@@ -26,11 +26,11 @@ Here are examples of these different formats:
 
 
 2.6 sysfs:
-   446216 784926 9550688 4382310 424847 312726 5922052 19310380 0 3376340 23705160
+   446216 784926 9550688 4382310 424847 312726 5922052 19310380 0 0 3376340 23705160
    35486    38030    38030    38030
 
 2.6 diskstats:
-   3    0   hda 446216 784926 9550688 4382310 424847 312726 5922052 19310380 0 3376340 23705160
+   3    0   hda 446216 784926 9550688 4382310 424847 312726 5922052 19310380 0 0 3376340 23705160
    3    1   hda1 35486 38030 38030 38030
 
 On 2.4 you might execute "grep 'hda ' /proc/partitions". On 2.6, you have
@@ -77,12 +77,15 @@ Field  7 -- # of sectors written
 Field  8 -- # of milliseconds spent writing
     This is the total number of milliseconds spent by all writes (as
     measured from __make_request() to end_that_request_last()).
-Field  9 -- # of I/Os currently in progress
-    The only field that should go to zero. Incremented as requests are
-    given to appropriate struct request_queue and decremented as they finish.
-Field 10 -- # of milliseconds spent doing I/Os
+Field  9 -- # of read I/Os currently in progress
+    This field should go to zero. Incremented as read requests are given
+    to appropriate struct request_queue and decremented as they finish.
+Field 10 -- # of write I/Os currently in progress
+    This field should go to zero. Incremented as write requests are given
+    to appropriate struct request_queue and decremented as they finish.
+Field 11 -- # of milliseconds spent doing I/Os
     This field is increases so long as field 9 is nonzero.
-Field 11 -- weighted # of milliseconds spent doing I/Os
+Field 12 -- weighted # of milliseconds spent doing I/Os
     This field is incremented at each I/O start, I/O completion, I/O
     merge, or read of these stats by the number of I/Os in progress
     (field 9) times the number of milliseconds spent doing I/O since the
diff --git a/block/blk-core.c b/block/blk-core.c
index e3299a7..e0ce820 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -69,7 +69,7 @@ static void drive_stat_acct(struct request *rq, int new_io)
 		part_stat_inc(cpu, part, merges[rw]);
 	else {
 		part_round_stats(cpu, part);
-		part_inc_in_flight(part);
+		part_inc_in_flight(part, rw);
 	}
 
 	part_stat_unlock();
@@ -1030,7 +1030,7 @@ static void part_round_stats_single(int cpu, struct hd_struct *part,
 
 	if (part->in_flight) {
 		__part_stat_add(cpu, part, time_in_queue,
-				part->in_flight * (now - part->stamp));
+				part_in_flight(part) * (now - part->stamp));
 		__part_stat_add(cpu, part, io_ticks, (now - part->stamp));
 	}
 	part->stamp = now;
@@ -1686,7 +1686,7 @@ static void blk_account_io_done(struct request *req)
 		part_stat_inc(cpu, part, ios[rw]);
 		part_stat_add(cpu, part, ticks[rw], duration);
 		part_round_stats(cpu, part);
-		part_dec_in_flight(part);
+		part_dec_in_flight(part, rw);
 
 		part_stat_unlock();
 	}
diff --git a/block/blk-merge.c b/block/blk-merge.c
index e199967..97ea454 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -321,7 +321,7 @@ static void blk_account_io_merge(struct request *req)
 		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
 
 		part_round_stats(cpu, part);
-		part_dec_in_flight(part);
+		part_dec_in_flight(part, rq_data_dir(req));
 
 		part_stat_unlock();
 	}
diff --git a/block/genhd.c b/block/genhd.c
index f4c64c2..ce4fbd2 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1042,7 +1042,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 		part_round_stats(cpu, hd);
 		part_stat_unlock();
 		seq_printf(seqf, "%4d %7d %s %lu %lu %llu "
-			   "%u %lu %lu %llu %u %u %u %u\n",
+			   "%u %lu %lu %llu %u %u %u %u %u\n",
 			   MAJOR(part_devt(hd)), MINOR(part_devt(hd)),
 			   disk_name(gp, hd->partno, buf),
 			   part_stat_read(hd, ios[0]),
@@ -1053,7 +1053,8 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 			   part_stat_read(hd, merges[1]),
 			   (unsigned long long)part_stat_read(hd, sectors[1]),
 			   jiffies_to_msecs(part_stat_read(hd, ticks[1])),
-			   hd->in_flight,
+			   hd->in_flight[0],
+			   hd->in_flight[1],
 			   jiffies_to_msecs(part_stat_read(hd, io_ticks)),
 			   jiffies_to_msecs(part_stat_read(hd, time_in_queue))
 			);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8a311ea..ba2fe6b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -130,7 +130,7 @@ struct mapped_device {
 	/*
 	 * A list of ios that arrived while we were suspended.
 	 */
-	atomic_t pending;
+	atomic_t pending[2];
 	wait_queue_head_t wait;
 	struct work_struct work;
 	struct bio_list deferred;
@@ -453,13 +453,14 @@ static void start_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
 	int cpu;
+	int rw = bio_data_dir(io->bio);
 
 	io->start_time = jiffies;
 
 	cpu = part_stat_lock();
 	part_round_stats(cpu, &dm_disk(md)->part0);
 	part_stat_unlock();
-	dm_disk(md)->part0.in_flight = atomic_inc_return(&md->pending);
+	dm_disk(md)->part0.in_flight[rw] = atomic_inc_return(&md->pending[rw]);
 }
 
 static void end_io_acct(struct dm_io *io)
@@ -479,8 +480,9 @@ static void end_io_acct(struct dm_io *io)
 	 * After this is decremented the bio must not be touched if it is
 	 * a barrier.
 	 */
-	dm_disk(md)->part0.in_flight = pending =
-		atomic_dec_return(&md->pending);
+	dm_disk(md)->part0.in_flight[rw] = pending =
+		atomic_dec_return(&md->pending[rw]);
+	pending += atomic_read(&md->pending[rw^0x1]);
 
 	/* nudge anyone waiting on suspend queue */
 	if (!pending)
@@ -1780,7 +1782,8 @@ static struct mapped_device *alloc_dev(int minor)
 	if (!md->disk)
 		goto bad_disk;
 
-	atomic_set(&md->pending, 0);
+	atomic_set(&md->pending[0], 0);
+	atomic_set(&md->pending[1], 0);
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
 	init_waitqueue_head(&md->eventq);
@@ -2083,7 +2086,8 @@ static int dm_wait_for_completion(struct mapped_device *md, int interruptible)
 				break;
 			}
 			spin_unlock_irqrestore(q->queue_lock, flags);
-		} else if (!atomic_read(&md->pending))
+		} else if (!atomic_read(&md->pending[0]) &&
+					!atomic_read(&md->pending[1]))
 			break;
 
 		if (interruptible == TASK_INTERRUPTIBLE &&
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index ea4e6cb..6adc764 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -238,7 +238,7 @@ ssize_t part_stat_show(struct device *dev,
 	return sprintf(buf,
 		"%8lu %8lu %8llu %8u "
 		"%8lu %8lu %8llu %8u "
-		"%8u %8u %8u"
+		"%8u %8u %8u %8u"
 		"\n",
 		part_stat_read(p, ios[READ]),
 		part_stat_read(p, merges[READ]),
@@ -248,7 +248,8 @@ ssize_t part_stat_show(struct device *dev,
 		part_stat_read(p, merges[WRITE]),
 		(unsigned long long)part_stat_read(p, sectors[WRITE]),
 		jiffies_to_msecs(part_stat_read(p, ticks[WRITE])),
-		p->in_flight,
+		p->in_flight[0],
+		p->in_flight[1],
 		jiffies_to_msecs(part_stat_read(p, io_ticks)),
 		jiffies_to_msecs(part_stat_read(p, time_in_queue)));
 }
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 45fc320..ebd878e 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -98,7 +98,7 @@ struct hd_struct {
 	int make_it_fail;
 #endif
 	unsigned long stamp;
-	int in_flight;
+	int in_flight[2];
 #ifdef	CONFIG_SMP
 	struct disk_stats *dkstats;
 #else
@@ -322,18 +322,23 @@ static inline void free_part_stats(struct hd_struct *part)
 #define part_stat_sub(cpu, gendiskp, field, subnd)			\
 	part_stat_add(cpu, gendiskp, field, -subnd)
 
-static inline void part_inc_in_flight(struct hd_struct *part)
+static inline void part_inc_in_flight(struct hd_struct *part, int rw)
 {
-	part->in_flight++;
+	part->in_flight[rw]++;
 	if (part->partno)
-		part_to_disk(part)->part0.in_flight++;
+		part_to_disk(part)->part0.in_flight[rw]++;
 }
 
-static inline void part_dec_in_flight(struct hd_struct *part)
+static inline void part_dec_in_flight(struct hd_struct *part, int rw)
 {
-	part->in_flight--;
+	part->in_flight[rw]--;
 	if (part->partno)
-		part_to_disk(part)->part0.in_flight--;
+		part_to_disk(part)->part0.in_flight[rw]--;
+}
+
+static inline int part_in_flight(struct hd_struct *part)
+{
+	return part->in_flight[0] + part->in_flight[1];
 }
 
 /* block/blk-core.c */
