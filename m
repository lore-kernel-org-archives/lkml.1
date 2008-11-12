Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbYKLIhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbYKLIhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 03:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYKLIhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 03:37:18 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:45937 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbYKLIhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 03:37:16 -0500
From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
To: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
       <virtualization@lists.linux-foundation.org>, <jens.axboe@oracle.com>,
       "'Ryo Tsuruta'" <ryov@valinux.co.jp>,
       "'Andrea Righi'" <righi.andrea@gmail.com>, <ngupta@google.com>,
       <fernando@oss.ntt.co.jp>, <vtaras@openvz.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'SUGAWARA Tomoyoshi'" <tom-sugawara@ap.jp.nec.com>,
       <menage@google.com>, <balbir@linux.vnet.ibm.com>
References: <000c01c9449e$c5bcdc20$51369460$@jp.nec.com>
In-Reply-To: <000c01c9449e$c5bcdc20$51369460$@jp.nec.com>
Subject: [PATCH][cfq-cgroups][10/12] Introduce request control for two layer. 
Date: Wed, 12 Nov 2008 17:30:21 +0900
Message-ID: <001701c944a0$e6ac56c0$b4050440$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AclEnsU5YPNAeH0jT4OGyB1wwkbE/wAAgupA
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  This patch controls requests according to two layer mechanism.
  As it is, functions searches corresponding cfq data and 
  activates/deactivates cfq data.


    Signed-off-by: Satoshi UCHIDA <s-uchida@ap.jp.nec.com> 

---
 block/cfq-cgroup.c          |   71 +++++++++++++++++++++++++++++++++++++++++++
 block/cfq-iosched.c         |   57 +++++++++++++++++++++++++++-------
 include/linux/cfq-iosched.h |    9 +++++
 3 files changed, 125 insertions(+), 12 deletions(-)

diff --git a/block/cfq-cgroup.c b/block/cfq-cgroup.c
index ff652fe..f3e9f40 100644
--- a/block/cfq-cgroup.c
+++ b/block/cfq-cgroup.c
@@ -557,6 +557,72 @@ int cfq_cgroup_completed_request_opt(struct cfq_data *cfqd)
 }
 
 /*
+ * optional functions for two layers
+ */
+struct cfq_data *cfq_cgroup_search_data(void *data,
+					struct task_struct *tsk)
+{
+	struct cfq_data *cfqd = (struct cfq_data *)data;
+	struct cfq_driver_data *cfqdd = cfqd->cfqdd;
+	struct cfq_cgroup *cont = task_to_cfq_cgroup(tsk);
+	struct rb_node *p = cont->sibling_tree.rb_node;
+
+	while (p) {
+		struct cfq_data *__cfqd;
+		__cfqd = rb_entry(p, struct cfq_data, group_node);
+
+
+		if (cfqdd < __cfqd->cfqdd)
+			p = p->rb_left;
+		else if (cfqdd > __cfqd->cfqdd)
+			p = p->rb_right;
+		else
+			return __cfqd;
+	}
+
+	return NULL;
+}
+
+static int cfq_cgroup_queue_empty(struct request_queue *q)
+{
+	struct cfq_data *cfqd = q->elevator->elevator_data;
+	struct cfq_driver_data *cfqdd = cfqd->cfqdd;
+
+	return !cfqdd->busy_data;
+}
+
+static void cfq_cgroup_add_cfqd_rr(struct cfq_data *cfqd)
+{
+	if (!cfq_cfqd_on_rr(cfqd)) {
+		cfq_mark_cfqd_on_rr(cfqd);
+		cfqd->cfqdd->busy_data++;
+
+		cfq_cgroup_service_tree_add(cfqd, 0);
+	}
+}
+
+static void cfq_cgroup_del_cfqd_rr(struct cfq_data *cfqd)
+{
+	if (RB_EMPTY_ROOT(&cfqd->service_tree.rb)) {
+		struct cfq_driver_data *cfqdd = cfqd->cfqdd;
+		BUG_ON(!cfq_cfqd_on_rr(cfqd));
+		cfq_clear_cfqd_on_rr(cfqd);
+		if (!RB_EMPTY_NODE(&cfqd->rb_node)) {
+			cfq_rb_erase(&cfqd->rb_node,
+				     &cfqdd->service_tree);
+		}
+		BUG_ON(!cfqdd->busy_data);
+		cfqdd->busy_data--;
+	}
+}
+
+static int cfq_cgroup_is_active_data(struct cfq_data *cfqd)
+{
+	return cfqd->cfqdd->active_data == cfqd;
+}
+
+
+/*
  * cgroupfs parts below -->
  */
 static void
