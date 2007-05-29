Return-Path: <linux-kernel-owner+w=401wt.eu-S1764760AbXE2SkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764760AbXE2SkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759822AbXE2Shb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:37:31 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43738 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbXE2ShZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:37:25 -0400
Message-Id: <20070529183710.683711996@polymtl.ca>
References: <20070529183356.192838687@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 29 May 2007 14:34:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 9/9] Scheduler profiling - Use conditional calls
Content-Disposition: inline; filename=profiling-use-cond-calls.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 29 May 2007 18:37:11 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use conditional calls with lower d-cache hit in optimized version as a
condition for scheduler profiling call.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

---
 kernel/profile.c |    4 ++++
 kernel/sched.c   |   32 +++++++++++++++++++-------------
 2 files changed, 23 insertions(+), 13 deletions(-)

Index: linux-2.6-lttng/kernel/profile.c
===================================================================
--- linux-2.6-lttng.orig/kernel/profile.c	2007-05-29 11:33:11.000000000 -0400
+++ linux-2.6-lttng/kernel/profile.c	2007-05-29 11:37:46.000000000 -0400
@@ -23,6 +23,7 @@
 #include <linux/profile.h>
 #include <linux/highmem.h>
 #include <linux/mutex.h>
+#include <linux/condcall.h>
 #include <asm/sections.h>
 #include <asm/semaphore.h>
 #include <asm/irq_regs.h>
@@ -91,6 +92,8 @@
 		printk(KERN_INFO "kernel profiling enabled (shift: %ld)\n",
 			prof_shift);
 	}
+	if (prof_on)
+		BUG_ON(cond_call_arm("profile_on"));
 	return 1;
 }
 __setup("profile=", profile_setup);
@@ -555,6 +558,7 @@
 	return 0;
 out_cleanup:
 	prof_on = 0;
+	cond_call_disarm("profile_on");
 	smp_mb();
 	on_each_cpu(profile_nop, NULL, 0, 1);
 	for_each_online_cpu(cpu) {
Index: linux-2.6-lttng/kernel/sched.c
===================================================================
--- linux-2.6-lttng.orig/kernel/sched.c	2007-05-29 11:38:06.000000000 -0400
+++ linux-2.6-lttng/kernel/sched.c	2007-05-29 11:42:36.000000000 -0400
@@ -54,6 +54,7 @@
 #include <linux/kprobes.h>
 #include <linux/delayacct.h>
 #include <linux/reciprocal_div.h>
+#include <linux/condcall.h>
 
 #include <asm/tlb.h>
 #include <asm/unistd.h>
@@ -972,6 +973,21 @@
 }
 
 /*
+ * Sleep time is in units of nanosecs, so shift by 20 to get a
+ * milliseconds-range estimation of the amount of time that the task
+ * spent sleeping:
+ */
+static inline void activate_task_prof(struct task_struct *p,
+		unsigned long long now)
+{
+	if (unlikely(prof_on == SLEEP_PROFILING)) {
+		if (p->state == TASK_UNINTERRUPTIBLE)
+			profile_hits(SLEEP_PROFILING, (void *)get_wchan(p),
+				     (now - p->timestamp) >> 20);
+	}
+}
+
+/*
  * activate_task - move a task to the runqueue and do priority recalculation
  *
  * Update all the scheduling statistics stuff. (sleep average
@@ -993,18 +1009,7 @@
 			+ rq->most_recent_timestamp;
 	}
 #endif
-
-	/*
-	 * Sleep time is in units of nanosecs, so shift by 20 to get a
-	 * milliseconds-range estimation of the amount of time that the task
-	 * spent sleeping:
-	 */
-	if (unlikely(prof_on == SLEEP_PROFILING)) {
-		if (p->state == TASK_UNINTERRUPTIBLE)
-			profile_hits(SLEEP_PROFILING, (void *)get_wchan(p),
-				     (now - p->timestamp) >> 20);
-	}
-
+	cond_call(profile_on, activate_task_prof(p, now));
 	p->prio = recalc_task_prio(p, now);
 
 	/*
@@ -3534,7 +3539,8 @@
 			print_irqtrace_events(current);
 		dump_stack();
 	}
-	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
+	cond_call(profile_on,
+		profile_hit(SCHED_PROFILING, __builtin_return_address(0)));
 
 need_resched:
 	preempt_disable();

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
