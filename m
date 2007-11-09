Return-Path: <linux-kernel-owner+w=401wt.eu-S1759604AbXKIVfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604AbXKIVfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759034AbXKIV3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:29:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757746AbXKIV3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:29:40 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 16/24] add native functions for descriptors handling
Date: Fri,  9 Nov 2007 16:42:57 -0200
Message-Id: <1194633873306-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11946338683305-git-send-email-gcosta@redhat.com>
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <11946337991750-git-send-email-gcosta@redhat.com> <11946338053158-git-send-email-gcosta@redhat.com> <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com> <11946338212915-git-send-email-gcosta@redhat.com> <11946338263902-git-send-email-gcosta@redhat.com> <1194633831882-git-send-email-gcosta@redhat.com> <11946338361369-git-send-email-gcosta@redhat.com> <11946338413283-git-send-email-gcosta@redhat.com> <11946338473652-git-send-email-gcosta@redhat.com> <1194633852469-git-send-email-gcosta@redhat.com> <1194633857930-git-send-email-gcosta@redhat.com> <11946338621966-git-send-email-gcosta@redhat.com> <11946338683305-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch turns the basic descriptor handling into native_
functions. It is basically write_idt, load_idt, write_gdt,
load_gdt, set_ldt, store_tr, load_tls, and the ones
for updating a single entry.

In the process of doing that, we change the definition of
load_LDT_nolock, and caller sites have to be patched. We
also patch call sites that now needs a typecast.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/asm-x86/desc.h           |   59 ++++++++++++
 include/asm-x86/desc_32.h        |   45 ---------
 include/asm-x86/desc_64.h        |  191 ++++++++++++++++++-------------------
 include/asm-x86/mmu_context_64.h |   23 ++++-
 4 files changed, 169 insertions(+), 149 deletions(-)

diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index 6065c50..276dc6e 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -1,5 +1,64 @@
+#ifndef _ASM_DESC_H_
+#define _ASM_DESC_H_
+
 #ifdef CONFIG_X86_32
 # include "desc_32.h"
 #else
 # include "desc_64.h"
 #endif
