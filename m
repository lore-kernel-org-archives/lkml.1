Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbZCMLYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbZCMLYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZCMLXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:23:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46679 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZCMLXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:23:41 -0400
Message-Id: <20090313112300.927414207@chello.nl>
References: <20090313112125.886730125@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 13 Mar 2009 12:21:26 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 01/11] sched: remove extra call overhead for schedule()
Content-Disposition: inline; filename=sched-remove_extra_call_overhead_for_schedule.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan's patch reminded me that I promised Nick to remove that
extra call overhead in schedule().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/mutex.c |    4 +++-
 kernel/sched.c |   12 ++++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c
+++ linux-2.6/kernel/mutex.c
@@ -248,7 +248,9 @@ __mutex_lock_common(struct mutex *lock, 
 
 		/* didnt get the lock, go to sleep: */
 		spin_unlock_mutex(&lock->wait_lock, flags);
-		__schedule();
+		preempt_enable_no_resched();
+		schedule();
+		preempt_disable();
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
 
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4763,13 +4763,15 @@ pick_next_task(struct rq *rq)
 /*
  * schedule() is the main scheduler function.
  */
-asmlinkage void __sched __schedule(void)
+asmlinkage void __sched schedule(void)
 {
 	struct task_struct *prev, *next;
 	unsigned long *switch_count;
 	struct rq *rq;
 	int cpu;
 
+need_resched:
+	preempt_disable();
 	cpu = smp_processor_id();
 	rq = cpu_rq(cpu);
 	rcu_qsctr_inc(cpu);
@@ -4827,15 +4829,9 @@ need_resched_nonpreemptible:
 
 	if (unlikely(reacquire_kernel_lock(current) < 0))
 		goto need_resched_nonpreemptible;
-}
 
-asmlinkage void __sched schedule(void)
-{
-need_resched:
-	preempt_disable();
-	__schedule();
 	preempt_enable_no_resched();
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))
+	if (need_resched())
 		goto need_resched;
 }
 EXPORT_SYMBOL(schedule);

-- 

