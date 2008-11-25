Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYKYCVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYKYCVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 21:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYKYCVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 21:21:39 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:55126 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbYKYCVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 21:21:38 -0500
Message-ID: <492B6131.7070902@ct.jp.nec.com>
Date: Mon, 24 Nov 2008 18:21:37 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: signal: move {setup|restore}_sigcontext()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Move {setup|restore}_sigcontext() declaration onto head of file.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |  271 ++++++++++++++++++++++---------------------
 arch/x86/kernel/signal_64.c |  148 ++++++++++++------------
 2 files changed, 210 insertions(+), 209 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index f7dd6c4..b3f30d2 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -70,6 +70,142 @@ static const struct {
 	0
 };
 
+#define COPY(x)			{		\
+	err |= __get_user(regs->x, &sc->x);	\
+}
+
+#define COPY_SEG(seg)		{			\
+		unsigned short tmp;			\
+		err |= __get_user(tmp, &sc->seg);	\
+		regs->seg = tmp;			\
+}
+
+#define COPY_SEG_CPL3(seg)	{			\
+		unsigned short tmp;			\
+		err |= __get_user(tmp, &sc->seg);	\
+		regs->seg = tmp | 3;			\
+}
+
+#define GET_SEG(seg)		{			\
+		unsigned short tmp;			\
+		err |= __get_user(tmp, &sc->seg);	\
+		loadsegment(seg, tmp);			\
+}
+
+static int
+restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
+		   unsigned long *pax)
+{
+	void __user *buf;
+	unsigned int tmpflags;
+	unsigned int err = 0;
+
+	/* Always make any pending restarted system calls return -EINTR */
+	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+
+#ifdef CONFIG_X86_32
+	GET_SEG(gs);
+	COPY_SEG(fs);
+	COPY_SEG(es);
+	COPY_SEG(ds);
+#endif /* CONFIG_X86_32 */
+
+	COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
+	COPY(dx); COPY(cx); COPY(ip);
+
+#ifdef CONFIG_X86_64
+	COPY(r8);
+	COPY(r9);
+	COPY(r10);
+	COPY(r11);
+	COPY(r12);
+	COPY(r13);
+	COPY(r14);
+	COPY(r15);
+#endif /* CONFIG_X86_64 */
+
+#ifdef CONFIG_X86_32
+	COPY_SEG_CPL3(cs);
+	COPY_SEG_CPL3(ss);
+#else /* !CONFIG_X86_32 */
+	/* Kernel saves and restores only the CS segment register on signals,
+	 * which is the bare minimum needed to allow mixed 32/64-bit code.
+	 * App's signal handler can save/restore other segments if needed. */
+	COPY_SEG_CPL3(cs);
+#endif /* CONFIG_X86_32 */
+
+	err |= __get_user(tmpflags, &sc->flags);
+	regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
+	regs->orig_ax = -1;		/* disable syscall checks */
+
+	err |= __get_user(buf, &sc->fpstate);
+	err |= restore_i387_xstate(buf);
+
+	err |= __get_user(*pax, &sc->ax);
+	return err;
+}
+
+static int
+setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
+		 struct pt_regs *regs, unsigned long mask)
+{
+	int err = 0;
+
+#ifdef CONFIG_X86_32
+	{
+		unsigned int tmp;
+
+		savesegment(gs, tmp);
+		err |= __put_user(tmp, (unsigned int __user *)&sc->gs);
+	}
+	err |= __put_user(regs->fs, (unsigned int __user *)&sc->fs);
+	err |= __put_user(regs->es, (unsigned int __user *)&sc->es);
+	err |= __put_user(regs->ds, (unsigned int __user *)&sc->ds);
+#endif /* CONFIG_X86_32 */
+
+	err |= __put_user(regs->di, &sc->di);
+	err |= __put_user(regs->si, &sc->si);
+	err |= __put_user(regs->bp, &sc->bp);
+	err |= __put_user(regs->sp, &sc->sp);
+	err |= __put_user(regs->bx, &sc->bx);
+	err |= __put_user(regs->dx, &sc->dx);
+	err |= __put_user(regs->cx, &sc->cx);
+	err |= __put_user(regs->ax, &sc->ax);
+#ifdef CONFIG_X86_64
+	err |= __put_user(regs->r8, &sc->r8);
+	err |= __put_user(regs->r9, &sc->r9);
+	err |= __put_user(regs->r10, &sc->r10);
+	err |= __put_user(regs->r11, &sc->r11);
+	err |= __put_user(regs->r12, &sc->r12);
+	err |= __put_user(regs->r13, &sc->r13);
+	err |= __put_user(regs->r14, &sc->r14);
+	err |= __put_user(regs->r15, &sc->r15);
+#endif /* CONFIG_X86_64 */
+
+	err |= __put_user(current->thread.trap_no, &sc->trapno);
+	err |= __put_user(current->thread.error_code, &sc->err);
+	err |= __put_user(regs->ip, &sc->ip);
+#ifdef CONFIG_X86_32
+	err |= __put_user(regs->cs, (unsigned int __user *)&sc->cs);
+	err |= __put_user(regs->flags, &sc->flags);
+	err |= __put_user(regs->sp, &sc->sp_at_signal);
+	err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);
+#else /* !CONFIG_X86_32 */
+	err |= __put_user(regs->flags, &sc->flags);
+	err |= __put_user(regs->cs, &sc->cs);
+	err |= __put_user(0, &sc->gs);
+	err |= __put_user(0, &sc->fs);
+#endif /* CONFIG_X86_32 */
+
+	err |= __put_user(fpstate, &sc->fpstate);
+
+	/* non-iBCS2 extensions.. */
+	err |= __put_user(mask, &sc->oldmask);
+	err |= __put_user(current->thread.cr2, &sc->cr2);
+
+	return err;
+}
+
 /*
  * Atomically swap in the new signal mask, and wait for a signal.
  */
