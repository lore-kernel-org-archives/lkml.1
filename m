Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbYKYCXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbYKYCXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 21:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYKYCXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 21:23:15 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:55373 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbYKYCXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 21:23:14 -0500
Message-ID: <492B6190.103@ct.jp.nec.com>
Date: Mon, 24 Nov 2008 18:23:12 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: signal: cosmetic unification of __setup_sigframe()
 and __setup_rt_sigframe()
References: <492B6131.7070902@ct.jp.nec.com>
In-Reply-To: <492B6131.7070902@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [PATCH] 

Impact: cleanup

Add #ifdef directive to unify __setup_sigframe() and __setup_rt_sigframe().
Move them after {setup|restore}_sigcontext() declaration.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |  469 ++++++++++++++++++++++++++-----------------
 arch/x86/kernel/signal_64.c |  309 +++++++++++++++++++++++-----
 2 files changed, 536 insertions(+), 242 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index b3f30d2..e9f7129 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -48,28 +48,6 @@
 # define FIX_EFLAGS	__FIX_EFLAGS
 #endif
 
-static const struct {
-	u16 poplmovl;
-	u32 val;
-	u16 int80;
-} __attribute__((packed)) retcode = {
-	0xb858,		/* popl %eax; movl $..., %eax */
-	__NR_sigreturn,
-	0x80cd,		/* int $0x80 */
-};
-
-static const struct {
-	u8  movl;
-	u32 val;
-	u16 int80;
-	u8  pad;
-} __attribute__((packed)) rt_retcode = {
-	0xb8,		/* movl $..., %eax */
-	__NR_rt_sigreturn,
-	0x80cd,		/* int $0x80 */
-	0
-};
-
 #define COPY(x)			{		\
 	err |= __get_user(regs->x, &sc->x);	\
 }
@@ -207,176 +185,30 @@ setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 }
 
 /*
- * Atomically swap in the new signal mask, and wait for a signal.
+ * Set up a signal frame.
  */
-asmlinkage int
-sys_sigsuspend(int history0, int history1, old_sigset_t mask)
-{
-	mask &= _BLOCKABLE;
-	spin_lock_irq(&current->sighand->siglock);
-	current->saved_sigmask = current->blocked;
-	siginitset(&current->blocked, mask);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	current->state = TASK_INTERRUPTIBLE;
-	schedule();
-	set_restore_sigmask();
-
-	return -ERESTARTNOHAND;
-}
-
-asmlinkage int
-sys_sigaction(int sig, const struct old_sigaction __user *act,
-	      struct old_sigaction __user *oact)
-{
-	struct k_sigaction new_ka, old_ka;
-	int ret;
-
-	if (act) {
-		old_sigset_t mask;
-
-		if (!access_ok(VERIFY_READ, act, sizeof(*act)) ||
-		    __get_user(new_ka.sa.sa_handler, &act->sa_handler) ||
-		    __get_user(new_ka.sa.sa_restorer, &act->sa_restorer))
-			return -EFAULT;
-
-		__get_user(new_ka.sa.sa_flags, &act->sa_flags);
-		__get_user(mask, &act->sa_mask);
-		siginitset(&new_ka.sa.sa_mask, mask);
-	}
-
-	ret = do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
-
-	if (!ret && oact) {
-		if (!access_ok(VERIFY_WRITE, oact, sizeof(*oact)) ||
-		    __put_user(old_ka.sa.sa_handler, &oact->sa_handler) ||
-		    __put_user(old_ka.sa.sa_restorer, &oact->sa_restorer))
-			return -EFAULT;
-
-		__put_user(old_ka.sa.sa_flags, &oact->sa_flags);
-		__put_user(old_ka.sa.sa_mask.sig[0], &oact->sa_mask);
-	}
-
-	return ret;
-}
-
 #ifdef CONFIG_X86_32
