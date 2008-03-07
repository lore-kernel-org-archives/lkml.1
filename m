Return-Path: <linux-kernel-owner+w=401wt.eu-S1760303AbYCGWES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303AbYCGWES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 17:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYCGWEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 17:04:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbYCGWD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 17:03:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86 signals: lift flags diddling code
X-Zippy-Says: I love FRUIT PICKERS!!
Message-Id: <20080307220255.1BEE826F990@magilla.localdomain>
Date: Fri,  7 Mar 2008 14:02:55 -0800 (PST)
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
 arch/x86/kernel/signal_64.c |   18 +++++++++++++++---
 3 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 5e7771a..e5e4b00 100644
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
index 0157a6f..806b2d6 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -401,16 +401,6 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 	regs->ss = __USER_DS;
 	regs->cs = __USER_CS;
 
-	/*
-	 * Clear TF when entering the signal handler, but
-	 * notify any tracer that was single-stepping it.
-	 * The tracer may want to single-step inside the
-	 * handler too.
-	 */
-	regs->flags &= ~(TF_MASK | X86_EFLAGS_DF);
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
-
 #if DEBUG_SIG
 	printk("SIG deliver (%s:%d): sp=%p pc=%p ra=%p\n",
 		current->comm, current->pid, frame, regs->ip, frame->pretcode);
@@ -494,16 +484,6 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->ss = __USER_DS;
 	regs->cs = __USER_CS;
 
-	/*
-	 * Clear TF when entering the signal handler, but
-	 * notify any tracer that was single-stepping it.
-	 * The tracer may want to single-step inside the
-	 * handler too.
-	 */
-	regs->flags &= ~(TF_MASK | X86_EFLAGS_DF);
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
-
 #if DEBUG_SIG
 	printk("SIG deliver (%s:%d): sp=%p pc=%p ra=%p\n",
 		current->comm, current->pid, frame, regs->ip, frame->pretcode);
@@ -562,6 +542,21 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 		ret = setup_frame(sig, ka, oldset, regs);
 
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
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 1c83e51..6c3f5f1 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -295,9 +295,6 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	   see include/asm-x86_64/uaccess.h for details. */
 	set_fs(USER_DS);
 
-	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
 #ifdef DEBUG_SIG
 	printk("SIG deliver (%s:%d): sp=%p pc=%lx ra=%p\n",
 		current->comm, current->pid, frame, regs->ip, frame->pretcode);
@@ -396,6 +393,21 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
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
