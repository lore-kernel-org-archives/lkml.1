Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbZAFDJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbZAFDJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 22:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZAFDJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 22:09:35 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:35751 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbZAFDJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 22:09:34 -0500
Message-ID: <4962CB6C.7010205@ct.jp.nec.com>
Date: Mon, 05 Jan 2009 19:09:32 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC -tip 3/4] x86: signal: use __{get|put}_user_ex exception handling
 framework
References: <4962CAAE.6090300@ct.jp.nec.com>
In-Reply-To: <4962CAAE.6090300@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: use new uaccess exception handling framework

Use __{get|put}_user_ex exception handling framework.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal.c |  214 +++++++++++++++++++++++++---------------------
 1 files changed, 118 insertions(+), 96 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 4fa5243..0927549 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -51,24 +51,24 @@
 #endif
 
 #define COPY(x)			{		\
-	err |= __get_user(regs->x, &sc->x);	\
+	__get_user_ex(regs->x, &sc->x);		\
 }
 
 #define COPY_SEG(seg)		{			\
 		unsigned short tmp;			\
-		err |= __get_user(tmp, &sc->seg);	\
+		__get_user_ex(tmp, &sc->seg);		\
 		regs->seg = tmp;			\
 }
 
 #define COPY_SEG_CPL3(seg)	{			\
 		unsigned short tmp;			\
-		err |= __get_user(tmp, &sc->seg);	\
+		__get_user_ex(tmp, &sc->seg);		\
 		regs->seg = tmp | 3;			\
 }
 
 #define GET_SEG(seg)		{			\
 		unsigned short tmp;			\
-		err |= __get_user(tmp, &sc->seg);	\
+		__get_user_ex(tmp, &sc->seg);		\
 		loadsegment(seg, tmp);			\
 }
 
@@ -83,6 +83,8 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	/* Always make any pending restarted system calls return -EINTR */
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
 
+	__get_user_ex_try();
+
 #ifdef CONFIG_X86_32
 	GET_SEG(gs);
 	COPY_SEG(fs);
@@ -114,14 +116,16 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	COPY_SEG_CPL3(cs);
 #endif /* CONFIG_X86_32 */
 
-	err |= __get_user(tmpflags, &sc->flags);
+	__get_user_ex(tmpflags, &sc->flags);
 	regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
 	regs->orig_ax = -1;		/* disable syscall checks */
 
-	err |= __get_user(buf, &sc->fpstate);
+	__get_user_ex(buf, &sc->fpstate);
 	err |= restore_i387_xstate(buf);
 
-	err |= __get_user(*pax, &sc->ax);
+	__get_user_ex(*pax, &sc->ax);
+
+	__get_user_ex_catch(&err);
 	return err;
 }
 
