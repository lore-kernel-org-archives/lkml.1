Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbZGaC3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbZGaC3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 22:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZGaC3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 22:29:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56102 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZGaC3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 22:29:06 -0400
Date: Thu, 30 Jul 2009 22:29:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <clark.williams@gmail.com>,
       Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH][RT] stacktrace: dump out last preempt disable locations
Message-ID: <alpine.DEB.2.00.0907302225500.21267@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

This patch was somehow dropped from the 31-rt port. It is very useful 
since it shows the last locations that preemption was disabled. The bugs 
that Darren and Clark are seeing would probably be spotted by this patch. 
Could you add it back.

Ingo wrote the original version of this code, but as things changed I 
needed to rewrite it.

-- Steve

-----
Track preempt disable nesting

This code was largly influenced by work from Ingo Molnar.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/arm/kernel/traps.c      |    1 +
 include/linux/preempt.h      |    3 ++-
 include/linux/sched.h        |   11 +++++++++++
 kernel/sched.c               |   17 +++++++++++++++--
 kernel/trace/Kconfig         |    8 ++++++++
 kernel/trace/Makefile        |    2 ++
 kernel/trace/preempt-trace.c |   30 ++++++++++++++++++++++++++++++
 7 files changed, 69 insertions(+), 3 deletions(-)

