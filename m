Return-Path: <linux-kernel-owner+w=401wt.eu-S1758329AbZCWRpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbZCWRpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 13:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZCWRpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 13:45:43 -0400
Received: from gw.goop.org ([64.81.55.164]:44796 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbZCWRpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 13:45:42 -0400
Message-ID: <49C7CABF.9020801@goop.org>
Date: Mon, 23 Mar 2009 10:45:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] core Xen updates for 2.6.30
References: <49C28AC2.4010407@goop.org> <49C29381.9050201@zytor.com> <49C29983.3040305@goop.org> <49C2ABCA.6010009@zytor.com> <49C43D31.7040805@goop.org> <49C45238.7050007@zytor.com>
In-Reply-To: <49C45238.7050007@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series updates core domU Xen support.

Changes since last posting:

    * rebased to newer tip/master
    * addressed hpa's review comments
    * little cleanups

Thanks,
    J

The following changes since commit 8d336ed83a87149bcae6b872fff1aed8be268342:
  Jeremy Fitzhardinge (1):
        x86/paravirt: use percpu_ rather than __get_cpu_var

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push2/xen/core

Alex Nixon (1):
      Xen: Add virt_to_pfn helper function

Hannes Eder (1):
      NULL noise: arch/x86/xen/smp.c

Jeremy Fitzhardinge (15):
      xen: disable preempt for leave_lazy_mmu
      xen: separate p2m allocation from setting
      xen: dynamically allocate p2m tables
      xen: split construction of p2m mfn tables from registration
      xen: clean up xen_load_gdt
      xen: make xen_load_gdt simpler
      xen: remove xen_load_gdt debug
      xen: reserve i386 Xen pagetables
      xen: mask XSAVE from cpuid
      xen: add FIX_TEXT_POKE to fixmap
      x86-64: remove PGE from must-have feature list
      x86-64: non-paravirt systems always has PSE and PGE
      xen/mmu: some early pagetable cleanups
      Revert "x86: create a non-zero sized bm_pte only when needed"
      xen/mmu: weaken flush_tlb_other test

 arch/x86/include/asm/required-features.h |    8 ++-
 arch/x86/include/asm/xen/page.h          |    3 +-
 arch/x86/mm/ioremap.c                    |   19 +---
 arch/x86/xen/enlighten.c                 |   76 +++++++++++---
 arch/x86/xen/mmu.c                       |  160 ++++++++++++++++++++++--------
 arch/x86/xen/mmu.h                       |    3 +
 arch/x86/xen/smp.c                       |    4 +-
 arch/x86/xen/xen-ops.h                   |    2 -
 8 files changed, 196 insertions(+), 79 deletions(-)

diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index d5cd6c5..64cf2d2 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -48,9 +48,15 @@
 #endif
 
 #ifdef CONFIG_X86_64
+#ifdef CONFIG_PARAVIRT
+/* Paravirtualized systems may not have PSE or PGE available */
 #define NEED_PSE	0
+#define NEED_PGE	0
+#else
+#define NEED_PSE	(1<<(X86_FEATURE_PSE) & 31)
+#define NEED_PGE	(1<<(X86_FEATURE_PGE) & 31)
+#endif
 #define NEED_MSR	(1<<(X86_FEATURE_MSR & 31))
-#define NEED_PGE	(1<<(X86_FEATURE_PGE & 31))
 #define NEED_FXSR	(1<<(X86_FEATURE_FXSR & 31))
 #define NEED_XMM	(1<<(X86_FEATURE_XMM & 31))
 #define NEED_XMM2	(1<<(X86_FEATURE_XMM2 & 31))
diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 1a918dd..018a0a4 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -124,7 +124,8 @@ static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
 
 /* VIRT <-> MACHINE conversion */
 #define virt_to_machine(v)	(phys_to_machine(XPADDR(__pa(v))))
-#define virt_to_mfn(v)		(pfn_to_mfn(PFN_DOWN(__pa(v))))
+#define virt_to_pfn(v)          (PFN_DOWN(__pa(v)))
+#define virt_to_mfn(v)		(pfn_to_mfn(virt_to_pfn(v)))
 #define mfn_to_virt(m)		(__va(mfn_to_pfn(m) << PAGE_SHIFT))
 
 static inline unsigned long pte_mfn(pte_t pte)
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 55e127f..83ed74a 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -487,12 +487,7 @@ static int __init early_ioremap_debug_setup(char *str)
 early_param("early_ioremap_debug", early_ioremap_debug_setup);
 
 static __initdata int after_paging_init;
