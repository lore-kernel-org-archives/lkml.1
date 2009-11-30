Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbZK3DD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbZK3DD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZK3DBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:01:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbZK3DAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:50 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 09/21] blkio: Group time used accounting and workload context save restore
Date: Sun, 29 Nov 2009 21:59:16 -0500
Message-Id: <1259549968-10369-10-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o This patch introduces the functionality to do the accounting of group time
  when a queue expires. This time used decides which is the group to go
  next.

o Also introduce the functionlity to save and restore the workload type
  context with-in group. It might happen that once we expire the cfq queue
  and group, a different group will schedule in and we will lose the context
  of the workload type. Hence save and restore it upon queue expiry.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   79 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6466393..5a75f81 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -114,6 +114,10 @@ struct cfq_queue {
 	/* fifo list of requests in sort_list */
 	struct list_head fifo;
 
+	/* time when queue got scheduled in to dispatch first request. */
+	unsigned long dispatch_start;
+	/* time when first request from queue completed and slice started. */
+	unsigned long slice_start;
 	unsigned long slice_end;
 	long slice_resid;
 	unsigned int slice_dispatch;
@@ -180,6 +184,10 @@ struct cfq_group {
 	 */
 	struct cfq_rb_root service_trees[2][3];
 	struct cfq_rb_root service_tree_idle;
+
+	unsigned long saved_workload_slice;
+	enum wl_type_t saved_workload;
+	enum wl_prio_t saved_serving_prio;
 };
 
 /*
@@ -540,6 +548,7 @@ cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 				    low_slice);
 		}
 	}
+	cfqq->slice_start = jiffies;
 	cfqq->slice_end = jiffies + slice;
 	cfq_log_cfqq(cfqd, cfqq, "set_slice=%lu", cfqq->slice_end - jiffies);
 }
@@ -820,6 +829,58 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	st->total_weight -= cfqg->weight;
 	if (!RB_EMPTY_NODE(&cfqg->rb_node))
 		cfq_rb_erase(&cfqg->rb_node, st);
+	cfqg->saved_workload_slice = 0;
+}
+
+static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
+{
+	unsigned int slice_used, allocated_slice;
+
+	/*
+	 * Queue got expired before even a single request completed or
+	 * got expired immediately after first request completion.
+	 */
+	if (!cfqq->slice_start || cfqq->slice_start == jiffies) {
+		/*
+		 * Also charge the seek time incurred to the group, otherwise
+		 * if there are mutiple queues in the group, each can dispatch
+		 * a single request on seeky media and cause lots of seek time
+		 * and group will never know it.
+		 */
+		slice_used = max_t(unsigned, (jiffies - cfqq->dispatch_start),
+					1);
+	} else {
+		slice_used = jiffies - cfqq->slice_start;
+		allocated_slice = cfqq->slice_end - cfqq->slice_start;
+		if (slice_used > allocated_slice)
+			slice_used = allocated_slice;
+	}
+
+	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u", slice_used);
+	return slice_used;
+}
+
+static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
+				struct cfq_queue *cfqq)
+{
+	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	unsigned int used_sl;
+
+	used_sl = cfq_cfqq_slice_usage(cfqq);
+
+	/* Can't update vdisktime while group is on service tree */
+	cfq_rb_erase(&cfqg->rb_node, st);
+	cfqg->vdisktime += cfq_scale_slice(used_sl, cfqg);
+	__cfq_group_service_tree_add(st, cfqg);
+
+	/* This group is being expired. Save the context */
+	if (time_after(cfqd->workload_expires, jiffies)) {
+		cfqg->saved_workload_slice = cfqd->workload_expires
+						- jiffies;
+		cfqg->saved_workload = cfqd->serving_type;
+		cfqg->saved_serving_prio = cfqd->serving_prio;
+	} else
+		cfqg->saved_workload_slice = 0;
 }
 
 /*
@@ -835,6 +896,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	unsigned long rb_key;
 	struct cfq_rb_root *service_tree;
 	int left;
+	int new_cfqq = 1;
 
 	service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
 						cfqq_type(cfqq), cfqd);
@@ -863,6 +925,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	}
 
 	if (!RB_EMPTY_NODE(&cfqq->rb_node)) {
+		new_cfqq = 0;
 		/*
 		 * same position, nothing more to do
 		 */
@@ -904,6 +967,8 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	rb_link_node(&cfqq->rb_node, parent, p);
 	rb_insert_color(&cfqq->rb_node, &service_tree->rb);
 	service_tree->count++;
+	if (add_front || !new_cfqq)
+		return;
 	cfq_group_service_tree_add(cfqd, cfqq->cfqg);
 }
 
@@ -1220,6 +1285,8 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 {
 	if (cfqq) {
 		cfq_log_cfqq(cfqd, cfqq, "set_active");
+		cfqq->slice_start = 0;
+		cfqq->dispatch_start = jiffies;
 		cfqq->slice_end = 0;
 		cfqq->slice_dispatch = 0;
 
@@ -1257,6 +1324,8 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfq_log_cfqq(cfqd, cfqq, "resid=%ld", cfqq->slice_resid);
 	}
 
+	cfq_group_served(cfqd, cfqq->cfqg, cfqq);
+
 	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
 		cfq_del_cfqq_rr(cfqd, cfqq);
 
@@ -1265,6 +1334,9 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (cfqq == cfqd->active_queue)
 		cfqd->active_queue = NULL;
 
+	if (&cfqq->cfqg->rb_node == cfqd->grp_service_tree.active)
+		cfqd->grp_service_tree.active = NULL;
+
 	if (cfqd->active_cic) {
 		put_io_context(cfqd->active_cic->ioc);
 		cfqd->active_cic = NULL;
@@ -1749,6 +1821,13 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
 	struct cfq_group *cfqg = cfq_get_next_cfqg(cfqd);
 
 	cfqd->serving_group = cfqg;
+
+	/* Restore the workload type data */
+	if (cfqg->saved_workload_slice) {
+		cfqd->workload_expires = jiffies + cfqg->saved_workload_slice;
+		cfqd->serving_type = cfqg->saved_workload;
+		cfqd->serving_prio = cfqg->saved_serving_prio;
+	}
 	choose_service_tree(cfqd, cfqg);
 }
 
-- 
1.6.2.5