-asmlinkage int sys_sigaltstack(unsigned long bx)
-{
-	/*
-	 * This is needed to make gcc realize it doesn't own the
-	 * "struct pt_regs"
-	 */
-	struct pt_regs *regs = (struct pt_regs *)&bx;
-	const stack_t __user *uss = (const stack_t __user *)bx;
-	stack_t __user *uoss = (stack_t __user *)regs->cx;
-
-	return do_sigaltstack(uss, uoss, regs->sp);
-}
-#else /* !CONFIG_X86_32 */
-asmlinkage long
-sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
-		struct pt_regs *regs)
-{
-	return do_sigaltstack(uss, uoss, regs->sp);
-}
-#endif /* CONFIG_X86_32 */
-
-/*
- * Do a signal return; undo the signal stack.
- */
-asmlinkage unsigned long sys_sigreturn(unsigned long __unused)
-{
-	struct sigframe __user *frame;
-	struct pt_regs *regs;
-	unsigned long ax;
-	sigset_t set;
-
-	regs = (struct pt_regs *) &__unused;
-	frame = (struct sigframe __user *)(regs->sp - 8);
-
-	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
-		goto badframe;
-	if (__get_user(set.sig[0], &frame->sc.oldmask) || (_NSIG_WORDS > 1
-		&& __copy_from_user(&set.sig[1], &frame->extramask,
-				    sizeof(frame->extramask))))
-		goto badframe;
-
-	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	if (restore_sigcontext(regs, &frame->sc, &ax))
-		goto badframe;
-	return ax;
-
-badframe:
-	if (show_unhandled_signals && printk_ratelimit()) {
-		printk("%s%s[%d] bad frame in sigreturn frame:"
-			"%p ip:%lx sp:%lx oeax:%lx",
-		    task_pid_nr(current) > 1 ? KERN_INFO : KERN_EMERG,
-		    current->comm, task_pid_nr(current), frame, regs->ip,
-		    regs->sp, regs->orig_ax);
-		print_vma_addr(" in ", regs->ip);
-		printk(KERN_CONT "\n");
-	}
-
-	force_sig(SIGSEGV, current);
-
-	return 0;
-}
-
-static long do_rt_sigreturn(struct pt_regs *regs)
-{
-	struct rt_sigframe __user *frame;
-	unsigned long ax;
-	sigset_t set;
-
-	frame = (struct rt_sigframe __user *)(regs->sp - sizeof(long));
-	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
-		goto badframe;
-	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
-		goto badframe;
-
-	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
-		goto badframe;
-
-	if (do_sigaltstack(&frame->uc.uc_stack, NULL, regs->sp) == -EFAULT)
-		goto badframe;
-
-	return ax;
-
-badframe:
-	signal_fault(regs, frame, "rt_sigreturn");
-	return 0;
-}
-
-#ifdef CONFIG_X86_32
-asmlinkage int sys_rt_sigreturn(unsigned long __unused)
-{
-	struct pt_regs *regs = (struct pt_regs *)&__unused;
-
-	return do_rt_sigreturn(regs);
-}
-#else /* !CONFIG_X86_32 */
-asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
-{
-	return do_rt_sigreturn(regs);
-}
-#endif /* CONFIG_X86_32 */
+static const struct {
+	u16 poplmovl;
+	u32 val;
+	u16 int80;
+} __attribute__((packed)) retcode = {
+	0xb858,		/* popl %eax; movl $..., %eax */
+	__NR_sigreturn,
+	0x80cd,		/* int $0x80 */
+};
 
