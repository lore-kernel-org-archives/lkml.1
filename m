Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbXLFTHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbXLFTHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbXLFTDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:03:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755795AbXLFTDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:03:41 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 18/19] move _set_gate and its users to a common location
Date: Thu,  6 Dec 2007 14:16:39 -0200
Message-Id: <1196957892937-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11969578862882-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11969578092869-git-send-email-gcosta@redhat.com> <11969578142514-git-send-email-gcosta@redhat.com> <11969578193406-git-send-email-gcosta@redhat.com> <11969578242463-git-send-email-gcosta@redhat.com> <11969578292944-git-send-email-gcosta@redhat.com> <11969578343061-git-send-email-gcosta@redhat.com> <11969578383955-git-send-email-gcosta@redhat.com> <11969578431489-git-send-email-gcosta@redhat.com> <11969578483552-git-send-email-gcosta@redhat.com> <11969578534185-git-send-email-gcosta@redhat.com> <11969578581299-git-send-email-gcosta@redhat.com> <1196957863723-git-send-email-gcosta@redhat.com> <11969578671479-git-send-email-gcosta@redhat.com> <119695787262-git-send-email-gcosta@redhat.com> <11969578773678-git-send-email-gcosta@redhat.com> <11969578811685-git-send-email-gcosta@redhat.com> <11969578862882-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves _set_gate and its users to desc.h. We can now
use common code for x86_64 and i386.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/traps_32.c  |   34 ----------------
 include/asm-x86/desc.h      |   88 +++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/desc_32.h   |   43 ---------------------
 include/asm-x86/desc_64.h   |   45 ----------------------
 include/asm-x86/desc_defs.h |    5 +--
 5 files changed, 89 insertions(+), 126 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 6b03d88..776e19b 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
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
diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index 1773dd2..1290757 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -15,6 +15,22 @@ extern struct desc_struct cpu_gdt_table[GDT_ENTRIES];
 extern struct desc_ptr cpu_gdt_descr[];
 /* the cpu gdt accessor */
 #define get_cpu_gdt_table(_cpu) ((struct desc_struct *)cpu_gdt_descr[_cpu].address)
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
 struct gdt_page
 {
@@ -26,6 +42,16 @@ static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
 {
 	return per_cpu(gdt_page, cpu).gdt;
 }
+
+static inline void pack_gate(gate_desc *gate,unsigned char type,
+       unsigned long base, unsigned dpl, unsigned flags, unsigned short seg)
+
+{
+	gate->a = (seg << 16) | (base & 0xffff);
+	gate->b = (base & 0xffff0000) |
+		  ((( 0x80 | type | (dpl << 5)) & 0xff) << 8);
+}
+
 #endif
 
 #ifdef CONFIG_PARAVIRT
@@ -214,6 +240,68 @@ static inline unsigned long get_desc_base(struct desc_struct *desc)
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
diff --git a/include/asm-x86/desc_32.h b/include/asm-x86/desc_32.h
deleted file mode 100644
index e8f2bc2..0000000
--- a/include/asm-x86/desc_32.h
+++ /dev/null
@@ -1,43 +0,0 @@
-#ifndef __ARCH_DESC_H
-#define __ARCH_DESC_H
-
-#include <asm/ldt.h>
-#include <asm/segment.h>
-#include <asm/desc_defs.h>
-
-#ifndef __ASSEMBLY__
-
-#include <linux/preempt.h>
-#include <linux/percpu.h>
-
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
-static inline void __set_tss_desc(unsigned int cpu, unsigned int entry, const void *addr)
-{
-	tss_desc tss;
-	pack_descriptor(&tss, (unsigned long)addr,
-			offsetof(struct tss_struct, __cacheline_filler) - 1,
-			DESCTYPE_TSS, 0);
-	write_gdt_entry(get_cpu_gdt_table(cpu), entry, &tss, sizeof(tss));
-}
-
-
-#define set_tss_desc(cpu,addr) __set_tss_desc(cpu, GDT_ENTRY_TSS, addr)
-
-#endif /* !__ASSEMBLY__ */
-
-#endif
diff --git a/include/asm-x86/desc_64.h b/include/asm-x86/desc_64.h
index fd907da..de37b9b 100644
--- a/include/asm-x86/desc_64.h
+++ b/include/asm-x86/desc_64.h
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
diff --git a/include/asm-x86/desc_defs.h b/include/asm-x86/desc_defs.h
index 69597f3..7759d8a 100644
--- a/include/asm-x86/desc_defs.h
+++ b/include/asm-x86/desc_defs.h
@@ -39,6 +39,7 @@ enum {
 	GATE_INTERRUPT = 0xE,
 	GATE_TRAP = 0xF,
 	GATE_CALL = 0xC,
+	GATE_TASK = 0x5,
 };
 
 // 16byte gate
@@ -60,10 +61,6 @@ enum {
 	DESC_LDT = 0x2,
 	DESCTYPE_LDT =	0x82,	/* present, system, DPL-0, LDT */
 	DESCTYPE_TSS =	0x89,	/* present, system, DPL-0, 32-bit TSS */
-	DESCTYPE_TASK = 0x85,   /* present, system, DPL-0, task gate */
-	DESCTYPE_INT =  0x8e,   /* present, system, DPL-0, interrupt gate */
-	DESCTYPE_TRAP = 0x8f,   /* present, system, DPL-0, trap gate */
-	DESCTYPE_DPL3 = 0x60,   /* DPL-3 */
 	DESCTYPE_S =	0x10,	/* !system */
 };
 
-- 
1.4.4.2

