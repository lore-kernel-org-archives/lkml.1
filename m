Return-Path: <linux-kernel-owner+w=401wt.eu-S932843AbYASQJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843AbYASQJf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 11:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761696AbYASQJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 11:09:25 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:41728 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932642AbYASQJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 11:09:22 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat, 19 Jan 2008 16:08:57 +0000
Message-Id: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk>
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk>
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH] x86: Construct 32 bit boot time page tables in native format.
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
---
 arch/x86/kernel/head_32.S      |  116 +++++++++++++------------------------
 arch/x86/kernel/setup_32.c     |    4 +
 arch/x86/mm/Makefile_32        |    2 +-
 arch/x86/mm/early_pgtable_32.c |  125 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/init_32.c          |   45 --------------
 arch/x86/mm/ioremap_32.c       |   53 ++++++++++-------
 include/asm-x86/page_32.h      |    1 -
 include/asm-x86/pgtable_32.h   |    4 -
 8 files changed, 201 insertions(+), 149 deletions(-)
 create mode 100644 arch/x86/mm/early_pgtable_32.c

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index f409fe2..2090aa4 100644
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
@@ -160,47 +122,52 @@ num_subarch_entries = (. - subarch_entries) / 4
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
+#define cr4_bits mmu_cr4_features-__PAGE_OFFSET
 
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
+
+	movl cr4_bits,%edx
+	andl %edx,%edx
+	jz 1f
+	movl %cr4,%eax		# Turn on paging options (PSE,PAE,..)
+	orl %edx,%eax
+	movl %eax,%cr4
+1:
+#ifdef CONFIG_X86_PAE
+	btl $5, %eax
+	jnc err_no_pae
+#endif
 
 	xorl %ebx,%ebx				/* This is the boot CPU (BSP) */
 	jmp 3f
+
+#ifdef CONFIG_X86_PAE
+err_no_pae:
+	/* It is probably too early but we might as well try... */
+#ifdef CONFIG_PRINTK
+	pusha
+	pushl %eax
+	pushl $err_no_pae_msg - __PAGE_OFFSET
+#ifdef CONFIG_EARLY_PRINTK
+	call early_printk - __PAGE_OFFSET
+#else
+	call printk - __PAGE_OFFSET
+#endif
+#endif
+	jmp hlt_loop
+
+err_no_pae_msg:
+	.ascii "cannot execute a PAE-enabled kernel on a PAE-less CPU!"
+	.ascii " (CR4 %lx)\n"
+	.byte  0
+#endif
+
 /*
  * Non-boot CPU entry point; entered from trampoline.S
  * We can't lgdt here, because lgdt itself uses a data segment, but
@@ -237,7 +204,6 @@ ENTRY(startup_32_smp)
  *	NOTE! We have to correct for the fact that we're
  *	not yet offset PAGE_OFFSET..
  */
-#define cr4_bits mmu_cr4_features-__PAGE_OFFSET
 	movl cr4_bits,%edx
 	andl %edx,%edx
 	jz 6f
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
diff --git a/arch/x86/mm/Makefile_32 b/arch/x86/mm/Makefile_32
index 2f69025..1b8c09f 100644
--- a/arch/x86/mm/Makefile_32
+++ b/arch/x86/mm/Makefile_32
@@ -2,7 +2,7 @@
 # Makefile for the linux i386-specific parts of the memory manager.
 #
 
-obj-y	:= init_32.o pgtable_32.o fault_32.o ioremap_32.o extable.o pageattr_32.o mmap.o pat.o ioremap.o
+obj-y	:= init_32.o pgtable_32.o fault_32.o ioremap_32.o extable.o pageattr_32.o mmap.o pat.o ioremap.o early_pgtable_32.o
 
 obj-$(CONFIG_CPA_DEBUG) += pageattr-test.o
 obj-$(CONFIG_NUMA) += discontig_32.o
