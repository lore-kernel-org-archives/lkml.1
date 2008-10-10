Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbYJJAGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbYJJAGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 20:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYJJAF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 20:05:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35873 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbYJJAF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 20:05:58 -0400
Date: Fri, 10 Oct 2008 02:05:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 updates for v2.6.28, phase #5, signal code
Message-ID: <20081010000533.GA7814@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-v28-for-linus-phase5 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-v28-for-linus-phase5

tip/x86/signal and tip/core/signal topics.

out-of-topic modifications in x86-v28-for-linus-phase5:
-------------------------------------------------------
arch/ia64/include/asm/siginfo.h    # da654b7: signals: demultiplexing SIGTRAP s
arch/powerpc/include/asm/siginfo.h # da654b7: signals: demultiplexing SIGTRAP s
include/asm-generic/siginfo.h      # da654b7: signals: demultiplexing SIGTRAP s
include/asm-parisc/siginfo.h       # da654b7: signals: demultiplexing SIGTRAP s

 Thanks,

	Ingo

------------------>
Hiroshi Shimamoto (22):
      x86_32: signal: use syscall_get_nr and error
      x86_32: signal: introduce signal_fault()
      x86: signal: make NR_restart_syscall
      x86: signal: split out frame setups
      x86_32: signal: move signal number conversion to upper layer
      x86: signal_64.c: clean up signal_fault()
      x86: signal_64.c: arg for restore_i387_xstate() is void __user *
      x86: signal_64.c: make handle_signal() similar
      x86: signal: put give_sigsegv of setup frames together
      x86: signal: remove unneeded err handling
      x86: signal: introduce do_rt_sigreturn()
      x86: signal: cosmetic unification of do_signal()
      x86: signal: cosmetic unification of do_notify_resume()
      x86: signal: cosmetic unification of handle_signal()
      x86: signal_32.c: introduce signr_convert()
      x86: signal_64.c: introduce helper function signr_convert()
      x86: signal: introduce helper macro is_ia32
      x86: signal_32.c: introduce macro ia32_setup_frame and ia32_setup_rt_frame
      x86: ia32_signal.c: remove unnecessary cast to u32
      x86: ia32_signal.c remove unnecessary function calls
      x86: signal: move macros out from restore_sigcontext()
      x86: signal: remove indent in restore_sigcontext()

Srinivasa Ds (2):
      signals: demultiplexing SIGTRAP signal
      signals: demultiplexing SIGTRAP signal, fix


 arch/ia64/include/asm/siginfo.h    |    5 -
 arch/powerpc/include/asm/siginfo.h |    5 -
 arch/x86/ia32/ia32_signal.c        |   68 +++++-------
 arch/x86/kernel/ptrace.c           |    7 +-
 arch/x86/kernel/signal_32.c        |  222 ++++++++++++++++++++++--------------
 arch/x86/kernel/signal_64.c        |  207 ++++++++++++++++++++-------------
 arch/x86/kernel/traps_32.c         |    4 +-
 arch/x86/kernel/traps_64.c         |    2 +-
 include/asm-generic/siginfo.h      |    2 +
 include/asm-parisc/siginfo.h       |    5 -
 include/asm-x86/ptrace.h           |    6 +-
 include/asm-x86/traps.h            |   12 ++
 12 files changed, 310 insertions(+), 235 deletions(-)

