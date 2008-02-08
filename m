Return-Path: <linux-kernel-owner+w=401wt.eu-S964982AbYBHUPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964982AbYBHUPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935288AbYBHUNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:13:47 -0500
Received: from hs-out-0708.google.com ([64.233.178.246]:59208 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935392AbYBHUNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:13:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aPZt1uQppRpeYBIWPY8HYVLRLc7vWuLpuUHXAhXrm0CsbqLWc4PuOybEH0yzkMllGbBGKEahKZXPUGJ2q5FwRq09WOHhx1hpuvzxbpYye6NwYyqHY80Mp+dqTOTZ4zAgvMCzBRJzHF6PIPjNalcgKAgFxx6F8b/dxbif8C1muNE=
Subject: [PATCH 4/9] x86: reduce trivial style differences in signal_32|64.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 12:09:58 -0800
Message-Id: <1202501398.12966.23.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small step towards unification.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/signal_32.c |   66 ++++++++++++++++++++----------------------
 arch/x86/kernel/signal_64.c |   47 ++++++++++++++++--------------
 2 files changed, 56 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index a99529e..70d0cc8 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -131,14 +131,8 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, int *peax
 	COPY_SEG(fs);
 	COPY_SEG(es);
 	COPY_SEG(ds);
-	COPY(di);
-	COPY(si);
-	COPY(bp);
-	COPY(sp);
-	COPY(bx);
-	COPY(dx);
-	COPY(cx);
-	COPY(ip);
+	COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
+	COPY(dx); COPY(cx); COPY(ip);
 	COPY_SEG_STRICT(cs);
 	COPY_SEG_STRICT(ss);
 	
@@ -500,12 +494,12 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	 * The tracer may want to single-step inside the
 	 * handler too.
 	 */
-	regs->flags &= ~TF_MASK;
+	regs->flags &= ~X86_EFLAGS_TF;
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 
 #if DEBUG_SIG
-	printk("SIG deliver (%s:%d): sp=%p pc=%p ra=%p\n",
+	printk("SIG deliver (%s:%d): sp=%p pc=%lx ra=%p\n",
 		current->comm, current->pid, frame, regs->ip, frame->pretcode);
 #endif
 
@@ -522,7 +516,7 @@ give_sigsegv:
 
 static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
-	      sigset_t *oldset,	struct pt_regs * regs)
+	      sigset_t *oldset, struct pt_regs *regs)
 {
 	int ret;
 
@@ -530,20 +524,21 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	if ((long)regs->orig_ax >= 0) {
 		/* If so, check system call restarting.. */
 		switch (regs->ax) {
-		        case -ERESTART_RESTARTBLOCK:
-			case -ERESTARTNOHAND:
+		case -ERESTART_RESTARTBLOCK:
+		case -ERESTARTNOHAND:
+			regs->ax = -EINTR;
+			break;
+
+		case -ERESTARTSYS:
+			if (!(ka->sa.sa_flags & SA_RESTART)) {
 				regs->ax = -EINTR;
 				break;
-
-			case -ERESTARTSYS:
-				if (!(ka->sa.sa_flags & SA_RESTART)) {
-					regs->ax = -EINTR;
-					break;
-				}
-			/* fallthrough */
-			case -ERESTARTNOINTR:
-				regs->ax = regs->orig_ax;
-				regs->ip -= 2;
+			}
+		/* fallthrough */
+		case -ERESTARTNOINTR:
+			regs->ax = regs->orig_ax;
+			regs->ip -= 2;
+			break;
 		}
 	}
 
@@ -580,18 +575,17 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
  */
 static void do_signal(struct pt_regs *regs)
 {
+	struct k_sigaction ka;
 	siginfo_t info;
 	int signr;
-	struct k_sigaction ka;
 	sigset_t *oldset;
 
 	/*
-	 * We want the common case to go fast, which
-	 * is why we may in certain cases get here from
-	 * kernel mode. Just return without doing anything
- 	 * if so.  vm86 regs switched out by assembly code
- 	 * before reaching here, so testing against kernel
- 	 * CS suffices.
+	 * We want the common case to go fast, which is why we may in certain
+	 * cases get here from kernel mode. Just return without doing anything
+	 * if so.
+	 * X86_32: vm86 regs switched out by assembly code before reaching
+	 * here, so testing against kernel CS suffices.
 	 */
 	if (!user_mode(regs))
 		return;
@@ -608,7 +602,7 @@ static void do_signal(struct pt_regs *regs)
 		 * have been cleared if the watchpoint triggered
 		 * inside the kernel.
 		 */
-		if (unlikely(current->thread.debugreg7))
+		if (current->thread.debugreg7)
 			set_debugreg(current->thread.debugreg7, 7);
 
 		/* Whee!  Actually deliver the signal.  */
@@ -642,8 +636,10 @@ static void do_signal(struct pt_regs *regs)
 		}
 	}
 
