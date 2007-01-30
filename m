Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbXA3BLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbXA3BLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 20:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbXA3BLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 20:11:46 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47375 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752632AbXA3BLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 20:11:44 -0500
Date: Tue, 30 Jan 2007 02:11:45 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@osdl.org>, Zachary Amsden <zach@vmware.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] vmi: cleanups
Message-ID: <20070130011145.GA3754@stusta.de>
References: <20070127234928.64d8e437.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070127234928.64d8e437.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make needlessly global code static
- remove pointless fastcall annotations
- don't mark functions in C files as inline
- #if 0 the following unused function:
  - arch/i386/kernel/vmitime.c: read_stolen_cycles()

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/i386/kernel/vmi.c      |   89 ++++++++++++++++++------------------
 arch/i386/kernel/vmitime.c  |   39 ++++++++-------
 include/asm-i386/vmi_time.h |   14 ++---
 3 files changed, 72 insertions(+), 70 deletions(-)

--- linux-2.6.20-rc6-mm1/include/asm-i386/vmi_time.h.old	2007-01-28 20:27:42.000000000 +0100
+++ linux-2.6.20-rc6-mm1/include/asm-i386/vmi_time.h	2007-01-28 20:27:48.000000000 +0100
@@ -37,12 +37,12 @@
 
 /* Cached VMI timer operations */
 extern struct vmi_timer_ops {
-	u64 (fastcall *get_cycle_frequency)(void);
-	u64 (fastcall *get_cycle_counter)(int);
-	u64 (fastcall *get_wallclock)(void);
-	int (fastcall *wallclock_updated)(void);
-	void (fastcall *set_alarm)(u32 flags, u64 expiry, u64 period);
-	void (fastcall *cancel_alarm)(u32 flags);
+	u64 (*get_cycle_frequency)(void);
+	u64 (*get_cycle_counter)(int);
+	u64 (*get_wallclock)(void);
+	int (*wallclock_updated)(void);
+	void (*set_alarm)(u32 flags, u64 expiry, u64 period);
+	void (*cancel_alarm)(u32 flags);
 } vmi_timer_ops;
 
 /* Prototypes */
@@ -54,7 +54,7 @@
 #ifdef CONFIG_X86_LOCAL_APIC
 extern void __init vmi_timer_setup_boot_alarm(void);
 extern void __init vmi_timer_setup_secondary_alarm(void);
-extern fastcall void apic_vmi_timer_interrupt(void);
+extern void apic_vmi_timer_interrupt(void);
 #endif
 
 #ifdef CONFIG_NO_IDLE_HZ
--- linux-2.6.20-rc6-mm1/arch/i386/kernel/vmi.c.old	2007-01-28 20:15:42.000000000 +0100
+++ linux-2.6.20-rc6-mm1/arch/i386/kernel/vmi.c	2007-01-28 20:22:15.000000000 +0100
@@ -56,19 +56,19 @@
 static int disable_mtrr;
 
 /* Cached VMI operations */
-struct {
-	void (fastcall *cpuid)(void /* non-c */);
-	void (fastcall *_set_ldt)(u32 selector);
-	void (fastcall *set_tr)(u32 selector);
-	void (fastcall *set_kernel_stack)(u32 selector, u32 esp0);
-	void (fastcall *allocate_page)(u32, u32, u32, u32, u32);
-	void (fastcall *release_page)(u32, u32);
-	void (fastcall *set_pte)(pte_t, pte_t *, unsigned);
-	void (fastcall *update_pte)(pte_t *, unsigned);
-	void (fastcall *set_linear_mapping)(int, u32, u32, u32);
-	void (fastcall *flush_tlb)(int);
-	void (fastcall *set_initial_ap_state)(int, int);
-	void (fastcall *halt)(void);
+static struct {
+	void (*cpuid)(void /* non-c */);
+	void (*_set_ldt)(u32 selector);
+	void (*set_tr)(u32 selector);
+	void (*set_kernel_stack)(u32 selector, u32 esp0);
+	void (*allocate_page)(u32, u32, u32, u32, u32);
+	void (*release_page)(u32, u32);
+	void (*set_pte)(pte_t, pte_t *, unsigned);
+	void (*update_pte)(pte_t *, unsigned);
+	void (*set_linear_mapping)(int, u32, u32, u32);
+	void (*flush_tlb)(int);
+	void (*set_initial_ap_state)(int, int);
+	void (*halt)(void);
 } vmi_ops;
 
 /* XXX move this to alternative.h */
@@ -90,7 +90,7 @@
 #define IRQ_PATCH_INT_MASK 0
 #define IRQ_PATCH_DISABLE  5
 
-static inline void patch_offset(unsigned char *eip, unsigned char *dest)
+static void patch_offset(unsigned char *eip, unsigned char *dest)
 {
         *(unsigned long *)(eip+1) = dest-eip-5;
 }
@@ -169,8 +169,8 @@
 }
 
 /* CPUID has non-C semantics, and paravirt-ops API doesn't match hardware ISA */
