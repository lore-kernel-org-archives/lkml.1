Return-Path: <linux-kernel-owner+w=401wt.eu-S1752363AbZIOJfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbZIOJfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbZIOJfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:35:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:57292 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbZIOJe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:34:56 -0400
Date: Tue, 15 Sep 2009 09:34:21 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf sched: Add 'perf sched latency' and 'perf sched replay'
Message-ID: <tip-f2858d8ad9858e63c87257553c5721cba5db95ae@git.kernel.org>
Git-Commit-ID: f2858d8ad9858e63c87257553c5721cba5db95ae
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:34:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f2858d8ad9858e63c87257553c5721cba5db95ae
Gitweb:     http://git.kernel.org/tip/f2858d8ad9858e63c87257553c5721cba5db95ae
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 11 Sep 2009 12:12:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Sep 2009 10:22:49 +0200

perf sched: Add 'perf sched latency' and 'perf sched replay'

Separate the option parsing cleanly and add two variants:

 - 'perf sched latency' (can be abbreviated via 'perf sched lat')
 - 'perf sched replay'  (can be abbreviated via 'perf sched rep')

Also add a repeat count option to replay and add a separation
set of options for replay.

Do the sorting setup only in the latency sub-command.

Display separate help screens for 'perf sched' and
'perf sched replay -h' - i.e. further separation of the
sub-commands.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c |   90 ++++++++++++++++++++++++++++---------------
 1 files changed, 58 insertions(+), 32 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 10fcd49..e01cc63 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -30,9 +30,6 @@ static struct thread		*last_match;
 static struct perf_header	*header;
 static u64			sample_type;
 
-static int			replay_mode;
-static int			lat_mode;
-
 static char			default_sort_order[] = "avg, max, switch, runtime";
 static char			*sort_order = default_sort_order;
 
@@ -623,9 +620,11 @@ static void test_calibrations(void)
 	printf("the sleep test took %Ld nsecs\n", T1-T0);
 }
 
+static unsigned long replay_repeat = 10;
+
 static void __cmd_replay(void)
 {
-	long nr_iterations = 10, i;
+	unsigned long i;
 
 	calibrate_run_measurement_overhead();
 	calibrate_sleep_measurement_overhead();
@@ -651,7 +650,7 @@ static void __cmd_replay(void)
 
 	create_tasks();
 	printf("------------------------------------------------------------\n");
-	for (i = 0; i < nr_iterations; i++)
+	for (i = 0; i < replay_repeat; i++)
 		run_one_test();
 }
 
@@ -1623,21 +1622,45 @@ more:
 }
 
 static const char * const sched_usage[] = {
-	"perf sched [<options>] <command>",
+	"perf sched [<options>] {record|latency|replay}",
 	NULL
 };
 
-static const struct option options[] = {
+static const struct option sched_options[] = {
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
-	OPT_BOOLEAN('r', "replay", &replay_mode,
-		    "replay sched behaviour from traces"),
-	OPT_BOOLEAN('l', "latency", &lat_mode,
-		    "measure various latencies"),
+	OPT_END()
+};
+
+static const char * const latency_usage[] = {
+	"perf sched latency [<options>]",
+	NULL
+};
+
+static const struct option latency_options[] = {
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): runtime, switch, avg, max"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_END()
+};
+
+static const char * const replay_usage[] = {
+	"perf sched replay [<options>]",
+	NULL
+};
+
+static const struct option replay_options[] = {
+	OPT_INTEGER('r', "repeat", &replay_repeat,
+		    "repeat the workload replay N times (-1: infinite)"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
 	OPT_END()
 };
 
@@ -1649,7 +1672,7 @@ static void setup_sorting(void)
 			tok; tok = strtok_r(NULL, ", ", &tmp)) {
 		if (sort_dimension__add(tok, &sort_list) < 0) {
 			error("Unknown --sort key: `%s'", tok);
-			usage_with_options(sched_usage, options);
+			usage_with_options(latency_usage, latency_options);
 		}
 	}
 
@@ -1663,29 +1686,32 @@ int cmd_sched(int argc, const char **argv, const char *prefix __used)
 	symbol__init();
 	page_size = getpagesize();
 
-	argc = parse_options(argc, argv, options, sched_usage, 0);
-	if (argc) {
-		/*
-		 * Special case: if there's an argument left then assume tha
-		 * it's a symbol filter:
-		 */
-		if (argc > 1)
-			usage_with_options(sched_usage, options);
-	}
+	argc = parse_options(argc, argv, sched_options, sched_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (!argc)
+		usage_with_options(sched_usage, sched_options);
 
-	if (replay_mode)
-		trace_handler = &replay_ops;
-	else if (lat_mode)
+	if (!strncmp(argv[0], "lat", 3)) {
 		trace_handler = &lat_ops;
-	else
-		usage_with_options(sched_usage, options);
-
-	setup_sorting();
-
-	if (replay_mode)
-		__cmd_replay();
-	else if (lat_mode)
+		if (argc > 1) {
+			argc = parse_options(argc, argv, latency_options, latency_usage, 0);
+			if (argc)
+				usage_with_options(latency_usage, latency_options);
+			setup_sorting();
+		}
 		__cmd_lat();
+	} else if (!strncmp(argv[0], "rep", 3)) {
+		trace_handler = &replay_ops;
+		if (argc) {
+			argc = parse_options(argc, argv, replay_options, replay_usage, 0);
+			if (argc)
+				usage_with_options(replay_usage, replay_options);
+		}
+		__cmd_replay();
+	} else {
+		usage_with_options(sched_usage, sched_options);
+	}
+
 
 	return 0;
 }
