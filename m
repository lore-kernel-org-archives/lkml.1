Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753402AbYLRBJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYLRBJu (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 20:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYLRBJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 20:09:40 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:53324 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbYLRBJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 20:09:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=DtBWIi+DRHcePr7gPUVN/3/VqbRQrauy8XtZiBZ6KYVA0C7SXwPaYPMKkS7kLpEfgq
         /MVmi5DZJMIr2QIV4vkiFmZ5v6d+N9mEAUEtdPrBs6PxQYcKbZ/CgTJvfqGM7F1epWgp
         fSThm4gtF9vFVeHIjcGTFvqbgc0BbX+1A+rcM=
Message-ID: <4949A2CC.6040209@gmail.com>
Date: Thu, 18 Dec 2008 02:09:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] tracing/function-graph-tracer: prevent from hrtimer interrupt
 infinite loop
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix a system hang on slow systems

While testing the function graph tracer on VirtualBox, I had a system hang
immediatly after enabling the tracer.
If hrtimer is enabled on kernel, a slow system can spend too much time during
tracing the hrtimer_interrupt which will do eternal loops, assuming it always
have to retry its process because too much time elapsed during its time
update.
Now we provide a feature which lurks at the number of retries on
hrtimer_interrupt. After 10 retries, the function graph tracer will definetly stop
its tracing.

Changes in v2 (Andrew's comments):

_ Moved ftrace_graph_hrtimer_*() from linux/ftrace.h to kernel/trace/trace.c, also
  uninlined them.
_ Turn ftrace_graph_hrtimer_loop into static
_ Fix my evil english :-)
_ Very small other fixes...

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/ftrace.h |   10 ++++++++++
 kernel/hrtimer.c       |    5 +++++
 kernel/trace/ftrace.c  |   29 +++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 286af82..4874782 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -408,6 +408,13 @@ extern void unregister_ftrace_graph(void);
 extern void ftrace_graph_init_task(struct task_struct *t);
 extern void ftrace_graph_exit_task(struct task_struct *t);
 
+/*
+ * Prevent infinite loops on hrtimer_interrupt()
+ * due to tracing on slow systems.
+ */
+extern void ftrace_graph_hrtimer_enter(void);
+extern void ftrace_graph_hrtimer_retry(void);
+
 static inline int task_curr_ret_stack(struct task_struct *t)
 {
 	return t->curr_ret_stack;
@@ -437,6 +444,9 @@ static inline int task_curr_ret_stack(struct task_struct *tsk)
 
 static inline void pause_graph_tracing(void) { }
 static inline void unpause_graph_tracing(void) { }
+
+static inline void ftrace_graph_hrtimer_enter(void) { }
+static inline void ftrace_graph_hrtimer_retry(void) { }
 #endif
 
 #ifdef CONFIG_TRACING
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index b741f85..12fa4d9 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -44,6 +44,7 @@
 #include <linux/seq_file.h>
 #include <linux/err.h>
 #include <linux/debugobjects.h>
+#include <linux/ftrace.h>
 
 #include <asm/uaccess.h>
 
@@ -1186,7 +1187,11 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	cpu_base->nr_events++;
 	dev->next_event.tv64 = KTIME_MAX;
 
+	ftrace_graph_hrtimer_enter();
  retry:
+	/* Prevent from infinite loop on slow systems while tracing */
+	ftrace_graph_hrtimer_retry();
+
 	now = ktime_get();
 
 	expires_next.tv64 = KTIME_MAX;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a12f80e..0b3a7a8 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1955,6 +1955,9 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 static atomic_t ftrace_graph_active;
 
+/* Count number of retries attempts in hrtimer_interrupt() */
+static DEFINE_PER_CPU(int, ftrace_graph_hrtimer_loop);
+
 int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace)
 {
 	return 0;
@@ -2095,6 +2098,32 @@ void ftrace_graph_exit_task(struct task_struct *t)
 	kfree(ret_stack);
 }
 
+/*
+ * Those two functions prevent infinite loops on hrtimer_interrupt
+ * because the function graph tracer can consume too much time processing
+ * on slow systems, and the hrtimer_interrupt can relaunch its processing
+ * if too much time elapsed during its previous time update.
+ *
+ * Note that we don't need an atomic counter for loops here because
+ * interrupts are disabled in hrtimer_interrupt.
+ */
+
+void ftrace_graph_hrtimer_enter(void)
+{
+	__get_cpu_var(ftrace_graph_hrtimer_loop) = 0;
+}
+
+void ftrace_graph_hrtimer_retry(void)
+{
+	__get_cpu_var(ftrace_graph_hrtimer_loop)++;
+
+	if (__get_cpu_var(ftrace_graph_hrtimer_loop) == 10) {
+		ftrace_graph_stop();
+		printk(KERN_WARNING "function-graph-tracer: hrtimer_interrupt exceeded"
+				" 10 loops. Stopping tracing\n");
+	}
+}
+
 void ftrace_graph_stop(void)
 {
 	ftrace_stop();
-- 
1.6.0.4
