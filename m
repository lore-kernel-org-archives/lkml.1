Return-Path: <linux-kernel-owner+w=401wt.eu-S1763946AbZFMOvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763946AbZFMOvu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762835AbZFMOuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:50:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:49133 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762796AbZFMOuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:50:35 -0400
Date: Sat, 13 Jun 2009 14:49:56 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf stat: Add feature to run and measure a command multiple times
Message-ID: <tip-42202dd56c717f173cd0bf2390249e1bf5cf210b@git.kernel.org>
Git-Commit-ID: 42202dd56c717f173cd0bf2390249e1bf5cf210b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 13 Jun 2009 14:49:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42202dd56c717f173cd0bf2390249e1bf5cf210b
Gitweb:     http://git.kernel.org/tip/42202dd56c717f173cd0bf2390249e1bf5cf210b
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 13 Jun 2009 14:57:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 13 Jun 2009 15:18:57 +0200

perf stat: Add feature to run and measure a command multiple times

Add the --repeat <n> feature to perf stat, which repeats a given
command up to a 100 times, collects the stats and calculates an
average and a stddev.

For example, the following oneliner 'perf stat' command runs hackbench
5 times and prints a tabulated result of all metrics, with averages
and noise levels (in percentage) printed:

 aldebaran:~/linux/linux/tools/perf> ./perf stat --repeat 5 ~/hackbench 10
 Time: 0.117
 Time: 0.108
 Time: 0.089
 Time: 0.088
 Time: 0.100

 Performance counter stats for '/home/mingo/hackbench 10' (5 runs):

    1243.989586  task-clock-msecs     #     10.460 CPUs    ( +-   4.720% )
          47706  context-switches     #      0.038 M/sec   ( +-  19.706% )
            387  CPU-migrations       #      0.000 M/sec   ( +-   3.608% )
          17793  page-faults          #      0.014 M/sec   ( +-   0.354% )
     3770941606  cycles               #   3031.329 M/sec   ( +-   4.621% )
     1566372416  instructions         #      0.415 IPC     ( +-   2.703% )
       16783421  cache-references     #     13.492 M/sec   ( +-   5.202% )
        7128590  cache-misses         #      5.730 M/sec   ( +-   7.420% )

    0.118924455  seconds time elapsed.

The goal of this feature is to allow the reliance on these accurate
statistics and to know how many times a command has to be repeated
for the noise to go down to an acceptable level.

(The -v option can be used to see a line printed out as each run progresses.)

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c |  259 +++++++++++++++++++++++++++++++++-----------
 1 files changed, 194 insertions(+), 65 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c128048..9eb42b1 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -43,6 +43,7 @@
 #include "util/parse-events.h"
 
 #include <sys/prctl.h>
