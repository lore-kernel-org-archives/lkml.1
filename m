Return-Path: <linux-kernel-owner+w=401wt.eu-S1759010AbZADXgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbZADXgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZADXf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:35:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56844 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZADXf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:35:28 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200901051236.281008835@firstfloor.org>
In-Reply-To: <200901051236.281008835@firstfloor.org>
To: akpm@linux-foundation.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/5] Use asm stubs for 32bit sigreturn codes
Message-Id: <20090104233641.6F5723E6652@basil.firstfloor.org>
Date: Mon,  5 Jan 2009 00:36:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


32bit sigreturn/rt_sigreturn currently uses some magic casting
with assumptions about the stack layout
to simulate call by reference for the pt_regs structure on the 
stack. This is fragile, non standard and according to reports 
breaks with LLVM at least. I suppose it could break in
future gcc versions too when their stack layout changes.

So instead of having this magic in C do it in small
assembler stubs similar to what x86-64 does (which
always passes a pointer to pt_regs for such functions)

This also leads to cleaner code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/entry_32.S         |   10 ++++++++++
 arch/x86/kernel/signal_32.c        |   13 ++-----------
 arch/x86/kernel/syscall_table_32.S |    4 ++--
 3 files changed, 14 insertions(+), 13 deletions(-)

Index: linux-2.6.28-test/arch/x86/kernel/entry_32.S
===================================================================
--- linux-2.6.28-test.orig/arch/x86/kernel/entry_32.S	2008-11-06 20:26:33.000000000 +0100
+++ linux-2.6.28-test/arch/x86/kernel/entry_32.S	2009-01-02 16:01:06.000000000 +0100
@@ -1206,6 +1206,16 @@
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #endif /* CONFIG_FUNCTION_TRACER */
 
+ENTRY(stub_sigreturn)
+	movl %esp,%eax
+	jmp sys_sigreturn
+END(stub_sigreturn)
+
+ENTRY(stub_rt_sigreturn)
+	movl %esp,%eax
+	jmp sys_rt_sigreturn
+END(stub_rt_sigreturn)
+
 .section .rodata,"a"
 #include "syscall_table_32.S"
 
Index: linux-2.6.28-test/arch/x86/kernel/signal_32.c
===================================================================
--- linux-2.6.28-test.orig/arch/x86/kernel/signal_32.c	2008-10-24 13:34:40.000000000 +0200
+++ linux-2.6.28-test/arch/x86/kernel/signal_32.c	2009-01-02 16:01:06.000000000 +0100
@@ -169,14 +169,12 @@
 	return err;
 }
 
-asmlinkage unsigned long sys_sigreturn(unsigned long __unused)
+asmlinkage unsigned long sys_sigreturn(struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
-	struct pt_regs *regs;
 	unsigned long ax;
 	sigset_t set;
 
-	regs = (struct pt_regs *) &__unused;
 	frame = (struct sigframe __user *)(regs->sp - 8);
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
@@ -212,7 +210,7 @@
 	return 0;
 }
 
-static long do_rt_sigreturn(struct pt_regs *regs)
+asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	unsigned long ax;
@@ -243,13 +241,6 @@
 	return 0;
 }
 
-asmlinkage int sys_rt_sigreturn(unsigned long __unused)
-{
-	struct pt_regs *regs = (struct pt_regs *)&__unused;
-
-	return do_rt_sigreturn(regs);
-}
-
 /*
  * Set up a signal frame.
  */
Index: linux-2.6.28-test/arch/x86/kernel/syscall_table_32.S
===================================================================
--- linux-2.6.28-test.orig/arch/x86/kernel/syscall_table_32.S	2008-08-15 17:13:40.000000000 +0200
+++ linux-2.6.28-test/arch/x86/kernel/syscall_table_32.S	2009-01-02 16:01:06.000000000 +0100
@@ -118,7 +118,7 @@
 	.long sys_sysinfo
 	.long sys_ipc
 	.long sys_fsync
-	.long sys_sigreturn
+	.long stub_sigreturn
 	.long sys_clone		/* 120 */
 	.long sys_setdomainname
 	.long sys_newuname
@@ -172,7 +172,7 @@
 	.long sys_setresgid16	/* 170 */
 	.long sys_getresgid16
 	.long sys_prctl
-	.long sys_rt_sigreturn
+	.long stub_rt_sigreturn
 	.long sys_rt_sigaction
 	.long sys_rt_sigprocmask	/* 175 */
 	.long sys_rt_sigpending
