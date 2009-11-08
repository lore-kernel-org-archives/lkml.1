Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZKHJ0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZKHJ0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 04:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZKHJ02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 04:26:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:60103 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbZKHJ01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 04:26:27 -0500
Date: Sun, 8 Nov 2009 09:25:38 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
       efault@gmx.de, mitake@dcl.info.waseda.ac.jp, jkosina@suse.cz,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       a.p.zijlstra@chello.nl, efault@gmx.de, mitake@dcl.info.waseda.ac.jp,
       jkosina@suse.cz, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257381097-4743-5-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257381097-4743-5-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Add builtin-bench.c: General framework for benchmark suites
Message-ID: <tip-629cc356653719c206a05f4dee5c5e242edb6546@git.kernel.org>
Git-Commit-ID: 629cc356653719c206a05f4dee5c5e242edb6546
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  629cc356653719c206a05f4dee5c5e242edb6546
Gitweb:     http://git.kernel.org/tip/629cc356653719c206a05f4dee5c5e242edb6546
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Thu, 5 Nov 2009 09:31:34 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 10:19:18 +0100

perf bench: Add builtin-bench.c: General framework for benchmark suites

This patch adds builtin-bench.c
builtin-bench.c is a general framework for benchmark suites.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: fweisbec@gmail.com
Cc: Jiri Kosina <jkosina@suse.cz>
LKML-Reference: <1257381097-4743-5-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-bench.c |  128 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 128 insertions(+), 0 deletions(-)

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