@@ -944,6 +1010,10 @@ static struct elevator_type iosched_cfq_cgroup = {
 static struct cfq_ops cfq_cgroup_op = {
 	.cfq_init_driver_data_opt_fn	= cfq_cgroup_init_driver_data_opt,
 	.cfq_completed_request_opt_fn	= cfq_cgroup_completed_request_opt,
+	.cfq_search_data_fn		= cfq_cgroup_search_data,
+	.cfq_add_cfqq_opt_fn		= cfq_cgroup_add_cfqd_rr,
+	.cfq_del_cfqq_opt_fn		= cfq_cgroup_del_cfqd_rr,
+	.cfq_is_active_data_fn		= cfq_cgroup_is_active_data,
 };
 
 static int __init cfq_cgroup_init(void)
@@ -953,6 +1023,7 @@ static int __init cfq_cgroup_init(void)
 	iosched_cfq_cgroup.ops.elevator_exit_fn = cfq_cgroup_exit_queue;
 	iosched_cfq_cgroup.ops.elevator_dispatch_fn =
 					cfq_cgroup_dispatch_requests,
+	iosched_cfq_cgroup.ops.elevator_queue_empty_fn = cfq_cgroup_queue_empty,
 
 	elv_register(&iosched_cfq_cgroup);
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5fbef85..5fe0551 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -181,26 +181,30 @@ static inline int cfq_bio_sync(struct bio *bio)
 	return 0;
 }
 
+
+static int cfq_queue_empty(struct request_queue *q)
+{
+	struct cfq_data *cfqd = q->elevator->elevator_data;
+
+	return !cfqd->busy_queues;
+}
+
 /*
  * scheduler run of queue, if there are requests pending and no one in the
  * driver that will restart queueing
  */
