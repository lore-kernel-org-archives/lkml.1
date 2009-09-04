Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbZIDPnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbZIDPnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 11:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757009AbZIDPnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 11:43:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:55557 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910AbZIDPna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 11:43:30 -0400
Date: Fri, 4 Sep 2009 15:42:56 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf stat: Change noise calculation to use stddev
Message-ID: <tip-506d4bc8d5dab20d84624aa07cdc6dcd77915d52@git.kernel.org>
Git-Commit-ID: 506d4bc8d5dab20d84624aa07cdc6dcd77915d52
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 15:42:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  506d4bc8d5dab20d84624aa07cdc6dcd77915d52
Gitweb:     http://git.kernel.org/tip/506d4bc8d5dab20d84624aa07cdc6dcd77915d52
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 4 Sep 2009 15:36:12 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 16:33:07 +0200

perf stat: Change noise calculation to use stddev

The current noise computation does:

 \Sum abs(n_i - avg(n)) * N^-1.5

Which is (afaik) not a regular noise function, and needs the
complete sample set available to post-process.

Change this to use a regular stddev computation which can be
done by keeping a two sums:

 stddev = sqrt( 1/N (\Sum n_i^2) - avg(n)^2 )

For which we only need to keep \Sum n_i and \Sum n_i^2.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c |  170 ++++++++++++++++++---------------------------
 1 files changed, 69 insertions(+), 101 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 1a26262..31ffc4d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -83,19 +83,32 @@ static u64			runtime_cycles[MAX_RUN];
 static u64			event_res[MAX_RUN][MAX_COUNTERS][3];
 static u64			event_scaled[MAX_RUN][MAX_COUNTERS];
 
-static u64			event_res_avg[MAX_COUNTERS][3];
-static u64			event_res_noise[MAX_COUNTERS][3];
+struct stats
+{
+	double sum;
+	double sum_sq;
+};
 
-static u64			event_scaled_avg[MAX_COUNTERS];
+static double avg_stats(struct stats *stats)
+{
+	return stats->sum / run_count;
+}
 
-static u64			runtime_nsecs_avg;
-static u64			runtime_nsecs_noise;
+/*
+ * stddev = sqrt(1/N (\Sum n_i^2) - avg(n)^2)
+ */
+static double stddev_stats(struct stats *stats)
+{
+	double avg = stats->sum / run_count;
 
-static u64			walltime_nsecs_avg;
-static u64			walltime_nsecs_noise;
+	return sqrt(stats->sum_sq/run_count - avg*avg);
+}
 
-static u64			runtime_cycles_avg;
-static u64			runtime_cycles_noise;
+struct stats			event_res_stats[MAX_COUNTERS][3];
+struct stats			event_scaled_stats[MAX_COUNTERS];
+struct stats			runtime_nsecs_stats;
+struct stats			walltime_nsecs_stats;
+struct stats			runtime_cycles_stats;
 
 #define MATCH_EVENT(t, c, counter)			\
 	(attrs[counter].type == PERF_TYPE_##t &&	\
@@ -279,42 +292,37 @@ static int run_perf_stat(int argc __used, const char **argv)
 	return WEXITSTATUS(status);
 }
 
-static void print_noise(u64 *count, u64 *noise)
+static void print_noise(double avg, double stddev)
 {
 	if (run_count > 1)
-		fprintf(stderr, "   ( +- %7.3f%% )",
-			(double)noise[0]/(count[0]+1)*100.0);
+		fprintf(stderr, "   ( +- %7.3f%% )", 100*stddev / avg);
 }
 
-static void nsec_printout(int counter, u64 *count, u64 *noise)
+static void nsec_printout(int counter, double avg, double stddev)
 {
-	double msecs = (double)count[0] / 1000000;
+	double msecs = avg / 1e6;
 
 	fprintf(stderr, " %14.6f  %-24s", msecs, event_name(counter));
 
 	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter)) {
-		if (walltime_nsecs_avg)
-			fprintf(stderr, " # %10.3f CPUs ",
-				(double)count[0] / (double)walltime_nsecs_avg);
+		fprintf(stderr, " # %10.3f CPUs ",
+				avg / avg_stats(&walltime_nsecs_stats));
 	}
