Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbXD2LFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbXD2LFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933090AbXD2LAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:00:35 -0400
Received: from mx1.suse.de ([195.135.220.2]:52191 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334AbXD2Kx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:29 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Avi Kivity <avi@qumranet.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [34/48] i386: rationalize paravirt wrappers
Message-Id: <20070429105323.EE6C815108@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>

paravirt.c used to implement native versions of all low-level
functions.  Far cleaner is to have the native versions exposed in the
headers and as inline native_XXX, and if !CONFIG_PARAVIRT, then simply
#define XXX native_XXX.

There are several nice side effects:

1) write_dt_entry() now takes the correct "struct Xgt_desc_struct *"
   not "void *".

2) load_TLS is reintroduced to the for loop, not manually unrolled
   with a #error in case the bounds ever change.

3) Macros become inlines, with type checking.

4) Access to the native versions is trivial for KVM, lguest, Xen and
   others who might want it.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@muc.de>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c  |  293 -------------------------------------------
 include/asm-i386/desc.h      |   82 ++++++++----
 include/asm-i386/io.h        |   15 +-
 include/asm-i386/irqflags.h  |   61 ++++++--
 include/asm-i386/msr.h       |  165 ++++++++++++++++--------
 include/asm-i386/paravirt.h  |   17 +-
 include/asm-i386/processor.h |   94 ++++++++++---
 include/asm-i386/system.h    |  137 ++++++++++++--------
 8 files changed, 389 insertions(+), 475 deletions(-)

Index: linux/arch/i386/kernel/paravirt.c
===================================================================
--- linux.orig/arch/i386/kernel/paravirt.c
+++ linux/arch/i386/kernel/paravirt.c
@@ -93,294 +93,11 @@ static unsigned native_patch(u8 type, u1
 	return insn_len;
 }
 
-static unsigned long native_get_debugreg(int regno)
-{
-	unsigned long val = 0; 	/* Damn you, gcc! */
-
-	switch (regno) {
-	case 0:
-		asm("movl %%db0, %0" :"=r" (val)); break;
-	case 1:
-		asm("movl %%db1, %0" :"=r" (val)); break;
-	case 2:
-		asm("movl %%db2, %0" :"=r" (val)); break;
-	case 3:
-		asm("movl %%db3, %0" :"=r" (val)); break;
-	case 6:
-		asm("movl %%db6, %0" :"=r" (val)); break;
-	case 7:
-		asm("movl %%db7, %0" :"=r" (val)); break;
-	default:
-		BUG();
-	}
-	return val;
-}
-
-static void native_set_debugreg(int regno, unsigned long value)
-{
-	switch (regno) {
-	case 0:
-		asm("movl %0,%%db0"	: /* no output */ :"r" (value));
-		break;
-	case 1:
-		asm("movl %0,%%db1"	: /* no output */ :"r" (value));
-		break;
-	case 2:
-		asm("movl %0,%%db2"	: /* no output */ :"r" (value));
-		break;
-	case 3:
-		asm("movl %0,%%db3"	: /* no output */ :"r" (value));
-		break;
-	case 6:
-		asm("movl %0,%%db6"	: /* no output */ :"r" (value));
-		break;
-	case 7:
-		asm("movl %0,%%db7"	: /* no output */ :"r" (value));
-		break;
-	default:
-		BUG();
-	}
-}
-
 void init_IRQ(void)
 {
 	paravirt_ops.init_IRQ();
 }
 
