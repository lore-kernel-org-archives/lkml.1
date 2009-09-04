Return-Path: <linux-kernel-owner+w=401wt.eu-S932571AbZIDPnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbZIDPnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 11:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932412AbZIDPnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 11:43:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:55566 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411AbZIDPnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 11:43:37 -0400
Date: Fri, 4 Sep 2009 15:43:09 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf stat: Remove the limit on repeat
Message-ID: <tip-9e9772c458d50dabdb5327821da3803254638cd1@git.kernel.org>
Git-Commit-ID: 9e9772c458d50dabdb5327821da3803254638cd1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 15:43:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e9772c458d50dabdb5327821da3803254638cd1
Gitweb:     http://git.kernel.org/tip/9e9772c458d50dabdb5327821da3803254638cd1
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 4 Sep 2009 15:36:08 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 16:33:08 +0200

perf stat: Remove the limit on repeat

Since we don't need all the individual samples to calculate the
error remove both the limit and the storage overhead associated
with that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c |   84 ++++++++++++++------------------------------
 1 files changed, 27 insertions(+), 57 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 31ffc4d..9c6377f 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -62,8 +62,6 @@ static struct perf_counter_attr default_attrs[] = {
 
 };
 
-#define MAX_RUN			100
-
 static int			system_wide			=  0;
 static unsigned int		nr_cpus				=  0;
 static int			run_idx				=  0;
@@ -76,12 +74,8 @@ static int			null_run			=  0;
 
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
-static u64			runtime_nsecs[MAX_RUN];
-static u64			walltime_nsecs[MAX_RUN];
-static u64			runtime_cycles[MAX_RUN];
-
-static u64			event_res[MAX_RUN][MAX_COUNTERS][3];
-static u64			event_scaled[MAX_RUN][MAX_COUNTERS];
+static u64			event_res[MAX_COUNTERS][3];
+static u64			event_scaled[MAX_COUNTERS];
 
 struct stats
 {
@@ -89,6 +83,14 @@ struct stats
 	double sum_sq;
 };
 
+static void update_stats(struct stats *stats, u64 val)
+{
+	double sq = val;
+
+	stats->sum += val;
+	stats->sum_sq += sq * sq;
+}
+
 static double avg_stats(struct stats *stats)
 {
 	return stats->sum / run_count;
@@ -167,8 +169,9 @@ static void read_counter(int counter)
 	unsigned int cpu;
 	size_t res, nv;
 	int scaled;
+	int i;
 
-	count = event_res[run_idx][counter];
+	count = event_res[counter];
 
 	count[0] = count[1] = count[2] = 0;
 
@@ -193,24 +196,33 @@ static void read_counter(int counter)
 	scaled = 0;
 	if (scale) {
 		if (count[2] == 0) {
-			event_scaled[run_idx][counter] = -1;
+			event_scaled[counter] = -1;
 			count[0] = 0;
 			return;
 		}
 
 		if (count[2] < count[1]) {
-			event_scaled[run_idx][counter] = 1;
+			event_scaled[counter] = 1;
 			count[0] = (unsigned long long)
 				((double)count[0] * count[1] / count[2] + 0.5);
 		}
 	}
+
+	for (i = 0; i < 3; i++)
+		update_stats(&event_res_stats[counter][i], count[i]);
+
+	if (verbose) {
+		fprintf(stderr, "%s: %Ld %Ld %Ld\n", event_name(counter),
+				count[0], count[1], count[2]);
+	}
+
 	/*
 	 * Save the full runtime - to allow normalization during printout:
 	 */
 	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter))
-		runtime_nsecs[run_idx] = count[0];
+		update_stats(&runtime_nsecs_stats, count[0]);
 	if (MATCH_EVENT(HARDWARE, HW_CPU_CYCLES, counter))
-		runtime_cycles[run_idx] = count[0];
+		update_stats(&runtime_cycles_stats, count[0]);
 }
 
 static int run_perf_stat(int argc __used, const char **argv)
@@ -284,7 +296,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 
 	t1 = rdclock();
 
-	walltime_nsecs[run_idx] = t1 - t0;
+	update_stats(&walltime_nsecs_stats, t1 - t0);
 
 	for (counter = 0; counter < nr_counters; counter++)
 		read_counter(counter);
@@ -361,52 +373,10 @@ static void print_counter(int counter)
 	fprintf(stderr, "\n");
 }
 
-static void update_stats(const char *name, int idx, struct stats *stats, u64 *val)
-{
-	double sq = *val;
-
-	stats->sum += *val;
-	stats->sum_sq += sq * sq;
-
-	if (verbose > 1)
-		fprintf(stderr, "debug: %20s[%d]: %Ld\n", name, idx, *val);
-}
-
-/*
- * Calculate the averages and noises:
- */
-static void calc_avg(void)
-{
-	int i, j;
-
-	if (verbose > 1)
-		fprintf(stderr, "\n");
-
-	for (i = 0; i < run_count; i++) {
-		update_stats("runtime", 0, &runtime_nsecs_stats, runtime_nsecs + i);
-		update_stats("walltime", 0, &walltime_nsecs_stats, walltime_nsecs + i);
-		update_stats("runtime_cycles", 0, &runtime_cycles_stats, runtime_cycles + i);
-
-		for (j = 0; j < nr_counters; j++) {
-			update_stats("counter/0", j,
-				event_res_stats[j]+0, event_res[i][j]+0);
-			update_stats("counter/1", j,
-				event_res_stats[j]+1, event_res[i][j]+1);
-			update_stats("counter/2", j,
-				event_res_stats[j]+2, event_res[i][j]+2);
-			if (event_scaled[i][j] != (u64)-1)
-				update_stats("scaled", j,
-					event_scaled_stats + j, event_scaled[i]+j);
-		}
-	}
-}
-
 static void print_stat(int argc, const char **argv)
 {
 	int i, counter;
 
-	calc_avg();
-
 	fflush(stdout);
 
 	fprintf(stderr, "\n");
@@ -484,7 +454,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc)
 		usage_with_options(stat_usage, options);
-	if (run_count <= 0 || run_count > MAX_RUN)
+	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
 
 	/* Set attrs and nr_counters if no event is selected and !null_run */
