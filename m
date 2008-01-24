Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbYAXUk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbYAXUk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbYAXUfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:35:39 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:53338 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757915AbYAXUfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:35:38 -0500
Message-Id: <20080124203341.270462519@polymtl.ca>
References: <20080124202706.250598537@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Jan 2008 15:27:27 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 21/26] Immediate Values - Move Kprobes x86 restore_interrupt to kdebug.h
Content-Disposition: inline; filename=immediate-values-move-kprobes-x86-restore-interrupt-to-kdebug-h.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Jan 2008 20:33:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the breakpoint handler is useful both to kprobes and immediate values, it
makes sense to make the required restore_interrupt() available through
asm-i386/kdebug.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
---
 include/asm-x86/kdebug.h  |   13 +++++++++++++
 include/asm-x86/kprobes.h |    9 ---------
 2 files changed, 13 insertions(+), 9 deletions(-)

Index: linux-2.6-lttng.mm/include/asm-x86/kdebug.h
===================================================================
--- linux-2.6-lttng.mm.orig/include/asm-x86/kdebug.h	2008-01-24 14:40:49.000000000 -0500
+++ linux-2.6-lttng.mm/include/asm-x86/kdebug.h	2008-01-24 14:41:10.000000000 -0500
@@ -3,6 +3,9 @@
 
 #include <linux/notifier.h>
 
+#include <linux/ptrace.h>
+#include <asm/system.h>
+
 struct pt_regs;
 
 /* Grossly misnamed. */
@@ -36,4 +39,14 @@ extern void dump_pagetable(unsigned long
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
 
+/*
+ * trap3/1 are intr gates for kprobes.  So, restore the status of IF,
+ * if necessary, before executing the original int3/1 (trap) handler.
+ */
+static inline void restore_interrupts(struct pt_regs *regs)
+{
+	if (regs->flags & X86_EFLAGS_IF)
+		local_irq_enable();
+}
+
 #endif
Index: linux-2.6-lttng.mm/include/asm-x86/kprobes.h
===================================================================
--- linux-2.6-lttng.mm.orig/include/asm-x86/kprobes.h	2008-01-24 14:41:14.000000000 -0500
+++ linux-2.6-lttng.mm/include/asm-x86/kprobes.h	2008-01-24 14:41:21.000000000 -0500
@@ -83,15 +83,6 @@ struct kprobe_ctlblk {
 	struct prev_kprobe prev_kprobe;
 };
 
-/* trap3/1 are intr gates for kprobes.  So, restore the status of IF,
- * if necessary, before executing the original int3/1 (trap) handler.
- */
-static inline void restore_interrupts(struct pt_regs *regs)
-{
-	if (regs->flags & X86_EFLAGS_IF)
-		local_irq_enable();
-}
-
 extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
