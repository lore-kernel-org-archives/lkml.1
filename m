Return-Path: <linux-kernel-owner+w=401wt.eu-S932400AbXGNXEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400AbXGNXEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 19:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764820AbXGNXEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 19:04:12 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:39540 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbXGNXEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 19:04:11 -0400
Date: Sat, 14 Jul 2007 19:04:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] Immediate Values - Move Kprobes i386 restore_interrupt to kdebug.h
Message-ID: <20070714230409.GF18674@Krystal>
References: <20070714012439.285079881@polymtl.ca> <20070714012624.150971859@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714012624.150971859@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:01:57 up 7 days, 13:07,  3 users,  load average: 0.57, 0.62, 0.38
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate Values - Move Kprobes i386 restore_interrupt to kdebug.h

Since the breakpoint handler is useful both to kprobes and immediate values, it
makes sense to make the required restore_interrupt() available through
asm-i386/kdebug.h.

This patch replaces "immediate-values-kprobes-headers.patch".

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Hellwig <hch@infradead.org>
CC: prasanna@in.ibm.com
CC: ananth@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
---
 include/asm-i386/kdebug.h  |   10 ++++++++++
 include/asm-i386/kprobes.h |    9 ---------
 2 files changed, 10 insertions(+), 9 deletions(-)

Index: linux-2.6-lttng/include/asm-i386/kdebug.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-i386/kdebug.h	2007-07-14 18:32:56.000000000 -0400
+++ linux-2.6-lttng/include/asm-i386/kdebug.h	2007-07-14 18:37:32.000000000 -0400
@@ -6,6 +6,7 @@
  * from x86_64 architecture.
  */
 #include <linux/notifier.h>
+#include <asm/ptrace.h>
 
 struct pt_regs;
 
@@ -31,4 +32,13 @@ enum die_val {
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
--- linux-2.6-lttng.orig/include/asm-i386/kprobes.h	2007-07-14 18:32:52.000000000 -0400
+++ linux-2.6-lttng/include/asm-i386/kprobes.h	2007-07-14 18:33:59.000000000 -0400
@@ -80,15 +80,6 @@ struct kprobe_ctlblk {
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
 extern int kernel_text_is_ro;
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
