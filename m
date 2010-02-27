Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030645Ab0B0SpO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:45:14 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:62344 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030615Ab0B0SpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:45:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=as6qURnAYW5scXfCgG+My1UfCvsk4y2X36yNEbjlcZ1libdhuHiBapKt2hhEhjPLr0
         lPg4iZqbZ6q2uOn0KDCyFg3UQ0ROxeK4dzhW2DjIdEw7Ov5llT8v26g57B3XSD3UXj7S
         HYQjRXfsvMKfZEnipqXNj0EQHJfwO5l/VJyc8=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: [PATCH 1/2] cfq-iosched: rework seeky detection
Date: Sat, 27 Feb 2010 19:45:39 +0100
Message-Id: <1267296340-3820-2-git-send-email-czoccolo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1267296340-3820-1-git-send-email-czoccolo@gmail.com>
References: <1267296340-3820-1-git-send-email-czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current seeky detection is based on average seek lenght.
This is suboptimal, since the average will not distinguish between:
* a process doing medium sized seeks
* a process doing some sequential requests interleaved with larger seeks
and even a medium seek can take lot of time, if the requested sector
happens to be behind the disk head in the rotation (50% probability).

Therefore, we change the seeky queue detection to work as follows:
* each request can be classified as sequential if it is very close to
  the current head position, i.e. it is likely in the disk cache (disks
  usually read more data than requested, and put it in cache for
  subsequent reads). Otherwise, the request is classified as seeky.
* an history window of the last 32 requests is kept, storing the
  classification result.
* A queue is marked as seeky if more than 1/8 of the last 32 requests
  were seeky.

This patch fixes a regression reported by Yanmin, on mmap 64k random
reads.

Reported-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   54 +++++++++++++-------------------------------------
 1 files changed, 14 insertions(+), 40 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index eed649c..806d30b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -46,8 +46,8 @@ static const int cfq_hist_divisor = 4;
 #define CFQ_HW_QUEUE_MIN	(5)
 #define CFQ_SERVICE_SHIFT       12
 
-#define CFQQ_SEEK_THR		8 * 1024
-#define CFQQ_SEEKY(cfqq)	((cfqq)->seek_mean > CFQQ_SEEK_THR)
+#define CFQQ_SEEK_THR		(sector_t)(8 * 100)
+#define CFQQ_SEEKY(cfqq)	(hweight32(cfqq->seek_history) > 32/8)
 
 #define RQ_CIC(rq)		\
 	((struct cfq_io_context *) (rq)->elevator_private)
@@ -132,9 +132,7 @@ struct cfq_queue {
 
 	pid_t pid;
 
-	unsigned int seek_samples;
-	u64 seek_total;
-	sector_t seek_mean;
+	u32 seek_history;
 	sector_t last_request_pos;
 
 	struct cfq_rb_root *service_tree;
@@ -1662,16 +1660,7 @@ static inline sector_t cfq_dist_from_last(struct cfq_data *cfqd,
 static inline int cfq_rq_close(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			       struct request *rq, bool for_preempt)
 {
-	sector_t sdist = cfqq->seek_mean;
-
-	if (!sample_valid(cfqq->seek_samples))
-		sdist = CFQQ_SEEK_THR;
-
-	/* if seek_mean is big, using it as close criteria is meaningless */
-	if (sdist > CFQQ_SEEK_THR && !for_preempt)
-		sdist = CFQQ_SEEK_THR;
-
-	return cfq_dist_from_last(cfqd, rq) <= sdist;
+	return cfq_dist_from_last(cfqd, rq) <= CFQQ_SEEK_THR;
 }
 
 static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
@@ -2968,30 +2957,16 @@ static void
 cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		       struct request *rq)
 {
-	sector_t sdist;
-	u64 total;
-
-	if (!cfqq->last_request_pos)
-		sdist = 0;
-	else if (cfqq->last_request_pos < blk_rq_pos(rq))
-		sdist = blk_rq_pos(rq) - cfqq->last_request_pos;
-	else
-		sdist = cfqq->last_request_pos - blk_rq_pos(rq);
-
-	/*
-	 * Don't allow the seek distance to get too large from the
-	 * odd fragment, pagein, etc
-	 */
-	if (cfqq->seek_samples <= 60) /* second&third seek */
-		sdist = min(sdist, (cfqq->seek_mean * 4) + 2*1024*1024);
-	else
-		sdist = min(sdist, (cfqq->seek_mean * 4) + 2*1024*64);
+	sector_t sdist = 0;
+	if (cfqq->last_request_pos) {
+		if (cfqq->last_request_pos < blk_rq_pos(rq))
+			sdist = blk_rq_pos(rq) - cfqq->last_request_pos;
+		else
+			sdist = cfqq->last_request_pos - blk_rq_pos(rq);
+	}
 
-	cfqq->seek_samples = (7*cfqq->seek_samples + 256) / 8;
-	cfqq->seek_total = (7*cfqq->seek_total + (u64)256*sdist) / 8;
-	total = cfqq->seek_total + (cfqq->seek_samples/2);
-	do_div(total, cfqq->seek_samples);
-	cfqq->seek_mean = (sector_t)total;
+	cfqq->seek_history <<= 1;
+	cfqq->seek_history |= (sdist > CFQQ_SEEK_THR);
 }
 
 /*
@@ -3016,8 +2991,7 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfq_mark_cfqq_deep(cfqq);
 
 	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-	    (!cfq_cfqq_deep(cfqq) && sample_valid(cfqq->seek_samples)
-	     && CFQQ_SEEKY(cfqq)))
+	    (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime_samples)) {
 		if (cic->ttime_mean > cfqd->cfq_slice_idle)
-- 
1.6.4.4

