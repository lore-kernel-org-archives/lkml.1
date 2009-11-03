Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbZKCXo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbZKCXo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZKCXoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:44:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbZKCXow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:52 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 13/20] blkio: Add a group dequeue interface in cgroup for debugging
Date: Tue,  3 Nov 2009 18:43:50 -0500
Message-Id: <1257291837-6246-14-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o "dequeue" is a debugging interface which keeps track how many times a group
  was dequeued from service tree. This helps if a group is not getting its
  fair share.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c  |   17 +++++++++++++++++
 block/blk-cgroup.h  |    6 ++++++
 block/cfq-iosched.c |    6 ++++++
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 47c0ce7..6a46156 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -182,8 +182,19 @@ static int blkiocg_##__VAR##_read(struct cgroup *cgroup,		\
 
 SHOW_FUNCTION_PER_GROUP(time);
 SHOW_FUNCTION_PER_GROUP(sectors);
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+SHOW_FUNCTION_PER_GROUP(dequeue);
+#endif
 #undef SHOW_FUNCTION_PER_GROUP
 
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
@@ -203,6 +214,12 @@ struct cftype blkio_files[] = {
 		.name = "sectors",
 		.read_seq_string = blkiocg_sectors_read,
 	},
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+       {
+		.name = "dequeue",
+		.read_seq_string = blkiocg_dequeue_read,
+       },
+#endif
 };
 
 static int blkiocg_populate(struct cgroup_subsys *subsys, struct cgroup *cgroup)
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 08f4ef8..4ca101d 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -29,6 +29,8 @@ struct blkio_group {
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	/* Store cgroup path */
 	char path[128];
+	/* How many times this group has been removed from service tree */
+	unsigned long dequeue;
 #endif
 	/* The device MKDEV(major, minor), this group has been created for */
 	dev_t   dev;
@@ -47,8 +49,12 @@ static inline char *blkg_path(struct blkio_group *blkg)
 {
 	return blkg->path;
 }
+void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
+			unsigned long dequeue);
 #else
 static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
+static inline void blkiocg_update_blkio_group_dequeue_stats(
+			struct blkio_group *blkg, unsigned long dequeue) {}
 #endif
 
 extern struct blkio_cgroup blkio_root_cgroup;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 21d487f..6936519 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -921,6 +921,12 @@ static void dequeue_cfqe(struct cfq_entity *cfqe)
 	__dequeue_cfqe(st, cfqe);
 	sd->nr_active--;
 	cfqe->on_st = 0;
+
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	if (!cfqe_is_cfqq(cfqe))
+		blkiocg_update_blkio_group_dequeue_stats(&cfqg_of(cfqe)->blkg,
+				1);
+#endif
 }
 
 static void dequeue_cfqq(struct cfq_queue *cfqq)
-- 
1.6.2.5

