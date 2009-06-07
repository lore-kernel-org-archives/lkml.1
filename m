Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbZFGKWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbZFGKWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbZFGKWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:22:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:56788 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922AbZFGKWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:22:42 -0400
Date: Sun, 7 Jun 2009 10:22:20 GMT
From: tip-bot for Steven Whitehouse <swhiteho@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, swhiteho@redhat.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, swhiteho@redhat.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1244037123.29604.603.camel@localhost.localdomain>
References: <1244037123.29604.603.camel@localhost.localdomain>
Subject: [tip:tracing/core] tracing: fix multiple use of __print_flags and __print_symbolic
Message-ID: <tip-56d8bd3f0b98972312cad683947ec90b21011199@git.kernel.org>
Git-Commit-ID: 56d8bd3f0b98972312cad683947ec90b21011199
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 10:22:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56d8bd3f0b98972312cad683947ec90b21011199
Gitweb:     http://git.kernel.org/tip/56d8bd3f0b98972312cad683947ec90b21011199
Author:     Steven Whitehouse <swhiteho@redhat.com>
AuthorDate: Wed, 3 Jun 2009 14:52:03 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 3 Jun 2009 10:29:48 -0400

tracing: fix multiple use of __print_flags and __print_symbolic

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
 
