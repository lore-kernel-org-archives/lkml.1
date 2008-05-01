Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbYEACRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbYEACRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755069AbYEACRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:17:06 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:57495 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753535AbYEACRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:17:04 -0400
Date: Thu, 1 May 2008 12:16:28 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200805010216.m412GSNC004094@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: fix signal handling return path
Cc: akpm@linux-foundation.org, gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wilson Callan <wcallan@savantav.com>

The return from software signal handling pushes code on the stack
that system calls to the kernels cleanup code. This is borrowed
directly from the m68k linux signal handler.

The rt signal case is not quite right for the restricted instruction
set of the ColdFire parts. And neither the normal signal case or rt
signal case properly flushes/pushes the appropriate cache lines.

Rework the return path to just call back through some code fragments
in the kernel proper (with no MMU in the way we can do this). No
cache problems, and less code overall.

Original patch submitted by Wilson Callan <wcallan@savantav.com>

Greg fixed the rt signal return path to use the proper system call

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.25/arch/m68knommu/kernel/entry.S linux-2.6.25-uc0/arch/m68knommu/kernel/entry.S
--- linux-2.6.25/arch/m68knommu/kernel/entry.S	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/arch/m68knommu/kernel/entry.S	2008-03-12 16:59:38.000000000 +1000
@@ -32,6 +32,7 @@
 #include <asm/segment.h>
 #include <asm/asm-offsets.h>
 #include <asm/entry.h>
+#include <asm/unistd.h>
 
 .text
 
@@ -140,3 +141,11 @@ ENTRY(sys_rt_sigreturn)
 	RESTORE_SWITCH_STACK
 	rts
 
+ENTRY(ret_from_user_signal)
+	moveq #__NR_sigreturn,%d0
+	trap #0
+
+ENTRY(ret_from_user_rt_signal)
+	move #__NR_rt_sigreturn,%d0
+	trap #0
+
diff -Naurp linux-2.6.25/arch/m68knommu/kernel/signal.c linux-2.6.25-uc0/arch/m68knommu/kernel/signal.c
--- linux-2.6.25/arch/m68knommu/kernel/signal.c	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/arch/m68knommu/kernel/signal.c	2008-03-12 16:59:38.000000000 +1000
@@ -51,6 +51,8 @@
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
+void ret_from_user_signal(void);
+void ret_from_user_rt_signal(void);
 asmlinkage int do_signal(sigset_t *oldset, struct pt_regs *regs);
 
 /*
@@ -539,10 +541,6 @@ static inline int rt_setup_ucontext(stru
 	return err;
 }
 
-static inline void push_cache (unsigned long vaddr)
-{
-}
-
 static inline void *
 get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
 {
@@ -586,16 +584,11 @@ static void setup_frame (int sig, struct
 	err |= copy_to_user (&frame->sc, &context, sizeof(context));
 
 	/* Set up to return from userspace.  */
-	err |= __put_user(frame->retcode, &frame->pretcode);
-	/* moveq #,d0; trap #0 */
-	err |= __put_user(0x70004e40 + (__NR_sigreturn << 16),
-			  (long *)(frame->retcode));
+	err |= __put_user((void *) ret_from_user_signal, &frame->pretcode);
 
 	if (err)
 		goto give_sigsegv;
 
-	push_cache ((unsigned long) &frame->retcode);
-
 	/* Set up registers for signal handler */
 	wrusp ((unsigned long) frame);
 	regs->pc = (unsigned long) ka->sa.sa_handler;
@@ -655,17 +648,11 @@ static void setup_rt_frame (int sig, str
 	err |= copy_to_user (&frame->uc.uc_sigmask, set, sizeof(*set));
 
 	/* Set up to return from userspace.  */
-	err |= __put_user(frame->retcode, &frame->pretcode);
-	/* moveq #,d0; notb d0; trap #0 */
-	err |= __put_user(0x70004600 + ((__NR_rt_sigreturn ^ 0xff) << 16),
-			  (long *)(frame->retcode + 0));
-	err |= __put_user(0x4e40, (short *)(frame->retcode + 4));
+	err |= __put_user((void *) ret_from_user_rt_signal, &frame->pretcode);
 
 	if (err)
 		goto give_sigsegv;
 
-	push_cache ((unsigned long) &frame->retcode);
-
 	/* Set up registers for signal handler */
 	wrusp ((unsigned long) frame);
 	regs->pc = (unsigned long) ka->sa.sa_handler;
