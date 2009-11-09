Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbZKIRDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbZKIRDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbZKIRDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:03:35 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:51899 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbZKIRD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:03:29 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/4] perf bench: Modified bench/bench-messaging.c to adopt unified output formatting
Date: Tue, 10 Nov 2009 02:03:25 +0900
Message-Id: <1257786206-9208-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257786206-9208-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257786206-9208-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257786206-9208-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1257786206-9208-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies bench/bench-messaging.c to adopt
unified output formatting: --format option.

Example of use:
% ./perf bench sched messaging              # with no style specify
(20 sender and receiver processes per group)
(10 groups == 400 processes run)

        Total time:1.431 sec
% ./perf bench --format=simple sched messaging # specified simple
1.431

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
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
-- 
1.5.6.5

