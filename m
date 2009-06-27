Return-Path: <linux-kernel-owner+w=401wt.eu-S1757281AbZF0RcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbZF0RcS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 13:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbZF0RcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 13:32:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:53314 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228AbZF0RcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 13:32:07 -0400
Date: Sat, 27 Jun 2009 17:31:20 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, jaswinder@kernel.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, peterz@infradead.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246051927.2988.10.camel@hpdv5.satnam>
References: <1246051927.2988.10.camel@hpdv5.satnam>
Subject: [tip:perfcounters/urgent] perf stat: Improve output
Message-ID: <tip-6e750a8fc009fd0ae98704525d1d8e80d60e8cc9@git.kernel.org>
Git-Commit-ID: 6e750a8fc009fd0ae98704525d1d8e80d60e8cc9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 27 Jun 2009 17:31:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e750a8fc009fd0ae98704525d1d8e80d60e8cc9
Gitweb:     http://git.kernel.org/tip/6e750a8fc009fd0ae98704525d1d8e80d60e8cc9
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sat, 27 Jun 2009 03:02:07 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 27 Jun 2009 18:39:41 +0200

perf stat: Improve output

Increase size for event name to handle bigger names like
'L1-d$-prefetch-misses'

Changed scaled counters from percentage to a multiplicative
factor because the latter is more expressive.

Also aligned the scaling factor, otherwise sometimes it looks
like:

            384  iTLB-load-misses           (4.74x scaled)
         452029  branch-loads               (8.00x scaled)
           5892  branch-load-misses         (20.39x scaled)
         972315  iTLB-loads                 (3.24x scaled)

Before:
         150708  L1-d$-stores          (scaled from 23.57%)
         428804  L1-d$-prefetches      (scaled from 23.47%)
         314446  L1-d$-prefetch-misses  (scaled from 23.42%)
      252626137  L1-i$-loads           (scaled from 23.24%)
        5297550  dTLB-load-misses      (scaled from 23.96%)
      106992392  branch-loads          (scaled from 23.67%)
        5239561  branch-load-misses    (scaled from 23.43%)

After:
        1731713  L1-d$-loads               (  14.25x scaled)
          44241  L1-d$-prefetches          (   3.88x scaled)
          21076  L1-d$-prefetch-misses     (   3.40x scaled)
        5789421  L1-i$-loads               (   3.78x scaled)
          29645  dTLB-load-misses          (   2.95x scaled)
         461474  branch-loads              (   6.52x scaled)
           7493  branch-load-misses        (  26.57x scaled)

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1246051927.2988.10.camel@hpdv5.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 52c176c..3840a70 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -32,6 +32,7 @@
  *   Wu Fengguang <fengguang.wu@intel.com>
  *   Mike Galbraith <efault@gmx.de>
  *   Paul Mackerras <paulus@samba.org>
+ *   Jaswinder Singh Rajput <jaswinder@kernel.org>
  *
  * Released under the GPL v2. (and only v2, not any later version)
  */
@@ -251,7 +252,7 @@ static void nsec_printout(int counter, u64 *count, u64 *noise)
 {
 	double msecs = (double)count[0] / 1000000;
 
-	fprintf(stderr, " %14.6f  %-20s", msecs, event_name(counter));
+	fprintf(stderr, " %14.6f  %-24s", msecs, event_name(counter));
 
 	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
 		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK) {
@@ -265,7 +266,7 @@ static void nsec_printout(int counter, u64 *count, u64 *noise)
 
 static void abs_printout(int counter, u64 *count, u64 *noise)
 {
-	fprintf(stderr, " %14Ld  %-20s", count[0], event_name(counter));
+	fprintf(stderr, " %14Ld  %-24s", count[0], event_name(counter));
 
 	if (runtime_cycles_avg &&
 		attrs[counter].type == PERF_TYPE_HARDWARE &&
@@ -295,7 +296,7 @@ static void print_counter(int counter)
 	scaled = event_scaled_avg[counter];
 
 	if (scaled == -1) {
-		fprintf(stderr, " %14s  %-20s\n",
+		fprintf(stderr, " %14s  %-24s\n",
 			"<not counted>", event_name(counter));
 		return;
 	}
@@ -306,8 +307,7 @@ static void print_counter(int counter)
 		abs_printout(counter, count, noise);
 
 	if (scaled)
-		fprintf(stderr, "  (scaled from %.2f%%)",
-			(double) count[2] / count[1] * 100);
+		fprintf(stderr, "  (%7.2fx scaled)", (double)count[1]/count[2]);
 
 	fprintf(stderr, "\n");
 }
@@ -421,7 +421,6 @@ static void print_stat(int argc, const char **argv)
 	for (counter = 0; counter < nr_counters; counter++)
 		print_counter(counter);
 
-
 	fprintf(stderr, "\n");
 	fprintf(stderr, " %14.9f  seconds time elapsed",
 			(double)walltime_nsecs_avg/1e9);
