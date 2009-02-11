Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbZBKVoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbZBKVoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZBKVn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:43:59 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:20957 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbZBKVn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:43:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fHOn9M0mSqGVPYlTFvJkghhZvS2rpPxpYfQs6QN3LoKqUXQZXNGsxnpedOGwEtdLY0
         vYxyTbG5a/qjoP8BUgVlWrT8Mq/QZd38g70yKwCCXmBeKLR4QZGBAHOmKC2sZnOQ+Y/2
         QSLGGGQKl0oK/UhxCTTG9svVMIWsKoa6gfhtU=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: pass in pt_regs pointer for syscalls that need it (take 2)
Date: Wed, 11 Feb 2009 16:43:58 -0500
Message-Id: <1234388638-13663-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234277507-4987-3-git-send-email-brgerst@gmail.com>
References: <1234277507-4987-3-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some syscalls need to access the pt_regs structure, either to copy
user register state or to modifiy it.  This patch adds stubs to load
the address of the pt_regs struct into the %eax register, and changes
the syscalls to take the pointer as an argument instead of relying on
the assumption that the pt_regs structure overlaps the function
arguments.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---

v2: drop the regparm(1) usage due to concerns over gcc bugs.

 arch/x86/include/asm/syscalls.h    |   20 ++++++++++----------
 arch/x86/kernel/entry_32.S         |   20 ++++++++++++++++++++
 arch/x86/kernel/ioport.c           |    3 +--
 arch/x86/kernel/process_32.c       |   32 ++++++++++++++++----------------
 arch/x86/kernel/signal.c           |   22 ++++------------------
 arch/x86/kernel/syscall_table_32.S |   20 ++++++++++----------
 arch/x86/kernel/vm86_32.c          |   16 ++++++++--------
 7 files changed, 69 insertions(+), 64 deletions(-)

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index c0b0bda..77bb31a 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -29,21 +29,21 @@ asmlinkage int sys_get_thread_area(struct user_desc __user *);
 /* X86_32 only */
 #ifdef CONFIG_X86_32
 /* kernel/process_32.c */
-asmlinkage int sys_fork(struct pt_regs);
-asmlinkage int sys_clone(struct pt_regs);
-asmlinkage int sys_vfork(struct pt_regs);
-asmlinkage int sys_execve(struct pt_regs);
+int sys_fork(struct pt_regs *);
+int sys_clone(struct pt_regs *);
+int sys_vfork(struct pt_regs *);
+int sys_execve(struct pt_regs *);
 
 /* kernel/signal_32.c */
 asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
 asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
 			     struct old_sigaction __user *);
-asmlinkage int sys_sigaltstack(unsigned long);
-asmlinkage unsigned long sys_sigreturn(unsigned long);
-asmlinkage int sys_rt_sigreturn(unsigned long);
+int sys_sigaltstack(struct pt_regs *);
+unsigned long sys_sigreturn(struct pt_regs *);
+int sys_rt_sigreturn(struct pt_regs *);
 
 /* kernel/ioport.c */
-asmlinkage long sys_iopl(unsigned long);
+long sys_iopl(struct pt_regs *);
 
 /* kernel/sys_i386_32.c */
 asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
@@ -59,8 +59,8 @@ struct oldold_utsname;
 asmlinkage int sys_olduname(struct oldold_utsname __user *);
 
 /* kernel/vm86_32.c */
-asmlinkage int sys_vm86old(struct pt_regs);
-asmlinkage int sys_vm86(struct pt_regs);
+int sys_vm86old(struct pt_regs *);
+int sys_vm86(struct pt_regs *);
 
 #else /* CONFIG_X86_32 */
 
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 5f5bd22..3de7b57 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -697,6 +697,26 @@ syscall_badsys:
 END(syscall_badsys)
 	CFI_ENDPROC
 
+/*
+ * System calls that need a pt_regs pointer.
+ */
+#define PTREGSCALL(name) \
+	ALIGN; \
+ptregs_##name: \
+	leal 4(%esp),%eax; \
+	jmp sys_##name;
+
+PTREGSCALL(iopl)
+PTREGSCALL(fork)
+PTREGSCALL(clone)
+PTREGSCALL(vfork)
+PTREGSCALL(execve)
+PTREGSCALL(sigaltstack)
+PTREGSCALL(sigreturn)
+PTREGSCALL(rt_sigreturn)
+PTREGSCALL(vm86)
+PTREGSCALL(vm86old)
+
 .macro FIXUP_ESPFIX_STACK
 	/* since we are on a wrong stack, we cant make it a C code :( */
 	PER_CPU(gdt_page, %ebx)
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index b12208f..e41980a 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -131,9 +131,8 @@ static int do_iopl(unsigned int level, struct pt_regs *regs)
 }
 
 #ifdef CONFIG_X86_32
-asmlinkage long sys_iopl(unsigned long regsp)
+long sys_iopl(struct pt_regs *regs)
 {
-	struct pt_regs *regs = (struct pt_regs *)&regsp;
 	unsigned int level = regs->bx;
 	struct thread_struct *t = &current->thread;
 	int rc;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index b50604b..fec79ad 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -603,24 +603,24 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	return prev_p;
 }
 
