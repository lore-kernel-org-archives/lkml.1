Return-Path: <linux-kernel-owner+w=401wt.eu-S1763405AbZE0Hdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763405AbZE0Hdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762467AbZE0H1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:27:19 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46942 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762474AbZE0H1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:27:16 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 12/29] microblaze_mmu_v2: Update process creation for MMU
Date: Wed, 27 May 2009 08:47:37 +0200
Message-Id: <1243406874-3917-13-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-12-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
 <1243406874-3917-2-git-send-email-monstr@monstr.eu>
 <1243406874-3917-3-git-send-email-monstr@monstr.eu>
 <1243406874-3917-4-git-send-email-monstr@monstr.eu>
 <1243406874-3917-5-git-send-email-monstr@monstr.eu>
 <1243406874-3917-6-git-send-email-monstr@monstr.eu>
 <1243406874-3917-7-git-send-email-monstr@monstr.eu>
 <1243406874-3917-8-git-send-email-monstr@monstr.eu>
 <1243406874-3917-9-git-send-email-monstr@monstr.eu>
 <1243406874-3917-10-git-send-email-monstr@monstr.eu>
 <1243406874-3917-11-git-send-email-monstr@monstr.eu>
 <1243406874-3917-12-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/processor.h |   95 +++++++++++++++++++++++++++++-
 arch/microblaze/include/asm/registers.h |   21 ++++++-
 arch/microblaze/include/asm/segment.h   |   20 ++++--
 arch/microblaze/kernel/process.c        |   58 +++++++++++++++++++
 4 files changed, 181 insertions(+), 13 deletions(-)

diff --git a/arch/microblaze/include/asm/processor.h b/arch/microblaze/include/asm/processor.h
index 9329029..563c6b9 100644
--- a/arch/microblaze/include/asm/processor.h
+++ b/arch/microblaze/include/asm/processor.h
@@ -1,6 +1,6 @@
 /*
- * Copyright (C) 2008 Michal Simek
- * Copyright (C) 2008 PetaLogix
+ * Copyright (C) 2008-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2008-2009 PetaLogix
  * Copyright (C) 2006 Atmark Techno, Inc.
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -26,14 +26,15 @@ extern const struct seq_operations cpuinfo_op;
 # define cpu_sleep()		do {} while (0)
 # define prepare_to_copy(tsk)	do {} while (0)
 
-# endif /* __ASSEMBLY__ */
-
 #define task_pt_regs(tsk) \
 		(((struct pt_regs *)(THREAD_SIZE + task_stack_page(tsk))) - 1)
 
 /* Do necessary setup to start up a newly executed thread. */
 void start_thread(struct pt_regs *regs, unsigned long pc, unsigned long usp);
 
+# endif /* __ASSEMBLY__ */
+
+# ifndef CONFIG_MMU
 /*
  * User space process size: memory size
  *
@@ -85,4 +86,90 @@ extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 # define KSTK_EIP(tsk)	(0)
 # define KSTK_ESP(tsk)	(0)
 
+# else /* CONFIG_MMU */
+
+/*
+ * This is used to define STACK_TOP, and with MMU it must be below
+ * kernel base to select the correct PGD when handling MMU exceptions.
+ */
+# define TASK_SIZE	(CONFIG_KERNEL_START)
+
+/*
+ * This decides where the kernel will search for a free chunk of vm
+ * space during mmap's.
+ */
+# define TASK_UNMAPPED_BASE	(TASK_SIZE / 8 * 3)
+
+# define THREAD_KSP	0
+
+#  ifndef __ASSEMBLY__
+
+/*
+ * Default implementation of macro that returns current
+ * instruction pointer ("program counter").
+ */
+#  define current_text_addr()	({ __label__ _l; _l: &&_l; })
+
+/* If you change this, you must change the associated assembly-languages
+ * constants defined below, THREAD_*.
+ */
+struct thread_struct {
+	/* kernel stack pointer (must be first field in structure) */
+	unsigned long	ksp;
+	unsigned long	ksp_limit;	/* if ksp <= ksp_limit stack overflow */
+	void		*pgdir;		/* root of page-table tree */
+	struct pt_regs	*regs;		/* Pointer to saved register state */
+};
+
+#  define INIT_THREAD { \
+	.ksp   = sizeof init_stack + (unsigned long)init_stack, \
+	.pgdir = swapper_pg_dir, \
+}
+
+/* Do necessary setup to start up a newly executed thread.  */
+void start_thread(struct pt_regs *regs,
+		unsigned long pc, unsigned long usp);
+
+/* Free all resources held by a thread. */
+extern inline void release_thread(struct task_struct *dead_task)
+{
+}
+
+extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
+
+/* Free current thread data structures etc.  */
+static inline void exit_thread(void)
+{
+}
+
+/* Return saved (kernel) PC of a blocked thread.  */
+#  define thread_saved_pc(tsk)	\
+	((tsk)->thread.regs ? (tsk)->thread.regs->r15 : 0)
+
+unsigned long get_wchan(struct task_struct *p);
+
+/* The size allocated for kernel stacks. This _must_ be a power of two! */
+# define KERNEL_STACK_SIZE	0x2000
+
+/* Return some info about the user process TASK.  */
+#  define task_tos(task)	((unsigned long)(task) + KERNEL_STACK_SIZE)
+#  define task_regs(task) ((struct pt_regs *)task_tos(task) - 1)
+
+#  define task_pt_regs_plus_args(tsk) \
+	(((void *)task_pt_regs(tsk)) - STATE_SAVE_ARG_SPACE)
+
+#  define task_sp(task)	(task_regs(task)->r1)
+#  define task_pc(task)	(task_regs(task)->pc)
+/* Grotty old names for some.  */
+#  define KSTK_EIP(task)	(task_pc(task))
+#  define KSTK_ESP(task)	(task_sp(task))
+
+/* FIXME */
+#  define deactivate_mm(tsk, mm)	do { } while (0)
+
+#  define STACK_TOP	TASK_SIZE
+#  define STACK_TOP_MAX	STACK_TOP
+
+#  endif /* __ASSEMBLY__ */
+# endif /* CONFIG_MMU */
 #endif /* _ASM_MICROBLAZE_PROCESSOR_H */
