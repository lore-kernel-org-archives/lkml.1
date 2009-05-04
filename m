Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbZEDPVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbZEDPVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756827AbZEDPUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:20:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45314 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbZEDPUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:20:21 -0400
Message-Id: <20090504152019.461026995@goodmis.org>
References: <20090504151933.728781787@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 04 May 2009 11:19:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/6] tracing: export stats of ring buffers to userspace
Content-Disposition: inline; filename=0002-tracing-export-stats-of-ring-buffers-to-userspace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds stats to the ftrace ring buffers:

 # cat /debugfs/tracing/per_cpu/cpu0/stats
 entries: 42360
 overrun: 30509326
 commit overrun: 0
 nmi dropped: 0

Where entries are the total number of data entries in the buffer.

overrun is the number of entries not consumed and were overwritten by
the writer.

commit overrun is the number of entries dropped due to nested writers
wrapping the buffer before the initial writer finished the commit.

nmi dropped is the number of entries dropped due to the ring buffer
lock being held when an nmi was going to write to the ring buffer.
Note, this field will be meaningless and will go away when the ring
buffer becomes lockless.

[ Impact: let userspace know what is happening in the ring buffers ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f5427e0..74df029 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3595,6 +3595,45 @@ static const struct file_operations tracing_buffers_fops = {
 	.llseek		= no_llseek,
 };
 
+static ssize_t
+tracing_stats_read(struct file *filp, char __user *ubuf,
+		   size_t count, loff_t *ppos)
+{
+	unsigned long cpu = (unsigned long)filp->private_data;
+	struct trace_array *tr = &global_trace;
+	struct trace_seq *s;
+	unsigned long cnt;
+
+	s = kmalloc(sizeof(*s), GFP_ATOMIC);
+	if (!s)
+		return ENOMEM;
+
+	trace_seq_init(s);
+
+	cnt = ring_buffer_entries_cpu(tr->buffer, cpu);
+	trace_seq_printf(s, "entries: %ld\n", cnt);
+
+	cnt = ring_buffer_overrun_cpu(tr->buffer, cpu);
+	trace_seq_printf(s, "overrun: %ld\n", cnt);
+
+	cnt = ring_buffer_commit_overrun_cpu(tr->buffer, cpu);
+	trace_seq_printf(s, "commit overrun: %ld\n", cnt);
+
+	cnt = ring_buffer_nmi_dropped_cpu(tr->buffer, cpu);
+	trace_seq_printf(s, "nmi dropped: %ld\n", cnt);
+
+	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
+
+	kfree(s);
+
+	return count;
+}
+
+static const struct file_operations tracing_stats_fops = {
+	.open		= tracing_open_generic,
+	.read		= tracing_stats_read,
+};
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 int __weak ftrace_arch_read_dyn_info(char *buf, int size)
@@ -3708,6 +3747,9 @@ static void tracing_init_debugfs_percpu(long cpu)
 
 	trace_create_file("trace_pipe_raw", 0444, d_cpu,
 			(void *) cpu, &tracing_buffers_fops);
+
+	trace_create_file("stats", 0444, d_cpu,
+			(void *) cpu, &tracing_stats_fops);
 }
 
 #ifdef CONFIG_FTRACE_SELFTEST
-- 
1.6.2.4

-- 
