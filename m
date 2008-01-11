Return-Path: <linux-kernel-owner+w=401wt.eu-S932208AbYAKS7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbYAKS7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 13:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932131AbYAKS7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 13:59:39 -0500
Received: from krynn.se.axis.com ([193.13.178.10]:34096 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbYAKS7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 13:59:36 -0500
Date: Fri, 11 Jan 2008 19:59:24 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] CRIS v10: Correct do_signal to fix oops and clean up signal handling in general.
Message-ID: <20080111185923.GE27482@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CRIS v10: Correct do_signal to fix oops and clean up signal handling in general.

This fixes a kernel panic on boot due to do_signal not being compatible
with it's callers.

- do_signal now returns void, and does not have the previous signal set
  as a parameter.
- Remove sys_rt_sigsuspend, we can use the common one instead.
- Change sys_sigsuspend to be more like x86, don't call do_signal here.
- handle_signal, setup_frame and setup_rt_frame now return -EFAULT
  if we've delivered a segfault, which is used by callers to perform
  necessary cleanup.
- Break long lines, correct whitespace and formatting errors.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v10/kernel/signal.c |  251 ++++++++++++++++--------------------
 1 files changed, 112 insertions(+), 139 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/signal.c b/arch/cris/arch-v10/kernel/signal.c
index 41d4a5f..b6be705 100644
--- a/arch/cris/arch-v10/kernel/signal.c
+++ b/arch/cris/arch-v10/kernel/signal.c
@@ -7,7 +7,7 @@
  *
  *  Ideas also taken from arch/arm.
  *
- *  Copyright (C) 2000, 2001 Axis Communications AB
+ *  Copyright (C) 2000-2007 Axis Communications AB
  *
  *  Authors:  Bjorn Wesen (bjornw@axis.com)
  *
@@ -40,84 +40,30 @@
  */
 #define RESTART_CRIS_SYS(regs) regs->r10 = regs->orig_r10; regs->irp -= 2;
 
-int do_signal(int canrestart, sigset_t *oldset, struct pt_regs *regs);
+void do_signal(int canrestart, struct pt_regs *regs);
 
 /*
- * Atomically swap in the new signal mask, and wait for a signal.  Define 
+ * Atomically swap in the new signal mask, and wait for a signal.  Define
  * dummy arguments to be able to reach the regs argument.  (Note that this
  * arrangement relies on old_sigset_t occupying one register.)
  */
-int
-sys_sigsuspend(old_sigset_t mask, long r11, long r12, long r13, long mof, 
-               long srp, struct pt_regs *regs)
+int sys_sigsuspend(old_sigset_t mask, long r11, long r12, long r13, long mof,
+	long srp, struct pt_regs *regs)
 {
-	sigset_t saveset;
-
 	mask &= _BLOCKABLE;
 	spin_lock_irq(&current->sighand->siglock);
-	saveset = current->blocked;
+	current->saved_sigmask = current->blocked;
 	siginitset(&current->blocked, mask);
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
-
-	regs->r10 = -EINTR;
-	while (1) {
-		current->state = TASK_INTERRUPTIBLE;
-		schedule();
-		if (do_signal(0, &saveset, regs))
-			/* We will get here twice: once to call the signal
-			   handler, then again to return from the
-			   sigsuspend system call.  When calling the
-			   signal handler, R10 holds the signal number as
-			   set through do_signal.  The sigsuspend call
-			   will return with the restored value set above;
-			   always -EINTR.  */
-			return regs->r10;
-	}
+	current->state = TASK_INTERRUPTIBLE;
+	schedule();
+	set_thread_flag(TIF_RESTORE_SIGMASK);
+	return -ERESTARTNOHAND;
 }
 
