Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949Ab0AYQDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab0AYQDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 11:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072Ab0AYQDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 11:03:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab0AYQDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 11:03:48 -0500
Subject: Re: Bisected rcu hang (kernel/sched.c): was 2.6.33rc4 RCU hang mm
 spin_lock deadlock(?) after running libvirtd - reproducible.
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Breuer <mbreuer@majjas.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <4B5BB535.8040200@majjas.com>
References: <4B49015D.9000903@majjas.com> <4B4A341B.6010800@majjas.com>
	 <20100112014909.GB10869@linux.vnet.ibm.com> <4B4E1461.4010806@majjas.com>
	 <4B5BB535.8040200@majjas.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 17:03:40 +0100
Message-ID: <1264435420.4283.1927.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-23 at 21:49 -0500, Michael Breuer wrote:
> Libvirtd always triggers the crash; other things that fork and use mmap 
> sometimes do (vsftpd, for example).

I bet its the nscgroup trainwreck, does this fix it?

---
commit fabf318e5e4bda0aca2b0d617b191884fda62703
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu Jan 21 21:04:57 2010 +0100

    sched: Fix fork vs hotplug vs cpuset namespaces
    
    There are a number of issues:
    
    1) TASK_WAKING vs cgroup_clone (cpusets)
    
    copy_process():
    
      sched_fork()
        child->state = TASK_WAKING; /* waiting for wake_up_new_task() */
      if (current->nsproxy != p->nsproxy)
         ns_cgroup_clone()
           cgroup_clone()
             mutex_lock(inode->i_mutex)
             mutex_lock(cgroup_mutex)
             cgroup_attach_task()
    	   ss->can_attach()
               ss->attach() [ -> cpuset_attach() ]
                 cpuset_attach_task()
                   set_cpus_allowed_ptr();
                     while (child->state == TASK_WAKING)
                       cpu_relax();
    will deadlock the system.
    
    
    2) cgroup_clone (cpusets) vs copy_process
    
    So even if the above would work we still have:
    
    copy_process():
    
      if (current->nsproxy != p->nsproxy)
         ns_cgroup_clone()
           cgroup_clone()
             mutex_lock(inode->i_mutex)
             mutex_lock(cgroup_mutex)
             cgroup_attach_task()
    	   ss->can_attach()
               ss->attach() [ -> cpuset_attach() ]
                 cpuset_attach_task()
                   set_cpus_allowed_ptr();
      ...
    
      p->cpus_allowed = current->cpus_allowed
    
    over-writing the modified cpus_allowed.
    
    
    3) fork() vs hotplug
    
      if we unplug the child's cpu after the sanity check when the child
      gets attached to the task_list but before wake_up_new_task() shit
      will meet with fan.
    
    Solve all these issues by moving fork cpu selection into
    wake_up_new_task().
    
    Reported-by: Serge E. Hallyn <serue@us.ibm.com>
    Tested-by: Serge E. Hallyn <serue@us.ibm.com>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    LKML-Reference: <1264106190.4283.1314.camel@laptop>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

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