diff --git a/arch/ia64/include/asm/siginfo.h b/arch/ia64/include/asm/siginfo.h
index 9294e4b..118d429 100644
--- a/arch/ia64/include/asm/siginfo.h
+++ b/arch/ia64/include/asm/siginfo.h
@@ -113,11 +113,6 @@ typedef struct siginfo {
 #undef NSIGSEGV
 #define NSIGSEGV	3
 
-/*
- * SIGTRAP si_codes
- */
-#define TRAP_BRANCH	(__SI_FAULT|3)	/* process taken branch trap */
-#define TRAP_HWBKPT	(__SI_FAULT|4)	/* hardware breakpoint or watchpoint */
 #undef NSIGTRAP
 #define NSIGTRAP	4
 
diff --git a/arch/powerpc/include/asm/siginfo.h b/arch/powerpc/include/asm/siginfo.h
index 12f1bce..49495b0 100644
--- a/arch/powerpc/include/asm/siginfo.h
+++ b/arch/powerpc/include/asm/siginfo.h
@@ -15,11 +15,6 @@
 
 #include <asm-generic/siginfo.h>
 
-/*
- * SIGTRAP si_codes
- */
-#define TRAP_BRANCH	(__SI_FAULT|3)	/* process taken branch trap */
-#define TRAP_HWBKPT	(__SI_FAULT|4)	/* hardware breakpoint or watchpoint */
 #undef NSIGTRAP
 #define NSIGTRAP	4
 
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 8d64c1b..4bc02b2 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -351,31 +351,28 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
 	savesegment(es, tmp);
 	err |= __put_user(tmp, (unsigned int __user *)&sc->es);
 
-	err |= __put_user((u32)regs->di, &sc->di);
-	err |= __put_user((u32)regs->si, &sc->si);
-	err |= __put_user((u32)regs->bp, &sc->bp);
-	err |= __put_user((u32)regs->sp, &sc->sp);
-	err |= __put_user((u32)regs->bx, &sc->bx);
-	err |= __put_user((u32)regs->dx, &sc->dx);
-	err |= __put_user((u32)regs->cx, &sc->cx);
-	err |= __put_user((u32)regs->ax, &sc->ax);
-	err |= __put_user((u32)regs->cs, &sc->cs);
-	err |= __put_user((u32)regs->ss, &sc->ss);
+	err |= __put_user(regs->di, &sc->di);
+	err |= __put_user(regs->si, &sc->si);
+	err |= __put_user(regs->bp, &sc->bp);
+	err |= __put_user(regs->sp, &sc->sp);
+	err |= __put_user(regs->bx, &sc->bx);
+	err |= __put_user(regs->dx, &sc->dx);
+	err |= __put_user(regs->cx, &sc->cx);
+	err |= __put_user(regs->ax, &sc->ax);
+	err |= __put_user(regs->cs, &sc->cs);
+	err |= __put_user(regs->ss, &sc->ss);
 	err |= __put_user(current->thread.trap_no, &sc->trapno);
 	err |= __put_user(current->thread.error_code, &sc->err);
-	err |= __put_user((u32)regs->ip, &sc->ip);
-	err |= __put_user((u32)regs->flags, &sc->flags);
-	err |= __put_user((u32)regs->sp, &sc->sp_at_signal);
+	err |= __put_user(regs->ip, &sc->ip);
+	err |= __put_user(regs->flags, &sc->flags);
+	err |= __put_user(regs->sp, &sc->sp_at_signal);
 
 	tmp = save_i387_xstate_ia32(fpstate);
 	if (tmp < 0)
 		err = -EFAULT;
-	else {
-		clear_used_math();
-		stts();
+	else
 		err |= __put_user(ptr_to_compat(tmp ? fpstate : NULL),
 					&sc->fpstate);
-	}
 
 	/* non-iBCS2 extensions.. */
 	err |= __put_user(mask, &sc->oldmask);
@@ -444,21 +441,18 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
-	err |= __put_user(sig, &frame->sig);
-	if (err)
-		goto give_sigsegv;
+	if (__put_user(sig, &frame->sig))
+		return -EFAULT;
 
-	err |= ia32_setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]);
-	if (err)
-		goto give_sigsegv;
+	if (ia32_setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]))
+		return -EFAULT;
 
 	if (_COMPAT_NSIG_WORDS > 1) {
-		err |= __copy_to_user(frame->extramask, &set->sig[1],
-				      sizeof(frame->extramask));
-		if (err)
-			goto give_sigsegv;
+		if (__copy_to_user(frame->extramask, &set->sig[1],
+				   sizeof(frame->extramask)))
+			return -EFAULT;
 	}
 
 	if (ka->sa.sa_flags & SA_RESTORER) {
@@ -479,7 +473,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	 */
 	err |= __copy_to_user(frame->retcode, &code, 8);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	regs->sp = (unsigned long) frame;
@@ -502,10 +496,6 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 #endif
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
@@ -533,14 +523,14 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
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
@@ -556,7 +546,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 				     regs, set->sig[0]);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (ka->sa.sa_flags & SA_RESTORER)
 		restorer = ka->sa.sa_restorer;
@@ -571,7 +561,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	 */
 	err |= __copy_to_user(frame->retcode, &code, 8);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	regs->sp = (unsigned long) frame;
@@ -599,8 +589,4 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 #endif
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index e375b65..42ec442 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1452,7 +1452,8 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 #endif
 }
 
