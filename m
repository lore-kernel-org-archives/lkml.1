Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbZE2JBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbZE2JBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757713AbZE2JB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:01:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:59592 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757337AbZE2JBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:01:25 -0400
Date: Fri, 29 May 2009 09:00:45 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Clean up builtin-stat.c's do_perfstat()
Message-ID: <tip-c04f5e5d7b523f90ee3cdd70a68c4002aaecd3fa@git.kernel.org>
Git-Commit-ID: c04f5e5d7b523f90ee3cdd70a68c4002aaecd3fa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 09:00:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c04f5e5d7b523f90ee3cdd70a68c4002aaecd3fa
Gitweb:     http://git.kernel.org/tip/c04f5e5d7b523f90ee3cdd70a68c4002aaecd3fa
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 29 May 2009 09:10:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 May 2009 09:11:49 +0200

perf_counter tools: Clean up builtin-stat.c's do_perfstat()

[ Impact: cleanup ]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-stat.c |  116 +++++++++++++++++------------
 1 files changed, 67 insertions(+), 49 deletions(-)

diff --git a/Documentation/perf_counter/builtin-stat.c b/Documentation/perf_counter/builtin-stat.c
index ac14086..6a29361 100644
--- a/Documentation/perf_counter/builtin-stat.c
+++ b/Documentation/perf_counter/builtin-stat.c
@@ -109,11 +109,75 @@ static void create_perfstat_counter(int counter)
 	}
 }
 
+/*
+ * Does the counter have nsecs as a unit?
+ */
+static inline int nsec_counter(int counter)
+{
+	if (event_id[counter] == EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_CLOCK))
+		return 1;
+	if (event_id[counter] == EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK))
+		return 1;
+
+	return 0;
+}
+
+/*
+ * Print out the results of a single counter:
+ */
+static void print_counter(int counter)
+{
+	__u64 count[3], single_count[3];
+	ssize_t res;
+	int cpu, nv;
+	int scaled;
+
+	count[0] = count[1] = count[2] = 0;
+	nv = scale ? 3 : 1;
+	for (cpu = 0; cpu < nr_cpus; cpu ++) {
+		res = read(fd[cpu][counter], single_count, nv * sizeof(__u64));
+		assert(res == nv * sizeof(__u64));
+
+		count[0] += single_count[0];
+		if (scale) {
+			count[1] += single_count[1];
+			count[2] += single_count[2];
+		}
+	}
+
+	scaled = 0;
+	if (scale) {
+		if (count[2] == 0) {
+			fprintf(stderr, " %14s  %-20s\n",
+				"<not counted>", event_name(counter));
+			return;
+		}
+		if (count[2] < count[1]) {
+			scaled = 1;
+			count[0] = (unsigned long long)
+				((double)count[0] * count[1] / count[2] + 0.5);
+		}
+	}
+
+	if (nsec_counter(counter)) {
+		double msecs = (double)count[0] / 1000000;
+
+		fprintf(stderr, " %14.6f  %-20s (msecs)",
+			msecs, event_name(counter));
+	} else {
+		fprintf(stderr, " %14Ld  %-20s (events)",
+			count[0], event_name(counter));
+	}
+	if (scaled)
+		fprintf(stderr, "  (scaled from %.2f%%)",
+			(double) count[2] / count[1] * 100);
+	fprintf(stderr, "\n");
+}
+
 static int do_perfstat(int argc, const char **argv)
 {
 	unsigned long long t0, t1;
 	int counter;
-	ssize_t res;
 	int status;
 	int pid;
 
@@ -149,55 +213,10 @@ static int do_perfstat(int argc, const char **argv)
 		argv[0]);
 	fprintf(stderr, "\n");
 
-	for (counter = 0; counter < nr_counters; counter++) {
-		int cpu, nv;
-		__u64 count[3], single_count[3];
-		int scaled;
-
-		count[0] = count[1] = count[2] = 0;
-		nv = scale ? 3 : 1;
-		for (cpu = 0; cpu < nr_cpus; cpu ++) {
-			res = read(fd[cpu][counter],
-				   single_count, nv * sizeof(__u64));
-			assert(res == nv * sizeof(__u64));
-
-			count[0] += single_count[0];
-			if (scale) {
-				count[1] += single_count[1];
-				count[2] += single_count[2];
-			}
-		}
-
-		scaled = 0;
-		if (scale) {
-			if (count[2] == 0) {
-				fprintf(stderr, " %14s  %-20s\n",
-					"<not counted>", event_name(counter));
-				continue;
-			}
-			if (count[2] < count[1]) {
-				scaled = 1;
-				count[0] = (unsigned long long)
-					((double)count[0] * count[1] / count[2] + 0.5);
-			}
-		}
-
-		if (event_id[counter] == EID(PERF_TYPE_SOFTWARE, PERF_COUNT_CPU_CLOCK) ||
-		    event_id[counter] == EID(PERF_TYPE_SOFTWARE, PERF_COUNT_TASK_CLOCK)) {
+	for (counter = 0; counter < nr_counters; counter++)
+		print_counter(counter);
 
-			double msecs = (double)count[0] / 1000000;
 
-			fprintf(stderr, " %14.6f  %-20s (msecs)",
-				msecs, event_name(counter));
-		} else {
-			fprintf(stderr, " %14Ld  %-20s (events)",
-				count[0], event_name(counter));
-		}
-		if (scaled)
-			fprintf(stderr, "  (scaled from %.2f%%)",
-				(double) count[2] / count[1] * 100);
-		fprintf(stderr, "\n");
-	}
 	fprintf(stderr, "\n");
 	fprintf(stderr, " Wall-clock time elapsed: %12.6f msecs\n",
 			(double)(t1-t0)/1e6);
@@ -212,7 +231,6 @@ static void skip_signal(int signo)
 
 static const char * const stat_usage[] = {
 	"perf stat [<options>] <command>",
-	"perf stat [<options>] -- <command> [<options>]",
 	NULL
 };
 