-static fastcall void vmi_cpuid(unsigned int *eax, unsigned int *ebx,
-                               unsigned int *ecx, unsigned int *edx)
+static void vmi_cpuid(unsigned int *eax, unsigned int *ebx,
+		      unsigned int *ecx, unsigned int *edx)
 {
 	int override = 0;
 	if (*eax == 1)
@@ -195,13 +195,14 @@
 	}
 }
 
-static inline void vmi_maybe_load_tls(struct desc_struct *gdt, int nr, struct desc_struct *new)
+static void vmi_maybe_load_tls(struct desc_struct *gdt, int nr,
+			       struct desc_struct *new)
 {
 	if (gdt[nr].a != new->a || gdt[nr].b != new->b)
 		write_gdt_entry(gdt, nr, new->a, new->b);
 }
 
-static fastcall void vmi_load_tls(struct thread_struct *t, unsigned int cpu)
+static void vmi_load_tls(struct thread_struct *t, unsigned int cpu)
 {
 	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
 	vmi_maybe_load_tls(gdt, GDT_ENTRY_TLS_MIN + 0, &t->tls_array[0]);
@@ -209,7 +210,7 @@
 	vmi_maybe_load_tls(gdt, GDT_ENTRY_TLS_MIN + 2, &t->tls_array[2]);
 }
 
-static fastcall void vmi_set_ldt(const void *addr, unsigned entries)
+static void vmi_set_ldt(const void *addr, unsigned entries)
 {
 	unsigned cpu = smp_processor_id();
 	u32 low, high;
@@ -221,13 +222,13 @@
 	vmi_ops._set_ldt(entries ? GDT_ENTRY_LDT*sizeof(struct desc_struct) : 0);
 }
 
-static fastcall void vmi_set_tr(void)
+static void vmi_set_tr(void)
 {
 	vmi_ops.set_tr(GDT_ENTRY_TSS*sizeof(struct desc_struct));
 }
 
-static fastcall void vmi_load_esp0(struct tss_struct *tss,
-				   struct thread_struct *thread)
+static void vmi_load_esp0(struct tss_struct *tss,
+			  struct thread_struct *thread)
 {
 	tss->esp0 = thread->esp0;
 
@@ -239,12 +240,12 @@
 	vmi_ops.set_kernel_stack(__KERNEL_DS, tss->esp0);
 }
 
-static fastcall void vmi_flush_tlb_user(void)
+static void vmi_flush_tlb_user(void)
 {
 	vmi_ops.flush_tlb(VMI_FLUSH_TLB);
 }
 
-static fastcall void vmi_flush_tlb_kernel(void)
+static void vmi_flush_tlb_kernel(void)
 {
 	vmi_ops.flush_tlb(VMI_FLUSH_TLB | VMI_FLUSH_GLOBAL);
 }
@@ -256,7 +257,7 @@
 
 /* For NO_IDLE_HZ, we stop the clock when halting the kernel */
 #ifdef CONFIG_NO_IDLE_HZ
