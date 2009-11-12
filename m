Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbZKMBws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbZKMBws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 20:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZKMBwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 20:52:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbZKMBwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 20:52:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 11/16] blkio: Some debugging aids for CFQ
Date: Thu, 12 Nov 2009 18:32:31 -0500
Message-Id: <1258068756-10766-12-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1258068756-10766-1-git-send-email-vgoyal@redhat.com>
References: <1258068756-10766-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Some debugging aids for CFQ.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/Kconfig         |    9 +++++++++
 block/Kconfig.iosched |    9 +++++++++
 block/blk-cgroup.c    |    4 ++++
 block/blk-cgroup.h    |   13 +++++++++++++
 block/cfq-iosched.c   |   17 +++++++++++++++++
 5 files changed, 52 insertions(+), 0 deletions(-)

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
index fa95fa7..b71abfb 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -40,6 +40,15 @@ config CFQ_GROUP_IOSCHED
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
index 0426ab6..6bc99a3 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -33,6 +33,10 @@ void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
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
index cd50a2f..3573199 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -27,12 +27,25 @@ struct blkio_group {
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
 #ifdef CONFIG_BLK_CGROUP
 extern struct blkio_cgroup blkio_root_cgroup;
 extern struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index de21882..6b30a6b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -331,8 +331,21 @@ CFQ_CFQQ_FNS(sync);
 CFQ_CFQQ_FNS(coop);
 #undef CFQ_CFQQ_FNS
 
+#ifdef CONFIG_DEBUG_CFQ_IOSCHED
+#define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
+	blk_add_trace_msg((cfqd)->queue, "cfq%d%c %s " fmt, (cfqq)->pid, \
+			cfq_cfqq_sync((cfqq)) ? 'S' : 'A', \
+			blkg_path(&(cfqq)->cfqg->blkg), ##args);
+
+#define cfq_log_cfqg(cfqd, cfqg, fmt, args...)				\
+	blk_add_trace_msg((cfqd)->queue, "%s " fmt,			\
+				blkg_path(&(cfqg)->blkg), ##args);      \
+
+#else
 #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
 	blk_add_trace_msg((cfqd)->queue, "cfq%d " fmt, (cfqq)->pid, ##args)
+#define cfq_log_cfqg(cfqd, cfqg, fmt, args...)		do{}while(0);
+#endif
 #define cfq_log(cfqd, fmt, args...)	\
 	blk_add_trace_msg((cfqd)->queue, "cfq " fmt, ##args)
 
@@ -796,6 +809,7 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	if (cfqg->nr_cfqq)
 		return;
 
+	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
 	cfqg->on_st = false;
 	cfqd->nr_groups--;
 	if (!RB_EMPTY_NODE(&cfqg->rb_node))
@@ -849,6 +863,9 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 		cfqg->saved_serving_prio = cfqd->serving_prio;
 	} else
 		cfqg->saved_workload_slice = 0;
+
+	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
+					st->min_vdisktime);
 }
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
-- 
1.6.2.5

