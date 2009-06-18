Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbZFRR47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbZFRR47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbZFRRz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:55:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62508 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbZFRRzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:55:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 05/11] microblaze: clean up signal handling
Date: Thu, 18 Jun 2009 19:55:29 +0200
Message-Id: <6c53760fdf8b14306c31639c3b5672d2232f6695.1245347640.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1245345894.git.arnd@arndb.de>
References: <cover.1245345894.git.arnd@arndb.de>
In-Reply-To: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
References: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/0oxd007nBsM6YYLqYhoIzsSaxnfHgXmSo6US
 90rRn2Hj/gwDhROn9Vxm4A29mLcz+s6SaUX8j0dHYAWiZYih6b
 //M/ELDwHtbOmiKETiV+g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When legacy signal handling is disabled, the
arch/microblaze/kernel/signal.c implementation can
be much simpler, as most of it is handled generically
from kernel/signal.c.

This is also a prerequisite for using the generic
asm/unistd.h, which does not provide __NR_sigreturn,
because this macro is referenced by the current signal.c
implementation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/microblaze/include/asm/signal.h   |  166 +------------------------------
 arch/microblaze/include/asm/syscalls.h |   11 +--
 arch/microblaze/include/asm/unistd.h   |    2 -
 arch/microblaze/kernel/signal.c        |  172 +++++++-------------------------
 4 files changed, 39 insertions(+), 312 deletions(-)
 rewrite arch/microblaze/include/asm/signal.h (100%)

