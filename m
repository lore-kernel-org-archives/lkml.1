Return-Path: <linux-kernel-owner+w=401wt.eu-S1763198AbZFKMJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763198AbZFKMJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763458AbZFKMIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:08:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39482 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbZFKMIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:08:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] MN10300: Add utrace/tracehooks support
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       David Howells <dhowells@redhat.com>
Date: Thu, 11 Jun 2009 13:08:37 +0100
Message-ID: <20090611120837.16989.20873.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090611120832.16989.99883.stgit@warthog.procyon.org.uk>
References: <20090611120832.16989.99883.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add utrace/tracehooks support to MN10300.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/Kconfig                 |    1 
 arch/mn10300/include/asm/elf.h       |    3 
 arch/mn10300/include/asm/processor.h |    8 -
 arch/mn10300/include/asm/ptrace.h    |    8 +
 arch/mn10300/kernel/entry.S          |   13 -
 arch/mn10300/kernel/ptrace.c         |  454 +++++++++++++++++-----------------
 arch/mn10300/kernel/signal.c         |    9 +
 7 files changed, 257 insertions(+), 239 deletions(-)


diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 3559267..89faaca 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -8,6 +8,7 @@ mainmenu "Linux Kernel Configuration"
 config MN10300
 	def_bool y
 	select HAVE_OPROFILE
+	select HAVE_ARCH_TRACEHOOK
 
 config AM33
 	def_bool y
diff --git a/arch/mn10300/include/asm/elf.h b/arch/mn10300/include/asm/elf.h
index bf09f8b..4910546 100644
--- a/arch/mn10300/include/asm/elf.h
+++ b/arch/mn10300/include/asm/elf.h
@@ -34,7 +34,7 @@
  */
 typedef unsigned long elf_greg_t;
 
-#define ELF_NGREG (sizeof (struct pt_regs) / sizeof(elf_greg_t))
+#define ELF_NGREG ((sizeof(struct pt_regs) / sizeof(elf_greg_t)) - 1)
 typedef elf_greg_t elf_gregset_t[ELF_NGREG];
 
 #define ELF_NFPREG 32
@@ -76,6 +76,7 @@ do {									\
 } while (0)
 
 #define USE_ELF_CORE_DUMP
+#define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	4096
 
 /*
diff --git a/arch/mn10300/include/asm/processor.h b/arch/mn10300/include/asm/processor.h
index 7323927..f7d4b0d 100644
--- a/arch/mn10300/include/asm/processor.h
+++ b/arch/mn10300/include/asm/processor.h
@@ -143,13 +143,7 @@ extern unsigned long thread_saved_pc(struct task_struct *tsk);
 
 unsigned long get_wchan(struct task_struct *p);
 
-#define task_pt_regs(task)						\
-({									\
-       struct pt_regs *__regs__;					\
-       __regs__ = (struct pt_regs *) (KSTK_TOP(task_stack_page(task)) - 8); \
-       __regs__ - 1;							\
-})
-
+#define task_pt_regs(task) ((task)->thread.uregs)
 #define KSTK_EIP(task) (task_pt_regs(task)->pc)
 #define KSTK_ESP(task) (task_pt_regs(task)->sp)
 
diff --git a/arch/mn10300/include/asm/ptrace.h b/arch/mn10300/include/asm/ptrace.h
index 7b06cc6..921942e 100644
--- a/arch/mn10300/include/asm/ptrace.h
+++ b/arch/mn10300/include/asm/ptrace.h
@@ -91,9 +91,17 @@ extern struct pt_regs *__frame; /* current frame pointer */
 #if defined(__KERNEL__)
 
 #if !defined(__ASSEMBLY__)
+struct task_struct;
+
 #define user_mode(regs)			(((regs)->epsw & EPSW_nSL) == EPSW_nSL)
 #define instruction_pointer(regs)	((regs)->pc)
+#define user_stack_pointer(regs)	((regs)->sp)
 extern void show_regs(struct pt_regs *);
