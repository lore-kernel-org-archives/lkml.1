Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbZFXCZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbZFXCZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 22:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZFXCZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 22:25:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:57681 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbZFXCZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 22:25:35 -0400
Subject: [PATCH] perf stat: fix hardcoded nr_counter
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 07:54:56 +0530
Message-Id: <1245810296.3434.3.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


nr_counter should be based on number of default_attrs entries.

Remove dead code and some code alignment.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/builtin-stat.c |   48 ++++++++++++++------------------------------
 1 files changed, 15 insertions(+), 33 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 5e04fcc..e22b32f 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -45,7 +45,7 @@
 #include <sys/prctl.h>
 #include <math.h>
 
-static struct perf_counter_attr default_attrs[MAX_COUNTERS] = {
+static struct perf_counter_attr default_attrs[] = {
 
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK	},
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES},
@@ -59,42 +59,27 @@ static struct perf_counter_attr default_attrs[MAX_COUNTERS] = {
 
 };
 
+#define MAX_RUN			100
+
 static int			system_wide			=  0;
-static int			inherit				=  1;
 static int			verbose				=  0;
-
-static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
-
-static int			target_pid			= -1;
 static int			nr_cpus				=  0;
-static unsigned int		page_size;
+static int			run_idx				=  0;
 
+static int			run_count			=  1;
+static int			inherit				=  1;
 static int			scale				=  1;
+static int			target_pid			= -1;
 
-static const unsigned int default_count[] = {
-	1000000,
-	1000000,
-	  10000,
-	  10000,
-	1000000,
-	  10000,
-};
-
-#define MAX_RUN 100
+static u64			runtime_nsecs[MAX_RUN];
+static u64			walltime_nsecs[MAX_RUN];
+static u64			runtime_cycles[MAX_RUN];
 
-static int			run_count		=  1;
-static int			run_idx			=  0;
+static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static u64			event_res[MAX_RUN][MAX_COUNTERS][3];
 static u64			event_scaled[MAX_RUN][MAX_COUNTERS];
 
-//static u64			event_hist[MAX_RUN][MAX_COUNTERS][3];
-
-
-static u64			runtime_nsecs[MAX_RUN];
-static u64			walltime_nsecs[MAX_RUN];
-static u64			runtime_cycles[MAX_RUN];
-
 static u64			event_res_avg[MAX_COUNTERS][3];
 static u64			event_res_noise[MAX_COUNTERS][3];
 
@@ -109,7 +94,6 @@ static u64			walltime_nsecs_noise;
 static u64			runtime_cycles_avg;
 static u64			runtime_cycles_noise;
 
-
 #define ERR_PERF_OPEN \
 "Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n"
 
@@ -470,9 +454,9 @@ static const struct option options[] = {
 	OPT_INTEGER('p', "pid", &target_pid,
 		    "stat events on existing pid"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
-			    "system-wide collection from all CPUs"),
+		    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('S', "scale", &scale,
-			    "scale/normalize counters"),
+		    "scale/normalize counters"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_INTEGER('r', "repeat", &run_count,
@@ -484,8 +468,6 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 {
 	int status;
 
-	page_size = sysconf(_SC_PAGE_SIZE);
-
 	memcpy(attrs, default_attrs, sizeof(attrs));
 
 	argc = parse_options(argc, argv, options, stat_usage, 0);
@@ -495,7 +477,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 		usage_with_options(stat_usage, options);
 
 	if (!nr_counters)
-		nr_counters = 8;
+		nr_counters = ARRAY_SIZE(default_attrs);
 
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	assert(nr_cpus <= MAX_NR_CPUS);
@@ -515,7 +497,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 	status = 0;
 	for (run_idx = 0; run_idx < run_count; run_idx++) {
 		if (run_count != 1 && verbose)
-			fprintf(stderr, "[ perf stat: executing run #%d ... ]\n", run_idx+1);
+			fprintf(stderr, "[ perf stat: executing run #%d ... ]\n", run_idx + 1);
 		status = run_perf_stat(argc, argv);
 	}
 
-- 
1.6.0.6



