Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbZCFLlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbZCFLlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZCFLld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:41:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57620 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZCFLld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:41:33 -0500
Message-ID: <49B10BA4.9070209@cn.fujitsu.com>
Date: Fri, 06 Mar 2009 19:40:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH -tip] sched: cleanup for TIF_NEED_RESCHED
References: <49B0F9C2.8060200@cn.fujitsu.com> <20090306104925.GA21168@elte.hu>
In-Reply-To: <20090306104925.GA21168@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
>> Impact: cleanup
>>
>> use need_resched() instead of unlikely(test_thread_flag(TIF_NEED_RESCHED))
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> looks good - but it does not apply cleanly to the latest 
> scheduler tree:
> 
>    http://people.redhat.com/mingo/tip.git/README
> 
> Could you please send a merged up patch and also make sure 
> there's no other TIF_NEED_RESCHED usage in kernel/sched.c that 
> could be converted to need_resched()?
> 
> Thanks,
> 
> 	Ingo
> 
> 

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Impact: cleanup

Use test_tsk_need_resched(), set_tsk_need_resched(), need_resched()
instead of using TIF_NEED_RESCHED.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index 63e8414..81b7c8b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1210,10 +1210,10 @@ static void resched_task(struct task_struct *p)
 
 	assert_spin_locked(&task_rq(p)->lock);
 
-	if (unlikely(test_tsk_thread_flag(p, TIF_NEED_RESCHED)))
+	if (test_tsk_need_resched(p))
 		return;
 
-	set_tsk_thread_flag(p, TIF_NEED_RESCHED);
+	set_tsk_need_resched(p);
 
 	cpu = task_cpu(p);
 	if (cpu == smp_processor_id())
@@ -1269,7 +1269,7 @@ void wake_up_idle_cpu(int cpu)
 	 * lockless. The worst case is that the other CPU runs the
 	 * idle task through an additional NOOP schedule()
 	 */
-	set_tsk_thread_flag(rq->idle, TIF_NEED_RESCHED);
+	set_tsk_need_resched(rq->idle);
 
 	/* NEED_RESCHED must be visible before we test polling */
 	smp_mb();
@@ -4795,12 +4795,11 @@ need_resched_nonpreemptible:
 
 asmlinkage void __sched schedule(void)
 {
-need_resched:
-	preempt_disable();
-	__schedule();
-	preempt_enable_no_resched();
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))
-		goto need_resched;
+	do {
+		preempt_disable();
+		__schedule();
+		preempt_enable_no_resched();
+	} while (need_resched());
 }
 EXPORT_SYMBOL(schedule);
 
@@ -4892,7 +4891,7 @@ asmlinkage void __sched preempt_schedule(void)
 		 * between schedule and now.
 		 */
 		barrier();
-	} while (unlikely(test_thread_flag(TIF_NEED_RESCHED)));
+	} while (need_resched());
 }
 EXPORT_SYMBOL(preempt_schedule);
 
@@ -4921,7 +4920,7 @@ asmlinkage void __sched preempt_schedule_irq(void)
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
