Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbYLDXqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbYLDXqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 18:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbYLDXqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 18:46:16 -0500
Received: from www.tglx.de ([62.245.132.106]:38353 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbYLDXqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 18:46:14 -0500
Message-Id: <20081204225345.654705757@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 04 Dec 2008 23:44:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>
Subject: [patch 0/3] [Announcement] Performance Counters for Linux
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Performance counters are special hardware registers available on most modern
CPUs. These register count the number of certain types of hw events: such
as instructions executed, cachemisses suffered, or branches mis-predicted,
without slowing down the kernel or applications. These registers can also
trigger interrupts when a threshold number of events have passed - and can
thus be used to profile the code that runs on that CPU.

We'd like to announce a brand new implementation of performance counter
support for Linux. It is a very simple and extensible design that has the
potential to implement the full range of features we would expect from such
a subsystem.

The Linux Performance Counter subsystem (implemented via the patches
posted in this announcement) provides an abstraction of performance counter
hardware capabilities. It provides per task and per CPU counters, and it
provides event capabilities on top of those.

The code is far from complete - but the basic approach is already there
and stable.

The biggest missing detail is lowlevel support for non-Intel CPUs and
older Intel CPUs - right now the code is implemented for Intel Core2
(and later) Intel CPUs that have the PERFMON CPU feature. (see below
a wider list of missing/upcoming features)

We are aware of the perfmon3 patchset that has been submitted to lkml
recently. Our patchset tries to achieve a similar end result, with
a fundamentally different (and we believe, superior :-) design:

 - The API is based on a single counter abstraction

 - Only one single new system call is needed: sys_perf_counter_open().
   All performance-counter operations are implemented via standard
   VFS APIs such as read() / fcntl() and poll().

 - User-space is not exposed to lowlevel details like contexts or
   arrays of counters. Opening and reading a basic counter is as simple
   as 2 lines of C code:

   void main(void)
   {
      u64 count;

      fd = perf_counter_open(3 /* PERF_COUNT_CACHE_MISSES */, 0, 0, 0, -1);
      ret = read(fd, &count, sizeof(count));
      if (ret == sizeof(count))
              printf("Current count: %Ld cachemisses!", count);
   }

 - Events, blocking/sleep are natural built-in properties of counters.

 - No interaction with ptrace: any task (with sufficient permissions) can
   monitor other tasks, without having to stop that task.

 - Mapping of counters to hw counters is not static - counters are
   scheduled dynamically on each CPU where a task runs.

 - There's a /sys based reservation facility that allows the allocation
   of a certain number of hw counters for guaranteed sysadmin access.

 - Generalized enumeration for common hw event types. Raw event codes
   can be passed to the API too - but the most common (and most useful)
   event codes are generalized into a hardware-independent registry
   of events:

    enum hw_event_types {
           PERF_COUNT_CYCLES,
           PERF_COUNT_INSTRUCTIONS,
           PERF_COUNT_CACHE_REFERENCES,
           PERF_COUNT_CACHE_MISSES,
           PERF_COUNT_BRANCH_INSTRUCTIONS,
           PERF_COUNT_BRANCH_MISSES,
    };

 - Simplified lowlevel/arch support. The x86 code for Intel CPUs (with
   the PERFMON CPU feature) is 340 lines of code that implements
   7 straightforward lowlevel API calls:

    int hw_perf_counter_init(struct perf_counter *counter, u32 hw_event_type);
    void hw_perf_counter_enable(struct perf_counter *counter);
    void hw_perf_counter_disable(struct perf_counter *counter);
    void hw_perf_counter_read(struct perf_counter *counter);
    void hw_perf_counter_enable_config(struct perf_counter *counter);
    void hw_perf_counter_disable_config(struct perf_counter *counter);
    void hw_perf_counter_setup(void);

   There's one kernel/perf_counter.c core file, and a single
   arch/x86/kernel/cpu/perf_counter.c architecture support file.

   The impact on the kernel tree is relatively moderate:

       27 files changed, 1641 insertions(+), 7 deletions(-)

TODO:

 - Non-Intel CPU support. Help is welcome :-)

 - Round-robin scheduling of counters, when there's more task counters
   than hw counters available.

 - Support for extended record types such as PEBS.

 - Support for NMI events in the x86 code (the core design is ready)

 - Make sure it works well with OProfile and the x86 NMI watchdog

Short documentation is available in Documentation/perf-counters.txt

Find below the source of a simple monitoring demo.

We'd like to seek the feedback of perfmon developers and architecture
maintainers - what do you think about this approach?

Comments, reports, suggestions, flames and other types of feedback
is more than welcome,

	Thomas, Ingo
---

/*
 * Performance counters monitoring test case
 */
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <unistd.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <fcntl.h>
#include <stdio.h>
#include <errno.h>

#define __user

#include "sys.h"

static int count = 10000;
static int eventid;
static int tid;
static char *debuginfo;

static void display_help(void)
{
	printf("monitor\n");
	printf("Usage:\n"
	       "monitor options threadid\n\n"
	       "-e EID   --eventid=EID  eventid\n"
	       "-c CNT   --count=CNT    event count on which IP is sampled\n"
	       "-d FILE  --debug=FILE   path to binary file with debug info\n");
	exit(0);
}

static void process_options (int argc, char *argv[])
{
	int error = 0;

	for (;;) {
		int option_index = 0;
		/** Options for getopt */
		static struct option long_options[] = {
			{"count", required_argument, NULL, 'c'},
			{"debug", required_argument, NULL, 'd'},
			{"eventid", required_argument, NULL, 'e'},
			{"help", no_argument, NULL, 'h'},
			{NULL, 0, NULL, 0}
		};
		int c = getopt_long(argc, argv, "c:d:e:",
				    long_options, &option_index);
		if (c == -1)
			break;
		switch (c) {
		case 'c': count = atoi(optarg); break;
		case 'd': debuginfo = strdup(optarg); break;
		case 'e': eventid = atoi(optarg); break;
		default: error = 1; break;
		}
	}
	if (error || optind == argc)
		display_help ();

	tid = atoi(argv[optind]);
}

int main(int argc, char *argv[])
{
	char str[256];
	uint64_t ip;
	ssize_t res;
	int fd;

	process_options(argc, argv);

	fd = perf_counter_open(eventid, count, 1, tid, -1);
	if (fd < 0) {
		perror("Create counter");
		exit(-1);
	}

	while (1) {
		res = read(fd, (char *) &ip, sizeof(ip));
		if (res != sizeof(ip)) {
			perror("Read counter");
			break;
		}

		if (!debuginfo) {
			printf("IP: 0x%016llx\n", (unsigned long long)ip);
		} else {
			sprintf(str, "addr2line -e %s 0x%llx\n", debuginfo,
				(unsigned long long)ip);
			system(str);
		}
	}

	close(fd);
	exit(0);
}



