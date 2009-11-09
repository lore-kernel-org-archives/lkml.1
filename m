Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZKIXUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZKIXUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 18:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbZKIXUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 18:20:46 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:54827 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbZKIXUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 18:20:43 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH v2 4/4] perf bench: Modify builtin-pipe.c for processing common options
Date: Tue, 10 Nov 2009 08:20:02 +0900
Message-Id: <1257808802-9420-5-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257808802-9420-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257808802-9420-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies builtin-pipe.c for processing common options.
The first option added is "--format".
Users of perf bench will be able to specify output style by --format.

Example of use:
% ./perf bench sched pipe		# with no style specify
(executing 1000000 pipe operations between two tasks)

        Total time:5.855 sec
                5.855061 usecs/op
                170792 ops/sec
% ./perf bench --format=simple sched pipe # specified simple
5.988

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/bench/sched-pipe.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index 6a29100..a9ac186 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -30,14 +30,10 @@
 
 #define LOOPS_DEFAULT 1000000
 static int loops = LOOPS_DEFAULT;
-static int simple = 0;
 
 static const struct option options[] = {
 	OPT_INTEGER('l', "loop", &loops,
 		    "Specify number of loops"),
-	OPT_BOOLEAN('s', "simple-output", &simple,
-		    "Do simple output (this maybe useful for"
-		    "processing by scripts or graph tools like gnuplot)"),
 	OPT_END()
 };
 
@@ -94,10 +90,8 @@ int bench_sched_pipe(int argc, const char **argv,
 		return 0;
 	}
 
-	if (simple)
-		printf("%lu.%03lu\n",
-		       diff.tv_sec, diff.tv_usec / 1000);
-	else {
+	switch (bench_format) {
+	case BENCH_FORMAT_DEFAULT:
 		printf("(executing %d pipe operations between two tasks)\n\n",
 			loops);
 
@@ -111,6 +105,18 @@ int bench_sched_pipe(int argc, const char **argv,
 		printf("\t\t%d ops/sec\n",
 		       (int)((double)loops /
 			     ((double)result_usec / (double)1000000)));
+		break;
+
+	case BENCH_FORMAT_SIMPLE:
+		printf("%lu.%03lu\n",
+		       diff.tv_sec, diff.tv_usec / 1000);
+		break;
+
+	default:
+		/* reaching here is something disaster */
+		fprintf(stderr, "Unknown format:%d\n", bench_format);
+		exit(1);
+		break;
 	}
 
 	return 0;
-- 
1.5.6.5

