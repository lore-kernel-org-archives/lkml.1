Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbZIKUCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbZIKUCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 16:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756389AbZIKUBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 16:01:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55326 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756406AbZIKUBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 16:01:50 -0400
Date: Fri, 11 Sep 2009 22:01:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [GIT PULL] x86/xen for v2.6.32
Message-ID: <20090911200135.GA1426@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-xen-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-xen-for-linus

 Thanks,

	Ingo

------------------>
Jeremy Fitzhardinge (3):
      xen: make -fstack-protector work under Xen
      xen: only enable interrupts while actually blocking for spinlock
      x86: split __phys_addr out into separate file

Yang Xiaowei (1):
      xen: use stronger barrier after unlocking lock


 arch/x86/mm/Makefile     |    6 ++-
 arch/x86/mm/ioremap.c    |   72 +-------------------------
 arch/x86/mm/physaddr.c   |   70 ++++++++++++++++++++++++
 arch/x86/mm/physaddr.h   |   10 ++++
 arch/x86/xen/Makefile    |    2 +
 arch/x86/xen/enlighten.c |  131 +++++++++++++++++++++++++++++++++++++++-------
 arch/x86/xen/smp.c       |    1 +
 arch/x86/xen/spinlock.c  |   28 ++++++----
 drivers/xen/Makefile     |    3 +
 9 files changed, 222 insertions(+), 101 deletions(-)
 create mode 100644 arch/x86/mm/physaddr.c
 create mode 100644 arch/x86/mm/physaddr.h

diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index eefdeee..9b5a9f5 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -1,5 +1,9 @@
 obj-y	:=  init.o init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
-	    pat.o pgtable.o gup.o
+	    pat.o pgtable.o physaddr.o gup.o
+
+# Make sure __phys_addr has no stackprotector
+nostackp := $(call cc-option, -fno-stack-protector)
+CFLAGS_physaddr.o		:= $(nostackp)
 
 obj-$(CONFIG_SMP)		+= tlb.o
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 8a45093..04e1ad6 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -22,77 +22,7 @@
 #include <asm/pgalloc.h>
 #include <asm/pat.h>
 
