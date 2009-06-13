Return-Path: <linux-kernel-owner+w=401wt.eu-S1763673AbZFMOvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763673AbZFMOvf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762826AbZFMOuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:50:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:49095 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762821AbZFMOuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:50:19 -0400
Date: Sat, 13 Jun 2009 14:49:44 GMT
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
Subject: [tip:perfcounters/core] perf stat: Reorganize output
Message-ID: <tip-44175b6f397a6724121eeaf0f072e2c912a46614@git.kernel.org>
Git-Commit-ID: 44175b6f397a6724121eeaf0f072e2c912a46614
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 13 Jun 2009 14:49:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44175b6f397a6724121eeaf0f072e2c912a46614
Gitweb:     http://git.kernel.org/tip/44175b6f397a6724121eeaf0f072e2c912a46614
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 13 Jun 2009 13:35:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 13 Jun 2009 13:40:03 +0200

perf stat: Reorganize output

 - use IPC for the instruction normalization output
 - CPUs for the CPU utilization factor value.
 - print out time elapsed like the other rows
 - tidy up the task-clocks/cpu-clocks printout

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c      |   67 ++++++++++++++++++++++++----------------
 tools/perf/util/parse-events.c |    4 +-
 2 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c43e4a9..c128048 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -184,6 +184,40 @@ static void read_counter(int counter)
 		runtime_cycles = count[0];
 }
 
+static void nsec_printout(int counter, __u64 *count)
+{
+	double msecs = (double)count[0] / 1000000;
+
+	fprintf(stderr, " %14.6f  %-20s", msecs, event_name(counter));
+
+	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
+		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK) {
+
+		if (walltime_nsecs)
+			fprintf(stderr, " # %10.3f CPUs",
+				(double)count[0] / (double)walltime_nsecs);
+	}
+}
+
+static void abs_printout(int counter, __u64 *count)
+{
+	fprintf(stderr, " %14Ld  %-20s", count[0], event_name(counter));
+
+	if (runtime_cycles &&
+		attrs[counter].type == PERF_TYPE_HARDWARE &&
+			attrs[counter].config == PERF_COUNT_HW_INSTRUCTIONS) {
+
+		fprintf(stderr, " # %10.3f IPC",
+			(double)count[0] / (double)runtime_cycles);
+
+		return;
+	}
+
+	if (runtime_nsecs)
+		fprintf(stderr, " # %10.3f M/sec",
+			(double)count[0]/runtime_nsecs*1000.0);
+}
+
 /*
  * Print out the results of a single counter:
  */
@@ -201,35 +235,15 @@ static void print_counter(int counter)
 		return;
 	}
 
-	if (nsec_counter(counter)) {
-		double msecs = (double)count[0] / 1000000;
-
-		fprintf(stderr, " %14.6f  %-20s",
-			msecs, event_name(counter));
-		if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
-			attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK) {
+	if (nsec_counter(counter))
+		nsec_printout(counter, count);
+	else
+		abs_printout(counter, count);
 
-			if (walltime_nsecs)
-				fprintf(stderr, " # %11.3f CPU utilization factor",
-					(double)count[0] / (double)walltime_nsecs);
-		}
-	} else {
-		fprintf(stderr, " %14Ld  %-20s",
-			count[0], event_name(counter));
-		if (runtime_nsecs)
-			fprintf(stderr, " # %11.3f M/sec",
-				(double)count[0]/runtime_nsecs*1000.0);
-		if (runtime_cycles &&
-			attrs[counter].type == PERF_TYPE_HARDWARE &&
-				attrs[counter].config == PERF_COUNT_HW_INSTRUCTIONS) {
-
-			fprintf(stderr, " # %1.3f per cycle",
-				(double)count[0] / (double)runtime_cycles);
-		}
-	}
 	if (scaled)
 		fprintf(stderr, "  (scaled from %.2f%%)",
 			(double) count[2] / count[1] * 100);
+
 	fprintf(stderr, "\n");
 }
 
@@ -290,8 +304,7 @@ static int do_perf_stat(int argc, const char **argv)
 
 
 	fprintf(stderr, "\n");
-	fprintf(stderr, " Wall-clock time elapsed: %12.6f msecs\n",
-			(double)(t1-t0)/1e6);
+	fprintf(stderr, " %14.9f  seconds time elapsed.\n", (double)(t1-t0)/1e9);
 	fprintf(stderr, "\n");
 
 	return 0;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5a72586..f0c9f26 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -63,8 +63,8 @@ static char *hw_event_names[] = {
 };
 
 static char *sw_event_names[] = {
-	"cpu-clock-ticks",
-	"task-clock-ticks",
+	"cpu-clock-msecs",
+	"task-clock-msecs",
 	"page-faults",
 	"context-switches",
 	"CPU-migrations",
