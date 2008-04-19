Return-Path: <linux-kernel-owner+w=401wt.eu-S1762460AbYDSV1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762460AbYDSV1M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 17:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYDSV06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 17:26:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbYDSV05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 17:26:57 -0400
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 1/2] x86 signals: lift flags diddling code
X-Shopping-List: (1) Pompous porno ammunition
   (2) Dramatic scorpions
   (3) Portentous consolation
   (4) Precarious revulsion pistons
Message-Id: <20080419212654.9971827037C@magilla.localdomain>
Date: Sat, 19 Apr 2008 14:26:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lifts the code diddling the TF and DF bits for signal handler setup
out of the several places copying the same code into the one place that
calls them all.  There is no change in what it does.

I also separated the recently-added DF bit clearing from the TF diddling.
The compiler turns them back into one instruction anyway.  The tossing
in of DF to the same line of code with no new comments was a bit more
arcane than seems wise.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ia32_signal.c |    6 ------
 arch/x86/kernel/signal_32.c |   35 +++++++++++++++--------------------
 arch/x86/kernel/signal_64.c |   19 +++++++++++++++----
 3 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 05e155d..0866104 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -500,9 +500,6 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	regs->ss = __USER32_DS;
 
 	set_fs(USER_DS);
-	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
 
 #if DEBUG_SIG
 	printk(KERN_DEBUG "SIG deliver (%s:%d): sp=%p pc=%lx ra=%u\n",
@@ -600,9 +597,6 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->ss = __USER32_DS;
 
 	set_fs(USER_DS);
-	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
 
 #if DEBUG_SIG
 	printk(KERN_DEBUG "SIG deliver (%s:%d): sp=%p pc=%lx ra=%u\n",
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index f1b1179..8e05e7f 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -413,16 +413,6 @@ setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	regs->ss = __USER_DS;
 	regs->cs = __USER_CS;
 
-	/*
-	 * Clear TF when entering the signal handler, but
-	 * notify any tracer that was single-stepping it.
-	 * The tracer may want to single-step inside the
-	 * handler too.
-	 */
-	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
-
 	return 0;
 
 give_sigsegv:
@@ -501,16 +491,6 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->ss = __USER_DS;
 	regs->cs = __USER_CS;
 
-	/*
-	 * Clear TF when entering the signal handler, but
-	 * notify any tracer that was single-stepping it.
-	 * The tracer may want to single-step inside the
-	 * handler too.
-	 */
-	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
-
 	return 0;
 
 give_sigsegv:
@@ -566,6 +546,21 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	if (ret)
 		return ret;
 
+	/*
+	 * Clear the direction flag as per the ABI for function entry.
+	 */
+	regs->flags &= ~X86_EFLAGS_DF;
+
+	/*
+	 * Clear TF when entering the signal handler, but
+	 * notify any tracer that was single-stepping it.
+	 * The tracer may want to single-step inside the
+	 * handler too.
+	 */
+	regs->flags &= ~X86_EFLAGS_TF;
+	if (test_thread_flag(TIF_SINGLESTEP))
+		ptrace_notify(SIGTRAP);
+
 	spin_lock_irq(&current->sighand->siglock);
 	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NODEFER))
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 827179c..3a76702 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -289,10 +289,6 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	   see include/asm-x86_64/uaccess.h for details. */
 	set_fs(USER_DS);
 
-	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
-
 	return 0;
 
 give_sigsegv:
@@ -380,6 +376,21 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	ret = setup_rt_frame(sig, ka, info, oldset, regs);
 
 	if (ret == 0) {
+		/*
+		 * Clear the direction flag as per the ABI for function entry.
+		 */
+		regs->flags &= ~X86_EFLAGS_DF;
+
+		/*
+		 * Clear TF when entering the signal handler, but
+		 * notify any tracer that was single-stepping it.
+		 * The tracer may want to single-step inside the
+		 * handler too.
+		 */
+		regs->flags &= ~X86_EFLAGS_TF;
+		if (test_thread_flag(TIF_SINGLESTEP))
+			ptrace_notify(SIGTRAP);
+
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
 		if (!(ka->sa.sa_flags & SA_NODEFER))
