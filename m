Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbZDTNy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbZDTNy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 09:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbZDTNyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 09:54:47 -0400
Received: from lutt.itea.ntnu.no ([129.241.18.234]:59309 "EHLO
	lutt.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617AbZDTNyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 09:54:46 -0400
From: Henrik Austad <henrik@austad.us>
To: Ingo Molnar <mingo@elte.hu>
Cc: --compose@medea.austad.us, --dry-run@medea.austad.us
Message-Id: <20090420135554.2A5852141A1@medea.austad.us>
Date: Mon, 20 Apr 2009 15:55:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LKML <linux-kernel@vger.kernel.org>, Peter Ziljstra <peterz@infradead.org>, Henrik Austad <henrik@austad.us>
Subject: [PATCH 2/2] sched: Let sched_class handle effective_prio calculation
Date: Mon, 20 Apr 2009 15:55:53 +0200
Message-Id: <1240235753-1180-2-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.6.1.2
In-Reply-To: <1240235753-1180-1-git-send-email-henrik@austad.us>
References: <1240235753-1180-1-git-send-email-henrik@austad.us>

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
index f16db27..f5e3ee9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1019,6 +1019,7 @@ struct sched_class {
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
 			     int oldprio, int running);
 	int (*normal_prio) (struct task_struct *task);
+	int (*effective_prio) (struct task_struct *task);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*moved_group) (struct task_struct *p);
diff --git a/kernel/sched.c b/kernel/sched.c
index d78c84e..d388641 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1826,15 +1826,10 @@ static inline int normal_prio(struct task_struct *p)
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
index 5c9a8f1..87390a9 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1669,6 +1669,11 @@ static int normal_prio_rt(struct task_struct *p)
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
@@ -1758,6 +1763,7 @@ static const struct sched_class rt_sched_class = {
 
 	.prio_changed		= prio_changed_rt,
 	.normal_prio		= normal_prio_rt,
+	.effective_prio		= effective_prio_rt,
 	.switched_to		= switched_to_rt,
 };
 
-- 
1.6.1.2

