Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbXLSVx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbXLSVx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 16:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbXLSVxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 16:53:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbXLSVxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 16:53:48 -0500
Message-ID: <476991D5.3030909@redhat.com>
Date: Wed, 19 Dec 2007 16:49:09 -0500
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
Subject: [PATCH 3/3] x86: move deeply indented code to reenter_kprobe
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move some deeply indented code related to re-entrance processing
from kprobe_handler() to reenter_kprobe().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
---

 arch/x86/kernel/kprobes.c |   46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

Index: b/arch/x86/kernel/kprobes.c
===================================================================
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -432,14 +432,32 @@ void __kprobes arch_prepare_kretprobe(st
  * within the handler. We save the original kprobes variables and just single
  * step on the instruction of the new probe without calling any user handlers.
  */
-static void __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
-				     struct kprobe_ctlblk *kcb)
+static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
+				    struct kprobe_ctlblk *kcb)
 {
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
 	save_previous_kprobe(kcb);
 	set_current_kprobe(p, regs, kcb);
 	kprobes_inc_nmissed_count(p);
 	prepare_singlestep(p, regs);
 	kcb->kprobe_status = KPROBE_REENTER;
+	return 1;
 }

 /*
@@ -466,27 +484,9 @@ static int __kprobes kprobe_handler(stru
 	if (kprobe_running()) {
 		p = get_kprobe(addr);
 		if (p) {
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
-			reenter_kprobe(p, regs, kcb);
-			return 1;
+			ret = reenter_kprobe(p, regs, kcb);
+			if (kcb->kprobe_status == KPROBE_REENTER)
+				return 1;
 		} else {
 			if (*addr != BREAKPOINT_INSTRUCTION) {
 			/* The breakpoint instruction was removed by

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

