Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbZDTNyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbZDTNyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 09:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbZDTNye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 09:54:34 -0400
Received: from lutt.itea.ntnu.no ([129.241.18.234]:59263 "EHLO
	lutt.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbZDTNyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 09:54:33 -0400
From: Henrik Austad <henrik@austad.us>
To: Ingo Molnar <mingo@elte.hu>
Cc: --compose@medea.austad.us, --dry-run@medea.austad.us
Message-Id: <20090420135554.0FE7B2141A4@medea.austad.us>
Date: Mon, 20 Apr 2009 15:55:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LKML <linux-kernel@vger.kernel.org>, Peter Ziljstra <peterz@infradead.org>, Henrik Austad <henrik@austad.us>
Subject: [PATCH 1/2] sched: Move priority calculation into sched_class.
Date: Mon, 20 Apr 2009 15:55:52 +0200
Message-Id: <1240235753-1180-1-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.6.1.2

When calculating the normal priority of a task, sched.c tested to see if the
task was an RT-task, or other. By moving this into sched_class, the calculation
becomes more modular, and the core scheduler becomes less aware of sched-class'
internals.

Signed-off-by: Henrik Austad <henrik@austad.us>
Acked-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sched.h   |    1 +
 kernel/sched.c          |   16 +---------------
 kernel/sched_fair.c     |    7 +++++++
 kernel/sched_idletask.c |    6 ++++++
 kernel/sched_rt.c       |    6 ++++++
 5 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b4c38bc..f16db27 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1018,6 +1018,7 @@ struct sched_class {
 			     int running);
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
 			     int oldprio, int running);
+	int (*normal_prio) (struct task_struct *task);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*moved_group) (struct task_struct *p);
diff --git a/kernel/sched.c b/kernel/sched.c
index b902e58..d78c84e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1806,14 +1806,6 @@ static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 }
 
 /*
- * __normal_prio - return the priority that is based on the static prio
- */
-static inline int __normal_prio(struct task_struct *p)
-{
-	return p->static_prio;
-}
-
-/*
  * Calculate the expected normal priority: i.e. priority
  * without taking RT-inheritance into account. Might be
  * boosted by interactivity modifiers. Changes upon fork,
@@ -1822,13 +1814,7 @@ static inline int __normal_prio(struct task_struct *p)
  */
 static inline int normal_prio(struct task_struct *p)
 {
-	int prio;
-
-	if (task_has_rt_policy(p))
-		prio = MAX_RT_PRIO-1 - p->rt_priority;
-	else
-		prio = __normal_prio(p);
-	return prio;
+	return p->sched_class->normal_prio(p);
 }
 
 /*
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3816f21..c94519a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1749,6 +1749,12 @@ static void prio_changed_fair(struct rq *rq, struct task_struct *p,
 		check_preempt_curr(rq, p, 0);
 }
 
+/* Return the expected, normal priority */
+static int normal_prio_fair(struct task_struct *p)
+{
+	return p->static_prio;
+}
+
 /*
  * We switched to the sched_fair class.
  */
@@ -1815,6 +1821,7 @@ static const struct sched_class fair_sched_class = {
 	.task_new		= task_new_fair,
 
 	.prio_changed		= prio_changed_fair,
+	.normal_prio		= normal_prio_fair,
 	.switched_to		= switched_to_fair,
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 8a21a2e..e52ae7c 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -96,6 +96,11 @@ static void prio_changed_idle(struct rq *rq, struct task_struct *p,
 		check_preempt_curr(rq, p, 0);
 }
 
+static int normal_prio_idle(struct task_struct *p)
+{
+	return p->static_prio;
+}
+
 /*
  * Simple, special scheduling class for the per-CPU idle tasks:
  */
@@ -122,6 +127,7 @@ static const struct sched_class idle_sched_class = {
 	.task_tick		= task_tick_idle,
 
 	.prio_changed		= prio_changed_idle,
+	.normal_prio		= normal_prio_idle,
 	.switched_to		= switched_to_idle,
 
 	/* no .task_new for idle tasks */
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index f2c66f8..5c9a8f1 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1664,6 +1664,11 @@ static void prio_changed_rt(struct rq *rq, struct task_struct *p,
 	}
 }
 
+static int normal_prio_rt(struct task_struct *p)
+{
+	return MAX_RT_PRIO-1 - p->rt_priority;
+}
+
 static void watchdog(struct rq *rq, struct task_struct *p)
 {
 	unsigned long soft, hard;
@@ -1752,6 +1757,7 @@ static const struct sched_class rt_sched_class = {
 	.task_tick		= task_tick_rt,
 
 	.prio_changed		= prio_changed_rt,
+	.normal_prio		= normal_prio_rt,
 	.switched_to		= switched_to_rt,
 };
 
-- 
1.6.1.2

