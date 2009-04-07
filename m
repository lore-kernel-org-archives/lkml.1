Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbZDGNuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbZDGNuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZDGNuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:50:11 -0400
Received: from lutt.itea.ntnu.no ([129.241.18.234]:35578 "EHLO
	lutt.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZDGNuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:50:09 -0400
From: Henrik Austad <henrik@austad.us>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Ziljstra <peterz@infradead.org>,
       Henrik Austad <henrik@austad.us>
Subject: [PATCH 2/2] sched: Let sched_class handle effective_prio calculation
Date: Tue,  7 Apr 2009 15:36:13 +0200
Message-Id: <1239111373-12774-3-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1239111373-12774-2-git-send-email-henrik@austad.us>
References: <1239111373-12774-1-git-send-email-henrik@austad.us>
 <1239111373-12774-2-git-send-email-henrik@austad.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of testing for sched_class in the core scheduler, the calculation of the
class-specific effective priority should be handled by the scheduling class.

Signed-off-by: Henrik Austad <henrik@austad.us>
Acked-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sched.h   |    1 +
 kernel/sched.c          |   11 +++--------
 kernel/sched_fair.c     |    1 +
 kernel/sched_idletask.c |    1 +
 kernel/sched_rt.c       |    6 ++++++
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6dc6591..c98e912 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1015,6 +1015,7 @@ struct sched_class {
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
 			     int oldprio, int running);
 	int (*normal_prio) (struct task_struct *task);
+	int (*effective_prio) (struct task_struct *task);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*moved_group) (struct task_struct *p);
diff --git a/kernel/sched.c b/kernel/sched.c
index da13af5..5a6d4bd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1814,15 +1814,10 @@ static inline int normal_prio(struct task_struct *p)
  */
 static int effective_prio(struct task_struct *p)
 {
+	/* update normal prio */
 	p->normal_prio = normal_prio(p);
-	/*
-	 * If we are RT tasks or we were boosted to RT priority,
-	 * keep the priority unchanged. Otherwise, update priority
-	 * to the normal priority:
-	 */
-	if (!rt_prio(p->prio))
-		return p->normal_prio;
-	return p->prio;
+
+	return p->sched_class->effective_prio(p);
 }
 
 /*
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c94519a..42af406 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1822,6 +1822,7 @@ static const struct sched_class fair_sched_class = {
 
 	.prio_changed		= prio_changed_fair,
 	.normal_prio		= normal_prio_fair,
+	.effective_prio		= normal_prio_fair,
 	.switched_to		= switched_to_fair,
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index e52ae7c..675de4e 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -128,6 +128,7 @@ static const struct sched_class idle_sched_class = {
 
 	.prio_changed		= prio_changed_idle,
 	.normal_prio		= normal_prio_idle,
+	.effective_prio		= normal_prio_idle,
 	.switched_to		= switched_to_idle,
 
 	/* no .task_new for idle tasks */
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index ec966b7..6426ced 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1676,6 +1676,11 @@ static int normal_prio_rt(struct task_struct *p)
 	return MAX_RT_PRIO-1 - p->rt_priority;
 }
 
+static int effective_prio_rt(struct task_struct *p)
+{
+	return p->prio;
+}
+
 static void watchdog(struct rq *rq, struct task_struct *p)
 {
 	unsigned long soft, hard;
@@ -1765,6 +1770,7 @@ static const struct sched_class rt_sched_class = {
 
 	.prio_changed		= prio_changed_rt,
 	.normal_prio		= normal_prio_rt,
+	.effective_prio		= effective_prio_rt,
 	.switched_to		= switched_to_rt,
 };
 
-- 
1.6.1

