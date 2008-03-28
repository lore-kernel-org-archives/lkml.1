Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbYC1PBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbYC1PBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 11:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbYC1PBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 11:01:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:33627 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbYC1PBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 11:01:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=Vcf3/9T0QQtavvJDfaM58FNgEgzr4WWvLoZHiAteowXL037D+HlAVolOyp9irGUGSclLnT17R+p8Ky7aqz2KkcCL7XCKxRGC26Joy624QHlikaIXwgzEk27IUtT0lGreEtsSBoCbbBEOhXVimPOcm0I4wA0DiAVr7T0XBCSxtD4=
Message-Id: <20080328150050.993920179@gmail.com>
References: <20080328145655.076024373@gmail.com>
User-Agent: quilt/0.46-1
Date: Fri, 28 Mar 2008 17:56:57 +0300
From: gorcunov@gmail.com
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de
Cc: gorcunov@gmail.com, linux-kernel@vger.kernel.org
Subject: [patch 2/2] x86: cleanup - rename VM_MASK to X86_VM_MASK
Content-Disposition: inline; filename=x86-vm86-vm-mask
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames VM_MASK to X86_VM_MASK (which
in turn defined as alias to X86_EFLAGS_VM) to better
distinguish from virtual memory flags. We can't just
use X86_EFLAGS_VM instead because it is also used
for conditional compilation

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/traps_32.c	2008-03-27 22:14:40.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/traps_32.c	2008-03-27 22:59:24.000000000 +0300
@@ -499,7 +499,7 @@ do_trap(int trapnr, int signr, char *str
 {
 	struct task_struct *tsk = current;
 
-	if (regs->flags & VM_MASK) {
+	if (regs->flags & X86_VM_MASK) {
 		if (vm86)
 			goto vm86_trap;
 		goto trap_signal;
Index: linux-2.6.git/arch/x86/mm/fault.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/fault.c	2008-03-27 21:41:05.000000000 +0300
+++ linux-2.6.git/arch/x86/mm/fault.c	2008-03-27 23:00:40.000000000 +0300
@@ -667,7 +667,7 @@ void __kprobes do_page_fault(struct pt_r
 #ifdef CONFIG_X86_32
 	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
 	   fault has been handled. */
-	if (regs->flags & (X86_EFLAGS_IF|VM_MASK))
+	if (regs->flags & (X86_EFLAGS_IF | X86_VM_MASK))
 		local_irq_enable();
 
 	/*
Index: linux-2.6.git/include/asm-x86/ptrace.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/ptrace.h	2008-03-27 21:41:05.000000000 +0300
+++ linux-2.6.git/include/asm-x86/ptrace.h	2008-03-27 22:59:09.000000000 +0300
@@ -170,7 +170,7 @@ static inline int user_mode(struct pt_re
 static inline int user_mode_vm(struct pt_regs *regs)
 {
 #ifdef CONFIG_X86_32
-	return ((regs->cs & SEGMENT_RPL_MASK) | (regs->flags & VM_MASK)) >=
+	return ((regs->cs & SEGMENT_RPL_MASK) | (regs->flags & X86_VM_MASK)) >=
 		USER_RPL;
 #else
 	return user_mode(regs);
@@ -180,7 +180,7 @@ static inline int user_mode_vm(struct pt
 static inline int v8086_mode(struct pt_regs *regs)
 {
 #ifdef CONFIG_X86_32
-	return (regs->flags & VM_MASK);
+	return (regs->flags & X86_VM_MASK);
 #else
 	return 0;	/* No V86 mode support in long mode */
 #endif
Index: linux-2.6.git/include/asm-x86/vm86.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/vm86.h	2008-03-27 21:44:15.000000000 +0300
+++ linux-2.6.git/include/asm-x86/vm86.h	2008-03-27 22:58:34.000000000 +0300
@@ -15,9 +15,9 @@
 #include <asm/processor-flags.h>
 
 #ifdef CONFIG_VM86
-#define VM_MASK		0x00020000
+#define X86_VM_MASK	X86_EFLAGS_VM
 #else
-#define VM_MASK		0 /* ignored */
+#define X86_VM_MASK	0 /* No VM86 support */
 #endif
 
 #define BIOSSEG		0x0f000

-- 
