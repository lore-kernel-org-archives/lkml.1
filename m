Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbXLSVui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbXLSVui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 16:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXLSVu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 16:50:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbXLSVu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 16:50:29 -0500
Message-ID: <476991C6.2070909@redhat.com>
Date: Wed, 19 Dec 2007 16:48:54 -0500
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
Subject: [PATCH 2/3] x86: add reenter_kprobe helper
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:  Harvey Harrison <harvey.harrison@gmail.com>

[ mhiramat@redhat.com: updated it to latest x86.git ]

Factor common X86_32, X86_64 kprobe reenter logic from deeply
indented section to helper function.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
---

 arch/x86/kernel/kprobes.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

Index: b/arch/x86/kernel/kprobes.c
===================================================================
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -427,6 +427,20 @@ void __kprobes arch_prepare_kretprobe(st
 	/* Replace the return addr with trampoline addr */
 	*sara = (unsigned long) &kretprobe_trampoline;
 }
+/*
+ * We have reentered the kprobe_handler(), since another probe was hit while
+ * within the handler. We save the original kprobes variables and just single
+ * step on the instruction of the new probe without calling any user handlers.
+ */
+static void __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
+				     struct kprobe_ctlblk *kcb)
+{
+	save_previous_kprobe(kcb);
+	set_current_kprobe(p, regs, kcb);
+	kprobes_inc_nmissed_count(p);
+	prepare_singlestep(p, regs);
+	kcb->kprobe_status = KPROBE_REENTER;
+}

 /*
  * Interrupts are disabled on entry as trap3 is an interrupt gate and they
@@ -471,17 +485,7 @@ static int __kprobes kprobe_handler(stru
 				goto no_kprobe;
 #endif
 			}
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
+			reenter_kprobe(p, regs, kcb);
 			return 1;
 		} else {
 			if (*addr != BREAKPOINT_INSTRUCTION) {
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com
