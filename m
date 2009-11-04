Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbZKDNHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbZKDNHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbZKDNH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:07:28 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61167 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbZKDNHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:07:18 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: [PATCH v3 3/7] Adding general performance benchmarking subcommand to perf.
Date: Wed,  4 Nov 2009 22:06:23 +0900
Message-Id: <1257339987-22953-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257339987-22953-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257339987-22953-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257339987-22953-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257339987-22953-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is version 3. But still (and always) comments are welcome.

This patch adds bench/sched-pipe.c.

bench/sched-pipe.c is a benchmark program
to measure performance of pipe() system call.
This benchmark is based on pipe-test-1m.c by Ingo Molnar.
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
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>

---
 tools/perf/bench/sched-pipe.c |  113 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 113 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/bench/sched-pipe.c

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
-- 
1.5.6.5

