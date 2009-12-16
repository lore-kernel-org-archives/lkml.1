Return-Path: <linux-kernel-owner+w=401wt.eu-S1760335AbZLPRAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335AbZLPRAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762281AbZLPRAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:00:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:54642 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbZLPRAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:00:00 -0500
Message-Id: <20091216165904.908184135@chello.nl>
References: <20091216165553.802559834@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 16 Dec 2009 17:55:55 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/3] perf-record: Properly synchronize child creation
Content-Disposition: inline; filename=perf2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove that ugly usleep and provide proper serialization between
parent and child just like perf-stat does.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/builtin-record.c |  111 ++++++++++++++++++++++++++++----------------
 1 file changed, 72 insertions(+), 39 deletions(-)

Index: linux-2.6/tools/perf/builtin-record.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-record.c
+++ linux-2.6/tools/perf/builtin-record.c
@@ -402,7 +402,7 @@ static void atexit_header(void)
 	perf_header__write(&session->header, output, true);
 }
 
-static int __cmd_record(int argc, const char **argv)
+static int __cmd_record(int argc __used, const char **argv)
 {
 	int i, counter;
 	struct stat st;
@@ -410,6 +410,8 @@ static int __cmd_record(int argc, const 
 	int flags;
 	int err;
 	unsigned long waking = 0;
+	int child_ready_pipe[2], go_pipe[2];
+	char buf;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
@@ -420,6 +422,11 @@ static int __cmd_record(int argc, const 
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
@@ -476,19 +483,65 @@ static int __cmd_record(int argc, const 
 
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
@@ -503,31 +556,6 @@ static int __cmd_record(int argc, const 
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
 
@@ -538,6 +566,11 @@ static int __cmd_record(int argc, const 
 		}
 	}
 
+	/*
+	 * Let the child rip
+	 */
+	close(go_pipe[1]);
+
 	for (;;) {
 		int hits = samples;
 
@@ -634,7 +667,7 @@ int cmd_record(int argc, const char **ar
 
 	argc = parse_options(argc, argv, options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && target_pid == -1 && !system_wide)
+	if (!argc && target_pid == -1 && (!system_wide || profile_cpu == -1))
 		usage_with_options(record_usage, options);
 
 	symbol__init();

-- 