-#define __FIXADDR_TOP (-PAGE_SIZE)
-static pte_t bm_pte[(__fix_to_virt(FIX_DBGP_BASE)
-		     ^ __fix_to_virt(FIX_BTMAP_BEGIN)) >> PMD_SHIFT
-		    ? PAGE_SIZE / sizeof(pte_t) : 0] __page_aligned_bss;
-#undef __FIXADDR_TOP
-static __initdata pte_t *bm_ptep;
+static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
 
 static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 {
@@ -507,8 +502,6 @@ static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 
 static inline pte_t * __init early_ioremap_pte(unsigned long addr)
 {
-	if (!sizeof(bm_pte))
-		return &bm_ptep[pte_index(addr)];
 	return &bm_pte[pte_index(addr)];
 }
 
@@ -526,14 +519,8 @@ void __init early_ioremap_init(void)
 		slot_virt[i] = fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*i);
 
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
-	if (sizeof(bm_pte)) {
-		memset(bm_pte, 0, sizeof(bm_pte));
-		pmd_populate_kernel(&init_mm, pmd, bm_pte);
-	} else {
-		bm_ptep = pte_offset_kernel(pmd, 0);
-		if (early_ioremap_debug)
-			printk(KERN_INFO "bm_ptep=%p\n", bm_ptep);
-	}
+	memset(bm_pte, 0, sizeof(bm_pte));
+	pmd_populate_kernel(&init_mm, pmd, bm_pte);
 
 	/*
 	 * The boot-ioremap range spans multiple pmds, for which
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 70b355d..da33e0c 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -168,21 +168,23 @@ static void __init xen_banner(void)
 	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" : "");
 }
 
+static __read_mostly unsigned int cpuid_leaf1_edx_mask = ~0;
+static __read_mostly unsigned int cpuid_leaf1_ecx_mask = ~0;
+
 static void xen_cpuid(unsigned int *ax, unsigned int *bx,
 		      unsigned int *cx, unsigned int *dx)
 {
+	unsigned maskecx = ~0;
 	unsigned maskedx = ~0;
 
 	/*
 	 * Mask out inconvenient features, to try and disable as many
 	 * unsupported kernel subsystems as possible.
 	 */
-	if (*ax == 1)
-		maskedx = ~((1 << X86_FEATURE_APIC) |  /* disable APIC */
-			    (1 << X86_FEATURE_ACPI) |  /* disable ACPI */
-			    (1 << X86_FEATURE_MCE)  |  /* disable MCE */
-			    (1 << X86_FEATURE_MCA)  |  /* disable MCA */
-			    (1 << X86_FEATURE_ACC));   /* thermal monitoring */
+	if (*ax == 1) {
+		maskecx = cpuid_leaf1_ecx_mask;
+		maskedx = cpuid_leaf1_edx_mask;
+	}
 
 	asm(XEN_EMULATE_PREFIX "cpuid"
 		: "=a" (*ax),
@@ -190,9 +192,43 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
 		  "=c" (*cx),
 		  "=d" (*dx)
 		: "0" (*ax), "2" (*cx));
+
+	*cx &= maskecx;
 	*dx &= maskedx;
 }
 
