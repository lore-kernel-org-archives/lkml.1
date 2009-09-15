Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbZIOJdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbZIOJdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZIOJdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:33:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:49340 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbZIOJdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:33:11 -0400
Date: Tue, 15 Sep 2009 09:32:37 GMT
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
Subject: [tip:perfcounters/core] perf sched: Display time in milliseconds, reorganize output
Message-ID: <tip-d9340c1db3f52460a8335eeb127a2728c5bba6ce@git.kernel.org>
Git-Commit-ID: d9340c1db3f52460a8335eeb127a2728c5bba6ce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:32:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9340c1db3f52460a8335eeb127a2728c5bba6ce
Gitweb:     http://git.kernel.org/tip/d9340c1db3f52460a8335eeb127a2728c5bba6ce
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 12 Sep 2009 10:08:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Sep 2009 10:22:44 +0200

perf sched: Display time in milliseconds, reorganize output

After:

-----------------------------------------------------------------------------------
 Task              |  runtime ms | switches | average delay ms | maximum delay ms |
-----------------------------------------------------------------------------------
 migration/0       |    0.000 ms |        1 | avg:    0.047 ms | max:    0.047 ms |
 ksoftirqd/0       |    0.000 ms |        1 | avg:    0.039 ms | max:    0.039 ms |
 migration/1       |    0.000 ms |        3 | avg:    0.013 ms | max:    0.016 ms |
 migration/3       |    0.000 ms |        2 | avg:    0.003 ms | max:    0.004 ms |
 migration/4       |    0.000 ms |        1 | avg:    0.022 ms | max:    0.022 ms |
 distccd           |    0.000 ms |        1 | avg:    0.004 ms | max:    0.004 ms |
 distccd           |    0.000 ms |        1 | avg:    0.014 ms | max:    0.014 ms |
 distccd           |    0.000 ms |        2 | avg:    0.000 ms | max:    0.000 ms |
 distccd           |    0.000 ms |        2 | avg:    0.012 ms | max:    0.019 ms |
 distccd           |    0.000 ms |        1 | avg:    0.002 ms | max:    0.002 ms |
 as                |    0.000 ms |        2 | avg:    0.019 ms | max:    0.019 ms |
 as                |    0.000 ms |        3 | avg:    0.015 ms | max:    0.017 ms |
 as                |    0.000 ms |        1 | avg:    0.009 ms | max:    0.009 ms |
 perf              |    0.000 ms |        1 | avg:    0.001 ms | max:    0.001 ms |
 gcc               |    0.000 ms |        1 | avg:    0.021 ms | max:    0.021 ms |
 run-mozilla.sh    |    0.000 ms |        2 | avg:    0.010 ms | max:    0.017 ms |
 mozilla-plugin-   |    0.000 ms |        1 | avg:    0.006 ms | max:    0.006 ms |
 gcc               |    0.000 ms |        2 | avg:    0.013 ms | max:    0.013 ms |
-----------------------------------------------------------------------------------

(The runtime ms column is not filled in yet.)

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c         |   17 +++++++++--------
 tools/perf/util/trace-event-read.c |    6 ++++--
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 84699cf..a084c28 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1096,14 +1096,15 @@ static void output_lat_thread(struct thread_latency *lat)
 	if (!count)
 		return;
 
-	ret = printf("%s", lat->thread->comm);
+	ret = printf(" %s ", lat->thread->comm);
 
-	for (i = 0; i < 25 - ret; i++)
+	for (i = 0; i < 19 - ret; i++)
 		printf(" ");
 
 	avg = total / count;
 
-	printf("%5d        %10llu       %10llu      %10llu\n", count, total, avg, max);
+	printf("|%9.3f ms |%9d | avg:%9.3f ms | max:%9.3f ms |\n",
+		0.0, count, (double)avg/1e9, (double)max/1e9);
 }
 
 static void __cmd_lat(void)
@@ -1113,11 +1114,9 @@ static void __cmd_lat(void)
 	setup_pager();
 	read_events();
 
-	printf(" Tasks");
-	printf("                     count");
-	printf("          total");
-	printf("              avg");
-	printf("            max\n\n");
+	printf("-----------------------------------------------------------------------------------\n");
+	printf(" Task              |  runtime ms | switches | average delay ms | maximum delay ms |\n");
+	printf("-----------------------------------------------------------------------------------\n");
 
 	next = rb_first(&lat_snapshot_root);
 
@@ -1128,6 +1127,8 @@ static void __cmd_lat(void)
 		output_lat_thread(lat);
 		next = rb_next(next);
 	}
+
+	printf("-----------------------------------------------------------------------------------\n");
 }
 
 static struct trace_sched_handler *trace_handler;
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index a1217a1..1b5c847 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -458,12 +458,13 @@ struct record *trace_read_data(int cpu)
 	return data;
 }
 
-void trace_report (void)
+void trace_report(void)
 {
 	const char *input_file = "trace.info";
 	char buf[BUFSIZ];
 	char test[] = { 23, 8, 68 };
 	char *version;
+	int show_version = 0;
 	int show_funcs = 0;
 	int show_printk = 0;
 
@@ -480,7 +481,8 @@ void trace_report (void)
 		die("not a trace file (missing tracing)");
 
 	version = read_string();
-	printf("version = %s\n", version);
+	if (show_version)
+		printf("version = %s\n", version);
 	free(version);
 
 	read_or_die(buf, 1);
