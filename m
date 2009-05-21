Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbZEUDS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbZEUDS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 23:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbZEUDRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 23:17:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbZEUDRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 23:17:49 -0400
Message-Id: <20090521031749.415088496@goodmis.org>
References: <20090521031711.494593605@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 20 May 2009 23:17:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH 4/5] tracing: add __print_symbolic to trace events
Content-Disposition: inline; filename=0004-tracing-add-__print_symbolic-to-trace-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds __print_symbolic which is similar to __print_flags but
works for an enumeration type instead. That is, there is only a one to one
mapping between the values and the symbols. When a match is made, then
it is printed, otherwise the hex value is outputed.

[ Impact: add interface for showing symbol names in events ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    3 +++
 include/trace/ftrace.h       |    8 ++++++++
 kernel/trace/trace_output.c  |   25 +++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4b58cf1..bbf40f6 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -20,6 +20,9 @@ const char *ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 				   unsigned long flags,
 				   const struct trace_print_flags *flag_array);
 
+const char *ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
+				     const struct trace_print_flags *symbol_array);
+
 /*
  * The trace entry - the most basic unit of tracing. This is what
  * is printed in the end as a single line in the trace output, such as:
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 063d227..d00863d 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -130,6 +130,14 @@
 		ftrace_print_flags_seq(p, delim, flag, flags);		\
 	})
 
+#undef __print_symbolic
+#define __print_symbolic(value, symbol_array...)			\
+	({								\
+		static const struct trace_print_flags symbols[] =	\
+			{ symbol_array, { -1, NULL }};			\
+		ftrace_print_symbols_seq(p, value, symbols);		\
+	})
+
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
 enum print_line_t							\
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index e51bcc0..4d87a55 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -250,6 +250,31 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 	return p->buffer;
 }
 
+const char *
+ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
+			 const struct trace_print_flags *symbol_array)
+{
+	int i;
+
+	trace_seq_init(p);
+
+	for (i = 0;  symbol_array[i].name; i++) {
+
+		if (val != symbol_array[i].mask)
+			continue;
+
+		trace_seq_puts(p, symbol_array[i].name);
+		break;
+	}
+
+	if (!p->len)
+		trace_seq_printf(p, "0x%lx", val);
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
