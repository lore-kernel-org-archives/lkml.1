Return-Path: <linux-kernel-owner+w=401wt.eu-S1763711AbXKMTC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763711AbXKMTC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763310AbXKMTBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:01:40 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:38541 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763300AbXKMTBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:01:39 -0500
Message-Id: <20071113190040.090133515@polymtl.ca>
References: <20071113185800.436425570@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 13:58:03 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: [patch 3/8] Immediate Values - Move Kprobes x86 restore_interrupt to kdebug.h
Content-Disposition: inline; filename=immediate-values-move-kprobes-x86-restore-interrupt-to-kdebug-h.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 19:00:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since the breakpoint handler is useful both to kprobes and immediate values, it
makes sense to make the required restore_interrupt() available through
asm-i386/kdebug.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: prasanna@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
---
 include/asm-x86/kdebug.h     |   12 ++++++++++++
 include/asm-x86/kprobes_32.h |    9 ---------
 include/asm-x86/kprobes_64.h |    9 ---------
 3 files changed, 12 insertions(+), 18 deletions(-)

Index: linux-2.6-lttng/include/asm-x86/kdebug.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/kdebug.h	2007-11-02 15:01:53.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/kdebug.h	2007-11-02 15:02:00.000000000 -0400
@@ -3,6 +3,9 @@
 
 #include <linux/notifier.h>
 
+#include <linux/ptrace.h>
+#include <asm/system.h>
+
 struct pt_regs;
 
 /* Grossly misnamed. */
@@ -30,4 +33,13 @@ extern void dump_pagetable(unsigned long
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long);
 
+/* trap3/1 are intr gates for kprobes.  So, restore the status of IF,
+ * if necessary, before executing the original int3/1 (trap) handler.
+ */
+static inline void restore_interrupts(struct pt_regs *regs)
+{
+	if (regs->eflags & IF_MASK)
+		local_irq_enable();
+}
+
 #endif
Index: linux-2.6-lttng/include/asm-x86/kprobes_32.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/kprobes_32.h	2007-11-02 15:01:53.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/kprobes_32.h	2007-11-02 15:02:00.000000000 -0400
@@ -79,15 +79,6 @@ struct kprobe_ctlblk {
 	struct prev_kprobe prev_kprobe;
 };
 
-/* trap3/1 are intr gates for kprobes.  So, restore the status of IF,
- * if necessary, before executing the original int3/1 (trap) handler.
- */
-static inline void restore_interrupts(struct pt_regs *regs)
-{
-	if (regs->eflags & IF_MASK)
-		local_irq_enable();
-}
-
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
 extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
Index: linux-2.6-lttng/include/asm-x86/kprobes_64.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/kprobes_64.h	2007-11-02 15:02:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/kprobes_64.h	2007-11-02 15:02:22.000000000 -0400
@@ -72,15 +72,6 @@ struct kprobe_ctlblk {
 	struct prev_kprobe prev_kprobe;
 };
 
-/* trap3/1 are intr gates for kprobes.  So, restore the status of IF,
- * if necessary, before executing the original int3/1 (trap) handler.
- */
-static inline void restore_interrupts(struct pt_regs *regs)
-{
-	if (regs->eflags & IF_MASK)
-		local_irq_enable();
-}
-
 extern int post_kprobe_handler(struct pt_regs *regs);
 extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 extern int kprobe_handler(struct pt_regs *regs);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
