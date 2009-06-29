Return-Path: <linux-kernel-owner+w=401wt.eu-S1751611AbZF2LOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbZF2LOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 07:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757363AbZF2LN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 07:13:58 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:50129 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbZF2LN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 07:13:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19016.41425.814043.870352@cargo.ozlabs.ibm.com>
Date: Mon, 29 Jun 2009 21:13:21 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] perf_counter: tools: Reduce perf stat overhead
In-Reply-To: <19016.41130.429944.316897@cargo.ozlabs.ibm.com>
References: <19016.41130.429944.316897@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present, perf stat creates its counters on the perf process.  Thus
the counters count the fork and various other activity in both the
parent and child, such as the resolver overhead for resolving PLT
entries for any libc functions that haven't been called before, such
as execvp.

This reduces the overhead by creating the counters on the child process
after the fork, using a couple of pipes to synchronize so that the
child process waits until the parent has created the counters before
doing the exec.  To eliminate the PLT resolution overhead on calling
execvp, this does a dummy execvp first which will always fail.

With this, the overhead of executing a program goes down from over
4800 instructions to about 90 instructions on powerpc (32-bit).
This was measured with a statically-linked program written in
assembler which only does the 3 instructions needed to call _exit(0).

Before:

$ perf stat -e 0:1:u ./three

 Performance counter stats for './three':

           4858  instructions

    0.001274523  seconds time elapsed

After:

$ perf stat -e 0:1:u ./three

 Performance counter stats for './three':

             92  instructions

    0.000468153  seconds time elapsed

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 tools/perf/builtin-stat.c |   64 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 3e5ea4e..f0260ac 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -99,7 +99,7 @@ static u64			runtime_cycles_noise;
 #define ERR_PERF_OPEN \
 "Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n"
 
-static void create_perf_stat_counter(int counter)
+static void create_perf_stat_counter(int counter, int pid)
 {
 	struct perf_counter_attr *attr = attrs + counter;
 
@@ -119,7 +119,7 @@ static void create_perf_stat_counter(int counter)
 		attr->inherit	= inherit;
 		attr->disabled	= 1;
 
-		fd[0][counter] = sys_perf_counter_open(attr, 0, -1, -1, 0);
+		fd[0][counter] = sys_perf_counter_open(attr, pid, -1, -1, 0);
 		if (fd[0][counter] < 0 && verbose)
 			fprintf(stderr, ERR_PERF_OPEN, counter,
 				fd[0][counter], strerror(errno));
@@ -205,12 +205,58 @@ static int run_perf_stat(int argc, const char **argv)
 	int status = 0;
 	int counter;
 	int pid;
+	int child_ready_pipe[2], go_pipe[2];
+	char buf;
 
 	if (!system_wide)
 		nr_cpus = 1;
 
+	if (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0) {
+		perror("failed to create pipes");
+		exit(1);
+	}
+
+	if ((pid = fork()) < 0)
+		perror("failed to fork");
+
+	if (!pid) {
+		close(child_ready_pipe[0]);
+		close(go_pipe[1]);
+		fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);
+
+		/*
+		 * Do a dummy execvp to get the PLT entry resolved,
+		 * so we avoid the resolver overhead on the real
+		 * execvp call.
+		 */
+		execvp("", (char **)argv);
+
+		/*
+		 * Tell the parent we're ready to go
+		 */
+		close(child_ready_pipe[1]);
+
+		/*
+		 * Wait until the parent tells us to go.
+		 */
+		read(go_pipe[0], &buf, 1);
+
+		execvp(argv[0], (char **)argv);
+
+		perror(argv[0]);
+		exit(-1);
+	}
+
+	/*
+	 * Wait for the child to be ready to exec.
+	 */
+	close(child_ready_pipe[1]);
+	close(go_pipe[0]);
+	read(child_ready_pipe[0], &buf, 1);
+	close(child_ready_pipe[0]);
+
 	for (counter = 0; counter < nr_counters; counter++)
-		create_perf_stat_counter(counter);
+		create_perf_stat_counter(counter, pid);
 
 	/*
 	 * Enable counters and exec the command:
@@ -218,19 +264,9 @@ static int run_perf_stat(int argc, const char **argv)
 	t0 = rdclock();
 	prctl(PR_TASK_PERF_COUNTERS_ENABLE);
 
-	if ((pid = fork()) < 0)
-		perror("failed to fork");
-
-	if (!pid) {
-		if (execvp(argv[0], (char **)argv)) {
-			perror(argv[0]);
-			exit(-1);
-		}
-	}
-
+	close(go_pipe[1]);
 	wait(&status);
 
-	prctl(PR_TASK_PERF_COUNTERS_DISABLE);
 	t1 = rdclock();
 
 	walltime_nsecs[run_idx] = t1 - t0;
-- 
1.6.0.4

