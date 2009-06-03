Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbZFCPTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbZFCPTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbZFCPSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:18:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59129 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367AbZFCPSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:18:23 -0400
Message-Id: <20090603151821.266956360@goodmis.org>
References: <20090603151724.144915858@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 03 Jun 2009 11:17:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/5] tracing: fix multiple use of __print_flags and __print_symbolic
Content-Disposition: inline; filename=0004-tracing-fix-multiple-use-of-__print_flags-and-__prin.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Here is an updated patch to include the extra call to
trace_seq_init() as requested. This is vs. the latest
-tip tree and fixes the use of multiple __print_flags
and __print_symbolic in a single tracer. Also tested
to ensure its working now:

mount.gfs2-2534  [000]   235.850587: gfs2_glock_queue: 8.7 glock 1:2 dequeue PR
mount.gfs2-2534  [000]   235.850591: gfs2_demote_rq: 8.7 glock 1:0 demote EX to NL flags:DI
mount.gfs2-2534  [000]   235.850591: gfs2_glock_queue: 8.7 glock 1:0 dequeue EX
glock_workqueue-2529  [000]   235.850666: gfs2_glock_state_change: 8.7 glock 1:0 state EX => NL tgt:NL dmt:NL flags:lDpI
glock_workqueue-2529  [000]   235.850672: gfs2_glock_put: 8.7 glock 1:0 state NL => IV flags:I

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
LKML-Reference: <1244037123.29604.603.camel@localhost.localdomain>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h      |    2 ++
 kernel/trace/trace_output.c |   10 ++++------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index b5478da..40ede4d 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -104,6 +104,7 @@
  *	field = (typeof(field))entry;
  *
  *	p = get_cpu_var(ftrace_event_seq);
+ *	trace_seq_init(p);
  *	ret = trace_seq_printf(s, <TP_printk> "\n");
  *	put_cpu();
  *	if (!ret)
@@ -167,6 +168,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 	field = (typeof(field))entry;					\
 									\
 	p = &get_cpu_var(ftrace_event_seq);				\
+	trace_seq_init(p);						\
 	ret = trace_seq_printf(s, #call ": " print);			\
 	put_cpu();							\
 	if (!ret)							\
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 8dadbbb..8afeea4 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -223,10 +223,9 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 {
 	unsigned long mask;
 	const char *str;
+	const char *ret = p->buffer + p->len;
 	int i;
 
-	trace_seq_init(p);
-
 	for (i = 0;  flag_array[i].name && flags; i++) {
 
 		mask = flag_array[i].mask;
@@ -249,7 +248,7 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 
 	trace_seq_putc(p, 0);
 
-	return p->buffer;
+	return ret;
 }
 EXPORT_SYMBOL(ftrace_print_flags_seq);
 
@@ -258,8 +257,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 			 const struct trace_print_flags *symbol_array)
 {
 	int i;
-
-	trace_seq_init(p);
+	const char *ret = p->buffer + p->len;
 
 	for (i = 0;  symbol_array[i].name; i++) {
 
@@ -275,7 +273,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 		
 	trace_seq_putc(p, 0);
 
-	return p->buffer;
+	return ret;
 }
 EXPORT_SYMBOL(ftrace_print_symbols_seq);
 
-- 
1.6.3.1

-- 
