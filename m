Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbZDBMR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbZDBMR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbZDBMRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:17:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58214 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbZDBMRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:17:45 -0400
Date: Thu, 2 Apr 2009 14:11:35 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] itimers: periodic timers fixes
Message-ID: <20090402141135.655d1b2b@dhcp-lab-109.englab.brq.redhat.com>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

We found the periodic timers ITIMER_PROF and ITIMER_VIRT are unreliable, they 
have systematic timing error. For example period of 10000 us will not be
represented by the kernel as 10 ticks, but 11 (for HZ=1000). The reason is that
the frequency of the hardware timer can only be chosen in discrete steps and
the actual frequency is about 1000.152 Hz. So 10 ticks would take only about
9.9985 ms, the kernel decides it must never return earlier than requested, so
it rounds the period up to 11 ticks. This results in a systematic multiplicative
timing error of -10 %. The situation is even worse where application try to
request with 1 thick period. It will get the signal once per two kernel ticks,
not on every tick. The systematic multiplicative timing error is -50 %. He have
program [1] that shows itimers systematic error, results are below [2]. 

To fix situation we wrote two patches. First one just simplify code related
with itimers. Second is fix, it change intervals measurement resolutions and
correct times when signal is generated. However this add some drawback, that
I'm not sure if are acceptable:

- the time between two consecutive tics can be smaller than requested
  interval

- intervals values which are returned to user by getitimer() are not
  rounded up

Second drawback mean that applications which first call setitimer() then
call getitimer() to see if interval was round up and to correct timings,
will potentially stop works. However this can be only problem with requested
interval smaller than 1/HZ, as for intervals > 1/Hz we can generate signals
with proper resolution.

Cheers
Stanislaw Gruszka

[1] PROGRAM SHOWS ITIMERS SYSTEMATIC ERRORS

=============================================================================

/*
 * Measures the systematic error of a periodic timer.
 * Best run on an otherwise idle system, so that the simplifying assumption
 * cpu_time_consumed_by_this_process==real_elapsed_time  holds.
 */

#include <sys/time.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>

/* This is what profiling with gcc -pg uses: */
#define SIGNAL SIGPROF
#define ITIMER ITIMER_PROF

//#define SIGNAL SIGVTALRM
//#define ITIMER ITIMER_VIRTUAL

//#define SIGNAL SIGALRM
//#define ITIMER ITIMER_REAL

#define ARRAY_SIZE(a) (sizeof(a)/sizeof(a[0]))

const int test_periods_us[] = {
	10000,  /* glibc's value for x86(_64) */
	9998,   /* this value would cause a much smaller error */
	1000    /* and this is what is used for profiling on ia64 */
};

volatile int prof_counter;

void handler(int signr)
{
	prof_counter++;
}

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

void measure_itimer_error(int period_us)
{
	struct sigaction act;
	struct timeval start, end;
	double real_time, counted_time;

	prof_counter = 0;

	/* setup a periodic timer */
	struct timeval period_tv = {
		.tv_sec = 0,
		.tv_usec = period_us
	};
	struct itimerval timer = {
		.it_interval = period_tv,
		.it_value = period_tv
	};
	act.sa_handler = handler;
	sigemptyset(&act.sa_mask);
	act.sa_flags = 0;
	if (sigaction(SIGNAL, &act, NULL) < 0) {
		printf("sigaction failed\n");
		exit(1);
	}
	if (setitimer(ITIMER, &timer, NULL) < 0) {
		perror("setitimer");
		exit(1);
	}

	/* run a busy loop and measure it */
	gettimeofday(&start, NULL);
	test_func();
	gettimeofday(&end, NULL);

	/* disable the timer */
	timer.it_value.tv_usec = 0;
	if (setitimer(ITIMER, &timer, NULL) < 0) {
		perror("setitimer");
		exit(1);
	}

	counted_time = prof_counter * period_us / 1000000.0;
	real_time = timeval_diff(&start, &end);
	printf("Requested a period of %d us and counted to %d, that should be %.2f s\n",
		period_us, prof_counter, counted_time);
	printf("Meanwhile real time elapsed: %.2f s\n", real_time);
	printf("The error was %.1f %%\n\n", (counted_time/real_time - 1.0)*100.0);
}

int main()
{
	int i;
	for (i=0; i<ARRAY_SIZE(test_periods_us); i++)
		measure_itimer_error(test_periods_us[i]);
	return 0;
}

===============================================================================


[2] TEST PROGRAM RESULTS 

Test program results for unpatched kernel:
==========================================

Requested a period of 10000 us and counted to 644, that should be 6.44 s
Meanwhile real time elapsed: 7.10 s
The error was -9.2 %

Requested a period of 9998 us and counted to 708, that should be 7.08 s
Meanwhile real time elapsed: 7.08 s
The error was -0.1 %

Requested a period of 1000 us and counted to 3542, that should be 3.54 s
Meanwhile real time elapsed: 7.09 s
The error was -50.1 %

To fix situation we wrote two patches, first just simplify code related
with itimers. Second 

Test program results after patches applied:
===========================================

Requested a period of 10000 us and counted to 708, that should be 7.08 s
Meanwhile real time elapsed: 7.10 s
The error was -0.2 %

Requested a period of 9998 us and counted to 709, that should be 7.09 s
Meanwhile real time elapsed: 7.10 s
The error was -0.1 %

Requested a period of 1000 us and counted to 7100, that should be 7.10 s
Meanwhile real time elapsed: 7.11 s
The error was -0.1 %
