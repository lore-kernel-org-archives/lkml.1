Return-Path: <linux-kernel-owner+w=401wt.eu-S1758613AbYD2MfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbYD2MfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYD2Mez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:34:55 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:21527 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbYD2Mey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:34:54 -0400
Message-ID: <481715E7.2070103@hp.com>
Date: Tue, 29 Apr 2008 08:34:47 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] Skip I/O merges when disabled
Content-Type: multipart/mixed;
 boundary="------------060901000500000506020008"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060901000500000506020008
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------060901000500000506020008
Content-Type: text/x-diff;
 name="0001-Skip-I-O-merges-when-disabled.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-Skip-I-O-merges-when-disabled.patch"


The block I/O + elevator + I/O scheduler code spend a lot of time trying
to merge I/Os -- rightfully so under "normal" circumstances. However,
if one were to know that the incoming I/O stream was /very/ random in
nature, the cycles are wasted.

This patch adds a per-request_queue tunable that (when set) disables
merge attempts (beyond the simple one-hit cache check), thus freeing up
a non-trivial amount of CPU cycles.

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 block/blk-sysfs.c      |   27 +++++++++++++++++++++++++++
 block/elevator.c       |    3 +++
 include/linux/blkdev.h |    2 ++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index fc41d83..00151e1 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -135,6 +135,26 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
+{
+	int nm = test_bit(QUEUE_FLAG_NOMERGES, &q->queue_flags);
+	return queue_var_show(nm, page);
+}
+
+static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
+				    size_t count)
+{
+	unsigned long nm;
+	ssize_t ret = queue_var_store(&nm, page, count);
+
+	if (nm)
+	       set_bit(QUEUE_FLAG_NOMERGES, &q->queue_flags);
+	else
+	       clear_bit(QUEUE_FLAG_NOMERGES, &q->queue_flags);
+
+	return ret;
+}
+
 
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
@@ -170,6 +190,12 @@ static struct queue_sysfs_entry queue_hw_sector_size_entry = {
 	.show = queue_hw_sector_size_show,
 };
 
+static struct queue_sysfs_entry queue_nomerges_entry = {
+	.attr = {.name = "nomerges", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_nomerges_show,
+	.store = queue_nomerges_store,
+};
+
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
@@ -177,6 +203,7 @@ static struct attribute *default_attrs[] = {
 	&queue_max_sectors_entry.attr,
 	&queue_iosched_entry.attr,
 	&queue_hw_sector_size_entry.attr,
+	&queue_nomerges_entry.attr,
 	NULL,
 };
 
diff --git a/block/elevator.c b/block/elevator.c
index 88318c3..13b24d3 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -488,6 +488,9 @@ int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
 		}
 	}
 
+	if (blk_queue_nomerges(q))
+		return ELEVATOR_NO_MERGE;
+
 	/*
 	 * See if our hash lookup can find a potential backmerge.
 	 */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c5065e3..d8361ea 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -407,6 +407,7 @@ struct request_queue
 #define QUEUE_FLAG_PLUGGED	7	/* queue is plugged */
 #define QUEUE_FLAG_ELVSWITCH	8	/* don't use elevator, just do FIFO */
 #define QUEUE_FLAG_BIDI		9	/* queue supports bidi requests */
+#define QUEUE_FLAG_NOMERGES    10	/* disable merge attempts */
 
 enum {
 	/*
@@ -451,6 +452,7 @@ enum {
 #define blk_queue_plugged(q)	test_bit(QUEUE_FLAG_PLUGGED, &(q)->queue_flags)
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
+#define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_flushing(q)	((q)->ordseq)
 
 #define blk_fs_request(rq)	((rq)->cmd_type == REQ_TYPE_FS)
-- 
1.5.4.3


--------------060901000500000506020008--