-/*
- * Set up a signal frame.
- */
+static const struct {
+	u8  movl;
+	u32 val;
+	u16 int80;
+	u8  pad;
+} __attribute__((packed)) rt_retcode = {
+	0xb8,		/* movl $..., %eax */
+	__NR_rt_sigreturn,
+	0x80cd,		/* int $0x80 */
+	0
+};
 
 /*
  * Determine which stack to use..
@@ -557,6 +389,265 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	return 0;
 }
+#else /* !CONFIG_X86_32 */
+/*
+ * Determine which stack to use..
+ */
+static void __user *
+get_stack(struct k_sigaction *ka, unsigned long sp, unsigned long size)
+{
+	/* Default to using normal stack - redzone*/
+	sp -= 128;
+
+	/* This is the X/Open sanctioned signal stack switching.  */
+	if (ka->sa.sa_flags & SA_ONSTACK) {
+		if (sas_ss_flags(sp) == 0)
+			sp = current->sas_ss_sp + current->sas_ss_size;
+	}
+
+	return (void __user *)round_down(sp - size, 64);
+}
+
+static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+			    sigset_t *set, struct pt_regs *regs)
+{
+	struct rt_sigframe __user *frame;
+	void __user *fp = NULL;
+	int err = 0;
+	struct task_struct *me = current;
+
+	if (used_math()) {
+		fp = get_stack(ka, regs->sp, sig_xstate_size);
+		frame = (void __user *)round_down(
+			(unsigned long)fp - sizeof(struct rt_sigframe), 16) - 8;
+
+		if (save_i387_xstate(fp) < 0)
+			return -EFAULT;
+	} else
+		frame = get_stack(ka, regs->sp, sizeof(struct rt_sigframe)) - 8;
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		return -EFAULT;
+
+	if (ka->sa.sa_flags & SA_SIGINFO) {
+		if (copy_siginfo_to_user(&frame->info, info))
+			return -EFAULT;
+	}
+
+	/* Create the ucontext.  */
+	if (cpu_has_xsave)
+		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
+	else
+		err |= __put_user(0, &frame->uc.uc_flags);
+	err |= __put_user(0, &frame->uc.uc_link);
+	err |= __put_user(me->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
+	err |= __put_user(sas_ss_flags(regs->sp),
+			  &frame->uc.uc_stack.ss_flags);
+	err |= __put_user(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
+	err |= setup_sigcontext(&frame->uc.uc_mcontext, fp, regs, set->sig[0]);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
+	/* Set up to return from userspace.  If provided, use a stub
+	   already in userspace.  */
+	/* x86-64 should always use SA_RESTORER. */
+	if (ka->sa.sa_flags & SA_RESTORER) {
+		err |= __put_user(ka->sa.sa_restorer, &frame->pretcode);
+	} else {
+		/* could use a vstub here */
+		return -EFAULT;
+	}
+
+	if (err)
+		return -EFAULT;
+
+	/* Set up registers for signal handler */
+	regs->di = sig;
+	/* In case the signal handler was declared without prototypes */
+	regs->ax = 0;
+
+	/* This also works for non SA_SIGINFO handlers because they expect the
+	   next argument after the signal number on the stack. */
+	regs->si = (unsigned long)&frame->info;
+	regs->dx = (unsigned long)&frame->uc;
+	regs->ip = (unsigned long) ka->sa.sa_handler;
+
+	regs->sp = (unsigned long)frame;
+
+	/* Set up the CS register to run signal handlers in 64-bit mode,
+	   even if the handler happens to be interrupting 32-bit code. */
+	regs->cs = __USER_CS;
+
+	return 0;
+}
+#endif /* CONFIG_X86_32 */
+
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
+
+#ifdef CONFIG_X86_32
+asmlinkage int sys_sigaltstack(unsigned long bx)
+{
+	/*
+	 * This is needed to make gcc realize it doesn't own the
+	 * "struct pt_regs"
+	 */
+	struct pt_regs *regs = (struct pt_regs *)&bx;
+	const stack_t __user *uss = (const stack_t __user *)bx;
+	stack_t __user *uoss = (stack_t __user *)regs->cx;
+
+	return do_sigaltstack(uss, uoss, regs->sp);
+}
+#else /* !CONFIG_X86_32 */
+asmlinkage long
+sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
+		struct pt_regs *regs)
+{
+	return do_sigaltstack(uss, uoss, regs->sp);
+}
+#endif /* CONFIG_X86_32 */
+
+/*
+ * Do a signal return; undo the signal stack.
+ */
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
+
+static long do_rt_sigreturn(struct pt_regs *regs)
+{
+	struct rt_sigframe __user *frame;
+	unsigned long ax;
+	sigset_t set;
+
+	frame = (struct rt_sigframe __user *)(regs->sp - sizeof(long));
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
+		goto badframe;
+
+	sigdelsetmask(&set, ~_BLOCKABLE);
+	spin_lock_irq(&current->sighand->siglock);
+	current->blocked = set;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
+		goto badframe;
+
+	if (do_sigaltstack(&frame->uc.uc_stack, NULL, regs->sp) == -EFAULT)
+		goto badframe;
+
+	return ax;
+
+badframe:
+	signal_fault(regs, frame, "rt_sigreturn");
+	return 0;
+}
+
+#ifdef CONFIG_X86_32
+asmlinkage int sys_rt_sigreturn(unsigned long __unused)
+{
+	struct pt_regs *regs = (struct pt_regs *)&__unused;
+
+	return do_rt_sigreturn(regs);
+}
+#else /* !CONFIG_X86_32 */
+asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
+{
+	return do_rt_sigreturn(regs);
+}
+#endif /* CONFIG_X86_32 */
 
 /*
  * OK, we're invoking a handler:
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 771c8fc..2da7e6e 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -174,80 +174,212 @@ setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 	return err;
 }
 
+/*
+ * Set up a signal frame.
+ */
 #ifdef CONFIG_X86_32
-asmlinkage int sys_sigaltstack(unsigned long bx)
+static const struct {
+	u16 poplmovl;
+	u32 val;
+	u16 int80;
+} __attribute__((packed)) retcode = {
+	0xb858,		/* popl %eax; movl $..., %eax */
+	__NR_sigreturn,
+	0x80cd,		/* int $0x80 */
+};
+
+static const struct {
+	u8  movl;
+	u32 val;
+	u16 int80;
+	u8  pad;
+} __attribute__((packed)) rt_retcode = {
+	0xb8,		/* movl $..., %eax */
+	__NR_rt_sigreturn,
+	0x80cd,		/* int $0x80 */
+	0
+};
+
+/*
+ * Determine which stack to use..
+ */
+static inline void __user *
+get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
+	     void **fpstate)
 {
+	unsigned long sp;
+
+	/* Default to using normal stack */
+	sp = regs->sp;
+
 	/*
-	 * This is needed to make gcc realize it doesn't own the
-	 * "struct pt_regs"
+	 * If we are on the alternate signal stack and would overflow it, don't.
+	 * Return an always-bogus address instead so we will die with SIGSEGV.
 	 */
-	struct pt_regs *regs = (struct pt_regs *)&bx;
-	const stack_t __user *uss = (const stack_t __user *)bx;
-	stack_t __user *uoss = (stack_t __user *)regs->cx;
+	if (on_sig_stack(sp) && !likely(on_sig_stack(sp - frame_size)))
+		return (void __user *) -1L;
 
-	return do_sigaltstack(uss, uoss, regs->sp);
-}
-#else /* !CONFIG_X86_32 */
-asmlinkage long
-sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
-		struct pt_regs *regs)
-{
-	return do_sigaltstack(uss, uoss, regs->sp);
+	/* This is the X/Open sanctioned signal stack switching.  */
+	if (ka->sa.sa_flags & SA_ONSTACK) {
+		if (sas_ss_flags(sp) == 0)
+			sp = current->sas_ss_sp + current->sas_ss_size;
+	} else {
+		/* This is the legacy signal stack switching. */
+		if ((regs->ss & 0xffff) != __USER_DS &&
+			!(ka->sa.sa_flags & SA_RESTORER) &&
+				ka->sa.sa_restorer)
+			sp = (unsigned long) ka->sa.sa_restorer;
+	}
+
+	if (used_math()) {
+		sp = sp - sig_xstate_size;
+		*fpstate = (struct _fpstate *) sp;
+		if (save_i387_xstate(*fpstate) < 0)
+			return (void __user *)-1L;
+	}
+
+	sp -= frame_size;
+	/*
+	 * Align the stack pointer according to the i386 ABI,
+	 * i.e. so that on function entry ((sp + 4) & 15) == 0.
+	 */
+	sp = ((sp + 4) & -16ul) - 4;
+
+	return (void __user *) sp;
 }
