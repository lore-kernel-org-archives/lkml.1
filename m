Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZK3DCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZK3DCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbZK3DBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:01:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbZK3DAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 07/21] blkio: Introduce per cfq group weights and vdisktime calculations
Date: Sun, 29 Nov 2009 21:59:14 -0500
Message-Id: <1259549968-10369-8-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Bring in the per cfq group weight and how vdisktime is calculated for the
  group. Also bring in the functionality of updating the min_vdisktime of
  the group service tree.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/Kconfig.iosched |    9 ++++++-
 block/cfq-iosched.c   |   62 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index be0280d..fa95fa7 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -23,7 +23,6 @@ config IOSCHED_DEADLINE
 
 config IOSCHED_CFQ
 	tristate "CFQ I/O scheduler"
-	select BLK_CGROUP
 	default y
 	---help---
 	  The CFQ I/O scheduler tries to distribute bandwidth equally
@@ -33,6 +32,14 @@ config IOSCHED_CFQ
 
 	  This is the default I/O scheduler.
 
+config CFQ_GROUP_IOSCHED
+	bool "CFQ Group Scheduling support"
+	depends on IOSCHED_CFQ && CGROUPS
+	select BLK_CGROUP
+	default n
+	---help---
+	  Enable group IO scheduling in CFQ.
+
 choice
 	prompt "Default I/O scheduler"
 	default DEFAULT_CFQ
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 0a284be..fbb6bf5 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -13,6 +13,7 @@
 #include <linux/rbtree.h>
 #include <linux/ioprio.h>
 #include <linux/blktrace_api.h>
+#include "blk-cgroup.h"
 
 /*
  * tunables
@@ -49,6 +50,7 @@ static const int cfq_hist_divisor = 4;
 
 #define CFQ_SLICE_SCALE		(5)
 #define CFQ_HW_QUEUE_MIN	(5)
+#define CFQ_SERVICE_SHIFT       12
 
 #define RQ_CIC(rq)		\
 	((struct cfq_io_context *) (rq)->elevator_private)
@@ -78,6 +80,7 @@ struct cfq_rb_root {
 	struct rb_node *left;
 	unsigned count;
 	u64 min_vdisktime;
+	struct rb_node *active;
 };
 #define CFQ_RB_ROOT	(struct cfq_rb_root) { RB_ROOT, NULL, 0, 0, }
 
@@ -162,6 +165,7 @@ struct cfq_group {
 
 	/* group service_tree key */
 	u64 vdisktime;
+	unsigned int weight;
 	bool on_st;
 
 	/* number of cfqq currently on this group */
@@ -431,6 +435,51 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
 }
 
+static inline u64 cfq_scale_slice(unsigned long delta, struct cfq_group *cfqg)
+{
+	u64 d = delta << CFQ_SERVICE_SHIFT;
+
+	d = d * BLKIO_WEIGHT_DEFAULT;
+	do_div(d, cfqg->weight);
+	return d;
+}
+
+static inline u64 max_vdisktime(u64 min_vdisktime, u64 vdisktime)
+{
+	s64 delta = (s64)(vdisktime - min_vdisktime);
+	if (delta > 0)
+		min_vdisktime = vdisktime;
+
+	return min_vdisktime;
+}
+
+static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
+{
+	s64 delta = (s64)(vdisktime - min_vdisktime);
+	if (delta < 0)
+		min_vdisktime = vdisktime;
+
+	return min_vdisktime;
+}
+
+static void update_min_vdisktime(struct cfq_rb_root *st)
+{
+	u64 vdisktime = st->min_vdisktime;
+	struct cfq_group *cfqg;
+
+	if (st->active) {
+		cfqg = rb_entry(st->active, struct cfq_group, rb_node);
+		vdisktime = cfqg->vdisktime;
+	}
+
+	if (st->left) {
+		cfqg = rb_entry(st->left, struct cfq_group, rb_node);
+		vdisktime = min_vdisktime(vdisktime, cfqg->vdisktime);
+	}
+
+	st->min_vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
+}
+
 /*
  * get averaged number of queues of RT/BE priority.
  * average is updated, with a formula that gives more weight to higher numbers,
@@ -736,8 +785,12 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 
+	if (st->active == &cfqg->rb_node)
+		st->active = NULL;
+
 	BUG_ON(cfqg->nr_cfqq < 1);
 	cfqg->nr_cfqq--;
+
 	/* If there are other cfq queues under this group, don't delete it */
 	if (cfqg->nr_cfqq)
 		return;
@@ -1656,10 +1709,14 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct cfq_group *cfqg;
 
 	if (RB_EMPTY_ROOT(&st->rb))
 		return NULL;
-	return cfq_rb_first_group(st);
+	cfqg = cfq_rb_first_group(st);
+	st->active = &cfqg->rb_node;
+	update_min_vdisktime(st);
+	return cfqg;
 }
 
 static void cfq_choose_cfqg(struct cfq_data *cfqd)
@@ -3152,6 +3209,9 @@ static void *cfq_init_queue(struct request_queue *q)
 		*st = CFQ_RB_ROOT;
 	RB_CLEAR_NODE(&cfqg->rb_node);
 
+	/* Give preference to root group over other groups */
+	cfqg->weight = 2*BLKIO_WEIGHT_DEFAULT;
+
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we
 	 * zeroed cfqd on alloc), but better be safe in case someone decides
-- 
1.6.2.5

