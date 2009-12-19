Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbZLSVXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbZLSVXN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 16:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbZLSVXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 16:23:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59422 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbZLSVXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 16:23:12 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1 v2] perf record: We should fork only if a program was specified to run
Date: Sat, 19 Dec 2009 19:22:51 -0200
Message-Id: <1261257771-10263-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

IOW: Now 'perf record -a' works, this was a bug introduced in:

856e96608a72412d319e498a3a7c557571f811bd
"perf record: Properly synchronize child creation"

Also fix the -C usage, i.e. allow for profiling all the tasks in one
CPU.

Reported-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 63136d0..2654253 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -402,7 +402,7 @@ static void atexit_header(void)
 	perf_header__write(&session->header, output, true);
 }
 
-static int __cmd_record(int argc __used, const char **argv)
+static int __cmd_record(int argc, const char **argv)
 {
 	int i, counter;
 	struct stat st;
@@ -411,6 +411,7 @@ static int __cmd_record(int argc __used, const char **argv)
 	int err;
 	unsigned long waking = 0;
 	int child_ready_pipe[2], go_pipe[2];
+	const bool forks = target_pid == -1 && argc > 0;
 	char buf;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
@@ -422,7 +423,7 @@ static int __cmd_record(int argc __used, const char **argv)
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 
-	if (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0) {
+	if (forks && (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
 		perror("failed to create pipes");
 		exit(-1);
 	}
@@ -483,7 +484,7 @@ static int __cmd_record(int argc __used, const char **argv)
 
 	atexit(atexit_header);
 
-	if (target_pid == -1) {
+	if (forks) {
 		pid = fork();
 		if (pid < 0) {
 			perror("failed to fork");
@@ -550,7 +551,7 @@ static int __cmd_record(int argc __used, const char **argv)
 			return err;
 	}
 
-	if (!system_wide)
+	if (!system_wide && profile_cpu == -1)
 		event__synthesize_thread(pid, process_synthesized_event,
 					 session);
 	else
@@ -569,7 +570,8 @@ static int __cmd_record(int argc __used, const char **argv)
 	/*
 	 * Let the child rip
 	 */
-	close(go_pipe[1]);
+	if (forks)
+		close(go_pipe[1]);
 
 	for (;;) {
 		int hits = samples;
@@ -667,7 +669,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && target_pid == -1 && (!system_wide || profile_cpu == -1))
+	if (!argc && target_pid == -1 && !system_wide && profile_cpu == -1)
 		usage_with_options(record_usage, options);
 
 	symbol__init();
-- 
1.6.2.5

