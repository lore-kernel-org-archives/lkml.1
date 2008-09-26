Return-Path: <linux-kernel-owner+w=401wt.eu-S1752156AbYIZMMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbYIZMMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYIZMMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:12:12 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:23146 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYIZMMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:12:10 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 7/7] traps: i386: make do_trap more like x86_64
Date: Fri, 26 Sep 2008 14:03:08 +0200
Message-Id: <1222430588-29072-8-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1222430588-29072-7-git-send-email-heukelum@fastmail.fm>
References: <1222430588-29072-1-git-send-email-heukelum@fastmail.fm>
 <1222430588-29072-2-git-send-email-heukelum@fastmail.fm>
 <1222430588-29072-3-git-send-email-heukelum@fastmail.fm>
 <1222430588-29072-4-git-send-email-heukelum@fastmail.fm>
 <1222430588-29072-5-git-send-email-heukelum@fastmail.fm>
 <1222430588-29072-6-git-send-email-heukelum@fastmail.fm>
 <1222430588-29072-7-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Fri, 26 Sep 2008 14:11:53 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.215; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch hardcodes which traps should be forwarded to
handle_vm86_trap in do_trap. This allows to remove the
vm86 parameter from the i386-version of do_trap, which
makes the DO_VM86_ERROR and DO_VM86_ERROR_INFO macros
unnecessary.

x86_64 part is whitespace only.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |   55 ++++++++++++-------------------------------
 arch/x86/kernel/traps_64.c |    6 ++--
 2 files changed, 19 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 041a25e..a603554 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -482,13 +482,17 @@ die_if_kernel(const char *str, struct pt_regs *regs, long err)
 }
 
 static void __kprobes
-do_trap(int trapnr, int signr, char *str, int vm86, struct pt_regs *regs,
+do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	long error_code, siginfo_t *info)
 {
 	struct task_struct *tsk = current;
 
 	if (regs->flags & X86_VM_MASK) {
-		if (vm86)
+		/*
+		 * traps 0, 1, 3, 4, and 5 should be forwarded to vm86.
+		 * On nmi (interrupt 2), do_trap should not be called.
+		 */
+		if (trapnr < 6)
 			goto vm86_trap;
 		goto trap_signal;
 	}
@@ -537,37 +541,10 @@ void do_##name(struct pt_regs *regs, long error_code)			\
 							== NOTIFY_STOP)	\
 		return;							\
 	conditional_sti(regs);						\
-	do_trap(trapnr, signr, str, 0, regs, error_code, NULL);		\
-}
-
-#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr, irq)	\
-void do_##name(struct pt_regs *regs, long error_code)			\
-{									\
-	siginfo_t info;							\
-	if (irq)							\
-		local_irq_enable();					\
-	info.si_signo = signr;						\
-	info.si_errno = 0;						\
-	info.si_code = sicode;						\
-	info.si_addr = (void __user *)siaddr;				\
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-							== NOTIFY_STOP)	\
-		return;							\
-	conditional_sti(regs);						\
-	do_trap(trapnr, signr, str, 0, regs, error_code, &info);	\
-}
-
-#define DO_VM86_ERROR(trapnr, signr, str, name)				\
-void do_##name(struct pt_regs *regs, long error_code)			\
-{									\
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-							== NOTIFY_STOP)	\
-		return;							\
-	conditional_sti(regs);						\
-	do_trap(trapnr, signr, str, 1, regs, error_code, NULL);		\
+	do_trap(trapnr, signr, str, regs, error_code, NULL);		\
 }
 
-#define DO_VM86_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)	\
+#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
 void do_##name(struct pt_regs *regs, long error_code)			\
 {									\
 	siginfo_t info;							\
@@ -579,18 +556,18 @@ void do_##name(struct pt_regs *regs, long error_code)			\
 							== NOTIFY_STOP)	\
 		return;							\
 	conditional_sti(regs);						\
-	do_trap(trapnr, signr, str, 1, regs, error_code, &info);	\
+	do_trap(trapnr, signr, str, regs, error_code, &info);		\
 }
 
-DO_VM86_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
-DO_VM86_ERROR(4, SIGSEGV, "overflow", overflow)
-DO_VM86_ERROR(5, SIGSEGV, "bounds", bounds)
-DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip, 0)
+DO_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
+DO_ERROR(4, SIGSEGV, "overflow", overflow)
+DO_ERROR(5, SIGSEGV, "bounds", bounds)
+DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip)
 DO_ERROR(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
 DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
 DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
 DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
-DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0, 0)
+DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
 
 void __kprobes
 do_general_protection(struct pt_regs *regs, long error_code)
@@ -868,7 +845,7 @@ void __kprobes do_int3(struct pt_regs *regs, long error_code)
 		return;
 #endif
 
-	do_trap(3, SIGTRAP, "int3", 1, regs, error_code, NULL);
+	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
 }
 
 /*
@@ -1212,7 +1189,7 @@ void do_iret_error(struct pt_regs *regs, long error_code)
 	if (notify_die(DIE_TRAP, "iret exception",
 			regs, error_code, 32, SIGILL) == NOTIFY_STOP)
 		return;
-	do_trap(32, SIGILL, "iret exception", 0, regs, error_code, &info);
+	do_trap(32, SIGILL, "iret exception", regs, error_code, &info);
 }
 
 void __init trap_init(void)
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index c5fb747..40da132 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -637,8 +637,8 @@ kernel_trap:
 	return;
 }
 
-#define DO_ERROR(trapnr, signr, str, name) \
-asmlinkage void do_##name(struct pt_regs * regs, long error_code)	\
+#define DO_ERROR(trapnr, signr, str, name)				\
+asmlinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
 							== NOTIFY_STOP)	\
@@ -648,7 +648,7 @@ asmlinkage void do_##name(struct pt_regs * regs, long error_code)	\
 }
 
 #define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
-asmlinkage void do_##name(struct pt_regs * regs, long error_code)	\
+asmlinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
 	siginfo_t info;							\
 	info.si_signo = signr;						\
-- 
1.5.4.3

