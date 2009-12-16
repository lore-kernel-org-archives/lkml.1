Return-Path: <linux-kernel-owner+w=401wt.eu-S1762558AbZLPRe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762558AbZLPRe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762642AbZLPRex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:34:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:45627 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762640AbZLPRev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:34:51 -0500
Date: Wed, 16 Dec 2009 17:34:16 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091216165904.908184135@chello.nl>
References: <20091216165904.908184135@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf record: Properly synchronize child creation
Message-ID: <tip-856e96608a72412d319e498a3a7c557571f811bd@git.kernel.org>
Git-Commit-ID: 856e96608a72412d319e498a3a7c557571f811bd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  856e96608a72412d319e498a3a7c557571f811bd
Gitweb:     http://git.kernel.org/tip/856e96608a72412d319e498a3a7c557571f811bd
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Dec 2009 17:55:55 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Dec 2009 18:30:12 +0100

perf record: Properly synchronize child creation

Remove that ugly usleep and provide proper serialization between
parent and child just like perf-stat does.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: fweisbec@gmail.com
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091216165904.908184135@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |  109 ++++++++++++++++++++++++++++---------------
 1 files changed, 71 insertions(+), 38 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 65301c5..9b7c6d8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -402,7 +402,7 @@ static void atexit_header(void)
 	perf_header__write(&session->header, output, true);
 }
 
-static int __cmd_record(int argc, const char **argv)
+static int __cmd_record(int argc __used, const char **argv)
 {
 	int i, counter;
 	struct stat st;
@@ -410,6 +410,8 @@ static int __cmd_record(int argc, const char **argv)
 	int flags;
 	int err;
 	unsigned long waking = 0;
+	int child_ready_pipe[2], go_pipe[2];
+	char buf;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
@@ -420,6 +422,11 @@ static int __cmd_record(int argc, const char **argv)
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 
+	if (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0) {
+		perror("failed to create pipes");
+		exit(-1);
+	}
+
 	if (!stat(output_name, &st) && st.st_size) {
 		if (!force) {
 			if (!append_file) {
@@ -476,19 +483,65 @@ static int __cmd_record(int argc, const char **argv)
 
 	atexit(atexit_header);
 
-	if (!system_wide) {
-		pid = target_pid;
-		if (pid == -1)
-			pid = getpid();
+	if (target_pid == -1) {
+		pid = fork();
+		if (pid < 0) {
+			perror("failed to fork");
+			exit(-1);
+		}
 
-		open_counters(profile_cpu, pid);
-	} else {
-		if (profile_cpu != -1) {
-			open_counters(profile_cpu, target_pid);
-		} else {
-			for (i = 0; i < nr_cpus; i++)
-				open_counters(i, target_pid);
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
 		}
+
+		child_pid = pid;
+
+		if (!system_wide)
+			target_pid = pid;
+
+		close(child_ready_pipe[1]);
+		close(go_pipe[0]);
+		/*
+		 * wait for child to settle
+		 */
+		if (read(child_ready_pipe[0], &buf, 1) == -1) {
+			perror("unable to read pipe");
+			exit(-1);
+		}
+		close(child_ready_pipe[0]);
+	}
+
+
+	if (!system_wide || profile_cpu != -1) {
+		open_counters(profile_cpu, target_pid);
+	} else {
+		for (i = 0; i < nr_cpus; i++)
+			open_counters(i, target_pid);
 	}
 
 	if (file_new) {
@@ -503,31 +556,6 @@ static int __cmd_record(int argc, const char **argv)
 	else
 		event__synthesize_threads(process_synthesized_event, session);
 
-	if (target_pid == -1 && argc) {
-		pid = fork();
-		if (pid < 0)
-			die("failed to fork");
-
-		if (!pid) {
-			if (execvp(argv[0], (char **)argv)) {
-				perror(argv[0]);
-				exit(-1);
-			}
-		} else {
-			/*
-			 * Wait a bit for the execv'ed child to appear
-			 * and be updated in /proc
-			 * FIXME: Do you know a less heuristical solution?
-			 */
-			usleep(1000);
-			event__synthesize_thread(pid,
-						 process_synthesized_event,
-						 session);
-		}
-
-		child_pid = pid;
-	}
-
 	if (realtime_prio) {
 		struct sched_param param;
 
@@ -538,6 +566,11 @@ static int __cmd_record(int argc, const char **argv)
 		}
 	}
 
+	/*
+	 * Let the child rip
+	 */
+	close(go_pipe[1]);
+
 	for (;;) {
 		int hits = samples;
 
@@ -634,7 +667,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && target_pid == -1 && !system_wide)
+	if (!argc && target_pid == -1 && (!system_wide || profile_cpu == -1))
 		usage_with_options(record_usage, options);
 
 	symbol__init();
