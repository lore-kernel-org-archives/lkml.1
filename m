Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYI3QlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYI3QlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYI3Qkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:40:55 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:10739 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYI3Qkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:40:55 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 1/4] traps: x86_64: split out math_error and simd_math_error
Date: Tue, 30 Sep 2008 18:41:34 +0200
Message-Id: <1222792897-5691-2-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1222792897-5691-1-git-send-email-heukelum@fastmail.fm>
References: <1222792897-5691-1-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Tue, 30 Sep 2008 18:40:41 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.231; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out math_error from do_coprocessor_error and simd_math_error
from do_simd_coprocessor_error, like on i386. While at it, add the
"error_code" parameter to do_coprocessor_error, do_simd_coprocessor_error
and do_spurious_interrupt_bug. This does not change the generated
code, but brings the declarations in line with all the other trap
handlers.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_64.c |   36 +++++++++++++++++++++---------------
 include/asm-x86/traps.h    |    6 +++---
 2 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 8ab8f81..201f98d 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -457,18 +457,12 @@ static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
  * the correct behaviour even in the presence of the asynchronous
  * IRQ13 behaviour
  */
-asmlinkage void do_coprocessor_error(struct pt_regs *regs)
+void math_error(void __user *ip)
 {
-	void __user *ip = (void __user *)(regs->ip);
 	struct task_struct *task;
 	siginfo_t info;
 	unsigned short cwd, swd;
 
-	conditional_sti(regs);
-	if (!user_mode(regs) &&
-	    kernel_math_error(regs, "kernel x87 math error", 16))
-		return;
-
 	/*
 	 * Save the info for the exception handler and clear the error.
 	 */
@@ -521,23 +515,26 @@ asmlinkage void do_coprocessor_error(struct pt_regs *regs)
 	force_sig_info(SIGFPE, &info, task);
 }
 
+asmlinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
+{
+	conditional_sti(regs);
+	if (!user_mode(regs) &&
+	    kernel_math_error(regs, "kernel x87 math error", 16))
+		return;
+	math_error((void __user *)regs->ip);
+}
+
 asmlinkage void bad_intr(void)
 {
 	printk("bad interrupt");
 }
 
-asmlinkage void do_simd_coprocessor_error(struct pt_regs *regs)
+static void simd_math_error(void __user *ip)
 {
-	void __user *ip = (void __user *)(regs->ip);
 	struct task_struct *task;
 	siginfo_t info;
 	unsigned short mxcsr;
 
-	conditional_sti(regs);
-	if (!user_mode(regs) &&
-			kernel_math_error(regs, "kernel simd math error", 19))
-		return;
-
 	/*
 	 * Save the info for the exception handler and clear the error.
 	 */
@@ -580,7 +577,16 @@ asmlinkage void do_simd_coprocessor_error(struct pt_regs *regs)
 	force_sig_info(SIGFPE, &info, task);
 }
 
-asmlinkage void do_spurious_interrupt_bug(struct pt_regs *regs)
+asmlinkage void do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
+{
+	conditional_sti(regs);
+	if (!user_mode(regs) &&
+			kernel_math_error(regs, "kernel simd math error", 19))
+		return;
+	simd_math_error((void __user *)regs->ip);
+}
+
+asmlinkage void do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
 {
 }
 
diff --git a/include/asm-x86/traps.h b/include/asm-x86/traps.h
index 7a692ba..c82c39c 100644
--- a/include/asm-x86/traps.h
+++ b/include/asm-x86/traps.h
@@ -72,9 +72,9 @@ asmlinkage void double_fault(void);
 asmlinkage void do_int3(struct pt_regs *, long);
 asmlinkage void do_stack_segment(struct pt_regs *, long);
 asmlinkage void do_debug(struct pt_regs *, unsigned long);
-asmlinkage void do_coprocessor_error(struct pt_regs *);
-asmlinkage void do_simd_coprocessor_error(struct pt_regs *);
-asmlinkage void do_spurious_interrupt_bug(struct pt_regs *);
+asmlinkage void do_coprocessor_error(struct pt_regs *, long);
+asmlinkage void do_simd_coprocessor_error(struct pt_regs *, long);
+asmlinkage void do_spurious_interrupt_bug(struct pt_regs *, long);
 
 asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long error_code);
 
-- 
1.5.4.3