+static __init void xen_init_cpuid_mask(void)
+{
+	unsigned int ax, bx, cx, dx;
+
+	cpuid_leaf1_edx_mask =
+		~((1 << X86_FEATURE_MCE)  |  /* disable MCE */
+		  (1 << X86_FEATURE_MCA)  |  /* disable MCA */
+		  (1 << X86_FEATURE_ACC));   /* thermal monitoring */
+
+	if (!xen_initial_domain())
+		cpuid_leaf1_edx_mask &=
+			~((1 << X86_FEATURE_APIC) |  /* disable local APIC */
+			  (1 << X86_FEATURE_ACPI));  /* disable ACPI */
+
+	ax = 1;
+	xen_cpuid(&ax, &bx, &cx, &dx);
+
+	/* cpuid claims we support xsave; try enabling it to see what happens */
+	if (cx & (1 << (X86_FEATURE_XSAVE % 32))) {
+		unsigned long cr4;
+
+		set_in_cr4(X86_CR4_OSXSAVE);
+		
+		cr4 = read_cr4();
+
+		if ((cr4 & X86_CR4_OSXSAVE) == 0)
+			cpuid_leaf1_ecx_mask &= ~(1 << (X86_FEATURE_XSAVE % 32));
+
+		clear_in_cr4(X86_CR4_OSXSAVE);
+	}
+}
+
 static void xen_set_debugreg(int reg, unsigned long val)
 {
 	HYPERVISOR_set_debugreg(reg, val);
@@ -284,12 +320,11 @@ static void xen_set_ldt(const void *addr, unsigned entries)
 
 static void xen_load_gdt(const struct desc_ptr *dtr)
 {
-	unsigned long *frames;
 	unsigned long va = dtr->address;
 	unsigned int size = dtr->size + 1;
 	unsigned pages = (size + PAGE_SIZE - 1) / PAGE_SIZE;
+	unsigned long frames[pages];
 	int f;
-	struct multicall_space mcs;
 
 	/* A GDT can be up to 64k in size, which corresponds to 8192
 	   8-byte entries, or 16 4k pages.. */
@@ -297,19 +332,26 @@ static void xen_load_gdt(const struct desc_ptr *dtr)
 	BUG_ON(size > 65536);
 	BUG_ON(va & ~PAGE_MASK);
 
-	mcs = xen_mc_entry(sizeof(*frames) * pages);
-	frames = mcs.args;
-
 	for (f = 0; va < dtr->address + size; va += PAGE_SIZE, f++) {
-		frames[f] = arbitrary_virt_to_mfn((void *)va);
+		int level;
+		pte_t *ptep = lookup_address(va, &level);
+		unsigned long pfn, mfn;
+		void *virt;
+
+		BUG_ON(ptep == NULL);
+
+		pfn = pte_pfn(*ptep);
+		mfn = pfn_to_mfn(pfn);
+		virt = __va(PFN_PHYS(pfn));
+
+		frames[f] = mfn;
 
 		make_lowmem_page_readonly((void *)va);
-		make_lowmem_page_readonly(mfn_to_virt(frames[f]));
+		make_lowmem_page_readonly(virt);
 	}
 
-	MULTI_set_gdt(mcs.mc, frames, size / sizeof(struct desc_struct));
-
-	xen_mc_issue(PARAVIRT_LAZY_CPU);
+	if (HYPERVISOR_set_gdt(frames, size / sizeof(struct desc_struct)))
+		BUG();
 }
 
 static void load_TLS_descriptor(struct thread_struct *t,
@@ -895,6 +937,8 @@ asmlinkage void __init xen_start_kernel(void)
 
 	xen_init_irq_ops();
 
+	xen_init_cpuid_mask();
+
 #ifdef CONFIG_X86_LOCAL_APIC
 	/*
 	 * set up the basic apic ops.
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index e194f72..aa16ef4 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -159,18 +159,14 @@ DEFINE_PER_CPU(unsigned long, xen_current_cr3);	 /* actual vcpu cr3 */
 #define TOP_ENTRIES		(MAX_DOMAIN_PAGES / P2M_ENTRIES_PER_PAGE)
 
 /* Placeholder for holes in the address space */
-static unsigned long p2m_missing[P2M_ENTRIES_PER_PAGE] __page_aligned_data =
-		{ [ 0 ... P2M_ENTRIES_PER_PAGE-1 ] = ~0UL };
+static unsigned long *p2m_missing;
 
  /* Array of pointers to pages containing p2m entries */
-static unsigned long *p2m_top[TOP_ENTRIES] __page_aligned_data =
-		{ [ 0 ... TOP_ENTRIES - 1] = &p2m_missing[0] };
+static unsigned long **p2m_top;
 
 /* Arrays of p2m arrays expressed in mfns used for save/restore */
-static unsigned long p2m_top_mfn[TOP_ENTRIES] __page_aligned_bss;
-
-static unsigned long p2m_top_mfn_list[TOP_ENTRIES / P2M_ENTRIES_PER_PAGE]
-	__page_aligned_bss;
+static unsigned long *p2m_top_mfn;
+static unsigned long *p2m_top_mfn_list;
 
 static inline unsigned p2m_top_index(unsigned long pfn)
 {
@@ -183,22 +179,35 @@ static inline unsigned p2m_index(unsigned long pfn)
 	return pfn % P2M_ENTRIES_PER_PAGE;
 }
 
+#define SIZE_TOP_MFN sizeof(*p2m_top_mfn) * TOP_ENTRIES
+#define SIZE_TOP_MFN_LIST sizeof(*p2m_top_mfn_list) *			\
+	(TOP_ENTRIES / P2M_ENTRIES_PER_PAGE)
+
+RESERVE_BRK(xen_top_mfn, SIZE_TOP_MFN);
+RESERVE_BRK(xen_top_mfn_list, SIZE_TOP_MFN_LIST);
+
 /* Build the parallel p2m_top_mfn structures */
-void xen_setup_mfn_list_list(void)
+static void __init xen_build_mfn_list_list(void)
 {
 	unsigned pfn, idx;
 
+	p2m_top_mfn = extend_brk(SIZE_TOP_MFN, PAGE_SIZE);
+	p2m_top_mfn_list = extend_brk(SIZE_TOP_MFN_LIST, PAGE_SIZE);
+
 	for (pfn = 0; pfn < MAX_DOMAIN_PAGES; pfn += P2M_ENTRIES_PER_PAGE) {
 		unsigned topidx = p2m_top_index(pfn);
 
 		p2m_top_mfn[topidx] = virt_to_mfn(p2m_top[topidx]);
 	}
 
-	for (idx = 0; idx < ARRAY_SIZE(p2m_top_mfn_list); idx++) {
+	for (idx = 0; idx < (TOP_ENTRIES / P2M_ENTRIES_PER_PAGE); idx++) {
 		unsigned topidx = idx * P2M_ENTRIES_PER_PAGE;
 		p2m_top_mfn_list[idx] = virt_to_mfn(&p2m_top_mfn[topidx]);
 	}
+}
 
+void xen_setup_mfn_list_list(void)
+{
 	BUG_ON(HYPERVISOR_shared_info == &xen_dummy_shared_info);
 
 	HYPERVISOR_shared_info->arch.pfn_to_mfn_frame_list_list =
@@ -206,18 +215,34 @@ void xen_setup_mfn_list_list(void)
 	HYPERVISOR_shared_info->arch.max_pfn = xen_start_info->nr_pages;
 }
 
+#define SIZE_P2M_MISSING	sizeof(*p2m_missing) * P2M_ENTRIES_PER_PAGE
+#define SIZE_P2M_TOP		sizeof(*p2m_top) * TOP_ENTRIES
+RESERVE_BRK(xen_p2m_missing, SIZE_P2M_MISSING);
+RESERVE_BRK(xen_p2m_top, SIZE_P2M_TOP);
+
 /* Set up p2m_top to point to the domain-builder provided p2m pages */
 void __init xen_build_dynamic_phys_to_machine(void)
 {
 	unsigned long *mfn_list = (unsigned long *)xen_start_info->mfn_list;
 	unsigned long max_pfn = min(MAX_DOMAIN_PAGES, xen_start_info->nr_pages);
 	unsigned pfn;
+	unsigned i;
+
+	p2m_missing = extend_brk(SIZE_P2M_MISSING, PAGE_SIZE);
+	for(i = 0; i < P2M_ENTRIES_PER_PAGE; i++)
+		p2m_missing[i] = ~0ul;
+
+	p2m_top = extend_brk(SIZE_P2M_TOP, PAGE_SIZE);
+	for(i = 0; i < TOP_ENTRIES; i++)
+		p2m_top[i] = p2m_missing;
 
 	for (pfn = 0; pfn < max_pfn; pfn += P2M_ENTRIES_PER_PAGE) {
 		unsigned topidx = p2m_top_index(pfn);
 
 		p2m_top[topidx] = &mfn_list[pfn];
 	}
+
+	xen_build_mfn_list_list();
 }
 
 unsigned long get_phys_to_machine(unsigned long pfn)
@@ -233,47 +258,74 @@ unsigned long get_phys_to_machine(unsigned long pfn)
 }
 EXPORT_SYMBOL_GPL(get_phys_to_machine);
 
-static void alloc_p2m(unsigned long **pp, unsigned long *mfnp)
+/* install a  new p2m_top page */
+bool install_p2mtop_page(unsigned long pfn, unsigned long *p)
 {
-	unsigned long *p;
+	unsigned topidx = p2m_top_index(pfn);
+	unsigned long **pfnp, *mfnp;
 	unsigned i;
 
-	p = (void *)__get_free_page(GFP_KERNEL | __GFP_NOFAIL);
-	BUG_ON(p == NULL);
+	pfnp = &p2m_top[topidx];
+	mfnp = &p2m_top_mfn[topidx];
 
 	for (i = 0; i < P2M_ENTRIES_PER_PAGE; i++)
 		p[i] = INVALID_P2M_ENTRY;
 
-	if (cmpxchg(pp, p2m_missing, p) != p2m_missing)
-		free_page((unsigned long)p);
-	else
+	if (cmpxchg(pfnp, p2m_missing, p) == p2m_missing) {
 		*mfnp = virt_to_mfn(p);
+		return true;
+	}
+
+	return false;
 }
 
-void set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+static void alloc_p2m(unsigned long pfn)
 {
-	unsigned topidx, idx;
+	unsigned long *p;
 
-	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
-		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
-		return;
-	}
+	p = (void *)__get_free_page(GFP_KERNEL | __GFP_NOFAIL);
+	BUG_ON(p == NULL);
+
+	if (!install_p2mtop_page(pfn, p))
+		free_page((unsigned long)p);
+}
+
+/* Try to install p2m mapping; fail if intermediate bits missing */
+bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+{
+	unsigned topidx, idx;
 
 	if (unlikely(pfn >= MAX_DOMAIN_PAGES)) {
 		BUG_ON(mfn != INVALID_P2M_ENTRY);
-		return;
+		return true;
 	}
 
 	topidx = p2m_top_index(pfn);
 	if (p2m_top[topidx] == p2m_missing) {
-		/* no need to allocate a page to store an invalid entry */
 		if (mfn == INVALID_P2M_ENTRY)
-			return;
-		alloc_p2m(&p2m_top[topidx], &p2m_top_mfn[topidx]);
+			return true;
+		return false;
 	}
 
 	idx = p2m_index(pfn);
 	p2m_top[topidx][idx] = mfn;
+
+	return true;
+}
+
+void set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+{
+	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
+		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
+		return;
+	}
+
+	if (unlikely(!__set_phys_to_machine(pfn, mfn)))  {
+		alloc_p2m(pfn);
+
+		if (!__set_phys_to_machine(pfn, mfn))
+			BUG();
+	}
 }
 
 unsigned long arbitrary_virt_to_mfn(void *vaddr)