diff --git a/arch/microblaze/include/asm/registers.h b/arch/microblaze/include/asm/registers.h
index 834142d..68c3afb 100644
--- a/arch/microblaze/include/asm/registers.h
+++ b/arch/microblaze/include/asm/registers.h
@@ -1,6 +1,6 @@
 /*
- * Copyright (C) 2008 Michal Simek
- * Copyright (C) 2008 PetaLogix
+ * Copyright (C) 2008-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2008-2009 PetaLogix
  * Copyright (C) 2006 Atmark Techno, Inc.
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -30,4 +30,21 @@
 #define FSR_UF		(1<<1) /* Underflow */
 #define FSR_DO		(1<<0) /* Denormalized operand error */
 
+# ifdef CONFIG_MMU
+/* Machine State Register (MSR) Fields */
+# define MSR_UM		(1<<11) /* User Mode */
+# define MSR_UMS	(1<<12) /* User Mode Save */
+# define MSR_VM		(1<<13) /* Virtual Mode */
+# define MSR_VMS	(1<<14) /* Virtual Mode Save */
+
+# define MSR_KERNEL	(MSR_EE | MSR_VM)
+/* # define MSR_USER	(MSR_KERNEL | MSR_UM | MSR_IE) */
+# define MSR_KERNEL_VMS	(MSR_EE | MSR_VMS)
+/* # define MSR_USER_VMS	(MSR_KERNEL_VMS | MSR_UMS | MSR_IE) */
+
+/* Exception State Register (ESR) Fields */
+# define	  ESR_DIZ	(1<<11) /* Zone Protection */
+# define	  ESR_S		(1<<10) /* Store instruction */
+
+# endif /* CONFIG_MMU */
 #endif /* _ASM_MICROBLAZE_REGISTERS_H */
diff --git a/arch/microblaze/include/asm/segment.h b/arch/microblaze/include/asm/segment.h
index 7f5dcc5..0e7102c 100644
--- a/arch/microblaze/include/asm/segment.h
+++ b/arch/microblaze/include/asm/segment.h
@@ -1,6 +1,6 @@
 /*
- * Copyright (C) 2008 Michal Simek
- * Copyright (C) 2008 PetaLogix
+ * Copyright (C) 2008-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2008-2009 PetaLogix
  * Copyright (C) 2006 Atmark Techno, Inc.
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -11,7 +11,7 @@
 #ifndef _ASM_MICROBLAZE_SEGMENT_H
 #define _ASM_MICROBLAZE_SEGMENT_H
 
-#ifndef __ASSEMBLY__
+# ifndef __ASSEMBLY__
 
 typedef struct {
 	unsigned long seg;
@@ -29,15 +29,21 @@ typedef struct {
  *
  * For non-MMU arch like Microblaze, KERNEL_DS and USER_DS is equal.
  */