@@ -131,57 +135,61 @@ setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 {
 	int err = 0;
 
+	__put_user_ex_try();
+
 #ifdef CONFIG_X86_32
 	{
 		unsigned int tmp;
 
 		savesegment(gs, tmp);
-		err |= __put_user(tmp, (unsigned int __user *)&sc->gs);
+		__put_user_ex(tmp, (unsigned int __user *)&sc->gs);
 	}
-	err |= __put_user(regs->fs, (unsigned int __user *)&sc->fs);
-	err |= __put_user(regs->es, (unsigned int __user *)&sc->es);
-	err |= __put_user(regs->ds, (unsigned int __user *)&sc->ds);
+	__put_user_ex(regs->fs, (unsigned int __user *)&sc->fs);
+	__put_user_ex(regs->es, (unsigned int __user *)&sc->es);
+	__put_user_ex(regs->ds, (unsigned int __user *)&sc->ds);
 #endif /* CONFIG_X86_32 */
 
-	err |= __put_user(regs->di, &sc->di);
-	err |= __put_user(regs->si, &sc->si);
-	err |= __put_user(regs->bp, &sc->bp);
-	err |= __put_user(regs->sp, &sc->sp);
-	err |= __put_user(regs->bx, &sc->bx);
-	err |= __put_user(regs->dx, &sc->dx);
-	err |= __put_user(regs->cx, &sc->cx);
-	err |= __put_user(regs->ax, &sc->ax);
+	__put_user_ex(regs->di, &sc->di);
+	__put_user_ex(regs->si, &sc->si);
+	__put_user_ex(regs->bp, &sc->bp);
+	__put_user_ex(regs->sp, &sc->sp);
+	__put_user_ex(regs->bx, &sc->bx);
+	__put_user_ex(regs->dx, &sc->dx);
+	__put_user_ex(regs->cx, &sc->cx);
+	__put_user_ex(regs->ax, &sc->ax);
 #ifdef CONFIG_X86_64
-	err |= __put_user(regs->r8, &sc->r8);
-	err |= __put_user(regs->r9, &sc->r9);
-	err |= __put_user(regs->r10, &sc->r10);
-	err |= __put_user(regs->r11, &sc->r11);
-	err |= __put_user(regs->r12, &sc->r12);
-	err |= __put_user(regs->r13, &sc->r13);
-	err |= __put_user(regs->r14, &sc->r14);
-	err |= __put_user(regs->r15, &sc->r15);
+	__put_user_ex(regs->r8, &sc->r8);
+	__put_user_ex(regs->r9, &sc->r9);
+	__put_user_ex(regs->r10, &sc->r10);
+	__put_user_ex(regs->r11, &sc->r11);
+	__put_user_ex(regs->r12, &sc->r12);
+	__put_user_ex(regs->r13, &sc->r13);
+	__put_user_ex(regs->r14, &sc->r14);
+	__put_user_ex(regs->r15, &sc->r15);
 #endif /* CONFIG_X86_64 */
 
-	err |= __put_user(current->thread.trap_no, &sc->trapno);
-	err |= __put_user(current->thread.error_code, &sc->err);
-	err |= __put_user(regs->ip, &sc->ip);
+	__put_user_ex(current->thread.trap_no, &sc->trapno);
+	__put_user_ex(current->thread.error_code, &sc->err);
+	__put_user_ex(regs->ip, &sc->ip);
 #ifdef CONFIG_X86_32
-	err |= __put_user(regs->cs, (unsigned int __user *)&sc->cs);
-	err |= __put_user(regs->flags, &sc->flags);
-	err |= __put_user(regs->sp, &sc->sp_at_signal);
-	err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);
+	__put_user_ex(regs->cs, (unsigned int __user *)&sc->cs);
+	__put_user_ex(regs->flags, &sc->flags);
+	__put_user_ex(regs->sp, &sc->sp_at_signal);
+	__put_user_ex(regs->ss, (unsigned int __user *)&sc->ss);
 #else /* !CONFIG_X86_32 */
-	err |= __put_user(regs->flags, &sc->flags);
-	err |= __put_user(regs->cs, &sc->cs);
-	err |= __put_user(0, &sc->gs);
-	err |= __put_user(0, &sc->fs);
+	__put_user_ex(regs->flags, &sc->flags);
+	__put_user_ex(regs->cs, &sc->cs);
+	__put_user_ex(0, &sc->gs);
+	__put_user_ex(0, &sc->fs);
 #endif /* CONFIG_X86_32 */
 
-	err |= __put_user(fpstate, &sc->fpstate);
+	__put_user_ex(fpstate, &sc->fpstate);
 
 	/* non-iBCS2 extensions.. */
-	err |= __put_user(mask, &sc->oldmask);
-	err |= __put_user(current->thread.cr2, &sc->cr2);
+	__put_user_ex(mask, &sc->oldmask);
+	__put_user_ex(current->thread.cr2, &sc->cr2);
+
+	__put_user_ex_catch(&err);
 
 	return err;
 }
@@ -274,16 +282,19 @@ __setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
-	if (__put_user(sig, &frame->sig))
-		return -EFAULT;
+	__put_user_ex_try();
 
-	if (setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]))
-		return -EFAULT;
+	__put_user_ex(sig, &frame->sig);
+
+	err |= setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]);
+	if (err)
+		goto out;
 
 	if (_NSIG_WORDS > 1) {
-		if (__copy_to_user(&frame->extramask, &set->sig[1],
-				   sizeof(frame->extramask)))
-			return -EFAULT;
+		err |= __copy_to_user(&frame->extramask, &set->sig[1],
+				      sizeof(frame->extramask));
+		if (err)
+			goto out;
 	}
 
 	if (current->mm->context.vdso)