+
+#define arch_has_single_step()	(1)
+extern void user_enable_single_step(struct task_struct *);
+extern void user_disable_single_step(struct task_struct *);
+
 #endif  /*  !__ASSEMBLY  */
 
 #define profile_pc(regs) ((regs)->pc)
diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index 3dc3e46..7408a27 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -76,7 +76,7 @@ ENTRY(system_call)
 	cmp	nr_syscalls,d0
 	bcc	syscall_badsys
 	btst	_TIF_SYSCALL_TRACE,(TI_flags,a2)
-	bne	syscall_trace_entry
+	bne	syscall_entry_trace
 syscall_call:
 	add	d0,d0,a1
 	add	a1,a1
@@ -104,11 +104,10 @@ restore_all:
 syscall_exit_work:
 	btst	_TIF_SYSCALL_TRACE,d2
 	beq	work_pending
-	__sti				# could let do_syscall_trace() call
+	__sti				# could let syscall_trace_exit() call
 					# schedule() instead
 	mov	fp,d0
-	mov	1,d1
-	call	do_syscall_trace[],0	# do_syscall_trace(regs,entryexit)
+	call	syscall_trace_exit[],0	# do_syscall_trace(regs)
 	jmp	resume_userspace
 
 	ALIGN
@@ -138,13 +137,11 @@ work_notifysig:
 	jmp	resume_userspace
 
 	# perform syscall entry tracing
-syscall_trace_entry:
+syscall_entry_trace:
 	mov	-ENOSYS,d0
 	mov	d0,(REG_D0,fp)
 	mov	fp,d0
-	clr	d1
-	call	do_syscall_trace[],0
-	mov	(REG_ORIG_D0,fp),d0
+	call	syscall_trace_entry[],0	# returns the syscall number to actually use
 	mov	(REG_D1,fp),d1
 	cmp	nr_syscalls,d0
 	bcs	syscall_call
diff --git a/arch/mn10300/kernel/ptrace.c b/arch/mn10300/kernel/ptrace.c
index d6d6cdc..e143339 100644
--- a/arch/mn10300/kernel/ptrace.c
+++ b/arch/mn10300/kernel/ptrace.c
@@ -17,6 +17,9 @@
 #include <linux/errno.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
+#include <linux/regset.h>
+#include <linux/elf.h>
+#include <linux/tracehook.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -64,12 +67,6 @@ static inline int get_stack_long(struct task_struct *task, int offset)
 		((unsigned long) task->thread.uregs + offset);
 }
 
-/*
- * this routine will put a word on the processes privileged stack.
- * the offset is how far from the base addr as stored in the TSS.
- * this routine assumes that all the privileged stacks are in our
- * data space.
- */
 static inline
 int put_stack_long(struct task_struct *task, int offset, unsigned long data)
 {
@@ -80,94 +77,233 @@ int put_stack_long(struct task_struct *task, int offset, unsigned long data)
 	return 0;
 }
 
-static inline unsigned long get_fpregs(struct fpu_state_struct *buf,
-				       struct task_struct *tsk)
+/*
+ * retrieve the contents of MN10300 userspace general registers
+ */
+static int genregs_get(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       void *kbuf, void __user *ubuf)
 {
-	return __copy_to_user(buf, &tsk->thread.fpu_state,
-			      sizeof(struct fpu_state_struct));
+	const struct pt_regs *regs = task_pt_regs(target);
+	int ret;
+
+	/* we need to skip regs->next */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  regs, 0, PT_ORIG_D0 * sizeof(long));
+	if (ret < 0)
+		return ret;
+
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  &regs->orig_d0, PT_ORIG_D0 * sizeof(long),
+				  NR_PTREGS * sizeof(long));
+	if (ret < 0)
+		return ret;
+
+	return user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+					NR_PTREGS * sizeof(long), -1);
 }
 
