Return-Path: <linux-kernel-owner+w=401wt.eu-S1756959AbXJCKtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbXJCKtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 06:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbXJCKsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 06:48:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56935 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbXJCKsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 06:48:51 -0400
Subject: [PATCH] lockdep: annotate kprobes irq fiddling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 12:42:52 +0200
Message-Id: <1191408172.5572.11.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The below patch fixes a lockdep error in 2.6.23-rc9 when using tcp_probe.

---

Subject: lockdep: annotate kprobes irq fiddling

kprobes disables irqs for jprobes, but does not tell lockdep about it.

CC: Prasanna S Panchamukhi <prasanna@in.ibm.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: David S. Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/kernel/kprobes.c   |    8 ++++++++
 arch/x86_64/kernel/kprobes.c |    8 ++++++++
 2 files changed, 16 insertions(+)

Index: linux-2.6-2/arch/i386/kernel/kprobes.c
===================================================================
--- linux-2.6-2.orig/arch/i386/kernel/kprobes.c
+++ linux-2.6-2/arch/i386/kernel/kprobes.c
@@ -558,6 +558,13 @@ static int __kprobes post_kprobe_handler
 
 	resume_execution(cur, regs, kcb);
 	regs->eflags |= kcb->kprobe_saved_eflags;
+#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
+	if (raw_irqs_disabled_flags(regs->eflags)) {
+		trace_hardirqs_off();
+	} else {
+		trace_hardirqs_on();
+	}
+#endif
 
 	/*Restore back the original saved kprobes variables and continue. */
 	if (kcb->kprobe_status == KPROBE_REENTER) {
@@ -695,6 +702,7 @@ int __kprobes setjmp_pre_handler(struct 
 	memcpy(kcb->jprobes_stack, (kprobe_opcode_t *)addr,
 			MIN_STACK_SIZE(addr));
 	regs->eflags &= ~IF_MASK;
+	trace_hardirqs_off();
 	regs->eip = (unsigned long)(jp->entry);
 	return 1;
 }
Index: linux-2.6-2/arch/x86_64/kernel/kprobes.c
===================================================================
--- linux-2.6-2.orig/arch/x86_64/kernel/kprobes.c
+++ linux-2.6-2/arch/x86_64/kernel/kprobes.c
@@ -545,6 +545,13 @@ int __kprobes post_kprobe_handler(struct
 
 	resume_execution(cur, regs, kcb);
 	regs->eflags |= kcb->kprobe_saved_rflags;
+#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
+	if (raw_irqs_disabled_flags(regs->eflags)) {
+		trace_hardirqs_off();
+	} else {
+		trace_hardirqs_on();
+	}
+#endif
 
 	/* Restore the original saved kprobes variables and continue. */
 	if (kcb->kprobe_status == KPROBE_REENTER) {
@@ -685,6 +692,7 @@ int __kprobes setjmp_pre_handler(struct 
 	memcpy(kcb->jprobes_stack, (kprobe_opcode_t *)addr,
 			MIN_STACK_SIZE(addr));
 	regs->eflags &= ~IF_MASK;
+	trace_hardirqs_off();
 	regs->rip = (unsigned long)(jp->entry);
 	return 1;
 }


