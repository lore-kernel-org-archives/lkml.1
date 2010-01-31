Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973Ab0AaR2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0AaR2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 12:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477Ab0AaR2s
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 12:28:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58129 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab0AaR2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 12:28:47 -0500
Date: Sun, 31 Jan 2010 18:28:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20100131172839.GA4956@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Frans Pop (1):
      sched: Correct printk whitespace in warning from cpu down task check

Peter Zijlstra (2):
      sched: Fix fork vs hotplug vs cpuset namespaces
      sched: Fix incorrect sanity check


 kernel/cpu.c   |   10 +++++-----
 kernel/fork.c  |   15 ---------------
 kernel/sched.c |   39 +++++++++++++++++++++++++++------------
 3 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 1c8ddd6..677f253 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -151,13 +151,13 @@ static inline void check_for_tasks(int cpu)
 
 	write_lock_irq(&tasklist_lock);
 	for_each_process(p) {
-		if (task_cpu(p) == cpu &&
+		if (task_cpu(p) == cpu && p->state == TASK_RUNNING &&
 		    (!cputime_eq(p->utime, cputime_zero) ||
 		     !cputime_eq(p->stime, cputime_zero)))
-			printk(KERN_WARNING "Task %s (pid = %d) is on cpu %d\
-				(state = %ld, flags = %x) \n",
-				 p->comm, task_pid_nr(p), cpu,
-				 p->state, p->flags);
+			printk(KERN_WARNING "Task %s (pid = %d) is on cpu %d "
+				"(state = %ld, flags = %x)\n",
+				p->comm, task_pid_nr(p), cpu,
+				p->state, p->flags);
 	}
 	write_unlock_irq(&tasklist_lock);
 }
diff --git a/kernel/fork.c b/kernel/fork.c
index 5b2959b..f88bd98 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1241,21 +1241,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	/* Need tasklist lock for parent etc handling! */
 	write_lock_irq(&tasklist_lock);
 
-	/*
-	 * The task hasn't been attached yet, so its cpus_allowed mask will
-	 * not be changed, nor will its assigned CPU.
-	 *
-	 * The cpus_allowed mask of the parent may have changed after it was
-	 * copied first time - so re-copy it here, then check the child's CPU
-	 * to ensure it is on a valid CPU (and if not, just force it back to
-	 * parent's CPU). This avoids alot of nasty races.
-	 */
-	p->cpus_allowed = current->cpus_allowed;
-	p->rt.nr_cpus_allowed = current->rt.nr_cpus_allowed;
-	if (unlikely(!cpu_isset(task_cpu(p), p->cpus_allowed) ||
-			!cpu_online(task_cpu(p))))
-		set_task_cpu(p, smp_processor_id());
-
 	/* CLONE_PARENT re-uses the old parent */
 	if (clone_flags & (CLONE_PARENT|CLONE_THREAD)) {
 		p->real_parent = current->real_parent;
diff --git a/kernel/sched.c b/kernel/sched.c
index 4508fe7..3a8fb30 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2320,14 +2320,12 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 }
 
 /*
- * Called from:
+ * Gets called from 3 sites (exec, fork, wakeup), since it is called without
+ * holding rq->lock we need to ensure ->cpus_allowed is stable, this is done
+ * by:
  *
- *  - fork, @p is stable because it isn't on the tasklist yet
- *
- *  - exec, @p is unstable, retry loop
- *
- *  - wake-up, we serialize ->cpus_allowed against TASK_WAKING so
- *             we should be good.
+ *  exec:           is unstable, retry loop
+ *  fork & wake-up: serialize ->cpus_allowed against TASK_WAKING
  */
 static inline
 int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
@@ -2620,9 +2618,6 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	if (p->sched_class->task_fork)
 		p->sched_class->task_fork(p);
 
-#ifdef CONFIG_SMP
-	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
-#endif
 	set_task_cpu(p, cpu);
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
@@ -2652,6 +2647,21 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 {
 	unsigned long flags;
 	struct rq *rq;
+	int cpu = get_cpu();
+
+#ifdef CONFIG_SMP
+	/*
+	 * Fork balancing, do it here and not earlier because:
+	 *  - cpus_allowed can change in the fork path
+	 *  - any previously selected cpu might disappear through hotplug
+	 *
+	 * We still have TASK_WAKING but PF_STARTING is gone now, meaning
+	 * ->cpus_allowed is stable, we have preemption disabled, meaning
+	 * cpu_online_mask is stable.
+	 */
+	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
+	set_task_cpu(p, cpu);
+#endif
 
 	rq = task_rq_lock(p, &flags);
 	BUG_ON(p->state != TASK_WAKING);
@@ -2665,6 +2675,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 		p->sched_class->task_woken(rq, p);
 #endif
 	task_rq_unlock(rq, &flags);
+	put_cpu();
 }
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
@@ -7139,14 +7150,18 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 	 * the ->cpus_allowed mask from under waking tasks, which would be
 	 * possible when we change rq->lock in ttwu(), so synchronize against
 	 * TASK_WAKING to avoid that.
+	 *
+	 * Make an exception for freshly cloned tasks, since cpuset namespaces
+	 * might move the task about, we have to validate the target in
+	 * wake_up_new_task() anyway since the cpu might have gone away.
 	 */
 again:
-	while (p->state == TASK_WAKING)
+	while (p->state == TASK_WAKING && !(p->flags & PF_STARTING))
 		cpu_relax();
 
 	rq = task_rq_lock(p, &flags);
 
-	if (p->state == TASK_WAKING) {
+	if (p->state == TASK_WAKING && !(p->flags & PF_STARTING)) {
 		task_rq_unlock(rq, &flags);
 		goto again;
 	}
