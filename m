Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbYIDI1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbYIDI1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757747AbYIDIYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:24:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37027 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710AbYIDIYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:24:15 -0400
Subject: [PATCH] ftrace: make ftrace_printk usable with the other tracers
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080903214249.661170580@goodmis.org>
References: <20080903214249.661170580@goodmis.org>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 10:24:14 +0200
Message-Id: <1220516654.8609.200.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: ftrace: make ftrace_printk usable with the other tracers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Sep 02 21:12:13 CEST 2008

Currently ftrace_printk only works with the ftrace tracer, switch it to an
iter_ctrl setting so we can make us of them with other tracers too.

[rostedt@redhat.com: tweak to the disable condition]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/trace/trace.c |   41 +++++++++++++++++++++++++++--------------
 kernel/trace/trace.h |    2 ++
 2 files changed, 29 insertions(+), 14 deletions(-)

Index: linux-2.6/kernel/trace/trace.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace.c
+++ linux-2.6/kernel/trace/trace.c
@@ -235,6 +235,7 @@ static const char *trace_options[] = {
 	"block",
 	"stacktrace",
 	"sched-tree",
+	"ftrace_printk",
 	NULL
 };
 
@@ -3086,9 +3098,10 @@ static __init void tracer_init_debugfs(v
 
 int __ftrace_printk(unsigned long ip, const char *fmt, ...)
 {
-	struct trace_array *tr = &global_trace;
 	static DEFINE_SPINLOCK(trace_buf_lock);
 	static char trace_buf[TRACE_BUF_SIZE];
+
+	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
 	struct trace_entry *entry;
 	unsigned long flags;
@@ -3096,7 +3109,7 @@ int __ftrace_printk(unsigned long ip, co
 	va_list ap;
 	int cpu, len = 0, write, written = 0;
 
-	if (likely(!ftrace_function_enabled))
+	if (!(trace_flags & TRACE_ITER_PRINTK) || !tr->ctrl || tracing_disabled)
 		return 0;
 
 	local_irq_save(flags);
@@ -3104,7 +3117,7 @@ int __ftrace_printk(unsigned long ip, co
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
 
-	if (unlikely(disabled != 1 || !ftrace_function_enabled))
+	if (unlikely(disabled != 1))
 		goto out;
 
 	spin_lock(&trace_buf_lock);
Index: linux-2.6/kernel/trace/trace.h
===================================================================
--- linux-2.6.orig/kernel/trace/trace.h
+++ linux-2.6/kernel/trace/trace.h
@@ -356,6 +357,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_BLOCK		= 0x80,
 	TRACE_ITER_STACKTRACE		= 0x100,
 	TRACE_ITER_SCHED_TREE		= 0x200,
+	TRACE_ITER_PRINTK		= 0x400,
 };
 
 #endif /* _LINUX_KERNEL_TRACE_H */


