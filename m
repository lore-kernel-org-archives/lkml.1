Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbZIOJdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbZIOJdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZIOJdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:33:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:49372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbZIOJdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:33:37 -0400
Date: Tue, 15 Sep 2009 09:33:02 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf sched: Output runtime and context switch totals
Message-ID: <tip-3e304147cdb404ce6d1dd0e50cb19f52142bb363@git.kernel.org>
Git-Commit-ID: 3e304147cdb404ce6d1dd0e50cb19f52142bb363
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:33:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e304147cdb404ce6d1dd0e50cb19f52142bb363
Gitweb:     http://git.kernel.org/tip/3e304147cdb404ce6d1dd0e50cb19f52142bb363
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 12 Sep 2009 10:08:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Sep 2009 10:22:45 +0200

perf sched: Output runtime and context switch totals

After:

-----------------------------------------------------------------------------------
 Task              |  Runtime ms | Switches | Average delay ms | Maximum delay ms |
-----------------------------------------------------------------------------------
 make              |    0.678 ms |       13 | avg:    0.018 ms | max:    0.050 ms |
 gcc               |    0.014 ms |        2 | avg:    0.320 ms | max:    0.627 ms |
 gcc               |    0.000 ms |        2 | avg:    0.185 ms | max:    0.369 ms |
...
-----------------------------------------------------------------------------------
 TOTAL:            |   21.316 ms |       63 |
---------------------------------------------

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index c382f53..727cc5b 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1087,6 +1087,9 @@ static struct trace_sched_handler lat_ops  = {
 	.fork_event		= latency_fork_event,
 };
 
+static u64 all_runtime;
+static u64 all_count;
+
 static void output_lat_thread(struct thread_latency *lat)
 {
 	struct lat_snapshot *shot;
@@ -1111,6 +1114,9 @@ static void output_lat_thread(struct thread_latency *lat)
 		total += delta;
 	}
 
+	all_runtime += total_runtime;
+	all_count += count;
+
 	if (!count)
 		return;
 
@@ -1133,7 +1139,7 @@ static void __cmd_lat(void)
 	read_events();
 
 	printf("-----------------------------------------------------------------------------------\n");
-	printf(" Task              |  runtime ms | switches | average delay ms | maximum delay ms |\n");
+	printf(" Task              |  Runtime ms | Switches | Average delay ms | Maximum delay ms |\n");
 	printf("-----------------------------------------------------------------------------------\n");
 
 	next = rb_first(&lat_snapshot_root);
@@ -1147,6 +1153,9 @@ static void __cmd_lat(void)
 	}
 
 	printf("-----------------------------------------------------------------------------------\n");
+	printf(" TOTAL:            |%9.3f ms |%9Ld |\n",
+		(double)all_runtime/1e9, all_count);
+	printf("---------------------------------------------\n");
 }
 
 static struct trace_sched_handler *trace_handler;
