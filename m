Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbZKCXpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbZKCXpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZKCXo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:44:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbZKCXoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:55 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 12/20] blkio: Export disk time and sectors dispatched from cgroup interface
Date: Tue,  3 Nov 2009 18:43:49 -0500
Message-Id: <1257291837-6246-13-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c  |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
 block/blk-cgroup.h  |   10 +++++++++-
 block/cfq-iosched.c |   29 +++++++++++++++++++++++++++--
 3 files changed, 82 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4c68682..47c0ce7 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -11,6 +11,8 @@
  * 	              Nauman Rafique <nauman@google.com>
  */
 #include <linux/ioprio.h>
+#include <linux/seq_file.h>
+#include <linux/kdev_t.h>
 #include "blk-cgroup.h"
 
 extern void cfq_update_blkio_group_weight(struct blkio_group *, unsigned int);
@@ -29,8 +31,15 @@ struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
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
 
@@ -43,6 +52,7 @@ void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 	/* Need to take css reference ? */
 	cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path));
 #endif
+	blkg->dev = dev;
 }
 
 static void __blkiocg_del_blkio_group(struct blkio_group *blkg)
@@ -147,6 +157,33 @@ static int blkiocg_ioprio_class_write(struct cgroup *cgroup,
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
+#undef SHOW_FUNCTION_PER_GROUP
+
 struct cftype blkio_files[] = {
 	{
 		.name = "weight",
@@ -158,6 +195,14 @@ struct cftype blkio_files[] = {
 		.read_u64 = blkiocg_ioprio_class_read,
 		.write_u64 = blkiocg_ioprio_class_write,
 	},
+	{
+		.name = "time",
+		.read_seq_string = blkiocg_time_read,
+	},
+	{
+		.name = "sectors",
+		.read_seq_string = blkiocg_sectors_read,
+	},
 };
 
 static int blkiocg_populate(struct cgroup_subsys *subsys, struct cgroup *cgroup)
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index cb72c35..08f4ef8 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -30,6 +30,12 @@ struct blkio_group {
 	/* Store cgroup path */
 	char path[128];
 #endif
+	/* The device MKDEV(major, minor), this group has been created for */
+	dev_t   dev;
+
+	/* total disk time and nr sectors dispatched by this group */
+	unsigned long time;
+	unsigned long sectors;
 };
 
 #define BLKIO_WEIGHT_MIN	100
@@ -48,6 +54,8 @@ static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
 extern struct blkio_cgroup blkio_root_cgroup;
 struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
 void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-				struct blkio_group *blkg, void *key);
+				struct blkio_group *blkg, void *key, dev_t dev);
 int blkiocg_del_blkio_group(struct blkio_group *blkg);
 struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key);
+void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
+			unsigned long time, unsigned long sectors);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 2fde3c4..21d487f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -137,6 +137,8 @@ struct cfq_queue {
 	unsigned short org_ioprio_class;
 
 	pid_t pid;
+	/* Sectors dispatched in current dispatch round */
+	unsigned long nr_sectors;
 };
 
 /* Per cgroup grouping structure */
@@ -462,6 +464,8 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
 	struct cfq_group *cfqg = NULL;
 	void *key = cfqd;
+	unsigned int major, minor;
+	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
 
 	/* Do we need to take this reference */
 	if (!css_tryget(&blkcg->css))
@@ -488,7 +492,9 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	cfq_get_cfqg_ref(cfqg);
 
 	/* Add group onto cgroup list */
-	blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd);
+	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+	blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
+					MKDEV(major, minor));
 
 	/* Add group on cfqd list */
 	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
@@ -607,6 +613,18 @@ void cfq_delink_blkio_group(void *key, struct blkio_group *blkg)
 	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
 }
 
+static void cfq_update_cfqq_stats(struct cfq_queue *cfqq,
+				unsigned long slice_used)
+{
+	struct cfq_entity *cfqe = &cfqq->entity;
+
+	for_each_entity(cfqe) {
+		struct cfq_group *cfqg = cfqg_of(parent_entity(cfqe));
+		blkiocg_update_blkio_group_stats(&cfqg->blkg, slice_used,
+					cfqq->nr_sectors);
+	}
+}
+
 #else /* CONFIG_CFQ_GROUP_IOSCHED */
 #define for_each_entity(entity)	\
 	for (; entity != NULL; entity = NULL)
@@ -639,6 +657,9 @@ static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
 {
 	return &cfqd->root_group;
 }
+
+static inline void cfq_update_cfqq_stats(struct cfq_queue *cfqq,
+				unsigned long slice_used) {}
 #endif /* CONFIG_CFQ_GROUP_IOSCHED */
 
 static inline int rq_in_driver(struct cfq_data *cfqd)
@@ -1380,6 +1401,7 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 		cfqq->slice_start = 0;
 		cfqq->slice_end = 0;
 		cfqq->slice_dispatch = 0;
+		cfqq->nr_sectors = 0;
 
 		cfq_clear_cfqq_wait_request(cfqq);
 		cfq_clear_cfqq_must_dispatch(cfqq);
@@ -1418,6 +1440,7 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 		slice_used = jiffies - cfqq->slice_start;
 
 	cfq_log_cfqq(cfqd, cfqq, "sl_used=%ld", slice_used);
+	cfq_update_cfqq_stats(cfqq, slice_used);
 
 	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
 		cfq_del_cfqq_rr(cfqd, cfqq);
@@ -1688,6 +1711,7 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 
 	if (cfq_cfqq_sync(cfqq))
 		cfqd->sync_flight++;
+	cfqq->nr_sectors += blk_rq_sectors(rq);
 }
 
 /*
@@ -3062,7 +3086,8 @@ static void cfq_init_root_group(struct cfq_data *cfqd)
 	 * to make sure that cfq_put_cfqg() does not try to kfree root group
 	 */
 	cfq_get_cfqg_ref(cfqg);
-	blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg, (void *)cfqd);
+	blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg, (void *)cfqd,
+					0);
 #endif
 }
 
-- 
1.6.2.5

