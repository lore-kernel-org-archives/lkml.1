Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZG2MdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZG2MdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZG2MdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:33:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42599 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbZG2MdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:33:19 -0400
Date: Wed, 29 Jul 2009 14:31:51 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC PATCH] Fix posix CPUCLOCK_{PROF,VIRT} periodic precision
Message-ID: <20090729123150.GA4272@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I found we have similar lack of precision as in itimers with posix cpu
timers when clockid is based on CPUCLOCK_PROF and CPUCLOCK_VIRT. This can
be showed by attached program. It generate below output on my laptop:

Without patch:

CLK_PROF
Period 10000:	counted time 6.46 , real time 7.12 , error -9.2 %
Period 9998:	counted time 7.11 , real time 7.11 , error -0.1 %
Period 1000:	counted time 3.56 , real time 7.12 , error -50.0 %
Period 11111:	counted time 6.58 , real time 7.11 , error -7.5 %
Period 21315:	counted time 6.88 , real time 7.11 , error -3.1 %
Period 1500:	counted time 5.34 , real time 7.12 , error -25.0 %
Period 15000:	counted time 6.66 , real time 7.11 , error -6.3 %
Period 50000:	counted time 6.95 , real time 7.11 , error -2.2 %
Period 500:	counted time 3.57 , real time 7.13 , error -50.0 %
CLK_VIRT
Period 10000:	counted time 6.46 , real time 7.11 , error -9.1 %
Period 9998:	counted time 7.10 , real time 7.11 , error -0.1 %
Period 1000:	counted time 3.55 , real time 7.12 , error -50.1 %
Period 11111:	counted time 6.58 , real time 7.11 , error -7.5 %
Period 21315:	counted time 6.88 , real time 7.11 , error -3.1 %
Period 1500:	counted time 5.33 , real time 7.12 , error -25.0 %
Period 15000:	counted time 6.64 , real time 7.11 , error -6.5 %
Period 50000:	counted time 6.95 , real time 7.11 , error -2.2 %
Period 500:	counted time 3.56 , real time 7.13 , error -50.0 % 

With patch:

CLK_PROF
Period 10000:	counted time 7.10 , real time 7.11 , error -0.2 %
Period 9998:	counted time 7.10 , real time 7.11 , error -0.2 %
Period 1000:	counted time 7.12 , real time 7.13 , error -0.1 %
Period 11111:	counted time 7.10 , real time 7.11 , error -0.1 %
Period 21315:	counted time 7.08 , real time 7.10 , error -0.3 %
Period 1500:	counted time 7.11 , real time 7.12 , error -0.1 %
Period 15000:	counted time 7.08 , real time 7.10 , error -0.3 %
Period 50000:	counted time 7.05 , real time 7.10 , error -0.7 %
Period 500:	counted time 3.56 , real time 7.12 , error -50.0 %
CLK_VIRT
Period 10000:	counted time 7.09 , real time 7.10 , error -0.2 %
Period 9998:	counted time 7.09 , real time 7.10 , error -0.2 %
Period 1000:	counted time 7.11 , real time 7.12 , error -0.2 %
Period 11111:	counted time 7.10 , real time 7.10 , error -0.0 %
Period 21315:	counted time 7.08 , real time 7.11 , error -0.4 %
Period 1500:	counted time 7.11 , real time 7.11 , error -0.1 %
Period 15000:	counted time 7.08 , real time 7.10 , error -0.3 %
Period 50000:	counted time 7.05 , real time 7.10 , error -0.7 %
Period 500:	counted time 3.56 , real time 7.12 , error -50.0 %

I think timers should be fixed (or maybe removed at all, is that
possible ?) This is first version of patch with fix, just for review. 
It's written on top of my itimer patches.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

