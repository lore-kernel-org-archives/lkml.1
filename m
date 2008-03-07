Return-Path: <linux-kernel-owner+w=401wt.eu-S1761860AbYCGS2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761860AbYCGS2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:28:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762674AbYCGS00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:26:26 -0500
Received: from nebensachen.de ([195.34.83.29]:59664 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762635AbYCGS0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:26:23 -0500
X-Hashcash: 1:20:080307:alan@lxorguk.ukuu.org.uk::HsZRaB5waqmTC+KL:00000000000000000000000000000000000007qjg
X-Hashcash: 1:20:080307:linux-ide@vger.kernel.org::v7/QutvikcNEKE0/:0000000000000000000000000000000000000KLr
X-Hashcash: 1:20:080307:linux-kernel@vger.kernel.org::H74opcqh4McVp0wn:00000000000000000000000000000000027+M
X-Hashcash: 1:20:080307:jens.axboe@oracle.com::9mr8ipQG/v/1h2TC:00000000000000000000000000000000000000002xwr
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 4/4] disk-protect: Add a generic block layer queue freezing
	facility
Message-ID: <20080307181750.9981.1330.stgit@denkblock.local>
References: <87skzgd1zk.fsf@denkblock.local> <20080226123946.75dbe3d2@core>
	<87mypl8p49.fsf@denkblock.local> <20080228111349.6831925c@core>
	<87bq5qfm2v.fsf@denkblock.local>
User-Agent: StGIT/0.12.1
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Mail-Copies-To: nobody
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe
	<jens.axboe@oracle.com>
Date: Fri, 07 Mar 2008 19:26:41 +0100
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a generic way to freeze the request queue of a block
device temporarily. This functionality is exposed to user space via sysfs.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 block/ll_rw_blk.c      |  140 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    7 ++
 2 files changed, 147 insertions(+), 0 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 8b91994..2626007 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -39,6 +39,8 @@
 
 static void blk_unplug_work(struct work_struct *work);
 static void blk_unplug_timeout(unsigned long data);
+static void blk_unfreeze_work(struct work_struct *work);
+static void blk_unfreeze_timeout(unsigned long data);
 static void drive_stat_acct(struct request *rq, int new_io);
 static void init_request_from_bio(struct request *req, struct bio *bio);
 static int __make_request(struct request_queue *q, struct bio *bio);
@@ -231,6 +233,13 @@ void blk_queue_make_request(struct request_queue * q, make_request_fn * mfn)
 	q->unplug_timer.function = blk_unplug_timeout;
 	q->unplug_timer.data = (unsigned long)q;
 
+	q->max_unfreeze = 30;
+
+	INIT_WORK(&q->unfreeze_work, blk_unfreeze_work);
+
+	q->unfreeze_timer.function = blk_unfreeze_timeout;
+	q->unfreeze_timer.data = (unsigned long)q;
+
 	/*
 	 * by default assume old behaviour and bounce for any highmem page
 	 */
@@ -1861,6 +1870,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	}
 
 	init_timer(&q->unplug_timer);
+	init_timer(&q->unfreeze_timer);
 
 	kobject_set_name(&q->kobj, "%s", "queue");
 	q->kobj.ktype = &queue_ktype;
@@ -1975,6 +1985,93 @@ int blk_get_queue(struct request_queue *q)
 
 EXPORT_SYMBOL(blk_get_queue);
 
