Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbXKIV3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbXKIV3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757869AbXKIV2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:28:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757830AbXKIV2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:28:40 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/24] tlb functions consolidation
Date: Fri,  9 Nov 2007 16:42:45 -0200
Message-Id: <11946338103068-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11946338053158-git-send-email-gcosta@redhat.com>
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <11946337991750-git-send-email-gcosta@redhat.com> <11946338053158-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch consolidates part of the tlb handling functions for the x86
architecture. In this approach, we start by the parts actually used for
paravirt in i386.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/smp_64.c      |    5 ++-
 include/asm-x86/tlbflush.h    |   77 +++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/tlbflush_32.h |   77 -----------------------------------------
 include/asm-x86/tlbflush_64.h |   43 +++--------------------
 4 files changed, 85 insertions(+), 117 deletions(-)

diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index 62b0f2a..ce3935b 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -166,11 +166,12 @@ out:
 	add_pda(irq_tlb_count, 1);
 }
 
-static void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
-						unsigned long va)
+void native_flush_tlb_others(const cpumask_t *cpumaskp,
+			     struct mm_struct *mm, unsigned long va)
 {
 	int sender;
 	union smp_flush_state *f;
+	cpumask_t cpumask = *cpumaskp;
 
 	/* Caller has disabled preemption */
 	sender = smp_processor_id() % NUM_INVALIDATE_TLB_VECTORS;
diff --git a/include/asm-x86/tlbflush.h b/include/asm-x86/tlbflush.h
index 9af4cc8..93283cf 100644
--- a/include/asm-x86/tlbflush.h
+++ b/include/asm-x86/tlbflush.h
@@ -1,5 +1,82 @@
+#ifndef _X86_TLBFLUSH_H_
+#define _X86_TLBFLUSH_H_
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define __flush_tlb() __native_flush_tlb()
+#define __flush_tlb_global() __native_flush_tlb_global()
+#define __flush_tlb_single(addr) __native_flush_tlb_single(addr)
+#endif
+
+static inline void __native_flush_tlb(void)
+{
+	write_cr3(read_cr3());
+}
+
+static inline void __native_flush_tlb_global(void)
+{
+	unsigned long cr4 = read_cr4();
+	write_cr4(cr4 & ~X86_CR4_PGE);  /* clear PGE */
+	write_cr4(cr4);                 /* write old PGE again and flush TLBs */
+}
+
+#define __native_flush_tlb_single(addr) 				\
+	__asm__ __volatile__("invlpg (%0)" ::"r" (addr) : "memory")
+
+#ifdef CONFIG_SMP
+
+#include <asm/smp.h>
+#include <linux/mm.h>
+
+#define local_flush_tlb() \
+	__flush_tlb()
+
+extern void flush_tlb_all(void);
+extern void flush_tlb_current_task(void);
+extern void flush_tlb_mm(struct mm_struct *);
+extern void flush_tlb_page(struct vm_area_struct *, unsigned long);
+
+#define flush_tlb()	flush_tlb_current_task()
+
+static inline void flush_tlb_range(struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end)
+{
+	flush_tlb_mm(vma->vm_mm);
+}
+
+void native_flush_tlb_others(const cpumask_t *cpumask, struct mm_struct *mm,
+			     unsigned long va);
+
+#define TLBSTATE_OK	1
+#define TLBSTATE_LAZY	2
+
+#ifdef CONFIG_X86_64
+/* Roughly an IPI every 20MB with 4k pages for freeing page table
+   ranges. Cost is about 42k of memory for each CPU. */
+#define ARCH_FREE_PTE_NR 5350
+
+#else /* X86_64 */
+struct tlb_state
+{
+	struct mm_struct *active_mm;
+	int state;
+	char __cacheline_padding[L1_CACHE_BYTES-8];
+};
+DECLARE_PER_CPU(struct tlb_state, cpu_tlbstate);
+#endif /* X86_64 */
+
+#endif
+
+#ifndef CONFIG_PARAVIRT
+#define flush_tlb_others(mask, mm, va)		\
+	native_flush_tlb_others(&mask, mm, va)
+#endif
+
 #ifdef CONFIG_X86_32
 # include "tlbflush_32.h"
 #else
 # include "tlbflush_64.h"
 #endif
+
+#endif
diff --git a/include/asm-x86/tlbflush_32.h b/include/asm-x86/tlbflush_32.h
index 2bd5b95..07eaf37 100644
--- a/include/asm-x86/tlbflush_32.h
+++ b/include/asm-x86/tlbflush_32.h
@@ -1,49 +1,8 @@
 #ifndef _I386_TLBFLUSH_H
 #define _I386_TLBFLUSH_H
 
-#include <linux/mm.h>
 #include <asm/processor.h>
 
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#define __flush_tlb() __native_flush_tlb()
-#define __flush_tlb_global() __native_flush_tlb_global()
-#define __flush_tlb_single(addr) __native_flush_tlb_single(addr)
-#endif
-
-#define __native_flush_tlb()						\
-	do {								\
-		unsigned int tmpreg;					\
-									\
-		__asm__ __volatile__(					\
-			"movl %%cr3, %0;              \n"		\
-			"movl %0, %%cr3;  # flush TLB \n"		\
-			: "=r" (tmpreg)					\
-			:: "memory");					\
-	} while (0)
-
-/*
- * Global pages have to be flushed a bit differently. Not a real
- * performance problem because this does not happen often.
- */
-#define __native_flush_tlb_global()					\
-	do {								\
-		unsigned int tmpreg, cr4, cr4_orig;			\
-									\
-		__asm__ __volatile__(					\
-			"movl %%cr4, %2;  # turn off PGE     \n"	\
-			"movl %2, %1;                        \n"	\
-			"andl %3, %1;                        \n"	\
-			"movl %1, %%cr4;                     \n"	\
-			"movl %%cr3, %0;                     \n"	\
-			"movl %0, %%cr3;  # flush TLB        \n"	\
-			"movl %2, %%cr4;  # turn PGE back on \n"	\
-			: "=&r" (tmpreg), "=&r" (cr4), "=&r" (cr4_orig)	\
-			: "i" (~X86_CR4_PGE)				\
-			: "memory");					\
-	} while (0)
-
 #define __native_flush_tlb_single(addr) 				\
 	__asm__ __volatile__("invlpg (%0)" ::"r" (addr) : "memory")
 
@@ -120,44 +79,8 @@ static inline void native_flush_tlb_others(const cpumask_t *cpumask,
 {
 }
 
-#else  /* SMP */
-
-#include <asm/smp.h>
-
-#define local_flush_tlb() \
-	__flush_tlb()
-
-extern void flush_tlb_all(void);
-extern void flush_tlb_current_task(void);
-extern void flush_tlb_mm(struct mm_struct *);
-extern void flush_tlb_page(struct vm_area_struct *, unsigned long);
-
-#define flush_tlb()	flush_tlb_current_task()
-
-static inline void flush_tlb_range(struct vm_area_struct * vma, unsigned long start, unsigned long end)
-{
-	flush_tlb_mm(vma->vm_mm);
-}
-
-void native_flush_tlb_others(const cpumask_t *cpumask, struct mm_struct *mm,
-			     unsigned long va);
-
-#define TLBSTATE_OK	1
-#define TLBSTATE_LAZY	2
-
-struct tlb_state
-{
-	struct mm_struct *active_mm;
-	int state;
-	char __cacheline_padding[L1_CACHE_BYTES-8];
-};
-DECLARE_PER_CPU(struct tlb_state, cpu_tlbstate);
 #endif	/* SMP */
 
-#ifndef CONFIG_PARAVIRT
-#define flush_tlb_others(mask, mm, va)		\
-	native_flush_tlb_others(&mask, mm, va)
-#endif
 
 static inline void flush_tlb_kernel_range(unsigned long start,
 					unsigned long end)
diff --git a/include/asm-x86/tlbflush_64.h b/include/asm-x86/tlbflush_64.h
index 7731fd2..d1d1097 100644
--- a/include/asm-x86/tlbflush_64.h
+++ b/include/asm-x86/tlbflush_64.h
@@ -6,21 +6,8 @@
 #include <asm/processor.h>
 #include <asm/system.h>
 
-static inline void __flush_tlb(void)
-{
-	write_cr3(read_cr3());
-}
-
-static inline void __flush_tlb_all(void)
-{
-	unsigned long cr4 = read_cr4();
-	write_cr4(cr4 & ~X86_CR4_PGE);	/* clear PGE */
-	write_cr4(cr4);			/* write old PGE again and flush TLBs */
-}
-
-#define __flush_tlb_one(addr) \
-	__asm__ __volatile__("invlpg (%0)" :: "r" (addr) : "memory")
-
+#define __flush_tlb_one(addr) __flush_tlb_single(addr)
+#define __flush_tlb_all() __flush_tlb_global()
 
 /*
  * TLB flushing:
@@ -63,32 +50,12 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
 		__flush_tlb();
 }
 
-#else
-
-#include <asm/smp.h>
-
-#define local_flush_tlb() \
-	__flush_tlb()
-
-extern void flush_tlb_all(void);
-extern void flush_tlb_current_task(void);
-extern void flush_tlb_mm(struct mm_struct *);
-extern void flush_tlb_page(struct vm_area_struct *, unsigned long);
-
-#define flush_tlb()	flush_tlb_current_task()
-
-static inline void flush_tlb_range(struct vm_area_struct * vma, unsigned long start, unsigned long end)
+static inline void native_flush_tlb_others(const cpumask_t *cpumask,
+					   struct mm_struct *mm,
+					   unsigned long va)
 {
-	flush_tlb_mm(vma->vm_mm);
 }
 
-#define TLBSTATE_OK	1
-#define TLBSTATE_LAZY	2
-
-/* Roughly an IPI every 20MB with 4k pages for freeing page table
-   ranges. Cost is about 42k of memory for each CPU. */
-#define ARCH_FREE_PTE_NR 5350	
-
 #endif
 
 static inline void flush_tlb_kernel_range(unsigned long start,
-- 
1.4.4.2

