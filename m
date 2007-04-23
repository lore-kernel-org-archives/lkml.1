Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbXDWPet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbXDWPet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 11:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbXDWPet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 11:34:49 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:54011 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbXDWPes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 11:34:48 -0400
Subject: [PATCH -rt] add caller for x86_64 trace from entry.S
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Mon, 23 Apr 2007 11:34:37 -0400
Message-Id: <1177342477.3437.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the x86_64 trace code from entry.S calls a
trace_hardirqs_on_thunk, that then calls trace_hardirqs_on.

The problem is that the trace records the call coming from
trace_hardirqs_on_thunk and not the location in entry.S, which makes it
difficult to find exactly where a latency lies.

This patch adds a call called trace_hardirqs_on_caller that passes in
the calling address to use for the trace. It also changes the code in
trace_hardirqs_on_thunk to pass in the caller.

So instead of getting a trace that looks like this:

preemption latency trace v1.1.5 on 2.6.20-rt8
--------------------------------------------------------------------
 latency: 25 us, #4/4, CPU#3 | (M:rt VP:0, KP:0, SP:1 HP:1 #P:4)
    -----------------
    | task: softirq-timer/3-44 (uid:0 nice:0 policy:1 rt_prio:50)
    -----------------

                 _------=> CPU#
                / _-----=> irqs-off
               | / _----=> need-resched
               || / _---=> hardirq/softirq
               ||| / _--=> preempt-depth
               |||| /
               |||||     delay
   cmd     pid ||||| time  |   caller
      \   /    |||||   \   |   /
     cat-3186  3D...    0us+: trace_hardirqs_off_thunk ((0))
   <...>-44    3D...   24us : schedule ((0))
   <...>-44    3D...   24us : trace_hardirqs_on (schedule)



We now get a trace that looks like this:

preemption latency trace v1.1.5 on 2.6.20-rt8
--------------------------------------------------------------------
 latency: 51 us, #4/4, CPU#0 | (M:rt VP:0, KP:0, SP:1 HP:1 #P:4)
    -----------------
    | task: automount-2692 (uid:0 nice:0 policy:0 rt_prio:0)
    -----------------

                 _------=> CPU#
                / _-----=> irqs-off
               | / _----=> need-resched
               || / _---=> hardirq/softirq
               ||| / _--=> preempt-depth
               |||| /
               |||||     delay
   cmd     pid ||||| time  |   caller
      \   /    |||||   \   |   /
automoun-2692  0D...    2us+: apic_timer_interrupt ((0))
automoun-2692  0DN..   21us+: retint_careful ((0))
automoun-2692  0DN..   23us : trace_hardirqs_on_caller (retint_careful)


Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.21-rc6-rt0/arch/x86_64/lib/thunk.S
===================================================================
--- linux-2.6.21-rc6-rt0.orig/arch/x86_64/lib/thunk.S
+++ linux-2.6.21-rc6-rt0/arch/x86_64/lib/thunk.S
@@ -49,8 +49,22 @@
 #endif
 
 #ifdef CONFIG_TRACE_IRQFLAGS
-	thunk trace_hardirqs_on_thunk,trace_hardirqs_on
-	thunk trace_hardirqs_off_thunk,trace_hardirqs_off
+	/* put return address in rdi (arg1) */
+	.macro thunk_ra name,func
+	.globl \name
+\name:
+	CFI_STARTPROC
+	SAVE_ARGS
+	/* SAVE_ARGS pushs 9 elements */
+	/* the next element would be the rip */
+	movq 9*8(%rsp), %rdi
+	call \func
+	jmp  restore
+	CFI_ENDPROC
+	.endm
+
+	thunk_ra trace_hardirqs_on_thunk,trace_hardirqs_on_caller
+	thunk_ra trace_hardirqs_off_thunk,trace_hardirqs_off_caller
 #endif
 	
 	/* SAVE_ARGS below is used only for the .cfi directives it contains. */
Index: linux-2.6.21-rc6-rt0/kernel/latency_trace.c
===================================================================
--- linux-2.6.21-rc6-rt0.orig/kernel/latency_trace.c
+++ linux-2.6.21-rc6-rt0/kernel/latency_trace.c
@@ -1986,6 +1986,28 @@ void notrace trace_hardirqs_off(void)
 
 EXPORT_SYMBOL(trace_hardirqs_off);
 
+/* used by x86_64 thunk.S */
+void notrace trace_hardirqs_on_caller(unsigned long caller_addr)
+{
+	unsigned long flags;
+
+	local_save_flags(flags);
+
+	if (!irqs_off_preempt_count() && irqs_disabled_flags(flags))
+		__stop_critical_timing(caller_addr, 0 /* CALLER_ADDR1 */);
+}
+
+void notrace trace_hardirqs_off_caller(unsigned long caller_addr)
+{
+	unsigned long flags;
+
+	local_save_flags(flags);
+
+	if (!irqs_off_preempt_count() && irqs_disabled_flags(flags))
+		__start_critical_timing(caller_addr, 0 /* CALLER_ADDR1 */,
+					INTERRUPT_LATENCY);
+}
+
 #endif /* !CONFIG_LOCKDEP */
 
 #endif /* CONFIG_CRITICAL_IRQSOFF_TIMING */
Index: linux-2.6.21-rc6-rt0/kernel/lockdep.c
===================================================================
--- linux-2.6.21-rc6-rt0.orig/kernel/lockdep.c
+++ linux-2.6.21-rc6-rt0/kernel/lockdep.c
@@ -1858,7 +1858,7 @@ void early_boot_irqs_on(void)
 /*
  * Hardirqs will be enabled:
  */
-void notrace trace_hardirqs_on(void)
+void notrace trace_hardirqs_on_caller(unsigned long a0)
 {
 	struct task_struct *curr = current;
 	unsigned long ip;
@@ -1900,16 +1900,20 @@ void notrace trace_hardirqs_on(void)
 	curr->hardirq_enable_event = ++curr->irq_events;
 	debug_atomic_inc(&hardirqs_on_events);
 #ifdef CONFIG_CRITICAL_IRQSOFF_TIMING
-	time_hardirqs_on(CALLER_ADDR0, 0 /* CALLER_ADDR1 */);
+	time_hardirqs_on(a0, 0 /* CALLER_ADDR1 */);
 #endif
 }
 
+void notrace trace_hardirqs_on(void) {
+	trace_hardirqs_on_caller(CALLER_ADDR0);
+}
+
 EXPORT_SYMBOL(trace_hardirqs_on);
 
 /*
  * Hardirqs were disabled:
  */
-void notrace trace_hardirqs_off(void)
+void notrace trace_hardirqs_off_caller(unsigned long a0)
 {
 	struct task_struct *curr = current;
 
@@ -1928,12 +1932,16 @@ void notrace trace_hardirqs_off(void)
 		curr->hardirq_disable_event = ++curr->irq_events;
 		debug_atomic_inc(&hardirqs_off_events);
 #ifdef CONFIG_CRITICAL_IRQSOFF_TIMING
-		time_hardirqs_off(CALLER_ADDR0, 0 /* CALLER_ADDR1 */);
+		time_hardirqs_off(a0, 0 /* CALLER_ADDR1 */);
 #endif
 	} else
 		debug_atomic_inc(&redundant_hardirqs_off);
 }
 
+void notrace trace_hardirqs_off(void) {
+	trace_hardirqs_off_caller(CALLER_ADDR0);
+}
+
 EXPORT_SYMBOL(trace_hardirqs_off);
 
 /*



