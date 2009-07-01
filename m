Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbZGALbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbZGALbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbZGALbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:31:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:53134 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbZGALbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:31:10 -0400
Date: Wed, 1 Jul 2009 11:30:33 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, jaswinder@kernel.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, peterz@infradead.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246440909.3403.5.camel@hpdv5.satnam>
References: <1246440909.3403.5.camel@hpdv5.satnam>
Subject: [tip:perfcounters/urgent] perf stat: Define MATCH_EVENT for easy attr checking
Message-ID: <tip-b9ebdcc0ce1c676ebf5dc4f6df6b440d8fcf88ab@git.kernel.org>
Git-Commit-ID: b9ebdcc0ce1c676ebf5dc4f6df6b440d8fcf88ab
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 11:30:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9ebdcc0ce1c676ebf5dc4f6df6b440d8fcf88ab
Gitweb:     http://git.kernel.org/tip/b9ebdcc0ce1c676ebf5dc4f6df6b440d8fcf88ab
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Wed, 1 Jul 2009 15:05:09 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 13:28:38 +0200

perf stat: Define MATCH_EVENT for easy attr checking

MATCH_EVENT is useful:

 1. for multiple attrs checking
 2. avoid repetition of PERF_TYPE_ and PERF_COUNT_ and save space
 3. avoids line breakage

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1246440909.3403.5.camel@hpdv5.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c |   27 ++++++++++-----------------
 1 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 095a90e..01cc07e 100644
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
 
@@ -133,13 +137,8 @@ static void create_perf_stat_counter(int counter, int pid)
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
@@ -194,11 +193,9 @@ static void read_counter(int counter)
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
 
@@ -292,9 +289,7 @@ static void nsec_printout(int counter, u64 *count, u64 *noise)
 
 	fprintf(stderr, " %14.6f  %-24s", msecs, event_name(counter));
 
-	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
-		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK) {
-
+	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter)) {
 		if (walltime_nsecs_avg)
 			fprintf(stderr, " # %10.3f CPUs ",
 				(double)count[0] / (double)walltime_nsecs_avg);
@@ -307,9 +302,7 @@ static void abs_printout(int counter, u64 *count, u64 *noise)
 	fprintf(stderr, " %14Ld  %-24s", count[0], event_name(counter));
 
 	if (runtime_cycles_avg &&
-		attrs[counter].type == PERF_TYPE_HARDWARE &&
-			attrs[counter].config == PERF_COUNT_HW_INSTRUCTIONS) {
-
+	    MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
 		fprintf(stderr, " # %10.3f IPC  ",
 			(double)count[0] / (double)runtime_cycles_avg);
 	} else {
