Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbYAUWQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbYAUWQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 17:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757987AbYAUWQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 17:16:09 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:15115 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756117AbYAUWQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 17:16:04 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       =?utf-8?q?Mika=20Penttil=C3=A4?= <mika.penttila@kolumbus.fi>
Date: Mon, 21 Jan 2008 22:15:21 +0000
Message-Id: <1200953721-3815-4-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: 479510CE.7010706@zytor.com
References: 479510CE.7010706@zytor.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH] x86_32: Construct 32 bit boot time page tables in native format.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specifically the boot time page tables in a CONFIG_X86_PAE=y enabled
kernel are in PAE format.

early_ioremap is updated to use the standard page table accessors.

Derived from an earlier patch by Eric Biederman.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Mika Penttilä <mika.penttila@kolumbus.fi>
---
 arch/x86/kernel/head_32.S    |   82 ++----------------
 arch/x86/kernel/setup_32.c   |    4 +
 arch/x86/mm/init_32.c        |  196 +++++++++++++++++++++++++++++++----------
 arch/x86/mm/ioremap_32.c     |   53 +++++++-----
 include/asm-x86/page_32.h    |    1 -
 include/asm-x86/pgtable_32.h |    4 -
 6 files changed, 189 insertions(+), 151 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index a2b6331..93e165a 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -33,44 +33,6 @@
 #define X86_VENDOR_ID	new_cpu_data+CPUINFO_x86_vendor_id
 
 /*
- * This is how much memory *in addition to the memory covered up to
- * and including _end* we need mapped initially.
- * We need:
- *  - one bit for each possible page, but only in low memory, which means
- *     2^32/4096/8 = 128K worst case (4G/4G split.)
- *  - enough space to map all low memory, which means
- *     (2^32/4096) / 1024 pages (worst case, non PAE)
- *     (2^32/4096) / 512 + 4 pages (worst case for PAE)
- *  - a few pages for allocator use before the kernel pagetable has
- *     been set up
- *
- * Modulo rounding, each megabyte assigned here requires a kilobyte of
- * memory, which is currently unreclaimed.
- *
- * This should be a multiple of a page.
- */
-LOW_PAGES = 1<<(32-PAGE_SHIFT_asm)
-
-/*
- * To preserve the DMA pool in PAGEALLOC kernels, we'll allocate
- * pagetables from above the 16MB DMA limit, so we'll have to set
- * up pagetables 16MB more (worst-case):
- */
-#ifdef CONFIG_DEBUG_PAGEALLOC
-LOW_PAGES = LOW_PAGES + 0x1000000
-#endif
-
-#if PTRS_PER_PMD > 1
-PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PMD) + PTRS_PER_PGD
-#else
-PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PGD)
-#endif
-BOOTBITMAP_SIZE = LOW_PAGES / 8
-ALLOCATOR_SLOP = 4
-
-INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE + ALLOCATOR_SLOP)*PAGE_SIZE_asm
-
-/*
  * 32-bit kernel entrypoint; only used by the boot CPU.  On entry,
  * %esi points to the real-mode code as a 32-bit pointer.
  * CS and DS must be 4 GB flat segments, but we don't depend on
@@ -160,46 +122,16 @@ num_subarch_entries = (. - subarch_entries) / 4
 .previous
 #endif /* CONFIG_PARAVIRT */
 
-/*
- * Initialize page tables.  This creates a PDE and a set of page
- * tables, which are located immediately beyond _end.  The variable
- * init_pg_tables_end is set up to point to the first "safe" location.
- * Mappings are created both at virtual address 0 (identity mapping)
- * and PAGE_OFFSET for up to _end+sizeof(page tables)+INIT_MAP_BEYOND_END.
- *
- * Warning: don't use %esi or the stack in this code.  However, %esp
- * can be used as a GPR if you really need it...
- */
-page_pde_offset = (__PAGE_OFFSET >> 20);
-
 default_entry:
-	movl $(pg0 - __PAGE_OFFSET), %edi
-	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx
-	movl $0x007, %eax			/* 0x007 = PRESENT+RW+USER */
-10:
-	leal 0x007(%edi),%ecx			/* Create PDE entry */
-	movl %ecx,(%edx)			/* Store identity PDE entry */
-	movl %ecx,page_pde_offset(%edx)		/* Store kernel PDE entry */
-	addl $4,%edx
-	movl $1024, %ecx
-11:
-	stosl
-	addl $0x1000,%eax
-	loop 11b
-	/* End condition: we must map up to and including INIT_MAP_BEYOND_END */
-	/* bytes beyond the end of our own page tables; the +0x007 is the attribute bits */
-	leal (INIT_MAP_BEYOND_END+0x007)(%edi),%ebp
-	cmpl %ebp,%eax
-	jb 10b
-	movl %edi,(init_pg_tables_end - __PAGE_OFFSET)
-
-	/* Do an early initialization of the fixmap area */
-	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx
-	movl $(swapper_pg_pmd - __PAGE_OFFSET), %eax
-	addl $0x67, %eax			/* 0x67 == _PAGE_TABLE */
-	movl %eax, 4092(%edx)
+	/* Setup the stack */
+	lss stack_start - __PAGE_OFFSET, %esp
+	subl $__PAGE_OFFSET, %esp
+
+	/* Initialize the boot page tables */
+	call early_pgtable_init
 
 	jmp 3f
+
 /*
  * Non-boot CPU entry point; entered from trampoline.S
  * We can't lgdt here, because lgdt itself uses a data segment, but
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index c6f25cb..196c23b 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -153,7 +153,11 @@ struct cpuinfo_x86 new_cpu_data __cpuinitdata = { 0, 0, 0, 0, -1, 1, 0, 0, -1 };
 struct cpuinfo_x86 boot_cpu_data __read_mostly = { 0, 0, 0, 0, -1, 1, 0, 0, -1 };
 EXPORT_SYMBOL(boot_cpu_data);
 
+#ifndef CONFIG_X86_PAE
 unsigned long mmu_cr4_features;
+#else
+unsigned long mmu_cr4_features = X86_CR4_PAE;
+#endif
 
 /* for MCA, but anyone else can use it if they want */
 unsigned int machine_id;
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index cbba769..a8eb443 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -43,6 +43,7 @@
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
 #include <asm/paravirt.h>
+#include <asm/setup.h>
 
 unsigned int __VMALLOC_RESERVE = 128 << 20;
 
