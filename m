Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbZHQJUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbZHQJUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932130AbZHQJUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:20:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51695 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757524AbZHQJUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:20:41 -0400
Message-ID: <4A89213C.5090109@cn.fujitsu.com>
Date: Mon, 17 Aug 2009 17:22:04 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] Add timer-source of walltime for ftrace
References: <4A698F90.90501@cn.fujitsu.com> <alpine.DEB.2.00.0907240902030.17438@gandalf.stny.rr.com> <20090728103227.D7FB.A69D9226@jp.fujitsu.com> <20090728015351.GF5147@nowhere> <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can add a timer-source for ftrace to support wall-time display.
It is based on Steven Rostedt <rostedt@goodmis.org>'s suggestion in:
http://lkml.org/lkml/2009/7/24/103

It needs to be applied on my patch of:
[PATCH v4 1/2] Add function to convert between calendar time and broken-down time for universal use
and
[PATCH v2 2/2] ftrace: Unify effect of writing to trace_options and option/*

We can get following output:
 # cd /mnt/debugfs/tracing/
 # ls options/*clock
 options/global-clock  options/local-clock  options/walltime-clock
 # echo sched_switch > current_tracer
 # cat trace
 # tracer: sched_switch
 #
 #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
 #              | |       |          |         |
             bash-3560  [000]   694.242386:   3560:120:S   + [000]  3560:120:S bash
             bash-3560  [000]   694.242476:   3560:120:S   + [000]  3560:120:S bash
             bash-3560  [000]   694.242865:   3560:120:R   + [000]     5:115:S events/0
             bash-3560  [000]   694.242912:   3560:120:R ==> [000]     5:115:R events/0
         events/0-5     [000]   694.243015:      5:115:R   + [000]  3558:120:S sshd
         events/0-5     [000]   694.243040:      5:115:S ==> [000]  3560:120:R bash
             bash-3560  [000]   694.243312:   3560:120:S   + [000]  3560:120:S bash
             bash-3560  [000]   694.243374:   3560:120:S ==> [000]  3558:120:R sshd
 ...
 # echo 1 > options/walltime-clock
 # echo > trace
 # cat trace
 # tracer: sched_switch
 #
 #           TASK-PID    CPU#           TIMESTAMP  FUNCTION
 #              | |       |                 |         |
             bash-3560  [000] 2009-08-17 23:58:22   3560:120:S   + [000]  3560:120:S bash
             bash-3560  [000] 2009-08-17 23:58:22   3560:120:R   + [000]     5:115:S events/0
             bash-3560  [000] 2009-08-17 23:58:22   3560:120:R ==> [000]     5:115:R events/0
         events/0-5     [000] 2009-08-17 23:58:22      5:115:R   + [000]  3558:120:S sshd
         events/0-5     [000] 2009-08-17 23:58:22      5:115:S ==> [000]  3558:120:R sshd
             sshd-3558  [000] 2009-08-17 23:58:22   3558:120:S ==> [000]  3560:120:R bash
             bash-3560  [000] 2009-08-17 23:58:22   3560:120:S   + [000]  3560:120:S bash
             bash-3560  [000] 2009-08-17 23:58:22   3560:120:S   + [000]  3560:120:S bash
 ...

Note:
It is only a prototype patch to for demostrate what is result looks like.
There still have many works to do(bug to fix) before apply.
For example, we need to add a hook(tracepoint) of xtime change event,
so we can update walltime's clock base then.
And maybe we need clear all events when changing clock-source, because old
clock value can't displayed correctly in new clock's format.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 include/linux/trace_clock.h |    1 +
 kernel/trace/trace.c        |   55 ++++++++++++++++++++++++++++++------------
 kernel/trace/trace.h        |    6 +++-
 kernel/trace/trace_clock.c  |   47 ++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_output.c |   20 ++++++++++++---
 5 files changed, 107 insertions(+), 22 deletions(-)

diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
index 7a81303..322707e 100644
--- a/include/linux/trace_clock.h
+++ b/include/linux/trace_clock.h
@@ -15,5 +15,6 @@
 extern u64 notrace trace_clock_local(void);
 extern u64 notrace trace_clock(void);
 extern u64 notrace trace_clock_global(void);
+extern u64 notrace trace_clock_walltime(void);
 
 #endif /* _LINUX_TRACE_CLOCK_H */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b7d873b..4474f7d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -263,8 +263,8 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 
 /* trace_flags holds trace_options default values */
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
-	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
-	TRACE_ITER_GRAPH_TIME;
+	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_LOCAL_CLK |
+	TRACE_ITER_SLEEP_TIME | TRACE_ITER_GRAPH_TIME;
 
 /**
  * trace_wake_up - wake up tasks waiting for trace input
@@ -324,6 +324,8 @@ static const char *trace_options[] = {
 	"context-info",
 	"latency-format",
 	"global-clock",
+	"local-clock",
+	"walltime-clock",
 	"sleep-time",
 	"graph-time",
 	NULL
@@ -1423,8 +1425,17 @@ static void print_lat_help_header(struct seq_file *m)
 
 static void print_func_help_header(struct seq_file *m)
 {
-	seq_puts(m, "#           TASK-PID    CPU#    TIMESTAMP  FUNCTION\n");
-	seq_puts(m, "#              | |       |          |         |\n");
+	if (trace_flags & TRACE_ITER_WALLTIME_CLK) {
+		seq_puts(m, "#           TASK-PID    CPU# "
+			"          TIMESTAMP  FUNCTION\n");
+		seq_puts(m, "#              | |       |   "
+			"              |         |\n");
+	} else {
+		seq_puts(m, "#           TASK-PID    CPU# "
+			"   TIMESTAMP  FUNCTION\n");
+		seq_puts(m, "#              | |       |   "
+			"       |         |\n");
+	}
 }
 
 
@@ -2151,30 +2162,42 @@ static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
 
 static void set_tracer_flags(unsigned int mask, int enabled)
 {
+	u64 (*clkfunc)(void) = NULL;
+
 	/* do nothing if flag is already set */
 	if (!!(trace_flags & mask) == !!enabled)
 		return;
 