+#include <math.h>
 
 static struct perf_counter_attr default_attrs[MAX_COUNTERS] = {
 
@@ -79,12 +80,34 @@ static const unsigned int default_count[] = {
 	  10000,
 };
 
-static __u64			event_res[MAX_COUNTERS][3];
-static __u64			event_scaled[MAX_COUNTERS];
+#define MAX_RUN 100
 
-static __u64			runtime_nsecs;
-static __u64			walltime_nsecs;
-static __u64			runtime_cycles;
+static int			run_count		=  1;
+static int			run_idx			=  0;
+
+static __u64			event_res[MAX_RUN][MAX_COUNTERS][3];
+static __u64			event_scaled[MAX_RUN][MAX_COUNTERS];
+
+//static __u64			event_hist[MAX_RUN][MAX_COUNTERS][3];
+
+
+static __u64			runtime_nsecs[MAX_RUN];
+static __u64			walltime_nsecs[MAX_RUN];
+static __u64			runtime_cycles[MAX_RUN];
+
+static __u64			event_res_avg[MAX_COUNTERS][3];
+static __u64			event_res_noise[MAX_COUNTERS][3];
+
+static __u64			event_scaled_avg[MAX_COUNTERS];
+
+static __u64			runtime_nsecs_avg;
+static __u64			runtime_nsecs_noise;
+
+static __u64			walltime_nsecs_avg;
+static __u64			walltime_nsecs_noise;
+
+static __u64			runtime_cycles_avg;
+static __u64			runtime_cycles_noise;
 
 static void create_perf_stat_counter(int counter)
 {
@@ -140,7 +163,7 @@ static void read_counter(int counter)
 	int cpu, nv;
 	int scaled;
 
-	count = event_res[counter];
+	count = event_res[run_idx][counter];
 
 	count[0] = count[1] = count[2] = 0;
 
@@ -151,6 +174,8 @@ static void read_counter(int counter)
 
 		res = read(fd[cpu][counter], single_count, nv * sizeof(__u64));
 		assert(res == nv * sizeof(__u64));
+		close(fd[cpu][counter]);
+		fd[cpu][counter] = -1;
 
 		count[0] += single_count[0];
 		if (scale) {
@@ -162,13 +187,13 @@ static void read_counter(int counter)
 	scaled = 0;
 	if (scale) {
 		if (count[2] == 0) {
-			event_scaled[counter] = -1;
+			event_scaled[run_idx][counter] = -1;
 			count[0] = 0;
 			return;
 		}
 
 		if (count[2] < count[1]) {
-			event_scaled[counter] = 1;
+			event_scaled[run_idx][counter] = 1;
 			count[0] = (unsigned long long)
 				((double)count[0] * count[1] / count[2] + 0.5);
 		}
@@ -178,13 +203,62 @@ static void read_counter(int counter)
 	 */
 	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
 		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK)
-		runtime_nsecs = count[0];
+		runtime_nsecs[run_idx] = count[0];
 	if (attrs[counter].type == PERF_TYPE_HARDWARE &&
 		attrs[counter].config == PERF_COUNT_HW_CPU_CYCLES)
-		runtime_cycles = count[0];
+		runtime_cycles[run_idx] = count[0];
 }
 
-static void nsec_printout(int counter, __u64 *count)
+static int run_perf_stat(int argc, const char **argv)
+{
+	unsigned long long t0, t1;
+	int status = 0;
+	int counter;
+	int pid;
+
+	if (!system_wide)
+		nr_cpus = 1;
+
+	for (counter = 0; counter < nr_counters; counter++)
+		create_perf_stat_counter(counter);
+
+	/*
+	 * Enable counters and exec the command:
+	 */
+	t0 = rdclock();
+	prctl(PR_TASK_PERF_COUNTERS_ENABLE);
+
+	if ((pid = fork()) < 0)
+		perror("failed to fork");
+
+	if (!pid) {
+		if (execvp(argv[0], (char **)argv)) {
+			perror(argv[0]);
+			exit(-1);
+		}
+	}
+
+	wait(&status);
+
+	prctl(PR_TASK_PERF_COUNTERS_DISABLE);
+	t1 = rdclock();
+
+	walltime_nsecs[run_idx] = t1 - t0;
+
+	for (counter = 0; counter < nr_counters; counter++)
+		read_counter(counter);
+
+	return WEXITSTATUS(status);
+}
+
+static void print_noise(__u64 *count, __u64 *noise)
+{
+	if (run_count > 1)
+		fprintf(stderr, "   ( +- %7.3f%% )",
+			(double)noise[0]/(count[0]+1)*100.0);
+}
+
+static void nsec_printout(int counter, __u64 *count, __u64 *noise)
 {
 	double msecs = (double)count[0] / 1000000;
 
@@ -193,29 +267,30 @@ static void nsec_printout(int counter, __u64 *count)
 	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
 		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK) {
 
-		if (walltime_nsecs)
-			fprintf(stderr, " # %10.3f CPUs",
-				(double)count[0] / (double)walltime_nsecs);
+		if (walltime_nsecs_avg)
+			fprintf(stderr, " # %10.3f CPUs ",
+				(double)count[0] / (double)walltime_nsecs_avg);
 	}
+	print_noise(count, noise);
 }
 
-static void abs_printout(int counter, __u64 *count)
+static void abs_printout(int counter, __u64 *count, __u64 *noise)
 {
 	fprintf(stderr, " %14Ld  %-20s", count[0], event_name(counter));
 
-	if (runtime_cycles &&
+	if (runtime_cycles_avg &&
 		attrs[counter].type == PERF_TYPE_HARDWARE &&
 			attrs[counter].config == PERF_COUNT_HW_INSTRUCTIONS) {
 
-		fprintf(stderr, " # %10.3f IPC",
-			(double)count[0] / (double)runtime_cycles);
-
-		return;
+		fprintf(stderr, " # %10.3f IPC  ",
+			(double)count[0] / (double)runtime_cycles_avg);
+	} else {
+		if (runtime_nsecs_avg) {
+			fprintf(stderr, " # %10.3f M/sec",
+				(double)count[0]/runtime_nsecs_avg*1000.0);
+		}
 	}
-
-	if (runtime_nsecs)
-		fprintf(stderr, " # %10.3f M/sec",
-			(double)count[0]/runtime_nsecs*1000.0);
+	print_noise(count, noise);
 }
 
 /*
@@ -223,11 +298,12 @@ static void abs_printout(int counter, __u64 *count)
  */
 static void print_counter(int counter)
 {
-	__u64 *count;
+	__u64 *count, *noise;
 	int scaled;
 
-	count = event_res[counter];
-	scaled = event_scaled[counter];
+	count = event_res_avg[counter];
+	noise = event_res_noise[counter];
+	scaled = event_scaled_avg[counter];
 
 	if (scaled == -1) {
 		fprintf(stderr, " %14s  %-20s\n",
@@ -236,9 +312,9 @@ static void print_counter(int counter)
 	}
 
 	if (nsec_counter(counter))
-		nsec_printout(counter, count);
+		nsec_printout(counter, count, noise);
 	else
-		abs_printout(counter, count);
+		abs_printout(counter, count, noise);
 
 	if (scaled)
 		fprintf(stderr, "  (scaled from %.2f%%)",
@@ -247,43 +323,83 @@ static void print_counter(int counter)
 	fprintf(stderr, "\n");
 }
 
-static int do_perf_stat(int argc, const char **argv)
+/*
+ * Normalize noise values down to stddev:
+ */
+static void normalize(__u64 *val)
 {
-	unsigned long long t0, t1;
-	int counter;
-	int status;
-	int pid;
-	int i;
-
-	if (!system_wide)
-		nr_cpus = 1;
+	double res;
 
-	for (counter = 0; counter < nr_counters; counter++)
-		create_perf_stat_counter(counter);
+	res = (double)*val / (run_count * sqrt((double)run_count));
 
-	/*
-	 * Enable counters and exec the command:
-	 */
-	t0 = rdclock();
-	prctl(PR_TASK_PERF_COUNTERS_ENABLE);
+	*val = (__u64)res;
+}
 
-	if ((pid = fork()) < 0)
-		perror("failed to fork");
+/*
+ * Calculate the averages and noises:
+ */
+static void calc_avg(void)
+{
+	int i, j;
+
+	for (i = 0; i < run_count; i++) {
+		runtime_nsecs_avg += runtime_nsecs[i];
+		walltime_nsecs_avg += walltime_nsecs[i];
+		runtime_cycles_avg += runtime_cycles[i];
+
+		for (j = 0; j < nr_counters; j++) {
+			event_res_avg[j][0] += event_res[i][j][0];
+			event_res_avg[j][1] += event_res[i][j][1];
+			event_res_avg[j][2] += event_res[i][j][2];
+			event_scaled_avg[j] += event_scaled[i][j];
+		}
+	}
+	runtime_nsecs_avg /= run_count;
+	walltime_nsecs_avg /= run_count;
+	runtime_cycles_avg /= run_count;
+
+	for (j = 0; j < nr_counters; j++) {
+		event_res_avg[j][0] /= run_count;
+		event_res_avg[j][1] /= run_count;
+		event_res_avg[j][2] /= run_count;
+	}
 
-	if (!pid) {
-		if (execvp(argv[0], (char **)argv)) {
-			perror(argv[0]);
-			exit(-1);
+	for (i = 0; i < run_count; i++) {
+		runtime_nsecs_noise +=
+			abs((__s64)(runtime_nsecs[i] - runtime_nsecs_avg));
+		walltime_nsecs_noise +=
+			abs((__s64)(walltime_nsecs[i] - walltime_nsecs_avg));
+		runtime_cycles_noise +=
+			abs((__s64)(runtime_cycles[i] - runtime_cycles_avg));
+
+		for (j = 0; j < nr_counters; j++) {
+			event_res_noise[j][0] +=
+				abs((__s64)(event_res[i][j][0] - event_res_avg[j][0]));
+			event_res_noise[j][1] +=
+				abs((__s64)(event_res[i][j][1] - event_res_avg[j][1]));
+			event_res_noise[j][2] +=
+				abs((__s64)(event_res[i][j][2] - event_res_avg[j][2]));
 		}
 	}
 
-	while (wait(&status) >= 0)
-		;
+	normalize(&runtime_nsecs_noise);
+	normalize(&walltime_nsecs_noise);
+	normalize(&runtime_cycles_noise);
 
-	prctl(PR_TASK_PERF_COUNTERS_DISABLE);
-	t1 = rdclock();
+	for (j = 0; j < nr_counters; j++) {
+		normalize(&event_res_noise[j][0]);
+		normalize(&event_res_noise[j][1]);
+		normalize(&event_res_noise[j][2]);
+	}
+}
+
+static void print_stat(int argc, const char **argv)
+{
+	int i, counter;
+
+	calc_avg();
 
-	walltime_nsecs = t1 - t0;
+	run_idx = 0;
 
 	fflush(stdout);
 
@@ -293,21 +409,19 @@ static int do_perf_stat(int argc, const char **argv)
 	for (i = 1; i < argc; i++)
 		fprintf(stderr, " %s", argv[i]);
 
-	fprintf(stderr, "\':\n");
-	fprintf(stderr, "\n");
-
-	for (counter = 0; counter < nr_counters; counter++)
-		read_counter(counter);
+	fprintf(stderr, "\'");
+	if (run_count > 1)
+		fprintf(stderr, " (%d runs)", run_count);
+	fprintf(stderr, ":\n\n");
 
 	for (counter = 0; counter < nr_counters; counter++)
 		print_counter(counter);
 
 
 	fprintf(stderr, "\n");
-	fprintf(stderr, " %14.9f  seconds time elapsed.\n", (double)(t1-t0)/1e9);
+	fprintf(stderr, " %14.9f  seconds time elapsed.\n",
+			(double)walltime_nsecs_avg/1e9);
 	fprintf(stderr, "\n");
-
-	return 0;
 }
 
 static volatile int signr = -1;
@@ -345,11 +459,15 @@ static const struct option options[] = {
 			    "scale/normalize counters"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
+	OPT_INTEGER('r', "repeat", &run_count,
+		    "repeat command and print average + stddev (max: 100)"),
 	OPT_END()
 };
 
 int cmd_stat(int argc, const char **argv, const char *prefix)
 {
+	int status;
+
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	memcpy(attrs, default_attrs, sizeof(attrs));
@@ -357,6 +475,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 	argc = parse_options(argc, argv, options, stat_usage, 0);
 	if (!argc)
 		usage_with_options(stat_usage, options);
+	if (run_count <= 0 || run_count > MAX_RUN)
+		usage_with_options(stat_usage, options);
 
 	if (!nr_counters)
 		nr_counters = 8;
@@ -376,5 +496,14 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 	signal(SIGALRM, skip_signal);
 	signal(SIGABRT, skip_signal);
 
-	return do_perf_stat(argc, argv);
+	status = 0;
+	for (run_idx = 0; run_idx < run_count; run_idx++) {
+		if (run_count != 1 && verbose)
+			fprintf(stderr, "[ perf stat: executing run #%d ... ]\n", run_idx+1);
+		status = run_perf_stat(argc, argv);
+	}
+
+	print_stat(argc, argv);
+
+	return status;
 }
