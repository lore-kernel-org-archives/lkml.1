Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbZF2Uwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbZF2Uwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZF2Uwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:52:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:39099 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbZF2Uwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:52:33 -0400
Date: Mon, 29 Jun 2009 20:51:50 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vince@deater.net, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, vince@deater.net,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <19016.41425.814043.870352@cargo.ozlabs.ibm.com>
References: <19016.41425.814043.870352@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/urgent] perf_counter tools: Reduce perf stat measurement overhead/skew
Message-ID: <tip-051ae7f7344f453616b6b10332d4d8e1d40ed823@git.kernel.org>
Git-Commit-ID: 051ae7f7344f453616b6b10332d4d8e1d40ed823
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 29 Jun 2009 20:51:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  051ae7f7344f453616b6b10332d4d8e1d40ed823
Gitweb:     http://git.kernel.org/tip/051ae7f7344f453616b6b10332d4d8e1d40ed823
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Mon, 29 Jun 2009 21:13:21 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 29 Jun 2009 22:38:09 +0200

perf_counter tools: Reduce perf stat measurement overhead/skew

Vince Weaver reported a 'perf stat' measurement overhead in the
count of retired instructions, which can amount to a +6000
instructions inflated count in the reported count.

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

Reported-by: Vince Weaver <vince@deater.net>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <19016.41425.814043.870352@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c |   64 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c5a2907..201ef23 100644
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
