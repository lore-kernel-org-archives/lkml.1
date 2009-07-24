Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbZGXKlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbZGXKlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 06:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZGXKle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 06:41:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56525 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbZGXKlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 06:41:32 -0400
Message-ID: <4A699085.9090903@cn.fujitsu.com>
Date: Fri, 24 Jul 2009 18:44:21 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 3/3] Make ftrace display walltime in output
References: <4A698F90.90501@cn.fujitsu.com>
In-Reply-To: <4A698F90.90501@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now ring-buffer system have ability to support events' walltime record.
We can make ftrace display walltime in output as:
 # cd /mnt/debugfs/tracing/
 # echo sched_switch > current_tracer
 # cat trace
 # tracer: sched_switch
 #
 #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
 #              | |       |          |         |
             bash-2457  [000]   214.895446:   2457:120:S   + [000]  2457:120:S bash
             bash-2457  [000]   214.898298:   2457:120:R   + [000]     5:115:S events/0
             bash-2457  [000]   214.898684:   2457:120:R ==> [000]     5:115:R events/0
         events/0-5     [000]   214.899458:      5:115:R   + [000]  2455:120:S sshd
         events/0-5     [000]   214.899495:      5:115:S ==> [000]  2455:120:R sshd
 ...
 # echo 1 > options/walltime
 # cat trace
 # tracer: sched_switch
 #
 #           TASK-PID    CPU#                  TIMESTAMP  FUNCTION
 #              | |       |                        |         |
           <idle>-0     [000] 2009-07-25 18:01:00.848468:      0:140:R ==> [000]     5:115:R events/0
         events/0-5     [000] 2009-07-25 18:01:00.848523:      5:115:S ==> [000]     0:140:R <idle>
           <idle>-0     [000] 2009-07-25 18:01:01.613479:      0:140:R   + [000]  2455:120:S sshd
           <idle>-0     [000] 2009-07-25 18:01:01.613678:      0:140:R ==> [000]  2455:120:R sshd
             sshd-2455  [000] 2009-07-25 18:01:01.614015:   2455:120:S   + [000]  2455:120:S sshd
 ...

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/trace.c        |   14 ++++++++++++--
 kernel/trace/trace.h        |    1 +
 kernel/trace/trace_output.c |   21 +++++++++++++++++----
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index af25bec..4e360cf 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -326,6 +326,7 @@ static const char *trace_options[] = {
 	"global-clock",
 	"sleep-time",
 	"graph-time",
+	"walltime",
 	NULL
 };
 
@@ -1601,8 +1602,17 @@ static void print_lat_help_header(struct seq_file *m)
 
 static void print_func_help_header(struct seq_file *m)
 {
-	seq_puts(m, "#           TASK-PID    CPU#    TIMESTAMP  FUNCTION\n");
-	seq_puts(m, "#              | |       |          |         |\n");
+	if (trace_flags & TRACE_ITER_WALLTIME) {
+		seq_puts(m, "#           TASK-PID    CPU# "
+			"                 TIMESTAMP  FUNCTION\n");
+		seq_puts(m, "#              | |       |   "
+			"                     |         |\n");
+	} else {
+		seq_puts(m, "#           TASK-PID    CPU# "
+			"   TIMESTAMP  FUNCTION\n");
+		seq_puts(m, "#              | |       |   "
+			"       |         |\n");
+	}
 }
 
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index fb3dcc8..0860b3b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -664,6 +664,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_GLOBAL_CLK		= 0x80000,
 	TRACE_ITER_SLEEP_TIME		= 0x100000,
 	TRACE_ITER_GRAPH_TIME		= 0x200000,
+	TRACE_ITER_WALLTIME		= 0x400000, /* Print walltime */
 };
 
 /*
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index f5c7f0c..3a52bb5 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -501,15 +501,28 @@ int trace_print_context(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry = iter->ent;
-	unsigned long long t = ns2usecs(iter->ts);
-	unsigned long usec_rem = do_div(t, USEC_PER_SEC);
-	unsigned long secs = (unsigned long)t;
 	char comm[TASK_COMM_LEN];
 
 	trace_find_cmdline(entry->pid, comm);
 
-	return trace_seq_printf(s, "%16s-%-5d [%03d] %5lu.%06lu: ",
+	if (trace_flags & TRACE_ITER_WALLTIME) {
+		struct tm tm;
+		localtime_r(iter->timespec.tv_sec, &tm);
+		return trace_seq_printf(s, "%16s-%-5d [%03d] "
+					"%04u-%02u-%02u "
+					"%02u:%02u:%02u.%06llu: ",
+					comm, entry->pid, iter->cpu,
+					tm.tm_year + 1900, tm.tm_mon + 1,
+					tm.tm_mday, tm.tm_hour, tm.tm_min,
+					tm.tm_sec,
+					ns2usecs(iter->timespec.tv_nsec));
+	} else {
+		unsigned long long t = ns2usecs(iter->ts);
+		unsigned long usec_rem = do_div(t, USEC_PER_SEC);
+		unsigned long secs = (unsigned long)t;
+		return trace_seq_printf(s, "%16s-%-5d [%03d] %5lu.%06lu: ",
 				comm, entry->pid, iter->cpu, secs, usec_rem);
+	}
 }
 
 int trace_print_lat_context(struct trace_iterator *iter)
-- 
1.5.5.3


