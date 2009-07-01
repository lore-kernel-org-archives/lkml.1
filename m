Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbZGAJp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbZGAJp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbZGAJpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:45:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:58326 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642AbZGAJps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:45:48 -0400
Subject: [PATCH 1/6 -tip] perf stat: define MATCH_EVENT for easy attrs
 checking
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246440815.3403.3.camel@hpdv5.satnam>
References: <1246440815.3403.3.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 15:05:09 +0530
Message-Id: <1246440909.3403.5.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


MATCH_EVENT is useful :
 1. for multiple attrs checking
 2. avoid repetition of PERF_TYPE_ and PERF_COUNT_ and save space
 3. avoids line breakage

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/builtin-stat.c |   27 ++++++++++-----------------
 1 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2e03524..6bf2b80 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -96,6 +96,10 @@ static u64			walltime_nsecs_noise;
 static u64			runtime_cycles_avg;
 static u64			runtime_cycles_noise;
 
+#define MATCH_EVENT(t, c, counter)			\
+	(attrs[counter].type == PERF_TYPE_##t &&	\
+	 attrs[counter].config == PERF_COUNT_##c)
+
 #define ERR_PERF_OPEN \
 "Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n"
 
@@ -132,13 +136,8 @@ static void create_perf_stat_counter(int counter, int pid)
  */
 static inline int nsec_counter(int counter)
 {
-	if (attrs[counter].type != PERF_TYPE_SOFTWARE)
-		return 0;
-
-	if (attrs[counter].config == PERF_COUNT_SW_CPU_CLOCK)
-		return 1;
-
-	if (attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK)
+	if (MATCH_EVENT(SOFTWARE, SW_CPU_CLOCK, counter) ||
+	    MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter))
 		return 1;
 
 	return 0;
@@ -192,11 +191,9 @@ static void read_counter(int counter)
 	/*
 	 * Save the full runtime - to allow normalization during printout:
 	 */
-	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
-		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK)
+	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter))
 		runtime_nsecs[run_idx] = count[0];
-	if (attrs[counter].type == PERF_TYPE_HARDWARE &&
-		attrs[counter].config == PERF_COUNT_HW_CPU_CYCLES)
+	if (MATCH_EVENT(HARDWARE, HW_CPU_CYCLES, counter))
 		runtime_cycles[run_idx] = count[0];
 }
 
@@ -290,9 +287,7 @@ static void nsec_printout(int counter, u64 *count, u64 *noise)
 
 	fprintf(stderr, " %14.6f  %-24s", msecs, event_name(counter));
 
-	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
-		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK) {
-
+	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter)) {
 		if (walltime_nsecs_avg)
 			fprintf(stderr, " # %10.3f CPUs ",
 				(double)count[0] / (double)walltime_nsecs_avg);
@@ -305,9 +300,7 @@ static void abs_printout(int counter, u64 *count, u64 *noise)
 	fprintf(stderr, " %14Ld  %-24s", count[0], event_name(counter));
 
 	if (runtime_cycles_avg &&
-		attrs[counter].type == PERF_TYPE_HARDWARE &&
-			attrs[counter].config == PERF_COUNT_HW_INSTRUCTIONS) {
-
+	    MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
 		fprintf(stderr, " # %10.3f IPC  ",
 			(double)count[0] / (double)runtime_cycles_avg);
 	} else {
-- 
1.6.0.6



