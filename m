Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbZLJAq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbZLJAq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759227AbZLJAq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:46:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:59240 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759169AbZLJAqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:46:20 -0500
Date: Thu, 10 Dec 2009 00:46:14 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1260403316-5679-4-git-send-email-brgerst@gmail.com>
References: <1260403316-5679-4-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Merge sys_execve
Message-ID: <tip-11cf88bd0b8165b65aaabaee0977e9a3ad474ab7@git.kernel.org>
Git-Commit-ID: 11cf88bd0b8165b65aaabaee0977e9a3ad474ab7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11cf88bd0b8165b65aaabaee0977e9a3ad474ab7
Gitweb:     http://git.kernel.org/tip/11cf88bd0b8165b65aaabaee0977e9a3ad474ab7
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Wed, 9 Dec 2009 19:01:53 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 9 Dec 2009 16:28:34 -0800

x86: Merge sys_execve

Change 32-bit sys_execve to PTREGSCALL3, and merge with 64-bit.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1260403316-5679-4-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/syscalls.h |    6 ++----
 arch/x86/kernel/entry_32.S      |    2 +-
 arch/x86/kernel/process.c       |   26 ++++++++++++++++++++++++++
 arch/x86/kernel/process_32.c    |   25 -------------------------
 arch/x86/kernel/process_64.c    |   19 -------------------
 5 files changed, 29 insertions(+), 49 deletions(-)

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 4b694cd..48c48e5 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -23,6 +23,8 @@ long sys_iopl(unsigned int, struct pt_regs *);
 /* kernel/process.c */
 int sys_fork(struct pt_regs *);
 int sys_vfork(struct pt_regs *);
+long sys_execve(char __user *, char __user * __user *,
+		char __user * __user *, struct pt_regs *);
 
 /* kernel/ldt.c */
 asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
@@ -39,7 +41,6 @@ asmlinkage int sys_get_thread_area(struct user_desc __user *);
 
 /* kernel/process_32.c */
 int sys_clone(struct pt_regs *);
-int sys_execve(struct pt_regs *);
 
 /* kernel/signal.c */
 asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
@@ -73,9 +74,6 @@ int sys_vm86(struct pt_regs *);
 asmlinkage long sys_clone(unsigned long, unsigned long,
 			  void __user *, void __user *,
 			  struct pt_regs *);
-asmlinkage long sys_execve(char __user *, char __user * __user *,
-			   char __user * __user *,
-			   struct pt_regs *);
 long sys_arch_prctl(int, unsigned long);
 
 /* kernel/signal.c */
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index ab7fcef..a96a0d8 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -762,7 +762,7 @@ PTREGSCALL1(iopl)
 PTREGSCALL0(fork)
 PTREGSCALL0(clone)
 PTREGSCALL0(vfork)
-PTREGSCALL0(execve)
+PTREGSCALL3(execve)
 PTREGSCALL0(sigaltstack)
 PTREGSCALL0(sigreturn)
 PTREGSCALL0(rt_sigreturn)
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 5e2ba63..bb17bd9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -236,6 +236,32 @@ int sys_vfork(struct pt_regs *regs)
 
 
 /*
+ * sys_execve() executes a new program.
+ */
+long sys_execve(char __user *name, char __user * __user *argv,
+		char __user * __user *envp, struct pt_regs *regs)
+{
+	long error;
+	char *filename;
+
+	filename = getname(name);
+	error = PTR_ERR(filename);
+	if (IS_ERR(filename))
+		return error;
+	error = do_execve(filename, argv, envp, regs);
+
+#ifdef CONFIG_X86_32
+	if (error == 0) {
+		/* Make sure we don't return using sysenter.. */
+                set_thread_flag(TIF_IRET);
+        }
+#endif
+
+	putname(filename);
+	return error;
+}
+
+/*
  * Idle related variables and functions
  */
 unsigned long boot_option_idle_override = 0;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 075580b..486e38e 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -451,31 +451,6 @@ int sys_clone(struct pt_regs *regs)
 	return do_fork(clone_flags, newsp, regs, 0, parent_tidptr, child_tidptr);
 }
 
-/*
- * sys_execve() executes a new program.
- */
-int sys_execve(struct pt_regs *regs)
-{
-	int error;
-	char *filename;
-
-	filename = getname((char __user *) regs->bx);
-	error = PTR_ERR(filename);
-	if (IS_ERR(filename))
-		goto out;
-	error = do_execve(filename,
-			(char __user * __user *) regs->cx,
-			(char __user * __user *) regs->dx,
-			regs);
-	if (error == 0) {
-		/* Make sure we don't return using sysenter.. */
-		set_thread_flag(TIF_IRET);
-	}
-	putname(filename);
-out:
-	return error;
-}
-
 #define top_esp                (THREAD_SIZE - sizeof(unsigned long))
 #define top_ebp                (THREAD_SIZE - 2*sizeof(unsigned long))
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index c95c8f4..671960d 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -520,25 +520,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	return prev_p;
 }
 
-/*
- * sys_execve() executes a new program.
- */
-asmlinkage
-long sys_execve(char __user *name, char __user * __user *argv,
-		char __user * __user *envp, struct pt_regs *regs)
-{
-	long error;
-	char *filename;
-
-	filename = getname(name);
-	error = PTR_ERR(filename);
-	if (IS_ERR(filename))
-		return error;
-	error = do_execve(filename, argv, envp, regs);
-	putname(filename);
-	return error;
-}
-
 void set_personality_64bit(void)
 {
 	/* inherit personality from parent */
