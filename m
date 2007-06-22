Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbXFVIHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbXFVIHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 04:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbXFVIGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 04:06:55 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34529 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbXFVIGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 04:06:52 -0400
Date: Fri, 22 Jun 2007 01:06:34 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: [PATCH -rt] CONFIG_PARAVIRT and CONFIG_MCOUNT don't play well
	together
Message-ID: <20070622080634.GP3723@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Current -rt is broken when compiling with CONFIG_PARAVIRT and
CONFIG_MCOUNT both enabled.  Because CONFIG_MCOUNT disables
CONFIG_REGPARM, the calling convention must once again be explicit
with fastcall.  However, this was only half-way addressed in the -rt
patch (adding fastcall back to paravirt_ops function ptr declaration but
not the actual function definitions) so the compiled kernel has caller
putting stuff in registers and callee pulling things from the stack.
Impressive how far into boot it can get despite that ;-)  Thanks to
Steven Rostedt for prodding me and starting the initial debugging.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
Patch against patch-2.6.21.5-rt17

 arch/i386/kernel/paravirt.c |   98 ++++++++++++++++++++++----------------------
 1 file changed, 49 insertions(+), 49 deletions(-)


diff --git a/arch/i386/kernel/paravirt.c b/arch/i386/kernel/paravirt.c
index 2ec331e..595cd6f 100644
--- a/arch/i386/kernel/paravirt.c
+++ b/arch/i386/kernel/paravirt.c
@@ -93,7 +93,7 @@ static unsigned native_patch(u8 type, u16 clobbers, void *insns, unsigned len)
 	return insn_len;
 }
 
-static unsigned long native_get_debugreg(int regno)
+static fastcall unsigned long native_get_debugreg(int regno)
 {
 	unsigned long val = 0; 	/* Damn you, gcc! */
 
@@ -116,7 +116,7 @@ static unsigned long native_get_debugreg(int regno)
 	return val;
 }
 