Index: linux-2.6.31-rc4-rt1/arch/arm/kernel/traps.c
===================================================================
--- linux-2.6.31-rc4-rt1.orig/arch/arm/kernel/traps.c	2009-07-30 21:28:57.000000000 -0400
+++ linux-2.6.31-rc4-rt1/arch/arm/kernel/traps.c	2009-07-30 21:30:58.000000000 -0400
@@ -365,6 +365,7 @@ asmlinkage void do_unexp_fiq (struct pt_
 {
 	printk("Hmm.  Unexpected FIQ received, but trying to continue\n");
 	printk("You may have a hardware problem...\n");
+	print_preempt_trace(current);
 }
 
 /*
Index: linux-2.6.31-rc4-rt1/include/linux/preempt.h
===================================================================
--- linux-2.6.31-rc4-rt1.orig/include/linux/preempt.h	2009-07-30 21:28:58.000000000 -0400
+++ linux-2.6.31-rc4-rt1/include/linux/preempt.h	2009-07-30 21:30:58.000000000 -0400
@@ -10,7 +10,8 @@
 #include <linux/linkage.h>
 #include <linux/list.h>
 
-#if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
+#if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER) || \
+	defined(CONFIG_PREEMPT_TRACE)
   extern void add_preempt_count(int val);
   extern void sub_preempt_count(int val);
 #else
Index: linux-2.6.31-rc4-rt1/include/linux/sched.h
===================================================================
--- linux-2.6.31-rc4-rt1.orig/include/linux/sched.h	2009-07-30 21:28:58.000000000 -0400
+++ linux-2.6.31-rc4-rt1/include/linux/sched.h	2009-07-30 21:33:50.000000000 -0400
@@ -1437,6 +1437,11 @@ struct task_struct {
 
 #define MAX_PREEMPT_TRACE 25
 #define MAX_LOCK_STACK	MAX_PREEMPT_TRACE
+#ifdef CONFIG_PREEMPT_TRACE
+	unsigned long preempt_trace_eip[MAX_PREEMPT_TRACE];
+	unsigned long preempt_trace_parent_eip[MAX_PREEMPT_TRACE];
+#endif
+
 #ifdef CONFIG_DEBUG_PREEMPT
 	atomic_t lock_count;
 # ifdef CONFIG_PREEMPT_RT
@@ -2605,6 +2610,12 @@ static inline int task_is_current(struct
 }
 #endif
 
+#ifdef CONFIG_PREEMPT_TRACE
+void print_preempt_trace(struct task_struct *tsk);
+#else
+static inline void print_preempt_trace(struct task_struct *tsk) { }
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
Index: linux-2.6.31-rc4-rt1/kernel/sched.c
===================================================================
--- linux-2.6.31-rc4-rt1.orig/kernel/sched.c	2009-07-30 21:28:58.000000000 -0400
+++ linux-2.6.31-rc4-rt1/kernel/sched.c	2009-07-30 22:01:03.000000000 -0400
@@ -5349,10 +5349,14 @@ EXPORT_SYMBOL(preempt_enable_no_resched)
 #endif
 
 #if defined(CONFIG_PREEMPT) && (defined(CONFIG_DEBUG_PREEMPT) || \
-				defined(CONFIG_PREEMPT_TRACER))
+				defined(CONFIG_PREEMPT_TRACER) || \
+				defined(CONFIG_PREEMPT_TRACE))
 
 void __kprobes add_preempt_count(int val)
 {
+	unsigned long eip = CALLER_ADDR0;
+	unsigned long parent_eip = get_parent_ip(CALLER_ADDR1);
+
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
 	 * Underflow?
@@ -5361,6 +5365,15 @@ void __kprobes add_preempt_count(int val
 		return;
 #endif
 	preempt_count() += val;
+#ifdef CONFIG_PREEMPT_TRACE
+	if (val <= 10) {
+		unsigned int idx = preempt_count() & PREEMPT_MASK;
+		if (idx < MAX_PREEMPT_TRACE) {
+			current->preempt_trace_eip[idx] = eip;
+			current->preempt_trace_parent_eip[idx] = parent_eip;
+		}
+	}
+#endif
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
 	 * Spinlock count overflowing soon?
@@ -5369,7 +5382,7 @@ void __kprobes add_preempt_count(int val
 				PREEMPT_MASK - 10);
 #endif
 	if (preempt_count() == val)
-		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
+		trace_preempt_off(eip, parent_eip);
 }
 EXPORT_SYMBOL(add_preempt_count);
 
Index: linux-2.6.31-rc4-rt1/kernel/trace/Kconfig
===================================================================
--- linux-2.6.31-rc4-rt1.orig/kernel/trace/Kconfig	2009-07-30 21:28:58.000000000 -0400
+++ linux-2.6.31-rc4-rt1/kernel/trace/Kconfig	2009-07-30 21:36:14.000000000 -0400
@@ -502,6 +502,14 @@ config RING_BUFFER_BENCHMARK
 
 	  If unsure, say N
 
+config PREEMPT_TRACE
+	bool "Keep a record of preempt disabled spots"
+	depends on DEBUG_KERNEL
+	depends on PREEMPT
+	select TRACING
+	help
+	  Keeps a record of the last 25 preempt disabled locations.
+
 endif # FTRACE
 
 endif # TRACING_SUPPORT
Index: linux-2.6.31-rc4-rt1/kernel/trace/Makefile
===================================================================
--- linux-2.6.31-rc4-rt1.orig/kernel/trace/Makefile	2009-07-30 21:26:32.000000000 -0400
+++ linux-2.6.31-rc4-rt1/kernel/trace/Makefile	2009-07-30 21:34:40.000000000 -0400
@@ -55,4 +55,6 @@ obj-$(CONFIG_FTRACE_SYSCALLS) += trace_s
 obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 
+obj-$(CONFIG_PREEMPT_TRACE) += preempt-trace.o
+
 libftrace-y := ftrace.o
Index: linux-2.6.31-rc4-rt1/kernel/trace/preempt-trace.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.31-rc4-rt1/kernel/trace/preempt-trace.c	2009-07-30 21:30:58.000000000 -0400
@@ -0,0 +1,30 @@
+#include <linux/sched.h>
+#include <linux/hardirq.h>
+#include <linux/kallsyms.h>
+
+void print_preempt_trace(struct task_struct *task)
+{
+	unsigned int count;
+	unsigned int i, lim;
+
+	if (!task)
+		task = current;
+
+	count = task_thread_info(task)->preempt_count;
+	lim = count & PREEMPT_MASK;
+
+	if (lim >= MAX_PREEMPT_TRACE)
+		lim = MAX_PREEMPT_TRACE-1;
+	printk("---------------------------\n");
+	printk("| preempt count: %08x ]\n", count);
+	printk("| %d-level deep critical section nesting:\n", lim);
+	printk("----------------------------------------\n");
+	for (i = 1; i <= lim; i++) {
+		printk(".. [<%08lx>] .... ", task->preempt_trace_eip[i]);
+		print_symbol("%s\n", task->preempt_trace_eip[i]);
+		printk(".....[<%08lx>] ..   ( <= ",
+				task->preempt_trace_parent_eip[i]);
+		print_symbol("%s)\n", task->preempt_trace_parent_eip[i]);
+	}
+	printk("\n");
+}

