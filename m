Return-Path: <linux-kernel-owner+w=401wt.eu-S965951AbZLHT5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965951AbZLHT5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965928AbZLHT5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:57:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63016 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965890AbZLHT51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:57:27 -0500
X-Authority-Analysis: v=1.0 c=1 a=tBCOW3DPGuAA:10 a=20KFwNOVAAAA:8 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=NPgCFe1sMsFnRFgVtZ0A:9 a=_JJ5eornTNnqqlv4QCAA:7 a=3LxRQfa_wDivBUH-HXhP57pQE5gA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091208195731.159263968@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Dec 2009 14:54:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2][RFC] [PATCH 1/2] tracing: Change trace_seq to use separate buffer
References: <20091208195405.653797300@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Change-trace_seq-to-use-separate-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently, the trace_seq buffer is part of the trace_seq structure.
This makes manipulating the trace_seq easier, but it also limits
its ability. In some cases, it is advantageous to have trace_seq
write into a separate buffer. Separating the buffer from the structure
makes the usage of trace_seq a little more complex, but it also
makes it more efficient.

The splice code will then be able to write directly into the splice
page as suppose to write into the trace_seq buffer and copying a page
worth of data.

Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    6 ++++-
 include/linux/trace_seq.h    |   22 ++++++++++++++++++-
 include/trace/ftrace.h       |   20 ++++++++++++++----
 kernel/trace/ftrace.c        |    3 +-
 kernel/trace/trace.c         |   24 +++++++++++++++------
 kernel/trace/trace_events.c  |   45 +++++++++++++++++++++++++++++++++++++----
 kernel/trace/trace_ksym.c    |   10 ++++++++-
 kernel/trace/trace_output.c  |   24 ++++++++++++----------
 8 files changed, 121 insertions(+), 33 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 38f8d65..1921cc0 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -10,7 +10,10 @@ struct trace_array;
 struct tracer;
 struct dentry;
 
+#define FTRACE_SEQ_BUFSIZE PAGE_SIZE
+
 DECLARE_PER_CPU(struct trace_seq, ftrace_event_seq);