@@ -294,7 +305,7 @@ __setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 		restorer = ka->sa.sa_restorer;
 
 	/* Set up to return from userspace.  */
-	err |= __put_user(restorer, &frame->pretcode);
+	__put_user_ex(restorer, &frame->pretcode);
 
 	/*
 	 * This is popl %eax ; movl $__NR_sigreturn, %eax ; int $0x80
@@ -303,10 +314,7 @@ __setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	 * reasons and because gdb uses it as a signature to notice
 	 * signal handler stack frames.
 	 */
-	err |= __put_user(*((u64 *)&retcode), (u64 *)frame->retcode);
-
-	if (err)
-		return -EFAULT;
+	__put_user_ex(*((u64 *)&retcode), (u64 *)frame->retcode);
 
 	/* Set up registers for signal handler */
 	regs->sp = (unsigned long)frame;
@@ -320,7 +328,10 @@ __setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	regs->ss = __USER_DS;
 	regs->cs = __USER_CS;
 
-	return 0;
+out:
+	__put_user_ex_catch(&err);
+
+	return err;
 }
 
 static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
@@ -336,34 +347,36 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
-	err |= __put_user(sig, &frame->sig);
-	err |= __put_user(&frame->info, &frame->pinfo);
-	err |= __put_user(&frame->uc, &frame->puc);
+	__put_user_ex_try();
+
+	__put_user_ex(sig, &frame->sig);
+	__put_user_ex(&frame->info, &frame->pinfo);
+	__put_user_ex(&frame->uc, &frame->puc);
 	err |= copy_siginfo_to_user(&frame->info, info);
 	if (err)
-		return -EFAULT;
+		goto out;
 
 	/* Create the ucontext.  */
 	if (cpu_has_xsave)
-		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
+		__put_user_ex(UC_FP_XSTATE, &frame->uc.uc_flags);
 	else
