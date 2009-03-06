Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZCFOef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZCFOef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 09:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZCFOe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 09:34:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41719 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZCFOe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 09:34:26 -0500
Subject: [PATCH] sched: remove extra call overhead for schedule()
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 15:34:11 +0100
Message-Id: <1236350051.6326.379.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
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

diff --git a/kernel/mutex.c b/kernel/mutex.c
index 5d79781..e1fb735 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -248,7 +248,9 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 		/* didnt get the lock, go to sleep: */
 		spin_unlock_mutex(&lock->wait_lock, flags);
-		__schedule();
+		preempt_enable_no_resched();
+		schedule();
+		preempt_disable();
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 4414926..784b079 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4727,13 +4727,15 @@ pick_next_task(struct rq *rq)
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
@@ -4791,15 +4793,9 @@ need_resched_nonpreemptible:
 
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


