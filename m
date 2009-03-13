Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZCMNB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZCMNB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZCMNBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:01:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:53952 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbZCMNBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:01:15 -0400
Date: Fri, 13 Mar 2009 13:00:29 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313112300.927414207@chello.nl>
References: <20090313112300.927414207@chello.nl>
Subject: [tip:core/locking] sched: remove extra call overhead for schedule()
Message-ID: <tip-e690e5337d953a0936a9735424a454ec21bae0a5@git.kernel.org>
Git-Commit-ID: e690e5337d953a0936a9735424a454ec21bae0a5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 13:00:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e690e5337d953a0936a9735424a454ec21bae0a5
Gitweb:     http://git.kernel.org/tip/e690e5337d953a0936a9735424a454ec21bae0a5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 13 Mar 2009 12:21:26 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 13:55:17 +0100

sched: remove extra call overhead for schedule()

Lai Jiangshan's patch reminded me that I promised Nick to remove
that extra call overhead in schedule().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090313112300.927414207@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
index 8549d48..01275cb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4543,13 +4543,15 @@ pick_next_task(struct rq *rq, struct task_struct *prev)
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
@@ -4606,15 +4608,9 @@ need_resched_nonpreemptible:
 
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
