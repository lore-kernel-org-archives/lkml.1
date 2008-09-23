Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbYIWBwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbYIWBwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 21:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbYIWBvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 21:51:50 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:2957 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbYIWBvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 21:51:49 -0400
Message-ID: <48D84BB4.9040304@ct.jp.nec.com>
Date: Mon, 22 Sep 2008 18:51:48 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH -tip 4/4] x86: signal: use __{put|get}_user_cerr
References: <48D84A2A.2030009@ct.jp.nec.com>
In-Reply-To: <48D84A2A.2030009@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Use __{put|get}_user_cerr for cumulative error handling in x86 signal code.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |   96 +++++++++++++++++++++---------------------
 arch/x86/kernel/signal_64.c |   86 +++++++++++++++++++-------------------
 2 files changed, 91 insertions(+), 91 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index da3cf32..cd6233e 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -126,21 +126,21 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	/* Always make any pending restarted system calls return -EINTR */
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
 
-#define COPY(x)		err |= __get_user(regs->x, &sc->x)
+#define COPY(x)		__get_user_cerr(regs->x, &sc->x, err)
 
 #define COPY_SEG(seg)							\
 	{ unsigned short tmp;						\
-	  err |= __get_user(tmp, &sc->seg);				\
+	  __get_user_cerr(tmp, &sc->seg, err);				\
 	  regs->seg = tmp; }
 
 #define COPY_SEG_STRICT(seg)						\
 	{ unsigned short tmp;						\
-	  err |= __get_user(tmp, &sc->seg);				\
+	  __get_user_cerr(tmp, &sc->seg, err);				\
 	  regs->seg = tmp|3; }
 
 #define GET_SEG(seg)							\
 	{ unsigned short tmp;						\
-	  err |= __get_user(tmp, &sc->seg);				\
+	  __get_user_cerr(tmp, &sc->seg, err);				\
 	  loadsegment(seg, tmp); }
 
 	GET_SEG(gs);
@@ -155,7 +155,7 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	{
 		unsigned int tmpflags;
 
-		err |= __get_user(tmpflags, &sc->flags);
+		__get_user_cerr(tmpflags, &sc->flags, err);
 		regs->flags = (regs->flags & ~FIX_EFLAGS) |
 						(tmpflags & FIX_EFLAGS);
 		regs->orig_ax = -1;		/* disable syscall checks */
@@ -164,11 +164,11 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	{
 		void __user *buf;
 
-		err |= __get_user(buf, &sc->fpstate);
+		__get_user_cerr(buf, &sc->fpstate, err);
 		err |= restore_i387_xstate(buf);
 	}
 
-	err |= __get_user(*pax, &sc->ax);
+	__get_user_cerr(*pax, &sc->ax, err);
 	return err;
 }
 
@@ -262,37 +262,37 @@ setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 {
 	int tmp, err = 0;
 
-	err |= __put_user(regs->fs, (unsigned int __user *)&sc->fs);
+	__put_user_cerr(regs->fs, (unsigned int __user *)&sc->fs, err);
 	savesegment(gs, tmp);
-	err |= __put_user(tmp, (unsigned int __user *)&sc->gs);
-
-	err |= __put_user(regs->es, (unsigned int __user *)&sc->es);
-	err |= __put_user(regs->ds, (unsigned int __user *)&sc->ds);
-	err |= __put_user(regs->di, &sc->di);
-	err |= __put_user(regs->si, &sc->si);
-	err |= __put_user(regs->bp, &sc->bp);
-	err |= __put_user(regs->sp, &sc->sp);
-	err |= __put_user(regs->bx, &sc->bx);
-	err |= __put_user(regs->dx, &sc->dx);
-	err |= __put_user(regs->cx, &sc->cx);
-	err |= __put_user(regs->ax, &sc->ax);
-	err |= __put_user(current->thread.trap_no, &sc->trapno);
-	err |= __put_user(current->thread.error_code, &sc->err);
-	err |= __put_user(regs->ip, &sc->ip);
-	err |= __put_user(regs->cs, (unsigned int __user *)&sc->cs);
-	err |= __put_user(regs->flags, &sc->flags);
-	err |= __put_user(regs->sp, &sc->sp_at_signal);
-	err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);
+	__put_user_cerr(tmp, (unsigned int __user *)&sc->gs, err);
+
+	__put_user_cerr(regs->es, (unsigned int __user *)&sc->es, err);
+	__put_user_cerr(regs->ds, (unsigned int __user *)&sc->ds, err);
+	__put_user_cerr(regs->di, &sc->di, err);
+	__put_user_cerr(regs->si, &sc->si, err);
+	__put_user_cerr(regs->bp, &sc->bp, err);
+	__put_user_cerr(regs->sp, &sc->sp, err);
+	__put_user_cerr(regs->bx, &sc->bx, err);
+	__put_user_cerr(regs->dx, &sc->dx, err);
+	__put_user_cerr(regs->cx, &sc->cx, err);
+	__put_user_cerr(regs->ax, &sc->ax, err);
+	__put_user_cerr(current->thread.trap_no, &sc->trapno, err);
+	__put_user_cerr(current->thread.error_code, &sc->err, err);
+	__put_user_cerr(regs->ip, &sc->ip, err);
+	__put_user_cerr(regs->cs, (unsigned int __user *)&sc->cs, err);
+	__put_user_cerr(regs->flags, &sc->flags, err);
+	__put_user_cerr(regs->sp, &sc->sp_at_signal, err);
+	__put_user_cerr(regs->ss, (unsigned int __user *)&sc->ss, err);
 
 	tmp = save_i387_xstate(fpstate);
 	if (tmp < 0)
 		err = 1;
 	else
