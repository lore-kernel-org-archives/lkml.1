Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbXLFTG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbXLFTG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbXLFTCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:02:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbXLFTCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:02:17 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 17/19] unify paravirt pieces of descriptor handling
Date: Thu,  6 Dec 2007 14:16:38 -0200
Message-Id: <11969578862882-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11969578811685-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11969578092869-git-send-email-gcosta@redhat.com> <11969578142514-git-send-email-gcosta@redhat.com> <11969578193406-git-send-email-gcosta@redhat.com> <11969578242463-git-send-email-gcosta@redhat.com> <11969578292944-git-send-email-gcosta@redhat.com> <11969578343061-git-send-email-gcosta@redhat.com> <11969578383955-git-send-email-gcosta@redhat.com> <11969578431489-git-send-email-gcosta@redhat.com> <11969578483552-git-send-email-gcosta@redhat.com> <11969578534185-git-send-email-gcosta@redhat.com> <11969578581299-git-send-email-gcosta@redhat.com> <1196957863723-git-send-email-gcosta@redhat.com> <11969578671479-git-send-email-gcosta@redhat.com> <119695787262-git-send-email-gcosta@redhat.com> <11969578773678-git-send-email-gcosta@redhat.com> <11969578811685-git-send-email-gcosta@redhat.com>
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
 include/asm-x86/desc.h      |  155 +++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/desc_32.h   |  120 ---------------------------------
 include/asm-x86/desc_64.h   |  104 +++--------------------------
 include/asm-x86/desc_defs.h |    6 +-
 4 files changed, 169 insertions(+), 216 deletions(-)

diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index 3480cb1..1773dd2 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -5,11 +5,166 @@
 
 #ifndef __ASSEMBLY__
 #include <asm/mmu.h>
+#include <linux/smp.h>
 
 extern struct desc_ptr idt_descr;
 extern gate_desc idt_table[];
 
+#ifdef CONFIG_X86_64
+extern struct desc_struct cpu_gdt_table[GDT_ENTRIES];
+extern struct desc_ptr cpu_gdt_descr[];
+/* the cpu gdt accessor */
+#define get_cpu_gdt_table(_cpu) ((struct desc_struct *)cpu_gdt_descr[_cpu].address)
+#else
+struct gdt_page
+{
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
+#define write_gdt_entry(dt, entry, desc, size) \
+				native_write_gdt_entry(dt, entry, desc, size)
+#define write_idt_entry(dt, entry, g) native_write_idt_entry(dt, entry, g)
+#endif
+
+static inline void native_write_idt_entry(gate_desc *idt, int entry, gate_desc *gate)
+{
+	memcpy(&idt[entry], gate, sizeof(*gate));
+}
+
+static inline void native_write_ldt_entry(struct desc_struct *ldt, int entry,
+					   void *desc)
+{
+	memcpy(&ldt[entry], desc, 8);
+}
+
+static inline void native_write_gdt_entry(struct desc_struct *gdt, int entry,
+					   void *desc, int size)
+{
+	memcpy(&gdt[entry], desc, size);
+}
+
+static inline void set_tssldt_descriptor(struct ldttss_desc64 *d, unsigned long tss,
+					 unsigned type, unsigned size)
+{
+	memset(d, 0, sizeof(*d));
+	d->limit0 = size & 0xFFFF;
+	d->base0 = PTR_LOW(tss);
+	d->base1 = PTR_MIDDLE(tss) & 0xFF;
+	d->type = type;
+	d->p = 1;
+	d->limit1 = (size >> 16) & 0xF;
+	d->base2 = (PTR_MIDDLE(tss) >> 8) & 0xFF;
+	d->base3 = PTR_HIGH(tss);
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
+}
+
+static inline void pack_ldt(ldt_desc *ldt, unsigned long addr,
+			   unsigned size)
+{
+
+#ifdef CONFIG_X86_64
+		set_tssldt_descriptor(ldt,
+			     addr, DESC_LDT, size);
+#else
+		pack_descriptor(ldt, (unsigned long)addr,
+				size,
+				0x80 | DESC_LDT, 0);
 #endif
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
+		pack_ldt(&ldt, (unsigned long)addr,
+				entries * sizeof(ldt) - 1);
+		write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_LDT,
+				&ldt, sizeof(ldt));
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
+	asm ("sgdt %0":"=m" (*dtr));
+}
+
+static inline void native_store_idt(struct desc_ptr *dtr)
+{
+	asm ("sidt %0":"=m" (*dtr));
+}
+
+static inline unsigned long native_store_tr(void)
+{
+	unsigned long tr;
+	asm ("str %0":"=r" (tr));
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
+#endif /* __ASSEMBLY__ */
+
 
 #ifdef CONFIG_X86_32
 # include "desc_32.h"
diff --git a/include/asm-x86/desc_32.h b/include/asm-x86/desc_32.h
index 960ec77..e8f2bc2 100644
--- a/include/asm-x86/desc_32.h
+++ b/include/asm-x86/desc_32.h
@@ -8,30 +8,10 @@
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
-}
-
 static inline void pack_gate(gate_desc *gate,
 	unsigned long base, unsigned short seg, unsigned char type, unsigned char flags)
 {
@@ -39,106 +19,6 @@ static inline void pack_gate(gate_desc *gate,
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
-#define write_gdt_entry(dt, entry, desc, size) \
-				native_write_gdt_entry(dt, entry, desc, size)
-#define write_idt_entry(dt, entry, g) native_write_idt_entry(dt, entry, g)
-#endif
-
-static inline void native_write_ldt_entry(struct desc_struct *ldt, int entry,
-					  void *desc)
-{
-	memcpy(&ldt[entry], desc, size);
-}
-
-static inline void native_write_idt_entry(gate_desc *idt, int entry, gate_desc *gate)
-{
-	memcpy(&idt[entry], gate, sizeof(*gate));
-}
-
-static inline void native_write_gdt_entry(struct desc_struct *gdt, int entry,
-					   void *desc, int size)
-{
-	memcpy(&gdt[entry], desc, size);
-}
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
-				DESCTYPE_LDT, 0);
-		write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_LDT,
-				&ldt, sizeof(ldt));
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
diff --git a/include/asm-x86/desc_64.h b/include/asm-x86/desc_64.h
index 7fd9876..fd907da 100644
--- a/include/asm-x86/desc_64.h
+++ b/include/asm-x86/desc_64.h
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
-#define get_cpu_gdt_table(_cpu) ((struct desc_struct *)cpu_gdt_descr[_cpu].address)
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
@@ -67,61 +30,37 @@ static inline void _set_gate(void *adr, unsigned type, unsigned long func,
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
@@ -129,31 +68,10 @@ static inline void set_tss_desc(unsigned cpu, void *addr)
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
+	write_gdt_entry(d, GDT_ENTRY_TSS, &tss, sizeof(tss_desc));
 }
 
 #endif /* !__ASSEMBLY__ */
diff --git a/include/asm-x86/desc_defs.h b/include/asm-x86/desc_defs.h
index d4ae70d..69597f3 100644
--- a/include/asm-x86/desc_defs.h
+++ b/include/asm-x86/desc_defs.h
@@ -51,9 +51,9 @@ struct gate_struct64 {
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
-- 
1.4.4.2

