Return-Path: <linux-kernel-owner+w=401wt.eu-S1762904AbZD2Wj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762904AbZD2Wj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760219AbZD2WVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:51 -0400
Received: from kroah.org ([198.145.64.141]:40685 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619AbZD2WVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:46 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:29 2009
Message-Id: <20090429220929.842695986@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, benh@kernel.crashing.org,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: [patch 46/58] powerpc: Sanitize stack pointer in signal handling code
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-sanitize-stack-pointer-in-signal-handling-code.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Josh Boyer <jwboyer@linux.vnet.ibm.com>

This has been backported to 2.6.27.x from commit efbda86098 in Linus' tree.

On powerpc64 machines running 32-bit userspace, we can get garbage bits in the
stack pointer passed into the kernel.  Most places handle this correctly, but
the signal handling code uses the passed value directly for allocating signal
stack frames.

This fixes the issue by introducing a get_clean_sp function that returns a
sanitized stack pointer.  For 32-bit tasks on a 64-bit kernel, the stack
pointer is masked correctly.  In all other cases, the stack pointer is simply
returned.

Additionally, we pass an 'is_32' parameter to get_sigframe now in order to
get the properly sanitized stack.  The callers are know to be 32 or 64-bit
statically.

Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/include/asm/processor.h |   19 +++++++++++++++++++
 arch/powerpc/kernel/signal.c         |    4 ++--
 arch/powerpc/kernel/signal.h         |    2 +-
 arch/powerpc/kernel/signal_32.c      |    4 ++--
 arch/powerpc/kernel/signal_64.c      |    2 +-
 5 files changed, 25 insertions(+), 6 deletions(-)

--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -309,6 +309,25 @@ static inline void prefetchw(const void 
 #define HAVE_ARCH_PICK_MMAP_LAYOUT
 #endif
 
+#ifdef CONFIG_PPC64
+static inline unsigned long get_clean_sp(struct pt_regs *regs, int is_32)
+{
+	unsigned long sp;
+
+	if (is_32)
+		sp = regs->gpr[1] & 0x0ffffffffUL;
+	else
+		sp = regs->gpr[1];
+
+	return sp;
+}
+#else
+static inline unsigned long get_clean_sp(struct pt_regs *regs, int is_32)
+{
+	return regs->gpr[1];
+}
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_POWERPC_PROCESSOR_H */
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -836,7 +836,7 @@ int handle_rt_signal32(unsigned long sig
 
 	/* Set up Signal Frame */
 	/* Put a Real Time Context onto stack */
-	rt_sf = get_sigframe(ka, regs, sizeof(*rt_sf));
+	rt_sf = get_sigframe(ka, regs, sizeof(*rt_sf), 1);
 	addr = rt_sf;
 	if (unlikely(rt_sf == NULL))
 		goto badframe;
@@ -1170,7 +1170,7 @@ int handle_signal32(unsigned long sig, s
 	unsigned long newsp = 0;
 
 	/* Set up Signal Frame */
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), 1);
 	if (unlikely(frame == NULL))
 		goto badframe;
 	sc = (struct sigcontext __user *) &frame->sctx;
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -404,7 +404,7 @@ int handle_rt_signal64(int signr, struct
 	unsigned long newsp = 0;
 	long err = 0;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), 0);
 	if (unlikely(frame == NULL))
 		goto badframe;
 
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -26,12 +26,12 @@ int show_unhandled_signals = 0;
  * Allocate space for the signal frame
  */
 void __user * get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
-			   size_t frame_size)
+			   size_t frame_size, int is_32)
 {
         unsigned long oldsp, newsp;
 
         /* Default to using normal stack */
-        oldsp = regs->gpr[1];
+        oldsp = get_clean_sp(regs, is_32);
 
 	/* Check for alt stack */
 	if ((ka->sa.sa_flags & SA_ONSTACK) &&
--- a/arch/powerpc/kernel/signal.h
+++ b/arch/powerpc/kernel/signal.h
@@ -13,7 +13,7 @@
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
 extern void __user * get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
-				  size_t frame_size);
+				  size_t frame_size, int is_32);
 extern void restore_sigmask(sigset_t *set);
 
 extern int handle_signal32(unsigned long sig, struct k_sigaction *ka,


