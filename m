Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbZJFNYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbZJFNYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757299AbZJFNYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:24:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:37617 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757243AbZJFNYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:24:23 -0400
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [RESEND][PATCH linux-2.6-block#for-linus]  Seperate read and write statistics of in_flight requests v2
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       "Linux-Kernel" <linux-kernel@vger.kernel.org>
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
Date: Tue, 6 Oct 2009 18:55:48 +0530
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910061855.48502.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry, resending as the previous mail was word-wrapped]

Commit a9327cac440be4d8333bba975cbbf76045096275 added seperate read
and write statistics of in_flight requests. And exported the number
of read and write requests in progress seperately through sysfs.

But  Corrado Zoccolo <czoccolo@gmail.com> reported getting strange
output from "iostat -kx 2". Global values for service time and
utilization were garbage. For interval values, utilization was always
100%, and service time is higher than normal.

So this was reverted by commit 0f78ab9899e9d6acb09d5465def618704255963b

The problem was in part_round_stats_single(), I missed the following:
        if (now == part->stamp)
                return;

-       if (part->in_flight) {
+       if (part_in_flight(part)) {
                __part_stat_add(cpu, part, time_in_queue,
                                part_in_flight(part) * (now - part->stamp));
                __part_stat_add(cpu, part, io_ticks, (now - part->stamp));

With this chunk included, the reported regression gets fixed.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

--

diff --git a/block/blk-core.c b/block/blk-core.c
index 73ecbed..ac0fa10 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -70,7 +70,7 @@ static void drive_stat_acct(struct request *rq, int new_io)
 		part_stat_inc(cpu, part, merges[rw]);
 	else {
 		part_round_stats(cpu, part);
-		part_inc_in_flight(part);
+		part_inc_in_flight(part, rw);
 	}
 
 	part_stat_unlock();
@@ -1030,9 +1030,9 @@ static void part_round_stats_single(int cpu, struct hd_struct *part,
 	if (now == part->stamp)
 		return;
 
-	if (part->in_flight) {
+	if (part_in_flight(part)) {
 		__part_stat_add(cpu, part, time_in_queue,
-				part->in_flight * (now - part->stamp));
+				part_in_flight(part) * (now - part->stamp));
 		__part_stat_add(cpu, part, io_ticks, (now - part->stamp));
 	}
 	part->stamp = now;
@@ -1739,7 +1739,7 @@ static void blk_account_io_done(struct request *req)
 		part_stat_inc(cpu, part, ios[rw]);
 		part_stat_add(cpu, part, ticks[rw], duration);
 		part_round_stats(cpu, part);
-		part_dec_in_flight(part);
+		part_dec_in_flight(part, rw);
 
 		part_stat_unlock();
 	}
diff --git a/block/blk-merge.c b/block/blk-merge.c
index b0de857..99cb5cf 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -351,7 +351,7 @@ static void blk_account_io_merge(struct request *req)
 		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
 
 		part_round_stats(cpu, part);
-		part_dec_in_flight(part);
+		part_dec_in_flight(part, rq_data_dir(req));
 
 		part_stat_unlock();
 	}
diff --git a/block/genhd.c b/block/genhd.c
index 5a0861d..517e433 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -869,6 +869,7 @@ static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
 static DEVICE_ATTR(alignment_offset, S_IRUGO, disk_alignment_offset_show, NULL);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
+static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
@@ -888,6 +889,7 @@ static struct attribute *disk_attrs[] = {
 	&dev_attr_alignment_offset.attr,
 	&dev_attr_capability.attr,
 	&dev_attr_stat.attr,
+	&dev_attr_inflight.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif
@@ -1053,7 +1055,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 			   part_stat_read(hd, merges[1]),
 			   (unsigned long long)part_stat_read(hd, sectors[1]),
 			   jiffies_to_msecs(part_stat_read(hd, ticks[1])),
-			   hd->in_flight,
+			   part_in_flight(hd),
 			   jiffies_to_msecs(part_stat_read(hd, io_ticks)),
 			   jiffies_to_msecs(part_stat_read(hd, time_in_queue))
 			);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 23e76fe..376f1ab 100644
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
@@ -1785,7 +1787,8 @@ static struct mapped_device *alloc_dev(int minor)
 	if (!md->disk)
 		goto bad_disk;
 
-	atomic_set(&md->pending, 0);
+	atomic_set(&md->pending[0], 0);
+	atomic_set(&md->pending[1], 0);
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
 	init_waitqueue_head(&md->eventq);
@@ -2088,7 +2091,8 @@ static int dm_wait_for_completion(struct mapped_device *md, int interruptible)
 				break;
 			}
 			spin_unlock_irqrestore(q->queue_lock, flags);
-		} else if (!atomic_read(&md->pending))
+		} else if (!atomic_read(&md->pending[0]) &&
+					!atomic_read(&md->pending[1]))
 			break;
 
 		if (interruptible == TASK_INTERRUPTIBLE &&
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index f38fee0..7b685e1 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -248,11 +248,19 @@ ssize_t part_stat_show(struct device *dev,
 		part_stat_read(p, merges[WRITE]),
 		(unsigned long long)part_stat_read(p, sectors[WRITE]),
 		jiffies_to_msecs(part_stat_read(p, ticks[WRITE])),
-		p->in_flight,
+		part_in_flight(p),
 		jiffies_to_msecs(part_stat_read(p, io_ticks)),
 		jiffies_to_msecs(part_stat_read(p, time_in_queue)));
 }
 
+ssize_t part_inflight_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+
+	return sprintf(buf, "%8u %8u\n", p->in_flight[0], p->in_flight[1]);
+}
+
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 ssize_t part_fail_show(struct device *dev,
 		       struct device_attribute *attr, char *buf)
@@ -281,6 +289,7 @@ static DEVICE_ATTR(start, S_IRUGO, part_start_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
 static DEVICE_ATTR(alignment_offset, S_IRUGO, part_alignment_offset_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
+static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
@@ -292,6 +301,7 @@ static struct attribute *part_attrs[] = {
 	&dev_attr_size.attr,
 	&dev_attr_alignment_offset.attr,
 	&dev_attr_stat.attr,
+	&dev_attr_inflight.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 7beaa21..297df45 100644
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
@@ -546,6 +551,8 @@ extern ssize_t part_size_show(struct device *dev,
 			      struct device_attribute *attr, char *buf);
 extern ssize_t part_stat_show(struct device *dev,
 			      struct device_attribute *attr, char *buf);
+extern ssize_t part_inflight_show(struct device *dev,
+			      struct device_attribute *attr, char *buf);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 extern ssize_t part_fail_show(struct device *dev,
 			      struct device_attribute *attr, char *buf);