-		err |= __put_user(0, &frame->uc.uc_flags);
-	err |= __put_user(0, &frame->uc.uc_link);
-	err |= __put_user(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
-	err |= __put_user(sas_ss_flags(regs->sp),
+		__put_user_ex(0, &frame->uc.uc_flags);
+	__put_user_ex(0, &frame->uc.uc_link);
+	__put_user_ex(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
+	__put_user_ex(sas_ss_flags(regs->sp),
 			  &frame->uc.uc_stack.ss_flags);
-	err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
+	__put_user_ex(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
 	err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
 				regs, set->sig[0]);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
-		return -EFAULT;
+		goto out;
 
 	/* Set up to return from userspace.  */
 	restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
 	if (ka->sa.sa_flags & SA_RESTORER)
 		restorer = ka->sa.sa_restorer;
-	err |= __put_user(restorer, &frame->pretcode);
+	__put_user_ex(restorer, &frame->pretcode);
 
 	/*
 	 * This is movl $__NR_rt_sigreturn, %ax ; int $0x80
@@ -372,10 +385,7 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	 * reasons and because gdb uses it as a signature to notice
 	 * signal handler stack frames.
 	 */
-	err |= __put_user(*((u64 *)&rt_retcode), (u64 *)frame->retcode);
-
-	if (err)
-		return -EFAULT;
+	__put_user_ex(*((u64 *)&rt_retcode), (u64 *)frame->retcode);
 
 	/* Set up registers for signal handler */
 	regs->sp = (unsigned long)frame;
@@ -389,7 +399,10 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->ss = __USER_DS;
 	regs->cs = __USER_CS;
 
-	return 0;
+out:
+	__put_user_ex_catch(&err);
+
+	return err;
 }
 #else /* !CONFIG_X86_32 */
 /*
@@ -436,16 +449,18 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 			return -EFAULT;
 	}
 
+	__put_user_ex_try();
+
 	/* Create the ucontext.  */
 	if (cpu_has_xsave)
-		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
+		__put_user_ex(UC_FP_XSTATE, &frame->uc.uc_flags);
 	else
-		err |= __put_user(0, &frame->uc.uc_flags);
-	err |= __put_user(0, &frame->uc.uc_link);
-	err |= __put_user(me->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
-	err |= __put_user(sas_ss_flags(regs->sp),
+		__put_user_ex(0, &frame->uc.uc_flags);
+	__put_user_ex(0, &frame->uc.uc_link);
+	__put_user_ex(me->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
+	__put_user_ex(sas_ss_flags(regs->sp),
 			  &frame->uc.uc_stack.ss_flags);
-	err |= __put_user(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
+	__put_user_ex(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
 	err |= setup_sigcontext(&frame->uc.uc_mcontext, fp, regs, set->sig[0]);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
@@ -453,15 +468,13 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	   already in userspace.  */
 	/* x86-64 should always use SA_RESTORER. */
 	if (ka->sa.sa_flags & SA_RESTORER) {
-		err |= __put_user(ka->sa.sa_restorer, &frame->pretcode);
+		__put_user_ex(ka->sa.sa_restorer, &frame->pretcode);
 	} else {
 		/* could use a vstub here */
-		return -EFAULT;
+		err = -EFAULT;
+		goto out;
 	}
 
-	if (err)
-		return -EFAULT;
-
 	/* Set up registers for signal handler */
 	regs->di = sig;
 	/* In case the signal handler was declared without prototypes */
@@ -479,7 +492,10 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	   even if the handler happens to be interrupting 32-bit code. */
 	regs->cs = __USER_CS;
 
-	return 0;
+out:
+	__put_user_ex_catch(&err);
+
+	return err;
 }
 #endif /* CONFIG_X86_32 */
 
@@ -509,31 +525,37 @@ sys_sigaction(int sig, const struct old_sigaction __user *act,
 	      struct old_sigaction __user *oact)
 {
 	struct k_sigaction new_ka, old_ka;
-	int ret;
+	int ret = 0;
 
 	if (act) {
 		old_sigset_t mask;
 
-		if (!access_ok(VERIFY_READ, act, sizeof(*act)) ||
-		    __get_user(new_ka.sa.sa_handler, &act->sa_handler) ||
-		    __get_user(new_ka.sa.sa_restorer, &act->sa_restorer))
+		if (!access_ok(VERIFY_READ, act, sizeof(*act)))
+			return -EFAULT;
+		__get_user_ex_try();
+		__get_user_ex(new_ka.sa.sa_handler, &act->sa_handler);
+		__get_user_ex(new_ka.sa.sa_flags, &act->sa_flags);
+		__get_user_ex(mask, &act->sa_mask);
+		__get_user_ex(new_ka.sa.sa_restorer, &act->sa_restorer);
+		__get_user_ex_catch(&ret);
+		if (ret)
 			return -EFAULT;
-
-		__get_user(new_ka.sa.sa_flags, &act->sa_flags);
-		__get_user(mask, &act->sa_mask);
 		siginitset(&new_ka.sa.sa_mask, mask);
 	}
 
 	ret = do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
 
 	if (!ret && oact) {
-		if (!access_ok(VERIFY_WRITE, oact, sizeof(*oact)) ||
-		    __put_user(old_ka.sa.sa_handler, &oact->sa_handler) ||
-		    __put_user(old_ka.sa.sa_restorer, &oact->sa_restorer))
+		if (!access_ok(VERIFY_WRITE, oact, sizeof(*oact)))
+			return -EFAULT;
+		__put_user_ex_try();
+		__put_user_ex(old_ka.sa.sa_handler, &oact->sa_handler);
+		__put_user_ex(old_ka.sa.sa_flags, &oact->sa_flags);
+		__put_user_ex(old_ka.sa.sa_mask.sig[0], &oact->sa_mask);
+		__put_user_ex(old_ka.sa.sa_restorer, &oact->sa_restorer);
+		__put_user_ex_catch(&ret);
+		if (ret)
 			return -EFAULT;
-
-		__put_user(old_ka.sa.sa_flags, &oact->sa_flags);
-		__put_user(old_ka.sa.sa_mask.sig[0], &oact->sa_mask);
 	}
 
 	return ret;
-- 
1.6.0.4