-void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
+void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
+					 int error_code, int si_code)
 {
 	struct siginfo info;
 
@@ -1461,7 +1462,7 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
 
 	memset(&info, 0, sizeof(info));
 	info.si_signo = SIGTRAP;
-	info.si_code = TRAP_BRKPT;
+	info.si_code = si_code;
 
 	/* User-mode ip? */
 	info.si_addr = user_mode_vm(regs) ? (void __user *) regs->ip : NULL;
@@ -1548,5 +1549,5 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
 	 */
 	if (test_thread_flag(TIF_SINGLESTEP) &&
 	    tracehook_consider_fatal_signal(current, SIGTRAP, SIG_DFL))
-		send_sigtrap(current, regs, 0);
+		send_sigtrap(current, regs, 0, TRAP_BRKPT);
 }
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index b21070e..d6dd057 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -27,6 +27,7 @@
 #include <asm/uaccess.h>
 #include <asm/i387.h>
 #include <asm/vdso.h>
+#include <asm/syscall.h>
 #include <asm/syscalls.h>
 
 #include "sigframe.h"
@@ -112,6 +113,27 @@ asmlinkage int sys_sigaltstack(unsigned long bx)
 	return do_sigaltstack(uss, uoss, regs->sp);
 }
 
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
+#define COPY_SEG_STRICT(seg)	{			\
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
 
 /*
  * Do a signal return; undo the signal stack.
@@ -120,28 +142,13 @@ static int
 restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 		   unsigned long *pax)
 {
+	void __user *buf;
+	unsigned int tmpflags;
 	unsigned int err = 0;
 
 	/* Always make any pending restarted system calls return -EINTR */
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
 
-#define COPY(x)		err |= __get_user(regs->x, &sc->x)
-
-#define COPY_SEG(seg)							\
-	{ unsigned short tmp;						\
-	  err |= __get_user(tmp, &sc->seg);				\
-	  regs->seg = tmp; }
-
-#define COPY_SEG_STRICT(seg)						\
-	{ unsigned short tmp;						\
-	  err |= __get_user(tmp, &sc->seg);				\
-	  regs->seg = tmp|3; }
-
-#define GET_SEG(seg)							\
-	{ unsigned short tmp;						\
-	  err |= __get_user(tmp, &sc->seg);				\
-	  loadsegment(seg, tmp); }
-
 	GET_SEG(gs);
 	COPY_SEG(fs);
 	COPY_SEG(es);
@@ -151,21 +158,12 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	COPY_SEG_STRICT(cs);
 	COPY_SEG_STRICT(ss);
 
-	{
-		unsigned int tmpflags;
-
-		err |= __get_user(tmpflags, &sc->flags);
-		regs->flags = (regs->flags & ~FIX_EFLAGS) |
-						(tmpflags & FIX_EFLAGS);
-		regs->orig_ax = -1;		/* disable syscall checks */
-	}
-
-	{
-		void __user *buf;
+	err |= __get_user(tmpflags, &sc->flags);
+	regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
+	regs->orig_ax = -1;		/* disable syscall checks */
 
-		err |= __get_user(buf, &sc->fpstate);
-		err |= restore_i387_xstate(buf);
-	}
+	err |= __get_user(buf, &sc->fpstate);
+	err |= restore_i387_xstate(buf);
 
 	err |= __get_user(*pax, &sc->ax);
 	return err;
@@ -214,9 +212,8 @@ badframe:
 	return 0;
 }
 
-asmlinkage int sys_rt_sigreturn(unsigned long __unused)
+static long do_rt_sigreturn(struct pt_regs *regs)
 {
-	struct pt_regs *regs = (struct pt_regs *)&__unused;
 	struct rt_sigframe __user *frame;
 	unsigned long ax;
 	sigset_t set;
@@ -242,10 +239,17 @@ asmlinkage int sys_rt_sigreturn(unsigned long __unused)
 	return ax;
 
 badframe:
-	force_sig(SIGSEGV, current);
+	signal_fault(regs, frame, "rt_sigreturn");
 	return 0;
 }
 
+asmlinkage int sys_rt_sigreturn(unsigned long __unused)
+{
+	struct pt_regs *regs = (struct pt_regs *)&__unused;
+
+	return do_rt_sigreturn(regs);
+}
+
 /*
  * Set up a signal frame.
  */
@@ -337,39 +341,29 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 }
 
 static int
-setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
-	    struct pt_regs *regs)
+__setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
+	      struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
 	void __user *restorer;
 	int err = 0;
-	int usig;
 	void __user *fpstate = NULL;
 
 	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
-	usig = current_thread_info()->exec_domain
-		&& current_thread_info()->exec_domain->signal_invmap
-		&& sig < 32
-		? current_thread_info()->exec_domain->signal_invmap[sig]
-		: sig;
+	if (__put_user(sig, &frame->sig))
+		return -EFAULT;
 
-	err = __put_user(usig, &frame->sig);
-	if (err)
-		goto give_sigsegv;
-
-	err = setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]);
-	if (err)
-		goto give_sigsegv;
+	if (setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]))
+		return -EFAULT;
 
 	if (_NSIG_WORDS > 1) {
-		err = __copy_to_user(&frame->extramask, &set->sig[1],
-				      sizeof(frame->extramask));
-		if (err)
-			goto give_sigsegv;
+		if (__copy_to_user(&frame->extramask, &set->sig[1],
+				   sizeof(frame->extramask)))
+			return -EFAULT;
 	}
 
 	if (current->mm->context.vdso)
@@ -394,7 +388,7 @@ setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	err |= __put_user(0x80cd, (short __user *)(frame->retcode+6));
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	regs->sp = (unsigned long)frame;
@@ -409,38 +403,27 @@ setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	regs->cs = __USER_CS;
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			  sigset_t *set, struct pt_regs *regs)
+static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+			    sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	void __user *restorer;
 	int err = 0;
-	int usig;
 	void __user *fpstate = NULL;
 
 	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
-
-	usig = current_thread_info()->exec_domain
-		&& current_thread_info()->exec_domain->signal_invmap
-		&& sig < 32
-		? current_thread_info()->exec_domain->signal_invmap[sig]
-		: sig;
+		return -EFAULT;
 
-	err |= __put_user(usig, &frame->sig);
+	err |= __put_user(sig, &frame->sig);
 	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
 	err |= copy_siginfo_to_user(&frame->info, info);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Create the ucontext.  */
 	if (cpu_has_xsave)
@@ -456,7 +439,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 				regs, set->sig[0]);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up to return from userspace.  */
 	restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
@@ -476,12 +459,12 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= __put_user(0x80cd, (short __user *)(frame->retcode+5));
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	regs->sp = (unsigned long)frame;
 	regs->ip = (unsigned long)ka->sa.sa_handler;
-	regs->ax = (unsigned long)usig;
+	regs->ax = (unsigned long)sig;
 	regs->dx = (unsigned long)&frame->info;
 	regs->cx = (unsigned long)&frame->uc;
 
@@ -491,15 +474,48 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->cs = __USER_CS;
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 /*
  * OK, we're invoking a handler:
  */
+static int signr_convert(int sig)
+{
+	struct thread_info *info = current_thread_info();
+
+	if (info->exec_domain && info->exec_domain->signal_invmap && sig < 32)
+		return info->exec_domain->signal_invmap[sig];
+	return sig;
+}
+
+#define is_ia32	1
+#define ia32_setup_frame	__setup_frame
+#define ia32_setup_rt_frame	__setup_rt_frame
+
+static int
+setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+	       sigset_t *set, struct pt_regs *regs)
+{
+	int usig = signr_convert(sig);
+	int ret;
+
+	/* Set up the stack frame */
+	if (is_ia32) {
+		if (ka->sa.sa_flags & SA_SIGINFO)
+			ret = ia32_setup_rt_frame(usig, ka, info, set, regs);
+		else
+			ret = ia32_setup_frame(usig, ka, set, regs);
+	} else
+		ret = __setup_rt_frame(sig, ka, info, set, regs);
+
+	if (ret) {
+		force_sigsegv(sig, current);
+		return -EFAULT;
+	}
+
+	return ret;
+}
+
 static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	      sigset_t *oldset, struct pt_regs *regs)
@@ -507,9 +523,9 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	int ret;
 
 	/* Are we from a system call? */
