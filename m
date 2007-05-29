Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbXE2Xkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbXE2Xkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 19:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbXE2XkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 19:40:08 -0400
Received: from are.twiddle.net ([64.81.246.98]:40665 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbXE2XkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 19:40:05 -0400
X-Greylist: delayed 2261 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 19:40:04 EDT
Date: Tue, 29 May 2007 16:03:28 -0700
From: Richard Henderson <rth@twiddle.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-kernel@vger.kernel.org
Subject: [alpha] support new syscalls
Message-ID: <20070529230328.GB16535@twiddle.net>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the new syscalls require supporting TIF_RESTORE_SIGMASK.


r~


diff -ruNp /home/rth/work/linux/linux-2.6.22-rc2/arch/alpha/kernel/entry.S linux-2.6.22-rc2/arch/alpha/kernel/entry.S
--- /home/rth/work/linux/linux-2.6.22-rc2/arch/alpha/kernel/entry.S	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22-rc2/arch/alpha/kernel/entry.S	2007-05-25 17:41:50.000000000 -0700
@@ -391,11 +391,10 @@ $work_resched:
 	bne	$2, $work_resched
 
 $work_notifysig:
-	mov	$sp, $17
+	mov	$sp, $16
 	br	$1, do_switch_stack
-	mov	$5, $21
-	mov	$sp, $18
-	mov	$31, $16
+	mov	$sp, $17
+	mov	$5, $18
 	jsr	$26, do_notify_resume
 	bsr	$1, undo_switch_stack
 	br	restore_all
diff -ruNp /home/rth/work/linux/linux-2.6.22-rc2/arch/alpha/kernel/signal.c linux-2.6.22-rc2/arch/alpha/kernel/signal.c
--- /home/rth/work/linux/linux-2.6.22-rc2/arch/alpha/kernel/signal.c	2007-05-28 15:23:20.000000000 -0700
+++ linux-2.6.22-rc2/arch/alpha/kernel/signal.c	2007-05-25 17:59:31.000000000 -0700
@@ -32,8 +32,8 @@
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
 asmlinkage void ret_from_sys_call(void);
-static int do_signal(sigset_t *, struct pt_regs *, struct switch_stack *,
-		     unsigned long, unsigned long);
+static void do_signal(struct pt_regs *, struct switch_stack *,
+		      unsigned long, unsigned long);
 
 
 /*
@@ -146,11 +146,9 @@ sys_rt_sigaction(int sig, const struct s
 asmlinkage int
 do_sigsuspend(old_sigset_t mask, struct pt_regs *regs, struct switch_stack *sw)
 {
-	sigset_t oldset;
-
 	mask &= _BLOCKABLE;
 	spin_lock_irq(&current->sighand->siglock);
-	oldset = current->blocked;
+	current->saved_sigmask = current->blocked;
 	siginitset(&current->blocked, mask);
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
@@ -160,19 +158,17 @@ do_sigsuspend(old_sigset_t mask, struct 
 	regs->r0 = EINTR;
 	regs->r19 = 1;
 
-	while (1) {
-		current->state = TASK_INTERRUPTIBLE;
-		schedule();
-		if (do_signal(&oldset, regs, sw, 0, 0))
-			return -EINTR;
-	}
+	current->state = TASK_INTERRUPTIBLE;
+	schedule();
+	set_thread_flag(TIF_RESTORE_SIGMASK);
+	return -ERESTARTNOHAND;
 }
 
 asmlinkage int
 do_rt_sigsuspend(sigset_t __user *uset, size_t sigsetsize,
 		 struct pt_regs *regs, struct switch_stack *sw)
 {
-	sigset_t oldset, set;
+	sigset_t set;
 
 	/* XXX: Don't preclude handling different sized sigset_t's.  */
 	if (sigsetsize != sizeof(sigset_t))
@@ -182,7 +178,7 @@ do_rt_sigsuspend(sigset_t __user *uset, 
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
 	spin_lock_irq(&current->sighand->siglock);
-	oldset = current->blocked;
+	current->saved_sigmask = current->blocked;
 	current->blocked = set;
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
@@ -192,12 +188,10 @@ do_rt_sigsuspend(sigset_t __user *uset, 
 	regs->r0 = EINTR;
 	regs->r19 = 1;
 
-	while (1) {
-		current->state = TASK_INTERRUPTIBLE;
-		schedule();
-		if (do_signal(&oldset, regs, sw, 0, 0))
-			return -EINTR;
-	}
+	current->state = TASK_INTERRUPTIBLE;
+	schedule();
+	set_thread_flag(TIF_RESTORE_SIGMASK);
+	return -ERESTARTNOHAND;
 }
 
 asmlinkage int
@@ -436,7 +430,7 @@ setup_sigcontext(struct sigcontext __use
 	return err;
 }
 
-static void
+static int
 setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	    struct pt_regs *regs, struct switch_stack * sw)
 {
@@ -481,13 +475,14 @@ setup_frame(int sig, struct k_sigaction 
 		current->comm, current->pid, frame, regs->pc, regs->r26);
 #endif
 
-	return;
+	return 0;
 
 give_sigsegv:
 	force_sigsegv(sig, current);
+	return -EFAULT;
 }
 
-static void
+static int
 setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	       sigset_t *set, struct pt_regs *regs, struct switch_stack * sw)
 {
@@ -543,34 +538,38 @@ setup_rt_frame(int sig, struct k_sigacti
 		current->comm, current->pid, frame, regs->pc, regs->r26);
 #endif
 
-	return;
+	return 0;
 
 give_sigsegv:
 	force_sigsegv(sig, current);
+	return -EFAULT;
 }
 
 
 /*
  * OK, we're invoking a handler.
  */
