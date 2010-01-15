Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab0AOLMU (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 06:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847Ab0AOLMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 06:12:19 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:59581 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753294Ab0AOLMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 06:12:17 -0500
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
To: linux-kernel@vger.kernel.org
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH] perf bench: Add memset and memmove benchmarks
Date: Fri, 15 Jan 2010 12:11:57 +0100
Message-Id: <1263553917-5395-1-git-send-email-peppe.cavallaro@st.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves the memory bench suite adding the memset and
memmove benchmarks.
The mem-memory.c file has been renamed as mem.c.
mem.c file contains all the memory routines to be benchmarked
(currently memcpy, memset and memmove).

Two new options have been added:
o iteration: that is the numbers of loop executed during the bench.
o unaligned: to work with unaligned pointers (not fully tested).

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 tools/perf/Makefile           |    2 +-
 tools/perf/bench/bench.h      |    4 +
 tools/perf/bench/mem-memcpy.c |  193 ------------------------
 tools/perf/bench/mem.c        |  324 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin-bench.c    |    6 +
 5 files changed, 335 insertions(+), 194 deletions(-)
 delete mode 100644 tools/perf/bench/mem-memcpy.c
 create mode 100644 tools/perf/bench/mem.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 652a470..b566467 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -433,7 +433,7 @@ BUILTIN_OBJS += builtin-bench.o
 # Benchmark modules
 BUILTIN_OBJS += bench/sched-messaging.o
 BUILTIN_OBJS += bench/sched-pipe.o
-BUILTIN_OBJS += bench/mem-memcpy.o
+BUILTIN_OBJS += bench/mem.o
 
 BUILTIN_OBJS += builtin-diff.o
 BUILTIN_OBJS += builtin-help.o
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index f7781c6..7111d97 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -4,6 +4,10 @@
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
 extern int bench_mem_memcpy(int argc, const char **argv, const char *prefix __used);