@@ -981,7 +1033,7 @@ static __init int xen_mark_pinned(struct mm_struct *mm, struct page *page,
 	return 0;
 }
 
-void __init xen_mark_init_mm_pinned(void)
+static void __init xen_mark_init_mm_pinned(void)
 {
 	xen_pgd_walk(&init_mm, xen_mark_pinned, FIXADDR_TOP);
 }
@@ -1261,8 +1313,8 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
 	} *args;
 	struct multicall_space mcs;
 
-	BUG_ON(cpumask_empty(cpus));
-	BUG_ON(!mm);
+	if (cpumask_empty(cpus))
+		return;		/* nothing to do */
 
 	mcs = xen_mc_entry(sizeof(*args));
 	args = mcs.args;
@@ -1429,6 +1481,15 @@ static __init void xen_set_pte_init(pte_t *ptep, pte_t pte)
 }
 #endif
 
+static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
+{
+	struct mmuext_op op;
+	op.cmd = cmd;
+	op.arg1.mfn = pfn_to_mfn(pfn);
+	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
+		BUG();
+}
+
 /* Early in boot, while setting up the initial pagetable, assume
    everything is pinned. */
 static __init void xen_alloc_pte_init(struct mm_struct *mm, unsigned long pfn)
@@ -1437,22 +1498,29 @@ static __init void xen_alloc_pte_init(struct mm_struct *mm, unsigned long pfn)
 	BUG_ON(mem_map);	/* should only be used early */
 #endif
 	make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
