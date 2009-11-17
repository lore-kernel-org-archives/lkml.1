Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbZKQPng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbZKQPng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbZKQPng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:43:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:58861 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbZKQPnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:43:35 -0500
Date: Tue, 17 Nov 2009 15:42:48 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       fweisbec@gmail.com, ling.ma@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mitake@dcl.info.waseda.ac.jp, fweisbec@gmail.com, ling.ma@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258471212-30281-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1258471212-30281-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench: Add memcpy() benchmark
Message-ID: <tip-a123296c34c2b60bced7538ab005e2edf1275aa8@git.kernel.org>
Git-Commit-ID: a123296c34c2b60bced7538ab005e2edf1275aa8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a123296c34c2b60bced7538ab005e2edf1275aa8
Gitweb:     http://git.kernel.org/tip/a123296c34c2b60bced7538ab005e2edf1275aa8
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Wed, 18 Nov 2009 00:20:09 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Nov 2009 16:40:16 +0100

perf bench: Add memcpy() benchmark

'perf bench mem memcpy' is a benchmark suite for measuring memcpy()
performance.

Example:

| % perf bench mem memcpy -l 1GB
| # Running mem/memcpy benchmark...
| # Copying 1GB Bytes from 0x7f0bf417d010 to 0x7f0c3417e010 ...
|
|      830.937491 MB/Sec
|
| % perf bench mem memcpy -l 1GB -c
| # Running mem/memcpy benchmark...
| # Copying 1GB Bytes from 0x7f113fbf6010 to 0x7f117fbf7010 ...
|
|        3.259315 Clock/Byte

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ling Ma <ling.ma@intel.com>
LKML-Reference: <1258471212-30281-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile           |    1 +
 tools/perf/bench/bench.h      |    1 +
 tools/perf/bench/mem-memcpy.c |  196 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin-bench.c    |   15 +++-
 4 files changed, 212 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5d1a8b0..b356987 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -430,6 +430,7 @@ BUILTIN_OBJS += builtin-bench.o
 # Benchmark modules
 BUILTIN_OBJS += bench/sched-messaging.o
 BUILTIN_OBJS += bench/sched-pipe.o
