Return-Path: <linux-kernel-owner+w=401wt.eu-S1763780AbYCGPvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763780AbYCGPvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 10:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbYCGPvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 10:51:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36675 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbYCGPvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 10:51:08 -0500
Date: Fri, 7 Mar 2008 16:50:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20080307155048.GA4659@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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


Linus, please pull the latest x86 fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git for-linus

Note: the "x86: clear DF before calling signal handler" commit 
changes/fixes our signal frame ABI on 32-bit and 64-bit x86.

Thanks,

	Ingo

------------------>
Aurelien Jarno (1):
      x86: clear DF before calling signal handler

Ingo Molnar (1):
      x86: re-add reboot fixups

Jan Beulich (2):
      x86: fix merge mistake in i387.c
      x86: fix typo in step.c

Peter Korsgaard (1):
      x86-boot: don't request VBE2 information

 arch/x86/boot/vesa.h        |    9 +--------
 arch/x86/boot/video-vesa.c  |    2 --
 arch/x86/ia32/ia32_signal.c |    4 ++--
 arch/x86/kernel/i387.c      |    2 +-
 arch/x86/kernel/reboot.c    |    6 ++++++
 arch/x86/kernel/signal_32.c |    4 ++--
 arch/x86/kernel/signal_64.c |    2 +-
 arch/x86/kernel/step.c      |    4 ++--
 8 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/arch/x86/boot/vesa.h b/arch/x86/boot/vesa.h
index ff5b73c..468e444 100644
--- a/arch/x86/boot/vesa.h
+++ b/arch/x86/boot/vesa.h
@@ -26,17 +26,10 @@ struct vesa_general_info {
 	far_ptr video_mode_ptr;	/* 14 */
 	u16 total_memory;	/* 18 */
 
-	u16 oem_software_rev;	/* 20 */
-	far_ptr oem_vendor_name_ptr;	/* 22 */
-	far_ptr oem_product_name_ptr;	/* 26 */
-	far_ptr oem_product_rev_ptr;	/* 30 */
-
-	u8 reserved[222];	/* 34 */
-	u8 oem_data[256];	/* 256 */
+	u8 reserved[236];	/* 20 */
 } __attribute__ ((packed));
 
 #define VESA_MAGIC ('V' + ('E' << 8) + ('S' << 16) + ('A' << 24))
-#define VBE2_MAGIC ('V' + ('B' << 8) + ('E' << 16) + ('2' << 24))
 
 struct vesa_mode_info {
 	u16 mode_attr;		/* 0 */
diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index 662dd2f..419b5c2 100644
--- a/arch/x86/boot/video-vesa.c
+++ b/arch/x86/boot/video-vesa.c
@@ -37,8 +37,6 @@ static int vesa_probe(void)
 
 	video_vesa.modes = GET_HEAP(struct mode_info, 0);
 
-	vginfo.signature = VBE2_MAGIC;
-
 	ax = 0x4f00;
 	di = (size_t)&vginfo;
 	asm(INT10
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 1c0503b..5e7771a 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -500,7 +500,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	regs->ss = __USER32_DS;
 
 	set_fs(USER_DS);
-	regs->flags &= ~X86_EFLAGS_TF;
+	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 
@@ -600,7 +600,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->ss = __USER32_DS;
 
 	set_fs(USER_DS);
-	regs->flags &= ~X86_EFLAGS_TF;
+	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 60fe801..d2e39e6 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -261,7 +261,7 @@ static void convert_from_fxsr(struct user_i387_ia32_struct *env,
 	}
 #else
 	env->fip = fxsave->fip;
-	env->fcs = fxsave->fcs;
+	env->fcs = (u16) fxsave->fcs | ((u32) fxsave->fop << 16);
 	env->foo = fxsave->foo;
 	env->fos = fxsave->fos;
 #endif
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 7fd6ac4..55ceb8c 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -326,6 +326,10 @@ static inline void kb_wait(void)
 	}
 }
 
+void __attribute__((weak)) mach_reboot_fixups(void)
+{
+}
+
 static void native_machine_emergency_restart(void)
 {
 	int i;
@@ -337,6 +341,8 @@ static void native_machine_emergency_restart(void)
 		/* Could also try the reset bit in the Hammer NB */
 		switch (reboot_type) {
 		case BOOT_KBD:
+			mach_reboot_fixups(); /* for board specific fixups */
+
 			for (i = 0; i < 10; i++) {
 				kb_wait();
 				udelay(50);
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index caee1f0..0157a6f 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -407,7 +407,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 	 * The tracer may want to single-step inside the
 	 * handler too.
 	 */
-	regs->flags &= ~TF_MASK;
+	regs->flags &= ~(TF_MASK | X86_EFLAGS_DF);
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 
@@ -500,7 +500,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	 * The tracer may want to single-step inside the
 	 * handler too.
 	 */
-	regs->flags &= ~TF_MASK;
+	regs->flags &= ~(TF_MASK | X86_EFLAGS_DF);
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 7347bb1..56b72fb 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -295,7 +295,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	   see include/asm-x86_64/uaccess.h for details. */
 	set_fs(USER_DS);
 
-	regs->flags &= ~X86_EFLAGS_TF;
+	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 #ifdef DEBUG_SIG
diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 2ef1a5f..9d406cd 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -166,7 +166,7 @@ static void enable_step(struct task_struct *child, bool block)
 				  child->thread.debugctlmsr | DEBUGCTLMSR_BTF);
 	} else {
 	    write_debugctlmsr(child,
-			      child->thread.debugctlmsr & ~TIF_DEBUGCTLMSR);
+			      child->thread.debugctlmsr & ~DEBUGCTLMSR_BTF);
 
 	    if (!child->thread.debugctlmsr)
 		    clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
@@ -189,7 +189,7 @@ void user_disable_single_step(struct task_struct *child)
 	 * Make sure block stepping (BTF) is disabled.
 	 */
 	write_debugctlmsr(child,
-			  child->thread.debugctlmsr & ~TIF_DEBUGCTLMSR);
+			  child->thread.debugctlmsr & ~DEBUGCTLMSR_BTF);
 
 	if (!child->thread.debugctlmsr)
 		clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