-static inline int phys_addr_valid(resource_size_t addr)
-{
-#ifdef CONFIG_PHYS_ADDR_T_64BIT
-	return !(addr >> boot_cpu_data.x86_phys_bits);
-#else
-	return 1;
-#endif
-}
-
-#ifdef CONFIG_X86_64
-
-unsigned long __phys_addr(unsigned long x)
-{
-	if (x >= __START_KERNEL_map) {
-		x -= __START_KERNEL_map;
-		VIRTUAL_BUG_ON(x >= KERNEL_IMAGE_SIZE);
-		x += phys_base;
-	} else {
-		VIRTUAL_BUG_ON(x < PAGE_OFFSET);
-		x -= PAGE_OFFSET;
-		VIRTUAL_BUG_ON(!phys_addr_valid(x));
-	}
-	return x;
-}
-EXPORT_SYMBOL(__phys_addr);
-
-bool __virt_addr_valid(unsigned long x)
-{
-	if (x >= __START_KERNEL_map) {
-		x -= __START_KERNEL_map;
-		if (x >= KERNEL_IMAGE_SIZE)
-			return false;
-		x += phys_base;
-	} else {
-		if (x < PAGE_OFFSET)
-			return false;
-		x -= PAGE_OFFSET;
-		if (!phys_addr_valid(x))
-			return false;
-	}
-
-	return pfn_valid(x >> PAGE_SHIFT);
-}
-EXPORT_SYMBOL(__virt_addr_valid);
-
-#else
-
-#ifdef CONFIG_DEBUG_VIRTUAL
-unsigned long __phys_addr(unsigned long x)
-{
-	/* VMALLOC_* aren't constants  */
-	VIRTUAL_BUG_ON(x < PAGE_OFFSET);
-	VIRTUAL_BUG_ON(__vmalloc_start_set && is_vmalloc_addr((void *) x));
-	return x - PAGE_OFFSET;
-}
-EXPORT_SYMBOL(__phys_addr);
-#endif
-
-bool __virt_addr_valid(unsigned long x)
-{
-	if (x < PAGE_OFFSET)
-		return false;
-	if (__vmalloc_start_set && is_vmalloc_addr((void *) x))
-		return false;
-	if (x >= FIXADDR_START)
-		return false;
-	return pfn_valid((x - PAGE_OFFSET) >> PAGE_SHIFT);
-}
-EXPORT_SYMBOL(__virt_addr_valid);
-
-#endif
+#include "physaddr.h"
 
 int page_is_ram(unsigned long pagenr)
 {
diff --git a/arch/x86/mm/physaddr.c b/arch/x86/mm/physaddr.c
new file mode 100644
index 0000000..d2e2735
--- /dev/null
+++ b/arch/x86/mm/physaddr.c
@@ -0,0 +1,70 @@
+#include <linux/mmdebug.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+
+#include <asm/page.h>
+
+#include "physaddr.h"
+
+#ifdef CONFIG_X86_64
+
+unsigned long __phys_addr(unsigned long x)
+{
+	if (x >= __START_KERNEL_map) {
+		x -= __START_KERNEL_map;
+		VIRTUAL_BUG_ON(x >= KERNEL_IMAGE_SIZE);
+		x += phys_base;
+	} else {
+		VIRTUAL_BUG_ON(x < PAGE_OFFSET);
+		x -= PAGE_OFFSET;
+		VIRTUAL_BUG_ON(!phys_addr_valid(x));
+	}
+	return x;
+}
+EXPORT_SYMBOL(__phys_addr);
+
+bool __virt_addr_valid(unsigned long x)
+{
+	if (x >= __START_KERNEL_map) {
+		x -= __START_KERNEL_map;
+		if (x >= KERNEL_IMAGE_SIZE)
+			return false;
+		x += phys_base;
+	} else {
+		if (x < PAGE_OFFSET)
+			return false;
+		x -= PAGE_OFFSET;
+		if (!phys_addr_valid(x))
+			return false;
+	}
+
+	return pfn_valid(x >> PAGE_SHIFT);
+}
+EXPORT_SYMBOL(__virt_addr_valid);
+
+#else
+
+#ifdef CONFIG_DEBUG_VIRTUAL
+unsigned long __phys_addr(unsigned long x)
+{
+	/* VMALLOC_* aren't constants  */
+	VIRTUAL_BUG_ON(x < PAGE_OFFSET);
+	VIRTUAL_BUG_ON(__vmalloc_start_set && is_vmalloc_addr((void *) x));
+	return x - PAGE_OFFSET;
+}
+EXPORT_SYMBOL(__phys_addr);
+#endif
+
+bool __virt_addr_valid(unsigned long x)
+{
+	if (x < PAGE_OFFSET)
+		return false;
+	if (__vmalloc_start_set && is_vmalloc_addr((void *) x))
+		return false;
+	if (x >= FIXADDR_START)
+		return false;
+	return pfn_valid((x - PAGE_OFFSET) >> PAGE_SHIFT);
+}
+EXPORT_SYMBOL(__virt_addr_valid);
+
+#endif	/* CONFIG_X86_64 */
diff --git a/arch/x86/mm/physaddr.h b/arch/x86/mm/physaddr.h
new file mode 100644
index 0000000..a3cd5a0
--- /dev/null
+++ b/arch/x86/mm/physaddr.h
@@ -0,0 +1,10 @@
+#include <asm/processor.h>
+
+static inline int phys_addr_valid(resource_size_t addr)
+{
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+	return !(addr >> boot_cpu_data.x86_phys_bits);
+#else
+	return 1;
+#endif
+}
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 7410640..3bb4fc2 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -8,6 +8,7 @@ endif
 # Make sure early boot has no stackprotector
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_enlighten.o		:= $(nostackp)
+CFLAGS_mmu.o			:= $(nostackp)
 
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			time.o xen-asm.o xen-asm_$(BITS).o \
@@ -16,3 +17,4 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
+
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index eb33aaa..7614313 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -51,6 +51,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/reboot.h>
+#include <asm/stackprotector.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
@@ -330,18 +331,28 @@ static void xen_load_gdt(const struct desc_ptr *dtr)
 	unsigned long frames[pages];
 	int f;
 
-	/* A GDT can be up to 64k in size, which corresponds to 8192
-	   8-byte entries, or 16 4k pages.. */
+	/*
+	 * A GDT can be up to 64k in size, which corresponds to 8192
+	 * 8-byte entries, or 16 4k pages..
+	 */
 
 	BUG_ON(size > 65536);
 	BUG_ON(va & ~PAGE_MASK);
 
 	for (f = 0; va < dtr->address + size; va += PAGE_SIZE, f++) {
 		int level;
-		pte_t *ptep = lookup_address(va, &level);
+		pte_t *ptep;
 		unsigned long pfn, mfn;
 		void *virt;
 
+		/*
+		 * The GDT is per-cpu and is in the percpu data area.
+		 * That can be virtually mapped, so we need to do a
+		 * page-walk to get the underlying MFN for the
+		 * hypercall.  The page can also be in the kernel's
+		 * linear range, so we need to RO that mapping too.
+		 */
+		ptep = lookup_address(va, &level);
 		BUG_ON(ptep == NULL);
 
 		pfn = pte_pfn(*ptep);
@@ -358,6 +369,44 @@ static void xen_load_gdt(const struct desc_ptr *dtr)
 		BUG();
 }
 
+/*
+ * load_gdt for early boot, when the gdt is only mapped once
+ */
+static __init void xen_load_gdt_boot(const struct desc_ptr *dtr)
+{
+	unsigned long va = dtr->address;
+	unsigned int size = dtr->size + 1;
+	unsigned pages = (size + PAGE_SIZE - 1) / PAGE_SIZE;
+	unsigned long frames[pages];
+	int f;
+
+	/*
+	 * A GDT can be up to 64k in size, which corresponds to 8192
+	 * 8-byte entries, or 16 4k pages..
+	 */
+
+	BUG_ON(size > 65536);
+	BUG_ON(va & ~PAGE_MASK);
+
+	for (f = 0; va < dtr->address + size; va += PAGE_SIZE, f++) {
+		pte_t pte;
+		unsigned long pfn, mfn;
+
+		pfn = virt_to_pfn(va);
+		mfn = pfn_to_mfn(pfn);
+
+		pte = pfn_pte(pfn, PAGE_KERNEL_RO);
+
+		if (HYPERVISOR_update_va_mapping((unsigned long)va, pte, 0))
+			BUG();
+
+		frames[f] = mfn;
+	}
+
+	if (HYPERVISOR_set_gdt(frames, size / sizeof(struct desc_struct)))
+		BUG();
+}
+
 static void load_TLS_descriptor(struct thread_struct *t,
 				unsigned int cpu, unsigned int i)
 {
@@ -581,6 +630,29 @@ static void xen_write_gdt_entry(struct desc_struct *dt, int entry,
 	preempt_enable();
 }
 
+/*
+ * Version of write_gdt_entry for use at early boot-time needed to
+ * update an entry as simply as possible.
+ */
+static __init void xen_write_gdt_entry_boot(struct desc_struct *dt, int entry,
+					    const void *desc, int type)
+{
+	switch (type) {
+	case DESC_LDT:
+	case DESC_TSS:
+		/* ignore */
+		break;
+
+	default: {
+		xmaddr_t maddr = virt_to_machine(&dt[entry]);
+
+		if (HYPERVISOR_update_descriptor(maddr.maddr, *(u64 *)desc))
+			dt[entry] = *(struct desc_struct *)desc;
+	}
+
+	}
+}
+
 static void xen_load_sp0(struct tss_struct *tss,
 			 struct thread_struct *thread)
 {
@@ -965,6 +1037,23 @@ static const struct machine_ops __initdata xen_machine_ops = {
 	.emergency_restart = xen_emergency_restart,
 };
 
+/*
+ * Set up the GDT and segment registers for -fstack-protector.  Until
+ * we do this, we have to be careful not to call any stack-protected
+ * function, which is most of the kernel.
+ */
+static void __init xen_setup_stackprotector(void)
+{
+	pv_cpu_ops.write_gdt_entry = xen_write_gdt_entry_boot;
+	pv_cpu_ops.load_gdt = xen_load_gdt_boot;
+
+	setup_stack_canary_segment(0);
+	switch_to_new_gdt(0);
+
+	pv_cpu_ops.write_gdt_entry = xen_write_gdt_entry;
+	pv_cpu_ops.load_gdt = xen_load_gdt;
+}
+
 /* First C function to be called on Xen boot */
 asmlinkage void __init xen_start_kernel(void)
 {
@@ -983,13 +1072,28 @@ asmlinkage void __init xen_start_kernel(void)
 	pv_apic_ops = xen_apic_ops;
 	pv_mmu_ops = xen_mmu_ops;
 
-#ifdef CONFIG_X86_64
 	/*
-	 * Setup percpu state.  We only need to do this for 64-bit
-	 * because 32-bit already has %fs set properly.
+	 * Set up some pagetable state before starting to set any ptes.
 	 */
-	load_percpu_segment(0);
-#endif
+
+	/* Prevent unwanted bits from being set in PTEs. */
+	__supported_pte_mask &= ~_PAGE_GLOBAL;
+	if (!xen_initial_domain())
+		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
+
+	__supported_pte_mask |= _PAGE_IOMAP;
+
+	xen_setup_features();
+
+	/* Get mfn list */
+	if (!xen_feature(XENFEAT_auto_translated_physmap))
+		xen_build_dynamic_phys_to_machine();
+
+	/*
+	 * Set up kernel GDT and segment registers, mainly so that
+	 * -fstack-protector code can be executed.
+	 */
+	xen_setup_stackprotector();
 
 	xen_init_irq_ops();
 	xen_init_cpuid_mask();
@@ -1001,8 +1105,6 @@ asmlinkage void __init xen_start_kernel(void)
 	set_xen_basic_apic_ops();
 #endif
 
-	xen_setup_features();
-
 	if (xen_feature(XENFEAT_mmu_pt_update_preserve_ad)) {
 		pv_mmu_ops.ptep_modify_prot_start = xen_ptep_modify_prot_start;
 		pv_mmu_ops.ptep_modify_prot_commit = xen_ptep_modify_prot_commit;
@@ -1019,17 +1121,8 @@ asmlinkage void __init xen_start_kernel(void)
 
 	xen_smp_init();
 
-	/* Get mfn list */
-	if (!xen_feature(XENFEAT_auto_translated_physmap))
-		xen_build_dynamic_phys_to_machine();
-
 	pgd = (pgd_t *)xen_start_info->pt_base;
 
-	/* Prevent unwanted bits from being set in PTEs. */
-	__supported_pte_mask &= ~_PAGE_GLOBAL;
-	if (!xen_initial_domain())
-		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
-
 #ifdef CONFIG_X86_64
 	/* Work out if we support NX */
 	check_efer();
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 429834e..fe03eee 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -236,6 +236,7 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	ctxt->user_regs.ss = __KERNEL_DS;
 #ifdef CONFIG_X86_32
 	ctxt->user_regs.fs = __KERNEL_PERCPU;
+	ctxt->user_regs.gs = __KERNEL_STACK_CANARY;
 #else
 	ctxt->gs_base_kernel = per_cpu_offset(cpu);
 #endif
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 5601506..36a5141 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -187,7 +187,6 @@ static noinline int xen_spin_lock_slow(struct raw_spinlock *lock, bool irq_enabl
 	struct xen_spinlock *prev;
 	int irq = __get_cpu_var(lock_kicker_irq);
 	int ret;
-	unsigned long flags;
 	u64 start;
 
 	/* If kicker interrupts not initialized yet, just spin */
@@ -199,16 +198,12 @@ static noinline int xen_spin_lock_slow(struct raw_spinlock *lock, bool irq_enabl
 	/* announce we're spinning */
 	prev = spinning_lock(xl);
 
-	flags = __raw_local_save_flags();
-	if (irq_enable) {
-		ADD_STATS(taken_slow_irqenable, 1);
-		raw_local_irq_enable();
-	}
-
 	ADD_STATS(taken_slow, 1);
 	ADD_STATS(taken_slow_nested, prev != NULL);
 
 	do {
+		unsigned long flags;
+
 		/* clear pending */
 		xen_clear_irq_pending(irq);
 
@@ -228,6 +223,12 @@ static noinline int xen_spin_lock_slow(struct raw_spinlock *lock, bool irq_enabl
 			goto out;
 		}
 
+		flags = __raw_local_save_flags();
+		if (irq_enable) {
+			ADD_STATS(taken_slow_irqenable, 1);
+			raw_local_irq_enable();
+		}
+
 		/*
 		 * Block until irq becomes pending.  If we're
 		 * interrupted at this point (after the trylock but
@@ -238,13 +239,15 @@ static noinline int xen_spin_lock_slow(struct raw_spinlock *lock, bool irq_enabl
 		 * pending.
 		 */
 		xen_poll_irq(irq);
+
+		raw_local_irq_restore(flags);
+
 		ADD_STATS(taken_slow_spurious, !xen_test_irq_pending(irq));
 	} while (!xen_test_irq_pending(irq)); /* check for spurious wakeups */
 
 	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
 
 out:
-	raw_local_irq_restore(flags);
 	unspinning_lock(xl, prev);
 	spin_time_accum_blocked(start);
 
@@ -323,8 +326,13 @@ static void xen_spin_unlock(struct raw_spinlock *lock)
 	smp_wmb();		/* make sure no writes get moved after unlock */
 	xl->lock = 0;		/* release lock */
 
-	/* make sure unlock happens before kick */
-	barrier();
+	/*
+	 * Make sure unlock happens before checking for waiting
+	 * spinners.  We need a strong barrier to enforce the
+	 * write-read ordering to different memory locations, as the
+	 * CPU makes no implied guarantees about their ordering.
+	 */
+	mb();
 
 	if (unlikely(xl->spinners))
 		xen_spin_unlock_slow(xl);
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index ec2a39b..7c28434 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,6 +1,9 @@
 obj-y	+= grant-table.o features.o events.o manage.o
 obj-y	+= xenbus/
 
+nostackp := $(call cc-option, -fno-stack-protector)
+CFLAGS_features.o			:= $(nostackp)
+
 obj-$(CONFIG_HOTPLUG_CPU)	+= cpu_hotplug.o
 obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
 obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
