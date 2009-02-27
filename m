Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbZB0SaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbZB0SaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 13:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbZB0SaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 13:30:00 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:1437 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbZB0S37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 13:29:59 -0500
Message-ID: <49A83125.7080401@ct.jp.nec.com>
Date: Fri, 27 Feb 2009 10:29:57 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] x86: signal: unify get_sigframe()
References: <49A83078.3020207@ct.jp.nec.com>
In-Reply-To: <49A83078.3020207@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Unify get_sigframe().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal.c |   97 +++++++++++++++++++--------------------------
 1 files changed, 41 insertions(+), 56 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 951aa60..83212e3 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -187,28 +187,6 @@ setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 /*
  * Set up a signal frame.
  */
-#ifdef CONFIG_X86_32
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
 
 /*
  * Determine which stack to use..
@@ -217,10 +195,13 @@ static inline void __user *
 get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 	     void __user **fpstate)
 {
-	unsigned long sp;
-
 	/* Default to using normal stack */
-	sp = regs->sp;
+	unsigned long sp = regs->sp;
+
+#ifdef CONFIG_X86_64
+	/* redzone */
+	sp -= 128;
+#endif /* CONFIG_X86_64 */
 
 	/*
 	 * If we are on the alternate signal stack and would overflow it, don't.
@@ -234,30 +215,64 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 		if (sas_ss_flags(sp) == 0)
 			sp = current->sas_ss_sp + current->sas_ss_size;
 	} else {
+#ifdef CONFIG_X86_32
 		/* This is the legacy signal stack switching. */
 		if ((regs->ss & 0xffff) != __USER_DS &&
 			!(ka->sa.sa_flags & SA_RESTORER) &&
 				ka->sa.sa_restorer)
 			sp = (unsigned long) ka->sa.sa_restorer;
+#endif /* CONFIG_X86_32 */
 	}
 
 	if (used_math()) {
-		sp = sp - sig_xstate_size;
+		sp -= sig_xstate_size;
+#ifdef CONFIG_X86_32
 		*fpstate = (void __user *) sp;
+#else /* !CONFIG_X86_32 */
+		*fpstate = (void __user *)round_down(sp, 64);
+#endif /* CONFIG_X86_32 */
+
 		if (save_i387_xstate(*fpstate) < 0)
 			return (void __user *)-1L;
 	}
 
 	sp -= frame_size;
+#ifdef CONFIG_X86_32
 	/*
 	 * Align the stack pointer according to the i386 ABI,
 	 * i.e. so that on function entry ((sp + 4) & 15) == 0.
 	 */
 	sp = ((sp + 4) & -16ul) - 4;
+#else /* !CONFIG_X86_32 */
+	sp = round_down(sp, 16) - 8;
+#endif
 
 	return (void __user *) sp;
 }
 
+#ifdef CONFIG_X86_32
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
 static int
 __setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	      struct pt_regs *regs)
@@ -388,36 +403,6 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	return 0;
 }
 #else /* !CONFIG_X86_32 */
-/*
- * Determine which stack to use..
- */
-static void __user *
-get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
-	     void __user **fpstate)
-{
-	unsigned long sp;
-
-	/* Default to using normal stack - redzone */
-	sp = regs->sp - 128;
-
-	/* This is the X/Open sanctioned signal stack switching.  */
-	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (sas_ss_flags(sp) == 0)
-			sp = current->sas_ss_sp + current->sas_ss_size;
-	}
-
-	if (used_math()) {
-		sp -= sig_xstate_size;
-		*fpstate = (void __user *)round_down(sp, 64);
-
-		if (save_i387_xstate(*fpstate) < 0)
-			return (void __user *) -1L;
-	}
-
-	sp -= frame_size;
-	return (void __user *)round_down(sp, 16) - 8;
-}
-
 static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 			    sigset_t *set, struct pt_regs *regs)
 {
-- 
1.6.1.2

