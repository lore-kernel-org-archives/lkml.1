Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbYIJAmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbYIJAmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 20:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYIJAmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 20:42:12 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:15790 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYIJAmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 20:42:11 -0400
From: heukelum@fastmail.fm
To: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 4/24] i386: expand exception 3 DO_TRAP macro
Date: Tue,  9 Sep 2008 21:55:58 +0200
Message-Id: <1220990178-29773-5-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1220990178-29773-4-git-send-email-heukelum@fastmail.fm>
References: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-2-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-3-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-4-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Wed, 10 Sep 2008 02:41:58 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.28; VDF: 7.0.6.136; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander van Heukelum <heukelum@fastmail.fm>

The int3 exception was already takes as an interrupt and
do_int3 does not fit in the new DO_ERROR macro. This patch
just expands the DO_TRAP macro and rearranges the code a
bit.

No functional changes intended.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 97d193c..944641a 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -633,9 +633,6 @@ void do_##name(struct pt_regs *regs, long error_code)			\
 }
 
 DO_VM86_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
-#ifndef CONFIG_KPROBES
-DO_VM86_TRAP(3, SIGTRAP, "int3", int3)
-#endif
 DO_VM86_TRAP(4, SIGSEGV, "overflow", overflow)
 DO_VM86_TRAP(5, SIGSEGV, "bounds", bounds)
 DO_TRAP_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip, 0)
@@ -907,9 +904,9 @@ void restart_nmi(void)
 	acpi_nmi_enable();
 }
 
-#ifdef CONFIG_KPROBES
 void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
+#ifdef CONFIG_KPROBES
 	trace_hardirqs_fixup();
 
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
@@ -920,10 +917,14 @@ void __kprobes do_int3(struct pt_regs *regs, long error_code)
 	 * disabled. Normal trap handlers don't.
 	 */
 	conditional_sti(regs);
+#else
+	if (notify_die(DIE_TRAP, "int3", regs, error_code, 3, SIGTRAP)
+			== NOTIFY_STOP)
+		return;
+#endif
 
 	do_trap(3, SIGTRAP, "int3", 1, regs, error_code, NULL);
 }
-#endif
 
 /*
  * Our handling of the processor debug registers is non-trivial.
-- 
1.5.4.3

