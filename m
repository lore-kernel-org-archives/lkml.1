Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbZJ2Kse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbZJ2Kse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 06:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbZJ2Kse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 06:48:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:57029 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750810AbZJ2Ksd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 06:48:33 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX199U5V4s2l9NwxzkZjTySKqyuMDfJXJLPOpbhnhZZ
	Mmiw/3UYhBnc/G
Subject: Re: [patch] Re: [regression bisect -next] BUG: using
 smp_processor_id() in preemptible [00000000] code: rmmod
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1256807967.7158.58.camel@marge.simson.net>
References: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com>
	 <1256805552.7158.22.camel@marge.simson.net>
	 <20091029091411.GE22963@elte.hu>
	 <1256807967.7158.58.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 29 Oct 2009 11:48:30 +0100
Message-Id: <1256813310.7574.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 10:19 +0100, Mike Galbraith wrote:
> On Thu, 2009-10-29 at 10:14 +0100, Ingo Molnar wrote:
> 
> > hm, the problem is kthread_bind(). It is rummaging around in scheduler 
> > internals without holding the runqueue lock - and this now got exposed. 
> > Even though it is operating on (supposedly ...) inactive tasks, the guts 
> > of that function should be moved into sched.c and it should be fixed to 
> > have proper locking.
> 
> Yeah, I was thinking that nobody should ever be able to hit that without
> it being a bug.. but wimped out.

How about so?

sched: Move the body of kthread_bind() to sched.c.

Eric Paris reported that commit f685ceacab07d3f6c236f04803e2f2f0dbcc5afb
causes boot time PREEMPT_DEBUG complaints.

[    4.590699] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1314
[    4.593043] caller is task_hot+0x86/0xd0
[    4.593872] Pid: 1314, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
[    4.595443] Call Trace:
[    4.596177]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    4.597337]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    4.598320]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    4.599368]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    4.600354]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    4.601545]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    4.602526]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
[    4.603811]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
[    4.604922]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
[    4.606202]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b

Since kthread_bind() messes with scheduler internals, move the body to sched.c,
and lock the runqueue.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Eric Paris <eparis@redhat.com>
LKML-Reference: <new-submission>

---
 kernel/kthread.c |   15 ++++++---------
 kernel/sched.c   |   31 +++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/kthread.c
===================================================================
--- linux-2.6.orig/kernel/kthread.c
+++ linux-2.6/kernel/kthread.c
@@ -149,6 +149,8 @@ struct task_struct *kthread_create(int (
 }
 EXPORT_SYMBOL(kthread_create);
 
+extern void sched_kthread_bind(struct task_struct *k, unsigned int cpu);
+
 /**
  * kthread_bind - bind a just-created kthread to a cpu.
  * @k: thread created by kthread_create().
@@ -157,18 +159,13 @@ EXPORT_SYMBOL(kthread_create);
  * Description: This function is equivalent to set_cpus_allowed(),
  * except that @cpu doesn't need to be online, and the thread must be
  * stopped (i.e., just returned from kthread_create()).
+ *
+ * The runqueue must be locked, ergo move the body if this function
+ * to sched.c
  */
 void kthread_bind(struct task_struct *k, unsigned int cpu)
 {
-	/* Must have done schedule() in kthread() before we set_task_cpu */
-	if (!wait_task_inactive(k, TASK_UNINTERRUPTIBLE)) {
-		WARN_ON(1);
-		return;
-	}
-	set_task_cpu(k, cpu);
-	k->cpus_allowed = cpumask_of_cpu(cpu);
-	k->rt.nr_cpus_allowed = 1;
-	k->flags |= PF_THREAD_BOUND;
+	sched_kthread_bind(k, cpu);
 }
 EXPORT_SYMBOL(kthread_bind);
 
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2063,6 +2063,37 @@ void set_task_cpu(struct task_struct *p,
 	__set_task_cpu(p, new_cpu);
 }
 
+/**
+ * sched_kthread_bind - bind a just-created kthread to a cpu.
+ * @k: thread created by kthread_create().
+ * @cpu: cpu (might not be online, must be possible) for @k to run on.
+ *
+ * Description: This function is equivalent to set_cpus_allowed(),
+ * except that @cpu doesn't need to be online, and the thread must be
+ * stopped (i.e., just returned from kthread_create()).
+ *
+ * Function lives here instead of kthread.c because it messes with
+ * scheduler internals which require locking.
+ */
+void sched_kthread_bind(struct task_struct *p, unsigned int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+
+	/* Must have done schedule() in kthread() before we set_task_cpu */
+	if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
+		WARN_ON(1);
+		return;
+	}
+
+	spin_lock_irqsave(&rq->lock, flags);
+	set_task_cpu(p, cpu);
+	p->cpus_allowed = cpumask_of_cpu(cpu);
+	p->rt.nr_cpus_allowed = 1;
+	p->flags |= PF_THREAD_BOUND;
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
+
 struct migration_req {
 	struct list_head list;
 