-	if ((long)regs->orig_ax >= 0) {
+	if (syscall_get_nr(current, regs) >= 0) {
 		/* If so, check system call restarting.. */
-		switch (regs->ax) {
+		switch (syscall_get_error(current, regs)) {
 		case -ERESTART_RESTARTBLOCK:
 		case -ERESTARTNOHAND:
 			regs->ax = -EINTR;
@@ -536,15 +552,20 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	    likely(test_and_clear_thread_flag(TIF_FORCED_TF)))
 		regs->flags &= ~X86_EFLAGS_TF;
 
-	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret = setup_rt_frame(sig, ka, info, oldset, regs);
-	else
-		ret = setup_frame(sig, ka, oldset, regs);
+	ret = setup_rt_frame(sig, ka, info, oldset, regs);
 
 	if (ret)
 		return ret;
 
+#ifdef CONFIG_X86_64
+	/*
+	 * This has nothing to do with segment registers,
+	 * despite the name.  This magic affects uaccess.h
+	 * macros' behavior.  Reset it to the normal setting.
+	 */
+	set_fs(USER_DS);
+#endif
+
 	/*
 	 * Clear the direction flag as per the ABI for function entry.
 	 */
@@ -571,6 +592,7 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	return 0;
 }
 
+#define NR_restart_syscall	__NR_restart_syscall
 /*
  * Note that 'init' is a special process: it doesn't get signals it doesn't
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
@@ -623,9 +645,9 @@ static void do_signal(struct pt_regs *regs)
 	}
 
 	/* Did we come from a system call? */
-	if ((long)regs->orig_ax >= 0) {
+	if (syscall_get_nr(current, regs) >= 0) {
 		/* Restart the system call - no handlers present */
-		switch (regs->ax) {
+		switch (syscall_get_error(current, regs)) {
 		case -ERESTARTNOHAND:
 		case -ERESTARTSYS:
 		case -ERESTARTNOINTR:
@@ -634,7 +656,7 @@ static void do_signal(struct pt_regs *regs)
 			break;
 
 		case -ERESTART_RESTARTBLOCK:
-			regs->ax = __NR_restart_syscall;
+			regs->ax = NR_restart_syscall;
 			regs->ip -= 2;
 			break;
 		}
@@ -657,6 +679,12 @@ static void do_signal(struct pt_regs *regs)
 void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
+#if defined(CONFIG_X86_64) && defined(CONFIG_X86_MCE)
+	/* notify userspace of pending MCEs */
+	if (thread_info_flags & _TIF_MCE_NOTIFY)
+		mce_notify_user();
+#endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
+
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
@@ -666,5 +694,23 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 		tracehook_notify_resume(regs);
 	}
 
+#ifdef CONFIG_X86_32
 	clear_thread_flag(TIF_IRET);
+#endif /* CONFIG_X86_32 */
+}
+
+void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
+{
+	struct task_struct *me = current;
+
+	if (show_unhandled_signals && printk_ratelimit()) {
+		printk(KERN_INFO
+		       "%s[%d] bad frame in %s frame:%p ip:%lx sp:%lx orax:%lx",
+		       me->comm, me->pid, where, frame,
+		       regs->ip, regs->sp, regs->orig_ax);
+		print_vma_addr(" in ", regs->ip);
+		printk(KERN_CONT "\n");
+	}
+
+	force_sig(SIGSEGV, me);
 }
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 823a55b..a5c9627 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -52,6 +52,16 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 	return do_sigaltstack(uss, uoss, regs->sp);
 }
 
+#define COPY(x)			{		\
+	err |= __get_user(regs->x, &sc->x);	\
+}
+
+#define COPY_SEG_STRICT(seg)	{			\
+		unsigned short tmp;			\
+		err |= __get_user(tmp, &sc->seg);	\
+		regs->seg = tmp | 3;			\
+}
+
 /*
  * Do a signal return; undo the signal stack.
  */
