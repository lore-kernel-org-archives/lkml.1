Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbYKVBie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbYKVBie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 20:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbYKVBi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 20:38:26 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:54655 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbYKVBi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 20:38:26 -0500
Message-ID: <49276291.3060403@ct.jp.nec.com>
Date: Fri, 21 Nov 2008 17:38:25 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: signal: cosmetic unification of sys_sigaltstack()
References: <49276229.9060000@ct.jp.nec.com>
In-Reply-To: <49276229.9060000@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Add #ifdef directive for unification.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |    9 +++++++++
 arch/x86/kernel/signal_64.c |   15 +++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 0ff8d87..d990988 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -125,6 +125,7 @@ sys_sigaction(int sig, const struct old_sigaction __user *act,
 	return ret;
 }
 
+#ifdef CONFIG_X86_32
 asmlinkage int sys_sigaltstack(unsigned long bx)
 {
 	/*
@@ -137,6 +138,14 @@ asmlinkage int sys_sigaltstack(unsigned long bx)
 
 	return do_sigaltstack(uss, uoss, regs->sp);
 }
+#else /* !CONFIG_X86_32 */
+asmlinkage long
+sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
+		struct pt_regs *regs)
+{
+	return do_sigaltstack(uss, uoss, regs->sp);
+}
+#endif /* CONFIG_X86_32 */
 
 #define COPY(x)			{		\
 	err |= __get_user(regs->x, &sc->x);	\
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index c52244a..b6e4fe0 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -50,12 +50,27 @@
 # define FIX_EFLAGS	__FIX_EFLAGS
 #endif
 
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
 asmlinkage long
 sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 		struct pt_regs *regs)
 {
 	return do_sigaltstack(uss, uoss, regs->sp);
 }
+#endif /* CONFIG_X86_32 */
 
 #define COPY(x)			{		\
 	err |= __get_user(regs->x, &sc->x);	\
-- 
1.5.6

