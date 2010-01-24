Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294Ab0AXGAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab0AXGAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 01:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141Ab0AXGAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 01:00:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:49633 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751572Ab0AXF77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 00:59:59 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/CEektICXCMYbmiczXHlDpwT8i3Oqkq2XxYqcBOH
	qlXCB+vybO7cMD
Subject: Re: Bisected rcu hang (kernel/sched.c): was 2.6.33rc4 RCU hang mm
 spin_lock deadlock(?) after running libvirtd - reproducible.
From: Mike Galbraith <efault@gmx.de>
To: Michael Breuer <mbreuer@majjas.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4B5BB535.8040200@majjas.com>
References: <4B49015D.9000903@majjas.com> <4B4A341B.6010800@majjas.com>
	 <20100112014909.GB10869@linux.vnet.ibm.com> <4B4E1461.4010806@majjas.com>
	 <4B5BB535.8040200@majjas.com>
Content-Type: text/plain
Date: Sun, 24 Jan 2010 06:59:55 +0100
Message-Id: <1264312795.5904.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.41999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-23 at 21:49 -0500, Michael Breuer wrote:
> On 01/13/2010 01:43 PM, Michael Breuer wrote:

> > I can now recreate this simply by "service start libvirtd" on an F12 
> > box. My earlier report that suggested this had something to do with 
> > the sky2 driver was incorrect. Interestingly, it's always CPU1 
> > whenever I start libvirtd.
> > Attaching two of the traces (I've got about ten, but they're all 
> > pretty much the same). Looks pretty consistent - libvirtd in CPU1 is 
> > hung forking. Not sure why yet - perhaps someone who knows this better 
> > than I can jump in.
> > Summary of hang appears to be libvirtd forks - two threads show with 
> > same pid deadlocked on a spin_lock
> >> Then if looking at the stack traces doesn't locate the offending loop,
> >> bisection might help.
> > It would, however it's going to be really difficult as I wasn't able 
> > to get this far with rc1 & rc2 :(
> >>                             Thanx, Paul
> >
> I was finally able to bisect this to commit: 
> 3802290628348674985d14914f9bfee7b9084548 (see below)

I suspect something went wrong during bisection, however...

Jan 13 12:59:25 mail kernel: [<ffffffff810447be>] ? set_cpus_allowed_ptr+0x22/0x14b
Jan 13 12:59:25 mail kernel: [<ffffffff810f2a7b>] ? spin_lock+0xe/0x10
Jan 13 12:59:25 mail kernel: [<ffffffff81087d79>] cpuset_attach_task+0x27/0x9b
Jan 13 12:59:25 mail kernel: [<ffffffff81087e77>] cpuset_attach+0x8a/0x133
Jan 13 12:59:25 mail kernel: [<ffffffff81042d2c>] ? sched_move_task+0x104/0x110
Jan 13 12:59:25 mail kernel: [<ffffffff81085dbd>] cgroup_attach_task+0x4e1/0x53f
Jan 13 12:59:25 mail kernel: [<ffffffff81084f48>] ? cgroup_populate_dir+0x77/0xff
Jan 13 12:59:25 mail kernel: [<ffffffff81086073>] cgroup_clone+0x258/0x2ac
Jan 13 12:59:25 mail kernel: [<ffffffff81088d04>] ns_cgroup_clone+0x58/0x75
Jan 13 12:59:25 mail kernel: [<ffffffff81048f3d>] copy_process+0xcef/0x13af
Jan 13 12:59:25 mail kernel: [<ffffffff810d963c>] ? handle_mm_fault+0x355/0x7ff
Jan 13 12:59:25 mail kernel: [<ffffffff81049768>] do_fork+0x16b/0x309
Jan 13 12:59:25 mail kernel: [<ffffffff81252ab2>] ? __up_read+0x8e/0x97
Jan 13 12:59:25 mail kernel: [<ffffffff81068c92>] ? up_read+0xe/0x10
Jan 13 12:59:25 mail kernel: [<ffffffff8145a779>] ? do_page_fault+0x280/0x2cc
Jan 13 12:59:25 mail kernel: [<ffffffff81010f2e>] sys_clone+0x28/0x2a
Jan 13 12:59:25 mail kernel: [<ffffffff81009f33>] stub_clone+0x13/0x20
Jan 13 12:59:25 mail kernel: [<ffffffff81009bf2>] ? system_call_fastpath+0x16/0x1b

...that looks like a bug which has already been fixed in tip, but not
yet propagated.  Your trace looks like relax forever scenario.

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


