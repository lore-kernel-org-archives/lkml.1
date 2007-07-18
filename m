Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbXGRHbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbXGRHbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbXGRHbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:31:10 -0400
Received: from ozlabs.org ([203.10.76.45]:59016 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbXGRHbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:31:08 -0400
Subject: [PATCH 3/3] i386: Replace struct Xgt_desc_struct with struct
	desc_ptr
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <1184743422.10380.114.camel@localhost.localdomain>
References: <1184743355.10380.112.camel@localhost.localdomain>
	 <1184743422.10380.114.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 17:30:12 +1000
Message-Id: <1184743812.10380.120.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove i386's Xgt_desc_struct definition and use desc_def.h's desc_ptr.

The offsets in asm-offsets.c do not seem to be used anywhere, so I
simply removed them.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 0b03f449c0b3 arch/i386/kernel/asm-offsets.c
--- a/arch/i386/kernel/asm-offsets.c	Wed Jul 18 16:34:04 2007 +1000
+++ b/arch/i386/kernel/asm-offsets.c	Wed Jul 18 16:55:36 2007 +1000
@@ -61,11 +61,6 @@ void foo(void)
 	OFFSET(TI_sysenter_return, thread_info, sysenter_return);
 	BLANK();
 
-	OFFSET(GDS_size, Xgt_desc_struct, size);
-	OFFSET(GDS_address, Xgt_desc_struct, address);
-	OFFSET(GDS_pad, Xgt_desc_struct, pad);
-	BLANK();
-
 	OFFSET(PT_EBX, pt_regs, ebx);
 	OFFSET(PT_ECX, pt_regs, ecx);
 	OFFSET(PT_EDX, pt_regs, edx);
diff -r 0b03f449c0b3 arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c	Wed Jul 18 16:34:04 2007 +1000
+++ b/arch/i386/kernel/cpu/common.c	Wed Jul 18 16:56:08 2007 +1000
@@ -642,7 +642,7 @@ struct pt_regs * __devinit idle_regs(str
  * it's on the real one. */
 void switch_to_new_gdt(void)
 {
-	struct Xgt_desc_struct gdt_descr;
+	struct desc_ptr gdt_descr;
 
 	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
 	gdt_descr.size = GDT_SIZE - 1;
diff -r 0b03f449c0b3 arch/i386/kernel/doublefault.c
--- a/arch/i386/kernel/doublefault.c	Wed Jul 18 16:34:04 2007 +1000
+++ b/arch/i386/kernel/doublefault.c	Wed Jul 18 16:56:34 2007 +1000
@@ -17,7 +17,7 @@ static unsigned long doublefault_stack[D
 
 static void doublefault_fn(void)
 {
-	struct Xgt_desc_struct gdt_desc = {0, 0};
+	struct desc_ptr gdt_desc = {0, 0};
 	unsigned long gdt, tss;
 
 	store_gdt(&gdt_desc);
diff -r 0b03f449c0b3 arch/i386/kernel/efi.c
--- a/arch/i386/kernel/efi.c	Wed Jul 18 16:34:04 2007 +1000
+++ b/arch/i386/kernel/efi.c	Wed Jul 18 16:56:43 2007 +1000
@@ -69,7 +69,7 @@ static void efi_call_phys_prelog(void) _
 {
 	unsigned long cr4;
 	unsigned long temp;
-	struct Xgt_desc_struct gdt_descr;
+	struct desc_ptr gdt_descr;
 
 	spin_lock(&efi_rt_lock);
 	local_irq_save(efi_rt_eflags);
@@ -111,7 +111,7 @@ static void efi_call_phys_epilog(void) _
 static void efi_call_phys_epilog(void) __releases(efi_rt_lock)
 {
 	unsigned long cr4;
-	struct Xgt_desc_struct gdt_descr;
+	struct desc_ptr gdt_descr;
 
 	gdt_descr.address = (unsigned long)get_cpu_gdt_table(0);
 	gdt_descr.size = GDT_SIZE - 1;
diff -r 0b03f449c0b3 arch/i386/kernel/machine_kexec.c
--- a/arch/i386/kernel/machine_kexec.c	Wed Jul 18 16:34:04 2007 +1000
+++ b/arch/i386/kernel/machine_kexec.c	Wed Jul 18 16:56:54 2007 +1000
@@ -31,7 +31,7 @@ static u32 kexec_pte1[1024] PAGE_ALIGNED
 
 static void set_idt(void *newidt, __u16 limit)
 {
-	struct Xgt_desc_struct curidt;
+	struct desc_ptr curidt;
 
 	/* ia32 supports unaliged loads & stores */
 	curidt.size    = limit;
@@ -43,7 +43,7 @@ static void set_idt(void *newidt, __u16 
 
 static void set_gdt(void *newgdt, __u16 limit)
 {
-	struct Xgt_desc_struct curgdt;
+	struct desc_ptr curgdt;
 
 	/* ia32 supports unaligned loads & stores */
 	curgdt.size    = limit;
diff -r 0b03f449c0b3 arch/i386/kernel/reboot.c
--- a/arch/i386/kernel/reboot.c	Wed Jul 18 16:34:04 2007 +1000
+++ b/arch/i386/kernel/reboot.c	Wed Jul 18 16:56:59 2007 +1000
@@ -155,7 +155,7 @@ real_mode_gdt_entries [3] =
 	0x000092000100ffffULL	/* 16-bit real-mode 64k data at 0x00000100 */
 };
 
-static struct Xgt_desc_struct
+static struct desc_ptr
 real_mode_gdt = { sizeof (real_mode_gdt_entries) - 1, (long)real_mode_gdt_entries },
 real_mode_idt = { 0x3ff, 0 },
 no_idt = { 0, 0 };
diff -r 0b03f449c0b3 drivers/kvm/svm.c
--- a/drivers/kvm/svm.c	Wed Jul 18 16:34:04 2007 +1000
+++ b/drivers/kvm/svm.c	Wed Jul 18 17:10:13 2007 +1000
@@ -290,11 +290,7 @@ static void svm_hardware_enable(void *ga
 
 	struct svm_cpu_data *svm_data;
 	uint64_t efer;
-#ifdef CONFIG_X86_64
 	struct desc_ptr gdt_descr;
-#else
-	struct Xgt_desc_struct gdt_descr;
-#endif
 	struct desc_struct *gdt;
 	int me = raw_smp_processor_id();
 
diff -r 0b03f449c0b3 include/asm-i386/desc.h
--- a/include/asm-i386/desc.h	Wed Jul 18 16:34:04 2007 +1000
+++ b/include/asm-i386/desc.h	Wed Jul 18 16:47:34 2007 +1000
@@ -12,12 +12,6 @@
 
 #include <asm/mmu.h>
 
-struct Xgt_desc_struct {
-	unsigned short size;
-	unsigned long address __attribute__((packed));
-	unsigned short pad;
-} __attribute__ ((packed));
-
 struct gdt_page
 {
 	struct desc_struct gdt[GDT_ENTRIES];
@@ -29,7 +23,7 @@ static inline struct desc_struct *get_cp
 	return per_cpu(gdt_page, cpu).gdt;
 }
 
-extern struct Xgt_desc_struct idt_descr;
+extern struct desc_ptr idt_descr;
 extern struct desc_struct idt_table[];
 extern void set_intr_gate(unsigned int irq, void * addr);
 
@@ -107,22 +101,22 @@ static inline void native_load_tr_desc(v
 	asm volatile("ltr %w0"::"q" (GDT_ENTRY_TSS*8));
 }
 
-static inline void native_load_gdt(const struct Xgt_desc_struct *dtr)
+static inline void native_load_gdt(const struct desc_ptr *dtr)
 {
 	asm volatile("lgdt %0"::"m" (*dtr));
 }
 
-static inline void native_load_idt(const struct Xgt_desc_struct *dtr)
+static inline void native_load_idt(const struct desc_ptr *dtr)
 {
 	asm volatile("lidt %0"::"m" (*dtr));
 }
 
-static inline void native_store_gdt(struct Xgt_desc_struct *dtr)
+static inline void native_store_gdt(struct desc_ptr *dtr)
 {
 	asm ("sgdt %0":"=m" (*dtr));
 }
 
-static inline void native_store_idt(struct Xgt_desc_struct *dtr)
+static inline void native_store_idt(struct desc_ptr *dtr)
 {
 	asm ("sidt %0":"=m" (*dtr));
 }
diff -r 0b03f449c0b3 include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Wed Jul 18 16:34:04 2007 +1000
+++ b/include/asm-i386/paravirt.h	Wed Jul 18 16:49:02 2007 +1000
@@ -20,7 +20,7 @@
 
 struct page;
 struct thread_struct;
-struct Xgt_desc_struct;
+struct desc_ptr;
 struct tss_struct;
 struct mm_struct;
 struct desc_struct;
@@ -121,10 +121,10 @@ struct paravirt_ops
 
 	/* Segment descriptor handling */
 	void (*load_tr_desc)(void);
-	void (*load_gdt)(const struct Xgt_desc_struct *);
-	void (*load_idt)(const struct Xgt_desc_struct *);
-	void (*store_gdt)(struct Xgt_desc_struct *);
-	void (*store_idt)(struct Xgt_desc_struct *);
+	void (*load_gdt)(const struct desc_ptr *);
+	void (*load_idt)(const struct desc_ptr *);
+	void (*store_gdt)(struct desc_ptr *);
+	void (*store_idt)(struct desc_ptr *);
 	void (*set_ldt)(const void *desc, unsigned entries);
 	unsigned long (*store_tr)(void);
 	void (*load_tls)(struct thread_struct *t, unsigned int cpu);
@@ -583,11 +583,11 @@ static inline void load_TR_desc(void)
 {
 	PVOP_VCALL0(load_tr_desc);
 }
-static inline void load_gdt(const struct Xgt_desc_struct *dtr)
+static inline void load_gdt(const struct desc_ptr *dtr)
 {
 	PVOP_VCALL1(load_gdt, dtr);
 }
-static inline void load_idt(const struct Xgt_desc_struct *dtr)
+static inline void load_idt(const struct desc_ptr *dtr)
 {
 	PVOP_VCALL1(load_idt, dtr);
 }
@@ -595,11 +595,11 @@ static inline void set_ldt(const void *a
 {
 	PVOP_VCALL2(set_ldt, addr, entries);
 }
-static inline void store_gdt(struct Xgt_desc_struct *dtr)
+static inline void store_gdt(struct desc_ptr *dtr)
 {
 	PVOP_VCALL1(store_gdt, dtr);
 }
-static inline void store_idt(struct Xgt_desc_struct *dtr)
+static inline void store_idt(struct desc_ptr *dtr)
 {
 	PVOP_VCALL1(store_idt, dtr);
 }
diff -r 0b03f449c0b3 include/asm-i386/processor.h
--- a/include/asm-i386/processor.h	Wed Jul 18 16:34:04 2007 +1000
+++ b/include/asm-i386/processor.h	Wed Jul 18 16:49:14 2007 +1000
@@ -748,7 +748,7 @@ extern int sysenter_setup(void);
 extern int sysenter_setup(void);
 
 /* Defined in head.S */
-extern struct Xgt_desc_struct early_gdt_descr;
+extern struct desc_ptr early_gdt_descr;
 
 extern void cpu_set_gdt(int);
 extern void switch_to_new_gdt(void);
diff -r 0b03f449c0b3 include/asm-i386/suspend.h
--- a/include/asm-i386/suspend.h	Wed Jul 18 16:34:04 2007 +1000
+++ b/include/asm-i386/suspend.h	Wed Jul 18 16:49:20 2007 +1000
@@ -12,8 +12,8 @@ struct saved_context {
 struct saved_context {
   	u16 es, fs, gs, ss;
 	unsigned long cr0, cr2, cr3, cr4;
-	struct Xgt_desc_struct gdt;
-	struct Xgt_desc_struct idt;
+	struct desc_ptr gdt;
+	struct desc_ptr idt;
 	u16 ldt;
 	u16 tss;
 	unsigned long tr;