-#endif /* CONFIG_X86_32 */
 
-/*
- * Do a signal return; undo the signal stack.
- */
-static long do_rt_sigreturn(struct pt_regs *regs)
+static int
+__setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
+	      struct pt_regs *regs)
 {
-	struct rt_sigframe __user *frame;
-	unsigned long ax;
-	sigset_t set;
+	struct sigframe __user *frame;
+	void __user *restorer;
+	int err = 0;
+	void __user *fpstate = NULL;
 
-	frame = (struct rt_sigframe __user *)(regs->sp - sizeof(long));
-	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
-		goto badframe;
-	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
-		goto badframe;
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
-	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		return -EFAULT;
 
-	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
-		goto badframe;
+	if (__put_user(sig, &frame->sig))
+		return -EFAULT;
 
-	if (do_sigaltstack(&frame->uc.uc_stack, NULL, regs->sp) == -EFAULT)
-		goto badframe;
+	if (setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]))
+		return -EFAULT;
 
-	return ax;
+	if (_NSIG_WORDS > 1) {
+		if (__copy_to_user(&frame->extramask, &set->sig[1],
+				   sizeof(frame->extramask)))
+			return -EFAULT;
+	}
+
+	if (current->mm->context.vdso)
+		restorer = VDSO32_SYMBOL(current->mm->context.vdso, sigreturn);
+	else
+		restorer = &frame->retcode;
+	if (ka->sa.sa_flags & SA_RESTORER)
+		restorer = ka->sa.sa_restorer;
+
+	/* Set up to return from userspace.  */
+	err |= __put_user(restorer, &frame->pretcode);
+
+	/*
+	 * This is popl %eax ; movl $__NR_sigreturn, %eax ; int $0x80
+	 *
+	 * WE DO NOT USE IT ANY MORE! It's only left here for historical
+	 * reasons and because gdb uses it as a signature to notice
+	 * signal handler stack frames.
+	 */
+	err |= __put_user(*((u64 *)&retcode), (u64 *)frame->retcode);
+
+	if (err)
+		return -EFAULT;
+
+	/* Set up registers for signal handler */
+	regs->sp = (unsigned long)frame;
+	regs->ip = (unsigned long)ka->sa.sa_handler;
+	regs->ax = (unsigned long)sig;
+	regs->dx = 0;
+	regs->cx = 0;
+
+	regs->ds = __USER_DS;
+	regs->es = __USER_DS;
+	regs->ss = __USER_DS;
+	regs->cs = __USER_CS;
 
