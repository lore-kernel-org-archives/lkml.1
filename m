Return-Path: <linux-kernel-owner+w=401wt.eu-S935545AbYBHUOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935545AbYBHUOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935389AbYBHUNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:13:44 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:32862 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935376AbYBHUNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:13:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=G64Kt5Qf3hbVceGg2D80Y4DvgK0y9EnNT2rALAsEfJ2bfSu6zfN02xVuqeRk314BbLJn4e4dcHVRRGzeVv1M6dGFVt09IDbZub56P9AwZU4pAGYTLoulLISeLHfsxcVqch5Auvqr/+N3/YIc6N+/ptrJGpzsH6iVZ7nTkdRAkeQ=
Subject: [PATCH 5/9] x86: Use FIX_EFLAGS define in X86_64
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 12:09:59 -0800
Message-Id: <1202501399.12966.24.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X86_64 differs by one bit from X86_32 in that it does not include
X86_EFLAGS_RF.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/signal_32.c |   17 ++++++++++++-----
 arch/x86/kernel/signal_64.c |   15 ++++++++++++++-
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 70d0cc8..e93b219 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -30,6 +30,18 @@
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
+#ifdef CONFIG_X86_32
+#define	FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_RF | X86_EFLAGS_OF | \
+			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
+			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
+			 X86_EFLAGS_CF)
+#else
+#define	FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
+			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
+			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
+			 X86_EFLAGS_CF)
+#endif
+
 /*
  * Atomically swap in the new signal mask, and wait for a signal.
  */
@@ -122,11 +134,6 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, int *peax
 	  err |= __get_user(tmp, &sc->seg);				\
 	  loadsegment(seg,tmp); }
 
-#define	FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_RF |		 \
-			 X86_EFLAGS_OF | X86_EFLAGS_DF |		 \
-			 X86_EFLAGS_TF | X86_EFLAGS_SF | X86_EFLAGS_ZF | \
-			 X86_EFLAGS_AF | X86_EFLAGS_PF | X86_EFLAGS_CF)
-
 	GET_SEG(gs);
 	COPY_SEG(fs);
 	COPY_SEG(es);
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index a1e56dc..dced99a 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -19,6 +19,7 @@
 #include <linux/stddef.h>
 #include <linux/personality.h>
 #include <linux/compiler.h>
+#include <asm/processor.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/i387.h>
@@ -30,6 +31,18 @@
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
+#ifdef CONFIG_X86_32
+#define	FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_RF | X86_EFLAGS_OF | \
+			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
+			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
+			 X86_EFLAGS_CF)
+#else
+#define	FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
+			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
+			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
+			 X86_EFLAGS_CF)
+#endif
+
 int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
                sigset_t *set, struct pt_regs * regs); 
 int ia32_setup_frame(int sig, struct k_sigaction *ka,
@@ -87,7 +100,7 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, unsigned
 	{
 		unsigned int tmpflags;
 		err |= __get_user(tmpflags, &sc->flags);
-		regs->flags = (regs->flags & ~0x40DD5) | (tmpflags & 0x40DD5);
+		regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
 		regs->orig_ax = -1;		/* disable syscall checks */
 	}
 
-- 
1.5.4.1219.g65b9


