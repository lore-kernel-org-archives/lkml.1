Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbZLXAzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbZLXAzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 19:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbZLXAzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 19:55:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:45726 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZLXAzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 19:55:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,445,1257148800"; 
   d="scan'208";a="525909281"
Date: Thu, 24 Dec 2009 08:55:06 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, jmoyer@redhat.com, czoccolo@gmail.com,
       yanmin.zhang@intel.com
Subject: cfq-iosched: tiobench regression
Message-ID: <20091224005506.GA7879@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We see about 30% regression in tiobench 32 threads 80M file sequential read.
The regression is caused by below commits.

5db5d64277bf390056b1a87d0bb288c8b8553f96
The commit makes the slice too small. In the test, the slice is limitted
to 2 * idle_slice(300ms/32 < 2*idle_slice). This dramatically impacts io
thoughput. The low_latency knob used to be only impact random io, now it
impacts sequential io too. Any idea to fix it?

df5fe3e8e13883f58dc97489076bbcc150789a21
b3b6d0408c953524f979468562e7e210d8634150
The coop merge is too aggressive. For example, if two tasks are reading two
files where the two files have some adjecent blocks, cfq will immediately
merge them. cfq_rq_close() also has trouble, sometimes the seek_mean is very
big. I did a test to make cfq_rq_close() always checks the distence according
to CIC_SEEK_THR, but still saw a lot of wrong merge. (BTW, why we take a long
distence far away request as close. Taking them close doesn't improve any thoughtput
to me. Maybe we should always use CIC_SEEK_THR as close criteria).
So sounds we need make split more aggressive. But the split is too lazay,
which requires to wait 1s. Time based check isn't reliable as queue might not
run at given time, so uses a small time isn't ok. I'm thinking changing the split
check based on requests number instead of time. That is if several continuous
requests are regarded as seeky, the coop queue is split. See blow RFC patch.
How many count a queue should be split after need more consideration,
below patch just uses an arbitary number.  This reduce about 5% performance
lost when doing tio 32 threads sequential read.

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e2f8046..d4d51b5 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -46,7 +46,7 @@ static const int cfq_hist_divisor = 4;
  * Allow merged cfqqs to perform this amount of seeky I/O before
  * deciding to break the queues up again.
  */
-#define CFQQ_COOP_TOUT		(HZ)
+#define CFQQ_COOP_TOUT		(cfq_quantum)
 
 #define CFQ_SLICE_SCALE		(5)
 #define CFQ_HW_QUEUE_MIN	(5)
@@ -138,6 +138,7 @@ struct cfq_queue {
 	sector_t seek_mean;
 	sector_t last_request_pos;
 	unsigned long seeky_start;
+	unsigned int reqs_since_seeky;
 
 	pid_t pid;
 
@@ -3035,9 +3036,10 @@ cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	 * queues apart again.
 	 */
 	if (cfq_cfqq_coop(cfqq)) {
-		if (CFQQ_SEEKY(cfqq) && !cfqq->seeky_start)
-			cfqq->seeky_start = jiffies;
-		else if (!CFQQ_SEEKY(cfqq))
+		if (CFQQ_SEEKY(cfqq) && !cfqq->seeky_start) {
+			cfqq->seeky_start = 1;
+			cfqq->reqs_since_seeky = 0;
+		} else if (!CFQQ_SEEKY(cfqq))
 			cfqq->seeky_start = 0;
 	}
 }
@@ -3189,6 +3191,8 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfq_update_idle_window(cfqd, cfqq, cic);
 
 	cfqq->last_request_pos = blk_rq_pos(rq) + blk_rq_sectors(rq);
+	if (cfqq->seeky_start)
+		cfqq->reqs_since_seeky ++;
 
 	if (cfqq == cfqd->active_queue) {
 		/*
@@ -3476,8 +3480,7 @@ cfq_merge_cfqqs(struct cfq_data *cfqd, struct cfq_io_context *cic,
 
 static int should_split_cfqq(struct cfq_queue *cfqq)
 {
-	if (cfqq->seeky_start &&
-	    time_after(jiffies, cfqq->seeky_start + CFQQ_COOP_TOUT))
+	if (cfqq->seeky_start && cfqq->reqs_since_seeky > CFQQ_COOP_TOUT)
 		return 1;
 	return 0;
 }
@@ -3491,6 +3494,7 @@ split_cfqq(struct cfq_io_context *cic, struct cfq_queue *cfqq)
 {
 	if (cfqq_process_refs(cfqq) == 1) {
 		cfqq->seeky_start = 0;
+		cfqq->reqs_since_seeky = 0;
 		cfqq->pid = current->pid;
 		cfq_clear_cfqq_coop(cfqq);
 		return cfqq;
