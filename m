Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbXLSKSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbXLSKSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 05:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbXLSKSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 05:18:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36899 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916AbXLSKSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 05:18:40 -0500
Date: Wed, 19 Dec 2007 11:17:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH] finish processor.h integration
Message-ID: <20071219101736.GC3521@elte.hu>
References: <1198008293639-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198008293639-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber de Oliveira Costa <gcosta@redhat.com> wrote:

> What's left in processor_32.h and processor_64.h cannot be cleanly 
> integrated. However, it's just a couple of definitions. They are moved 
> to processor.h around ifdefs, and the original files are deleted. Note 
> that there's much less headers included in the final version.

hm, doesnt apply;

 Applying patch patches/x86-finish-processor-h-integration.patch
 patching file include/asm-x86/processor.h
 Hunk #2 FAILED at 287.
 Hunk #3 FAILED at 311.
 Hunk #4 succeeded at 786 (offset -8 lines).
 2 out of 4 hunks FAILED -- rejects in file include/asm-x86/processor.h

i fixed it up by hand - the result is below - does it look OK to you? 
(Also, could you check latest x86.git whether i've picked up all your 
patches correctly - the reject might be indicative of some missing 
pieces.)

	Ingo

------------>
Subject: finish processor.h integration
From: Glauber de Oliveira Costa <gcosta@redhat.com>

What's left in processor_32.h and processor_64.h cannot be cleanly
integrated. However, it's just a couple of definitions. They are moved
to processor.h around ifdefs, and the original files are deleted. Note that
there's much less headers included in the final version.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-x86/processor.h |  140 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 137 insertions(+), 3 deletions(-)

Index: linux-x86.q/include/asm-x86/processor.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/processor.h
+++ linux-x86.q/include/asm-x86/processor.h
@@ -7,12 +7,24 @@
 struct task_struct;
 struct mm_struct;
 
+#include <asm/vm86.h>
+#include <asm/math_emu.h>
+#include <asm/segment.h>
 #include <asm/page.h>
-#include <asm/percpu.h>
+#include <asm/types.h>
+#include <asm/sigcontext.h>
+#include <asm/current.h>
+#include <asm/cpufeature.h>
 #include <asm/system.h>
+#include <asm/page.h>
 #include <asm/percpu.h>
+#include <asm/msr.h>
+#include <asm/desc_defs.h>
+#include <linux/personality.h>
 #include <linux/cpumask.h>
 #include <linux/cache.h>
+#include <linux/threads.h>
+#include <linux/init.h>
 
 /*
  * Default implementation of macro that returns current
@@ -285,9 +297,13 @@ union i387_union {
 };
 
 #ifdef CONFIG_X86_32
-# include "processor_32.h"
+/*
+ * the following now lives in the per cpu area:
+ * extern	int cpu_llc_id[NR_CPUS];
+ */
+DECLARE_PER_CPU(u8, cpu_llc_id);
 #else
-# include "processor_64.h"
+DECLARE_PER_CPU(struct orig_ist, orig_ist);
 #endif
 
 extern void print_cpu_info(struct cpuinfo_x86 *);
@@ -770,6 +786,124 @@ static inline void prefetchw(const void 
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
