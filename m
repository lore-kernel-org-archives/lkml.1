Return-Path: <linux-kernel-owner+w=401wt.eu-S1763181AbYA2Sj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763181AbYA2Sj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758470AbYA2SjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:39:04 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:40346 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105AbYA2Si6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:38:58 -0500
Date: Tue, 29 Jan 2008 13:38:30 -0500
From: Jeff Dike <jdike@addtoit.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: uml-user <user-mode-linux-user@lists.sourceforge.net>
Subject: [RFC PATCH] Address spaces as independent objects
Message-ID: <20080129183830.GA599@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a patch which allows address spaces to be created,
manipulated, and destroyed independently of processes.

The additions are
	two system calls, new_mm and switch_mm
	/proc/<pid>/mm
	PTRACE_SWITCH_MM

new_mm() returns a file descriptor referencing a new address space
which is a copy of the current one.

switch_mm(fd, flags, new_regs, save_regs) switches the current process
to the address space referenced by fd.  flags describes how the
registers should be initialized once in the other address space.
MM_ALL_REGS initializes all of the registers from new_regs.  MM_SP_IP
initialize only the instruction pointer and stack pointer from
new_regs.  If save is non-NULL, then the current registers are saved
there.  It must be a userspace pointer that's valid in the new address
space.

Opening /proc/<pid>/mm gives you a descriptor referencing the address
space of the given process.  If you are switching temporarily to
another address space and want to come back to the current one, then
you need to open /proc/self/mm and use that descriptor to return.

PTRACE_SWITCH_MM takes a file descriptor in data and makes the child
process switch to the address space referenced by it.

If you're familiar with UML, you'll recognize this stuff as what's in
the host SKAS3 patch, except with a different interface.

The purpose behind this is to allow UML to run more efficiently.  With
this patch, plus a PTRACE_GETSIGINFO extension, I get kernel build
performance in the 82% - 83% range compared to native on i386.

Internal interface changes - I made some previously static functions
global:
	dup_mm - address space duplication
	getreg, putreg, getreg32, putreg32 - save and restore process
register state

The guts of this are in mm/mmfs.c, which implements a little
filesystem sitting behind /proc/<pid>/mm and new_mm().

Architecture support is there for 32 and 64-bit x86 and 32 bit compat
on 64-bit.

I want this to go into mainline, so I'd like to see it take a spin in
-mm during 2.6.24 and then go into 2.6.25 if there no major problems
with it.

TODO -
	The architecture support needs work
	Register saving and restoring should include the FP registers
	Registers should be saved in the current address space
	Need to add /proc/<pid>/task/mm

In order to play with this, you'll need either this patch, which is
a rolled-up patch containing both host and guest support:

	http://marc.info/?l=user-mode-linux-devel&m=120155633500396&q=raw

or this broken-out series, of which the patch below is number 7:
	http://marc.info/?l=user-mode-linux-devel&m=120155631600315&q=raw
	http://marc.info/?l=user-mode-linux-devel&m=120155631700323&q=raw
	http://marc.info/?l=user-mode-linux-devel&m=120155634000413&q=raw
	http://marc.info/?l=user-mode-linux-devel&m=120155631900336&q=raw
	http://marc.info/?l=user-mode-linux-devel&m=120155634200425&q=raw
	http://marc.info/?l=user-mode-linux-devel&m=120155632800373&q=raw
	http://marc.info/?l=user-mode-linux-devel&m=120155635600462&q=raw
	http://marc.info/?l=user-mode-linux-devel&m=120155633100382&q=raw
	http://marc.info/?l=user-mode-linux-devel&m=120155634600430&q=raw
	http://marc.info/?l=user-mode-linux-devel&m=120155636000474&q=raw

These are against 2.6.24.  Build both host and guest from this tree.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

diff --git a/arch/um/include/skas_ptrace.h b/arch/um/include/skas_ptrace.h
index cd2327d..6b55c52 100644
--- a/arch/um/include/skas_ptrace.h
+++ b/arch/um/include/skas_ptrace.h
@@ -7,7 +7,9 @@
 #define __SKAS_PTRACE_H
 
 #define PTRACE_FAULTINFO 52
-#define PTRACE_SWITCH_MM 55
+#ifndef OLD_PTRACE_SWITCH_MM
+#define OLD_PTRACE_SWITCH_MM 55
+#endif
 
 #include "sysdep/skas_ptrace.h"
 
diff --git a/arch/um/kernel/ptrace.c b/arch/um/kernel/ptrace.c
index 47b57b4..913037e 100644
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -192,7 +192,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	}
 #endif
 #ifdef CONFIG_PROC_MM
