Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbZKHJ0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbZKHJ0I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 04:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbZKHJ0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 04:26:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:34963 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbZKHJ0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 04:26:04 -0500
Date: Sun, 8 Nov 2009 09:25:21 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
       efault@gmx.de, mitake@dcl.info.waseda.ac.jp, jkosina@suse.cz,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       a.p.zijlstra@chello.nl, efault@gmx.de, mitake@dcl.info.waseda.ac.jp,
       jkosina@suse.cz, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257381097-4743-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257381097-4743-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Add sched-pipe.c: Benchmark for pipe() system call
Message-ID: <tip-c7d9300f367f480aee4663a0e3695c5b48859a1a@git.kernel.org>
Git-Commit-ID: c7d9300f367f480aee4663a0e3695c5b48859a1a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7d9300f367f480aee4663a0e3695c5b48859a1a
Gitweb:     http://git.kernel.org/tip/c7d9300f367f480aee4663a0e3695c5b48859a1a
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Thu, 5 Nov 2009 09:31:33 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 10:19:18 +0100

perf bench: Add sched-pipe.c: Benchmark for pipe() system call

This patch adds bench/sched-pipe.c.

bench/sched-pipe.c is a benchmark program
to measure performance of pipe() system call.
This benchmark is based on pipe-test-1m.c by Ingo Molnar:

   http://people.redhat.com/mingo/cfs-scheduler/tools/pipe-test-1m.c

Example of use:

% perf bench sched pipe
  (executing 1000000 pipe operations between two tasks)

          Total time:4.499 sec
                  4.499179 usecs/op
                  222262 ops/sec

% perf bench sched pipe -s -l 1000
0.015

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: fweisbec@gmail.com
Cc: Jiri Kosina <jkosina@suse.cz>
LKML-Reference: <1257381097-4743-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/bench/sched-pipe.c |  113 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 113 insertions(+), 0 deletions(-)

diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
new file mode 100644
index 0000000..3214ed2
--- /dev/null
+++ b/tools/perf/bench/sched-pipe.c
@@ -0,0 +1,113 @@
+/*
+ *
+ * builtin-bench-pipe.c
+ *
+ * pipe: Benchmark for pipe()
+ *
+ * Based on pipe-test-1m.c by Ingo Molnar <mingo@redhat.com>
+ *  http://people.redhat.com/mingo/cfs-scheduler/tools/pipe-test-1m.c
+ * Ported to perf by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
+ *
+ */
+
+#include "../perf.h"
+#include "../util/util.h"
+#include "../util/parse-options.h"
+#include "../builtin.h"
+#include "bench.h"
+
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <sys/wait.h>
+#include <linux/unistd.h>
+#include <string.h>
+#include <errno.h>
+#include <assert.h>
+#include <sys/time.h>
+
+#define LOOPS_DEFAULT 1000000
+static int loops = LOOPS_DEFAULT;
+static int simple = 0;
+
+static const struct option options[] = {
+	OPT_INTEGER('l', "loop", &loops,
+		    "Specify number of loops"),
+	OPT_BOOLEAN('s', "simple-output", &simple,
+		    "Do simple output (this maybe useful for"
+		    "processing by scripts or graph tools like gnuplot)"),
+	OPT_END()
+};
+
+static const char * const bench_sched_pipe_usage[] = {
+	"perf bench sched pipe <options>",
+	NULL
+};
+
+int bench_sched_pipe(int argc, const char **argv,
+		     const char *prefix __used)
+{
+	int pipe_1[2], pipe_2[2];
+	int m = 0, i;
+	struct timeval start, stop, diff;
+	unsigned long long result_usec = 0;
+
+	/*
+	 * why does "ret" exist?
+	 * discarding returned value of read(), write()
+	 * causes error in building environment for perf
+	 */
+	int ret;
+	pid_t pid;
+
+	argc = parse_options(argc, argv, options,
+			     bench_sched_pipe_usage, 0);
+
+	assert(!pipe(pipe_1));
+	assert(!pipe(pipe_2));
+
+	pid = fork();
+	assert(pid >= 0);
+
+	gettimeofday(&start, NULL);
+
+	if (!pid) {
+		for (i = 0; i < loops; i++) {
+			ret = read(pipe_1[0], &m, sizeof(int));
+			ret = write(pipe_2[1], &m, sizeof(int));
+		}
+	} else {
+		for (i = 0; i < loops; i++) {
+			ret = write(pipe_1[1], &m, sizeof(int));
+			ret = read(pipe_2[0], &m, sizeof(int));
+		}
+	}
+
+	gettimeofday(&stop, NULL);
+	timersub(&stop, &start, &diff);
+
+	if (pid)
+		return 0;
+
+	if (simple)
+		printf("%lu.%03lu\n",
+		       diff.tv_sec, diff.tv_usec / 1000);
+	else {
+		printf("(executing %d pipe operations between two tasks)\n\n",
+			loops);
+
+		result_usec = diff.tv_sec * 1000000;
+		result_usec += diff.tv_usec;
+
+		printf("\tTotal time:%lu.%03lu sec\n",
+		       diff.tv_sec, diff.tv_usec / 1000);
+		printf("\t\t%lf usecs/op\n",
+		       (double)result_usec / (double)loops);
+		printf("\t\t%d ops/sec\n",
+		       (int)((double)loops /
+			     ((double)result_usec / (double)1000000)));
+	}
+
+	return 0;
+}
