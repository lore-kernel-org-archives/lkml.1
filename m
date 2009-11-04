Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbZKDJij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbZKDJij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 04:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbZKDJii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 04:38:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53541 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbZKDJih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 04:38:37 -0500
Message-ID: <4AF14C35.80108@cn.fujitsu.com>
Date: Wed, 04 Nov 2009 17:41:09 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: rostedt@goodmis.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] ftrace: Add timer-source of walltime
References: <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com>	 <4A89213C.5090109@cn.fujitsu.com>	 <20090818215620.A63C.A69D9226@jp.fujitsu.com>	 <alpine.DEB.2.00.0908181454090.727@gandalf.stny.rr.com>	 <4A939CDF.2000407@cn.fujitsu.com> <4AB076DE.10604@cn.fujitsu.com>	 <4AB077AF.6080800@cn.fujitsu.com> <20090916055928.GF5121@nowhere>	 <4AB0885C.4010504@cn.fujitsu.com> <1253129843.20020.214.camel@gandalf.stny.rr.com> <4AB1E0F2.6030108@cn.fujitsu.com>
In-Reply-To: <4AB1E0F2.6030108@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can add a timer-source for ftrace to support wall-time display.

We can get following output:
 # cd /mnt/debugfs/tracing/
 # cat trace_clock
 [local] global walltime
 # echo function > current_tracer
 # head trace
 # tracer: function
 #
 #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
 #              | |       |          |         |
             sshd-2644  [000] 15567.508188: fsnotify <-fsnotify_access
             sshd-2644  [000] 15567.508191: fput_light <-sys_read
             sshd-2644  [000] 15567.508299: sys_select <-sysenter_do_call
             sshd-2644  [000] 15567.508304: core_sys_select <-sys_select
             sshd-2644  [000] 15567.508306: get_fd_set <-core_sys_select
             sshd-2644  [000] 15567.508309: copy_from_user <-get_fd_set
 # echo walltime > trace_clock
 # head trace
 # tracer: function
 #
 #           TASK-PID    CPU#                  TIMESTAMP  FUNCTION
 #              | |       |                        |         |
             sshd-2644  [000] 2009-11-04 15:53:55.454003: __spin_unlock_irq <-run_timer_softirq
             sshd-2644  [000] 2009-11-04 15:53:55.454003: rcu_bh_qs <-__do_softirq
             sshd-2644  [000] 2009-11-04 15:53:55.454003: _local_bh_enable <-__do_softirq
             sshd-2644  [000] 2009-11-04 15:53:55.454003: rcu_irq_exit <-irq_exit
             sshd-2644  [000] 2009-11-04 15:53:55.454003: idle_cpu <-irq_exit
             sshd-2644  [000] 2009-11-04 15:53:55.454003: fput_light <-do_select

Changelog:
v1->v2: Rebase to top of tip tree.
v2->v3: Use lockless __current_kernel_time() instead of xtime tracepoint

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 include/linux/trace_clock.h |    1 +
 kernel/trace/trace.c        |   24 ++++++++++++++++++------
 kernel/trace/trace.h        |    8 +++++++-
 kernel/trace/trace_clock.c  |    7 +++++++
 kernel/trace/trace_output.c |   23 ++++++++++++++++++-----
 5 files changed, 51 insertions(+), 12 deletions(-)

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
index 9d3067a..7885005 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -334,9 +334,10 @@ static struct {
 } trace_clocks[] = {
 	{ trace_clock_local,	"local" },
 	{ trace_clock_global,	"global" },
+	{ trace_clock_walltime,	"walltime" },
 };
 
