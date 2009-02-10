Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbZBJOwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbZBJOwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbZBJOvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:51:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:7355 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbZBJOvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:51:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fUkshxnHPbRZzPHlvWee9XxkM8BmCu8qNvCw9qbmBwEnUCsMoHWlJIYTOkGBrJKs8K
         GdYJkuyhvGIKm4swh7SAwvk/BKxcTgh9Yhpx6B9amcyASCsraHZAWjJgY72LV1tiaX2U
         8szo5MSUOMdcd9pMzADBPDgmk4pvmU8vwdO/4=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that need it
Date: Tue, 10 Feb 2009 09:51:46 -0500
Message-Id: <1234277507-4987-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234277507-4987-1-git-send-email-brgerst@gmail.com>
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some syscalls need to access the pt_regs structure, either to copy
user register state or to modifiy it.  This patch adds stubs to load
the address of the pt_regs struct into the %eax register, and changes
the syscalls to regparm(1) to receive the pt_regs pointer as the
first argument.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/linkage.h     |    7 +++++++
 arch/x86/include/asm/syscalls.h    |   25 +++++++++++++++----------
 arch/x86/kernel/entry_32.S         |   20 ++++++++++++++++++++
 arch/x86/kernel/ioport.c           |    4 +---
 arch/x86/kernel/process_32.c       |   35 ++++++++++++++---------------------
 arch/x86/kernel/signal.c           |   35 +++++++----------------------------
 arch/x86/kernel/syscall_table_32.S |   20 ++++++++++----------
 arch/x86/kernel/vm86_32.c          |   15 +++++++--------
 8 files changed, 81 insertions(+), 80 deletions(-)

diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index 5d98d0b..2fd5926 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -18,6 +18,13 @@
 #define asmregparm __attribute__((regparm(3)))
 
 /*
+ * For syscalls that need a pointer to the pt_regs struct (ie. fork).
+ * The regs pointer is passed in %eax as the first argument.  The
+ * remaining function arguments remain on the stack.
+ */
+#define ptregscall __attribute__((regparm(1)))
+
+/*
  * Make sure the compiler doesn't do anything stupid with the
  * arguments on the stack - they are owned by the *caller*, not
  * the callee. This just fools gcc into not spilling into them,
diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index c0b0bda..6172952 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -29,21 +29,26 @@ asmlinkage int sys_get_thread_area(struct user_desc __user *);
 /* X86_32 only */
 #ifdef CONFIG_X86_32
 /* kernel/process_32.c */
-asmlinkage int sys_fork(struct pt_regs);
-asmlinkage int sys_clone(struct pt_regs);
-asmlinkage int sys_vfork(struct pt_regs);
-asmlinkage int sys_execve(struct pt_regs);
+ptregscall int sys_fork(struct pt_regs *);
+ptregscall int sys_clone(struct pt_regs *, unsigned long,
+			 unsigned long, int __user *,
+			 unsigned long, int __user *);
+ptregscall int sys_vfork(struct pt_regs *);
+ptregscall int sys_execve(struct pt_regs *, char __user *,
+			  char __user * __user *,
+			  char __user * __user *);
 
 /* kernel/signal_32.c */
 asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
 asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
 			     struct old_sigaction __user *);
-asmlinkage int sys_sigaltstack(unsigned long);
-asmlinkage unsigned long sys_sigreturn(unsigned long);
-asmlinkage int sys_rt_sigreturn(unsigned long);
+ptregscall int sys_sigaltstack(struct pt_regs *, const stack_t __user *,
+			       stack_t __user *);
+ptregscall unsigned long sys_sigreturn(struct pt_regs *);
+ptregscall int sys_rt_sigreturn(struct pt_regs *);
 
 /* kernel/ioport.c */
-asmlinkage long sys_iopl(unsigned long);
+ptregscall long sys_iopl(struct pt_regs *, unsigned int);
 
 /* kernel/sys_i386_32.c */
 asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
@@ -59,8 +64,8 @@ struct oldold_utsname;
 asmlinkage int sys_olduname(struct oldold_utsname __user *);
 
 /* kernel/vm86_32.c */
