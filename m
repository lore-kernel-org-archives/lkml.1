Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbXDWPmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbXDWPmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 11:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbXDWPmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 11:42:50 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:61298 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbXDWPmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 11:42:49 -0400
Subject: [PATCH -rt] trace cpu idle enter and exit
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Mon, 23 Apr 2007 11:42:30 -0400
Message-Id: <1177342950.3437.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When tracing both hard irqs off, as well as preemption off, we get
ridiculous latency times caused by cpu_idle.

What is happening is that the cpu_idle code in i386 and x86_64 has
either interrupts off or preemption off.  Since it calls __schedule
instead of schedule, it can do this.

The loop looks something like this:

/* start with interrupts on but preemption off */
while (1) {
     idle();
     local_irq_disable();
     preempt_enable();
     __schedule();
     preempt_disable();
     local_irq_enable();
}

So when the system goes idle, that whole time is recorded as a latency.

This patch adds the calls of trace_preempt_enter_idle and exit.  Where
the preempt_enable will ignore interrupts disabled, and turn off/on
tracing.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.21-rc6-rt0/arch/x86_64/kernel/process.c
===================================================================
--- linux-2.6.21-rc6-rt0.orig/arch/x86_64/kernel/process.c
+++ linux-2.6.21-rc6-rt0/arch/x86_64/kernel/process.c
@@ -231,9 +231,11 @@ void cpu_idle (void)
 
 		tick_nohz_restart_sched_tick();
 		local_irq_disable();
+		trace_preempt_exit_idle();
 		__preempt_enable_no_resched();
 		__schedule();
 		preempt_disable();
+		trace_preempt_enter_idle();
 		local_irq_enable();
 	}
 }
@@ -264,9 +266,10 @@ static void mwait_idle(void)
 	if (!need_resched() && !need_resched_delayed()) {
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
-		if (!need_resched() && !need_resched_delayed())
+		if (!need_resched() && !need_resched_delayed()) {
+			trace_hardirqs_on();
 			__sti_mwait(0, 0);
-		else
+		} else
 			local_irq_enable();
 	} else {
 		local_irq_enable();
Index: linux-2.6.21-rc6-rt0/include/linux/irqflags.h
===================================================================
--- linux-2.6.21-rc6-rt0.orig/include/linux/irqflags.h
+++ linux-2.6.21-rc6-rt0/include/linux/irqflags.h
@@ -22,6 +22,13 @@
   extern void trace_hardirqs_off(void);
   extern void trace_softirqs_on(unsigned long ip);
   extern void trace_softirqs_off(unsigned long ip);
+# ifdef CONFIG_CRITICAL_PREEMPT_TIMING
+   extern void trace_preempt_enter_idle(void);
+   extern void trace_preempt_exit_idle(void);
+# else
+#  define trace_preempt_enter_idle()	do { } while (0)
+#  define trace_preempt_exit_idle()	do { } while (0)
+# endif
 # define trace_hardirq_context(p)	((p)->hardirq_context)
 # define trace_softirq_context(p)	((p)->softirq_context)
 # define trace_hardirqs_enabled(p)	((p)->hardirqs_enabled)
@@ -32,6 +39,8 @@
 # define trace_softirq_exit()	do { current->softirq_context--; } while (0)
 # define INIT_TRACE_IRQFLAGS	.softirqs_enabled = 1,
 #else
+# define trace_preempt_enter_idle()	do { } while (0)
+# define trace_preempt_exit_idle()	do { } while (0)
 # define trace_hardirqs_on()		do { } while (0)
 # define trace_hardirqs_off()		do { } while (0)
 # define trace_softirqs_on(ip)		do { } while (0)
Index: linux-2.6.21-rc6-rt0/kernel/latency_trace.c
===================================================================
--- linux-2.6.21-rc6-rt0.orig/kernel/latency_trace.c
+++ linux-2.6.21-rc6-rt0/kernel/latency_trace.c
@@ -84,7 +84,8 @@ static inline int DEBUG_WARN_ON(int cond
 
 #ifdef CONFIG_CRITICAL_IRQSOFF_TIMING
 # ifdef CONFIG_CRITICAL_PREEMPT_TIMING
-#  define irqs_off_preempt_count() preempt_count()
+   static DEFINE_PER_CPU(int, trace_cpu_idle);
+#  define irqs_off_preempt_count() (!__get_cpu_var(trace_cpu_idle) && preempt_count())
 # else
 #  define irqs_off_preempt_count() 0
 # endif
@@ -2153,6 +2154,20 @@ void notrace unmask_preempt_count(unsign
 }
 EXPORT_SYMBOL(unmask_preempt_count);
 
+#ifdef CONFIG_CRITICAL_PREEMPT_TIMING
+
+/* Some archs do their cpu_idle with preemption on. Don't measure it */
+void notrace trace_preempt_enter_idle(void)
+{
+	__get_cpu_var(trace_cpu_idle) = 1;
+}
+
+void notrace trace_preempt_exit_idle(void)
+{
+	__get_cpu_var(trace_cpu_idle) = 0;
+}
+
+#endif /* CONFIG_CRITICAL_PREEMPT_TIMING */
 
 #endif
 
Index: linux-2.6.21-rc6-rt0/arch/i386/kernel/process.c
===================================================================
--- linux-2.6.21-rc6-rt0.orig/arch/i386/kernel/process.c
+++ linux-2.6.21-rc6-rt0/arch/i386/kernel/process.c
@@ -196,10 +196,12 @@ void cpu_idle(void)
 			idle();
 		}
 		local_irq_disable();
+		trace_preempt_exit_idle();
 		tick_nohz_restart_sched_tick();
 		__preempt_enable_no_resched();
 		__schedule();
 		preempt_disable();
+		trace_preempt_enter_idle();
 		local_irq_enable();
 	}
 }


