Return-Path: <linux-kernel-owner+w=401wt.eu-S964788AbXCYB74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964788AbXCYB74 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 21:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964789AbXCYB74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 21:59:56 -0400
Received: from mail02.syd.optusnet.com.au ([211.29.132.183]:36487 "EHLO
	mail02.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964788AbXCYB7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 21:59:54 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux list <linux-kernel@vger.kernel.org>
Subject: [PATCH] [RFC] sched: accurate user accounting
Date: Sun, 25 Mar 2007 11:59:03 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 532
Cc: malc <av1474@comtv.ru>, zwane@infradead.org, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, ijuz@mannheim.wgermanyrulez.de
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703251159.03616.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For an rsdl 0.33 patched kernel. Comments? Overhead worth it?

---
Currently we only do cpu accounting to userspace based on what is actually
happening precisely on each tick. The accuracy of that accounting gets
progressively worse the lower HZ is. As we already keep accounting of
nanosecond resolution we can accurately track user cpu, nice cpu and idle cpu
if we move the accounting to update_cpu_clock with a nanosecond cpu_usage_stat
entry. This increases overhead slightly but avoids the problem of tick
aliasing errors making accounting unreliable.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 include/linux/kernel_stat.h |    3 ++
 include/linux/sched.h       |    2 -
 kernel/sched.c              |   51 +++++++++++++++++++++++++++++++++++++++++---
 kernel/timer.c              |    5 +---
 4 files changed, 54 insertions(+), 7 deletions(-)

Index: linux-2.6.20.4-ck1/include/linux/kernel_stat.h
===================================================================
--- linux-2.6.20.4-ck1.orig/include/linux/kernel_stat.h	2007-03-25 09:47:52.000000000 +1000
+++ linux-2.6.20.4-ck1/include/linux/kernel_stat.h	2007-03-25 11:31:29.000000000 +1000
@@ -16,11 +16,14 @@
 
 struct cpu_usage_stat {
 	cputime64_t user;
+	cputime64_t user_ns;
 	cputime64_t nice;
+	cputime64_t nice_ns;
 	cputime64_t system;
 	cputime64_t softirq;
 	cputime64_t irq;
 	cputime64_t idle;
+	cputime64_t idle_ns;
 	cputime64_t iowait;
 	cputime64_t steal;
 };
Index: linux-2.6.20.4-ck1/kernel/sched.c
===================================================================
--- linux-2.6.20.4-ck1.orig/kernel/sched.c	2007-03-25 09:47:56.000000000 +1000
+++ linux-2.6.20.4-ck1/kernel/sched.c	2007-03-25 11:42:28.000000000 +1000
@@ -77,6 +77,11 @@
 #define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
 #define SCHED_PRIO(p)		((p)+MAX_RT_PRIO)
 
+/*
+ * Some helpers for converting nanosecond timing to jiffy resolution
+ */
+#define NS_TO_JIFFIES(TIME)	((TIME) / (1000000000 / HZ))
+#define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
 #define TASK_PREEMPTS_CURR(p, curr)	((p)->prio < (curr)->prio)
 
 /*
@@ -2993,8 +2998,50 @@ EXPORT_PER_CPU_SYMBOL(kstat);
 static inline void
 update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long long now)
 {
-	p->sched_time += now - p->last_ran;
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t time_diff = now - p->last_ran;
+
+	p->sched_time += time_diff;
 	p->last_ran = rq->most_recent_timestamp = now;
+	if (p != rq->idle) {
+		cputime_t utime_diff = time_diff;
+
+		if (TASK_NICE(p) > 0) {
+			cpustat->nice_ns = cputime64_add(cpustat->nice_ns,
+							 time_diff);
+			if (NS_TO_JIFFIES(cpustat->nice_ns) > 1) {
+				cpustat->nice_ns =
+					cputime64_sub(cpustat->nice_ns,
+					JIFFIES_TO_NS(1));
+				cpustat->nice =
+					cputime64_add(cpustat->nice, 1);
+			}
+		} else {
+			cpustat->user_ns = cputime64_add(cpustat->user_ns,
+						time_diff);
+			if (NS_TO_JIFFIES(cpustat->user_ns) > 1) {
+				cpustat->user_ns =
+					cputime64_sub(cpustat->user_ns,
+					JIFFIES_TO_NS(1));
+				cpustat ->user =
+					cputime64_add(cpustat->user, 1);
+			}
+		}
+		p->utime_ns = cputime_add(p->utime_ns, utime_diff);
+		if (NS_TO_JIFFIES(p->utime_ns) > 1) {
+			p->utime_ns = cputime_sub(p->utime_ns,
+						  JIFFIES_TO_NS(1));
+			p->utime = cputime_add(p->utime,
+					       jiffies_to_cputime(1));
+		}
+	} else {
+		cpustat->idle_ns = cputime64_add(cpustat->idle_ns, time_diff);
+		if (NS_TO_JIFFIES(cpustat->idle_ns) > 1) {
+			cpustat->idle_ns = cputime64_sub(cpustat->idle_ns,
+							 JIFFIES_TO_NS(1));
+			cpustat->idle = cputime64_add(cpustat->idle, 1);
+		}
+	}
 }
 
 /*
@@ -3059,8 +3106,6 @@ void account_system_time(struct task_str
 		cpustat->system = cputime64_add(cpustat->system, tmp);
 	else if (atomic_read(&rq->nr_iowait) > 0)
 		cpustat->iowait = cputime64_add(cpustat->iowait, tmp);
-	else
-		cpustat->idle = cputime64_add(cpustat->idle, tmp);
 	/* Account for system time used */
 	acct_update_integrals(p);
 }
Index: linux-2.6.20.4-ck1/include/linux/sched.h
===================================================================
--- linux-2.6.20.4-ck1.orig/include/linux/sched.h	2007-03-25 11:08:21.000000000 +1000
+++ linux-2.6.20.4-ck1/include/linux/sched.h	2007-03-25 11:08:54.000000000 +1000
@@ -903,7 +903,7 @@ struct task_struct {
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
 
 	unsigned long rt_priority;
-	cputime_t utime, stime;
+	cputime_t utime, utime_ns, stime;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time;
 /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
Index: linux-2.6.20.4-ck1/kernel/timer.c
===================================================================
--- linux-2.6.20.4-ck1.orig/kernel/timer.c	2007-03-25 11:28:56.000000000 +1000
+++ linux-2.6.20.4-ck1/kernel/timer.c	2007-03-25 11:30:44.000000000 +1000
@@ -1106,10 +1106,9 @@ void update_process_times(int user_tick)
 	int cpu = smp_processor_id();
 
 	/* Note: this timer irq context must be accounted for as well. */
-	if (user_tick)
-		account_user_time(p, jiffies_to_cputime(1));
-	else
+	if (!user_tick)
 		account_system_time(p, HARDIRQ_OFFSET, jiffies_to_cputime(1));
+	/* User time is accounted for in update_cpu_clock in sched.c */
 	run_local_timers();
 	if (rcu_pending(cpu))
 		rcu_check_callbacks(cpu, user_tick);

-- 
-ck