-static inline unsigned long set_fpregs(struct task_struct *tsk,
-				       struct fpu_state_struct *buf)
+/*
+ * update the contents of the MN10300 userspace general registers
+ */
+static int genregs_set(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       const void *kbuf, const void __user *ubuf)
 {
-	return __copy_from_user(&tsk->thread.fpu_state, buf,
-				sizeof(struct fpu_state_struct));
+	struct pt_regs *regs = task_pt_regs(target);
+	unsigned long tmp;
+	int ret;
+
+	/* we need to skip regs->next */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 regs, 0, PT_ORIG_D0 * sizeof(long));
+	if (ret < 0)
+		return ret;
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &regs->orig_d0, PT_ORIG_D0 * sizeof(long),
+				 PT_EPSW * sizeof(long));
+	if (ret < 0)
+		return ret;
+
+	/* we need to mask off changes to EPSW */
+	tmp = regs->epsw;
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &tmp, PT_EPSW * sizeof(long),
+				 PT_PC * sizeof(long));
+	tmp &= EPSW_FLAG_V | EPSW_FLAG_C | EPSW_FLAG_N | EPSW_FLAG_Z;
+	tmp |= regs->epsw & ~(EPSW_FLAG_V | EPSW_FLAG_C | EPSW_FLAG_N |
+			      EPSW_FLAG_Z);
+	regs->epsw = tmp;
+
+	if (ret < 0)
+		return ret;
+
+	/* and finally load the PC */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &regs->pc, PT_PC * sizeof(long),
+				 NR_PTREGS * sizeof(long));
+
+	if (ret < 0)
+		return ret;
+
+	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					 NR_PTREGS * sizeof(long), -1);
 }
 
-static inline void fpsave_init(struct task_struct *task)
+/*
+ * retrieve the contents of MN10300 userspace FPU registers
+ */
+static int fpuregs_get(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       void *kbuf, void __user *ubuf)
 {
-	memset(&task->thread.fpu_state, 0, sizeof(struct fpu_state_struct));
+	const struct fpu_state_struct *fpregs = &target->thread.fpu_state;
+	int ret;
+
+	unlazy_fpu(target);
+
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  fpregs, 0, sizeof(*fpregs));
+	if (ret < 0)
+		return ret;
+
+	return user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+					sizeof(*fpregs), -1);
 }
 
 /*
- * make sure the single step bit is not set
+ * update the contents of the MN10300 userspace FPU registers
  */
-void ptrace_disable(struct task_struct *child)
+static int fpuregs_set(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       const void *kbuf, const void __user *ubuf)
+{
+	struct fpu_state_struct fpu_state = target->thread.fpu_state;
+	int ret;
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &fpu_state, 0, sizeof(fpu_state));
+	if (ret < 0)
+		return ret;
+
+	fpu_kill_state(target);
+	target->thread.fpu_state = fpu_state;
+	set_using_fpu(target);
+
+	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					 sizeof(fpu_state), -1);
+}
+
+/*
+ * determine if the FPU registers have actually been used
+ */
+static int fpuregs_active(struct task_struct *target,
+			  const struct user_regset *regset)
+{
+	return is_using_fpu(target) ? regset->n : 0;
+}
+
+/*
+ * Define the register sets available on the MN10300 under Linux
+ */
+enum mn10300_regset {
+	REGSET_GENERAL,
+	REGSET_FPU,
+};
+
+static const struct user_regset mn10300_regsets[] = {
+	/*
+	 * General register format is:
+	 *	A3, A2, D3, D2, MCVF, MCRL, MCRH, MDRQ
+	 *	E1, E0, E7...E2, SP, LAR, LIR, MDR
+	 *	A1, A0, D1, D0, ORIG_D0, EPSW, PC
+	 */
+	[REGSET_GENERAL] = {
+		.core_note_type	= NT_PRSTATUS,
+		.n		= ELF_NGREG,
+		.size		= sizeof(long),
+		.align		= sizeof(long),
+		.get		= genregs_get,
+		.set		= genregs_set,
+	},
+	/*
+	 * FPU register format is:
+	 *	FS0-31, FPCR
+	 */
+	[REGSET_FPU] = {
+		.core_note_type	= NT_PRFPREG,
+		.n		= sizeof(struct fpu_state_struct) / sizeof(long),
+		.size		= sizeof(long),
+		.align		= sizeof(long),
+		.get		= fpuregs_get,
+		.set		= fpuregs_set,
+		.active		= fpuregs_active,
+	},
+};
+
+static const struct user_regset_view user_mn10300_native_view = {
+	.name		= "mn10300",
+	.e_machine	= EM_MN10300,
+	.regsets	= mn10300_regsets,
+	.n		= ARRAY_SIZE(mn10300_regsets),
+};
+
+const struct user_regset_view *task_user_regset_view(struct task_struct *task)
+{
+	return &user_mn10300_native_view;
+}
+
+/*
+ * set the single-step bit
+ */
+void user_enable_single_step(struct task_struct *child)
 {
 #ifndef CONFIG_MN10300_USING_JTAG
 	struct user *dummy = NULL;
 	long tmp;
 
 	tmp = get_stack_long(child, (unsigned long) &dummy->regs.epsw);
-	tmp &= ~EPSW_T;
+	tmp |= EPSW_T;
 	put_stack_long(child, (unsigned long) &dummy->regs.epsw, tmp);
 #endif
 }
 
 /*
- * set the single step bit
+ * make sure the single-step bit is not set
  */