-static fastcall void vmi_safe_halt(void)
+static void vmi_safe_halt(void)
 {
 	int idle = vmi_stop_hz_timer();
 	vmi_ops.halt();
@@ -371,13 +372,13 @@
 #define vmi_check_page_type(p,t) do { } while (0)
 #endif
 
-static fastcall void vmi_allocate_pt(u32 pfn)
+static void vmi_allocate_pt(u32 pfn)
 {
 	vmi_set_page_type(pfn, VMI_PAGE_L1);
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L1, 0, 0, 0);
 }
 
-static fastcall void vmi_allocate_pd(u32 pfn)
+static void vmi_allocate_pd(u32 pfn)
 {
  	/*
 	 * This call comes in very early, before mem_map is setup.
@@ -388,20 +389,20 @@
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L2, 0, 0, 0);
 }
 
-static fastcall void vmi_allocate_pd_clone(u32 pfn, u32 clonepfn, u32 start, u32 count)
+static void vmi_allocate_pd_clone(u32 pfn, u32 clonepfn, u32 start, u32 count)
 {
  	vmi_set_page_type(pfn, VMI_PAGE_L2 | VMI_PAGE_CLONE);
 	vmi_check_page_type(clonepfn, VMI_PAGE_L2);
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L2 | VMI_PAGE_CLONE, clonepfn, start, count);
 }
 
-static fastcall void vmi_release_pt(u32 pfn)
+static void vmi_release_pt(u32 pfn)
 {
 	vmi_ops.release_page(pfn, VMI_PAGE_L1);
 	vmi_set_page_type(pfn, VMI_PAGE_NORMAL);
 }
 
-static fastcall void vmi_release_pd(u32 pfn)
+static void vmi_release_pd(u32 pfn)
 {
 	vmi_ops.release_page(pfn, VMI_PAGE_L2);
 	vmi_set_page_type(pfn, VMI_PAGE_NORMAL);
@@ -426,32 +427,32 @@
         ((level) | (is_current_as(mm, user) ?                           \
                 (VMI_PAGE_DEFER | VMI_PAGE_CURRENT_AS | ((addr) & VMI_PAGE_VA_MASK)) : 0))
 
-static fastcall void vmi_update_pte(struct mm_struct *mm, u32 addr, pte_t *ptep)
+static void vmi_update_pte(struct mm_struct *mm, u32 addr, pte_t *ptep)
 {
 	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE);
 	vmi_ops.update_pte(ptep, vmi_flags_addr(mm, addr, VMI_PAGE_PT, 0));
 }
 
-static fastcall void vmi_update_pte_defer(struct mm_struct *mm, u32 addr, pte_t *ptep)
+static void vmi_update_pte_defer(struct mm_struct *mm, u32 addr, pte_t *ptep)
 {
 	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE);
 	vmi_ops.update_pte(ptep, vmi_flags_addr_defer(mm, addr, VMI_PAGE_PT, 0));
 }
 
-static fastcall void vmi_set_pte(pte_t *ptep, pte_t pte)
+static void vmi_set_pte(pte_t *ptep, pte_t pte)
 {
 	/* XXX because of set_pmd_pte, this can be called on PT or PD layers */
 	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE | VMI_PAGE_PD);
 	vmi_ops.set_pte(pte, ptep, VMI_PAGE_PT);
 }
 
-static fastcall void vmi_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte)
+static void vmi_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte)
 {
 	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE);
 	vmi_ops.set_pte(pte, ptep, vmi_flags_addr(mm, addr, VMI_PAGE_PT, 0));
 }
 
-static fastcall void vmi_set_pmd(pmd_t *pmdp, pmd_t pmdval)
+static void vmi_set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
 #ifdef CONFIG_X86_PAE
 	const pte_t pte = { pmdval.pmd, pmdval.pmd >> 32 };
@@ -465,7 +466,7 @@
 
 #ifdef CONFIG_X86_PAE
 
