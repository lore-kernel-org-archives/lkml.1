Return-Path: <linux-kernel-owner+w=401wt.eu-S932773AbXCYJFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773AbXCYJFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 05:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933215AbXCYJFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 05:05:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47815 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932773AbXCYJFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 05:05:32 -0400
Date: Sun, 25 Mar 2007 11:04:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux list <linux-kernel@vger.kernel.org>, malc <av1474@comtv.ru>,
       zwane@infradead.org, ck list <ck@vds.kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] sched: accurate user accounting
Message-ID: <20070325090453.GA30423@elte.hu>
References: <200703251159.03616.kernel@kolivas.org> <20070325075134.GA14453@elte.hu> <200703251839.24148.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703251839.24148.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:

> > +/*
> > + * Some helpers for converting nanosecond timing to jiffy resolution
> > + */
> > +#define NS_TO_JIFFIES(TIME)   ((TIME) / (1000000000 / HZ))
> > +#define JIFFIES_TO_NS(TIME)   ((TIME) * (1000000000 / HZ))
> > +
> 
> This hunk is already in mainline so it will be double defined now.

yeah. Updated patch below.

	Ingo

---------------------->
Subject: [patch] sched: accurate user accounting
From: Con Kolivas <kernel@kolivas.org>

Currently we only do cpu accounting to userspace based on what is 
actually happening precisely on each tick. The accuracy of that 
accounting gets progressively worse the lower HZ is. As we already keep 
accounting of nanosecond resolution we can accurately track user cpu, 
nice cpu and idle cpu if we move the accounting to update_cpu_clock with 
a nanosecond cpu_usage_stat entry. This increases overhead slightly but 
avoids the problem of tick aliasing errors making accounting unreliable.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/kernel_stat.h |    3 ++
 include/linux/sched.h       |    2 -
 kernel/sched.c              |   46 +++++++++++++++++++++++++++++++++++++++++---
 kernel/timer.c              |    5 +---
 4 files changed, 49 insertions(+), 7 deletions(-)

Index: linux/include/linux/kernel_stat.h
===================================================================
--- linux.orig/include/linux/kernel_stat.h
+++ linux/include/linux/kernel_stat.h
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
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -882,7 +882,7 @@ struct task_struct {
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
 
 	unsigned long rt_priority;
-	cputime_t utime, stime;
+	cputime_t utime, utime_ns, stime;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time;
 /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -3017,8 +3017,50 @@ EXPORT_PER_CPU_SYMBOL(kstat);
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
@@ -3104,8 +3146,6 @@ void account_system_time(struct task_str
 		cpustat->system = cputime64_add(cpustat->system, tmp);
 	else if (atomic_read(&rq->nr_iowait) > 0)
 		cpustat->iowait = cputime64_add(cpustat->iowait, tmp);
-	else
-		cpustat->idle = cputime64_add(cpustat->idle, tmp);
 	/* Account for system time used */
 	acct_update_integrals(p);
 }
Index: linux/kernel/timer.c
===================================================================
--- linux.orig/kernel/timer.c
+++ linux/kernel/timer.c
@@ -1196,10 +1196,9 @@ void update_process_times(int user_tick)
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
