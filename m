Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbZDGNqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbZDGNqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZDGNqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:46:08 -0400
Received: from lutt.itea.ntnu.no ([129.241.18.234]:47192 "EHLO
	lutt.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZDGNqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:46:07 -0400
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Apr 2009 09:46:06 EDT
From: Henrik Austad <henrik@austad.us>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Ziljstra <peterz@infradead.org>,
       Henrik Austad <henrik@austad.us>
Subject: [PATCH 1/2] sched: Move priority calculation into sched_class.
Date: Tue,  7 Apr 2009 15:36:12 +0200
Message-Id: <1239111373-12774-2-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1239111373-12774-1-git-send-email-henrik@austad.us>
References: <1239111373-12774-1-git-send-email-henrik@austad.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calculating the normal priority of a task, sched.c tested to see if the
task was an RT-task, before doing scheduling-class specific operations. 

By moving this into sched_class, the calculation becomes more modular, and 
the core scheduler becomes less aware of sched-class' internals.

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
index b94f354..6dc6591 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1014,6 +1014,7 @@ struct sched_class {
 			     int running);
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
 			     int oldprio, int running);
+	int (*normal_prio) (struct task_struct *task);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*moved_group) (struct task_struct *p);
diff --git a/kernel/sched.c b/kernel/sched.c
index 6cc1fd5..da13af5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1794,14 +1794,6 @@ static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
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
@@ -1810,13 +1802,7 @@ static inline int __normal_prio(struct task_struct *p)
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
index 299d012..ec966b7 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1671,6 +1671,11 @@ static void prio_changed_rt(struct rq *rq, struct task_struct *p,
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
@@ -1759,6 +1764,7 @@ static const struct sched_class rt_sched_class = {
 	.task_tick		= task_tick_rt,
 
 	.prio_changed		= prio_changed_rt,
+	.normal_prio		= normal_prio_rt,
 	.switched_to		= switched_to_rt,
 };
 
-- 
1.6.1

