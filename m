Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbZIDSeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbZIDSeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 14:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbZIDSef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 14:34:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:51581 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173AbZIDSef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 14:34:35 -0400
Date: Fri, 4 Sep 2009 18:34:03 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf stat: Clean up statistics calculations a bit more
Message-ID: <tip-849abde92bd3314a4894f2b4f70b30c2accf8653@git.kernel.org>
Git-Commit-ID: 849abde92bd3314a4894f2b4f70b30c2accf8653
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 18:34:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  849abde92bd3314a4894f2b4f70b30c2accf8653
Gitweb:     http://git.kernel.org/tip/849abde92bd3314a4894f2b4f70b30c2accf8653
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 4 Sep 2009 18:23:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 20:27:26 +0200

perf stat: Clean up statistics calculations a bit more

Remove some, now useless, global storage.
Don't calculate the stddev when not needed.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c |   31 ++++++++++++++-----------------
 1 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 32b5c00..61b8282 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -74,7 +74,6 @@ static int			null_run			=  0;
 
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
-static u64			event_res[MAX_COUNTERS][3];
 static int			event_scaled[MAX_COUNTERS];
 
 struct stats
@@ -179,14 +178,12 @@ static inline int nsec_counter(int counter)
  */
 static void read_counter(int counter)
 {
-	u64 *count, single_count[3];
+	u64 count[3], single_count[3];
 	unsigned int cpu;
 	size_t res, nv;
 	int scaled;
 	int i;
 
-	count = event_res[counter];
-
 	count[0] = count[1] = count[2] = 0;
 
 	nv = scale ? 3 : 1;
@@ -318,13 +315,16 @@ static int run_perf_stat(int argc __used, const char **argv)
 	return WEXITSTATUS(status);
 }
 
-static void print_noise(double avg, double stddev)
+static void print_noise(int counter, double avg)
 {
-	if (run_count > 1)
-		fprintf(stderr, "   ( +- %7.3f%% )", 100*stddev / avg);
+	if (run_count == 1)
+		return;
+
+	fprintf(stderr, "   ( +- %7.3f%% )",
+			100 * stddev_stats(&event_res_stats[counter][0]) / avg);
 }
 
-static void nsec_printout(int counter, double avg, double stddev)
+static void nsec_printout(int counter, double avg)
 {
 	double msecs = avg / 1e6;
 
@@ -334,10 +334,9 @@ static void nsec_printout(int counter, double avg, double stddev)
 		fprintf(stderr, " # %10.3f CPUs ",
 				avg / avg_stats(&walltime_nsecs_stats));
 	}
-	print_noise(avg, stddev);
 }
 
-static void abs_printout(int counter, double avg, double stddev)
+static void abs_printout(int counter, double avg)
 {
 	fprintf(stderr, " %14.0f  %-24s", avg, event_name(counter));
 
@@ -348,7 +347,6 @@ static void abs_printout(int counter, double avg, double stddev)
 		fprintf(stderr, " # %10.3f M/sec",
 				1000.0 * avg / avg_stats(&runtime_nsecs_stats));
 	}
-	print_noise(avg, stddev);
 }
 
 /*
@@ -356,12 +354,9 @@ static void abs_printout(int counter, double avg, double stddev)
  */
 static void print_counter(int counter)
 {
-	double avg, stddev;
+	double avg = avg_stats(&event_res_stats[counter][0]);
 	int scaled = event_scaled[counter];
 
-	avg    = avg_stats(&event_res_stats[counter][0]);
-	stddev = stddev_stats(&event_res_stats[counter][0]);
-
 	if (scaled == -1) {
 		fprintf(stderr, " %14s  %-24s\n",
 			"<not counted>", event_name(counter));
@@ -369,9 +364,11 @@ static void print_counter(int counter)
 	}
 
 	if (nsec_counter(counter))
-		nsec_printout(counter, avg, stddev);
+		nsec_printout(counter, avg);
 	else
-		abs_printout(counter, avg, stddev);
+		abs_printout(counter, avg);
+
+	print_noise(counter, avg);
 
 	if (scaled) {
 		double avg_enabled, avg_running;
