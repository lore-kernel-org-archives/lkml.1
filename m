Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbXD3K3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbXD3K3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbXD3K3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:29:10 -0400
Received: from ns.suse.de ([195.135.220.2]:51170 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbXD3K1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:27:46 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, linux-arch@vger.kernel.org, James.Bottomley@SteelEye.com,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [8/40] x86: add hooks to intercept mm creation and destruction
Message-Id: <20070430102741.43396151D3@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:27:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Add hooks to allow a paravirt implementation to track the lifetime of
an mm.  Paravirtualization requires three hooks, but only two are
needed in common code.  They are:

arch_dup_mmap, which is called when a new mmap is created at fork

arch_exit_mmap, which is called when the last process reference to an
  mm is dropped, which typically happens on exit and exec.

The third hook is activate_mm, which is called from the arch-specific
activate_mm() macro/function, and so doesn't need stub versions for
other architectures.  It's called when an mm is first used.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: linux-arch@vger.kernel.org
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Acked-by: Ingo Molnar <mingo@elte.hu>

---
 arch/i386/kernel/paravirt.c         |    4 ++++
 include/asm-alpha/mmu_context.h     |    1 +
 include/asm-arm/mmu_context.h       |    1 +
 include/asm-arm26/mmu_context.h     |    2 ++
 include/asm-avr32/mmu_context.h     |    1 +
 include/asm-cris/mmu_context.h      |    2 ++
 include/asm-frv/mmu_context.h       |    1 +
 include/asm-generic/mm_hooks.h      |   18 ++++++++++++++++++
 include/asm-h8300/mmu_context.h     |    1 +
 include/asm-i386/mmu_context.h      |   17 +++++++++++++++--
 include/asm-i386/paravirt.h         |   23 +++++++++++++++++++++++
 include/asm-ia64/mmu_context.h      |    1 +
 include/asm-m32r/mmu_context.h      |    1 +
 include/asm-m68k/mmu_context.h      |    1 +
 include/asm-m68knommu/mmu_context.h |    1 +
 include/asm-mips/mmu_context.h      |    1 +
 include/asm-parisc/mmu_context.h    |    1 +
 include/asm-powerpc/mmu_context.h   |    1 +
 include/asm-ppc/mmu_context.h       |    1 +
 include/asm-s390/mmu_context.h      |    2 ++
 include/asm-sh/mmu_context.h        |    1 +
 include/asm-sh64/mmu_context.h      |    2 +-
 include/asm-sparc/mmu_context.h     |    2 ++
 include/asm-sparc64/mmu_context.h   |    1 +
 include/asm-um/mmu_context.h        |    2 ++
 include/asm-v850/mmu_context.h      |    2 ++
 include/asm-x86_64/mmu_context.h    |    1 +
 include/asm-xtensa/mmu_context.h    |    1 +
 kernel/fork.c                       |    2 ++
 mm/mmap.c                           |    4 ++++
 30 files changed, 96 insertions(+), 3 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/paravirt.c
===================================================================
--- linux.orig/arch/i386/kernel/paravirt.c
+++ linux/arch/i386/kernel/paravirt.c
@@ -237,6 +237,10 @@ struct paravirt_ops paravirt_ops = {
 	.irq_enable_sysexit = native_irq_enable_sysexit,
 	.iret = native_iret,
 
+	.dup_mmap = paravirt_nop,
+	.exit_mmap = paravirt_nop,
+	.activate_mm = paravirt_nop,
+
 	.startup_ipi_hook = paravirt_nop,
 };
 
Index: linux/include/asm-alpha/mmu_context.h
===================================================================
--- linux.orig/include/asm-alpha/mmu_context.h
+++ linux/include/asm-alpha/mmu_context.h
@@ -10,6 +10,7 @@
 #include <asm/system.h>
 #include <asm/machvec.h>
 #include <asm/compiler.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * Force a context reload. This is needed when we change the page
Index: linux/include/asm-arm/mmu_context.h
===================================================================
--- linux.orig/include/asm-arm/mmu_context.h
+++ linux/include/asm-arm/mmu_context.h
@@ -16,6 +16,7 @@
 #include <linux/compiler.h>
 #include <asm/cacheflush.h>
 #include <asm/proc-fns.h>
+#include <asm-generic/mm_hooks.h>
 
 void __check_kvm_seq(struct mm_struct *mm);
 
Index: linux/include/asm-arm26/mmu_context.h
===================================================================
--- linux.orig/include/asm-arm26/mmu_context.h
+++ linux/include/asm-arm26/mmu_context.h
@@ -13,6 +13,8 @@
 #ifndef __ASM_ARM_MMU_CONTEXT_H
 #define __ASM_ARM_MMU_CONTEXT_H
 
+#include <asm-generic/mm_hooks.h>
+
 #define init_new_context(tsk,mm)	0
 #define destroy_context(mm)		do { } while(0)
 
Index: linux/include/asm-avr32/mmu_context.h
===================================================================
--- linux.orig/include/asm-avr32/mmu_context.h
+++ linux/include/asm-avr32/mmu_context.h
@@ -15,6 +15,7 @@
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
 #include <asm/sysreg.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * The MMU "context" consists of two things:
Index: linux/include/asm-cris/mmu_context.h
===================================================================
--- linux.orig/include/asm-cris/mmu_context.h
+++ linux/include/asm-cris/mmu_context.h
@@ -1,6 +1,8 @@
 #ifndef __CRIS_MMU_CONTEXT_H
 #define __CRIS_MMU_CONTEXT_H
 
+#include <asm-generic/mm_hooks.h>
+
 extern int init_new_context(struct task_struct *tsk, struct mm_struct *mm);
 extern void get_mmu_context(struct mm_struct *mm);
 extern void destroy_context(struct mm_struct *mm);
Index: linux/include/asm-frv/mmu_context.h
===================================================================
--- linux.orig/include/asm-frv/mmu_context.h
+++ linux/include/asm-frv/mmu_context.h
@@ -15,6 +15,7 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
Index: linux/include/asm-generic/mm_hooks.h
===================================================================
--- /dev/null
+++ linux/include/asm-generic/mm_hooks.h
@@ -0,0 +1,18 @@
+/*
+ * Define generic no-op hooks for arch_dup_mmap and arch_exit_mmap, to
+ * be included in asm-FOO/mmu_context.h for any arch FOO which doesn't
+ * need to hook these.
+ */
+#ifndef _ASM_GENERIC_MM_HOOKS_H
+#define _ASM_GENERIC_MM_HOOKS_H
+
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
+
+#endif	/* _ASM_GENERIC_MM_HOOKS_H */
Index: linux/include/asm-h8300/mmu_context.h
===================================================================
--- linux.orig/include/asm-h8300/mmu_context.h
+++ linux/include/asm-h8300/mmu_context.h
@@ -4,6 +4,7 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
Index: linux/include/asm-i386/mmu_context.h
===================================================================
--- linux.orig/include/asm-i386/mmu_context.h
+++ linux/include/asm-i386/mmu_context.h
@@ -5,6 +5,16 @@
 #include <asm/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
+#include <asm/paravirt.h>
+#ifndef CONFIG_PARAVIRT
+#include <asm-generic/mm_hooks.h>
+
+static inline void paravirt_activate_mm(struct mm_struct *prev,
+					struct mm_struct *next)
+{
+}
+#endif	/* !CONFIG_PARAVIRT */
+
 
 /*
  * Used for LDT copy/destruction.
@@ -65,7 +75,10 @@ static inline void switch_mm(struct mm_s
 #define deactivate_mm(tsk, mm)			\
 	asm("movl %0,%%gs": :"r" (0));
 
-#define activate_mm(prev, next) \
-	switch_mm((prev),(next),NULL)
+#define activate_mm(prev, next)				\
+	do {						\
+		paravirt_activate_mm(prev, next);	\
+		switch_mm((prev),(next),NULL);		\
+	} while(0);
 
 #endif
Index: linux/include/asm-i386/paravirt.h
===================================================================
--- linux.orig/include/asm-i386/paravirt.h
+++ linux/include/asm-i386/paravirt.h
@@ -119,6 +119,12 @@ struct paravirt_ops
 
 	void (*io_delay)(void);
 
+	void (*activate_mm)(struct mm_struct *prev,
+			    struct mm_struct *next);
+	void (*dup_mmap)(struct mm_struct *oldmm,
+			 struct mm_struct *mm);
+	void (*exit_mmap)(struct mm_struct *mm);
+
 #ifdef CONFIG_X86_LOCAL_APIC
 	void (*apic_write)(unsigned long reg, unsigned long v);
 	void (*apic_write_atomic)(unsigned long reg, unsigned long v);
@@ -395,6 +401,23 @@ static inline void startup_ipi_hook(int 
 }
 #endif
 
+static inline void paravirt_activate_mm(struct mm_struct *prev,
+					struct mm_struct *next)
+{
+	paravirt_ops.activate_mm(prev, next);
+}
+
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+	paravirt_ops.dup_mmap(oldmm, mm);
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+	paravirt_ops.exit_mmap(mm);
+}
+
 #define __flush_tlb() paravirt_ops.flush_tlb_user()
 #define __flush_tlb_global() paravirt_ops.flush_tlb_kernel()
 #define __flush_tlb_single(addr) paravirt_ops.flush_tlb_single(addr)
Index: linux/include/asm-ia64/mmu_context.h
===================================================================
--- linux.orig/include/asm-ia64/mmu_context.h
+++ linux/include/asm-ia64/mmu_context.h
@@ -29,6 +29,7 @@
 #include <linux/spinlock.h>
 
 #include <asm/processor.h>
+#include <asm-generic/mm_hooks.h>
 
 struct ia64_ctx {
 	spinlock_t lock;
Index: linux/include/asm-m32r/mmu_context.h
===================================================================
--- linux.orig/include/asm-m32r/mmu_context.h
+++ linux/include/asm-m32r/mmu_context.h
@@ -15,6 +15,7 @@
 #include <asm/pgalloc.h>
 #include <asm/mmu.h>
 #include <asm/tlbflush.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * Cache of MMU context last used.
Index: linux/include/asm-m68k/mmu_context.h
===================================================================
--- linux.orig/include/asm-m68k/mmu_context.h
+++ linux/include/asm-m68k/mmu_context.h
@@ -1,6 +1,7 @@
 #ifndef __M68K_MMU_CONTEXT_H
 #define __M68K_MMU_CONTEXT_H
 
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
Index: linux/include/asm-m68knommu/mmu_context.h
===================================================================
--- linux.orig/include/asm-m68knommu/mmu_context.h
+++ linux/include/asm-m68knommu/mmu_context.h
@@ -4,6 +4,7 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
Index: linux/include/asm-mips/mmu_context.h
===================================================================
--- linux.orig/include/asm-mips/mmu_context.h
+++ linux/include/asm-mips/mmu_context.h
@@ -20,6 +20,7 @@
 #include <asm/mipsmtregs.h>
 #include <asm/smtc.h>
 #endif /* SMTC */
+#include <asm-generic/mm_hooks.h>
 
 /*
  * For the fast tlb miss handlers, we keep a per cpu array of pointers
Index: linux/include/asm-parisc/mmu_context.h
===================================================================
--- linux.orig/include/asm-parisc/mmu_context.h
+++ linux/include/asm-parisc/mmu_context.h
@@ -5,6 +5,7 @@
 #include <asm/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
Index: linux/include/asm-powerpc/mmu_context.h
===================================================================
--- linux.orig/include/asm-powerpc/mmu_context.h
+++ linux/include/asm-powerpc/mmu_context.h
@@ -10,6 +10,7 @@
 #include <linux/mm.h>	
 #include <asm/mmu.h>	
 #include <asm/cputable.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * Copyright (C) 2001 PPC 64 Team, IBM Corp
Index: linux/include/asm-ppc/mmu_context.h
===================================================================
--- linux.orig/include/asm-ppc/mmu_context.h
+++ linux/include/asm-ppc/mmu_context.h
@@ -6,6 +6,7 @@
 #include <asm/bitops.h>
 #include <asm/mmu.h>
 #include <asm/cputable.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * On 32-bit PowerPC 6xx/7xx/7xxx CPUs, we use a set of 16 VSIDs
Index: linux/include/asm-s390/mmu_context.h
===================================================================
--- linux.orig/include/asm-s390/mmu_context.h
+++ linux/include/asm-s390/mmu_context.h
@@ -10,6 +10,8 @@
 #define __S390_MMU_CONTEXT_H
 
 #include <asm/pgalloc.h>
+#include <asm-generic/mm_hooks.h>
+
 /*
  * get a new mmu context.. S390 don't know about contexts.
  */
Index: linux/include/asm-sh/mmu_context.h
===================================================================
--- linux.orig/include/asm-sh/mmu_context.h
+++ linux/include/asm-sh/mmu_context.h
@@ -12,6 +12,7 @@
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * The MMU "context" consists of two things:
Index: linux/include/asm-sh64/mmu_context.h
===================================================================
--- linux.orig/include/asm-sh64/mmu_context.h
+++ linux/include/asm-sh64/mmu_context.h
@@ -27,7 +27,7 @@
 extern unsigned long mmu_context_cache;
 
 #include <asm/page.h>
-
+#include <asm-generic/mm_hooks.h>
 
 /* Current mm's pgd */
 extern pgd_t *mmu_pdtp_cache;
Index: linux/include/asm-sparc/mmu_context.h
===================================================================
--- linux.orig/include/asm-sparc/mmu_context.h
+++ linux/include/asm-sparc/mmu_context.h
@@ -5,6 +5,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm-generic/mm_hooks.h>
+
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
 }
