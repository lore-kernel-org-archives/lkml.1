Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904Ab0AZH3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab0AZH3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 02:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584Ab0AZH32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 02:29:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58485 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab0AZH31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 02:29:27 -0500
Message-ID: <4B5E998D.9070603@cn.fujitsu.com>
Date: Tue, 26 Jan 2010 15:28:13 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: move static old_tracer to trace_iterator
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


static old_tracer is global for all processes.

So there is a potential bug when:
current_trace and static old_tracer are changed by other processes,
current_trace and static old_tracer are match with each other.
but *iter->trace and *current_trace are not match.

This patch move old_tracer to trace_iterator, and make it not global.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 3ca9485..925897e 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -47,6 +47,7 @@ struct trace_entry {
  */
 struct trace_iterator {
 	struct trace_array	*tr;
+	struct tracer		*old_tracer;
 	struct tracer		*trace;
 	void			*private;
 	int			cpu_file;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5314c90..bbb2229 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1667,7 +1667,6 @@ static void tracing_iter_reset(struct trace_iterator *iter, int cpu)
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
 	struct trace_iterator *iter = m->private;
-	static struct tracer *old_tracer;
 	int cpu_file = iter->cpu_file;
 	void *p = NULL;
 	loff_t l = 0;
@@ -1675,8 +1674,8 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(old_tracer != current_trace && current_trace)) {
-		old_tracer = current_trace;
+	if (unlikely(iter->old_tracer != current_trace && current_trace)) {
+		iter->old_tracer = current_trace;
 		*iter->trace = *current_trace;
 	}
 	mutex_unlock(&trace_types_lock);
@@ -3080,7 +3079,6 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 		  size_t cnt, loff_t *ppos)
 {
 	struct trace_iterator *iter = filp->private_data;
-	static struct tracer *old_tracer;
 	ssize_t sret;
 
 	/* return any leftover data */
@@ -3092,8 +3090,8 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(old_tracer != current_trace && current_trace)) {
-		old_tracer = current_trace;
+	if (unlikely(iter->old_tracer != current_trace && current_trace)) {
+		iter->old_tracer = current_trace;
 		*iter->trace = *current_trace;
 	}
 	mutex_unlock(&trace_types_lock);
@@ -3242,15 +3240,14 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		.ops		= &tracing_pipe_buf_ops,
 		.spd_release	= tracing_spd_release_pipe,
 	};
-	static struct tracer *old_tracer;
 	ssize_t ret;
 	size_t rem;
 	unsigned int i;
 
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(old_tracer != current_trace && current_trace)) {
-		old_tracer = current_trace;
+	if (unlikely(iter->old_tracer != current_trace && current_trace)) {
+		iter->old_tracer = current_trace;
 		*iter->trace = *current_trace;
 	}
 	mutex_unlock(&trace_types_lock);

