Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYG2Fu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYG2Fu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbYG2Fs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:48:59 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:55505 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbYG2Fs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:48:58 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 4/6] x86: coding style fixes to arch/x86/kernel/signal_64.c
Date: Tue, 29 Jul 2008 02:48:54 -0300
Message-Id: <1217310536-7181-5-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217310536-7181-4-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217310536-7181-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1217310536-7181-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1217310536-7181-3-git-send-email-gustavo@las.ic.unicamp.br>
 <1217310536-7181-4-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix all errors and many warnings reported by checkpatch.pl
without change signal_64.o

arch/x86/kernel/signal_64.o
text    data     bss     dec     hex filename
5143       0       8    5151    141f signal_64.o.after
5143       0       8    5151    141f signal_64.o.before
md5:
e68718092b3641cb27e79e55ce57e3ad  signal_64.o.after
e68718092b3641cb27e79e55ce57e3ad  signal_64.o.before

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/sigframe.h  |    5 +++
 arch/x86/kernel/signal_64.c |   62 ++++++++++++++++++++----------------------
 2 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/sigframe.h b/arch/x86/kernel/sigframe.h
index 72bbb51..8b4956e 100644
--- a/arch/x86/kernel/sigframe.h
+++ b/arch/x86/kernel/sigframe.h
@@ -24,4 +24,9 @@ struct rt_sigframe {
 	struct ucontext uc;
 	struct siginfo info;
 };
+
+int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+		sigset_t *set, struct pt_regs *regs);
+int ia32_setup_frame(int sig, struct k_sigaction *ka,
+		sigset_t *set, struct pt_regs *regs);
 #endif
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index b45ef8d..87a9c2f 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -19,9 +19,10 @@
 #include <linux/stddef.h>
 #include <linux/personality.h>
 #include <linux/compiler.h>
+#include <linux/uaccess.h>
+
 #include <asm/processor.h>
 #include <asm/ucontext.h>
-#include <asm/uaccess.h>
 #include <asm/i387.h>
 #include <asm/proto.h>
 #include <asm/ia32_unistd.h>
@@ -41,11 +42,6 @@
 # define FIX_EFLAGS	__FIX_EFLAGS
 #endif
 
-int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-               sigset_t *set, struct pt_regs * regs); 
-int ia32_setup_frame(int sig, struct k_sigaction *ka,
-            sigset_t *set, struct pt_regs * regs); 
-
 asmlinkage long
 sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 		struct pt_regs *regs)
@@ -119,7 +115,7 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	/* Always make any pending restarted system calls return -EINTR */
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
 
-#define COPY(x)		err |= __get_user(regs->x, &sc->x)
+#define COPY(x)		(err |= __get_user(regs->x, &sc->x))
 
 	COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
 	COPY(dx); COPY(cx); COPY(ip);
@@ -149,7 +145,7 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	}
 
 	{
-		struct _fpstate __user * buf;
+		struct _fpstate __user *buf;
 		err |= __get_user(buf, &sc->fpstate);
 
 		if (buf) {
@@ -189,7 +185,7 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 	current->blocked = set;
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
-	
+
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
 		goto badframe;
 
@@ -199,16 +195,17 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 	return ax;
 
 badframe:
-	signal_fault(regs,frame,"sigreturn");
+	signal_fault(regs, frame, "sigreturn");
 	return 0;
-}	
+}
 
 /*
  * Set up a signal frame.
  */
 
 static inline int
-setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs, unsigned long mask, struct task_struct *me)
+setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs,
+		unsigned long mask, struct task_struct *me)
 {
 	int err = 0;
 
@@ -264,35 +261,35 @@ get_stack(struct k_sigaction *ka, struct pt_regs *regs, unsigned long size)
 }
 
 static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			   sigset_t *set, struct pt_regs * regs)
