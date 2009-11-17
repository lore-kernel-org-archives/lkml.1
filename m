Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbZKQLmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbZKQLmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbZKQLml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:42:41 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:55063 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbZKQLmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:42:37 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ling Ma <ling.ma@intel.com>
Subject: [PATCH 1/4] perf bench: Add mem-memcpy.c:memcpy() benchmark
Date: Tue, 17 Nov 2009 20:42:30 +0900
Message-Id: <1258458153-25700-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091117112148.GA32578@elte.hu>
References: <20091117112148.GA32578@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new file mem-memcpy.c.
mem-memcpy.c is benchmark suite for measuring memcpy() performance.

This patch is version 2.
mem-memcpy.c of this version uses perf event systemcall to
obtain clock cycle.

Example of use:

| % perf bench mem memcpy -l 1GB
| # Running mem/memcpy benchmark...
| # Copying 1GB Bytes from 0x7f0bf417d010 to 0x7f0c3417e010 ...
|
|      830.937491 MB/Sec
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
---
 tools/perf/bench/mem-memcpy.c |  196 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 196 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/bench/mem-memcpy.c

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
new file mode 100644
index 0000000..21a0f00
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
+		fprintf(stderr, "Invalid length:%s, %lu\n", length_str, length);
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
-- 
1.6.5.2

