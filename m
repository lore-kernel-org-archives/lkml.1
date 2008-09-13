Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbYIMABU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbYIMABU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 20:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757290AbYIMABM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 20:01:12 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:4772 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281AbYIMABL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 20:01:11 -0400
Message-ID: <48CB02C5.4060805@ct.jp.nec.com>
Date: Fri, 12 Sep 2008 17:01:09 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: signal: get give_sigsegv of setup frames together
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

When setup frame failed, force_sigsegv is called and returns -EFAULT.
There are same code in ia32_setup_fram(), ia32_setup_rt_frame(),
__setup_frame() and __setup_rt_frame().
Get them together.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |   26 +++++++++-----------------
 arch/x86/kernel/signal_32.c |   31 ++++++++++++++-----------------
 arch/x86/kernel/signal_64.c |   17 +++++++++--------
 3 files changed, 32 insertions(+), 42 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 8d64c1b..5f42cfc 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -444,21 +444,21 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	err |= __put_user(sig, &frame->sig);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	err |= ia32_setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (_COMPAT_NSIG_WORDS > 1) {
 		err |= __copy_to_user(frame->extramask, &set->sig[1],
 				      sizeof(frame->extramask));
 		if (err)
-			goto give_sigsegv;
+			return -EFAULT;
 	}
 
 	if (ka->sa.sa_flags & SA_RESTORER) {
@@ -479,7 +479,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	 */
 	err |= __copy_to_user(frame->retcode, &code, 8);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	regs->sp = (unsigned long) frame;
@@ -502,10 +502,6 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 #endif
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
@@ -533,14 +529,14 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	err |= __put_user(sig, &frame->sig);
 	err |= __put_user(ptr_to_compat(&frame->info), &frame->pinfo);
 	err |= __put_user(ptr_to_compat(&frame->uc), &frame->puc);
 	err |= copy_siginfo_to_user32(&frame->info, info);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Create the ucontext.  */
 	if (cpu_has_xsave)
@@ -556,7 +552,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 				     regs, set->sig[0]);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (ka->sa.sa_flags & SA_RESTORER)
 		restorer = ka->sa.sa_restorer;
@@ -571,7 +567,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	 */
 	err |= __copy_to_user(frame->retcode, &code, 8);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	regs->sp = (unsigned long) frame;
@@ -599,8 +595,4 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 #endif
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index b668efc..1c22e00 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -349,21 +349,21 @@ __setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	err = __put_user(sig, &frame->sig);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	err = setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (_NSIG_WORDS > 1) {
 		err = __copy_to_user(&frame->extramask, &set->sig[1],
 				      sizeof(frame->extramask));
 		if (err)
-			goto give_sigsegv;
+			return -EFAULT;
 	}
 
 	if (current->mm->context.vdso)
@@ -388,7 +388,7 @@ __setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	err |= __put_user(0x80cd, (short __user *)(frame->retcode+6));
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	regs->sp = (unsigned long)frame;
@@ -403,10 +403,6 @@ __setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	regs->cs = __USER_CS;
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
@@ -420,14 +416,14 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	err |= __put_user(sig, &frame->sig);
 	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
 	err |= copy_siginfo_to_user(&frame->info, info);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Create the ucontext.  */
 	if (cpu_has_xsave)
@@ -443,7 +439,7 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 				regs, set->sig[0]);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up to return from userspace.  */
 	restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
@@ -463,7 +459,7 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= __put_user(0x80cd, (short __user *)(frame->retcode+5));
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	regs->sp = (unsigned long)frame;
@@ -478,10 +474,6 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->cs = __USER_CS;
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 /*
@@ -506,6 +498,11 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	else
 		ret = __setup_frame(usig, ka, set, regs);
 
+	if (ret) {
+		force_sigsegv(sig, current);
+		return -EFAULT;
+	}
+
 	return ret;
 }
 
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 43e6862..3b79e17 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -215,12 +215,12 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		frame = get_stack(ka, regs, sizeof(struct rt_sigframe)) - 8;
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (ka->sa.sa_flags & SA_SIGINFO) {
 		err |= copy_siginfo_to_user(&frame->info, info);
 		if (err)
-			goto give_sigsegv;
+			return -EFAULT;
 	}
 
 	/* Create the ucontext.  */
@@ -248,11 +248,11 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		err |= __put_user(ka->sa.sa_restorer, &frame->pretcode);
 	} else {
 		/* could use a vstub here */
-		goto give_sigsegv;
+		return -EFAULT;
 	}
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	regs->di = sig;
@@ -272,10 +272,6 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->cs = __USER_CS;
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 /*
@@ -297,6 +293,11 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 #endif
 	ret = __setup_rt_frame(sig, ka, info, set, regs);
 
+	if (ret) {
+		force_sigsegv(sig, current);
+		return -EFAULT;
+	}
+
 	return ret;
 }
 
-- 
1.5.6

