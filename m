Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbYKZEPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbYKZEPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 23:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYKZEOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 23:14:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59634 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbYKZEOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 23:14:55 -0500
Date: Wed, 26 Nov 2008 05:14:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: signal: unify signal_{32|64}.c
Message-ID: <20081126041438.GB9732@elte.hu>
References: <492B6131.7070902@ct.jp.nec.com> <492B61CB.7030808@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492B61CB.7030808@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Impact: cleanup
> 
> Add #ifdef directive for 32-bit only code and unify signal_{32|64}.c
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/kernel/Makefile    |    2 +-
>  arch/x86/kernel/signal.c    |  915 +++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/signal_32.c |  909 ------------------------------------------
>  arch/x86/kernel/signal_64.c |  801 -------------------------------------
>  4 files changed, 916 insertions(+), 1711 deletions(-)
>  create mode 100644 arch/x86/kernel/signal.c
>  delete mode 100644 arch/x86/kernel/signal_32.c
>  delete mode 100644 arch/x86/kernel/signal_64.c

yay! :-)

applied to tip/x86/signal, thanks Hiroshi!

One small detail, i inserted yet another commit in the middle:

 5ceb40d: x86: signal: unify signal_{32|64}.c
 e5fa2d0: x86: signal: unify signal_{32|64}.c, prepare
 bfeb91a: x86: signal: cosmetic unification of __setup_sigframe() and __setup_rt_sigframe()
 2601657: x86: signal: move {setup|restore}_sigcontext()

the e5fa2d0 commit (see it below) contains all the non-mechanic 
modifications that you did in the final unification commit. It's best 
to keep this separate - because a big unification commit is hard to 
review and debug, should it cause any problems.

the 5ceb40d commit can thus do pure unification:

 arch/x86/kernel/signal.c    |  915 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/signal_32.c |  915 -------------------------------------------
 arch/x86/kernel/signal_64.c |  915 -------------------------------------------

... and the end result is still the same as with your series.

Thanks,

	Ingo

------------------>
>From e5fa2d063cf2ca38eae5fb3469315db669d5c041 Mon Sep 17 00:00:00 2001
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Date: Mon, 24 Nov 2008 18:24:11 -0800
Subject: [PATCH] x86: signal: unify signal_{32|64}.c, prepare

Impact: cleanup

Add #ifdef directive for 32-bit only code.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/signal_32.c |    6 ++
 arch/x86/kernel/signal_64.c |  116 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 121 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index e9f7129..b1f4d34 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -1,8 +1,10 @@
 /*
  *  Copyright (C) 1991, 1992  Linus Torvalds
+ *  Copyright (C) 2000, 2001, 2002 Andi Kleen SuSE Labs
  *
  *  1997-11-28  Modified for POSIX.1b signals by Richard Henderson
  *  2000-06-20  Pentium III FXSR, SSE support by Gareth Hughes
+ *  2000-2002   x86-64 support by Andi Kleen
  */
 
 #include <linux/sched.h>
@@ -481,6 +483,7 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 }
 #endif /* CONFIG_X86_32 */
 
+#ifdef CONFIG_X86_32
 /*
  * Atomically swap in the new signal mask, and wait for a signal.
  */
@@ -535,6 +538,7 @@ sys_sigaction(int sig, const struct old_sigaction __user *act,
 
 	return ret;
 }
+#endif /* CONFIG_X86_32 */
 
 #ifdef CONFIG_X86_32
 asmlinkage int sys_sigaltstack(unsigned long bx)
@@ -561,6 +565,7 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 /*
  * Do a signal return; undo the signal stack.
  */
+#ifdef CONFIG_X86_32
 asmlinkage unsigned long sys_sigreturn(unsigned long __unused)
 {
 	struct sigframe __user *frame;
@@ -603,6 +608,7 @@ badframe:
 
 	return 0;
 }
+#endif /* CONFIG_X86_32 */
 
 static long do_rt_sigreturn(struct pt_regs *regs)
 {
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 2da7e6e..b1f4d34 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -54,12 +54,24 @@
 	err |= __get_user(regs->x, &sc->x);	\
 }
 
+#define COPY_SEG(seg)		{			\
+		unsigned short tmp;			\
+		err |= __get_user(tmp, &sc->seg);	\
+		regs->seg = tmp;			\
+}
+
 #define COPY_SEG_CPL3(seg)	{			\
 		unsigned short tmp;			\
 		err |= __get_user(tmp, &sc->seg);	\
 		regs->seg = tmp | 3;			\
 }
 
