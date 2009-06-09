Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbZFIGlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbZFIGlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbZFIGlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:41:17 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:58890 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbZFIGlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:41:15 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 22/27] score: create kernel files signal.c sys_score.c time.c
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF32AB4A20.4574C065-ON482575D0.00243CB1-482575D0.0024AD26@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:36:18 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:36:19,
	Serialize complete at 2009/06/09 ?? 02:36:19
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 79973c044436267234fe16a8e202cabb7c4608bf Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:17 +0800
Subject: [PATCH 22/27] score: create kernel files signal.c sys_score.c 
time.c


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/kernel/signal.c    |  355 
+++++++++++++++++++++++++++++++++++++++++
 arch/score/kernel/sys_score.c |  179 +++++++++++++++++++++
 arch/score/kernel/time.c      |  150 +++++++++++++++++
 3 files changed, 684 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/kernel/signal.c
 create mode 100644 arch/score/kernel/sys_score.c
 create mode 100644 arch/score/kernel/time.c

diff --git a/arch/score/kernel/signal.c b/arch/score/kernel/signal.c
new file mode 100644
index 0000000..b4ed1b3
--- /dev/null
+++ b/arch/score/kernel/signal.c
@@ -0,0 +1,355 @@
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
+#include <linux/errno.h>
+#include <linux/signal.h>
+#include <linux/unistd.h>
+#include <linux/uaccess.h>
+#include <asm-generic/ucontext.h>
+
+#include <asm/cacheflush.h>
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
+       save_gp_reg(3); save_gp_reg(4); save_gp_reg(5);
+       save_gp_reg(6); save_gp_reg(7); save_gp_reg(8);
+       save_gp_reg(9); save_gp_reg(10); save_gp_reg(11);
+       save_gp_reg(12); save_gp_reg(13); save_gp_reg(14);
+       save_gp_reg(15); save_gp_reg(16); save_gp_reg(17);
+       save_gp_reg(18); save_gp_reg(19); save_gp_reg(20);
+       save_gp_reg(21); save_gp_reg(22); save_gp_reg(23);
+       save_gp_reg(24); save_gp_reg(25); save_gp_reg(26);
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
+       restore_gp_reg(3); restore_gp_reg(4); restore_gp_reg(5);
+       restore_gp_reg(6); restore_gp_reg(7); restore_gp_reg(8);
+       restore_gp_reg(9); restore_gp_reg(10); restore_gp_reg(11);
+       restore_gp_reg(12); restore_gp_reg(13); restore_gp_reg(14);
+       restore_gp_reg(15); restore_gp_reg(16); restore_gp_reg(17);
+       restore_gp_reg(18); restore_gp_reg(19); restore_gp_reg(20);
+       restore_gp_reg(21); restore_gp_reg(22); restore_gp_reg(23);
+       restore_gp_reg(24); restore_gp_reg(25); restore_gp_reg(26);
+       restore_gp_reg(27); restore_gp_reg(28); restore_gp_reg(29);
+#undef restore_gp_reg
+
+       return err;
+}
+
+/*
+ * Determine which stack to use..
+ */
+void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
+                       size_t frame_size)
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
+asmlinkage int score_sigaltstack(struct pt_regs *regs)
+{
+       const stack_t *uss = (const stack_t *) regs->regs[4];
+       stack_t *uoss = (stack_t *) regs->regs[5];
+       unsigned long usp = regs->regs[0];
+
+       return do_sigaltstack(uss, uoss, usp);
+}
+
+asmlinkage void score_rt_sigreturn(struct pt_regs *regs)
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
+               int signr, sigset_t *set, siginfo_t *info)
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
+       err |= __put_user(0x87788000 + __NR_rt_sigreturn*2,
+                       frame->rs_code + 0);
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
diff --git a/arch/score/kernel/sys_score.c b/arch/score/kernel/sys_score.c
new file mode 100644
index 0000000..ed2bf67
--- /dev/null
+++ b/arch/score/kernel/sys_score.c
@@ -0,0 +1,179 @@
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
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/mman.h>
+#include <linux/module.h>
+#include <linux/unistd.h>
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
+       error = do_mmap_pgoff(file, addr, len, prot, flags,
+                       pgoff >> (PAGE_SHIFT - 12));
+       up_write(&current->mm->mmap_sem);
+
+       if (file)
+               fput(file);
+
+       return error;
+}
+
+asmlinkage long sys_mmap(unsigned long addr, size_t len,
+                       unsigned long prot, unsigned long flags,
+                       unsigned long fd, off_t offset)
+{
+       int err = -EINVAL;
+
+       if (offset & ~PAGE_MASK) {
+               printk(KERN_INFO "no pagemask in mmap\r\n");
+               goto out;
+       }
+
+       err = sys_mmap2(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
+out:
+       return err;
+}
+
+asmlinkage long score_vfork(struct pt_regs *regs)
+{
+       return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->regs[0],
+                                               regs, 0, NULL, NULL);
+}
+
+/*
+ * Fork a new task - this creates a new program thread.
+ * This is called indirectly via a small wrapper
+ */
+asmlinkage int
+score_fork(struct pt_regs *regs)
+{
+       return do_fork(SIGCHLD, regs->regs[0], regs, 0, NULL, NULL);
+}
+
+/*
+ * Clone a task - this clones the calling program thread.
+ * This is called indirectly via a small wrapper
+ */
+asmlinkage int
+score_clone(struct pt_regs *regs)
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
+asmlinkage int score_execve(struct pt_regs *regs)
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
diff --git a/arch/score/kernel/time.c b/arch/score/kernel/time.c
new file mode 100644
index 0000000..45029eb
--- /dev/null
+++ b/arch/score/kernel/time.c
@@ -0,0 +1,150 @@
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
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+
+#include <asm/scoreregs.h>
+
+irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+       struct clock_event_device *evdev = dev_id;
+
+       /* clear timer interrupt flag */
+       __raw_writel(1, (void *)P_TIMER0_CPP_REG);
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
+       __raw_writel((TMR_M_PERIODIC | TMR_IE_ENABLE), (void 
*)P_TIMER0_CTRL);
+       __raw_writel(delta, (void *)P_TIMER0_PRELOAD);
+       __raw_writel(__raw_readl((void *)P_TIMER0_CTRL) | TMR_ENABLE,
+               (void *)P_TIMER0_CTRL);
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
+                       (void *)P_TIMER0_CTRL);
+               __raw_writel(SYSTEM_CLOCK/100, (void *)P_TIMER0_PRELOAD);
+               __raw_writel(__raw_readl((void *)P_TIMER0_CTRL) | 
TMR_ENABLE,
+                       (void *)P_TIMER0_CTRL);
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
+static cycle_t score_read_clk(struct clocksource *cs)
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
+                               -xtime.tv_nsec);
+
+       /* disable timer, timer interrupt enable */
+       __raw_writel((TMR_M_PERIODIC | TMR_IE_ENABLE), (void 
*)P_TIMER0_CTRL);
+       __raw_writel(SYSTEM_CLOCK/100, (void *)P_TIMER0_PRELOAD); /* 10ms 
*/
+
+       /* start timer */
+       __raw_writel(__raw_readl((void *)P_TIMER0_CTRL) | TMR_ENABLE,
+               (void *)P_TIMER0_CTRL);
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
-- 
1.6.2