-		err |= __put_user(tmp ? fpstate : NULL, &sc->fpstate);
+		__put_user_cerr(tmp ? fpstate : NULL, &sc->fpstate, err);
 
 	/* non-iBCS2 extensions.. */
-	err |= __put_user(mask, &sc->oldmask);
-	err |= __put_user(current->thread.cr2, &sc->cr2);
+	__put_user_cerr(mask, &sc->oldmask, err);
+	__put_user_cerr(current->thread.cr2, &sc->cr2, err);
 
 	return err;
 }
@@ -377,7 +377,7 @@ __setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 		restorer = ka->sa.sa_restorer;
 
 	/* Set up to return from userspace.  */
-	err |= __put_user(restorer, &frame->pretcode);
+	__put_user_cerr(restorer, &frame->pretcode, err);
 
 	/*
 	 * This is popl %eax ; movl $__NR_sigreturn, %eax ; int $0x80
@@ -386,9 +386,9 @@ __setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	 * reasons and because gdb uses it as a signature to notice
 	 * signal handler stack frames.
 	 */
-	err |= __put_user(0xb858, (short __user *)(frame->retcode+0));
-	err |= __put_user(__NR_sigreturn, (int __user *)(frame->retcode+2));
-	err |= __put_user(0x80cd, (short __user *)(frame->retcode+6));
+	__put_user_cerr(0xb858, (short __user *)(frame->retcode+0), err);
+	__put_user_cerr(__NR_sigreturn, (int __user *)(frame->retcode+2), err);
+	__put_user_cerr(0x80cd, (short __user *)(frame->retcode+6), err);
 
 	if (err)
 		return -EFAULT;
@@ -421,23 +421,23 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
-	err |= __put_user(sig, &frame->sig);
-	err |= __put_user(&frame->info, &frame->pinfo);
-	err |= __put_user(&frame->uc, &frame->puc);
+	__put_user_cerr(sig, &frame->sig, err);
+	__put_user_cerr(&frame->info, &frame->pinfo, err);
+	__put_user_cerr(&frame->uc, &frame->puc, err);
 	err |= copy_siginfo_to_user(&frame->info, info);
 	if (err)
 		return -EFAULT;
 
 	/* Create the ucontext.  */
 	if (cpu_has_xsave)
-		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
+		__put_user_cerr(UC_FP_XSTATE, &frame->uc.uc_flags, err);
 	else
-		err |= __put_user(0, &frame->uc.uc_flags);
-	err |= __put_user(0, &frame->uc.uc_link);
-	err |= __put_user(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
-	err |= __put_user(sas_ss_flags(regs->sp),
-			  &frame->uc.uc_stack.ss_flags);
-	err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
+		__put_user_cerr(0, &frame->uc.uc_flags, err);
+	__put_user_cerr(0, &frame->uc.uc_link, err);
+	__put_user_cerr(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp, err);
+	__put_user_cerr(sas_ss_flags(regs->sp),
+			  &frame->uc.uc_stack.ss_flags, err);
+	__put_user_cerr(current->sas_ss_size, &frame->uc.uc_stack.ss_size, err);
 	err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
 				regs, set->sig[0]);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