diff --git a/arch/microblaze/include/asm/signal.h b/arch/microblaze/include/asm/signal.h
dissimilarity index 100%
index 46bc226..7b1573c 100644
--- a/arch/microblaze/include/asm/signal.h
+++ b/arch/microblaze/include/asm/signal.h
@@ -1,165 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *	Yasushi SHOJI <yashi@atmark-techno.com>
- *	Tetsuya OHKAWA <tetsuya@atmark-techno.com>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_SIGNAL_H
-#define _ASM_MICROBLAZE_SIGNAL_H
-
-#define SIGHUP		1
-#define SIGINT		2
-#define SIGQUIT		3
-#define SIGILL		4
-#define SIGTRAP		5
-#define SIGABRT		6
-#define SIGIOT		6
-#define SIGBUS		7
-#define SIGFPE		8
-#define SIGKILL		9
-#define SIGUSR1		10
-#define SIGSEGV		11
-#define SIGUSR2		12
-#define SIGPIPE		13
-#define SIGALRM		14
-#define SIGTERM		15
-#define SIGSTKFLT	16
-#define SIGCHLD		17
-#define SIGCONT		18
-#define SIGSTOP		19
-#define SIGTSTP		20
-#define SIGTTIN		21
-#define SIGTTOU		22
-#define SIGURG		23
-#define SIGXCPU		24
-#define SIGXFSZ		25
-#define SIGVTALRM	26
-#define SIGPROF		27
-#define SIGWINCH	28
-#define SIGIO		29
-#define SIGPOLL		SIGIO
-/*
-#define SIGLOST		29
-*/
-#define SIGPWR		30
-#define SIGSYS		31
-#define	SIGUNUSED	31
-
-/* These should not be considered constants from userland. */
-#define SIGRTMIN	32
-#define SIGRTMAX	_NSIG
-
-/*
- * SA_FLAGS values:
- *
- * SA_ONSTACK indicates that a registered stack_t will be used.
- * SA_RESTART flag to get restarting signals (which were the default long ago)
- * SA_NOCLDSTOP flag to turn off SIGCHLD when children stop.
- * SA_RESETHAND clears the handler when the signal is delivered.
- * SA_NOCLDWAIT flag on SIGCHLD to inhibit zombies.
- * SA_NODEFER prevents the current signal from being masked in the handler.
- *
- * SA_ONESHOT and SA_NOMASK are the historical Linux names for the Single
- * Unix names RESETHAND and NODEFER respectively.
- */
-#define SA_NOCLDSTOP	0x00000001
-#define SA_NOCLDWAIT	0x00000002
-#define SA_SIGINFO	0x00000004
-#define SA_ONSTACK	0x08000000
-#define SA_RESTART	0x10000000
-#define SA_NODEFER	0x40000000
-#define SA_RESETHAND	0x80000000
-
-#define SA_NOMASK	SA_NODEFER
-#define SA_ONESHOT	SA_RESETHAND
-
-#define SA_RESTORER	0x04000000
-
-/*
- * sigaltstack controls
- */
-#define SS_ONSTACK	1
-#define SS_DISABLE	2
-
-#define MINSIGSTKSZ	2048
-#define SIGSTKSZ	8192
-
-# ifndef __ASSEMBLY__
-# include <linux/types.h>
-# include <asm-generic/signal-defs.h>
-
-/* Avoid too many header ordering problems. */
-struct siginfo;
-
-#  ifdef __KERNEL__
-/*
- * Most things should be clean enough to redefine this at will, if care
- * is taken to make libc match.
- */
-#  define _NSIG		64
-#  define _NSIG_BPW	32
-#  define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
-
-typedef unsigned long old_sigset_t; /* at least 32 bits */
-
-typedef struct {
-	unsigned long sig[_NSIG_WORDS];
-} sigset_t;
-
-struct old_sigaction {
-	__sighandler_t sa_handler;
-	old_sigset_t sa_mask;
-	unsigned long sa_flags;
-	void (*sa_restorer)(void);
-};
-
-struct sigaction {
-	__sighandler_t sa_handler;
-	unsigned long sa_flags;
-	void (*sa_restorer)(void);
-	sigset_t sa_mask; /* mask last for extensibility */
-};
-
-struct k_sigaction {
-	struct sigaction sa;
-};
-
-#  include <asm/sigcontext.h>
-#  undef __HAVE_ARCH_SIG_BITOPS
-
-#  define ptrace_signal_deliver(regs, cookie) do { } while (0)
-
-#  else /* !__KERNEL__ */
-
-/* Here we must cater to libcs that poke about in kernel headers. */
-
-#  define NSIG		32
-typedef unsigned long sigset_t;
-
-struct sigaction {
-	union {
-	__sighandler_t _sa_handler;
-	void (*_sa_sigaction)(int, struct siginfo *, void *);
-	} _u;
-	sigset_t sa_mask;
-	unsigned long sa_flags;
-	void (*sa_restorer)(void);
-};
-
-#  define sa_handler	_u._sa_handler
-#  define sa_sigaction	_u._sa_sigaction
-
-#  endif /* __KERNEL__ */
-
-typedef struct sigaltstack {
-	void *ss_sp;
-	int ss_flags;
-	size_t ss_size;
-} stack_t;
-
-# endif /* __ASSEMBLY__ */
-#endif /* _ASM_MICROBLAZE_SIGNAL_H */
+#include <asm-generic/signal.h>
diff --git a/arch/microblaze/include/asm/syscalls.h b/arch/microblaze/include/asm/syscalls.h
index ddea9eb..ea23843 100644
--- a/arch/microblaze/include/asm/syscalls.h
+++ b/arch/microblaze/include/asm/syscalls.h
@@ -26,23 +26,16 @@ asmlinkage unsigned long sys_mmap(unsigned long addr, size_t len,
 			unsigned long fd, off_t offset);
 
 /* from signal.c */
-asmlinkage int sys_sigsuspend(old_sigset_t mask, struct pt_regs *regs);
-
-asmlinkage int sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize,
+asmlinkage long sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize,
 		struct pt_regs *regs);
 
-asmlinkage int sys_sigaction(int sig, const struct old_sigaction *act,
-		struct old_sigaction *oact);
-
 asmlinkage long sys_rt_sigaction(int sig, const struct sigaction __user *act,
 		struct sigaction __user *oact, size_t sigsetsize);
 
 asmlinkage int sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 		struct pt_regs *regs);
 
-asmlinkage int sys_sigreturn(struct pt_regs *regs);
-
-asmlinkage int sys_rt_sigreturn(struct pt_regs *regs);
+asmlinkage long sys_rt_sigreturn(struct pt_regs *regs);
 
 #endif /* __KERNEL__ */
 #endif /* __ASM_MICROBLAZE_SYSCALLS_H */