-	print_noise(count, noise);
+	print_noise(avg, stddev);
 }
 
-static void abs_printout(int counter, u64 *count, u64 *noise)
+static void abs_printout(int counter, double avg, double stddev)
 {
-	fprintf(stderr, " %14Ld  %-24s", count[0], event_name(counter));
+	fprintf(stderr, " %14.0f  %-24s", avg, event_name(counter));
 
-	if (runtime_cycles_avg &&
-	    MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
+	if (MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
 		fprintf(stderr, " # %10.3f IPC  ",
-			(double)count[0] / (double)runtime_cycles_avg);
+				avg / avg_stats(&runtime_cycles_stats));
 	} else {
-		if (runtime_nsecs_avg) {
-			fprintf(stderr, " # %10.3f M/sec",
-				(double)count[0]/runtime_nsecs_avg*1000.0);
-		}
+		fprintf(stderr, " # %10.3f M/sec",
+				1000.0 * avg / avg_stats(&runtime_nsecs_stats));
 	}
-	print_noise(count, noise);
+	print_noise(avg, stddev);
 }
 
 /*
@@ -322,12 +330,12 @@ static void abs_printout(int counter, u64 *count, u64 *noise)
  */
 static void print_counter(int counter)
 {
-	u64 *count, *noise;
+	double avg, stddev;
 	int scaled;
 
-	count = event_res_avg[counter];
-	noise = event_res_noise[counter];
-	scaled = event_scaled_avg[counter];
+	avg    = avg_stats(&event_res_stats[counter][0]);
+	stddev = stddev_stats(&event_res_stats[counter][0]);
+	scaled = avg_stats(&event_scaled_stats[counter]);
 
 	if (scaled == -1) {
 		fprintf(stderr, " %14s  %-24s\n",
@@ -336,36 +344,34 @@ static void print_counter(int counter)
 	}
 
 	if (nsec_counter(counter))
-		nsec_printout(counter, count, noise);
+		nsec_printout(counter, avg, stddev);
 	else
-		abs_printout(counter, count, noise);
+		abs_printout(counter, avg, stddev);
+
+	if (scaled) {
+		double avg_enabled, avg_running;
+
+		avg_enabled = avg_stats(&event_res_stats[counter][1]);
+		avg_running = avg_stats(&event_res_stats[counter][2]);
 
-	if (scaled)
 		fprintf(stderr, "  (scaled from %.2f%%)",
-			(double) count[2] / count[1] * 100);
+				100 * avg_running / avg_enabled);
+	}
 
 	fprintf(stderr, "\n");
 }
 
-/*
- * normalize_noise noise values down to stddev:
- */
-static void normalize_noise(u64 *val)
+static void update_stats(const char *name, int idx, struct stats *stats, u64 *val)
 {
-	double res;
+	double sq = *val;
 
-	res = (double)*val / (run_count * sqrt((double)run_count));
-
-	*val = (u64)res;
-}
-
-static void update_avg(const char *name, int idx, u64 *avg, u64 *val)
-{
-	*avg += *val;
+	stats->sum += *val;
+	stats->sum_sq += sq * sq;
 
 	if (verbose > 1)
 		fprintf(stderr, "debug: %20s[%d]: %Ld\n", name, idx, *val);
 }
+
 /*
  * Calculate the averages and noises:
  */
