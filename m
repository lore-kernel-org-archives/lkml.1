Return-Path: <linux-kernel-owner+w=401wt.eu-S932562AbXCZFxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbXCZFxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 01:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933602AbXCZFxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 01:53:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36936 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562AbXCZFxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 01:53:17 -0400
Date: Mon, 26 Mar 2007 07:53:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux list <linux-kernel@vger.kernel.org>, ck list <ck@vds.kolivas.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: rSDl cpu scheduler version 0.34-test patch
Message-ID: <20070326055303.GA8927@elte.hu>
References: <200703261100.22467.kernel@kolivas.org> <20070326054631.GA7759@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326054631.GA7759@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > The patches available also include a rollup of sched: accurate user 
> > accounting as this code touches the same area and it is most 
> > convenient to include them together.
> 
> as i mentioned it before, please keep this one separate, as we want to 
> apply it first.

i.e. have the patch below the first patch of the series. Thanks,

	Ingo

----------------------->
Subject: [patch] sched: accurate user accounting
From: Con Kolivas <kernel@kolivas.org>

Currently we only do cpu accounting to userspace based on what is 
actually happening precisely on each tick. The accuracy of that 
accounting gets progressively worse the lower HZ is. As we already keep 
accounting of nanosecond resolution we can accurately track user cpu, 
nice cpu and idle cpu if we move the accounting to update_cpu_clock with 
a nanosecond cpu_usage_stat entry. This increases overhead slightly but 
avoids the problem of tick aliasing errors making accounting unreliable.

Remove the now defunct Documentation/cpu-load.txt file.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/cpu-load.txt  |  113 --------------------------------------------
 include/linux/kernel_stat.h |    3 +
 include/linux/sched.h       |    2 
 kernel/sched.c              |   58 +++++++++++++++++++++-
 kernel/timer.c              |    5 -
 5 files changed, 60 insertions(+), 121 deletions(-)