diff --git a/arch/microblaze/include/asm/unistd.h b/arch/microblaze/include/asm/unistd.h
index dceba3e..6ce1536 100644
--- a/arch/microblaze/include/asm/unistd.h
+++ b/arch/microblaze/include/asm/unistd.h
@@ -10,5 +10,3 @@
 #endif /* __MICROBLAZE_UNISTD_H */
 
 #include <asm-generic/unistd.h>
-
-#undef __ARCH_WANT_SYS_RT_SIGSUSPEND
diff --git a/arch/microblaze/kernel/signal.c b/arch/microblaze/kernel/signal.c
index e663123..2783364 100644
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -45,90 +45,6 @@
 
 asmlinkage int do_signal(struct pt_regs *regs, sigset_t *oldset, int in_sycall);
 
-/*
- * Atomically swap in the new signal mask, and wait for a signal.
- */
-asmlinkage int
-sys_sigsuspend(old_sigset_t mask, struct pt_regs *regs)
-{
-	sigset_t saveset;
-
-	mask &= _BLOCKABLE;
-	spin_lock_irq(&current->sighand->siglock);
-	saveset = current->blocked;
-	siginitset(&current->blocked, mask);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	regs->r3 = -EINTR;
-	while (1) {
-		current->state = TASK_INTERRUPTIBLE;
-		schedule();
-		if (do_signal(regs, &saveset, 1))
-			return -EINTR;
-	}
-}
-
-asmlinkage int
-sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize,
-		struct pt_regs *regs)
-{
-	sigset_t saveset, newset;
-
-	/* XXX: Don't preclude handling different sized sigset_t's. */
-	if (sigsetsize != sizeof(sigset_t))
-		return -EINVAL;
-
-	if (copy_from_user(&newset, unewset, sizeof(newset)))
-		return -EFAULT;
-	sigdelsetmask(&newset, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	saveset = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	regs->r3 = -EINTR;
-	while (1) {
-		current->state = TASK_INTERRUPTIBLE;
-		schedule();
-		if (do_signal(regs, &saveset, 1))
-			return -EINTR;
-	}
-}
-
-asmlinkage int
-sys_sigaction(int sig, const struct old_sigaction *act,
-		struct old_sigaction *oact)
-{
-	struct k_sigaction new_ka, old_ka;
-	int ret;
-
-	if (act) {
-		old_sigset_t mask;
-		if (!access_ok(VERIFY_READ, act, sizeof(*act)) ||
-			__get_user(new_ka.sa.sa_handler, &act->sa_handler) ||
-			__get_user(new_ka.sa.sa_restorer, &act->sa_restorer))
-			return -EFAULT;
-		__get_user(new_ka.sa.sa_flags, &act->sa_flags);
-		__get_user(mask, &act->sa_mask);
-		siginitset(&new_ka.sa.sa_mask, mask);
-	}
-
-	ret = do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
-
-	if (!ret && oact) {
-		if (!access_ok(VERIFY_WRITE, oact, sizeof(*oact)) ||
-			__put_user(old_ka.sa.sa_handler, &oact->sa_handler) ||
-			__put_user(old_ka.sa.sa_restorer, &oact->sa_restorer))
-			return -EFAULT;
-		__put_user(old_ka.sa.sa_flags, &oact->sa_flags);
-		__put_user(old_ka.sa.sa_mask.sig[0], &oact->sa_mask);
-	}
-
-	return ret;
-}
-
 asmlinkage long
 microblaze_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 		struct pt_regs *regs)
@@ -139,13 +55,13 @@ microblaze_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 /*
  * Do a signal return; undo the signal stack.
  */
-
 struct sigframe {
 	struct sigcontext sc;
 	unsigned long extramask[_NSIG_WORDS-1];
 	unsigned long tramp[2];	/* signal trampoline */
 };
 
