Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbYIIXcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbYIIXcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 19:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbYIIXcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 19:32:24 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:24630 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbYIIXcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 19:32:23 -0400
From: heukelum@fastmail.fm
To: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 24/24] i386: trace_hardirqs_fixup should now not be necessary: irqs are off.
Date: Tue,  9 Sep 2008 21:56:18 +0200
Message-Id: <1220990178-29773-25-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1220990178-29773-24-git-send-email-heukelum@fastmail.fm>
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
 <1220990178-29773-20-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-21-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-22-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-23-git-send-email-heukelum@fastmail.fm>
 <1220990178-29773-24-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Wed, 10 Sep 2008 01:31:58 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.28; VDF: 7.0.6.136; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander van Heukelum <heukelum@fastmail.fm>

The exception handlers in entry_32.S should now all call
TRACE_IRQS_OFF before calling the C code. The calls to
trace_hardirqs_fixup should now be unnecessary. Remove them.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 7047760..041a25e 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -533,7 +533,6 @@ vm86_trap:
 #define DO_ERROR(trapnr, signr, str, name)				\
 void do_##name(struct pt_regs *regs, long error_code)			\
 {									\
-	trace_hardirqs_fixup();						\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
 							== NOTIFY_STOP)	\
 		return;							\
@@ -576,7 +575,6 @@ void do_##name(struct pt_regs *regs, long error_code)			\
 	info.si_errno = 0;						\
 	info.si_code = sicode;						\
 	info.si_addr = (void __user *)siaddr;				\
-	trace_hardirqs_fixup();						\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
 							== NOTIFY_STOP)	\
 		return;							\
@@ -860,15 +858,9 @@ void restart_nmi(void)
 void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
 #ifdef CONFIG_KPROBES
-	trace_hardirqs_fixup();
-
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
 		return;
-	/*
-	 * This is an interrupt gate, because kprobes wants interrupts
-	 * disabled. Normal trap handlers don't.
-	 */
 	conditional_sti(regs);
 #else
 	if (notify_die(DIE_TRAP, "int3", regs, error_code, 3, SIGTRAP)
@@ -906,8 +898,6 @@ void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	struct task_struct *tsk = current;
 	unsigned int condition;
 
-	trace_hardirqs_fixup();
-
 	get_debugreg(condition, 6);
 
 	/*
-- 
1.5.4.3

