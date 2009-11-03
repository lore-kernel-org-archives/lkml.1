Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbZKCEiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbZKCEiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbZKCEiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:38:24 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60275 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbZKCEiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:38:23 -0500
Date: Tue, 03 Nov 2009 13:38:24 +0900 (JST)
Message-Id: <20091103.133824.590139143948085461.mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: [RFC][PATCH 5/7] Adding general performance benchmarking subsystem
 to perf.
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding general performance benchmarking subsystem to perf.
This patch adds builtin-bench.c

builtin-bench.c is general framework for benchmark suites.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/builtin-bench.c |   87 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 87 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/builtin-bench.c

diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
new file mode 100644
index 0000000..85fa927
--- /dev/null
+++ b/tools/perf/builtin-bench.c
@@ -0,0 +1,87 @@
+/*
+ *
+ * builtin-bench.c
+ *
+ * General benchmarking subsystem provided by perf
+ *
+ * Copyright (C) 2009, Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
+ *
+ */
+
+/*
+ *
+ * Available subsystem list:
+ *  sched ... scheduler and IPC mechanism
+ *
+ */
+
+#include "perf.h"
+#include "util/util.h"
+#include "util/parse-options.h"
+#include "builtin.h"
+#include "bench-suite.h"
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+static const char * const bench_sched_usage[] = {
+	"perf bench sched <options>",
+	NULL
+};
+
+struct bench_suite {
+	const char *name;
+	int (*fn)(int, const char **, const char *);
+};
+
+static struct bench_suite sched_suite_array[] = {
+	{ "messaging", bench_sched_messaging },
+	{ "pipe", bench_sched_pipe },
+	{ NULL, NULL }
+};
+
+struct bench_subsys {
+	const char *name;
+	struct bench_suite *suite_array;
+};
+
+static struct bench_subsys subsys_array[] = {
+	{ "sched", sched_suite_array },
+	{ NULL, NULL }
+};
+
+int cmd_bench(int argc, const char **argv, const char *prefix __used)
+{
+	int i, j, status = 0;
+	const char *s;
+	int (*fn)(int, const char **, const char *);
+
+	if (argc < 3) {
+		printf("Usage: perf bench <subsystem> <suite> [<options>]\n");
+		goto end;
+	}
+
+	for (i = 0; subsys_array[i].name; i++) {
+		if (!strcmp(subsys_array[i].name, argv[1])) {
+			for (j = 0;
+			     subsys_array[i].suite_array[j].name;
+			     j++) {
+				s = subsys_array[i].suite_array[j].name;
+				if (!strcmp(s, argv[2])) {
+					fn = subsys_array[i].suite_array[j].fn;
+					status = fn(argc - 2,
+						    argv + 2, prefix);
+					goto end;
+				}
+			}
+		}
+	}
+
+	/* No subsystem matched. */
+	fprintf(stderr, "Unknown pair... subsystem:%s & suite:%s\n", argv[1], argv[2]);
+	status = 1;
+
+end:
+	return status;
+}
-- 
1.5.6.5

