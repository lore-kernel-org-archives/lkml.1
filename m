Return-Path: <linux-kernel-owner+w=401wt.eu-S933636AbYBHUOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636AbYBHUOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935401AbYBHUNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:13:45 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:32862 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935384AbYBHUNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:13:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=reFYfZt0u35PmRZETSsFeIzfuNwVddgrPjOduAeKxuTrp7Qg3dzH/7Dtk1ducAQO21E/jZPI4I7ciYbzx5gGT6cwp7w2rgB3Vej0vBFUro2xQoy0dU7WXJi6Tb2qgT6nWzco0qAZs2P0ja1M7B+T8ez71ZLeZzz4w3bFLivL7x0=
Subject: [PATCH 6/9] x86: use sizeof(long) to unify signal_32|64.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 12:10:00 -0800
Message-Id: <1202501400.12966.25.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use sizeof(long) instead of hardcoded 4 and 8 in offset subtraction.
Clean up small bracketing/trailing space while we're here.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/signal_32.c |    5 +++--
 arch/x86/kernel/signal_64.c |    8 +++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index e93b219..cf6bedf 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -215,11 +215,12 @@ badframe:
 
 asmlinkage int sys_rt_sigreturn(unsigned long __unused)
 {
-	struct pt_regs *regs = (struct pt_regs *) &__unused;
-	struct rt_sigframe __user *frame = (struct rt_sigframe __user *)(regs->sp - 4);
+	struct pt_regs *regs = (struct pt_regs *)&__unused;
+	struct rt_sigframe __user *frame;
 	sigset_t set;
 	int ax;
 
+	frame = (struct rt_sigframe __user *)(regs->sp - sizeof(long));
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
 	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index dced99a..fb27473 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -134,13 +134,11 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 	sigset_t set;
 	unsigned long ax;
 
-	frame = (struct rt_sigframe __user *)(regs->sp - 8);
-	if (!access_ok(VERIFY_READ, frame, sizeof(*frame))) {
+	frame = (struct rt_sigframe __user *)(regs->sp - sizeof(long));
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
-	} 
-	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set))) { 
+	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
 		goto badframe;
-	} 
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
 	spin_lock_irq(&current->sighand->siglock);
-- 
1.5.4.1219.g65b9