-badframe:
-	signal_fault(regs, frame, "rt_sigreturn");
 	return 0;
 }
 
-#ifdef CONFIG_X86_32
-asmlinkage int sys_rt_sigreturn(unsigned long __unused)
+static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+			    sigset_t *set, struct pt_regs *regs)
 {
-	struct pt_regs *regs = (struct pt_regs *)&__unused;
+	struct rt_sigframe __user *frame;
+	void __user *restorer;
+	int err = 0;
+	void __user *fpstate = NULL;
 
-	return do_rt_sigreturn(regs);
-}
-#else /* !CONFIG_X86_32 */
-asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
-{
-	return do_rt_sigreturn(regs);
-}
-#endif /* CONFIG_X86_32 */
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
-/*
- * Set up a signal frame.
- */
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		return -EFAULT;
+
+	err |= __put_user(sig, &frame->sig);
+	err |= __put_user(&frame->info, &frame->pinfo);
+	err |= __put_user(&frame->uc, &frame->puc);
+	err |= copy_siginfo_to_user(&frame->info, info);
+	if (err)
+		return -EFAULT;
+
+	/* Create the ucontext.  */
+	if (cpu_has_xsave)
+		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
+	else
+		err |= __put_user(0, &frame->uc.uc_flags);
+	err |= __put_user(0, &frame->uc.uc_link);
+	err |= __put_user(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
+	err |= __put_user(sas_ss_flags(regs->sp),
+			  &frame->uc.uc_stack.ss_flags);
+	err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
+	err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
+				regs, set->sig[0]);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+	if (err)
+		return -EFAULT;
+
+	/* Set up to return from userspace.  */
+	restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
+	if (ka->sa.sa_flags & SA_RESTORER)
+		restorer = ka->sa.sa_restorer;
+	err |= __put_user(restorer, &frame->pretcode);
+
+	/*
+	 * This is movl $__NR_rt_sigreturn, %ax ; int $0x80
+	 *
+	 * WE DO NOT USE IT ANY MORE! It's only left here for historical
+	 * reasons and because gdb uses it as a signature to notice
+	 * signal handler stack frames.
+	 */
+	err |= __put_user(*((u64 *)&rt_retcode), (u64 *)frame->retcode);
 
