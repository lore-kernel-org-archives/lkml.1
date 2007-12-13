Return-Path: <linux-kernel-owner+w=401wt.eu-S1763961AbXLMQqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763961AbXLMQqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762120AbXLMQoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:44:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761992AbXLMQoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:44:05 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 17/19] unify paravirt pieces of descriptor handling
Date: Thu, 13 Dec 2007 11:58:05 -0200
Message-Id: <1197554399402-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11975543942657-git-send-email-gcosta@redhat.com>
References: <11975113122984-git-send-email-gcosta@redhat.com> <1197554287294-git-send-email-gcosta@redhat.com> <11975542952896-git-send-email-gcosta@redhat.com> <11975543001070-git-send-email-gcosta@redhat.com> <1197554307167-git-send-email-gcosta@redhat.com> <11975543173017-git-send-email-gcosta@redhat.com> <11975543382698-git-send-email-gcosta@redhat.com> <11975543442801-git-send-email-gcosta@redhat.com> <11975543492215-git-send-email-gcosta@redhat.com> <11975543543850-git-send-email-gcosta@redhat.com> <11975543592701-git-send-email-gcosta@redhat.com> <11975543641360-git-send-email-gcosta@redhat.com> <11975543691134-git-send-email-gcosta@redhat.com> <11975543742848-git-send-email-gcosta@redhat.com> <11975543792334-git-send-email-gcosta@redhat.com> <11975543843977-git-send-email-gcosta@redhat.com> <11975543892403-git-send-email-gcosta@redhat.com> <11975543942657-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the types used to access descriptors in x86_64 and i386
now being the same, the code that effectively handles them can
now be easily shared. This patch moves the paravirt part of
desc_32.h into desc.h, and then, we get paravirt support in x86_64
for free.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/desc.h      |  169 +++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/desc_32.h   |  130 ---------------------------------
 include/asm-x86/desc_64.h   |  104 +++------------------------
 include/asm-x86/desc_defs.h |    6 +-
 4 files changed, 183 insertions(+), 226 deletions(-)

Index: linux-2.6-x86/include/asm-x86/desc_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc_32.h
+++ linux-2.6-x86/include/asm-x86/desc_32.h
@@ -8,31 +8,10 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/preempt.h>
-#include <linux/smp.h>
 #include <linux/percpu.h>
 
-struct gdt_page
-{
-	struct desc_struct gdt[GDT_ENTRIES];
-} __attribute__((aligned(PAGE_SIZE)));
-DECLARE_PER_CPU(struct gdt_page, gdt_page);
-
-static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
-{
-	return per_cpu(gdt_page, cpu).gdt;
-}
-
 extern void set_intr_gate(unsigned int irq, void * addr);
 
