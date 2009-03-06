Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbZCFLw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbZCFLw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbZCFLwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:52:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:57374 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbZCFLwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:52:15 -0500
Date: Fri, 6 Mar 2009 11:51:31 GMT
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
In-Reply-To: <49B10BA4.9070209@cn.fujitsu.com>
References: <49B10BA4.9070209@cn.fujitsu.com>
Subject: [tip:sched/cleanups] sched: TIF_NEED_RESCHED -> need_reshed() cleanup
Message-ID: <tip-5ed0cec0ac5f1b3759bdbe4d9df32ee4ff8afb5a@git.kernel.org>
Git-Commit-ID: 5ed0cec0ac5f1b3759bdbe4d9df32ee4ff8afb5a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 11:51:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ed0cec0ac5f1b3759bdbe4d9df32ee4ff8afb5a
Gitweb:     http://git.kernel.org/tip/5ed0cec0ac5f1b3759bdbe4d9df32ee4ff8afb5a
Author:     "Lai Jiangshan" <laijs@cn.fujitsu.com>
AuthorDate: Fri, 6 Mar 2009 19:40:20 +0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 12:48:55 +0100

sched: TIF_NEED_RESCHED -> need_reshed() cleanup

Impact: cleanup

Use test_tsk_need_resched(), set_tsk_need_resched(), need_resched()
instead of using TIF_NEED_RESCHED.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <49B10BA4.9070209@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c    |   10 +++++-----
 lib/kernel_lock.c |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8b92f40..e0fa739 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1189,10 +1189,10 @@ static void resched_task(struct task_struct *p)
 
 	assert_spin_locked(&task_rq(p)->lock);
 
-	if (unlikely(test_tsk_thread_flag(p, TIF_NEED_RESCHED)))
+	if (test_tsk_need_resched(p))
 		return;
 
-	set_tsk_thread_flag(p, TIF_NEED_RESCHED);
+	set_tsk_need_resched(p);
 
 	cpu = task_cpu(p);
 	if (cpu == smp_processor_id())
@@ -1248,7 +1248,7 @@ void wake_up_idle_cpu(int cpu)
 	 * lockless. The worst case is that the other CPU runs the
 	 * idle task through an additional NOOP schedule()
 	 */
-	set_tsk_thread_flag(rq->idle, TIF_NEED_RESCHED);
+	set_tsk_need_resched(rq->idle);
 
 	/* NEED_RESCHED must be visible before we test polling */
 	smp_mb();
@@ -4740,7 +4740,7 @@ asmlinkage void __sched preempt_schedule(void)
 		 * between schedule and now.
 		 */
 		barrier();
-	} while (unlikely(test_thread_flag(TIF_NEED_RESCHED)));
+	} while (need_resched());
 }
 EXPORT_SYMBOL(preempt_schedule);
 
@@ -4769,7 +4769,7 @@ asmlinkage void __sched preempt_schedule_irq(void)
 		 * between schedule and now.
 		 */
 		barrier();
-	} while (unlikely(test_thread_flag(TIF_NEED_RESCHED)));
+	} while (need_resched());
 }
 
 #endif /* CONFIG_PREEMPT */
diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index 01a3c22..39f1029 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -39,7 +39,7 @@ static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kernel_flag);
 int __lockfunc __reacquire_kernel_lock(void)
 {
 	while (!_raw_spin_trylock(&kernel_flag)) {
-		if (test_thread_flag(TIF_NEED_RESCHED))
+		if (need_resched())
 			return -EAGAIN;
 		cpu_relax();
 	}