+			   sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	struct _fpstate __user *fp = NULL; 
+	struct _fpstate __user *fp = NULL;
 	int err = 0;
 	struct task_struct *me = current;
 
 	if (used_math()) {
-		fp = get_stack(ka, regs, sizeof(struct _fpstate)); 
+		fp = get_stack(ka, regs, sizeof(struct _fpstate));
 		frame = (void __user *)round_down(
 			(unsigned long)fp - sizeof(struct rt_sigframe), 16) - 8;
 
 		if (!access_ok(VERIFY_WRITE, fp, sizeof(struct _fpstate)))
 			goto give_sigsegv;
 
-		if (save_i387(fp) < 0) 
-			err |= -1; 
+		if (save_i387(fp) < 0)
+			err |= -1;
 	} else
 		frame = get_stack(ka, regs, sizeof(struct rt_sigframe)) - 8;
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
 
-	if (ka->sa.sa_flags & SA_SIGINFO) { 
+	if (ka->sa.sa_flags & SA_SIGINFO) {
 		err |= copy_siginfo_to_user(&frame->info, info);
 		if (err)
 			goto give_sigsegv;
 	}
-		
+
 	/* Create the ucontext.  */
 	err |= __put_user(0, &frame->uc.uc_flags);
 	err |= __put_user(0, &frame->uc.uc_link);
@@ -302,9 +299,9 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= __put_user(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
 	err |= setup_sigcontext(&frame->uc.uc_mcontext, regs, set->sig[0], me);
 	err |= __put_user(fp, &frame->uc.uc_mcontext.fpstate);
-	if (sizeof(*set) == 16) { 
+	if (sizeof(*set) == 16) {
 		__put_user(set->sig[0], &frame->uc.uc_sigmask.sig[0]);
-		__put_user(set->sig[1], &frame->uc.uc_sigmask.sig[1]); 
+		__put_user(set->sig[1], &frame->uc.uc_sigmask.sig[1]);
 	} else
 		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
@@ -315,7 +312,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		err |= __put_user(ka->sa.sa_restorer, &frame->pretcode);
 	} else {
 		/* could use a vstub here */
-		goto give_sigsegv; 
+		goto give_sigsegv;
 	}
 
 	if (err)
@@ -323,7 +320,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	/* Set up registers for signal handler */
 	regs->di = sig;
-	/* In case the signal handler was declared without prototypes */ 
+	/* In case the signal handler was declared without prototypes */
 	regs->ax = 0;
 
 	/* This also works for non SA_SIGINFO handlers because they expect the
@@ -376,7 +373,7 @@ static long current_syscall_ret(struct pt_regs *regs)
 
 /*
  * OK, we're invoking a handler
- */	
+ */
 
 static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
@@ -420,7 +417,7 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 			ret = ia32_setup_rt_frame(sig, ka, info, oldset, regs);
 		else
 			ret = ia32_setup_frame(sig, ka, oldset, regs);
-	} else 
+	} else
 #endif
 	ret = setup_rt_frame(sig, ka, info, oldset, regs);
 
@@ -448,9 +445,9 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 			ptrace_notify(SIGTRAP);
 
 		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
+		sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
 		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked,sig);
+			sigaddset(&current->blocked, sig);
 		recalc_sigpending();
 		spin_unlock_irq(&current->sighand->siglock);
 	}
@@ -552,14 +549,15 @@ void do_notify_resume(struct pt_regs *regs, void *unused,
 }
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
-{ 
-	struct task_struct *me = current; 
+{
+	struct task_struct *me = current;
 	if (show_unhandled_signals && printk_ratelimit()) {
 		printk("%s[%d] bad frame in %s frame:%p ip:%lx sp:%lx orax:%lx",
-	       me->comm,me->pid,where,frame,regs->ip,regs->sp,regs->orig_ax);
+	       me->comm, me->pid, where, frame, regs->ip,
+		   regs->sp, regs->orig_ax);
 		print_vma_addr(" in ", regs->ip);
 		printk("\n");
 	}
 
-	force_sig(SIGSEGV, me); 
-} 
+	force_sig(SIGSEGV, me);
+}
-- 
1.5.4.5