-	if (enabled)
-		trace_flags |= mask;
-	else
-		trace_flags &= ~mask;
+	if (mask == TRACE_ITER_GLOBAL_CLK)
+		clkfunc = trace_clock_global;
+	if (mask == TRACE_ITER_LOCAL_CLK)
+		clkfunc = trace_clock_local;
+	if (mask == TRACE_ITER_WALLTIME_CLK)
+		clkfunc = trace_clock_walltime;
 
-	if (mask == TRACE_ITER_GLOBAL_CLK) {
-		u64 (*func)(void);
+	if (clkfunc) {
+		if (!enabled)
+			return;
 
-		if (enabled)
-			func = trace_clock_global;
-		else
-			func = trace_clock_local;
+		trace_flags &= ~TRACE_ITER_GLOBAL_CLK;
+		trace_flags &= ~TRACE_ITER_LOCAL_CLK;
+		trace_flags &= ~TRACE_ITER_WALLTIME_CLK;
+		trace_flags |= mask;
 
 		mutex_lock(&trace_types_lock);
-		ring_buffer_set_clock(global_trace.buffer, func);
+		ring_buffer_set_clock(global_trace.buffer, clkfunc);
 
 		if (max_tr.buffer)
-			ring_buffer_set_clock(max_tr.buffer, func);
+			ring_buffer_set_clock(max_tr.buffer, clkfunc);
 		mutex_unlock(&trace_types_lock);
+
+		return;
 	}
+
+	if (enabled)
+		trace_flags |= mask;
+	else
+		trace_flags &= ~mask;
 }
 
 static ssize_t
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 606073c..02ffa4c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -675,8 +675,10 @@ enum trace_iterator_flags {
 	TRACE_ITER_CONTEXT_INFO		= 0x20000, /* Print pid/cpu/time */
 	TRACE_ITER_LATENCY_FMT		= 0x40000,
 	TRACE_ITER_GLOBAL_CLK		= 0x80000,
-	TRACE_ITER_SLEEP_TIME		= 0x100000,
-	TRACE_ITER_GRAPH_TIME		= 0x200000,
+	TRACE_ITER_LOCAL_CLK		= 0x100000,
+	TRACE_ITER_WALLTIME_CLK		= 0x200000,
+	TRACE_ITER_SLEEP_TIME		= 0x400000,
+	TRACE_ITER_GRAPH_TIME		= 0x800000,
 };
 
 /*
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index b588fd8..53ced3e 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -107,3 +107,50 @@ u64 notrace trace_clock_global(void)
 
 	return now;
 }
+
+/* value of time_t when traceclock is 0 */
+static struct timespec base_walltime;
+
+u64 notrace trace_clock_walltime(void)
+{
+	u32 remainder;
+	return base_walltime.tv_sec + div_u64_rem(
+			trace_clock() + base_walltime.tv_nsec,
+			NSEC_PER_SEC, &remainder);
+}
+
+static int __init walltime_init(void)
+{
+	unsigned long flags;
+	struct timespec ts;
+	u64 traceclock;
+	u32 remainder;
+
+	local_irq_save(flags);
+
+	getnstimeofday(&ts);
+	traceclock = trace_clock();
+
+	if (traceclock > ts.tv_nsec) {
+		base_walltime.tv_sec = ts.tv_sec - div_u64_rem(
+				traceclock - ts.tv_nsec + NSEC_PER_SEC - 1,
+				NSEC_PER_SEC, &remainder);
+
+		/*
+		 * base_walltime.tv_nsec =
+		 * 	(NSEC_PER_SEC - (traceclock - ts.tv_nsec) %
+		 * 	NSEC_PER_SEC) % NSEC_PER_SEC;
+		 */
+		div_u64_rem(traceclock - ts.tv_nsec, NSEC_PER_SEC, &remainder);
+		base_walltime.tv_nsec = remainder ?
+					NSEC_PER_SEC - remainder : 0;
+	} else {
+		base_walltime.tv_sec = ts.tv_sec;
+		base_walltime.tv_nsec = ts.tv_nsec - traceclock;
+	}
+
+	local_irq_restore(flags);
+	return 0;
+}
+
+device_initcall_sync(walltime_init);
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index e0c2545..0419b37 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -501,15 +501,27 @@ int trace_print_context(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry = iter->ent;
-	unsigned long long t = ns2usecs(iter->ts);
-	unsigned long usec_rem = do_div(t, USEC_PER_SEC);
-	unsigned long secs = (unsigned long)t;
 	char comm[TASK_COMM_LEN];
 
 	trace_find_cmdline(entry->pid, comm);
 
-	return trace_seq_printf(s, "%16s-%-5d [%03d] %5lu.%06lu: ",
+	if (trace_flags & TRACE_ITER_WALLTIME_CLK) {
+		struct tm tm;
+		time_to_tm(iter->ts, 0, &tm);
+		return trace_seq_printf(s, "%16s-%-5d [%03d] "
+					"%04ld-%02d-%02d "
+					"%02d:%02d:%02d ",
+					comm, entry->pid, iter->cpu,
+					tm.tm_year + 1900, tm.tm_mon + 1,
+					tm.tm_mday, tm.tm_hour, tm.tm_min,
+					tm.tm_sec);
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