@@ -59,13 +69,13 @@ static int
 restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 		   unsigned long *pax)
 {
+	void __user *buf;
+	unsigned int tmpflags;
 	unsigned int err = 0;
 
 	/* Always make any pending restarted system calls return -EINTR */
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
 
-#define COPY(x)		(err |= __get_user(regs->x, &sc->x))
-
 	COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
 	COPY(dx); COPY(cx); COPY(ip);
 	COPY(r8);
@@ -80,34 +90,24 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	/* Kernel saves and restores only the CS segment register on signals,
 	 * which is the bare minimum needed to allow mixed 32/64-bit code.
 	 * App's signal handler can save/restore other segments if needed. */
-	{
-		unsigned cs;
-		err |= __get_user(cs, &sc->cs);
-		regs->cs = cs | 3;	/* Force into user mode */
-	}
+	COPY_SEG_STRICT(cs);
 
-	{
-		unsigned int tmpflags;
-		err |= __get_user(tmpflags, &sc->flags);
-		regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
-		regs->orig_ax = -1;		/* disable syscall checks */
-	}
+	err |= __get_user(tmpflags, &sc->flags);
+	regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
+	regs->orig_ax = -1;		/* disable syscall checks */
 
-	{
-		struct _fpstate __user *buf;
-		err |= __get_user(buf, &sc->fpstate);
-		err |= restore_i387_xstate(buf);
-	}
+	err |= __get_user(buf, &sc->fpstate);
+	err |= restore_i387_xstate(buf);
 
 	err |= __get_user(*pax, &sc->ax);
 	return err;
 }
 
-asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
+static long do_rt_sigreturn(struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	sigset_t set;
 	unsigned long ax;
+	sigset_t set;
 
 	frame = (struct rt_sigframe __user *)(regs->sp - sizeof(long));
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
@@ -130,10 +130,15 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 	return ax;
 
 badframe:
-	signal_fault(regs, frame, "sigreturn");
+	signal_fault(regs, frame, "rt_sigreturn");
 	return 0;
 }
 
+asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
+{
+	return do_rt_sigreturn(regs);
+}
+
 /*
  * Set up a signal frame.
  */
@@ -195,8 +200,8 @@ get_stack(struct k_sigaction *ka, struct pt_regs *regs, unsigned long size)
 	return (void __user *)round_down(sp - size, 64);
 }
 
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			   sigset_t *set, struct pt_regs *regs)
+static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+			    sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	void __user *fp = NULL;
@@ -209,17 +214,16 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 			(unsigned long)fp - sizeof(struct rt_sigframe), 16) - 8;
 
 		if (save_i387_xstate(fp) < 0)
-			err |= -1;
+			return -EFAULT;
 	} else
 		frame = get_stack(ka, regs, sizeof(struct rt_sigframe)) - 8;
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (ka->sa.sa_flags & SA_SIGINFO) {
-		err |= copy_siginfo_to_user(&frame->info, info);
-		if (err)
-			goto give_sigsegv;
+		if (copy_siginfo_to_user(&frame->info, info))
+			return -EFAULT;
 	}
 
 	/* Create the ucontext.  */
@@ -247,11 +251,11 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
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
@@ -271,15 +275,45 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->cs = __USER_CS;
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 /*
  * OK, we're invoking a handler
  */
+static int signr_convert(int sig)
+{
+	return sig;
+}
+
+#ifdef CONFIG_IA32_EMULATION
+#define is_ia32	test_thread_flag(TIF_IA32)
+#else
+#define is_ia32	0
+#endif
+
+static int
+setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+	       sigset_t *set, struct pt_regs *regs)
+{
+	int usig = signr_convert(sig);
+	int ret;
+
+	/* Set up the stack frame */
+	if (is_ia32) {
+		if (ka->sa.sa_flags & SA_SIGINFO)
+			ret = ia32_setup_rt_frame(usig, ka, info, set, regs);
+		else
+			ret = ia32_setup_frame(usig, ka, set, regs);
+	} else
+		ret = __setup_rt_frame(sig, ka, info, set, regs);
+
+	if (ret) {
+		force_sigsegv(sig, current);
+		return -EFAULT;
+	}
+
+	return ret;
+}
 
 static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
@@ -317,51 +351,48 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	    likely(test_and_clear_thread_flag(TIF_FORCED_TF)))
 		regs->flags &= ~X86_EFLAGS_TF;
 
-#ifdef CONFIG_IA32_EMULATION
-	if (test_thread_flag(TIF_IA32)) {
-		if (ka->sa.sa_flags & SA_SIGINFO)
-			ret = ia32_setup_rt_frame(sig, ka, info, oldset, regs);
-		else
-			ret = ia32_setup_frame(sig, ka, oldset, regs);
-	} else
-#endif
 	ret = setup_rt_frame(sig, ka, info, oldset, regs);
 