-static fastcall void vmi_set_pte_atomic(pte_t *ptep, pte_t pteval)
+static void vmi_set_pte_atomic(pte_t *ptep, pte_t pteval)
 {
 	/*
 	 * XXX This is called from set_pmd_pte, but at both PT
@@ -478,13 +479,13 @@
 	vmi_ops.update_pte(ptep, VMI_PAGE_PT);
 }
 
-static fastcall void vmi_set_pte_present(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
+static void vmi_set_pte_present(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
 {
 	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE);
 	vmi_ops.set_pte(pte, ptep, vmi_flags_addr_defer(mm, addr, VMI_PAGE_PT, 1));
 }
 
-static fastcall void vmi_set_pud(pud_t *pudp, pud_t pudval)
+static void vmi_set_pud(pud_t *pudp, pud_t pudval)
 {
 	/* Um, eww */
 	const pte_t pte = { pudval.pgd.pgd, pudval.pgd.pgd >> 32 };
@@ -492,14 +493,14 @@
 	vmi_ops.set_pte(pte, (pte_t *)pudp, VMI_PAGE_PDP);
 }
 
-static fastcall void vmi_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+static void vmi_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	const pte_t pte = { 0 };
 	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE);
 	vmi_ops.set_pte(pte, ptep, vmi_flags_addr(mm, addr, VMI_PAGE_PT, 0));
 }
 
-fastcall void vmi_pmd_clear(pmd_t *pmd)
+static void vmi_pmd_clear(pmd_t *pmd)
 {
 	const pte_t pte = { 0 };
 	vmi_check_page_type(__pa(pmd) >> PAGE_SHIFT, VMI_PAGE_PMD);
@@ -511,7 +512,7 @@
 struct vmi_ap_state ap;
 extern void setup_pda(void);
 
-static fastcall void __init /* XXX cpu hotplug */
+static void __init /* XXX cpu hotplug */
 vmi_startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 		     unsigned long start_esp)
 {
@@ -557,7 +558,7 @@
 }
 #endif
 