+extern int bench_mem_memmove(int argc, const char **argv,
+			     const char *prefix __used);
+extern int bench_mem_memset(int argc, const char **argv,
+			    const char *prefix __used);
 
 #define BENCH_FORMAT_DEFAULT_STR	"default"
 #define BENCH_FORMAT_DEFAULT		0
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
deleted file mode 100644
index 8977317..0000000
--- a/tools/perf/bench/mem-memcpy.c
+++ /dev/null
@@ -1,193 +0,0 @@
-/*
- * mem-memcpy.c
- *
- * memcpy: Simple memory copy in various ways
- *
- * Written by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
- */
-#include <ctype.h>
-
-#include "../perf.h"
-#include "../util/util.h"
-#include "../util/parse-options.h"
-#include "../util/string.h"
-#include "../util/header.h"
-#include "bench.h"
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <sys/time.h>
-#include <errno.h>
-
-#define K 1024
-
-static const char	*length_str	= "1MB";
-static const char	*routine	= "default";
-static int		use_clock	= 0;
-static int		clock_fd;
-
-static const struct option options[] = {
-	OPT_STRING('l', "length", &length_str, "1MB",
-		    "Specify length of memory to copy. "
-		    "available unit: B, MB, GB (upper and lower)"),
-	OPT_STRING('r', "routine", &routine, "default",
-		    "Specify routine to copy"),
-	OPT_BOOLEAN('c', "clock", &use_clock,
-		    "Use CPU clock for measuring"),
-	OPT_END()
-};
-
-struct routine {
-	const char *name;
-	const char *desc;
-	void * (*fn)(void *dst, const void *src, size_t len);
-};
-
-struct routine routines[] = {
-	{ "default",
-	  "Default memcpy() provided by glibc",
-	  memcpy },
-	{ NULL,
-	  NULL,
-	  NULL   }
-};
-
-static const char * const bench_mem_memcpy_usage[] = {
-	"perf bench mem memcpy <options>",
-	NULL
-};
-
-static struct perf_event_attr clock_attr = {
-	.type		= PERF_TYPE_HARDWARE,
-	.config		= PERF_COUNT_HW_CPU_CYCLES
-};
-
-static void init_clock(void)
-{
-	clock_fd = sys_perf_event_open(&clock_attr, getpid(), -1, -1, 0);
-
-	if (clock_fd < 0 && errno == ENOSYS)
-		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
-	else
-		BUG_ON(clock_fd < 0);
-}
-
-static u64 get_clock(void)
-{
-	int ret;
-	u64 clk;
-
-	ret = read(clock_fd, &clk, sizeof(u64));
-	BUG_ON(ret != sizeof(u64));
-
-	return clk;
-}
-
-static double timeval2double(struct timeval *ts)
-{
-	return (double)ts->tv_sec +
-		(double)ts->tv_usec / (double)1000000;
-}
-
-int bench_mem_memcpy(int argc, const char **argv,
-		     const char *prefix __used)
-{
-	int i;
-	void *dst, *src;
-	size_t length;
-	double bps = 0.0;
-	struct timeval tv_start, tv_end, tv_diff;
-	u64 clock_start, clock_end, clock_diff;
-
-	clock_start = clock_end = clock_diff = 0ULL;
-	argc = parse_options(argc, argv, options,
-			     bench_mem_memcpy_usage, 0);
-
-	tv_diff.tv_sec = 0;
-	tv_diff.tv_usec = 0;
-	length = (size_t)perf_atoll((char *)length_str);
-
-	if ((s64)length <= 0) {
-		fprintf(stderr, "Invalid length:%s\n", length_str);
-		return 1;
-	}
-
-	for (i = 0; routines[i].name; i++) {
-		if (!strcmp(routines[i].name, routine))
-			break;
-	}
-	if (!routines[i].name) {
-		printf("Unknown routine:%s\n", routine);
-		printf("Available routines...\n");
-		for (i = 0; routines[i].name; i++) {
-			printf("\t%s ... %s\n",
-			       routines[i].name, routines[i].desc);
-		}
-		return 1;
-	}
-
-	dst = zalloc(length);
-	if (!dst)
-		die("memory allocation failed - maybe length is too large?\n");
-
-	src = zalloc(length);
-	if (!src)
-		die("memory allocation failed - maybe length is too large?\n");
-
-	if (bench_format == BENCH_FORMAT_DEFAULT) {
-		printf("# Copying %s Bytes from %p to %p ...\n\n",
-		       length_str, src, dst);
-	}
-
-	if (use_clock) {
-		init_clock();
-		clock_start = get_clock();
-	} else {
-		BUG_ON(gettimeofday(&tv_start, NULL));
-	}
-
-	routines[i].fn(dst, src, length);
-
-	if (use_clock) {
-		clock_end = get_clock();
-		clock_diff = clock_end - clock_start;
-	} else {
-		BUG_ON(gettimeofday(&tv_end, NULL));
-		timersub(&tv_end, &tv_start, &tv_diff);
-		bps = (double)((double)length / timeval2double(&tv_diff));
-	}
-
-	switch (bench_format) {
-	case BENCH_FORMAT_DEFAULT:
-		if (use_clock) {
-			printf(" %14lf Clock/Byte\n",
-			       (double)clock_diff / (double)length);
-		} else {
-			if (bps < K)
-				printf(" %14lf B/Sec\n", bps);
-			else if (bps < K * K)
-				printf(" %14lfd KB/Sec\n", bps / 1024);
-			else if (bps < K * K * K)
-				printf(" %14lf MB/Sec\n", bps / 1024 / 1024);
-			else {
-				printf(" %14lf GB/Sec\n",
-				       bps / 1024 / 1024 / 1024);
-			}
-		}
-		break;
-	case BENCH_FORMAT_SIMPLE:
-		if (use_clock) {
-			printf("%14lf\n",
-			       (double)clock_diff / (double)length);
-		} else
-			printf("%lf\n", bps);
-		break;
-	default:
-		/* reaching this means there's some disaster: */
-		die("unknown format: %d\n", bench_format);
-		break;
-	}
-
-	return 0;
-}
diff --git a/tools/perf/bench/mem.c b/tools/perf/bench/mem.c
new file mode 100644
index 0000000..f667806
--- /dev/null
+++ b/tools/perf/bench/mem.c
@@ -0,0 +1,324 @@
+/*
+ * mem.c
+ *
+ * mem: test memory routine (memcpy, memset, memmove)
+ *
+ * Based on mem-memcpy.c by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
+ *
+ * Ported to perf by Giuseppe Cavallaro <peppe.cavallaro@st.com>
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
+static const char	*length_str	= "1MB";
+static const char	*routine	= "default";
+static int		use_clock;
+static int		unaligned;
+static int		clock_fd;
+static int		iterations = 200;
+
+static const struct option options[] = {
+	OPT_BOOLEAN('a', "unaligned", &unaligned,
+		    "To have unaligned pointers)"),
+	OPT_BOOLEAN('c', "clock", &use_clock,
+		    "Use CPU clock for measuring"),
+	OPT_INTEGER('i', "iterations", &iterations,
+		    "Number of loops (default: 200)"),
+	OPT_STRING('l', "length", &length_str, "1MB",
+		    "Specify length of memory to copy. "
+		    "available unit: B, MB, GB (upper and lower)"),
+	OPT_STRING('r', "routine", &routine, "default",
+		    "Specify routine to test"),
+	OPT_END()
+};
+
+struct routine {
+	const char *name;
+	const char *desc;
+	void * (*cpy)(void *dst, const void *src, size_t len);
+	void * (*set)(void *s, int c, size_t len);
+};
+
+static struct routine routines[] = {
+	{ "memcpy",
+	  "Default memcpy() provided by C library",
+	  memcpy,
+	  NULL},
+	{ "memmove",
+	  "Default memmove() provided by C library",
+	  memmove,
+	  NULL },
+	{ "memset",
+	  "Default memset() provided by C library",
+	  NULL,
+	  memset }
+};
+
+static const char * const bench_mem_usage[] = {
+	"perf bench mem <routine> <options>",
+	NULL
+};
+
+static struct perf_event_attr clock_attr = {
+	.type		= PERF_TYPE_HARDWARE,
+	.config		= PERF_COUNT_HW_CPU_CYCLES
+};
+
+static void init_clock(void)
+{
+	clock_fd = sys_perf_event_open(&clock_attr, getpid(), -1, -1, 0);
+
+	if (clock_fd < 0 && errno == ENOSYS)
+		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
+	else
+		BUG_ON(clock_fd < 0);
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
+
+static int check_sizes(void)
+{
+	int length = (int)perf_atoll((char *)length_str);
+
+	if ((s64)length <= 0) {
+		fprintf(stderr, "Invalid length:%s\n", length_str);
+		return -1;
+	}
+	if (iterations <= 0) {
+		fprintf(stderr, "Invalid iterations: %d\n", iterations);
+		return -1;
+	}
+	return length;
+}
+
+static int check_routines(const char *prefix)
+{
+	int i;
+
+	for (i = 0; routines[i].name; i++) {
+		if (!strcmp(routines[i].name, prefix))
+			break;
+	}
+
+	if (!routines[i].name) {
+		printf("Unknown routine:%s\n", prefix);
+		printf("Available routines...\n");
+		for (i = 0; routines[i].name; i++) {
+			printf("\t%s ... %s\n",
+			       routines[i].name, routines[i].desc);
+		}
+		return -1;
+	}
+	return i;
+}
+
+
+static void print_result(double bps, u64 clock_diff, size_t length)
+{
+	switch (bench_format) {
+	case BENCH_FORMAT_DEFAULT:
+		if (use_clock) {
+			printf(" %14lf Clock/Byte\n",
+			       (double)clock_diff / (double)length);
+		} else {
+			if (bps < K)
+				printf(" %14lf B/Sec\n", bps);
+			else if (bps < K * K)
+				printf(" %14lfd KB/Sec\n", bps / K);
+			else if (bps < K * K * K)
+				printf(" %14lf MB/Sec\n", bps / K / K);
+			else {
+				printf(" %14lf GB/Sec\n",
+				       bps / K / K / K);
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
+		/* reaching this means there's some disaster: */
+		die("unknown format: %d\n", bench_format);
+		break;
+	}
+	return;
+}
+
+static int bench_mem(int argc, const char **argv, const char *prefix __used)
+{
+	int i, n;
+	int length;
+	unsigned long bytes;
+	void *dst, *src;
+	double bps = 0.0;
+	struct timeval tv_start, tv_end, tv_diff;
+	u64 clock_start, clock_end, clock_diff;
+
+	clock_start = clock_end = clock_diff = 0ULL;
+	argc = parse_options(argc, argv, options,
+			     bench_mem_usage, 0);
+
+	tv_diff.tv_sec = 0;
+	tv_diff.tv_usec = 0;
+
+	length = check_sizes();
+	if (length < 0)
+		return 1;
+
+	i = check_routines(prefix);
+	if (i < 0)
+		return 1;
+
+	dst = zalloc(length);
+	if (!dst)
+		die("memory allocation failed - maybe length is too large?\n");
+
+	src = zalloc(length);
+	if (!src)
+		die("memory allocation failed - maybe length is too large?\n");
+
+	if (unaligned) {
+		src = src + 1;
+		dst = dst + 1;
+		length--;
+	}
+
+	if (bench_format == BENCH_FORMAT_DEFAULT) {
+		printf("# Copying %s Bytes from %p to %p ... (loop %d)\n\n",
+		       length_str, src, dst, iterations);
+	}
+
+	if (use_clock) {
+		init_clock();
+		clock_start = get_clock();
+	} else
+		BUG_ON(gettimeofday(&tv_start, NULL));
+
+	for (n = 0; n < iterations; n++)
+		routines[i].cpy(dst, src, (size_t)length);
+
+	if (use_clock) {
+		clock_end = get_clock();
+		clock_diff = clock_end - clock_start;
+	} else {
+		BUG_ON(gettimeofday(&tv_end, NULL));
+		timersub(&tv_end, &tv_start, &tv_diff);
+		bytes = length * iterations;
+		bps = (double)(bytes / timeval2double(&tv_diff));
+	}
+
+	print_result(bps, clock_diff, (size_t)length);
+
+	return 0;
+}
+
+int bench_mem_memcpy(int argc, const char **argv, const char *prefix __used)
+{
+	return bench_mem(argc, argv, "memcpy");
+}
+
+int bench_mem_memmove(int argc, const char **argv, const char *prefix __used)
+{
+	return bench_mem(argc, argv, "memmove");
+}
+
+int bench_mem_memset(int argc, const char **argv, const char *prefix __used)
+{
+	int i, n;
+	int length;
+	unsigned long bytes;
+	void *s;
+	double bps = 0.0;
+	struct timeval tv_start, tv_end, tv_diff;
+	u64 clock_start, clock_end, clock_diff;
+
+	clock_start = 0ULL;
+	clock_end = 0ULL;
+	clock_diff = 0ULL;
+	argc = parse_options(argc, argv, options,
+			     bench_mem_usage, 0);
+
+	tv_diff.tv_sec = 0;
+	tv_diff.tv_usec = 0;
+
+	length = check_sizes();
+	if (length < 0)
+		return 1;
+
+	i = check_routines("memset");
+	if (i < 0)
+		return 1;
+
+	s = zalloc(length);
+	if (!s)
+		die("memory allocation failed - maybe length is too large?\n");
+
+	if (unaligned) {
+		s = s + 1;
+		length--;
+	}
+
+	if (bench_format == BENCH_FORMAT_DEFAULT) {
+		printf("# Fill %s Bytes (to 0) to %p ... (loop %d)\n\n",
+		       length_str, s, iterations);
+	}
+
+	if (use_clock) {
+		init_clock();
+		clock_start = get_clock();
+	} else
+		BUG_ON(gettimeofday(&tv_start, NULL));
+
+	for (n = 0; n < iterations; n++)
+		routines[i].set(s, 0, (size_t)length);
+
+	if (use_clock) {
+		clock_end = get_clock();
+		clock_diff = clock_end - clock_start;
+	} else {
+		BUG_ON(gettimeofday(&tv_end, NULL));
+		timersub(&tv_end, &tv_start, &tv_diff);
+		bytes = length * iterations;
+		bps = (double)(bytes / timeval2double(&tv_diff));
+	}
+
+	print_result(bps, clock_diff, (size_t)length);
+
+	return 0;
+}
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 4699677..beb0984 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -52,6 +52,12 @@ static struct bench_suite mem_suites[] = {
 	{ "memcpy",
 	  "Simple memory copy in various ways",
 	  bench_mem_memcpy },
+	{ "memmove",
+	  "Simple memory move in various ways",
+	  bench_mem_memmove },
+	{ "memset",
+	  NULL,
+	  bench_mem_memset },
 	suite_all,
 	{ NULL,
 	  NULL,
-- 
1.6.0.4