-static void native_clts(void)
-{
-	asm volatile ("clts");
-}
-
-static unsigned long native_read_cr0(void)
-{
-	unsigned long val;
-	asm volatile("movl %%cr0,%0\n\t" :"=r" (val));
-	return val;
-}
-
-static void native_write_cr0(unsigned long val)
-{
-	asm volatile("movl %0,%%cr0": :"r" (val));
-}
-
-static unsigned long native_read_cr2(void)
-{
-	unsigned long val;
-	asm volatile("movl %%cr2,%0\n\t" :"=r" (val));
-	return val;
-}
-
-static void native_write_cr2(unsigned long val)
-{
-	asm volatile("movl %0,%%cr2": :"r" (val));
-}
-
-static unsigned long native_read_cr3(void)
-{
-	unsigned long val;
-	asm volatile("movl %%cr3,%0\n\t" :"=r" (val));
-	return val;
-}
-
-static void native_write_cr3(unsigned long val)
-{
-	asm volatile("movl %0,%%cr3": :"r" (val));
-}
-
-static unsigned long native_read_cr4(void)
-{
-	unsigned long val;
-	asm volatile("movl %%cr4,%0\n\t" :"=r" (val));
-	return val;
-}
-
-static unsigned long native_read_cr4_safe(void)
-{
-	unsigned long val;
-	/* This could fault if %cr4 does not exist */
-	asm("1: movl %%cr4, %0		\n"
-		"2:				\n"
-		".section __ex_table,\"a\"	\n"
-		".long 1b,2b			\n"
-		".previous			\n"
-		: "=r" (val): "0" (0));
-	return val;
-}
-
-static void native_write_cr4(unsigned long val)
-{
-	asm volatile("movl %0,%%cr4": :"r" (val));
-}
-
-static unsigned long native_save_fl(void)
-{
-	unsigned long f;
-	asm volatile("pushfl ; popl %0":"=g" (f): /* no input */);
-	return f;
-}
-
-static void native_restore_fl(unsigned long f)
-{
-	asm volatile("pushl %0 ; popfl": /* no output */
-			     :"g" (f)
-			     :"memory", "cc");
-}
-
-static void native_irq_disable(void)
-{
-	asm volatile("cli": : :"memory");
-}
-
-static void native_irq_enable(void)
-{
-	asm volatile("sti": : :"memory");
-}
-
-static void native_safe_halt(void)
-{
-	asm volatile("sti; hlt": : :"memory");
-}
-
-static void native_halt(void)
-{
-	asm volatile("hlt": : :"memory");
-}
-
-static void native_wbinvd(void)
-{
-	asm volatile("wbinvd": : :"memory");
-}
-
-static unsigned long long native_read_msr(unsigned int msr, int *err)
-{
-	unsigned long long val;
-
-	asm volatile("2: rdmsr ; xorl %0,%0\n"
-		     "1:\n\t"
-		     ".section .fixup,\"ax\"\n\t"
-		     "3:  movl %3,%0 ; jmp 1b\n\t"
-		     ".previous\n\t"
- 		     ".section __ex_table,\"a\"\n"
-		     "   .align 4\n\t"
-		     "   .long 	2b,3b\n\t"
-		     ".previous"
-		     : "=r" (*err), "=A" (val)
-		     : "c" (msr), "i" (-EFAULT));
-
-	return val;
-}
-
-static int native_write_msr(unsigned int msr, unsigned long long val)
-{
-	int err;
-	asm volatile("2: wrmsr ; xorl %0,%0\n"
-		     "1:\n\t"
-		     ".section .fixup,\"ax\"\n\t"
-		     "3:  movl %4,%0 ; jmp 1b\n\t"
-		     ".previous\n\t"
- 		     ".section __ex_table,\"a\"\n"
-		     "   .align 4\n\t"
-		     "   .long 	2b,3b\n\t"
-		     ".previous"
-		     : "=a" (err)
-		     : "c" (msr), "0" ((u32)val), "d" ((u32)(val>>32)),
-		       "i" (-EFAULT));
-	return err;
-}
-
-static unsigned long long native_read_tsc(void)
-{
-	unsigned long long val;
-	asm volatile("rdtsc" : "=A" (val));
-	return val;
-}
-
-static unsigned long long native_read_pmc(void)
-{
-	unsigned long long val;
-	asm volatile("rdpmc" : "=A" (val));
-	return val;
-}
-
-static void native_load_tr_desc(void)
-{
-	asm volatile("ltr %w0"::"q" (GDT_ENTRY_TSS*8));
-}
-
-static void native_load_gdt(const struct Xgt_desc_struct *dtr)
-{
-	asm volatile("lgdt %0"::"m" (*dtr));
-}
-
-static void native_load_idt(const struct Xgt_desc_struct *dtr)
-{
-	asm volatile("lidt %0"::"m" (*dtr));
-}
-
-static void native_store_gdt(struct Xgt_desc_struct *dtr)
-{
-	asm ("sgdt %0":"=m" (*dtr));
-}
-
-static void native_store_idt(struct Xgt_desc_struct *dtr)
-{
-	asm ("sidt %0":"=m" (*dtr));
-}
-
-static unsigned long native_store_tr(void)
-{
-	unsigned long tr;
-	asm ("str %0":"=r" (tr));
-	return tr;
-}
-
-static void native_load_tls(struct thread_struct *t, unsigned int cpu)
-{
-#define C(i) get_cpu_gdt_table(cpu)[GDT_ENTRY_TLS_MIN + i] = t->tls_array[i]
-	C(0); C(1); C(2);
-#undef C
-}
-
-static inline void native_write_dt_entry(void *dt, int entry, u32 entry_low, u32 entry_high)
-{
-	u32 *lp = (u32 *)((char *)dt + entry*8);
-	lp[0] = entry_low;
-	lp[1] = entry_high;
-}
-
-static void native_write_ldt_entry(void *dt, int entrynum, u32 low, u32 high)
-{
-	native_write_dt_entry(dt, entrynum, low, high);
-}
-
-static void native_write_gdt_entry(void *dt, int entrynum, u32 low, u32 high)
-{
-	native_write_dt_entry(dt, entrynum, low, high);
-}
-
-static void native_write_idt_entry(void *dt, int entrynum, u32 low, u32 high)
-{
-	native_write_dt_entry(dt, entrynum, low, high);
-}
-
-static void native_load_esp0(struct tss_struct *tss,
-				      struct thread_struct *thread)
-{
-	tss->esp0 = thread->esp0;
-
-	/* This can only happen when SEP is enabled, no need to test "SEP"arately */
-	if (unlikely(tss->ss1 != thread->sysenter_cs)) {
-		tss->ss1 = thread->sysenter_cs;
-		wrmsr(MSR_IA32_SYSENTER_CS, thread->sysenter_cs, 0);
-	}
-}
-
-static void native_io_delay(void)
-{
-	asm volatile("outb %al,$0x80");
-}
-
 static void native_flush_tlb(void)
 {
 	__native_flush_tlb();
@@ -517,8 +234,8 @@ struct paravirt_ops paravirt_ops = {
 	.safe_halt = native_safe_halt,
 	.halt = native_halt,
 	.wbinvd = native_wbinvd,
-	.read_msr = native_read_msr,
-	.write_msr = native_write_msr,
+	.read_msr = native_read_msr_safe,
+	.write_msr = native_write_msr_safe,
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 	.get_scheduled_cycles = native_read_tsc,
@@ -531,9 +248,9 @@ struct paravirt_ops paravirt_ops = {
 	.store_idt = native_store_idt,
 	.store_tr = native_store_tr,
 	.load_tls = native_load_tls,
-	.write_ldt_entry = native_write_ldt_entry,
-	.write_gdt_entry = native_write_gdt_entry,
-	.write_idt_entry = native_write_idt_entry,
+	.write_ldt_entry = write_dt_entry,
+	.write_gdt_entry = write_dt_entry,
+	.write_idt_entry = write_dt_entry,
 	.load_esp0 = native_load_esp0,
 
 	.set_iopl_mask = native_set_iopl_mask,
Index: linux/include/asm-i386/desc.h
===================================================================
--- linux.orig/include/asm-i386/desc.h
+++ linux/include/asm-i386/desc.h
@@ -57,45 +57,33 @@ static inline void pack_gate(__u32 *a, _
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
-#define load_TR_desc() __asm__ __volatile__("ltr %w0"::"q" (GDT_ENTRY_TSS*8))
-
-#define load_gdt(dtr) __asm__ __volatile("lgdt %0"::"m" (*dtr))
-#define load_idt(dtr) __asm__ __volatile("lidt %0"::"m" (*dtr))
+#define load_TR_desc() native_load_tr_desc()
+#define load_gdt(dtr) native_load_gdt(dtr)
+#define load_idt(dtr) native_load_idt(dtr)
 #define load_tr(tr) __asm__ __volatile("ltr %0"::"m" (tr))
 #define load_ldt(ldt) __asm__ __volatile("lldt %0"::"m" (ldt))
 
-#define store_gdt(dtr) __asm__ ("sgdt %0":"=m" (*dtr))
-#define store_idt(dtr) __asm__ ("sidt %0":"=m" (*dtr))
-#define store_tr(tr) __asm__ ("str %0":"=m" (tr))
+#define store_gdt(dtr) native_store_gdt(dtr)
+#define store_idt(dtr) native_store_idt(dtr)
+#define store_tr(tr) (tr = native_store_tr())
 #define store_ldt(ldt) __asm__ ("sldt %0":"=m" (ldt))
 
-#if TLS_SIZE != 24
-# error update this code.
-#endif
-
-static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
-{
-#define C(i) get_cpu_gdt_table(cpu)[GDT_ENTRY_TLS_MIN + i] = t->tls_array[i]
-	C(0); C(1); C(2);
-#undef C
-}
+#define load_TLS(t, cpu) native_load_tls(t, cpu)
+#define set_ldt native_set_ldt
 
 #define write_ldt_entry(dt, entry, a, b) write_dt_entry(dt, entry, a, b)
 #define write_gdt_entry(dt, entry, a, b) write_dt_entry(dt, entry, a, b)
 #define write_idt_entry(dt, entry, a, b) write_dt_entry(dt, entry, a, b)
+#endif
 
-static inline void write_dt_entry(void *dt, int entry, __u32 entry_a, __u32 entry_b)
+static inline void write_dt_entry(struct desc_struct *dt,
+				  int entry, u32 entry_low, u32 entry_high)
 {
-	__u32 *lp = (__u32 *)((char *)dt + entry*8);
-	*lp = entry_a;
-	*(lp+1) = entry_b;
+	dt[entry].a = entry_low;
+	dt[entry].b = entry_high;
 }
 
-#define set_ldt native_set_ldt
-#endif /* CONFIG_PARAVIRT */
-
-static inline fastcall void native_set_ldt(const void *addr,
-					   unsigned int entries)
+static inline void native_set_ldt(const void *addr, unsigned int entries)
 {
 	if (likely(entries == 0))
 		__asm__ __volatile__("lldt %w0"::"q" (0));
@@ -111,6 +99,48 @@ static inline fastcall void native_set_l
 	}
 }
 
+
+static inline void native_load_tr_desc(void)
+{
+	asm volatile("ltr %w0"::"q" (GDT_ENTRY_TSS*8));
+}
+
+static inline void native_load_gdt(const struct Xgt_desc_struct *dtr)
+{
+	asm volatile("lgdt %0"::"m" (*dtr));
+}
+
+static inline void native_load_idt(const struct Xgt_desc_struct *dtr)
+{
+	asm volatile("lidt %0"::"m" (*dtr));
+}
+
+static inline void native_store_gdt(struct Xgt_desc_struct *dtr)
+{
+	asm ("sgdt %0":"=m" (*dtr));
+}
+
+static inline void native_store_idt(struct Xgt_desc_struct *dtr)
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
+
 static inline void _set_gate(int gate, unsigned int type, void *addr, unsigned short seg)
 {
 	__u32 a, b;
Index: linux/include/asm-i386/io.h
===================================================================
--- linux.orig/include/asm-i386/io.h
+++ linux/include/asm-i386/io.h
@@ -250,19 +250,22 @@ static inline void flush_write_buffers(v
 
 #endif /* __KERNEL__ */
 
+static inline void native_io_delay(void)
+{
+	asm volatile("outb %%al,$0x80" : : : "memory");
+}
+
 #if defined(CONFIG_PARAVIRT)
 #include <asm/paravirt.h>
 #else
 
-#define __SLOW_DOWN_IO "outb %%al,$0x80;"
-
 static inline void slow_down_io(void) {
-	__asm__ __volatile__(
-		__SLOW_DOWN_IO
+	native_io_delay();
 #ifdef REALLY_SLOW_IO
-		__SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO
+	native_io_delay();
+	native_io_delay();
+	native_io_delay();
 #endif
-		: : );
 }
 
 #endif
Index: linux/include/asm-i386/irqflags.h
===================================================================
--- linux.orig/include/asm-i386/irqflags.h
+++ linux/include/asm-i386/irqflags.h
@@ -10,6 +10,42 @@
 #ifndef _ASM_IRQFLAGS_H
 #define _ASM_IRQFLAGS_H
 
+#ifndef __ASSEMBLY__
+static inline unsigned long native_save_fl(void)
+{
+	unsigned long f;
+	asm volatile("pushfl ; popl %0":"=g" (f): /* no input */);
+	return f;
+}
+
+static inline void native_restore_fl(unsigned long f)
+{
+	asm volatile("pushl %0 ; popfl": /* no output */
+			     :"g" (f)
+			     :"memory", "cc");
+}
+
+static inline void native_irq_disable(void)
+{
+	asm volatile("cli": : :"memory");
+}
+
+static inline void native_irq_enable(void)
+{
+	asm volatile("sti": : :"memory");
+}
+
+static inline void native_safe_halt(void)
+{
+	asm volatile("sti; hlt": : :"memory");
+}
+
+static inline void native_halt(void)
+{
+	asm volatile("hlt": : :"memory");
+}
+#endif	/* __ASSEMBLY__ */
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
@@ -17,35 +53,22 @@
 
 static inline unsigned long __raw_local_save_flags(void)
 {
-	unsigned long flags;
-
-	__asm__ __volatile__(
-		"pushfl ; popl %0"
-		: "=g" (flags)
-		: /* no input */
-	);
-
-	return flags;
+	return native_save_fl();
 }
 
 static inline void raw_local_irq_restore(unsigned long flags)
 {
-	__asm__ __volatile__(
-		"pushl %0 ; popfl"
-		: /* no output */
-		:"g" (flags)
-		:"memory", "cc"
-	);
+	native_restore_fl(flags);
 }
 
 static inline void raw_local_irq_disable(void)
 {
-	__asm__ __volatile__("cli" : : : "memory");
+	native_irq_disable();
 }
 
 static inline void raw_local_irq_enable(void)
 {
-	__asm__ __volatile__("sti" : : : "memory");
+	native_irq_enable();
 }
 
 /*
@@ -54,7 +77,7 @@ static inline void raw_local_irq_enable(
  */
 static inline void raw_safe_halt(void)
 {
-	__asm__ __volatile__("sti; hlt" : : : "memory");
+	native_safe_halt();
 }
 
 /*
@@ -63,7 +86,7 @@ static inline void raw_safe_halt(void)
  */
 static inline void halt(void)
 {
-	__asm__ __volatile__("hlt": : :"memory");
+	native_halt();
 }
 
 /*
Index: linux/include/asm-i386/msr.h
===================================================================
--- linux.orig/include/asm-i386/msr.h
+++ linux/include/asm-i386/msr.h
@@ -1,6 +1,74 @@
 #ifndef __ASM_MSR_H
 #define __ASM_MSR_H
 
+#include <asm/errno.h>
+
+static inline unsigned long long native_read_msr(unsigned int msr)
+{
+	unsigned long long val;
+
+	asm volatile("rdmsr" : "=A" (val) : "c" (msr));
+	return val;
+}
+
+static inline unsigned long long native_read_msr_safe(unsigned int msr,
+						      int *err)
+{
+	unsigned long long val;
+
+	asm volatile("2: rdmsr ; xorl %0,%0\n"
+		     "1:\n\t"
+		     ".section .fixup,\"ax\"\n\t"
+		     "3:  movl %3,%0 ; jmp 1b\n\t"
+		     ".previous\n\t"
+ 		     ".section __ex_table,\"a\"\n"
+		     "   .align 4\n\t"
+		     "   .long 	2b,3b\n\t"
+		     ".previous"
+		     : "=r" (*err), "=A" (val)
+		     : "c" (msr), "i" (-EFAULT));
+
+	return val;
+}
+
+static inline void native_write_msr(unsigned int msr, unsigned long long val)
+{
+	asm volatile("wrmsr" : : "c" (msr), "A"(val));
+}
+
+static inline int native_write_msr_safe(unsigned int msr,
+					unsigned long long val)
+{
+	int err;
+	asm volatile("2: wrmsr ; xorl %0,%0\n"
+		     "1:\n\t"
+		     ".section .fixup,\"ax\"\n\t"
+		     "3:  movl %4,%0 ; jmp 1b\n\t"
+		     ".previous\n\t"
+ 		     ".section __ex_table,\"a\"\n"
+		     "   .align 4\n\t"
+		     "   .long 	2b,3b\n\t"
+		     ".previous"
+		     : "=a" (err)
+		     : "c" (msr), "0" ((u32)val), "d" ((u32)(val>>32)),
+		       "i" (-EFAULT));
+	return err;
+}
+
+static inline unsigned long long native_read_tsc(void)
+{
+	unsigned long long val;
+	asm volatile("rdtsc" : "=A" (val));
+	return val;
+}
+
+static inline unsigned long long native_read_pmc(void)
+{
+	unsigned long long val;
+	asm volatile("rdpmc" : "=A" (val));
+	return val;
+}
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
@@ -11,22 +79,20 @@
  * pointer indirection), this allows gcc to optimize better
  */
 
-#define rdmsr(msr,val1,val2) \
-	__asm__ __volatile__("rdmsr" \
-			  : "=a" (val1), "=d" (val2) \
-			  : "c" (msr))
-
-#define wrmsr(msr,val1,val2) \
-	__asm__ __volatile__("wrmsr" \
-			  : /* no outputs */ \
-			  : "c" (msr), "a" (val1), "d" (val2))
-
-#define rdmsrl(msr,val) do { \
-	unsigned long l__,h__; \
-	rdmsr (msr, l__, h__);  \
-	val = l__;  \
-	val |= ((u64)h__<<32);  \
-} while(0)
+#define rdmsr(msr,val1,val2)						\
+	do {								\
+		unsigned long long __val = native_read_msr(msr);	\
+		val1 = __val;						\
+		val2 = __val >> 32;					\
+	} while(0)
+
+#define wrmsr(msr,val1,val2)						\
+	native_write_msr(msr, ((unsigned long long)val2 << 32) | val1)
+
+#define rdmsrl(msr,val)					\
+	do {						\
+		(val) = native_read_msr(msr);		\
+	} while(0)
 
 static inline void wrmsrl (unsigned long msr, unsigned long long val)
 {
@@ -37,50 +103,41 @@ static inline void wrmsrl (unsigned long
 }
 
 /* wrmsr with exception handling */
-#define wrmsr_safe(msr,a,b) ({ int ret__;						\
-	asm volatile("2: wrmsr ; xorl %0,%0\n"						\
-		     "1:\n\t"								\
-		     ".section .fixup,\"ax\"\n\t"					\
-		     "3:  movl %4,%0 ; jmp 1b\n\t"					\
-		     ".previous\n\t"							\
- 		     ".section __ex_table,\"a\"\n"					\
-		     "   .align 4\n\t"							\
-		     "   .long 	2b,3b\n\t"						\
-		     ".previous"							\
-		     : "=a" (ret__)							\
-		     : "c" (msr), "0" (a), "d" (b), "i" (-EFAULT));\
-	ret__; })
+#define wrmsr_safe(msr,val1,val2)						\
+	(native_write_msr_safe(msr, ((unsigned long long)val2 << 32) | val1))
 
 /* rdmsr with exception handling */
-#define rdmsr_safe(msr,a,b) ({ int ret__;						\
-	asm volatile("2: rdmsr ; xorl %0,%0\n"						\
-		     "1:\n\t"								\
-		     ".section .fixup,\"ax\"\n\t"					\
-		     "3:  movl %4,%0 ; jmp 1b\n\t"					\
-		     ".previous\n\t"							\
- 		     ".section __ex_table,\"a\"\n"					\
-		     "   .align 4\n\t"							\
-		     "   .long 	2b,3b\n\t"						\
-		     ".previous"							\
-		     : "=r" (ret__), "=a" (*(a)), "=d" (*(b))				\
-		     : "c" (msr), "i" (-EFAULT));\
-	ret__; })
-
-#define rdtsc(low,high) \
-     __asm__ __volatile__("rdtsc" : "=a" (low), "=d" (high))
-
-#define rdtscl(low) \
-     __asm__ __volatile__("rdtsc" : "=a" (low) : : "edx")
+#define rdmsr_safe(msr,p1,p2)						\
+	({								\
+		int __err;						\
+		unsigned long long __val = native_read_msr_safe(msr, &__err);\
+		(*p1) = __val;						\
+		(*p2) = __val >> 32;					\
+		__err;							\
+	})
+
+#define rdtsc(low,high)						\
+	do {							\
+		u64 _l = native_read_tsc();			\
+		(low) = (u32)_l;				\
+		(high) = _l >> 32;				\
+	} while(0)
+
+#define rdtscl(low)						\
+	do {							\
+		(low) = native_read_tsc();			\
+	} while(0)
 
-#define rdtscll(val) \
-     __asm__ __volatile__("rdtsc" : "=A" (val))
+#define rdtscll(val) ((val) = native_read_tsc())
 
 #define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
 
-#define rdpmc(counter,low,high) \
-     __asm__ __volatile__("rdpmc" \
-			  : "=a" (low), "=d" (high) \
-			  : "c" (counter))
+#define rdpmc(counter,low,high)					\
+	do {							\
+		u64 _l = native_read_pmc();			\
+		low = (u32)_l;					\
+		high = _l >> 32;				\
+	} while(0)
 #endif	/* !CONFIG_PARAVIRT */
 
 #ifdef CONFIG_SMP
Index: linux/include/asm-i386/paravirt.h
===================================================================
--- linux.orig/include/asm-i386/paravirt.h
+++ linux/include/asm-i386/paravirt.h
@@ -29,6 +29,7 @@ struct thread_struct;
 struct Xgt_desc_struct;
 struct tss_struct;
 struct mm_struct;
+struct desc_struct;
 struct paravirt_ops
 {
 	unsigned int kernel_rpl;
@@ -105,14 +106,13 @@ struct paravirt_ops
 	void (*set_ldt)(const void *desc, unsigned entries);
 	unsigned long (*store_tr)(void);
 	void (*load_tls)(struct thread_struct *t, unsigned int cpu);
-	void (*write_ldt_entry)(void *dt, int entrynum,
-					 u32 low, u32 high);
-	void (*write_gdt_entry)(void *dt, int entrynum,
-					 u32 low, u32 high);
-	void (*write_idt_entry)(void *dt, int entrynum,
-					 u32 low, u32 high);
-	void (*load_esp0)(struct tss_struct *tss,
-				   struct thread_struct *thread);
+	void (*write_ldt_entry)(struct desc_struct *,
+				int entrynum, u32 low, u32 high);
+	void (*write_gdt_entry)(struct desc_struct *,
+				int entrynum, u32 low, u32 high);
+	void (*write_idt_entry)(struct desc_struct *,
+				int entrynum, u32 low, u32 high);
+	void (*load_esp0)(struct tss_struct *tss, struct thread_struct *t);
 
 	void (*set_iopl_mask)(unsigned mask);
 
@@ -232,6 +232,7 @@ static inline void halt(void)
 
 #define get_kernel_rpl()  (paravirt_ops.kernel_rpl)
 
+/* These should all do BUG_ON(_err), but our headers are too tangled. */
 #define rdmsr(msr,val1,val2) do {				\
 	int _err;						\
 	u64 _l = paravirt_ops.read_msr(msr,&_err);		\
Index: linux/include/asm-i386/processor.h
===================================================================
--- linux.orig/include/asm-i386/processor.h
+++ linux/include/asm-i386/processor.h
@@ -147,7 +147,7 @@ static inline void detect_ht(struct cpui
 #define X86_EFLAGS_VIP	0x00100000 /* Virtual Interrupt Pending */
 #define X86_EFLAGS_ID	0x00200000 /* CPUID detection flag */
 
-static inline fastcall void native_cpuid(unsigned int *eax, unsigned int *ebx,
+static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 					 unsigned int *ecx, unsigned int *edx)
 {
 	/* ecx is often an input as well as an output. */
@@ -545,13 +545,7 @@ static inline void rep_nop(void)
 
 #define cpu_relax()	rep_nop()
 
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#define paravirt_enabled() 0
-#define __cpuid native_cpuid
-
-static inline void load_esp0(struct tss_struct *tss, struct thread_struct *thread)
+static inline void native_load_esp0(struct tss_struct *tss, struct thread_struct *thread)
 {
 	tss->esp0 = thread->esp0;
 	/* This can only happen when SEP is enabled, no need to test "SEP"arately */
@@ -561,24 +555,60 @@ static inline void load_esp0(struct tss_
 	}
 }
 
-/*
- * These special macros can be used to get or set a debugging register
- */
-#define get_debugreg(var, register)				\
-		__asm__("movl %%db" #register ", %0"		\
-			:"=r" (var))
-#define set_debugreg(value, register)			\
-		__asm__("movl %0,%%db" #register		\
-			: /* no output */			\
-			:"r" (value))
 
-#define set_iopl_mask native_set_iopl_mask
-#endif /* CONFIG_PARAVIRT */
+static inline unsigned long native_get_debugreg(int regno)
+{
+	unsigned long val = 0; 	/* Damn you, gcc! */
+
+	switch (regno) {
+	case 0:
+		asm("movl %%db0, %0" :"=r" (val)); break;
+	case 1:
+		asm("movl %%db1, %0" :"=r" (val)); break;
+	case 2:
+		asm("movl %%db2, %0" :"=r" (val)); break;
+	case 3:
+		asm("movl %%db3, %0" :"=r" (val)); break;
+	case 6:
+		asm("movl %%db6, %0" :"=r" (val)); break;
+	case 7:
+		asm("movl %%db7, %0" :"=r" (val)); break;
+	default:
+		BUG();
+	}
+	return val;
+}
+
+static inline void native_set_debugreg(int regno, unsigned long value)
+{
+	switch (regno) {
+	case 0:
+		asm("movl %0,%%db0"	: /* no output */ :"r" (value));
+		break;
+	case 1:
+		asm("movl %0,%%db1"	: /* no output */ :"r" (value));
+		break;
+	case 2:
+		asm("movl %0,%%db2"	: /* no output */ :"r" (value));
+		break;
+	case 3:
+		asm("movl %0,%%db3"	: /* no output */ :"r" (value));
+		break;
+	case 6:
+		asm("movl %0,%%db6"	: /* no output */ :"r" (value));
+		break;
+	case 7:
+		asm("movl %0,%%db7"	: /* no output */ :"r" (value));
+		break;
+	default:
+		BUG();
+	}
+}
 
 /*
  * Set IOPL bits in EFLAGS from given mask
  */
-static fastcall inline void native_set_iopl_mask(unsigned mask)
+static inline void native_set_iopl_mask(unsigned mask)
 {
 	unsigned int reg;
 	__asm__ __volatile__ ("pushfl;"
@@ -591,6 +621,28 @@ static fastcall inline void native_set_i
 				: "i" (~X86_EFLAGS_IOPL), "r" (mask));
 }
 
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define paravirt_enabled() 0
+#define __cpuid native_cpuid
+
+static inline void load_esp0(struct tss_struct *tss, struct thread_struct *thread)
+{
+	native_load_esp0(tss, thread);
+}
+
+/*
+ * These special macros can be used to get or set a debugging register
+ */
+#define get_debugreg(var, register)				\
+	(var) = native_get_debugreg(register)
+#define set_debugreg(value, register)				\
+	native_set_debugreg(register, value)
+
+#define set_iopl_mask native_set_iopl_mask
+#endif /* CONFIG_PARAVIRT */
+
 /*
  * Generic CPUID function
  * clear %ecx since some cpus (Cyrix MII) do not set or clear %ecx
Index: linux/include/asm-i386/system.h
===================================================================
--- linux.orig/include/asm-i386/system.h
+++ linux/include/asm-i386/system.h
@@ -88,65 +88,96 @@ __asm__ __volatile__ ("movw %%dx,%1\n\t"
 #define savesegment(seg, value) \
 	asm volatile("mov %%" #seg ",%0":"=rm" (value))
 
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#define read_cr0() ({ \
-	unsigned int __dummy; \
-	__asm__ __volatile__( \
-		"movl %%cr0,%0\n\t" \
-		:"=r" (__dummy)); \
-	__dummy; \
-})
-#define write_cr0(x) \
-	__asm__ __volatile__("movl %0,%%cr0": :"r" (x))
 
-#define read_cr2() ({ \
-	unsigned int __dummy; \
-	__asm__ __volatile__( \
-		"movl %%cr2,%0\n\t" \
-		:"=r" (__dummy)); \
-	__dummy; \
-})
-#define write_cr2(x) \
-	__asm__ __volatile__("movl %0,%%cr2": :"r" (x))
+static inline void native_clts(void)
+{
+	asm volatile ("clts");
+}
 
-#define read_cr3() ({ \
-	unsigned int __dummy; \
-	__asm__ ( \
-		"movl %%cr3,%0\n\t" \
-		:"=r" (__dummy)); \
-	__dummy; \
-})
-#define write_cr3(x) \
-	__asm__ __volatile__("movl %0,%%cr3": :"r" (x))
+static inline unsigned long native_read_cr0(void)
+{
+	unsigned long val;
+	asm volatile("movl %%cr0,%0\n\t" :"=r" (val));
+	return val;
+}
 
-#define read_cr4() ({ \
-	unsigned int __dummy; \
-	__asm__( \
-		"movl %%cr4,%0\n\t" \
-		:"=r" (__dummy)); \
-	__dummy; \
-})
-#define read_cr4_safe() ({			      \
-	unsigned int __dummy;			      \
-	/* This could fault if %cr4 does not exist */ \
-	__asm__("1: movl %%cr4, %0		\n"   \
-		"2:				\n"   \
-		".section __ex_table,\"a\"	\n"   \
-		".long 1b,2b			\n"   \
-		".previous			\n"   \
-		: "=r" (__dummy): "0" (0));	      \
-	__dummy;				      \
-})
-#define write_cr4(x) \
-	__asm__ __volatile__("movl %0,%%cr4": :"r" (x))
+static inline void native_write_cr0(unsigned long val)
+{
+	asm volatile("movl %0,%%cr0": :"r" (val));
+}
+
+static inline unsigned long native_read_cr2(void)
+{
+	unsigned long val;
+	asm volatile("movl %%cr2,%0\n\t" :"=r" (val));
+	return val;
+}
 
-#define wbinvd() \
-	__asm__ __volatile__ ("wbinvd": : :"memory")
+static inline void native_write_cr2(unsigned long val)
+{
+	asm volatile("movl %0,%%cr2": :"r" (val));
+}
+
+static inline unsigned long native_read_cr3(void)
+{
+	unsigned long val;
+	asm volatile("movl %%cr3,%0\n\t" :"=r" (val));
+	return val;
+}
+
+static inline void native_write_cr3(unsigned long val)
+{
+	asm volatile("movl %0,%%cr3": :"r" (val));
+}
+
+static inline unsigned long native_read_cr4(void)
+{
+	unsigned long val;
+	asm volatile("movl %%cr4,%0\n\t" :"=r" (val));
+	return val;
+}
+
+static inline unsigned long native_read_cr4_safe(void)
+{
+	unsigned long val;
+	/* This could fault if %cr4 does not exist */
+	asm("1: movl %%cr4, %0		\n"
+		"2:				\n"
+		".section __ex_table,\"a\"	\n"
+		".long 1b,2b			\n"
+		".previous			\n"
+		: "=r" (val): "0" (0));
+	return val;
+}
+
+static inline void native_write_cr4(unsigned long val)
+{
+	asm volatile("movl %0,%%cr4": :"r" (val));
+}
+
+static inline void native_wbinvd(void)
+{
+	asm volatile("wbinvd": : :"memory");
+}
+
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define read_cr0()	(native_read_cr0())
+#define write_cr0(x)	(native_write_cr0(x))
+#define read_cr2()	(native_read_cr2())
+#define write_cr2(x)	(native_write_cr2(x))
+#define read_cr3()	(native_read_cr3())
+#define write_cr3(x)	(native_write_cr3(x))
+#define read_cr4()	(native_read_cr4())
+#define read_cr4_safe()	(native_read_cr4_safe())
+#define write_cr4(x)	(native_write_cr4(x))
+#define wbinvd()	(native_wbinvd())
 
 /* Clear the 'TS' bit */
-#define clts() __asm__ __volatile__ ("clts")
+#define clts()		(native_clts())
+
 #endif/* CONFIG_PARAVIRT */
 
 /* Set the 'TS' bit */