@@ -377,61 +383,22 @@ static void calc_avg(void)
 		fprintf(stderr, "\n");
 
 	for (i = 0; i < run_count; i++) {
-		update_avg("runtime", 0, &runtime_nsecs_avg, runtime_nsecs + i);
-		update_avg("walltime", 0, &walltime_nsecs_avg, walltime_nsecs + i);
-		update_avg("runtime_cycles", 0, &runtime_cycles_avg, runtime_cycles + i);
+		update_stats("runtime", 0, &runtime_nsecs_stats, runtime_nsecs + i);
+		update_stats("walltime", 0, &walltime_nsecs_stats, walltime_nsecs + i);
+		update_stats("runtime_cycles", 0, &runtime_cycles_stats, runtime_cycles + i);
 
 		for (j = 0; j < nr_counters; j++) {
-			update_avg("counter/0", j,
-				event_res_avg[j]+0, event_res[i][j]+0);
-			update_avg("counter/1", j,
-				event_res_avg[j]+1, event_res[i][j]+1);
-			update_avg("counter/2", j,
-				event_res_avg[j]+2, event_res[i][j]+2);
+			update_stats("counter/0", j,
+				event_res_stats[j]+0, event_res[i][j]+0);
+			update_stats("counter/1", j,
+				event_res_stats[j]+1, event_res[i][j]+1);
+			update_stats("counter/2", j,
+				event_res_stats[j]+2, event_res[i][j]+2);
 			if (event_scaled[i][j] != (u64)-1)
-				update_avg("scaled", j,
-					event_scaled_avg + j, event_scaled[i]+j);
-			else
-				event_scaled_avg[j] = -1;
+				update_stats("scaled", j,
+					event_scaled_stats + j, event_scaled[i]+j);
 		}
 	}
-	runtime_nsecs_avg /= run_count;
-	walltime_nsecs_avg /= run_count;
-	runtime_cycles_avg /= run_count;
-
-	for (j = 0; j < nr_counters; j++) {
-		event_res_avg[j][0] /= run_count;
-		event_res_avg[j][1] /= run_count;
-		event_res_avg[j][2] /= run_count;
-	}
-
-	for (i = 0; i < run_count; i++) {
-		runtime_nsecs_noise +=
-			abs((s64)(runtime_nsecs[i] - runtime_nsecs_avg));
-		walltime_nsecs_noise +=
-			abs((s64)(walltime_nsecs[i] - walltime_nsecs_avg));
-		runtime_cycles_noise +=
-			abs((s64)(runtime_cycles[i] - runtime_cycles_avg));
-
-		for (j = 0; j < nr_counters; j++) {
-			event_res_noise[j][0] +=
-				abs((s64)(event_res[i][j][0] - event_res_avg[j][0]));
-			event_res_noise[j][1] +=
-				abs((s64)(event_res[i][j][1] - event_res_avg[j][1]));
-			event_res_noise[j][2] +=
-				abs((s64)(event_res[i][j][2] - event_res_avg[j][2]));
-		}
-	}
-
-	normalize_noise(&runtime_nsecs_noise);
-	normalize_noise(&walltime_nsecs_noise);
-	normalize_noise(&runtime_cycles_noise);
-
-	for (j = 0; j < nr_counters; j++) {
-		normalize_noise(&event_res_noise[j][0]);
-		normalize_noise(&event_res_noise[j][1]);
-		normalize_noise(&event_res_noise[j][2]);
-	}
 }
 
 static void print_stat(int argc, const char **argv)
@@ -458,10 +425,11 @@ static void print_stat(int argc, const char **argv)
 
 	fprintf(stderr, "\n");
 	fprintf(stderr, " %14.9f  seconds time elapsed",
-			(double)walltime_nsecs_avg/1e9);
+			avg_stats(&walltime_nsecs_stats)/1e9);
 	if (run_count > 1) {
 		fprintf(stderr, "   ( +- %7.3f%% )",
-			100.0*(double)walltime_nsecs_noise/(double)walltime_nsecs_avg);
+				100*stddev_stats(&walltime_nsecs_stats) /
+				avg_stats(&walltime_nsecs_stats));
 	}
 	fprintf(stderr, "\n\n");
 }
