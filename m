Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbYDDSnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbYDDSnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 14:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757449AbYDDSnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 14:43:42 -0400
Received: from www.tglx.de ([62.245.132.106]:49085 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235AbYDDSnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 14:43:41 -0400
Date: Fri, 4 Apr 2008 20:42:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 fixes for 2.6.25
Message-ID: <alpine.LFD.1.10.0804042019210.3224@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git for-linus

The scoop is:
    - nmi watchdog fixes
    - xen fixes
    - agpgart remove confusing printk noise
    - vsmp irq ops fix
    - revert of the hpet irq assignement patch (regression)
    - tsc time going backwards fix

Note, there are non x86 parts:

1) drivers/char/hpet.c
   include/linux/hpet.h

   due to the revert of the HPET irq assignemt, which was only affects x86.

2) drivers/xen/grant-table.c

   on request of Jeremy as this fix is related to the other x86 xen fixes.

Thanks,
	tglx

------------------>
Ingo Molnar (2):
      x86: fix nmi_watchdog=2 on Pentium-D CPUs
      x86: print message if nmi_watchdog=2 cannot be enabled

Mark McLoughlin (3):
      xen: refactor xen_{alloc,release}_{pt,pd}()
      xen: Do not pin/unpin PMD pages
      xen: Clear PG_pinned in release_{pt,pd}()

Michael Abd-El-Malek (1):
      xen: fix grant table bug

Pavel Machek (1):
      x86, agpgart: scary messages are fortunately obsolete

Ravikiran G Thirumalai (1):
      x86: fix breakage of vSMP irq operations

Thomas Gleixner (2):
      x86: tsc prevent time going backwards
      x86: revert assign IRQs to hpet timer

 arch/x86/kernel/cpu/perfctr-watchdog.c |    7 ++--
 arch/x86/kernel/hpet.c                 |    9 ++++--
 arch/x86/kernel/pci-gart_64.c          |   10 +++---
 arch/x86/kernel/tsc_32.c               |   15 +++++++++-
 arch/x86/kernel/tsc_64.c               |   23 ++++++++++++--
 arch/x86/xen/enlighten.c               |   29 +++++++++++++-----
 arch/x86/xen/mmu.c                     |    7 ----
 arch/x86/xen/mmu.h                     |    7 ++++
 drivers/char/hpet.c                    |   51 ++++---------------------------
 drivers/xen/grant-table.c              |   16 ++++++----
 include/asm-x86/irqflags.h             |   29 ++++++++++++++++++
 include/linux/hpet.h                   |    2 +-
 12 files changed, 123 insertions(+), 82 deletions(-)

diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index 9b83832..b943e10 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -652,9 +652,6 @@ static void probe_nmi_watchdog(void)
 			wd_ops = &p6_wd_ops;
 			break;
 		case 15:
-			if (boot_cpu_data.x86_model > 0x4)
-				return;
-
 			wd_ops = &p4_wd_ops;
 			break;
 		default:
