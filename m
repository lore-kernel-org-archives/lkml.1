Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbZKEAd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbZKEAd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZKEAcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:32:36 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50478 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbZKEAbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:31:40 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, fweisbec@gmail.com,
       Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH v5 4/7] builtin-bench.c: General framework for benchmark suites
Date: Thu,  5 Nov 2009 09:31:34 +0900
Message-Id: <1257381097-4743-5-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257381097-4743-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257381097-4743-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257381097-4743-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds builtin-bench.c
builtin-bench.c is a general framework for benchmark suites.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/builtin-bench.c |  128 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 128 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/builtin-bench.c

diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
new file mode 100644
index 0000000..31f4164
--- /dev/null
+++ b/tools/perf/builtin-bench.c
@@ -0,0 +1,128 @@
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
+#include "bench/bench.h"
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+struct bench_suite {
+	const char *name;
+	const char *summary;
+	int (*fn)(int, const char **, const char *);
+};
+
+static struct bench_suite sched_suites[] = {
+	{ "messaging",
+	  "Benchmark for scheduler and IPC mechanisms",
+	  bench_sched_messaging },
+	{ "pipe",
+	  "Flood of communication over pipe() between two processes",
+	  bench_sched_pipe      },
+	{ NULL,
+	  NULL,
+	  NULL                  }
+};
+
+struct bench_subsys {
+	const char *name;
+	const char *summary;
+	struct bench_suite *suites;
+};
+
+static struct bench_subsys subsystems[] = {
+	{ "sched",
+	  "scheduler and IPC mechanism",
+	  sched_suites },
+	{ NULL,
+	  NULL,
+	  NULL         }
+};
+
+static void dump_suites(int subsys_index)
+{
+	int i;
+
+	printf("List of available suites for %s...\n\n",
+	       subsystems[subsys_index].name);
+
+	for (i = 0; subsystems[subsys_index].suites[i].name; i++)
+		printf("\t%s: %s\n",
+		       subsystems[subsys_index].suites[i].name,
+		       subsystems[subsys_index].suites[i].summary);
+
+	printf("\n");
+	return;
+}
+
+int cmd_bench(int argc, const char **argv, const char *prefix __used)
+{
+	int i, j, status = 0;
+
+	if (argc < 2) {
+		/* No subsystem specified. */
+		printf("Usage: perf bench <subsystem> <suite> [<options>]\n\n");
+		printf("List of available subsystems...\n\n");
+
+		for (i = 0; subsystems[i].name; i++)
+			printf("\t%s: %s\n",
+			       subsystems[i].name, subsystems[i].summary);
+		printf("\n");
+
+		goto end;
+	}
+
+	for (i = 0; subsystems[i].name; i++) {
+		if (strcmp(subsystems[i].name, argv[1]))
+			continue;
+
+		if (argc < 3) {
+			/* No suite specified. */
+			dump_suites(i);
+			goto end;
+		}
+
+		for (j = 0; subsystems[i].suites[j].name; j++) {
+			if (strcmp(subsystems[i].suites[j].name, argv[2]))
+				continue;
+
+			status = subsystems[i].suites[j].fn(argc - 2,
+							    argv + 2, prefix);
+			goto end;
+		}
+
+		if (!strcmp(argv[2], "-h") || !strcmp(argv[2], "--help")) {
+			dump_suites(i);
+			goto end;
+		}
+
+		printf("Unknown suite:%s for %s\n", argv[2], argv[1]);
+		status = 1;
+		goto end;
+	}
+
+	printf("Unknown subsystem:%s\n", argv[1]);
+	status = 1;
+
+end:
+	return status;
+}
-- 
1.6.5.2