-void ptrace_enable(struct task_struct *child)
+void user_disable_single_step(struct task_struct *child)
 {
 #ifndef CONFIG_MN10300_USING_JTAG
 	struct user *dummy = NULL;
 	long tmp;
 
 	tmp = get_stack_long(child, (unsigned long) &dummy->regs.epsw);
-	tmp |= EPSW_T;
+	tmp &= ~EPSW_T;
 	put_stack_long(child, (unsigned long) &dummy->regs.epsw, tmp);
 #endif
 }
 
+void ptrace_disable(struct task_struct *child)
+{
+	user_disable_single_step(child);
+}
+
 /*
  * handle the arch-specific side of process tracing
  */
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
-	struct fpu_state_struct fpu_state;
-	int i, ret;
+	unsigned long tmp;
+	int ret;
 
 	switch (request) {
-	/* read the word at location addr. */
-	case PTRACE_PEEKTEXT: {
-		unsigned long tmp;
-		int copied;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		ret = -EIO;
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp, (unsigned long *) data);
-		break;
-	}
-
-	/* read the word at location addr. */
-	case PTRACE_PEEKDATA: {
-		unsigned long tmp;
-		int copied;
-
-		copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 0);
-		ret = -EIO;
-		if (copied != sizeof(tmp))
-			break;
-		ret = put_user(tmp, (unsigned long *) data);
-		break;
-	}
-
 	/* read the word at location addr in the USER area. */
-	case PTRACE_PEEKUSR: {
-		unsigned long tmp;
-
+	case PTRACE_PEEKUSR:
 		ret = -EIO;
 		if ((addr & 3) || addr < 0 ||
 		    addr > sizeof(struct user) - 3)
@@ -179,17 +315,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 					     ptrace_regid_to_frame[addr]);
 		ret = put_user(tmp, (unsigned long *) data);
 		break;
-	}
-
-	/* write the word at location addr. */
-	case PTRACE_POKETEXT:
-	case PTRACE_POKEDATA:
-		if (access_process_vm(child, addr, &data, sizeof(data), 1) ==
-		    sizeof(data))
-			ret = 0;
-		else
-			ret = -EIO;
-		break;
 
 		/* write the word at location addr in the USER area */
 	case PTRACE_POKEUSR:
@@ -204,132 +329,32 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 					     data);
 		break;
 
