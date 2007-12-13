Return-Path: <linux-kernel-owner+w=401wt.eu-S1763626AbXLMQpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763626AbXLMQpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760690AbXLMQnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:43:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762109AbXLMQnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:43:51 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 14/19] unify non-paravirt parts of desc.h
Date: Thu, 13 Dec 2007 11:58:02 -0200
Message-Id: <11975543843977-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11975543792334-git-send-email-gcosta@redhat.com>
References: <11975113122984-git-send-email-gcosta@redhat.com> <1197554287294-git-send-email-gcosta@redhat.com> <11975542952896-git-send-email-gcosta@redhat.com> <11975543001070-git-send-email-gcosta@redhat.com> <1197554307167-git-send-email-gcosta@redhat.com> <11975543173017-git-send-email-gcosta@redhat.com> <11975543382698-git-send-email-gcosta@redhat.com> <11975543442801-git-send-email-gcosta@redhat.com> <11975543492215-git-send-email-gcosta@redhat.com> <11975543543850-git-send-email-gcosta@redhat.com> <11975543592701-git-send-email-gcosta@redhat.com> <11975543641360-git-send-email-gcosta@redhat.com> <11975543691134-git-send-email-gcosta@redhat.com> <11975543742848-git-send-email-gcosta@redhat.com> <11975543792334-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch unifies the non-paravirt part of desc_{32,64}.h into
desc.h. Most of it, is simply common code, that is moved to
the shared header. The only exception is the set_ldt_desc in desc_64.h,
which is changed - included its name - to accomodate for the way
the ldt is set up in i386.

Also, constant definitions used in desc_32.h are moved to desc_defs.h

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/desc.h           |   87 ++++++++++++++++++++++++++++++++++++++
 include/asm-x86/desc_32.h        |   66 ----------------------------
 include/asm-x86/desc_64.h        |   64 ++++-----------------------
 include/asm-x86/mmu_context_64.h |    4 +-
 4 files changed, 99 insertions(+), 122 deletions(-)

Index: linux-2.6-x86/include/asm-x86/desc.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc.h
+++ linux-2.6-x86/include/asm-x86/desc.h
@@ -4,6 +4,7 @@
 #ifndef __ASSEMBLY__
 #include <asm/desc_defs.h>
 #include <asm/ldt.h>