@@ -52,6 +53,151 @@ unsigned long highstart_pfn, highend_pfn;
 static int noinline do_test_wp_bit(void);
 
 /*
+ * Initialize page tables.  This creates a PDE and a set of page
+ * tables, which are located immediately beyond _end.  The variable
+ * init_pg_tables_end is set up to point to the first "safe" location.
+ * Mappings are created both at virtual address 0 (identity mapping)
+ * and PAGE_OFFSET for up to _end+sizeof(page tables)+INIT_MAP_BEYOND_END.
+ *
+ * WARNING: This code runs at it's physical address not it's virtual address,
+ * with all physical everything identity mapped, and nothing else mapped.
+ * This means global variables must be done very carefully.
+ */
+#define __pavar(X) (*(__typeof__(X) *)__pa_symbol(&(X)))
+
+static inline __init pgd_t *early_pgd_offset(pgd_t *pgd, unsigned long vaddr)
+{
+	return pgd + pgd_index(vaddr);
+}
+
+static inline __init pmd_t *early_pmd_offset(pgd_t *pgd, unsigned long vaddr)
+{
+#ifndef CONFIG_X86_PAE
+	return (pmd_t *)pgd;
+#else
+	return ((pmd_t *)(unsigned long)(native_pgd_val(*pgd) & PAGE_MASK))
+		+ pmd_index(vaddr);
+#endif
+}
+
+static inline __init pte_t *early_pte_offset(pmd_t *pmd, unsigned long vaddr)
+{
+	return ((pte_t *)(unsigned long)(native_pmd_val(*pmd) & PAGE_MASK))
+		+ pte_index(vaddr);
+}
+
+static inline __init pmd_t *
+early_pmd_alloc(pgd_t *pgd_base, unsigned long vaddr, unsigned long *end)
+{
+	pgd_t *pgd = early_pgd_offset(pgd_base, vaddr);
+
+	if (!(unsigned long)native_pgd_val(*pgd)) {
+		unsigned long phys = *end;
+		memset((void *)phys, 0, PAGE_SIZE);
+#ifdef CONFIG_X86_PAE
+		*pgd = native_make_pgd(phys | _PAGE_PRESENT);
+#else
+		*pgd = native_make_pgd(phys | _PAGE_TABLE);
+#endif
+		*end += PAGE_SIZE;
+	}
+
+	return early_pmd_offset(pgd, vaddr);
+}
+
+static inline __init pte_t *
+early_pte_alloc(pgd_t *pgd_base, unsigned long vaddr, unsigned long *end)
+{
+	pmd_t *pmd;
+
+	pmd = early_pmd_alloc(pgd_base, vaddr, end);
+#ifdef CONFIG_X86_PAE
+	if (!(unsigned long)native_pmd_val(*pmd)) {
+		unsigned long phys = *end;
+		memset((void *)phys, 0, PAGE_SIZE);
+		native_set_pmd(pmd, native_make_pmd(phys | _PAGE_TABLE));
+		*end += PAGE_SIZE;
+	}
+#endif
+	return early_pte_offset(pmd, vaddr);
+}
+
+static __init void early_set_pte_phys(pgd_t *pgd_base, unsigned long vaddr,
+				      unsigned long phys, unsigned long *end)
+{
+	pte_t *pte;
+	pte = early_pte_alloc(pgd_base, vaddr, end);
+	native_set_pte(pte, native_make_pte(phys | _PAGE_KERNEL_EXEC));
+}
+
+/*
+ * To preserve the DMA pool in PAGEALLOC kernels, we'll allocate
+ * pagetables from above the 16MB DMA limit, so we'll have to set
+ * up pagetables 16MB more (worst-case):
+ */
+#ifdef CONFIG_DEBUG_PAGEALLOC
+#define LOW_PAGES (1<<(32-PAGE_SHIFT) + 0x1000000)
+#else
+#define LOW_PAGES (1<<(32-PAGE_SHIFT))
+#endif
+
+void __init early_pgtable_init(void)
+{
+	unsigned long addr, end, limit;
+	pgd_t *pgd_base;
+
+	pgd_base = __pavar(swapper_pg_dir);
+	end = __pa_symbol(pg0);
+
+	/*
+	 * This is how much memory *in addition to the memory covered up to
+	 * and including _end* we need mapped initially.
+	 */
+	limit = end;
+
+	/*
+	 *  - one bit for each possible page, but only in low memory,
+	 *    which means
+	 *     2^32/4096/8 = 128K worst case (4G/4G split.)
+	 */
+	limit += LOW_PAGES / 8;
+
+	/*
+	 *  - enough space to map all low memory, which means
+	 *     (2^32/4096) / 1024 pages (worst case, non PAE)
+	 *     (2^32/4096) / 512 + 4 pages (worst case for PAE)
+	 */
+#if PTRS_PER_PMD > 1
+	limit += (LOW_PAGES / PTRS_PER_PMD) * PAGE_SIZE;
+	limit += PTRS_PER_PGD * PAGE_SIZE;
+#else
+	limit += (LOW_PAGES / PTRS_PER_PGD) * PAGE_SIZE;
+#endif
+
+	/*
+	 *  - a few pages for allocator use before the kernel pagetable has
+	 *     been set up
+	 */
+	limit += 4 * PAGE_SIZE;
+
+	/* Initialize the directory page */
+	memset(pgd_base, 0, PAGE_SIZE);
+
+	/* Set up the fixmap page table */
+	early_pte_alloc(pgd_base, __pavar(__FIXADDR_TOP), &end);
+
+	/* Set up the initial kernel mapping */
+	for (addr = 0; addr < limit; addr += PAGE_SIZE)
+		early_set_pte_phys(pgd_base, addr + PAGE_OFFSET, addr, &end);
+
+	/* Set up the low identity mappings */
+	clone_pgd_range(pgd_base, pgd_base + USER_PTRS_PER_PGD,
+			min_t(unsigned long, KERNEL_PGD_PTRS, USER_PGD_PTRS));
+
+	__pavar(init_pg_tables_end) = end;
+}
+
+/*
  * Creates a middle page table and puts a pointer to it in the
  * given global directory entry. This only returns the gd entry
  * in non-PAE compilation mode, since the middle layer is folded.
@@ -353,44 +499,11 @@ extern void __init remap_numa_kva(void);
 
 void __init native_pagetable_setup_start(pgd_t *base)
 {
-#ifdef CONFIG_X86_PAE
-	int i;
-
-	/*
-	 * Init entries of the first-level page table to the
-	 * zero page, if they haven't already been set up.
-	 *
-	 * In a normal native boot, we'll be running on a
-	 * pagetable rooted in swapper_pg_dir, but not in PAE
-	 * mode, so this will end up clobbering the mappings
-	 * for the lower 24Mbytes of the address space,
-	 * without affecting the kernel address space.
-	 */
-	for (i = 0; i < USER_PTRS_PER_PGD; i++)
-		set_pgd(&base[i],
-			__pgd(__pa(empty_zero_page) | _PAGE_PRESENT));
-
-	/* Make sure kernel address space is empty so that a pagetable
-	   will be allocated for it. */
-	memset(&base[USER_PTRS_PER_PGD], 0,
-	       KERNEL_PGD_PTRS * sizeof(pgd_t));
-#else
 	paravirt_alloc_pd(__pa(swapper_pg_dir) >> PAGE_SHIFT);
