Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbZLJArg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbZLJArg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZLJArb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:47:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:52093 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759310AbZLJArD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:47:03 -0500
Date: Thu, 10 Dec 2009 00:46:58 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1260403316-5679-7-git-send-email-brgerst@gmail.com>
References: <1260403316-5679-7-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Merge sys_clone
Message-ID: <tip-f839bbc5c81b1c92ff8e81c360e9564f7b961b2e@git.kernel.org>
Git-Commit-ID: f839bbc5c81b1c92ff8e81c360e9564f7b961b2e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f839bbc5c81b1c92ff8e81c360e9564f7b961b2e
Gitweb:     http://git.kernel.org/tip/f839bbc5c81b1c92ff8e81c360e9564f7b961b2e
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Wed, 9 Dec 2009 19:01:56 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 9 Dec 2009 16:29:42 -0800

x86: Merge sys_clone

Change 32-bit sys_clone to new PTREGSCALL stub, and merge with 64-bit.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1260403316-5679-7-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/syscalls.h |    8 ++------
 arch/x86/kernel/entry_32.S      |   14 +++++++++++++-
 arch/x86/kernel/process.c       |    9 +++++++++
 arch/x86/kernel/process_32.c    |   15 ---------------
 arch/x86/kernel/process_64.c    |    9 ---------
 5 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index df2c511..b0ce780 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -25,6 +25,8 @@ int sys_fork(struct pt_regs *);
 int sys_vfork(struct pt_regs *);
 long sys_execve(char __user *, char __user * __user *,
 		char __user * __user *, struct pt_regs *);
+long sys_clone(unsigned long, unsigned long, void __user *,
+	       void __user *, struct pt_regs *);
 
 /* kernel/ldt.c */
 asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
@@ -42,9 +44,6 @@ asmlinkage int sys_get_thread_area(struct user_desc __user *);
 /* X86_32 only */
 #ifdef CONFIG_X86_32
 
-/* kernel/process_32.c */
-int sys_clone(struct pt_regs *);
-
 /* kernel/signal.c */
 asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
 asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
@@ -73,9 +72,6 @@ int sys_vm86(unsigned long, unsigned long, struct pt_regs *);
 
 /* X86_64 only */
 /* kernel/process_64.c */
-asmlinkage long sys_clone(unsigned long, unsigned long,
-			  void __user *, void __user *,
-			  struct pt_regs *);
 long sys_arch_prctl(int, unsigned long);
 
 /* kernel/sys_x86_64.c */
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 6c2f25d..6492555 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -760,7 +760,6 @@ ptregs_##name: \
 
 PTREGSCALL1(iopl)
 PTREGSCALL0(fork)
-PTREGSCALL0(clone)
 PTREGSCALL0(vfork)
 PTREGSCALL3(execve)
 PTREGSCALL2(sigaltstack)
@@ -769,6 +768,19 @@ PTREGSCALL0(rt_sigreturn)
 PTREGSCALL2(vm86)
 PTREGSCALL1(vm86old)
 
+/* Clone is an oddball.  The 4th arg is in %edi */
+	ALIGN;
+ptregs_clone:
+	leal 4(%esp),%eax
+	pushl %eax
+	pushl PT_EDI(%eax)
+	movl PT_EDX(%eax),%ecx
+	movl PT_ECX(%eax),%edx
+	movl PT_EBX(%eax),%eax
+	call sys_clone
+	addl $8,%esp
+	ret
+
 .macro FIXUP_ESPFIX_STACK
 /*
  * Switch back for ESPFIX stack to the normal zerobased stack
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index bb17bd9..f3c1a6b 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -234,6 +234,15 @@ int sys_vfork(struct pt_regs *regs)
 		       NULL, NULL);
 }
 
+long
+sys_clone(unsigned long clone_flags, unsigned long newsp,
+	  void __user *parent_tid, void __user *child_tid, struct pt_regs *regs)
+{
+	if (!newsp)
+		newsp = regs->sp;
+	return do_fork(clone_flags, newsp, regs, 0, parent_tid, child_tid);
+}
+
 
 /*
  * sys_execve() executes a new program.
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 486e38e..506d5a7 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -436,21 +436,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	return prev_p;
 }
 
-int sys_clone(struct pt_regs *regs)
-{
-	unsigned long clone_flags;
-	unsigned long newsp;
-	int __user *parent_tidptr, *child_tidptr;
-
-	clone_flags = regs->bx;
-	newsp = regs->cx;
-	parent_tidptr = (int __user *)regs->dx;
-	child_tidptr = (int __user *)regs->di;
-	if (!newsp)
-		newsp = regs->sp;
-	return do_fork(clone_flags, newsp, regs, 0, parent_tidptr, child_tidptr);
-}
-
 #define top_esp                (THREAD_SIZE - sizeof(unsigned long))
 #define top_ebp                (THREAD_SIZE - 2*sizeof(unsigned long))
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 671960d..83019f9 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -534,15 +534,6 @@ void set_personality_64bit(void)
 	current->personality &= ~READ_IMPLIES_EXEC;
 }
 
-asmlinkage long
-sys_clone(unsigned long clone_flags, unsigned long newsp,
-	  void __user *parent_tid, void __user *child_tid, struct pt_regs *regs)
-{
-	if (!newsp)
-		newsp = regs->sp;
-	return do_fork(clone_flags, newsp, regs, 0, parent_tid, child_tid);
-}
-
 unsigned long get_wchan(struct task_struct *p)
 {
 	unsigned long stack;
