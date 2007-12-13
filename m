Return-Path: <linux-kernel-owner+w=401wt.eu-S1763577AbXLMQqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763577AbXLMQqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762770AbXLMQoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:44:03 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763202AbXLMQoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:44:00 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 18/19] move _set_gate and its users to a common location
Date: Thu, 13 Dec 2007 11:58:06 -0200
Message-Id: <1197554404337-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1197554399402-git-send-email-gcosta@redhat.com>
References: <11975113122984-git-send-email-gcosta@redhat.com> <1197554287294-git-send-email-gcosta@redhat.com> <11975542952896-git-send-email-gcosta@redhat.com> <11975543001070-git-send-email-gcosta@redhat.com> <1197554307167-git-send-email-gcosta@redhat.com> <11975543173017-git-send-email-gcosta@redhat.com> <11975543382698-git-send-email-gcosta@redhat.com> <11975543442801-git-send-email-gcosta@redhat.com> <11975543492215-git-send-email-gcosta@redhat.com> <11975543543850-git-send-email-gcosta@redhat.com> <11975543592701-git-send-email-gcosta@redhat.com> <11975543641360-git-send-email-gcosta@redhat.com> <11975543691134-git-send-email-gcosta@redhat.com> <11975543742848-git-send-email-gcosta@redhat.com> <11975543792334-git-send-email-gcosta@redhat.com> <11975543843977-git-send-email-gcosta@redhat.com> <11975543892403-git-send-email-gcosta@redhat.com> <11975543942657-git-send-email-gcosta@redhat.com> <1197554399402-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves _set_gate and its users to desc.h. We can now
use common code for x86_64 and i386.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/traps_32.c  |   34 ----------------
 include/asm-x86/desc.h      |   88 +++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/desc_32.h   |   16 --------
 include/asm-x86/desc_64.h   |   45 ----------------------
 include/asm-x86/desc_defs.h |    5 +--
 5 files changed, 89 insertions(+), 99 deletions(-)

Index: linux-2.6-x86/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/traps_32.c
+++ linux-2.6-x86/arch/x86/kernel/traps_32.c
@@ -1102,40 +1102,6 @@ asmlinkage void math_emulate(long arg)
 
 #endif /* CONFIG_MATH_EMULATION */
 