-#  define KERNEL_DS	((mm_segment_t){0})
+# define MAKE_MM_SEG(s)       ((mm_segment_t) { (s) })
+
+#  ifndef CONFIG_MMU
+#  define KERNEL_DS	MAKE_MM_SEG(0)
 #  define USER_DS	KERNEL_DS
+#  else
+#  define KERNEL_DS	MAKE_MM_SEG(0xFFFFFFFF)
+#  define USER_DS	MAKE_MM_SEG(TASK_SIZE - 1)
+#  endif
 
 # define get_ds()	(KERNEL_DS)
 # define get_fs()	(current_thread_info()->addr_limit)
-# define set_fs(x) \
-		do { current_thread_info()->addr_limit = (x); } while (0)
+# define set_fs(val)	(current_thread_info()->addr_limit = (val))
 
-# define segment_eq(a, b)		((a).seg == (b).seg)
+# define segment_eq(a, b)	((a).seg == (b).seg)
 
 # endif /* __ASSEMBLY__ */
 #endif /* _ASM_MICROBLAZE_SEGMENT_H */
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 685ad71..00b12c6 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -126,9 +126,54 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
 	else
 		childregs->r1 = ((unsigned long) ti) + THREAD_SIZE;
 
+#ifndef CONFIG_MMU
 	memset(&ti->cpu_context, 0, sizeof(struct cpu_context));
 	ti->cpu_context.r1 = (unsigned long)childregs;
 	ti->cpu_context.msr = (unsigned long)childregs->msr;
+#else
+
+	/* if creating a kernel thread then update the current reg (we don't
+	 * want to use the parent's value when restoring by POP_STATE) */
+	if (kernel_mode(regs))
+		/* save new current on stack to use POP_STATE */
+		childregs->CURRENT_TASK = (unsigned long)p;
+	/* if returning to user then use the parent's value of this register */
+
+	/* if we're creating a new kernel thread then just zeroing all
+	 * the registers. That's OK for a brand new thread.*/
+	/* Pls. note that some of them will be restored in POP_STATE */
+	if (kernel_mode(regs))
+		memset(&ti->cpu_context, 0, sizeof(struct cpu_context));
+	/* if this thread is created for fork/vfork/clone, then we want to
+	 * restore all the parent's context */
+	/* in addition to the registers which will be restored by POP_STATE */
+	else {
+		ti->cpu_context = *(struct cpu_context *)regs;
+		childregs->msr |= MSR_UMS;
+	}
+
+	/* FIXME STATE_SAVE_PT_OFFSET; */
+	ti->cpu_context.r1  = (unsigned long)childregs - STATE_SAVE_ARG_SPACE;
+	/* we should consider the fact that childregs is a copy of the parent
+	 * regs which were saved immediately after entering the kernel state
+	 * before enabling VM. This MSR will be restored in switch_to and
+	 * RETURN() and we want to have the right machine state there
+	 * specifically this state must have INTs disabled before and enabled
+	 * after performing rtbd
+	 * compose the right MSR for RETURN(). It will work for switch_to also
+	 * excepting for VM and UMS
+	 * don't touch UMS , CARRY and cache bits
+	 * right now MSR is a copy of parent one */
+	childregs->msr |= MSR_BIP;
+	childregs->msr &= ~MSR_EIP;
+	childregs->msr |= MSR_IE;
+	childregs->msr &= ~MSR_VM;
+	childregs->msr |= MSR_VMS;
+	childregs->msr |= MSR_EE; /* exceptions will be enabled*/
+
+	ti->cpu_context.msr = (childregs->msr|MSR_VM);
+	ti->cpu_context.msr &= ~MSR_UMS; /* switch_to to kernel mode */
+#endif
 	ti->cpu_context.r15 = (unsigned long)ret_from_fork - 8;
 
 	if (clone_flags & CLONE_SETTLS)
@@ -137,6 +182,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
 	return 0;
 }
 
+#ifndef CONFIG_MMU
 /*
  * Return saved PC of a blocked thread.
  */
@@ -151,6 +197,7 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 	else
 		return ctx->r14;
 }
+#endif
 
 static void kernel_thread_helper(int (*fn)(void *), void *arg)
 {
@@ -189,3 +236,14 @@ void start_thread(struct pt_regs *regs, unsigned long pc, unsigned long usp)
 	regs->r1 = usp;
 	regs->pt_mode = 0;
 }
+
+#ifdef CONFIG_MMU
+#include <linux/elfcore.h>
+/*
+ * Set up a thread for executing a new program
+ */
+int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpregs)
+{
+	return 0; /* MicroBlaze has no separate FPU registers */
+}
+#endif /* CONFIG_MMU */
-- 
1.5.5.1

