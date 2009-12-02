Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZLBPv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZLBPv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbZLBPv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:51:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbZLBPv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:51:26 -0500
Date: Wed, 2 Dec 2009 10:49:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, czoccolo@gmail.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 05/21] blkio: Introduce the root service tree for cfq
	groups
Message-ID: <20091202154929.GF31715@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com> <1259549968-10369-6-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259549968-10369-6-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 09:59:12PM -0500, Vivek Goyal wrote:
> o So far we just had one cfq_group in cfq_data. To create space for more than
>   one cfq_group, we need to have a service tree of groups where all the groups
>   can be queued if they have active cfq queues backlogged in these.
> 

Reposting this patch. Introduced a new macro rb_entry_cfqg() along the
lines of rb_entry_rq().


o So far we just had one cfq_group in cfq_data. To create space for more than
  one cfq_group, we need to have a service tree of groups where all the groups
  can be queued if they have active cfq queues backlogged in these.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |  137 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 134 insertions(+), 3 deletions(-)

Index: linux10/block/cfq-iosched.c
===================================================================
--- linux10.orig/block/cfq-iosched.c	2009-11-30 17:22:57.000000000 -0500
+++ linux10/block/cfq-iosched.c	2009-12-02 10:47:17.000000000 -0500
@@ -66,6 +66,7 @@ static DEFINE_SPINLOCK(ioc_gone_lock);
 #define cfq_class_rt(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_RT)
 
 #define sample_valid(samples)	((samples) > 80)
