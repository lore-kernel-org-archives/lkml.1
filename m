Return-Path: <linux-kernel-owner+w=401wt.eu-S933073AbXLQQIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073AbXLQQIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932588AbXLQQHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:07:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932446AbXLQQHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:07:45 -0500
Message-ID: <47669E9D.4010608@redhat.com>
Date: Mon, 17 Dec 2007 11:06:53 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>
CC: systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [-mm][PATCH 2/6] kprobes bugfix and cleanup resume_execution
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up and fixes bugs in resume_execution on x86-64.
Kprobes for x86-64 may cause a kernel crash if it inserted on "iret"
instruction. "call absolute" is invalid on x86-64, so we don't need
treat it.

 - Change the processing order as same as x86-32.
 - Add "iret"(0xcf) case.
 - Remove next_rip local variable.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 arch/x86/kernel/kprobes_64.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

Index: 2.6.24-rc4-mm1/arch/x86/kernel/kprobes_64.c
===================================================================
--- 2.6.24-rc4-mm1.orig/arch/x86/kernel/kprobes_64.c
+++ 2.6.24-rc4-mm1/arch/x86/kernel/kprobes_64.c
@@ -498,7 +498,6 @@ static void __kprobes resume_execution(s
 		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
 {
 	unsigned long *tos = (unsigned long *)regs->sp;
-	unsigned long next_rip = 0;
 	unsigned long copy_rip = (unsigned long)p->ainsn.insn;
 	unsigned long orig_rip = (unsigned long)p->addr;
 	kprobe_opcode_t *insn = p->ainsn.insn;
@@ -507,48 +506,44 @@ static void __kprobes resume_execution(s
 	if (*insn >= 0x40 && *insn <= 0x4f)
 		insn++;

+	regs->flags &= ~TF_MASK;
 	switch (*insn) {
-	case 0x9c:		/* pushfl */
+	case 0x9c:	/* pushfl */
 		*tos &= ~(TF_MASK | IF_MASK);
 		*tos |= kcb->kprobe_old_rflags;
 		break;
-	case 0xc3:		/* ret/lret */
-	case 0xcb:
-	case 0xc2:
+	case 0xc2:	/* iret/ret/lret */
+	case 0xc3:
 	case 0xca:
-		regs->flags &= ~TF_MASK;
-		/* ip is already adjusted, no more changes required*/
-		return;
-	case 0xe8:		/* call relative - Fix return addr */
+	case 0xcb:
+	case 0xcf:
+	case 0xea:	/* jmp absolute -- ip is correct */
+		/* ip is already adjusted, no more changes required */
+		goto no_change;
+	case 0xe8:	/* call relative - Fix return addr */
 		*tos = orig_rip + (*tos - copy_rip);
 		break;
 	case 0xff:
 		if ((insn[1] & 0x30) == 0x10) {
 			/* call absolute, indirect */
 			/* Fix return addr; ip is correct. */
-			next_rip = regs->ip;
 			*tos = orig_rip + (*tos - copy_rip);
+			goto no_change;
 		} else if (((insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
 			   ((insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
 			/* ip is correct. */
-			next_rip = regs->ip;
+			goto no_change;
 		}
-		break;
-	case 0xea:		/* jmp absolute -- ip is correct */
-		next_rip = regs->ip;
-		break;
 	default:
 		break;
 	}

-	regs->flags &= ~TF_MASK;
-	if (next_rip) {
-		regs->ip = next_rip;
-	} else {
-		regs->ip = orig_rip + (regs->ip - copy_rip);
-	}
+	regs->ip = orig_rip + (regs->ip - copy_rip);

+no_change:
 	restore_btf();
+
+	return;
 }

 int __kprobes post_kprobe_handler(struct pt_regs *regs)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com


