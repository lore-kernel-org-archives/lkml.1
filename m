Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbZKCXo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbZKCXo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbZKCXo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:44:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbZKCXox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 11/20] blkio: Some CFQ debugging Aid
Date: Tue,  3 Nov 2009 18:43:48 -0500
Message-Id: <1257291837-6246-12-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Some CFQ debugging Aid.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/Kconfig         |    9 +++++++++
 block/Kconfig.iosched |    9 +++++++++
 block/blk-cgroup.c    |    4 ++++
 block/blk-cgroup.h    |   13 +++++++++++++
 block/cfq-iosched.c   |   33 +++++++++++++++++++++++++++++++++
 5 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 6ba1a8e..e20fbde 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -90,6 +90,15 @@ config BLK_CGROUP
 	control disk bandwidth allocation (proportional time slice allocation)
 	to such task groups.
 
+config DEBUG_BLK_CGROUP
+	bool
+	depends on BLK_CGROUP
+	default n
+	---help---
+	Enable some debugging help. Currently it stores the cgroup path
+	in the blk group which can be used by cfq for tracing various
+	group related activity.
+
 endif # BLOCK
 
 config BLOCK_COMPAT
diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index a521c69..9c5f0b5 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -48,6 +48,15 @@ config CFQ_GROUP_IOSCHED
 	---help---
 	  Enable group IO scheduling in CFQ.
 
+config DEBUG_CFQ_IOSCHED
+	bool "Debug CFQ Scheduling"
+	depends on CFQ_GROUP_IOSCHED
+	select DEBUG_BLK_CGROUP
+	default n
+	---help---
+	  Enable CFQ IO scheduling debugging in CFQ. Currently it makes
+	  blktrace output more verbose.
+
 choice
 	prompt "Default I/O scheduler"
 	default DEFAULT_CFQ
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index a62b8a3..4c68682 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -39,6 +39,10 @@ void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 	blkg->blkcg_id = css_id(&blkcg->css);
 	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
 	spin_unlock_irqrestore(&blkcg->lock, flags);
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+	/* Need to take css reference ? */
+	cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path));
+#endif
 }
 
 static void __blkiocg_del_blkio_group(struct blkio_group *blkg)
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 2bf736b..cb72c35 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -26,12 +26,25 @@ struct blkio_group {
 	void *key;
 	struct hlist_node blkcg_node;
 	unsigned short blkcg_id;
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+	/* Store cgroup path */
+	char path[128];
+#endif
 };
 
 #define BLKIO_WEIGHT_MIN	100
 #define BLKIO_WEIGHT_MAX	1000
 #define BLKIO_WEIGHT_DEFAULT	500
 
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+static inline char *blkg_path(struct blkio_group *blkg)
+{
+	return blkg->path;
+}
+#else
+static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
+#endif
+
 extern struct blkio_cgroup blkio_root_cgroup;
 struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
 void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b9a052b..2fde3c4 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -258,8 +258,29 @@ CFQ_CFQQ_FNS(sync);
 CFQ_CFQQ_FNS(coop);
 #undef CFQ_CFQQ_FNS
 
+#ifdef CONFIG_DEBUG_CFQ_IOSCHED
+#define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
+	blk_add_trace_msg((cfqd)->queue, "cfq%d%c %s " fmt, (cfqq)->pid, \
+			cfq_cfqq_sync((cfqq)) ? 'S' : 'A', \
+			blkg_path(&cfqq_to_cfqg((cfqq))->blkg), ##args);
+
+#define cfq_log_cfqe(cfqd, cfqe, fmt, args...)			\
+	if (cfqq_of(cfqe)) {						\
+		struct cfq_queue *cfqq = cfqq_of(cfqe);			\
+		blk_add_trace_msg((cfqd)->queue, "cfq%d%c %s " fmt,	\
+			(cfqq)->pid, cfq_cfqq_sync((cfqq)) ? 'S' : 'A', \
+			blkg_path(&cfqq_to_cfqg((cfqq))->blkg), ##args);\
+	} else {							\
+		struct cfq_group *cfqg = cfqg_of(cfqe);			\
+		blk_add_trace_msg((cfqd)->queue, "%s " fmt, 		\
+				blkg_path(&(cfqg)->blkg), ##args);	\
+	}
+#else
 #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
 	blk_add_trace_msg((cfqd)->queue, "cfq%d " fmt, (cfqq)->pid, ##args)
+#define cfq_log_cfqe(cfqd, cfqe, fmt, args...)
+#endif
+
 #define cfq_log(cfqd, fmt, args...)	\
 	blk_add_trace_msg((cfqd)->queue, "cfq " fmt, ##args)
 
@@ -400,6 +421,8 @@ cfq_init_cfqe_parent(struct cfq_entity *cfqe, struct cfq_entity *p_cfqe)
 #define for_each_entity(entity)	\
 	for (; entity && entity->parent; entity = entity->parent)
 
+#define cfqe_is_cfqq(cfqe)     (!(cfqe)->my_sd)
+
 static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
 {
 	if (blkg)
@@ -588,6 +611,8 @@ void cfq_delink_blkio_group(void *key, struct blkio_group *blkg)
 #define for_each_entity(entity)	\
 	for (; entity != NULL; entity = NULL)
 
+#define cfqe_is_cfqq(cfqe)     1
+
 static void cfq_release_cfq_groups(struct cfq_data *cfqd) {}
 static inline void cfq_get_cfqg_ref(struct cfq_group *cfqg) {}
 static inline void cfq_put_cfqg(struct cfq_group *cfqg) {}
@@ -885,6 +910,10 @@ static void dequeue_cfqq(struct cfq_queue *cfqq)
 		struct cfq_sched_data *sd = cfq_entity_sched_data(cfqe);
 
 		dequeue_cfqe(cfqe);
+		if (!cfqe_is_cfqq(cfqe)) {
+			cfq_log_cfqe(cfqq->cfqd, cfqe, "del_from_rr group");
+		}
+
 		/* Do not dequeue parent if it has other entities under it */
 		if (sd->nr_active)
 			break;
@@ -970,6 +999,8 @@ static void requeue_cfqq(struct cfq_queue *cfqq, int add_front)
 
 static void cfqe_served(struct cfq_entity *cfqe, unsigned long served)
 {
+	struct cfq_data *cfqd = cfqq_of(cfqe)->cfqd;
+
 	for_each_entity(cfqe) {
 		/*
 		 * Can't update entity disk time while it is on sorted rb-tree
@@ -979,6 +1010,8 @@ static void cfqe_served(struct cfq_entity *cfqe, unsigned long served)
 		cfqe->vdisktime += cfq_delta_fair(served, cfqe);
 		update_min_vdisktime(cfqe->st);
 		__enqueue_cfqe(cfqe->st, cfqe, 0);
+		cfq_log_cfqe(cfqd, cfqe, "served: vt=%llx min_vt=%llx",
+				cfqe->vdisktime, cfqe->st->min_vdisktime);
 
 		/* If entity prio class has changed, take that into account */
 		if (unlikely(cfqe->ioprio_class_changed)) {
-- 
1.6.2.5