+#define rb_entry_cfqg(node)	rb_entry((node), struct cfq_group, rb_node)
 
 /*
  * Most of our rbtree usage is for sorting with min extraction, so
@@ -77,8 +78,9 @@ struct cfq_rb_root {
 	struct rb_root rb;
 	struct rb_node *left;
 	unsigned count;
+	u64 min_vdisktime;
 };
-#define CFQ_RB_ROOT	(struct cfq_rb_root) { RB_ROOT, NULL, 0, }
+#define CFQ_RB_ROOT	(struct cfq_rb_root) { RB_ROOT, NULL, 0, 0, }
 
 /*
  * Per process-grouping structure
@@ -156,6 +158,16 @@ enum wl_type_t {
 
 /* This is per cgroup per device grouping structure */
 struct cfq_group {
+	/* group service_tree member */
+	struct rb_node rb_node;
+
+	/* group service_tree key */
+	u64 vdisktime;
+	bool on_st;
+
+	/* number of cfqq currently on this group */
+	int nr_cfqq;
+
 	/*
 	 * rr lists of queues with requests, onle rr for each priority class.
 	 * Counts are embedded in the cfq_rb_root
@@ -169,6 +181,8 @@ struct cfq_group {
  */
 struct cfq_data {
 	struct request_queue *queue;
+	/* Root service tree for cfq_groups */
+	struct cfq_rb_root grp_service_tree;
 	struct cfq_group root_group;
 
 	/*
@@ -251,6 +265,9 @@ static struct cfq_rb_root *service_tree_
 					    enum wl_type_t type,
 					    struct cfq_data *cfqd)
 {
+	if (!cfqg)
+		return NULL;
+
 	if (prio == IDLE_WORKLOAD)
 		return &cfqg->service_tree_idle;
 
@@ -589,6 +606,17 @@ static struct cfq_queue *cfq_rb_first(st
 	return NULL;
 }
 
+static struct cfq_group *cfq_rb_first_group(struct cfq_rb_root *root)
+{
+	if (!root->left)
+		root->left = rb_first(&root->rb);
+
+	if (root->left)
+		return rb_entry_cfqg(root->left);
+
+	return NULL;
+}
+
 static void rb_erase_init(struct rb_node *n, struct rb_root *root)
 {
 	rb_erase(n, root);
@@ -645,6 +673,83 @@ static unsigned long cfq_slice_offset(st
 		   cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
 }
 
+static inline s64
+cfqg_key(struct cfq_rb_root *st, struct cfq_group *cfqg)
+{
+	return cfqg->vdisktime - st->min_vdisktime;
+}
+
+static void
+__cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
+{
+	struct rb_node **node = &st->rb.rb_node;
+	struct rb_node *parent = NULL;
+	struct cfq_group *__cfqg;
+	s64 key = cfqg_key(st, cfqg);
+	int left = 1;
+
+	while (*node != NULL) {
+		parent = *node;
+		__cfqg = rb_entry_cfqg(parent);
+
+		if (key < cfqg_key(st, __cfqg))
+			node = &parent->rb_left;
+		else {
+			node = &parent->rb_right;
+			left = 0;
+		}
+	}
+
+	if (left)
+		st->left = &cfqg->rb_node;
+
+	rb_link_node(&cfqg->rb_node, parent, node);
+	rb_insert_color(&cfqg->rb_node, &st->rb);
+}
+
+static void
+cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
+{
+	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct cfq_group *__cfqg;
+	struct rb_node *n;
+
+	cfqg->nr_cfqq++;
+	if (cfqg->on_st)
+		return;
+
+	/*
+	 * Currently put the group at the end. Later implement something
+	 * so that groups get lesser vtime based on their weights, so that
+	 * if group does not loose all if it was not continously backlogged.
+	 */
+	n = rb_last(&st->rb);
+	if (n) {
+		__cfqg = rb_entry_cfqg(n);
+		cfqg->vdisktime = __cfqg->vdisktime + CFQ_IDLE_DELAY;
+	} else
+		cfqg->vdisktime = st->min_vdisktime;
+
+	__cfq_group_service_tree_add(st, cfqg);
+	cfqg->on_st = true;
+}
+
+static void
+cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
+{
+	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+
+	BUG_ON(cfqg->nr_cfqq < 1);
+	cfqg->nr_cfqq--;
+	/* If there are other cfq queues under this group, don't delete it */
+	if (cfqg->nr_cfqq)
+		return;
+
+	cfqg->on_st = false;
+	if (!RB_EMPTY_NODE(&cfqg->rb_node))
+		cfq_rb_erase(&cfqg->rb_node, st);
+}
+
 /*
  * The cfqd->service_trees holds all pending cfq_queue's that have
  * requests waiting to be processed. It is sorted in the order that
@@ -727,6 +832,7 @@ static void cfq_service_tree_add(struct 
 	rb_link_node(&cfqq->rb_node, parent, p);
 	rb_insert_color(&cfqq->rb_node, &service_tree->rb);
 	service_tree->count++;
+	cfq_group_service_tree_add(cfqd, cfqq->cfqg);
 }
 
 static struct cfq_queue *
@@ -837,6 +943,7 @@ static void cfq_del_cfqq_rr(struct cfq_d
 		cfqq->p_root = NULL;
 	}
 
+	cfq_group_service_tree_del(cfqd, cfqq->cfqg);
 	BUG_ON(!cfqd->busy_queues);
 	cfqd->busy_queues--;
 }
@@ -1113,6 +1220,9 @@ static struct cfq_queue *cfq_get_next_qu
 	if (!cfqd->rq_queued)
 		return NULL;
 
+	/* There is nothing to dispatch */
+	if (!service_tree)
+		return NULL;
 	if (RB_EMPTY_ROOT(&service_tree->rb))
 		return NULL;
 	return cfq_rb_first(service_tree);
@@ -1482,6 +1592,12 @@ static void choose_service_tree(struct c
 	unsigned count;
 	struct cfq_rb_root *st;
 
+	if (!cfqg) {
+		cfqd->serving_prio = IDLE_WORKLOAD;
+		cfqd->workload_expires = jiffies + 1;
+		return;
+	}
+
 	/* Choose next priority. RT > BE > IDLE */
 	if (cfq_busy_queues_wl(RT_WORKLOAD, cfqd))
 		cfqd->serving_prio = RT_WORKLOAD;
@@ -1540,10 +1656,21 @@ static void choose_service_tree(struct c
 	cfqd->noidle_tree_requires_idle = false;
 }
 
+static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
+{
+	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+
+	if (RB_EMPTY_ROOT(&st->rb))
+		return NULL;
+	return cfq_rb_first_group(st);
+}
+
 static void cfq_choose_cfqg(struct cfq_data *cfqd)
 {
-	cfqd->serving_group = &cfqd->root_group;
-	choose_service_tree(cfqd, &cfqd->root_group);
+	struct cfq_group *cfqg = cfq_get_next_cfqg(cfqd);
+
+	cfqd->serving_group = cfqg;
+	choose_service_tree(cfqd, cfqg);
 }
 
 /*
@@ -3019,10 +3146,14 @@ static void *cfq_init_queue(struct reque
 	if (!cfqd)
 		return NULL;
 
+	/* Init root service tree */
+	cfqd->grp_service_tree = CFQ_RB_ROOT;
+
 	/* Init root group */
 	cfqg = &cfqd->root_group;
 	for_each_cfqg_st(cfqg, i, j, st)
 		*st = CFQ_RB_ROOT;
+	RB_CLEAR_NODE(&cfqg->rb_node);
 
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we
