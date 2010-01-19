Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312Ab0ASHfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab0ASHfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 02:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145Ab0ASHfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 02:35:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49909 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755268Ab0ASHfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 02:35:41 -0500
Message-ID: <4B556078.7000004@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 15:34:16 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/6] tracing: Change trace_seq to use separate buffer
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
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

Lai Jiangshan changed this patch, we should blame to him when need,
changes from Steven's patch:
     rebase it for newly -tip tree
     use stack local struct trace_seq instead of allocate them.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/ftrace_event.h |    5 +++
 include/linux/trace_seq.h    |   22 ++++++++++++++-
 include/trace/ftrace.h       |   20 ++++++++++----
 kernel/trace/ftrace.c        |    3 +-
 kernel/trace/trace.c         |   14 +++++++--
 kernel/trace/trace_events.c  |   61 ++++++++++++++++++++++---------------------
 kernel/trace/trace_ksym.c    |   12 ++++----
 kernel/trace/trace_output.c  |   24 +++++++++-------
 8 files changed, 104 insertions(+), 57 deletions(-)
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index c6d0e1a..be9ece5 100644
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
@@ -55,6 +58,8 @@ struct trace_iterator {
 	unsigned long		iter_flags;
 
 	struct trace_seq	seq;
+	unsigned char		buffer[FTRACE_SEQ_BUFSIZE];
+
 	struct trace_entry	*ent;
 	int			leftover;
 	int			cpu;
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 5cf397c..b64218f 100644
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
index 5b46cf9..f30f4d6 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -142,6 +142,7 @@
  *	struct ftrace_raw_<call> *field; <-- defined in stage 1
  *	struct trace_entry *entry;
  *	struct trace_seq *p;
+ *	unsigned char *buffer;
  *	int ret;
  *
  *	entry = iter->ent;
@@ -154,7 +155,8 @@
  *	field = (typeof(field))entry;
  *
  *	p = get_cpu_var(ftrace_event_seq);
- *	trace_seq_init(p);
+ *	buffer = get_cpu_var(ftrace_event_buffer);
+ *	trace_seq_init(p, buffer, FTRACE_SEQ_BUFSIZE);
  *	ret = trace_seq_printf(s, <TP_printk> "\n");
  *	put_cpu();
  *	if (!ret)
@@ -207,7 +209,9 @@ ftrace_raw_output_id_##call(int event_id, const char *name,		\
 	struct ftrace_raw_##call *field;				\
 	struct trace_entry *entry;					\
 	struct trace_seq *p;						\
+	unsigned char *buffer;						\
 	int ret;							\
+	int cpu;							\
 									\
 	entry = iter->ent;						\
 									\
@@ -218,8 +222,10 @@ ftrace_raw_output_id_##call(int event_id, const char *name,		\
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
@@ -248,7 +254,9 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 	struct ftrace_raw_##template *field;				\
 	struct trace_entry *entry;					\
 	struct trace_seq *p;						\
+	unsigned char *buffer;						\
 	int ret;							\
+	int cpu;							\
 									\
 	entry = iter->ent;						\
 									\
@@ -259,8 +267,10 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
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
index 7968762..4e0a668 100644
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
index 27fecf8..9dfcc06 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2091,6 +2091,7 @@ __tracing_open(struct inode *inode, struct file *file)
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
 	if (!iter)
 		return ERR_PTR(-ENOMEM);
+	trace_seq_init(&iter->seq, iter->buffer, FTRACE_SEQ_BUFSIZE);
 
 	/*
 	 * We make a copy of the current tracer to avoid concurrent
@@ -2921,6 +2922,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 		ret = -ENOMEM;
 		goto out;
 	}
+	trace_seq_init(&iter->seq, iter->buffer, FTRACE_SEQ_BUFSIZE);
 
 	/*
 	 * We make a copy of the current tracer to avoid concurrent
@@ -3088,7 +3090,7 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 	if (sret != -EBUSY)
 		return sret;
 
-	trace_seq_init(&iter->seq);
+	trace_seq_reset(&iter->seq);
 
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
@@ -3124,6 +3126,8 @@ waitagain:
 	if (cnt >= PAGE_SIZE)
 		cnt = PAGE_SIZE - 1;
 
+	trace_seq_reset(&iter->seq);
+
 	trace_event_read_lock();
 	trace_access_lock(iter->cpu_file);
 	while (find_next_entry_inc(iter) != NULL) {
@@ -3148,7 +3152,7 @@ waitagain:
 	/* Now copy what we have to the user */
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
 	if (iter->seq.readpos >= iter->seq.len)
-		trace_seq_init(&iter->seq);
+		trace_seq_reset(&iter->seq);
 
 	/*
 	 * If there was nothing to send to user, inspite of consuming trace
@@ -3289,7 +3293,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		partial[i].offset = 0;
 		partial[i].len = iter->seq.len;
 
-		trace_seq_init(&iter->seq);
+		trace_seq_reset(&iter->seq);
 	}
 
 	trace_access_unlock(iter->cpu_file);
@@ -4335,7 +4334,7 @@ trace_printk_seq(struct trace_seq *s)
 
 	printk(KERN_TRACE "%s", s->buffer);
 
-	trace_seq_init(s);
+	trace_seq_reset(s);
 }
 
 static void __ftrace_dump(bool disable_tracing)
@@ -4385,6 +4384,8 @@ static void __ftrace_dump(bool disable_tracing)
 	 * and then release the locks again.
 	 */
 
+	trace_seq_init(&iter.seq, iter.buffer, FTRACE_SEQ_BUFSIZE);
+
 	while (!trace_empty(&iter)) {
 
 		if (!cnt)
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 699d06d..a6c0195 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -526,19 +526,19 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 {
 	struct ftrace_event_call *call = filp->private_data;
 	struct ftrace_event_field *field;
-	struct trace_seq *s;
+	struct trace_seq seq, *s = &seq;
+	unsigned char *buffer;
 	int common_field_count = 5;
-	char *buf;
 	int r = 0;
 
 	if (*ppos)
 		return 0;
 
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
-	if (!s)
+	buffer = (unsigned char *)__get_free_page(GFP_KERNEL);
+	if (!buffer)
 		return -ENOMEM;
 
-	trace_seq_init(s);
+	trace_seq_init(s, buffer, PAGE_SIZE);
 
 	trace_seq_printf(s, "name: %s\n", call->name);
 	trace_seq_printf(s, "ID: %d\n", call->id);
@@ -586,7 +586,7 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 		/*
 		 * ug!  The format output is bigger than a PAGE!!
 		 */
-		buf = "FORMAT TOO BIG\n";
+		char *buf = "FORMAT TOO BIG\n";
 		r = simple_read_from_buffer(ubuf, cnt, ppos,
 					      buf, strlen(buf));
 		goto out;
@@ -594,8 +594,8 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	r = simple_read_from_buffer(ubuf, cnt, ppos,
 				    s->buffer, s->len);
- out:
-	kfree(s);
+out:
+	free_page((unsigned long)buffer);
 	return r;
 }
 
@@ -620,22 +620,23 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
 	struct ftrace_event_call *call = filp->private_data;
-	struct trace_seq *s;
+	unsigned char *buffer;
+	struct trace_seq seq;
 	int r;
 
 	if (*ppos)
 		return 0;
 
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
-	if (!s)
+	buffer = (unsigned char *)__get_free_page(GFP_KERNEL);
+	if (!buffer)
 		return -ENOMEM;
 
-	trace_seq_init(s);
+	trace_seq_init(&seq, buffer, PAGE_SIZE);
 
-	print_event_filter(call, s);
-	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+	print_event_filter(call, &seq);
+	r = simple_read_from_buffer(ubuf, cnt, ppos, seq.buffer, seq.len);
 
-	kfree(s);
+	free_page((unsigned long)buffer);
 
 	return r;
 }
@@ -676,22 +677,23 @@ subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 		      loff_t *ppos)
 {
 	struct event_subsystem *system = filp->private_data;
-	struct trace_seq *s;
+	unsigned char *buffer;
+	struct trace_seq seq;
 	int r;
 
 	if (*ppos)
 		return 0;
 
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
-	if (!s)
+	buffer = (unsigned char *)__get_free_page(GFP_KERNEL);
+	if (!buffer)
 		return -ENOMEM;
 
-	trace_seq_init(s);
+	trace_seq_init(&seq, buffer, PAGE_SIZE);
 
-	print_subsystem_event_filter(system, s);
-	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+	print_subsystem_event_filter(system, &seq);
+	r = simple_read_from_buffer(ubuf, cnt, ppos, seq.buffer, seq.len);
 
-	kfree(s);
+	free_page((unsigned long)buffer);
 
 	return r;
 }
