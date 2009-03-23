Return-Path: <linux-kernel-owner+w=401wt.eu-S1760334AbZCWU6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334AbZCWU6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759925AbZCWU5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:57:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:49101 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759859AbZCWU5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:57:40 -0400
Date: Mon, 23 Mar 2009 20:57:07 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       fengguang.wu@intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, fengguang.wu@intel.com, mingo@elte.hu
In-Reply-To: <20090323172417.559643732@chello.nl>
References: <20090323172417.559643732@chello.nl>
Subject: [tip:perfcounters/core] kerneltop: update to new syscall ABI
Message-ID: <tip-d68cd6cac7e4b63ca990e7c4c24aef112f8d6c60@git.kernel.org>
Git-Commit-ID: d68cd6cac7e4b63ca990e7c4c24aef112f8d6c60
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 20:57:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d68cd6cac7e4b63ca990e7c4c24aef112f8d6c60
Gitweb:     http://git.kernel.org/tip/d68cd6cac7e4b63ca990e7c4c24aef112f8d6c60
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 23 Mar 2009 18:22:11 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 21:45:11 +0100

kerneltop: update to new syscall ABI

update the kerneltop userspace to work with the latest syscall ABI

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090323172417.559643732@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/kerneltop.c |  235 +++++++++++++++++++++-----------
 1 files changed, 157 insertions(+), 78 deletions(-)

diff --git a/Documentation/perf_counter/kerneltop.c b/Documentation/perf_counter/kerneltop.c
index 81a68aa..a72c9bd 100644
--- a/Documentation/perf_counter/kerneltop.c
+++ b/Documentation/perf_counter/kerneltop.c
@@ -87,20 +87,90 @@
 
 #include <linux/unistd.h>
 
-#include "perfcounters.h"
+#include "include/linux/perf_counter.h"
 
 
+/*
+ * prctl(PR_TASK_PERF_COUNTERS_DISABLE) will (cheaply) disable all
+ * counters in the current task.
+ */
+#define PR_TASK_PERF_COUNTERS_DISABLE   31
+#define PR_TASK_PERF_COUNTERS_ENABLE    32
+
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+
+#define rdclock()                                       \
+({                                                      \
+        struct timespec ts;                             \
+                                                        \
+        clock_gettime(CLOCK_MONOTONIC, &ts);            \
+        ts.tv_sec * 1000000000ULL + ts.tv_nsec;         \
+})
+
+/*
+ * Pick up some kernel type conventions:
+ */
+#define __user
+#define asmlinkage
+
+typedef unsigned int            __u32;
+typedef unsigned long long      __u64;
+typedef long long               __s64;
+
+
+#ifdef __x86_64__
+# define __NR_perf_counter_open 295
+#endif
+
+#ifdef __i386__
+# define __NR_perf_counter_open 333
+#endif
+
+#ifdef __powerpc__
+#define __NR_perf_counter_open 319
+#endif
+
+asmlinkage int sys_perf_counter_open(
+        struct perf_counter_hw_event    *hw_event_uptr          __user,
+        pid_t                           pid,
+        int                             cpu,
+        int                             group_fd,
+        unsigned long                   flags)
+{
+        int ret;
+
+        ret = syscall(
+                __NR_perf_counter_open, hw_event_uptr, pid, cpu, group_fd, flags);
+#if defined(__x86_64__) || defined(__i386__)
+        if (ret < 0 && ret > -4096) {
+                errno = -ret;
+                ret = -1;
+        }
+#endif
+        return ret;
+}
+
 #define MAX_COUNTERS			64
 #define MAX_NR_CPUS			256
 
-#define DEF_PERFSTAT_EVENTS		{ -2, -5, -4, -3, 0, 1, 2, 3}
+#define EID(type, id) (((__u64)(type) << PERF_COUNTER_TYPE_SHIFT) | (id))
 
 static int			run_perfstat			=  0;
 static int			system_wide			=  0;
 
 static int			nr_counters			=  0;
