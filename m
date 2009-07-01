Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbZGAJrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbZGAJrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbZGAJqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:46:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:52552 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbZGAJqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:46:54 -0400
Subject: [PATCH 2/6 -tip] perf stat: treat same behaviour for all CYCLES
 and CLOCKS
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246440909.3403.5.camel@hpdv5.satnam>
References: <1246440815.3403.3.camel@hpdv5.satnam>
	 <1246440909.3403.5.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 15:06:17 +0530
Message-Id: <1246440977.3403.7.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For normalization also added SW_CPU_CLOCK and HW_BUS_CYCLES

For nsec_printout also added SW_CPU_CLOCK

Added helper functions to check counter unit as cycles and instructions

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 tools/perf/builtin-stat.c |   49 +++++++++++++++++++++++++++++++-------------
 1 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 6bf2b80..af61c29 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -144,6 +144,29 @@ static inline int nsec_counter(int counter)
 }
 
 /*
+ * Does the counter have cycles as a unit?
+ */
+static inline int cycle_counter(int counter)
+{
+	if (MATCH_EVENT(HARDWARE, HW_CPU_CYCLES, counter) ||
+	    MATCH_EVENT(HARDWARE, HW_BUS_CYCLES, counter))
+		return 1;
+
+	return 0;
+}
+
+/*
+ * Does the counter have instructions as a unit?
+ */
+static inline int instruction_counter(int counter)
+{
+	if (MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter))
+		return 1;
+
+	return 0;
+}
+
+/*
  * Read out the results of a single counter:
  */
 static void read_counter(int counter)
@@ -191,9 +214,9 @@ static void read_counter(int counter)
 	/*
 	 * Save the full runtime - to allow normalization during printout:
 	 */
-	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter))
+	if (nsec_counter(counter))
 		runtime_nsecs[run_idx] = count[0];
-	if (MATCH_EVENT(HARDWARE, HW_CPU_CYCLES, counter))
+	else if (cycle_counter(counter))
 		runtime_cycles[run_idx] = count[0];
 }
 
@@ -287,11 +310,10 @@ static void nsec_printout(int counter, u64 *count, u64 *noise)
 
 	fprintf(stderr, " %14.6f  %-24s", msecs, event_name(counter));
 
-	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter)) {
-		if (walltime_nsecs_avg)
-			fprintf(stderr, " # %10.3f CPUs ",
-				(double)count[0] / (double)walltime_nsecs_avg);
-	}
+	if (nsec_counter(counter) && walltime_nsecs_avg)
+		fprintf(stderr, " # %10.3f CPUs ",
+			(double)count[0] / (double)walltime_nsecs_avg);
+
 	print_noise(count, noise);
 }
 
@@ -299,16 +321,13 @@ static void abs_printout(int counter, u64 *count, u64 *noise)
 {
 	fprintf(stderr, " %14Ld  %-24s", count[0], event_name(counter));
 
-	if (runtime_cycles_avg &&
-	    MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
+	if (instruction_counter(counter) && runtime_cycles_avg)
 		fprintf(stderr, " # %10.3f IPC  ",
 			(double)count[0] / (double)runtime_cycles_avg);
-	} else {
-		if (runtime_nsecs_avg) {
-			fprintf(stderr, " # %10.3f M/sec",
-				(double)count[0]/runtime_nsecs_avg*1000.0);
-		}
-	}
+	else if (runtime_nsecs_avg)
+		fprintf(stderr, " # %10.3f M/sec",
+			(double)count[0]/runtime_nsecs_avg*1000.0);
+
 	print_noise(count, noise);
 }
 
-- 
1.6.0.6



