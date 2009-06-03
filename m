Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbZFCNwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbZFCNwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 09:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbZFCNwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 09:52:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33665 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbZFCNwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 09:52:32 -0400
Subject: trace: fix multiple use of __print_flags and __print_symbolic
From: Steven Whitehouse <swhiteho@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.DEB.2.00.0906030917010.14994@gandalf.stny.rr.com>
References: <1244019900.29604.588.camel@localhost.localdomain>
	 <4A26474C.1000900@cn.fujitsu.com>
	 <1244033875.29604.599.camel@localhost.localdomain>
	 <alpine.DEB.2.00.0906030917010.14994@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Wed, 03 Jun 2009 14:52:03 +0100
Message-Id: <1244037123.29604.603.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index b4ec83a..1c58f05 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -100,6 +100,7 @@
  *	field = (typeof(field))entry;
  *
  *	p = get_cpu_var(ftrace_event_seq);
+ *	trace_seq_init(p);
  *	ret = trace_seq_printf(s, <TP_printk> "\n");
  *	put_cpu();
  *	if (!ret)
@@ -159,6 +160,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 	field = (typeof(field))entry;					\
 									\
 	p = &get_cpu_var(ftrace_event_seq);				\
+	trace_seq_init(p);						\
 	ret = trace_seq_printf(s, #call ": " print);			\
 	put_cpu();							\
 	if (!ret)							\
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index c12d95d..ac6ced1 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -222,10 +222,9 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 {
 	unsigned long mask;
 	const char *str;
+	const char *ret = p->buffer + p->len;
 	int i;
 
-	trace_seq_init(p);
-
 	for (i = 0;  flag_array[i].name && flags; i++) {
 
 		mask = flag_array[i].mask;
@@ -248,7 +247,7 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
 
 	trace_seq_putc(p, 0);
 
-	return p->buffer;
+	return ret;
 }
 
 const char *
@@ -256,8 +255,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 			 const struct trace_print_flags *symbol_array)
 {
 	int i;
-
-	trace_seq_init(p);
+	const char *ret = p->buffer + p->len;
 
 	for (i = 0;  symbol_array[i].name; i++) {
 
@@ -273,7 +271,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 		
 	trace_seq_putc(p, 0);
 
-	return p->buffer;
+	return ret;
 }
 
 #ifdef CONFIG_KRETPROBES