-static inline int __init check_vmi_rom(struct vrom_header *rom)
+static int __init check_vmi_rom(struct vrom_header *rom)
 {
 	struct pci_header *pci;
 	struct pnp_header *pnp;
@@ -623,7 +624,7 @@
 /*
  * Probe for the VMI option ROM
  */
-static inline int __init probe_vmi_rom(void)
+static int __init probe_vmi_rom(void)
 {
 	unsigned long base;
 
@@ -681,7 +682,7 @@
 /*
  * Activate the VMI interface and switch into paravirtualized mode
  */
-static inline int __init activate_vmi(void)
+static int __init activate_vmi(void)
 {
 	short kernel_cs;
 	u64 reloc;
--- linux-2.6.20-rc6-mm1/arch/i386/kernel/vmitime.c.old	2007-01-28 20:18:02.000000000 +0100
+++ linux-2.6.20-rc6-mm1/arch/i386/kernel/vmitime.c	2007-01-28 23:28:50.000000000 +0100
@@ -65,8 +65,8 @@
 int sysctl_hz_timer;
 
 /* Some stats */
-DEFINE_PER_CPU(unsigned long, vmi_idle_no_hz_irqs);
-DEFINE_PER_CPU(unsigned long, vmi_idle_no_hz_jiffies);
+static DEFINE_PER_CPU(unsigned long, vmi_idle_no_hz_irqs);
+static DEFINE_PER_CPU(unsigned long, vmi_idle_no_hz_jiffies);
 static DEFINE_PER_CPU(unsigned long, idle_start_jiffies);
 
 #endif /* CONFIG_NO_IDLE_HZ */
@@ -91,20 +91,22 @@
 static DEFINE_PER_CPU(unsigned long long, stolen_cycles_accounted_cpu);
 
 /* Clock source. */
-static inline cycle_t read_real_cycles(void)
+static cycle_t read_real_cycles(void)
 {
 	return vmi_timer_ops.get_cycle_counter(VMI_CYCLES_REAL);
 }
 
-static inline cycle_t read_available_cycles(void)
+static cycle_t read_available_cycles(void)
 {
 	return vmi_timer_ops.get_cycle_counter(VMI_CYCLES_AVAILABLE);
 }
 
-static inline cycle_t read_stolen_cycles(void)
+#if 0
+static cycle_t read_stolen_cycles(void)
 {
 	return vmi_timer_ops.get_cycle_counter(VMI_CYCLES_STOLEN);
 }
+#endif  /*  0  */
 
 static struct clocksource clocksource_vmi = {
 	.name			= "vmi-timer",
@@ -120,7 +122,7 @@
 /* Timer interrupt handler. */
 static irqreturn_t vmi_timer_interrupt(int irq, void *dev_id);
 
-struct irqaction vmi_timer_irq  = {
+static struct irqaction vmi_timer_irq  = {
 	.handler = vmi_timer_interrupt,
 	.flags = IRQF_DISABLED,
 	.mask = CPU_MASK_NONE,
@@ -141,7 +143,7 @@
 
 
 /* Initialization */
-static inline void vmi_get_wallclock_ts(struct timespec *ts)
+static void vmi_get_wallclock_ts(struct timespec *ts)
 {
 	unsigned long long wallclock;
 	wallclock = vmi_timer_ops.get_wallclock(); // nsec units
@@ -149,7 +151,7 @@
 	ts->tv_sec = wallclock;
 }
 
-static inline void update_xtime_from_wallclock(void)
+static void update_xtime_from_wallclock(void)
 {
 	struct timespec ts;
 	vmi_get_wallclock_ts(&ts);
@@ -260,7 +262,7 @@
 #endif
 
 /* Update system wide (real) time accounting (e.g. jiffies, xtime). */
-static inline void vmi_account_real_cycles(unsigned long long cur_real_cycles)
+static void vmi_account_real_cycles(unsigned long long cur_real_cycles)
 {
 	long long cycles_not_accounted;
 
@@ -282,9 +284,8 @@
 }
 
 /* Update per-cpu process times. */
-static inline void vmi_account_process_times_cycles(struct pt_regs *regs,
-						    int cpu,
-						    unsigned long long cur_process_times_cycles)
+static void vmi_account_process_times_cycles(struct pt_regs *regs, int cpu,
+					     unsigned long long cur_process_times_cycles)
 {
 	long long cycles_not_accounted;
 	cycles_not_accounted = cur_process_times_cycles -
@@ -305,8 +306,8 @@
 
 #ifdef CONFIG_NO_IDLE_HZ
 /* Update per-cpu idle times.  Used when a no-hz halt is ended. */
-static inline void vmi_account_no_hz_idle_cycles(int cpu,
-						 unsigned long long cur_process_times_cycles)
+static void vmi_account_no_hz_idle_cycles(int cpu,
+					  unsigned long long cur_process_times_cycles)
 {
 	long long cycles_not_accounted;
 	unsigned long no_idle_hz_jiffies = 0;
@@ -325,9 +326,9 @@
 #endif
 
 /* Update per-cpu stolen time. */
-static inline void vmi_account_stolen_cycles(int cpu,
-					     unsigned long long cur_real_cycles,
-					     unsigned long long cur_avail_cycles)
+static void vmi_account_stolen_cycles(int cpu,
+				      unsigned long long cur_real_cycles,
+				      unsigned long long cur_avail_cycles)
 {
 	long long stolen_cycles_not_accounted;
 	unsigned long stolen_jiffies = 0;
@@ -410,7 +411,7 @@
 	return idle;
 }
 
-static inline void vmi_reenable_hz_timer(int cpu)
+static void vmi_reenable_hz_timer(int cpu)
 {
 	/* For /proc/vmi/info idle_hz stat. */
 	per_cpu(vmi_idle_no_hz_jiffies, cpu) += jiffies - per_cpu(idle_start_jiffies, cpu);
@@ -462,7 +463,7 @@
 /* SMP VMI-timer alarm interrupt handler. Handler for LVTT vector.
  * Also used in UP when CONFIG_X86_LOCAL_APIC.
  * The wrapper code is from arch/i386/kernel/apic.c#smp_apic_timer_interrupt. */
-fastcall void smp_apic_vmi_timer_interrupt(struct pt_regs *regs)
+void smp_apic_vmi_timer_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	int cpu = smp_processor_id();

