Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZEZLEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZEZLEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 07:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZEZLEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 07:04:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:40076 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbZEZLE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 07:04:28 -0400
Date: Tue, 26 May 2009 11:03:31 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf stat: Convert to Git option parsing
Message-ID: <tip-5242519b0296d128425368fc6ab17f541d5fa775@git.kernel.org>
Git-Commit-ID: 5242519b0296d128425368fc6ab17f541d5fa775
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 11:03:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5242519b0296d128425368fc6ab17f541d5fa775
Gitweb:     http://git.kernel.org/tip/5242519b0296d128425368fc6ab17f541d5fa775
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 26 May 2009 09:17:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 11:59:34 +0200

perf stat: Convert to Git option parsing

Remove getopt usage and use Git's much more advanced and more compact
command option library.

Extend the event parser library with the extensions that were in
perf-stat before.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c    |    3 +-
 Documentation/perf_counter/builtin-stat.c      |  414 ++++--------------------
 Documentation/perf_counter/util/parse-events.c |   82 ++++-
 Documentation/perf_counter/util/parse-events.h |   10 +
 4 files changed, 145 insertions(+), 364 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index 6fa6ed6..ec2b787 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -4,7 +4,6 @@
 #include "util/util.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
-#include "util/exec_cmd.h"
 
 #include <sched.h>
 
