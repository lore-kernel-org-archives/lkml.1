Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbXLFTFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbXLFTFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbXLFTCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:02:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877AbXLFTB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:01:59 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 13/19] unify non-paravirt parts of desc.h
Date: Thu,  6 Dec 2007 14:16:34 -0200
Message-Id: <11969578671479-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1196957863723-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11969578092869-git-send-email-gcosta@redhat.com> <11969578142514-git-send-email-gcosta@redhat.com> <11969578193406-git-send-email-gcosta@redhat.com> <11969578242463-git-send-email-gcosta@redhat.com> <11969578292944-git-send-email-gcosta@redhat.com> <11969578343061-git-send-email-gcosta@redhat.com> <11969578383955-git-send-email-gcosta@redhat.com> <11969578431489-git-send-email-gcosta@redhat.com> <11969578483552-git-send-email-gcosta@redhat.com> <11969578534185-git-send-email-gcosta@redhat.com> <11969578581299-git-send-email-gcosta@redhat.com> <1196957863723-git-send-email-gcosta@redhat.com>
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

diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index 6065c50..926d6f8 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -1,5 +1,92 @@
+#ifndef _ASM_DESC_H_
+#define _ASM_DESC_H_
+
+#include <asm/desc_defs.h>
+
+#ifndef __ASSEMBLY__
+#include <asm/mmu.h>
+
+extern struct desc_ptr idt_descr;
+extern gate_desc idt_table[];
+
+#endif
+
 #ifdef CONFIG_X86_32
 # include "desc_32.h"
 #else
 # include "desc_64.h"
 #endif
+
+#ifndef __ASSEMBLY__
+
+#define _LDT_empty(info) (\
+	(info)->base_addr	== 0	&& \
+	(info)->limit		== 0	&& \
+	(info)->contents	== 0	&& \
+	(info)->read_exec_only	== 1	&& \
+	(info)->seg_32bit	== 0	&& \
+	(info)->limit_in_pages	== 0	&& \
+	(info)->seg_not_present	== 1	&& \
+	(info)->useable		== 0	)
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
+static inline unsigned long get_desc_base(unsigned long *desc)
+{
+	unsigned long base;
+	base = ((desc[0] >> 16)  & 0x0000ffff) |
+		((desc[1] << 16) & 0x00ff0000) |
+		(desc[1] & 0xff000000);
+	return base;
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
+#endif
diff --git a/include/asm-x86/desc_32.h b/include/asm-x86/desc_32.h
index 5d1e848..960ec77 100644
--- a/include/asm-x86/desc_32.h
+++ b/include/asm-x86/desc_32.h
@@ -11,8 +11,6 @@
 #include <linux/smp.h>
 #include <linux/percpu.h>
 
-#include <asm/mmu.h>
-
 struct gdt_page
 {
 	struct desc_struct gdt[GDT_ENTRIES];
@@ -24,8 +22,6 @@ static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
 	return per_cpu(gdt_page, cpu).gdt;
 }
 
-extern struct desc_ptr idt_descr;
-extern gate_desc idt_table[];
 extern void set_intr_gate(unsigned int irq, void * addr);
 
 static inline void pack_descriptor(struct desc_struct *desc,
@@ -162,68 +158,6 @@ static inline void __set_tss_desc(unsigned int cpu, unsigned int entry, const vo
 
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
-static inline unsigned long get_desc_base(unsigned long *desc)
-{
-	unsigned long base;
-	base = ((desc[0] >> 16)  & 0x0000ffff) |
-		((desc[1] << 16) & 0x00ff0000) |
-		(desc[1] & 0xff000000);
-	return base;
-}
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
diff --git a/include/asm-x86/desc_64.h b/include/asm-x86/desc_64.h
index 3cd5f10..2dc19e2 100644
--- a/include/asm-x86/desc_64.h
+++ b/include/asm-x86/desc_64.h
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
@@ -30,7 +27,6 @@ static inline unsigned long __store_tr(void)
 
 #define store_tr(tr) (tr) = __store_tr()
 
-extern gate_desc idt_table[];
 extern struct desc_ptr cpu_gdt_descr[];
 
 static inline void write_ldt_entry(struct desc_struct *ldt,
@@ -138,22 +134,18 @@ static inline void set_tss_desc(unsigned cpu, void *addr)
 		IO_BITMAP_OFFSET + IO_BITMAP_BYTES + sizeof(unsigned long) - 1);
 }
 
-static inline void set_ldt_desc(unsigned cpu, void *addr, int size)
+static inline void set_ldt(void *addr, int entries)
 {
-	set_tssldt_descriptor(&get_cpu_gdt_table(cpu)[GDT_ENTRY_LDT],
-			     (unsigned long)addr, DESC_LDT, size * 8 - 1);
-}
+	if (likely(entries == 0))
+		__asm__ __volatile__("lldt %w0"::"q" (0));
+	else {
+		unsigned cpu = smp_processor_id();
 
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
+		set_tssldt_descriptor(&get_cpu_gdt_table(cpu)[GDT_ENTRY_LDT],
+			     (unsigned long)addr, DESC_LDT, entries * 8 - 1);
+		__asm__ __volatile__("lldt %w0"::"q" (GDT_ENTRY_LDT*8));
+	}
+}
 
 static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
 {
@@ -164,42 +156,6 @@ static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
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
-static inline unsigned long get_desc_base(const void *ptr)
-{
-	const u32 *desc = ptr;
-	unsigned long base;
-	base = ((desc[0] >> 16)  & 0x0000ffff) |
-		((desc[1] << 16) & 0x00ff0000) |
-		(desc[1] & 0xff000000);
-	return base;
-}
-
 #endif /* !__ASSEMBLY__ */
 
 #endif
diff --git a/include/asm-x86/mmu_context_64.h b/include/asm-x86/mmu_context_64.h
index 29f95c3..98bfe43 100644
--- a/include/asm-x86/mmu_context_64.h
+++ b/include/asm-x86/mmu_context_64.h
@@ -43,7 +43,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		load_cr3(next->pgd);
 
 		if (unlikely(next->context.ldt != prev->context.ldt)) 
-			load_LDT_nolock(&next->context, cpu);
+			load_LDT_nolock(&next->context);
 	}
 #ifdef CONFIG_SMP
 	else {
@@ -56,7 +56,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 			 * to make sure to use no freed page tables.
 			 */
 			load_cr3(next->pgd);
-			load_LDT_nolock(&next->context, cpu);
+			load_LDT_nolock(&next->context);
 		}
 	}
 #endif
-- 
1.4.4.2

