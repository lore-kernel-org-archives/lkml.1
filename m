Return-Path: <linux-kernel-owner+w=401wt.eu-S1751663AbYIJEMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbYIJEMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 00:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYIJEMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 00:12:23 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:23571 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbYIJEMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 00:12:22 -0400
From: heukelum@fastmail.fm
To: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 2/24] i386: prepare to convert exceptions to interrupts
Date: Tue,  9 Sep 2008 21:55:56 +0200
Message-Id: <1220990178-29773-3-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1220990178-29773-2-git-send-email-heukelum@fastmail.fm>
References: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-2-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Wed, 10 Sep 2008 06:11:58 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.28; VDF: 7.0.6.136; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander van Heukelum <heukelum@fastmail.fm>

There is some macro magic in traps_32.c to construct standard
exception dispatch functions. This patch renames the DO_ERROR-
like macros to DO_TRAP, and introduces new DO_ERROR ones that
conditionally reenable interrupts explicitly, like x86_64.

No code changes.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |   76 +++++++++++++++++++++++++++++++++++++------
 1 files changed, 65 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index c8096f7..9ac59e0 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -528,6 +528,56 @@ vm86_trap:
 	return;
 }
 
+#define DO_TRAP(trapnr, signr, str, name)				\
+void do_##name(struct pt_regs *regs, long error_code)			\
+{									\
+	trace_hardirqs_fixup();						\
+	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
+							== NOTIFY_STOP)	\
+		return;							\
+	do_trap(trapnr, signr, str, 0, regs, error_code, NULL);		\
+}
+
+#define DO_TRAP_INFO(trapnr, signr, str, name, sicode, siaddr, irq)	\
+void do_##name(struct pt_regs *regs, long error_code)			\
+{									\
+	siginfo_t info;							\
+	if (irq)							\
+		local_irq_enable();					\
+	info.si_signo = signr;						\
+	info.si_errno = 0;						\
+	info.si_code = sicode;						\
+	info.si_addr = (void __user *)siaddr;				\
+	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
+							== NOTIFY_STOP)	\
+		return;							\
+	do_trap(trapnr, signr, str, 0, regs, error_code, &info);	\
+}
+
+#define DO_VM86_TRAP(trapnr, signr, str, name)				\
+void do_##name(struct pt_regs *regs, long error_code)			\
+{									\
+	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
+							== NOTIFY_STOP)	\
+		return;							\
+	do_trap(trapnr, signr, str, 1, regs, error_code, NULL);		\
+}
+
+#define DO_VM86_TRAP_INFO(trapnr, signr, str, name, sicode, siaddr)	\
+void do_##name(struct pt_regs *regs, long error_code)			\
+{									\
+	siginfo_t info;							\
+	info.si_signo = signr;						\
+	info.si_errno = 0;						\
+	info.si_code = sicode;						\
+	info.si_addr = (void __user *)siaddr;				\
+	trace_hardirqs_fixup();						\
+	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
+							== NOTIFY_STOP)	\
+		return;							\
+	do_trap(trapnr, signr, str, 1, regs, error_code, &info);	\
+}
+
 #define DO_ERROR(trapnr, signr, str, name)				\
 void do_##name(struct pt_regs *regs, long error_code)			\
 {									\
@@ -535,6 +585,7 @@ void do_##name(struct pt_regs *regs, long error_code)			\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
 							== NOTIFY_STOP)	\
 		return;							\
+	conditional_sti(regs);						\
 	do_trap(trapnr, signr, str, 0, regs, error_code, NULL);		\
 }
 
@@ -551,6 +602,7 @@ void do_##name(struct pt_regs *regs, long error_code)			\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
 							== NOTIFY_STOP)	\
 		return;							\
+	conditional_sti(regs);						\
 	do_trap(trapnr, signr, str, 0, regs, error_code, &info);	\
 }
 
@@ -560,6 +612,7 @@ void do_##name(struct pt_regs *regs, long error_code)			\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
 							== NOTIFY_STOP)	\
 		return;							\
+	conditional_sti(regs);						\
 	do_trap(trapnr, signr, str, 1, regs, error_code, NULL);		\
 }
 
@@ -575,22 +628,23 @@ void do_##name(struct pt_regs *regs, long error_code)			\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
 							== NOTIFY_STOP)	\
 		return;							\
+	conditional_sti(regs);						\
 	do_trap(trapnr, signr, str, 1, regs, error_code, &info);	\
 }
 
-DO_VM86_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
+DO_VM86_TRAP_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
 #ifndef CONFIG_KPROBES
-DO_VM86_ERROR(3, SIGTRAP, "int3", int3)
+DO_VM86_TRAP(3, SIGTRAP, "int3", int3)
 #endif
-DO_VM86_ERROR(4, SIGSEGV, "overflow", overflow)
-DO_VM86_ERROR(5, SIGSEGV, "bounds", bounds)
-DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip, 0)
-DO_ERROR(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
-DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
-DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
-DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
-DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0, 0)
-DO_ERROR_INFO(32, SIGILL, "iret exception", iret_error, ILL_BADSTK, 0, 1)
+DO_VM86_TRAP(4, SIGSEGV, "overflow", overflow)
+DO_VM86_TRAP(5, SIGSEGV, "bounds", bounds)
+DO_TRAP_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip, 0)
+DO_TRAP(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
+DO_TRAP(10, SIGSEGV, "invalid TSS", invalid_TSS)
+DO_TRAP(11, SIGBUS, "segment not present", segment_not_present)
+DO_TRAP(12, SIGBUS, "stack segment", stack_segment)
+DO_TRAP_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0, 0)
+DO_TRAP_INFO(32, SIGILL, "iret exception", iret_error, ILL_BADSTK, 0, 1)
 
 void __kprobes
 do_general_protection(struct pt_regs *regs, long error_code)
-- 
1.5.4.3

