Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbZDQGRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbZDQGRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbZDQGRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:17:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:59228 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbZDQGRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:17:11 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] Fix discard requests accounting in the diskstats
Date: Fri, 17 Apr 2009 11:44:49 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: David Woodhouse <David.Woodhouse@intel.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904171144.49448.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When 2 discard requests are merged, the stats gets updated, but we do not
update statistics normally when a discard request is issued or completed. For
example the in_flight counter would be decremented when 2 discard requests are
merged, but it was not at all incremented when they were issued, and in_flight
counter will not be decremented, when they are completed as well.

This patch fixes this by adding discard requests to the statistics.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/block/blk-core.c b/block/blk-core.c
index 07ab754..ee960a7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -68,7 +68,7 @@ static void drive_stat_acct(struct request *rq, int new_io)
 	int rw = rq_data_dir(rq);
 	int cpu;
 
-	if (!blk_fs_request(rq) || !blk_do_io_stat(rq))
+	if (!rq_accountable(rq) || !blk_do_io_stat(rq))
 		return;
 
 	cpu = part_stat_lock();
@@ -1698,7 +1698,7 @@ static void blk_account_io_done(struct request *req)
 	 * IO on queueing nor completion.  Accounting the containing
 	 * request is enough.
 	 */
-	if (blk_fs_request(req) && req != &req->q->bar_rq) {
+	if (rq_accountable(req) && req != &req->q->bar_rq) {
 		unsigned long duration = jiffies - req->start_time;
 		const int rw = rq_data_dir(req);
 		struct hd_struct *part;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ba54c83..9483c02 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -667,7 +667,9 @@ static inline void blk_clear_queue_full(struct request_queue *q, int sync)
 	(REQ_NOMERGE | REQ_STARTED | REQ_HARDBARRIER | REQ_SOFTBARRIER)
 #define rq_mergeable(rq)	\
 	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
-	 (blk_discard_rq(rq) || blk_fs_request((rq))))
+	 (blk_discard_rq(rq) || blk_fs_request(rq)))
+#define rq_accountable(rq)	\
+	(blk_discard_rq(rq) || blk_fs_request(rq))
 
 /*
  * q->prep_rq_fn return values

