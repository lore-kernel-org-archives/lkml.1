Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYI3Qrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYI3Qrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbYI3QrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:47:12 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:22858 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbYI3QrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:47:10 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 4/4] traps: x86: converge do_debug handlers
Date: Tue, 30 Sep 2008 18:41:37 +0200
Message-Id: <1222792897-5691-5-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1222792897-5691-4-git-send-email-heukelum@fastmail.fm>
References: <1222792897-5691-1-git-send-email-heukelum@fastmail.fm>
 <1222792897-5691-2-git-send-email-heukelum@fastmail.fm>
 <1222792897-5691-3-git-send-email-heukelum@fastmail.fm>
 <1222792897-5691-4-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Tue, 30 Sep 2008 18:46:51 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.231; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the x86_64-version and the i386-version of do_debug
more similar.

 - introduce preempt_conditional_sti/cli to i386. The preempt-count
	is now elevated during the trap handler, like on x86_64. It
	does not run on a separate stack, however.
 - replace an open-coded "send_sigtrap"
 - copy some comments

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |   30 +++++++++++++++++++++---------
 arch/x86/kernel/traps_64.c |   17 +++++++++--------
 include/asm-x86/ptrace.h   |    4 ----
 3 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 6ecc1b7..da97cd2 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -89,6 +89,20 @@ static inline void conditional_sti(struct pt_regs *regs)
 		local_irq_enable();
 }
 
+static inline void preempt_conditional_sti(struct pt_regs *regs)
+{
+	inc_preempt_count();
+	if (regs->flags & X86_EFLAGS_IF)
+		local_irq_enable();
+}
+
+static inline void preempt_conditional_cli(struct pt_regs *regs)
+{
+	if (regs->flags & X86_EFLAGS_IF)
+		local_irq_disable();
+	dec_preempt_count();
+}
+
 static inline void
 die_if_kernel(const char *str, struct pt_regs *regs, long err)
 {
@@ -499,7 +513,7 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
-	unsigned int condition;
+	unsigned long condition;
 	int si_code;
 
 	get_debugreg(condition, 6);
@@ -517,9 +531,9 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
 						SIGTRAP) == NOTIFY_STOP)
 		return;
+
 	/* It's safe to allow irq's after DR6 has been saved */
-	if (regs->flags & X86_EFLAGS_IF)
-		local_irq_enable();
+	preempt_conditional_sti(regs);
 
 	/* Mask out spurious debug traps due to lazy DR7 setting */
 	if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) {
@@ -538,16 +552,11 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	 * kernel space (but re-enable TF when returning to user mode).
 	 */
 	if (condition & DR_STEP) {
-		/*
-		 * We already checked v86 mode above, so we can
-		 * check for kernel mode by just checking the CPL
-		 * of CS.
-		 */
 		if (!user_mode(regs))
 			goto clear_TF_reenable;
 	}
 
-	si_code = get_si_code((unsigned long)condition);
+	si_code = get_si_code(condition);
 	/* Ok, finally something we can handle */
 	send_sigtrap(tsk, regs, error_code, si_code);
 
@@ -557,15 +566,18 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	 */
 clear_dr7:
 	set_debugreg(0, 7);
+	preempt_conditional_cli(regs);
 	return;
 
 debug_vm86:
 	handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code, 1);
+	preempt_conditional_cli(regs);
 	return;
 
 clear_TF_reenable:
 	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
 	regs->flags &= ~X86_EFLAGS_TF;
+	preempt_conditional_cli(regs);
 	return;
 }
 
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index d4e02c1..80dbbc7 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -381,7 +381,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
 	unsigned long condition;
-	siginfo_t info;
+	int si_code;
 
 	get_debugreg(condition, 6);
 
@@ -399,6 +399,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 						SIGTRAP) == NOTIFY_STOP)
 		return;
 
+	/* It's safe to allow irq's after DR6 has been saved */
 	preempt_conditional_sti(regs);
 
 	/* Mask out spurious debug traps due to lazy DR7 setting */
@@ -407,6 +408,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 			goto clear_dr7;
 	}
 
+	/* Save debug status register where ptrace can see it */
 	tsk->thread.debugreg6 = condition;
 
 	/*
@@ -418,15 +420,14 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 			goto clear_TF_reenable;
 	}
 
+	si_code = get_si_code(condition);
 	/* Ok, finally something we can handle */
-	tsk->thread.trap_no = 1;
-	tsk->thread.error_code = error_code;
-	info.si_signo = SIGTRAP;
-	info.si_errno = 0;
-	info.si_code = get_si_code(condition);
-	info.si_addr = user_mode(regs) ? (void __user *)regs->ip : NULL;
-	force_sig_info(SIGTRAP, &info, tsk);
+	send_sigtrap(tsk, regs, error_code, si_code);
 
+	/*
+	 * Disable additional traps. They'll be re-enabled when
+	 * the signal is delivered.
+	 */
 clear_dr7:
 	set_debugreg(0, 7);
 	preempt_conditional_cli(regs);
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index ac578f1..a202552 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -174,12 +174,8 @@ extern unsigned long profile_pc(struct pt_regs *regs);
 
 extern unsigned long
 convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
-
-#ifdef CONFIG_X86_32
 extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 			 int error_code, int si_code);
-#endif
-
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
 extern long syscall_trace_enter(struct pt_regs *);
-- 
1.5.4.3

