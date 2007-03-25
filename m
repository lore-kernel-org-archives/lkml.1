Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbXCYX6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbXCYX6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 19:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933006AbXCYX6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 19:58:43 -0400
Received: from mail16.syd.optusnet.com.au ([211.29.132.197]:54421 "EHLO
	mail16.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932903AbXCYX6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 19:58:41 -0400
From: Con Kolivas <kernel@kolivas.org>
To: malc <av1474@comtv.ru>
Subject: Re: [patch] sched: accurate user accounting
Date: Mon, 26 Mar 2007 09:57:34 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       zwane@infradead.org, ck list <ck@vds.kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200703251159.03616.kernel@kolivas.org> <Pine.LNX.4.64.0703252107590.31900@linmac.oyster.ru> <200703260901.54943.kernel@kolivas.org>
In-Reply-To: <200703260901.54943.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703260957.34798.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 March 2007 09:01, Con Kolivas wrote:
> On Monday 26 March 2007 03:14, malc wrote:
> > On Mon, 26 Mar 2007, Con Kolivas wrote:
> > > On Monday 26 March 2007 01:19, malc wrote:
> > Erm... i just looked at the code and suddenly it stopped making any sense
> > at all:
> >
> >          p->last_ran = rq->most_recent_timestamp = now;
> >          /* Sanity check. It should never go backwards or ruin accounting
> > */ if (unlikely(now < p->last_ran))
> >                  return;
> >          time_diff = now - p->last_ran;
> >
> > First `now' is assigned to `p->last_ran' and the very next line
> > compares those two values, and then the difference is taken.. I quite
> > frankly am either very tired or fail to see the point.. time_diff is
> > either always zero or there's always a race here.
>
> Bah major thinko error on my part! That will teach me to post patches
> untested at 1:30 am. I'll try again shortly sorry.

Ok this one is heavily tested. Please try it when you find the time.

---
Currently we only do cpu accounting to userspace based on what is 
actually happening precisely on each tick. The accuracy of that 
accounting gets progressively worse the lower HZ is. As we already keep 
accounting of nanosecond resolution we can accurately track user cpu, 
nice cpu and idle cpu if we move the accounting to update_cpu_clock with 
a nanosecond cpu_usage_stat entry. This increases overhead slightly but 
avoids the problem of tick aliasing errors making accounting unreliable.

Remove the now defunct Documentation/cpu-load.txt file.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 Documentation/cpu-load.txt  |  113 --------------------------------------------
 include/linux/kernel_stat.h |    3 +
 include/linux/sched.h       |    2 
 kernel/sched.c              |   58 +++++++++++++++++++++-
 kernel/timer.c              |    5 -
 5 files changed, 60 insertions(+), 121 deletions(-)

Index: linux-2.6.21-rc4-acct/include/linux/kernel_stat.h
===================================================================
--- linux-2.6.21-rc4-acct.orig/include/linux/kernel_stat.h	2007-03-26 00:56:05.000000000 +1000
+++ linux-2.6.21-rc4-acct/include/linux/kernel_stat.h	2007-03-26 00:56:25.000000000 +1000
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
Index: linux-2.6.21-rc4-acct/include/linux/sched.h
===================================================================
--- linux-2.6.21-rc4-acct.orig/include/linux/sched.h	2007-03-26 00:56:05.000000000 +1000
+++ linux-2.6.21-rc4-acct/include/linux/sched.h	2007-03-26 00:57:01.000000000 +1000
@@ -882,7 +882,7 @@ struct task_struct {
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
 
 	unsigned long rt_priority;
-	cputime_t utime, stime;
+	cputime_t utime, utime_ns, stime;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time;
 /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
Index: linux-2.6.21-rc4-acct/kernel/sched.c
===================================================================
--- linux-2.6.21-rc4-acct.orig/kernel/sched.c	2007-03-26 00:56:05.000000000 +1000
+++ linux-2.6.21-rc4-acct/kernel/sched.c	2007-03-26 09:38:50.000000000 +1000
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
Index: linux-2.6.21-rc4-acct/kernel/timer.c
===================================================================
--- linux-2.6.21-rc4-acct.orig/kernel/timer.c	2007-03-26 00:56:05.000000000 +1000
+++ linux-2.6.21-rc4-acct/kernel/timer.c	2007-03-26 00:56:25.000000000 +1000
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
Index: linux-2.6.21-rc4-acct/Documentation/cpu-load.txt
===================================================================
--- linux-2.6.21-rc4-acct.orig/Documentation/cpu-load.txt	2007-03-21 12:52:51.000000000 +1100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
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

-- 
-ck
