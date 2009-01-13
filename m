Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbZAMWha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbZAMWha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbZAMWhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:37:10 -0500
Received: from www.tglx.de ([62.245.132.106]:40973 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756519AbZAMWhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:37:06 -0500
Date: Tue, 13 Jan 2009 23:36:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Michal Suchanek <hramrach@centrum.cz>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: vm86: fix preemption bug
In-Reply-To: <nHCfeC0YLrE.A.WKC.qafaJB@chimera>
Message-ID: <alpine.LFD.2.00.0901132117270.3549@localhost.localdomain>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera> <nHCfeC0YLrE.A.WKC.qafaJB@chimera>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix scheduling while atomic bug

commit 3d2a71a596bd9c761c8487a2178e95f8a61da083 (x86, traps: converge
do_debug handlers) changed the preemption disable logic of do_debug()
so vm86_handle_trap() is called with preemption disabled resulting in:

BUG: sleeping function called from invalid context at include/linux/kernel.h:155
in_atomic(): 1, irqs_disabled(): 0, pid: 3005, name: dosemu.bin
Pid: 3005, comm: dosemu.bin Tainted: G        W  2.6.29-rc1 #51
Call Trace:
 [<c050d669>] copy_to_user+0x33/0x108
 [<c04181f4>] save_v86_state+0x65/0x149
 [<c0418531>] handle_vm86_trap+0x20/0x8f
 [<c064e345>] do_debug+0x15b/0x1a4
 [<c064df1f>] debug_stack_correct+0x27/0x2c
 [<c040365b>] sysenter_do_call+0x12/0x2f
BUG: scheduling while atomic: dosemu.bin/3005/0x10000001

Restore the original calling convention and reenable preemption before
calling handle_vm86_trap().

Reported-by: Michal Suchanek <hramrach@centrum.cz>
Cc: stable@kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/traps.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/traps.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/traps.c
+++ linux-2.6/arch/x86/kernel/traps.c
@@ -99,6 +99,12 @@ static inline void preempt_conditional_s
 		local_irq_enable();
 }
 
+static inline void conditional_cli(struct pt_regs *regs)
+{
+	if (regs->flags & X86_EFLAGS_IF)
+		local_irq_disable();
+}
+
 static inline void preempt_conditional_cli(struct pt_regs *regs)
 {
 	if (regs->flags & X86_EFLAGS_IF)
@@ -626,8 +632,10 @@ clear_dr7:
 
 #ifdef CONFIG_X86_32
 debug_vm86:
+	/* reenable preemption: handle_vm86_trap() might sleep */
+	dec_preempt_count();
 	handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code, 1);
-	preempt_conditional_cli(regs);
+	conditional_cli(regs);
 	return;
 #endif
 
