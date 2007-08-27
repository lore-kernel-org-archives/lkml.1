Return-Path: <linux-kernel-owner+w=401wt.eu-S1760748AbXH0QNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748AbXH0QNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759137AbXH0QCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:02:36 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:44284 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759336AbXH0QCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:02:33 -0400
Message-Id: <20070827160213.207157818@polymtl.ca>
References: <20070827155910.336723755@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 11:59:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: [patch 4/8] Immediate Values - Move Kprobes i386 restore_interrupt to kdebug.h
Content-Disposition: inline; filename=immediate-values-move-kprobes-i386-restore-interrupt-to-kdebug-h.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 16:02:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since the breakpoint handler is useful both to kprobes and immediate values, it
makes sense to make the required restore_interrupt() available through
asm-i386/kdebug.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Hellwig <hch@infradead.org>
CC: prasanna@in.ibm.com
CC: ananth@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
---
 include/asm-i386/kdebug.h  |   12 ++++++++++++
 include/asm-i386/kprobes.h |    9 ---------
 2 files changed, 12 insertions(+), 9 deletions(-)

Index: linux-2.6-lttng/include/asm-i386/kdebug.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-i386/kdebug.h	2007-08-09 15:45:55.000000000 -0400
+++ linux-2.6-lttng/include/asm-i386/kdebug.h	2007-08-09 16:23:50.000000000 -0400
@@ -6,6 +6,9 @@
  * from x86_64 architecture.
  */
 
+#include <asm/ptrace.h>
+#include <asm/system.h>
+
 struct pt_regs;
 
 /* Grossly misnamed. */
@@ -25,4 +28,13 @@ enum die_val {
 	DIE_PAGE_FAULT_NO_CONTEXT,
 };
 
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
Index: linux-2.6-lttng/include/asm-i386/kprobes.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-i386/kprobes.h	2007-08-09 15:45:55.000000000 -0400
+++ linux-2.6-lttng/include/asm-i386/kprobes.h	2007-08-09 15:46:39.000000000 -0400
@@ -77,15 +77,6 @@ struct kprobe_ctlblk {
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

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
