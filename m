Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbYBIOV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbYBIOV2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 09:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYBIOVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 09:21:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40325 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbYBIOVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 09:21:16 -0500
Date: Sat, 9 Feb 2008 15:21:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] latency tracer
Message-ID: <20080209142101.GA30844@elte.hu>
References: <20080208214522.GA31101@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208214522.GA31101@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Linus, please pull the latency tracer tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

i've updated the git tree - find the shortlog below.

It's a few small changes (got rid of the DONT_TRACE_NMI complication, 
Steve removed the max_mutex, removed 2 lines of leftover debugging 
code), and streamlined the splitup to reduce the number of patches from 
24 to 18. No bugs have been found in the tracer code in overnight 
testing, and the queue still is bisectable at every patch point with 
tracers on and off as well.
 
(i've attached the delta patch below the diffstat, relative to 
yesterday's tree - the full patch would be too large for lkml.)

	Ingo

------------------>
Arnaldo Carvalho de Melo (2):
      ftrace: annotate core code that should not be traced
      ftrace: add basic support for gcc profiler instrumentation

Ingo Molnar (2):
      sched: add latency tracer callbacks to the scheduler
      tracing: add notrace to linkage.h

Steven Rostedt (14):
      rcu: add support for dynamic ticks and preempt rcu
      printk: dont wake up klogd with the rq locked
      ftrace: add preempt_enable/disable notrace macros
      ftrace: make the task state char-string visible to all
      x86: add notrace annotations to vsyscall.
      ftrace: add notrace annotations for NMI routines
      ftrace: latency tracer infrastructure
      ftrace: function tracer
      ftrace: add tracing of context switches
      ftrace: tracer for scheduler wakeup latency
      ftrace: trace irq disabled critical timings
      ftrace: trace preempt off critical timings
      ftrace: dynamic enabling/disabling of function calls
      ftrace: add ftrace_enabled sysctl to disable mcount function

 Makefile                          |    3 +
 arch/x86/Kconfig                  |    1 +
 arch/x86/kernel/Makefile          |    1 +
 arch/x86/kernel/entry_32.S        |   27 +
 arch/x86/kernel/entry_64.S        |   37 +
 arch/x86/kernel/ftrace.c          |  237 ++++++
 arch/x86/kernel/nmi_32.c          |    3 +-
 arch/x86/kernel/nmi_64.c          |    6 +-
 arch/x86/kernel/process_32.c      |    3 +
 arch/x86/kernel/process_64.c      |    3 +
 arch/x86/kernel/traps_32.c        |   12 +-
 arch/x86/kernel/traps_64.c        |   11 +-
 arch/x86/kernel/vsyscall_64.c     |    3 +-
 arch/x86/lib/Makefile             |    1 +
 arch/x86/lib/thunk_32.S           |   47 ++
 arch/x86/lib/thunk_64.S           |   19 +-
 arch/x86/vdso/vclock_gettime.c    |   15 +-
 arch/x86/vdso/vgetcpu.c           |    3 +-
 include/asm-x86/irqflags.h        |   24 +-
 include/asm-x86/vsyscall.h        |    3 +-
 include/linux/ftrace.h            |   93 +++
 include/linux/hardirq.h           |   10 +
 include/linux/irqflags.h          |   13 +-
 include/linux/linkage.h           |    2 +
 include/linux/preempt.h           |   34 +-
 include/linux/rcuclassic.h        |    3 +
 include/linux/rcupreempt.h        |   22 +
 include/linux/sched.h             |   30 +
 kernel/Makefile                   |    2 +
 kernel/fork.c                     |    2 +-
 kernel/lockdep.c                  |   23 +-
 kernel/printk.c                   |   16 +-
 kernel/rcupreempt.c               |  224 ++++++-
 kernel/sched.c                    |   47 ++-
 kernel/softirq.c                  |    1 +
 kernel/sysctl.c                   |   11 +
 kernel/time/tick-sched.c          |    3 +
 kernel/trace/Kconfig              |  107 +++
 kernel/trace/Makefile             |   10 +
 kernel/trace/ftrace.c             |  519 +++++++++++++
 kernel/trace/trace.c              | 1547 +++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h              |  185 +++++
 kernel/trace/trace_functions.c    |   73 ++
 kernel/trace/trace_irqsoff.c      |  486 ++++++++++++
 kernel/trace/trace_sched_switch.c |  125 +++
 kernel/trace/trace_sched_wakeup.c |  310 ++++++++
 lib/Kconfig.debug                 |    2 +
 lib/smp_processor_id.c            |    2 +-
 48 files changed, 4294 insertions(+), 67 deletions(-)
 create mode 100644 arch/x86/kernel/ftrace.c
 create mode 100644 arch/x86/lib/thunk_32.S
 create mode 100644 include/linux/ftrace.h
 create mode 100644 kernel/trace/Kconfig
 create mode 100644 kernel/trace/Makefile
 create mode 100644 kernel/trace/ftrace.c
 create mode 100644 kernel/trace/trace.c
 create mode 100644 kernel/trace/trace.h
 create mode 100644 kernel/trace/trace_functions.c
 create mode 100644 kernel/trace/trace_irqsoff.c
 create mode 100644 kernel/trace/trace_sched_switch.c
 create mode 100644 kernel/trace/trace_sched_wakeup.c


--------------{ delta patch }------------->

Index: linux/arch/x86/kernel/nmi_32.c
===================================================================
--- linux.orig/arch/x86/kernel/nmi_32.c
+++ linux/arch/x86/kernel/nmi_32.c
@@ -320,7 +320,7 @@ EXPORT_SYMBOL(touch_nmi_watchdog);
 
 extern void die_nmi(struct pt_regs *, const char *msg);
 
-notrace_nmi __kprobes int
+notrace __kprobes int
 nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 {
 
Index: linux/arch/x86/kernel/nmi_64.c
===================================================================
--- linux.orig/arch/x86/kernel/nmi_64.c
+++ linux/arch/x86/kernel/nmi_64.c
@@ -314,7 +314,7 @@ void touch_nmi_watchdog(void)
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
 
-notrace_nmi __kprobes int
+notrace __kprobes int
 nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 {
 	int sum;
@@ -386,7 +386,7 @@ nmi_watchdog_tick(struct pt_regs *regs, 
 
 static unsigned ignore_nmis;
 
-asmlinkage notrace_nmi __kprobes void
+asmlinkage notrace __kprobes void
 do_nmi(struct pt_regs *regs, long error_code)
 {
 	nmi_enter();
Index: linux/arch/x86/kernel/traps_32.c
===================================================================
--- linux.orig/arch/x86/kernel/traps_32.c
+++ linux/arch/x86/kernel/traps_32.c
@@ -665,7 +665,7 @@ gp_in_kernel:
 	}
 }
 
-static notrace_nmi __kprobes void
+static notrace __kprobes void
 mem_parity_error(unsigned char reason, struct pt_regs * regs)
 {
 	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x on "
@@ -688,7 +688,7 @@ mem_parity_error(unsigned char reason, s
 	clear_mem_error(reason);
 }
 
-static notrace_nmi __kprobes void
+static notrace __kprobes void
 io_check_error(unsigned char reason, struct pt_regs * regs)
 {
 	unsigned long i;
@@ -705,7 +705,7 @@ io_check_error(unsigned char reason, str
 	outb(reason, 0x61);
 }
 
-static notrace_nmi __kprobes void
+static notrace __kprobes void
 unknown_nmi_error(unsigned char reason, struct pt_regs * regs)
 {
 #ifdef CONFIG_MCA
@@ -727,7 +727,7 @@ unknown_nmi_error(unsigned char reason, 
 
 static DEFINE_SPINLOCK(nmi_print_lock);
 
-void notrace_nmi __kprobes die_nmi(struct pt_regs *regs, const char *msg)
+void notrace __kprobes die_nmi(struct pt_regs *regs, const char *msg)
 {
 	if (notify_die(DIE_NMIWATCHDOG, msg, regs, 0, 2, SIGINT) ==
 	    NOTIFY_STOP)
@@ -758,7 +758,7 @@ void notrace_nmi __kprobes die_nmi(struc
 	do_exit(SIGSEGV);
 }
 
-static notrace_nmi __kprobes void default_do_nmi(struct pt_regs *regs)
+static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 
@@ -798,7 +798,7 @@ static notrace_nmi __kprobes void defaul
 
 static int ignore_nmis;
 
-notrace_nmi __kprobes void do_nmi(struct pt_regs *regs, long error_code)
+notrace __kprobes void do_nmi(struct pt_regs *regs, long error_code)
 {
 	int cpu;
 
Index: linux/arch/x86/kernel/traps_64.c
===================================================================
--- linux.orig/arch/x86/kernel/traps_64.c
+++ linux/arch/x86/kernel/traps_64.c
@@ -598,7 +598,7 @@ void die(const char * str, struct pt_reg
 	oops_end(flags, regs, SIGSEGV);
 }
 
-notrace_nmi __kprobes void
+notrace __kprobes void
 die_nmi(char *str, struct pt_regs *regs, int do_panic)
 {
 	unsigned long flags = oops_begin();
@@ -766,7 +766,7 @@ asmlinkage void __kprobes do_general_pro
 	die("general protection fault", regs, error_code);
 }
 
-static notrace_nmi __kprobes void
+static notrace __kprobes void
 mem_parity_error(unsigned char reason, struct pt_regs * regs)
 {
 	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x.\n",
@@ -790,7 +790,7 @@ mem_parity_error(unsigned char reason, s
 	outb(reason, 0x61);
 }
 
-static notrace_nmi __kprobes void
+static notrace __kprobes void
 io_check_error(unsigned char reason, struct pt_regs * regs)
 {
 	printk("NMI: IOCK error (debug interrupt?)\n");
@@ -804,7 +804,7 @@ io_check_error(unsigned char reason, str
 	outb(reason, 0x61);
 }
 
-static notrace_nmi __kprobes void
+static notrace __kprobes void
 unknown_nmi_error(unsigned char reason, struct pt_regs * regs)
 {
 	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x.\n",
@@ -819,7 +819,7 @@ unknown_nmi_error(unsigned char reason, 
 
 /* Runs on IST stack. This code must keep interrupts off all the time.
    Nested NMIs are prevented by the CPU. */
-asmlinkage notrace_nmi  __kprobes void default_do_nmi(struct pt_regs *regs)
+asmlinkage notrace  __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 	int cpu;
Index: linux/include/linux/ftrace.h
===================================================================
--- linux.orig/include/linux/ftrace.h
+++ linux/include/linux/ftrace.h
@@ -2,6 +2,7 @@
 #define _LINUX_FTRACE_H
 
 #ifdef CONFIG_FTRACE
+
 #include <linux/linkage.h>
 
 extern int ftrace_enabled;
Index: linux/include/linux/linkage.h
===================================================================
--- linux.orig/include/linux/linkage.h
+++ linux/include/linux/linkage.h
@@ -5,12 +5,6 @@
 
 #define notrace __attribute__((no_instrument_function))
 
-#ifdef CONFIG_DONT_TRACE_NMI
-# define notrace_nmi __attribute__((no_instrument_function))
-#else
-# define notrace_nmi
-#endif
-
 #ifdef __cplusplus
 #define CPP_ASMLINKAGE extern "C"
 #else
Index: linux/kernel/trace/Kconfig
===================================================================
--- linux.orig/kernel/trace/Kconfig
+++ linux/kernel/trace/Kconfig
@@ -11,9 +11,6 @@ config TRACING
 	bool
 	select DEBUG_FS
 
-config DONT_TRACE_NMI
-	bool
-
 config FTRACE
 	bool "Kernel Function Tracer"
 	depends on DEBUG_KERNEL && HAVE_FTRACE
@@ -95,7 +92,6 @@ config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
 	depends on FTRACE
 	default y
-	select DONT_TRACE_NMI
 	help
          This option will modify all the calls to ftrace dynamically
 	 (will patch them out of the binary image and replaces them
Index: linux/kernel/trace/ftrace.c
===================================================================
--- linux.orig/kernel/trace/ftrace.c
+++ linux/kernel/trace/ftrace.c
@@ -346,8 +346,6 @@ static int notrace __ftrace_update_code(
 
 		/* all CPUS are stopped, we are safe to modify code */
 		hlist_for_each_entry(p, t, &head, node) {
-			unsigned short y;
-			y = *(short *)(p->ip-5);
 			ftrace_code_disable(p);
 			ftrace_update_cnt++;
 		}
Index: linux/kernel/trace/trace_irqsoff.c
===================================================================
--- linux.orig/kernel/trace/trace_irqsoff.c
+++ linux/kernel/trace/trace_irqsoff.c
@@ -21,8 +21,6 @@
 static struct trace_array		*irqsoff_trace __read_mostly;
 static int				tracer_enabled __read_mostly;
 
-static __cacheline_aligned_in_smp	DEFINE_MUTEX(max_mutex);
-
 static DEFINE_PER_CPU(int, tracing_cpu);
 
 enum {
@@ -147,8 +145,7 @@ check_critical_timing(struct trace_array
 
 	latency = nsecs_to_usecs(delta);
 
-	if (data->critical_sequence != max_sequence ||
-	    !mutex_trylock(&max_mutex))
+	if (data->critical_sequence != max_sequence)
 		goto out;
 
 	tracing_max_latency = delta;
@@ -183,8 +180,6 @@ check_critical_timing(struct trace_array
 
 	max_sequence++;
 
-	mutex_unlock(&max_mutex);
-
 out:
 	data->critical_sequence = max_sequence;
 	data->preempt_timestamp = now(cpu);
@@ -409,16 +404,6 @@ static void notrace irqsoff_tracer_close
 		start_irqsoff_tracer(iter->tr);
 }
 
-static void irqsoff_tracer_start(struct trace_iterator *iter)
-{
-	mutex_lock(&max_mutex);
-}
-
-static void irqsoff_tracer_stop(struct trace_iterator *iter)
-{
-	mutex_unlock(&max_mutex);
-}
-
 #ifdef CONFIG_IRQSOFF_TRACER
 static void irqsoff_tracer_init(struct trace_array *tr)
 {
@@ -433,8 +418,6 @@ static struct tracer irqsoff_tracer __re
 	.reset		= irqsoff_tracer_reset,
 	.open		= irqsoff_tracer_open,
 	.close		= irqsoff_tracer_close,
-	.start		= irqsoff_tracer_start,
-	.stop		= irqsoff_tracer_stop,
 	.ctrl_update	= irqsoff_tracer_ctrl_update,
 	.print_max	= 1,
 };
@@ -458,8 +441,6 @@ static struct tracer preemptoff_tracer _
 	.reset		= irqsoff_tracer_reset,
 	.open		= irqsoff_tracer_open,
 	.close		= irqsoff_tracer_close,
-	.start		= irqsoff_tracer_start,
-	.stop		= irqsoff_tracer_stop,
 	.ctrl_update	= irqsoff_tracer_ctrl_update,
 	.print_max	= 1,
 };
@@ -468,27 +449,27 @@ static struct tracer preemptoff_tracer _
 # define register_preemptoff(trace) do { } while (0)
 #endif
 
-
 #if defined(CONFIG_IRQSOFF_TRACER) && \
 	defined(CONFIG_PREEMPT_TRACER)
+
 static void preemptirqsoff_tracer_init(struct trace_array *tr)
 {
 	trace_type = TRACER_IRQS_OFF | TRACER_PREEMPT_OFF;
 
 	__irqsoff_tracer_init(tr);
 }
+
 static struct tracer preemptirqsoff_tracer __read_mostly =
 {
-	.name = "preemptirqsoff",
-	.init = preemptirqsoff_tracer_init,
-	.reset = irqsoff_tracer_reset,
-	.open = irqsoff_tracer_open,
-	.close = irqsoff_tracer_close,
-	.start = irqsoff_tracer_start,
-	.stop = irqsoff_tracer_stop,
-	.ctrl_update = irqsoff_tracer_ctrl_update,
-	.print_max = 1,
+	.name		= "preemptirqsoff",
+	.init		= preemptirqsoff_tracer_init,
+	.reset		= irqsoff_tracer_reset,
+	.open		= irqsoff_tracer_open,
+	.close		= irqsoff_tracer_close,
+	.ctrl_update	= irqsoff_tracer_ctrl_update,
+	.print_max	= 1,
 };
+
 # define register_preemptirqsoff(trace) register_tracer(&trace)
 #else
 # define register_preemptirqsoff(trace) do { } while (0)
