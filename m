Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbZLaIc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbZLaIc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 03:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZLaIc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 03:32:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:38207 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbZLaIc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 03:32:58 -0500
From: Liming Wang <liming.wang@windriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Liming Wang <liming.wang@windriver.com>
Subject: [PATCH 1/1] perf tools: fix pid option for stat
Date: Thu, 31 Dec 2009 16:05:50 +0800
Message-Id: <1262246750-2191-1-git-send-email-liming.wang@windriver.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <20091230092327.GA10486@elte.hu>
References: <20091230092327.GA10486@elte.hu>
X-OriginalArrivalTime: 31 Dec 2009 08:32:24.0634 (UTC) FILETIME=[C73F19A0:01CA89F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

current pid option doesn't work for perf stat. Change it to what
perf record --pid acts as.

Signed-off-by: Liming Wang <liming.wang@windriver.com>
---
 tools/perf/builtin-stat.c |  106 ++++++++++++++++++++++++++-------------------
 1 files changed, 61 insertions(+), 45 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c70d720..e8c85d5 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -44,6 +44,7 @@
 #include "util/parse-events.h"
 #include "util/event.h"
 #include "util/debug.h"
+#include "util/header.h"
 
 #include <sys/prctl.h>
 #include <math.h>
@@ -79,6 +80,8 @@ static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static int			event_scaled[MAX_COUNTERS];
 
+static volatile int done = 0;
+
 struct stats
 {
 	double n, mean, M2;
@@ -247,61 +250,64 @@ static int run_perf_stat(int argc __used, const char **argv)
 	unsigned long long t0, t1;
 	int status = 0;
 	int counter;
-	int pid;
+	int pid = target_pid;
 	int child_ready_pipe[2], go_pipe[2];
+	const bool forks = (target_pid == -1 && argc > 0);
 	char buf;
 
 	if (!system_wide)
 		nr_cpus = 1;
 
-	if (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0) {
+	if (forks && (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
 		perror("failed to create pipes");
 		exit(1);
 	}
 
-	if ((pid = fork()) < 0)
-		perror("failed to fork");
+	if (forks) {
+		if ((pid = fork()) < 0)
+			perror("failed to fork");
+
+		if (!pid) {
+			close(child_ready_pipe[0]);
+			close(go_pipe[1]);
+			fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);
+
+			/*
+			 * Do a dummy execvp to get the PLT entry resolved,
+			 * so we avoid the resolver overhead on the real
+			 * execvp call.
+			 */
+			execvp("", (char **)argv);
+
+			/*
+			 * Tell the parent we're ready to go
+			 */
+			close(child_ready_pipe[1]);
+
+			/*
+			 * Wait until the parent tells us to go.
+			 */
+			if (read(go_pipe[0], &buf, 1) == -1)
+				perror("unable to read pipe");
+
+			execvp(argv[0], (char **)argv);
+
+			perror(argv[0]);
+			exit(-1);
+		}
 
-	if (!pid) {
-		close(child_ready_pipe[0]);
-		close(go_pipe[1]);
-		fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);
+		child_pid = pid;
 
 		/*
-		 * Do a dummy execvp to get the PLT entry resolved,
-		 * so we avoid the resolver overhead on the real
-		 * execvp call.
-		 */
-		execvp("", (char **)argv);
-
-		/*
-		 * Tell the parent we're ready to go
+		 * Wait for the child to be ready to exec.
 		 */
 		close(child_ready_pipe[1]);
-
-		/*
-		 * Wait until the parent tells us to go.
-		 */
-		if (read(go_pipe[0], &buf, 1) == -1)
+		close(go_pipe[0]);
+		if (read(child_ready_pipe[0], &buf, 1) == -1)
 			perror("unable to read pipe");
-
-		execvp(argv[0], (char **)argv);
-
-		perror(argv[0]);
-		exit(-1);
+		close(child_ready_pipe[0]);
 	}
 
-	child_pid = pid;
-
-	/*
-	 * Wait for the child to be ready to exec.
-	 */
-	close(child_ready_pipe[1]);
-	close(go_pipe[0]);
-	if (read(child_ready_pipe[0], &buf, 1) == -1)
-		perror("unable to read pipe");
-	close(child_ready_pipe[0]);
-
 	for (counter = 0; counter < nr_counters; counter++)
 		create_perf_stat_counter(counter, pid);
 
@@ -310,8 +316,12 @@ static int run_perf_stat(int argc __used, const char **argv)
 	 */
 	t0 = rdclock();
 
-	close(go_pipe[1]);
-	wait(&status);
+	if (forks) {
+		close(go_pipe[1]);
+		wait(&status);
+	} else {
+		while(!done);
+	}
 
 	t1 = rdclock();
 
@@ -417,10 +427,13 @@ static void print_stat(int argc, const char **argv)
 	fflush(stdout);
 
 	fprintf(stderr, "\n");
-	fprintf(stderr, " Performance counter stats for \'%s", argv[0]);
-
-	for (i = 1; i < argc; i++)
-		fprintf(stderr, " %s", argv[i]);
+	fprintf(stderr, " Performance counter stats for ");
+	if(target_pid == -1) {
+		fprintf(stderr, "\'%s", argv[0]);
+		for (i = 1; i < argc; i++)
+			fprintf(stderr, " %s", argv[i]);
+	}else
+		fprintf(stderr, "task pid \'%d", target_pid);
 
 	fprintf(stderr, "\'");
 	if (run_count > 1)
@@ -445,6 +458,9 @@ static volatile int signr = -1;
 
 static void skip_signal(int signo)
 {
+	if(target_pid != -1)
+		done = 1;
+
 	signr = signo;
 }
 
@@ -461,7 +477,7 @@ static void sig_atexit(void)
 }
 
 static const char * const stat_usage[] = {
-	"perf stat [<options>] <command>",
+	"perf stat [<options>] [<command>]",
 	NULL
 };
 
@@ -492,7 +508,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, options, stat_usage,
 		PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc)
+	if (!argc && target_pid == -1)
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
-- 
1.6.0.3

