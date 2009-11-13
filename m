Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbZKMRkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbZKMRkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbZKMRkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:40:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbZKMRkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:40:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, czoccolo@gmail.com
Subject: [PATCH 11/16] blkio: Export disk time and sectors used by a group to user space
Date: Fri, 13 Nov 2009 12:40:10 -0500
Message-Id: <1258134015-21632-12-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
References: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Export disk time and sector used by a group to user space through cgroup
  interface.

o Also export a "dequeue" interface to cgroup which keeps track of how many
  a times a group was deleted from service tree. Helps in debugging.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c  |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 block/blk-cgroup.h  |   22 ++++++++++++++++-
 block/cfq-iosched.c |   23 ++++++++++++++----
 3 files changed, 101 insertions(+), 8 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 6bc99a3..4ef78d3 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -11,6 +11,8 @@
  * 	              Nauman Rafique <nauman@google.com>
  */
 #include <linux/ioprio.h>
+#include <linux/seq_file.h>
+#include <linux/kdev_t.h>
 #include "blk-cgroup.h"
 
 extern void cfq_unlink_blkio_group(void *, struct blkio_group *);
@@ -23,8 +25,15 @@ struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
 			    struct blkio_cgroup, css);
 }
 
+void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
+			unsigned long time, unsigned long sectors)
+{
+	blkg->time += time;
+	blkg->sectors += sectors;
+}
+
 void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-				struct blkio_group *blkg, void *key)
+			struct blkio_group *blkg, void *key, dev_t dev)
 {
 	unsigned long flags;
 
@@ -37,6 +46,7 @@ void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 	/* Need to take css reference ? */
 	cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path));
 #endif
+	blkg->dev = dev;
 }
 
 static void __blkiocg_del_blkio_group(struct blkio_group *blkg)
@@ -115,12 +125,64 @@ blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 	return 0;
 }
 
+#define SHOW_FUNCTION_PER_GROUP(__VAR)					\
+static int blkiocg_##__VAR##_read(struct cgroup *cgroup,		\
+			struct cftype *cftype, struct seq_file *m)	\
+{									\
+	struct blkio_cgroup *blkcg;					\
+	struct blkio_group *blkg;					\
+	struct hlist_node *n;						\
+									\
+	if (!cgroup_lock_live_group(cgroup))				\
+		return -ENODEV;						\
+									\
+	blkcg = cgroup_to_blkio_cgroup(cgroup);				\
+	rcu_read_lock();						\
+	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {\
+		if (blkg->dev)						\
+			seq_printf(m, "%u:%u %lu\n", MAJOR(blkg->dev),	\
+				 MINOR(blkg->dev), blkg->__VAR);	\
+	}								\
+	rcu_read_unlock();						\
+	cgroup_unlock();						\
+	return 0;							\
+}
+
+SHOW_FUNCTION_PER_GROUP(time);
+SHOW_FUNCTION_PER_GROUP(sectors);
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+SHOW_FUNCTION_PER_GROUP(dequeue);
+#endif
+#undef SHOW_FUNCTION_PER_GROUP
+
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
+			unsigned long dequeue)
+{
+	blkg->dequeue += dequeue;
+}
+#endif
+
 struct cftype blkio_files[] = {
 	{
 		.name = "weight",
 		.read_u64 = blkiocg_weight_read,
 		.write_u64 = blkiocg_weight_write,
 	},
+	{
+		.name = "time",
+		.read_seq_string = blkiocg_time_read,
+	},
+	{
+		.name = "sectors",
+		.read_seq_string = blkiocg_sectors_read,
+	},
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+       {
+		.name = "dequeue",
+		.read_seq_string = blkiocg_dequeue_read,
+       },
+#endif
 };
 
 static int blkiocg_populate(struct cgroup_subsys *subsys, struct cgroup *cgroup)
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 3573199..b24ab71 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -30,7 +30,15 @@ struct blkio_group {
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	/* Store cgroup path */
 	char path[128];
+	/* How many times this group has been removed from service tree */
+	unsigned long dequeue;
 #endif
+	/* The device MKDEV(major, minor), this group has been created for */
+	dev_t   dev;
+
+	/* total disk time and nr sectors dispatched by this group */
+	unsigned long time;
+	unsigned long sectors;
 };
 
 #define BLKIO_WEIGHT_MIN	100
@@ -42,24 +50,30 @@ static inline char *blkg_path(struct blkio_group *blkg)
 {
 	return blkg->path;
 }
