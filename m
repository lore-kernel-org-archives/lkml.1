Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbZFYJRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbZFYJRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbZFYJRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:17:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:57998 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbZFYJRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:17:21 -0400
Date: Thu, 25 Jun 2009 09:16:22 GMT
From: tip-bot for Paul Mundt <lethal@linux-sh.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, jcm@jonmasters.org, lethal@linux-sh.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, jcm@jonmasters.org, tglx@linutronix.de,
       lethal@linux-sh.org, mingo@elte.hu
In-Reply-To: <20090625053012.GB19944@linux-sh.org>
References: <20090625053012.GB19944@linux-sh.org>
Subject: [tip:tracing/urgent] ring-buffer: Make it generally available
Message-ID: <tip-1155de47cd66d0c496d5a6fb2223e980ef1285b2@git.kernel.org>
Git-Commit-ID: 1155de47cd66d0c496d5a6fb2223e980ef1285b2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 25 Jun 2009 09:16:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1155de47cd66d0c496d5a6fb2223e980ef1285b2
Gitweb:     http://git.kernel.org/tip/1155de47cd66d0c496d5a6fb2223e980ef1285b2
Author:     Paul Mundt <lethal@linux-sh.org>
AuthorDate: Thu, 25 Jun 2009 14:30:12 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Jun 2009 10:31:30 +0200

ring-buffer: Make it generally available

In hunting down the cause for the hwlat_detector ring buffer spew in
my failed -next builds it became obvious that folks are now treating
ring_buffer as something that is generic independent of tracing and thus,
suitable for public driver consumption.

Given that there are only a few minor areas in ring_buffer that have any
reliance on CONFIG_TRACING or CONFIG_FUNCTION_TRACER, provide stubs for
those and make it generally available.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Jon Masters <jcm@jonmasters.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090625053012.GB19944@linux-sh.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/Makefile            |    1 +
 kernel/trace/ring_buffer.c |   11 +++++++++++
 kernel/trace/trace.h       |    7 +++++++
 3 files changed, 19 insertions(+), 0 deletions(-)

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
