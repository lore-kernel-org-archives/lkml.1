Return-Path: <linux-kernel-owner+w=401wt.eu-S932496AbXK2R7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbXK2R7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759302AbXK2R66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:58:58 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36383 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756750AbXK2R65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:58:57 -0500
To: mingo@elte.hu
CC: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <20071129171647.GA1326@elte.hu> (message from Ingo Molnar on Thu,
	29 Nov 2007 18:16:47 +0100)
Subject: Re: scheduling anomaly on uml (was: -rt doesn't compile for UML)
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128150637.GA5518@c2.user-mode-linux.org> <E1IxOwS-000752-HF@dorka.pomaz.szeredi.hu> <20071128182935.GA8048@c2.user-mode-linux.org> <E1IxRv7-0007e8-Dq@dorka.pomaz.szeredi.hu> <E1IxgUe-00011b-Sl@dorka.pomaz.szeredi.hu> <20071129170205.GA7415@c2.user-mode-linux.org> <20071129171647.GA1326@elte.hu>
Message-Id: <E1Ixner-0002Ct-IQ@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 Nov 2007 18:58:41 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Thu, Nov 29, 2007 at 11:19:40AM +0100, Miklos Szeredi wrote:
> > >     date-7119  0.... 15636591us!: schedule <bash-502> (0 0)
> > >     bash-502   0.... 15643908us!: schedule <date-7119> (0 0)
> > >     bash-502   0.... 15646250us!: schedule <date-7120> (0 0)
> > 
> > How exactly did you end up getting this data?

This:

http://people.redhat.com/mingo/latency-tracing-patches/tracing-QuickStart.txt

and some hacking, which is probably not very useful:

Index: linux/include/asm-um/rtc.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/include/asm-um/rtc.h	2007-11-28 17:41:42.000000000 +0100
@@ -0,0 +1 @@
+/* stub for the latency tracer */
Index: linux/include/asm-um/irqflags.h
===================================================================
--- linux.orig/include/asm-um/irqflags.h	2007-11-28 17:36:21.000000000 +0100
+++ linux/include/asm-um/irqflags.h	2007-11-28 17:41:42.000000000 +0100
@@ -1,6 +1,9 @@
 #ifndef __UM_IRQFLAGS_H
 #define __UM_IRQFLAGS_H
 
-/* Empty for now */
+static inline int raw_irqs_disabled_flags(unsigned long flags)
+{
+	return 0;
+}
 
 #endif
Index: linux/kernel/latency_trace.c
===================================================================
--- linux.orig/kernel/latency_trace.c	2007-11-28 17:41:35.000000000 +0100
+++ linux/kernel/latency_trace.c	2007-11-29 16:05:45.000000000 +0100
@@ -26,6 +26,7 @@
 #include <asm/unistd.h>
 #include <asm/asm-offsets.h>
 #include <asm/rtc.h>
+#include <asm/irqflags.h>
 #include <linux/stacktrace.h>
 
 #ifndef DEFINE_RAW_SPINLOCK
@@ -59,6 +60,8 @@ static unsigned long notrace cycles_to_u
 	delta = mulhwu(tb_to_us, delta);
 #elif defined(CONFIG_ARM)
 	delta = mach_cycles_to_usecs(delta);
+#elif defined(CONFIG_UML)
+	/* Dunno */
 #else
 	#error Implement cycles_to_usecs.
 #endif
@@ -188,7 +191,7 @@ static int report_latency(cycle_t delta)
 /*
  * Number of per-CPU trace entries:
  */
-#define MAX_TRACE (65536UL*16UL)
+#define MAX_TRACE (1024UL*16UL)
 
 #define CMDLINE_BYTES 16
 
@@ -655,7 +658,7 @@ again:
 	entry->cpu = cpu;
 #endif
 	entry->flags = (irqs_off() ? TRACE_FLAG_IRQS_OFF : 0) |
-		(irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_HARD_OFF : 0)|
+		(raw_irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_HARD_OFF : 0)|
 		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
 		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
 		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0) |
@@ -2709,7 +2712,7 @@ void __init init_tracer(void)
 
 	for_each_possible_cpu(cpu) {
 		tr = cpu_traces + cpu;
-		array = tracer_alloc_bootmem(size);
+		array = alloc_bootmem(size);
 		if (!array) {
 			printk(KERN_ERR
 			"CPU#%d: failed to allocate %ld bytes trace buffer!\n",
@@ -2723,7 +2726,7 @@ void __init init_tracer(void)
 		tr->cpu = cpu;
 		tr->trace = array;
 
-		array = tracer_alloc_bootmem(size);
+		array = alloc_bootmem(size);
 		if (!array) {
 			printk(KERN_ERR
 			"CPU#%d: failed to allocate %ld bytes max-trace buffer!\n",
@@ -2742,7 +2745,7 @@ void __init init_tracer(void)
 	 * trace entries for the first cpu-trace structure:
 	 */
 	size = sizeof(struct trace_entry)*MAX_TRACE*num_possible_cpus();
-	array = tracer_alloc_bootmem(size);
+	array = alloc_bootmem(size);
 	if (!array) {
 		printk(KERN_ERR
 			"failed to allocate %ld bytes out-trace buffer!\n",
Index: linux/arch/um/sys-i386/sysrq.c
===================================================================
--- linux.orig/arch/um/sys-i386/sysrq.c	2007-10-09 22:31:38.000000000 +0200
+++ linux/arch/um/sys-i386/sysrq.c	2007-11-29 16:20:12.000000000 +0100
@@ -7,6 +7,7 @@
 #include "linux/smp.h"
 #include "linux/sched.h"
 #include "linux/kallsyms.h"
+#include "linux/stacktrace.h"
 #include "asm/ptrace.h"
 #include "sysrq.h"
 
@@ -99,3 +100,26 @@ void show_trace(struct task_struct* task
 	printk("\n");
 }
 
+void save_stack_trace(struct stack_trace *trace)
+{
+	unsigned long ebp;
+	struct thread_info *tinfo;
+	unsigned long stack;
+	unsigned long addr;
+
+	asm ("movl %%ebp, %0" : "=r" (ebp) : );
+
+	tinfo = (struct thread_info *)
+		((unsigned long)(&stack) & (~(THREAD_SIZE - 1)));
+
+	while (valid_stack_ptr(tinfo, (void *)ebp)) {
+		addr = *(unsigned long *)(ebp + 4);
+		if (trace->skip > 0) {
+			trace->skip--;
+		} else if (trace->nr_entries < trace->max_entries) {
+			trace->entries[trace->nr_entries++] = addr;
+		}
+		ebp = *(unsigned long *)ebp;
+	}
+}
+
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c	2007-11-29 16:29:08.000000000 +0100
+++ linux/kernel/sched.c	2007-11-29 16:29:20.000000000 +0100
@@ -3658,6 +3658,7 @@ need_resched_nonpreemptible:
 	next = pick_next_task(rq, prev);
 
 	trace_all_runnable_tasks(rq);
+	trace_special_sym();
 
 	sched_info_switch(prev, next);
 
