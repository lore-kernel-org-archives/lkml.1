Return-Path: <linux-kernel-owner+w=401wt.eu-S1762598AbYFEUyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762598AbYFEUyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYFEUyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:54:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60514 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762511AbYFEUyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:54:08 -0400
Date: Thu, 5 Jun 2008 16:54:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@osdl.org
Subject: [PATCH] ftrace: disable function tracing bringing up new CPU
Message-ID: <Pine.LNX.4.58.0806051648380.13380@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Peter Zijlstra found that taking down and bringing up a new CPU caused
ftrace to crash the kernel. This was due to some arch calls that were
being traced by the function tracer before the smp_processor_id was set
up. Since the function tracer uses smp_processor_id it caused a triple
fault.

Instead of adding notrace all over the architecture code to prevent
this problem, it is easier to simply disable the function tracer
when bringing up a new CPU.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h            |   11 ++++++++---
 kernel/cpu.c                      |    9 +++++++++
 kernel/trace/ftrace.c             |   28 ++++++++++++++++++++++++++++
 kernel/trace/trace_irqsoff.c      |    3 +++
 kernel/trace/trace_sched_wakeup.c |    2 +-
 5 files changed, 49 insertions(+), 4 deletions(-)

Index: linux-tip.git/include/linux/ftrace.h
===================================================================
--- linux-tip.git.orig/include/linux/ftrace.h	2008-06-05 14:51:47.000000000 -0400
+++ linux-tip.git/include/linux/ftrace.h	2008-06-05 16:52:32.000000000 -0400
@@ -33,10 +33,15 @@ void clear_ftrace_function(void);
 extern void ftrace_stub(unsigned long a0, unsigned long a1);
 extern void mcount(void);

+void ftrace_enable(void);
+void ftrace_disable(void);
+
 #else /* !CONFIG_FTRACE */
-# define register_ftrace_function(ops) do { } while (0)
-# define unregister_ftrace_function(ops) do { } while (0)
-# define clear_ftrace_function(ops) do { } while (0)
+# define register_ftrace_function(ops)		do { } while (0)
+# define unregister_ftrace_function(ops)	do { } while (0)
+# define clear_ftrace_function(ops)		do { } while (0)
+# define ftrace_enable()			do { } while (0)
+# define ftrace_disable()			do { } while (0)
 #endif /* CONFIG_FTRACE */

 #ifdef CONFIG_DYNAMIC_FTRACE
Index: linux-tip.git/kernel/cpu.c
===================================================================
--- linux-tip.git.orig/kernel/cpu.c	2008-06-05 14:50:44.000000000 -0400
+++ linux-tip.git/kernel/cpu.c	2008-06-05 14:51:50.000000000 -0400
@@ -14,6 +14,7 @@
 #include <linux/kthread.h>
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
+#include <linux/ftrace.h>

 /* Serializes the updates to cpu_online_map, cpu_present_map */
 static DEFINE_MUTEX(cpu_add_remove_lock);
@@ -300,8 +301,16 @@ static int __cpuinit _cpu_up(unsigned in
 		goto out_notify;
 	}

+	/*
+	 * Disable function tracing while bringing up a new CPU.
+	 * We don't want to trace functions that can not handle a
+	 * smp_processor_id() call.
+	 */
+	ftrace_disable();
+
 	/* Arch-specific enabling code. */
 	ret = __cpu_up(cpu);
+	ftrace_enable();
 	if (ret != 0)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-06-05 14:50:44.000000000 -0400
+++ linux-tip.git/kernel/trace/ftrace.c	2008-06-05 16:41:09.000000000 -0400
@@ -148,6 +148,34 @@ static int __unregister_ftrace_function(
 	return ret;
 }

+static int ftrace_disabled_count;
+static int save_ftrace_enabled;
+
+void ftrace_disable(void)
+{
+	unsigned long flags;
+
+	mutex_lock(&ftrace_sysctl_lock);
+
+	save_ftrace_enabled = ftrace_enabled;
+	ftrace_enabled = 0;
+}
+
+void ftrace_enable(void)
+{
+	unsigned long flags;
+
+	/* ftrace_enable must be paired with ftrace_disable */
+	if (!mutex_is_locked(&ftrace_sysctl_lock)) {
+		WARN_ON(1);
+		return;
+	}
+
+	ftrace_enabled = save_ftrace_enabled;
+
+	mutex_unlock(&ftrace_sysctl_lock);
+}
+
 #ifdef CONFIG_DYNAMIC_FTRACE

 static struct task_struct *ftraced_task;
Index: linux-tip.git/kernel/trace/trace_irqsoff.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_irqsoff.c	2008-06-05 14:50:44.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_irqsoff.c	2008-06-05 14:51:50.000000000 -0400
@@ -76,6 +76,9 @@ irqsoff_tracer_call(unsigned long ip, un
 	long disabled;
 	int cpu;

+	if (unlikely(!ftrace_enabled))
+		return;
+
 	/*
 	 * Does not matter if we preempt. We test the flags
 	 * afterward, to see if irqs are disabled or not.
Index: linux-tip.git/kernel/trace/trace_sched_wakeup.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_sched_wakeup.c	2008-06-05 14:50:44.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_sched_wakeup.c	2008-06-05 14:51:50.000000000 -0400
@@ -44,7 +44,7 @@ wakeup_tracer_call(unsigned long ip, uns
 	int resched;
 	int cpu;

-	if (likely(!wakeup_task))
+	if (likely(!wakeup_task) || !ftrace_enabled)
 		return;

 	resched = need_resched();