@@ -400,7 +399,7 @@ static const char * const record_usage[] = {
 
 static char events_help_msg[EVENTS_HELP_MAX];
 
-const struct option options[] = {
+static const struct option options[] = {
 	OPT_CALLBACK('e', "event", NULL, "event",
 		     events_help_msg, parse_events),
 	OPT_INTEGER('c', "count", &default_interval,
diff --git a/Documentation/perf_counter/builtin-stat.c b/Documentation/perf_counter/builtin-stat.c
index c1053d8..e7cb941 100644
--- a/Documentation/perf_counter/builtin-stat.c
+++ b/Documentation/perf_counter/builtin-stat.c
@@ -1,35 +1,5 @@
 /*
- * kerneltop.c: show top kernel functions - performance counters showcase
-
-   Build with:
-
-     cc -O6 -Wall -c -o kerneltop.o kerneltop.c -lrt
-
-   Sample output:
-
-------------------------------------------------------------------------------
- KernelTop:    2669 irqs/sec  [NMI, cache-misses/cache-refs],  (all, cpu: 2)
-------------------------------------------------------------------------------
-
-             weight         RIP          kernel function
-             ______   ________________   _______________
-
-              35.20 - ffffffff804ce74b : skb_copy_and_csum_dev
-              33.00 - ffffffff804cb740 : sock_alloc_send_skb
-              31.26 - ffffffff804ce808 : skb_push
-              22.43 - ffffffff80510004 : tcp_established_options
-              19.00 - ffffffff8027d250 : find_get_page
-              15.76 - ffffffff804e4fc9 : eth_type_trans
-              15.20 - ffffffff804d8baa : dst_release
-              14.86 - ffffffff804cf5d8 : skb_release_head_state
-              14.00 - ffffffff802217d5 : read_hpet
-              12.00 - ffffffff804ffb7f : __ip_local_out
-              11.97 - ffffffff804fc0c8 : ip_local_deliver_finish
-               8.54 - ffffffff805001a3 : ip_queue_xmit
- */
-
-/*
- * perfstat:  /usr/bin/time -alike performance counter statistics utility
+ * perf stat:  /usr/bin/time -alike performance counter statistics utility
 
           It summarizes the counter events of all tasks (and child tasks),
           covering all CPUs that the command (or workload) executes on.
@@ -38,59 +8,38 @@
 
    Sample output:
 
-   $ ./perfstat -e 1 -e 3 -e 5 ls -lR /usr/include/ >/dev/null
+   $ perf stat -e 1 -e 3 -e 5 ls -lR /usr/include/ >/dev/null
 
    Performance counter stats for 'ls':
 
            163516953 instructions
                 2295 cache-misses
              2855182 branch-misses
+ *
+ * Copyright (C) 2008, Red Hat Inc, Ingo Molnar <mingo@redhat.com>
+ *
+ * Improvements and fixes by:
+ *
+ *   Arjan van de Ven <arjan@linux.intel.com>
+ *   Yanmin Zhang <yanmin.zhang@intel.com>
+ *   Wu Fengguang <fengguang.wu@intel.com>
+ *   Mike Galbraith <efault@gmx.de>
+ *   Paul Mackerras <paulus@samba.org>
+ *
+ * Released under the GPL v2. (and only v2, not any later version)
  */
 
- /*
-  * Copyright (C) 2008, Red Hat Inc, Ingo Molnar <mingo@redhat.com>
-  *
-  * Improvements and fixes by:
-  *
-  *   Arjan van de Ven <arjan@linux.intel.com>
-  *   Yanmin Zhang <yanmin.zhang@intel.com>
-  *   Wu Fengguang <fengguang.wu@intel.com>
-  *   Mike Galbraith <efault@gmx.de>
-  *   Paul Mackerras <paulus@samba.org>
-  *
-  * Released under the GPL v2. (and only v2, not any later version)
-  */
-
 #include "perf.h"
 #include "util/util.h"
+#include "util/parse-options.h"
+#include "util/parse-events.h"
 
-#include <getopt.h>
-#include <assert.h>
-#include <fcntl.h>
-#include <stdio.h>
-#include <errno.h>
-#include <time.h>
-#include <sched.h>
-#include <pthread.h>
-
-#include <sys/syscall.h>
-#include <sys/ioctl.h>
-#include <sys/poll.h>
 #include <sys/prctl.h>
-#include <sys/wait.h>
-#include <sys/uio.h>
-#include <sys/mman.h>
-
-#include <linux/unistd.h>
-#include <linux/types.h>
-
-#define EVENT_MASK_KERNEL		1
-#define EVENT_MASK_USER			2
 
 static int			system_wide			=  0;
+static int			inherit				=  1;
 
-static int			nr_counters			=  0;
-static __u64			event_id[MAX_COUNTERS]		= {
+static __u64			default_event_id[MAX_COUNTERS]	= {
 	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK),
 	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CONTEXT_SWITCHES),
 	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_MIGRATIONS),
@@ -101,20 +50,15 @@ static __u64			event_id[MAX_COUNTERS]		= {
 	EID(PERF_TYPE_HARDWARE, PERF_COUNT_CACHE_REFERENCES),
 	EID(PERF_TYPE_HARDWARE, PERF_COUNT_CACHE_MISSES),
 };
+
 static int			default_interval = 100000;
 static int			event_count[MAX_COUNTERS];
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
-static int			event_mask[MAX_COUNTERS];
 
-static int			tid				= -1;
-static int			profile_cpu			= -1;
+static int			target_pid			= -1;
 static int			nr_cpus				=  0;
-static int			nmi				=  1;
-static int			group				=  0;
 static unsigned int		page_size;
 
-static int			zero;
-
 static int			scale				=  1;
 
 static const unsigned int default_count[] = {
@@ -126,197 +70,6 @@ static const unsigned int default_count[] = {
 	  10000,
 };
 
-static char *hw_event_names[] = {
-	"CPU cycles",
-	"instructions",
-	"cache references",
-	"cache misses",
-	"branches",
-	"branch misses",
-	"bus cycles",
-};
-
-static char *sw_event_names[] = {
-	"cpu clock ticks",
-	"task clock ticks",
-	"pagefaults",
-	"context switches",
-	"CPU migrations",
-	"minor faults",
-	"major faults",
-};
-
-struct event_symbol {
-	__u64 event;
-	char *symbol;
-};
-
-static struct event_symbol event_symbols[] = {
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_CPU_CYCLES),		"cpu-cycles",		},
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_CPU_CYCLES),		"cycles",		},
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_INSTRUCTIONS),		"instructions",		},
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_CACHE_REFERENCES),		"cache-references",	},
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_CACHE_MISSES),		"cache-misses",		},
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_BRANCH_INSTRUCTIONS),	"branch-instructions",	},
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_BRANCH_INSTRUCTIONS),	"branches",		},
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_BRANCH_MISSES),		"branch-misses",	},
-	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_BUS_CYCLES),		"bus-cycles",		},
-
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_CLOCK),			"cpu-clock",		},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK),		"task-clock",		},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS),		"page-faults",		},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS),		"faults",		},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS_MIN),		"minor-faults",		},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS_MAJ),		"major-faults",		},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CONTEXT_SWITCHES),		"context-switches",	},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CONTEXT_SWITCHES),		"cs",			},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_MIGRATIONS),		"cpu-migrations",	},
-	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_MIGRATIONS),		"migrations",		},
-};
-
-#define __PERF_COUNTER_FIELD(config, name) \
-	((config & PERF_COUNTER_##name##_MASK) >> PERF_COUNTER_##name##_SHIFT)
-
-#define PERF_COUNTER_RAW(config)	__PERF_COUNTER_FIELD(config, RAW)
-#define PERF_COUNTER_CONFIG(config)	__PERF_COUNTER_FIELD(config, CONFIG)
-#define PERF_COUNTER_TYPE(config)	__PERF_COUNTER_FIELD(config, TYPE)
-#define PERF_COUNTER_ID(config)		__PERF_COUNTER_FIELD(config, EVENT)
-
-static void display_events_help(void)
-{
-	unsigned int i;
-	__u64 e;
-
-	printf(
-	" -e EVENT     --event=EVENT   #  symbolic-name        abbreviations");
-
-	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
-		int type, id;
-
-		e = event_symbols[i].event;
-		type = PERF_COUNTER_TYPE(e);
-		id = PERF_COUNTER_ID(e);
-
-		printf("\n                             %d:%d: %-20s",
-				type, id, event_symbols[i].symbol);
-	}
-
-	printf("\n"
-	"                           rNNN: raw PMU events (eventsel+umask)\n\n");
-}
-
-static void display_help(void)
-{
-	printf(
-	"Usage: perfstat [<events...>] <cmd...>\n\n"
-	"PerfStat Options (up to %d event types can be specified):\n\n",
-		 MAX_COUNTERS);
-
-	display_events_help();
-
-	printf(
-	" -l                           # scale counter values\n"
-	" -a                           # system-wide collection\n");
-	exit(0);
-}
-
-static char *event_name(int ctr)
-{
-	__u64 config = event_id[ctr];
-	int type = PERF_COUNTER_TYPE(config);
-	int id = PERF_COUNTER_ID(config);
-	static char buf[32];
-
-	if (PERF_COUNTER_RAW(config)) {
-		sprintf(buf, "raw 0x%llx", PERF_COUNTER_CONFIG(config));
-		return buf;
-	}
-
-	switch (type) {
-	case PERF_TYPE_HARDWARE:
-		if (id < PERF_HW_EVENTS_MAX)
-			return hw_event_names[id];
-		return "unknown-hardware";
-
-	case PERF_TYPE_SOFTWARE:
-		if (id < PERF_SW_EVENTS_MAX)
-			return sw_event_names[id];
-		return "unknown-software";
-
-	default:
-		break;
-	}
-
-	return "unknown";
-}
-
-/*
- * Each event can have multiple symbolic names.
- * Symbolic names are (almost) exactly matched.
- */
-static __u64 match_event_symbols(char *str)
-{
-	__u64 config, id;
-	int type;
-	unsigned int i;
-	char mask_str[4];
-
-	if (sscanf(str, "r%llx", &config) == 1)
-		return config | PERF_COUNTER_RAW_MASK;
-
-	switch (sscanf(str, "%d:%llu:%2s", &type, &id, mask_str)) {
-		case 3:
-			if (strchr(mask_str, 'k'))
-				event_mask[nr_counters] |= EVENT_MASK_USER;
-			if (strchr(mask_str, 'u'))
-				event_mask[nr_counters] |= EVENT_MASK_KERNEL;
-		case 2:
-			return EID(type, id);
-
-		default:
-			break;
-	}
-
-	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
-		if (!strncmp(str, event_symbols[i].symbol,
-			     strlen(event_symbols[i].symbol)))
-			return event_symbols[i].event;
-	}
-
-	return ~0ULL;
-}
-
-static int parse_events(char *str)
-{
-	__u64 config;
-
-again:
-	if (nr_counters == MAX_COUNTERS)
-		return -1;
-
-	config = match_event_symbols(str);
-	if (config == ~0ULL)
-		return -1;
-
-	event_id[nr_counters] = config;
-	nr_counters++;
-
-	str = strstr(str, ",");
-	if (str) {
-		str++;
-		goto again;
-	}
-
-	return 0;
-}
-
-
-/*
- * perfstat
- */
-
-char fault_here[1000000];
-
 static void create_perfstat_counter(int counter)
 {
 	struct perf_counter_hw_event hw_event;
@@ -324,7 +77,7 @@ static void create_perfstat_counter(int counter)
 	memset(&hw_event, 0, sizeof(hw_event));
 	hw_event.config		= event_id[counter];
 	hw_event.record_type	= 0;
-	hw_event.nmi		= 0;
+	hw_event.nmi		= 1;
 	hw_event.exclude_kernel = event_mask[counter] & EVENT_MASK_KERNEL;
 	hw_event.exclude_user   = event_mask[counter] & EVENT_MASK_USER;
 
@@ -343,7 +96,7 @@ static void create_perfstat_counter(int counter)
 			}
 		}
 	} else {
-		hw_event.inherit	= 1;
+		hw_event.inherit	= inherit;
 		hw_event.disabled	= 1;
 
 		fd[0][counter] = sys_perf_counter_open(&hw_event, 0, -1, -1, 0);
@@ -355,7 +108,7 @@ static void create_perfstat_counter(int counter)
 	}
 }
 
