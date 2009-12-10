Return-Path: <linux-kernel-owner+w=401wt.eu-S1759061AbZLJAB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061AbZLJAB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758996AbZLJABo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:01:44 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:55764 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758949AbZLJABk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:01:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rAV1yOdgJH4UUHTuaA5pMMrmGMfybpJoz2RZ4n93/z2HlsBLHOdwxFoe4FrMnWfZZT
         zd9AEfW/cAT2ecBwZiJscTshHUlfBYdak7ePr2oN9lKjsRgkPhU3h3+6ZbUfZcQzZJBl
         3DfGdV9wmFOQhiqTJsUZHNLEzVn+od9oQWkeQ=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, torvalds@linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] x86: Merge sys_sigaltstack
Date: Wed,  9 Dec 2009 19:01:54 -0500
Message-Id: <1260403316-5679-5-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1260403316-5679-1-git-send-email-brgerst@gmail.com>
References: <1260403316-5679-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change 32-bit sys_sigaltstack to PTREGSCALL2, and merge with 64-bit.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/syscalls.h |    8 +++-----
 arch/x86/kernel/entry_32.S      |    2 +-
 arch/x86/kernel/signal.c        |   12 +-----------
 3 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 48c48e5..94e0b61 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -31,6 +31,9 @@ asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
 
 /* kernel/signal.c */
 long sys_rt_sigreturn(struct pt_regs *);
+long sys_sigaltstack(const stack_t __user *, stack_t __user *,
+		     struct pt_regs *);
+
 
 /* kernel/tls.c */
 asmlinkage int sys_set_thread_area(struct user_desc __user *);
@@ -46,7 +49,6 @@ int sys_clone(struct pt_regs *);
 asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
 asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
 			     struct old_sigaction __user *);
-int sys_sigaltstack(struct pt_regs *);
 unsigned long sys_sigreturn(struct pt_regs *);
 
 /* kernel/sys_i386_32.c */
@@ -76,10 +78,6 @@ asmlinkage long sys_clone(unsigned long, unsigned long,
 			  struct pt_regs *);
 long sys_arch_prctl(int, unsigned long);
 
-/* kernel/signal.c */
-asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t __user *,
-				struct pt_regs *);
-
 /* kernel/sys_x86_64.c */
 struct new_utsname;
 
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index a96a0d8..621ef45 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -763,7 +763,7 @@ PTREGSCALL0(fork)
 PTREGSCALL0(clone)
 PTREGSCALL0(vfork)
 PTREGSCALL3(execve)
-PTREGSCALL0(sigaltstack)
+PTREGSCALL2(sigaltstack)
 PTREGSCALL0(sigreturn)
 PTREGSCALL0(rt_sigreturn)
 PTREGSCALL0(vm86)
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 74fe6d8..4fd173c 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -545,22 +545,12 @@ sys_sigaction(int sig, const struct old_sigaction __user *act,
 }
 #endif /* CONFIG_X86_32 */
 
-#ifdef CONFIG_X86_32
-int sys_sigaltstack(struct pt_regs *regs)
-{
-	const stack_t __user *uss = (const stack_t __user *)regs->bx;
-	stack_t __user *uoss = (stack_t __user *)regs->cx;
-
-	return do_sigaltstack(uss, uoss, regs->sp);
-}
-#else /* !CONFIG_X86_32 */
-asmlinkage long
+long
 sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 		struct pt_regs *regs)
 {
 	return do_sigaltstack(uss, uoss, regs->sp);
 }
-#endif /* CONFIG_X86_32 */
 
 /*
  * Do a signal return; undo the signal stack.
-- 
1.6.5.2