-	/* if there's no signal to deliver, we just put the saved sigmask
-	 * back */
+	/*
+	 * If there's no signal to deliver, we just put the saved sigmask
+	 * back.
+	 */
 	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
 		clear_thread_flag(TIF_RESTORE_SIGMASK);
 		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
@@ -654,12 +650,12 @@ static void do_signal(struct pt_regs *regs)
  * notification of userspace execution resumption
  * - triggered by the TIF_WORK_MASK flags
  */
-void do_notify_resume(struct pt_regs *regs, void *_unused,
+void do_notify_resume(struct pt_regs *regs, void *unused,
 		      __u32 thread_info_flags)
 {
 	/* Pending single-step? */
 	if (thread_info_flags & _TIF_SINGLESTEP) {
-		regs->flags |= TF_MASK;
+		regs->flags |= X86_EFLAGS_TF;
 		clear_thread_flag(TIF_SINGLESTEP);
 	}
 
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 7347bb1..a1e56dc 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -316,7 +316,7 @@ give_sigsegv:
 
 static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
-		sigset_t *oldset, struct pt_regs *regs)
+	      sigset_t *oldset, struct pt_regs *regs)
 {
 	int ret;
 
@@ -330,21 +330,21 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	if ((long)regs->orig_ax >= 0) {
 		/* If so, check system call restarting.. */
 		switch (regs->ax) {
-		        case -ERESTART_RESTARTBLOCK:
-			case -ERESTARTNOHAND:
-				regs->ax = -EINTR;
-				break;
+		case -ERESTART_RESTARTBLOCK:
+		case -ERESTARTNOHAND:
+			regs->ax = -EINTR;
+			break;
 
-			case -ERESTARTSYS:
-				if (!(ka->sa.sa_flags & SA_RESTART)) {
-					regs->ax = -EINTR;
-					break;
-				}
-				/* fallthrough */
-			case -ERESTARTNOINTR:
-				regs->ax = regs->orig_ax;
-				regs->ip -= 2;
+		case -ERESTARTSYS:
+			if (!(ka->sa.sa_flags & SA_RESTART)) {
+				regs->ax = -EINTR;
 				break;
+			}
+		/* fallthrough */
+		case -ERESTARTNOINTR:
+			regs->ax = regs->orig_ax;
+			regs->ip -= 2;
+			break;
 		}
 	}
 
@@ -391,10 +391,11 @@ static void do_signal(struct pt_regs *regs)
 	sigset_t *oldset;
 
 	/*
-	 * We want the common case to go fast, which
-	 * is why we may in certain cases get here from
-	 * kernel mode. Just return without doing anything
+	 * We want the common case to go fast, which is why we may in certain
+	 * cases get here from kernel mode. Just return without doing anything
 	 * if so.
+	 * X86_32: vm86 regs switched out by assembly code before reaching
+	 * here, so testing against kernel CS suffices.
 	 */
 	if (!user_mode(regs))
 		return;
@@ -445,16 +446,18 @@ static void do_signal(struct pt_regs *regs)
 		}
 	}
 
-	/* if there's no signal to deliver, we just put the saved sigmask
-	   back. */
+	/*
+	 * If there's no signal to deliver, we just put the saved sigmask
+	 * back.
+	 */
 	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
 		clear_thread_flag(TIF_RESTORE_SIGMASK);
 		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
 	}
 }
 
-void
-do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
+void do_notify_resume(struct pt_regs *regs, void *unused,
+		      __u32 thread_info_flags)
 {
 #ifdef DEBUG_SIG
 	printk("do_notify_resume flags:%x ip:%lx sp:%lx caller:%p pending:%x\n",
@@ -474,7 +477,7 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 #endif /* CONFIG_X86_MCE */
 
 	/* deal with pending signal delivery */
-	if (thread_info_flags & (_TIF_SIGPENDING|_TIF_RESTORE_SIGMASK))
+	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
 		do_signal(regs);
 
 	if (thread_info_flags & _TIF_HRTICK_RESCHED)
-- 
1.5.4.1219.g65b9


