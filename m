Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbXLFTCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbXLFTCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbXLFTBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:01:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287AbXLFTBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:01:16 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 2/19] unify struct desc_ptr
Date: Thu,  6 Dec 2007 14:16:23 -0200
Message-Id: <11969578142514-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11969578092869-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11969578092869-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch unifies struct desc_ptr between i386 and x86_64.
They can be expressed in the exact same way in C code, only
having to change the name of one of them. As Xgt_desc_struct
is ugly and big, this is the one that goes away.

There's also a padding field in i386, but it is not really
needed in the C structure definition.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/asm-offsets_32.c   |    5 ++---
 arch/x86/kernel/cpu/common.c       |    2 +-
 arch/x86/kernel/doublefault_32.c   |    2 +-
 arch/x86/kernel/efi_32.c           |    4 ++--
 arch/x86/kernel/machine_kexec_32.c |    4 ++--
 arch/x86/kernel/reboot_32.c        |    2 +-
 arch/x86/lguest/boot.c             |    4 ++--
 arch/x86/xen/enlighten.c           |   10 +++++-----
 drivers/kvm/svm.c                  |    2 +-
 include/asm-x86/desc_32.h          |   16 +++++-----------
 include/asm-x86/lguest.h           |    8 ++++----
 include/asm-x86/paravirt.h         |   18 +++++++++---------
 include/asm-x86/processor_32.h     |    2 +-
 include/asm-x86/suspend_32.h       |    4 ++--
 14 files changed, 38 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index 4153135..afd8446 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -70,9 +70,8 @@ void foo(void)
 	OFFSET(TI_cpu, thread_info, cpu);
 	BLANK();
 
