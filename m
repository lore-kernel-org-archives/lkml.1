Return-Path: <linux-kernel-owner+w=401wt.eu-S1751398AbZKSFhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbZKSFhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 00:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbZKSFhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 00:37:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:47407 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbZKSFhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 00:37:19 -0500
Date: Thu, 19 Nov 2009 05:36:38 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258471212-30281-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1258471212-30281-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Add memcpy() benchmark
Message-ID: <tip-827f3b4974c5db2968d4979fe6a0ae00ab37bdd8@git.kernel.org>
Git-Commit-ID: 827f3b4974c5db2968d4979fe6a0ae00ab37bdd8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  827f3b4974c5db2968d4979fe6a0ae00ab37bdd8
Gitweb:     http://git.kernel.org/tip/827f3b4974c5db2968d4979fe6a0ae00ab37bdd8
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Wed, 18 Nov 2009 00:20:09 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 19 Nov 2009 06:21:48 +0100

perf bench: Add memcpy() benchmark

'perf bench mem memcpy' is a benchmark suite for measuring memcpy()
performance.

Example on a Intel(R) Core(TM)2 Duo CPU E6850 @ 3.00GHz:

| % perf bench mem memcpy -l 1GB
| # Running mem/memcpy benchmark...
| # Copying 1MB Bytes from 0xb7d98008 to 0xb7e99008 ...
|
|     726.216412 MB/Sec

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1258471212-30281-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
[ v2: updated changelog, clarified history of builtin-bench.c ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile           |    1 +
 tools/perf/bench/bench.h      |    1 +
 tools/perf/bench/mem-memcpy.c |  186 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin-bench.c    |   15 +++-
 4 files changed, 202 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3f0666a..53e663a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -432,6 +432,7 @@ BUILTIN_OBJS += builtin-bench.o
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
index 0000000..d4f4f98
--- /dev/null
+++ b/tools/perf/bench/mem-memcpy.c
@@ -0,0 +1,186 @@
+/*
+ * mem-memcpy.c
+ *
+ * memcpy: Simple memory copy in various ways
+ *
+ * Written by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
+ */
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
