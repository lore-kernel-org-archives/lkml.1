Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbYAICPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbYAICPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbYAICP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:15:28 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:8740 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbYAICP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:15:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=t7O2T+onXUSJEVfMVrr+4zVvUxqlnNpGX5YVy4nrWUkZUxKXCM0FmcTD8NIyXmmSwcLF0vEKxmfSPPulcbF9obzVXl009wGGQOzqrv62BLAGAey8/yqkBzclvCJ6rQmknCNGopEgFdTTDUDi8u6flxagVEJ/mgqSgwS5GHSBlA0=
Subject: [PATCH] x86: Use fixup_exception() in traps_64.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 18:15:28 -0800
Message-Id: <1199844928.6424.29.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the fixup_exception() helper instead of the open-coded
search_extable() users.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, this depends on my patch in x86.git unifying extable.c that
introduces fixup_exception() to X86_64.

 arch/x86/kernel/traps_64.c |   47 ++++++++++++++-----------------------------
 1 files changed, 15 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index e3d1ca1..c173687 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -606,19 +606,12 @@ static void __kprobes do_trap(int trapnr, int signr, char *str,
 	}
 

-	/* kernel trap */ 
-	{	     
-		const struct exception_table_entry *fixup;
-		fixup = search_exception_tables(regs->ip);
-		if (fixup)
-			regs->ip = fixup->fixup;
-		else {
-			tsk->thread.error_code = error_code;
-			tsk->thread.trap_no = trapnr;
-			die(str, regs, error_code);
-		}
-		return;
+	if (!fixup_exception(regs)) {
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_no = trapnr;
+		die(str, regs, error_code);
 	}
+	return;
 }
 
 #define DO_ERROR(trapnr, signr, str, name) \
@@ -707,22 +700,15 @@ asmlinkage void __kprobes do_general_protection(struct pt_regs * regs,
 		return;
 	} 
 
-	/* kernel gp */
-	{
-		const struct exception_table_entry *fixup;
-		fixup = search_exception_tables(regs->ip);
-		if (fixup) {
-			regs->ip = fixup->fixup;
-			return;
-		}
+	if (fixup_exception(regs))
+		return;
 
-		tsk->thread.error_code = error_code;
-		tsk->thread.trap_no = 13;
-		if (notify_die(DIE_GPF, "general protection fault", regs,
-					error_code, 13, SIGSEGV) == NOTIFY_STOP)
-			return;
-		die("general protection fault", regs, error_code);
-	}
+	tsk->thread.error_code = error_code;
+	tsk->thread.trap_no = 13;
+	if (notify_die(DIE_GPF, "general protection fault", regs,
+				error_code, 13, SIGSEGV) == NOTIFY_STOP)
+		return;
+	die("general protection fault", regs, error_code);
 }
 
 static __kprobes void
@@ -914,12 +900,9 @@ clear_TF_reenable:
 
 static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
 {
-	const struct exception_table_entry *fixup;
-	fixup = search_exception_tables(regs->ip);
-	if (fixup) {
-		regs->ip = fixup->fixup;
+	if (fixup_exception(regs))
 		return 1;
-	}
+
 	notify_die(DIE_GPF, str, regs, 0, trapnr, SIGFPE);
 	/* Illegal floating point operation in the kernel */
 	current->thread.trap_no = trapnr;
-- 
1.5.4.rc2.1164.g6451