-	OFFSET(GDS_size, Xgt_desc_struct, size);
-	OFFSET(GDS_address, Xgt_desc_struct, address);
-	OFFSET(GDS_pad, Xgt_desc_struct, pad);
+	OFFSET(GDS_size, desc_ptr, size);
+	OFFSET(GDS_address, desc_ptr, address);
 	BLANK();
 
 	OFFSET(PT_EBX, pt_regs, bx);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0fe1c1d..a80847f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -642,7 +642,7 @@ struct pt_regs * __devinit idle_regs(struct pt_regs *regs)
  * it's on the real one. */
 void switch_to_new_gdt(void)
 {
-	struct Xgt_desc_struct gdt_descr;
+	struct desc_ptr gdt_descr;
 
 	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
 	gdt_descr.size = GDT_SIZE - 1;
diff --git a/arch/x86/kernel/doublefault_32.c b/arch/x86/kernel/doublefault_32.c
index cc19a3e..d16122a 100644
--- a/arch/x86/kernel/doublefault_32.c
+++ b/arch/x86/kernel/doublefault_32.c
@@ -17,7 +17,7 @@ static unsigned long doublefault_stack[DOUBLEFAULT_STACKSIZE];
 
 static void doublefault_fn(void)
 {
-	struct Xgt_desc_struct gdt_desc = {0, 0};
+	struct desc_ptr gdt_desc = {0, 0};
 	unsigned long gdt, tss;
 
 	store_gdt(&gdt_desc);
diff --git a/arch/x86/kernel/efi_32.c b/arch/x86/kernel/efi_32.c
index e2be78f..863e892 100644
--- a/arch/x86/kernel/efi_32.c
+++ b/arch/x86/kernel/efi_32.c
@@ -69,7 +69,7 @@ static void efi_call_phys_prelog(void) __acquires(efi_rt_lock)
 {
 	unsigned long cr4;
 	unsigned long temp;
-	struct Xgt_desc_struct gdt_descr;
+	struct desc_ptr gdt_descr;
 
 	spin_lock(&efi_rt_lock);
 	local_irq_save(efi_rt_eflags);
@@ -111,7 +111,7 @@ static void efi_call_phys_prelog(void) __acquires(efi_rt_lock)
 static void efi_call_phys_epilog(void) __releases(efi_rt_lock)
 {
 	unsigned long cr4;
-	struct Xgt_desc_struct gdt_descr;
+	struct desc_ptr gdt_descr;
 
 	gdt_descr.address = (unsigned long)get_cpu_gdt_table(0);
 	gdt_descr.size = GDT_SIZE - 1;
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index 11b935f..c1cfd60 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -32,7 +32,7 @@ static u32 kexec_pte1[1024] PAGE_ALIGNED;
 
 static void set_idt(void *newidt, __u16 limit)
 {
-	struct Xgt_desc_struct curidt;
+	struct desc_ptr curidt;
 
 	/* ia32 supports unaliged loads & stores */
 	curidt.size    = limit;
@@ -44,7 +44,7 @@ static void set_idt(void *newidt, __u16 limit)
 
 static void set_gdt(void *newgdt, __u16 limit)
 {
-	struct Xgt_desc_struct curgdt;
+	struct desc_ptr curgdt;
 
 	/* ia32 supports unaligned loads & stores */
 	curgdt.size    = limit;
diff --git a/arch/x86/kernel/reboot_32.c b/arch/x86/kernel/reboot_32.c
index bb1a0f8..c3376fa 100644
--- a/arch/x86/kernel/reboot_32.c
+++ b/arch/x86/kernel/reboot_32.c
@@ -161,7 +161,7 @@ real_mode_gdt_entries [3] =
 	0x000092000100ffffULL	/* 16-bit real-mode 64k data at 0x00000100 */
 };
 
-static struct Xgt_desc_struct
+static struct desc_ptr
 real_mode_gdt = { sizeof (real_mode_gdt_entries) - 1, (long)real_mode_gdt_entries },
 real_mode_idt = { 0x3ff, 0 },
 no_idt = { 0, 0 };
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index c751e3c..aa0bdd5 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -229,7 +229,7 @@ static void lguest_write_idt_entry(struct desc_struct *dt,
 /* Changing to a different IDT is very rare: we keep the IDT up-to-date every
  * time it is written, so we can simply loop through all entries and tell the
  * Host about them. */
-static void lguest_load_idt(const struct Xgt_desc_struct *desc)
+static void lguest_load_idt(const struct desc_ptr *desc)
 {
 	unsigned int i;
 	struct desc_struct *idt = (void *)desc->address;
@@ -252,7 +252,7 @@ static void lguest_load_idt(const struct Xgt_desc_struct *desc)
  * hypercall and use that repeatedly to load a new IDT.  I don't think it
  * really matters, but wouldn't it be nice if they were the same?
  */
-static void lguest_load_gdt(const struct Xgt_desc_struct *desc)
+static void lguest_load_gdt(const struct desc_ptr *desc)
 {
 	BUG_ON((desc->size+1)/8 != GDT_ENTRIES);
 	hcall(LHCALL_LOAD_GDT, __pa(desc->address), GDT_ENTRIES, 0);
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 7b16f2c..53b097a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -295,7 +295,7 @@ static void xen_set_ldt(const void *addr, unsigned entries)
 	xen_mc_issue(PARAVIRT_LAZY_CPU);
 }
 
-static void xen_load_gdt(const struct Xgt_desc_struct *dtr)
+static void xen_load_gdt(const struct desc_ptr *dtr)
 {
 	unsigned long *frames;
 	unsigned long va = dtr->address;
@@ -395,7 +395,7 @@ static int cvt_gate_to_trap(int vector, u32 low, u32 high,
 }
 
 /* Locations of each CPU's IDT */
-static DEFINE_PER_CPU(struct Xgt_desc_struct, idt_desc);
+static DEFINE_PER_CPU(struct desc_ptr, idt_desc);
 
 /* Set an IDT entry.  If the entry is part of the current IDT, then
    also update Xen. */
@@ -427,7 +427,7 @@ static void xen_write_idt_entry(struct desc_struct *dt, int entrynum,
 	preempt_enable();
 }
 
-static void xen_convert_trap_info(const struct Xgt_desc_struct *desc,
+static void xen_convert_trap_info(const struct desc_ptr *desc,
 				  struct trap_info *traps)
 {
 	unsigned in, out, count;
@@ -446,7 +446,7 @@ static void xen_convert_trap_info(const struct Xgt_desc_struct *desc,
 
 void xen_copy_trap_info(struct trap_info *traps)
 {
-	const struct Xgt_desc_struct *desc = &__get_cpu_var(idt_desc);
+	const struct desc_ptr *desc = &__get_cpu_var(idt_desc);
 
 	xen_convert_trap_info(desc, traps);
 }
@@ -454,7 +454,7 @@ void xen_copy_trap_info(struct trap_info *traps)
 /* Load a new IDT into Xen.  In principle this can be per-CPU, so we
    hold a spinlock to protect the static traps[] array (static because
    it avoids allocation, and saves stack space). */
-static void xen_load_idt(const struct Xgt_desc_struct *desc)
+static void xen_load_idt(const struct desc_ptr *desc)
 {
 	static DEFINE_SPINLOCK(lock);
 	static struct trap_info traps[257];
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 4e04e49..ced4ac1 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -290,7 +290,7 @@ static void svm_hardware_enable(void *garbage)
 #ifdef CONFIG_X86_64
 	struct desc_ptr gdt_descr;
 #else
-	struct Xgt_desc_struct gdt_descr;
+	struct desc_ptr gdt_descr;
 #endif
 	struct desc_struct *gdt;
 	int me = raw_smp_processor_id();
diff --git a/include/asm-x86/desc_32.h b/include/asm-x86/desc_32.h
index c547403..bc5ca34 100644
--- a/include/asm-x86/desc_32.h
+++ b/include/asm-x86/desc_32.h
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
@@ -29,7 +23,7 @@ static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
 	return per_cpu(gdt_page, cpu).gdt;
 }
 
-extern struct Xgt_desc_struct idt_descr;
+extern struct desc_ptr idt_descr;
 extern struct desc_struct idt_table[];
 extern void set_intr_gate(unsigned int irq, void * addr);
 
@@ -107,22 +101,22 @@ static inline void native_load_tr_desc(void)
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
diff --git a/include/asm-x86/lguest.h b/include/asm-x86/lguest.h
index ccd3384..d39f881 100644
--- a/include/asm-x86/lguest.h
+++ b/include/asm-x86/lguest.h
@@ -44,13 +44,13 @@ struct lguest_ro_state
 {
 	/* Host information we need to restore when we switch back. */
 	u32 host_cr3;
-	struct Xgt_desc_struct host_idt_desc;
-	struct Xgt_desc_struct host_gdt_desc;
+	struct desc_ptr host_idt_desc;
+	struct desc_ptr host_gdt_desc;
 	u32 host_sp;
 
 	/* Fields which are used when guest is running. */
-	struct Xgt_desc_struct guest_idt_desc;
-	struct Xgt_desc_struct guest_gdt_desc;
+	struct desc_ptr guest_idt_desc;
+	struct desc_ptr guest_gdt_desc;
 	struct i386_hw_tss guest_tss;
 	struct desc_struct guest_idt[IDT_ENTRIES];
 	struct desc_struct guest_gdt[GDT_ENTRIES];
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index e95c2a6..0333fb6 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -20,7 +20,7 @@
 
 struct page;
 struct thread_struct;
-struct Xgt_desc_struct;
+struct desc_ptr;
 struct tss_struct;
 struct mm_struct;
 struct desc_struct;
@@ -88,10 +88,10 @@ struct pv_cpu_ops {
 
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
@@ -630,11 +630,11 @@ static inline void load_TR_desc(void)
 {
 	PVOP_VCALL0(pv_cpu_ops.load_tr_desc);
 }
-static inline void load_gdt(const struct Xgt_desc_struct *dtr)
+static inline void load_gdt(const struct desc_ptr *dtr)
 {
 	PVOP_VCALL1(pv_cpu_ops.load_gdt, dtr);
 }
-static inline void load_idt(const struct Xgt_desc_struct *dtr)
+static inline void load_idt(const struct desc_ptr *dtr)
 {
 	PVOP_VCALL1(pv_cpu_ops.load_idt, dtr);
 }
@@ -642,11 +642,11 @@ static inline void set_ldt(const void *addr, unsigned entries)
 {
 	PVOP_VCALL2(pv_cpu_ops.set_ldt, addr, entries);
 }
-static inline void store_gdt(struct Xgt_desc_struct *dtr)
+static inline void store_gdt(struct desc_ptr *dtr)
 {
 	PVOP_VCALL1(pv_cpu_ops.store_gdt, dtr);
 }
-static inline void store_idt(struct Xgt_desc_struct *dtr)
+static inline void store_idt(struct desc_ptr *dtr)
 {
 	PVOP_VCALL1(pv_cpu_ops.store_idt, dtr);
 }
diff --git a/include/asm-x86/processor_32.h b/include/asm-x86/processor_32.h
index f1fc049..a8aedb2 100644
--- a/include/asm-x86/processor_32.h
+++ b/include/asm-x86/processor_32.h
@@ -704,7 +704,7 @@ extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
 /* Defined in head.S */
-extern struct Xgt_desc_struct early_gdt_descr;
+extern struct desc_ptr early_gdt_descr;
 
 extern void cpu_set_gdt(int);
 extern void switch_to_new_gdt(void);
diff --git a/include/asm-x86/suspend_32.h b/include/asm-x86/suspend_32.h
index a252073..1bbda3a 100644
--- a/include/asm-x86/suspend_32.h
+++ b/include/asm-x86/suspend_32.h
@@ -12,8 +12,8 @@ static inline int arch_prepare_suspend(void) { return 0; }
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
-- 
1.4.4.2

