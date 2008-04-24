Return-Path: <linux-kernel-owner+w=401wt.eu-S1763897AbYDXPY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763897AbYDXPY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759892AbYDXPP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:15:27 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56393 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758073AbYDXPPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:15:25 -0400
Message-Id: <20080424151400.772049556@polymtl.ca>
References: <20080424150324.802695381@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 11:03:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 20/37] Immediate Values - Move Kprobes x86 restore_interrupt to kdebug.h
Content-Disposition: inline; filename=immediate-values-move-kprobes-x86-restore-interrupt-to-kdebug-h.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Apr 2008 15:14:01 +0000
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
 include/asm-x86/kdebug.h  |   12 ++++++++++++
 include/asm-x86/kprobes.h |    9 ---------
 2 files changed, 12 insertions(+), 9 deletions(-)

Index: linux-2.6-lttng/include/asm-x86/kdebug.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/kdebug.h	2008-03-25 08:56:54.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/kdebug.h	2008-03-25 09:00:17.000000000 -0400
@@ -3,6 +3,9 @@
 
 #include <linux/notifier.h>
 
+#include <linux/ptrace.h>
+#include <asm/system.h>
+
 struct pt_regs;
 
 /* Grossly misnamed. */
@@ -34,4 +37,13 @@ extern void show_regs(struct pt_regs *re
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
 
+/* trap3/1 are intr gates for kprobes.  So, restore the status of IF,
+ * if necessary, before executing the original int3/1 (trap) handler.
+ */
+static inline void restore_interrupts(struct pt_regs *regs)
+{
+	if (regs->flags & X86_EFLAGS_IF)
+		local_irq_enable();
+}
+
 #endif
Index: linux-2.6-lttng/include/asm-x86/kprobes.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/kprobes.h	2008-03-25 08:56:54.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/kprobes.h	2008-03-25 09:00:17.000000000 -0400
@@ -82,15 +82,6 @@ struct kprobe_ctlblk {
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
