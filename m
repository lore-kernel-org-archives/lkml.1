Return-Path: <linux-kernel-owner+w=401wt.eu-S932596AbZIDPoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbZIDPoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 11:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932184AbZIDPoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 11:44:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:55587 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932412AbZIDPoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 11:44:00 -0400
Date: Fri, 4 Sep 2009 15:43:22 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf stat: Use stddev_mean in stead of stddev
Message-ID: <tip-63d40deb2e7c64ed55943d49f078e09fc4b64b54@git.kernel.org>
Git-Commit-ID: 63d40deb2e7c64ed55943d49f078e09fc4b64b54
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 15:43:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63d40deb2e7c64ed55943d49f078e09fc4b64b54
Gitweb:     http://git.kernel.org/tip/63d40deb2e7c64ed55943d49f078e09fc4b64b54
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 4 Sep 2009 17:03:13 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 17:38:14 +0200

perf stat: Use stddev_mean in stead of stddev

When we're computing the mean by sampling the distribution,
then the std dev of the mean is related to the std dev of the
sample set by:

  stddev_mean = std_dev / sqrt(N)

Which is exactly what we want.

This results in the error on the mean decreasing with
increasing number of samples.

Also fix the scaled == -1, aka not counted case.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 9c6377f..e9424fa 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -75,7 +75,7 @@ static int			null_run			=  0;
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static u64			event_res[MAX_COUNTERS][3];
-static u64			event_scaled[MAX_COUNTERS];
+static int			event_scaled[MAX_COUNTERS];
 
 struct stats
 {
@@ -97,17 +97,31 @@ static double avg_stats(struct stats *stats)
 }
 
 /*
- * stddev = sqrt(1/N (\Sum n_i^2) - avg(n)^2)
+ * http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
+ *
+ *      (\Sum n_i^2) - ((\Sum n_i)^2)/n
+ * s^2  -------------------------------
+ *                   n - 1
+ *
+ * http://en.wikipedia.org/wiki/Stddev
+ *
+ * The std dev of the mean is related to the std dev by:
+ *
+ *             s
+ * s_mean = -------
+ *          sqrt(n)
+ *
  */
 static double stddev_stats(struct stats *stats)
 {
 	double avg = stats->sum / run_count;
+	double variance = (stats->sum_sq - stats->sum*avg)/(run_count - 1);
+	double variance_mean = variance / run_count;
 
-	return sqrt(stats->sum_sq/run_count - avg*avg);
+	return sqrt(variance_mean);
 }
 
 struct stats			event_res_stats[MAX_COUNTERS][3];
-struct stats			event_scaled_stats[MAX_COUNTERS];
 struct stats			runtime_nsecs_stats;
 struct stats			walltime_nsecs_stats;
 struct stats			runtime_cycles_stats;
@@ -343,11 +357,10 @@ static void abs_printout(int counter, double avg, double stddev)
 static void print_counter(int counter)
 {
 	double avg, stddev;
-	int scaled;
+	int scaled = event_scaled[counter];
 
 	avg    = avg_stats(&event_res_stats[counter][0]);
 	stddev = stddev_stats(&event_res_stats[counter][0]);
-	scaled = avg_stats(&event_scaled_stats[counter]);
 
 	if (scaled == -1) {
 		fprintf(stderr, " %14s  %-24s\n",