+	pin_pagetable_pfn(MMUEXT_PIN_L1_TABLE, pfn);
+}
+
+/* Used for pmd and pud */
+static __init void xen_alloc_pmd_init(struct mm_struct *mm, unsigned long pfn)
+{
+#ifdef CONFIG_FLATMEM
+	BUG_ON(mem_map);	/* should only be used early */
+#endif
+	make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
 }
 
 /* Early release_pte assumes that all pts are pinned, since there's
    only init_mm and anything attached to that is pinned. */
-static void xen_release_pte_init(unsigned long pfn)
+static __init void xen_release_pte_init(unsigned long pfn)
 {
+	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
 	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 }
 
-static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
+static __init void xen_release_pmd_init(unsigned long pfn)
 {
-	struct mmuext_op op;
-	op.cmd = cmd;
-	op.arg1.mfn = pfn_to_mfn(pfn);
-	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
-		BUG();
+	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 }
 
 /* This needs to make sure the new pte page is pinned iff its being
@@ -1737,6 +1805,11 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 
 	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(swapper_pg_dir)));
 
+	reserve_early(__pa(xen_start_info->pt_base),
+		      __pa(xen_start_info->pt_base +
+			   xen_start_info->nr_pt_frames * PAGE_SIZE),
+		      "XEN PAGETABLES");
+
 	return swapper_pg_dir;
 }
 #endif	/* CONFIG_X86_64 */
