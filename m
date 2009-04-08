Return-Path: <linux-kernel-owner+w=401wt.eu-S1763446AbZDHHb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763446AbZDHHb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763396AbZDHHb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:31:29 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:38388 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763422AbZDHHbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:31:25 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Kyle McMartin <kyle@mcmartin.ca>
MIME-Version: 1.0
Subject: [PATCH 10/14] score - New architecure port to SunplusCT S+CORE
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF2105AD3B.51B1C200-ON48257592.0029010D-48257592.0029439F@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Wed, 8 Apr 2009 15:28:34 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/04/08 ?? 03:28:35,
	Serialize complete at 2009/04/08 ?? 03:28:35
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Liqin <liqin.chen@sunplusct.com>

kernel/signal.c, kernel/syscalls.S, kernel/sys-score.c,
kernel/time.c for the score architecture.

Signed off by: Chen Liqin <liqin.chen@sunplusct.com>
Signed off by: Lennox Wu <lennox.wu@sunplusct.com>
--

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/signal.c 
linux-2.6-git.new/arch/score/kernel/signal.c
--- linux-2.6-git.ori/arch/score/kernel/signal.c        1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/signal.c        2009-04-07 
21:47:02.000000000 +0800
@@ -0,0 +1,380 @@
+/*
+ * arch/score/kernel/signal.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/signal.h>
+#include <linux/errno.h>
+#include <linux/ptrace.h>
+#include <linux/unistd.h>
+#include <linux/uaccess.h>
+#include <asm/cacheflush.h>
+#include <asm/ucontext.h>
+
+#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
+
+struct rt_sigframe {
+       u32 rs_ass[4];          /* argument save space */
+       u32 rs_code[2];         /* signal trampoline */
+       struct siginfo rs_info;
+       struct ucontext rs_uc;
+};
+
+int setup_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
+{
+       int err = 0;
+       unsigned long reg;
+
+       reg = regs->cp0_epc; err |= __put_user(reg, &sc->sc_pc);
+       err |= __put_user(regs->cp0_psr, &sc->sc_psr);
+       err |= __put_user(regs->cp0_condition, &sc->sc_condition);
+
+
+#define save_gp_reg(i) {                               \
+       reg = regs->regs[i];                            \
+       err |= __put_user(reg, &sc->sc_regs[i]);        \
+} while (0)
+       save_gp_reg(0); save_gp_reg(1); save_gp_reg(2);
+       save_gp_reg(3); save_gp_reg(4); save_gp_reg(5); save_gp_reg(6);
+       save_gp_reg(7); save_gp_reg(8); save_gp_reg(9); save_gp_reg(10);
+       save_gp_reg(11); save_gp_reg(12); save_gp_reg(13); 
save_gp_reg(14);
+       save_gp_reg(15); save_gp_reg(16); save_gp_reg(17); 
save_gp_reg(18);
+       save_gp_reg(19); save_gp_reg(20); save_gp_reg(21); 
save_gp_reg(22);
+       save_gp_reg(23); save_gp_reg(24); save_gp_reg(25); 
save_gp_reg(26);
+       save_gp_reg(27); save_gp_reg(28); save_gp_reg(29);
+#undef save_gp_reg
+
+       reg = regs->ceh; err |= __put_user(reg, &sc->sc_mdceh);
+       reg = regs->cel; err |= __put_user(reg, &sc->sc_mdcel);
+       err |= __put_user(regs->cp0_ecr, &sc->sc_ecr);
+       err |= __put_user(regs->cp0_ema, &sc->sc_ema);
+
+       return err;
+}
+
+int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user 
*sc)
+{
+       int err = 0;
+       u32 reg;
+
+       err |= __get_user(regs->cp0_epc, &sc->sc_pc);
+       err |= __get_user(regs->cp0_condition, &sc->sc_condition);
+
+       err |= __get_user(reg, &sc->sc_mdceh);
+       regs->ceh = (int) reg;
+       err |= __get_user(reg, &sc->sc_mdcel);
+       regs->cel = (int) reg;
+
+       err |= __get_user(reg, &sc->sc_psr);
+       regs->cp0_psr = (int) reg;
+       err |= __get_user(reg, &sc->sc_ecr);
+       regs->cp0_ecr = (int) reg;
+       err |= __get_user(reg, &sc->sc_ema);
+       regs->cp0_ema = (int) reg;
+
+#define restore_gp_reg(i) do {                         \
+       err |= __get_user(reg, &sc->sc_regs[i]);        \
+       regs->regs[i] = reg;                            \
+} while (0)
+       restore_gp_reg(0); restore_gp_reg(1); restore_gp_reg(2); 
restore_gp_reg(3);
+       restore_gp_reg(4); restore_gp_reg(5); restore_gp_reg(6); 
restore_gp_reg(7);
+       restore_gp_reg(8); restore_gp_reg(9); restore_gp_reg(10); 
restore_gp_reg(11);
+       restore_gp_reg(12); restore_gp_reg(13); restore_gp_reg(14); 
restore_gp_reg(15);
+       restore_gp_reg(16); restore_gp_reg(17); restore_gp_reg(18); 
restore_gp_reg(19);
+       restore_gp_reg(20); restore_gp_reg(21); restore_gp_reg(22); 
restore_gp_reg(23);
+       restore_gp_reg(24); restore_gp_reg(25); restore_gp_reg(26); 
restore_gp_reg(27);
+       restore_gp_reg(28); restore_gp_reg(29);
+#undef restore_gp_reg
+
+       return err;
+}
+
+/*
+ * Determine which stack to use..
+ */
+void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
+                         size_t frame_size)
+{
+       unsigned long sp;
+
+       /* Default to using normal stack */
+       sp = regs->regs[0];
+       sp -= 32;
+
+       /* This is the X/Open sanctioned signal stack switching.  */
+       if ((ka->sa.sa_flags & SA_ONSTACK) && (!on_sig_stack(sp)))
+               sp = current->sas_ss_sp + current->sas_ss_size;
+
+       return (void *)((sp - frame_size) & ~7);
+}
+
+asmlinkage int sys_rt_sigsuspend(struct pt_regs *regs)
+{
+       sigset_t newset;
+       sigset_t __user *unewset;
+       size_t sigsetsize;
+
+       sigsetsize = regs->regs[5];
+       if (sigsetsize != sizeof(sigset_t))
+               return -EINVAL;
+
+       unewset = (sigset_t __user *) regs->regs[4];
+       if (copy_from_user(&newset, unewset, sizeof(newset)))
+               return -EFAULT;
+
+       sigdelsetmask(&newset, ~_BLOCKABLE);
+
+       spin_lock_irq(&current->sighand->siglock);
+       current->saved_sigmask = current->blocked;
+       current->blocked = newset;
+       recalc_sigpending();
+       spin_unlock_irq(&current->sighand->siglock);
+
+       current->state = TASK_INTERRUPTIBLE;
+       schedule();
+       set_thread_flag(TIF_RESTORE_SIGMASK);
+       return -ERESTARTNOHAND;
+}
+
+asmlinkage int sys_sigaltstack(struct pt_regs *regs)
+{
+       const stack_t *uss = (const stack_t *) regs->regs[4];
+       stack_t *uoss = (stack_t *) regs->regs[5];
+       unsigned long usp = regs->regs[0];
+
+       return do_sigaltstack(uss, uoss, usp);
+}
+
+asmlinkage void sys_rt_sigreturn(struct pt_regs *regs)
+{
+       struct rt_sigframe __user *frame;
+       sigset_t set;
+       stack_t st;
+       int sig;
+
+       frame = (struct rt_sigframe __user *) regs->regs[0];
+       if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+               goto badframe;
+       if (__copy_from_user(&set, &frame->rs_uc.uc_sigmask, sizeof(set)))
+               goto badframe;
+
+       sigdelsetmask(&set, ~_BLOCKABLE);
+       spin_lock_irq(&current->sighand->siglock);
+       current->blocked = set;
+       recalc_sigpending();
+       spin_unlock_irq(&current->sighand->siglock);
+
+       sig = restore_sigcontext(regs, &frame->rs_uc.uc_mcontext);
+       if (sig < 0)
+               goto badframe;
+       else if (sig)
+               force_sig(sig, current);
+
+       if (__copy_from_user(&st, &frame->rs_uc.uc_stack, sizeof(st)))
+               goto badframe;
+
+       /* It is more difficult to avoid calling this function than to
+          call it and ignore errors.  */
+       do_sigaltstack((stack_t __user *)&st, NULL, regs->regs[0]);
+
+       __asm__ __volatile__(
+               "mv\tr0, %0\n\t"
+               "la\tr8, syscall_exit\n\t"
+               "br\tr8\n\t"
+               : : "r" (regs) : "r8");
+
+badframe:
+       force_sig(SIGSEGV, current);
+}
+
+int setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
+       int signr, sigset_t *set, siginfo_t *info)
+{
+       struct rt_sigframe *frame;
+       int err = 0;
+
+       frame = get_sigframe(ka, regs, sizeof(*frame));
+       if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+               goto give_sigsegv;
+
+       /*
+        * Set up the return code ...
+        *
+        *         li      v0, __NR_rt_sigreturn
+        *         syscall
+        */
+       err |= __put_user(0x87788000 + __NR_rt_sigreturn*2, frame->rs_code 
+ 0);
+       err |= __put_user(0x80008002, frame->rs_code + 1);
+       flush_cache_sigtramp((unsigned long) frame->rs_code);
+
+       err |= copy_siginfo_to_user(&frame->rs_info, info);
+       err |= __put_user(0, &frame->rs_uc.uc_flags);
+       err |= __put_user(0, &frame->rs_uc.uc_link);
+       err |= __put_user((void *)current->sas_ss_sp,
+                               &frame->rs_uc.uc_stack.ss_sp);
+       err |= __put_user(sas_ss_flags(regs->regs[0]),
+                               &frame->rs_uc.uc_stack.ss_flags);
+       err |= __put_user(current->sas_ss_size,
+                               &frame->rs_uc.uc_stack.ss_size);
+       err |= setup_sigcontext(regs, &frame->rs_uc.uc_mcontext);
+       err |= __copy_to_user(&frame->rs_uc.uc_sigmask, set, 
sizeof(*set));
+
+       if (err)
+               goto give_sigsegv;
+
+       regs->regs[0] = (unsigned long) frame;
+       regs->regs[3] = (unsigned long) frame->rs_code;
+       regs->regs[4] = signr;
+       regs->regs[5] = (unsigned long) &frame->rs_info;
+       regs->regs[6] = (unsigned long) &frame->rs_uc;
+       regs->regs[29] = (unsigned long) ka->sa.sa_handler;
+       regs->cp0_epc = (unsigned long) ka->sa.sa_handler;
+
+       return 0;
+
+give_sigsegv:
+       if (signr == SIGSEGV)
+               ka->sa.sa_handler = SIG_DFL;
+       force_sig(SIGSEGV, current);
+       return -EFAULT;
+}
+
+int handle_signal(unsigned long sig, siginfo_t *info,
+       struct k_sigaction *ka, sigset_t *oldset, struct pt_regs *regs)
+{
+       int ret;
+
+       if (regs->is_syscall) {
+               switch (regs->regs[4]) {
+               case ERESTART_RESTARTBLOCK:
+               case ERESTARTNOHAND:
+                       regs->regs[4] = EINTR;
+                       break;
+               case ERESTARTSYS:
+                       if (!(ka->sa.sa_flags & SA_RESTART)) {
+                               regs->regs[4] = EINTR;
+                               break;
+                       }
+               case ERESTARTNOINTR:
+                       regs->regs[4] = regs->orig_r4;
+                       regs->regs[7] = regs->orig_r7;
+                       regs->cp0_epc -= 8;
+               }
+
+               regs->is_syscall = 0;
+       }
+
+       /*
+        * Set up the stack frame
+        */
+       ret = setup_rt_frame(ka, regs, sig, oldset, info);
+
+       spin_lock_irq(&current->sighand->siglock);
+       sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
+       if (!(ka->sa.sa_flags & SA_NODEFER))
+               sigaddset(&current->blocked, sig);
+       recalc_sigpending();
+       spin_unlock_irq(&current->sighand->siglock);
+
+       return ret;
+}
+
+asmlinkage void do_signal(struct pt_regs *regs)
+{
+       struct k_sigaction ka;
+       sigset_t *oldset;
+       siginfo_t info;
+       int signr;
+
+       /*
+        * We want the common case to go fast, which is why we may in 
certain
+        * cases get here from kernel mode. Just return without doing 
anything
+        * if so.
+        */
+       if (!user_mode(regs))
+               return;
+
+       if (test_thread_flag(TIF_RESTORE_SIGMASK))
+               oldset = &current->saved_sigmask;
+       else
+               oldset = &current->blocked;
+
+       signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+       if (signr > 0) {
+               /* Actually deliver the signal.  */
+               if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
+                       /*
+                        * A signal was successfully delivered; the saved
+                        * sigmask will have been stored in the signal 
frame,
+                        * and will be restored by sigreturn, so we can 
simply
+                        * clear the TIF_RESTORE_SIGMASK flag.
+                        */
+                       if (test_thread_flag(TIF_RESTORE_SIGMASK))
+                               clear_thread_flag(TIF_RESTORE_SIGMASK);
+               }
+
+               return;
+       }
+
+       if (regs->is_syscall) {
+               if (regs->regs[4] == ERESTARTNOHAND ||
+                   regs->regs[4] == ERESTARTSYS ||
+                   regs->regs[4] == ERESTARTNOINTR) {
+                       regs->regs[4] = regs->orig_r4;
+                       regs->regs[7] = regs->orig_r7;
+                       regs->cp0_epc -= 8;
+               }
+
+               if (regs->regs[4] == ERESTART_RESTARTBLOCK) {
+                       regs->regs[27] = __NR_restart_syscall;
+                       regs->regs[4] = regs->orig_r4;
+                       regs->regs[7] = regs->orig_r7;
+                       regs->cp0_epc -= 8;
+               }
+
+               regs->is_syscall = 0;   /* Don't deal with this again.  */
+       }
+
+       /*
+        * If there's no signal to deliver, we just put the saved sigmask
+        * back
+        */
+       if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
+               clear_thread_flag(TIF_RESTORE_SIGMASK);
+               sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+       }
+}
+
+/*
+ * notification of userspace execution resumption
+ * - triggered by the TIF_WORK_MASK flags
+ */
+asmlinkage void do_notify_resume(struct pt_regs *regs, void *unused,
+                               __u32 thread_info_flags)
+{
+       /* deal with pending signal delivery */
+       if (thread_info_flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
+               do_signal(regs);
+}
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/syscalls.S 
linux-2.6-git.new/arch/score/kernel/syscalls.S
--- linux-2.6-git.ori/arch/score/kernel/syscalls.S      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/syscalls.S      2009-04-02 
15:09:33.000000000 +0800
@@ -0,0 +1,372 @@
+/*
+ * arch/score/kernel/syscalls.S
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+       .macro  syscalltable
+       sys     sys_restart_syscall     0       /* 0 */
+       sys     sys_exit                1
+       sys     sys_fork_wrapper        0
+       sys     sys_read                3
+       sys     sys_write               3
+       sys     sys_open                3       /* 5 */
+       sys     sys_close               1
+       sys     sys_waitpid             3
+       sys     sys_creat               2
+       sys     sys_link                2
+       sys     sys_unlink              1       /* 10 */
+       sys     sys_execve_wrapper      0
+       sys     sys_chdir               1
+       sys     sys_time                1
+       sys     sys_mknod               3
+       sys     sys_chmod               2       /* 15 */
+       sys     sys_lchown              3
+       sys     sys_ni_syscall          0
+       sys     sys_ni_syscall          0       /* old stat */
+       sys     sys_lseek               3
+       sys     sys_getpid              0       /* 20 */
+       sys     sys_mount               5
+       sys     sys_ni_syscall          0       /* old umount */
+       sys     sys_setuid              1
+       sys     sys_getuid              0
+       sys     sys_stime               1       /* 25 */
+       sys     sys_ptrace              4
+       sys     sys_alarm               1
+       sys     sys_ni_syscall          0       /* old fstat */
+       sys     sys_pause               0
+       sys     sys_ni_syscall          0       /* 30 old utime */
+       sys     sys_ni_syscall          0       /* old stty */
+       sys     sys_ni_syscall          0       /* old gtty */
+       sys     sys_access              2
+       sys     sys_nice                1
+       sys     sys_ni_syscall          0       /* 35 old ftime */
+       sys     sys_sync                0
+       sys     sys_kill                2
+       sys     sys_rename              2
+       sys     sys_mkdir               2
+       sys     sys_rmdir               1       /* 40 */
+       sys     sys_dup                 1
+       sys     sys_pipe                0
+       sys     sys_times               1
+       sys     sys_ni_syscall          0       /* old prof */
+       sys     sys_brk                 1       /* 45 */
+       sys     sys_setgid              1
+       sys     sys_getgid              0
+       sys     sys_ni_syscall          0       /* old signal */
+       sys     sys_geteuid             0
+       sys     sys_getegid             0       /* 50 */
+       sys     sys_acct                1
+       sys     sys_umount              2
+       sys     sys_ni_syscall          0       /* old lock */
+       sys     sys_ioctl               3
+       sys     sys_fcntl               3       /* 55 */
+       sys     sys_ni_syscall          2
+       sys     sys_setpgid             2
+       sys     sys_ni_syscall          0       /* old ulimit */
+       sys     sys_ni_syscall          0       /* old uname */
+       sys     sys_umask               1       /* 60 */
+       sys     sys_chroot              1
+       sys     sys_ustat               2
+       sys     sys_dup2                2
+       sys     sys_getppid             0
+       sys     sys_getpgrp             0       /* 65 */
+       sys     sys_setsid              0
+       sys     sys_ni_syscall          0       /* old sigaction */
+       sys     sys_sgetmask            0
+       sys     sys_ssetmask            1
+       sys     sys_setreuid            2       /* 70 */
+       sys     sys_setregid            2
+       sys     sys_ni_syscall          0       /* old sigsuspend */
+       sys     sys_ni_syscall          0       /* old sigpending */
+       sys     sys_sethostname         2
+       sys     sys_setrlimit           2       /* 75 */
+       sys     sys_ni_syscall          0       /* old getrlimit */
+       sys     sys_getrusage           2
+       sys     sys_gettimeofday        2
+       sys     sys_settimeofday        2
+       sys     sys_getgroups           2       /* 80 */
+       sys     sys_setgroups           2
+       sys     sys_ni_syscall          0       /* old_select */
+       sys     sys_symlink             2
+       sys     sys_ni_syscall          0       /* old lstat */
+       sys     sys_readlink            3       /* 85 */
+       sys     sys_uselib              1
+       sys     sys_ni_syscall          0       /* sys_swapon */
+       sys     sys_reboot              3
+       sys     sys_ni_syscall          0       /* old_readdir */
+       sys     sys_ni_syscall          0       /* 90 sys_mmap */
+       sys     sys_munmap              2
+       sys     sys_truncate            2
+       sys     sys_ftruncate           2
+       sys     sys_fchmod              2
+       sys     sys_fchown              3       /* 95 */
+       sys     sys_getpriority         2
+       sys     sys_setpriority         3
+       sys     sys_ni_syscall          0       /* old profil */
+       sys     sys_statfs              2
+       sys     sys_fstatfs             2       /* 100 */
+       sys     sys_ni_syscall          0       /* old ioperm */
+       sys     sys_ni_syscall          0       /* old socketcall */
+       sys     sys_syslog              3
+       sys     sys_setitimer           3
+       sys     sys_getitimer           2       /* 105 */
+       sys     sys_newstat             2
+       sys     sys_newlstat            2
+       sys     sys_newfstat            2
+       sys     sys_ni_syscall          0       /* old uname */
+       sys     sys_ni_syscall          0       /* 110 */
+       sys     sys_vhangup             0
+       sys     sys_ni_syscall          0       /* old idle */
+       sys     sys_ni_syscall          0       /* old vm86 */
+       sys     sys_wait4               4
+       sys     sys_ni_syscall          0       /* 115 swapoff */
+       sys     sys_sysinfo             1
+       sys     sys_ni_syscall          0       /* old ipc */
+       sys     sys_fsync               1
+       sys     sys_ni_syscall          0       /* old sigreturn */
+       sys     sys_clone_wrapper       0       /* 120 */
+       sys     sys_setdomainname       2
+       sys     sys_newuname            1
+       sys     sys_ni_syscall          0       /* old modify_ldt */
+       sys     sys_adjtimex            1
+       sys     sys_ni_syscall          0       /* 125 old mprotect */
+       sys     sys_ni_syscall          0       /* old sigprocmask */
+       sys     sys_ni_syscall          0       /* old create_module */
+       sys     sys_init_module         5
+       sys     sys_delete_module       1
+       sys     sys_ni_syscall          0       /* 130 old get_kernel_syms 
*/
+       sys     sys_quotactl            4
+       sys     sys_getpgid             1
+       sys     sys_fchdir              1
+       sys     sys_bdflush             2
+       sys     sys_ni_syscall          0       /* 135 old sysfs */
+       sys     sys_personality         1
+       sys     sys_ni_syscall          0       /* for afs_syscall */
+       sys     sys_setfsuid            1
+       sys     sys_setfsgid            1
+       sys     sys_llseek              5       /* 140 */
+       sys     sys_getdents            3
+       sys     sys_ni_syscall          0       /* old select */
+       sys     sys_flock               2
+       sys     sys_ni_syscall          0       /* old msync */
+       sys     sys_readv               3       /* 145 */
+       sys     sys_writev              3
+       sys     sys_ni_syscall          0
+       sys     sys_ni_syscall          0
+       sys     sys_ni_syscall          0
+       sys     sys_ni_syscall          0       /* 150 */
+       sys     sys_getsid              1
+       sys     sys_fdatasync           1
+       sys     sys_sysctl              1
+       sys     sys_ni_syscall          0       /* old mlock */
+       sys     sys_ni_syscall          0       /* 155 old munlock */
+       sys     sys_ni_syscall          0       /* old mlockall */
+       sys     sys_ni_syscall          0       /* old munlockall */
+       sys     sys_sched_setparam      2
+       sys     sys_sched_getparam      2
+       sys     sys_sched_setscheduler  3       /* 160 */
+       sys     sys_sched_getscheduler  1
+       sys     sys_sched_yield         0
+       sys     sys_sched_get_priority_max 1
+       sys     sys_sched_get_priority_min 1
+       sys     sys_sched_rr_get_interval 2     /* 165 */
+       sys     sys_nanosleep,          2
+       sys     sys_mremap,             5
+       sys     sys_accept              3
+       sys     sys_bind                3
+       sys     sys_connect             3       /* 170 */
+       sys     sys_getpeername         3
+       sys     sys_getsockname         3
+       sys     sys_getsockopt          5
+       sys     sys_listen              2
+       sys     sys_recv                4       /* 175 */
+       sys     sys_recvfrom            6
+       sys     sys_recvmsg             3
+       sys     sys_send                4
+       sys     sys_sendmsg             3
+       sys     sys_sendto              6       /* 180 */
+       sys     sys_setsockopt          5
+       sys     sys_shutdown            2
+       sys     sys_socket              3
+       sys     sys_socketpair          4
+       sys     sys_setresuid           3       /* 185 */
+       sys     sys_getresuid           3
+       sys     sys_ni_syscall          0       /* old query_module */
+       sys     sys_ni_syscall          0       /* old poll */
+       sys     sys_nfsservctl          3
+       sys     sys_setresgid           3       /* 190 */
+       sys     sys_getresgid           3
+       sys     sys_prctl               5
+       sys     sys_rt_sigreturn_wrapper        0
+       sys     sys_rt_sigaction        4
+       sys     sys_rt_sigprocmask      4       /* 195 */
+       sys     sys_rt_sigpending       2
+       sys     sys_rt_sigtimedwait     4
+       sys     sys_rt_sigqueueinfo     3
+       sys     sys_rt_sigsuspend_wrapper       0
+       sys     sys_pread64_wrapper     6       /* 200 */
+       sys     sys_pwrite64_wrapper    6
+       sys     sys_chown               3
+       sys     sys_getcwd              2
+       sys     sys_capget              2
+       sys     sys_capset              2       /* 205 */
+       sys     sys_sigaltstack_wrapper 0
+       sys     sys_sendfile            4
+       sys     sys_ni_syscall          0
+       sys     sys_ni_syscall          0
+       sys     sys_mmap2               6       /* 210 */
+       sys     sys_truncate64          4
+       sys     sys_ftruncate64         4
+       sys     sys_stat64              2
+       sys     sys_lstat64             2
+       sys     sys_fstat64             2       /* 215 */
+       sys     sys_pivot_root          2
+       sys     sys_ni_syscall          0       /* old mincore */
+       sys     sys_ni_syscall          0       /* old madvise */
+       sys     sys_getdents64          3
+       sys     sys_fcntl64             3       /* 220 */
+       sys     sys_ni_syscall          0
+       sys     sys_gettid              0
+       sys     sys_readahead           5
+       sys     sys_setxattr            5
+       sys     sys_lsetxattr           5       /* 225 */
+       sys     sys_fsetxattr           5
+       sys     sys_getxattr            4
+       sys     sys_lgetxattr           4
+       sys     sys_fgetxattr           4
+       sys     sys_listxattr           3       /* 230 */
+       sys     sys_llistxattr          3
+       sys     sys_flistxattr          3
+       sys     sys_removexattr         2
+       sys     sys_lremovexattr        2
+       sys     sys_fremovexattr        2       /* 235 */
+       sys     sys_tkill               2
+       sys     sys_sendfile64          5
+       sys     sys_futex               6
+       sys     sys_sched_setaffinity   3
+       sys     sys_sched_getaffinity   3       /* 240 */
+       sys     sys_io_setup            2
+       sys     sys_io_destroy          1
+       sys     sys_io_getevents        5
+       sys     sys_io_submit           3
+       sys     sys_io_cancel           3       /* 245 */
+       sys     sys_exit_group          1
+       sys     sys_lookup_dcookie      4
+       sys     sys_epoll_create        1
+       sys     sys_epoll_ctl           4
+       sys     sys_epoll_wait          3       /* 250 */
+       sys     sys_ni_syscall          0       /* old remap_file_pages */
+       sys     sys_set_tid_address     1
+       sys     sys_ni_syscall          0
+       sys     sys_fadvise64_64_wrapper        6
+       sys     sys_statfs64            3       /* 255 */
+       sys     sys_fstatfs64           2
+       sys     sys_timer_create        3
+       sys     sys_timer_settime       4
+       sys     sys_timer_gettime       2
+       sys     sys_timer_getoverrun    1       /* 260 */
+       sys     sys_timer_delete        1
+       sys     sys_clock_settime       2
+       sys     sys_clock_gettime       2
+       sys     sys_clock_getres        2
+       sys     sys_clock_nanosleep     4       /* 265 */
+       sys     sys_tgkill              3
+       sys     sys_utimes              2
+       sys     sys_ni_syscall          0       /* old mbind */
+       sys     sys_ni_syscall          0       /* old get_mempolicy */
+       sys     sys_ni_syscall          0       /* 270 old set_mempolicy 
*/
+       sys     sys_mq_open             4
+       sys     sys_mq_unlink           1
+       sys     sys_mq_timedsend        5
+       sys     sys_mq_timedreceive     5
+       sys     sys_mq_notify           2       /* 275 */
+       sys     sys_mq_getsetattr       3
+       sys     sys_ni_syscall          0       /* sys_vserver */
+       sys     sys_waitid              5
+       sys     sys_ni_syscall          0
+       sys     sys_add_key             5       /* 280 */
+       sys     sys_request_key         4
+       sys     sys_keyctl              5
+       sys     sys_ni_syscall          0       /* old set_thread_area */
+       sys     sys_inotify_init        0
+       sys     sys_inotify_add_watch   3       /* 285 */
+       sys     sys_inotify_rm_watch    2
+       sys     sys_ni_syscall          0       /* old migrate_pages */
+       sys     sys_openat              4
+       sys     sys_mkdirat             3
+       sys     sys_mknodat             4       /* 290 */
+       sys     sys_fchownat            5
+       sys     sys_futimesat           3
+       sys     sys_fstatat64           4
+       sys     sys_unlinkat            3
+       sys     sys_renameat            4       /* 295 */
+       sys     sys_linkat              5
+       sys     sys_symlinkat           3
+       sys     sys_readlinkat          4
+       sys     sys_fchmodat            3
+       sys     sys_faccessat           3       /* 300 */
+       sys     sys_pselect6            6
+       sys     sys_ppoll               5
+       sys     sys_unshare             1
+       sys     sys_splice              4
+       sys     sys_sync_file_range     7       /* 305 */
+       sys     sys_tee                 4
+       sys     sys_vmsplice            4
+       sys     sys_move_pages          6
+       sys     sys_set_robust_list     2
+       sys     sys_get_robust_list     3       /* 310 */
+       sys     sys_kexec_load          4
+       sys     sys_getcpu              3
+       sys     sys_epoll_pwait         6
+       sys     sys_ioprio_set          3
+       sys     sys_ioprio_get          2       /* 315 */
+       sys     sys_utimensat           4
+       sys     sys_signalfd            3
+       sys     sys_ni_syscall          0
+       sys     sys_eventfd             1
+       sys     sys_fallocate           6       /* 320 */
+       sys     sys_timerfd_create      2
+       sys     sys_timerfd_gettime     2
+       sys     sys_timerfd_settime     4
+       sys     sys_signalfd4           4
+       sys     sys_eventfd2            2       /* 325 */
+       sys     sys_epoll_create1       1
+       sys     sys_dup3                3
+       sys     sys_pipe2               2
+       sys     sys_inotify_init1       1
+       .endm
+
+       /* We pre-compute the number of _instruction_ bytes needed to
+          load or store the arguments 6-8. Negative values are ignored. 
*/
+
+       .macro  sys function, nargs
+       .word   \function
+       .word   \nargs
+       .endm
+
+       .align  2
+       .globl  sys_call_table
+       .type   sys_call_table, @object
+sys_call_table:
+       syscalltable
+       .size   sys_call_table, . - sys_call_table
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/sys-score.c 
linux-2.6-git.new/arch/score/kernel/sys-score.c
--- linux-2.6-git.ori/arch/score/kernel/sys-score.c     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/sys-score.c     2009-04-07 
21:21:20.000000000 +0800
@@ -0,0 +1,178 @@
+/*
+ * arch/score/kernel/syscall.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/fs.h>
+#include <linux/mman.h>
+#include <linux/syscalls.h>
+#include <linux/file.h>
+#include <linux/utsname.h>
+#include <linux/unistd.h>
+#include <linux/shm.h>
+#include <linux/module.h>
+#include <asm/uaccess.h>
+
+unsigned long shm_align_mask = PAGE_SIZE - 1;
+EXPORT_SYMBOL(shm_align_mask);
+
+asmlinkage unsigned long
+sys_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
+         unsigned long flags, unsigned long fd, unsigned long pgoff)
+{
+       int error = -EBADF;
+       struct file *file = NULL;
+
+       if (pgoff & (~PAGE_MASK >> 12))
+               return -EINVAL;
+
+       flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
+       if (!(flags & MAP_ANONYMOUS)) {
+               file = fget(fd);
+               if (!file)
+                       return error;
+       }
+
+       down_write(&current->mm->mmap_sem);
+       error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff >> 
(PAGE_SHIFT-12));
+       up_write(&current->mm->mmap_sem);
+
+       if (file)
+               fput(file);
+
+       return error;
+}
+
+/*
+ * Fork a new task - this creates a new program thread.
+ * This is called indirectly via a small wrapper
+ */
+asmlinkage int
+sys_fork(struct pt_regs *regs)
+{
+       return do_fork(SIGCHLD, regs->regs[0], regs, 0, NULL, NULL);
+}
+
+/*
+ * Clone a task - this clones the calling program thread.
+ * This is called indirectly via a small wrapper
+ */
+asmlinkage int
+sys_clone(struct pt_regs *regs)
+{
+       unsigned long clone_flags;
+       unsigned long newsp;
+       int __user *parent_tidptr, *child_tidptr;
+
+       clone_flags = regs->regs[4];
+       newsp = regs->regs[5];
+       if (!newsp)
+               newsp = regs->regs[0];
+       parent_tidptr = (int __user *)regs->regs[6];
+
+       child_tidptr = NULL;
+       if (clone_flags & (CLONE_CHILD_SETTID | CLONE_CHILD_CLEARTID)) {
+               int __user *__user *usp = (int __user *__user 
*)regs->regs[0];
+
+               if (get_user(child_tidptr, &usp[4]))
+                       return -EFAULT;
+       }
+
+       return do_fork(clone_flags, newsp, regs, 0,
+                       parent_tidptr, child_tidptr);
+}
+
+/*
+ * sys_execve() executes a new program.
+ * This is called indirectly via a small wrapper
+ */
+asmlinkage int sys_execve(struct pt_regs *regs)
+{
+       int error;
+       char *filename;
+
+       filename = getname((char *) (long) regs->regs[4]);
+       error = PTR_ERR(filename);
+       if (IS_ERR(filename))
+               return error;
+
+       error = do_execve(filename, (char **) (long) regs->regs[5],
+                         (char **) (long) regs->regs[6], regs);
+
+       putname(filename);
+       return error;
+}
+
+/*
+ * If we ever come here the user sp is bad.  Zap the process right away.
+ * Due to the bad stack signaling wouldn't work.
+ */
+asmlinkage void bad_stack(void)
+{
+       do_exit(SIGSEGV);
+}
+
+/*
+ * Do a system call from kernel instead of calling sys_execve so we
+ * end up with proper pt_regs.
+ */
+int kernel_execve(const char *filename, char *const argv[], char *const 
envp[])
+{
+       register unsigned long __r4 asm("r4") = (unsigned long) filename;
+       register unsigned long __r5 asm("r5") = (unsigned long) argv;
+       register unsigned long __r6 asm("r6") = (unsigned long) envp;
+       register unsigned long __r7 asm("r7");
+
+       __asm__ volatile ("     \n"
+               "ldi    r27, %5         \n"
+               "syscall                \n"
+               "mv     %0, r4          \n"
+               "mv     %1, r7          \n"
+               : "=&r" (__r4), "=r" (__r7)
+               : "r" (__r4), "r" (__r5), "r" (__r6), "i" (__NR_execve)
+               : "r8", "r9", "r10", "r11", "r22", "r23", "r24", "r25",
+                 "r26", "r27", "memory");
+
+       if (__r7 == 0)
+               return __r4;
+
+       return -__r4;
+}
+
+asmlinkage ssize_t sys_pwrite64_wrapper(unsigned int fd, const char *buf,
+                                       long long count, loff_t pos)
+{
+       return sys_pwrite64(fd, buf, (long) count, pos);
+}
+
+asmlinkage ssize_t sys_pread64_wrapper(unsigned int fd, char *buf,
+                                       long long count, loff_t pos)
+{
+       return sys_pread64(fd, buf, (long) count, pos);
+}
+
+asmlinkage long
+sys_fadvise64_64_wrapper(int fd, int unused, loff_t offset, size_t len, 
int advice)
+{
+       return sys_fadvise64(fd, offset, len, advice);
+}
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/time.c 
linux-2.6-git.new/arch/score/kernel/time.c
--- linux-2.6-git.ori/arch/score/kernel/time.c  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/time.c  2009-04-07 
21:21:49.000000000 +0800
@@ -0,0 +1,144 @@
+/*
+ * arch/score/kernel/time.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/interrupt.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <asm/scoreregs.h>
+
+int timer_interrupt(int irq, void *dev_id)
+{
+       struct clock_event_device *evdev = dev_id;
+
+       __raw_writel(1, P_TIMER0_CPP_REG);      /* clear timer interrupt 
flag */
+       evdev->event_handler(evdev);
+
+       return IRQ_HANDLED;
+}
+
+static struct irqaction timer_irq = {
+       .handler = timer_interrupt,
+       .flags = IRQF_DISABLED | IRQF_TIMER,
+       .mask = CPU_MASK_NONE,
+       .name = "timer",
+};
+
+static int comparator_next_event(unsigned long delta,
+               struct clock_event_device *evdev)
+{
+       unsigned long   flags;
+
+       raw_local_irq_save(flags);
+
+       __raw_writel((TMR_M_PERIODIC | TMR_IE_ENABLE), P_TIMER0_CTRL);
+       __raw_writel(delta, P_TIMER0_PRELOAD);
+       __raw_writel(__raw_readl(P_TIMER0_CTRL) | TMR_ENABLE, 
P_TIMER0_CTRL);
+
+       raw_local_irq_restore(flags);
+
+       return 0;
+}
+
+static void comparator_mode(enum clock_event_mode mode,
+               struct clock_event_device *evdev)
+{
+       unsigned long   flags;
+
+       switch (mode) {
+       case CLOCK_EVT_MODE_PERIODIC:
+               raw_local_irq_save(flags);
+               __raw_writel((TMR_M_PERIODIC | TMR_IE_ENABLE), 
P_TIMER0_CTRL);
+               __raw_writel(SYSTEM_CLOCK/100, P_TIMER0_PRELOAD);
+               __raw_writel(__raw_readl(P_TIMER0_CTRL) | TMR_ENABLE, 
P_TIMER0_CTRL);
+               raw_local_irq_restore(flags);
+               break;
+       case CLOCK_EVT_MODE_ONESHOT:
+       case CLOCK_EVT_MODE_RESUME:
+       case CLOCK_EVT_MODE_UNUSED:
+       case CLOCK_EVT_MODE_SHUTDOWN:
+               break;
+       default:
+               BUG();
+       }
+}
+
+static struct clock_event_device comparator = {
+       .name           = "avr32_comparator",
+       .features       = CLOCK_EVT_FEAT_PERIODIC | 
CLOCK_EVT_FEAT_ONESHOT,
+       .shift          = 16,
+       .set_next_event = comparator_next_event,
+       .set_mode       = comparator_mode,
+};
+
+static u32 score_tick_cnt;
+
+static cycle_t score_read_clk(void)
+{
+       unsigned long flags;
+
+       local_irq_save(flags);
+       score_tick_cnt += SYSTEM_CLOCK/100;
+       local_irq_restore(flags);
+
+       return score_tick_cnt;
+}
+
+static struct clocksource score_clk = {
+       .name   = "timer",
+       .rating = 250,
+       .read   = score_read_clk,
+       .shift  = 20,
+       .mask   = CLOCKSOURCE_MASK(32),
+       .flags  = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+void __init time_init(void)
+{
+       xtime.tv_sec = mktime(2009, 1, 1, 0, 0, 0);
+       xtime.tv_nsec = 0;
+
+       set_normalized_timespec(&wall_to_monotonic, -xtime.tv_sec, 
-xtime.tv_nsec);
+
+       /* disable timer, timer interrupt enable */
+       __raw_writel((TMR_M_PERIODIC | TMR_IE_ENABLE), P_TIMER0_CTRL);
+       __raw_writel(SYSTEM_CLOCK/100, P_TIMER0_PRELOAD);       /* 10ms */
+
+       /* start timer */
+       __raw_writel(__raw_readl(P_TIMER0_CTRL) | TMR_ENABLE, 
P_TIMER0_CTRL);
+
+       score_clk.mult = clocksource_hz2mult(SYSTEM_CLOCK, 
score_clk.shift);
+       clocksource_register(&score_clk);
+
+       /* setup COMPARE clockevent */
+       comparator.mult = div_sc(SYSTEM_CLOCK, NSEC_PER_SEC, 
comparator.shift);
+       comparator.max_delta_ns = clockevent_delta2ns((u32)~0, 
&comparator);
+       comparator.min_delta_ns = clockevent_delta2ns(50, &comparator) + 
1;
+       comparator.cpumask = cpumask_of(0);
+
+       timer_irq.dev_id = &comparator;
+       setup_irq(IRQ_TIMER , &timer_irq);
+
+       clockevents_register_device(&comparator);
+}
