Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbYJXKBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbYJXKBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 06:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbYJXJ6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:58:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44858 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbYJXJ6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:58:53 -0400
Message-Id: <20081024091109.998783999@chello.nl>
References: <20081024090611.936552213@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 24 Oct 2008 11:06:19 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, efault@gmx.de, vatsa@in.ibm.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 8/8] use avg_vruntime for task placement
Content-Disposition: inline; filename=sched-placement.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to use the avg_vruntime for task placement.

The pro: its the 'fair' place to insert tasks.
The con: its an extra division.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c          |    9 +++++++--
 kernel/sched_fair.c     |    7 ++++++-
 kernel/sched_features.h |    1 +
 3 files changed, 14 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1847,8 +1847,13 @@ void set_task_cpu(struct task_struct *p,
 			schedstat_inc(p, se.nr_forced2_migrations);
 	}
 #endif
-	p->se.vruntime -= old_cfsrq->min_vruntime -
-					 new_cfsrq->min_vruntime;
+	if (sched_feat(AVG_VRUNTIME)) {
+		p->se.vruntime -=
+			avg_vruntime(old_cfsrq) - avg_vruntime(new_cfsrq);
+	} else {
+		p->se.vruntime -=
+			old_cfsrq->min_vruntime - new_cfsrq->min_vruntime;
+	}
 
 	__set_task_cpu(p, new_cpu);
 }
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -719,7 +719,12 @@ static void check_spread(struct cfs_rq *
 static void
 place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 {
-	u64 vruntime = cfs_rq->min_vruntime;
+	u64 vruntime;
+
+	if (sched_feat(AVG_VRUNTIME))
+		vruntime = avg_vruntime(cfs_rq);
+	else
+		vruntime = cfs_rq->min_vruntime;
 
 	/*
 	 * The 'current' period is already promised to the current tasks,
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -11,4 +11,5 @@ SCHED_FEAT(ASYM_GRAN, 1)
 SCHED_FEAT(LB_BIAS, 1)
 SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
+SCHED_FEAT(AVG_VRUNTIME, 0)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)

-- 