+static void issue_queue_freeze_cmd(struct request_queue *q, int thaw)
+{
+	struct request *rq;
+	unsigned long flags;
+
+	rq = blk_get_request(q, 0, GFP_NOIO);
+	if (!rq)
+		return;
+	rq->cmd_type = REQ_TYPE_LINUX_BLOCK;
+	rq->cmd_len = 1;
+	rq->cmd_flags |= REQ_NOMERGE | REQ_SOFTBARRIER;
+	if (thaw)
+		rq->cmd[0] = REQ_LB_OP_THAW;
+	else
+		rq->cmd[0] = REQ_LB_OP_FREEZE;
+	rq->rq_disk = NULL;
+	rq->sense = NULL;
+	rq->sense_len = 0;
+	rq->retries = 5;
+	rq->timeout = HZ;
+	spin_lock_irqsave(q->queue_lock, flags);
+	__elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 0);
+	if (thaw)
+		blk_start_queue(q);
+	else {
+		blk_stop_queue(q);
+		q->request_fn(q);
+	}
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+static void blk_unfreeze_work(struct work_struct *work)
+{
+	struct request_queue *q = container_of(work, struct request_queue,
+					       unfreeze_work);
+	int pending;
+
+	pending = timer_pending(&q->unfreeze_timer);
+	if (!pending)
+		issue_queue_freeze_cmd(q, 1);
+}
+
+static void blk_unfreeze_timeout(unsigned long data)
+{
+	struct request_queue *q = (struct request_queue *) data;
+
+	kblockd_schedule_work(&q->unfreeze_work);
+}
+
+/**
+ * blk_freeze_queue - (un)freeze queue and manage the queue unfreeze timer
+ * @q:		queue to be (un)frozen
+ * @second:	number of seconds to freeze the queue for
+ *
+ * Description: This function (re)sets the unfreeze timer of a request
+ *    queue. When a timer is started / stopped (not just modified),
+ *    then low level drivers are notified about this event.
+ */
+static int blk_freeze_queue(struct request_queue *q, unsigned int seconds)
+{
+	int thaw, rc;
+
+	if (seconds > 0) {
+		if (seconds > q->max_unfreeze)
+			seconds = q->max_unfreeze;
+		/* set / reset the thaw timer */
+		rc = !mod_timer(&q->unfreeze_timer,
+				msecs_to_jiffies(seconds*1000) + jiffies);
+		thaw = 0;
+		if (rc && blk_queue_stopped(q)) {
+			/* Someone else has stopped the queue already.
+			 * Best leave it alone.
+			 */
+			del_timer(&q->unfreeze_timer);
+			rc = 0;
+		}
+	} else {
+		rc = del_timer(&q->unfreeze_timer);
+		thaw = 1;
+	}
+
+	if (rc)
+		issue_queue_freeze_cmd(q, thaw);
+
+	return rc;
+}
+
 static inline void blk_free_request(struct request_queue *q, struct request *rq)
 {
 	if (rq->cmd_flags & REQ_ELVPRIV)
@@ -4080,6 +4177,42 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+/*
+ * When reading the 'protect' attribute, we return seconds remaining
+ * before the unfreeze timeout expires.
+ */
+static ssize_t queue_protect_show(struct request_queue *q, char *page)
+{
+	unsigned int seconds = 0;
+
+	if (blk_queue_stopped(q) && timer_pending(&q->unfreeze_timer))
+		/*
+		 * Adding 1 in order to guarantee nonzero value until timer
+		 * has actually expired.
+		 */
+		seconds = jiffies_to_msecs(q->unfreeze_timer.expires
+					   - jiffies) / 1000 + 1;
+	return queue_var_show(seconds, (page));
+}
+
+/*
+ * When writing to the 'protect' attribute, input is the number of
+ * seconds to freeze the queue for. We call a helper function to park
+ * the heads and freeze/block the queue, then we make a block layer
+ * call to setup the thaw timeout. If input is 0, then the queue will
+ * be thawed by that helper function immediately.
+ */
+static ssize_t queue_protect_store(struct request_queue *q,
+				   const char *page, size_t count)
+{
+	unsigned long seconds;
+
+	queue_var_store(&seconds, page, count);
+	blk_freeze_queue(q, seconds);
+
+	return count;
+}
+
 
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
@@ -4110,12 +4243,19 @@ static struct queue_sysfs_entry queue_iosched_entry = {
 	.store = elv_iosched_store,
 };
 
+static struct queue_sysfs_entry queue_protect_entry = {
+	.attr = { .name = "protect", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_protect_show,
+	.store = queue_protect_store,
+};
+
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
 	&queue_max_sectors_entry.attr,
 	&queue_iosched_entry.attr,
+	&queue_protect_entry.attr,
 	NULL,
 };
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1854a69..082e2d3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -385,6 +385,13 @@ struct request_queue
 	unsigned long		unplug_delay;	/* After this many jiffies */
 	struct work_struct	unplug_work;
 
+	/*
+	 * Auto-unfreeze state
+	 */
+	struct timer_list	unfreeze_timer;
+	int			max_unfreeze;	/* At most this many seconds */
+	struct work_struct	unfreeze_work;
+
 	struct backing_dev_info	backing_dev_info;
 
 	/*