@@ -670,8 +667,10 @@ int lapic_watchdog_init(unsigned nmi_hz)
 {
 	if (!wd_ops) {
 		probe_nmi_watchdog();
-		if (!wd_ops)
+		if (!wd_ops) {
+			printk(KERN_INFO "NMI watchdog: CPU not supported\n");
 			return -1;
+		}
 
 		if (!wd_ops->reserve()) {
 			printk(KERN_ERR
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 235fd6c..36652ea 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -133,13 +133,16 @@ static void hpet_reserve_platform_timers(unsigned long id)
 #ifdef CONFIG_HPET_EMULATE_RTC
 	hpet_reserve_timer(&hd, 1);
 #endif
+
 	hd.hd_irq[0] = HPET_LEGACY_8254;
 	hd.hd_irq[1] = HPET_LEGACY_RTC;
 
-       for (i = 2; i < nrtimers; timer++, i++)
-	       hd.hd_irq[i] = (timer->hpet_config & Tn_INT_ROUTE_CNF_MASK) >>
-		       Tn_INT_ROUTE_CNF_SHIFT;
+	for (i = 2; i < nrtimers; timer++, i++)
+		hd.hd_irq[i] = (timer->hpet_config & Tn_INT_ROUTE_CNF_MASK) >>
+			Tn_INT_ROUTE_CNF_SHIFT;
+
 	hpet_alloc(&hd);
+
 }
 #else
 static void hpet_reserve_platform_timers(unsigned long id) { }
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index faf3229..700e464 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -615,8 +615,8 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 
  nommu:
 	/* Should not happen anymore */
-	printk(KERN_ERR "PCI-DMA: More than 4GB of RAM and no IOMMU\n"
-	       KERN_ERR "PCI-DMA: 32bit PCI IO may malfunction.\n");
+	printk(KERN_WARNING "PCI-DMA: More than 4GB of RAM and no IOMMU\n"
+	       KERN_WARNING "falling back to iommu=soft.\n");
 	return -1;
 }
 
@@ -692,9 +692,9 @@ void __init gart_iommu_init(void)
 	    !gart_iommu_aperture ||
 	    (no_agp && init_k8_gatt(&info) < 0)) {
 		if (end_pfn > MAX_DMA32_PFN) {
-			printk(KERN_ERR "WARNING more than 4GB of memory "
-					"but GART IOMMU not available.\n"
-			       KERN_ERR "WARNING 32bit PCI may malfunction.\n");
+			printk(KERN_WARNING "More than 4GB of memory "
+			       	          "but GART IOMMU not available.\n"
+			       KERN_WARNING "falling back to iommu=soft.\n");
 		}
 		return;
 	}
diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index f14cfd9..d7498b3 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -287,14 +287,27 @@ core_initcall(cpufreq_tsc);
 /* clock source code */
 
 static unsigned long current_tsc_khz = 0;
+static struct clocksource clocksource_tsc;
 
+/*
+ * We compare the TSC to the cycle_last value in the clocksource
+ * structure to avoid a nasty time-warp issue. This can be observed in
+ * a very small window right after one CPU updated cycle_last under
+ * xtime lock and the other CPU reads a TSC value which is smaller
+ * than the cycle_last reference value due to a TSC which is slighty
+ * behind. This delta is nowhere else observable, but in that case it
+ * results in a forward time jump in the range of hours due to the
+ * unsigned delta calculation of the time keeping core code, which is
+ * necessary to support wrapping clocksources like pm timer.
+ */
 static cycle_t read_tsc(void)
 {
 	cycle_t ret;
 
 	rdtscll(ret);
 
-	return ret;
+	return ret >= clocksource_tsc.cycle_last ?
+		ret : clocksource_tsc.cycle_last;
 }
 
 static struct clocksource clocksource_tsc = {
diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index 947554d..01fc9f0 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -11,6 +11,7 @@
 #include <asm/hpet.h>
 #include <asm/timex.h>
 #include <asm/timer.h>
+#include <asm/vgtod.h>
 
 static int notsc __initdata = 0;
 
@@ -290,18 +291,34 @@ int __init notsc_setup(char *s)
 
 __setup("notsc", notsc_setup);
 
+static struct clocksource clocksource_tsc;
 
-/* clock source code: */
+/*
+ * We compare the TSC to the cycle_last value in the clocksource
+ * structure to avoid a nasty time-warp. This can be observed in a
+ * very small window right after one CPU updated cycle_last under
+ * xtime/vsyscall_gtod lock and the other CPU reads a TSC value which
+ * is smaller than the cycle_last reference value due to a TSC which
+ * is slighty behind. This delta is nowhere else observable, but in
+ * that case it results in a forward time jump in the range of hours
+ * due to the unsigned delta calculation of the time keeping core
+ * code, which is necessary to support wrapping clocksources like pm
+ * timer.
+ */
 static cycle_t read_tsc(void)
 {
 	cycle_t ret = (cycle_t)get_cycles();
-	return ret;
+
+	return ret >= clocksource_tsc.cycle_last ?
+		ret : clocksource_tsc.cycle_last;
 }
 
 static cycle_t __vsyscall_fn vread_tsc(void)
 {
 	cycle_t ret = (cycle_t)vget_cycles();
-	return ret;
+
+	return ret >= __vsyscall_gtod_data.clock.cycle_last ?
+		ret : __vsyscall_gtod_data.clock.cycle_last;
 }
 
 static struct clocksource clocksource_tsc = {
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index de4e6f0..27ee26a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -667,10 +667,10 @@ static void xen_release_pt_init(u32 pfn)
 	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 }
 
-static void pin_pagetable_pfn(unsigned level, unsigned long pfn)
+static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
 {
 	struct mmuext_op op;
-	op.cmd = level;
+	op.cmd = cmd;
 	op.arg1.mfn = pfn_to_mfn(pfn);
 	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
 		BUG();
@@ -687,7 +687,8 @@ static void xen_alloc_ptpage(struct mm_struct *mm, u32 pfn, unsigned level)
 
 		if (!PageHighMem(page)) {
 			make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
-			pin_pagetable_pfn(level, pfn);
+			if (level == PT_PTE)
+				pin_pagetable_pfn(MMUEXT_PIN_L1_TABLE, pfn);
 		} else
 			/* make sure there are no stray mappings of
 			   this page */
@@ -697,27 +698,39 @@ static void xen_alloc_ptpage(struct mm_struct *mm, u32 pfn, unsigned level)
 
 static void xen_alloc_pt(struct mm_struct *mm, u32 pfn)
 {
-	xen_alloc_ptpage(mm, pfn, MMUEXT_PIN_L1_TABLE);
+	xen_alloc_ptpage(mm, pfn, PT_PTE);
 }
 
 static void xen_alloc_pd(struct mm_struct *mm, u32 pfn)
 {
-	xen_alloc_ptpage(mm, pfn, MMUEXT_PIN_L2_TABLE);
+	xen_alloc_ptpage(mm, pfn, PT_PMD);
 }
 
 /* This should never happen until we're OK to use struct page */
-static void xen_release_pt(u32 pfn)
+static void xen_release_ptpage(u32 pfn, unsigned level)
 {
 	struct page *page = pfn_to_page(pfn);
 
 	if (PagePinned(page)) {
 		if (!PageHighMem(page)) {
-			pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
+			if (level == PT_PTE)
+				pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
 			make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 		}
+		ClearPagePinned(page);
 	}
 }
 
+static void xen_release_pt(u32 pfn)
+{
+	xen_release_ptpage(pfn, PT_PTE);
+}
+
+static void xen_release_pd(u32 pfn)
+{
+	xen_release_ptpage(pfn, PT_PMD);
+}
+
 #ifdef CONFIG_HIGHPTE
 static void *xen_kmap_atomic_pte(struct page *page, enum km_type type)
 {
@@ -838,7 +851,7 @@ static __init void xen_pagetable_setup_done(pgd_t *base)
 	pv_mmu_ops.alloc_pt = xen_alloc_pt;
 	pv_mmu_ops.alloc_pd = xen_alloc_pd;
 	pv_mmu_ops.release_pt = xen_release_pt;
-	pv_mmu_ops.release_pd = xen_release_pt;
+	pv_mmu_ops.release_pd = xen_release_pd;
 	pv_mmu_ops.set_pte = xen_set_pte;
 
 	setup_shared_info();
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 0144395..2a054ef 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -310,13 +310,6 @@ pgd_t xen_make_pgd(unsigned long pgd)
 }
 #endif	/* CONFIG_X86_PAE */
 
-enum pt_level {
-	PT_PGD,
-	PT_PUD,
-	PT_PMD,
-	PT_PTE
-};
-
 /*
   (Yet another) pagetable walker.  This one is intended for pinning a
   pagetable.  This means that it walks a pagetable and calls the
diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
index c9ff27f..b5e189b 100644
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -3,6 +3,13 @@
 #include <linux/linkage.h>
 #include <asm/page.h>
 
+enum pt_level {
+	PT_PGD,
+	PT_PUD,
+	PT_PMD,
+	PT_PTE
+};
+
 /*
  * Page-directory addresses above 4GB do not fit into architectural %cr3.
  * When accessing %cr3, or equivalent field in vcpu_guest_context, guests
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 465ad35..1399971 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -731,14 +731,14 @@ static unsigned long hpet_calibrate(struct hpets *hpetp)
 
 int hpet_alloc(struct hpet_data *hdp)
 {
-	u64 cap, mcfg, hpet_config;
+	u64 cap, mcfg;
 	struct hpet_dev *devp;
-	u32 i, ntimer, irq;
+	u32 i, ntimer;
 	struct hpets *hpetp;
 	size_t siz;
 	struct hpet __iomem *hpet;
 	static struct hpets *last = NULL;
-	unsigned long period, irq_bitmap;
+	unsigned long period;
 	unsigned long long temp;
 
 	/*
@@ -765,47 +765,11 @@ int hpet_alloc(struct hpet_data *hdp)
 	hpetp->hp_hpet_phys = hdp->hd_phys_address;
 
 	hpetp->hp_ntimer = hdp->hd_nirqs;
-	hpet = hpetp->hp_hpet;
-
-	/* Assign IRQs statically for legacy devices */
-	hpetp->hp_dev[0].hd_hdwirq = hdp->hd_irq[0];
-	hpetp->hp_dev[1].hd_hdwirq = hdp->hd_irq[1];
-
-	/* Assign IRQs dynamically for the others */
-	for (i = 2, devp = &hpetp->hp_dev[2]; i < hdp->hd_nirqs; i++, devp++) {
-		struct hpet_timer __iomem *timer;
 
-		timer = &hpet->hpet_timers[devp - hpetp->hp_dev];
+	for (i = 0; i < hdp->hd_nirqs; i++)
+		hpetp->hp_dev[i].hd_hdwirq = hdp->hd_irq[i];
 
-		/* Check if there's already an IRQ assigned to the timer */
-		if (hdp->hd_irq[i]) {
-			hpetp->hp_dev[i].hd_hdwirq = hdp->hd_irq[i];
-			continue;
-		}
-
-		hpet_config = readq(&timer->hpet_config);
-		irq_bitmap = (hpet_config & Tn_INT_ROUTE_CAP_MASK)
-			>> Tn_INT_ROUTE_CAP_SHIFT;
-		if (!irq_bitmap)
-			irq = 0;        /* No valid IRQ Assignable */
-		else {
-			irq = find_first_bit(&irq_bitmap, 32);
-			do {
-				hpet_config |= irq << Tn_INT_ROUTE_CNF_SHIFT;
-				writeq(hpet_config, &timer->hpet_config);
-
-				/*
-				 * Verify whether we have written a valid
-				 * IRQ number by reading it back again
-				 */
-				hpet_config = readq(&timer->hpet_config);
-				if (irq == (hpet_config & Tn_INT_ROUTE_CNF_MASK)
-						>> Tn_INT_ROUTE_CNF_SHIFT)
-					break;  /* Success */
-			} while ((irq = (find_next_bit(&irq_bitmap, 32, irq))));
-		}
-		hpetp->hp_dev[i].hd_hdwirq = irq;
-	}
+	hpet = hpetp->hp_hpet;
 
 	cap = readq(&hpet->hpet_cap);
 
@@ -836,8 +800,7 @@ int hpet_alloc(struct hpet_data *hdp)
 		hpetp->hp_which, hdp->hd_phys_address,
 		hpetp->hp_ntimer > 1 ? "s" : "");
 	for (i = 0; i < hpetp->hp_ntimer; i++)
-		printk("%s %d", i > 0 ? "," : "",
-				hpetp->hp_dev[i].hd_hdwirq);
+		printk("%s %d", i > 0 ? "," : "", hdp->hd_irq[i]);
 	printk("\n");
 
 	printk(KERN_INFO "hpet%u: %u %d-bit timers, %Lu Hz\n",
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index ea94dba..d85dc6d 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -381,11 +381,15 @@ EXPORT_SYMBOL_GPL(gnttab_cancel_free_callback);
 static int grow_gnttab_list(unsigned int more_frames)
 {
 	unsigned int new_nr_grant_frames, extra_entries, i;
+	unsigned int nr_glist_frames, new_nr_glist_frames;
 
 	new_nr_grant_frames = nr_grant_frames + more_frames;
 	extra_entries       = more_frames * GREFS_PER_GRANT_FRAME;
 
-	for (i = nr_grant_frames; i < new_nr_grant_frames; i++) {
+	nr_glist_frames = (nr_grant_frames * GREFS_PER_GRANT_FRAME + RPP - 1) / RPP;
+	new_nr_glist_frames =
+		(new_nr_grant_frames * GREFS_PER_GRANT_FRAME + RPP - 1) / RPP;
+	for (i = nr_glist_frames; i < new_nr_glist_frames; i++) {
 		gnttab_list[i] = (grant_ref_t *)__get_free_page(GFP_ATOMIC);
 		if (!gnttab_list[i])
 			goto grow_nomem;
@@ -407,7 +411,7 @@ static int grow_gnttab_list(unsigned int more_frames)
 	return 0;
 
 grow_nomem:
-	for ( ; i >= nr_grant_frames; i--)
+	for ( ; i >= nr_glist_frames; i--)
 		free_page((unsigned long) gnttab_list[i]);
 	return -ENOMEM;
 }
@@ -530,7 +534,7 @@ static int gnttab_expand(unsigned int req_entries)
 static int __devinit gnttab_init(void)
 {
 	int i;
-	unsigned int max_nr_glist_frames;
+	unsigned int max_nr_glist_frames, nr_glist_frames;
 	unsigned int nr_init_grefs;
 
 	if (!is_running_on_xen())
@@ -543,15 +547,15 @@ static int __devinit gnttab_init(void)
 	 * grant reference free list on the current hypervisor.
 	 */
 	max_nr_glist_frames = (boot_max_nr_grant_frames *
-			       GREFS_PER_GRANT_FRAME /
-			       (PAGE_SIZE / sizeof(grant_ref_t)));
+			       GREFS_PER_GRANT_FRAME / RPP);
 
 	gnttab_list = kmalloc(max_nr_glist_frames * sizeof(grant_ref_t *),
 			      GFP_KERNEL);
 	if (gnttab_list == NULL)
 		return -ENOMEM;
 
-	for (i = 0; i < nr_grant_frames; i++) {
+	nr_glist_frames = (nr_grant_frames * GREFS_PER_GRANT_FRAME + RPP - 1) / RPP;
+	for (i = 0; i < nr_glist_frames; i++) {
 		gnttab_list[i] = (grant_ref_t *)__get_free_page(GFP_KERNEL);
 		if (gnttab_list[i] == NULL)
 			goto ini_nomem;
diff --git a/include/asm-x86/irqflags.h b/include/asm-x86/irqflags.h
index 92021c1..0e22924 100644
--- a/include/asm-x86/irqflags.h
+++ b/include/asm-x86/irqflags.h
@@ -70,6 +70,26 @@ static inline void raw_local_irq_restore(unsigned long flags)
 	native_restore_fl(flags);
 }
 
+#ifdef CONFIG_X86_VSMP
+
+/*
+ * Interrupt control for the VSMP architecture:
+ */
+
+static inline void raw_local_irq_disable(void)
+{
+	unsigned long flags = __raw_local_save_flags();
+	raw_local_irq_restore((flags & ~X86_EFLAGS_IF) | X86_EFLAGS_AC);
+}
+
+static inline void raw_local_irq_enable(void)
+{
+	unsigned long flags = __raw_local_save_flags();
+	raw_local_irq_restore((flags | X86_EFLAGS_IF) & (~X86_EFLAGS_AC));
+}
+
+#else
+
 static inline void raw_local_irq_disable(void)
 {
 	native_irq_disable();
@@ -80,6 +100,8 @@ static inline void raw_local_irq_enable(void)
 	native_irq_enable();
 }
 
+#endif
+
 /*
  * Used in the idle loop; sti takes one instruction cycle
  * to complete:
@@ -137,10 +159,17 @@ static inline unsigned long __raw_local_irq_save(void)
 #define raw_local_irq_save(flags) \
 		do { (flags) = __raw_local_irq_save(); } while (0)
 
+#ifdef CONFIG_X86_VSMP
+static inline int raw_irqs_disabled_flags(unsigned long flags)
+{
+	return !(flags & X86_EFLAGS_IF) || (flags & X86_EFLAGS_AC);
+}
+#else
 static inline int raw_irqs_disabled_flags(unsigned long flags)
 {
 	return !(flags & X86_EFLAGS_IF);
 }
+#endif
 
 static inline int raw_irqs_disabled(void)
 {
diff --git a/include/linux/hpet.h b/include/linux/hpet.h
index 9cd94bf..2dc29ce 100644
--- a/include/linux/hpet.h
+++ b/include/linux/hpet.h
@@ -64,7 +64,7 @@ struct hpet {
  */
 
 #define	Tn_INT_ROUTE_CAP_MASK		(0xffffffff00000000ULL)
-#define	Tn_INT_ROUTE_CAP_SHIFT		(32UL)
+#define	Tn_INI_ROUTE_CAP_SHIFT		(32UL)
 #define	Tn_FSB_INT_DELCAP_MASK		(0x8000UL)
 #define	Tn_FSB_INT_DELCAP_SHIFT		(15)
 #define	Tn_FSB_EN_CNF_MASK		(0x4000UL)
