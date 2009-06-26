Return-Path: <linux-kernel-owner+w=401wt.eu-S1761144AbZFZS4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144AbZFZS4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 14:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757605AbZFZS4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 14:56:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58564 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757801AbZFZS4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 14:56:14 -0400
Date: Fri, 26 Jun 2009 20:56:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [GIT PULL] tracing fixes
Message-ID: <20090626185607.GA1332@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Li Zefan (10):
      tracing/events: Don't increment @pos in s_start()
      tracing_bprintk: Don't increment @pos in t_start()
      trace_stat: Don't increment @pos in seq start()
      tracing: Reset iterator in t_start()
      ftrace: Don't increment @pos in g_start()
      ftrace: Don't manipulate @pos in t_start()
      ftrace: Fix t_hash_start()
      tracing: Fix trace_buf_size boot option
      ftrace: Remove duplicate newline
      ftrace: Fix the output of profile

Paul Mundt (1):
      ring-buffer: Make it generally available


 Documentation/kernel-parameters.txt |    3 +-
 kernel/Makefile                     |    1 +
 kernel/trace/ftrace.c               |   56 ++++++++++++++++++++---------------
 kernel/trace/ring_buffer.c          |   11 +++++++
 kernel/trace/trace.c                |   23 ++++----------
 kernel/trace/trace.h                |    7 ++++
 kernel/trace/trace_events.c         |   28 +++++++++++++----
 kernel/trace/trace_functions.c      |    3 +-
 kernel/trace/trace_printk.c         |   26 ++++------------
 kernel/trace/trace_stat.c           |    6 +---
 10 files changed, 89 insertions(+), 75 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 92e1ab8..d3f41db 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2475,7 +2475,8 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	tp720=		[HW,PS2]
 
-	trace_buf_size=nn[KMG] [ftrace] will set tracing buffer size.
+	trace_buf_size=nn[KMG]
+			[FTRACE] will set tracing buffer size.
 
 	trix=		[HW,OSS] MediaTrix AudioTrix Pro
 			Format:
diff --git a/kernel/Makefile b/kernel/Makefile
index 0a32cb2..0630e29 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -96,6 +96,7 @@ obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_X86_DS) += trace/
+obj-$(CONFIG_RING_BUFFER) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_SLOW_WORK) += slow-work.o
 obj-$(CONFIG_PERF_COUNTERS) += perf_counter.o
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3718d55..f3716bf 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -291,7 +291,9 @@ function_stat_next(void *v, int idx)
 	pg = (struct ftrace_profile_page *)((unsigned long)rec & PAGE_MASK);
 
  again:
-	rec++;
+	if (idx != 0)
+		rec++;
+
 	if ((void *)rec >= (void *)&pg->records[pg->index]) {
 		pg = pg->next;
 		if (!pg)
@@ -1417,10 +1419,20 @@ static void *t_hash_start(struct seq_file *m, loff_t *pos)
 {
 	struct ftrace_iterator *iter = m->private;
 	void *p = NULL;
+	loff_t l;
+
+	if (!(iter->flags & FTRACE_ITER_HASH))
+		*pos = 0;
 
 	iter->flags |= FTRACE_ITER_HASH;
 
-	return t_hash_next(m, p, pos);
+	iter->hidx = 0;
+	for (l = 0; l <= *pos; ) {
+		p = t_hash_next(m, p, &l);
+		if (!p)
+			break;
+	}
+	return p;
 }
 
 static int t_hash_show(struct seq_file *m, void *v)
@@ -1467,8 +1479,6 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 			iter->pg = iter->pg->next;
 			iter->idx = 0;
 			goto retry;
-		} else {
-			iter->idx = -1;
 		}
 	} else {
 		rec = &iter->pg->records[iter->idx++];
@@ -1497,6 +1507,7 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 {
 	struct ftrace_iterator *iter = m->private;
 	void *p = NULL;
+	loff_t l;
 
 	mutex_lock(&ftrace_lock);
 	/*
@@ -1508,23 +1519,21 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 		if (*pos > 0)
 			return t_hash_start(m, pos);
 		iter->flags |= FTRACE_ITER_PRINTALL;
-		(*pos)++;
 		return iter;
 	}
 
 	if (iter->flags & FTRACE_ITER_HASH)
 		return t_hash_start(m, pos);
 
-	if (*pos > 0) {
-		if (iter->idx < 0)
-			return p;
-		(*pos)--;
-		iter->idx--;
+	iter->pg = ftrace_pages_start;
+	iter->idx = 0;
+	for (l = 0; l <= *pos; ) {
+		p = t_next(m, p, &l);
+		if (!p)
+			break;
 	}
 
-	p = t_next(m, p, pos);
-
-	if (!p)
+	if (!p && iter->flags & FTRACE_ITER_FILTER)
 		return t_hash_start(m, pos);
 
 	return p;
@@ -2500,32 +2509,31 @@ int ftrace_graph_count;
 unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
 
 static void *
-g_next(struct seq_file *m, void *v, loff_t *pos)
+__g_next(struct seq_file *m, loff_t *pos)
 {
 	unsigned long *array = m->private;
-	int index = *pos;
 
-	(*pos)++;
-
-	if (index >= ftrace_graph_count)
+	if (*pos >= ftrace_graph_count)
 		return NULL;
+	return &array[*pos];
+}
 
-	return &array[index];
+static void *
+g_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return __g_next(m, pos);
 }
 
 static void *g_start(struct seq_file *m, loff_t *pos)
 {
-	void *p = NULL;
-
 	mutex_lock(&graph_lock);
 
 	/* Nothing, tell g_show to print all functions are enabled */
 	if (!ftrace_graph_count && !*pos)
 		return (void *)1;
 
-	p = g_next(m, p, pos);
-
-	return p;
+	return __g_next(m, pos);
 }
 
 static void g_stop(struct seq_file *m, void *p)
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 04dac26..bf27bb7 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1563,6 +1563,8 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	return NULL;
 }
 