@@ -448,7 +448,7 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
 	if (ka->sa.sa_flags & SA_RESTORER)
 		restorer = ka->sa.sa_restorer;
-	err |= __put_user(restorer, &frame->pretcode);
+	__put_user_cerr(restorer, &frame->pretcode, err);
 
 	/*
 	 * This is movl $__NR_rt_sigreturn, %ax ; int $0x80
@@ -457,9 +457,9 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	 * reasons and because gdb uses it as a signature to notice
 	 * signal handler stack frames.
 	 */
-	err |= __put_user(0xb8, (char __user *)(frame->retcode+0));
-	err |= __put_user(__NR_rt_sigreturn, (int __user *)(frame->retcode+1));
-	err |= __put_user(0x80cd, (short __user *)(frame->retcode+5));
+	__put_user_cerr(0xb8, (char __user *)(frame->retcode+0), err);
+	__put_user_cerr(__NR_rt_sigreturn, (int __user *)(frame->retcode+1), err);
+	__put_user_cerr(0x80cd, (short __user *)(frame->retcode+5), err);
 
 	if (err)
 		return -EFAULT;
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index bf77d47..10375f4 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -64,7 +64,7 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	/* Always make any pending restarted system calls return -EINTR */
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
 
-#define COPY(x)		(err |= __get_user(regs->x, &sc->x))
+#define COPY(x)		__get_user_cerr(regs->x, &sc->x, err)
 
 	COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
 	COPY(dx); COPY(cx); COPY(ip);
@@ -82,13 +82,13 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	 * App's signal handler can save/restore other segments if needed. */
 	{
 		unsigned cs;
-		err |= __get_user(cs, &sc->cs);
+		__get_user_cerr(cs, &sc->cs, err);
 		regs->cs = cs | 3;	/* Force into user mode */
 	}
 
 	{
 		unsigned int tmpflags;
-		err |= __get_user(tmpflags, &sc->flags);
+		__get_user_cerr(tmpflags, &sc->flags, err);
 		regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
 		regs->orig_ax = -1;		/* disable syscall checks */
 	}
@@ -96,11 +96,11 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	{
 		void __user *buf;
 
-		err |= __get_user(buf, &sc->fpstate);
+		__get_user_cerr(buf, &sc->fpstate, err);
 		err |= restore_i387_xstate(buf);
 	}
 
-	err |= __get_user(*pax, &sc->ax);
+	__get_user_cerr(*pax, &sc->ax, err);
 	return err;
 }
 
