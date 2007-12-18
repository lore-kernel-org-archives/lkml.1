Return-Path: <linux-kernel-owner+w=401wt.eu-S1761223AbXLRQ4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761223AbXLRQ4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 11:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760592AbXLRQyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 11:54:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758540AbXLRQyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 11:54:06 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 2/2] finish processor.h integration
Date: Tue, 18 Dec 2007 14:52:56 -0200
Message-Id: <11979967932428-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11979967763153-git-send-email-gcosta@redhat.com>
References: <11979967763153-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What's left in processor_32.h and processor_64.h cannot be cleanly
integrated. However, it's just a couple of definitions. They are moved
to processor.h around ifdefs, and the original files are deleted. Note that
there's much less headers included in the final version.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/processor.h    |  128 +++++++++++++++++++++++++++++++++++++++-
 include/asm-x86/processor_32.h |   97 ------------------------------
 include/asm-x86/processor_64.h |   66 --------------------
 3 files changed, 126 insertions(+), 165 deletions(-)
 delete mode 100644 include/asm-x86/processor_32.h
 delete mode 100644 include/asm-x86/processor_64.h

diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 80c5002..decb740 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -11,6 +11,8 @@ struct mm_struct;
 #include <asm/percpu.h>
 #include <asm/system.h>
 #include <asm/percpu.h>
+#include <asm/msr.h>
+#include <asm/desc_defs.h>
 #include <linux/cpumask.h>
 #include <linux/cache.h>
 
@@ -275,7 +277,11 @@ union i387_union {
 	struct i387_soft_struct soft;
 };
 
-# include "processor_32.h"
+/*
+ * the following now lives in the per cpu area:
+ * extern	int cpu_llc_id[NR_CPUS];
+ */
+DECLARE_PER_CPU(u8, cpu_llc_id);
 #else
 struct i387_fxsave_struct {
 	u16	cwd;
@@ -295,7 +301,7 @@ union i387_union {
 	struct i387_fxsave_struct	fxsave;
 };
 
-# include "processor_64.h"
+DECLARE_PER_CPU(struct orig_ist, orig_ist);
 #endif
 
 extern void print_cpu_info(struct cpuinfo_x86 *);
@@ -778,6 +784,124 @@ static inline void prefetchw(const void *x)
 }
 
 #define spin_lock_prefetch(x)	prefetchw(x)