+#ifdef CONFIG_TRACING
+
 #define TRACE_RECURSIVE_DEPTH 16
 
 static int trace_recursive_lock(void)
@@ -1593,6 +1595,13 @@ static void trace_recursive_unlock(void)
 	current->trace_recursion--;
 }
 
+#else
+
+#define trace_recursive_lock()		(0)
+#define trace_recursive_unlock()	do { } while (0)
+
+#endif
+
 static DEFINE_PER_CPU(int, rb_need_resched);
 
 /**
@@ -3104,6 +3113,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read_page);
 
+#ifdef CONFIG_TRACING
 static ssize_t
 rb_simple_read(struct file *filp, char __user *ubuf,
 	       size_t cnt, loff_t *ppos)
@@ -3171,6 +3181,7 @@ static __init int rb_init_debugfs(void)
 }
 
 fs_initcall(rb_init_debugfs);
+#endif
 
 #ifdef CONFIG_HOTPLUG_CPU
 static int rb_cpu_notify(struct notifier_block *self,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 076fa6f..3aa0a0d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -284,13 +284,12 @@ void trace_wake_up(void)
 static int __init set_buf_size(char *str)
 {
 	unsigned long buf_size;
-	int ret;
 
 	if (!str)
 		return 0;
-	ret = strict_strtoul(str, 0, &buf_size);
+	buf_size = memparse(str, &str);
 	/* nr_entries can not be zero */
-	if (ret < 0 || buf_size == 0)
+	if (buf_size == 0)
 		return 0;
 	trace_buf_size = buf_size;
 	return 1;
@@ -2053,25 +2052,23 @@ static int tracing_open(struct inode *inode, struct file *file)
 static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct tracer *t = m->private;
+	struct tracer *t = v;
 
 	(*pos)++;
 
 	if (t)
 		t = t->next;
 
-	m->private = t;
-
 	return t;
 }
 
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
-	struct tracer *t = m->private;
+	struct tracer *t;
 	loff_t l = 0;
 
 	mutex_lock(&trace_types_lock);
-	for (; t && l < *pos; t = t_next(m, t, &l))
+	for (t = trace_types; t && l < *pos; t = t_next(m, t, &l))
 		;
 
 	return t;
@@ -2107,18 +2104,10 @@ static struct seq_operations show_traces_seq_ops = {
 
 static int show_traces_open(struct inode *inode, struct file *file)
 {
-	int ret;
-
 	if (tracing_disabled)
 		return -ENODEV;
 
-	ret = seq_open(file, &show_traces_seq_ops);
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		m->private = trace_types;
-	}
-
-	return ret;
+	return seq_open(file, &show_traces_seq_ops);
 }
 
 static ssize_t
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6e735d4..3548ae5 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -597,6 +597,7 @@ print_graph_function(struct trace_iterator *iter)
 
 extern struct pid *ftrace_pid_trace;
 
