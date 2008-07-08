Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbYGHMtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbYGHMtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759295AbYGHMra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:47:30 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27570 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758796AbYGHMr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:47:27 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 08/58] microblaze_v5: Signal support
Date: Tue,  8 Jul 2008 13:59:08 +0200
Message-Id: <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/signal.c |  532 +++++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/signal.h |  181 +++++++++++++
 2 files changed, 713 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/signal.c
 create mode 100644 include/asm-microblaze/signal.h

diff --git a/arch/microblaze/kernel/signal.c b/arch/microblaze/kernel/signal.c
new file mode 100644
index 0000000..ba56799
--- /dev/null
+++ b/arch/microblaze/kernel/signal.c
@@ -0,0 +1,532 @@
+/*
+ * Signal handling
+ *
+ * Copyright (C) 2003,2004 John Williams <jwilliams@itee.uq.edu.au>
+ * Copyright (C) 2001 NEC Corporation
+ * Copyright (C) 2001 Miles Bader <miles@gnu.org>
+ * Copyright (C) 1999,2000 Niibe Yutaka & Kaz Kojima
+ * Copyright (C) 1991,1992 Linus Torvalds
+ *
+ * 1997-11-28 Modified for POSIX.1b signals by Richard Henderson
+ *
+ * This file was was derived from the sh version, arch/sh/kernel/signal.c
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ */
+
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/kernel.h>
+#include <linux/signal.h>
+#include <linux/errno.h>
+#include <linux/wait.h>
+#include <linux/ptrace.h>
+#include <linux/unistd.h>
+#include <linux/stddef.h>
+#include <linux/personality.h>
+#include <linux/percpu.h>
+#include <linux/linkage.h>
+#include <asm/entry.h>
+#include <asm/ucontext.h>
+#include <asm/uaccess.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <asm/signal.h>
+#include <asm/cacheflush.h>
+
+#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
+
+asmlinkage int do_signal(struct pt_regs *regs, sigset_t *oldset, int in_sycall);
+
+/*
+ * Atomically swap in the new signal mask, and wait for a signal.
+ */
+asmlinkage int
+sys_sigsuspend(old_sigset_t mask, struct pt_regs *regs)
+{
+	sigset_t saveset;
+
+	mask &= _BLOCKABLE;
+	spin_lock_irq(&current->sighand->siglock);
+	saveset = current->blocked;
+	siginitset(&current->blocked, mask);
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	regs->r3 = -EINTR;
+	while (1) {
+		current->state = TASK_INTERRUPTIBLE;
+		schedule();
+		if (do_signal(regs, &saveset, 1))
+			return -EINTR;
+	}
+}
+
+asmlinkage int
+sys_rt_sigsuspend(sigset_t *unewset, size_t sigsetsize,
+		struct pt_regs *regs)
+{
+	sigset_t saveset, newset;
+
+	/* XXX: Don't preclude handling different sized sigset_t's. */
+	if (sigsetsize != sizeof(sigset_t))
+		return -EINVAL;
+
+	if (copy_from_user(&newset, unewset, sizeof(newset)))
+		return -EFAULT;
+	sigdelsetmask(&newset, ~_BLOCKABLE);
+	spin_lock_irq(&current->sighand->siglock);
+	saveset = current->blocked;
+	current->blocked = newset;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	regs->r3 = -EINTR;
+	while (1) {
+		current->state = TASK_INTERRUPTIBLE;
+		schedule();
+		if (do_signal(regs, &saveset, 1))
+			return -EINTR;
+	}
+}
+
+asmlinkage int
+sys_sigaction(int sig, const struct old_sigaction *act,
+		struct old_sigaction *oact)
+{
+	struct k_sigaction new_ka, old_ka;
+	int ret;
+
+	if (act) {
+		old_sigset_t mask;
+		if (!access_ok(VERIFY_READ, act, sizeof(*act)) ||
+			__get_user(new_ka.sa.sa_handler, &act->sa_handler) ||
+			__get_user(new_ka.sa.sa_restorer, &act->sa_restorer))
+			return -EFAULT;
+		__get_user(new_ka.sa.sa_flags, &act->sa_flags);
+		__get_user(mask, &act->sa_mask);
+		siginitset(&new_ka.sa.sa_mask, mask);
+	}
+
+	ret = do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
+
+	if (!ret && oact) {
+		if (!access_ok(VERIFY_WRITE, oact, sizeof(*oact)) ||
+			__put_user(old_ka.sa.sa_handler, &oact->sa_handler) ||
+			__put_user(old_ka.sa.sa_restorer, &oact->sa_restorer))
+			return -EFAULT;
+		__put_user(old_ka.sa.sa_flags, &oact->sa_flags);
+		__put_user(old_ka.sa.sa_mask.sig[0], &oact->sa_mask);
+	}
+
+	return ret;
+}
+
+asmlinkage int
+sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
+		struct pt_regs *regs)
+{
+	return do_sigaltstack(uss, uoss, regs->r1);
+}
+
+/*
+ * Do a signal return; undo the signal stack.
+ */
+
+struct sigframe {
+	struct sigcontext sc;
+	unsigned long extramask[_NSIG_WORDS-1];
+	unsigned long tramp[2];	/* signal trampoline */
+};
+
+struct rt_sigframe {
+	struct siginfo info;
+	struct ucontext uc;
+	unsigned long tramp[2];	/* signal trampoline */
+};
+
+static int
+restore_sigcontext(struct pt_regs *regs, struct sigcontext *sc, int *rval_p)
+{
+	unsigned int err = 0;
+
+#define COPY(x)		err |= __get_user(regs->x, &sc->regs.x)
+	COPY(r0);	COPY(r1);
+	COPY(r2);	COPY(r3);	COPY(r4);	COPY(r5);
+	COPY(r6);	COPY(r7);	COPY(r8);	COPY(r9);
+	COPY(r10);	COPY(r11);	COPY(r12);	COPY(r13);
+	COPY(r14);	COPY(r15);	COPY(r16);	COPY(r17);
+	COPY(r18);	COPY(r19);	COPY(r20);	COPY(r21);
+	COPY(r22);	COPY(r23);	COPY(r24);	COPY(r25);
+	COPY(r26);	COPY(r27);	COPY(r28);	COPY(r29);
+	COPY(r30);	COPY(r31);
+	COPY(pc);	COPY(ear);	COPY(esr);	COPY(fsr);
+#undef COPY
+
+	*rval_p = regs->r3;
+
+	return err;
+}
+
+asmlinkage int sys_sigreturn(struct pt_regs *regs)
+{
+	struct sigframe *frame = (struct sigframe *)regs->r1;
+	sigset_t set;
+	int rval;
+
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+
+	if (__get_user(set.sig[0], &frame->sc.oldmask)
+		|| (_NSIG_WORDS > 1
+		&& __copy_from_user(&set.sig[1], &frame->extramask,
+					sizeof(frame->extramask))))
+		goto badframe;
+
+	sigdelsetmask(&set, ~_BLOCKABLE);
+
+	spin_lock_irq(&current->sighand->siglock);
+	current->blocked = set;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (restore_sigcontext(regs, &frame->sc, &rval))
+		goto badframe;
+	return rval;
+
+badframe:
+	force_sig(SIGSEGV, current);
+	return 0;
+}
+
+asmlinkage int sys_rt_sigreturn(struct pt_regs *regs)
+{
+	struct rt_sigframe *frame = (struct rt_sigframe *)regs->r1;
+	sigset_t set;
+	stack_t st;
+	int rval;
+
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+
+	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
+		goto badframe;
+
+	sigdelsetmask(&set, ~_BLOCKABLE);
+	spin_lock_irq(&current->sighand->siglock);
+	current->blocked = set;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &rval))
+		goto badframe;
+
+	if (__copy_from_user((void *)&st, &frame->uc.uc_stack, sizeof(st)))
+		goto badframe;
+	/* It is more difficult to avoid calling this function than to
+	 call it and ignore errors. */
+	do_sigaltstack(&st, NULL, regs->r1);
+
+	return rval;
+
+badframe:
+	force_sig(SIGSEGV, current);
+	return 0;
+}
+
+/*
+ * Set up a signal frame.
+ */
+
+static int
+setup_sigcontext(struct sigcontext *sc, struct pt_regs *regs,
+		unsigned long mask)
+{
+	int err = 0;
+
+#define COPY(x)		err |= __put_user(regs->x, &sc->regs.x)
+	COPY(r0);	COPY(r1);
+	COPY(r2);	COPY(r3);	COPY(r4);	COPY(r5);
+	COPY(r6);	COPY(r7);	COPY(r8);	COPY(r9);
+	COPY(r10);	COPY(r11);	COPY(r12);	COPY(r13);
+	COPY(r14);	COPY(r15);	COPY(r16);	COPY(r17);
+	COPY(r18);	COPY(r19);	COPY(r20);	COPY(r21);
+	COPY(r22);	COPY(r23);	COPY(r24);	COPY(r25);
+	COPY(r26);	COPY(r27);	COPY(r28);	COPY(r29);
+	COPY(r30);	COPY(r31);
+	COPY(pc);	COPY(ear);	COPY(esr);	COPY(fsr);
+#undef COPY
+
+	err |= __put_user(mask, &sc->oldmask);
+
+	return err;
+}
+
+/*
+ * Determine which stack to use..
+ */
+static inline void *
+get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
+{
+	/* Default to using normal stack */
+	unsigned long sp = regs->r1;
+
+	if ((ka->sa.sa_flags & SA_ONSTACK) != 0 && !on_sig_stack(sp))
+		sp = current->sas_ss_sp + current->sas_ss_size;
+
+	return (void *)((sp - frame_size) & -8UL);
+}
+
+static void setup_frame(int sig, struct k_sigaction *ka,
+			sigset_t *set, struct pt_regs *regs)
+{
+	struct sigframe *frame;
+	int err = 0;
+	int signal;
+
+	frame = get_sigframe(ka, regs, sizeof(*frame));
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		goto give_sigsegv;
+
+	signal = current_thread_info()->exec_domain
+		&& current_thread_info()->exec_domain->signal_invmap
+		&& sig < 32
+		? current_thread_info()->exec_domain->signal_invmap[sig]
+		: sig;
+
+	err |= setup_sigcontext(&frame->sc, regs, set->sig[0]);
+
+	if (_NSIG_WORDS > 1) {
+		err |= __copy_to_user(frame->extramask, &set->sig[1],
+					sizeof(frame->extramask));
+	}
+
+	/* Set up to return from userspace. If provided, use a stub
+	 already in userspace. */
+	/* minus 8 is offset to cater for "rtsd r15,8" offset */
+	if (ka->sa.sa_flags & SA_RESTORER) {
+		regs->r15 = ((unsigned long)ka->sa.sa_restorer)-8;
+	} else {
+		/* Note, these encodings are _big endian_! */
+
+		/* addi r12, r0, __NR_sigreturn */
+		err |= __put_user(0x31800000 | __NR_sigreturn ,
+				frame->tramp + 0);
+		/* brki r14, 0x8 */
+		err |= __put_user(0xb9cc0008, frame->tramp + 1);
+
+		/* Return from sighandler will jump to the tramp.
+		 Negative 8 offset because return is rtsd r15, 8 */
+		regs->r15 = ((unsigned long)frame->tramp)-8;
+
+		__invalidate_cache_sigtramp((unsigned long)frame->tramp);
+	}
+
+	if (err)
+		goto give_sigsegv;
+
+	/* Set up registers for signal handler */
+	regs->r1 = (unsigned long) frame;
+	/* Signal handler args: */
+	regs->r5 = signal; /* Arg 0: signum */
+	regs->r6 = (unsigned long) &frame->sc; /* arg 1: sigcontext */
+
+	/* Offset of 4 to handle microblaze rtid r14, 0 */
+	regs->pc = (unsigned long)ka->sa.sa_handler;
+
+	set_fs(USER_DS);
+
+#ifdef DEBUG_SIG
+	printk(KERN_INFO "SIG deliver (%s:%d): sp=%p pc=%08lx\n",
+		current->comm, current->pid, frame, regs->pc);
+#endif
+
+	return;
+
+give_sigsegv:
+	if (sig == SIGSEGV)
+		ka->sa.sa_handler = SIG_DFL;
+	force_sig(SIGSEGV, current);
+}
+
+static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+			sigset_t *set, struct pt_regs *regs)
+{
+	struct rt_sigframe *frame;
+	int err = 0;
+	int signal;
+
+	frame = get_sigframe(ka, regs, sizeof(*frame));
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		goto give_sigsegv;
+
+	signal = current_thread_info()->exec_domain
+		&& current_thread_info()->exec_domain->signal_invmap
+		&& sig < 32
+		? current_thread_info()->exec_domain->signal_invmap[sig]
+		: sig;
+
+	err |= copy_siginfo_to_user(&frame->info, info);
+
+	/* Create the ucontext. */
+	err |= __put_user(0, &frame->uc.uc_flags);
+	err |= __put_user(0, &frame->uc.uc_link);
+	err |= __put_user((void *)current->sas_ss_sp,
+			&frame->uc.uc_stack.ss_sp);
+	err |= __put_user(sas_ss_flags(regs->r1),
+			&frame->uc.uc_stack.ss_flags);
+	err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
+	err |= setup_sigcontext(&frame->uc.uc_mcontext,
+			regs, set->sig[0]);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
+	/* Set up to return from userspace. If provided, use a stub
+	 already in userspace. */
+	/* minus 8 is offset to cater for "rtsd r15,8" */
+	if (ka->sa.sa_flags & SA_RESTORER) {
+		regs->r15 = ((unsigned long)ka->sa.sa_restorer)-8;
+	} else {
+		/* addi r12, r0, __NR_sigreturn */
+		err |= __put_user(0x31800000 | __NR_rt_sigreturn ,
+				frame->tramp + 0);
+		/* brki r14, 0x8 */
+		err |= __put_user(0xb9cc0008, frame->tramp + 1);
+
+		/* Return from sighandler will jump to the tramp.
+		 Negative 8 offset because return is rtsd r15, 8 */
+		regs->r15 = ((unsigned long)frame->tramp)-8;
+
+		__invalidate_cache_sigtramp((unsigned long)frame->tramp);
+	}
+
+	if (err)
+		goto give_sigsegv;
+
+	/* Set up registers for signal handler */
+	regs->r1 = (unsigned long) frame;
+	/* Signal handler args: */
+	regs->r5 = signal; /* arg 0: signum */
+	regs->r6 = (unsigned long) &frame->info; /* arg 1: siginfo */
+	regs->r7 = (unsigned long) &frame->uc; /* arg2: ucontext */
+	/* Offset to handle microblaze rtid r14, 0 */
+	regs->pc = (unsigned long)ka->sa.sa_handler;
+
+	set_fs(USER_DS);
+
+#ifdef DEBUG_SIG
+	printk(KERN_INFO "SIG deliver (%s:%d): sp=%p pc=%08lx\n",
+		current->comm, current->pid, frame, regs->pc);
+#endif
+
+	return;
+
+give_sigsegv:
+	if (sig == SIGSEGV)
+		ka->sa.sa_handler = SIG_DFL;
+	force_sig(SIGSEGV, current);
+}
+
+/* Handle restarting system calls */
+static inline void
+handle_restart(struct pt_regs *regs, struct k_sigaction *ka, int has_handler)
+{
+	switch (regs->r3) {
+	case -ERESTART_RESTARTBLOCK:
+	case -ERESTARTNOHAND:
+		if (!has_handler)
+			goto do_restart;
+		regs->r3 = -EINTR;
+		break;
+	case -ERESTARTSYS:
+		if (has_handler && !(ka->sa.sa_flags & SA_RESTART)) {
+			regs->r3 = -EINTR;
+			break;
+	}
+	/* fallthrough */
+	case -ERESTARTNOINTR:
+do_restart:
+		/* offset of 4 bytes to re-execute trap (brki) instruction */
+		regs->pc -= 4;
+		break;
+	}
+}
+
+/*
+ * OK, we're invoking a handler
+ */
+
+static void
+handle_signal(unsigned long sig, struct k_sigaction *ka,
+		siginfo_t *info, sigset_t *oldset, struct pt_regs *regs)
+{
+	/* Set up the stack frame */
+	if (ka->sa.sa_flags & SA_SIGINFO)
+		setup_rt_frame(sig, ka, info, oldset, regs);
+	else
+		setup_frame(sig, ka, oldset, regs);
+
+	if (ka->sa.sa_flags & SA_ONESHOT)
+		ka->sa.sa_handler = SIG_DFL;
+
+	if (!(ka->sa.sa_flags & SA_NODEFER)) {
+		spin_lock_irq(&current->sighand->siglock);
+		sigorsets(&current->blocked,
+				&current->blocked, &ka->sa.sa_mask);
+		sigaddset(&current->blocked, sig);
+		recalc_sigpending();
+		spin_unlock_irq(&current->sighand->siglock);
+	}
+}
+
+/*
+ * Note that 'init' is a special process: it doesn't get signals it doesn't
+ * want to handle. Thus you cannot kill init even with a SIGKILL even by
+ * mistake.
+ *
+ * Note that we go through the signals twice: once to check the signals that
+ * the kernel can handle, and then we build all the user-level signal handling
+ * stack-frames in one go after that.
+ */
+int do_signal(struct pt_regs *regs, sigset_t *oldset, int in_syscall)
+{
+	siginfo_t info;
+	int signr;
+	struct k_sigaction ka;
+#ifdef DEBUG_SIG
+	printk(KERN_INFO "do signal: %p %p %d\n", regs, oldset, in_syscall);
+	printk(KERN_INFO "do signal2: %lx %lx %ld [%lx]\n", regs->pc, regs->r1,
+			regs->r12, current_thread_info()->flags);
+#endif
+	/*
+	 * We want the common case to go fast, which
+	 * is why we may in certain cases get here from
+	 * kernel mode. Just return without doing anything
+	 * if so.
+	 */
+	if (!user_mode(regs))
+		return 1;
+
+	if (!oldset)
+		oldset = &current->blocked;
+
+	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+	if (signr > 0) {
+		/* Whee! Actually deliver the signal. */
+		if (in_syscall)
+			handle_restart(regs, &ka, 1);
+		handle_signal(signr, &ka, &info, oldset, regs);
+		return 1;
+	}
+
+	if (in_syscall)
+		handle_restart(regs, NULL, 0);
+
+	/* Did we come from a system call? */
+	return 0;
+}
diff --git a/include/asm-microblaze/signal.h b/include/asm-microblaze/signal.h
new file mode 100644
index 0000000..fc6f5db
--- /dev/null
+++ b/include/asm-microblaze/signal.h
@@ -0,0 +1,181 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *	Yasushi SHOJI <yashi@atmark-techno.com>
+ *	Tetsuya OHKAWA <tetsuya@atmark-techno.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_SIGNAL_H
+#define _ASM_MICROBLAZE_SIGNAL_H
+
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+
+/* Avoid too many header ordering problems. */
+struct siginfo;
+
+#ifdef __KERNEL__
+
+/* Most things should be clean enough to redefine this at will, if care
+ is taken to make libc match. */
+#define _NSIG		64
+#define _NSIG_BPW	32
+#define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
+
+typedef unsigned long old_sigset_t; /* at least 32 bits */
+
+typedef struct {
+	unsigned long sig[_NSIG_WORDS];
+} sigset_t;
+
+#else /* !__KERNEL__ */
+
+/* Here we must cater to libcs that poke about in kernel headers. */
+
+#define NSIG		32
+typedef unsigned long sigset_t;
+
+#endif /* __KERNEL__ */
+
+#endif /* __ASSEMBLY__ */
+
+#define SIGHUP		1
+#define SIGINT		2
+#define SIGQUIT		3
+#define SIGILL		4
+#define SIGTRAP		5
+#define SIGABRT		6
+#define SIGIOT		6
+#define SIGBUS		7
+#define SIGFPE		8
+#define SIGKILL		9
+#define SIGUSR1		10
+#define SIGSEGV		11
+#define SIGUSR2		12
+#define SIGPIPE		13
+#define SIGALRM		14
+#define SIGTERM		15
+#define SIGSTKFLT	16
+#define SIGCHLD		17
+#define SIGCONT		18
+#define SIGSTOP		19
+#define SIGTSTP		20
+#define SIGTTIN		21
+#define SIGTTOU		22
+#define SIGURG		23
+#define SIGXCPU		24
+#define SIGXFSZ		25
+#define SIGVTALRM	26
+#define SIGPROF		27
+#define SIGWINCH	28
+#define SIGIO		29
+#define SIGPOLL		SIGIO
+/*
+#define SIGLOST		29
+*/
+#define SIGPWR		30
+#define SIGSYS		31
+#define	SIGUNUSED	31
+
+/* These should not be considered constants from userland. */
+#define SIGRTMIN	32
+#define SIGRTMAX	_NSIG
+
+/*
+ * SA_FLAGS values:
+ *
+ * SA_ONSTACK indicates that a registered stack_t will be used.
+ * SA_RESTART flag to get restarting signals (which were the default long ago)
+ * SA_NOCLDSTOP flag to turn off SIGCHLD when children stop.
+ * SA_RESETHAND clears the handler when the signal is delivered.
+ * SA_NOCLDWAIT flag on SIGCHLD to inhibit zombies.
+ * SA_NODEFER prevents the current signal from being masked in the handler.
+ *
+ * SA_ONESHOT and SA_NOMASK are the historical Linux names for the Single
+ * Unix names RESETHAND and NODEFER respectively.
+ */
+#define SA_NOCLDSTOP	0x00000001
+#define SA_NOCLDWAIT	0x00000002
+#define SA_SIGINFO	0x00000004
+#define SA_ONSTACK	0x08000000
+#define SA_RESTART	0x10000000
+#define SA_NODEFER	0x40000000
+#define SA_RESETHAND	0x80000000
+
+#define SA_NOMASK	SA_NODEFER
+#define SA_ONESHOT	SA_RESETHAND
+
+#define SA_RESTORER	0x04000000
+
+/*
+ * sigaltstack controls
+ */
+#define SS_ONSTACK	1
+#define SS_DISABLE	2
+
+#define MINSIGSTKSZ	2048
+#define SIGSTKSZ	8192
+
+#ifndef __ASSEMBLY__
+#include <asm-generic/signal.h>
+
+#ifdef __KERNEL__
+
+struct old_sigaction {
+	__sighandler_t sa_handler;
+	old_sigset_t sa_mask;
+	unsigned long sa_flags;
+	void (*sa_restorer)(void);
+};
+
+struct sigaction {
+	__sighandler_t sa_handler;
+	unsigned long sa_flags;
+	void (*sa_restorer)(void);
+	sigset_t sa_mask; /* mask last for extensibility */
+};
+
+struct k_sigaction {
+	struct sigaction sa;
+};
+
+#else /* !__KERNEL__ */
+
+/* Here we must cater to libcs that poke about in kernel headers. */
+
+struct sigaction {
+	union {
+	__sighandler_t _sa_handler;
+	void (*_sa_sigaction)(int, struct siginfo *, void *);
+	} _u;
+	sigset_t sa_mask;
+	unsigned long sa_flags;
+	void (*sa_restorer)(void);
+};
+
+#define sa_handler	_u._sa_handler
+#define sa_sigaction	_u._sa_sigaction
+
+#endif /* __KERNEL__ */
+
+
+typedef struct sigaltstack {
+	void *ss_sp;
+	int ss_flags;
+	size_t ss_size;
+} stack_t;
+
+#ifdef __KERNEL__
+
+#include <asm/sigcontext.h>
+#undef __HAVE_ARCH_SIG_BITOPS
+
+#define ptrace_signal_deliver(regs, cookie) do { } while (0)
+
+#endif /* __KERNEL__ */
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_MICROBLAZE_SIGNAL_H */
-- 
1.5.4.GIT

