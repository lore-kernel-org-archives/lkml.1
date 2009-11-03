Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbZKCKzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbZKCKzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZKCKzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:55:36 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:63521 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbZKCKzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:55:36 -0500
Date: Tue, 03 Nov 2009 19:55:35 +0900 (JST)
Message-Id: <20091103.195535.789626513029853730.mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: [PATCH v2 3/7] Adding general performance benchmarking subcommand
 to perf.
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding general performance benchmarking subcommand to perf.
This patch adds bench/sched-pipe.c.

bench/sched-pipe.c is a benchmark program
to measure performance of pipe() system call.
This benchmark is based on pipe-test-1m.c by Ingo Molnar.
http://people.redhat.com/mingo/cfs-scheduler/tools/pipe-test-1m.c

Example of use:
% perf bench sched pipe               # Use default options
4.575  	     	   		      # Result is time
% perf bench sched pipe -l 2000	      # This option means "loop 2000 counts"
0.024

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/bench/sched-pipe.c |   89 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 89 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/bench/sched-pipe.c

diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
new file mode 100644
index 0000000..3f22f54
--- /dev/null
+++ b/tools/perf/bench/sched-pipe.c
@@ -0,0 +1,89 @@
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
+#include "/bench.h"
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
+
+static const struct option options[] = {
+	OPT_INTEGER('l', "loop", &loops,
+		    "Specify number of loops"),
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
+	if (!pid)
+		printf("%lu.%03lu\n",
+		       diff.tv_sec, diff.tv_usec/1000);
+
+	return 0;
+}
-- 
1.5.6.5

