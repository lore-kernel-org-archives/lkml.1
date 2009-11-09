Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZKIXUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZKIXUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 18:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbZKIXUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 18:20:44 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:54818 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377AbZKIXUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 18:20:43 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH v2 2/4] perf bench: Modify builtin-bench.c for processing common options
Date: Tue, 10 Nov 2009 08:20:00 +0900
Message-Id: <1257808802-9420-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257808802-9420-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257808802-9420-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies builtin-bench.c for processing common options.
The first option added is "--format".
Users of perf bench will be able to specify output style by --format.

Example of use:
% ./perf bench sched messaging		# with no style specify
(20 sender and receiver processes per group)
(10 groups == 400 processes run)

        Total time:1.431 sec
% ./perf bench --format=simple sched messaging # specified simple
1.431

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/builtin-bench.c |   79 ++++++++++++++++++++++++++++++++++++--------
 1 files changed, 65 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 31f4164..c7505ea 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -74,53 +74,104 @@ static void dump_suites(int subsys_index)
 	return;
 }
 
+static char *bench_format_str;
+int bench_format = BENCH_FORMAT_DEFAULT;
+
+static const struct option bench_options[] = {
+	OPT_STRING('f', "format", &bench_format_str, "default",
+		    "Specify format style"),
+	OPT_END()
+};
+
+static const char * const bench_usage[] = {
+	"perf bench [<common options>] <subsystem> <suite> [<options>]",
+	NULL
+};
+
+static void print_usage(void)
+{
+	int i;
+
+	printf("Usage: \n");
+	for (i = 0; bench_usage[i]; i++)
+		printf("\t%s\n", bench_usage[i]);
+	printf("\n");
+
+	printf("List of available subsystems...\n\n");
+
+	for (i = 0; subsystems[i].name; i++)
+		printf("\t%s: %s\n",
+		       subsystems[i].name, subsystems[i].summary);
+	printf("\n");
+}
+
+static int bench_str2int(char *str)
+{
+	if (!str)
+		return BENCH_FORMAT_DEFAULT;
+
+	if (!strcmp(str, BENCH_FORMAT_DEFAULT_STR))
+		return BENCH_FORMAT_DEFAULT;
+	else if (!strcmp(str, BENCH_FORMAT_SIMPLE_STR))
+		return BENCH_FORMAT_SIMPLE;
+
+	return BENCH_FORMAT_UNKNOWN;
+}
+
 int cmd_bench(int argc, const char **argv, const char *prefix __used)
 {
 	int i, j, status = 0;
 
 	if (argc < 2) {
 		/* No subsystem specified. */
-		printf("Usage: perf bench <subsystem> <suite> [<options>]\n\n");
-		printf("List of available subsystems...\n\n");
+		print_usage();
+		goto end;
+	}
 
-		for (i = 0; subsystems[i].name; i++)
-			printf("\t%s: %s\n",
-			       subsystems[i].name, subsystems[i].summary);
-		printf("\n");
+	argc = parse_options(argc, argv, bench_options, bench_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+
+	bench_format = bench_str2int(bench_format_str);
+	if (bench_format == BENCH_FORMAT_UNKNOWN) {
+		printf("Unknown format descriptor:%s\n", bench_format_str);
+		goto end;
+	}
 
+	if (argc < 1) {
+		print_usage();
 		goto end;
 	}
 
 	for (i = 0; subsystems[i].name; i++) {
-		if (strcmp(subsystems[i].name, argv[1]))
+		if (strcmp(subsystems[i].name, argv[0]))
 			continue;
 
-		if (argc < 3) {
+		if (argc < 2) {
 			/* No suite specified. */
 			dump_suites(i);
 			goto end;
 		}
 
 		for (j = 0; subsystems[i].suites[j].name; j++) {
-			if (strcmp(subsystems[i].suites[j].name, argv[2]))
+			if (strcmp(subsystems[i].suites[j].name, argv[1]))
 				continue;
 
-			status = subsystems[i].suites[j].fn(argc - 2,
-							    argv + 2, prefix);
+			status = subsystems[i].suites[j].fn(argc - 1,
+							    argv + 1, prefix);
 			goto end;
 		}
 
-		if (!strcmp(argv[2], "-h") || !strcmp(argv[2], "--help")) {
+		if (!strcmp(argv[1], "-h") || !strcmp(argv[1], "--help")) {
 			dump_suites(i);
 			goto end;
 		}
 
-		printf("Unknown suite:%s for %s\n", argv[2], argv[1]);
+		printf("Unknown suite:%s for %s\n", argv[1], argv[0]);
 		status = 1;
 		goto end;
 	}
 
-	printf("Unknown subsystem:%s\n", argv[1]);
+	printf("Unknown subsystem:%s\n", argv[0]);
 	status = 1;
 
 end:
-- 
1.5.6.5

