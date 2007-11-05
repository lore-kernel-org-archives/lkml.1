Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbXKFAxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbXKFAxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 19:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbXKFAul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 19:50:41 -0500
Received: from nds154-200.nds.lab.novell.com ([151.155.154.200]:25189 "EHLO
	lsg.lab.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755551AbXKFAue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 19:50:34 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 7/8] RT: Optimize rebalancing
To: rostedt@goodmis.org
Cc: mingo@elte.hu, dvhltc@us.ibm.com, zijlstra@redhat.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       ghaskins@novell.com
Date: Mon, 05 Nov 2007 16:49:08 -0700
Message-ID: <20071105234908.25451.67301.stgit@lsg>
In-Reply-To: <20071105234832.25451.55430.stgit@lsg>
References: <20071105234832.25451.55430.stgit@lsg>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We have logic to detect whether the system has migratable tasks, but we are
not using it when deciding whether to push tasks away.  So we add support
for considering this new information.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c    |    2 ++
 kernel/sched_rt.c |   10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8a27f09..0eced8c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -268,6 +268,7 @@ struct rt_rq {
 	unsigned long rt_nr_uninterruptible;
 	/* highest queued rt task prio */
 	int highest_prio;
+	int overloaded;
 };
 
 /*
@@ -6869,6 +6870,7 @@ void __init sched_init(void)
 		rq->migration_thread = NULL;
 		INIT_LIST_HEAD(&rq->migration_queue);
 		rq->rt.highest_prio = MAX_RT_PRIO;
+		rq->rt.overloaded = 0;
 #endif
 		atomic_set(&rq->nr_iowait, 0);
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 6ba5921..698f4d9 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -28,10 +28,12 @@ static inline cpumask_t *rt_overload(struct rq *rq)
 static inline void rt_set_overload(struct rq *rq)
 {
 	cpu_set(rq->cpu, *rt_overload_mask(rq->cpu));
+	rq->rt.overloaded = 1;
 }
 static inline void rt_clear_overload(struct rq *rq)
 {
 	cpu_clear(rq->cpu, *rt_overload_mask(rq->cpu));
+	rq->rt.overloaded = 0;
 }
 
 static void update_rt_migration(struct task_struct *p, struct rq *rq)
@@ -496,6 +498,9 @@ static int push_rt_task(struct rq *rq)
 
 	assert_spin_locked(&rq->lock);
 
+	if (!rq->rt.overloaded)
+		return 0;
+
 	next_task = pick_next_highest_task_rt(rq, -1);
 	if (!next_task)
 		return 0;
@@ -737,7 +742,7 @@ static void schedule_tail_balance_rt(struct rq *rq)
 	 * the lock was owned by prev, we need to release it
 	 * first via finish_lock_switch and then reaquire it here.
 	 */
-	if (unlikely(rq->rt.rt_nr_running > 1)) {
+	if (unlikely(rq->rt.overloaded)) {
 		spin_lock(&rq->lock);
 		push_rt_tasks(rq);
 		schedstat_inc(rq, rto_schedule_tail);
@@ -749,7 +754,8 @@ static void wakeup_balance_rt(struct rq *rq, struct task_struct *p)
 {
 	if (unlikely(rt_task(p)) &&
 	    !task_running(rq, p) &&
-	    (p->prio >= rq->curr->prio)) {
+	    (p->prio >= rq->rt.highest_prio) &&
+	    rq->rt.overloaded) {
 		push_rt_tasks(rq);
 		schedstat_inc(rq, rto_wakeup);
 	}

