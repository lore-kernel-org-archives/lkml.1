Return-Path: <linux-kernel-owner+w=401wt.eu-S1766764AbXDSPCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766764AbXDSPCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766767AbXDSPCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:02:39 -0400
Received: from mail06.syd.optusnet.com.au ([211.29.132.187]:57482 "EHLO
	mail06.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766764AbXDSPCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:02:38 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>
Subject: [PATCH] [1/3] sched: implement staircase deadline scheduler timeslice fixes
Date: Fri, 20 Apr 2007 01:01:49 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704200101.49823.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first in a series of 3 patches to bring the staircase deadline cpu
scheduler up to version 0.43. They apply on top of
"[PATCH] sched: implement staircase deadline scheduler further improvements-1"
Assuming we're still queueing these up in -mm for comparison, that patch is
still outstanding.

---
There is no need for time_slice and quota to be stored in nanoseconds and
can overflow on 32bit when rr_intervals are large. Convert them to
microseconds.

This then allows the maximum rr_interval to be as large as 5000 milliseconds.

Alter the choice of initial rr_interval to scale more with cpus in an
understandable fashion along with explanation.

Don't check that rr_interval is at least one tick every time rr_quota is
called. Simply allow it to be less if the user desires and allow aliasing
to keep accounting sane overall.

Thanks to Nick Piggin for suggesting larger timeslices.
Thanks to Peter Zijlstra for help.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 kernel/sched.c  |   45 +++++++++++++++++++++++----------------------
 kernel/sysctl.c |   11 ++++++-----
 2 files changed, 29 insertions(+), 27 deletions(-)

Index: linux-2.6.21-rc7-sd/kernel/sched.c
===================================================================
--- linux-2.6.21-rc7-sd.orig/kernel/sched.c	2007-04-19 22:50:01.000000000 +1000
+++ linux-2.6.21-rc7-sd/kernel/sched.c	2007-04-19 23:59:24.000000000 +1000
@@ -53,6 +53,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/kprobes.h>
 #include <linux/delayacct.h>
+#include <linux/log2.h>
 #include <asm/tlb.h>
 
 #include <asm/unistd.h>
@@ -89,7 +90,7 @@ unsigned long long __attribute__((weak))
 /* Some helpers for converting to/from various scales.*/
 #define NS_TO_JIFFIES(TIME)	((TIME) / (1000000000 / HZ))
 #define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
-#define MS_TO_NS(TIME)		((TIME) * 1000000)
+#define MS_TO_US(TIME)		((TIME) * 1000)
 /* Can return 0 */
 #define MS_TO_JIFFIES(TIME)	((TIME) * HZ / 1000)
 #define JIFFIES_TO_MS(TIME)	((TIME) * 1000 / HZ)
@@ -101,9 +102,8 @@ unsigned long long __attribute__((weak))
  * Value is in ms and set to a minimum of 8ms. Scales with number of cpus.
  * Tunable via /proc interface.
  */
-int rr_interval __read_mostly;
+int rr_interval __read_mostly = 8;
 
-#define RR_INTERVAL		8
 #define DEF_TIMESLICE		(rr_interval * 20)
 
 /*
@@ -988,23 +988,20 @@ static int effective_prio(struct task_st
  * tick still. Below nice 0 they get progressively larger.
  * ie nice -6..0 = rr_interval. nice -10 = 2.5 * rr_interval
  * nice -20 = 10 * rr_interval. nice 1-19 = rr_interval / 2.
- * Value returned is in nanoseconds.
+ * Value returned is in microseconds.
  */
 static unsigned int rr_quota(struct task_struct *p)
 {
 	int nice = TASK_NICE(p), rr = rr_interval;
 
-	/* Ensure that rr_interval is at least 1 tick */
-	if (unlikely(!MS_TO_JIFFIES(rr)))
-		rr = rr_interval = JIFFIES_TO_MS(1) ? : 1;
 	if (!rt_task(p)) {
 		if (nice < -6) {
 			rr *= nice * nice;
 			rr /= 40;
-		} else if (nice > 0 && (rr * HZ / 1000 / 2) > 0)
-			rr /= 2;
+		} else if (nice > 0)
+			rr = rr / 2 ? : 1;
 	}
-	return MS_TO_NS(rr);
+	return MS_TO_US(rr);
 }
 
 /*
@@ -3015,16 +3012,17 @@ EXPORT_PER_CPU_SYMBOL(kstat);
 /*
  * This is called on clock ticks and on context switches.
  * Bank in p->sched_time the ns elapsed since the last tick or switch.
- * CPU scheduler quota accounting is also performed here.
+ * CPU scheduler quota accounting is also performed here in microseconds.
  * The value returned from sched_clock() occasionally gives bogus values so
  * some sanity checking is required.
  */