+#include <asm/mmu.h>
 
 static inline void fill_ldt(struct desc_struct *desc, struct user_desc *info)
 {
@@ -23,7 +24,8 @@ static inline void fill_ldt(struct desc_
 	desc->base2 = (info->base_addr & 0xff000000) >> 24;
 }
 
-#endif
+extern struct desc_ptr idt_descr;
+extern gate_desc idt_table[];
 
 #ifdef CONFIG_X86_32
 # include "desc_32.h"
@@ -31,4 +33,65 @@ static inline void fill_ldt(struct desc_
 # include "desc_64.h"
 #endif
 
+#define _LDT_empty(info) (\
+	(info)->base_addr	== 0	&& \
+	(info)->limit		== 0	&& \
+	(info)->contents	== 0	&& \
+	(info)->read_exec_only	== 1	&& \
+	(info)->seg_32bit	== 0	&& \
+	(info)->limit_in_pages	== 0	&& \
+	(info)->seg_not_present	== 1	&& \
+	(info)->useable		== 0)
+
+#ifdef CONFIG_X86_64
+#define LDT_empty(info) (_LDT_empty(info) && ((info)->lm == 0))
+#else
+#define LDT_empty(info) (_LDT_empty(info))
+#endif
+
+static inline void clear_LDT(void)
+{
+	set_ldt(NULL, 0);
+}
+
+/*
+ * load one particular LDT into the current CPU
+ */
+static inline void load_LDT_nolock(mm_context_t *pc)
+{
+	set_ldt(pc->ldt, pc->size);
+}
+
+static inline void load_LDT(mm_context_t *pc)
+{
+	preempt_disable();
+	load_LDT_nolock(pc);
+	preempt_enable();
+}
+
+#else
+/*
+ * GET_DESC_BASE reads the descriptor base of the specified segment.
+ *
+ * Args:
+ *    idx - descriptor index
+ *    gdt - GDT pointer
+ *    base - 32bit register to which the base will be written
+ *    lo_w - lo word of the "base" register
+ *    lo_b - lo byte of the "base" register
+ *    hi_b - hi byte of the low word of the "base" register
+ *
+ * Example:
+ *    GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah)
+ *    Will read the base address of GDT_ENTRY_ESPFIX_SS and put it into %eax.
+ */
+#define GET_DESC_BASE(idx, gdt, base, lo_w, lo_b, hi_b) \
+	movb idx*8+4(gdt), lo_b; \
+	movb idx*8+7(gdt), hi_b; \
+	shll $16, base; \
+	movw idx*8+2(gdt), lo_w;
+
+
+#endif /* __ASSEMBLY__ */
+
 #endif
Index: linux-2.6-x86/include/asm-x86/desc_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc_32.h
+++ linux-2.6-x86/include/asm-x86/desc_32.h
@@ -11,8 +11,6 @@
 #include <linux/smp.h>
 #include <linux/percpu.h>
 
-#include <asm/mmu.h>
-
 struct gdt_page
 {
 	struct desc_struct gdt[GDT_ENTRIES];
@@ -24,8 +22,6 @@ static inline struct desc_struct *get_cp
 	return per_cpu(gdt_page, cpu).gdt;
 }
 
-extern struct desc_ptr idt_descr;
-extern gate_desc idt_table[];
 extern void set_intr_gate(unsigned int irq, void * addr);
 
 static inline void pack_descriptor(struct desc_struct *desc,
@@ -172,36 +168,6 @@ static inline void __set_tss_desc(unsign
 
 #define set_tss_desc(cpu,addr) __set_tss_desc(cpu, GDT_ENTRY_TSS, addr)
 
-#define LDT_empty(info) (\
-	(info)->base_addr	== 0	&& \
-	(info)->limit		== 0	&& \
-	(info)->contents	== 0	&& \
-	(info)->read_exec_only	== 1	&& \
-	(info)->seg_32bit	== 0	&& \
-	(info)->limit_in_pages	== 0	&& \
-	(info)->seg_not_present	== 1	&& \
-	(info)->useable		== 0	)
-
-static inline void clear_LDT(void)
-{
-	set_ldt(NULL, 0);
-}
-
-/*
- * load one particular LDT into the current CPU
- */
-static inline void load_LDT_nolock(mm_context_t *pc)
-{
-	set_ldt(pc->ldt, pc->size);
-}
-
-static inline void load_LDT(mm_context_t *pc)
-{
-	preempt_disable();
-	load_LDT_nolock(pc);
-	preempt_enable();
-}
-
 static inline unsigned long get_desc_base(unsigned long *desc)
 {
 	unsigned long base;
@@ -210,30 +176,6 @@ static inline unsigned long get_desc_bas
 		(desc[1] & 0xff000000);
 	return base;
 }
-
-#else /* __ASSEMBLY__ */
-
-/*
- * GET_DESC_BASE reads the descriptor base of the specified segment.
- *
- * Args:
- *    idx - descriptor index
- *    gdt - GDT pointer
- *    base - 32bit register to which the base will be written
- *    lo_w - lo word of the "base" register
- *    lo_b - lo byte of the "base" register
- *    hi_b - hi byte of the low word of the "base" register
- *
- * Example:
- *    GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah)
- *    Will read the base address of GDT_ENTRY_ESPFIX_SS and put it into %eax.
- */
-#define GET_DESC_BASE(idx, gdt, base, lo_w, lo_b, hi_b) \
-	movb idx*8+4(gdt), lo_b; \
-	movb idx*8+7(gdt), hi_b; \
-	shll $16, base; \
-	movw idx*8+2(gdt), lo_w;
-
 #endif /* !__ASSEMBLY__ */
 
 #endif
Index: linux-2.6-x86/include/asm-x86/desc_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc_64.h
+++ linux-2.6-x86/include/asm-x86/desc_64.h
@@ -9,16 +9,13 @@
 
 #include <linux/string.h>
 #include <linux/smp.h>
-#include <asm/desc_defs.h>
 
 #include <asm/segment.h>
-#include <asm/mmu.h>
 
 extern struct desc_struct cpu_gdt_table[GDT_ENTRIES];
 
 #define load_TR_desc() asm volatile("ltr %w0"::"r" (GDT_ENTRY_TSS*8))
 #define load_LDT_desc() asm volatile("lldt %w0"::"r" (GDT_ENTRY_LDT*8))
-#define clear_LDT()  asm volatile("lldt %w0"::"r" (0))
 
 static inline unsigned long __store_tr(void)
 {
@@ -30,7 +27,6 @@ static inline unsigned long __store_tr(v
 
 #define store_tr(tr) (tr) = __store_tr()
 
-extern gate_desc idt_table[];
 extern struct desc_ptr cpu_gdt_descr[];
 
 static inline void write_ldt_entry(struct desc_struct *ldt,
@@ -138,23 +134,19 @@ static inline void set_tss_desc(unsigned
 		IO_BITMAP_OFFSET + IO_BITMAP_BYTES + sizeof(unsigned long) - 1);
 }
 
-static inline void set_ldt_desc(unsigned cpu, void *addr, int size)
+static inline void set_ldt(void *addr, int entries)
 {
-	set_tssldt_descriptor(&get_cpu_gdt_table(cpu)[GDT_ENTRY_LDT],
-			     (unsigned long)addr, DESC_LDT, size * 8 - 1);
+	if (likely(entries == 0))
+		__asm__ __volatile__("lldt %w0"::"q" (0));
+	else {
+		unsigned cpu = smp_processor_id();
+
+		set_tssldt_descriptor(&get_cpu_gdt_table(cpu)[GDT_ENTRY_LDT],
+			     (unsigned long)addr, DESC_LDT, entries * 8 - 1);
+		__asm__ __volatile__("lldt %w0"::"q" (GDT_ENTRY_LDT*8));
+	}
 }
 
-#define LDT_empty(info) (\
-	(info)->base_addr	== 0	&& \
-	(info)->limit		== 0	&& \
-	(info)->contents	== 0	&& \
-	(info)->read_exec_only	== 1	&& \
-	(info)->seg_32bit	== 0	&& \
-	(info)->limit_in_pages	== 0	&& \
-	(info)->seg_not_present	== 1	&& \
-	(info)->useable		== 0	&& \
-	(info)->lm		== 0)
-
 static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
 {
 	unsigned int i;
@@ -164,32 +156,6 @@ static inline void load_TLS(struct threa
 		gdt[i] = t->tls_array[i];
 }
 
-/*
- * load one particular LDT into the current CPU
- */
-static inline void load_LDT_nolock(mm_context_t *pc, int cpu)
-{
-	int count = pc->size;
-
-	if (likely(!count)) {
-		clear_LDT();
-		return;
-	}
-
-	set_ldt_desc(cpu, pc->ldt, count);
-	load_LDT_desc();
-}
-
-static inline void load_LDT(mm_context_t *pc)
-{
-	int cpu = get_cpu();
-
-	load_LDT_nolock(pc, cpu);
-	put_cpu();
-}
-
-extern struct desc_ptr idt_descr;
-
 static inline unsigned long get_desc_base(const void *ptr)
 {
 	const u32 *desc = ptr;
@@ -199,7 +165,6 @@ static inline unsigned long get_desc_bas
 		(desc[1] & 0xff000000);
 	return base;
 }
-
 #endif /* !__ASSEMBLY__ */
 
 #endif
Index: linux-2.6-x86/include/asm-x86/mmu_context_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/mmu_context_64.h
+++ linux-2.6-x86/include/asm-x86/mmu_context_64.h
@@ -43,7 +43,7 @@ static inline void switch_mm(struct mm_s
 		load_cr3(next->pgd);
 
 		if (unlikely(next->context.ldt != prev->context.ldt)) 
-			load_LDT_nolock(&next->context, cpu);
+			load_LDT_nolock(&next->context);
 	}
 #ifdef CONFIG_SMP
 	else {
@@ -56,7 +56,7 @@ static inline void switch_mm(struct mm_s
 			 * to make sure to use no freed page tables.
 			 */
 			load_cr3(next->pgd);
-			load_LDT_nolock(&next->context, cpu);
+			load_LDT_nolock(&next->context);
 		}
 	}
 #endif