+
+#ifndef __ASSEMBLY__
+#define LDT_entry_a(info) \
+	((((info)->base_addr & 0x0000ffff) << 16) | ((info)->limit & 0x0ffff))
+
+#define LDT_entry_b(info) \
+	(((info)->base_addr & 0xff000000) | \
+	(((info)->base_addr & 0x00ff0000) >> 16) | \
+	((info)->limit & 0xf0000) | \
+	(((info)->read_exec_only ^ 1) << 9) | \
+	((info)->contents << 10) | \
+	(((info)->seg_not_present ^ 1) << 15) | \
+	((info)->seg_32bit << 22) | \
+	((info)->limit_in_pages << 23) | \
+	((info)->useable << 20) | \
+	0x7000)
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
+#define LDT_empty(info) _LDT_empty(info)
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
+#endif /* __ASSEMBLY__ */
+
+#endif
diff --git a/include/asm-x86/desc_32.h b/include/asm-x86/desc_32.h
index c547403..84bb843 100644
--- a/include/asm-x86/desc_32.h
+++ b/include/asm-x86/desc_32.h
@@ -162,51 +162,6 @@ static inline void __set_tss_desc(unsigned int cpu, unsigned int entry, const vo
 
 #define set_tss_desc(cpu,addr) __set_tss_desc(cpu, GDT_ENTRY_TSS, addr)
 
-#define LDT_entry_a(info) \
-	((((info)->base_addr & 0x0000ffff) << 16) | ((info)->limit & 0x0ffff))
-
-#define LDT_entry_b(info) \
-	(((info)->base_addr & 0xff000000) | \
-	(((info)->base_addr & 0x00ff0000) >> 16) | \
-	((info)->limit & 0xf0000) | \
-	(((info)->read_exec_only ^ 1) << 9) | \
-	((info)->contents << 10) | \
-	(((info)->seg_not_present ^ 1) << 15) | \
-	((info)->seg_32bit << 22) | \
-	((info)->limit_in_pages << 23) | \
-	((info)->useable << 20) | \
-	0x7000)
-
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
diff --git a/include/asm-x86/desc_64.h b/include/asm-x86/desc_64.h
index 7d48df7..d12cd07 100644
--- a/include/asm-x86/desc_64.h
+++ b/include/asm-x86/desc_64.h
@@ -16,11 +16,12 @@
 
 extern struct desc_struct cpu_gdt_table[GDT_ENTRIES];
 
-#define load_TR_desc() asm volatile("ltr %w0"::"r" (GDT_ENTRY_TSS*8))
-#define load_LDT_desc() asm volatile("lldt %w0"::"r" (GDT_ENTRY_LDT*8))
-#define clear_LDT()  asm volatile("lldt %w0"::"r" (0))
+static inline void native_load_tr_desc(void)
+{
+	asm volatile("ltr %w0"::"r" (GDT_ENTRY_TSS*8));
+}
 
-static inline unsigned long __store_tr(void)
+static inline unsigned long native_store_tr(void)
 {
        unsigned long tr;
 
@@ -28,8 +29,6 @@ static inline unsigned long __store_tr(void)
        return tr;
 }
 
-#define store_tr(tr) (tr) = __store_tr()
-
 /*
  * This is the ldt that every process will get unless we need
  * something other than this.
@@ -38,79 +37,54 @@ extern struct desc_struct default_ldt[];
 extern struct gate_struct idt_table[];
 extern struct desc_ptr cpu_gdt_descr[];
 
-static inline void write_ldt_entry(struct desc_struct *ldt,
-				   int entry, u32 entry_low, u32 entry_high)
+static inline void write_dt_entry(struct desc_struct *dt, int entry,
+				  u32 entry_low, u32 entry_high)
 {
-	__u32 *lp = (__u32 *)((entry << 3) + (char *)ldt);
-
-	lp[0] = entry_low;
-	lp[1] = entry_high;
+	((struct n_desc_struct *)dt)[entry].a = entry_low;
+	((struct n_desc_struct *)dt)[entry].b = entry_high;
 }
 
 /* the cpu gdt accessor */
 #define cpu_gdt(_cpu) ((struct desc_struct *)cpu_gdt_descr[_cpu].address)
 
-static inline void load_gdt(const struct desc_ptr *ptr)
+static inline void native_load_gdt(const struct desc_ptr *ptr)
 {
 	asm volatile("lgdt %w0"::"m" (*ptr));
 }
 
-static inline void store_gdt(struct desc_ptr *ptr)
+static inline void native_store_gdt(struct desc_ptr *ptr)
 {
        asm("sgdt %w0":"=m" (*ptr));
 }
 
-static inline void _set_gate(void *adr, unsigned type, unsigned long func,
-			     unsigned dpl, unsigned ist)
+static inline void native_write_idt_entry(void *adr, struct gate_struct *s)
 {
-	struct gate_struct s;
-
-	s.offset_low = PTR_LOW(func);
-	s.segment = __KERNEL_CS;
-	s.ist = ist;
-	s.p = 1;
-	s.dpl = dpl;
-	s.zero0 = 0;
-	s.zero1 = 0;
-	s.type = type;
-	s.offset_middle = PTR_MIDDLE(func);
-	s.offset_high = PTR_HIGH(func);
-	/*
-	 * does not need to be atomic because it is only done once at
-	 * setup time
-	 */
-	memcpy(adr, &s, 16);
+	/* does not need to be atomic because
+	 * it is only done once at setup time */
+	memcpy(adr, s, 16);
 }
 
-static inline void set_intr_gate(int nr, void *func)
+static inline void native_write_gdt_entry(void *ptr, void *entry,
+					  unsigned type, unsigned size)
 {
-	BUG_ON((unsigned)nr > 0xFF);
-	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 0, 0);
-}
-
-static inline void set_intr_gate_ist(int nr, void *func, unsigned ist)
-{
-	BUG_ON((unsigned)nr > 0xFF);
-	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 0, ist);
-}
-
-static inline void set_system_gate(int nr, void *func)
-{
-	BUG_ON((unsigned)nr > 0xFF);
-	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 3, 0);
+	memcpy(ptr, entry, size);
 }
 