+	if (err)
+		return -EFAULT;
+
+	/* Set up registers for signal handler */
+	regs->sp = (unsigned long)frame;
+	regs->ip = (unsigned long)ka->sa.sa_handler;
+	regs->ax = (unsigned long)sig;
+	regs->dx = (unsigned long)&frame->info;
+	regs->cx = (unsigned long)&frame->uc;
+
+	regs->ds = __USER_DS;
+	regs->es = __USER_DS;
+	regs->ss = __USER_DS;
+	regs->cs = __USER_CS;
+
+	return 0;
+}
+#else /* !CONFIG_X86_32 */
 /*
  * Determine which stack to use..
  */
@@ -337,6 +469,77 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	return 0;
 }
+#endif /* CONFIG_X86_32 */
+
+#ifdef CONFIG_X86_32
+asmlinkage int sys_sigaltstack(unsigned long bx)
+{
+	/*
+	 * This is needed to make gcc realize it doesn't own the
+	 * "struct pt_regs"
+	 */
+	struct pt_regs *regs = (struct pt_regs *)&bx;
+	const stack_t __user *uss = (const stack_t __user *)bx;
+	stack_t __user *uoss = (stack_t __user *)regs->cx;
+
+	return do_sigaltstack(uss, uoss, regs->sp);
+}
+#else /* !CONFIG_X86_32 */
+asmlinkage long
+sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
+		struct pt_regs *regs)
+{
+	return do_sigaltstack(uss, uoss, regs->sp);
+}
+#endif /* CONFIG_X86_32 */
+
+/*
+ * Do a signal return; undo the signal stack.
+ */
+static long do_rt_sigreturn(struct pt_regs *regs)
+{
+	struct rt_sigframe __user *frame;
+	unsigned long ax;
+	sigset_t set;
+
+	frame = (struct rt_sigframe __user *)(regs->sp - sizeof(long));
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
+		goto badframe;
+
+	sigdelsetmask(&set, ~_BLOCKABLE);
+	spin_lock_irq(&current->sighand->siglock);
+	current->blocked = set;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
+		goto badframe;
+
+	if (do_sigaltstack(&frame->uc.uc_stack, NULL, regs->sp) == -EFAULT)
+		goto badframe;
+
+	return ax;
+
+badframe:
+	signal_fault(regs, frame, "rt_sigreturn");
+	return 0;
+}
+
+#ifdef CONFIG_X86_32
+asmlinkage int sys_rt_sigreturn(unsigned long __unused)
+{
+	struct pt_regs *regs = (struct pt_regs *)&__unused;
+
+	return do_rt_sigreturn(regs);
+}
+#else /* !CONFIG_X86_32 */
+asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
+{
+	return do_rt_sigreturn(regs);
+}
+#endif /* CONFIG_X86_32 */
 
 /*
  * OK, we're invoking a handler
-- 
1.6.0.4