@@ -150,32 +150,32 @@ setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs,
 {
 	int err = 0;
 
-	err |= __put_user(regs->cs, &sc->cs);
-	err |= __put_user(0, &sc->gs);
-	err |= __put_user(0, &sc->fs);
-
-	err |= __put_user(regs->di, &sc->di);
-	err |= __put_user(regs->si, &sc->si);
-	err |= __put_user(regs->bp, &sc->bp);
-	err |= __put_user(regs->sp, &sc->sp);
-	err |= __put_user(regs->bx, &sc->bx);
-	err |= __put_user(regs->dx, &sc->dx);
-	err |= __put_user(regs->cx, &sc->cx);
-	err |= __put_user(regs->ax, &sc->ax);
-	err |= __put_user(regs->r8, &sc->r8);
-	err |= __put_user(regs->r9, &sc->r9);
-	err |= __put_user(regs->r10, &sc->r10);
-	err |= __put_user(regs->r11, &sc->r11);
-	err |= __put_user(regs->r12, &sc->r12);
-	err |= __put_user(regs->r13, &sc->r13);
-	err |= __put_user(regs->r14, &sc->r14);
-	err |= __put_user(regs->r15, &sc->r15);
-	err |= __put_user(me->thread.trap_no, &sc->trapno);
-	err |= __put_user(me->thread.error_code, &sc->err);
-	err |= __put_user(regs->ip, &sc->ip);
-	err |= __put_user(regs->flags, &sc->flags);
-	err |= __put_user(mask, &sc->oldmask);
-	err |= __put_user(me->thread.cr2, &sc->cr2);
+	__put_user_cerr(regs->cs, &sc->cs, err);
+	__put_user_cerr(0, &sc->gs, err);
+	__put_user_cerr(0, &sc->fs, err);
+
+	__put_user_cerr(regs->di, &sc->di, err);
+	__put_user_cerr(regs->si, &sc->si, err);
+	__put_user_cerr(regs->bp, &sc->bp, err);
+	__put_user_cerr(regs->sp, &sc->sp, err);
+	__put_user_cerr(regs->bx, &sc->bx, err);
+	__put_user_cerr(regs->dx, &sc->dx, err);
+	__put_user_cerr(regs->cx, &sc->cx, err);
+	__put_user_cerr(regs->ax, &sc->ax, err);
+	__put_user_cerr(regs->r8, &sc->r8, err);
+	__put_user_cerr(regs->r9, &sc->r9, err);
+	__put_user_cerr(regs->r10, &sc->r10, err);
+	__put_user_cerr(regs->r11, &sc->r11, err);
+	__put_user_cerr(regs->r12, &sc->r12, err);
+	__put_user_cerr(regs->r13, &sc->r13, err);
+	__put_user_cerr(regs->r14, &sc->r14, err);
+	__put_user_cerr(regs->r15, &sc->r15, err);
+	__put_user_cerr(me->thread.trap_no, &sc->trapno, err);
+	__put_user_cerr(me->thread.error_code, &sc->err, err);
+	__put_user_cerr(regs->ip, &sc->ip, err);
+	__put_user_cerr(regs->flags, &sc->flags, err);
+	__put_user_cerr(mask, &sc->oldmask, err);
+	__put_user_cerr(me->thread.cr2, &sc->cr2, err);
 
 	return err;
 }
@@ -229,19 +229,19 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	/* Create the ucontext.  */
 	if (cpu_has_xsave)
-		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
+		__put_user_cerr(UC_FP_XSTATE, &frame->uc.uc_flags, err);
 	else
-		err |= __put_user(0, &frame->uc.uc_flags);
-	err |= __put_user(0, &frame->uc.uc_link);
-	err |= __put_user(me->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
-	err |= __put_user(sas_ss_flags(regs->sp),
-			  &frame->uc.uc_stack.ss_flags);
-	err |= __put_user(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
-	err |= setup_sigcontext(&frame->uc.uc_mcontext, regs, set->sig[0], me);
-	err |= __put_user(fp, &frame->uc.uc_mcontext.fpstate);
+		__put_user_cerr(0, &frame->uc.uc_flags, err);
+	__put_user_cerr(0, &frame->uc.uc_link, err);
+	__put_user_cerr(me->sas_ss_sp, &frame->uc.uc_stack.ss_sp, err);
+	__put_user_cerr(sas_ss_flags(regs->sp),
+			  &frame->uc.uc_stack.ss_flags, err);
+	__put_user_cerr(me->sas_ss_size, &frame->uc.uc_stack.ss_size, err);
+	setup_sigcontext(&frame->uc.uc_mcontext, regs, set->sig[0], me);
+	__put_user_cerr(fp, &frame->uc.uc_mcontext.fpstate, err);
 	if (sizeof(*set) == 16) {
-		__put_user(set->sig[0], &frame->uc.uc_sigmask.sig[0]);
-		__put_user(set->sig[1], &frame->uc.uc_sigmask.sig[1]);
+		__put_user_cerr(set->sig[0], &frame->uc.uc_sigmask.sig[0], err);
+		__put_user_cerr(set->sig[1], &frame->uc.uc_sigmask.sig[1], err);
 	} else
 		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
@@ -249,7 +249,7 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	   already in userspace.  */
 	/* x86-64 should always use SA_RESTORER. */
 	if (ka->sa.sa_flags & SA_RESTORER) {
-		err |= __put_user(ka->sa.sa_restorer, &frame->pretcode);
+		__put_user_cerr(ka->sa.sa_restorer, &frame->pretcode, err);
 	} else {
 		/* could use a vstub here */
 		return -EFAULT;
-- 
1.5.6

