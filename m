Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbZDTTB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbZDTTB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbZDTTBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:01:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:43603 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbZDTTBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:01:46 -0400
Date: Mon, 20 Apr 2009 19:00:45 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313112300.927414207@chello.nl>
References: <20090313112300.927414207@chello.nl>
Subject: [tip:sched/core] sched: remove extra call overhead for schedule()
Message-ID: <tip-ff743345bf7685a207868048a70e23164c4785e5@git.kernel.org>
Git-Commit-ID: ff743345bf7685a207868048a70e23164c4785e5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 20 Apr 2009 19:00:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff743345bf7685a207868048a70e23164c4785e5
Gitweb:     http://git.kernel.org/tip/ff743345bf7685a207868048a70e23164c4785e5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 13 Mar 2009 12:21:26 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 20 Apr 2009 20:49:53 +0200

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
index 7601cee..797f6fd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5131,13 +5131,15 @@ pick_next_task(struct rq *rq)
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
@@ -5194,15 +5196,9 @@ need_resched_nonpreemptible:
 
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
