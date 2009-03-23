Return-Path: <linux-kernel-owner+w=401wt.eu-S1760763AbZCWU7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763AbZCWU7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759881AbZCWU6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:58:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:49112 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756AbZCWU6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:58:01 -0400
Date: Mon, 23 Mar 2009 20:57:25 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       fengguang.wu@intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, fengguang.wu@intel.com, mingo@elte.hu
In-Reply-To: <20090323172417.677932499@chello.nl>
References: <20090323172417.677932499@chello.nl>
Subject: [tip:perfcounters/core] perf_counter tools: tidy up in-kernel dependencies
Message-ID: <tip-4d1b100b57e8d472ca3b3a628e03c24d66cb782c@git.kernel.org>
Git-Commit-ID: 4d1b100b57e8d472ca3b3a628e03c24d66cb782c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 20:57:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d1b100b57e8d472ca3b3a628e03c24d66cb782c
Gitweb:     http://git.kernel.org/tip/4d1b100b57e8d472ca3b3a628e03c24d66cb782c
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 23 Mar 2009 21:49:25 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 21:51:35 +0100

perf_counter tools: tidy up in-kernel dependencies

Remove now unified perfstat.c and perf_counter.h, and link to the
in-kernel perf_counter.h.

Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090323172417.677932499@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/Makefile       |    2 +-
 Documentation/perf_counter/kerneltop.c    |    2 +-
 Documentation/perf_counter/perfcounters.h |  142 ----------------
 Documentation/perf_counter/perfstat.c     |  251 -----------------------------
 4 files changed, 2 insertions(+), 395 deletions(-)

diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
index b457497..666da95 100644
--- a/Documentation/perf_counter/Makefile
+++ b/Documentation/perf_counter/Makefile
@@ -2,7 +2,7 @@ BINS = kerneltop perfstat
 
 all: $(BINS)
 
-kerneltop: kerneltop.c perfcounters.h
+kerneltop: kerneltop.c ../../include/linux/perf_counter.h
 	cc -O6 -Wall -lrt `pkg-config --cflags --libs glib-2.0` -o $@ $<
 
 perfstat: kerneltop
diff --git a/Documentation/perf_counter/kerneltop.c b/Documentation/perf_counter/kerneltop.c
index 80b7905..25e80bc 100644
--- a/Documentation/perf_counter/kerneltop.c
+++ b/Documentation/perf_counter/kerneltop.c
@@ -88,7 +88,7 @@
 
 #include <linux/unistd.h>
 