-int do_perfstat(int argc, char *argv[])
+int do_perfstat(int argc, const char **argv)
 {
 	unsigned long long t0, t1;
 	int counter;
@@ -369,12 +122,6 @@ int do_perfstat(int argc, char *argv[])
 	for (counter = 0; counter < nr_counters; counter++)
 		create_perfstat_counter(counter);
 
-	argc -= optind;
-	argv += optind;
-
-	if (!argc)
-		display_help();
-
 	/*
 	 * Enable counters and exec the command:
 	 */
@@ -384,7 +131,7 @@ int do_perfstat(int argc, char *argv[])
 	if ((pid = fork()) < 0)
 		perror("failed to fork");
 	if (!pid) {
-		if (execvp(argv[0], argv)) {
+		if (execvp(argv[0], (char **)argv)) {
 			perror(argv[0]);
 			exit(-1);
 		}
@@ -458,70 +205,45 @@ int do_perfstat(int argc, char *argv[])
 	return 0;
 }
 
-static void process_options(int argc, char **argv)
+static void skip_signal(int signo)
 {
-	int error = 0, counter;
-
-	for (;;) {
-		int option_index = 0;
-		/** Options for getopt */
-		static struct option long_options[] = {
-			{"count",	required_argument,	NULL, 'c'},
-			{"cpu",		required_argument,	NULL, 'C'},
-			{"delay",	required_argument,	NULL, 'd'},
-			{"dump_symtab",	no_argument,		NULL, 'D'},
-			{"event",	required_argument,	NULL, 'e'},
-			{"filter",	required_argument,	NULL, 'f'},
-			{"group",	required_argument,	NULL, 'g'},
-			{"help",	no_argument,		NULL, 'h'},
-			{"nmi",		required_argument,	NULL, 'n'},
-			{"munmap_info",	no_argument,		NULL, 'U'},
-			{"pid",		required_argument,	NULL, 'p'},
-			{"realtime",	required_argument,	NULL, 'r'},
-			{"scale",	no_argument,		NULL, 'l'},
-			{"symbol",	required_argument,	NULL, 's'},
-			{"stat",	no_argument,		NULL, 'S'},
-			{"vmlinux",	required_argument,	NULL, 'x'},
-			{"zero",	no_argument,		NULL, 'z'},
-			{NULL,		0,			NULL,  0 }
-		};
-		int c = getopt_long(argc, argv, "+:ac:C:d:De:f:g:hln:m:p:r:s:Sx:zMU",
-				    long_options, &option_index);
-		if (c == -1)
-			break;
-
-		switch (c) {
-		case 'a': system_wide			=	       1; break;
-		case 'c': default_interval		=   atoi(optarg); break;
-		case 'C':
-			/* CPU and PID are mutually exclusive */
-			if (tid != -1) {
-				printf("WARNING: CPU switch overriding PID\n");
-				sleep(1);
-				tid = -1;
-			}
-			profile_cpu			=   atoi(optarg); break;
-
-		case 'e': error				= parse_events(optarg); break;
-
-		case 'g': group				=   atoi(optarg); break;
-		case 'h':      				  display_help(); break;
-		case 'l': scale				=	       1; break;
-		case 'n': nmi				=   atoi(optarg); break;
-		case 'p':
-			/* CPU and PID are mutually exclusive */
-			if (profile_cpu != -1) {
-				printf("WARNING: PID switch overriding CPU\n");
-				sleep(1);
-				profile_cpu = -1;
-			}
-			tid				=   atoi(optarg); break;
-		case 'z': zero				=              1; break;
-		default: error = 1; break;
-		}
-	}
-	if (error)
-		display_help();
+}
+
+static const char * const stat_usage[] = {
+	"perf stat [<options>] <command>",
+	NULL
+};
+
+static char events_help_msg[EVENTS_HELP_MAX];
+
+static const struct option options[] = {
+	OPT_CALLBACK('e', "event", NULL, "event",
+		     events_help_msg, parse_events),
+	OPT_INTEGER('c', "count", &default_interval,
+		    "event period to sample"),
+	OPT_BOOLEAN('i', "inherit", &inherit,
+		    "child tasks inherit counters"),
+	OPT_INTEGER('p', "pid", &target_pid,
+		    "stat events on existing pid"),
+	OPT_BOOLEAN('a', "all-cpus", &system_wide,
+			    "system-wide collection from all CPUs"),
+	OPT_BOOLEAN('l', "scale", &scale,
+			    "scale/normalize counters"),
+	OPT_END()
+};
+
+int cmd_stat(int argc, const char **argv, const char *prefix)
+{
+	int counter;
+
+	page_size = sysconf(_SC_PAGE_SIZE);
+
+	create_events_help(events_help_msg);
+	memcpy(event_id, default_event_id, sizeof(default_event_id));
+
+	argc = parse_options(argc, argv, options, stat_usage, 0);
+	if (!argc)
+		usage_with_options(stat_usage, options);
 
 	if (!nr_counters) {
 		nr_counters = 8;
@@ -533,18 +255,6 @@ static void process_options(int argc, char **argv)
 
 		event_count[counter] = default_interval;
 	}
-}
-
-static void skip_signal(int signo)
-{
-}
-
-int cmd_stat(int argc, char **argv, const char *prefix)
-{
-	page_size = sysconf(_SC_PAGE_SIZE);
-
-	process_options(argc, argv);
-
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	assert(nr_cpus <= MAX_NR_CPUS);
 	assert(nr_cpus >= 0);
diff --git a/Documentation/perf_counter/util/parse-events.c b/Documentation/perf_counter/util/parse-events.c
index 77d0917..88c903e 100644
--- a/Documentation/perf_counter/util/parse-events.c
+++ b/Documentation/perf_counter/util/parse-events.c
@@ -8,6 +8,7 @@
 int nr_counters;
 
 __u64			event_id[MAX_COUNTERS]		= { };
+int			event_mask[MAX_COUNTERS];
 
 struct event_symbol {
 	__u64 event;
@@ -37,6 +38,64 @@ static struct event_symbol event_symbols[] = {
 	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_MIGRATIONS),		"migrations",		},
 };
 
+#define __PERF_COUNTER_FIELD(config, name) \
+	((config & PERF_COUNTER_##name##_MASK) >> PERF_COUNTER_##name##_SHIFT)
+
+#define PERF_COUNTER_RAW(config)	__PERF_COUNTER_FIELD(config, RAW)
+#define PERF_COUNTER_CONFIG(config)	__PERF_COUNTER_FIELD(config, CONFIG)
+#define PERF_COUNTER_TYPE(config)	__PERF_COUNTER_FIELD(config, TYPE)
+#define PERF_COUNTER_ID(config)		__PERF_COUNTER_FIELD(config, EVENT)
+
+static char *hw_event_names[] = {
+	"CPU cycles",
+	"instructions",
+	"cache references",
+	"cache misses",
+	"branches",
+	"branch misses",
+	"bus cycles",
+};
+
+static char *sw_event_names[] = {
+	"cpu clock ticks",
+	"task clock ticks",
+	"pagefaults",
+	"context switches",
+	"CPU migrations",
+	"minor faults",
+	"major faults",
+};
+
+char *event_name(int ctr)
+{
+	__u64 config = event_id[ctr];
+	int type = PERF_COUNTER_TYPE(config);
+	int id = PERF_COUNTER_ID(config);
+	static char buf[32];
+
+	if (PERF_COUNTER_RAW(config)) {
+		sprintf(buf, "raw 0x%llx", PERF_COUNTER_CONFIG(config));
+		return buf;
+	}
+
+	switch (type) {
+	case PERF_TYPE_HARDWARE:
+		if (id < PERF_HW_EVENTS_MAX)
+			return hw_event_names[id];
+		return "unknown-hardware";
+
+	case PERF_TYPE_SOFTWARE:
+		if (id < PERF_SW_EVENTS_MAX)
+			return sw_event_names[id];
+		return "unknown-software";
+
+	default:
+		break;
+	}
+
+	return "unknown";
+}
+
 /*
  * Each event can have multiple symbolic names.
  * Symbolic names are (almost) exactly matched.
@@ -46,12 +105,23 @@ static __u64 match_event_symbols(const char *str)
 	__u64 config, id;
 	int type;
 	unsigned int i;
+	char mask_str[4];
 
 	if (sscanf(str, "r%llx", &config) == 1)
 		return config | PERF_COUNTER_RAW_MASK;
 
-	if (sscanf(str, "%d:%llu", &type, &id) == 2)
-		return EID(type, id);
+	switch (sscanf(str, "%d:%llu:%2s", &type, &id, mask_str)) {
+		case 3:
+			if (strchr(mask_str, 'k'))
+				event_mask[nr_counters] |= EVENT_MASK_USER;
+			if (strchr(mask_str, 'u'))
+				event_mask[nr_counters] |= EVENT_MASK_KERNEL;
+		case 2:
+			return EID(type, id);
+
+		default:
+			break;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
 		if (!strncmp(str, event_symbols[i].symbol,
@@ -86,14 +156,6 @@ again:
 	return 0;
 }
 
-#define __PERF_COUNTER_FIELD(config, name) \
-	((config & PERF_COUNTER_##name##_MASK) >> PERF_COUNTER_##name##_SHIFT)
-
-#define PERF_COUNTER_RAW(config)	__PERF_COUNTER_FIELD(config, RAW)
-#define PERF_COUNTER_CONFIG(config)	__PERF_COUNTER_FIELD(config, CONFIG)
-#define PERF_COUNTER_TYPE(config)	__PERF_COUNTER_FIELD(config, TYPE)
-#define PERF_COUNTER_ID(config)		__PERF_COUNTER_FIELD(config, EVENT)
-
 /*
  * Create the help text for the event symbols:
  */
diff --git a/Documentation/perf_counter/util/parse-events.h b/Documentation/perf_counter/util/parse-events.h
index 6e2ebe5..0da306b 100644
--- a/Documentation/perf_counter/util/parse-events.h
+++ b/Documentation/perf_counter/util/parse-events.h
@@ -1,6 +1,16 @@
 
+/*
+ * Parse symbolic events/counts passed in as options:
+ */
+
 extern int nr_counters;
 extern __u64			event_id[MAX_COUNTERS];
+extern int			event_mask[MAX_COUNTERS];
+
+#define EVENT_MASK_KERNEL	1
+#define EVENT_MASK_USER		2
+
+extern char *event_name(int ctr);
 
 extern int parse_events(const struct option *opt, const char *str, int unset);
 