-static __s64			event_id[MAX_COUNTERS]		= DEF_PERFSTAT_EVENTS;
-static int			event_raw[MAX_COUNTERS];
+static __u64			event_id[MAX_COUNTERS]		= {
+	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK),
+	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_MIGRATIONS),
+	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_MIGRATIONS),
+	EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS),
+
+	EID(PERF_TYPE_HARDWARE, PERF_COUNT_CPU_CYCLES),
+	EID(PERF_TYPE_HARDWARE, PERF_COUNT_INSTRUCTIONS),
+	EID(PERF_TYPE_HARDWARE, PERF_COUNT_CACHE_REFERENCES),
+	EID(PERF_TYPE_HARDWARE, PERF_COUNT_CACHE_MISSES),
+};
+static int			default_interval = 100000;
 static int			event_count[MAX_COUNTERS];
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
@@ -156,49 +226,63 @@ static char *sw_event_names[] = {
 	"pagefaults",
 	"context switches",
 	"CPU migrations",
+	"minor faults",
+	"major faults",
 };
 
 struct event_symbol {
-	int event;
+	__u64 event;
 	char *symbol;
 };
 
 static struct event_symbol event_symbols[] = {
-	{PERF_COUNT_CPU_CYCLES,			"cpu-cycles",		},
-	{PERF_COUNT_CPU_CYCLES,			"cycles",		},
-	{PERF_COUNT_INSTRUCTIONS,		"instructions",		},
-	{PERF_COUNT_CACHE_REFERENCES,		"cache-references",	},
-	{PERF_COUNT_CACHE_MISSES,		"cache-misses",		},
-	{PERF_COUNT_BRANCH_INSTRUCTIONS,	"branch-instructions",	},
-	{PERF_COUNT_BRANCH_INSTRUCTIONS,	"branches",		},
-	{PERF_COUNT_BRANCH_MISSES,		"branch-misses",	},
-	{PERF_COUNT_BUS_CYCLES,			"bus-cycles",		},
-	{PERF_COUNT_CPU_CLOCK,			"cpu-ticks",		},
-	{PERF_COUNT_CPU_CLOCK,			"ticks",		},
-	{PERF_COUNT_TASK_CLOCK,			"task-ticks",		},
-	{PERF_COUNT_PAGE_FAULTS,		"page-faults",		},
-	{PERF_COUNT_PAGE_FAULTS,		"faults",		},
-	{PERF_COUNT_CONTEXT_SWITCHES,		"context-switches",	},
-	{PERF_COUNT_CONTEXT_SWITCHES,		"cs",			},
-	{PERF_COUNT_CPU_MIGRATIONS,		"cpu-migrations",	},
-	{PERF_COUNT_CPU_MIGRATIONS,		"migrations",		},
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_CPU_CYCLES),		"cpu-cycles",		},
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_CPU_CYCLES),		"cycles",		},
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_INSTRUCTIONS),		"instructions",		},
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_CACHE_REFERENCES),		"cache-references",	},
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_CACHE_MISSES),		"cache-misses",		},
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_BRANCH_INSTRUCTIONS),	"branch-instructions",	},
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_BRANCH_INSTRUCTIONS),	"branches",		},
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_BRANCH_MISSES),		"branch-misses",	},
+	{EID(PERF_TYPE_HARDWARE, PERF_COUNT_BUS_CYCLES),		"bus-cycles",		},
+
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_CLOCK),			"cpu-clock",		},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK),		"task-clock",		},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS),		"page-faults",		},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS),		"faults",		},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS_MIN),		"minor-faults",		},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_PAGE_FAULTS_MAJ),		"major-faults",		},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CONTEXT_SWITCHES),		"context-switches",	},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CONTEXT_SWITCHES),		"cs",			},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_MIGRATIONS),		"cpu-migrations",	},
+	{EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_MIGRATIONS),		"migrations",		},
 };
 