-	case PTRACE_SWITCH_MM: {
+	case OLD_PTRACE_SWITCH_MM: {
 		struct mm_struct *old = child->mm;
 		struct mm_struct *new = proc_mm_get_mm(data);
 
@@ -292,3 +292,19 @@ void syscall_trace(struct uml_pt_regs *regs, int entryexit)
 		current->exit_code = 0;
 	}
 }
+
+int copyin_user_regs(struct user_regs *to, unsigned long __user *from)
+{
+	return copy_from_user(&to->regs, from, sizeof(to->regs));
+}
+
+int ptrace_to_pt_regs(struct pt_regs *to, struct user_regs *from)
+{
+	memcpy(to, &from->regs, sizeof(from->regs));
+	return 0;
+}
+
+int pt_regs_to_ptrace(unsigned long __user *to, struct pt_regs *from)
+{
+	return copy_to_user(to, &from->regs.gp, sizeof(from->regs.gp));
+}
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index 82a0780..522d0f1 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -627,7 +627,7 @@ void __switch_mm(struct mm_id *mm_idp)
 
 	/* FIXME: need cpu pid in __switch_mm */
 	if (proc_mm) {
-		err = ptrace(PTRACE_SWITCH_MM, userspace_pid[0], 0,
+		err = ptrace(OLD_PTRACE_SWITCH_MM, userspace_pid[0], 0,
 			     mm_idp->u.mm_fd);
 		if (err)
 			panic("__switch_mm - PTRACE_SWITCH_MM failed, "
diff --git a/arch/um/sys-i386/syscalls.c b/arch/um/sys-i386/syscalls.c
index e2d1426..85621a2 100644
--- a/arch/um/sys-i386/syscalls.c
+++ b/arch/um/sys-i386/syscalls.c
@@ -200,3 +200,11 @@ long sys_sigaction(int sig, const struct old_sigaction __user *act,
 
 	return ret;
 }
+
+extern long do_switch_mm(int fd, int flags, long __user *new,
+			 long __user *save, struct pt_regs *regs);
+
+long sys_switch_mm(int fd, int flags, long __user *new, long __user *save)
+{
+	return do_switch_mm(fd, flags, new, save, &current->thread.regs);
+}
diff --git a/arch/um/sys-x86_64/syscalls.c b/arch/um/sys-x86_64/syscalls.c
index 86f6b18..ff012ba 100644
--- a/arch/um/sys-x86_64/syscalls.c
+++ b/arch/um/sys-x86_64/syscalls.c
@@ -112,3 +112,11 @@ void arch_switch_to(struct task_struct *from, struct task_struct *to)
 
 	arch_prctl(to, ARCH_SET_FS, (void __user *) to->thread.arch.fs);
 }
+
+extern long do_switch_mm(int fd, int flags, long __user *new,
+			 long __user *save, struct pt_regs *regs);
+
+long stub_switch_mm(int fd, int flags, long __user *new, long __user *save)
+{
+	return do_switch_mm(fd, flags, new, save, &current->thread.regs);
+}
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index df588f0..1992458 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -374,6 +374,7 @@ quiet_ni_syscall:
 	PTREGSCALL stub32_vfork, sys_vfork, %rdi
 	PTREGSCALL stub32_iopl, sys_iopl, %rsi
 	PTREGSCALL stub32_rt_sigsuspend, sys_rt_sigsuspend, %rdx
+	PTREGSCALL stub32_switch_mm, sys_switch_mm, %r8
 
 ENTRY(ia32_ptregs_common)
 	popq %r11
@@ -726,4 +727,6 @@ ia32_sys_call_table:
 	.quad compat_sys_timerfd
 	.quad sys_eventfd
 	.quad sys32_fallocate
+ 	.quad sys_new_mm		/* 325 */
+	.quad stub32_switch_mm
 ia32_syscall_end:
diff --git a/arch/x86/ia32/ptrace32.c b/arch/x86/ia32/ptrace32.c
index 4a233ad..5c0caa4 100644
--- a/arch/x86/ia32/ptrace32.c
+++ b/arch/x86/ia32/ptrace32.c
@@ -38,7 +38,7 @@
 #define R32(l,q) \
 	case offsetof(struct user32, regs.l): stack[offsetof(struct pt_regs, q)/8] = val; break
 
-static int putreg32(struct task_struct *child, unsigned regno, u32 val)
+int putreg32(struct task_struct *child, unsigned regno, u32 val)
 {
 	int i;
 	__u64 *stack = (__u64 *)task_pt_regs(child);
@@ -139,7 +139,7 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 val)
 #define R32(l,q) \
 	case offsetof(struct user32, regs.l): *val = stack[offsetof(struct pt_regs, q)/8]; break
 
-static int getreg32(struct task_struct *child, unsigned regno, u32 *val)
+int getreg32(struct task_struct *child, unsigned regno, u32 *val)
 {
 	__u64 *stack = (__u64 *)task_pt_regs(child);
 
@@ -248,6 +248,7 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 	case PTRACE_SETOPTIONS:
 	case PTRACE_SET_THREAD_AREA:
 	case PTRACE_GET_THREAD_AREA:
+	case PTRACE_SWITCH_MM:
 		return sys_ptrace(request, pid, addr, data); 
 
 	default:
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e70f388..103ad9c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -412,6 +412,7 @@ END(\label)
 	PTREGSCALL stub_rt_sigsuspend, sys_rt_sigsuspend, %rdx
 	PTREGSCALL stub_sigaltstack, sys_sigaltstack, %rdx
 	PTREGSCALL stub_iopl, sys_iopl, %rsi
+	PTREGSCALL stub_switch_mm, sys_switch_mm, %r8
 
 ENTRY(ptregscall_common)
 	popq %r11
diff --git a/arch/x86/kernel/ptrace_32.c b/arch/x86/kernel/ptrace_32.c
index ff5431c..a35dd5f 100644
--- a/arch/x86/kernel/ptrace_32.c
+++ b/arch/x86/kernel/ptrace_32.c
@@ -83,8 +83,8 @@ static inline int put_stack_long(struct task_struct *task, int offset,
 	return 0;
 }
 
-static int putreg(struct task_struct *child,
-	unsigned long regno, unsigned long value)
+int putreg(struct task_struct *child,
+	   unsigned long regno, unsigned long value)
 {
 	switch (regno >> 2) {
 		case GS:
@@ -116,7 +116,7 @@ static int putreg(struct task_struct *child,
 	return 0;
 }
 
-static unsigned long getreg(struct task_struct *child,
+unsigned long getreg(struct task_struct *child,
 	unsigned long regno)
 {
 	unsigned long retval = ~0UL;
@@ -715,3 +715,36 @@ out:
 		audit_syscall_exit(AUDITSC_RESULT(regs->eax), regs->eax);
 	return 1;
 }
+
+int copyin_user_regs(struct user_regs *to, unsigned long __user *from)
+{
+	return copy_from_user(&to->regs, from, sizeof(to->regs));
+}
+
+int ptrace_to_pt_regs(struct pt_regs *regs, struct user_regs *ptrace)
+{
+	int i, err;
+
+	for (i = 0; i < FRAME_SIZE; i++){
+		err = putreg(current, i * 4, ptrace->regs[i]);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+int pt_regs_to_ptrace(unsigned long __user *ptrace, struct pt_regs *regs)
+{
+	int i;
+
+	if (!access_ok(VERIFY_WRITE, ptrace, FRAME_SIZE * sizeof(long)))
+		return -EFAULT;
+
+	for (i = 0; i < FRAME_SIZE; i++){
+		unsigned long n = getreg(current, i * 4), err;
+		err = put_user(n, &ptrace[i]);
+	}
+
+	return 0;
+}
diff --git a/arch/x86/kernel/ptrace_64.c b/arch/x86/kernel/ptrace_64.c
index 607085f..ab8954d 100644
--- a/arch/x86/kernel/ptrace_64.c
+++ b/arch/x86/kernel/ptrace_64.c
@@ -226,7 +226,7 @@ void ptrace_disable(struct task_struct *child)
 	clear_singlestep(child);
 }
 
-static int putreg(struct task_struct *child,
+int putreg(struct task_struct *child,
 	unsigned long regno, unsigned long value)
 {
 	unsigned long tmp; 
@@ -283,7 +283,7 @@ static int putreg(struct task_struct *child,
 	return 0;
 }
 
-static unsigned long getreg(struct task_struct *child, unsigned long regno)
+unsigned long getreg(struct task_struct *child, unsigned long regno)
 {
 	unsigned long val;
 	switch (regno) {
@@ -619,3 +619,101 @@ asmlinkage void syscall_trace_leave(struct pt_regs *regs)
 	    && (current->ptrace & PT_PTRACED))
 		syscall_trace(regs);
 }
+
+int copyin_user_regs(struct user_regs *to, unsigned long __user *from)
+{
+#ifdef CONFIG_IA32_EMULATION
+	if (test_thread_flag(TIF_IA32))
+		return copy_from_user(&to->u.regs32, from,
+				      sizeof(to->u.regs32));
+#endif
+	return copy_from_user(&to->u.regs64, from, sizeof(to->u.regs64));
+}
+
+extern int putreg32(struct task_struct *child, unsigned regno, u32 val);
+
+int ptrace_to_pt_regs(struct pt_regs *regs, struct user_regs *ptrace)
+{
+	int i, err;
+
+#ifdef CONFIG_IA32_EMULATION
+	if (test_thread_flag(TIF_IA32)) {
+		for (i = 0; i < MAX_REG32_NR; i++){
+			err = putreg32(current, i * 4, ptrace->u.regs32[i]);
+			if (err)
+				return err;
+		}
+
+		return 0;
+	}
+#endif
+	for (i = 0; i < MAX_REG_NR; i++){
+		err = putreg(current, i * 8, ptrace->u.regs64[i]);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+extern int getreg32(struct task_struct *child, unsigned regno, u32 *val);
+
+int pt_regs_to_ptrace(unsigned long __user *ptrace, struct pt_regs *regs)
+{
+	int i, err;
+
+#ifdef CONFIG_IA32_EMULATION
+	if (test_thread_flag(TIF_IA32)) {
+		u32 __user *ptrace32 = (u32 __user *) ptrace;
+
+		if (!access_ok(VERIFY_WRITE, ptrace32, MAX_REG32_NR * 4))
+			return -EFAULT;
+
+		for (i = 0; i < MAX_REG32_NR; i++){
+			u32 n;
+
+			err = getreg32(current, i * 4, &n);
+			if (err)
+				return err;
+
+			err = __put_user(n, &ptrace32[i]);
+			if (err)
+				return err;
+		}
+
+		return 0;
+	}
+#endif
+	if (!access_ok(VERIFY_WRITE, ptrace, MAX_REG_NR * 8))
+		return -EFAULT;
+
+	for (i = 0; i < MAX_REG_NR; i++){
+		unsigned long n = getreg(current, i * 8);
+		err = __put_user(n, &ptrace[i]);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+#define RIP_INDEX (128 / sizeof(long))
+#define RSP_INDEX (152 / sizeof(long))
+
+unsigned long ptrace_ip(struct user_regs *regs)
+{
+#ifdef CONFIG_IA32_EMULATION
+	if (test_thread_flag(TIF_IA32))
+		return ptrace_ip32(regs->u.regs32);
+#endif
+	return regs->u.regs64[RIP_INDEX];
+}
+
+unsigned long ptrace_sp(struct user_regs *regs)
+{
+#ifdef CONFIG_IA32_EMULATION
+	if (test_thread_flag(TIF_IA32))
+		return ptrace_sp32(regs->u.regs32);
+#endif
+	return regs->u.regs64[RSP_INDEX];
+}
diff --git a/arch/x86/kernel/sys_i386_32.c b/arch/x86/kernel/sys_i386_32.c
index a86d26f..7b9d43b 100644
--- a/arch/x86/kernel/sys_i386_32.c
+++ b/arch/x86/kernel/sys_i386_32.c
@@ -261,3 +261,12 @@ int kernel_execve(const char *filename, char *const argv[], char *const envp[])
 	: "0" (__NR_execve),"ri" (filename),"c" (argv), "d" (envp) : "memory");
 	return __res;
 }
+
+extern long do_switch_mm(int fd, int flags, long __user *new, long __user *save,
+			 struct pt_regs *regs);
+
+asmlinkage long sys_switch_mm(struct pt_regs regs)
+{
+	return do_switch_mm(regs.ebx, regs.ecx, (long __user *) regs.edx,
+			    (long __user *) regs.esi, &regs);
+}
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 907942e..ddc1c98 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -153,3 +153,12 @@ asmlinkage long sys_uname(struct new_utsname __user * name)
 		err |= copy_to_user(&name->machine, "i686", 5); 		
 	return err ? -EFAULT : 0;
 }
+
+extern long do_switch_mm(int fd, int flags, long __user *new,
+			 long __user *save, struct pt_regs *regs);
+
+asmlinkage long sys_switch_mm(int fd, int flags, long __user *new,
+			      long __user *save, struct pt_regs *regs)
+{
+	return do_switch_mm(fd, flags, new, save, regs);
+}
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 8344c70..3346997 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -324,3 +324,5 @@ ENTRY(sys_call_table)
 	.long sys_timerfd
 	.long sys_eventfd
 	.long sys_fallocate
+	.long sys_new_mm
+	.long sys_switch_mm
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 91fa8e6..03475a0 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2259,6 +2259,34 @@ static int proc_pid_io_accounting(struct task_struct *task, char *buffer)
 }
 #endif
 
+static int proc_pid_mm_open(struct inode *inode, struct file *file)
+{
+	struct task_struct *task = pid_task(proc_pid(inode), PIDTYPE_PID);
+
+	if (task == NULL)
+		return -ENOENT;
+
+	if(task->mm != NULL)
+		atomic_inc(&task->mm->mm_users);
+	file->private_data = task->mm;
+	return 0;
+}
+
+static int proc_pid_mm_release(struct inode *inode, struct file *file)
+{
+	struct mm_struct *mm = file->private_data;
+
+	if(mm != NULL)
+		mmput(mm);
+
+	return 0;
+}
+
+const struct file_operations proc_pid_mm_operations = {
+	.open		= proc_pid_mm_open,
+	.release	= proc_pid_mm_release,
+};
+
 /*
  * Thread groups
  */
@@ -2325,6 +2353,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUGO, pid_io_accounting),
 #endif
+	REG("mm", S_IRUSR | S_IWUSR, pid_mm),
 };
 
 static int proc_tgid_base_readdir(struct file * filp,
diff --git a/include/asm-um/ptrace-generic.h b/include/asm-um/ptrace-generic.h
index 6aefcd3..7894c3d 100644
--- a/include/asm-um/ptrace-generic.h
+++ b/include/asm-um/ptrace-generic.h
@@ -34,6 +34,15 @@ struct pt_regs {
 
 #define instruction_pointer(regs) PT_REGS_IP(regs)
 
+struct user_regs {
+	unsigned long regs[MAX_REG_NR];
+};
+
+extern int copyin_user_regs(struct user_regs *to, unsigned long __user *from);
+extern int ptrace_to_pt_regs(struct pt_regs *ptregs, struct user_regs *regs);
+extern int pt_regs_to_ptrace(unsigned long __user *regs,
+			     struct pt_regs *ptregs);
+
 struct task_struct;
 
 extern long subarch_ptrace(struct task_struct *child, long request, long addr,
diff --git a/include/asm-um/ptrace-i386.h b/include/asm-um/ptrace-i386.h
index b2d24c5..9bec151 100644
--- a/include/asm-um/ptrace-i386.h
+++ b/include/asm-um/ptrace-i386.h
@@ -40,6 +40,12 @@
 
 #define user_mode(r) UPT_IS_USER(&(r)->regs)
 
+#define pt_regs_ip(r) (r).regs.gp[EIP]
+#define pt_regs_sp(r) (r).regs.gp[UESP]
+
+#define ptrace_ip(r) (r)->regs[EIP]
+#define ptrace_sp(r) (r)->regs[UESP]
+
 /*
  * Forward declaration to avoid including sysdep/tls.h, which causes a
  * circular include, and compilation failures.
diff --git a/include/asm-um/ptrace-x86_64.h b/include/asm-um/ptrace-x86_64.h
index 4c47535..9c5365e 100644
--- a/include/asm-um/ptrace-x86_64.h
+++ b/include/asm-um/ptrace-x86_64.h
@@ -62,6 +62,12 @@
 
 #define PT_FIX_EXEC_STACK(sp) do ; while(0)
 
+#define pt_regs_ip(r) (r).regs.gp[RIP / sizeof(long)]
+#define pt_regs_sp(r) (r).regs.gp[RSP / sizeof(long)]
+
+#define ptrace_ip(r) (r)->regs[RIP / sizeof(long)]
+#define ptrace_sp(r) (r)->regs[RSP / sizeof(long)]
+
 #define profile_pc(regs) PT_REGS_IP(regs)
 
 static inline int ptrace_get_thread_area(struct task_struct *child, int idx,
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index 51ddb25..229b5b2 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_PTRACE_H
 
 #include <linux/compiler.h>	/* For __user */
+#include <asm/user.h>
 #include <asm/ptrace-abi.h>
 
 #ifndef __ASSEMBLY__
@@ -64,6 +65,22 @@ static inline int v8086_mode(struct pt_regs *regs)
 #define regs_return_value(regs) ((regs)->eax)
 
 extern unsigned long profile_pc(struct pt_regs *regs);
+
+struct user_regs {
+	unsigned long regs[FRAME_SIZE];
+};
+
+#define pt_regs_ip(r) (r).eip
+#define pt_regs_sp(r) (r).esp
+
+#define ptrace_ip(r) (r)->regs[EIP]
+#define ptrace_sp(r) (r)->regs[UESP]
+
+extern int copyin_user_regs(struct user_regs *to, unsigned long __user *from);
+extern int ptrace_to_pt_regs(struct pt_regs *regs, struct user_regs *ptrace);
+extern int pt_regs_to_ptrace(unsigned long __user *ptrace,
+			     struct pt_regs *regs);
+
 #endif /* __KERNEL__ */
 
 #else /* __i386__ */
@@ -135,6 +152,40 @@ enum {
 	EF_VIP  = 0x00100000,   /* virtual interrupt pending */
 	EF_ID   = 0x00200000,   /* id */
 };
+
+#ifdef CONFIG_IA32_EMULATION
+#define MAX_REG32_NR 17
+
+#define EIP 12
+#define UESP 15
+
+#define ptrace_ip32(regs) (unsigned long) (regs)[EIP]
+#define ptrace_sp32(regs) (unsigned long) (regs)[UESP]
+
+#endif
+
+#define MAX_REG_NR (sizeof(struct user_regs_struct) / sizeof(long))
+
+struct user_regs {
+	union {
+		unsigned long regs64[MAX_REG_NR];
+#ifdef CONFIG_IA32_EMULATION
+		u32 regs32[MAX_REG32_NR];
+#endif
+	} u;
+};
+
+#define pt_regs_ip(regs) (regs).rip
+#define pt_regs_sp(regs) (regs).rsp
+
+extern unsigned long ptrace_ip(struct user_regs *regs);
+extern unsigned long ptrace_sp(struct user_regs *regs);
+
+extern int copyin_user_regs(struct user_regs *to, unsigned long __user *from);
+extern int ptrace_to_pt_regs(struct pt_regs *regs, struct user_regs *ptrace);
+extern int pt_regs_to_ptrace(unsigned long __user *ptrace,
+			     struct pt_regs *regs);
+
 #endif /* __KERNEL__ */
 #endif /* !__i386__ */
 #endif /* !__ASSEMBLY__ */
diff --git a/include/asm-x86/unistd_32.h b/include/asm-x86/unistd_32.h
index 9b15545..3477555 100644
--- a/include/asm-x86/unistd_32.h
+++ b/include/asm-x86/unistd_32.h
@@ -330,10 +330,12 @@
 #define __NR_timerfd		322
 #define __NR_eventfd		323
 #define __NR_fallocate		324
+#define __NR_new_mm		325
+#define __NR_switch_mm		326
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 325
+#define NR_syscalls 327
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/include/asm-x86/unistd_64.h b/include/asm-x86/unistd_64.h
index 5ff4d3e..baf4c0c 100644
--- a/include/asm-x86/unistd_64.h
+++ b/include/asm-x86/unistd_64.h
@@ -635,6 +635,10 @@ __SYSCALL(__NR_timerfd, sys_timerfd)
 __SYSCALL(__NR_eventfd, sys_eventfd)
 #define __NR_fallocate				285
 __SYSCALL(__NR_fallocate, sys_fallocate)
+#define __NR_new_mm				286
+__SYSCALL(__NR_new_mm, sys_new_mm)
+#define __NR_switch_mm				287
+__SYSCALL(__NR_switch_mm, stub_switch_mm)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 3ea5750..6758e86 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -21,6 +21,8 @@
 
 #define PTRACE_SYSCALL		  24
 
+#define PTRACE_SWITCH_MM	  33
+
 /* 0x4200-0x4300 are reserved for architecture-independent additions.  */
 #define PTRACE_SETOPTIONS	0x4200
 #define PTRACE_GETEVENTMSG	0x4201
diff --git a/include/linux/sched.h b/include/linux/sched.h
index df5b24e..a07f60a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1707,6 +1707,7 @@ static inline int sas_ss_flags(unsigned long sp)
  * Routines for handling mm_structs
  */
 extern struct mm_struct * mm_alloc(void);
+extern struct mm_struct *dup_mm(struct task_struct *tsk);
 
 /* mmdrop drops the mm and the page tables */
 extern void FASTCALL(__mmdrop(struct mm_struct *));
diff --git a/kernel/fork.c b/kernel/fork.c
index 39d22b3..720f188 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -491,7 +491,7 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
  * Allocate a new mm structure and copy contents from the
  * mm structure of the passed in task structure.
  */
-static struct mm_struct *dup_mm(struct task_struct *tsk)
+struct mm_struct *dup_mm(struct task_struct *tsk)
 {
 	struct mm_struct *mm, *oldmm = current->mm;
 	int err;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index c719bb9..863b786 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -366,6 +366,23 @@ static int ptrace_setsiginfo(struct task_struct *child, siginfo_t __user * data)
 	return error;
 }
 
+extern struct mm_struct *fd_to_mm(int fd);
+extern void do_switch(struct task_struct *task, struct mm_struct *mm);
+
+static int ptrace_switch_mm(struct task_struct *child, int mm_fd)
+{
+	struct mm_struct *new = fd_to_mm(mm_fd);
+
+	if (IS_ERR(new))
+		return PTR_ERR(new);
+
+	do_switch(child, new);
+
+	mmput(new);
+
+	return 0;
+}
+
 int ptrace_request(struct task_struct *child, long request,
 		   long addr, long data)
 {
@@ -390,6 +407,9 @@ int ptrace_request(struct task_struct *child, long request,
 	case PTRACE_DETACH:	 /* detach a process that was attached. */
 		ret = ptrace_detach(child, data);
 		break;
+	case PTRACE_SWITCH_MM:
+		ret = ptrace_switch_mm(child, data);
+		break;
 	default:
 		break;
 	}
diff --git a/mm/Makefile b/mm/Makefile
index 5c0b0ea..9351c4e 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -4,8 +4,8 @@
 
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
-			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
-			   vmalloc.o
+			   mlock.o mmap.o mmfs.o mprotect.o mremap.o msync.o \
+			   rmap.o vmalloc.o
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   page_alloc.o page-writeback.o pdflush.o \
diff --git a/mm/mmfs.c b/mm/mmfs.c
new file mode 100644
index 0000000..5ec5e45
--- /dev/null
+++ b/mm/mmfs.c
@@ -0,0 +1,254 @@
+#define __FRAME_OFFSETS
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/sched.h>
+#include <asm/mmu_context.h>
+#include <asm/ptrace.h>
+#include <asm/uaccess.h>
+#include <asm/user.h>
+
+static int release_mm(struct inode *inode, struct file *file)
+{
+	struct mm_struct *mm = file->private_data;
+
+	mmput(mm);
+	return 0;
+}
+
+#define MM_MAGIC 0xE0AAC500
+
+static int mm_get_sb(struct file_system_type *fs_type,
+		     int flags, const char *dev_name, void *data,
+		     struct vfsmount *mnt)
+{
+	return get_sb_pseudo(fs_type, "mm:", NULL, MM_MAGIC, mnt);
+}
+
+static struct vfsmount *mm_mnt;
+
+static struct file_system_type mm_fs_type = {
+	.name		= "mm",
+	.get_sb		= mm_get_sb,
+	.kill_sb	= kill_anon_super,
+};
+
+static int __init init_mm_fs(void)
+{
+	int err;
+
+	err = register_filesystem(&mm_fs_type);
+	if (err)
+		return err;
+
+	mm_mnt = kern_mount(&mm_fs_type);
+	if (IS_ERR(mm_mnt)) {
+		err = PTR_ERR(mm_mnt);
+		unregister_filesystem(&mm_fs_type);
+	}
+
+	return err;
+}
+
+static void __exit exit_mm_fs(void)
+{
+	unregister_filesystem(&mm_fs_type);
+	mntput(mm_mnt);
+}
+
+fs_initcall(init_mm_fs);
+module_exit(exit_mm_fs);
+
+static int mm_delete_dentry(struct dentry *dentry)
+{
+	/*
+	 * At creation time, we pretended this dentry was hashed
+	 * (by clearing DCACHE_UNHASHED bit in d_flags)
+	 * At delete time, we restore the truth : not hashed.
+	 * (so that dput() can proceed correctly)
+	 */
+	dentry->d_flags |= DCACHE_UNHASHED;
+	return 0;
+}
+
+/*
+ * pipefs_dname() is called from d_path().
+ */
+static char *mm_dname(struct dentry *dentry, char *buffer, int buflen)
+{
+	return dynamic_dname(dentry, buffer, buflen, "mm:[%lu]",
+			     dentry->d_inode->i_ino);
+}
+
+static struct dentry_operations mm_dentry_operations = {
+	.d_delete	= mm_delete_dentry,
+	.d_dname	= mm_dname,
+};
+
+static struct file_operations mm_fops = {
+	.release	= release_mm,
+};
+
+#define MM_FLAGS_MASK 1
+#define MM_INIT_MASK 1
+
+#define MM_COPY 0
+#define MM_EMPTY 1
+
+asmlinkage long sys_new_mm(int flags)
+{
+	struct file *file;
+	struct mm_struct *mm;
+	struct inode *inode;
+	struct dentry *dentry;
+	struct qstr name = { .name = "" };
+	int err, fd;
+
+	if ((flags & ~MM_FLAGS_MASK) != 0)
+		return -EINVAL;
+
+	if ((flags & MM_INIT_MASK) == MM_COPY) {
+		mm = dup_mm(current);
+		if (mm == NULL)
+			return -ENOMEM;
+	}
+	else
+		return -EINVAL;
+
+	fd = get_unused_fd();
+	if (fd < 0) {
+		err = fd;
+		goto out_free;
+	}
+
+	err = -ENOMEM;
+	dentry = d_alloc(mm_mnt->mnt_sb->s_root, &name);
+	if (dentry == NULL)
+		goto out_put;
+
+	dentry->d_op = &mm_dentry_operations;
+	dentry->d_flags &= ~DCACHE_UNHASHED;
+
+	inode = new_inode(mm_mnt->mnt_sb);
+	if (inode == NULL)
+		goto out_dput;
+
+	inode->i_mode = S_IRUSR;
+	inode->i_uid = current->fsuid;
+	inode->i_gid = current->fsgid;
+	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+
+	d_instantiate(dentry, inode);
+
+	file = alloc_file(mm_mnt, dentry, FMODE_READ, &mm_fops);
+	if (file == NULL)
+		goto out_dput;
+
+	file->f_flags = O_RDONLY;
+	file->private_data = mm;
+
+	fd_install(fd, file);
+
+	return fd;
+
+ out_dput:
+	dput(dentry);
+ out_put:
+	put_unused_fd(fd);
+ out_free:
+	mmput(mm);
+	return err;
+}
+
+extern const struct file_operations proc_pid_mm_operations;
+
+/* Returns with an extra reference on mm */
+struct mm_struct *fd_to_mm(int fd)
+{
+	struct mm_struct *mm;
+	struct file *file = fget(fd);
+
+	if (!file)
+		return ERR_PTR(-EBADF);
+
+	if ((file->f_op != &mm_fops) &&
+	    (file->f_op != &proc_pid_mm_operations))
+		mm = ERR_PTR(-EINVAL);
+	else {
+		mm = file->private_data;
+		atomic_inc(&mm->mm_users);
+	}
+
+	fput(file);
+
+	return mm;
+}
+
+void do_switch(struct task_struct *task, struct mm_struct *mm)
+{
+	struct mm_struct *old = task->mm;
+
+	task_lock(task);
+
+	atomic_inc(&mm->mm_users);
+	task->mm = mm;
+	task->active_mm = mm;
+
+	if(task == current)
+		switch_mm(old, task->mm, task);
+
+	task_unlock(task);
+
+	mmput(old);
+}
+
+#define MM_REGS_MASK 1
+
+#define MM_ALL_REGS 0
+#define MM_SP_IP 1
+
+long do_switch_mm(int fd, unsigned long flags, long __user *new,
+		  long __user *save, struct pt_regs *regs)
+{
+	struct user_regs new_regs;
+	struct mm_struct *old_mm, *new_mm;
+	int ret = 0;
+
+	if ((flags & ~MM_REGS_MASK) != 0)
+		return -EINVAL;
+
+	old_mm = current->mm;
+	if (old_mm == NULL)
+		return -EINVAL;
+
+	if (new == NULL)
+		return -EINVAL;
+	if (copyin_user_regs(&new_regs, new))
+		return -EFAULT;
+
+	new_mm = fd_to_mm(fd);
+	if (IS_ERR(new_mm))
+		return PTR_ERR(new_mm);
+
+	atomic_inc(&old_mm->mm_users);
+	do_switch(current, new_mm);
+
+	mmput(new_mm);
+
+	if ((save != NULL) && pt_regs_to_ptrace(save, regs)) {
+		do_switch(current, old_mm);
+		ret = EFAULT;
+		goto out;
+	}
+
+	if (flags == MM_SP_IP) {
+		pt_regs_ip(*regs) = ptrace_ip(&new_regs);
+		pt_regs_sp(*regs) = ptrace_sp(&new_regs);
+	}
+	else
+		ret = ptrace_to_pt_regs(regs, &new_regs);
+
+ out:
+	mmput(old_mm);
+	return ret;
+}