-#include "include/linux/perf_counter.h"
+#include "../../include/linux/perf_counter.h"
 
 
 /*
diff --git a/Documentation/perf_counter/perfcounters.h b/Documentation/perf_counter/perfcounters.h
deleted file mode 100644
index 32e24b9..0000000
--- a/Documentation/perf_counter/perfcounters.h
+++ /dev/null
@@ -1,142 +0,0 @@
-/*
- * Ioctls that can be done on a perf counter fd:
- */
-#define PERF_COUNTER_IOC_ENABLE		_IO('$', 0)
-#define PERF_COUNTER_IOC_DISABLE	_IO('$', 1)
-
-/*
- * prctl(PR_TASK_PERF_COUNTERS_DISABLE) will (cheaply) disable all
- * counters in the current task.
- */
-#define PR_TASK_PERF_COUNTERS_DISABLE	31
-#define PR_TASK_PERF_COUNTERS_ENABLE    32
-
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-
-#define rdclock()					\
-({							\
-	struct timespec ts;				\
-							\
-	clock_gettime(CLOCK_MONOTONIC, &ts);		\
-	ts.tv_sec * 1000000000ULL + ts.tv_nsec;		\
-})
-
-/*
- * Pick up some kernel type conventions:
- */
-#define __user
-#define asmlinkage
-
-typedef unsigned int		__u32;
-typedef unsigned long long	__u64;
-typedef long long		__s64;
-
-/*
- * User-space ABI bits:
- */
-
-/*
- * Generalized performance counter event types, used by the hw_event.type
- * parameter of the sys_perf_counter_open() syscall:
- */
-enum hw_event_types {
-	/*
-	 * Common hardware events, generalized by the kernel:
-	 */
-	PERF_COUNT_CPU_CYCLES		=  0,
-	PERF_COUNT_INSTRUCTIONS		=  1,
-	PERF_COUNT_CACHE_REFERENCES	=  2,
-	PERF_COUNT_CACHE_MISSES		=  3,
-	PERF_COUNT_BRANCH_INSTRUCTIONS	=  4,
-	PERF_COUNT_BRANCH_MISSES	=  5,
-	PERF_COUNT_BUS_CYCLES		=  6,
-
-	PERF_HW_EVENTS_MAX		=  7,
-
-	/*
-	 * Special "software" counters provided by the kernel, even if
-	 * the hardware does not support performance counters. These
-	 * counters measure various physical and sw events of the
-	 * kernel (and allow the profiling of them as well):
-	 */
-	PERF_COUNT_CPU_CLOCK		= -1,
-	PERF_COUNT_TASK_CLOCK		= -2,
-	PERF_COUNT_PAGE_FAULTS		= -3,
-	PERF_COUNT_CONTEXT_SWITCHES	= -4,
-	PERF_COUNT_CPU_MIGRATIONS	= -5,
-
-	PERF_SW_EVENTS_MIN		= -6,
-};
-
-/*
- * IRQ-notification data record type:
- */
-enum perf_counter_record_type {
-	PERF_RECORD_SIMPLE		=  0,
-	PERF_RECORD_IRQ			=  1,
-	PERF_RECORD_GROUP		=  2,
-};
-
-/*
- * Hardware event to monitor via a performance monitoring counter:
- */
-struct perf_counter_hw_event {
-	__s64			type;
-
-	__u64			irq_period;
-	__u64			record_type;
-	__u64			read_format;
-
-	__u64			disabled       :  1, /* off by default        */
-				nmi	       :  1, /* NMI sampling          */
-				raw	       :  1, /* raw event type        */
-				inherit	       :  1, /* children inherit it   */
-				pinned	       :  1, /* must always be on PMU */
-				exclusive      :  1, /* only group on PMU     */
-				exclude_user   :  1, /* don't count user      */
-				exclude_kernel :  1, /* ditto kernel          */
-				exclude_hv     :  1, /* ditto hypervisor      */
-				exclude_idle   :  1, /* don't count when idle */
-
-				__reserved_1   : 54;
-
-	__u32			extra_config_len;
-	__u32			__reserved_4;
-
-	__u64			__reserved_2;
-	__u64			__reserved_3;
-};
-
-
-#ifdef __x86_64__
-# define __NR_perf_counter_open	295
-#endif
-
-#ifdef __i386__
-# define __NR_perf_counter_open 333
-#endif
-
-#ifdef __powerpc__
-#define __NR_perf_counter_open 319
-#endif
-
-asmlinkage int sys_perf_counter_open(
-
-	struct perf_counter_hw_event	*hw_event_uptr		__user,
-	pid_t				pid,
-	int				cpu,
-	int				group_fd,
-	unsigned long			flags)
-{
-	int ret;
-
-	ret = syscall(
-		__NR_perf_counter_open, hw_event_uptr, pid, cpu, group_fd, flags);
-#if defined(__x86_64__) || defined(__i386__)
-	if (ret < 0 && ret > -4096) {
-		errno = -ret;
-		ret = -1;
-	}
-#endif
-	return ret;
-}
diff --git a/Documentation/perf_counter/perfstat.c b/Documentation/perf_counter/perfstat.c
deleted file mode 100644
index fd59446..0000000
--- a/Documentation/perf_counter/perfstat.c
+++ /dev/null
@@ -1,251 +0,0 @@
-/*
- * perfstat:  /usr/bin/time -alike performance counter statistics utility
- *
- *        It summarizes the counter events of all tasks (and child tasks),
- *        covering all CPUs that the command (or workload) executes on.
- *        It only counts the per-task events of the workload started,
- *        independent of how many other tasks run on those CPUs.
- *
- * Build with:       cc -O2 -g -lrt -Wall -W -o perfstat perfstat.c
- *
- * Sample output:
- *
-
-   $ ./perfstat -e 1 -e 3 -e 5 ls -lR /usr/include/ >/dev/null
-
-   Performance counter stats for 'ls':
-
-           163516953 instructions
-                2295 cache-misses
-             2855182 branch-misses
-
- *
- * Copyright (C) 2008, Red Hat Inc, Ingo Molnar <mingo@redhat.com>
- *
- * Released under the GPLv2 (not later).
- *
- * Percpu counter support by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
- * Symbolic event options by: Wu Fengguang <fengguang.wu@intel.com>
- */
-#define _GNU_SOURCE
-
-#include <assert.h>
-#include <getopt.h>
-#include <stdint.h>
-#include <stdlib.h>
-#include <string.h>
-#include <unistd.h>
-#include <ctype.h>
-#include <errno.h>
-#include <fcntl.h>
-#include <stdio.h>
-#include <time.h>
-
-#include <sys/syscall.h>
-#include <sys/ioctl.h>
-#include <sys/prctl.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/time.h>
-#include <sys/wait.h>
-#include <sys/uio.h>
-
-#include <linux/unistd.h>
-
-#include "perfcounters.h"
-
-static int			nr_cpus			= 0;
-
-static int			system_wide		= 0;
-
-static void display_help(void)
-{
-	unsigned int i;
-	int e;
-
-	printf(
-	"Usage: perfstat [<events...>] <cmd...>\n\n"
-	"PerfStat Options (up to %d event types can be specified):\n\n",
-		 MAX_COUNTERS);
-	printf(
-	" -e EVENT     --event=EVENT        #  symbolic-name        abbreviations");
-
-	for (i = 0, e = PERF_HW_EVENTS_MAX; i < ARRAY_SIZE(event_symbols); i++) {
-		if (e != event_symbols[i].event) {
-			e = event_symbols[i].event;
-			printf(
-	"\n                                  %2d: %-20s", e, event_symbols[i].symbol);
-		} else
-			printf(" %s", event_symbols[i].symbol);
-	}
-
-	printf("\n"
-	"                                rNNN: raw event type\n\n"
-	" -s                                # system-wide collection\n\n"
-	" -c <cmd..>   --command=<cmd..>    # command+arguments to be timed.\n"
-	"\n");
-	exit(0);
-}
-
-static void process_options(int argc, char *argv[])
-{
-	for (;;) {
-		int option_index = 0;
-		/** Options for getopt */
-		static struct option long_options[] = {
-			{"event",	required_argument,	NULL, 'e'},
-			{"help",	no_argument,		NULL, 'h'},
-			{"command",	no_argument,		NULL, 'c'},
-			{NULL,		0,			NULL,  0 }
-		};
-		int c = getopt_long(argc, argv, "+:e:c:s",
-				    long_options, &option_index);
-		if (c == -1)
-			break;
-
-		switch (c) {
-		case 'c':
-			break;
-		case 's':
-			system_wide = 1;
-			break;
-		case 'e':
-			parse_events(optarg);
-			break;
-		default:
-			break;
-		}
-	}
-	if (optind == argc)
-		goto err;
-
-	if (!nr_counters)
-		nr_counters = 8;
-	return;
-
-err:
-	display_help();
-}
-
-char fault_here[1000000];
-
-static int fd[MAX_NR_CPUS][MAX_COUNTERS];
-
-static void create_counter(int counter)
-{
-	struct perf_counter_hw_event hw_event;
-
-	memset(&hw_event, 0, sizeof(hw_event));
-	hw_event.type		= event_id[counter];
-	hw_event.raw		= event_raw[counter];
-	hw_event.record_type	= PERF_RECORD_SIMPLE;
-	hw_event.nmi		= 0;
-
-	if (system_wide) {
-		int cpu;
-		for (cpu = 0; cpu < nr_cpus; cpu ++) {
-			fd[cpu][counter] = sys_perf_counter_open(&hw_event, -1, cpu, -1, 0);
-			if (fd[cpu][counter] < 0) {
-				printf("perfstat error: syscall returned with %d (%s)\n",
-						fd[cpu][counter], strerror(errno));
-				exit(-1);
-			}
-			
-		}
-	} else {
-		hw_event.inherit	= 1;
-		hw_event.disabled	= 1;
-
-		fd[0][counter] = sys_perf_counter_open(&hw_event, 0, -1, -1, 0);
-		if (fd[0][counter] < 0) {
-			printf("perfstat error: syscall returned with %d (%s)\n",
-					fd[0][counter], strerror(errno));
-			exit(-1);
-		}
-	}
-}
-
-
-int main(int argc, char *argv[])
-{
-	unsigned long long t0, t1;
-	int counter;
-	ssize_t res;
-	int status;
-	int pid;
-
-	process_options(argc, argv);
-
-	if (system_wide) {
-		nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
-		assert(nr_cpus <= MAX_NR_CPUS);
-		assert(nr_cpus >= 0);
-	} else
-		nr_cpus = 1;
-
-	for (counter = 0; counter < nr_counters; counter++)
-		create_counter(counter);
-
-	argc -= optind;
-	argv += optind;
-
-	/*
-	 * Enable counters and exec the command:
-	 */
-	t0 = rdclock();
-	prctl(PR_TASK_PERF_COUNTERS_ENABLE);
-
-	if ((pid = fork()) < 0)
-		perror("failed to fork");
-	if (!pid) {
-		if (execvp(argv[0], argv)) {
-			perror(argv[0]);
-			exit(-1);
-		}
-	}
-	while (wait(&status) >= 0)
-		;
-	prctl(PR_TASK_PERF_COUNTERS_DISABLE);
-	t1 = rdclock();
-
-	fflush(stdout);
-
-	fprintf(stderr, "\n");
-	fprintf(stderr, " Performance counter stats for \'%s\':\n",
-		argv[0]);
-	fprintf(stderr, "\n");
-
-	for (counter = 0; counter < nr_counters; counter++) {
-		int cpu;
-		__u64 count, single_count;
-
-		count = 0;
-		for (cpu = 0; cpu < nr_cpus; cpu ++) {
-			res = read(fd[cpu][counter],
-					(char *) &single_count, sizeof(single_count));
-			assert(res == sizeof(single_count));
-			count += single_count;
-		}
-
-		if (!event_raw[counter] &&
-		    (event_id[counter] == PERF_COUNT_CPU_CLOCK ||
-		     event_id[counter] == PERF_COUNT_TASK_CLOCK)) {
-
-			double msecs = (double)count / 1000000;
-
-			fprintf(stderr, " %14.6f  %-20s (msecs)\n",
-				msecs, event_name(counter));
-		} else {
-			fprintf(stderr, " %14Ld  %-20s (events)\n",
-				count, event_name(counter));
-		}
-		if (!counter)
-			fprintf(stderr, "\n");
-	}
-	fprintf(stderr, "\n");
-	fprintf(stderr, " Wall-clock time elapsed: %12.6f msecs\n",
-			(double)(t1-t0)/1e6);
-	fprintf(stderr, "\n");
-
-	return 0;
-}