-static void native_set_debugreg(int regno, unsigned long value)
+static fastcall void native_set_debugreg(int regno, unsigned long value)
 {
 	switch (regno) {
 	case 0:
@@ -147,55 +147,55 @@ void init_IRQ(void)
 	paravirt_ops.init_IRQ();
 }
 
-static void native_clts(void)
+static fastcall void native_clts(void)
 {
 	asm volatile ("clts");
 }
 
-static unsigned long native_read_cr0(void)
+static fastcall unsigned long native_read_cr0(void)
 {
 	unsigned long val;
 	asm volatile("movl %%cr0,%0\n\t" :"=r" (val));
 	return val;
 }
 
-static void native_write_cr0(unsigned long val)
+static fastcall void native_write_cr0(unsigned long val)
 {
 	asm volatile("movl %0,%%cr0": :"r" (val));
 }
 
-static unsigned long native_read_cr2(void)
+static fastcall unsigned long native_read_cr2(void)
 {
 	unsigned long val;
 	asm volatile("movl %%cr2,%0\n\t" :"=r" (val));
 	return val;
 }
 
-static void native_write_cr2(unsigned long val)
+static fastcall void native_write_cr2(unsigned long val)
 {
 	asm volatile("movl %0,%%cr2": :"r" (val));
 }
 
-static unsigned long native_read_cr3(void)
+static fastcall unsigned long native_read_cr3(void)
 {
 	unsigned long val;
 	asm volatile("movl %%cr3,%0\n\t" :"=r" (val));
 	return val;
 }
 
-static void native_write_cr3(unsigned long val)
+static fastcall void native_write_cr3(unsigned long val)
 {
 	asm volatile("movl %0,%%cr3": :"r" (val));
 }
 
-static unsigned long native_read_cr4(void)
+static fastcall unsigned long native_read_cr4(void)
 {
 	unsigned long val;
 	asm volatile("movl %%cr4,%0\n\t" :"=r" (val));
 	return val;
 }
 
-static unsigned long native_read_cr4_safe(void)
+static fastcall unsigned long native_read_cr4_safe(void)
 {
 	unsigned long val;
 	/* This could fault if %cr4 does not exist */
@@ -208,51 +208,51 @@ static unsigned long native_read_cr4_safe(void)
 	return val;
 }
 
-static void native_write_cr4(unsigned long val)
+static fastcall void native_write_cr4(unsigned long val)
 {
 	asm volatile("movl %0,%%cr4": :"r" (val));
 }
 
-static unsigned long native_save_fl(void)
+static fastcall unsigned long native_save_fl(void)
 {
 	unsigned long f;
 	asm volatile("pushfl ; popl %0":"=g" (f): /* no input */);
 	return f;
 }
 
-static void native_restore_fl(unsigned long f)
+static fastcall void native_restore_fl(unsigned long f)
 {
 	asm volatile("pushl %0 ; popfl": /* no output */
 			     :"g" (f)
 			     :"memory", "cc");
 }
 
-static void native_irq_disable(void)
+static fastcall void native_irq_disable(void)
 {
 	asm volatile("cli": : :"memory");
 }
 
-static void native_irq_enable(void)
+static fastcall void native_irq_enable(void)
 {
 	asm volatile("sti": : :"memory");
 }
 
-static void native_safe_halt(void)
+static fastcall void native_safe_halt(void)
 {
 	asm volatile("sti; hlt": : :"memory");
 }
 
-static void native_halt(void)
+static fastcall void native_halt(void)
 {
 	asm volatile("hlt": : :"memory");
 }
 
-static void native_wbinvd(void)
+static fastcall void native_wbinvd(void)
 {
 	asm volatile("wbinvd": : :"memory");
 }
 
-static unsigned long long native_read_msr(unsigned int msr, int *err)
+static fastcall unsigned long long native_read_msr(unsigned int msr, int *err)
 {
 	unsigned long long val;
 
@@ -271,7 +271,7 @@ static unsigned long long native_read_msr(unsigned int msr, int *err)
 	return val;
 }
 
-static int native_write_msr(unsigned int msr, unsigned long long val)
+static fastcall int native_write_msr(unsigned int msr, unsigned long long val)
 {
 	int err;
 	asm volatile("2: wrmsr ; xorl %0,%0\n"
@@ -289,53 +289,53 @@ static int native_write_msr(unsigned int msr, unsigned long long val)
 	return err;
 }
 
-static unsigned long long native_read_tsc(void)
+static fastcall unsigned long long native_read_tsc(void)
 {
 	unsigned long long val;
 	asm volatile("rdtsc" : "=A" (val));
 	return val;
 }
 
-static unsigned long long native_read_pmc(void)
+static fastcall unsigned long long native_read_pmc(void)
 {
 	unsigned long long val;
 	asm volatile("rdpmc" : "=A" (val));
 	return val;
 }
 
-static void native_load_tr_desc(void)
+static fastcall void native_load_tr_desc(void)
 {
 	asm volatile("ltr %w0"::"q" (GDT_ENTRY_TSS*8));
 }
 
-static void native_load_gdt(const struct Xgt_desc_struct *dtr)
+static fastcall void native_load_gdt(const struct Xgt_desc_struct *dtr)
 {
 	asm volatile("lgdt %0"::"m" (*dtr));
 }
 
-static void native_load_idt(const struct Xgt_desc_struct *dtr)
+static fastcall void native_load_idt(const struct Xgt_desc_struct *dtr)
 {
 	asm volatile("lidt %0"::"m" (*dtr));
 }
 
-static void native_store_gdt(struct Xgt_desc_struct *dtr)
+static fastcall void native_store_gdt(struct Xgt_desc_struct *dtr)
 {
 	asm ("sgdt %0":"=m" (*dtr));
 }
 
-static void native_store_idt(struct Xgt_desc_struct *dtr)
+static fastcall void native_store_idt(struct Xgt_desc_struct *dtr)
 {
 	asm ("sidt %0":"=m" (*dtr));
 }
 
-static unsigned long native_store_tr(void)
+static fastcall unsigned long native_store_tr(void)
 {
 	unsigned long tr;
 	asm ("str %0":"=r" (tr));
 	return tr;
 }
 
-static void native_load_tls(struct thread_struct *t, unsigned int cpu)
+static fastcall void native_load_tls(struct thread_struct *t, unsigned int cpu)
 {
 #define C(i) get_cpu_gdt_table(cpu)[GDT_ENTRY_TLS_MIN + i] = t->tls_array[i]
 	C(0); C(1); C(2);
@@ -349,22 +349,22 @@ static inline void native_write_dt_entry(void *dt, int entry, u32 entry_low, u32
 	lp[1] = entry_high;
 }
 
-static void native_write_ldt_entry(void *dt, int entrynum, u32 low, u32 high)
+static fastcall void native_write_ldt_entry(void *dt, int entrynum, u32 low, u32 high)
 {
 	native_write_dt_entry(dt, entrynum, low, high);
 }
 
-static void native_write_gdt_entry(void *dt, int entrynum, u32 low, u32 high)
+static fastcall void native_write_gdt_entry(void *dt, int entrynum, u32 low, u32 high)
 {
 	native_write_dt_entry(dt, entrynum, low, high);
 }
 
-static void native_write_idt_entry(void *dt, int entrynum, u32 low, u32 high)
+static fastcall void native_write_idt_entry(void *dt, int entrynum, u32 low, u32 high)
 {
 	native_write_dt_entry(dt, entrynum, low, high);
 }
 
-static void native_load_esp0(struct tss_struct *tss,
+static fastcall void native_load_esp0(struct tss_struct *tss,
 				      struct thread_struct *thread)
 {
 	tss->esp0 = thread->esp0;
@@ -376,12 +376,12 @@ static void native_load_esp0(struct tss_struct *tss,
 	}
 }
 
-static void native_io_delay(void)
+static fastcall void native_io_delay(void)
 {
 	asm volatile("outb %al,$0x80");
 }
 
-static void native_flush_tlb(void)
+static fastcall void native_flush_tlb(void)
 {
 	__native_flush_tlb();
 }
@@ -390,49 +390,49 @@ static void native_flush_tlb(void)
  * Global pages have to be flushed a bit differently. Not a real
  * performance problem because this does not happen often.
  */
-static void native_flush_tlb_global(void)
+static fastcall void native_flush_tlb_global(void)
 {
 	__native_flush_tlb_global();
 }
 
-static void native_flush_tlb_single(u32 addr)
+static fastcall void native_flush_tlb_single(u32 addr)
 {
 	__native_flush_tlb_single(addr);
 }
 
 #ifndef CONFIG_X86_PAE
-static void native_set_pte(pte_t *ptep, pte_t pteval)
+static fastcall void native_set_pte(pte_t *ptep, pte_t pteval)
 {
 	*ptep = pteval;
 }
 
-static void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pteval)
+static fastcall void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pteval)
 {
 	*ptep = pteval;
 }
 
-static void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
+static fastcall void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
 	*pmdp = pmdval;
 }
 
 #else /* CONFIG_X86_PAE */
 
-static void native_set_pte(pte_t *ptep, pte_t pte)
+static fastcall void native_set_pte(pte_t *ptep, pte_t pte)
 {
 	ptep->pte_high = pte.pte_high;
 	smp_wmb();
 	ptep->pte_low = pte.pte_low;
 }
 
-static void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte)
+static fastcall void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte)
 {
 	ptep->pte_high = pte.pte_high;
 	smp_wmb();
 	ptep->pte_low = pte.pte_low;
 }
 