-static inline void set_system_gate_ist(int nr, void *func, unsigned ist)
-{
-	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 3, ist);
-}
+/*
+ * This one unfortunately can't go with the others, in below, because it has
+ * an user anxious for its definition: set_tssldt_descriptor
+ */
+#ifndef CONFIG_PARAVIRT
+#define write_gdt_entry(_ptr, _e, _type, _size) \
+		native_write_gdt_entry((_ptr), (_e), (_type), (_size))
+#endif
 
-static inline void load_idt(const struct desc_ptr *ptr)
+static inline void native_load_idt(const struct desc_ptr *ptr)
 {
 	asm volatile("lidt %w0"::"m" (*ptr));
 }
 
-static inline void store_idt(struct desc_ptr *dtr)
+static inline void native_store_idt(struct desc_ptr *dtr)
 {
        asm("sidt %w0":"=m" (*dtr));
 }
@@ -129,7 +103,7 @@ static inline void set_tssldt_descriptor(void *ptr, unsigned long tss,
 	d.limit1 = (size >> 16) & 0xF;
 	d.base2 = (PTR_MIDDLE(tss) >> 8) & 0xFF;
 	d.base3 = PTR_HIGH(tss);
-	memcpy(ptr, &d, 16);
+	write_gdt_entry(ptr, &d, type, 16);
 }
 
 static inline void set_tss_desc(unsigned cpu, void *addr)
@@ -152,35 +126,7 @@ static inline void set_ldt_desc(unsigned cpu, void *addr, int size)
 			      DESC_LDT, size * 8 - 1);
 }
 
-#define LDT_entry_a(info) \
-	((((info)->base_addr & 0x0000ffff) << 16) | ((info)->limit & 0x0ffff))
-/* Don't allow setting of the lm bit. It is useless anyways because
-   64bit system calls require __USER_CS. */
-#define LDT_entry_b(info) \
-	(((info)->base_addr & 0xff000000) | \
-	(((info)->base_addr & 0x00ff0000) >> 16) | \
-	((info)->limit & 0xf0000) | \
-	(((info)->read_exec_only ^ 1) << 9) | \
-	((info)->contents << 10) | \
-	(((info)->seg_not_present ^ 1) << 15) | \
-	((info)->seg_32bit << 22) | \
-	((info)->limit_in_pages << 23) | \
-	((info)->useable << 20) | \
-	/* ((info)->lm << 21) | */ \
-	0x7000)
-
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
-static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
+static inline void native_load_tls(struct thread_struct *t, unsigned int cpu)
 {
 	unsigned int i;
 	u64 *gdt = (u64 *)(cpu_gdt(cpu) + GDT_ENTRY_TLS_MIN);
@@ -189,28 +135,77 @@ static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
 		gdt[i] = t->tls_array[i];
 }
 
