Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbXLRXVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbXLRXVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 18:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbXLRXVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 18:21:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbXLRXVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 18:21:38 -0500
Message-ID: <47685565.3040906@redhat.com>
Date: Tue, 18 Dec 2007 18:19:01 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>
CC: Roland McGrath <roland@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] x86: add reenter_kprobe helper
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kprobe reenter logic from deeply indented section to helper function.
This improves code readability.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
Harvey, I picked up your patch and enhanced it.
I think this idea is good for improving readability.

 arch/x86/kernel/kprobes.c |   68 +++++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

Index: b/arch/x86/kernel/kprobes.c
===================================================================
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -427,6 +427,38 @@ void __kprobes arch_prepare_kretprobe(st
 	/* Replace the return addr with trampoline addr */
 	*sara = (unsigned long) &kretprobe_trampoline;
 }
+/*
+ * We have reentered the kprobe_handler(), since another probe was hit while
+ * within the handler. We save the original kprobes variables and just single
+ * step on the instruction of the new probe without calling any user handlers.
+ */
+static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
+				   struct kprobe_ctlblk *kcb)
+{
+	if (kcb->kprobe_status == KPROBE_HIT_SS &&
+	    *p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
+		regs->flags &= ~X86_EFLAGS_TF;
+		regs->flags |= kcb->kprobe_saved_flags;
+		return 0;
+#ifdef CONFIG_X86_64
+	} else if (kcb->kprobe_status == KPROBE_HIT_SSDONE) {
+		/* TODO: Provide re-entrancy from post_kprobes_handler() and
+		 * avoid exception stack corruption while single-stepping on
+		 * the instruction of the new probe.
+		 */
+		arch_disarm_kprobe(p);
+		regs->ip = (unsigned long)p->addr;
+		reset_current_kprobe();
+		return 1;
+#endif
+	}
+	save_previous_kprobe(kcb);
+	set_current_kprobe(p, regs, kcb);
+	kprobes_inc_nmissed_count(p);
+	prepare_singlestep(p, regs);
+	kcb->kprobe_status = KPROBE_REENTER;
+	return 1;
+}

 /*
  * Interrupts are disabled on entry as trap3 is an interrupt gate and they
@@ -451,39 +483,9 @@ static int __kprobes kprobe_handler(stru
 	/* Check we're not actually recursing */
 	if (kprobe_running()) {
 		p = get_kprobe(addr);
-		if (p) {
-			if (kcb->kprobe_status == KPROBE_HIT_SS &&
-				*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
-				regs->flags &= ~X86_EFLAGS_TF;
-				regs->flags |= kcb->kprobe_saved_flags;
-				goto no_kprobe;
-#ifdef CONFIG_X86_64
-			} else if (kcb->kprobe_status == KPROBE_HIT_SSDONE) {
-				/* TODO: Provide re-entrancy from
-				 * post_kprobes_handler() and avoid exception
-				 * stack corruption while single-stepping on
-				 * the instruction of the new probe.
-				 */
-				arch_disarm_kprobe(p);
-				regs->ip = (unsigned long)p->addr;
-				reset_current_kprobe();
-				ret = 1;
-				goto no_kprobe;
-#endif
-			}
-			/* We have reentered the kprobe_handler(), since
-			 * another probe was hit while within the handler.
-			 * We here save the original kprobes variables and
-			 * just single step on the instruction of the new probe
-			 * without calling any user handlers.
-			 */
-			save_previous_kprobe(kcb);
-			set_current_kprobe(p, regs, kcb);
-			kprobes_inc_nmissed_count(p);
-			prepare_singlestep(p, regs);
-			kcb->kprobe_status = KPROBE_REENTER;
-			ret = 1;
-		} else {
+		if (p)
+			ret = reenter_kprobe(p, regs, kcb);
+		else {
 			if (*addr != BREAKPOINT_INSTRUCTION) {
 			/* The breakpoint instruction was removed by
 			 * another cpu right after we hit, no further



-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com


