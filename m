Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbZCFKZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbZCFKZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbZCFKZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:25:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64727 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755731AbZCFKZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:25:09 -0500
Message-ID: <49B0F9C2.8060200@cn.fujitsu.com>
Date: Fri, 06 Mar 2009 18:24:02 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] sched: use need_resched
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

use need_resched() instead of unlikely(test_thread_flag(TIF_NEED_RESCHED))

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index e1f676e..78f4848 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4610,12 +4610,11 @@ need_resched_nonpreemptible:
 
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
 
@@ -4707,7 +4706,7 @@ asmlinkage void __sched preempt_schedule(void)
 		 * between schedule and now.
 		 */
 		barrier();
-	} while (unlikely(test_thread_flag(TIF_NEED_RESCHED)));
+	} while (need_resched());
 }
 EXPORT_SYMBOL(preempt_schedule);
 
@@ -4736,7 +4735,7 @@ asmlinkage void __sched preempt_schedule_irq(void)
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