+DECLARE_PER_CPU(unsigned char[FTRACE_SEQ_BUFSIZE], ftrace_event_buffer);
 
 struct trace_print_flags {
 	unsigned long		mask;
@@ -53,9 +56,10 @@ struct trace_iterator {
 	struct mutex		mutex;
 	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
 	unsigned long		iter_flags;
+	struct trace_seq	seq;
+	unsigned char		buffer[FTRACE_SEQ_BUFSIZE];
 
 	/* The below is zeroed out in pipe_read */
-	struct trace_seq	seq;
 	struct trace_entry	*ent;
 	int			leftover;
 	int			cpu;
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index dd38678..72238e7 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -11,18 +11,36 @@
  */
 
 struct trace_seq {
-	unsigned char		buffer[PAGE_SIZE];
 	unsigned int		len;
 	unsigned int		readpos;
 	int			full;
+	int			buflen;
+	unsigned char		*buffer;
 };
 
 static inline void
-trace_seq_init(struct trace_seq *s)
+trace_seq_init(struct trace_seq *s,
+	       unsigned char *buffer, int buflen)
 {
 	s->len = 0;
 	s->readpos = 0;
 	s->full = 0;
+	s->buflen = buflen;
+	s->buffer = buffer;
+}
+
+static inline void trace_seq_reset(struct trace_seq *s)
+{
+	WARN_ON_ONCE(!s->buffer);
+
+	s->len = 0;
+	s->readpos = 0;
+	s->full = 0;
+}
+
+static inline unsigned char *trace_seq_buffer(struct trace_seq *s)
+{
+	return s->buffer;
 }
 
 /*
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index d1b3de9..de03116 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -266,6 +266,7 @@ ftrace_format_##name(struct ftrace_event_call *unused,			\
  *	struct ftrace_raw_<call> *field; <-- defined in stage 1
  *	struct trace_entry *entry;
  *	struct trace_seq *p;
+ *	unsigned char *buffer;
  *	int ret;
  *
  *	entry = iter->ent;
@@ -278,7 +279,8 @@ ftrace_format_##name(struct ftrace_event_call *unused,			\
  *	field = (typeof(field))entry;
  *
  *	p = get_cpu_var(ftrace_event_seq);
- *	trace_seq_init(p);
+ *	buffer = get_cpu_var(ftrace_event_buffer);
+ *	trace_seq_init(p, buffer, FTRACE_SEQ_BUFSIZE);
  *	ret = trace_seq_printf(s, <TP_printk> "\n");
  *	put_cpu();
  *	if (!ret)
@@ -331,7 +333,9 @@ ftrace_raw_output_id_##call(int event_id, const char *name,		\
 	struct ftrace_raw_##call *field;				\
 	struct trace_entry *entry;					\
 	struct trace_seq *p;						\
+	unsigned char *buffer;						\
 	int ret;							\
+	int cpu;							\
 									\
 	entry = iter->ent;						\
 									\
@@ -342,8 +346,10 @@ ftrace_raw_output_id_##call(int event_id, const char *name,		\
 									\
 	field = (typeof(field))entry;					\
 									\
-	p = &get_cpu_var(ftrace_event_seq);				\
-	trace_seq_init(p);						\
+	cpu = get_cpu();						\
+	p = &per_cpu(ftrace_event_seq, cpu);				\
+	buffer = per_cpu(ftrace_event_buffer, cpu);			\
+	trace_seq_init(p, buffer, FTRACE_SEQ_BUFSIZE);			\
 	ret = trace_seq_printf(s, "%s: ", name);			\
 	if (ret)							\
 		ret = trace_seq_printf(s, print);			\
@@ -372,7 +378,9 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 	struct ftrace_raw_##template *field;				\
 	struct trace_entry *entry;					\
 	struct trace_seq *p;						\
+	unsigned char *buffer;						\
 	int ret;							\
+	int cpu;							\
 									\
 	entry = iter->ent;						\
 									\
@@ -383,8 +391,10 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 									\
 	field = (typeof(field))entry;					\
 									\
-	p = &get_cpu_var(ftrace_event_seq);				\
-	trace_seq_init(p);						\
+	cpu = get_cpu();						\
+	p = &per_cpu(ftrace_event_seq, cpu);				\
+	buffer = per_cpu(ftrace_event_buffer, cpu);			\
+	trace_seq_init(p, buffer, FTRACE_SEQ_BUFSIZE);			\
 	ret = trace_seq_printf(s, "%s: ", #call);			\
 	if (ret)							\
 		ret = trace_seq_printf(s, print);			\
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e51a1bc..3118503 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -383,6 +383,7 @@ static int function_stat_show(struct seq_file *m, void *v)
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	static DEFINE_MUTEX(mutex);
 	static struct trace_seq s;
+	static char s_buffer[PAGE_SIZE];
 	unsigned long long avg;
 #endif
 
@@ -395,7 +396,7 @@ static int function_stat_show(struct seq_file *m, void *v)
 	do_div(avg, rec->counter);
 
 	mutex_lock(&mutex);
-	trace_seq_init(&s);
+	trace_seq_init(&s, s_buffer, PAGE_SIZE);
 	trace_print_graph_duration(rec->time, &s);
 	trace_seq_puts(&s, "    ");
 	trace_print_graph_duration(avg, &s);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 596dcf2..df25c4f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2001,6 +2001,7 @@ __tracing_open(struct inode *inode, struct file *file)
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
 	if (!iter)
 		return ERR_PTR(-ENOMEM);
+	trace_seq_init(&iter->seq, iter->buffer, FTRACE_SEQ_BUFSIZE);
 
 	/*
 	 * We make a copy of the current tracer to avoid concurrent
@@ -2873,6 +2874,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 		ret = -ENOMEM;
 		goto out;
 	}
+	trace_seq_init(&iter->seq, iter->buffer, FTRACE_SEQ_BUFSIZE);
 
 	/*
 	 * We make a copy of the current tracer to avoid concurrent
@@ -3046,7 +3048,7 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 	if (sret != -EBUSY)
 		return sret;
 
-	trace_seq_init(&iter->seq);
+	trace_seq_reset(&iter->seq);
 
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
@@ -3083,10 +3085,11 @@ waitagain:
 		cnt = PAGE_SIZE - 1;
 
 	/* reset all but tr, trace, and overruns */
-	memset(&iter->seq, 0,
+	memset(&iter->ent, 0,
 	       sizeof(struct trace_iterator) -
-	       offsetof(struct trace_iterator, seq));
+	       offsetof(struct trace_iterator, ent));
 	iter->pos = -1;
+	trace_seq_reset(&iter->seq);
 
 	trace_event_read_lock();
 	while (find_next_entry_inc(iter) != NULL) {
@@ -3110,7 +3113,7 @@ waitagain:
 	/* Now copy what we have to the user */
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
 	if (iter->seq.readpos >= iter->seq.len)
-		trace_seq_init(&iter->seq);
+		trace_seq_reset(&iter->seq);
 
 	/*
 	 * If there was nothing to send to user, inspite of consuming trace
@@ -3250,7 +3253,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		partial[i].offset = 0;
 		partial[i].len = iter->seq.len;
 
-		trace_seq_init(&iter->seq);
+		trace_seq_reset(&iter->seq);
 	}
 
 	trace_event_read_unlock();
@@ -3748,13 +3751,19 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	unsigned long cpu = (unsigned long)filp->private_data;
 	struct trace_array *tr = &global_trace;
 	struct trace_seq *s;
+	unsigned char *buffer;
 	unsigned long cnt;
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return -ENOMEM;
+	buffer = (unsigned char *)__get_free_page(GFP_KERNEL);
+	if (!buffer) {
+		kfree(s);
+		return -ENOMEM;
+	}
 
-	trace_seq_init(s);
+	trace_seq_init(s, buffer, PAGE_SIZE);
 
 	cnt = ring_buffer_entries_cpu(tr->buffer, cpu);
 	trace_seq_printf(s, "entries: %ld\n", cnt);
@@ -3767,6 +3776,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 
 	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
 
+	free_page((unsigned long)buffer);
 	kfree(s);
 
 	return count;
@@ -4296,7 +4306,7 @@ trace_printk_seq(struct trace_seq *s)
 
 	printk(KERN_TRACE "%s", s->buffer);
 
-	trace_seq_init(s);
+	trace_seq_reset(s);
 }
 
 static void __ftrace_dump(bool disable_tracing)
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 1d18315..4959e2d 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -529,6 +529,7 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
 	struct ftrace_event_call *call = filp->private_data;
+	unsigned char *buffer;
 	struct trace_seq *s;
 	char *buf;
 	int r;
@@ -539,8 +540,13 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return -ENOMEM;
+	buffer = (unsigned char *)__get_free_page(GFP_KERNEL);
+	if (!buffer) {
+		kfree(s);
+		return -ENOMEM;
+	}
 
-	trace_seq_init(s);
+	trace_seq_init(s, buffer, PAGE_SIZE);
 
 	/* If any of the first writes fail, so will the show_format. */
 
@@ -563,6 +569,7 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 	r = simple_read_from_buffer(ubuf, cnt, ppos,
 				    s->buffer, s->len);
  out:
+	free_page((unsigned long)buffer);
 	kfree(s);
 	return r;
 }
@@ -571,6 +578,7 @@ static ssize_t
 event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 {
 	struct ftrace_event_call *call = filp->private_data;
+	unsigned char *buffer;
 	struct trace_seq *s;
 	int r;
 
@@ -580,12 +588,18 @@ event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return -ENOMEM;
+	buffer = (unsigned char *)__get_free_page(GFP_KERNEL);
+	if (!buffer) {
+		kfree(s);
+		return -ENOMEM;
+	}
 
-	trace_seq_init(s);
+	trace_seq_init(s, buffer, PAGE_SIZE);
 	trace_seq_printf(s, "%d\n", call->id);
 
 	r = simple_read_from_buffer(ubuf, cnt, ppos,
 				    s->buffer, s->len);
+	free_page((unsigned long)buffer);
 	kfree(s);
 	return r;
 }
@@ -595,6 +609,7 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
 	struct ftrace_event_call *call = filp->private_data;
+	unsigned char *buffer;
 	struct trace_seq *s;
 	int r;
 
@@ -604,12 +619,18 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return -ENOMEM;
+	buffer = (unsigned char *)__get_free_page(GFP_KERNEL);
+	if (!buffer) {
+		kfree(s);
+		return -ENOMEM;
+	}
 
-	trace_seq_init(s);
+	trace_seq_init(s, buffer, PAGE_SIZE);
 
 	print_event_filter(call, s);
 	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
+	free_page((unsigned long)buffer);
 	kfree(s);
 
 	return r;
@@ -651,6 +672,7 @@ subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 		      loff_t *ppos)
 {
 	struct event_subsystem *system = filp->private_data;
+	unsigned char *buffer;
 	struct trace_seq *s;
 	int r;
 
@@ -660,12 +682,18 @@ subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return -ENOMEM;
+	buffer = (unsigned char *)__get_free_page(GFP_KERNEL);
+	if (!buffer) {
+		kfree(s);
+		return -ENOMEM;
+	}
 
-	trace_seq_init(s);
+	trace_seq_init(s, buffer, PAGE_SIZE);
 
 	print_subsystem_event_filter(system, s);
 	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
+	free_page((unsigned long)buffer);
 	kfree(s);
 
 	return r;
@@ -706,6 +734,7 @@ static ssize_t
 show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 {
 	int (*func)(struct trace_seq *s) = filp->private_data;
+	unsigned char *buffer;
 	struct trace_seq *s;
 	int r;
 
@@ -715,12 +744,18 @@ show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return -ENOMEM;
+	buffer = (unsigned char *)__get_free_page(GFP_KERNEL);
+	if (!buffer) {
+		kfree(s);
+		return -ENOMEM;
+	}
 
-	trace_seq_init(s);
+	trace_seq_init(s, buffer, PAGE_SIZE);
 
 	func(s);
 	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
+	free_page((unsigned long)buffer);
 	kfree(s);
 
 	return r;
diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index ddfa0fd..c4972e1 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -223,6 +223,7 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
 {
 	struct trace_ksym *entry;
 	struct hlist_node *node;
+	unsigned char *buffer;
 	struct trace_seq *s;
 	ssize_t cnt = 0;
 	int ret;
@@ -230,7 +231,13 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return -ENOMEM;
-	trace_seq_init(s);
+	buffer = (unsigned char *)__get_free_page(GFP_KERNEL);
+	if (!buffer) {
+		kfree(s);
+		return -ENOMEM;
+	}
+
+	trace_seq_init(s, buffer, PAGE_SIZE);
 
 	mutex_lock(&ksym_tracer_mutex);
 
@@ -249,6 +256,7 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
 
 	mutex_unlock(&ksym_tracer_mutex);
 
+	free_page((unsigned long)buffer);
 	kfree(s);
 
 	return cnt;
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 8e46b33..78f9825 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -17,7 +17,9 @@
 DECLARE_RWSEM(trace_event_mutex);
 
 DEFINE_PER_CPU(struct trace_seq, ftrace_event_seq);
+DEFINE_PER_CPU(unsigned char[PAGE_SIZE], ftrace_event_buffer);
 EXPORT_PER_CPU_SYMBOL(ftrace_event_seq);
+EXPORT_PER_CPU_SYMBOL(ftrace_event_buffer);
 
 static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
 
@@ -25,7 +27,7 @@ static int next_event_type = __TRACE_LAST_TYPE + 1;
 
 int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
-	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
+	int len = s->len >= s->buflen ? s->buflen - 1 : s->len;
 	int ret;
 
 	ret = seq_write(m, s->buffer, len);
@@ -35,7 +37,7 @@ int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 	 * seq_file buffer.
 	 */
 	if (!ret)
-		trace_seq_init(s);
+		trace_seq_reset(s);
 
 	return ret;
 }
@@ -89,7 +91,7 @@ enum print_line_t trace_print_printk_msg_only(struct trace_iterator *iter)
 int
 trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 {
-	int len = (PAGE_SIZE - 1) - s->len;
+	int len = (s->buflen - 1) - s->len;
 	va_list ap;
 	int ret;
 
@@ -126,7 +128,7 @@ EXPORT_SYMBOL_GPL(trace_seq_printf);
 int
 trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 {
-	int len = (PAGE_SIZE - 1) - s->len;
+	int len = (s->buflen - 1) - s->len;
 	int ret;
 
 	if (s->full || !len)
@@ -148,7 +150,7 @@ EXPORT_SYMBOL_GPL(trace_seq_vprintf);
 
 int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 {
-	int len = (PAGE_SIZE - 1) - s->len;
+	int len = (s->buflen - 1) - s->len;
 	int ret;
 
 	if (s->full || !len)
@@ -184,7 +186,7 @@ int trace_seq_puts(struct trace_seq *s, const char *str)
 	if (s->full)
 		return 0;
 
-	if (len > ((PAGE_SIZE - 1) - s->len)) {
+	if (len > ((s->buflen - 1) - s->len)) {
 		s->full = 1;
 		return 0;
 	}
@@ -200,7 +202,7 @@ int trace_seq_putc(struct trace_seq *s, unsigned char c)
 	if (s->full)
 		return 0;
 
-	if (s->len >= (PAGE_SIZE - 1)) {
+	if (s->len >= (s->buflen - 1)) {
 		s->full = 1;
 		return 0;
 	}
@@ -215,7 +217,7 @@ int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
 	if (s->full)
 		return 0;
 
-	if (len > ((PAGE_SIZE - 1) - s->len)) {
+	if (len > ((s->buflen - 1) - s->len)) {
 		s->full = 1;
 		return 0;
 	}
@@ -255,7 +257,7 @@ void *trace_seq_reserve(struct trace_seq *s, size_t len)
 	if (s->full)
 		return 0;
 
-	if (len > ((PAGE_SIZE - 1) - s->len)) {
+	if (len > ((s->buflen - 1) - s->len)) {
 		s->full = 1;
 		return NULL;
 	}
@@ -273,12 +275,12 @@ int trace_seq_path(struct trace_seq *s, struct path *path)
 	if (s->full)
 		return 0;
 
-	if (s->len >= (PAGE_SIZE - 1)) {
+	if (s->len >= (s->buflen - 1)) {
 		s->full = 1;
 		return 0;
 	}
 
-	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
+	p = d_path(path, s->buffer + s->len, s->buflen - s->len);
 	if (!IS_ERR(p)) {
 		p = mangle_path(s->buffer + s->len, p, "\n");
 		if (p) {
-- 
1.6.5