+BUILTIN_OBJS += bench/mem-memcpy.o
 
 BUILTIN_OBJS += builtin-help.o
 BUILTIN_OBJS += builtin-sched.o
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index 9fbd8d7..f7781c6 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -3,6 +3,7 @@
 
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
+extern int bench_mem_memcpy(int argc, const char **argv, const char *prefix __used);
 
 #define BENCH_FORMAT_DEFAULT_STR	"default"
 #define BENCH_FORMAT_DEFAULT		0
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
new file mode 100644
index 0000000..27822ec
--- /dev/null
+++ b/tools/perf/bench/mem-memcpy.c
@@ -0,0 +1,196 @@
+/*
+ *
+ * mem-memcpy.c
+ *
+ * memcpy: Simple memory copy in various ways
+ *
+ * Based on memcpy.c by Ma Ling <ling.ma@intel.com>
+ * http://marc.info/?l=linux-kernel&m=125792321123782&w=2
+ * This memcpy.c is posted to LKML by Ma Ling for comparing
+ * two ways of memory copying.
+ * The thread is started from
+ * http://marc.info/?l=linux-kernel&m=125750023424093&w=2
+ *
+ * Ported to perf by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
+ *
+ */
+
+#include <ctype.h>
+
+#include "../perf.h"
+#include "../util/util.h"
+#include "../util/parse-options.h"
+#include "../util/string.h"
+#include "../util/header.h"
+#include "bench.h"
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/time.h>
+#include <errno.h>
+
+#define K 1024
+
+static const char *length_str = "1MB";
+static const char *routine    = "default";
+static int use_clock = 0;
+
+static const struct option options[] = {
+	OPT_STRING('l', "length", &length_str, "1MB",
+		    "Specify length of memory to copy. "
+		    "available unit: B, MB, GB (upper and lower)"),
+	OPT_STRING('r', "routine", &routine, "default",
+		    "Specify routine to copy"),
+	OPT_BOOLEAN('c', "clock", &use_clock,
+		    "Use CPU clock for measuring"),
+	OPT_END()
+};
+
+struct routine {
+	const char *name;
+	const char *desc;
+	void * (*fn)(void *dst, const void *src, size_t len);
+};
+
+struct routine routines[] = {
+	{ "default",
+	  "Default memcpy() provided by glibc",
+	  memcpy },
+	{ NULL,
+	  NULL,
+	  NULL   }
+};
+
+static const char * const bench_mem_memcpy_usage[] = {
+	"perf bench mem memcpy <options>",
+	NULL
+};
+
+static int clock_fd;
+
+static struct perf_event_attr clock_attr = {
+	.type = PERF_TYPE_HARDWARE,
+	.config = PERF_COUNT_HW_CPU_CYCLES
+};
+
+static void init_clock(void)
+{
+	clock_fd = sys_perf_event_open(&clock_attr, getpid(), -1, -1, 0);
+	BUG_ON(clock_fd < 0);
+}
+
+static u64 get_clock(void)
+{
+	int ret;
+	u64 clk;
+
+	ret = read(clock_fd, &clk, sizeof(u64));
+	BUG_ON(ret != sizeof(u64));
+
+	return clk;
+}
+
+static double timeval2double(struct timeval *ts)
+{
+	return (double)ts->tv_sec +
+		(double)ts->tv_usec / (double)1000000;
+}
+
+int bench_mem_memcpy(int argc, const char **argv,
+		     const char *prefix __used)
+{
+	int i;
+	void *dst, *src;
+	size_t length;
+	double bps = 0.0;
+	struct timeval tv_start, tv_end, tv_diff;
+	u64 clock_start, clock_end, clock_diff;
+
+	clock_start = clock_end = clock_diff = 0ULL;
+	argc = parse_options(argc, argv, options,
+			     bench_mem_memcpy_usage, 0);
+
+	tv_diff.tv_sec = 0;
+	tv_diff.tv_usec = 0;
+	length = (size_t)perf_atoll((char *)length_str);
+	if ((long long int)length <= 0) {
+		fprintf(stderr, "Invalid length:%s\n", length_str);
+		return 1;
+	}
+
+	for (i = 0; routines[i].name; i++) {
+		if (!strcmp(routines[i].name, routine))
+			break;
+	}
+	if (!routines[i].name) {
+		printf("Unknown routine:%s\n", routine);
+		printf("Available routines...\n");
+		for (i = 0; routines[i].name; i++) {
+			printf("\t%s ... %s\n",
+			       routines[i].name, routines[i].desc);
+		}
+		return 1;
+	}
+
+	dst = calloc(length, sizeof(char));
+	assert(dst);
+	src = calloc(length, sizeof(char));
+	assert(src);
+
+	if (bench_format == BENCH_FORMAT_DEFAULT) {
+		printf("# Copying %s Bytes from %p to %p ...\n\n",
+		       length_str, src, dst);
+	}
+
+	if (use_clock) {
+		init_clock();
+		clock_start = get_clock();
+	} else
+		BUG_ON(gettimeofday(&tv_start, NULL));
+
+	routines[i].fn(dst, src, length);
+
+	if (use_clock) {
+		clock_end = get_clock();
+		clock_diff = clock_end - clock_start;
+	} else {
+		BUG_ON(gettimeofday(&tv_end, NULL));
+		timersub(&tv_end, &tv_start, &tv_diff);
+		bps = (double)((double)length / timeval2double(&tv_diff));
+	}
+
+	switch (bench_format) {
+	case BENCH_FORMAT_DEFAULT:
+		if (use_clock) {
+			printf(" %14lf Clock/Byte\n",
+			       (double)clock_diff / (double)length);
+		} else {
+			if (bps < K)
+				printf(" %14lf B/Sec\n", bps);
+			else if (bps < K * K)
+				printf(" %14lfd KB/Sec\n", bps / 1024);
+			else if (bps < K * K * K)
+				printf(" %14lf MB/Sec\n", bps / 1024 / 1024);
+			else {
+				printf(" %14lf GB/Sec\n",
+				       bps / 1024 / 1024 / 1024);
+			}
+		}
+		break;
+	case BENCH_FORMAT_SIMPLE:
+		if (use_clock) {
+			printf("%14lf\n",
+			       (double)clock_diff / (double)length);
+		} else
+			printf("%lf\n", bps);
+		break;
+	default:
+		/* reaching here is something disaster */
+		fprintf(stderr, "Unknown format:%d\n", bench_format);
+		exit(1);
+		break;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 90c39ba..e043eb8 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -12,6 +12,7 @@
  *
  * Available subsystem list:
  *  sched ... scheduler and IPC mechanism
+ *  mem   ... memory access performance
  *
  */
 
@@ -43,6 +44,15 @@ static struct bench_suite sched_suites[] = {
 	  NULL                  }
 };
 
+static struct bench_suite mem_suites[] = {
+	{ "memcpy",
+	  "Simple memory copy in various ways",
+	  bench_mem_memcpy },
+	{ NULL,
+	  NULL,
+	  NULL             }
+};
+
 struct bench_subsys {
 	const char *name;
 	const char *summary;
@@ -53,9 +63,12 @@ static struct bench_subsys subsystems[] = {
 	{ "sched",
 	  "scheduler and IPC mechanism",
 	  sched_suites },
+	{ "mem",
+	  "memory access performance",
+	  mem_suites },
 	{ NULL,
 	  NULL,
-	  NULL         }
+	  NULL       }
 };
 
 static void dump_suites(int subsys_index)
