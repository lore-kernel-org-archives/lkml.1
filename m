Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbZDNR3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbZDNR3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbZDNR0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:26:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64772 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbZDNR0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:26:45 -0400
Message-Id: <20090414172640.993528505@goodmis.org>
References: <20090414172337.280621613@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 14 Apr 2009 13:23:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: [PATCH 3/8] tracing: make trace_seq operations available for core kernel
Content-Disposition: inline; filename=0003-tracing-make-trace_seq-operations-available-for-cor.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

In the process to make TRACE_EVENT macro work for modules, the trace_seq
operations must be available for core kernel code.

These operations are quite useful and can be used for other implementations.

The main idea is that we create a trace_seq handle that acts very much
like the seq_file handle.

	struct trace_seq *s = kmalloc(sizeof(*s, GFP_KERNEL);

	trace_seq_init(s);
	trace_seq_printf(s, "some data %d\n", variable);

	printk("%s", s->buffer);

The main use is to allow a top level function call several other functions
that may store printf like data into the buffer. Then at the end, the top
level function can process all the data with any method it would like to.
It could be passed to userspace, output via printk or even use seq_file:

	trace_seq_to_user(s, ubuf, cnt);
	seq_puts(m, s->buffer);

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/trace_seq.h   |   89 +++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h        |   15 +------
 kernel/trace/trace_output.h |   16 +-------
 3 files changed, 92 insertions(+), 28 deletions(-)
 create mode 100644 include/linux/trace_seq.h

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
new file mode 100644
index 0000000..28051da
--- /dev/null
+++ b/include/linux/trace_seq.h
@@ -0,0 +1,89 @@
+#ifndef _LINUX_TRACE_SEQ_H
+#define _LINUX_TRACE_SEQ_H
+
+/*
+ * Trace sequences are used to allow a function to call several other functions
+ * to create a string of data to use (up to a max of PAGE_SIZE.
+ */
+
+struct trace_seq {
+	unsigned char		buffer[PAGE_SIZE];
+	unsigned int		len;
+	unsigned int		readpos;
+};
+
+static inline void
+trace_seq_init(struct trace_seq *s)
+{
+	s->len = 0;
+	s->readpos = 0;
+}
+
+/*
+ * Currently only defined when tracing is enabled.
+ */
+#ifdef CONFIG_TRACING
+extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern int
+trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary);
+extern void trace_print_seq(struct seq_file *m, struct trace_seq *s);
+extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
+				 size_t cnt);
+extern int trace_seq_puts(struct trace_seq *s, const char *str);
+extern int trace_seq_putc(struct trace_seq *s, unsigned char c);
+extern int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len);
+extern int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
+				size_t len);
+extern void *trace_seq_reserve(struct trace_seq *s, size_t len);
+extern int trace_seq_path(struct trace_seq *s, struct path *path);
+
+#else /* CONFIG_TRACING */
+static inline int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)))
+{
+	return 0;
+}
+static inline int
+trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
+{
+	return 0;
+}
+
+static inline void trace_print_seq(struct seq_file *m, struct trace_seq *s)
+{
+}
+static inline ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
+				 size_t cnt)
+{
+	return 0;
+}
+static inline int trace_seq_puts(struct trace_seq *s, const char *str)
+{
+	return 0;
+}
+static inline int trace_seq_putc(struct trace_seq *s, unsigned char c);
+{
+	return 0;
+}
+static inline int
+trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
+{
+	return 0;
+}
+static inline int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
+				       size_t len)
+{
+	return 0;
+}
+static inline void *trace_seq_reserve(struct trace_seq *s, size_t len)
+{
+	return NULL;
+}
+static inline int trace_seq_path(struct trace_seq *s, struct path *path)
+{
+	return 0;
+}
+#endif /* CONFIG_TRACING */
+
+#endif /* _LINUX_TRACE_SEQ_H */
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index b05b6ac..1882846 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -12,6 +12,8 @@
 #include <linux/kmemtrace.h>
 #include <trace/power.h>
 
+#include <linux/trace_seq.h>
+
 enum trace_type {
 	__TRACE_FIRST_TYPE = 0,
 
@@ -423,19 +425,6 @@ struct tracer {
 	struct tracer_stat	*stats;
 };
 
-struct trace_seq {
-	unsigned char		buffer[PAGE_SIZE];
-	unsigned int		len;
-	unsigned int		readpos;
-};
-
-static inline void
-trace_seq_init(struct trace_seq *s)
-{
-	s->len = 0;
-	s->readpos = 0;
-}
-
 
 #define TRACE_PIPE_ALL_CPU	-1
 
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 9163021..5c7cbfb 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -1,6 +1,7 @@
 #ifndef __TRACE_EVENTS_H
 #define __TRACE_EVENTS_H
 
+#include <linux/trace_seq.h>
 #include "trace.h"
 
 typedef enum print_line_t (*trace_print_func)(struct trace_iterator *iter,
@@ -20,24 +21,9 @@ trace_print_bprintk_msg_only(struct trace_iterator *iter);
 extern enum print_line_t
 trace_print_printk_msg_only(struct trace_iterator *iter);
 
-extern void trace_print_seq(struct seq_file *m, struct trace_seq *s);
-
-extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int
-trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary);
 extern int
 seq_print_ip_sym(struct trace_seq *s, unsigned long ip,
 		unsigned long sym_flags);
-extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
-				 size_t cnt);
-extern int trace_seq_puts(struct trace_seq *s, const char *str);
-extern int trace_seq_putc(struct trace_seq *s, unsigned char c);
-extern int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len);
-extern int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
-				size_t len);
-extern void *trace_seq_reserve(struct trace_seq *s, size_t len);
-extern int trace_seq_path(struct trace_seq *s, struct path *path);
 extern int seq_print_userip_objs(const struct userstack_entry *entry,
 				 struct trace_seq *s, unsigned long sym_flags);
 extern int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
-- 
1.6.2.1

-- 
