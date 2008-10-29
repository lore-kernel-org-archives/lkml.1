Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbYJ2JGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbYJ2JGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 05:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYJ2JGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 05:06:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57187 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbYJ2JGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 05:06:16 -0400
Message-ID: <490826DA.2060802@cn.fujitsu.com>
Date: Wed, 29 Oct 2008 17:03:22 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: cleanup for alloc_rt/fair_sched_group()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove checking parent == NULL. It won't be NULLL, because we dynamically
create sub task_group only, and sub task_group always has its parent.
(root task_group is statically defined)

Also replace kmalloc_node(GFP_ZERO) with kzalloc_node().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e8819bc..7dd6c86 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8472,7 +8472,7 @@ static
 int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	struct cfs_rq *cfs_rq;
-	struct sched_entity *se, *parent_se;
+	struct sched_entity *se;
 	struct rq *rq;
 	int i;
 
@@ -8488,18 +8488,17 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
 
-		cfs_rq = kmalloc_node(sizeof(struct cfs_rq),
-				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
+		cfs_rq = kzalloc_node(sizeof(struct cfs_rq),
+				      GFP_KERNEL, cpu_to_node(i));
 		if (!cfs_rq)
 			goto err;
 
-		se = kmalloc_node(sizeof(struct sched_entity),
-				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
+		se = kzalloc_node(sizeof(struct sched_entity),
+				  GFP_KERNEL, cpu_to_node(i));
 		if (!se)
 			goto err;
 
-		parent_se = parent ? parent->se[i] : NULL;
-		init_tg_cfs_entry(tg, cfs_rq, se, i, 0, parent_se);
+		init_tg_cfs_entry(tg, cfs_rq, se, i, 0, parent->se[i]);
 	}
 
 	return 1;
@@ -8560,7 +8559,7 @@ static
 int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	struct rt_rq *rt_rq;
-	struct sched_rt_entity *rt_se, *parent_se;
+	struct sched_rt_entity *rt_se;
 	struct rq *rq;
 	int i;
 
@@ -8577,18 +8576,17 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
 
-		rt_rq = kmalloc_node(sizeof(struct rt_rq),
-				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
+		rt_rq = kzalloc_node(sizeof(struct rt_rq),
+				     GFP_KERNEL, cpu_to_node(i));
 		if (!rt_rq)
 			goto err;
 
-		rt_se = kmalloc_node(sizeof(struct sched_rt_entity),
-				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
+		rt_se = kzalloc_node(sizeof(struct sched_rt_entity),
+				     GFP_KERNEL, cpu_to_node(i));
 		if (!rt_se)
 			goto err;
 
-		parent_se = parent ? parent->rt_se[i] : NULL;
-		init_tg_rt_entry(tg, rt_rq, rt_se, i, 0, parent_se);
+		init_tg_rt_entry(tg, rt_rq, rt_se, i, 0, parent->rt_se[i]);
 	}
 
 	return 1;
-- 
1.5.4.rc3

