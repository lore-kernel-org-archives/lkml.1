Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbZFGPNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbZFGPNX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 11:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbZFGPNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 11:13:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:50139 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673AbZFGPNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 11:13:18 -0400
Date: Sun, 7 Jun 2009 15:12:31 GMT
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
Subject: [tip:perfcounters/core] perf stat: Continue even on counter creation error
Message-ID: <tip-743ee1f80434138495bbb95ffb897acf46b51d54@git.kernel.org>
Git-Commit-ID: 743ee1f80434138495bbb95ffb897acf46b51d54
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 15:12:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  743ee1f80434138495bbb95ffb897acf46b51d54
Gitweb:     http://git.kernel.org/tip/743ee1f80434138495bbb95ffb897acf46b51d54
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 7 Jun 2009 17:06:46 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 7 Jun 2009 17:08:59 +0200

perf stat: Continue even on counter creation error

Before:

 $ perf stat ~/hackbench 5

 error: syscall returned with -1 (No such device)

After:

 $ perf stat ~/hackbench 5
 Time: 1.640

 Performance counter stats for '/home/mingo/hackbench 5':

    6524.570382  task-clock-ticks     #       3.838 CPU utilization factor
          35704  context-switches     #       0.005 M/sec
            191  CPU-migrations       #       0.000 M/sec
           8958  page-faults          #       0.001 M/sec
  <not counted>  cycles
  <not counted>  instructions
  <not counted>  cache-references
  <not counted>  cache-misses

 Wall-clock time elapsed:  1699.999995 msecs

Also add -v (--verbose) option to allow the printing of failed
counter opens.

Plus dont print 'inf' if wall-time is zero (due to jiffies granularity),
instead skip the printing of the CPU utilization factor.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2cbf5a1..184ff95 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -59,6 +59,7 @@ static struct perf_counter_attr default_attrs[MAX_COUNTERS] = {
 
 static int			system_wide			=  0;
 static int			inherit				=  1;
+static int			verbose				=  0;
 
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
@@ -83,7 +84,7 @@ static __u64			event_scaled[MAX_COUNTERS];
 static __u64			runtime_nsecs;
 static __u64			walltime_nsecs;
 
-static void create_perfstat_counter(int counter)
+static void create_perf_stat_counter(int counter)
 {
 	struct perf_counter_attr *attr = attrs + counter;
 
@@ -95,10 +96,8 @@ static void create_perfstat_counter(int counter)
 		int cpu;
 		for (cpu = 0; cpu < nr_cpus; cpu ++) {
 			fd[cpu][counter] = sys_perf_counter_open(attr, -1, cpu, -1, 0);
-			if (fd[cpu][counter] < 0) {
-				printf("perfstat error: syscall returned with %d (%s)\n",
-						fd[cpu][counter], strerror(errno));
-				exit(-1);
+			if (fd[cpu][counter] < 0 && verbose) {
+				printf("Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n", counter, fd[cpu][counter], strerror(errno));
 			}
 		}
 	} else {
@@ -106,10 +105,8 @@ static void create_perfstat_counter(int counter)
 		attr->disabled	= 1;
 
 		fd[0][counter] = sys_perf_counter_open(attr, 0, -1, -1, 0);
-		if (fd[0][counter] < 0) {
-			printf("perfstat error: syscall returned with %d (%s)\n",
-					fd[0][counter], strerror(errno));
-			exit(-1);
+		if (fd[0][counter] < 0 && verbose) {
+			printf("Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n", counter, fd[0][counter], strerror(errno));
 		}
 	}
 }
@@ -147,6 +144,9 @@ static void read_counter(int counter)
 
 	nv = scale ? 3 : 1;
 	for (cpu = 0; cpu < nr_cpus; cpu ++) {
+		if (fd[cpu][counter] < 0)
+			continue;
+
 		res = read(fd[cpu][counter], single_count, nv * sizeof(__u64));
 		assert(res == nv * sizeof(__u64));
 
@@ -204,8 +204,9 @@ static void print_counter(int counter)
 		if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
 			attrs[counter].config == PERF_COUNT_TASK_CLOCK) {
 
-			fprintf(stderr, " # %11.3f CPU utilization factor",
-				(double)count[0] / (double)walltime_nsecs);
+			if (walltime_nsecs)
+				fprintf(stderr, " # %11.3f CPU utilization factor",
+					(double)count[0] / (double)walltime_nsecs);
 		}
 	} else {
 		fprintf(stderr, " %14Ld  %-20s",
@@ -220,7 +221,7 @@ static void print_counter(int counter)
 	fprintf(stderr, "\n");
 }
 
-static int do_perfstat(int argc, const char **argv)
+static int do_perf_stat(int argc, const char **argv)
 {
 	unsigned long long t0, t1;
 	int counter;
@@ -232,7 +233,7 @@ static int do_perfstat(int argc, const char **argv)
 		nr_cpus = 1;
 
 	for (counter = 0; counter < nr_counters; counter++)
-		create_perfstat_counter(counter);
+		create_perf_stat_counter(counter);
 
 	/*
 	 * Enable counters and exec the command:
@@ -305,6 +306,8 @@ static const struct option options[] = {
 			    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('S', "scale", &scale,
 			    "scale/normalize counters"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show counter open errors, etc)"),
 	OPT_END()
 };
 
@@ -335,5 +338,5 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 	signal(SIGALRM, skip_signal);
 	signal(SIGABRT, skip_signal);
 
-	return do_perfstat(argc, argv);
+	return do_perf_stat(argc, argv);
 }