-	if (ret == 0) {
-		/*
-		 * This has nothing to do with segment registers,
-		 * despite the name.  This magic affects uaccess.h
-		 * macros' behavior.  Reset it to the normal setting.
-		 */
-		set_fs(USER_DS);
+	if (ret)
+		return ret;
 
-		/*
-		 * Clear the direction flag as per the ABI for function entry.
-		 */
-		regs->flags &= ~X86_EFLAGS_DF;
+#ifdef CONFIG_X86_64
+	/*
+	 * This has nothing to do with segment registers,
+	 * despite the name.  This magic affects uaccess.h
+	 * macros' behavior.  Reset it to the normal setting.
+	 */
+	set_fs(USER_DS);
+#endif
 
-		/*
-		 * Clear TF when entering the signal handler, but
-		 * notify any tracer that was single-stepping it.
-		 * The tracer may want to single-step inside the
-		 * handler too.
-		 */
-		regs->flags &= ~X86_EFLAGS_TF;
+	/*
+	 * Clear the direction flag as per the ABI for function entry.
+	 */
+	regs->flags &= ~X86_EFLAGS_DF;
 
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
-		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+	/*
+	 * Clear TF when entering the signal handler, but
+	 * notify any tracer that was single-stepping it.
+	 * The tracer may want to single-step inside the
+	 * handler too.
+	 */
+	regs->flags &= ~X86_EFLAGS_TF;
 
-		tracehook_signal_handler(sig, info, ka, regs,
-					 test_thread_flag(TIF_SINGLESTEP));
-	}
+	spin_lock_irq(&current->sighand->siglock);
+	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
+	if (!(ka->sa.sa_flags & SA_NODEFER))
+		sigaddset(&current->blocked, sig);
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
 
-	return ret;
+	tracehook_signal_handler(sig, info, ka, regs,
+				 test_thread_flag(TIF_SINGLESTEP));
+
+	return 0;
 }
 
+#define NR_restart_syscall	\
+	test_thread_flag(TIF_IA32) ? __NR_ia32_restart_syscall : __NR_restart_syscall
 /*
  * Note that 'init' is a special process: it doesn't get signals it doesn't
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
@@ -391,7 +422,8 @@ static void do_signal(struct pt_regs *regs)
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
-		/* Re-enable any watchpoints before delivering the
+		/*
+		 * Re-enable any watchpoints before delivering the
 		 * signal to user space. The processor register will
 		 * have been cleared if the watchpoint triggered
 		 * inside the kernel.
@@ -399,7 +431,7 @@ static void do_signal(struct pt_regs *regs)
 		if (current->thread.debugreg7)
 			set_debugreg(current->thread.debugreg7, 7);
 
-		/* Whee!  Actually deliver the signal.  */
+		/* Whee! Actually deliver the signal.  */
 		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
 			/*
 			 * A signal was successfully delivered; the saved
@@ -422,10 +454,9 @@ static void do_signal(struct pt_regs *regs)
 			regs->ax = regs->orig_ax;
 			regs->ip -= 2;
 			break;
+
 		case -ERESTART_RESTARTBLOCK:
-			regs->ax = test_thread_flag(TIF_IA32) ?
-					__NR_ia32_restart_syscall :
-					__NR_restart_syscall;
+			regs->ax = NR_restart_syscall;
 			regs->ip -= 2;
 			break;
 		}
@@ -441,14 +472,18 @@ static void do_signal(struct pt_regs *regs)
 	}
 }
 
-void do_notify_resume(struct pt_regs *regs, void *unused,
-		      __u32 thread_info_flags)
+/*
+ * notification of userspace execution resumption
+ * - triggered by the TIF_WORK_MASK flags
+ */
+void
+do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
-#ifdef CONFIG_X86_MCE
+#if defined(CONFIG_X86_64) && defined(CONFIG_X86_MCE)
 	/* notify userspace of pending MCEs */
 	if (thread_info_flags & _TIF_MCE_NOTIFY)
 		mce_notify_user();
-#endif /* CONFIG_X86_MCE */
+#endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
 
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
@@ -458,17 +493,23 @@ void do_notify_resume(struct pt_regs *regs, void *unused,
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
 	}
