Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370Ab0AZPO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab0AZPO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 10:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104Ab0AZPOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 10:14:55 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:9105 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab0AZPOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 10:14:55 -0500
Subject: Added in stricter no merge semantics for block I/O
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: jens.axboe@oracle.com, whalajam@yahoo.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jan 2010 10:14:44 -0500
Message-ID: <1264518884.3278.15.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added in stricter no merge semantics for block I/O

Updated 'nomerges' tunable to accept a value of '2' - indicating that _no_
merges at all are to be attempted (not even the simple one-hit cache).

The following table illustrates the additional benefit - 5 minute runs of
a random I/O load were applied to a dozen devices on a 16-way x86_64 system.

nomerges        Throughput      %System         Improvement (tput / %sys)
--------        ------------    -----------     -------------------------
0               12.45 MB/sec    0.669365609
1               12.50 MB/sec    0.641519199     0.40% / 2.71%
2               12.52 MB/sec    0.639849750     0.56% / 2.96%

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
Cc: jens.axboe@oracle.com
---
 Documentation/ABI/testing/sysfs-block |   14 ++++++++++++++
 Documentation/block/queue-sysfs.txt   |   10 +++++-----
 block/blk-sysfs.c                     |   11 +++++++----
 block/elevator.c                      |   11 ++++++++++-
 include/linux/blkdev.h                |    3 +++
 5 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index d2f9033..954624f 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -128,3 +128,17 @@ Description:
 		preferred request size for workloads where sustained
 		throughput is desired.  If no optimal I/O size is
 		reported this file contains 0.
+
+What:		/sys/block/<disk>/queue/nomerges
+Date:		January 2010
+Contact:	
+Description:
+		Standard I/O elevator operations include attempts to
+		merge contiguous I/Os. For known random I/O loads these
+		attempts will always fail and result in extra cycles
+		being spent in the kernel. This allows one to turn off
+		this behavior on one of two ways: When set to 1, complex
+		merge checks are disabled, but the simple one-shot merges
+		with the previous I/O request are enabled. When set to 2,
+		all merge tries are disabled. The default value is 0 -
+		which enables all types of merge tries.
diff --git a/Documentation/block/queue-sysfs.txt b/Documentation/block/queue-sysfs.txt
index e164403..f652740 100644
--- a/Documentation/block/queue-sysfs.txt
+++ b/Documentation/block/queue-sysfs.txt
@@ -25,11 +25,11 @@ size allowed by the hardware.
 
 nomerges (RW)
 -------------
-This enables the user to disable the lookup logic involved with IO merging
-requests in the block layer. Merging may still occur through a direct
-1-hit cache, since that comes for (almost) free. The IO scheduler will not
-waste cycles doing tree/hash lookups for merges if nomerges is 1. Defaults
-to 0, enabling all merges.
+This enables the user to disable the lookup logic involved with IO
+merging requests in the block layer. By default (0) all merges are
+enabled. When set to 1 only simple one-hit merges will be tried. When
+set to 2 no merge algorithms will be tried (including one-hit or more
+complex tree/hash lookups).
 
 nr_requests (RW)
 ----------------
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 8606c95..e854424 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -189,7 +189,8 @@ static ssize_t queue_nonrot_store(struct request_queue *q, const char *page,
 
 static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
 {
-	return queue_var_show(blk_queue_nomerges(q), page);
+	return queue_var_show((blk_queue_nomerges(q) << 1) |
+			       blk_queue_noxmerges(q), page);
 }
 
 static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
@@ -199,10 +200,12 @@ static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
 	ssize_t ret = queue_var_store(&nm, page, count);
 
 	spin_lock_irq(q->queue_lock);
-	if (nm)
+	queue_flag_clear(QUEUE_FLAG_NOMERGES, q);
+	queue_flag_clear(QUEUE_FLAG_NOXMERGES, q);
+	if (nm == 2)
 		queue_flag_set(QUEUE_FLAG_NOMERGES, q);
-	else
-		queue_flag_clear(QUEUE_FLAG_NOMERGES, q);
+	else if (nm)
+		queue_flag_set(QUEUE_FLAG_NOXMERGES, q);
 	spin_unlock_irq(q->queue_lock);
 
 	return ret;
diff --git a/block/elevator.c b/block/elevator.c
index 9ad5ccc..ee3a883 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -474,6 +474,15 @@ int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
 	int ret;
 
 	/*
+	 * Levels of merges:
+	 * 	nomerges:  No merges at all attempted
+	 * 	noxmerges: Only simple one-hit cache try
+	 * 	merges:	   All merge tries attempted
+	 */
+	if (blk_queue_nomerges(q))
+		return ELEVATOR_NO_MERGE;
+
+	/*
 	 * First try one-hit cache.
 	 */
 	if (q->last_merge) {
@@ -484,7 +493,7 @@ int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
 		}
 	}
 
-	if (blk_queue_nomerges(q))
+	if (blk_queue_noxmerges(q))
 		return ELEVATOR_NO_MERGE;
 
 	/*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ffb13ad..f71f5c5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -463,6 +463,7 @@ struct request_queue
 #define QUEUE_FLAG_IO_STAT     15	/* do IO stats */
 #define QUEUE_FLAG_CQ	       16	/* hardware does queuing */
 #define QUEUE_FLAG_DISCARD     17	/* supports DISCARD */
+#define QUEUE_FLAG_NOXMERGES   18	/* No extended merges */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_CLUSTER) |		\
@@ -589,6 +590,8 @@ enum {
 #define blk_queue_queuing(q)	test_bit(QUEUE_FLAG_CQ, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
+#define blk_queue_noxmerges(q)	\
+	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)
 #define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, &(q)->queue_flags)
 #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
 #define blk_queue_flushing(q)	((q)->ordseq)
-- 
1.6.5