-asmlinkage int sys_fork(struct pt_regs regs)
+int sys_fork(struct pt_regs *regs)
 {
-	return do_fork(SIGCHLD, regs.sp, &regs, 0, NULL, NULL);
+	return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);
 }
 
-asmlinkage int sys_clone(struct pt_regs regs)
+int sys_clone(struct pt_regs *regs)
 {
 	unsigned long clone_flags;
 	unsigned long newsp;
 	int __user *parent_tidptr, *child_tidptr;
 
-	clone_flags = regs.bx;
-	newsp = regs.cx;
-	parent_tidptr = (int __user *)regs.dx;
-	child_tidptr = (int __user *)regs.di;
+	clone_flags = regs->bx;
+	newsp = regs->cx;
+	parent_tidptr = (int __user *)regs->dx;
+	child_tidptr = (int __user *)regs->di;
 	if (!newsp)
-		newsp = regs.sp;
-	return do_fork(clone_flags, newsp, &regs, 0, parent_tidptr, child_tidptr);
+		newsp = regs->sp;
+	return do_fork(clone_flags, newsp, regs, 0, parent_tidptr, child_tidptr);
 }
 
 /*
@@ -633,27 +633,27 @@ asmlinkage int sys_clone(struct pt_regs regs)
  * do not have enough call-clobbered registers to hold all
  * the information you need.
  */
-asmlinkage int sys_vfork(struct pt_regs regs)
+int sys_vfork(struct pt_regs *regs)
 {
-	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs.sp, &regs, 0, NULL, NULL);
+	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp, regs, 0, NULL, NULL);
 }
 
 /*
  * sys_execve() executes a new program.
  */