-static inline void pack_descriptor(struct desc_struct *desc,
-	unsigned long base, unsigned long limit, unsigned char type, unsigned char flags)
-{
-	desc->a = ((base & 0xffff) << 16) | (limit & 0xffff);
-	desc->b = (base & 0xff000000) | ((base & 0xff0000) >> 16) |
-		(limit & 0x000f0000) | ((type & 0xff) << 8) | ((flags & 0xf) << 20);
-	desc->p = 1;
-}
-
 static inline void pack_gate(gate_desc *gate,
 	unsigned long base, unsigned short seg, unsigned char type, unsigned char flags)
 {
@@ -40,115 +19,6 @@ static inline void pack_gate(gate_desc *
 	gate->b = (base & 0xffff0000) | ((type & 0xff) << 8) | (flags & 0xff);
 }
 
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#define load_TR_desc() native_load_tr_desc()
-#define load_gdt(dtr) native_load_gdt(dtr)
-#define load_idt(dtr) native_load_idt(dtr)
-#define load_tr(tr) __asm__ __volatile("ltr %0"::"m" (tr))
-#define load_ldt(ldt) __asm__ __volatile("lldt %0"::"m" (ldt))
-
-#define store_gdt(dtr) native_store_gdt(dtr)
-#define store_idt(dtr) native_store_idt(dtr)
-#define store_tr(tr) (tr = native_store_tr())
-#define store_ldt(ldt) __asm__ ("sldt %0":"=m" (ldt))
-
-#define load_TLS(t, cpu) native_load_tls(t, cpu)
-#define set_ldt native_set_ldt
-
-#define write_ldt_entry(dt, entry, desc) \
-				native_write_ldt_entry(dt, entry, desc)
-#define write_gdt_entry(dt, entry, desc, type) \
-				native_write_gdt_entry(dt, entry, desc, type)
-#define write_idt_entry(dt, entry, g) native_write_idt_entry(dt, entry, g)
-#endif
-
-static inline void native_write_ldt_entry(struct desc_struct *ldt, int entry,
-					  const void *desc)
-{
-	memcpy(&ldt[entry], desc, sizeof(struct desc_struct));
-}
-
-static inline void native_write_idt_entry(gate_desc *idt, int entry,
-					  const gate_desc *gate)
-{
-	memcpy(&idt[entry], gate, sizeof(*gate));
-}
-
-static inline void native_write_gdt_entry(struct desc_struct *gdt, int entry,
-					  const void *desc, int type)
-{
-	memcpy(&gdt[entry], desc, sizeof(struct desc_struct));
-}
-
-static inline void write_dt_entry(struct desc_struct *dt,
-				  int entry, u32 entry_low, u32 entry_high)
-{
-	dt[entry].a = entry_low;
-	dt[entry].b = entry_high;
-}
-
-
-static inline void native_set_ldt(const void *addr, unsigned int entries)
-{
-	if (likely(entries == 0))
-		__asm__ __volatile__("lldt %w0"::"q" (0));
-	else {
-		unsigned cpu = smp_processor_id();
-		ldt_desc ldt;
-
-		pack_descriptor(&ldt, (unsigned long)addr,
-				entries * sizeof(struct desc_struct) - 1,
-				DESC_LDT, 0);
-		write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_LDT,
-				&ldt, DESC_LDT);
-		__asm__ __volatile__("lldt %w0"::"q" (GDT_ENTRY_LDT*8));
-	}
-}
-
-
-static inline void native_load_tr_desc(void)
-{
-	asm volatile("ltr %w0"::"q" (GDT_ENTRY_TSS*8));
-}
-
-static inline void native_load_gdt(const struct desc_ptr *dtr)
-{
-	asm volatile("lgdt %0"::"m" (*dtr));
-}
-
-static inline void native_load_idt(const struct desc_ptr *dtr)
-{
-	asm volatile("lidt %0"::"m" (*dtr));
-}
-
-static inline void native_store_gdt(struct desc_ptr *dtr)
-{
-	asm ("sgdt %0":"=m" (*dtr));
-}
-
-static inline void native_store_idt(struct desc_ptr *dtr)
-{
-	asm ("sidt %0":"=m" (*dtr));
-}
-
-static inline unsigned long native_store_tr(void)
-{
-	unsigned long tr;
-	asm ("str %0":"=r" (tr));
-	return tr;
-}
-
-static inline void native_load_tls(struct thread_struct *t, unsigned int cpu)
-{
-	unsigned int i;
-	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
-
-	for (i = 0; i < GDT_ENTRY_TLS_ENTRIES; i++)
-		gdt[GDT_ENTRY_TLS_MIN + i] = t->tls_array[i];
-}
-
 static inline void _set_gate(int gate, unsigned int type, void *addr, unsigned short seg)
 {
 	gate_desc g;
Index: linux-2.6-x86/include/asm-x86/desc_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc_64.h
+++ linux-2.6-x86/include/asm-x86/desc_64.h
@@ -8,47 +8,10 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/string.h>
-#include <linux/smp.h>
 
 #include <asm/segment.h>
 
-extern struct desc_struct cpu_gdt_table[GDT_ENTRIES];
-
-#define load_TR_desc() asm volatile("ltr %w0"::"r" (GDT_ENTRY_TSS*8))
-#define load_LDT_desc() asm volatile("lldt %w0"::"r" (GDT_ENTRY_LDT*8))
-
-static inline unsigned long __store_tr(void)
-{
-       unsigned long tr;
-
-       asm volatile ("str %w0":"=r" (tr));
-       return tr;
-}
-
-#define store_tr(tr) (tr) = __store_tr()
-
-extern struct desc_ptr cpu_gdt_descr[];
-
-static inline void write_ldt_entry(struct desc_struct *ldt,
-				   int entry, void *ptr)
-{
-	memcpy(&ldt[entry], ptr, 8);
-}
-
-/* the cpu gdt accessor */
-#define get_cpu_gdt_table(x) ((struct desc_struct *)cpu_gdt_descr[x].address)
-
-static inline void load_gdt(const struct desc_ptr *ptr)
-{
-	asm volatile("lgdt %w0"::"m" (*ptr));
-}
-
-static inline void store_gdt(struct desc_ptr *ptr)
-{
-       asm("sgdt %w0":"=m" (*ptr));
-}
-
-static inline void _set_gate(void *adr, unsigned type, unsigned long func,
+static inline void _set_gate(int gate, unsigned type, unsigned long func,
 			     unsigned dpl, unsigned ist)
 {
 	gate_desc s;
@@ -67,61 +30,37 @@ static inline void _set_gate(void *adr, 
 	 * does not need to be atomic because it is only done once at
 	 * setup time
 	 */
-	memcpy(adr, &s, 16);
+	write_idt_entry(idt_table, gate, &s);
 }
 
 static inline void set_intr_gate(int nr, void *func)
 {
 	BUG_ON((unsigned)nr > 0xFF);
-	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 0, 0);
+	_set_gate(nr, GATE_INTERRUPT, (unsigned long) func, 0, 0);
 }
 
 static inline void set_intr_gate_ist(int nr, void *func, unsigned ist)
 {
 	BUG_ON((unsigned)nr > 0xFF);
-	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 0, ist);
+	_set_gate(nr, GATE_INTERRUPT, (unsigned long) func, 0, ist);
 }
 
 static inline void set_system_gate(int nr, void *func)
 {
 	BUG_ON((unsigned)nr > 0xFF);
-	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 3, 0);
+	_set_gate(nr, GATE_INTERRUPT, (unsigned long) func, 3, 0);
 }
 
 static inline void set_system_gate_ist(int nr, void *func, unsigned ist)
 {
-	_set_gate(&idt_table[nr], GATE_INTERRUPT, (unsigned long) func, 3, ist);
-}
-
-static inline void load_idt(const struct desc_ptr *ptr)
-{
-	asm volatile("lidt %w0"::"m" (*ptr));
-}
-
-static inline void store_idt(struct desc_ptr *dtr)
-{
-       asm("sidt %w0":"=m" (*dtr));
-}
-
-static inline void set_tssldt_descriptor(void *ptr, unsigned long tss,
-					 unsigned type, unsigned size)
-{
-	struct ldttss_desc64 d;
-
-	memset(&d, 0, sizeof(d));
-	d.limit0 = size & 0xFFFF;
-	d.base0 = PTR_LOW(tss);
-	d.base1 = PTR_MIDDLE(tss) & 0xFF;
-	d.type = type;
-	d.p = 1;
-	d.limit1 = (size >> 16) & 0xF;
-	d.base2 = (PTR_MIDDLE(tss) >> 8) & 0xFF;
-	d.base3 = PTR_HIGH(tss);
-	memcpy(ptr, &d, 16);
+	_set_gate(nr, GATE_INTERRUPT, (unsigned long) func, 3, ist);
 }
 
 static inline void set_tss_desc(unsigned cpu, void *addr)
 {
+	struct desc_struct *d = get_cpu_gdt_table(cpu);
+	tss_desc tss;
+
 	/*
 	 * sizeof(unsigned long) coming from an extra "long" at the end
 	 * of the iobitmap. See tss_struct definition in processor.h
@@ -129,31 +68,10 @@ static inline void set_tss_desc(unsigned
 	 * -1? seg base+limit should be pointing to the address of the
 	 * last valid byte
 	 */
-	set_tssldt_descriptor(&get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS],
+	set_tssldt_descriptor(&tss,
 		(unsigned long)addr, DESC_TSS,
 		IO_BITMAP_OFFSET + IO_BITMAP_BYTES + sizeof(unsigned long) - 1);
-}
-
-static inline void set_ldt(void *addr, int entries)
-{
-	if (likely(entries == 0))
-		__asm__ __volatile__("lldt %w0"::"q" (0));
-	else {
-		unsigned cpu = smp_processor_id();
-
-		set_tssldt_descriptor(&get_cpu_gdt_table(cpu)[GDT_ENTRY_LDT],
-			     (unsigned long)addr, DESC_LDT, entries * 8 - 1);
-		__asm__ __volatile__("lldt %w0"::"q" (GDT_ENTRY_LDT*8));
-	}
-}
-
-static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
-{
-	unsigned int i;
-	struct desc_struct *gdt = (get_cpu_gdt_table(cpu) + GDT_ENTRY_TLS_MIN);
-
-	for (i = 0; i < GDT_ENTRY_TLS_ENTRIES; i++)
-		gdt[i] = t->tls_array[i];
+	write_gdt_entry(d, GDT_ENTRY_TSS, &tss, DESC_TSS);
 }
 
 #endif /* !__ASSEMBLY__ */