-/*
- * This needs to use 'idt_table' rather than 'idt', and
- * thus use the _nonmapped_ version of the IDT, as the
- * Pentium F0 0F bugfix can have resulted in the mapped
- * IDT being write-protected.
- */
-void set_intr_gate(unsigned int n, void *addr)
-{
-	_set_gate(n, DESCTYPE_INT, addr, __KERNEL_CS);
-}
-
-/*
- * This routine sets up an interrupt gate at directory privilege level 3.
- */
-static inline void set_system_intr_gate(unsigned int n, void *addr)
-{
-	_set_gate(n, DESCTYPE_INT | DESCTYPE_DPL3, addr, __KERNEL_CS);
-}
-
-static void __init set_trap_gate(unsigned int n, void *addr)
-{
-	_set_gate(n, DESCTYPE_TRAP, addr, __KERNEL_CS);
-}
-
-static void __init set_system_gate(unsigned int n, void *addr)
-{
-	_set_gate(n, DESCTYPE_TRAP | DESCTYPE_DPL3, addr, __KERNEL_CS);
-}
-
-static void __init set_task_gate(unsigned int n, unsigned int gdt_entry)
-{
-	_set_gate(n, DESCTYPE_TASK, (void *)0, (gdt_entry<<3));
-}
-
 
 void __init trap_init(void)
 {
Index: linux-2.6-x86/include/asm-x86/desc.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc.h
+++ linux-2.6-x86/include/asm-x86/desc.h
@@ -33,6 +33,22 @@ extern struct desc_struct cpu_gdt_table[
 extern struct desc_ptr cpu_gdt_descr[];
 /* the cpu gdt accessor */
 #define get_cpu_gdt_table(x) ((struct desc_struct *)cpu_gdt_descr[x].address)
+
+static inline void pack_gate(gate_desc *gate, unsigned type, unsigned long func,
+			     unsigned dpl, unsigned ist, unsigned seg)
+{
+	gate->offset_low = PTR_LOW(func);
+	gate->segment = __KERNEL_CS;
+	gate->ist = ist;
+	gate->p = 1;
+	gate->dpl = dpl;
+	gate->zero0 = 0;
+	gate->zero1 = 0;
+	gate->type = type;
+	gate->offset_middle = PTR_MIDDLE(func);
+	gate->offset_high = PTR_HIGH(func);
+}
+
 #else
 struct gdt_page {
 	struct desc_struct gdt[GDT_ENTRIES];
@@ -43,6 +59,16 @@ static inline struct desc_struct *get_cp
 {
 	return per_cpu(gdt_page, cpu).gdt;
 }
+
+static inline void pack_gate(gate_desc *gate, unsigned char type,
+       unsigned long base, unsigned dpl, unsigned flags, unsigned short seg)
+
+{
+	gate->a = (seg << 16) | (base & 0xffff);
+	gate->b = (base & 0xffff0000) |
+		  (((0x80 | type | (dpl << 5)) & 0xff) << 8);
+}
+
 #endif
 
 #ifdef CONFIG_PARAVIRT
@@ -234,6 +260,68 @@ static inline unsigned long get_desc_bas
 {
 	return desc->base0 | ((desc->base1) << 16) | ((desc->base2) << 24);
 }
+static inline void _set_gate(int gate, unsigned type, void *addr,
+			      unsigned dpl, unsigned ist, unsigned seg)
+{
+	gate_desc s;
+	pack_gate(&s, type, (unsigned long)addr, dpl, ist, seg);
+	/*
+	 * does not need to be atomic because it is only done once at
+	 * setup time
+	 */
+	write_idt_entry(idt_table, gate, &s);
+}
+
+/*
+ * This needs to use 'idt_table' rather than 'idt', and
+ * thus use the _nonmapped_ version of the IDT, as the
+ * Pentium F0 0F bugfix can have resulted in the mapped
+ * IDT being write-protected.
+ */
+static inline void set_intr_gate(unsigned int n, void *addr)
+{
+	BUG_ON((unsigned)n > 0xFF);
+	_set_gate(n, GATE_INTERRUPT, addr, 0, 0, __KERNEL_CS);
+}
+
+/*
+ * This routine sets up an interrupt gate at directory privilege level 3.
+ */
+static inline void set_system_intr_gate(unsigned int n, void *addr)
+{
+	BUG_ON((unsigned)n > 0xFF);
+	_set_gate(n, GATE_INTERRUPT, addr, 0x3, 0, __KERNEL_CS);
+}
+
+static inline void set_trap_gate(unsigned int n, void *addr)
+{
+	BUG_ON((unsigned)n > 0xFF);
+	_set_gate(n, GATE_TRAP, addr, 0, 0, __KERNEL_CS);
+}
+
+static inline void set_system_gate(unsigned int n, void *addr)
+{
+	BUG_ON((unsigned)n > 0xFF);
+	_set_gate(n, GATE_TRAP, addr, 0x3, 0, __KERNEL_CS);
+}
+
+static inline void set_task_gate(unsigned int n, unsigned int gdt_entry)
+{
+	BUG_ON((unsigned)n > 0xFF);
+	_set_gate(n, GATE_TASK, (void *)0, 0, 0, (gdt_entry<<3));
+}
+
+static inline void set_intr_gate_ist(int n, void *addr, unsigned ist)
+{
+	BUG_ON((unsigned)n > 0xFF);
+	_set_gate(n, GATE_INTERRUPT, addr, 0, ist, __KERNEL_CS);
+}
+
+static inline void set_system_gate_ist(int n, void *addr, unsigned ist)
+{
+	BUG_ON((unsigned)n > 0xFF);
+	_set_gate(n, GATE_INTERRUPT, addr, 0x3, ist, __KERNEL_CS);
+}
 
 #else
 /*
Index: linux-2.6-x86/include/asm-x86/desc_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc_32.h
+++ linux-2.6-x86/include/asm-x86/desc_32.h
@@ -10,22 +10,6 @@
 #include <linux/preempt.h>
 #include <linux/percpu.h>
 
-extern void set_intr_gate(unsigned int irq, void * addr);
-
-static inline void pack_gate(gate_desc *gate,
-	unsigned long base, unsigned short seg, unsigned char type, unsigned char flags)
-{
-	gate->a = (seg << 16) | (base & 0xffff);
-	gate->b = (base & 0xffff0000) | ((type & 0xff) << 8) | (flags & 0xff);
-}
-
-static inline void _set_gate(int gate, unsigned int type, void *addr, unsigned short seg)
-{
-	gate_desc g;
-	pack_gate(&g, (unsigned long)addr, seg, type, 0);
-	write_idt_entry(idt_table, gate, &g);
-}
-
 static inline void __set_tss_desc(unsigned int cpu, unsigned int entry, const void *addr)
 {
 	tss_desc tss;
Index: linux-2.6-x86/include/asm-x86/desc_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc_64.h
+++ linux-2.6-x86/include/asm-x86/desc_64.h
@@ -11,51 +11,6 @@
 
 #include <asm/segment.h>
 
-static inline void _set_gate(int gate, unsigned type, unsigned long func,
-			     unsigned dpl, unsigned ist)
-{
-	gate_desc s;
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
-	write_idt_entry(idt_table, gate, &s);
-}
-
-static inline void set_intr_gate(int nr, void *func)
-{
-	BUG_ON((unsigned)nr > 0xFF);
-	_set_gate(nr, GATE_INTERRUPT, (unsigned long) func, 0, 0);
-}
-
-static inline void set_intr_gate_ist(int nr, void *func, unsigned ist)
-{
-	BUG_ON((unsigned)nr > 0xFF);
-	_set_gate(nr, GATE_INTERRUPT, (unsigned long) func, 0, ist);
-}
-
-static inline void set_system_gate(int nr, void *func)
-{
-	BUG_ON((unsigned)nr > 0xFF);
-	_set_gate(nr, GATE_INTERRUPT, (unsigned long) func, 3, 0);
-}
-
-static inline void set_system_gate_ist(int nr, void *func, unsigned ist)
-{
-	_set_gate(nr, GATE_INTERRUPT, (unsigned long) func, 3, ist);
-}
-
 static inline void set_tss_desc(unsigned cpu, void *addr)
 {
 	struct desc_struct *d = get_cpu_gdt_table(cpu);
Index: linux-2.6-x86/include/asm-x86/desc_defs.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/desc_defs.h
+++ linux-2.6-x86/include/asm-x86/desc_defs.h
@@ -36,6 +36,7 @@ enum {
 	GATE_INTERRUPT = 0xE,
 	GATE_TRAP = 0xF,
 	GATE_CALL = 0xC,
+	GATE_TASK = 0x5,
 };
 
 // 16byte gate
@@ -55,10 +56,6 @@ struct gate_struct64 {
 enum {
 	DESC_TSS = 0x9,
 	DESC_LDT = 0x2,
-	DESCTYPE_TASK = 0x85,   /* present, system, DPL-0, task gate */
-	DESCTYPE_INT =  0x8e,   /* present, system, DPL-0, interrupt gate */
-	DESCTYPE_TRAP = 0x8f,   /* present, system, DPL-0, trap gate */
-	DESCTYPE_DPL3 = 0x60,   /* DPL-3 */
 	DESCTYPE_S =	0x10,	/* !system */
 };
 