Index: linux/include/asm-sparc64/mmu_context.h
===================================================================
--- linux.orig/include/asm-sparc64/mmu_context.h
+++ linux/include/asm-sparc64/mmu_context.h
@@ -9,6 +9,7 @@
 #include <linux/spinlock.h>
 #include <asm/system.h>
 #include <asm/spitfire.h>
+#include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
Index: linux/include/asm-um/mmu_context.h
===================================================================
--- linux.orig/include/asm-um/mmu_context.h
+++ linux/include/asm-um/mmu_context.h
@@ -6,6 +6,8 @@
 #ifndef __UM_MMU_CONTEXT_H
 #define __UM_MMU_CONTEXT_H
 
+#include <asm-generic/mm_hooks.h>
+
 #include "linux/sched.h"
 #include "choose-mode.h"
 #include "um_mmu.h"
Index: linux/include/asm-v850/mmu_context.h
===================================================================
--- linux.orig/include/asm-v850/mmu_context.h
+++ linux/include/asm-v850/mmu_context.h
@@ -1,6 +1,8 @@
 #ifndef __V850_MMU_CONTEXT_H__
 #define __V850_MMU_CONTEXT_H__
 
+#include <asm-generic/mm_hooks.h>
+
 #define destroy_context(mm)		((void)0)
 #define init_new_context(tsk,mm)	0
 #define switch_mm(prev,next,tsk)	((void)0)