-static inline void
+static void
 update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long long now,
 		 int tick)
 {
 	cputime64_t time_diff = now - p->last_ran;
-	unsigned int min_diff = 1000;
+	const unsigned int min_diff = 1000;
+	int us_time_diff;
 
 	if (tick) {
 		/*
@@ -3043,8 +3041,11 @@ update_cpu_clock(struct task_struct *p, 
 		if (time_diff > JIFFIES_TO_NS(1) || time_diff < min_diff)
 			time_diff = min_diff;
 	}
+	/* time_slice accounting is done in usecs to avoid overflow on 32bit */
+	us_time_diff = time_diff;
+	us_time_diff /= 1000;
 	if (p != rq->idle && p->policy != SCHED_FIFO)
-		p->time_slice -= time_diff;
+		p->time_slice -= us_time_diff;
 	p->sched_time += time_diff;
 	p->last_ran = rq->most_recent_timestamp = now;
 }
@@ -3145,8 +3146,7 @@ void account_steal_time(struct task_stru
 static void task_expired_entitlement(struct rq *rq, struct task_struct *p)
 {
 	struct prio_array *old_array;
-	int overrun;
-	int old_prio;
+	int overrun, old_prio;
 
 	if (unlikely(p->first_time_slice))
 		p->first_time_slice = 0;
@@ -6653,6 +6653,13 @@ void __init sched_init_smp(void)
 	/* Move init over to a non-isolated CPU */
 	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
 		BUG();
+
+	/*
+	 * Assume that every added cpu gives us slightly less overall latency
+	 * allowing us to increase the base rr_interval, but in a non linear
+	 * fashion.
+	 */
+	rr_interval *= 1 + ilog2(num_online_cpus());
 }
 #else
 void __init sched_init_smp(void)
@@ -6673,7 +6680,6 @@ int in_sched_functions(unsigned long add
 void __init sched_init(void)
 {
 	int i, j, k;
-	unsigned int rr_us = 0, rr_inc = RR_INTERVAL * 1000;
 
 	/* Generate the priority matrix */
 	for (i = 0; i < PRIO_RANGE; i++) {
@@ -6724,12 +6730,7 @@ void __init sched_init(void)
 			__set_bit(MAX_PRIO, array->prio_bitmap);
 		}
 
-		/* Every added cpu increases the rr_interval */
-		rr_us += rr_inc;
-		rr_inc /= 2;
 	}
-	rr_interval = rr_us / 1000;
-
 	set_load_weight(&init_task);
 
 #ifdef CONFIG_SMP
Index: linux-2.6.21-rc7-sd/kernel/sysctl.c
===================================================================
--- linux-2.6.21-rc7-sd.orig/kernel/sysctl.c	2007-04-19 23:59:58.000000000 +1000
+++ linux-2.6.21-rc7-sd/kernel/sysctl.c	2007-04-20 00:07:05.000000000 +1000
@@ -160,11 +160,12 @@ int sysctl_legacy_va_layout;
 #endif
 
 
-/* Constants for minimum and maximum testing in vm_table.
+/* Constants for minimum and maximum testing.
    We use these as one-element integer vectors. */
-static int  __read_mostly zero;
-static int  __read_mostly one = 1;
-static int  __read_mostly one_hundred = 100;
+static int __read_mostly zero;
+static int __read_mostly one = 1;
+static int __read_mostly one_hundred = 100;
+static int __read_mostly five_thousand = 5000;
 
 
 /* The default sysctl tables: */
@@ -516,7 +517,7 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec_minmax,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &one,
-		.extra2		= &one_hundred,
+		.extra2		= &five_thousand,
 	},
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
 	{


-- 
-ck