-static inline void cfq_schedule_dispatch(struct cfq_data *cfqd)
+inline void cfq_schedule_dispatch(struct cfq_data *cfqd)
 {
 	struct cfq_driver_data *cfqdd = cfqd->cfqdd;
-	if (cfqd->busy_queues) {
+	struct elevator_ops *ops = cfqdd->queue->elevator->ops;
+
+	if (!ops->elevator_queue_empty_fn(cfqdd->queue)) {
 		cfq_log(cfqd, "schedule dispatch");
 		kblockd_schedule_work(cfqdd->queue,
 				      &cfqdd->unplug_work);
 	}
 }
 
-static int cfq_queue_empty(struct request_queue *q)
-{
-	struct cfq_data *cfqd = q->elevator->elevator_data;
-
-	return !cfqd->busy_queues;
-}
 
 /*
  * Scale schedule slice based on io priority. Use the sync time slice only
@@ -503,6 +507,9 @@ static void cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	cfqd->busy_queues++;
 
 	cfq_resort_rr_list(cfqd, cfqq);
+
+	if (cfqd->cfqdd->op->cfq_add_cfqq_opt_fn)
+		cfqd->cfqdd->op->cfq_add_cfqq_opt_fn(cfqd);
 }
 
 /*
@@ -520,6 +527,9 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 
 	BUG_ON(!cfqd->busy_queues);
 	cfqd->busy_queues--;
+
+	if (cfqd->cfqdd->op->cfq_del_cfqq_opt_fn)
+		cfqd->cfqdd->op->cfq_del_cfqq_opt_fn(cfqd);
 }
 
 /*
@@ -639,6 +649,9 @@ static int cfq_merge(struct request_queue *q, struct request **req,
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct request *__rq;
 
+	if (cfqd->cfqdd->op->cfq_search_data_fn)
+		cfqd = cfqd->cfqdd->op->cfq_search_data_fn(cfqd, current);
+
 	__rq = cfq_find_rq_fmerge(cfqd, bio);
 	if (__rq && elv_rq_merge_ok(__rq, bio)) {
 		*req = __rq;
@@ -679,6 +692,9 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
 
+	if (cfqd->cfqdd->op->cfq_search_data_fn)
+		cfqd = cfqd->cfqdd->op->cfq_search_data_fn(cfqd, current);
+
 	/*
 	 * Disallow merge of a sync bio into an async request.
 	 */
@@ -882,8 +898,8 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
  */
 static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 {
-	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
+	struct cfq_data *cfqd = cfqq->cfqd;
 
 	cfq_log_cfqq(cfqd, cfqq, "dispatch_insert");
 
@@ -1739,6 +1755,13 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 		   struct request *rq)
 {
 	struct cfq_queue *cfqq;
+	struct cfq_driver_data *cfqdd = cfqd->cfqdd;
+	int flag = 1;
+
+	if (cfqdd->op->cfq_is_active_data_fn)
+		flag = cfqdd->op->cfq_is_active_data_fn(cfqd);
+	if (!flag)
+		return 0;
 
 	cfqq = cfqd->active_queue;
 	if (!cfqq)
@@ -1767,7 +1790,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (rq_is_meta(rq) && !cfqq->meta_pending)
 		return 1;
 
-	if (!cfqd->cfqdd->active_cic || !cfq_cfqq_wait_request(cfqq))
+	if (!cfqdd->active_cic || !cfq_cfqq_wait_request(cfqq))
 		return 0;
 
 	/*
@@ -1811,6 +1834,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 {
 	struct cfq_io_context *cic = RQ_CIC(rq);
 	struct cfq_driver_data *cfqdd = cfqd->cfqdd;
+	int flag = 1;
 
 	cfqdd->rq_queued++;
 	if (rq_is_meta(rq))
@@ -1822,7 +1846,10 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	cic->last_request_pos = rq->sector + rq->nr_sectors;
 
-	if (cfqq == cfqd->active_queue) {
+	if (cfqdd->op->cfq_is_active_data_fn)
+		flag = cfqdd->op->cfq_is_active_data_fn(cfqd);
+
+	if ((flag) && (cfqq == cfqd->active_queue)) {
 		/*
 		 * if we are waiting for a request for this queue, let it rip
 		 * immediately and flag that we must not expire this queue
@@ -1847,8 +1874,8 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 static void cfq_insert_request(struct request_queue *q, struct request *rq)
 {
-	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
+	struct cfq_data *cfqd = cfqq->cfqd;
 
 	cfq_log_cfqq(cfqd, cfqq, "insert_request");
 	cfq_init_prio_data(cfqq, RQ_CIC(rq)->ioc);
@@ -1979,6 +2006,9 @@ static int cfq_may_queue(struct request_queue *q, int rw)
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
 
+	if (cfqd->cfqdd->op->cfq_search_data_fn)
+		cfqd = cfqd->cfqdd->op->cfq_search_data_fn(cfqd, current);
+
 	/*
 	 * don't force setup of a queue from here, as a call to may_queue
 	 * does not necessarily imply that a request actually will be queued.
@@ -2035,6 +2065,9 @@ cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 	struct cfq_queue *cfqq;
 	unsigned long flags;
 
+	if (cfqd->cfqdd->op->cfq_search_data_fn)
+		cfqd = cfqd->cfqdd->op->cfq_search_data_fn(cfqd, current);
+
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
 	cic = cfq_get_io_context(cfqd, gfp_mask);
diff --git a/include/linux/cfq-iosched.h b/include/linux/cfq-iosched.h
index 30702c9..7287186 100644
--- a/include/linux/cfq-iosched.h
+++ b/include/linux/cfq-iosched.h
@@ -132,9 +132,18 @@ struct cfq_data {
 typedef void (cfq_init_driver_data_opt_fn)(struct cfq_driver_data *,
 						struct cfq_data *);
 typedef int (cfq_completed_request_opt_fn)(struct cfq_data *);
+typedef struct cfq_data* (cfq_search_data_fn)(void *, struct task_struct *);
+typedef void (cfq_add_cfqq_opt_fn)(struct cfq_data *);
+typedef void (cfq_del_cfqq_opt_fn)(struct cfq_data *);
+typedef int (cfq_is_active_data_fn)(struct cfq_data *);
+
 struct cfq_ops {
 	cfq_init_driver_data_opt_fn *cfq_init_driver_data_opt_fn;
 	cfq_completed_request_opt_fn *cfq_completed_request_opt_fn;
+	cfq_search_data_fn *cfq_search_data_fn;
+	cfq_add_cfqq_opt_fn *cfq_add_cfqq_opt_fn;
+	cfq_del_cfqq_opt_fn *cfq_del_cfqq_opt_fn;
+	cfq_is_active_data_fn *cfq_is_active_data_fn;
 };
 
 
-- 
1.5.6.5


