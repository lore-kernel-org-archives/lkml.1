Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbZLRUmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbZLRUmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbZLRUmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:42:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47062 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbZLRUmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:42:35 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf record: We should fork only if a program was specified to run
Date: Fri, 18 Dec 2009 18:42:24 -0200
Message-Id: <1261168944-6615-1-git-send-email-acme@infradead.org>
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

Reported-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 63136d0..90eedd9 100644
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
@@ -422,7 +422,8 @@ static int __cmd_record(int argc __used, const char **argv)
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 
-	if (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0) {
+	if (target_pid == -1 && argc > 0 &&
+	    (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
 		perror("failed to create pipes");
 		exit(-1);
 	}
@@ -483,7 +484,7 @@ static int __cmd_record(int argc __used, const char **argv)
 
 	atexit(atexit_header);
 
-	if (target_pid == -1) {
+	if (target_pid == -1 && argc > 0) {
 		pid = fork();
 		if (pid < 0) {
 			perror("failed to fork");
@@ -667,7 +668,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && target_pid == -1 && (!system_wide || profile_cpu == -1))
+	if (!argc && target_pid == -1 && !system_wide)
 		usage_with_options(record_usage, options);
 
 	symbol__init();
-- 
1.6.2.5

