Return-Path: <linux-kernel-owner+w=401wt.eu-S1764797AbZFQHLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764797AbZFQHLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764366AbZFQHLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:11:14 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:60170 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751325AbZFQHLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:11:11 -0400
Date: Wed, 17 Jun 2009 17:11:04 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200906170711.n5H7B4DY009020@localhost.localdomain>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] m68k: merge mmu and non-mmu versions of processor.h
Cc: gerg@uclinux.org, linux-m68k@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] m68k: merge mmu and non-mmu versions of processor.h

The mmu and non-mmu versions of processor.h have a lot of common code.
This is a strait forward merge. start_thread() could be improved, but
that is not quite as strait forward, leaving for a follow on change.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---
 .../include/asm/{processor_mm.h => processor.h}    |   42 ++++++-
 arch/m68k/include/asm/processor_no.h               |  143 --------------------
 2 files changed, 41 insertions(+), 144 deletions(-)
 rename arch/m68k/include/asm/{processor_mm.h => processor.h} (75%)
 delete mode 100644 arch/m68k/include/asm/processor_no.h

diff --git a/arch/m68k/include/asm/processor_mm.h b/arch/m68k/include/asm/processor.h
similarity index 75%
rename from arch/m68k/include/asm/processor_mm.h
rename to arch/m68k/include/asm/processor.h
index 1f61ef5..74fd674 100644
--- a/arch/m68k/include/asm/processor_mm.h
+++ b/arch/m68k/include/asm/processor.h
@@ -20,15 +20,24 @@
 
 static inline unsigned long rdusp(void)
 {
+#ifdef CONFIG_COLDFIRE
+	extern unsigned int sw_usp;
+	return sw_usp;
+#else
 	unsigned long usp;
-
 	__asm__ __volatile__("move %/usp,%0" : "=a" (usp));
 	return usp;
+#endif
 }
 
 static inline void wrusp(unsigned long usp)
 {
+#ifdef CONFIG_COLDFIRE
+	extern unsigned int sw_usp;
+	sw_usp = usp;
+#else
 	__asm__ __volatile__("move %0,%/usp" : : "a" (usp));
+#endif
 }
 
 /*
@@ -49,12 +58,16 @@ static inline void wrusp(unsigned long usp)
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
+#ifdef CONFIG_MMU
 #ifndef CONFIG_SUN3
 #define TASK_UNMAPPED_BASE	0xC0000000UL
 #else
 #define TASK_UNMAPPED_BASE	0x0A000000UL
 #endif
 #define TASK_UNMAPPED_ALIGN(addr, off)	PAGE_ALIGN(addr)
+#else
+#define TASK_UNMAPPED_BASE	0
+#endif
 
 struct thread_struct {
 	unsigned long  ksp;		/* kernel stack pointer */
@@ -78,6 +91,7 @@ struct thread_struct {
 	.info	= INIT_THREAD_INFO(init_task),				\
 }
 
+#ifdef CONFIG_MMU
 /*
  * Do necessary setup to start up a newly executed thread.
  */
@@ -92,6 +106,32 @@ static inline void start_thread(struct pt_regs * regs, unsigned long pc,
 	wrusp(usp);
 }
 
+#else
+
+/*
+ * Coldfire stacks need to be re-aligned on trap exit, conventional
+ * 68k can handle this case cleanly.
+ */
+#ifdef CONFIG_COLDFIRE
+#define reformat(_regs)		do { (_regs)->format = 0x4; } while(0)
+#else
+#define reformat(_regs)		do { } while (0)
+#endif
+
+#define start_thread(_regs, _pc, _usp)                  \
+do {                                                    \
+	set_fs(USER_DS); /* reads from user space */    \
+	(_regs)->pc = (_pc);                            \
+	((struct switch_stack *)(_regs))[-1].a6 = 0;    \
+	reformat(_regs);                                \
+	if (current->mm)                                \
+		(_regs)->d5 = current->mm->start_data;  \
+	(_regs)->sr &= ~0x2000;                         \
+	wrusp(_usp);                                    \
+} while(0)
+
+#endif
+
 /* Forward declaration, a strange C thing */
 struct task_struct;
 