-asmlinkage int sys_vm86old(struct pt_regs);
-asmlinkage int sys_vm86(struct pt_regs);
+ptregscall int sys_vm86old(struct pt_regs *, struct vm86_struct __user *);
+ptregscall int sys_vm86(struct pt_regs *, unsigned long, unsigned long);
 
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
index b12208f..7ec1486 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -131,10 +131,8 @@ static int do_iopl(unsigned int level, struct pt_regs *regs)
 }
 
 #ifdef CONFIG_X86_32
-asmlinkage long sys_iopl(unsigned long regsp)
+ptregscall long sys_iopl(struct pt_regs *regs, unsigned int level)
 {
-	struct pt_regs *regs = (struct pt_regs *)&regsp;
-	unsigned int level = regs->bx;
 	struct thread_struct *t = &current->thread;
 	int rc;
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 9a62383..922e3d2 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -593,24 +593,18 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	return prev_p;
 }
 
-asmlinkage int sys_fork(struct pt_regs regs)
+ptregscall int sys_fork(struct pt_regs *regs)
 {
-	return do_fork(SIGCHLD, regs.sp, &regs, 0, NULL, NULL);
+	return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);
 }
 
-asmlinkage int sys_clone(struct pt_regs regs)
+ptregscall int sys_clone(struct pt_regs *regs, unsigned long clone_flags,
+			 unsigned long newsp, int __user *parent_tidptr,
+			 unsigned long unused, int __user *child_tidptr)
 {
-	unsigned long clone_flags;
-	unsigned long newsp;
-	int __user *parent_tidptr, *child_tidptr;
-
-	clone_flags = regs.bx;
-	newsp = regs.cx;
-	parent_tidptr = (int __user *)regs.dx;
-	child_tidptr = (int __user *)regs.di;
 	if (!newsp)
-		newsp = regs.sp;
-	return do_fork(clone_flags, newsp, &regs, 0, parent_tidptr, child_tidptr);
+		newsp = regs->sp;
+	return do_fork(clone_flags, newsp, regs, 0, parent_tidptr, child_tidptr);
 }
 
 /*
@@ -623,27 +617,26 @@ asmlinkage int sys_clone(struct pt_regs regs)
  * do not have enough call-clobbered registers to hold all
  * the information you need.
  */
-asmlinkage int sys_vfork(struct pt_regs regs)
+ptregscall int sys_vfork(struct pt_regs *regs)
 {
-	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs.sp, &regs, 0, NULL, NULL);
+	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp, regs, 0, NULL, NULL);
 }
 
 /*
  * sys_execve() executes a new program.
  */