@@ -1764,6 +1837,9 @@ static void xen_set_fixmap(unsigned idx, unsigned long phys, pgprot_t prot)
 #ifdef CONFIG_X86_LOCAL_APIC
 	case FIX_APIC_BASE:	/* maps dummy local APIC */
 #endif
+	case FIX_TEXT_POKE0:
+	case FIX_TEXT_POKE1:
+		/* All local page mappings */
 		pte = pfn_pte(phys, prot);
 		break;
 
@@ -1812,8 +1888,10 @@ __init void xen_post_allocator_init(void)
 
 static void xen_leave_lazy_mmu(void)
 {
+	preempt_disable();
 	xen_mc_flush();
 	paravirt_leave_lazy_mmu();
+	preempt_enable();
 }
 
 const struct pv_mmu_ops xen_mmu_ops __initdata = {
@@ -1839,9 +1917,9 @@ const struct pv_mmu_ops xen_mmu_ops __initdata = {
 
 	.alloc_pte = xen_alloc_pte_init,
 	.release_pte = xen_release_pte_init,
-	.alloc_pmd = xen_alloc_pte_init,
+	.alloc_pmd = xen_alloc_pmd_init,
 	.alloc_pmd_clone = paravirt_nop,
-	.release_pmd = xen_release_pte_init,
+	.release_pmd = xen_release_pmd_init,
 
 #ifdef CONFIG_HIGHPTE
 	.kmap_atomic_pte = xen_kmap_atomic_pte,
@@ -1879,8 +1957,8 @@ const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.make_pud = PV_CALLEE_SAVE(xen_make_pud),
 	.set_pgd = xen_set_pgd_hyper,
 
-	.alloc_pud = xen_alloc_pte_init,
-	.release_pud = xen_release_pte_init,
+	.alloc_pud = xen_alloc_pmd_init,
+	.release_pud = xen_release_pmd_init,
 #endif	/* PAGETABLE_LEVELS == 4 */
 
 	.activate_mm = xen_activate_mm,
diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
index 24d1b44..da73026 100644
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -11,6 +11,9 @@ enum pt_level {
 };
 
 
+bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
+bool install_p2mtop_page(unsigned long pfn, unsigned long *p);
+
 void set_pte_mfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
 
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 585a6e3..429834e 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -317,7 +317,7 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
 	BUG_ON(rc);
 
 	while(per_cpu(cpu_state, cpu) != CPU_ONLINE) {
-		HYPERVISOR_sched_op(SCHEDOP_yield, 0);
+		HYPERVISOR_sched_op(SCHEDOP_yield, NULL);
 		barrier();
 	}
 
@@ -422,7 +422,7 @@ static void xen_smp_send_call_function_ipi(const struct cpumask *mask)
 	/* Make sure other vcpus get a chance to run if they need to. */
 	for_each_cpu(cpu, mask) {
 		if (xen_vcpu_stolen(cpu)) {
-			HYPERVISOR_sched_op(SCHEDOP_yield, 0);
+			HYPERVISOR_sched_op(SCHEDOP_yield, NULL);
 			break;
 		}
 	}
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index f897cdf..5c50a10 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -56,8 +56,6 @@ irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
 
 bool xen_vcpu_stolen(int vcpu);
 
-void xen_mark_init_mm_pinned(void);
-
 void xen_setup_vcpu_info_placement(void);
 
 #ifdef CONFIG_SMP


