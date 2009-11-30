Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbZK3DBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbZK3DBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbZK3DAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:00:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbZK3DAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 18/21] blkio: Determine async workload length based on total number of queues
Date: Sun, 29 Nov 2009 21:59:25 -0500
Message-Id: <1259549968-10369-19-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Async queues are not per group. Instead these are system wide and maintained
  in root group. Hence their workload slice length should be calculated
  based on total number of queues in the system and not just queues in the
  root group.

o As root group's default weight is 1000, make sure to charge async queue
  more in terms of vtime so that it does not get more time on disk because
  root group has higher weight.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   36 +++++++++++++++++++++++++++++++-----
 1 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 52d504b..ba052cf 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -405,6 +405,13 @@ static inline int cfq_group_busy_queues_wl(enum wl_prio_t wl,
 		+ cfqg->service_trees[wl][SYNC_WORKLOAD].count;
 }
 
+static inline int cfqg_busy_async_queues(struct cfq_data *cfqd,
+					struct cfq_group *cfqg)
+{
+	return cfqg->service_trees[RT_WORKLOAD][ASYNC_WORKLOAD].count
+		+ cfqg->service_trees[BE_WORKLOAD][ASYNC_WORKLOAD].count;
+}
+
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
 static struct cfq_queue *cfq_get_queue(struct cfq_data *, bool,
 				       struct io_context *, gfp_t);
@@ -897,13 +904,19 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 				struct cfq_queue *cfqq)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
-	unsigned int used_sl;
+	unsigned int used_sl, charge_sl;
+	int nr_sync = cfqg->nr_cfqq - cfqg_busy_async_queues(cfqd, cfqg)
+			- cfqg->service_tree_idle.count;
+
+	BUG_ON(nr_sync < 0);
+	used_sl = charge_sl = cfq_cfqq_slice_usage(cfqq);
 
-	used_sl = cfq_cfqq_slice_usage(cfqq);
+	if (!cfq_cfqq_sync(cfqq) && !nr_sync)
+		charge_sl = cfqq->allocated_slice;
 
 	/* Can't update vdisktime while group is on service tree */
 	cfq_rb_erase(&cfqg->rb_node, st);
-	cfqg->vdisktime += cfq_scale_slice(used_sl, cfqg);
+	cfqg->vdisktime += cfq_scale_slice(charge_sl, cfqg);
 	__cfq_group_service_tree_add(st, cfqg);
 
 	/* This group is being expired. Save the context */
@@ -2018,11 +2031,24 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
 		      cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd, cfqg));
 
-	if (cfqd->serving_type == ASYNC_WORKLOAD)
+	if (cfqd->serving_type == ASYNC_WORKLOAD) {
+		unsigned int tmp;
+
+		/*
+		 * Async queues are currently system wide. Just taking
+		 * proportion of queues with-in same group will lead to higher
+		 * async ratio system wide as generally root group is going
+		 * to have higher weight. A more accurate thing would be to
+		 * calculate system wide asnc/sync ratio.
+		 */
+		tmp = cfq_target_latency * cfqg_busy_async_queues(cfqd, cfqg);
+		tmp = tmp/cfqd->busy_queues;
+		slice = min_t(unsigned, slice, tmp);
+
 		/* async workload slice is scaled down according to
 		 * the sync/async slice ratio. */
 		slice = slice * cfqd->cfq_slice[0] / cfqd->cfq_slice[1];
-	else
+	} else
 		/* sync workload slice is at least 2 * cfq_slice_idle */
 		slice = max(slice, 2 * cfqd->cfq_slice_idle);
 
-- 
1.6.2.5