@@ -147,84 +283,9 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 }
 #endif /* CONFIG_X86_32 */
 
-#define COPY(x)			{		\
-	err |= __get_user(regs->x, &sc->x);	\
-}
-
-#define COPY_SEG(seg)		{			\
-		unsigned short tmp;			\
-		err |= __get_user(tmp, &sc->seg);	\
-		regs->seg = tmp;			\
-}
-
-#define COPY_SEG_CPL3(seg)	{			\
-		unsigned short tmp;			\
-		err |= __get_user(tmp, &sc->seg);	\
-		regs->seg = tmp | 3;			\
-}
-
-#define GET_SEG(seg)		{			\
-		unsigned short tmp;			\
-		err |= __get_user(tmp, &sc->seg);	\
-		loadsegment(seg, tmp);			\
-}
-
 /*
  * Do a signal return; undo the signal stack.
  */
-static int
-restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
-		   unsigned long *pax)
-{
-	void __user *buf;
-	unsigned int tmpflags;
-	unsigned int err = 0;
-
-	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
-
-#ifdef CONFIG_X86_32
-	GET_SEG(gs);
-	COPY_SEG(fs);
-	COPY_SEG(es);
-	COPY_SEG(ds);
-#endif /* CONFIG_X86_32 */
-
-	COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
-	COPY(dx); COPY(cx); COPY(ip);
-
-#ifdef CONFIG_X86_64
-	COPY(r8);
-	COPY(r9);
-	COPY(r10);
-	COPY(r11);
-	COPY(r12);
-	COPY(r13);
-	COPY(r14);
-	COPY(r15);
-#endif /* CONFIG_X86_64 */
-
-#ifdef CONFIG_X86_32
-	COPY_SEG_CPL3(cs);
-	COPY_SEG_CPL3(ss);
-#else /* !CONFIG_X86_32 */
-	/* Kernel saves and restores only the CS segment register on signals,
-	 * which is the bare minimum needed to allow mixed 32/64-bit code.
-	 * App's signal handler can save/restore other segments if needed. */
-	COPY_SEG_CPL3(cs);
-#endif /* CONFIG_X86_32 */
-
-	err |= __get_user(tmpflags, &sc->flags);
-	regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
-	regs->orig_ax = -1;		/* disable syscall checks */
-
-	err |= __get_user(buf, &sc->fpstate);
-	err |= restore_i387_xstate(buf);
-
-	err |= __get_user(*pax, &sc->ax);
-	return err;
-}
-
 asmlinkage unsigned long sys_sigreturn(unsigned long __unused)
 {
 	struct sigframe __user *frame;
@@ -316,66 +377,6 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 /*
  * Set up a signal frame.
  */
-static int
-setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
-		 struct pt_regs *regs, unsigned long mask)
-{
-	int err = 0;
-
-#ifdef CONFIG_X86_32
-	{
-		unsigned int tmp;
-
-		savesegment(gs, tmp);
-		err |= __put_user(tmp, (unsigned int __user *)&sc->gs);
-	}
-	err |= __put_user(regs->fs, (unsigned int __user *)&sc->fs);
-	err |= __put_user(regs->es, (unsigned int __user *)&sc->es);
-	err |= __put_user(regs->ds, (unsigned int __user *)&sc->ds);
-#endif /* CONFIG_X86_32 */
-
-	err |= __put_user(regs->di, &sc->di);
-	err |= __put_user(regs->si, &sc->si);
-	err |= __put_user(regs->bp, &sc->bp);
-	err |= __put_user(regs->sp, &sc->sp);
-	err |= __put_user(regs->bx, &sc->bx);
-	err |= __put_user(regs->dx, &sc->dx);
-	err |= __put_user(regs->cx, &sc->cx);
-	err |= __put_user(regs->ax, &sc->ax);
-#ifdef CONFIG_X86_64
-	err |= __put_user(regs->r8, &sc->r8);
-	err |= __put_user(regs->r9, &sc->r9);
-	err |= __put_user(regs->r10, &sc->r10);
-	err |= __put_user(regs->r11, &sc->r11);
-	err |= __put_user(regs->r12, &sc->r12);
-	err |= __put_user(regs->r13, &sc->r13);
-	err |= __put_user(regs->r14, &sc->r14);
-	err |= __put_user(regs->r15, &sc->r15);
-#endif /* CONFIG_X86_64 */
-
-	err |= __put_user(current->thread.trap_no, &sc->trapno);
-	err |= __put_user(current->thread.error_code, &sc->err);
-	err |= __put_user(regs->ip, &sc->ip);
-#ifdef CONFIG_X86_32
-	err |= __put_user(regs->cs, (unsigned int __user *)&sc->cs);
-	err |= __put_user(regs->flags, &sc->flags);
-	err |= __put_user(regs->sp, &sc->sp_at_signal);
-	err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);
-#else /* !CONFIG_X86_32 */
-	err |= __put_user(regs->flags, &sc->flags);
-	err |= __put_user(regs->cs, &sc->cs);
-	err |= __put_user(0, &sc->gs);
-	err |= __put_user(0, &sc->fs);
-#endif /* CONFIG_X86_32 */
-
-	err |= __put_user(fpstate, &sc->fpstate);
-
-	/* non-iBCS2 extensions.. */
-	err |= __put_user(mask, &sc->oldmask);
-	err |= __put_user(current->thread.cr2, &sc->cr2);
-
-	return err;
-}
 
 /*
  * Determine which stack to use..
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 32718f5..771c8fc 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -50,28 +50,6 @@
 # define FIX_EFLAGS	__FIX_EFLAGS
 #endif
 
-#ifdef CONFIG_X86_32
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
 #define COPY(x)			{		\
 	err |= __get_user(regs->x, &sc->x);	\
 }
@@ -82,9 +60,6 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 		regs->seg = tmp | 3;			\
 }
 
-/*
- * Do a signal return; undo the signal stack.
- */
 static int
 restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 		   unsigned long *pax)
@@ -138,54 +113,6 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	return err;
 }
 
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
-
-/*
- * Set up a signal frame.
- */
 static int
 setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 		 struct pt_regs *regs, unsigned long mask)
@@ -247,10 +174,83 @@ setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 	return err;
 }
 
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
 /*
- * Determine which stack to use..
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
+
+/*
+ * Set up a signal frame.
  */
 
+/*
+ * Determine which stack to use..
+ */
 static void __user *
 get_stack(struct k_sigaction *ka, unsigned long sp, unsigned long size)
 {
-- 
1.6.0.4

