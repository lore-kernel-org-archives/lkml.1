Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYF0MHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYF0MHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbYF0L60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:26 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:64186 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756792AbYF0L6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:58:07 -0400
Message-Id: <20080627115211.276771961@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:15 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/30] sched: sched_clock_cpu() based cpu_clock()
Content-Disposition: inline; filename=sched-cpu_clock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with sched_clock_cpu() being reasonably in sync between cpus (max 1 jiffy 
difference) use this to provide cpu_clock().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c       |   80 ---------------------------------------------------
 kernel/sched_clock.c |   12 +++++++
 2 files changed, 12 insertions(+), 80 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -809,82 +807,6 @@ static inline u64 global_rt_runtime(void
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
 
-unsigned long long time_sync_thresh = 100000;
-
-static DEFINE_PER_CPU(unsigned long long, time_offset);
-static DEFINE_PER_CPU(unsigned long long, prev_cpu_time);
-
-/*
- * Global lock which we take every now and then to synchronize
- * the CPUs time. This method is not warp-safe, but it's good
- * enough to synchronize slowly diverging time sources and thus
- * it's good enough for tracing:
- */
-static DEFINE_SPINLOCK(time_sync_lock);
-static unsigned long long prev_global_time;
-
-static unsigned long long __sync_cpu_clock(unsigned long long time, int cpu)
-{
-	/*
-	 * We want this inlined, to not get tracer function calls
-	 * in this critical section:
-	 */
-	spin_acquire(&time_sync_lock.dep_map, 0, 0, _THIS_IP_);
-	__raw_spin_lock(&time_sync_lock.raw_lock);
-
-	if (time < prev_global_time) {
-		per_cpu(time_offset, cpu) += prev_global_time - time;
-		time = prev_global_time;
-	} else {
-		prev_global_time = time;
-	}
-
-	__raw_spin_unlock(&time_sync_lock.raw_lock);
-	spin_release(&time_sync_lock.dep_map, 1, _THIS_IP_);
-
-	return time;
-}
-
-static unsigned long long __cpu_clock(int cpu)
-{
-	unsigned long long now;
-
-	/*
-	 * Only call sched_clock() if the scheduler has already been
-	 * initialized (some code might call cpu_clock() very early):
-	 */
-	if (unlikely(!scheduler_running))
-		return 0;
-
-	now = sched_clock_cpu(cpu);
-
-	return now;
-}
-
-/*
- * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
- * clock constructed from sched_clock():
- */
-unsigned long long cpu_clock(int cpu)
-{
-	unsigned long long prev_cpu_time, time, delta_time;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	prev_cpu_time = per_cpu(prev_cpu_time, cpu);
-	time = __cpu_clock(cpu) + per_cpu(time_offset, cpu);
-	delta_time = time-prev_cpu_time;
-
-	if (unlikely(delta_time > time_sync_thresh)) {
-		time = __sync_cpu_clock(time, cpu);
-		per_cpu(prev_cpu_time, cpu) = time;
-	}
-	local_irq_restore(flags);
-
-	return time;
-}
-EXPORT_SYMBOL_GPL(cpu_clock);
-
 #ifndef prepare_arch_switch
 # define prepare_arch_switch(next)	do { } while (0)
 #endif
Index: linux-2.6/kernel/sched_clock.c
===================================================================
--- linux-2.6.orig/kernel/sched_clock.c
+++ linux-2.6/kernel/sched_clock.c
@@ -244,3 +244,15 @@ unsigned long long __attribute__((weak))
 {
 	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
 }
+
+unsigned long long cpu_clock(int cpu)
+{
+	unsigned long long clock;
+	unsigned long flags;
+
+	raw_local_irq_save(flags);
+	clock = sched_clock_cpu(cpu);
+	raw_local_irq_restore(flags);
+
+	return clock;
+}

-- 

