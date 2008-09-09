Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbYIJFWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbYIJFWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 01:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYIJFWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 01:22:11 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:11685 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbYIJFWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 01:22:11 -0400
From: heukelum@fastmail.fm
To: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 19/24] i386: remove temporary DO_TRAP macros, expanding the last one used
Date: Tue,  9 Sep 2008 21:56:13 +0200
Message-Id: <1220990178-29773-20-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1220990178-29773-19-git-send-email-heukelum@fastmail.fm>
References: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-2-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-3-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-4-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-5-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-6-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-7-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-8-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-9-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-10-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-11-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-12-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-13-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-14-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-15-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-16-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-17-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-18-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-19-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Wed, 10 Sep 2008 07:21:58 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.28; VDF: 7.0.6.136; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander van Heukelum <heukelum@fastmail.fm>

Only one use of the DO_TRAP macros remains. Expand that one and
remove the macros now.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |   66 ++++++++++----------------------------------
 1 files changed, 15 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 1ad7697..7047760 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -530,56 +530,6 @@ vm86_trap:
 	return;
 }
 
-#define DO_TRAP(trapnr, signr, str, name)				\
-void do_##name(struct pt_regs *regs, long error_code)			\
-{									\
-	trace_hardirqs_fixup();						\
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-							== NOTIFY_STOP)	\
-		return;							\
-	do_trap(trapnr, signr, str, 0, regs, error_code, NULL);		\
-}
-
-#define DO_TRAP_INFO(trapnr, signr, str, name, sicode, siaddr, irq)	\
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
-	do_trap(trapnr, signr, str, 0, regs, error_code, &info);	\
-}
-
-#define DO_VM86_TRAP(trapnr, signr, str, name)				\
-void do_##name(struct pt_regs *regs, long error_code)			\
-{									\
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-							== NOTIFY_STOP)	\
-		return;							\
-	do_trap(trapnr, signr, str, 1, regs, error_code, NULL);		\
-}
-
-#define DO_VM86_TRAP_INFO(trapnr, signr, str, name, sicode, siaddr)	\
-void do_##name(struct pt_regs *regs, long error_code)			\
-{									\
-	siginfo_t info;							\
-	info.si_signo = signr;						\
-	info.si_errno = 0;						\
-	info.si_code = sicode;						\
-	info.si_addr = (void __user *)siaddr;				\
-	trace_hardirqs_fixup();						\
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-							== NOTIFY_STOP)	\
-		return;							\
-	do_trap(trapnr, signr, str, 1, regs, error_code, &info);	\
-}
-
 #define DO_ERROR(trapnr, signr, str, name)				\
 void do_##name(struct pt_regs *regs, long error_code)			\
 {									\
@@ -643,7 +593,6 @@ DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
 DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
 DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
 DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0, 0)
-DO_TRAP_INFO(32, SIGILL, "iret exception", iret_error, ILL_BADSTK, 0, 1)
 
 void __kprobes
 do_general_protection(struct pt_regs *regs, long error_code)
@@ -1261,6 +1210,21 @@ void __kprobes do_machine_check(struct pt_regs *regs, long error)
 }
 #endif
 
+void do_iret_error(struct pt_regs *regs, long error_code)
+{
+	siginfo_t info;
+	local_irq_enable();
+
+	info.si_signo = SIGILL;
+	info.si_errno = 0;
+	info.si_code = ILL_BADSTK;
+	info.si_addr = 0;
+	if (notify_die(DIE_TRAP, "iret exception",
+			regs, error_code, 32, SIGILL) == NOTIFY_STOP)
+		return;
+	do_trap(32, SIGILL, "iret exception", 0, regs, error_code, &info);
+}
+
 void __init trap_init(void)
 {
 	int i;
-- 
1.5.4.3

