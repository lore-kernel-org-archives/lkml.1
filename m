Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbZKJEXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbZKJEXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 23:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbZKJEXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 23:23:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:45950 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618AbZKJEXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 23:23:13 -0500
Date: Tue, 10 Nov 2009 04:22:36 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257808802-9420-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257808802-9420-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Modify bench/bench-messaging.c to adopt unified output formatting
Message-ID: <tip-cced06c62a9db6bd6d77e3f0a57dbe47a26d881e@git.kernel.org>
Git-Commit-ID: cced06c62a9db6bd6d77e3f0a57dbe47a26d881e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cced06c62a9db6bd6d77e3f0a57dbe47a26d881e
Gitweb:     http://git.kernel.org/tip/cced06c62a9db6bd6d77e3f0a57dbe47a26d881e
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Tue, 10 Nov 2009 08:20:01 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 04:53:49 +0100

perf bench: Modify bench/bench-messaging.c to adopt unified output formatting

This patch modifies bench/bench-messaging.c to adopt
unified output formatting: --format option.

Usage example:

 % ./perf bench sched messaging              # with no style
 specify (20 sender and receiver processes per group)
 (10 groups == 400 processes run)

        Total time:1.431 sec

 % ./perf bench --format=simple sched messaging # specified
 simple 1.431

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1257808802-9420-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/bench/sched-messaging.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index 36b62c5..2cc5edc 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -35,7 +35,6 @@ static int use_pipes = 0;
 static unsigned int loops = 100;
 static unsigned int thread_mode = 0;
 static unsigned int num_groups = 10;
-static int simple = 0;
 
 struct sender_context {
 	unsigned int num_fds;
@@ -261,9 +260,6 @@ static const struct option options[] = {
 		    "Specify number of groups"),
 	OPT_INTEGER('l', "loop", &loops,
 		    "Specify number of loops"),
-	OPT_BOOLEAN('s', "simple-output", &simple,
-		    "Do simple output (this maybe useful for"
-		    "processing by scripts or graph tools like gnuplot)"),
 	OPT_END()
 };
 
@@ -316,9 +312,8 @@ int bench_sched_messaging(int argc, const char **argv,
 
 	timersub(&stop, &start, &diff);
 
-	if (simple)
-		printf("%lu.%03lu\n", diff.tv_sec, diff.tv_usec/1000);
-	else {
+	switch (bench_format) {
+	case BENCH_FORMAT_DEFAULT:
 		printf("(%d sender and receiver %s per group)\n",
 		       num_fds, thread_mode ? "threads" : "processes");
 		printf("(%d groups == %d %s run)\n\n",
@@ -326,6 +321,15 @@ int bench_sched_messaging(int argc, const char **argv,
 		       thread_mode ? "threads" : "processes");
 		printf("\tTotal time:%lu.%03lu sec\n",
 		       diff.tv_sec, diff.tv_usec/1000);
+		break;
+	case BENCH_FORMAT_SIMPLE:
+		printf("%lu.%03lu\n", diff.tv_sec, diff.tv_usec/1000);
+		break;
+	default:
+		/* reaching here is something disaster */
+		fprintf(stderr, "Unknown format:%d\n", bench_format);
+		exit(1);
+		break;
 	}
 
 	return 0;