diff --git a/arch/m68k/include/asm/processor_no.h b/arch/m68k/include/asm/processor_no.h
deleted file mode 100644
index 7a1e0ba..0000000
--- a/arch/m68k/include/asm/processor_no.h
+++ /dev/null
@@ -1,143 +0,0 @@
-/*
- * include/asm-m68knommu/processor.h
- *
- * Copyright (C) 1995 Hamish Macdonald
- */
-
-#ifndef __ASM_M68K_PROCESSOR_H
-#define __ASM_M68K_PROCESSOR_H
-
-/*
- * Default implementation of macro that returns current
- * instruction pointer ("program counter").
- */
-#define current_text_addr() ({ __label__ _l; _l: &&_l;})
-
-#include <linux/compiler.h>
-#include <linux/threads.h>
-#include <asm/types.h>
-#include <asm/segment.h>
-#include <asm/fpu.h>
-#include <asm/ptrace.h>
-#include <asm/current.h>
-
-static inline unsigned long rdusp(void)
-{
-#ifdef CONFIG_COLDFIRE
-	extern unsigned int sw_usp;
-	return(sw_usp);
-#else
-  	unsigned long usp;
-	__asm__ __volatile__("move %/usp,%0" : "=a" (usp));
-	return usp;
-#endif
-}
-
-static inline void wrusp(unsigned long usp)
-{
-#ifdef CONFIG_COLDFIRE
-	extern unsigned int sw_usp;
-	sw_usp = usp;
-#else
-	__asm__ __volatile__("move %0,%/usp" : : "a" (usp));
-#endif
-}
-
-/*
- * User space process size: 3.75GB. This is hardcoded into a few places,
- * so don't change it unless you know what you are doing.
- */
-#define TASK_SIZE	(0xF0000000UL)
-
-/*
- * This decides where the kernel will search for a free chunk of vm
- * space during mmap's. We won't be using it
- */
-#define TASK_UNMAPPED_BASE	0
-
-/* 
- * if you change this structure, you must change the code and offsets
- * in m68k/machasm.S
- */
-   
-struct thread_struct {
-	unsigned long  ksp;		/* kernel stack pointer */
-	unsigned long  usp;		/* user stack pointer */
-	unsigned short sr;		/* saved status register */
-	unsigned short fs;		/* saved fs (sfc, dfc) */
-	unsigned long  crp[2];		/* cpu root pointer */
-	unsigned long  esp0;		/* points to SR of stack frame */
-	unsigned long  fp[8*3];
-	unsigned long  fpcntl[3];	/* fp control regs */
-	unsigned char  fpstate[FPSTATESIZE];  /* floating point state */
-};
-
-#define INIT_THREAD  {							\
-	.ksp	= sizeof(init_stack) + (unsigned long) init_stack,	\
-	.sr	= PS_S,							\
-	.fs	= __KERNEL_DS,						\
-}
-
-/*
- * Coldfire stacks need to be re-aligned on trap exit, conventional
- * 68k can handle this case cleanly.
- */
-#if defined(CONFIG_COLDFIRE)
-#define	reformat(_regs)		do { (_regs)->format = 0x4; } while(0)
-#else
-#define	reformat(_regs)		do { } while (0)
-#endif
-
-/*
- * Do necessary setup to start up a newly executed thread.
- *
- * pass the data segment into user programs if it exists,
- * it can't hurt anything as far as I can tell
- */
-#define start_thread(_regs, _pc, _usp)			\
-do {							\
-	set_fs(USER_DS); /* reads from user space */	\
-	(_regs)->pc = (_pc);				\
-	((struct switch_stack *)(_regs))[-1].a6 = 0;	\
-	reformat(_regs);				\
-	if (current->mm)				\
-		(_regs)->d5 = current->mm->start_data;	\
-	(_regs)->sr &= ~0x2000;				\
-	wrusp(_usp);					\
-} while(0)
-
-/* Forward declaration, a strange C thing */
-struct task_struct;
-
-/* Free all resources held by a thread. */
-static inline void release_thread(struct task_struct *dead_task)
-{
-}
-
-/* Prepare to copy thread state - unlazy all lazy status */
-#define prepare_to_copy(tsk)	do { } while (0)
-
-extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
-
-/*
- * Free current thread data structures etc..
- */
-static inline void exit_thread(void)
-{
-}
-
-unsigned long thread_saved_pc(struct task_struct *tsk);
-unsigned long get_wchan(struct task_struct *p);
-
-#define	KSTK_EIP(tsk)	\
-    ({			\
-	unsigned long eip = 0;	 \
-	if ((tsk)->thread.esp0 > PAGE_SIZE && \
-	    (virt_addr_valid((tsk)->thread.esp0))) \
-	      eip = ((struct pt_regs *) (tsk)->thread.esp0)->pc; \
-	eip; })
-#define	KSTK_ESP(tsk)	((tsk) == current ? rdusp() : (tsk)->thread.usp)
-
-#define cpu_relax()    barrier()
-
-#endif