diff --git a/arch/x86/mm/early_pgtable_32.c b/arch/x86/mm/early_pgtable_32.c
new file mode 100644
index 0000000..dc5d648
--- /dev/null
+++ b/arch/x86/mm/early_pgtable_32.c
@@ -0,0 +1,125 @@
+/*
+ * Construct boot time page tables.
+ */
+
+/*
+ * Since a paravirt guest will never come down this path we want
+ * native style page table accessors here.
+ */
+#undef CONFIG_PARAVIRT
+
+#include <linux/pagemap.h>
+
+#include <asm/setup.h>
+
+/*
+ * This is how much memory *in addition to the memory covered up to
+ * and including _end* we need mapped initially.  We need one bit for
+ * each possible page, but only in low memory, which means
+ * 2^32/4096/8 = 128K worst case (4G/4G split.)
+ *
+ * Modulo rounding, each megabyte assigned here requires a kilobyte of
+ * memory, which is currently unreclaimed.
+ *
+ * This should be a multiple of a page.
+ */
+#define INIT_MAP_BEYOND_END	(128*1024)
+
+/*
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
+static inline __init pud_t *early_pud_offset(pgd_t *pgd, unsigned long vaddr)
+{
+	return (pud_t *)(pgd + pgd_index(vaddr));
+}
+
+static inline __init pmd_t *early_pmd_offset(pud_t *pud, unsigned long vaddr)
+{
+#ifndef CONFIG_X86_PAE
+	return (pmd_t *)pud;
+#else
+	return ((pmd_t *)(u32)(pud_val(*pud) & PAGE_MASK))
+		+ pmd_index(vaddr);
+#endif
+}
+
+static inline __init pte_t *early_pte_offset(pmd_t *pmd, unsigned long vaddr)
+{
+	return ((pte_t *)(u32)(pmd_val(*pmd) & PAGE_MASK))
+		+ pte_index(vaddr);
+}
+
+static inline __init pmd_t *
+early_pmd_alloc(pgd_t *pgd_base, unsigned long vaddr, unsigned long *end)
+{
+	pud_t *pud = early_pud_offset(pgd_base, vaddr);
+
+#ifdef CONFIG_X86_PAE
+	if (!(pud_val(*pud) & _PAGE_PRESENT)) {
+		unsigned long phys = *end;
+		memset((void *)phys, 0, PAGE_SIZE);
+		set_pud(pud, __pud(phys | _PAGE_PRESENT));
+		*end += PAGE_SIZE;
+	}
+#endif
+	return early_pmd_offset(pud, vaddr);
+}
+
+static __init pte_t *
+early_pte_alloc(pgd_t *pgd_base, unsigned long vaddr, unsigned long *end)
+{
+	pmd_t *pmd;
+
+	pmd = early_pmd_alloc(pgd_base, vaddr, end);
+	if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
+		unsigned long phys = *end;
+		memset((void *)phys, 0, PAGE_SIZE);
+		set_pmd(pmd, __pmd(phys | _PAGE_TABLE));
+		*end += PAGE_SIZE;
+	}
+	return early_pte_offset(pmd, vaddr);
+}
+
+static __init void early_set_pte_phys(pgd_t *pgd_base, unsigned long vaddr,
+				      unsigned long phys, unsigned long *end)
+{
+	pte_t *pte;
+	pte = early_pte_alloc(pgd_base, vaddr, end);
+	set_pte(pte, __pte(phys | _PAGE_KERNEL_EXEC));
+}
+
+void __init early_pgtable_init(void)
+{
+	unsigned long addr, end;
+	pgd_t *pgd_base;
+
+	pgd_base = __pavar(swapper_pg_dir);
+	end = __pa_symbol(pg0);
+
+	/* Initialize the directory page */
+	memset(pgd_base, 0, PAGE_SIZE);
+
+	/* Set up the fixmap page table */
+	early_pte_alloc(pgd_base, __pavar(__FIXADDR_TOP), &end);
+
+	/* Set up the initial kernel mapping */
+	for (addr = 0; addr < (end + INIT_MAP_BEYOND_END); addr += PAGE_SIZE)
+		early_set_pte_phys(pgd_base, addr + PAGE_OFFSET, addr, &end);
+
+
+	/* Set up the low identity mappings */
+	clone_pgd_range(pgd_base, pgd_base + USER_PTRS_PER_PGD,
+			min_t(unsigned long, KERNEL_PGD_PTRS, USER_PGD_PTRS));
+
+	__pavar(init_pg_tables_end) = end;
+}
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index cbba769..2f94a3a 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -353,44 +353,11 @@ extern void __init remap_numa_kva(void);
 
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
@@ -559,14 +526,6 @@ void __init paging_init(void)
 
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
@@ -696,10 +655,6 @@ void __init mem_init(void)
 	BUG_ON((unsigned long)high_memory      > VMALLOC_START);
 #endif /* double-sanity-check paranoia */
 
-#ifdef CONFIG_X86_PAE
-	if (!cpu_has_pae)
-		panic("cannot execute a PAE-enabled kernel on a PAE-less CPU!");
-#endif
 	if (boot_cpu_data.wp_works_ok < 0)
 		test_wp_bit();
 
diff --git a/arch/x86/mm/ioremap_32.c b/arch/x86/mm/ioremap_32.c
index 05a24cd..73a36cd 100644
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
+		if (!(pte_val(*pte) & _PAGE_PRESENT)) {
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