+#define GET_SEG(seg)		{			\
+		unsigned short tmp;			\
+		err |= __get_user(tmp, &sc->seg);	\
+		loadsegment(seg, tmp);			\
+}
+
 static int
 restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 		   unsigned long *pax)
@@ -472,6 +484,63 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 #endif /* CONFIG_X86_32 */
 
 #ifdef CONFIG_X86_32
+/*
+ * Atomically swap in the new signal mask, and wait for a signal.
+ */
+asmlinkage int
+sys_sigsuspend(int history0, int history1, old_sigset_t mask)
+{
+	mask &= _BLOCKABLE;
+	spin_lock_irq(&current->sighand->siglock);
+	current->saved_sigmask = current->blocked;
+	siginitset(&current->blocked, mask);
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	current->state = TASK_INTERRUPTIBLE;
+	schedule();
+	set_restore_sigmask();
+
+	return -ERESTARTNOHAND;
+}
+
+asmlinkage int
+sys_sigaction(int sig, const struct old_sigaction __user *act,
+	      struct old_sigaction __user *oact)
+{
+	struct k_sigaction new_ka, old_ka;
+	int ret;
+
+	if (act) {
+		old_sigset_t mask;
+
+		if (!access_ok(VERIFY_READ, act, sizeof(*act)) ||
+		    __get_user(new_ka.sa.sa_handler, &act->sa_handler) ||
+		    __get_user(new_ka.sa.sa_restorer, &act->sa_restorer))
+			return -EFAULT;
+
+		__get_user(new_ka.sa.sa_flags, &act->sa_flags);
+		__get_user(mask, &act->sa_mask);
+		siginitset(&new_ka.sa.sa_mask, mask);
+	}
+
+	ret = do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
+
+	if (!ret && oact) {
+		if (!access_ok(VERIFY_WRITE, oact, sizeof(*oact)) ||
+		    __put_user(old_ka.sa.sa_handler, &oact->sa_handler) ||
+		    __put_user(old_ka.sa.sa_restorer, &oact->sa_restorer))
+			return -EFAULT;
+
+		__put_user(old_ka.sa.sa_flags, &oact->sa_flags);
+		__put_user(old_ka.sa.sa_mask.sig[0], &oact->sa_mask);
+	}
+
+	return ret;
+}
+#endif /* CONFIG_X86_32 */
+
+#ifdef CONFIG_X86_32
 asmlinkage int sys_sigaltstack(unsigned long bx)
 {
 	/*
@@ -496,6 +565,51 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 /*
  * Do a signal return; undo the signal stack.
  */
+#ifdef CONFIG_X86_32
+asmlinkage unsigned long sys_sigreturn(unsigned long __unused)
+{
+	struct sigframe __user *frame;
+	struct pt_regs *regs;
+	unsigned long ax;
+	sigset_t set;
+
+	regs = (struct pt_regs *) &__unused;
+	frame = (struct sigframe __user *)(regs->sp - 8);
+
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+	if (__get_user(set.sig[0], &frame->sc.oldmask) || (_NSIG_WORDS > 1
+		&& __copy_from_user(&set.sig[1], &frame->extramask,
+				    sizeof(frame->extramask))))
+		goto badframe;
+
+	sigdelsetmask(&set, ~_BLOCKABLE);
+	spin_lock_irq(&current->sighand->siglock);
+	current->blocked = set;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (restore_sigcontext(regs, &frame->sc, &ax))
+		goto badframe;
+	return ax;
+
+badframe:
+	if (show_unhandled_signals && printk_ratelimit()) {
+		printk("%s%s[%d] bad frame in sigreturn frame:"
+			"%p ip:%lx sp:%lx oeax:%lx",
+		    task_pid_nr(current) > 1 ? KERN_INFO : KERN_EMERG,
+		    current->comm, task_pid_nr(current), frame, regs->ip,
+		    regs->sp, regs->orig_ax);
+		print_vma_addr(" in ", regs->ip);
+		printk(KERN_CONT "\n");
+	}
+
+	force_sig(SIGSEGV, current);
+
+	return 0;
+}
+#endif /* CONFIG_X86_32 */
+
 static long do_rt_sigreturn(struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
@@ -542,7 +656,7 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 #endif /* CONFIG_X86_32 */
 
 /*
- * OK, we're invoking a handler
+ * OK, we're invoking a handler:
  */
 static int signr_convert(int sig)
 {
