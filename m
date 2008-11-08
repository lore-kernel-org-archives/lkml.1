Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbYKHDZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbYKHDZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 22:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYKHDZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 22:25:40 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:51621 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbYKHDZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 22:25:39 -0500
Message-ID: <491506B0.5030503@ct.jp.nec.com>
Date: Fri, 07 Nov 2008 19:25:36 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: signal: cosmetic unification of setup_sigcontext()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Make setup_sigcontext() same.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |   32 ++++++++++++++++++++++++++++----
 arch/x86/kernel/signal_64.c |   33 ++++++++++++++++++++++++++++-----
 2 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 6a05c74..27a5c81 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -279,14 +279,20 @@ static int
 setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 		 struct pt_regs *regs, unsigned long mask)
 {
-	int tmp, err = 0;
+	int err = 0;
 
-	err |= __put_user(regs->fs, (unsigned int __user *)&sc->fs);
-	savesegment(gs, tmp);
-	err |= __put_user(tmp, (unsigned int __user *)&sc->gs);
+#ifdef CONFIG_X86_32
+	{
+		unsigned int tmp;
 
+		savesegment(gs, tmp);
+		err |= __put_user(tmp, (unsigned int __user *)&sc->gs);
+	}
+	err |= __put_user(regs->fs, (unsigned int __user *)&sc->fs);
 	err |= __put_user(regs->es, (unsigned int __user *)&sc->es);
 	err |= __put_user(regs->ds, (unsigned int __user *)&sc->ds);
+#endif /* CONFIG_X86_32 */
+
 	err |= __put_user(regs->di, &sc->di);
 	err |= __put_user(regs->si, &sc->si);
 	err |= __put_user(regs->bp, &sc->bp);
@@ -295,13 +301,31 @@ setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 	err |= __put_user(regs->dx, &sc->dx);
 	err |= __put_user(regs->cx, &sc->cx);
 	err |= __put_user(regs->ax, &sc->ax);
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
 	err |= __put_user(current->thread.trap_no, &sc->trapno);
 	err |= __put_user(current->thread.error_code, &sc->err);
 	err |= __put_user(regs->ip, &sc->ip);
+#ifdef CONFIG_X86_32
 	err |= __put_user(regs->cs, (unsigned int __user *)&sc->cs);
 	err |= __put_user(regs->flags, &sc->flags);
 	err |= __put_user(regs->sp, &sc->sp_at_signal);
 	err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);
+#else /* !CONFIG_X86_32 */
+	err |= __put_user(regs->flags, &sc->flags);
+	err |= __put_user(regs->cs, &sc->cs);
+	err |= __put_user(0, &sc->gs);
+	err |= __put_user(0, &sc->fs);
+#endif /* CONFIG_X86_32 */
 
 	err |= __put_user(fpstate, &sc->fpstate);
 
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 3868c2a..d2307e4 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -157,16 +157,23 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 /*
  * Set up a signal frame.
  */
-
-static inline int
+static int
 setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 		 struct pt_regs *regs, unsigned long mask)
 {
 	int err = 0;
 
-	err |= __put_user(regs->cs, &sc->cs);
-	err |= __put_user(0, &sc->gs);
-	err |= __put_user(0, &sc->fs);
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
 
 	err |= __put_user(regs->di, &sc->di);
 	err |= __put_user(regs->si, &sc->si);
@@ -176,6 +183,7 @@ setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 	err |= __put_user(regs->dx, &sc->dx);
 	err |= __put_user(regs->cx, &sc->cx);
 	err |= __put_user(regs->ax, &sc->ax);
+#ifdef CONFIG_X86_64
 	err |= __put_user(regs->r8, &sc->r8);
 	err |= __put_user(regs->r9, &sc->r9);
 	err |= __put_user(regs->r10, &sc->r10);
@@ -184,11 +192,26 @@ setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 	err |= __put_user(regs->r13, &sc->r13);
 	err |= __put_user(regs->r14, &sc->r14);
 	err |= __put_user(regs->r15, &sc->r15);
+#endif /* CONFIG_X86_64 */
+
 	err |= __put_user(current->thread.trap_no, &sc->trapno);
 	err |= __put_user(current->thread.error_code, &sc->err);
 	err |= __put_user(regs->ip, &sc->ip);
+#ifdef CONFIG_X86_32
+	err |= __put_user(regs->cs, (unsigned int __user *)&sc->cs);
 	err |= __put_user(regs->flags, &sc->flags);
+	err |= __put_user(regs->sp, &sc->sp_at_signal);
+	err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);
+#else /* !CONFIG_X86_32 */
+	err |= __put_user(regs->flags, &sc->flags);
+	err |= __put_user(regs->cs, &sc->cs);
+	err |= __put_user(0, &sc->gs);
+	err |= __put_user(0, &sc->fs);
+#endif /* CONFIG_X86_32 */
+
 	err |= __put_user(fpstate, &sc->fpstate);
+
+	/* non-iBCS2 extensions.. */
 	err |= __put_user(mask, &sc->oldmask);
 	err |= __put_user(current->thread.cr2, &sc->cr2);
 
-- 
1.5.6

