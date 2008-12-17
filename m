Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753241AbYLQXxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbYLQXxS (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYLQXwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:52:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:65497 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbYLQXwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:52:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=nEOQ0kgihqvBZWKYPsg5o2yFqtKaCTBTAl3dCakYpzCqHdFp1Zr/BMmYKfjiZlTvsm
         ljYcL6fL8SOvM+3rbVkOMA4tqNUkmVgRNlp5ey34drLW5lwFXPiOT0x9OrenW+4vjz29
         uHnVZhXT1ZH0A12aj/TZMvZveMPFkggpBiNRQ=
Message-ID: <494990CF.70504@gmail.com>
Date: Thu, 18 Dec 2008 00:52:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/function-graph-tracer: prevent from hrtimer interrupt
 eternal loop
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix a system hang on slow systems

While testing the function graph tracer on VirtualBox, I had a system hang
immediately after enabling the tracer.
If hrtimer is enabled on kernel, a slow system can spend too much time during
tracing the hrtimer_interrupt which will do eternal loops, assuming it always
have to retry its process because too much time elapsed during its time
update.
Now we provide a feature which lurks at the number of retries on
hrtimer_interrupt. After 10 retries, the function graph tracer will finally stop
its tracing.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c |    2 ++
 include/linux/ftrace.h   |   31 +++++++++++++++++++++++++++++++
 kernel/hrtimer.c         |    5 +++++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1b43086..244f178 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -389,6 +389,8 @@ void ftrace_nmi_exit(void)
 
 #endif /* !CONFIG_DYNAMIC_FTRACE */
 
+DEFINE_PER_CPU(int, ftrace_graph_hrtimer_loop) = LOCAL_INIT(0);
+
 /* Add a function return address to the trace stack on thread info.*/
 static int push_return_trace(unsigned long ret, unsigned long long time,
 				unsigned long func, int *depth)
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 286af82..39be782 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -408,6 +408,34 @@ extern void unregister_ftrace_graph(void);
 extern void ftrace_graph_init_task(struct task_struct *t);
 extern void ftrace_graph_exit_task(struct task_struct *t);
 
+/*
+ * Those two functions prevent from eternal loops on hrtimer_interrupt
+ * because the function graph tracer can cause two much time processing
+ * on slow systems, and the hrtimer_interrupt can relaunch its processing
+ * if too much time elapsed during its previous time update.
+ *
+ * Note that we don't need an atomic counter for loops here because
+ * interrupts are disabled in hrtimer_interrupt.
+ */
+
+extern DEFINE_PER_CPU(int, ftrace_graph_hrtimer_loop);
+
+static inline void ftrace_graph_hrtimer_enter(void)
+{
+	__get_cpu_var(ftrace_graph_hrtimer_loop) = 0;
+}
+
+static inline void ftrace_graph_hrtimer_retry(void)
+{
+	__get_cpu_var(ftrace_graph_hrtimer_loop)++;
+
+	if (__get_cpu_var(ftrace_graph_hrtimer_loop) == 10) {
+		ftrace_graph_stop();
+		printk(KERN_WARNING "function-graph-tracer: hrtimer_interrupt "
+				"exceeded 10 loops. Stopping tracing\n");
+	}
+}
+
 static inline int task_curr_ret_stack(struct task_struct *t)
 {
 	return t->curr_ret_stack;
@@ -437,6 +465,9 @@ static inline int task_curr_ret_stack(struct task_struct *tsk)
 
 static inline void pause_graph_tracing(void) { }
 static inline void unpause_graph_tracing(void) { }
+
+static inline void ftrace_graph_hrtimer_enter(void) { };
+static inline void ftrace_graph_hrtimer_retry(void) { };
 #endif
 
 #ifdef CONFIG_TRACING
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index b741f85..662eb53 100644
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
+	/* Prevent from eternal loop on slow systems while tracing */
+	ftrace_graph_hrtimer_retry();
+
 	now = ktime_get();
 
 	expires_next.tv64 = KTIME_MAX;
-- 
1.6.0.4

