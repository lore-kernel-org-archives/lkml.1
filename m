Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbYLIXBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbYLIXBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbYLIXA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:00:28 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:55926 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbYLIXA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:00:27 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2008 18:00:16 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=XgoRoGc/Sm/F+1pD8jwBdCW3RuKT+23w1h06Csk0x5LtS8KW1byV/JAvv5qtF0ln2y
         7ubDwSZIiyQhCZrguTEGM9RxC7TX0Pwg/LBv6F4lZelKoYGdOymsuZM8+cp17R9OVUsW
         RJo8ejKQFXhKD/ocIBFWltSGgj4f9u0tKwdfM=
Message-ID: <493EF71C.1000707@gmail.com>
Date: Tue, 09 Dec 2008 23:54:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] tracing/function-graph-tracer: annotate do_IRQ and smp_apic_timer_interrupt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: move most importants x86 irq entrypoints on a separate subsection

Annotate do_IRQ and smp_apic_timer_interrupt to put them into the .irqentry.text
subsection. These function will so be recognized as hardirq entrypoints for the
function-graph-tracer. We could also annotate other irq entries but the others
are far less important but they can be added on request.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/apic.c   |    3 ++-
 arch/x86/kernel/irq_64.c |    3 ++-
 include/linux/ftrace.h   |   11 +++++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 02d64c9..204c5c8 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/dmi.h>
 #include <linux/dmar.h>
+#include <linux/ftrace.h>
 
 #include <asm/intel_arch_perfmon.h>
 #include <asm/atomic.h>
@@ -795,7 +796,7 @@ static void local_apic_timer_interrupt(void)
  * [ if a single-CPU system runs an SMP kernel then we call the local
  *   interrupt as well. Thus we cannot inline the local irq ... ]
  */
-void smp_apic_timer_interrupt(struct pt_regs *regs)
+void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 7ebb34a..a174a21 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -13,6 +13,7 @@
 #include <linux/seq_file.h>
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/ftrace.h>
 #include <asm/uaccess.h>
 #include <asm/io_apic.h>
 #include <asm/idle.h>
@@ -45,7 +46,7 @@ static inline void stack_overflow_check(struct pt_regs *regs)
  * SMP cross-CPU interrupts have their own specific
  * handlers).
  */
-asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
+asmlinkage unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	struct irq_desc *desc;
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 11cac81..44020f3 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -377,6 +377,16 @@ struct ftrace_graph_ret {
  */
 #define __notrace_funcgraph		notrace
 
+/*
+ * We want to which function is an entrypoint of a hardirq.
+ * That will help us to put a signal on output.
+ */
+#define __irq_entry		 __attribute__((__section__(".irqentry.text")))
+
+/* Limits of hardirq entrypoints */
+extern char __irqentry_text_start[];
+extern char __irqentry_text_end[];
+
 #define FTRACE_RETFUNC_DEPTH 50
 #define FTRACE_RETSTACK_ALLOC_SIZE 32
 /* Type of the callback handlers for tracing function graph*/
@@ -414,6 +424,7 @@ static inline void unpause_graph_tracing(void)
 #else
 
 #define __notrace_funcgraph
+#define __irq_entry
 
 static inline void ftrace_graph_init_task(struct task_struct *t) { }
 static inline void ftrace_graph_exit_task(struct task_struct *t) { }
-- 
1.6.0.4