-static inline void
+static inline int
 handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
 	      sigset_t *oldset, struct pt_regs * regs, struct switch_stack *sw)
 {
+	int ret;
+
 	if (ka->sa.sa_flags & SA_SIGINFO)
-		setup_rt_frame(sig, ka, info, oldset, regs, sw);
+		ret = setup_rt_frame(sig, ka, info, oldset, regs, sw);
 	else
-		setup_frame(sig, ka, oldset, regs, sw);
+		ret = setup_frame(sig, ka, oldset, regs, sw);
 
-	if (ka->sa.sa_flags & SA_RESETHAND)
-		ka->sa.sa_handler = SIG_DFL;
+	if (ret == 0) {
+		spin_lock_irq(&current->sighand->siglock);
+		sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
+		if (!(ka->sa.sa_flags & SA_NODEFER)) 
+			sigaddset(&current->blocked,sig);
+		recalc_sigpending();
+		spin_unlock_irq(&current->sighand->siglock);
+	}
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER)) 
-		sigaddset(&current->blocked,sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	return ret;
 }
 
 static inline void
@@ -611,30 +610,42 @@ syscall_restart(unsigned long r0, unsign
  * restart. "r0" is also used as an indicator whether we can restart at
  * all (if we get here from anything but a syscall return, it will be 0)
  */
-static int
-do_signal(sigset_t *oldset, struct pt_regs * regs, struct switch_stack * sw,
+static void
+do_signal(struct pt_regs * regs, struct switch_stack * sw,
 	  unsigned long r0, unsigned long r19)
 {
 	siginfo_t info;
 	int signr;
 	unsigned long single_stepping = ptrace_cancel_bpt(current);
 	struct k_sigaction ka;
+	sigset_t *oldset;
 
-	if (!oldset)
+	if (test_thread_flag(TIF_RESTORE_SIGMASK))
+		oldset = &current->saved_sigmask;
+	else
 		oldset = &current->blocked;
 
 	/* This lets the debugger run, ... */
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+
 	/* ... so re-check the single stepping. */
 	single_stepping |= ptrace_cancel_bpt(current);
 
 	if (signr > 0) {
 		/* Whee!  Actually deliver the signal.  */
-		if (r0) syscall_restart(r0, r19, regs, &ka);
-		handle_signal(signr, &ka, &info, oldset, regs, sw);
+		if (r0)
+			syscall_restart(r0, r19, regs, &ka);
+		if (handle_signal(signr, &ka, &info, oldset, regs, sw) == 0) {
+			/* A signal was successfully delivered, and the
+			   saved sigmask was stored on the signal frame,
+			   and will be restored by sigreturn.  So we can
+			   simply clear the restore sigmask flag.  */
+			if (test_thread_flag(TIF_RESTORE_SIGMASK))
+				clear_thread_flag(TIF_RESTORE_SIGMASK);
+		}
 		if (single_stepping) 
 			ptrace_set_bpt(current); /* re-set bpt */
-		return 1;
+		return;
 	}
 
 	if (r0) {
@@ -654,17 +665,22 @@ do_signal(sigset_t *oldset, struct pt_re
 			break;
 		}
 	}
+
+	/* If there's no signal to deliver, we just restore the saved mask.  */
+	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
+		clear_thread_flag(TIF_RESTORE_SIGMASK);
+		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+	}
+
 	if (single_stepping)
 		ptrace_set_bpt(current);	/* re-set breakpoint */
-
-	return 0;
 }
 
 void
-do_notify_resume(sigset_t *oldset, struct pt_regs *regs,
-		 struct switch_stack *sw, unsigned long r0,
-		 unsigned long r19, unsigned long thread_info_flags)
+do_notify_resume(struct pt_regs *regs, struct switch_stack *sw,
+		 unsigned long thread_info_flags,
+		 unsigned long r0, unsigned long r19)
 {
-	if (thread_info_flags & _TIF_SIGPENDING)
-		do_signal(oldset, regs, sw, r0, r19);
+	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
+		do_signal(regs, sw, r0, r19);
 }
diff -ruNp /home/rth/work/linux/linux-2.6.22-rc2/arch/alpha/kernel/systbls.S linux-2.6.22-rc2/arch/alpha/kernel/systbls.S
--- /home/rth/work/linux/linux-2.6.22-rc2/arch/alpha/kernel/systbls.S	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22-rc2/arch/alpha/kernel/systbls.S	2007-05-25 16:12:50.000000000 -0700
@@ -465,6 +465,38 @@ sys_call_table:
 	.quad sys_inotify_init
 	.quad sys_inotify_add_watch		/* 445 */
 	.quad sys_inotify_rm_watch
+	.quad sys_fdatasync
+	.quad sys_kexec_load
+	.quad sys_migrate_pages
+	.quad sys_openat			/* 450 */
+	.quad sys_mkdirat
+	.quad sys_mknodat
+	.quad sys_fchownat
+	.quad sys_futimesat
+	.quad sys_fstatat64			/* 455 */
+	.quad sys_unlinkat
+	.quad sys_renameat
+	.quad sys_linkat
+	.quad sys_symlinkat
+	.quad sys_readlinkat			/* 460 */
+	.quad sys_fchmodat
+	.quad sys_faccessat
+	.quad sys_pselect6
+	.quad sys_ppoll
+	.quad sys_unshare			/* 465 */
+	.quad sys_set_robust_list
+	.quad sys_get_robust_list
+	.quad sys_splice
+	.quad sys_sync_file_range
+	.quad sys_tee				/* 470 */
+	.quad sys_vmsplice
+	.quad sys_move_pages
+	.quad sys_getcpu
+	.quad sys_epoll_pwait
+	.quad sys_utimensat			/* 475 */
+	.quad sys_signalfd
+	.quad sys_timerfd
+	.quad sys_eventfd
 
 	.size sys_call_table, . - sys_call_table
 	.type sys_call_table, @object
diff -ruNp /home/rth/work/linux/linux-2.6.22-rc2/include/asm-alpha/thread_info.h linux-2.6.22-rc2/include/asm-alpha/thread_info.h
--- /home/rth/work/linux/linux-2.6.22-rc2/include/asm-alpha/thread_info.h	2007-05-28 15:23:29.000000000 -0700
+++ linux-2.6.22-rc2/include/asm-alpha/thread_info.h	2007-05-25 17:37:43.000000000 -0700
@@ -76,12 +76,14 @@ register struct thread_info *__current_t
 #define TIF_UAC_NOFIX		7
 #define TIF_UAC_SIGBUS		8
 #define TIF_MEMDIE		9
+#define TIF_RESTORE_SIGMASK	10	/* restore signal mask in do_signal */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+#define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 
 /* Work to do on interrupt/exception return.  */
 #define _TIF_WORK_MASK		(_TIF_NOTIFY_RESUME	\
diff -ruNp /home/rth/work/linux/linux-2.6.22-rc2/include/asm-alpha/unistd.h linux-2.6.22-rc2/include/asm-alpha/unistd.h
--- /home/rth/work/linux/linux-2.6.22-rc2/include/asm-alpha/unistd.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22-rc2/include/asm-alpha/unistd.h	2007-05-25 16:09:58.000000000 -0700
@@ -233,6 +233,20 @@
 #define __NR_osf_memcntl	260	/* not implemented */
 #define __NR_osf_fdatasync	261	/* not implemented */
 
+/*
+ * Ignore legacy syscalls that we don't use.
+ */
+#define __IGNORE_alarm
+#define __IGNORE_creat
+#define __IGNORE_getegid
+#define __IGNORE_geteuid
+#define __IGNORE_getgid
+#define __IGNORE_getpid
+#define __IGNORE_getppid
+#define __IGNORE_getuid
+#define __IGNORE_pause
+#define __IGNORE_time
+#define __IGNORE_utime
 
 /*
  * Linux-specific system calls begin at 300
@@ -387,10 +401,42 @@
 #define __NR_inotify_init		444
 #define __NR_inotify_add_watch		445
 #define __NR_inotify_rm_watch		446
+#define __NR_fdatasync			447
+#define __NR_kexec_load			448
+#define __NR_migrate_pages		449
+#define __NR_openat			450
+#define __NR_mkdirat			451
+#define __NR_mknodat			452
+#define __NR_fchownat			453
+#define __NR_futimesat			454
+#define __NR_fstatat64			455
+#define __NR_unlinkat			456
+#define __NR_renameat			457
+#define __NR_linkat			458
+#define __NR_symlinkat			459
+#define __NR_readlinkat			460
+#define __NR_fchmodat			461
+#define __NR_faccessat			462
+#define __NR_pselect6			463
+#define __NR_ppoll			464
+#define __NR_unshare			465
+#define __NR_set_robust_list		466
+#define __NR_get_robust_list		467
+#define __NR_splice			468
+#define __NR_sync_file_range		469
+#define __NR_tee			470
+#define __NR_vmsplice			471
+#define __NR_move_pages			472
+#define __NR_getcpu			473
+#define __NR_epoll_pwait		474
+#define __NR_utimensat			475
+#define __NR_signalfd			476
+#define __NR_timerfd			477
+#define __NR_eventfd			478
 
 #ifdef __KERNEL__
 
-#define NR_SYSCALLS			447
+#define NR_SYSCALLS			479
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
