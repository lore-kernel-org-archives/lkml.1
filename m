Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbYJCFKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbYJCFKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 01:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYJCFJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 01:09:52 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:45300 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYJCFJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 01:09:52 -0400
Message-ID: <48E5A900.6090308@ct.jp.nec.com>
Date: Thu, 02 Oct 2008 22:09:20 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86: signal: move macros out from restore_sigcontext()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

move macros, COPY, COPY_SEG*, GET_SEG, out from restore_sigcontext().
x86_64: introduce COPY_SEG_STRICT for cs.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |   38 +++++++++++++++++++++-----------------
 arch/x86/kernel/signal_64.c |   18 +++++++++++-------
 2 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 4337cd5..545448b 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -113,6 +113,27 @@ asmlinkage int sys_sigaltstack(unsigned long bx)
 	return do_sigaltstack(uss, uoss, regs->sp);
 }
 
+#define COPY(x)			{		\
+	err |= __get_user(regs->x, &sc->x);	\
+}
+
+#define COPY_SEG(seg)		{			\
+		unsigned short tmp;			\
+		err |= __get_user(tmp, &sc->seg);	\
+		regs->seg = tmp;			\
+}
+
+#define COPY_SEG_STRICT(seg)	{			\
+		unsigned short tmp;			\
+		err |= __get_user(tmp, &sc->seg);	\
+		regs->seg = tmp | 3;			\
+}
+
+#define GET_SEG(seg)		{			\
+		unsigned short tmp;			\
+		err |= __get_user(tmp, &sc->seg);	\
+		loadsegment(seg, tmp);			\
+}
 
 /*
  * Do a signal return; undo the signal stack.
@@ -126,23 +147,6 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	/* Always make any pending restarted system calls return -EINTR */
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
 
-#define COPY(x)		err |= __get_user(regs->x, &sc->x)
-
-#define COPY_SEG(seg)							\
-	{ unsigned short tmp;						\
-	  err |= __get_user(tmp, &sc->seg);				\
-	  regs->seg = tmp; }
-
-#define COPY_SEG_STRICT(seg)						\
-	{ unsigned short tmp;						\
-	  err |= __get_user(tmp, &sc->seg);				\
-	  regs->seg = tmp|3; }
-
-#define GET_SEG(seg)							\
-	{ unsigned short tmp;						\
-	  err |= __get_user(tmp, &sc->seg);				\
-	  loadsegment(seg, tmp); }
-
 	GET_SEG(gs);
 	COPY_SEG(fs);
 	COPY_SEG(es);
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 53f86d9..feff4a9 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -52,6 +52,16 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 	return do_sigaltstack(uss, uoss, regs->sp);
 }
 
+#define COPY(x)			{		\
+	err |= __get_user(regs->x, &sc->x);	\
+}
+
+#define COPY_SEG_STRICT(seg)	{			\
+		unsigned short tmp;			\
+		err |= __get_user(tmp, &sc->seg);	\
+		regs->seg = tmp | 3;			\
+}
+
 /*
  * Do a signal return; undo the signal stack.
  */
@@ -64,8 +74,6 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	/* Always make any pending restarted system calls return -EINTR */
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
 
-#define COPY(x)		(err |= __get_user(regs->x, &sc->x))
-
 	COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
 	COPY(dx); COPY(cx); COPY(ip);
 	COPY(r8);
@@ -80,11 +88,7 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	/* Kernel saves and restores only the CS segment register on signals,
 	 * which is the bare minimum needed to allow mixed 32/64-bit code.
 	 * App's signal handler can save/restore other segments if needed. */
-	{
-		unsigned cs;
-		err |= __get_user(cs, &sc->cs);
-		regs->cs = cs | 3;	/* Force into user mode */
-	}
+	COPY_SEG_STRICT(cs);
 
 	{
 		unsigned int tmpflags;
