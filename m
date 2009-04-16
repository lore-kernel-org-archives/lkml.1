Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbZDPH1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbZDPH1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 03:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZDPH1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 03:27:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:51913 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZDPH1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 03:27:05 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] [RFC] make hd_struct->in_flight atomic to avoid diskstat corruption
Date: Thu, 16 Apr 2009 12:54:40 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904161254.41433.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The disk statistics exported to userspace through proc and sysfs are not
protected by locks to avoid performance overhead. Since most of the statistics
are maintained in the per_cpu struct disk_stats, the chances of them getting
corrupted is negligible. But the in_flight counter, that records the no of
requests currently in progress is not per-cpu. This increases the chance of it
getting corrupted. And corruption of this value would result in visibly
distorted statistics such as negative in_flight. This can be avoided by making
this field atomic.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/block/blk-core.c b/block/blk-core.c
index 07ab754..c295deb 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1013,12 +1013,15 @@ static inline void add_request(struct request_queue *q, struct request *req)
 static void part_round_stats_single(int cpu, struct hd_struct *part,
 				    unsigned long now)
 {
+	int in_flight;
+
 	if (now == part->stamp)
 		return;
 
-	if (part->in_flight) {
+	in_flight = atomic_read(&part->in_flight);
+	if (in_flight) {
 		__part_stat_add(cpu, part, time_in_queue,
-				part->in_flight * (now - part->stamp));
+				in_flight * (now - part->stamp));
 		__part_stat_add(cpu, part, io_ticks, (now - part->stamp));
 	}
 	part->stamp = now;
diff --git a/block/genhd.c b/block/genhd.c
index a9ec910..9436991 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1028,7 +1028,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 			   part_stat_read(hd, merges[1]),
 			   (unsigned long long)part_stat_read(hd, sectors[1]),
 			   jiffies_to_msecs(part_stat_read(hd, ticks[1])),
-			   hd->in_flight,
+			   atomic_read(&hd->in_flight),
 			   jiffies_to_msecs(part_stat_read(hd, io_ticks)),
 			   jiffies_to_msecs(part_stat_read(hd, time_in_queue))
 			);
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 99e33ef..ae1f55a 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -241,7 +241,7 @@ ssize_t part_stat_show(struct device *dev,
 		part_stat_read(p, merges[WRITE]),
 		(unsigned long long)part_stat_read(p, sectors[WRITE]),
 		jiffies_to_msecs(part_stat_read(p, ticks[WRITE])),
-		p->in_flight,
+		atomic_read(&p->in_flight),
 		jiffies_to_msecs(part_stat_read(p, io_ticks)),
 		jiffies_to_msecs(part_stat_read(p, time_in_queue)));
 }
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 634c530..5921400 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -97,7 +97,7 @@ struct hd_struct {
 	int make_it_fail;
 #endif
 	unsigned long stamp;
-	int in_flight;
+	atomic_t in_flight;
 #ifdef	CONFIG_SMP
 	struct disk_stats *dkstats;
 #else
@@ -321,16 +321,16 @@ static inline void free_part_stats(struct hd_struct *part)
 
 static inline void part_inc_in_flight(struct hd_struct *part)
 {
-	part->in_flight++;
+	atomic_inc(&part->in_flight);
 	if (part->partno)
-		part_to_disk(part)->part0.in_flight++;
+		atomic_inc(&part_to_disk(part)->part0.in_flight);
 }
 
 static inline void part_dec_in_flight(struct hd_struct *part)
 {
-	part->in_flight--;
+	atomic_dec(&part->in_flight);
 	if (part->partno)
-		part_to_disk(part)->part0.in_flight--;
+		atomic_dec(&part_to_disk(part)->part0.in_flight);
 }
 
 /* block/blk-core.c */