-#endif
 }
 
 void __init native_pagetable_setup_done(pgd_t *base)
 {
-#ifdef CONFIG_X86_PAE
-	/*
-	 * Add low memory identity-mappings - SMP needs it when
-	 * starting up on an AP from real-mode. In the non-PAE
-	 * case we already have these mappings through head.S.
-	 * All user-space mappings are explicitly cleared after
-	 * SMP startup.
-	 */
-	set_pgd(&base[0], base[USER_PTRS_PER_PGD]);
-#endif
 }
 
 /*
@@ -399,9 +512,8 @@ void __init native_pagetable_setup_done(pgd_t *base)
  * the boot process.
  *
  * If we're booting on native hardware, this will be a pagetable
- * constructed in arch/i386/kernel/head.S, and not running in PAE mode
- * (even if we'll end up running in PAE).  The root of the pagetable
- * will be swapper_pg_dir.
+ * constructed in arch/x86/kernel/head_32.S.  The root of the
+ * pagetable will be swapper_pg_dir.
  *
  * If we're booting paravirtualized under a hypervisor, then there are
  * more options: we may already be running PAE, and the pagetable may
@@ -559,14 +671,6 @@ void __init paging_init(void)
 
 	load_cr3(swapper_pg_dir);
 
-#ifdef CONFIG_X86_PAE
-	/*
-	 * We will bail out later - printk doesn't work right now so
-	 * the user would just see a hanging kernel.
-	 */
-	if (cpu_has_pae)
-		set_in_cr4(X86_CR4_PAE);
-#endif
 	__flush_tlb_all();
 
 	kmap_init();
@@ -696,10 +800,6 @@ void __init mem_init(void)
 	BUG_ON((unsigned long)high_memory      > VMALLOC_START);
 #endif /* double-sanity-check paranoia */
 
-#ifdef CONFIG_X86_PAE
-	if (!cpu_has_pae)
-		panic("cannot execute a PAE-enabled kernel on a PAE-less CPU!");
-#endif
 	if (boot_cpu_data.wp_works_ok < 0)
 		test_wp_bit();
 
diff --git a/arch/x86/mm/ioremap_32.c b/arch/x86/mm/ioremap_32.c
index 05a24cd..fa8a3ff 100644
--- a/arch/x86/mm/ioremap_32.c
+++ b/arch/x86/mm/ioremap_32.c
@@ -226,40 +226,45 @@ static int __init early_ioremap_debug_setup(char *str)
 __setup("early_ioremap_debug", early_ioremap_debug_setup);
 
 static __initdata int after_paging_init;
-static __initdata unsigned long bm_pte[1024]
+static __initdata pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)]
 				__attribute__((aligned(PAGE_SIZE)));
 
-static inline unsigned long * __init early_ioremap_pgd(unsigned long addr)
+static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 {
-	return (unsigned long *)swapper_pg_dir + ((addr >> 22) & 1023);
+	pgd_t *pgd = &swapper_pg_dir[pgd_index(addr)];
+	pud_t *pud = pud_offset(pgd, addr);
+	pmd_t *pmd = pmd_offset(pud, addr);
+
+	return pmd;
 }
 