+#define __PERF_COUNTER_FIELD(config, name) \
+	((config & PERF_COUNTER_##name##_MASK) >> PERF_COUNTER_##name##_SHIFT)
+
+#define PERF_COUNTER_RAW(config)	__PERF_COUNTER_FIELD(config, RAW)
+#define PERF_COUNTER_CONFIG(config)	__PERF_COUNTER_FIELD(config, CONFIG)
+#define PERF_COUNTER_TYPE(config)	__PERF_COUNTER_FIELD(config, TYPE)
+#define PERF_COUNTER_ID(config)		__PERF_COUNTER_FIELD(config, EVENT)
+
 static void display_events_help(void)
 {
 	unsigned int i;
-	int e;
+	__u64 e;
 
 	printf(
 	" -e EVENT     --event=EVENT   #  symbolic-name        abbreviations");
 
-	for (i = 0, e = PERF_HW_EVENTS_MAX; i < ARRAY_SIZE(event_symbols); i++) {
-		if (e != event_symbols[i].event) {
-			e = event_symbols[i].event;
-			printf(
-	"\n                             %2d: %-20s", e, event_symbols[i].symbol);
-		} else
-			printf(" %s", event_symbols[i].symbol);
+	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
+		int type, id;
+
+		e = event_symbols[i].event;
+		type = PERF_COUNTER_TYPE(e);
+		id = PERF_COUNTER_ID(e);
+
+		printf("\n                             %d:%d: %-20s",
+				type, id, event_symbols[i].symbol);
 	}
 
 	printf("\n"
@@ -249,44 +333,51 @@ static void display_help(void)
 	exit(0);
 }
 
-static int type_valid(int type)
-{
-	if (type >= PERF_HW_EVENTS_MAX)
-		return 0;
-	if (type <= PERF_SW_EVENTS_MIN)
-		return 0;
-
-	return 1;
-}
-
 static char *event_name(int ctr)
 {
-	__s64 type = event_id[ctr];
+	__u64 config = event_id[ctr];
+	int type = PERF_COUNTER_TYPE(config);
+	int id = PERF_COUNTER_ID(config);
 	static char buf[32];
 
-	if (event_raw[ctr]) {
-		sprintf(buf, "raw 0x%llx", (long long)type);
+	if (PERF_COUNTER_RAW(config)) {
+		sprintf(buf, "raw 0x%llx", PERF_COUNTER_CONFIG(config));
 		return buf;
 	}
-	if (!type_valid(type))
-		return "unknown";
 
-	if (type >= 0)
-		return hw_event_names[type];
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
 
-	return sw_event_names[-type-1];
+	default:
+		break;
+	}
+
+	return "unknown";
 }
 
 /*
  * Each event can have multiple symbolic names.
  * Symbolic names are (almost) exactly matched.
  */
-static int match_event_symbols(char *str)
+static __u64 match_event_symbols(char *str)
 {
+	__u64 config, id;
+	int type;
 	unsigned int i;
 
-	if (isdigit(str[0]) || str[0] == '-')
-		return atoi(str);
+	if (sscanf(str, "r%llx", &config) == 1)
+		return config | PERF_COUNTER_RAW_MASK;
+
+	if (sscanf(str, "%d:%llu", &type, &id) == 2)
+		return EID(type, id);
 
 	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
 		if (!strncmp(str, event_symbols[i].symbol,
@@ -294,31 +385,22 @@ static int match_event_symbols(char *str)
 			return event_symbols[i].event;
 	}
 
-	return PERF_HW_EVENTS_MAX;
+	return ~0ULL;
 }
 
 static int parse_events(char *str)
 {
-	__s64 type;
-	int raw;
+	__u64 config;
 
 again:
 	if (nr_counters == MAX_COUNTERS)
 		return -1;
 
-	raw = 0;
-	if (*str == 'r') {
-		raw = 1;
-		++str;
-		type = strtol(str, NULL, 16);
-	} else {
-		type = match_event_symbols(str);
-		if (!type_valid(type))
-			return -1;
-	}
+	config = match_event_symbols(str);
+	if (config == ~0ULL)
+		return -1;
 
-	event_id[nr_counters] = type;
-	event_raw[nr_counters] = raw;
+	event_id[nr_counters] = config;
 	nr_counters++;
 
 	str = strstr(str, ",");
@@ -342,8 +424,7 @@ static void create_perfstat_counter(int counter)
 	struct perf_counter_hw_event hw_event;
 
 	memset(&hw_event, 0, sizeof(hw_event));
-	hw_event.type		= event_id[counter];
-	hw_event.raw		= event_raw[counter];
+	hw_event.config		= event_id[counter];
 	hw_event.record_type	= PERF_RECORD_SIMPLE;
 	hw_event.nmi		= 0;
 
@@ -428,7 +509,7 @@ int do_perfstat(int argc, char *argv[])
 			count += single_count;
 		}
 
-		if (!event_raw[counter] &&
+		if (!PERF_COUNTER_RAW(event_id[counter]) &&
 		    (event_id[counter] == PERF_COUNT_CPU_CLOCK ||
 		     event_id[counter] == PERF_COUNT_TASK_CLOCK)) {
 
@@ -911,7 +992,7 @@ static void record_ip(uint64_t ip, int counter)
 		assert(left <= middle && middle <= right);
 		if (!(left <= ip && ip <= right)) {
 			printf(" left: %016lx\n", left);
-			printf("   ip: %016lx\n", ip);
+			printf("   ip: %016llx\n", ip);
 			printf("right: %016lx\n", right);
 		}
 		assert(left <= ip && ip <= right);
@@ -983,7 +1064,7 @@ static void process_options(int argc, char *argv[])
 
 		switch (c) {
 		case 'a': system_wide			=	       1; break;
-		case 'c': event_count[nr_counters]	=   atoi(optarg); break;
+		case 'c': default_interval		=   atoi(optarg); break;
 		case 'C':
 			/* CPU and PID are mutually exclusive */
 			if (tid != -1) {
@@ -1032,10 +1113,7 @@ static void process_options(int argc, char *argv[])
 		if (event_count[counter])
 			continue;
 
-		if (event_id[counter] < PERF_HW_EVENTS_MAX)
-			event_count[counter] = default_count[event_id[counter]];
-		else
-			event_count[counter] = 100000;
+		event_count[counter] = default_interval;
 	}
 }
 
@@ -1070,12 +1148,13 @@ int main(int argc, char *argv[])
 				cpu = i;
 
 			memset(&hw_event, 0, sizeof(hw_event));
-			hw_event.type		= event_id[counter];
-			hw_event.raw		= event_raw[counter];
+			hw_event.config		= event_id[counter];
 			hw_event.irq_period	= event_count[counter];
 			hw_event.record_type	= PERF_RECORD_IRQ;
 			hw_event.nmi		= nmi;
 
+			printf("FOO: %d %llx %llx\n", counter, event_id[counter], event_count[counter]);
+
 			fd[i][counter] = sys_perf_counter_open(&hw_event, tid, cpu, group_fd, 0);
 			fcntl(fd[i][counter], F_SETFL, O_NONBLOCK);
 			if (fd[i][counter] < 0) {