+
 struct rt_sigframe {
 	struct siginfo info;
 	struct ucontext uc;
@@ -176,39 +92,6 @@ static int restore_sigcontext(struct pt_regs *regs,
 	return err;
 }
 
-asmlinkage int sys_sigreturn(struct pt_regs *regs)
-{
-	struct sigframe *frame =
-			(struct sigframe *)(regs->r1 + STATE_SAVE_ARG_SPACE);
-
-	sigset_t set;
-	int rval;
-
-	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
-		goto badframe;
-
-	if (__get_user(set.sig[0], &frame->sc.oldmask)
-		|| (_NSIG_WORDS > 1
-		&& __copy_from_user(&set.sig[1], &frame->extramask,
-					sizeof(frame->extramask))))
-		goto badframe;
-
-	sigdelsetmask(&set, ~_BLOCKABLE);
-
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	if (restore_sigcontext(regs, &frame->sc, &rval))
-		goto badframe;
-	return rval;
-
-badframe:
-	force_sig(SIGSEGV, current);
-	return 0;
-}
-
 asmlinkage long microblaze_rt_sigreturn(struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame =
@@ -324,21 +207,17 @@ static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	/* Set up to return from userspace. If provided, use a stub
 	 already in userspace. */
 	/* minus 8 is offset to cater for "rtsd r15,8" */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		regs->r15 = ((unsigned long)ka->sa.sa_restorer)-8;
-	} else {
-		/* addi r12, r0, __NR_sigreturn */
-		err |= __put_user(0x31800000 | __NR_rt_sigreturn ,
-				frame->tramp + 0);
-		/* brki r14, 0x8 */
-		err |= __put_user(0xb9cc0008, frame->tramp + 1);
-
-		/* Return from sighandler will jump to the tramp.
-		 Negative 8 offset because return is rtsd r15, 8 */
-		regs->r15 = ((unsigned long)frame->tramp)-8;
-
-		__invalidate_cache_sigtramp((unsigned long)frame->tramp);
-	}
+	/* addi r12, r0, __NR_sigreturn */
+	err |= __put_user(0x31800000 | __NR_rt_sigreturn ,
+			frame->tramp + 0);
+	/* brki r14, 0x8 */
+	err |= __put_user(0xb9cc0008, frame->tramp + 1);
+
+	/* Return from sighandler will jump to the tramp.
+	 Negative 8 offset because return is rtsd r15, 8 */
+	regs->r15 = ((unsigned long)frame->tramp)-8;
+
+	__invalidate_cache_sigtramp((unsigned long)frame->tramp);
 
 	if (err)
 		goto give_sigsegv;
@@ -405,7 +284,7 @@ do_restart:
  * OK, we're invoking a handler
  */
 
-static void
+static int
 handle_signal(unsigned long sig, struct k_sigaction *ka,
 		siginfo_t *info, sigset_t *oldset, struct pt_regs *regs)
 {
@@ -442,6 +321,7 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset, int in_syscall)
 	siginfo_t info;
 	int signr;
 	struct k_sigaction ka;
+
 #ifdef DEBUG_SIG
 	printk(KERN_INFO "do signal: %p %p %d\n", regs, oldset, in_syscall);
 	printk(KERN_INFO "do signal2: %lx %lx %ld [%lx]\n", regs->pc, regs->r1,
@@ -456,7 +336,9 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset, int in_syscall)
 	if (kernel_mode(regs))
 		return 1;
 
-	if (!oldset)
+	if (current_thread_info()->status & TS_RESTORE_SIGMASK)
+		oldset = &current->saved_sigmask;
+	else
 		oldset = &current->blocked;
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
@@ -464,13 +346,31 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset, int in_syscall)
 		/* Whee! Actually deliver the signal. */
 		if (in_syscall)
 			handle_restart(regs, &ka, 1);
-		handle_signal(signr, &ka, &info, oldset, regs);
+		if (handle_signal(signr, &ka, &info, oldset, regs)) {
+			/*
+			 * A signal was successfully delivered; the saved
+			 * sigmask will have been stored in the signal frame,
+			 * and will be restored by sigreturn, so we can simply
+			 * clear the TS_RESTORE_SIGMASK flag.
+			 */
+			current_thread_info()->status &=
+			    ~TS_RESTORE_SIGMASK;
+		}
 		return 1;
 	}
 
 	if (in_syscall)
 		handle_restart(regs, NULL, 0);
 
+	/*
+	 * If there's no signal to deliver, we just put the saved sigmask
+	 * back.
+	 */
+	if (current_thread_info()->status & TS_RESTORE_SIGMASK) {
+		current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
+		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+	}
+
 	/* Did we come from a system call? */
 	return 0;
 }
-- 
1.6.3.1