+void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
+				unsigned long dequeue);
 #else
 static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
+static inline void blkiocg_update_blkio_group_dequeue_stats(
+			struct blkio_group *blkg, unsigned long dequeue) {}
 #endif
 
 #ifdef CONFIG_BLK_CGROUP
 extern struct blkio_cgroup blkio_root_cgroup;
 extern struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
 extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-				struct blkio_group *blkg, void *key);
+			struct blkio_group *blkg, void *key, dev_t dev);
 extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
 extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
 						void *key);
+void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
+			unsigned long time, unsigned long sectors);
 #else
 static inline struct blkio_cgroup *
 cgroup_to_blkio_cgroup(struct cgroup *cgroup) { return NULL; }
 
 static inline void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-			struct blkio_group *blkg, void *key)
+			struct blkio_group *blkg, void *key, dev_t dev)
 {
 }
 
@@ -68,5 +82,9 @@ blkiocg_del_blkio_group(struct blkio_group *blkg) { return 0; }
 
 static inline struct blkio_group *
 blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key) { return NULL; }
+static inline void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
+			unsigned long time, unsigned long sectors)
+{
+}
 #endif
 #endif /* _BLK_CGROUP_H */
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 005a8ee..4e1c673 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -142,6 +142,8 @@ struct cfq_queue {
 	struct cfq_rb_root *service_tree;
 	struct cfq_queue *new_cfqq;
 	struct cfq_group *cfqg;
+	/* Sectors dispatched in current dispatch round */
+	unsigned long nr_sectors;
 };
 
 /*
@@ -832,6 +834,7 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	if (!RB_EMPTY_NODE(&cfqg->rb_node))
 		cfq_rb_erase(&cfqg->rb_node, st);
 	cfqg->saved_workload_slice = 0;
+	blkiocg_update_blkio_group_dequeue_stats(&cfqg->blkg, 1);
 }
 
 static inline unsigned long cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
@@ -858,12 +861,13 @@ static inline unsigned long cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
 			slice_used = allocated_slice;
 	}
 
-	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%lu", slice_used);
+	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%lu sect=%lu", slice_used,
+				cfqq->nr_sectors);
 	return slice_used;
 }
 
 static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
-				unsigned long service)
+				unsigned long service, unsigned long sectors)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 
@@ -883,6 +887,7 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 
 	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
 					st->min_vdisktime);
+	blkiocg_update_blkio_group_stats(&cfqg->blkg, service, sectors);
 }
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
@@ -900,6 +905,8 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	struct cfq_group *cfqg = NULL;
 	void *key = cfqd;
 	int i, j;
+	unsigned int major, minor;
+	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
 
 	/* Do we need to take this reference */
 	if (!css_tryget(&blkcg->css))
@@ -930,7 +937,9 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	atomic_set(&cfqg->ref, 1);
 
 	/* Add group onto cgroup list */
-	blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd);
+	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+	blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
+					MKDEV(major, minor));
 
 	/* Add group on cfqd list */
 	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
@@ -1467,6 +1476,7 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 		cfqq->dispatch_start = jiffies;
 		cfqq->slice_end = 0;
 		cfqq->slice_dispatch = 0;
+		cfqq->nr_sectors = 0;
 
 		cfq_clear_cfqq_wait_request(cfqq);
 		cfq_clear_cfqq_must_dispatch(cfqq);
@@ -1502,7 +1512,8 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfq_log_cfqq(cfqd, cfqq, "resid=%ld", cfqq->slice_resid);
 	}
 
-	cfq_group_served(cfqd, cfqq->cfqg, cfq_cfqq_slice_usage(cfqq));
+	cfq_group_served(cfqd, cfqq->cfqg, cfq_cfqq_slice_usage(cfqq),
+				cfqq->nr_sectors);
 
 	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
 		cfq_del_cfqq_rr(cfqd, cfqq);
@@ -1815,6 +1826,7 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 
 	if (cfq_cfqq_sync(cfqq))
 		cfqd->sync_flight++;
+	cfqq->nr_sectors += blk_rq_sectors(rq);
 }
 
 /*
@@ -3509,7 +3521,8 @@ static void *cfq_init_queue(struct request_queue *q)
 	 * to make sure that cfq_put_cfqg() does not try to kfree root group
 	 */
 	atomic_set(&cfqg->ref, 1);
-	blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg, (void *)cfqd);
+	blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg, (void *)cfqd,
+					0);
 #endif
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we
-- 
1.6.2.5