-		/* continue and stop at next (return from) syscall */
-	case PTRACE_SYSCALL:
-		/* restart after signal. */
-	case PTRACE_CONT:
-		ret = -EIO;
-		if ((unsigned long) data > _NSIG)
-			break;
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		child->exit_code = data;
-		ptrace_disable(child);
-		wake_up_process(child);
-		ret = 0;
-		break;
-
-		/*
-		 * make the child exit
-		 * - the best I can do is send it a sigkill
-		 * - perhaps it should be put in the status that it wants to
-		 *   exit
-		 */
-	case PTRACE_KILL:
-		ret = 0;
-		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
-			break;
-		child->exit_code = SIGKILL;
-		clear_tsk_thread_flag(child, TIF_SINGLESTEP);
-		ptrace_disable(child);
-		wake_up_process(child);
-		break;
-
-	case PTRACE_SINGLESTEP: /* set the trap flag. */
-#ifndef CONFIG_MN10300_USING_JTAG
-		ret = -EIO;
-		if ((unsigned long) data > _NSIG)
-			break;
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		ptrace_enable(child);
-		child->exit_code = data;
-		wake_up_process(child);
-		ret = 0;
-#else
-		ret = -EINVAL;
-#endif
-		break;
-
-	case PTRACE_DETACH:	/* detach a process that was attached. */
-		ret = ptrace_detach(child, data);
-		break;
-
-		/* Get all gp regs from the child. */
-	case PTRACE_GETREGS: {
-		unsigned long tmp;
-
-		if (!access_ok(VERIFY_WRITE, (unsigned *) data, NR_PTREGS << 2)) {
-			ret = -EIO;
-			break;
-		}
-
-		for (i = 0; i < NR_PTREGS << 2; i += 4) {
-			tmp = get_stack_long(child, ptrace_regid_to_frame[i]);
-			__put_user(tmp, (unsigned long *) data);
-			data += sizeof(tmp);
-		}
-		ret = 0;
-		break;
-	}
-
-	case PTRACE_SETREGS: { /* Set all gp regs in the child. */
-		unsigned long tmp;
-
-		if (!access_ok(VERIFY_READ, (unsigned long *)data,
-			       sizeof(struct pt_regs))) {
-			ret = -EIO;
-			break;
-		}
-
-		for (i = 0; i < NR_PTREGS << 2; i += 4) {
-			__get_user(tmp, (unsigned long *) data);
-			put_stack_long(child, ptrace_regid_to_frame[i], tmp);
-			data += sizeof(tmp);
-		}
-		ret = 0;
-		break;
-	}
-
-	case PTRACE_GETFPREGS: { /* Get the child FPU state. */
-		if (is_using_fpu(child)) {
-			unlazy_fpu(child);
-			fpu_state = child->thread.fpu_state;
-		} else {
-			memset(&fpu_state, 0, sizeof(fpu_state));
-		}
-
-		ret = -EIO;
-		if (copy_to_user((void *) data, &fpu_state,
-				 sizeof(fpu_state)) == 0)
-			ret = 0;
-		break;
-	}
-
-	case PTRACE_SETFPREGS: { /* Set the child FPU state. */
-		ret = -EFAULT;
-		if (copy_from_user(&fpu_state, (const void *) data,
-				   sizeof(fpu_state)) == 0) {
-			fpu_kill_state(child);
-			child->thread.fpu_state = fpu_state;
-			set_using_fpu(child);
-			ret = 0;
-		}
-		break;
-	}
-
-	case PTRACE_SETOPTIONS: {
-		if (data & PTRACE_O_TRACESYSGOOD)
-			child->ptrace |= PT_TRACESYSGOOD;
-		else
-			child->ptrace &= ~PT_TRACESYSGOOD;
-		ret = 0;
-		break;
-	}
+	case PTRACE_GETREGS:	/* Get all integer regs from the child. */
+		return copy_regset_to_user(child, &user_mn10300_native_view,
+					   REGSET_GENERAL,
+					   0, NR_PTREGS * sizeof(long),
+					   (void __user *)data);
+
+	case PTRACE_SETREGS:	/* Set all integer regs in the child. */
+		return copy_regset_from_user(child, &user_mn10300_native_view,
+					     REGSET_GENERAL,
+					     0, NR_PTREGS * sizeof(long),
+					     (const void __user *)data);
+
+	case PTRACE_GETFPREGS:	/* Get the child FPU state. */
+		return copy_regset_to_user(child, &user_mn10300_native_view,
+					   REGSET_FPU,
+					   0, sizeof(struct fpu_state_struct),
+					   (void __user *)data);
+
+	case PTRACE_SETFPREGS:	/* Set the child FPU state. */
+		return copy_regset_from_user(child, &user_mn10300_native_view,
+					     REGSET_FPU,
+					     0, sizeof(struct fpu_state_struct),
+					     (const void __user *)data);
 
 	default:
-		ret = -EIO;
+		ret = ptrace_request(child, request, addr, data);
 		break;
 	}
 
@@ -337,43 +362,26 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 }
 
 /*
- * notification of system call entry/exit
- * - triggered by current->work.syscall_trace
+ * handle tracing of system call entry
+ * - return the revised system call number or ULONG_MAX to cause ENOSYS
  */
-asmlinkage void do_syscall_trace(struct pt_regs *regs, int entryexit)
+asmlinkage unsigned long syscall_trace_entry(struct pt_regs *regs)
 {
-#if 0
-	/* just in case... */
-	printk(KERN_DEBUG "[%d] syscall_%lu(%lx,%lx,%lx,%lx) = %lx\n",
-	       current->pid,
-	       regs->orig_d0,
-	       regs->a0,
-	       regs->d1,
-	       regs->a3,
-	       regs->a2,
-	       regs->d0);
-	return;
-#endif
-
-	if (!test_thread_flag(TIF_SYSCALL_TRACE) &&
-	    !test_thread_flag(TIF_SINGLESTEP))
-		return;
-	if (!(current->ptrace & PT_PTRACED))
-		return;
+	if (tracehook_report_syscall_entry(regs))
+		/* tracing decided this syscall should not happen, so
+		 * We'll return a bogus call number to get an ENOSYS
+		 * error, but leave the original number in
+		 * regs->orig_d0
+		 */
+		return ULONG_MAX;
 
-	/* the 0x80 provides a way for the tracing parent to distinguish
-	   between a syscall stop and SIGTRAP delivery */
-	ptrace_notify(SIGTRAP |
-		      ((current->ptrace & PT_TRACESYSGOOD) &&
-		       !test_thread_flag(TIF_SINGLESTEP) ? 0x80 : 0));
+	return regs->orig_d0;
+}
 
-	/*
-	 * this isn't the same as continuing with a signal, but it will do
-	 * for normal use.  strace only continues with a signal if the
-	 * stopping signal is not SIGTRAP.  -brl
-	 */
-	if (current->exit_code) {
-		send_sig(current->exit_code, current, 1);
-		current->exit_code = 0;
-	}
+/*
+ * handle tracing of system call exit
+ */
+asmlinkage void syscall_trace_exit(struct pt_regs *regs)
+{
+	tracehook_report_syscall_exit(regs, 0);
 }
diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index 841ca99..9f7572a 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -23,6 +23,7 @@
 #include <linux/tty.h>
 #include <linux/personality.h>
 #include <linux/suspend.h>
+#include <linux/tracehook.h>
 #include <asm/cacheflush.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
@@ -511,6 +512,9 @@ static void do_signal(struct pt_regs *regs)
 			 * clear the TIF_RESTORE_SIGMASK flag */
 			if (test_thread_flag(TIF_RESTORE_SIGMASK))
 				clear_thread_flag(TIF_RESTORE_SIGMASK);
+
+			tracehook_signal_handler(signr, &info, &ka, regs,
+						 test_thread_flag(TIF_SINGLESTEP));
 		}
 
 		return;
@@ -561,4 +565,9 @@ asmlinkage void do_notify_resume(struct pt_regs *regs, u32 thread_info_flags)
 	/* deal with pending signal delivery */
 	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
 		do_signal(regs);
+
+	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
+		clear_thread_flag(TIF_NOTIFY_RESUME);
+		tracehook_notify_resume(__frame);
+	}
 }

