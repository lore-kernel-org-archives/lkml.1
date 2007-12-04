Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbXLDVMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbXLDVMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbXLDVHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:07:45 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53481
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755023AbXLDVHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:07:41 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 15/23] Subject: SCHED - Optimize rebalancing
To: mingo@elte.hu
Cc: rostedt@goodmis.org, ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2007 15:45:41 -0500
Message-ID: <20071204204541.3567.46150.stgit@novell1.haskins.net>
In-Reply-To: <20071204204236.3567.65491.stgit@novell1.haskins.net>
References: <20071204204236.3567.65491.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have logic to detect whether the system has migratable tasks, but we are
not using it when deciding whether to push tasks away.  So we add support
for considering this new information.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched.c    |    2 ++
 kernel/sched_rt.c |   10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 651270e..ed031bd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -273,6 +273,7 @@ struct rt_rq {
 	unsigned long rt_nr_migratory;
 	/* highest queued rt task prio */
 	int highest_prio;
+	int overloaded;
 };
 
 /*
@@ -6692,6 +6693,7 @@ void __init sched_init(void)
 		rq->migration_thread = NULL;
 		INIT_LIST_HEAD(&rq->migration_queue);
 		rq->rt.highest_prio = MAX_RT_PRIO;
+		rq->rt.overloaded = 0;
 #endif
 		atomic_set(&rq->nr_iowait, 0);
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 67daa66..19db3a9 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -16,6 +16,7 @@ static inline cpumask_t *rt_overload(void)
 }
 static inline void rt_set_overload(struct rq *rq)
 {
+	rq->rt.overloaded = 1;
 	cpu_set(rq->cpu, rt_overload_mask);
 	/*
 	 * Make sure the mask is visible before we set
@@ -32,6 +33,7 @@ static inline void rt_clear_overload(struct rq *rq)
 	/* the order here really doesn't matter */
 	atomic_dec(&rto_count);
 	cpu_clear(rq->cpu, rt_overload_mask);
+	rq->rt.overloaded = 0;
 }
 
 static void update_rt_migration(struct rq *rq)
@@ -446,6 +448,9 @@ static int push_rt_task(struct rq *rq)
 
 	assert_spin_locked(&rq->lock);
 
+	if (!rq->rt.overloaded)
+		return 0;
+
 	next_task = pick_next_highest_task_rt(rq, -1);
 	if (!next_task)
 		return 0;
@@ -673,7 +678,7 @@ static void schedule_tail_balance_rt(struct rq *rq)
 	 * the lock was owned by prev, we need to release it
 	 * first via finish_lock_switch and then reaquire it here.
 	 */
-	if (unlikely(rq->rt.rt_nr_running > 1)) {
+	if (unlikely(rq->rt.overloaded)) {
 		spin_lock_irq(&rq->lock);
 		push_rt_tasks(rq);
 		spin_unlock_irq(&rq->lock);
@@ -685,7 +690,8 @@ static void wakeup_balance_rt(struct rq *rq, struct task_struct *p)
 {
 	if (unlikely(rt_task(p)) &&
 	    !task_running(rq, p) &&
-	    (p->prio >= rq->curr->prio))
+	    (p->prio >= rq->rt.highest_prio) &&
+	    rq->rt.overloaded)
 		push_rt_tasks(rq);
 }
 