-asmlinkage int sys_execve(struct pt_regs regs)
+ptregscall int sys_execve(struct pt_regs *regs, char __user *u_filename,
+			  char __user * __user *argv,
+			  char __user * __user *envp)
 {
 	int error;
 	char *filename;
 
-	filename = getname((char __user *) regs.bx);
+	filename = getname(u_filename);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
-	error = do_execve(filename,
-			(char __user * __user *) regs.cx,
-			(char __user * __user *) regs.dx,
-			&regs);
+	error = do_execve(filename, argv, envp, regs);
 	if (error == 0) {
 		/* Make sure we don't return using sysenter.. */
 		set_thread_flag(TIF_IRET);
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 8562387..d7a1583 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -549,39 +549,28 @@ sys_sigaction(int sig, const struct old_sigaction __user *act,
 #endif /* CONFIG_X86_32 */
 
 #ifdef CONFIG_X86_32
-asmlinkage int sys_sigaltstack(unsigned long bx)
-{
-	/*
-	 * This is needed to make gcc realize it doesn't own the
-	 * "struct pt_regs"
-	 */
-	struct pt_regs *regs = (struct pt_regs *)&bx;
-	const stack_t __user *uss = (const stack_t __user *)bx;
-	stack_t __user *uoss = (stack_t __user *)regs->cx;
-
-	return do_sigaltstack(uss, uoss, regs->sp);
-}
+ptregscall int
+sys_sigaltstack(struct pt_regs *regs, const stack_t __user *uss,
+		stack_t __user *uoss)
 #else /* !CONFIG_X86_32 */
 asmlinkage long
 sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 		struct pt_regs *regs)
+#endif /* CONFIG_X86_32 */
 {
 	return do_sigaltstack(uss, uoss, regs->sp);
 }
-#endif /* CONFIG_X86_32 */
 
 /*
  * Do a signal return; undo the signal stack.
  */
 #ifdef CONFIG_X86_32
-asmlinkage unsigned long sys_sigreturn(unsigned long __unused)
+ptregscall unsigned long sys_sigreturn(struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
-	struct pt_regs *regs;
 	unsigned long ax;
 	sigset_t set;
 
-	regs = (struct pt_regs *) &__unused;
 	frame = (struct sigframe __user *)(regs->sp - 8);
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
@@ -640,23 +629,13 @@ badframe:
 }
 
 #ifdef CONFIG_X86_32
-/*
- * Note: do not pass in pt_regs directly as with tail-call optimization
- * GCC will incorrectly stomp on the caller's frame and corrupt user-space
- * register state:
- */
-asmlinkage int sys_rt_sigreturn(unsigned long __unused)
-{
-	struct pt_regs *regs = (struct pt_regs *)&__unused;
-
-	return do_rt_sigreturn(regs);
-}
+ptregscall int sys_rt_sigreturn(struct pt_regs *regs)
 #else /* !CONFIG_X86_32 */
 asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
+#endif /* CONFIG_X86_32 */
 {
 	return do_rt_sigreturn(regs);
 }
-#endif /* CONFIG_X86_32 */
 
 /*
  * OK, we're invoking a handler:
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
index 55ea30d..8fa6ba7 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -197,9 +197,8 @@ out:
 static int do_vm86_irq_handling(int subfunction, int irqnumber);
 static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk);
 
-asmlinkage int sys_vm86old(struct pt_regs regs)
+ptregscall int sys_vm86old(struct pt_regs *regs, struct vm86_struct __user *v86)
 {
-	struct vm86_struct __user *v86 = (struct vm86_struct __user *)regs.bx;
 	struct kernel_vm86_struct info; /* declare this _on top_,
 					 * this avoids wasting of stack space.
 					 * This remains on the stack until we
@@ -218,7 +217,7 @@ asmlinkage int sys_vm86old(struct pt_regs regs)
 	if (tmp)
 		goto out;
 	memset(&info.vm86plus, 0, (int)&info.regs32 - (int)&info.vm86plus);
-	info.regs32 = &regs;
+	info.regs32 = regs;
 	tsk->thread.vm86_info = v86;
 	do_sys_vm86(&info, tsk);
 	ret = 0;	/* we never return here */
@@ -227,7 +226,7 @@ out:
 }
 
 
-asmlinkage int sys_vm86(struct pt_regs regs)
+ptregscall int sys_vm86(struct pt_regs *regs, unsigned long cmd, unsigned long arg)
 {
 	struct kernel_vm86_struct info; /* declare this _on top_,
 					 * this avoids wasting of stack space.
@@ -239,12 +238,12 @@ asmlinkage int sys_vm86(struct pt_regs regs)
 	struct vm86plus_struct __user *v86;
 
 	tsk = current;
-	switch (regs.bx) {
+	switch (cmd) {
 	case VM86_REQUEST_IRQ:
 	case VM86_FREE_IRQ:
 	case VM86_GET_IRQ_BITS:
 	case VM86_GET_AND_RESET_IRQ:
-		ret = do_vm86_irq_handling(regs.bx, (int)regs.cx);
+		ret = do_vm86_irq_handling(cmd, (int)arg);
 		goto out;
 	case VM86_PLUS_INSTALL_CHECK:
 		/*
@@ -261,14 +260,14 @@ asmlinkage int sys_vm86(struct pt_regs regs)
 	ret = -EPERM;
 	if (tsk->thread.saved_sp0)
 		goto out;
-	v86 = (struct vm86plus_struct __user *)regs.cx;
+	v86 = (struct vm86plus_struct __user *)arg;
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

