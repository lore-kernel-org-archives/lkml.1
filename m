Return-Path: <linux-kernel-owner+w=401wt.eu-S1757688AbYAOUwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688AbYAOUwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbYAOUuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:50:37 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:44086 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbYAOUub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:31 -0500
Message-Id: <20080115205026.070515029@goodmis.org>
References: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 25/30 v3] Trace irq disabled critical timings
Content-Disposition: inline; filename=mcount-tracer-latency-trace-irqs-off.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds latency tracing for critical timings.
In /debugfs/tracing/ three files are added:

  preempt_max_latency
    holds the max latency thus far (in usecs)
   (default to large number so one must start latency tracing)

  preempt_thresh
    threshold (in usecs) to always print out if irqs off
    is detected to be longer than stated here.
    If irq_thresh is non-zero, then max_irq_latency
    is ignored.

  preempt_trace
    Trace of where the latecy was detected.

  preempt_fn_trace_ctrl
    0 - don't use mcount
    1 - use mcount to trace

Here's an example of a trace with preempt_fn_trace_ctrl == 0

=======
preemption latency trace v1.1.5 on 2.6.24-rc7
--------------------------------------------------------------------
 latency: 100 us, #3/3, CPU#1 | (M:rt VP:0, KP:0, SP:0 HP:0 #P:2)
    -----------------
    | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
    -----------------
 => started at: _spin_lock_irqsave+0x2a/0xb7
 => ended at:   _spin_unlock_irqrestore+0x32/0x5f

                 _------=> CPU#            
                / _-----=> irqs-off        
               | / _----=> need-resched    
               || / _---=> hardirq/softirq 
               ||| / _--=> preempt-depth   
               |||| /                      
               |||||     delay             
   cmd     pid ||||| time  |   caller      
      \   /    |||||   \   |   /           
 swapper-0     1d.s3    0us+: _spin_lock_irqsave+0x2a/0xb7 (e1000_update_stats+0x47/0x64c [e1000])
 swapper-0     1d.s3  100us : _spin_unlock_irqrestore+0x32/0x5f (e1000_update_stats+0x641/0x64c [e1000])
 swapper-0     1d.s3  100us : trace_hardirqs_on_caller+0x75/0x89 (_spin_unlock_irqrestore+0x32/0x5f)


vim:ft=help
=======


And this is a trace with irqsoff_fn_trace_ctrl == 1


=======
preemption latency trace v1.1.5 on 2.6.24-rc7
--------------------------------------------------------------------
 latency: 102 us, #12/12, CPU#1 | (M:rt VP:0, KP:0, SP:0 HP:0 #P:2)
    -----------------
    | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
    -----------------
 => started at: _spin_lock_irqsave+0x2a/0xb7
 => ended at:   _spin_unlock_irqrestore+0x32/0x5f

                 _------=> CPU#            
                / _-----=> irqs-off        
               | / _----=> need-resched    
               || / _---=> hardirq/softirq 
               ||| / _--=> preempt-depth   
               |||| /                      
               |||||     delay             
   cmd     pid ||||| time  |   caller      
      \   /    |||||   \   |   /           
 swapper-0     1dNs3    0us+: _spin_lock_irqsave+0x2a/0xb7 (e1000_update_stats+0x47/0x64c [e1000])
 swapper-0     1dNs3   46us : e1000_read_phy_reg+0x16/0x225 [e1000] (e1000_update_stats+0x5e2/0x64c [e1000])
 swapper-0     1dNs3   46us : e1000_swfw_sync_acquire+0x10/0x99 [e1000] (e1000_read_phy_reg+0x49/0x225 [e1000])
 swapper-0     1dNs3   46us : e1000_get_hw_eeprom_semaphore+0x12/0xa6 [e1000] (e1000_swfw_sync_acquire+0x36/0x99 [e1000])
 swapper-0     1dNs3   47us : __const_udelay+0x9/0x47 (e1000_read_phy_reg+0x116/0x225 [e1000])
 swapper-0     1dNs3   47us+: __delay+0x9/0x50 (__const_udelay+0x45/0x47)
 swapper-0     1dNs3   97us : preempt_schedule+0xc/0x84 (__delay+0x4e/0x50)
 swapper-0     1dNs3   98us : e1000_swfw_sync_release+0xc/0x55 [e1000] (e1000_read_phy_reg+0x211/0x225 [e1000])
 swapper-0     1dNs3   99us+: e1000_put_hw_eeprom_semaphore+0x9/0x35 [e1000] (e1000_swfw_sync_release+0x50/0x55 [e1000])
 swapper-0     1dNs3  101us : _spin_unlock_irqrestore+0xe/0x5f (e1000_update_stats+0x641/0x64c [e1000])
 swapper-0     1dNs3  102us : _spin_unlock_irqrestore+0x32/0x5f (e1000_update_stats+0x641/0x64c [e1000])
 swapper-0     1dNs3  102us : trace_hardirqs_on_caller+0x75/0x89 (_spin_unlock_irqrestore+0x32/0x5f)


