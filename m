Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbZKMEXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbZKMEXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 23:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbZKMEXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 23:23:42 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50388 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbZKMEXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 23:23:07 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ling Ma <ling.ma@intel.com>
Subject: [PATCH 1/4] perf bench: Add new subsystem and new suite, bench/mem-memcpy.c
Date: Fri, 13 Nov 2009 13:23:03 +0900
Message-Id: <1258086186-32317-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1258086186-32317-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1258086186-32317-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds bench/mem-memcpy.c.
This file provides new subsystem "mem": evaluating for memory performance,
and new suite "memcpy": measurements performance of memcpy(2) like function.

bench/mem-memcpy.c will be start point for comparing
different algorithms of memcpy() on same CPU
or same memcpy() on different CPUs.

Current supported memcpy() is memcpy() provided by glibc.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ling Ma <ling.ma@intel.com>

| % perf bench mem memcpy -l 1GB -c    # Measure in clock
| # Running mem/memcpy benchmark...
| # Copying 1GB Bytes from 0x7f53f8c25010 to 0x7f5438c26010 ...
|
|        2.156751 Clock/Byte
| % perf bench mem memcpy -l 1GB       # Measure in time(default)
| # Running mem/memcpy benchmark...
| # Copying 1GB Bytes from 0x7f2cffefb010 to 0x7f2d3fefc010 ...
|
|        1.415502 GB/Sec
---
 tools/perf/bench/mem-memcpy.c |  258 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 258 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/bench/mem-memcpy.c

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
new file mode 100644
index 0000000..dd9cbc6
--- /dev/null
+++ b/tools/perf/bench/mem-memcpy.c
@@ -0,1 +1,258 @@
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
+#include "../builtin.h"
+#include "bench.h"
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/time.h>
+#include <assert.h>
+
+#define K 1024
+static char *length_str = (char *)"1MB";
+static char *routine = (char *)"default";
+static int use_clockcycle = 0;
+
+typedef unsigned long int clockcycle_t;
+
+#ifdef x86_64
+
+static inline clockcycle_t get_clock(void)
+{
+	long int ret;
+
+	asm("rdtsc; shlq $32, %%rdx;"
+	    "orq %%rdx, %%rax;"
+	    "movq %%rax, %0;"
+	    : "=r" (ret));
+
+	return ret;
+}
+
+#endif /* x86_64 */
+
+static const struct option options[] = {
+	OPT_STRING('l', "length", &length_str, "1MB",
+		    "Specify length of memory to copy. "
+		    "available unit: B, MB, GB (upper and lower)"),
+	OPT_STRING('r', "routine", &routine, "default",
+		    "Specify routine to copy"),
+#ifdef x86_64
+	/*
+	 * TODO: This should be expanded to any architecuture
+	 * perf supports
+	 */
+	OPT_BOOLEAN('c', "clockcycle", &use_clockcycle,
+		    "Use CPU's clock cycle for measurement"),
+#endif /* x86_64 */
+	OPT_END()
+};
+
+struct routine {
+	const char *name;
+	void * (*fn)(void *dst, const void *src, size_t len);
+	const char *desc;
+};
+
+struct routine routines[] = {
+	{ "default",
+	  memcpy,
+	  "Default memcpy() provided by glibc" },
+	{ NULL,
+	  NULL,
+	  NULL }
+};
+
+static const char * const bench_mem_memcpy_usage[] = {
+	"perf bench mem memcpy <options>",
+	NULL
+};
+
+static size_t str2length(char *_str)
+{
+	int i, unit = 1;
+	char *str;
+	size_t length = -1;
+
+	str = calloc(strlen(_str) + 1, sizeof(char));
+	assert(str);
+	strcpy(str, _str);
+
+	if (!isdigit(str[0]))
+		goto err;
+
+	for (i = 1; i < (int)strlen(str); i++) {
+		switch ((int)str[i]) {
+		case 'B':
+		case 'b':
+			str[i] = '\0';
+			break;
+		case 'K':
+		case 'k':
+			if (str[i + 1] != 'B' && str[i + 1] != 'b')
+				goto err;
+			unit = K;
+			str[i] = '\0';
+			break;
+		case 'M':
+		case 'm':
+			if (str[i + 1] != 'B' && str[i + 1] != 'b')
+				goto err;
+			unit = K * K;
+			str[i] = '\0';
+			break;
+		case 'G':
+		case 'g':
+			if (str[i + 1] != 'B' && str[i + 1] != 'b')
+				goto err;
+			unit = K * K * K;
+			str[i] = '\0';
+			break;
+		case '\0':	/* only specified figures */
+			unit = 1;
+			break;
+		default:
+			if (!isdigit(str[i]))
+				goto err;
+			break;
+		}
+	}
+
+	length = atoi(str) * unit;
+	goto end;
+
+err:
+	fprintf(stderr, "Invalid length:%s\n", str);
+end:
+	free(str);
+	return length;
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
+	struct timeval start, stop, diff;
+	clockcycle_t clock_start = 0, clock_diff = 0;
+	size_t length;
+	double bps = 0.0;
+
+	argc = parse_options(argc, argv, options,
+			     bench_mem_memcpy_usage, 0);
+
+	/*
+	 * Caution!
+	 * Without the statement
+	 * 	gettimeofday(&diff, NULL);
+	 * compiler warns (and build environment of perf regards it as error)
+	 * like this,
+	 * bench/mem-memcpy.c:93: error: ‘diff.tv_sec’ may be\
+	 * used uninitialized in this function
+	 * bench/mem-memcpy.c:93: error: ‘diff.tv_usec’ may be\
+	 * used uninitialized in this function
+	 *
+	 * hmm...
+	 */
+	gettimeofday(&diff, NULL);
+
+	length = str2length(length_str);
+	if ((int)length < 0)
+		return 1;
+
+	for (i = 0; routines[i].name; i++)
+		if (!strcmp(routines[i].name, routine))
+			break;
+	if (!routines[i].name) {
+		printf("Unknown routine:%s\n", routine);
+		printf("Available routines...\n");
+		for (i = 0; routines[i].name; i++)
+			printf("\t%s ... %s\n",
+			       routines[i].name, routines[i].desc);
+		return 1;
+	}
+
+	dst = calloc(length, sizeof(char));
+	assert(dst);
+	src = calloc(length, sizeof(char));
+	assert(src);
+
+	if (bench_format == BENCH_FORMAT_DEFAULT)
+		printf("# Copying %s Bytes from %p to %p ...\n\n",
+		       length_str, src, dst);
+
+	if (use_clockcycle) {
+		clock_start = get_clock();
+	} else {
+		gettimeofday(&start, NULL);
+	}
+
+	routines[i].fn(dst, src, length);
+
+	if (use_clockcycle) {
+		clock_diff = get_clock() - clock_start;
+	} else {
+		gettimeofday(&stop, NULL);
+		timersub(&stop, &start, &diff);
+		bps = (double)((double)length / timeval2double(&diff));
+	}
+
+	switch (bench_format) {
+	case BENCH_FORMAT_DEFAULT:
+		if (use_clockcycle)
+			printf(" %14lf Clock/Byte\n",
+			       (double)clock_diff / (double)length);
+		else
+			if (bps < K)
+				printf(" %14lf B/Sec\n", bps);
+			else if (bps < K * K)
+				printf(" %14lfd KB/Sec\n", bps / 1024);
+			else if (bps < K * K * K)
+				printf(" %14lf MB/Sec\n", bps / 1024 / 1024);
+			else
+				printf(" %14lf GB/Sec\n",
+				       bps / 1024 / 1024 / 1024);
+		break;
+	case BENCH_FORMAT_SIMPLE:
+		if (use_clockcycle)
+			printf("%lf\n",
+			       (double)clock_diff / (double)length);
+		else
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