@@ -731,22 +733,23 @@ static ssize_t
 show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 {
 	int (*func)(struct trace_seq *s) = filp->private_data;
-	struct trace_seq *s;
+	unsigned char *buffer;
+	struct trace_seq seq;
 	int r;
 
 	if (*ppos)
 		return 0;
 
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
-	if (!s)
+	buffer = (unsigned char *)__get_free_page(GFP_KERNEL);
+	if (!buffer)
 		return -ENOMEM;
 
-	trace_seq_init(s);
+	trace_seq_init(&seq, buffer, PAGE_SIZE);
 
-	func(s);
-	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+	func(&seq);
+	r = simple_read_from_buffer(ubuf, cnt, ppos, seq.buffer, seq.len);
 
-	kfree(s);
+	free_page((unsigned long)buffer);
 
 	return r;
 }
diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 94103cd..933e221 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -223,14 +223,16 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
 {
 	struct trace_ksym *entry;
 	struct hlist_node *node;
-	struct trace_seq *s;
+	unsigned char *buffer;
+	struct trace_seq seq, *s = &seq;
 	ssize_t cnt = 0;
 	int ret;
 
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
-	if (!s)
+	buffer = (unsigned char *)__get_free_page(GFP_KERNEL);
+	if (!buffer)
 		return -ENOMEM;
-	trace_seq_init(s);
+
+	trace_seq_init(s, buffer, PAGE_SIZE);
 
 	mutex_lock(&ksym_tracer_mutex);
 
@@ -250,7 +252,7 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
 
 	mutex_unlock(&ksym_tracer_mutex);
 
-	kfree(s);
+	free_page((unsigned long)buffer);
 
 	return cnt;
 }
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

