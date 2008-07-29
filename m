Return-Path: <linux-kernel-owner+w=401wt.eu-S1760043AbYG2Wc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbYG2Wc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbYG2WcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:32:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52927 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbYG2WcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:32:19 -0400
Date: Tue, 29 Jul 2008 23:31:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Fwd: Commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa breaks PXA270 (at least)?
Message-ID: <20080729223105.GK10982@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sigh.  This is going to break virtually every ARM platform which
provides a high resolution sched_clock.

We've had this issue before when printk_clock was linked to sched_clock.

We worked around that breakage by defining our own printk_clock().
But then some bright spark thought it would be a good idea to get
rid of printk_clock().

If we want to couple the clock used by printk to sched_clock() by
default, can we please have printk_clock() back so ARM can provide
an implementation based solely upon jiffies, because basing it on
hardware sources Just Doesn't Work - the reason why...

... you can not access high resolution clocks because peripherals
are MMIO.  There's no standard high resolution clocks, so there's
no standard place to map.  And mappings are setup after the first
printk happens.

So, while we want to be able to use high resolution clocks for the
scheduler, the scheduler clock must _not_ be used for printk.

----- Forwarded message from Bill Gatliff <bgat@billgatliff.com> -----

Delivery-date: Tue, 29 Jul 2008 23:21:39 +0100
Date: Sat, 26 Jul 2008 12:18:43 -0500
From: Bill Gatliff <bgat@billgatliff.com>
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa breaks PXA270 (at
	least)?

Guys:


I'm tracking this git repo:

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

The commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa causes my PXA270
board to hang at boot.  If I surgically remove that change, things seem
to work fine.

I'm not quite sure what this patch is doing.  Anyone having similar
problems?



commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Jun 27 13:41:15 2008 +0200

    sched: sched_clock_cpu() based cpu_clock()

    with sched_clock_cpu() being reasonably in sync between cpus (max 1
jiffy
    difference) use this to provide cpu_clock().

    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
    Cc: Mike Galbraith <efault@gmx.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/sched.c b/kernel/sched.c
index 874b6da..eb3454c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -818,82 +818,6 @@ static inline u64 global_rt_runtime(void)
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
-static unsigned long long __sync_cpu_clock(unsigned long long time, int
cpu)
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
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index ce05271..3c696db 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -244,3 +244,15 @@ unsigned long long __attribute__((weak))
sched_clock(void)
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
Bill Gatliff
bgat@billgatliff.com


-------------------------------------------------------------------
List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php

----- End forwarded message -----