-/*
- * load one particular LDT into the current CPU
- */
-static inline void load_LDT_nolock(mm_context_t *pc, int cpu)
+static inline void native_set_ldt(const void *addr,
+				  unsigned int entries)
 {
-	int count = pc->size;
+	if (likely(entries == 0))
+		__asm__ __volatile__ ("lldt %w0" :: "r" (0));
+	else {
+		unsigned cpu = smp_processor_id();
 
-	if (likely(!count)) {
-		clear_LDT();
-		return;
+		set_tssldt_descriptor(&cpu_gdt(cpu)[GDT_ENTRY_LDT],
+					(unsigned long)addr, DESC_LDT,
+					entries * 8 - 1);
+		__asm__ __volatile__ ("lldt %w0"::"r" (GDT_ENTRY_LDT*8));
 	}
+}
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define load_TR_desc()	native_load_tr_desc()
+#define load_gdt(ptr)	native_load_gdt(ptr)
+#define load_idt(ptr)	native_load_idt(ptr)
+#define load_TLS(t, cpu) native_load_tls(t, cpu)
+#define set_ldt(addr, entries)	native_set_ldt(addr, entries)
+#define store_tr(tr) (tr) = native_store_tr()
+#define store_gdt(ptr)	native_store_gdt(ptr)
+#define store_idt(ptr)	native_store_idt(ptr)
+
+#define write_idt_entry(_adr, _s) native_write_idt_entry((_adr), (_s))
+#define write_ldt_entry(_ldt, _number, _entry1, _entry2) \
+		write_dt_entry((_ldt), (_number), (_entry1), (_entry2))
+#endif
+
+static inline void _set_gate(void *adr, unsigned type, unsigned long func,
+			     unsigned dpl, unsigned ist)
+{
+	struct gate_struct s;
+
+	s.offset_low = PTR_LOW(func);
+	s.segment = __KERNEL_CS;
+	s.ist = ist;
+	s.p = 1;
+	s.dpl = dpl;
+	s.zero0 = 0;
+	s.zero1 = 0;
+	s.type = type;
+	s.offset_middle = PTR_MIDDLE(func);
+	s.offset_high = PTR_HIGH(func);
+	write_idt_entry(adr, &s);
+}
+
+static inline void set_intr_gate(int nr, void *func)
+{
+	BUG_ON((unsigned)nr > 0xFF);
+	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 0, 0);
+}
 
-	set_ldt_desc(cpu, pc->ldt, count);
-	load_LDT_desc();
+static inline void set_intr_gate_ist(int nr, void *func, unsigned ist)
+{
+	BUG_ON((unsigned)nr > 0xFF);
+	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 0, ist);
 }
 
-static inline void load_LDT(mm_context_t *pc)
+static inline void set_system_gate(int nr, void *func)
 {
-	int cpu = get_cpu();
+	BUG_ON((unsigned)nr > 0xFF);
+	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 3, 0);
+}
 
-	load_LDT_nolock(pc, cpu);
-	put_cpu();
+static inline void set_system_gate_ist(int nr, void *func, unsigned ist)
+{
+	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 3, ist);
 }
 
 extern struct desc_ptr idt_descr;
diff --git a/include/asm-x86/mmu_context_64.h b/include/asm-x86/mmu_context_64.h
index 29f95c3..85b7fb8 100644
--- a/include/asm-x86/mmu_context_64.h
+++ b/include/asm-x86/mmu_context_64.h
@@ -7,7 +7,16 @@
 #include <asm/pda.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
 #include <asm-generic/mm_hooks.h>
+static inline void paravirt_activate_mm(struct mm_struct *prev,
+					struct mm_struct *next)
+{
+}
+#endif /* CONFIG_PARAVIRT */
 
 /*
  * possibly do the LDT unload here?
@@ -25,7 +34,7 @@ static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 
 static inline void load_cr3(pgd_t *pgd)
 {
-	asm volatile("movq %0,%%cr3" :: "r" (__pa(pgd)) : "memory");
+	write_cr3(__pa(pgd));
 }
 
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next, 
@@ -43,7 +52,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		load_cr3(next->pgd);
 
 		if (unlikely(next->context.ldt != prev->context.ldt)) 
-			load_LDT_nolock(&next->context, cpu);
+			load_LDT_nolock(&next->context);
 	}
 #ifdef CONFIG_SMP
 	else {
@@ -56,7 +65,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 			 * to make sure to use no freed page tables.
 			 */
 			load_cr3(next->pgd);
-			load_LDT_nolock(&next->context, cpu);
+			load_LDT_nolock(&next->context);
 		}
 	}
 #endif
@@ -67,8 +76,10 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	asm volatile("movl %0,%%fs"::"r"(0));  \
 } while(0)
 
-#define activate_mm(prev, next) \
-	switch_mm((prev),(next),NULL)
-
+#define activate_mm(prev, next) 		\
+do {						\
+	paravirt_activate_mm(prev, next);	\
+	switch_mm((prev), (next), NULL);	\
+} while (0)
 
 #endif
-- 
1.4.4.2

