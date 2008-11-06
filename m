Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbYKFCiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbYKFCiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 21:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYKFCiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 21:38:46 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:14511 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbYKFCip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 21:38:45 -0500
Message-ID: <4912577F.70103@ct.jp.nec.com>
Date: Wed, 05 Nov 2008 18:33:35 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] x86: signal_64: setup fpstate in setup_sigcontext()
References: <491256C1.2060709@ct.jp.nec.com>
In-Reply-To: <491256C1.2060709@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

set fpstate field of signal context at setup_sigcontext().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_64.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index cfbb60a..97d26fa 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -159,8 +159,9 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
  */
 
 static inline int
-setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs,
-		unsigned long mask, struct task_struct *me)
+setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
+		 struct pt_regs *regs,
+		 unsigned long mask, struct task_struct *me)
 {
 	int err = 0;
 
@@ -188,6 +189,7 @@ setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs,
 	err |= __put_user(me->thread.error_code, &sc->err);
 	err |= __put_user(regs->ip, &sc->ip);
 	err |= __put_user(regs->flags, &sc->flags);
+	err |= __put_user(fpstate, &sc->fpstate);
 	err |= __put_user(mask, &sc->oldmask);
 	err |= __put_user(me->thread.cr2, &sc->cr2);
 
@@ -249,8 +251,8 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= __put_user(sas_ss_flags(regs->sp),
 			  &frame->uc.uc_stack.ss_flags);
 	err |= __put_user(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
-	err |= setup_sigcontext(&frame->uc.uc_mcontext, regs, set->sig[0], me);
-	err |= __put_user(fp, &frame->uc.uc_mcontext.fpstate);
+	err |= setup_sigcontext(&frame->uc.uc_mcontext, fp,
+				regs, set->sig[0], me);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
 	/* Set up to return from userspace.  If provided, use a stub
-- 
1.5.6

