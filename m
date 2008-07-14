Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbYGNVOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbYGNVOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 17:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755654AbYGNVOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 17:14:41 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:28024 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbYGNVOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 17:14:40 -0400
Message-ID: <487BC1B9.1090400@ct.jp.nec.com>
Date: Mon, 14 Jul 2008 14:14:33 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: ia32_signal.c: use macro instead of immediate
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Make and use macro FIX_EFLAGS, instead of immediate value 0x40DD5 in
ia32_restore_sigcontext().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index cb3856a..7cf50cb 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -36,6 +36,17 @@
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
+#define __FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
+			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
+			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
+			 X86_EFLAGS_CF)
+
+#ifdef CONFIG_X86_32
+# define FIX_EFLAGS	(__FIX_EFLAGS | X86_EFLAGS_RF)
+#else
+# define FIX_EFLAGS	__FIX_EFLAGS
+#endif
+
 asmlinkage int do_signal(struct pt_regs *regs, sigset_t *oldset);
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
@@ -248,7 +259,7 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 	regs->ss |= 3;
 
 	err |= __get_user(tmpflags, &sc->flags);
-	regs->flags = (regs->flags & ~0x40DD5) | (tmpflags & 0x40DD5);
+	regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
 	/* disable syscall checks */
 	regs->orig_ax = -1;
 
-- 
1.5.4.1


