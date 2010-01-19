Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325Ab0ASHfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab0ASHfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 02:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968Ab0ASHfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 02:35:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49916 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755314Ab0ASHfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 02:35:46 -0500
Message-ID: <4B55607E.8070403@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 15:34:22 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/6] tracing: reduce latency and remove percpu trace_seq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__print_flags() and __print_symbolic() use percpu trace_seq:

1) Its memory is preallocated, it wastes memory when we don't use tracing.
2) It wastes memory for multi-cpus system.
3) It disables preemption when it executes its core routine
   "trace_seq_printf(s, "%s: ", #call);" and introduce latency
   for more important process.

So we move this trace_seq to struct trace_iterator.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index be9ece5..348500d 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -12,9 +12,6 @@ struct dentry;
 
 #define FTRACE_SEQ_BUFSIZE PAGE_SIZE
 
-DECLARE_PER_CPU(struct trace_seq, ftrace_event_seq);
-DECLARE_PER_CPU(unsigned char[FTRACE_SEQ_BUFSIZE], ftrace_event_buffer);
-
 struct trace_print_flags {
 	unsigned long		mask;
 	const char		*name;
@@ -60,6 +57,10 @@ struct trace_iterator {
 	struct trace_seq	seq;
 	unsigned char		buffer[FTRACE_SEQ_BUFSIZE];
 
+	/* trace_seq for __print_flags() and __print_symbolic() */
+	struct trace_seq	tmp_seq;
+	unsigned char 		tmp_buffer[FTRACE_SEQ_BUFSIZE];
+
 	struct trace_entry	*ent;
 	int			leftover;
 	int			cpu;
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index f30f4d6..4807d1e 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -141,8 +141,7 @@
  *	struct trace_seq *s = &iter->seq;
  *	struct ftrace_raw_<call> *field; <-- defined in stage 1
  *	struct trace_entry *entry;
- *	struct trace_seq *p;
- *	unsigned char *buffer;
+ *	struct trace_seq *p = &iter->tmp_seq;
  *	int ret;
  *
  *	entry = iter->ent;
@@ -154,11 +153,8 @@
  *
  *	field = (typeof(field))entry;
  *
- *	p = get_cpu_var(ftrace_event_seq);
- *	buffer = get_cpu_var(ftrace_event_buffer);
- *	trace_seq_init(p, buffer, FTRACE_SEQ_BUFSIZE);
+ *	trace_seq_init(p, iter->tmp_buffer, FTRACE_SEQ_BUFSIZE);
  *	ret = trace_seq_printf(s, <TP_printk> "\n");
- *	put_cpu();
  *	if (!ret)
  *		return TRACE_TYPE_PARTIAL_LINE;
  *
@@ -208,10 +204,8 @@ ftrace_raw_output_id_##call(int event_id, const char *name,		\
 	struct trace_seq *s = &iter->seq;				\
 	struct ftrace_raw_##call *field;				\
 	struct trace_entry *entry;					\
-	struct trace_seq *p;						\
-	unsigned char *buffer;						\
+	struct trace_seq *p = &iter->tmp_seq;				\
 	int ret;							\
-	int cpu;							\
 									\
 	entry = iter->ent;						\
 									\
@@ -222,14 +216,10 @@ ftrace_raw_output_id_##call(int event_id, const char *name,		\
 									\
 	field = (typeof(field))entry;					\
 									\
-	cpu = get_cpu();						\
-	p = &per_cpu(ftrace_event_seq, cpu);				\
-	buffer = per_cpu(ftrace_event_buffer, cpu);			\
-	trace_seq_init(p, buffer, FTRACE_SEQ_BUFSIZE);			\
+	trace_seq_init(p, iter->tmp_buffer, FTRACE_SEQ_BUFSIZE);	\
 	ret = trace_seq_printf(s, "%s: ", name);			\
 	if (ret)							\
 		ret = trace_seq_printf(s, print);			\
-	put_cpu();							\
 	if (!ret)							\
 		return TRACE_TYPE_PARTIAL_LINE;				\
 									\
@@ -253,10 +243,8 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 	struct trace_seq *s = &iter->seq;				\
 	struct ftrace_raw_##template *field;				\
 	struct trace_entry *entry;					\
-	struct trace_seq *p;						\
-	unsigned char *buffer;						\
+	struct trace_seq *p = &iter->tmp_seq;				\
 	int ret;							\
-	int cpu;							\
 									\
 	entry = iter->ent;						\
 									\
@@ -267,14 +255,10 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 									\
 	field = (typeof(field))entry;					\
 									\
-	cpu = get_cpu();						\
-	p = &per_cpu(ftrace_event_seq, cpu);				\
-	buffer = per_cpu(ftrace_event_buffer, cpu);			\
 	trace_seq_init(p, buffer, FTRACE_SEQ_BUFSIZE);			\
 	ret = trace_seq_printf(s, "%s: ", #call);			\
 	if (ret)							\
 		ret = trace_seq_printf(s, print);			\
-	put_cpu();							\
 	if (!ret)							\
 		return TRACE_TYPE_PARTIAL_LINE;				\
 									\
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 78f9825..f531a16 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -16,11 +16,6 @@
 
 DECLARE_RWSEM(trace_event_mutex);
 
-DEFINE_PER_CPU(struct trace_seq, ftrace_event_seq);
-DEFINE_PER_CPU(unsigned char[PAGE_SIZE], ftrace_event_buffer);
-EXPORT_PER_CPU_SYMBOL(ftrace_event_seq);
-EXPORT_PER_CPU_SYMBOL(ftrace_event_buffer);
-
 static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
 
 static int next_event_type = __TRACE_LAST_TYPE + 1;


