Return-Path: <linux-kernel-owner+w=401wt.eu-S1761500AbZFZVms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761500AbZFZVms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 17:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758941AbZFZVmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 17:42:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:46720 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759529AbZFZVmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 17:42:37 -0400
Subject: [PATCH 1/3 -tip] perf stat: fix stat output
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246051852.2988.8.camel@hpdv5.satnam>
References: <1246051852.2988.8.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 03:02:07 +0530
Message-Id: <1246051927.2988.10.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Increase size for event name to handle big names like 'L1-d$-prefetch-misses'

Changed scaled as a multiplicative factor is more expressive,
than the percentage of from where we scale up.

Also aligned scaled otherwise sometimes it looks like :

            384  iTLB-load-misses           (4.74x scaled)
         452029  branch-loads               (8.00x scaled)
           5892  branch-load-misses         (20.39x scaled)
         972315  iTLB-loads                 (3.24x scaled)

Before :
         150708  L1-d$-stores          (scaled from 23.57%)
         428804  L1-d$-prefetches      (scaled from 23.47%)
         314446  L1-d$-prefetch-misses  (scaled from 23.42%)
      252626137  L1-i$-loads           (scaled from 23.24%)
        5297550  dTLB-load-misses      (scaled from 23.96%)
      106992392  branch-loads          (scaled from 23.67%)
        5239561  branch-load-misses    (scaled from 23.43%)

After :

        1731713  L1-d$-loads               (  14.25x scaled)
          44241  L1-d$-prefetches          (   3.88x scaled)
          21076  L1-d$-prefetch-misses     (   3.40x scaled)
        5789421  L1-i$-loads               (   3.78x scaled)
          29645  dTLB-load-misses          (   2.95x scaled)
         461474  branch-loads              (   6.52x scaled)
           7493  branch-load-misses        (  26.57x scaled)

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/builtin-stat.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 8420ec5..9ff9dd5 100644
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
@@ -250,7 +251,7 @@ static void nsec_printout(int counter, u64 *count, u64 *noise)
 {
 	double msecs = (double)count[0] / 1000000;
 
-	fprintf(stderr, " %14.6f  %-20s", msecs, event_name(counter));
+	fprintf(stderr, " %14.6f  %-24s", msecs, event_name(counter));
 
 	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
 		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK) {
@@ -264,7 +265,7 @@ static void nsec_printout(int counter, u64 *count, u64 *noise)
 
 static void abs_printout(int counter, u64 *count, u64 *noise)
 {
-	fprintf(stderr, " %14Ld  %-20s", count[0], event_name(counter));
+	fprintf(stderr, " %14Ld  %-24s", count[0], event_name(counter));
 
 	if (runtime_cycles_avg &&
 		attrs[counter].type == PERF_TYPE_HARDWARE &&
@@ -294,7 +295,7 @@ static void print_counter(int counter)
 	scaled = event_scaled_avg[counter];
 
 	if (scaled == -1) {
-		fprintf(stderr, " %14s  %-20s\n",
+		fprintf(stderr, " %14s  %-24s\n",
 			"<not counted>", event_name(counter));
 		return;
 	}
@@ -305,8 +306,7 @@ static void print_counter(int counter)
 		abs_printout(counter, count, noise);
 
 	if (scaled)
-		fprintf(stderr, "  (scaled from %.2f%%)",
-			(double) count[2] / count[1] * 100);
+		fprintf(stderr, "  (%7.2fx scaled)", (double)count[1]/count[2]);
 
 	fprintf(stderr, "\n");
 }
@@ -417,7 +417,6 @@ static void print_stat(int argc, const char **argv)
 	for (counter = 0; counter < nr_counters; counter++)
 		print_counter(counter);
 
-
 	fprintf(stderr, "\n");
 	fprintf(stderr, " %14.9f  seconds time elapsed.\n",
 			(double)walltime_nsecs_avg/1e9);
-- 
1.6.0.6



