Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbZCQX20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbZCQX20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 19:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZCQX2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 19:28:13 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:39432 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbZCQX2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 19:28:12 -0400
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="hH2l0xIwX0"
Content-Transfer-Encoding: 7bit
Message-ID: <18880.12797.758764.128252@cargo.ozlabs.ibm.com>
Date: Wed, 18 Mar 2009 10:27:57 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Test program for counters in groups
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hH2l0xIwX0
Content-Type: text/plain; charset=us-ascii
Content-Description: message body text
Content-Transfer-Encoding: 7bit

Here's a little test program that checks whether software counters
(specifically, the task clock counter) work correctly when they're in
a group with hardware counters.

What it does is to create several groups, each with one hardware
counter, counting instructions, plus a task clock counter.  It needs
to know an upper bound N on the number of hardware counters you have
(N defaults to 8), and it creates N+4 groups to force them to be
multiplexed.  It also creates an overall task clock counter.

Then it spins for a while, and then stops all the counters and reads
them.  It takes the total of the task clock counters in the groups and
computes the ratio of that total to the overall execution time from
the overall task clock counter.

That ratio should be equal to the number of actual hardware counters
that can count instructions.  If the task clock counters in the groups
don't stop when their group gets taken off the PMU, the ratio will
instead be close to N+4.  The program will declare that the test fails
if the ratio is greater than N (actually, N + 0.0001 to allow for FP
rounding errors).

Could someone run this on x86 on the latest PCL tree and let me know
what happens?  I don't have an x86 crash box easily to hand.  On
powerpc, it passes, but I think that is because I am missing setting
counter->prev_count in arch/powerpc/kernel/perf_counter.c, and I think
that means that enabling/disabling a group with a task clock counter
in it won't work correctly (I'll do a test program for that next).

Usage is: swsched-test [-c num-hw-counters] [-v]

Use -c N if you have more than 8 hardware counters.  The -v flag makes
it print out the values of each counter.

Paul.


--hH2l0xIwX0
Content-Type: text/x-csrc; name="swsched-test.c"
Content-Description: counter group test program
Content-Disposition: inline;
	filename="swsched-test.c"
Content-Transfer-Encoding: 7bit

#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <poll.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include "perf_counter.h"

#ifdef __x86_64__
# define __NR_perf_counter_open	295
#endif

#ifdef __i386__
# define __NR_perf_counter_open 333
#endif

#ifdef __powerpc__
# define __NR_perf_counter_open 319
#endif

#define PR_TASK_PERF_COUNTERS_DISABLE           31
#define PR_TASK_PERF_COUNTERS_ENABLE            32

int sys_perf_counter_open(struct perf_counter_hw_event *hw_event,
			  pid_t pid, int cpu, int group_fd, unsigned long flags)
{
	return syscall(__NR_perf_counter_open, hw_event, pid, cpu, group_fd,
		       flags);
}

#define MAX_CTRS	50
#define LOOPS	1000000000

void do_work(void)
{
	int i;

	for (i = 0; i < LOOPS; ++i)
		asm volatile("" : : "g" (i));
}

main(int ac, char **av)
{
	int tsk0;
	int hwfd[MAX_CTRS], tskfd[MAX_CTRS];
	struct perf_counter_hw_event tsk_event;
	struct perf_counter_hw_event hw_event;
	unsigned long long vt0, vt[MAX_CTRS], vh[MAX_CTRS], vtsum, vhsum;
	int i, n, nhw;
	int verbose = 0;
	double ratio;

	nhw = 8;
	while ((i = getopt(ac, av, "c:v")) != -1) {
		switch (i) {
		case 'c':
			n = atoi(optarg);
			break;
		case 'v':
			verbose = 1;
			break;
		case '?':
			fprintf(stderr, "Usage: %s [-c #hwctrs] [-v]\n", av[0]);
			exit(1);
		}
	}

	if (nhw < 0 || nhw > MAX_CTRS - 4) {
		fprintf(stderr, "invalid number of hw counters specified: %d\n",
			nhw);
		exit(1);
	}

	n = nhw + 4;

	memset(&tsk_event, 0, sizeof(tsk_event));
	tsk_event.type = PERF_COUNT_TASK_CLOCK;
	tsk_event.disabled = 1;

	memset(&hw_event, 0, sizeof(hw_event));
	hw_event.disabled = 1;
	hw_event.type = PERF_COUNT_INSTRUCTIONS;

	tsk0 = sys_perf_counter_open(&tsk_event, 0, -1, -1, 0);
	if (tsk0 == -1) {
		perror("perf_counter_open");
		exit(1);
	}

	tsk_event.disabled = 0;
	for (i = 0; i < n; ++i) {
		hwfd[i] =  sys_perf_counter_open(&hw_event, 0, -1, -1, 0);
		tskfd[i] = sys_perf_counter_open(&tsk_event, 0, -1, hwfd[i], 0);
		if (tskfd[i] == -1 || hwfd[i] == -1) {
			perror("perf_counter_open");
			exit(1);
		}
	}

	prctl(PR_TASK_PERF_COUNTERS_ENABLE);
	do_work();
	prctl(PR_TASK_PERF_COUNTERS_DISABLE);

	if (read(tsk0, &vt0, sizeof(vt0)) != sizeof(vt0)) {
		fprintf(stderr, "error reading task clock counter\n");
		exit(1);
	}

	vtsum = vhsum = 0;
	for (i = 0; i < n; ++i) {
		if (read(tskfd[i], &vt[i], sizeof(vt[i])) != sizeof(vt[i]) ||
		    read(hwfd[i], &vh[i], sizeof(vh[i])) != sizeof(vh[i])) {
			fprintf(stderr, "error reading counter(s)\n");
			exit(1);
		}
		vtsum += vt[i];
		vhsum += vh[i];
	}

	printf("overall task clock: %lld\n", vt0);
	printf("hw sum: %lld, task clock sum: %lld\n", vhsum, vtsum);
	if (verbose) {
		printf("hw counters:");
		for (i = 0; i < n; ++i)
			printf(" %lld", vh[i]);
		printf("\ntask clock counters:");
		for (i = 0; i < n; ++i)
			printf(" %lld", vt[i]);
		printf("\n");
	}
	ratio = (double)vtsum / vt0;
	printf("ratio: %.2f\n", ratio);
	if (ratio > nhw + 0.0001) {
		fprintf(stderr, "test failed\n");
		exit(1);
	}

	fprintf(stderr, "test passed\n");
	exit(0);
}

--hH2l0xIwX0--