vim:ft=help
=======


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/process_64.c  |    3 
 arch/x86/lib/thunk_64.S       |   18 +
 include/asm-x86/irqflags_32.h |    4 
 include/asm-x86/irqflags_64.h |    4 
 include/linux/irqflags.h      |   37 ++
 include/linux/mcount.h        |   31 ++
 kernel/fork.c                 |    2 
 kernel/lockdep.c              |   25 +
 lib/tracing/Kconfig           |   18 +
 lib/tracing/Makefile          |    1 
 lib/tracing/trace_irqsoff.c   |  558 ++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 680 insertions(+), 21 deletions(-)

Index: linux-compile.git/arch/x86/kernel/process_64.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/process_64.c	2008-01-15 12:50:00.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/process_64.c	2008-01-15 12:51:36.000000000 -0500
@@ -233,7 +233,10 @@ void cpu_idle (void)
 			 */
 			local_irq_disable();
 			enter_idle();
+			/* Don't trace irqs off for idle */
+			stop_critical_timings();
 			idle();
+			start_critical_timings();
 			/* In many cases the interrupt that ended idle
 			   has already called exit_idle. But some idle
 			   loops can be woken up without interrupt. */
Index: linux-compile.git/arch/x86/lib/thunk_64.S
===================================================================
--- linux-compile.git.orig/arch/x86/lib/thunk_64.S	2008-01-15 12:49:33.000000000 -0500
+++ linux-compile.git/arch/x86/lib/thunk_64.S	2008-01-15 12:51:36.000000000 -0500
@@ -47,8 +47,22 @@
 	thunk __up_wakeup,__up
 
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
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
Index: linux-compile.git/include/asm-x86/irqflags_32.h
===================================================================
--- linux-compile.git.orig/include/asm-x86/irqflags_32.h	2008-01-15 12:49:33.000000000 -0500
+++ linux-compile.git/include/asm-x86/irqflags_32.h	2008-01-15 12:51:36.000000000 -0500
@@ -139,9 +139,9 @@ static inline int raw_irqs_disabled(void
 static inline void trace_hardirqs_fixup_flags(unsigned long flags)
 {
 	if (raw_irqs_disabled_flags(flags))
-		trace_hardirqs_off();
+		__trace_hardirqs_off();
 	else
-		trace_hardirqs_on();
+		__trace_hardirqs_on();
 }
 
 static inline void trace_hardirqs_fixup(void)
Index: linux-compile.git/include/asm-x86/irqflags_64.h
===================================================================
--- linux-compile.git.orig/include/asm-x86/irqflags_64.h	2008-01-15 12:49:33.000000000 -0500
+++ linux-compile.git/include/asm-x86/irqflags_64.h	2008-01-15 12:51:36.000000000 -0500
@@ -120,9 +120,9 @@ static inline int raw_irqs_disabled(void
 static inline void trace_hardirqs_fixup_flags(unsigned long flags)
 {
 	if (raw_irqs_disabled_flags(flags))
-		trace_hardirqs_off();
+		__trace_hardirqs_off();
 	else
-		trace_hardirqs_on();
+		__trace_hardirqs_on();
 }
 
 static inline void trace_hardirqs_fixup(void)
Index: linux-compile.git/include/linux/irqflags.h
===================================================================
--- linux-compile.git.orig/include/linux/irqflags.h	2008-01-15 12:49:33.000000000 -0500
+++ linux-compile.git/include/linux/irqflags.h	2008-01-15 12:51:36.000000000 -0500
@@ -12,10 +12,21 @@
 #define _LINUX_TRACE_IRQFLAGS_H
 
 #ifdef CONFIG_TRACE_IRQFLAGS
-  extern void trace_hardirqs_on(void);
-  extern void trace_hardirqs_off(void);
+# include <linux/mcount.h>
+  extern void trace_hardirqs_on_caller(unsigned long ip);
+  extern void trace_hardirqs_off_caller(unsigned long ip);
   extern void trace_softirqs_on(unsigned long ip);
   extern void trace_softirqs_off(unsigned long ip);
+  extern void trace_hardirqs_on(void);
+  extern void trace_hardirqs_off(void);
+  static inline void notrace __trace_hardirqs_on(void)
+  {
+	trace_hardirqs_on_caller(CALLER_ADDR0);
+  }
+  static inline void notrace __trace_hardirqs_off(void)
+  {
+	trace_hardirqs_off_caller(CALLER_ADDR0);
+  }
 # define trace_hardirq_context(p)	((p)->hardirq_context)
 # define trace_softirq_context(p)	((p)->softirq_context)
 # define trace_hardirqs_enabled(p)	((p)->hardirqs_enabled)
@@ -28,6 +39,8 @@
 #else
 # define trace_hardirqs_on()		do { } while (0)
 # define trace_hardirqs_off()		do { } while (0)
+# define __trace_hardirqs_on()		do { } while (0)
+# define __trace_hardirqs_off()		do { } while (0)
 # define trace_softirqs_on(ip)		do { } while (0)
 # define trace_softirqs_off(ip)		do { } while (0)
 # define trace_hardirq_context(p)	0
@@ -41,24 +54,32 @@
 # define INIT_TRACE_IRQFLAGS
 #endif
 
+#ifdef CONFIG_CRITICAL_IRQSOFF_TIMING
+ extern void stop_critical_timings(void);
+ extern void start_critical_timings(void);
+#else
+# define stop_critical_timings() do { } while (0)
+# define start_critical_timings() do { } while (0)
+#endif
+
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 
 #include <asm/irqflags.h>
 
 #define local_irq_enable() \
-	do { trace_hardirqs_on(); raw_local_irq_enable(); } while (0)
+	do { __trace_hardirqs_on(); raw_local_irq_enable(); } while (0)
 #define local_irq_disable() \
-	do { raw_local_irq_disable(); trace_hardirqs_off(); } while (0)
+	do { raw_local_irq_disable(); __trace_hardirqs_off(); } while (0)
 #define local_irq_save(flags) \
-	do { raw_local_irq_save(flags); trace_hardirqs_off(); } while (0)
+	do { raw_local_irq_save(flags); __trace_hardirqs_off(); } while (0)
 
 #define local_irq_restore(flags)				\
 	do {							\
 		if (raw_irqs_disabled_flags(flags)) {		\
 			raw_local_irq_restore(flags);		\
-			trace_hardirqs_off();			\
+			__trace_hardirqs_off();			\
 		} else {					\
-			trace_hardirqs_on();			\
+			__trace_hardirqs_on();			\
 			raw_local_irq_restore(flags);		\
 		}						\
 	} while (0)
@@ -76,7 +97,7 @@
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 #define safe_halt()						\
 	do {							\
-		trace_hardirqs_on();				\
+		__trace_hardirqs_on();				\
 		raw_safe_halt();				\
 	} while (0)
 
Index: linux-compile.git/include/linux/mcount.h
===================================================================
--- linux-compile.git.orig/include/linux/mcount.h	2008-01-15 12:50:57.000000000 -0500
+++ linux-compile.git/include/linux/mcount.h	2008-01-15 13:12:30.000000000 -0500
@@ -6,10 +6,6 @@ extern int mcount_enabled;
 
 #include <linux/linkage.h>
 
-#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
-#define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
-#define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
-
 typedef void (*mcount_func_t)(unsigned long ip, unsigned long parent_ip);
 
 struct mcount_ops {
@@ -35,4 +31,31 @@ extern void mcount(void);
 # define unregister_mcount_function(ops) do { } while (0)
 # define clear_mcount_function(ops) do { } while (0)
 #endif /* CONFIG_MCOUNT */
+
+
+#ifdef CONFIG_FRAME_POINTER
+/* TODO: need to fix this for ARM */
+# define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
+# define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
+# define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
+# define CALLER_ADDR3 ((unsigned long)__builtin_return_address(3))
+# define CALLER_ADDR4 ((unsigned long)__builtin_return_address(4))
+# define CALLER_ADDR5 ((unsigned long)__builtin_return_address(5))
+#else
+# define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
+# define CALLER_ADDR1 0UL
+# define CALLER_ADDR2 0UL
+# define CALLER_ADDR3 0UL
+# define CALLER_ADDR4 0UL
+# define CALLER_ADDR5 0UL
+#endif
+
+#ifdef CONFIG_CRITICAL_IRQSOFF_TIMING
+  extern void notrace time_hardirqs_on(unsigned long a0, unsigned long a1);
+  extern void notrace time_hardirqs_off(unsigned long a0, unsigned long a1);
+#else
+# define time_hardirqs_on(a0, a1)		do { } while (0)
+# define time_hardirqs_off(a0, a1)		do { } while (0)
+#endif
+
 #endif /* _LINUX_MCOUNT_H */
Index: linux-compile.git/kernel/fork.c
===================================================================
--- linux-compile.git.orig/kernel/fork.c	2008-01-15 12:49:33.000000000 -0500
+++ linux-compile.git/kernel/fork.c	2008-01-15 12:51:36.000000000 -0500
@@ -1010,7 +1010,7 @@ static struct task_struct *copy_process(
 
 	rt_mutex_init_task(p);
 
-#ifdef CONFIG_TRACE_IRQFLAGS
+#if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_LOCKDEP)
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
Index: linux-compile.git/kernel/lockdep.c
===================================================================
--- linux-compile.git.orig/kernel/lockdep.c	2008-01-15 12:49:33.000000000 -0500
+++ linux-compile.git/kernel/lockdep.c	2008-01-15 12:51:36.000000000 -0500
@@ -39,6 +39,7 @@
 #include <linux/irqflags.h>
 #include <linux/utsname.h>
 #include <linux/hash.h>
+#include <linux/mcount.h>
 
 #include <asm/sections.h>
 
@@ -2009,7 +2010,7 @@ void early_boot_irqs_on(void)
 /*
  * Hardirqs will be enabled:
  */
-void trace_hardirqs_on(void)
+void notrace trace_hardirqs_on_caller(unsigned long a0)
 {
 	struct task_struct *curr = current;
 	unsigned long ip;
@@ -2050,14 +2051,27 @@ void trace_hardirqs_on(void)
 	curr->hardirq_enable_ip = ip;
 	curr->hardirq_enable_event = ++curr->irq_events;
 	debug_atomic_inc(&hardirqs_on_events);
+
+#ifdef CONFIG_CRITICAL_IRQSOFF_TIMING
+	time_hardirqs_on(CALLER_ADDR0, a0);
+#endif
 }
+EXPORT_SYMBOL(trace_hardirqs_on_caller);
 
+void notrace trace_hardirqs_on(void) {
+	trace_hardirqs_on_caller(CALLER_ADDR0);
+}
 EXPORT_SYMBOL(trace_hardirqs_on);
 
+void notrace trace_hardirqs_off(void) {
+	trace_hardirqs_off_caller(CALLER_ADDR0);
+}
+EXPORT_SYMBOL(trace_hardirqs_off);
+
 /*
  * Hardirqs were disabled:
  */
-void trace_hardirqs_off(void)
+void notrace trace_hardirqs_off_caller(unsigned long a0)
 {
 	struct task_struct *curr = current;
 
@@ -2075,10 +2089,17 @@ void trace_hardirqs_off(void)
 		curr->hardirq_disable_ip = _RET_IP_;
 		curr->hardirq_disable_event = ++curr->irq_events;
 		debug_atomic_inc(&hardirqs_off_events);
+#ifdef CONFIG_CRITICAL_IRQSOFF_TIMING
+		time_hardirqs_off(CALLER_ADDR0, a0);
+#endif
 	} else
 		debug_atomic_inc(&redundant_hardirqs_off);
 }
 
+void notrace trace_hardirqs_off(void) {
+	trace_hardirqs_off_caller(CALLER_ADDR0);
+}
+
 EXPORT_SYMBOL(trace_hardirqs_off);
 
 /*
Index: linux-compile.git/lib/tracing/Kconfig
===================================================================
--- linux-compile.git.orig/lib/tracing/Kconfig	2008-01-15 12:51:21.000000000 -0500
+++ linux-compile.git/lib/tracing/Kconfig	2008-01-15 13:12:36.000000000 -0500
@@ -24,3 +24,21 @@ config FUNCTION_TRACER
 	  insert a call to an architecture specific __mcount routine,
 	  that the debugging mechanism using this facility will hook by
 	  providing a set of inline routines.
+
+config CRITICAL_IRQSOFF_TIMING
+	bool "Interrupts-off critical section latency timing"
+	default n
+	depends on TRACE_IRQFLAGS_SUPPORT
+	depends on GENERIC_TIME
+	select TRACE_IRQFLAGS
+	select TRACING
+	help
+	  This option measures the time spent in irqs-off critical
+	  sections, with microsecond accuracy.
+
+	  The default measurement method is a maximum search, which is
+	  disabled by default and can be runtime (re-)started
+	  via:
+
+	      echo 0 > /debug/tracing/preempt_max_latency
+
Index: linux-compile.git/lib/tracing/Makefile
===================================================================
--- linux-compile.git.orig/lib/tracing/Makefile	2008-01-15 12:51:21.000000000 -0500
+++ linux-compile.git/lib/tracing/Makefile	2008-01-15 13:12:36.000000000 -0500
@@ -2,5 +2,6 @@ obj-$(CONFIG_MCOUNT) += libmcount.o
 
 obj-$(CONFIG_TRACING) += tracer.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace_function.o
+obj-$(CONFIG_CRITICAL_IRQSOFF_TIMING) += trace_irqsoff.o
 
 libmcount-y := mcount.o
Index: linux-compile.git/lib/tracing/trace_irqsoff.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile.git/lib/tracing/trace_irqsoff.c	2008-01-15 13:13:07.000000000 -0500
@@ -0,0 +1,558 @@
+/*
+ * trace irqs off criticall timings
+ *
+ * Copyright (C) 2007 Steven Rostedt <srostedt@redhat.com>
+ *
+ * From code in the latency_tracer, that is:
+ *
+ *  Copyright (C) 2004-2006 Ingo Molnar
+ *  Copyright (C) 2004 William Lee Irwin III
+ */
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/kallsyms.h>
+#include <linux/uaccess.h>
+#include <linux/mcount.h>
+
+#include "tracer.h"
+
+static struct tracing_trace irqsoff_trace __read_mostly;
+static struct tracing_trace max_tr __read_mostly;
+static DEFINE_PER_CPU(struct tracing_trace_cpu, irqsoff_trace_cpu);
+static DEFINE_PER_CPU(struct tracing_trace_cpu, max_data);
+static unsigned long preempt_max_latency = (cycle_t)ULONG_MAX;
+static unsigned long preempt_thresh;
+static __cacheline_aligned_in_smp DEFINE_MUTEX(max_mutex);
+static int trace_enabled __read_mostly;
+
+/*
+ * max trace is switched with this buffer.
+ */
+static void *max_buffer;
+
+/*
+ * Sequence count - we record it when starting a measurement and
+ * skip the latency if the sequence has changed - some other section
+ * did a maximum and could disturb our measurement with serial console
+ * printouts, etc. Truly coinciding maximum latencies should be rare
+ * and what happens together happens separately as well, so this doesnt
+ * decrease the validity of the maximum found:
+ */
+static __cacheline_aligned_in_smp unsigned long max_sequence;
+
+/*
+ * Should this new latency be reported/recorded?
+ */
+static int notrace report_latency(cycle_t delta)
+{
+	if (preempt_thresh) {
+		if (delta < preempt_thresh)
+			return 0;
+	} else {
+		if (delta <= preempt_max_latency)
+			return 0;
+	}
+	return 1;
+}
+
+/*
+ * Copy the new maximum trace into the separate maximum-trace
+ * structure. (this way the maximum trace is permanently saved,
+ * for later retrieval via /proc/latency_trace)
+ */
+static void update_max_tr(struct tracing_trace *tr,
+			  struct tracing_trace_cpu *data,
+			  int cpu)
+{
+	struct tracing_trace_cpu *save;
+	int i;
+
+#ifdef CONFIG_PREEMPT
+	WARN_ON(!preempt_count() && !irqs_disabled());
+#endif
+
+	max_tr.cpu = cpu;
+	save = max_tr.data[cpu];
+
+	/* clear out all the previous traces */
+	for_each_possible_cpu(i) {
+		if (max_tr.data[i]->trace)
+			max_tr.data[i]->trace = NULL;
+	}
+
+	max_tr.time_start = data->preempt_timestamp;
+
+	memcpy(save, data, sizeof(*data));
+	save->saved_latency = preempt_max_latency;
+
+	memcpy(save->comm, current->comm, TASK_COMM_LEN);
+	save->pid = current->pid;
+	save->uid = current->uid;
+	save->nice = current->static_prio - 20 - MAX_RT_PRIO;
+	save->policy = current->policy;
+	save->rt_priority = current->rt_priority;
+
+	/* from memcpy above: save->trace = data->trace */
+	data->trace = max_buffer;
+	max_buffer = save->trace;
+}
+
+cycle_t notrace usecs_to_cycles(unsigned long usecs);
+
+static void notrace
+check_critical_timing(struct tracing_trace *tr,
+		      struct tracing_trace_cpu *data,
+		      unsigned long parent_ip,
+		      int cpu)
+{
+	unsigned long latency, t0, t1;
+	cycle_t T0, T1, T2, delta;
+	unsigned long flags;
+
+	/*
+	 * usecs conversion is slow so we try to delay the conversion
+	 * as long as possible:
+	 */
+	T0 = data->preempt_timestamp;
+	T1 = now();
+	delta = T1-T0;
+
+	local_save_flags(flags);
+
+	if (!report_latency(delta))
+		goto out;
+
+	tracing_function_trace(tr, data, CALLER_ADDR0, parent_ip, flags);
+	/*
+	 * Update the timestamp, because the trace entry above
+	 * might change it (it can only get larger so the latency
+	 * is fair to be reported):
+	 */
+	T2 = now();
+
+	delta = T2-T0;
+
+	latency = cycles_to_usecs(delta);
+
+	if (data->critical_sequence != max_sequence ||
+	    !mutex_trylock(&max_mutex))
+		goto out;
+
+	preempt_max_latency = delta;
+	t0 = cycles_to_usecs(T0);
+	t1 = cycles_to_usecs(T1);
+
+	data->critical_end = parent_ip;
+
+	update_max_tr(tr, data, cpu);
+
+	if (preempt_thresh)
+		printk(KERN_INFO "(%16s-%-5d|#%d): %lu us critical section "
+		       "violates %lu us threshold.\n"
+		       " => started at timestamp %lu: ",
+				current->comm, current->pid,
+				raw_smp_processor_id(),
+				latency, cycles_to_usecs(preempt_thresh), t0);
+	else
+		printk(KERN_INFO "(%16s-%-5d|#%d): new %lu us maximum-latency "
+		       "critical section.\n => started at timestamp %lu: ",
+				current->comm, current->pid,
+				raw_smp_processor_id(),
+				latency, t0);
+
+	print_symbol(KERN_CONT "<%s>\n", data->critical_start);
+	printk(KERN_CONT " =>   ended at timestamp %lu: ", t1);
+	print_symbol(KERN_CONT "<%s>\n", data->critical_end);
+	dump_stack();
+	t1 = cycles_to_usecs(now());
+	printk(KERN_CONT " =>   dump-end timestamp %lu\n\n", t1);
+
+	max_sequence++;
+
+	mutex_unlock(&max_mutex);
+
+out:
+	data->critical_sequence = max_sequence;
+	data->preempt_timestamp = now();
+	tracing_reset(data);
+	tracing_function_trace(tr, data, CALLER_ADDR0, parent_ip, flags);
+}
+
+static inline void notrace
+start_critical_timing(unsigned long ip, unsigned long parent_ip)
+{
+	int cpu = raw_smp_processor_id();
+	struct tracing_trace *tr = &irqsoff_trace;
+	struct tracing_trace_cpu *data = tr->data[cpu];
+	unsigned long flags;
+
+	if (unlikely(!data) || unlikely(!data->trace) ||
+	    data->critical_start || atomic_read(&data->disabled))
+		return;
+
+	atomic_inc(&data->disabled);
+
+	data->critical_sequence = max_sequence;
+	data->preempt_timestamp = now();
+	data->critical_start = parent_ip;
+	tracing_reset(data);
+
+	local_save_flags(flags);
+	tracing_function_trace(tr, data, ip, parent_ip, flags);
+
+	atomic_dec(&data->disabled);
+}
+
+static inline void notrace
+stop_critical_timing(unsigned long ip, unsigned long parent_ip)
+{
+	int cpu = raw_smp_processor_id();
+	struct tracing_trace *tr = &irqsoff_trace;
+	struct tracing_trace_cpu *data = tr->data[cpu];
+	unsigned long flags;
+
+	if (unlikely(!data) || unlikely(!data->trace) ||
+	    !data->critical_start || atomic_read(&data->disabled))
+		return;
+
+	atomic_inc(&data->disabled);
+	local_save_flags(flags);
+	tracing_function_trace(tr, data, ip, parent_ip, flags);
+	check_critical_timing(tr, data, parent_ip, cpu);
+	data->critical_start = 0;
+	atomic_dec(&data->disabled);
+}
+
+void notrace start_critical_timings(void)
+{
+	unsigned long flags;
+
+	local_save_flags(flags);
+
+	if (irqs_disabled_flags(flags))
+		start_critical_timing(CALLER_ADDR0, 0);
+}
+
+void notrace stop_critical_timings(void)
+{
+	unsigned long flags;
+
+	local_save_flags(flags);
+
+	if (irqs_disabled_flags(flags))
+		stop_critical_timing(CALLER_ADDR0, 0);
+}
+
+#ifdef CONFIG_LOCKDEP
+void notrace time_hardirqs_on(unsigned long a0, unsigned long a1)
+{
+	unsigned long flags;
+
+	local_save_flags(flags);
+
+	if (irqs_disabled_flags(flags))
+		stop_critical_timing(a0, a1);
+}
+
+void notrace time_hardirqs_off(unsigned long a0, unsigned long a1)
+{
+	unsigned long flags;
+
+	local_save_flags(flags);
+
+	if (irqs_disabled_flags(flags))
+		start_critical_timing(a0, a1);
+}
+
+#else /* !CONFIG_LOCKDEP */
+
+/*
+ * Stubs:
+ */
+
+void early_boot_irqs_off(void)
+{
+}
+
+void early_boot_irqs_on(void)
+{
+}
+
+void trace_softirqs_on(unsigned long ip)
+{
+}
+
+void trace_softirqs_off(unsigned long ip)
+{
+}
+
+inline void print_irqtrace_events(struct task_struct *curr)
+{
+}
+
+/*
+ * We are only interested in hardirq on/off events:
+ */
+void notrace trace_hardirqs_on(void)
+{
+	unsigned long flags;
+
+	local_save_flags(flags);
+
+	if (irqs_disabled_flags(flags))
+		stop_critical_timing(CALLER_ADDR0, 0);
+}
+EXPORT_SYMBOL(trace_hardirqs_on);
+
+void notrace trace_hardirqs_off(void)
+{
+	unsigned long flags;
+
+	local_save_flags(flags);
+
+	if (irqs_disabled_flags(flags))
+		start_critical_timing(CALLER_ADDR0, 0);
+}
+EXPORT_SYMBOL(trace_hardirqs_off);
+
+void notrace trace_hardirqs_on_caller(unsigned long caller_addr)
+{
+	unsigned long flags;
+
+	local_save_flags(flags);
+
+	if (irqs_disabled_flags(flags))
+		stop_critical_timing(CALLER_ADDR0, caller_addr);
+}
+EXPORT_SYMBOL(trace_hardirqs_on_caller);
+
+void notrace trace_hardirqs_off_caller(unsigned long caller_addr)
+{
+	unsigned long flags;
+
+	local_save_flags(flags);
+
+	if (irqs_disabled_flags(flags))
+		start_critical_timing(CALLER_ADDR0, caller_addr);
+}
+EXPORT_SYMBOL(trace_hardirqs_off_caller);
+
+#endif /* CONFIG_LOCKDEP */
+
+
+#ifdef CONFIG_MCOUNT
+static void notrace irqsoff_trace_call(unsigned long ip,
+					unsigned long parent_ip)
+{
+	struct tracing_trace *tr = &irqsoff_trace;
+	struct tracing_trace_cpu *data;
+	unsigned long flags;
+	int cpu;
+
+	if (unlikely(!trace_enabled))
+		return;
+
+	local_save_flags(flags);
+
+	if (!irqs_disabled_flags(flags))
+		return;
+
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	atomic_inc(&data->disabled);
+
+	if (likely(atomic_read(&data->disabled) == 1))
+		tracing_function_trace(tr, data, ip, parent_ip, flags);
+
+	atomic_dec(&data->disabled);
+}
+
+static struct mcount_ops trace_ops __read_mostly =
+{
+	.func = irqsoff_trace_call,
+};
+#endif /* CONFIG_MCOUNT */
+
+#ifdef CONFIG_DEBUG_FS
+static void irqsoff_start(struct tracing_iterator *iter)
+{
+	mutex_lock(&max_mutex);
+}
+
+static void irqsoff_stop(struct tracing_iterator *iter)
+{
+	mutex_unlock(&max_mutex);
+}
+
+static ssize_t max_irq_lat_read(struct file *filp, char __user *ubuf,
+					size_t cnt, loff_t *ppos)
+{
+	unsigned long *ptr = filp->private_data;
+	char buf[64];
+	int r;
+
+	r = snprintf(buf, 64, "%ld\n", *ptr == -1 ? : cycles_to_usecs(*ptr));
+	if (r > 64)
+		r = 64;
+	return simple_read_from_buffer(ubuf, cnt, ppos,
+				       buf, r);
+}
+static ssize_t max_irq_lat_write(struct file *filp,
+				 const char __user *ubuf,
+				 size_t cnt, loff_t *ppos)
+{
+	long *ptr = filp->private_data;
+	long val;
+	char buf[64];
+
+	if (cnt > 63)
+		cnt = 63;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	val = simple_strtoul(buf, NULL, 10);
+
+	*ptr = usecs_to_cycles(val);
+
+	return cnt;
+}
+
+static struct file_operations max_irq_lat_fops = {
+	.open = tracing_open_generic,
+	.read = max_irq_lat_read,
+	.write = max_irq_lat_write,
+};
+
+static void irqsoff_trace_ctrl_update(struct tracing_trace *tr,
+				      unsigned long val)
+{
+	val = !!val;
+
+	if (tr->ctrl ^ val) {
+		if (val) {
+			trace_enabled = 1;
+			register_mcount_function(&trace_ops);
+		} else {
+			trace_enabled = 0;
+			unregister_mcount_function(&trace_ops);
+		}
+		tr->ctrl = val;
+	}
+}
+
+static __init void irqsoff_trace_init_debugfs(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+
+	irqsoff_trace.ctrl_update = irqsoff_trace_ctrl_update;
+
+#ifdef CONFIG_MCOUNT
+	entry = debugfs_create_file("preempt_fn_trace_ctrl", 0644, d_tracer,
+				    &irqsoff_trace, &tracing_ctrl_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs"
+			   " 'preempt_fn_trace' entry\n");
+#endif
+
+	entry = debugfs_create_file("preempt_max_latency", 0644, d_tracer,
+				    &preempt_max_latency, &max_irq_lat_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'ctrl' entry\n");
+
+	entry = debugfs_create_file("preempt_thresh", 0644, d_tracer,
+				    &preempt_thresh, &max_irq_lat_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'ctrl' entry\n");
+
+	entry = debugfs_create_file("preempt_trace", 0444, d_tracer,
+				    &max_tr, &tracing_lt_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'irqsoff_trace' entry\n");
+}
+
+#endif /* CONFIG_DEBUGFS */
+
+static void notrace irqsoff_trace_open(struct tracing_iterator *iter)
+{
+	/* stop the trace while dumping */
+	if (iter->tr->ctrl)
+		trace_enabled = 0;
+}
+
+static void notrace irqsoff_trace_close(struct tracing_iterator *iter)
+{
+	if (iter->tr->ctrl)
+		trace_enabled = 1;
+}
+
+__init static int trace_irqsoff_alloc_buffers(void)
+{
+	const int order = page_order(TRACING_NR_ENTRIES * TRACING_ENTRY_SIZE);
+	const unsigned long size = (1UL << order) << PAGE_SHIFT;
+	struct tracing_entry *array;
+	int i;
+
+	for_each_possible_cpu(i) {
+		irqsoff_trace.data[i] = &per_cpu(irqsoff_trace_cpu, i);
+		max_tr.data[i] = &per_cpu(max_data, i);
+
+		array = (struct tracing_entry *)
+			  __get_free_pages(GFP_KERNEL, order);
+		if (array == NULL) {
+			printk(KERN_ERR "irqsoff tracer: failed to allocate"
+			       " %ld bytes for trace buffer!\n", size);
+			goto free_buffers;
+		}
+		irqsoff_trace.data[i]->trace = array;
+	}
+
+	array = (struct tracing_entry *)
+		__get_free_pages(GFP_KERNEL, order);
+	if (array == NULL) {
+		printk(KERN_ERR "irqsoff tracer: failed to allocate"
+		       " %ld bytes for trace buffer!\n", size);
+		goto free_buffers;
+	}
+	max_buffer = array;
+
+	/*
+	 * Since we allocate by orders of pages, we may be able to
+	 * round up a bit.
+	 */
+	irqsoff_trace.entries = size / TRACING_ENTRY_SIZE;
+	max_tr.entries = irqsoff_trace.entries;
+	max_tr.start = irqsoff_start;
+	max_tr.stop = irqsoff_stop;
+
+	pr_info("irqs off tracer: %ld bytes allocated for %ld",
+		size, TRACING_NR_ENTRIES);
+	pr_info(" entries of %d bytes\n", (int)TRACING_ENTRY_SIZE);
+	pr_info("   actual entries %ld\n", irqsoff_trace.entries);
+
+	irqsoff_trace_init_debugfs();
+
+	irqsoff_trace.open = irqsoff_trace_open;
+	irqsoff_trace.close = irqsoff_trace_close;
+
+	return 0;
+
+ free_buffers:
+	for (i-- ; i >= 0; i--) {
+		struct tracing_trace_cpu *data = irqsoff_trace.data[i];
+
+		if (data && data->trace) {
+			free_pages((unsigned long)data->trace, order);
+			data->trace = NULL;
+		}
+	}
+	return -ENOMEM;
+}
+
+device_initcall(trace_irqsoff_alloc_buffers);

-- 
