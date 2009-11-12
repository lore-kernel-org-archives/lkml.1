Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbZKLXq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbZKLXq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbZKLXqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:46:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606AbZKLXqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:46:15 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 08/16] blkio: Group time used accounting and workload context save restore
Date: Thu, 12 Nov 2009 18:32:28 -0500
Message-Id: <1258068756-10766-9-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1258068756-10766-1-git-send-email-vgoyal@redhat.com>
References: <1258068756-10766-1-git-send-email-vgoyal@redhat.com>
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
 block/cfq-iosched.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1354c6b..1e20478 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -113,6 +113,10 @@ struct cfq_queue {
 	/* fifo list of requests in sort_list */
 	struct list_head fifo;
 
+	/* time when queue got scheduled in to dispatch first request. */
+	unsigned long dispatch_start;
+	/* time when first request from queue completed and slice started. */
+	unsigned long slice_start;
 	unsigned long slice_end;
 	long slice_resid;
 	unsigned int slice_dispatch;
@@ -179,6 +183,10 @@ struct cfq_group {
 	 */
 	struct cfq_rb_root service_trees[2][3];
 	struct cfq_rb_root service_tree_idle;
+
+	unsigned long saved_workload_slice;
+	enum wl_type_t saved_workload;
+	enum wl_prio_t saved_serving_prio;
 };
 
 /*
@@ -512,6 +520,7 @@ cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 				    low_slice);
 		}
 	}
+	cfqq->slice_start = jiffies;
 	cfqq->slice_end = jiffies + slice;
 	cfq_log_cfqq(cfqd, cfqq, "set_slice=%lu", cfqq->slice_end - jiffies);
 }
@@ -781,6 +790,55 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	cfqd->nr_groups--;
 	if (!RB_EMPTY_NODE(&cfqg->rb_node))
 		cfq_rb_erase(&cfqg->rb_node, st);
+	cfqg->saved_workload_slice = 0;
+}
+
+static inline unsigned long cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
+{
+	unsigned long slice_used, allocated_slice;
+
+	/*
+	 * Queue got expired before even a single request completed or
+	 * got expired immediately after first request completion.
+	 */
+	if (!cfqq->slice_end || cfqq->slice_start == jiffies) {
+		/*
+		 * Also charge the seek time incurred to the group, otherwise
+		 * if there are mutiple queues in the group, each can dispatch
+		 * a single request on seeky media and cause lots of seek time
+		 * and group will never know it.
+		 */
+		slice_used = max_t(unsigned long,
+					(jiffies - cfqq->dispatch_start), 1);
+	} else {
+		slice_used = jiffies - cfqq->slice_start;
+		allocated_slice = cfqq->slice_end - cfqq->slice_start;
+		if (slice_used > allocated_slice)
+			slice_used = allocated_slice;
+	}
+
+	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%lu", slice_used);
+	return slice_used;
+}
+
+static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
+				unsigned long service)
+{
+	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+
+	/* Can't update vdisktime while group is on service tree */
+	cfq_rb_erase(&cfqg->rb_node, st);
+	cfqg->vdisktime += cfq_scale_slice(service, cfqg);
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
@@ -796,6 +854,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	unsigned long rb_key;
 	struct cfq_rb_root *service_tree;
 	int left;
+	int new_cfqq = 1;
 
 	service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
 						cfqq_type(cfqq), cfqd);
@@ -824,6 +883,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	}
 
 	if (!RB_EMPTY_NODE(&cfqq->rb_node)) {
+		new_cfqq = 0;
 		/*
 		 * same position, nothing more to do
 		 */
@@ -865,6 +925,8 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	rb_link_node(&cfqq->rb_node, parent, p);
 	rb_insert_color(&cfqq->rb_node, &service_tree->rb);
 	service_tree->count++;
+	if (add_front || !new_cfqq)
+		return;
 	cfq_group_service_tree_add(cfqd, cfqq->cfqg);
 }
 
@@ -1182,6 +1244,8 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 {
 	if (cfqq) {
 		cfq_log_cfqq(cfqd, cfqq, "set_active");
+		cfqq->slice_start = 0;
+		cfqq->dispatch_start = jiffies;
 		cfqq->slice_end = 0;
 		cfqq->slice_dispatch = 0;
 
@@ -1219,6 +1283,8 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfq_log_cfqq(cfqd, cfqq, "resid=%ld", cfqq->slice_resid);
 	}
 
+	cfq_group_served(cfqd, cfqq->cfqg, cfq_cfqq_slice_usage(cfqq));
+
 	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
 		cfq_del_cfqq_rr(cfqd, cfqq);
 
@@ -1227,6 +1293,9 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (cfqq == cfqd->active_queue)
 		cfqd->active_queue = NULL;
 
+	if (&cfqq->cfqg->rb_node == cfqd->grp_service_tree.active)
+		cfqd->grp_service_tree.active = NULL;
+
 	if (cfqd->active_cic) {
 		put_io_context(cfqd->active_cic->ioc);
 		cfqd->active_cic = NULL;
@@ -1735,6 +1804,13 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
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