+#ifdef CONFIG_FUNCTION_TRACER
 static inline int ftrace_trace_task(struct task_struct *task)
 {
 	if (!ftrace_pid_trace)
@@ -604,6 +605,12 @@ static inline int ftrace_trace_task(struct task_struct *task)
 
 	return test_tsk_trace_trace(task);
 }
+#else
+static inline int ftrace_trace_task(struct task_struct *task)
+{
+	return 1;
+}
+#endif
 
 /*
  * trace_iterator_flags is an enumeration that defines bit
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index aa08be6..53c8fd3 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -300,10 +300,18 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
+	struct ftrace_event_call *call = NULL;
+	loff_t l;
+
 	mutex_lock(&event_mutex);
-	if (*pos == 0)
-		m->private = ftrace_events.next;
-	return t_next(m, NULL, pos);
+
+	m->private = ftrace_events.next;
+	for (l = 0; l <= *pos; ) {
+		call = t_next(m, NULL, &l);
+		if (!call)
+			break;
+	}
+	return call;
 }
 
 static void *
@@ -332,10 +340,18 @@ s_next(struct seq_file *m, void *v, loff_t *pos)
 
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
+	struct ftrace_event_call *call = NULL;
+	loff_t l;
+
 	mutex_lock(&event_mutex);
-	if (*pos == 0)
-		m->private = ftrace_events.next;
-	return s_next(m, NULL, pos);
+
+	m->private = ftrace_events.next;
+	for (l = 0; l <= *pos; ) {
+		call = s_next(m, NULL, &l);
+		if (!call)
+			break;
+	}
+	return call;
 }
 
 static int t_show(struct seq_file *m, void *v)
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 90f1347..7402144 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -302,8 +302,7 @@ ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
 	if (count == -1)
 		seq_printf(m, ":unlimited\n");
 	else
-		seq_printf(m, ":count=%ld", count);
-	seq_putc(m, '\n');
+		seq_printf(m, ":count=%ld\n", count);
 
 	return 0;
 }
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 9bece96..7b62781 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -155,25 +155,19 @@ int __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap)
 EXPORT_SYMBOL_GPL(__ftrace_vprintk);
 
 static void *
-t_next(struct seq_file *m, void *v, loff_t *pos)
+t_start(struct seq_file *m, loff_t *pos)
 {
-	const char **fmt = m->private;
-	const char **next = fmt;
-
-	(*pos)++;
+	const char **fmt = __start___trace_bprintk_fmt + *pos;
 
 	if ((unsigned long)fmt >= (unsigned long)__stop___trace_bprintk_fmt)
 		return NULL;
-
-	next = fmt;
-	m->private = ++next;
-
 	return fmt;
 }
 
-static void *t_start(struct seq_file *m, loff_t *pos)
+static void *t_next(struct seq_file *m, void * v, loff_t *pos)
 {
-	return t_next(m, NULL, pos);
+	(*pos)++;
+	return t_start(m, pos);
 }
 
 static int t_show(struct seq_file *m, void *v)
@@ -224,15 +218,7 @@ static const struct seq_operations show_format_seq_ops = {
 static int
 ftrace_formats_open(struct inode *inode, struct file *file)
 {
-	int ret;
-
-	ret = seq_open(file, &show_format_seq_ops);
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-
-		m->private = __start___trace_bprintk_fmt;
-	}
-	return ret;
+	return seq_open(file, &show_format_seq_ops);
 }
 
 static const struct file_operations ftrace_formats_fops = {
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index c006437..e66f5e4 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -199,17 +199,13 @@ static void *stat_seq_start(struct seq_file *s, loff_t *pos)
 	mutex_lock(&session->stat_mutex);
 
 	/* If we are in the beginning of the file, print the headers */
-	if (!*pos && session->ts->stat_headers) {
-		(*pos)++;
+	if (!*pos && session->ts->stat_headers)
 		return SEQ_START_TOKEN;
-	}
 
 	node = rb_first(&session->stat_root);
 	for (i = 0; node && i < *pos; i++)
 		node = rb_next(node);
 
-	(*pos)++;
-
 	return node;
 }
 
