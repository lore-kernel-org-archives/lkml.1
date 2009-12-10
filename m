Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbZLJACM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbZLJACM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759075AbZLJACJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:02:09 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:60782 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759006AbZLJABr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:01:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=T4Pq+QMMREUgVreahcfWdU8XPJUgXLnD976pJPBpZRciiQ04GJ0tcz/kIGErfT30kk
         7nwF2JeGKB77u14VPZnJEc6q2mEai9vck+m4hgxZgD2QYqzLmspaPl3VmZlLGyOtmsNP
         QELFC2NWvCdgenqXZ+PzSq+aPgxf2i0yK7mK4=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, torvalds@linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] x86, 32-bit: Convert sys_vm86 & sys_vm86old
Date: Wed,  9 Dec 2009 19:01:55 -0500
Message-Id: <1260403316-5679-6-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1260403316-5679-1-git-send-email-brgerst@gmail.com>
References: <1260403316-5679-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert these to new PTREGSCALL stubs.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/syscalls.h |    4 ++--
 arch/x86/kernel/entry_32.S      |    4 ++--
 arch/x86/kernel/vm86_32.c       |   11 +++++------
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 94e0b61..df2c511 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -66,8 +66,8 @@ asmlinkage int sys_uname(struct old_utsname __user *);
 asmlinkage int sys_olduname(struct oldold_utsname __user *);
 
 /* kernel/vm86_32.c */
-int sys_vm86old(struct pt_regs *);
-int sys_vm86(struct pt_regs *);
+int sys_vm86old(struct vm86_struct __user *, struct pt_regs *);
+int sys_vm86(unsigned long, unsigned long, struct pt_regs *);
 
 #else /* CONFIG_X86_32 */
 
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 621ef45..6c2f25d 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -766,8 +766,8 @@ PTREGSCALL3(execve)
 PTREGSCALL2(sigaltstack)
 PTREGSCALL0(sigreturn)
 PTREGSCALL0(rt_sigreturn)
-PTREGSCALL0(vm86)
-PTREGSCALL0(vm86old)
+PTREGSCALL2(vm86)
+PTREGSCALL1(vm86old)
 
 .macro FIXUP_ESPFIX_STACK
 /*
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 9c4e625..5ffb562 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -197,9 +197,8 @@ out:
 static int do_vm86_irq_handling(int subfunction, int irqnumber);
 static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk);
 
-int sys_vm86old(struct pt_regs *regs)
+int sys_vm86old(struct vm86_struct __user *v86, struct pt_regs *regs)
 {
-	struct vm86_struct __user *v86 = (struct vm86_struct __user *)regs->bx;
 	struct kernel_vm86_struct info; /* declare this _on top_,
 					 * this avoids wasting of stack space.
 					 * This remains on the stack until we
@@ -227,7 +226,7 @@ out:
 }
 
 
-int sys_vm86(struct pt_regs *regs)
+int sys_vm86(unsigned long cmd, unsigned long arg, struct pt_regs *regs)
 {
 	struct kernel_vm86_struct info; /* declare this _on top_,
 					 * this avoids wasting of stack space.
@@ -239,12 +238,12 @@ int sys_vm86(struct pt_regs *regs)
 	struct vm86plus_struct __user *v86;
 
 	tsk = current;
-	switch (regs->bx) {
+	switch (cmd) {
 	case VM86_REQUEST_IRQ:
 	case VM86_FREE_IRQ:
 	case VM86_GET_IRQ_BITS:
 	case VM86_GET_AND_RESET_IRQ:
-		ret = do_vm86_irq_handling(regs->bx, (int)regs->cx);
+		ret = do_vm86_irq_handling(cmd, (int)arg);
 		goto out;
 	case VM86_PLUS_INSTALL_CHECK:
 		/*
@@ -261,7 +260,7 @@ int sys_vm86(struct pt_regs *regs)
 	ret = -EPERM;
 	if (tsk->thread.saved_sp0)
 		goto out;
-	v86 = (struct vm86plus_struct __user *)regs->cx;
+	v86 = (struct vm86plus_struct __user *)arg;
 	tmp = copy_vm86_regs_from_user(&info.regs, &v86->regs,
 				       offsetof(struct kernel_vm86_struct, regs32) -
 				       sizeof(info.regs));
-- 
1.6.5.2

