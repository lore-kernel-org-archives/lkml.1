Return-Path: <linux-kernel-owner+w=401wt.eu-S1759169AbZLJAq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169AbZLJAq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759233AbZLJAqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:46:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:52075 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759227AbZLJAqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:46:48 -0500
Date: Thu, 10 Dec 2009 00:46:28 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1260403316-5679-5-git-send-email-brgerst@gmail.com>
References: <1260403316-5679-5-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Merge sys_sigaltstack
Message-ID: <tip-052acad48a566a6dbcccb95e5d22e5e1b7cac8dd@git.kernel.org>
Git-Commit-ID: 052acad48a566a6dbcccb95e5d22e5e1b7cac8dd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  052acad48a566a6dbcccb95e5d22e5e1b7cac8dd
Gitweb:     http://git.kernel.org/tip/052acad48a566a6dbcccb95e5d22e5e1b7cac8dd
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Wed, 9 Dec 2009 19:01:54 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 9 Dec 2009 16:28:59 -0800

x86: Merge sys_sigaltstack

Change 32-bit sys_sigaltstack to PTREGSCALL2, and merge with 64-bit.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1260403316-5679-5-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