+#ifdef CONFIG_X86_32
+/*
+ * User space process size: 3GB (default).
+ */
+#define TASK_SIZE	(PAGE_OFFSET)
+
+#define INIT_THREAD  {							\
+	.sp0 = sizeof(init_stack) + (long)&init_stack,			\
+	.vm86_info = NULL,						\
+	.sysenter_cs = __KERNEL_CS,					\
+	.io_bitmap_ptr = NULL,						\
+	.fs = __KERNEL_PERCPU,						\
+}
+
+/*
+ * Note that the .io_bitmap member must be extra-big. This is because
+ * the CPU will access an additional byte beyond the end of the IO
+ * permission bitmap. The extra byte must be all 1 bits, and must
+ * be within the limit.
+ */
+#define INIT_TSS  {							\
+	.x86_tss = {							\
+		.sp0		= sizeof(init_stack) + (long)&init_stack, \
+		.ss0		= __KERNEL_DS,				\
+		.ss1		= __KERNEL_CS,				\
+		.io_bitmap_base	= INVALID_IO_BITMAP_OFFSET,		\
+	 },								\
+	.io_bitmap	= { [0 ... IO_BITMAP_LONGS] = ~0 },		\
+}
+
+#define start_thread(regs, new_eip, new_esp) do {		\
+	__asm__("movl %0,%%gs": :"r" (0));			\
+	regs->fs = 0;						\
+	set_fs(USER_DS);					\
+	regs->ds = __USER_DS;					\
+	regs->es = __USER_DS;					\
+	regs->ss = __USER_DS;					\
+	regs->cs = __USER_CS;					\
+	regs->ip = new_eip;					\
+	regs->sp = new_esp;					\
+} while (0)
+
+
+extern unsigned long thread_saved_pc(struct task_struct *tsk);
+
+#define THREAD_SIZE_LONGS      (THREAD_SIZE/sizeof(unsigned long))
+#define KSTK_TOP(info)                                                 \
+({                                                                     \
+       unsigned long *__ptr = (unsigned long *)(info);                 \
+       (unsigned long)(&__ptr[THREAD_SIZE_LONGS]);                     \
+})
+
+/*
+ * The below -8 is to reserve 8 bytes on top of the ring0 stack.
+ * This is necessary to guarantee that the entire "struct pt_regs"
+ * is accessable even if the CPU haven't stored the SS/ESP registers
+ * on the stack (interrupt gate does not save these registers
+ * when switching to the same priv ring).
+ * Therefore beware: accessing the ss/esp fields of the
+ * "struct pt_regs" is possible, but they may contain the
+ * completely wrong values.
+ */
+#define task_pt_regs(task)                                             \
+({                                                                     \
+       struct pt_regs *__regs__;                                       \
+       __regs__ = (struct pt_regs *)(KSTK_TOP(task_stack_page(task))-8); \
+       __regs__ - 1;                                                   \
+})
+
+#define KSTK_ESP(task) (task_pt_regs(task)->sp)
+
+#else
+/*
+ * User space process size. 47bits minus one guard page.
+ */
+#define TASK_SIZE64	(0x800000000000UL - 4096)
+
+/* This decides where the kernel will search for a free chunk of vm
+ * space during mmap's.
+ */
+#define IA32_PAGE_OFFSET ((current->personality & ADDR_LIMIT_3GB) ? \
+			   0xc0000000 : 0xFFFFe000)
+
+#define TASK_SIZE 		(test_thread_flag(TIF_IA32) ? \
+				 IA32_PAGE_OFFSET : TASK_SIZE64)
+#define TASK_SIZE_OF(child) 	((test_tsk_thread_flag(child, TIF_IA32)) ? \
+				  IA32_PAGE_OFFSET : TASK_SIZE64)
+
+#define INIT_THREAD  { \
+	.sp0 = (unsigned long)&init_stack + sizeof(init_stack) \
+}
+
+#define INIT_TSS  { \
+	.x86_tss.sp0 = (unsigned long)&init_stack + sizeof(init_stack) \
+}
+
+#define start_thread(regs, new_rip, new_rsp) do { 			     \
+	asm volatile("movl %0,%%fs; movl %0,%%es; movl %0,%%ds": :"r" (0));  \
+	load_gs_index(0);						     \
+	(regs)->ip = (new_rip);						     \
+	(regs)->sp = (new_rsp);						     \
+	write_pda(oldrsp, (new_rsp));					     \
+	(regs)->cs = __USER_CS;						     \
+	(regs)->ss = __USER_DS;						     \
+	(regs)->flags = 0x200;						     \
+	set_fs(USER_DS);						     \
+} while (0)
+
+/*
+ * Return saved PC of a blocked thread.
+ * What is this good for? it will be always the scheduler or ret_from_fork.
+ */
+#define thread_saved_pc(t) (*(unsigned long *)((t)->thread.sp - 8))
+
+#define task_pt_regs(tsk) ((struct pt_regs *)(tsk)->thread.sp0 - 1)
+#define KSTK_ESP(tsk) -1 /* sorry. doesn't work for syscall. */
+#endif /* CONFIG_X86_64 */
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-x86/processor_32.h b/include/asm-x86/processor_32.h
deleted file mode 100644
index 0d6a430..0000000
--- a/include/asm-x86/processor_32.h
+++ /dev/null
@@ -1,97 +0,0 @@
-/*
- * Copyright (C) 1994 Linus Torvalds
- */
-
-#ifndef __ASM_I386_PROCESSOR_H
-#define __ASM_I386_PROCESSOR_H
-
-#include <asm/vm86.h>
-#include <asm/math_emu.h>
-#include <asm/segment.h>
-#include <asm/page.h>
-#include <asm/types.h>
-#include <asm/sigcontext.h>
-#include <asm/cpufeature.h>
-#include <asm/msr.h>
-#include <asm/system.h>
-#include <linux/threads.h>
-#include <linux/init.h>
-#include <asm/desc_defs.h>
-
-/*
- * the following now lives in the per cpu area:
- * extern	int cpu_llc_id[NR_CPUS];
- */
-DECLARE_PER_CPU(u8, cpu_llc_id);
-
-/*
- * User space process size: 3GB (default).
- */
-#define TASK_SIZE	(PAGE_OFFSET)
-
-#define INIT_THREAD  {							\
-	.sp0 = sizeof(init_stack) + (long)&init_stack,			\
-	.vm86_info = NULL,						\
-	.sysenter_cs = __KERNEL_CS,					\
-	.io_bitmap_ptr = NULL,						\
-	.fs = __KERNEL_PERCPU,						\
-}
-
-/*
- * Note that the .io_bitmap member must be extra-big. This is because
- * the CPU will access an additional byte beyond the end of the IO
- * permission bitmap. The extra byte must be all 1 bits, and must
- * be within the limit.
- */
-#define INIT_TSS  {							\
-	.x86_tss = {							\
-		.sp0		= sizeof(init_stack) + (long)&init_stack, \
-		.ss0		= __KERNEL_DS,				\
-		.ss1		= __KERNEL_CS,				\
-		.io_bitmap_base	= INVALID_IO_BITMAP_OFFSET,		\
-	 },								\
-	.io_bitmap	= { [ 0 ... IO_BITMAP_LONGS] = ~0 },		\
-}
-
-#define start_thread(regs, new_eip, new_esp) do {		\
-	__asm__("movl %0,%%gs": :"r" (0));			\
-	regs->fs = 0;						\
-	set_fs(USER_DS);					\
-	regs->ds = __USER_DS;					\
-	regs->es = __USER_DS;					\
-	regs->ss = __USER_DS;					\
-	regs->cs = __USER_CS;					\
-	regs->ip = new_eip;					\
-	regs->sp = new_esp;					\
-} while (0)
-
-
-extern unsigned long thread_saved_pc(struct task_struct *tsk);
-
-#define THREAD_SIZE_LONGS      (THREAD_SIZE/sizeof(unsigned long))
-#define KSTK_TOP(info)                                                 \
-({                                                                     \
-       unsigned long *__ptr = (unsigned long *)(info);                 \
-       (unsigned long)(&__ptr[THREAD_SIZE_LONGS]);                     \
-})
-
-/*
- * The below -8 is to reserve 8 bytes on top of the ring0 stack.
- * This is necessary to guarantee that the entire "struct pt_regs"
- * is accessable even if the CPU haven't stored the SS/ESP registers
- * on the stack (interrupt gate does not save these registers
- * when switching to the same priv ring).
- * Therefore beware: accessing the ss/esp fields of the
- * "struct pt_regs" is possible, but they may contain the
- * completely wrong values.
- */
-#define task_pt_regs(task)                                             \
-({                                                                     \
-       struct pt_regs *__regs__;                                       \
-       __regs__ = (struct pt_regs *)(KSTK_TOP(task_stack_page(task))-8); \
-       __regs__ - 1;                                                   \
-})
-
-#define KSTK_ESP(task) (task_pt_regs(task)->sp)
-
-#endif /* __ASM_I386_PROCESSOR_H */
diff --git a/include/asm-x86/processor_64.h b/include/asm-x86/processor_64.h
deleted file mode 100644
index 04ce823..0000000
--- a/include/asm-x86/processor_64.h
+++ /dev/null
@@ -1,66 +0,0 @@
-/*
- * Copyright (C) 1994 Linus Torvalds
- */
-
-#ifndef __ASM_X86_64_PROCESSOR_H
-#define __ASM_X86_64_PROCESSOR_H
-
-#include <asm/segment.h>
-#include <asm/page.h>
-#include <asm/types.h>
-#include <asm/sigcontext.h>
-#include <asm/cpufeature.h>
-#include <linux/threads.h>
-#include <asm/msr.h>
-#include <asm/current.h>
-#include <asm/system.h>
-#include <linux/personality.h>
-#include <asm/desc_defs.h>
-
-/*
- * User space process size. 47bits minus one guard page.
- */
-#define TASK_SIZE64	(0x800000000000UL - 4096)
-
-/* This decides where the kernel will search for a free chunk of vm
- * space during mmap's.
- */
-#define IA32_PAGE_OFFSET ((current->personality & ADDR_LIMIT_3GB) ? 0xc0000000 : 0xFFFFe000)
-
-#define TASK_SIZE 		(test_thread_flag(TIF_IA32) ? IA32_PAGE_OFFSET : TASK_SIZE64)
-#define TASK_SIZE_OF(child) 	((test_tsk_thread_flag(child, TIF_IA32)) ? IA32_PAGE_OFFSET : TASK_SIZE64)
-
-
-
-DECLARE_PER_CPU(struct orig_ist, orig_ist);
-
-#define INIT_THREAD  { \
-	.sp0 = (unsigned long)&init_stack + sizeof(init_stack) \
-}
-
-#define INIT_TSS  { \
-	.x86_tss.sp0 = (unsigned long)&init_stack + sizeof(init_stack) \
-}
-
-#define start_thread(regs,new_rip,new_rsp) do { \
-	asm volatile("movl %0,%%fs; movl %0,%%es; movl %0,%%ds": :"r" (0));	 \
-	load_gs_index(0);							\
-	(regs)->ip = (new_rip);						 \
-	(regs)->sp = (new_rsp);						 \
-	write_pda(oldrsp, (new_rsp));						 \
-	(regs)->cs = __USER_CS;							 \
-	(regs)->ss = __USER_DS;							 \
-	(regs)->flags = 0x200;							 \
-	set_fs(USER_DS);							 \
-} while(0) 
-
-/*
- * Return saved PC of a blocked thread.
- * What is this good for? it will be always the scheduler or ret_from_fork.
- */
-#define thread_saved_pc(t) (*(unsigned long *)((t)->thread.sp - 8))
-
-#define task_pt_regs(tsk) ((struct pt_regs *)(tsk)->thread.sp0 - 1)
-#define KSTK_ESP(tsk) -1 /* sorry. doesn't work for syscall. */
-
-#endif /* __ASM_X86_64_PROCESSOR_H */
-- 
1.5.0.6

