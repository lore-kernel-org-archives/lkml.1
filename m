Return-Path: <linux-kernel-owner+w=401wt.eu-S1752171AbZGVOzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbZGVOzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZGVOzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:55:04 -0400
Received: from www.tglx.de ([62.245.132.106]:58207 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbZGVOzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:55:03 -0400
Date: Wed, 22 Jul 2009 16:54:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] scheduler fixes for 2.6.31
Message-ID: <alpine.LFD.2.00.0907221653300.2813@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

Thanks,

	tglx

------------------>
Fabio Checconi (1):
      sched: Account for vruntime wrapping

Thomas Gleixner (2):
      sched: fix load average accounting vs. cpu hotplug
      sched: fix nr_uninterruptible accounting of frozen tasks really


 include/linux/sched.h |    3 ++-
 kernel/freezer.c      |    7 +++++++
 kernel/sched.c        |    4 ++--
 kernel/sched_fair.c   |   10 ++++++++--
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 16a982e..3ab08e4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -209,7 +209,7 @@ extern unsigned long long time_sync_thresh;
 			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
 #define task_contributes_to_load(task)	\
 				((task->state & TASK_UNINTERRUPTIBLE) != 0 && \
-				 (task->flags & PF_FROZEN) == 0)
+				 (task->flags & PF_FREEZING) == 0)
 
 #define __set_task_state(tsk, state_value)		\
 	do { (tsk)->state = (state_value); } while (0)
@@ -1680,6 +1680,7 @@ extern cputime_t task_gtime(struct task_struct *p);
 #define PF_MEMALLOC	0x00000800	/* Allocating memory */
 #define PF_FLUSHER	0x00001000	/* responsible for disk writeback */
 #define PF_USED_MATH	0x00002000	/* if unset the fpu must be initialized before use */
+#define PF_FREEZING	0x00004000	/* freeze in progress. do not account to load */
 #define PF_NOFREEZE	0x00008000	/* this thread should not be frozen */
 #define PF_FROZEN	0x00010000	/* frozen for system suspend */
 #define PF_FSTRANS	0x00020000	/* inside a filesystem transaction */
diff --git a/kernel/freezer.c b/kernel/freezer.c
index 2f4936c..bd1d42b 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -44,12 +44,19 @@ void refrigerator(void)
 	recalc_sigpending(); /* We sent fake signal, clean it up */
 	spin_unlock_irq(&current->sighand->siglock);
 
+	/* prevent accounting of that task to load */
+	current->flags |= PF_FREEZING;
+
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (!frozen(current))
 			break;
 		schedule();
 	}
+
+	/* Remove the accounting blocker */
+	current->flags &= ~PF_FREEZING;
+
 	pr_debug("%s left refrigerator\n", current->comm);
 	__set_current_state(save);
 }
diff --git a/kernel/sched.c b/kernel/sched.c
index 98972d3..1b59e26 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7289,6 +7289,7 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
 static void calc_global_load_remove(struct rq *rq)
 {
 	atomic_long_sub(rq->calc_load_active, &calc_load_tasks);
+	rq->calc_load_active = 0;
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
@@ -7515,6 +7516,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		task_rq_unlock(rq, &flags);
 		get_task_struct(p);
 		cpu_rq(cpu)->migration_thread = p;
+		rq->calc_load_update = calc_load_update;
 		break;
 
 	case CPU_ONLINE:
@@ -7525,8 +7527,6 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		/* Update our root-domain */
 		rq = cpu_rq(cpu);
 		spin_lock_irqsave(&rq->lock, flags);
-		rq->calc_load_update = calc_load_update;
-		rq->calc_load_active = 0;
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 7c248dc..9ffb2b2 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -266,6 +266,12 @@ static inline u64 min_vruntime(u64 min_vruntime, u64 vruntime)
 	return min_vruntime;
 }
 
+static inline int entity_before(struct sched_entity *a,
+				struct sched_entity *b)
+{
+	return (s64)(a->vruntime - b->vruntime) < 0;
+}
+
 static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	return se->vruntime - cfs_rq->min_vruntime;
@@ -1017,7 +1023,7 @@ static void yield_task_fair(struct rq *rq)
 	/*
 	 * Already in the rightmost position?
 	 */
-	if (unlikely(!rightmost || rightmost->vruntime < se->vruntime))
+	if (unlikely(!rightmost || entity_before(rightmost, se)))
 		return;
 
 	/*
@@ -1713,7 +1719,7 @@ static void task_new_fair(struct rq *rq, struct task_struct *p)
 
 	/* 'curr' will be NULL if the child belongs to a different group */
 	if (sysctl_sched_child_runs_first && this_cpu == task_cpu(p) &&
-			curr && curr->vruntime < se->vruntime) {
+			curr && entity_before(curr, se)) {
 		/*
 		 * Upon rescheduling, sched_class::put_prev_task() will place
 		 * 'current' within the tree based on its new key value.
