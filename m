Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbZL3PIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbZL3PIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 10:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZL3PIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 10:08:47 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37944 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZL3PIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 10:08:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Q9nQwf78wc/ZKZYRnHiCS1sHdmEFmE1psSby9Pcb+i7NALFc0KV/AODxaLHo6oWzRp
         SEHGbW1gxTnmwYl4MUOH0Hp2n83WBsF7GclUwtok78CU6u6z4j4+PM95kcdP3ItZXnY0
         X2gUoWAAbpw/w3i+YCWyogn6O3eynZDklRVFs=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: [PATCH] cfq-iosched: replace sync_flight by rq_in_driver[BLK_RW_SYNC]
Date: Wed, 30 Dec 2009 16:08:58 +0100
Message-Id: <1262185738-11942-1-git-send-email-czoccolo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to my intuition (and brief testing), sync_flight is always
equal to rq_in_driver[BLK_RW_SYNC] at the point of usage, so it can
be removed and replaced by the other.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 01bb0f3..4865e08 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -228,7 +228,6 @@ struct cfq_data {
 	unsigned int busy_queues;
 
 	int rq_in_driver[2];
-	int sync_flight;
 
 	/*
 	 * queue-depth detection
@@ -1875,8 +1874,6 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 	cfqq->dispatched++;
 	elv_dispatch_sort(q, rq);
 
-	if (cfq_cfqq_sync(cfqq))
-		cfqd->sync_flight++;
 	cfqq->nr_sectors += blk_rq_sectors(rq);
 }
 
@@ -2229,7 +2226,7 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	/*
 	 * If this is an async queue and we have sync IO in flight, let it wait
 	 */
-	if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
+	if (cfqd->rq_in_driver[BLK_RW_SYNC] && !cfq_cfqq_sync(cfqq))
 		return false;
 
 	max_dispatch = cfqd->cfq_quantum;
@@ -3294,9 +3291,6 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	cfqd->rq_in_driver[sync]--;
 	cfqq->dispatched--;
 
-	if (cfq_cfqq_sync(cfqq))
-		cfqd->sync_flight--;
-
 	if (sync) {
 		RQ_CIC(rq)->last_end_request = now;
 		if (!time_after(rq->start_time + cfqd->cfq_fifo_expire[1], now))
-- 
1.6.4.4