+
+#ifdef CONFIG_X86_32
+	clear_thread_flag(TIF_IRET);
+#endif /* CONFIG_X86_32 */
 }
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
 {
 	struct task_struct *me = current;
+
 	if (show_unhandled_signals && printk_ratelimit()) {
-		printk("%s[%d] bad frame in %s frame:%p ip:%lx sp:%lx orax:%lx",
-	       me->comm, me->pid, where, frame, regs->ip,
-		   regs->sp, regs->orig_ax);
+		printk(KERN_INFO
+		       "%s[%d] bad frame in %s frame:%p ip:%lx sp:%lx orax:%lx",
+		       me->comm, me->pid, where, frame,
+		       regs->ip, regs->sp, regs->orig_ax);
 		print_vma_addr(" in ", regs->ip);
-		printk("\n");
+		printk(KERN_CONT "\n");
 	}
 
 	force_sig(SIGSEGV, me);
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index da5a596..0429c5d 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -891,6 +891,7 @@ void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
 	unsigned int condition;
+	int si_code;
 
 	trace_hardirqs_fixup();
 
@@ -935,8 +936,9 @@ void __kprobes do_debug(struct pt_regs *regs, long error_code)
 			goto clear_TF_reenable;
 	}
 
+	si_code = get_si_code((unsigned long)condition);
 	/* Ok, finally something we can handle */
-	send_sigtrap(tsk, regs, error_code);
+	send_sigtrap(tsk, regs, error_code, si_code);
 
 	/*
 	 * Disable additional traps. They'll be re-enabled when
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 2887a78..9c0ac0c 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -940,7 +940,7 @@ asmlinkage void __kprobes do_debug(struct pt_regs *regs,
 	tsk->thread.error_code = error_code;
 	info.si_signo = SIGTRAP;
 	info.si_errno = 0;
-	info.si_code = TRAP_BRKPT;
+	info.si_code = get_si_code(condition);
 	info.si_addr = user_mode(regs) ? (void __user *)regs->ip : NULL;
 	force_sig_info(SIGTRAP, &info, tsk);
 
diff --git a/include/asm-generic/siginfo.h b/include/asm-generic/siginfo.h
index 8786e01..9695701 100644
--- a/include/asm-generic/siginfo.h
+++ b/include/asm-generic/siginfo.h
@@ -199,6 +199,8 @@ typedef struct siginfo {
  */
 #define TRAP_BRKPT	(__SI_FAULT|1)	/* process breakpoint */
 #define TRAP_TRACE	(__SI_FAULT|2)	/* process trace trap */
+#define TRAP_BRANCH     (__SI_FAULT|3)  /* process taken branch trap */
+#define TRAP_HWBKPT     (__SI_FAULT|4)  /* hardware breakpoint/watchpoint */
 #define NSIGTRAP	2
 
 /*
diff --git a/include/asm-parisc/siginfo.h b/include/asm-parisc/siginfo.h
index d4909f5..d703472 100644
--- a/include/asm-parisc/siginfo.h
+++ b/include/asm-parisc/siginfo.h
@@ -3,11 +3,6 @@
 
 #include <asm-generic/siginfo.h>
 
-/*
- * SIGTRAP si_codes
- */
-#define TRAP_BRANCH	(__SI_FAULT|3)	/* process taken branch trap */
-#define TRAP_HWBKPT	(__SI_FAULT|4)	/* hardware breakpoint or watchpoint */
 #undef NSIGTRAP
 #define NSIGTRAP	4
 
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index d64a610..ac578f1 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -177,11 +177,11 @@ convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
 
 #ifdef CONFIG_X86_32
 extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
-			 int error_code);
-#else
-void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
+			 int error_code, int si_code);
 #endif
 
+void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
+
 extern long syscall_trace_enter(struct pt_regs *);
 extern void syscall_trace_leave(struct pt_regs *);
 
diff --git a/include/asm-x86/traps.h b/include/asm-x86/traps.h
index 2ccebc6..7a692ba 100644
--- a/include/asm-x86/traps.h
+++ b/include/asm-x86/traps.h
@@ -1,6 +1,8 @@
 #ifndef ASM_X86__TRAPS_H
 #define ASM_X86__TRAPS_H
 
+#include <asm/debugreg.h>
+
 /* Common in X86_32 and X86_64 */
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
@@ -36,6 +38,16 @@ void do_invalid_op(struct pt_regs *, long);
 void do_general_protection(struct pt_regs *, long);
 void do_nmi(struct pt_regs *, long);
 
+static inline int get_si_code(unsigned long condition)
+{
+	if (condition & DR_STEP)
+		return TRAP_TRACE;
+	else if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3))
+		return TRAP_HWBKPT;
+	else
+		return TRAP_BRKPT;
+}
+
 extern int panic_on_unrecovered_nmi;
 extern int kstack_depth_to_print;
 
