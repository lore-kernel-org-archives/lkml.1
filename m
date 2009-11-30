Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbZK3DCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbZK3DCB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbZK3DBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:01:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbZK3DAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:54 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 14/21] blkio: Provide some isolation between groups
Date: Sun, 29 Nov 2009 21:59:21 -0500
Message-Id: <1259549968-10369-15-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Do not allow following three operations across groups for isolation.
	- selection of co-operating queues
	- preemtpions across groups
	- request merging across groups.

o Async queues are currently global and not per group. Allow preemption of
  an async queue if a sync queue in other group gets backlogged.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 8abc25b..ed18746 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1463,6 +1463,9 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
 
+	/* Deny merge if bio and rq don't belong to same cfq group */
+	if ((RQ_CFQQ(rq))->cfqg != cfq_get_cfqg(cfqd, 0))
+		return false;
 	/*
 	 * Disallow merge of a sync bio into an async request.
 	 */
@@ -1700,6 +1703,10 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 	if (!cfqq)
 		return NULL;
 
+	/* If new queue belongs to different cfq_group, don't choose it */
+	if (cur_cfqq->cfqg != cfqq->cfqg)
+		return NULL;
+
 	/*
 	 * It only makes sense to merge sync queues.
 	 */
@@ -2952,22 +2959,12 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (!cfqq)
 		return false;
 
-	if (cfq_slice_used(cfqq))
-		return true;
-
 	if (cfq_class_idle(new_cfqq))
 		return false;
 
 	if (cfq_class_idle(cfqq))
 		return true;
 
-	/* Allow preemption only if we are idling on sync-noidle tree */
-	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD &&
-	    cfqq_type(new_cfqq) == SYNC_NOIDLE_WORKLOAD &&
-	    new_cfqq->service_tree->count == 2 &&
-	    RB_EMPTY_ROOT(&cfqq->sort_list))
-		return true;
-
 	/*
 	 * if the new request is sync, but the currently running queue is
 	 * not, let the sync request have priority.
@@ -2975,6 +2972,19 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq))
 		return true;
 
+	if (new_cfqq->cfqg != cfqq->cfqg)
+		return false;
+
+	if (cfq_slice_used(cfqq))
+		return true;
+
+	/* Allow preemption only if we are idling on sync-noidle tree */
+	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD &&
+	    cfqq_type(new_cfqq) == SYNC_NOIDLE_WORKLOAD &&
+	    new_cfqq->service_tree->count == 2 &&
+	    RB_EMPTY_ROOT(&cfqq->sort_list))
+		return true;
+
 	/*
 	 * So both queues are sync. Let the new request get disk time if
 	 * it's a metadata request and the current queue is doing regular IO.
-- 
1.6.2.5