-/* Define dummy arguments to be able to reach the regs argument.  (Note that
- * this arrangement relies on size_t occupying one register.)
- */
-int
-sys_rt_sigsuspend(sigset_t *unewset, size_t sigsetsize, long r12, long r13, 
-                  long mof, long srp, struct pt_regs *regs)
-{
-	sigset_t saveset, newset;
-
-	/* XXX: Don't preclude handling different sized sigset_t's.  */
-	if (sigsetsize != sizeof(sigset_t))
-		return -EINVAL;
-
-	if (copy_from_user(&newset, unewset, sizeof(newset)))
-		return -EFAULT;
-	sigdelsetmask(&newset, ~_BLOCKABLE);
-
-	spin_lock_irq(&current->sighand->siglock);
-	saveset = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	regs->r10 = -EINTR;
-	while (1) {
-		current->state = TASK_INTERRUPTIBLE;
-		schedule();
-		if (do_signal(0, &saveset, regs))
-			/* We will get here twice: once to call the signal
-			   handler, then again to return from the
-			   sigsuspend system call.  When calling the
-			   signal handler, R10 holds the signal number as
-			   set through do_signal.  The sigsuspend call
-			   will return with the restored value set above;
-			   always -EINTR.  */
-			return regs->r10;
-	}
-}
-
-int 
-sys_sigaction(int sig, const struct old_sigaction __user *act,
-	      struct old_sigaction *oact)
+int sys_sigaction(int sig, const struct old_sigaction __user *act,
+	struct old_sigaction *oact)
 {
 	struct k_sigaction new_ka, old_ka;
 	int ret;
@@ -147,8 +93,7 @@ sys_sigaction(int sig, const struct old_sigaction __user *act,
 	return ret;
 }
 
-int
-sys_sigaltstack(const stack_t *uss, stack_t __user *uoss)
+int sys_sigaltstack(const stack_t *uss, stack_t __user *uoss)
 {
 	return do_sigaltstack(uss, uoss, rdusp());
 }
@@ -205,7 +150,7 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
 
 	/* TODO: the other ports use regs->orig_XX to disable syscall checks
 	 * after this completes, but we don't use that mechanism. maybe we can
-	 * use it now ? 
+	 * use it now ?
 	 */
 
 	return err;
@@ -216,7 +161,7 @@ badframe:
 
 /* Define dummy arguments to be able to reach the regs argument.  */
 
-asmlinkage int sys_sigreturn(long r10, long r11, long r12, long r13, long mof, 
+asmlinkage int sys_sigreturn(long r10, long r11, long r12, long r13, long mof,
                              long srp, struct pt_regs *regs)
 {
 	struct sigframe __user *frame = (struct sigframe *)rdusp();
@@ -243,7 +188,7 @@ asmlinkage int sys_sigreturn(long r10, long r11, long r12, long r13, long mof,
 	current->blocked = set;
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
-	
+
 	if (restore_sigcontext(regs, &frame->sc))
 		goto badframe;
 
@@ -254,11 +199,11 @@ asmlinkage int sys_sigreturn(long r10, long r11, long r12, long r13, long mof,
 badframe:
 	force_sig(SIGSEGV, current);
 	return 0;
-}	
+}
 
 /* Define dummy arguments to be able to reach the regs argument.  */
 
-asmlinkage int sys_rt_sigreturn(long r10, long r11, long r12, long r13, 
+asmlinkage int sys_rt_sigreturn(long r10, long r11, long r12, long r13,
                                 long mof, long srp, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame = (struct rt_sigframe *)rdusp();
@@ -282,7 +227,7 @@ asmlinkage int sys_rt_sigreturn(long r10, long r11, long r12, long r13,
 	current->blocked = set;
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
-	
+
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
 		goto badframe;
 
@@ -294,14 +239,14 @@ asmlinkage int sys_rt_sigreturn(long r10, long r11, long r12, long r13,
 badframe:
 	force_sig(SIGSEGV, current);
 	return 0;
-}	
+}
 
 /*
  * Set up a signal frame.
  */
 
-static int
-setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs, unsigned long mask)
+static int setup_sigcontext(struct sigcontext __user *sc,
+	struct pt_regs *regs, unsigned long mask)
 {
 	int err = 0;
 	unsigned long usp = rdusp();
@@ -324,10 +269,11 @@ setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs, unsigned lo
 	return err;
 }
 
-/* figure out where we want to put the new signal frame - usually on the stack */
+/* Figure out where we want to put the new signal frame
+ * - usually on the stack. */
 
 static inline void __user *
-get_sigframe(struct k_sigaction *ka, struct pt_regs * regs, size_t frame_size)
+get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
 {
 	unsigned long sp = rdusp();
 
@@ -345,15 +291,15 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs * regs, size_t frame_size)
 }
 
 /* grab and setup a signal frame.
- * 
+ *
  * basically we stack a lot of state info, and arrange for the
  * user-mode program to return to the kernel using either a
  * trampoline which performs the syscall sigreturn, or a provided
  * user-mode trampoline.
  */
 
-static void setup_frame(int sig, struct k_sigaction *ka,
-			sigset_t *set, struct pt_regs * regs)
+static int setup_frame(int sig, struct k_sigaction *ka,
+		       sigset_t *set, struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
 	unsigned long return_ip;
@@ -401,14 +347,15 @@ static void setup_frame(int sig, struct k_sigaction *ka,
 
 	wrusp((unsigned long)frame);
 
-	return;
+	return 0;
 
 give_sigsegv:
 	force_sigsegv(sig, current);
+	return -EFAULT;
 }
 
-static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			   sigset_t *set, struct pt_regs * regs)
+static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+	sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	unsigned long return_ip;
@@ -443,9 +390,10 @@ static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		/* trampoline - the desired return ip is the retcode itself */
 		return_ip = (unsigned long)&frame->retcode;
 		/* This is movu.w __NR_rt_sigreturn, r9; break 13; */
-		err |= __put_user(0x9c5f,            (short __user*)(frame->retcode+0));
-		err |= __put_user(__NR_rt_sigreturn, (short __user*)(frame->retcode+2));
-		err |= __put_user(0xe93d,            (short __user*)(frame->retcode+4));
+		err |= __put_user(0x9c5f, (short __user *)(frame->retcode+0));
+		err |= __put_user(__NR_rt_sigreturn,
+			(short __user *)(frame->retcode+2));
+		err |= __put_user(0xe93d, (short __user *)(frame->retcode+4));
 	}
 
 	if (err)
@@ -455,73 +403,81 @@ static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	/* Set up registers for signal handler */
 
-	regs->irp = (unsigned long) ka->sa.sa_handler;  /* what we enter NOW   */
-	regs->srp = return_ip;                          /* what we enter LATER */
-	regs->r10 = sig;                                /* first argument is signo */
-        regs->r11 = (unsigned long) &frame->info;       /* second argument is (siginfo_t *) */
-        regs->r12 = 0;                                  /* third argument is unused */
-
-	/* actually move the usp to reflect the stacked frame */
-
+	/* What we enter NOW   */
+	regs->irp = (unsigned long) ka->sa.sa_handler;
+	/* What we enter LATER */
+	regs->srp = return_ip;
+	/* First argument is signo */
+	regs->r10 = sig;
+	/* Second argument is (siginfo_t *) */
+	regs->r11 = (unsigned long)&frame->info;
+	/* Third argument is unused */
+	regs->r12 = 0;
+
+	/* Actually move the usp to reflect the stacked frame */
 	wrusp((unsigned long)frame);
 
-	return;
+	return 0;
 
 give_sigsegv:
 	force_sigsegv(sig, current);
+	return -EFAULT;
 }
 
 /*
  * OK, we're invoking a handler
- */	
+ */
 
-static inline void
-handle_signal(int canrestart, unsigned long sig,
-	      siginfo_t *info, struct k_sigaction *ka,
-              sigset_t *oldset, struct pt_regs * regs)
+static inline int handle_signal(int canrestart, unsigned long sig,
+	siginfo_t *info, struct k_sigaction *ka,
+	sigset_t *oldset, struct pt_regs *regs)
 {
+	int ret;
+
 	/* Are we from a system call? */
 	if (canrestart) {
 		/* If so, check system call restarting.. */
 		switch (regs->r10) {
-			case -ERESTART_RESTARTBLOCK:
-			case -ERESTARTNOHAND:
-				/* ERESTARTNOHAND means that the syscall should only be
-				   restarted if there was no handler for the signal, and since
-				   we only get here if there is a handler, we don't restart */
+		case -ERESTART_RESTARTBLOCK:
+		case -ERESTARTNOHAND:
+			/* ERESTARTNOHAND means that the syscall should
+			 * only be restarted if there was no handler for
+			 * the signal, and since we only get here if there
+			 * is a handler, we don't restart */
+			regs->r10 = -EINTR;
+			break;
+		case -ERESTARTSYS:
+			/* ERESTARTSYS means to restart the syscall if
+			 * there is no handler or the handler was
+			 * registered with SA_RESTART */
+			if (!(ka->sa.sa_flags & SA_RESTART)) {
 				regs->r10 = -EINTR;
 				break;
-
-			case -ERESTARTSYS:
-				/* ERESTARTSYS means to restart the syscall if there is no
-				   handler or the handler was registered with SA_RESTART */
-				if (!(ka->sa.sa_flags & SA_RESTART)) {
-					regs->r10 = -EINTR;
-					break;
-				}
-			/* fallthrough */
-			case -ERESTARTNOINTR:
-				/* ERESTARTNOINTR means that the syscall should be called again
-				   after the signal handler returns. */
-				RESTART_CRIS_SYS(regs);
+			}
+		/* fallthrough */
+		case -ERESTARTNOINTR:
+			/* ERESTARTNOINTR means that the syscall should
+			 * be called again after the signal handler returns. */
+			RESTART_CRIS_SYS(regs);
 		}
 	}
 
 	/* Set up the stack frame */
 	if (ka->sa.sa_flags & SA_SIGINFO)
-		setup_rt_frame(sig, ka, info, oldset, regs);
+		ret = setup_rt_frame(sig, ka, info, oldset, regs);
 	else
-		setup_frame(sig, ka, oldset, regs);
-
-	if (ka->sa.sa_flags & SA_ONESHOT)
-		ka->sa.sa_handler = SIG_DFL;
-
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked,sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+		ret = setup_frame(sig, ka, oldset, regs);
+
+	if (ret == 0) {
+		spin_lock_irq(&current->sighand->siglock);
+		sigorsets(&current->blocked, &current->blocked,
+			&ka->sa.sa_mask);
+		if (!(ka->sa.sa_flags & SA_NODEFER))
+			sigaddset(&current->blocked, sig);
+		recalc_sigpending();
+		spin_unlock_irq(&current->sighand->siglock);
+	}
+	return ret;
 }
 
 /*
@@ -536,11 +492,12 @@ handle_signal(int canrestart, unsigned long sig,
  * mode below.
  */
 
-int do_signal(int canrestart, sigset_t *oldset, struct pt_regs *regs)
+void do_signal(int canrestart, struct pt_regs *regs)
 {
 	siginfo_t info;
 	int signr;
         struct k_sigaction ka;
+	sigset_t *oldset;
 
 	/*
 	 * We want the common case to go fast, which
@@ -549,16 +506,26 @@ int do_signal(int canrestart, sigset_t *oldset, struct pt_regs *regs)
 	 * if so.
 	 */
 	if (!user_mode(regs))
-		return 1;
+		return;
 
-	if (!oldset)
+	if (test_thread_flag(TIF_RESTORE_SIGMASK))
+		oldset = &current->saved_sigmask;
+	else
 		oldset = &current->blocked;
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(canrestart, signr, &info, &ka, oldset, regs);
-		return 1;
+		if (handle_signal(canrestart, signr, &info, &ka,
+				oldset, regs)) {
+			/* a signal was successfully delivered; the saved
+			 * sigmask will have been stored in the signal frame,
+			 * and will be restored by sigreturn, so we can simply
+			 * clear the TIF_RESTORE_SIGMASK flag */
+			if (test_thread_flag(TIF_RESTORE_SIGMASK))
+				clear_thread_flag(TIF_RESTORE_SIGMASK);
+		}
+		return;
 	}
 
 	/* Did we come from a system call? */
@@ -569,10 +536,16 @@ int do_signal(int canrestart, sigset_t *oldset, struct pt_regs *regs)
 		    regs->r10 == -ERESTARTNOINTR) {
 			RESTART_CRIS_SYS(regs);
 		}
-		if (regs->r10 == -ERESTART_RESTARTBLOCK){
+		if (regs->r10 == -ERESTART_RESTARTBLOCK) {
 			regs->r10 = __NR_restart_syscall;
 			regs->irp -= 2;
 		}
 	}
-	return 0;
+
+	/* if there's no signal to deliver, we just put the saved sigmask
+	 * back */
+	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
+		clear_thread_flag(TIF_RESTORE_SIGMASK);
+		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+	}
 }
-- 
1.5.3.6.970.gd25430


/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
