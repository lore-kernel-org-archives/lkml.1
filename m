Return-Path: <linux-kernel-owner+w=401wt.eu-S1752164AbZIOJc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbZIOJc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZIOJcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:32:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:49318 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZIOJcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:32:52 -0400
Date: Tue, 15 Sep 2009 09:32:24 GMT
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
Subject: [tip:perfcounters/core] perf sched: Clean up latency and replay sub-commands
Message-ID: <tip-46f392c97f9fd772426ed3361c5179a0d44b8c3f@git.kernel.org>
Git-Commit-ID: 46f392c97f9fd772426ed3361c5179a0d44b8c3f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:32:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46f392c97f9fd772426ed3361c5179a0d44b8c3f
Gitweb:     http://git.kernel.org/tip/46f392c97f9fd772426ed3361c5179a0d44b8c3f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 12 Sep 2009 10:08:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Sep 2009 10:22:44 +0200

perf sched: Clean up latency and replay sub-commands

- Separate the latency and the replay commands more cleanly

 - Use consistent naming

 - Display help page on 'perf sched' outlining comments,
   instead of aborting

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c |   99 ++++++++++++++++++++++----------------------
 1 files changed, 49 insertions(+), 50 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 4f9e943..84699cf 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -543,24 +543,7 @@ static void wait_for_tasks(void)
 	}
 }
 
-static int __cmd_sched(void);
-
-static void parse_trace(void)
-{
-	__cmd_sched();
-
-	printf("nr_run_events:        %ld\n", nr_run_events);
-	printf("nr_sleep_events:      %ld\n", nr_sleep_events);
-	printf("nr_wakeup_events:     %ld\n", nr_wakeup_events);
-
-	if (targetless_wakeups)
-		printf("target-less wakeups:  %ld\n", targetless_wakeups);
-	if (multitarget_wakeups)
-		printf("multi-target wakeups: %ld\n", multitarget_wakeups);
-	if (nr_run_events_optimized)
-		printf("run events optimized: %ld\n",
-			nr_run_events_optimized);
-}
+static int read_events(void);
 
 static unsigned long nr_runs;
 static nsec_t sum_runtime;
@@ -637,6 +620,38 @@ static void test_calibrations(void)
 	printf("the sleep test took %Ld nsecs\n", T1-T0);
 }
 
+static void __cmd_replay(void)
+{
+	long nr_iterations = 10, i;
+
+	calibrate_run_measurement_overhead();
+	calibrate_sleep_measurement_overhead();
+
+	test_calibrations();
+
+	read_events();
+
+	printf("nr_run_events:        %ld\n", nr_run_events);
+	printf("nr_sleep_events:      %ld\n", nr_sleep_events);
+	printf("nr_wakeup_events:     %ld\n", nr_wakeup_events);
+
+	if (targetless_wakeups)
+		printf("target-less wakeups:  %ld\n", targetless_wakeups);
+	if (multitarget_wakeups)
+		printf("multi-target wakeups: %ld\n", multitarget_wakeups);
+	if (nr_run_events_optimized)
+		printf("run events optimized: %ld\n",
+			nr_run_events_optimized);
+
+	print_task_traces();
+	add_cross_task_wakeups();
+
+	create_tasks();
+	printf("------------------------------------------------------------\n");
+	for (i = 0; i < nr_iterations; i++)
+		run_one_test();
+}
+
 static int
 process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
@@ -1091,10 +1106,13 @@ static void output_lat_thread(struct thread_latency *lat)
 	printf("%5d        %10llu       %10llu      %10llu\n", count, total, avg, max);
 }
 
-static void output_lat_results(void)
+static void __cmd_lat(void)
 {
 	struct rb_node *next;
 
+	setup_pager();
+	read_events();
+
 	printf(" Tasks");
 	printf("                     count");
 	printf("          total");
@@ -1312,7 +1330,7 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
-static int __cmd_sched(void)
+static int read_events(void)
 {
 	int ret, rc = EXIT_FAILURE;
 	unsigned long offset = 0;
@@ -1408,8 +1426,8 @@ more:
 	return rc;
 }
 
-static const char * const annotate_usage[] = {
-	"perf trace [<options>] <command>",
+static const char * const sched_usage[] = {
+	"perf sched [<options>] <command>",
 	NULL
 };
 
@@ -1427,49 +1445,30 @@ static const struct option options[] = {
 
 int cmd_sched(int argc, const char **argv, const char *prefix __used)
 {
-	long nr_iterations = 10, i;
-
 	symbol__init();
 	page_size = getpagesize();
 
-	argc = parse_options(argc, argv, options, annotate_usage, 0);
+	argc = parse_options(argc, argv, options, sched_usage, 0);
 	if (argc) {
 		/*
 		 * Special case: if there's an argument left then assume tha
 		 * it's a symbol filter:
 		 */
 		if (argc > 1)
-			usage_with_options(annotate_usage, options);
+			usage_with_options(sched_usage, options);
 	}
 
-//	setup_pager();
-
 	if (replay_mode)
 		trace_handler = &replay_ops;
 	else if (lat_mode)
 		trace_handler = &lat_ops;
-	else /* We may need a default subcommand (perf trace?) */
-		die("Please select a sub command (-r)\n");
-
-	if (replay_mode) {
-		calibrate_run_measurement_overhead();
-		calibrate_sleep_measurement_overhead();
-
-		test_calibrations();
-
-		parse_trace();
-		print_task_traces();
-		add_cross_task_wakeups();
-
-		create_tasks();
-		printf("------------------------------------------------------------\n");
-		for (i = 0; i < nr_iterations; i++)
-			run_one_test();
-	} else if (lat_mode) {
-		setup_pager();
-		__cmd_sched();
-		output_lat_results();
-	}
+	else
+		usage_with_options(sched_usage, options);
+
+	if (replay_mode)
+		__cmd_replay();
+	else if (lat_mode)
+		__cmd_lat();
 
 	return 0;
 }