-int trace_clock_id;
+enum TRACE_CLOCK_TYPE trace_clock_type = TRACE_CLOCK_LOCAL;
 
 /*
  * trace_parser_get_init - gets the buffer for trace parser
@@ -1642,8 +1643,17 @@ static void print_lat_help_header(struct seq_file *m)
 
 static void print_func_help_header(struct seq_file *m)
 {
-	seq_puts(m, "#           TASK-PID    CPU#    TIMESTAMP  FUNCTION\n");
-	seq_puts(m, "#              | |       |          |         |\n");
+	if (trace_clock_type == TRACE_CLOCK_WALLTIME) {
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
 
 
@@ -3374,8 +3384,8 @@ static ssize_t tracing_clock_read(struct file *filp, char __user *ubuf,
 	for (i = 0; i < ARRAY_SIZE(trace_clocks); i++)
 		bufiter += snprintf(buf + bufiter, sizeof(buf) - bufiter,
 			"%s%s%s%s", i ? " " : "",
-			i == trace_clock_id ? "[" : "", trace_clocks[i].name,
-			i == trace_clock_id ? "]" : "");
+			i == trace_clock_type ? "[" : "", trace_clocks[i].name,
+			i == trace_clock_type ? "]" : "");
 	bufiter += snprintf(buf + bufiter, sizeof(buf) - bufiter, "\n");
 
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, bufiter);
@@ -3405,7 +3415,7 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
 	if (i == ARRAY_SIZE(trace_clocks))
 		return -EINVAL;
 
-	trace_clock_id = i;
+	trace_clock_type = i;
 
 	mutex_lock(&trace_types_lock);
 
@@ -3415,6 +3425,8 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
 
 	mutex_unlock(&trace_types_lock);
 
+	tracing_reset_online_cpus(&global_trace);
+
 	*fpos += cnt;
 
 	return cnt;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c30556a..52be403 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -495,7 +495,13 @@ int trace_array_printk(struct trace_array *tr,
 
 extern unsigned long trace_flags;
 
-extern int trace_clock_id;
+enum TRACE_CLOCK_TYPE {
+	TRACE_CLOCK_LOCAL,
+	TRACE_CLOCK_GLOBAL,
+	TRACE_CLOCK_WALLTIME,
+};
+
+extern enum TRACE_CLOCK_TYPE trace_clock_type;
 
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 20c5f92..a93a6ca 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -111,3 +111,10 @@ u64 notrace trace_clock_global(void)
 
 	return now;
 }
+
+u64 notrace trace_clock_walltime(void)
+{
+	struct timespec timespec;
+	timespec = __current_kernel_time();
+	return (u64)timespec.tv_sec * NSEC_PER_SEC + timespec.tv_nsec;
+}
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index b6c12c6..08249e3 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -532,15 +532,28 @@ int trace_print_context(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry = iter->ent;
-	unsigned long long t = ns2usecs(iter->ts);
-	unsigned long usec_rem = do_div(t, USEC_PER_SEC);
-	unsigned long secs = (unsigned long)t;
 	char comm[TASK_COMM_LEN];
 
 	trace_find_cmdline(entry->pid, comm);
 
-	return trace_seq_printf(s, "%16s-%-5d [%03d] %5lu.%06lu: ",
-				comm, entry->pid, iter->cpu, secs, usec_rem);
+	if (trace_clock_type == TRACE_CLOCK_WALLTIME) {
+		struct tm tm;
+		u32 remainder;
+		time_to_tm(div_u64_rem(iter->ts, NSEC_PER_SEC, &remainder),
+			   -sys_tz.tz_minuteswest * 60, &tm);
+		return trace_seq_printf(s, "%16s-%-5d [%03d] "
+			"%04ld-%02d-%02d %02d:%02d:%02d.%06llu: ",
+			comm, entry->pid, iter->cpu,
+			tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
+			tm.tm_hour, tm.tm_min, tm.tm_sec,
+			ns2usecs(remainder));
+	} else {
+		unsigned long long t = ns2usecs(iter->ts);
+		unsigned long usec_rem = do_div(t, USEC_PER_SEC);
+		unsigned long secs = (unsigned long)t;
+		return trace_seq_printf(s, "%16s-%-5d [%03d] %5lu.%06lu: ",
+			comm, entry->pid, iter->cpu, secs, usec_rem);
+	}
 }
 
 int trace_print_lat_context(struct trace_iterator *iter)
-- 
1.5.5.3