Index: linux/Documentation/cpu-load.txt
===================================================================
--- linux.orig/Documentation/cpu-load.txt
+++ /dev/null
@@ -1,113 +0,0 @@
-CPU load
---------
-
-Linux exports various bits of information via `/proc/stat' and
-`/proc/uptime' that userland tools, such as top(1), use to calculate
-the average time system spent in a particular state, for example:
-
-    $ iostat
-    Linux 2.6.18.3-exp (linmac)     02/20/2007
-
-    avg-cpu:  %user   %nice %system %iowait  %steal   %idle
-              10.01    0.00    2.92    5.44    0.00   81.63
-
-    ...
-
-Here the system thinks that over the default sampling period the
-system spent 10.01% of the time doing work in user space, 2.92% in the
-kernel, and was overall 81.63% of the time idle.
-
-In most cases the `/proc/stat' information reflects the reality quite
-closely, however due to the nature of how/when the kernel collects
-this data sometimes it can not be trusted at all.
-
-So how is this information collected?  Whenever timer interrupt is
-signalled the kernel looks what kind of task was running at this
-moment and increments the counter that corresponds to this tasks
-kind/state.  The problem with this is that the system could have
-switched between various states multiple times between two timer
-interrupts yet the counter is incremented only for the last state.
-
-
-Example
--------
-
-If we imagine the system with one task that periodically burns cycles
-in the following manner:
-
- time line between two timer interrupts
-|--------------------------------------|
- ^                                    ^
- |_ something begins working          |
-                                      |_ something goes to sleep
-                                     (only to be awaken quite soon)
-
-In the above situation the system will be 0% loaded according to the
-`/proc/stat' (since the timer interrupt will always happen when the
-system is executing the idle handler), but in reality the load is
-closer to 99%.
-
-One can imagine many more situations where this behavior of the kernel
-will lead to quite erratic information inside `/proc/stat'.
-
-
-/* gcc -o hog smallhog.c */
-#include <time.h>
-#include <limits.h>
-#include <signal.h>
-#include <sys/time.h>
-#define HIST 10
-
-static volatile sig_atomic_t stop;
-
-static void sighandler (int signr)
-{
-     (void) signr;
-     stop = 1;
-}
-static unsigned long hog (unsigned long niters)
-{
-     stop = 0;
-     while (!stop && --niters);
-     return niters;
-}
-int main (void)
-{
-     int i;
-     struct itimerval it = { .it_interval = { .tv_sec = 0, .tv_usec = 1 },
-                             .it_value = { .tv_sec = 0, .tv_usec = 1 } };
-     sigset_t set;
-     unsigned long v[HIST];
-     double tmp = 0.0;
-     unsigned long n;
-     signal (SIGALRM, &sighandler);
-     setitimer (ITIMER_REAL, &it, NULL);
-
-     hog (ULONG_MAX);
-     for (i = 0; i < HIST; ++i) v[i] = ULONG_MAX - hog (ULONG_MAX);
-     for (i = 0; i < HIST; ++i) tmp += v[i];
-     tmp /= HIST;
-     n = tmp - (tmp / 3.0);
-
-     sigemptyset (&set);
-     sigaddset (&set, SIGALRM);
-
-     for (;;) {
-         hog (n);
-         sigwait (&set, &i);
-     }
-     return 0;
-}
-
-
-References
-----------
-
-http://lkml.org/lkml/2007/2/12/6
-Documentation/filesystems/proc.txt (1.8)
-
-
-Thanks
-------
-
-Con Kolivas, Pavel Machek
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
@@ -89,6 +89,7 @@ unsigned long long __attribute__((weak))
  */
 #define NS_TO_JIFFIES(TIME)	((TIME) / (1000000000 / HZ))
 #define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
+#define JIFFY_NS		JIFFIES_TO_NS(1)
 
 /*
  * These are the 'tuning knobs' of the scheduler:
@@ -3017,8 +3018,59 @@ EXPORT_PER_CPU_SYMBOL(kstat);
 static inline void
 update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long long now)
 {
-	p->sched_time += now - p->last_ran;
-	p->last_ran = rq->most_recent_timestamp = now;
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t time_diff;
+
+	/* Sanity check. It should never go backwards or ruin accounting */
+	if (unlikely(now < p->last_ran))
+		goto out_set;
+	/* All the userspace visible cpu accounting is done here */
+	time_diff = now - p->last_ran;
+	p->sched_time += time_diff;
+	if (p != rq->idle) {
+		cputime_t utime_diff = time_diff;
+
+		if (TASK_NICE(p) > 0) {
+			cpustat->nice_ns = cputime64_add(cpustat->nice_ns,
+							 time_diff);
+			if (cpustat->nice_ns > JIFFY_NS) {
+				cpustat->nice_ns =
+					cputime64_sub(cpustat->nice_ns,
+					JIFFY_NS);
+				cpustat->nice =
+					cputime64_add(cpustat->nice, 1);
+			}
+		} else {
+			cpustat->user_ns = cputime64_add(cpustat->user_ns,
+							 time_diff);
+			if (cpustat->user_ns > JIFFY_NS) {
+				cpustat->user_ns =
+					cputime64_sub(cpustat->user_ns,
+					JIFFY_NS);
+				cpustat ->user =
+					cputime64_add(cpustat->user, 1);
+			}
+		}
+		p->utime_ns = cputime_add(p->utime_ns, utime_diff);
+		if (p->utime_ns > JIFFY_NS) {
+			p->utime_ns = cputime_sub(p->utime_ns, JIFFY_NS);
+			p->utime = cputime_add(p->utime,
+					       jiffies_to_cputime(1));
+		}
+	} else {
+		cpustat->idle_ns = cputime64_add(cpustat->idle_ns, time_diff);
+		if (cpustat->idle_ns > JIFFY_NS) {
+			cpustat->idle_ns = cputime64_sub(cpustat->idle_ns,
+							 JIFFY_NS);
+			cpustat->idle = cputime64_add(cpustat->idle, 1);
+		}
+	}
+out_set:
+	/*
+	 * We still need to set these values even if the clock appeared to
+	 * go backwards in case _this_ is the correct timestamp.
+	 */
+	rq->most_recent_timestamp = p->last_ran = now;
 }
 
 /*
@@ -3104,8 +3156,6 @@ void account_system_time(struct task_str
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