Index: linux-2.6-x86/include/asm-x86/desc_defs.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc_defs.h
+++ linux-2.6-x86/include/asm-x86/desc_defs.h
@@ -48,9 +48,9 @@ struct gate_struct64 {
 	u32 zero1;
 } __attribute__((packed));
 
-#define PTR_LOW(x) ((unsigned long)(x) & 0xFFFF)
-#define PTR_MIDDLE(x) (((unsigned long)(x) >> 16) & 0xFFFF)
-#define PTR_HIGH(x) ((unsigned long)(x) >> 32)
+#define PTR_LOW(x) ((unsigned long long)(x) & 0xFFFF)
+#define PTR_MIDDLE(x) (((unsigned long long)(x) >> 16) & 0xFFFF)
+#define PTR_HIGH(x) ((unsigned long long)(x) >> 32)
 
 enum {
 	DESC_TSS = 0x9,
Index: linux-2.6-x86/include/asm-x86/desc.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc.h
+++ linux-2.6-x86/include/asm-x86/desc.h
@@ -5,6 +5,7 @@
 #include <asm/desc_defs.h>
 #include <asm/ldt.h>
 #include <asm/mmu.h>
+#include <linux/smp.h>
 
 static inline void fill_ldt(struct desc_struct *desc, struct user_desc *info)
 {
@@ -27,6 +28,166 @@ static inline void fill_ldt(struct desc_
 extern struct desc_ptr idt_descr;
 extern gate_desc idt_table[];
 
+#ifdef CONFIG_X86_64
+extern struct desc_struct cpu_gdt_table[GDT_ENTRIES];
+extern struct desc_ptr cpu_gdt_descr[];
+/* the cpu gdt accessor */
+#define get_cpu_gdt_table(x) ((struct desc_struct *)cpu_gdt_descr[x].address)
+#else
+struct gdt_page {
+	struct desc_struct gdt[GDT_ENTRIES];
+} __attribute__((aligned(PAGE_SIZE)));
+DECLARE_PER_CPU(struct gdt_page, gdt_page);
+
+static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
+{
+	return per_cpu(gdt_page, cpu).gdt;
+}
+#endif
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define load_TR_desc() native_load_tr_desc()
+#define load_gdt(dtr) native_load_gdt(dtr)
+#define load_idt(dtr) native_load_idt(dtr)
+#define load_tr(tr) __asm__ __volatile("ltr %0"::"m" (tr))
+#define load_ldt(ldt) __asm__ __volatile("lldt %0"::"m" (ldt))
+
+#define store_gdt(dtr) native_store_gdt(dtr)
+#define store_idt(dtr) native_store_idt(dtr)
+#define store_tr(tr) (tr = native_store_tr())
+#define store_ldt(ldt) __asm__ ("sldt %0":"=m" (ldt))
+
+#define load_TLS(t, cpu) native_load_tls(t, cpu)
+#define set_ldt native_set_ldt
+
+#define write_ldt_entry(dt, entry, desc) \
+				native_write_ldt_entry(dt, entry, desc)
+#define write_gdt_entry(dt, entry, desc, type) \
+				native_write_gdt_entry(dt, entry, desc, type)
+#define write_idt_entry(dt, entry, g) native_write_idt_entry(dt, entry, g)
+#endif
+
+static inline void native_write_idt_entry(gate_desc *idt, int entry,
+					  const gate_desc *gate)
+{
+	memcpy(&idt[entry], gate, sizeof(*gate));
+}
+
+static inline void native_write_ldt_entry(struct desc_struct *ldt, int entry,
+					  const void *desc)
+{
+	memcpy(&ldt[entry], desc, 8);
+}
+
+static inline void native_write_gdt_entry(struct desc_struct *gdt, int entry,
+					  const void *desc, int type)
+{
+	unsigned int size;
+	switch (type) {
+	case DESC_TSS:
+		size = sizeof(tss_desc);
+		break;
+	case DESC_LDT:
+		size = sizeof(ldt_desc);
+		break;
+	default:
+		size = sizeof(struct desc_struct);
+		break;
+	}
+	memcpy(&gdt[entry], desc, size);
+}
+
+static inline void pack_descriptor(struct desc_struct *desc, unsigned long base,
+				   unsigned long limit, unsigned char type,
+				   unsigned char flags)
+{
+	desc->a = ((base & 0xffff) << 16) | (limit & 0xffff);
+	desc->b = (base & 0xff000000) | ((base & 0xff0000) >> 16) |
+		  (limit & 0x000f0000) | ((type & 0xff) << 8) |
+		  ((flags & 0xf) << 20);
+	desc->p = 1;
+}
+
+
+static inline void set_tssldt_descriptor(void *d, unsigned long addr,
+					 unsigned type, unsigned size)
+{
+#ifdef CONFIG_X86_64
+	struct ldttss_desc64 *desc = d;
+	memset(desc, 0, sizeof(*desc));
+	desc->limit0 = size & 0xFFFF;
+	desc->base0 = PTR_LOW(addr);
+	desc->base1 = PTR_MIDDLE(addr) & 0xFF;
+	desc->type = type;
+	desc->p = 1;
+	desc->limit1 = (size >> 16) & 0xF;
+	desc->base2 = (PTR_MIDDLE(addr) >> 8) & 0xFF;
+	desc->base3 = PTR_HIGH(addr);
+#else
+
+	pack_descriptor((struct desc_struct *)d, addr, size, 0x80 | type, 0);
+#endif
+}
+
+static inline void native_set_ldt(const void *addr, unsigned int entries)
+{
+	if (likely(entries == 0))
+		__asm__ __volatile__("lldt %w0"::"q" (0));
+	else {
+		unsigned cpu = smp_processor_id();
+		ldt_desc ldt;
+
+		set_tssldt_descriptor(&ldt, (unsigned long)addr,
+				      DESC_LDT, entries * sizeof(ldt) - 1);
+		write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_LDT,
+				&ldt, DESC_LDT);
+		__asm__ __volatile__("lldt %w0"::"q" (GDT_ENTRY_LDT*8));
+	}
+}
+
+static inline void native_load_tr_desc(void)
+{
+	asm volatile("ltr %w0"::"q" (GDT_ENTRY_TSS*8));
+}
+
+static inline void native_load_gdt(const struct desc_ptr *dtr)
+{
+	asm volatile("lgdt %0"::"m" (*dtr));
+}
+
+static inline void native_load_idt(const struct desc_ptr *dtr)
+{
+	asm volatile("lidt %0"::"m" (*dtr));
+}
+
+static inline void native_store_gdt(struct desc_ptr *dtr)
+{
+	asm volatile("sgdt %0":"=m" (*dtr));
+}
+
+static inline void native_store_idt(struct desc_ptr *dtr)
+{
+	asm volatile("sidt %0":"=m" (*dtr));
+}
+
+static inline unsigned long native_store_tr(void)
+{
+	unsigned long tr;
+	asm volatile("str %0":"=r" (tr));
+	return tr;
+}
+
+static inline void native_load_tls(struct thread_struct *t, unsigned int cpu)
+{
+	unsigned int i;
+	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
+
+	for (i = 0; i < GDT_ENTRY_TLS_ENTRIES; i++)
+		gdt[GDT_ENTRY_TLS_MIN + i] = t->tls_array[i];
+}
+
 #ifdef CONFIG_X86_32
 # include "desc_32.h"
 #else
