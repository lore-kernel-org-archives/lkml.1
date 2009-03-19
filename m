Return-Path: <linux-kernel-owner+w=401wt.eu-S1759165AbZCSR4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbZCSR4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbZCSR4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:56:36 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:42952 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbZCSR4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:56:36 -0400
Message-ID: <49C2874D.3080002@ct.jp.nec.com>
Date: Thu, 19 Mar 2009 10:56:29 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: signal: check signal stack overflow properly
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Check alternate signal stack overflow with proper stack pointer. The stack
pointer of the next signal frame is different if that task has i387 state.

On x86_64, redzone would be included.

No need to check SA_ONSTACK if we're already using alternate signal stack.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal.c |   48 +++++++++++++++++++++++++--------------------
 1 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 4da412a..62f2164 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -211,31 +211,27 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 {
 	/* Default to using normal stack */
 	unsigned long sp = regs->sp;
+	int onsigstack = on_sig_stack(sp);
 
 #ifdef CONFIG_X86_64
 	/* redzone */
 	sp -= 128;
 #endif /* CONFIG_X86_64 */
 
-	/*
-	 * If we are on the alternate signal stack and would overflow it, don't.
-	 * Return an always-bogus address instead so we will die with SIGSEGV.
-	 */
-	if (on_sig_stack(sp) && !likely(on_sig_stack(sp - frame_size)))
-		return (void __user *) -1L;
-
-	/* This is the X/Open sanctioned signal stack switching.  */
-	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (sas_ss_flags(sp) == 0)
-			sp = current->sas_ss_sp + current->sas_ss_size;
-	} else {
+	if (!onsigstack) {
+		/* This is the X/Open sanctioned signal stack switching.  */
+		if (ka->sa.sa_flags & SA_ONSTACK) {
+			if (sas_ss_flags(sp) == 0)
+				sp = current->sas_ss_sp + current->sas_ss_size;
+		} else {
 #ifdef CONFIG_X86_32
-		/* This is the legacy signal stack switching. */
-		if ((regs->ss & 0xffff) != __USER_DS &&
-			!(ka->sa.sa_flags & SA_RESTORER) &&
-				ka->sa.sa_restorer)
-			sp = (unsigned long) ka->sa.sa_restorer;
+			/* This is the legacy signal stack switching. */
+			if ((regs->ss & 0xffff) != __USER_DS &&
+				!(ka->sa.sa_flags & SA_RESTORER) &&
+					ka->sa.sa_restorer)
+				sp = (unsigned long) ka->sa.sa_restorer;
 #endif /* CONFIG_X86_32 */
+		}
 	}
 
 	if (used_math()) {
@@ -244,12 +240,22 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 		sp = round_down(sp, 64);
 #endif /* CONFIG_X86_64 */
 		*fpstate = (void __user *)sp;
-
-		if (save_i387_xstate(*fpstate) < 0)
-			return (void __user *)-1L;
 	}
 
-	return (void __user *)align_sigframe(sp - frame_size);
+	sp = align_sigframe(sp - frame_size);
+
+	/*
+	 * If we are on the alternate signal stack and would overflow it, don't.
+	 * Return an always-bogus address instead so we will die with SIGSEGV.
+	 */
+	if (onsigstack && !likely(on_sig_stack(sp)))
+		return (void __user *)-1L;
+
+	/* save i387 state */
+	if (used_math() && save_i387_xstate(*fpstate) < 0)
+		return (void __user *)-1L;
+
+	return (void __user *)sp;
 }
 
 #ifdef CONFIG_X86_32
-- 
1.6.1.2