---
 include/linux/posix-timers.h |    1 +
 kernel/posix-cpu-timers.c    |   51 +++++++++++++++++++++++++++++++++++------
 2 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 4f71bf4..d429c82 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -13,6 +13,7 @@ union cpu_time_count {
 struct cpu_timer_list {
 	struct list_head entry;
 	union cpu_time_count expires, incr;
+	u32 error, incr_error;
 	struct task_struct *task;
 	int firing;
 };
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 18bdde6..2bbe76a 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -9,6 +9,19 @@
 #include <asm/uaccess.h>
 #include <linux/kernel_stat.h>
 
+static u32 onecputick;
+
+static inline u32 cputime_sub_ns(cputime_t ct, s64 real_ns)
+{
+	struct timespec ts;
+	s64 cpu_ns;
+
+	cputime_to_timespec(ct, &ts);
+	cpu_ns = timespec_to_ns(&ts);
+
+	return (cpu_ns <= real_ns) ? 0 : cpu_ns - real_ns;
+}
+
 /*
  * Called after updating RLIMIT_CPU to set timer expiration if necessary.
  */
@@ -147,6 +160,8 @@ static void bump_cpu_timer(struct k_itimer *timer,
 		}
 	} else {
 		cputime_t delta, incr;
+		u64 error, incr_error, incr_error_val;
+		unsigned long nticks;
 
 		if (cputime_lt(now.cpu, timer->it.cpu.expires.cpu))
 			return;
@@ -154,16 +169,32 @@ static void bump_cpu_timer(struct k_itimer *timer,
 		delta = cputime_sub(cputime_add(now.cpu, incr),
 				    timer->it.cpu.expires.cpu);
 		/* Don't use (incr*2 < delta), incr*2 might overflow. */
-		for (i = 0; cputime_lt(incr, cputime_sub(delta, incr)); i++)
-			     incr = cputime_add(incr, incr);
-		for (; i >= 0; incr = cputime_halve(incr), i--) {
-			if (cputime_lt(delta, incr))
+		incr_error = timer->it.cpu.incr_error;
+		for (i = 0; cputime_lt(incr, cputime_sub(delta, incr)); i++) {
+			incr = cputime_add(incr, incr);
+			incr_error += incr_error;
+		}
+
+		incr_error_val = incr_error;
+		for ( ; i >= 0; incr = cputime_halve(incr), incr_error >>= 1, i--) {
+			if (cputime_lt(delta, incr)) {
+				incr_error_val -= incr_error;
 				continue;
+			}
 			timer->it.cpu.expires.cpu =
 				cputime_add(timer->it.cpu.expires.cpu, incr);
 			timer->it_overrun += 1 << i;
 			delta = cputime_sub(delta, incr);
 		}
+
+		error = timer->it.cpu.error + incr_error_val;
+		timer->it.cpu.error = do_div(error, onecputick);
+		nticks = (unsigned long) error;
+		timer->it_overrun -= nticks;
+		if (timer->it_overrun < 0)
+			timer->it_overrun = 0;
+		timer->it.cpu.expires.cpu = cputime_sub(timer->it.cpu.expires.cpu,
+							jiffies_to_cputime(nticks));
 	}
 }
 
@@ -397,6 +428,8 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 	INIT_LIST_HEAD(&new_timer->it.cpu.entry);
 	new_timer->it.cpu.incr.sched = 0;
 	new_timer->it.cpu.expires.sched = 0;
+	new_timer->it.cpu.error = 0;
+	new_timer->it.cpu.incr_error = 0;
 
 	read_lock(&tasklist_lock);
 	if (CPUCLOCK_PERTHREAD(new_timer->it_clock)) {
@@ -840,6 +873,9 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	 */
 	timer->it.cpu.incr = timespec_to_sample(timer->it_clock,
 						&new->it_interval);
+	timer->it.cpu.incr_error = cputime_sub_ns(timer->it.cpu.incr.cpu,
+						  timespec_to_ns(&new->it_interval));
+	timer->it.cpu.error = 0;
 
 	/*
 	 * This acts as a modification timestamp for the timer,
@@ -1072,7 +1108,6 @@ static void stop_process_timers(struct task_struct *tsk)
 	spin_unlock_irqrestore(&cputimer->lock, flags);
 }
 
-static u32 onecputick;
 
 static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
 			     cputime_t *expires, cputime_t cur_time, int signo)
@@ -1709,13 +1744,13 @@ static __init int init_posix_cpu_timers(void)
 	};
 	struct timespec ts;
 
-	register_posix_clock(CLOCK_PROCESS_CPUTIME_ID, &process);
-	register_posix_clock(CLOCK_THREAD_CPUTIME_ID, &thread);
-
 	cputime_to_timespec(cputime_one_jiffy, &ts);
 	onecputick = ts.tv_nsec;
 	WARN_ON(ts.tv_sec != 0);
 
+	register_posix_clock(CLOCK_PROCESS_CPUTIME_ID, &process);
+	register_posix_clock(CLOCK_THREAD_CPUTIME_ID, &thread);
+
 	return 0;
 }
 __initcall(init_posix_cpu_timers);
-- 
1.6.2.5


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cputimer_test.c"

#include <sys/time.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <unistd.h>

#define ARRAY_SIZE(a) (sizeof(a)/sizeof(a[0]))

const int test_periods_us[] = {
	10000,
	9998,
	1000,
	11111,
	21315,
	1500,
	15000,
	50000,
	500,
};

volatile int prof_counter;

void handler(int signr)
{
	prof_counter++;
}

#define CPUCLOCK_PROF		0
#define CPUCLOCK_VIRT		1
#define CPUCLOCK_SCHED		2

#define MAKE_PROCESS_CPUCLOCK(pid, clock) \
	((~(clockid_t) (pid) << 3) | (clockid_t) (clock))

#define CLK_PROF	MAKE_PROCESS_CPUCLOCK(0, CPUCLOCK_PROF)
#define CLK_VIRT	MAKE_PROCESS_CPUCLOCK(0, CPUCLOCK_VIRT)
#define CLK_SCHED	MAKE_PROCESS_CPUCLOCK(0, CPUCLOCK_SCHED)

void test_func(void)
{
	int i = 0;
	int count = 0;

	for(i=0; i<2000000000; i++)
		count++;
}

double timeval_diff(const struct timeval *start, const struct timeval *end)
{
	return (end->tv_sec - start->tv_sec) + (end->tv_usec - start->tv_usec)/1000000.0;
}

void measure_itimer_error(int period_us, clockid_t clk_id)
{
	struct sigaction act;
	struct timeval start, end;
	struct sigevent evt;
	double real_time, counted_time;
	timer_t tid;

	prof_counter = 0;

	struct timespec period_ts = {
		.tv_sec = 0,
		.tv_nsec = period_us * 1000,
	};
	struct itimerspec timer_spec = {
		.it_interval = period_ts,
		.it_value = period_ts
	};

	act.sa_handler = handler;
	sigemptyset(&act.sa_mask);
	act.sa_flags = 0;
	if (sigaction(SIGPROF, &act, NULL) < 0) {
		printf("sigaction failed\n");
		exit(1);
	}

	memset(&evt, 0, sizeof(evt));
	evt.sigev_notify = SIGEV_SIGNAL;
	evt.sigev_signo = SIGPROF;
	if (timer_create(clk_id, &evt,  &tid) <  0) {
		perror("timer_create");
		exit(1);
	}

	if (timer_settime(tid, 0, &timer_spec,  NULL) < 0) {
		perror("timer_settime");
		exit(1);
	}

	/* run a busy loop and measure it */
	gettimeofday(&start, NULL);
	test_func();
	gettimeofday(&end, NULL);

	/* disable the timer */
	memset(&timer_spec, 0, sizeof(timer_spec));
	if (timer_settime(tid, 0,  &timer_spec, NULL) < 0) {
		perror("timer_settime");
		exit(1);
	}
	if (timer_delete(tid) < 0) {
		perror("timer_delete");
		exit(1);
	}

	counted_time = prof_counter * period_us / 1000000.0;
	real_time = timeval_diff(&start, &end);

	printf("Period %d:\tcounted time %.2f , real time %.2f , error %.1f %%\n",
		period_us, counted_time, real_time, (counted_time/real_time - 1.0)*100.0);
}

int main()
{
	int i;
	
	printf("CLK_PROF\n");	
	for (i=0; i<ARRAY_SIZE(test_periods_us); i++)
		measure_itimer_error(test_periods_us[i], CLK_PROF);
	printf("CLK_VIRT\n");
	for (i=0; i<ARRAY_SIZE(test_periods_us); i++)
		measure_itimer_error(test_periods_us[i], CLK_VIRT);
	
	return 0;
}

--7AUc2qLy4jB3hD7Z--