-asmlinkage int sys_execve(struct pt_regs regs)
+int sys_execve(struct pt_regs *regs)
 {
 	int error;
 	char *filename;
 
-	filename = getname((char __user *) regs.bx);
+	filename = getname((char __user *) regs->bx);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
 	error = do_execve(filename,
-			(char __user * __user *) regs.cx,
-			(char __user * __user *) regs.dx,
-			&regs);
+			(char __user * __user *) regs->cx,
+			(char __user * __user *) regs->dx,
+			regs);
 	if (error == 0) {
 		/* Make sure we don't return using sysenter.. */
 		set_thread_flag(TIF_IRET);
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 8562387..ccfb274 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -549,14 +549,9 @@ sys_sigaction(int sig, const struct old_sigaction __user *act,
 #endif /* CONFIG_X86_32 */
 
 #ifdef CONFIG_X86_32
-asmlinkage int sys_sigaltstack(unsigned long bx)
+int sys_sigaltstack(struct pt_regs *regs)
 {
-	/*
-	 * This is needed to make gcc realize it doesn't own the
-	 * "struct pt_regs"
-	 */
-	struct pt_regs *regs = (struct pt_regs *)&bx;
-	const stack_t __user *uss = (const stack_t __user *)bx;
+	const stack_t __user *uss = (const stack_t __user *)regs->bx;
 	stack_t __user *uoss = (stack_t __user *)regs->cx;
 
 	return do_sigaltstack(uss, uoss, regs->sp);
@@ -574,14 +569,12 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
  * Do a signal return; undo the signal stack.
  */
 #ifdef CONFIG_X86_32
-asmlinkage unsigned long sys_sigreturn(unsigned long __unused)
+unsigned long sys_sigreturn(struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
-	struct pt_regs *regs;
 	unsigned long ax;
 	sigset_t set;
 
-	regs = (struct pt_regs *) &__unused;
 	frame = (struct sigframe __user *)(regs->sp - 8);
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
@@ -640,15 +633,8 @@ badframe:
 }
 
 #ifdef CONFIG_X86_32
-/*
- * Note: do not pass in pt_regs directly as with tail-call optimization
- * GCC will incorrectly stomp on the caller's frame and corrupt user-space
- * register state:
- */
-asmlinkage int sys_rt_sigreturn(unsigned long __unused)
+int sys_rt_sigreturn(struct pt_regs *regs)
 {
-	struct pt_regs *regs = (struct pt_regs *)&__unused;
-
 	return do_rt_sigreturn(regs);
 }
 #else /* !CONFIG_X86_32 */
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index e2e86a0..3bdb648 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -1,7 +1,7 @@
 ENTRY(sys_call_table)
 	.long sys_restart_syscall	/* 0 - old "setup()" system call, used for restarting */
 	.long sys_exit
-	.long sys_fork
+	.long ptregs_fork
 	.long sys_read
 	.long sys_write
 	.long sys_open		/* 5 */
@@ -10,7 +10,7 @@ ENTRY(sys_call_table)
 	.long sys_creat
 	.long sys_link
 	.long sys_unlink	/* 10 */
-	.long sys_execve
+	.long ptregs_execve
 	.long sys_chdir
 	.long sys_time
 	.long sys_mknod
@@ -109,17 +109,17 @@ ENTRY(sys_call_table)
 	.long sys_newlstat
 	.long sys_newfstat
 	.long sys_uname
-	.long sys_iopl		/* 110 */
+	.long ptregs_iopl	/* 110 */
 	.long sys_vhangup
 	.long sys_ni_syscall	/* old "idle" system call */
-	.long sys_vm86old
+	.long ptregs_vm86old
 	.long sys_wait4
 	.long sys_swapoff	/* 115 */
 	.long sys_sysinfo
 	.long sys_ipc
 	.long sys_fsync
-	.long sys_sigreturn
-	.long sys_clone		/* 120 */
+	.long ptregs_sigreturn
+	.long ptregs_clone	/* 120 */
 	.long sys_setdomainname
 	.long sys_newuname
 	.long sys_modify_ldt
@@ -165,14 +165,14 @@ ENTRY(sys_call_table)
 	.long sys_mremap
 	.long sys_setresuid16
 	.long sys_getresuid16	/* 165 */
-	.long sys_vm86
+	.long ptregs_vm86
 	.long sys_ni_syscall	/* Old sys_query_module */
 	.long sys_poll
 	.long sys_nfsservctl
 	.long sys_setresgid16	/* 170 */
 	.long sys_getresgid16
 	.long sys_prctl
-	.long sys_rt_sigreturn
+	.long ptregs_rt_sigreturn
 	.long sys_rt_sigaction
 	.long sys_rt_sigprocmask	/* 175 */
 	.long sys_rt_sigpending
@@ -185,11 +185,11 @@ ENTRY(sys_call_table)
 	.long sys_getcwd
 	.long sys_capget
 	.long sys_capset	/* 185 */
-	.long sys_sigaltstack
+	.long ptregs_sigaltstack
 	.long sys_sendfile
 	.long sys_ni_syscall	/* reserved for streams1 */
 	.long sys_ni_syscall	/* reserved for streams2 */
-	.long sys_vfork		/* 190 */
+	.long ptregs_vfork	/* 190 */
 	.long sys_getrlimit
 	.long sys_mmap2
 	.long sys_truncate64
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 55ea30d..d7ac84e 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -197,9 +197,9 @@ out:
 static int do_vm86_irq_handling(int subfunction, int irqnumber);
 static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk);
 
-asmlinkage int sys_vm86old(struct pt_regs regs)
+int sys_vm86old(struct pt_regs *regs)
 {
-	struct vm86_struct __user *v86 = (struct vm86_struct __user *)regs.bx;
+	struct vm86_struct __user *v86 = (struct vm86_struct __user *)regs->bx;
 	struct kernel_vm86_struct info; /* declare this _on top_,
 					 * this avoids wasting of stack space.
 					 * This remains on the stack until we
@@ -218,7 +218,7 @@ asmlinkage int sys_vm86old(struct pt_regs regs)
 	if (tmp)
 		goto out;
 	memset(&info.vm86plus, 0, (int)&info.regs32 - (int)&info.vm86plus);
-	info.regs32 = &regs;
+	info.regs32 = regs;
 	tsk->thread.vm86_info = v86;
 	do_sys_vm86(&info, tsk);
 	ret = 0;	/* we never return here */
@@ -227,7 +227,7 @@ out:
 }
 
 
-asmlinkage int sys_vm86(struct pt_regs regs)
+int sys_vm86(struct pt_regs *regs)
 {
 	struct kernel_vm86_struct info; /* declare this _on top_,
 					 * this avoids wasting of stack space.
@@ -239,12 +239,12 @@ asmlinkage int sys_vm86(struct pt_regs regs)
 	struct vm86plus_struct __user *v86;
 
 	tsk = current;
-	switch (regs.bx) {
+	switch (regs->bx) {
 	case VM86_REQUEST_IRQ:
 	case VM86_FREE_IRQ:
 	case VM86_GET_IRQ_BITS:
 	case VM86_GET_AND_RESET_IRQ:
-		ret = do_vm86_irq_handling(regs.bx, (int)regs.cx);
+		ret = do_vm86_irq_handling(regs->bx, (int)regs->cx);
 		goto out;
 	case VM86_PLUS_INSTALL_CHECK:
 		/*
@@ -261,14 +261,14 @@ asmlinkage int sys_vm86(struct pt_regs regs)
 	ret = -EPERM;
 	if (tsk->thread.saved_sp0)
 		goto out;
-	v86 = (struct vm86plus_struct __user *)regs.cx;
+	v86 = (struct vm86plus_struct __user *)regs->cx;
 	tmp = copy_vm86_regs_from_user(&info.regs, &v86->regs,
 				       offsetof(struct kernel_vm86_struct, regs32) -
 				       sizeof(info.regs));
 	ret = -EFAULT;
 	if (tmp)
 		goto out;
-	info.regs32 = &regs;
+	info.regs32 = regs;
 	info.vm86plus.is_vm86pus = 1;
 	tsk->thread.vm86_info = (struct vm86_struct __user *)v86;
 	do_sys_vm86(&info, tsk);
-- 
1.6.1

