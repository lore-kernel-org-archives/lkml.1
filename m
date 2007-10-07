Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbXJGVBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbXJGVBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 17:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbXJGVAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 17:00:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:34183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbXJGU77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 16:59:59 -0400
From: Andi Kleen <ak@suse.de>
References: <200710071059.126674000@suse.de>
In-Reply-To: <200710071059.126674000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH] [5/6] scheduler: Protect important kernel threads against normalize_rt
Message-Id: <20071007205958.7D8C41474B@wotan.suse.de>
Date: Sun,  7 Oct 2007 22:59:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Not only the migration thread, but also softlockup and stop machine
need to be protected against normalize_rt(). Instead of checking
for them all I added a new process flag for this. 

This was the last available bit in 32bit task->flags, sorry for that.

This removes the is_migration_thread macro added in the last patch
again because it is not needed anymore.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6-sched-devel/include/linux/sched.h
===================================================================
--- linux-2.6-sched-devel.orig/include/linux/sched.h
+++ linux-2.6-sched-devel/include/linux/sched.h
@@ -1330,6 +1330,7 @@ static inline void put_task_struct(struc
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
+#define PF_RT_PROTECTED 0x80000000	/* RT task protected from sysrq */
 
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
Index: linux-2.6-sched-devel/kernel/sched.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/sched.c
+++ linux-2.6-sched-devel/kernel/sched.c
@@ -74,12 +74,6 @@ unsigned long long __attribute__((weak))
 	return (unsigned long long)jiffies * (1000000000 / HZ);
 }
 
-#ifdef CONFIG_SMP
-#define is_migration_thread(p, rq) ((p) == (rq)->migration_thread)
-#else
-#define is_migration_thread(p, rq) 0
-#endif
-
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
@@ -5305,6 +5299,7 @@ migration_call(struct notifier_block *nf
 		kthread_bind(p, cpu);
 		/* Must be high prio: stop_machine expects to yield to it. */
 		rq = task_rq_lock(p, &flags);
+		p->flags |= PF_RT_PROTECTED;
 		__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
 		task_rq_unlock(rq, &flags);
 		cpu_rq(cpu)->migration_thread = p;
@@ -6583,7 +6578,7 @@ void normalize_rt_tasks(void)
 		spin_lock_irqsave(&p->pi_lock, flags);
 		rq = __task_rq_lock(p);
 
-		if (!is_migration_thread(p, rq))
+		if (!(p->flags & PF_RT_PROTECTED))
 			normalize_task(rq, p);
 
 		__task_rq_unlock(rq);
Index: linux-2.6-sched-devel/kernel/softlockup.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/softlockup.c
+++ linux-2.6-sched-devel/kernel/softlockup.c
@@ -116,6 +116,7 @@ static int watchdog(void * __bind_cpu)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
+	current->flags |= PF_RT_PROTECTED;
 	sched_setscheduler(current, SCHED_FIFO, &param);
 
 	/* initialize timestamp */
Index: linux-2.6-sched-devel/kernel/stop_machine.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/stop_machine.c
+++ linux-2.6-sched-devel/kernel/stop_machine.c
@@ -187,6 +187,7 @@ struct task_struct *__stop_machine_run(i
 	if (!IS_ERR(p)) {
 		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
+		p->flags |= PF_RT_PROTECTED;
 		/* One high-prio thread per cpu.  We'll do this one. */
 		sched_setscheduler(p, SCHED_FIFO, &param);
 		kthread_bind(p, cpu);
