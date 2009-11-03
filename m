Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbZKCXrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbZKCXrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZKCXrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:47:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493AbZKCXoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 05/20] blkio: Introduce the notion of cfq groups
Date: Tue,  3 Nov 2009 18:43:42 -0500
Message-Id: <1257291837-6246-6-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o This is first step in introducing cfq groups. Currently we define only
  on cfq_group (root cfq group) which is embedded in cfq_data.

o Down the line, each cfq_group will have its own service tree. Hence move
  the service tree from cfqd to root group so that it becomes property of
  group.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 922aa8e..323ed12 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -136,16 +136,17 @@ struct cfq_queue {
 	pid_t pid;
 };
 
+/* Per cgroup grouping structure */
+struct cfq_group {
+	struct cfq_sched_data sched_data;
+};
+
 /*
  * Per block device queue structure
  */
 struct cfq_data {
 	struct request_queue *queue;
-
-	/*
-	 * rr list of queues with requests and the count of them
-	 */
-	struct cfq_sched_data sched_data;
+	struct cfq_group root_group;
 
 	/*
 	 * Each priority tree is sorted by next_request position.  These
@@ -270,7 +271,7 @@ init_cfqe_service_tree(struct cfq_data *cfqd, struct cfq_entity *cfqe)
 
 	BUG_ON(idx >= IO_IOPRIO_CLASSES);
 
-	cfqe->st = &cfqd->sched_data.service_tree[idx];
+	cfqe->st = &cfqd->root_group.sched_data.service_tree[idx];
 }
 
 static inline s64
@@ -1160,7 +1161,7 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 	if (!cfqd->rq_queued)
 		return NULL;
 
-	cfqe = cfq_get_next_entity(&cfqd->sched_data);
+	cfqe = cfq_get_next_entity(&cfqd->root_group.sched_data);
 
 	if (cfqe)
 		return cfqq_of(cfqe);
@@ -2700,6 +2701,15 @@ static void cfq_put_async_queues(struct cfq_data *cfqd)
 		cfq_put_queue(cfqd->async_idle_cfqq);
 }
 
+static void cfq_init_root_group(struct cfq_data *cfqd)
+{
+	struct cfq_group *cfqg = &cfqd->root_group;
+	int i;
+
+	for (i = 0; i < IO_IOPRIO_CLASSES; i++)
+		cfqg->sched_data.service_tree[i] = CFQ_RB_ROOT;
+}
+
 static void cfq_exit_queue(struct elevator_queue *e)
 {
 	struct cfq_data *cfqd = e->elevator_data;
@@ -2738,8 +2748,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	if (!cfqd)
 		return NULL;
 
-	for (i = 0; i < IO_IOPRIO_CLASSES; i++)
-		cfqd->sched_data.service_tree[i] = CFQ_RB_ROOT;
+	cfq_init_root_group(cfqd);
 
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we
-- 
1.6.2.5

