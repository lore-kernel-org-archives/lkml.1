Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZKJEXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZKJEXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 23:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbZKJEXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 23:23:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:45955 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032AbZKJEXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 23:23:17 -0500
Date: Tue, 10 Nov 2009 04:22:52 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257808802-9420-5-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257808802-9420-5-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Modify builtin-pipe.c for processing common options
Message-ID: <tip-158ba827f6deef4102c5247ed4b6a587f0bd6a07@git.kernel.org>
Git-Commit-ID: 158ba827f6deef4102c5247ed4b6a587f0bd6a07
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  158ba827f6deef4102c5247ed4b6a587f0bd6a07
Gitweb:     http://git.kernel.org/tip/158ba827f6deef4102c5247ed4b6a587f0bd6a07
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Tue, 10 Nov 2009 08:20:02 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 04:53:49 +0100

perf bench: Modify builtin-pipe.c for processing common options

This patch modifies builtin-pipe.c for processing common
options. The first option added is "--format".
Users of perf bench will be able to specify output style by
--format.

Usage example:

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
LKML-Reference: <1257808802-9420-5-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