-static void native_set_pte_present(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
+static fastcall void native_set_pte_present(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
 {
 	ptep->pte_low = 0;
 	smp_wmb();
@@ -441,29 +441,29 @@ static void native_set_pte_present(struct mm_struct *mm, unsigned long addr, pte
 	ptep->pte_low = pte.pte_low;
 }
 
-static void native_set_pte_atomic(pte_t *ptep, pte_t pteval)
+static fastcall void native_set_pte_atomic(pte_t *ptep, pte_t pteval)
 {
 	set_64bit((unsigned long long *)ptep,pte_val(pteval));
 }
 
-static void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
+static fastcall void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
 	set_64bit((unsigned long long *)pmdp,pmd_val(pmdval));
 }
 
-static void native_set_pud(pud_t *pudp, pud_t pudval)
+static fastcall void native_set_pud(pud_t *pudp, pud_t pudval)
 {
 	*pudp = pudval;
 }
 
-static void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+static fastcall void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	ptep->pte_low = 0;
 	smp_wmb();
 	ptep->pte_high = 0;
 }
 
-static void native_pmd_clear(pmd_t *pmd)
+static fastcall void native_pmd_clear(pmd_t *pmd)
 {
 	u32 *tmp = (u32 *)pmd;
 	*tmp = 0;

