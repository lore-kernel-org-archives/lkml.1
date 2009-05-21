Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbZEUDSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbZEUDSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 23:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbZEUDRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 23:17:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbZEUDRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 23:17:49 -0400
Message-Id: <20090521031748.789938997@goodmis.org>
References: <20090521031711.494593605@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 20 May 2009 23:17:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH 1/5] tracing: add __print_flags for events
Content-Disposition: inline; filename=0001-tracing-add-__print_flags-for-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Developers have been asking for the ability in the ftrace event tracer
to display names of bits in a flags variable.

Instead of printing out c2, it would be easier to read FOO|BAR|GOO,
assuming that FOO is bit 1, BAR is bit 6 and GOO is bit 7.

Some examples where this would be useful are the state flags in a context
switch, kmalloc flags, and even permision flags in accessing files.

[
  v2 changes include:

  Frederic Weisbecker's idea of using a mask instead of bits,
  thus we can output GFP_KERNEL instead of GPF_WAIT|GFP_IO|GFP_FS.

  Li Zefan's idea of allowing the caller of __print_flags to add their
  own delimiter (or no delimiter) where we can get for file permissions
  rwx instead of r|w|x.
]

[
  v3 changes:

   Christoph Hellwig's idea of using an array instead of va_args.
]

[ Impact: better displaying of flags in trace output ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |   13 ++++++++++++-
 include/trace/ftrace.h       |   14 ++++++++++++++
 kernel/trace/trace_output.c  |   38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index bae51dd..4b58cf1 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -3,12 +3,23 @@
 
 #include <linux/trace_seq.h>
 #include <linux/ring_buffer.h>
-
+#include <linux/percpu.h>
 
 struct trace_array;
 struct tracer;
 struct dentry;
 
+DECLARE_PER_CPU(struct trace_seq, ftrace_event_seq);
+
+struct trace_print_flags {
+	unsigned long		mask;
+	const char		*name;
+};
+
+const char *ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
+				   unsigned long flags,
+				   const struct trace_print_flags *flag_array);
+
 /*
  * The trace entry - the most basic unit of tracing. This is what
  * is printed in the end as a single line in the trace output, such as:
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index edb02bc..063d227 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -87,6 +87,7 @@
  *	struct trace_seq *s = &iter->seq;
  *	struct ftrace_raw_<call> *field; <-- defined in stage 1
  *	struct trace_entry *entry;
+ *	struct trace_seq *p;
  *	int ret;
  *
  *	entry = iter->ent;
@@ -98,7 +99,9 @@
  *
  *	field = (typeof(field))entry;
  *
+ *	p = get_cpu_var(ftrace_event_seq);
  *	ret = trace_seq_printf(s, <TP_printk> "\n");
+ *	put_cpu();
  *	if (!ret)
  *		return TRACE_TYPE_PARTIAL_LINE;
  *
@@ -119,6 +122,14 @@
 #undef __get_str
 #define __get_str(field)	((char *)__entry + __entry->__str_loc_##field)
 
+#undef __print_flags
+#define __print_flags(flag, delim, flag_array...)			\
+	({								\
+		static const struct trace_print_flags flags[] =		\
+			{ flag_array, { -1, NULL }};			\
+		ftrace_print_flags_seq(p, delim, flag, flags);		\
+	})
+
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
 enum print_line_t							\
@@ -127,6 +138,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 	struct trace_seq *s = &iter->seq;				\
 	struct ftrace_raw_##call *field;				\
 	struct trace_entry *entry;					\
+	struct trace_seq *p;						\
 	int ret;							\
 									\
 	entry = iter->ent;						\
@@ -138,7 +150,9 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 									\
 	field = (typeof(field))entry;					\
 									\
+	p = &get_cpu_var(ftrace_event_seq);				\
 	ret = trace_seq_printf(s, #call ": " print);			\
+	put_cpu();							\
 	if (!ret)							\
 		return TRACE_TYPE_PARTIAL_LINE;				\
 									\
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 489c0e8..e51bcc0 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -14,6 +14,8 @@
 /* must be a power of 2 */
 #define EVENT_HASHSIZE	128
 
+DEFINE_PER_CPU(struct trace_seq, ftrace_event_seq);
+
 static DEFINE_MUTEX(trace_event_mutex);
 static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
 
@@ -212,6 +214,42 @@ int trace_seq_path(struct trace_seq *s, struct path *path)
 	return 0;
 }
 
+const char *
+ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
+		       unsigned long flags,
+		       const struct trace_print_flags *flag_array)
+{
+	unsigned long mask;
+	const char *str;
+	int i;
+
+	trace_seq_init(p);
+
+	for (i = 0;  flag_array[i].name && flags; i++) {
+
+		mask = flag_array[i].mask;
+		if ((flags & mask) != mask)
+			continue;
+
+		str = flag_array[i].name;
+		flags &= ~mask;
+		if (p->len && delim)
+			trace_seq_puts(p, delim);
+		trace_seq_puts(p, str);
+	}
+
+	/* check for left over flags */
+	if (flags) {
+		if (p->len && delim)
+			trace_seq_puts(p, delim);
+		trace_seq_printf(p, "0x%lx", flags);
+	}
+
+	trace_seq_putc(p, 0);
+
+	return p->buffer;
+}
+
 #ifdef CONFIG_KRETPROBES
 static inline const char *kretprobed(const char *name)
 {
-- 
1.6.2.4

-- 
