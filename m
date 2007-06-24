Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbXFXR2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbXFXR2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 13:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbXFXR2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 13:28:34 -0400
Received: from lilly.ping.de ([83.97.42.2]:2789 "HELO lilly.ping.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751348AbXFXR2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 13:28:33 -0400
Date: Sun, 24 Jun 2007 19:27:23 +0200
From: Patrick Mau <mau@oscar.ping.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] [RFC] Adjust queue unplugging and congestion limits
Message-ID: <20070624172722.GA865@oscar.prima.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good afternoon

Following is a small patch to "ll_rw_block" I played around with.
I started using "blktrace" to analyse the performance of my dated
LVM / MD / SCSI setup. It's really a nice tool, by the way.

The changes are:

* Change the "q->unplug_thresh" to be halve of "q->nr_requets".
  This dynamically delays unplugging. It was hardcoded to 4 and
  makes a difference in performace because of higher merge counts.

* Change the unplug timeout to 10 milliseconds.
  This is of course questionable, but I don't know why 3 was
  choosen in the first place. I just played with it.

* Set the congestion on/off limits further apart.

* Cleanup the congestion checks (no "+1" anymore, more readable).

* Update "q->unplug_thresh" whenever "q->nr_requests" is updated
  through sysfs.

I did various artifical benchmarksi, mostly tar, dd and cp (also to NFS).
Comments are welcome.

Best regards,
Patrick

Signed-Off-By: Patrick Mau <mau@oscar.ping.de>

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index c99b463..aa26ff3 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -96,17 +96,8 @@ static inline int queue_congestion_off_threshold(struct request_queue *q)
 
 static void blk_queue_congestion_threshold(struct request_queue *q)
 {
-	int nr;
-
-	nr = q->nr_requests - (q->nr_requests / 8) + 1;
-	if (nr > q->nr_requests)
-		nr = q->nr_requests;
-	q->nr_congestion_on = nr;
-
-	nr = q->nr_requests - (q->nr_requests / 8) - (q->nr_requests / 16) - 1;
-	if (nr < 1)
-		nr = 1;
-	q->nr_congestion_off = nr;
+	q->nr_congestion_on  = q->nr_requests - (q->nr_requests / 32);
+	q->nr_congestion_off = q->nr_requests - (q->nr_requests / 16);
 }
 
 /**
@@ -217,8 +208,10 @@ void blk_queue_make_request(request_queue_t * q, make_request_fn * mfn)
 	blk_queue_congestion_threshold(q);
 	q->nr_batching = BLK_BATCH_REQ;
 
-	q->unplug_thresh = 4;		/* hmm */
-	q->unplug_delay = (3 * HZ) / 1000;	/* 3 milliseconds */
+	/* make these tuneable ? */
+	q->unplug_thresh = BLKDEV_MAX_RQ / 2;
+	q->unplug_delay = (10 * HZ) / 1000;
+
 	if (q->unplug_delay == 0)
 		q->unplug_delay = 1;
 
@@ -2033,7 +2026,7 @@ static void __freed_request(request_queue_t *q, int rw)
 	if (rl->count[rw] < queue_congestion_off_threshold(q))
 		blk_clear_queue_congested(q, rw);
 
-	if (rl->count[rw] + 1 <= q->nr_requests) {
+	if (rl->count[rw] < q->nr_requests) {
 		if (waitqueue_active(&rl->wait[rw]))
 			wake_up(&rl->wait[rw]);
 
@@ -2078,8 +2071,8 @@ static struct request *get_request(request_queue_t *q, int rw_flags,
 	if (may_queue == ELV_MQUEUE_NO)
 		goto rq_starved;
 
-	if (rl->count[rw]+1 >= queue_congestion_on_threshold(q)) {
-		if (rl->count[rw]+1 >= q->nr_requests) {
+	if (rl->count[rw] >= queue_congestion_on_threshold(q)) {
+		if (rl->count[rw] >= q->nr_requests) {
 			ioc = current_io_context(GFP_ATOMIC, q->node);
 			/*
 			 * The queue will fill after this allocation, so set
@@ -3877,7 +3870,7 @@ queue_var_store(unsigned long *var, const char *page, size_t count)
 
 static ssize_t queue_requests_show(struct request_queue *q, char *page)
 {
-	return queue_var_show(q->nr_requests, (page));
+	return queue_var_show(q->nr_requests, page);
 }
 
 static ssize_t
@@ -3890,6 +3883,7 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
 		nr = BLKDEV_MIN_RQ;
 
 	spin_lock_irq(q->queue_lock);
+	q->unplug_thresh = nr / 2;
 	q->nr_requests = nr;
 	blk_queue_congestion_threshold(q);
 
@@ -3905,14 +3899,14 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
 
 	if (rl->count[READ] >= q->nr_requests) {
 		blk_set_queue_full(q, READ);
-	} else if (rl->count[READ]+1 <= q->nr_requests) {
+	} else if (rl->count[READ] < q->nr_requests) {
 		blk_clear_queue_full(q, READ);
 		wake_up(&rl->wait[READ]);
 	}
 
 	if (rl->count[WRITE] >= q->nr_requests) {
 		blk_set_queue_full(q, WRITE);
-	} else if (rl->count[WRITE]+1 <= q->nr_requests) {
+	} else if (rl->count[WRITE] < q->nr_requests) {
 		blk_clear_queue_full(q, WRITE);
 		wake_up(&rl->wait[WRITE]);
 	}

