Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbYJXAOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbYJXAOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 20:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYJXAO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 20:14:29 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:27401 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbYJXAO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 20:14:29 -0400
Message-ID: <49011361.3090907@ct.jp.nec.com>
Date: Thu, 23 Oct 2008 17:14:25 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: signal: cosmetic unification of restore_sigcontext()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Make restore_sigcontext() same.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |   22 ++++++++++++++++++++++
 arch/x86/kernel/signal_64.c |   15 +++++++++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index d6dd057..85a0d37 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -149,14 +149,36 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	/* Always make any pending restarted system calls return -EINTR */
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
 
+#ifdef CONFIG_X86_32
 	GET_SEG(gs);
 	COPY_SEG(fs);
 	COPY_SEG(es);
 	COPY_SEG(ds);
+#endif /* CONFIG_X86_32 */
+
 	COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
 	COPY(dx); COPY(cx); COPY(ip);
+
+#ifdef CONFIG_X86_64
+	COPY(r8);
+	COPY(r9);
+	COPY(r10);
+	COPY(r11);
+	COPY(r12);
+	COPY(r13);
+	COPY(r14);
+	COPY(r15);
+#endif /* CONFIG_X86_64 */
+
+#ifdef CONFIG_X86_32
 	COPY_SEG_STRICT(cs);
 	COPY_SEG_STRICT(ss);
+#else /* !CONFIG_X86_32 */
+	/* Kernel saves and restores only the CS segment register on signals,
+	 * which is the bare minimum needed to allow mixed 32/64-bit code.
+	 * App's signal handler can save/restore other segments if needed. */
+	COPY_SEG_STRICT(cs);
+#endif /* CONFIG_X86_32 */
 
 	err |= __get_user(tmpflags, &sc->flags);
 	regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index a5c9627..9c469da 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -76,8 +76,17 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	/* Always make any pending restarted system calls return -EINTR */
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
 
+#ifdef CONFIG_X86_32
+	GET_SEG(gs);
+	COPY_SEG(fs);
+	COPY_SEG(es);
+	COPY_SEG(ds);
+#endif /* CONFIG_X86_32 */
+
 	COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
 	COPY(dx); COPY(cx); COPY(ip);
+
+#ifdef CONFIG_X86_64
 	COPY(r8);
 	COPY(r9);
 	COPY(r10);
@@ -86,11 +95,17 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	COPY(r13);
 	COPY(r14);
 	COPY(r15);
+#endif /* CONFIG_X86_64 */
 
+#ifdef CONFIG_X86_32
+	COPY_SEG_STRICT(cs);
+	COPY_SEG_STRICT(ss);
+#else /* !CONFIG_X86_32 */
 	/* Kernel saves and restores only the CS segment register on signals,
 	 * which is the bare minimum needed to allow mixed 32/64-bit code.
 	 * App's signal handler can save/restore other segments if needed. */
 	COPY_SEG_STRICT(cs);
+#endif /* CONFIG_X86_32 */
 
 	err |= __get_user(tmpflags, &sc->flags);
 	regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
-- 
1.5.6

