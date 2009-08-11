Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbZHKOca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbZHKOca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZHKOc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:32:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40989 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbZHKOc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:32:29 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH -tip 0/1] posix-cpu-timers: fix CPUCLOCK_{PROF,VIRT} periodic tics precision
Date: Tue, 11 Aug 2009 16:31:39 +0200
Message-Id: <1250001100-3936-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello. 

POSIX 1.b cpu timers where clockid is based on CPUCLOCK_PROF and CPUCLOCK_VIRT,
have systematic timer error, the same as had itimers. Error can be showed by
program [1]. Results for unpatched and patched kernel are below:

Unpatched kernel:

CLK_PROF
Period 10000:	counted time 14.51 , real time 15.99 , error -9.2 %
Period 9998:	counted time 15.95 , real time 15.96 , error -0.1 %
Period 1000:	counted time 7.99 , real time 15.98 , error -50.0 %
Period 11111:	counted time 14.77 , real time 15.96 , error -7.5 %
Period 21315:	counted time 15.45 , real time 15.96 , error -3.1 %
Period 1500:	counted time 11.98 , real time 15.98 , error -25.0 %
Period 15000:	counted time 14.96 , real time 15.96 , error -6.3 %
Period 50000:	counted time 15.60 , real time 15.95 , error -2.2 %
Period 777777:	counted time 15.56 , real time 15.95 , error -2.5 %
Period 212341:	counted time 15.71 , real time 15.95 , error -1.5 %
Period 10001:	counted time 14.50 , real time 15.96 , error -9.1 %
Period 1002:	counted time 8.01 , real time 15.98 , error -49.9 %
Period 999000:	counted time 14.98 , real time 15.95 , error -6.1 %
Period 2222:	counted time 11.83 , real time 15.97 , error -26.0 %
Period 500:	counted time 8.01 , real time 16.02 , error -50.0 %
CLK_VIRT
Period 10000:	counted time 14.50 , real time 15.96 , error -9.2 %
Period 9998:	counted time 15.95 , real time 15.96 , error -0.1 %
Period 1000:	counted time 7.99 , real time 15.98 , error -50.0 %
Period 11111:	counted time 14.77 , real time 15.97 , error -7.5 %
Period 21315:	counted time 15.45 , real time 15.96 , error -3.2 %
Period 1500:	counted time 11.99 , real time 15.99 , error -25.0 %
Period 15000:	counted time 14.96 , real time 15.96 , error -6.3 %
Period 50000:	counted time 15.60 , real time 15.96 , error -2.2 %
Period 777777:	counted time 15.56 , real time 15.95 , error -2.5 %
Period 212341:	counted time 15.71 , real time 15.96 , error -1.5 %
Period 10001:	counted time 14.50 , real time 15.96 , error -9.1 %
Period 1002:	counted time 8.01 , real time 15.99 , error -49.9 %
Period 999000:	counted time 14.98 , real time 15.95 , error -6.1 %
Period 2222:	counted time 11.83 , real time 15.98 , error -26.0 %
Period 500:	counted time 8.01 , real time 16.01 , error -50.0 %

Patched kernel:

CLK_PROF
Period 10000:	counted time 16.05 , real time 16.06 , error -0.1 %
Period 9998:	counted time 16.30 , real time 16.30 , error -0.0 %
Period 1000:	counted time 16.45 , real time 16.45 , error -0.0 %
Period 11111:	counted time 15.99 , real time 16.00 , error -0.1 %
Period 21315:	counted time 15.99 , real time 15.99 , error -0.1 %
Period 1500:	counted time 16.03 , real time 16.03 , error -0.0 %
Period 15000:	counted time 15.99 , real time 16.00 , error -0.0 %
Period 50000:	counted time 15.95 , real time 15.99 , error -0.3 %
Period 777777:	counted time 15.56 , real time 15.99 , error -2.7 %
Period 212341:	counted time 16.35 , real time 16.37 , error -0.1 %
Period 10001:	counted time 15.99 , real time 16.00 , error -0.0 %
Period 1002:	counted time 16.05 , real time 16.05 , error -0.0 %
Period 999000:	counted time 15.98 , real time 15.99 , error -0.1 %
Period 2222:	counted time 16.02 , real time 16.02 , error -0.0 %
Period 500:	counted time 8.02 , real time 16.05 , error -50.0 %
CLK_VIRT
Period 10000:	counted time 15.99 , real time 16.00 , error -0.1 %
Period 9998:	counted time 16.02 , real time 16.03 , error -0.1 %
Period 1000:	counted time 16.04 , real time 16.05 , error -0.1 %
Period 11111:	counted time 15.99 , real time 16.00 , error -0.1 %
Period 21315:	counted time 16.39 , real time 16.40 , error -0.1 %
Period 1500:	counted time 16.02 , real time 16.03 , error -0.0 %
Period 15000:	counted time 15.97 , real time 16.00 , error -0.1 %
Period 50000:	counted time 15.95 , real time 16.00 , error -0.3 %
Period 777777:	counted time 15.56 , real time 16.00 , error -2.8 %
Period 212341:	counted time 16.14 , real time 16.34 , error -1.2 %
Period 10001:	counted time 15.98 , real time 16.00 , error -0.1 %
Period 1002:	counted time 16.04 , real time 16.05 , error -0.0 %
Period 999000:	counted time 15.98 , real time 16.00 , error -0.1 %
Period 2222:	counted time 16.01 , real time 16.02 , error -0.1 %
Period 500:	counted time 8.02 , real time 16.05 , error -50.0 %

Even if probably nobody use these timers, I think we should fix them
because we have this API in kernel and the timers perform bad. Patch
is against Ingo's -tip (-sched-devel) tree where are my previous itmiers
patches.

Cheers
Stanislaw 


[1] Program for measurement POSIX.1b CPUCLOCK_{PROF,VIRT} cpu timers precision

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
	777777,
	212341,
	10001,
	1002,
	999000,
	2222,
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
	long long i = 0;
	long long count = 0;

	for(i=0; i<3000000000LL; i++)
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

