Return-Path: <linux-kernel-owner+w=401wt.eu-S1765856AbXHKTG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765856AbXHKTG4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762767AbXHKS6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:46 -0400
Received: from 1wt.eu ([62.212.114.60]:1594 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762729AbXHKS6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:44 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184848.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:14 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Chris Wright <chrisw@sous-sol.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 22/28] POWERPC: Fix subtle FP state corruption bug in signal return on SMP
Content-Disposition: inline; filename=0022-POWERPC-Fix-subtle-FP-state-corruption-bug-in-signa.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a bug which can cause corruption of the floating-point state
on return from a signal handler.  If we have a signal handler that has
used the floating-point registers, and it happens to context-switch to
another task while copying the interrupted floating-point state from the
user stack into the thread struct (e.g. because of a page fault, or
because it gets preempted), the context switch code will think that the
FP registers contain valid FP state that needs to be copied into the
thread_struct, and will thus overwrite the values that the signal return
code has put into the thread_struct.

This can occur because we clear the MSR bits that indicate the presence
of valid FP state after copying the state into the thread_struct.  To fix
this we just move the clearing of the MSR bits to before the copy.  A
similar potential problem also occurs with the Altivec state, and this
fixes that in the same way.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/kernel/signal_64.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index f72e8e8..a84304e 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -177,6 +177,13 @@ static long restore_sigcontext(struct pt_regs *regs, sigset_t *set, int sig,
 	 */
 	discard_lazy_cpu_state();
 
+	/*
+	 * Force reload of FP/VEC.
+	 * This has to be done before copying stuff into current->thread.fpr/vr
+	 * for the reasons explained in the previous comment.
+	 */
+	regs->msr &= ~(MSR_FP | MSR_FE0 | MSR_FE1 | MSR_VEC);
+
 	err |= __copy_from_user(&current->thread.fpr, &sc->fp_regs, FP_REGS_SIZE);
 
 #ifdef CONFIG_ALTIVEC
@@ -198,9 +205,6 @@ static long restore_sigcontext(struct pt_regs *regs, sigset_t *set, int sig,
 		current->thread.vrsave = 0;
 #endif /* CONFIG_ALTIVEC */
 
-	/* Force reload of FP/VEC */
-	regs->msr &= ~(MSR_FP | MSR_FE0 | MSR_FE1 | MSR_VEC);
-
 	return err;
 }
 
-- 
1.5.2.4

-- 