Index: linux/include/asm-x86_64/mmu_context.h
===================================================================
--- linux.orig/include/asm-x86_64/mmu_context.h
+++ linux/include/asm-x86_64/mmu_context.h
@@ -7,6 +7,7 @@
 #include <asm/pda.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
+#include <asm-generic/mm_hooks.h>
 
 /*
  * possibly do the LDT unload here?
Index: linux/include/asm-xtensa/mmu_context.h
===================================================================
--- linux.orig/include/asm-xtensa/mmu_context.h
+++ linux/include/asm-xtensa/mmu_context.h
@@ -18,6 +18,7 @@
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
+#include <asm-generic/mm_hooks.h>
 
 #define XCHAL_MMU_ASID_BITS	8
 
Index: linux/kernel/fork.c
===================================================================
--- linux.orig/kernel/fork.c
+++ linux/kernel/fork.c
@@ -286,6 +286,8 @@ static inline int dup_mmap(struct mm_str
 		if (retval)
 			goto out;
 	}
+	/* a new mm has just been created */
+	arch_dup_mmap(oldmm, mm);
 	retval = 0;
 out:
 	up_write(&mm->mmap_sem);
Index: linux/mm/mmap.c
===================================================================
--- linux.orig/mm/mmap.c
+++ linux/mm/mmap.c
@@ -29,6 +29,7 @@
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
 #include <asm/tlb.h>
+#include <asm/mmu_context.h>
 
 #ifndef arch_mmap_check
 #define arch_mmap_check(addr, len, flags)	(0)
@@ -1979,6 +1980,9 @@ void exit_mmap(struct mm_struct *mm)
 	unsigned long nr_accounted = 0;
 	unsigned long end;
 
+	/* mm's last user has gone, and its about to be pulled down */
+	arch_exit_mmap(mm);
+
 	lru_add_drain();
 	flush_cache_mm(mm);
 	tlb = tlb_gather_mmu(mm, 1);
