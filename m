Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbYKHDux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbYKHDux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 22:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbYKHDr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 22:47:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48872 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbYKHDrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 22:47:52 -0500
Message-Id: <20081108034750.579388751@goodmis.org>
References: <20081108034605.289816911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 22:46:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 10/10] ftrace: display start of CPU buffer in trace output
Content-Disposition: inline; filename=0010-ftrace-display-start-of-CPU-buffer-in-trace-output.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: change in trace output

Because the trace buffers are per cpu ring buffers, the start of
the trace can be confusing. If one CPU is very active at the
end of the trace, its history will not go as far back as the
other CPU traces.  This means that output for a particular CPU
may not appear for the first part of a trace.

To help annotate what is happening, and to prevent any more
confusion, this patch adds a line that annotates the start of
a CPU buffer output.

For example:

# tracer: function
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
##### CPU 1 buffer started ####
       automount-3495  [001]   184.596443: dnotify_parent <-vfs_write
[...]
       automount-3495  [001]   184.596449: dput <-path_put
##### CPU 2 buffer started ####
       automount-3496  [002]   184.596450: down_read_trylock <-do_page_fault
[...]
           sshd-3497  [001]   184.597069: up_read <-do_page_fault
##### CPU 0 buffer started ####
          <idle>-0     [000]   184.597074: __exit_idle <-exit_idle
[...]
       automount-3496  [002]   184.597257: filemap_fault <-__do_fault
##### CPU 3 buffer started ####
          <idle>-0     [003]   184.597261: exit_idle <-smp_apic_timer_interrupt

Note, parsers of a trace output should always ignore any lines that
start with a '#'.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/trace/trace.c |   19 +++++++++++++++++++
 kernel/trace/trace.h |    2 ++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5843541..f147f19 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1478,6 +1478,17 @@ void trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
 		trace_seq_putc(s, '\n');
 }
 
+static void test_cpu_buff_start(struct trace_iterator *iter)
+{
+	struct trace_seq *s = &iter->seq;
+
+	if (cpu_isset(iter->cpu, iter->started))
+		return;
+
+	cpu_set(iter->cpu, iter->started);
+	trace_seq_printf(s, "##### CPU %u buffer started ####\n", iter->cpu);
+}
+
 static enum print_line_t
 print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 {
@@ -1497,6 +1508,8 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 	if (entry->type == TRACE_CONT)
 		return TRACE_TYPE_HANDLED;
 
+	test_cpu_buff_start(iter);
+
 	next_entry = find_next_entry(iter, NULL, &next_ts);
 	if (!next_entry)
 		next_ts = iter->ts;
@@ -1612,6 +1625,8 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 	if (entry->type == TRACE_CONT)
 		return TRACE_TYPE_HANDLED;
 
+	test_cpu_buff_start(iter);
+
 	comm = trace_find_cmdline(iter->ent->pid);
 
 	t = ns2usecs(iter->ts);
@@ -2631,6 +2646,10 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 		return -ENOMEM;
 
 	mutex_lock(&trace_types_lock);
+
+	/* trace pipe does not show start of buffer */
+	cpus_setall(iter->started);
+
 	iter->tr = &global_trace;
 	iter->trace = current_trace;
 	filp->private_data = iter;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index cfda9d2..9781450 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -277,6 +277,8 @@ struct trace_iterator {
 	unsigned long		iter_flags;
 	loff_t			pos;
 	long			idx;
+
+	cpumask_t		started;
 };
 
 int tracing_is_enabled(void);
-- 
1.5.6.5

-- 
