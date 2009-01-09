Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZAIXqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZAIXqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbZAIXph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:45:37 -0500
Received: from ozlabs.org ([203.10.76.45]:37583 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbZAIXpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:45:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18791.57749.799335.646130@cargo.ozlabs.ibm.com>
Date: Sat, 10 Jan 2009 10:45:25 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: my version of timec.c
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this, raw events can be specified with the event number in hex
preceded by "r", e.g. "timec -e r380f,2 ls".

---

/*
 * timec:  /usr/bin/time -alike performance counter statistics utility
 *
 *        It summarizes the counter events of all tasks (and child tasks),
 *        covering all CPUs that the command (or workload) executes on.
 *        It only counts the per-task events of the workload started,
 *        independent of how many other tasks run on those CPUs.
 *
 * Build with:       cc -O2 -g -lrt -Wall -W -o timec timec.c
 *
 * Sample output:
 *

   $ ./timec -e 1 -e 3 -e 5 ls -lR /usr/include/ >/dev/null

   Performance counter stats for 'ls':

           163516953 instructions
                2295 cache-misses
             2855182 branch-misses

 *
 * Copyright (C) 2008, Red Hat Inc, Ingo Molnar <mingo@redhat.com>
 *
 * Released under the GPLv2 (not later).
 */
#define _GNU_SOURCE

#include <assert.h>
#include <getopt.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <time.h>

#include <sys/syscall.h>
#include <sys/ioctl.h>
#include <sys/prctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <sys/uio.h>

#include <linux/unistd.h>

#ifdef __x86_64__
# define __NR_perf_counter_open	295
#endif

#ifdef __i386__
# define __NR_perf_counter_open 333
#endif

#ifdef __powerpc__
#define __NR_perf_counter_open 319
#endif

/*
 * Pick up some kernel type conventions:
 */
#define __user
#define asmlinkage

typedef unsigned int		u32;
typedef unsigned long long	u64;
typedef long long		s64;

/*
 * Generalized performance counter event types, used by the hw_event.type
 * parameter of the sys_perf_counter_open() syscall:
 */
enum hw_event_types {
	/*
	 * Common hardware events, generalized by the kernel:
	 */
	PERF_COUNT_CPU_CYCLES		=  0,
	PERF_COUNT_INSTRUCTIONS		=  1,
	PERF_COUNT_CACHE_REFERENCES	=  2,
	PERF_COUNT_CACHE_MISSES		=  3,
	PERF_COUNT_BRANCH_INSTRUCTIONS	=  4,
	PERF_COUNT_BRANCH_MISSES	=  5,
	PERF_COUNT_BUS_CYCLES		=  6,

	PERF_HW_EVENTS_MAX		=  7,

	/*
	 * Special "software" counters provided by the kernel, even if
	 * the hardware does not support performance counters. These
	 * counters measure various physical and sw events of the
	 * kernel (and allow the profiling of them as well):
	 */
	PERF_COUNT_CPU_CLOCK		= -1,
	PERF_COUNT_TASK_CLOCK		= -2,
	PERF_COUNT_PAGE_FAULTS		= -3,
	PERF_COUNT_CONTEXT_SWITCHES	= -4,
	PERF_COUNT_CPU_MIGRATIONS	= -5,

	PERF_SW_EVENTS_MIN		= -6,
};

/*
 * IRQ-notification data record type:
 */
enum perf_counter_record_type {
	PERF_RECORD_SIMPLE		=  0,
	PERF_RECORD_IRQ			=  1,
	PERF_RECORD_GROUP		=  2,
};

/*
 * Hardware event to monitor via a performance monitoring counter:
 */
struct perf_counter_hw_event {
	s64			type;

	u64			irq_period;
	u32			record_type;

	u32			disabled     :  1, /* off by default      */
				nmi	     :  1, /* NMI sampling        */
				raw	     :  1, /* raw event type      */
				inherit	     :  1, /* children inherit it */
				__reserved_1 : 28;

	u64			__reserved_2;
};


asmlinkage int sys_perf_counter_open(

	struct perf_counter_hw_event	*hw_event_uptr		__user,
	pid_t				pid,
	int				cpu,
	int				group_fd)
{
	int ret;

	ret = syscall(
		__NR_perf_counter_open, hw_event_uptr, pid, cpu, group_fd);
#if defined(__x86_64__) || defined(__i386__)
	if (ret < 0 && ret > -4096) {
		errno = -ret;
		ret = -1;
	}
#endif
	return ret;
}


static char *hw_event_names [] = {
	"CPU cycles",
	"instructions",
	"cache references",
	"cache misses",
	"branches",
	"branch misses",
	"bus cycles",
};

static char *sw_event_names [] = {
	"cpu clock ticks",
	"task clock ticks",
	"pagefaults",
	"context switches",
	"CPU migrations",
};

#define MAX_COUNTERS						64

static int			nr_counters			= 0;

static int			event_id[MAX_COUNTERS]		= { -2, };
static int			event_raw[MAX_COUNTERS];

static void display_help(void)
{
	printf(
	"Usage: timec [<events...>] <cmd...>\n\n"
	"Time-Counters Options (up to %d event types can be specified):\n\n",
		 MAX_COUNTERS);
	printf(
	" -e EID       --event_id=EID       # event type ID              [default:  0]\n"
	"                                   0: CPU cycles\n"
	"                                   1: instructions\n"
	"                                   2: cache accesses\n"
	"                                   3: cache misses\n"
	"                                   4: branch instructions\n"
	"                                   5: branch prediction misses\n\n"
	"                                   6: bus cycles\n"
	" -c <cmd..>   --command=<cmd..>    # command+arguments to be timed.\n"
	"\n");

	exit(0);
}

static int type_valid(int type)
{
	if (type >= PERF_HW_EVENTS_MAX)
		return 0;
	if (type <= PERF_SW_EVENTS_MIN)
		return 0;

	return 1;
}

static char *event_name(int ctr)
{
	int type = event_id[ctr];
	static char buf[32];

	if (event_raw[ctr]) {
		sprintf(buf, "raw 0x%x", type);
		return buf;
	}
	if (!type_valid(type))
		return "unknown";

	if (type >= 0)
		return hw_event_names[type];

	return sw_event_names[-type-1];
}

static void parse_events(char *str)
{
	int type, raw;

again:
	nr_counters++;
	if (nr_counters == MAX_COUNTERS)
		display_help();

	raw = 0;
	if (*str == 'r') {
		raw = 1;
		++str;
		type = strtol(str, NULL, 16);
	} else {
		type = atoi(str);
		if (!type_valid(type))
			display_help();
	}

	event_id[nr_counters] = type;
	event_raw[nr_counters] = raw;
	str = strstr(str, ",");
	if (str) {
		str++;
		goto again;
	}
}

static void process_options(int argc, char *argv[])
{
	for (;;) {
		int option_index = 0;
		/** Options for getopt */
		static struct option long_options[] = {
			{"event_id",	required_argument,	NULL, 'e'},
			{"help",	no_argument,		NULL, 'h'},
			{"command",	no_argument,		NULL, 'c'},
			{NULL,		0,			NULL,  0 }
		};
		int c = getopt_long(argc, argv, "+:e:c",
				    long_options, &option_index);
		if (c == -1)
			break;

		switch (c) {
		case 'c':
			break;
		case 'e':
			parse_events(optarg);
			break;
		default:
			break;
		}
	}
	if (optind == argc)
		goto err;

	nr_counters++;
	if (nr_counters < 1)
		nr_counters = 1;
	return;

err:
	display_help();
}

char fault_here[1000000];

#define PR_TASK_PERF_COUNTERS_DISABLE           31
#define PR_TASK_PERF_COUNTERS_ENABLE            32

static int fd[MAX_COUNTERS];

static void create_counter(int counter)
{
	struct perf_counter_hw_event hw_event;

	memset(&hw_event, 0, sizeof(hw_event));
	hw_event.type		= event_id[counter];
	hw_event.raw		= event_raw[counter];
	hw_event.record_type	= PERF_RECORD_SIMPLE;
	hw_event.nmi		= 0;
	hw_event.inherit	= 1;
	hw_event.disabled	= 1;

	fd[counter] = sys_perf_counter_open(&hw_event, 0, -1, -1);
	if (fd[counter] < 0) {
		printf("timec error: syscall returned with %d (%s)\n",
			fd[counter], strerror(errno));
		exit(-1);
	}
	assert(fd[counter] >= 0);
}


#define rdclock()					\
({							\
	struct timespec ts;				\
							\
	clock_gettime(CLOCK_MONOTONIC, &ts);		\
	ts.tv_sec * 1000000000ULL + ts.tv_nsec;		\
})

int main(int argc, char *argv[])
{
	unsigned long long t0, t1;
	int counter;
	ssize_t res;
	int status;
	int pid;

	process_options(argc, argv);

	for (counter = 0; counter < nr_counters; counter++)
		create_counter(counter);

	argc -= optind;
	argv += optind;

	/*
	 * Enable counters and exec the command:
	 */
	t0 = rdclock();
	prctl(PR_TASK_PERF_COUNTERS_ENABLE);

	if ((pid = fork()) < 0)
		perror("failed to fork");
	if (!pid) {
		if (execvp(argv[0], argv))
			exit(-1);
	}
	while (wait(&status) >= 0)
		;
	prctl(PR_TASK_PERF_COUNTERS_DISABLE);
	t1 = rdclock();

	fflush(stdout);

	fprintf(stderr, "\n");
	fprintf(stderr, " Performance counter stats for \'%s\':\n",
		argv[0]);
	fprintf(stderr, "\n");

	for (counter = 0; counter < nr_counters; counter++) {
		u64 count;

		res = read(fd[counter],
			   (char *) &count, sizeof(count));
		assert(res == sizeof(count));


		if (!event_raw[counter] &&
		    (event_id[counter] == PERF_COUNT_CPU_CLOCK ||
		     event_id[counter] == PERF_COUNT_TASK_CLOCK)) {

			double msecs = (double)count / 1000000;

			fprintf(stderr, " %14.6f  %-20s (msecs)\n",
				msecs, event_name(counter));
		} else {
			fprintf(stderr, " %14Ld  %-20s (events)\n",
				count, event_name(counter));
		}
		if (!counter)
			fprintf(stderr, "\n");
	}
	fprintf(stderr, "\n");
	fprintf(stderr, " Wall-clock time elapsed: %12.6f msecs\n",
			(double)(t1-t0)/1e6);
	fprintf(stderr, "\n");

	return 0;
}
