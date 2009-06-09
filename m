Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbZFILAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbZFILAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 07:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759882AbZFIK75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:59:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54782 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759336AbZFIK74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:59:56 -0400
Message-ID: <4A2E4088.1010403@cn.fujitsu.com>
Date: Tue, 09 Jun 2009 18:59:20 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] CFQ:optimize the cfq_should_preempt()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The patch don't fix bug, just optimizes the cfq_should_preempt()
to preempt higher priority queue.

Additionally, the comment above cfq_preempt_queue() is outdated.


Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 block/cfq-iosched.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a55a9bd..427f522 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1993,10 +1993,10 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (cfq_slice_used(cfqq))
 		return 1;
 
-	if (cfq_class_idle(new_cfqq))
-		return 0;
-
-	if (cfq_class_idle(cfqq))
+	/*
+	 * if new_cfqq is of higher priority, preempting the active queue.
+	 */
+	if (new_cfqq->ioprio_class < cfqq->ioprio_class)
 		return 1;
 
 	/*
@@ -2013,12 +2013,6 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (rq_is_meta(rq) && !cfqq->meta_pending)
 		return 1;
 
-	/*
-	 * Allow an RT request to pre-empt an ongoing non-RT cfqq timeslice.
-	 */
-	if (cfq_class_rt(new_cfqq) && !cfq_class_rt(cfqq))
-		return 1;
-
 	if (!cfqd->active_cic || !cfq_cfqq_wait_request(cfqq))
 		return 0;
 
@@ -2033,8 +2027,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 }
 
 /*
- * cfqq preempts the active queue. if we allowed preempt with no slice left,
- * let it have half of its nominal slice.
+ * cfqq preempts the active queue, and is set a new slice time.
  */
 static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