-static inline unsigned long * __init early_ioremap_pte(unsigned long addr)
+static inline pte_t * __init early_ioremap_pte(unsigned long addr)
 {
-	return bm_pte + ((addr >> PAGE_SHIFT) & 1023);
+	return &bm_pte[pte_index(addr)];
 }
 
 void __init early_ioremap_init(void)
 {
-	unsigned long *pgd;
+	pmd_t *pmd;
 
 	if (early_ioremap_debug)
 		printk("early_ioremap_init()\n");
 
-	pgd = early_ioremap_pgd(fix_to_virt(FIX_BTMAP_BEGIN));
-	*pgd = __pa(bm_pte) | _PAGE_TABLE;
+	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
 	memset(bm_pte, 0, sizeof(bm_pte));
+	set_pmd(pmd, __pmd(__pa(bm_pte) | _PAGE_TABLE));
+
 	/*
-	 * The boot-ioremap range spans multiple pgds, for which
+	 * The boot-ioremap range spans multiple pmds, for which
 	 * we are not prepared:
 	 */
-	if (pgd != early_ioremap_pgd(fix_to_virt(FIX_BTMAP_END))) {
+	if (pmd != early_ioremap_pmd(fix_to_virt(FIX_BTMAP_END))) {
 		WARN_ON(1);
-		printk("pgd %p != %p\n",
-			pgd, early_ioremap_pgd(fix_to_virt(FIX_BTMAP_END)));
-		printk("fix_to_virt(FIX_BTMAP_BEGIN): %08lx\n",
+		printk(KERN_WARNING "pmd %p != %p\n",
+		       pmd, early_ioremap_pmd(fix_to_virt(FIX_BTMAP_END)));
+		printk(KERN_WARNING "fix_to_virt(FIX_BTMAP_BEGIN): %08lx\n",
 			fix_to_virt(FIX_BTMAP_BEGIN));
-		printk("fix_to_virt(FIX_BTMAP_END):   %08lx\n",
+		printk(KERN_WARNING "fix_to_virt(FIX_BTMAP_END):   %08lx\n",
 			fix_to_virt(FIX_BTMAP_END));
 
 		printk("FIX_BTMAP_END:       %d\n", FIX_BTMAP_END);
@@ -269,27 +274,28 @@ void __init early_ioremap_init(void)
 
 void __init early_ioremap_clear(void)
 {
-	unsigned long *pgd;
+	pmd_t *pmd;
 
 	if (early_ioremap_debug)
 		printk("early_ioremap_clear()\n");
 
-	pgd = early_ioremap_pgd(fix_to_virt(FIX_BTMAP_BEGIN));
-	*pgd = 0;
+	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
+	pmd_clear(pmd);
 	__flush_tlb_all();
 }
 
 void __init early_ioremap_reset(void)
 {
 	enum fixed_addresses idx;
-	unsigned long *pte, phys, addr;
+	unsigned long addr, phys;
+	pte_t *pte;
 
 	after_paging_init = 1;
 	for (idx = FIX_BTMAP_BEGIN; idx <= FIX_BTMAP_END; idx--) {
 		addr = fix_to_virt(idx);
 		pte = early_ioremap_pte(addr);
-		if (!*pte & _PAGE_PRESENT) {
-			phys = *pte & PAGE_MASK;
+		if (pte_present(*pte)) {
+			phys = pte_val(*pte) & PAGE_MASK;
 			set_fixmap(idx, phys);
 		}
 	}
@@ -298,7 +304,8 @@ void __init early_ioremap_reset(void)
 static void __init __early_set_fixmap(enum fixed_addresses idx,
 				   unsigned long phys, pgprot_t flags)
 {
-	unsigned long *pte, addr = __fix_to_virt(idx);
+	unsigned long addr = __fix_to_virt(idx);
+	pte_t *pte;
 
 	if (idx >= __end_of_fixed_addresses) {
 		BUG();
@@ -306,9 +313,9 @@ static void __init __early_set_fixmap(enum fixed_addresses idx,
 	}
 	pte = early_ioremap_pte(addr);
 	if (pgprot_val(flags))
-		*pte = (phys & PAGE_MASK) | pgprot_val(flags);
+		set_pte(pte, pfn_pte(phys >> PAGE_SHIFT, flags));
 	else
-		*pte = 0;
+		pte_clear(NULL, addr, pte);
 	__flush_tlb_one(addr);
 }
 
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
index 11c4b39..8fc0473 100644
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -48,7 +48,6 @@ typedef unsigned long	pgprotval_t;
 typedef unsigned long	phys_addr_t;
 
 typedef union { pteval_t pte, pte_low; } pte_t;
-typedef pte_t boot_pte_t;
 
 #endif	/* __ASSEMBLY__ */
 #endif	/* CONFIG_X86_PAE */
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index 11c8b73..c07389b 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -55,10 +55,6 @@ int text_address(unsigned long);
 #define USER_PGD_PTRS (PAGE_OFFSET >> PGDIR_SHIFT)
 #define KERNEL_PGD_PTRS (PTRS_PER_PGD-USER_PGD_PTRS)
 
-#define TWOLEVEL_PGDIR_SHIFT	22
-#define BOOT_USER_PGD_PTRS (__PAGE_OFFSET >> TWOLEVEL_PGDIR_SHIFT)
-#define BOOT_KERNEL_PGD_PTRS (1024-BOOT_USER_PGD_PTRS)
-
 /* Just any arbitrary offset to the start of the vmalloc VM area: the
  * current 8MB value just means that there will be a 8MB "hole" after the
  * physical memory until the kernel virtual memory starts.  That means that
-- 
1.5.3.8

