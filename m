Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbYAVUC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbYAVUC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbYAVUCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:02:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45466 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbYAVUCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:02:05 -0500
Message-ID: <47964B7B.9000905@zytor.com>
Date: Tue, 22 Jan 2008 12:00:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk>	 <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>	 <47939363.8040603@kolumbus.fi>	 <1200950633.15491.21.camel@cthulhu.hellion.org.uk>	 <479510CE.7010706@zytor.com>	 <1200951996.15491.28.camel@cthulhu.hellion.org.uk>	 <479551FD.5040801@zytor.com>	 <1201023401.5643.52.camel@localhost.localdomain>	 <479634A9.1090908@zytor.com> <1201031325.15491.66.camel@cthulhu.hellion.org.uk>
In-Reply-To: <1201031325.15491.66.camel@cthulhu.hellion.org.uk>
Content-Type: multipart/mixed;
 boundary="------------000707070807060406010503"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000707070807060406010503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ian Campbell wrote:
> On Tue, 2008-01-22 at 10:23 -0800, H. Peter Anvin wrote:
>> Ian Campbell wrote:
>>> Anyhow, I don't feel all that strongly about it so if the opinion of the
>>> early start of day maintainer(s) is strongly in favour of ASM I'll defer
>>> to that.
>>>
>> My opinion is that I want it done properly (PIC and all that jazz) or 
>> not at all, and certainly would not want to mix linear and 
>> paging-enabled code in the same file.  When it comes to assembly code, 
>> at least people can *see* that there there be dragons.
>>
>> The plus *and* minus of a C version is that it's easier for people to 
>> modify.  The plus side of that is that if we really need it, it's a lot 
>> cleaner; the minus side is that it may encourage more code to creep into 
>> the pre-paging code, which would not be a good thing IMO.
> 
> Seems reasonable to me. I'll integrate your asm diff with the other
> changes and give it a whirl.

This version boots into userspace on both PAE and !PAE.  You want to 
take it from here?

	-hpa

--------------000707070807060406010503
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index f409fe2..d6a1e04 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -18,6 +18,10 @@
 #include <asm/thread_info.h>
 #include <asm/asm-offsets.h>
 #include <asm/setup.h>
+#include <asm/processor-flags.h>
+
+/* Physical address */
+#define pa(X) ((X) - __PAGE_OFFSET)
 
 /*
  * References to members of the new_cpu_data structure.
@@ -79,10 +83,6 @@ INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE + ALLOCATOR_SLOP)*PAGE_
  */
 .section .text.head,"ax",@progbits
 ENTRY(startup_32)
-	/* check to see if KEEP_SEGMENTS flag is meaningful */
-	cmpw $0x207, BP_version(%esi)
-	jb 1f
-
 	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
 		us to not reload segments */
 	testb $(1<<6), BP_loadflags(%esi)
@@ -91,7 +91,7 @@ ENTRY(startup_32)
 /*
  * Set segments to known values.
  */
-1:	lgdt boot_gdt_descr - __PAGE_OFFSET
+1:	lgdt pa(boot_gdt_descr)
 	movl $(__BOOT_DS),%eax
 	movl %eax,%ds
 	movl %eax,%es
@@ -104,8 +104,8 @@ ENTRY(startup_32)
  */
 	cld
 	xorl %eax,%eax
-	movl $__bss_start - __PAGE_OFFSET,%edi
-	movl $__bss_stop - __PAGE_OFFSET,%ecx
+	movl $pa(__bss_start),%edi
+	movl $pa(__bss_stop),%ecx
 	subl %edi,%ecx
 	shrl $2,%ecx
 	rep ; stosl
@@ -117,31 +117,32 @@ ENTRY(startup_32)
  * (kexec on panic case). Hence copy out the parameters before initializing
  * page tables.
  */
-	movl $(boot_params - __PAGE_OFFSET),%edi
+	movl $pa(boot_params),%edi
 	movl $(PARAM_SIZE/4),%ecx
 	cld
 	rep
 	movsl
-	movl boot_params - __PAGE_OFFSET + NEW_CL_POINTER,%esi
+	movl pa(boot_params) + NEW_CL_POINTER,%esi
 	andl %esi,%esi
 	jz 1f			# No comand line
-	movl $(boot_command_line - __PAGE_OFFSET),%edi
+	movl $pa(boot_command_line),%edi
 	movl $(COMMAND_LINE_SIZE/4),%ecx
 	rep
 	movsl
 1:
 
 #ifdef CONFIG_PARAVIRT
-	cmpw $0x207, (boot_params + BP_version - __PAGE_OFFSET)
+	/* This is can only trip for a broken bootloader... */
+	cmpw $0x207, pa(boot_params + BP_version)
 	jb default_entry
 
 	/* Paravirt-compatible boot parameters.  Look to see what architecture
 		we're booting under. */
-	movl (boot_params + BP_hardware_subarch - __PAGE_OFFSET), %eax
+	movl pa(boot_params + BP_hardware_subarch), %eax
 	cmpl $num_subarch_entries, %eax
 	jae bad_subarch
 
-	movl subarch_entries - __PAGE_OFFSET(,%eax,4), %eax
+	movl pa(subarch_entries)(,%eax,4), %eax
 	subl $__PAGE_OFFSET, %eax
 	jmp *%eax
 
@@ -167,17 +168,74 @@ num_subarch_entries = (. - subarch_entries) / 4
  * Mappings are created both at virtual address 0 (identity mapping)
  * and PAGE_OFFSET for up to _end+sizeof(page tables)+INIT_MAP_BEYOND_END.
  *
- * Warning: don't use %esi or the stack in this code.  However, %esp
- * can be used as a GPR if you really need it...
+ * Note that the stack is not yet set up!
  */
-page_pde_offset = (__PAGE_OFFSET >> 20);
+#define PTE_ATTR	0x007		/* PRESENT+RW+USER */
+#define PDE_ATTR	0x067		/* PRESENT+RW+USER+DIRTY+ACCESSED */
+#define PGD_ATTR	0x001		/* PRESENT (no other attributes) */
 
 default_entry:
-	movl $(pg0 - __PAGE_OFFSET), %edi
-	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx
-	movl $0x007, %eax			/* 0x007 = PRESENT+RW+USER */
+#ifdef CONFIG_X86_PAE
+	/*
+	 * In PAE mode, the kernel PMD is shared, and __PAGE_OFFSET
+	 * is guaranteed to be a multiple of 1 GB (the PGD granulatity.)
+	 * Thus, we only need to set up a single PMD here; the identity
+	 * mapping is handled by pointing two PGD entries to the PMD.
+	 *
+	 * Note the upper half of each PMD or PTE are always zero at
+	 * this stage.
+	 */
+page_pde_offset = (__PAGE_OFFSET >> 27);
+
+	movl %cr4, %eax
+	orl  $X86_CR4_PAE, %eax
+	movl %eax, %cr4
+
+	xorl %ebx,%ebx				/* %ebx is kept at zero */
+	
+	movl $pa(pg0), %edi
+	movl $pa(swapper_pg_pmd), %edx
+	movl $PTE_ATTR, %eax
+10:
+	leal PDE_ATTR(%edi),%ecx		/* Create PMD entry */
+	movl %ecx,(%edx)			/* Store PMD entry */
+						/* Upper half already zero */
+	addl $8,%edx
+	movl $512,%ecx
+11:
+	stosl
+	xchgl %eax,%ebx
+	stosl
+	xchgl %eax,%ebx
+	addl $0x1000,%eax
+	loop 11b
+
+	/*
+	 * End condition: we must map up to and including INIT_MAP_BEYOND_END
+	 * bytes beyond the end of our own page tables.
+	 */
+	leal (INIT_MAP_BEYOND_END+PTE_ATTR)(%edi),%ebp
+	cmpl %ebp,%eax
+	jb 10b
+	movl %edi,pa(init_pg_tables_end)
+
+	/* Set up the PGD */
+	movl $pa(swapper_pg_pmd)+PGD_ATTR, %eax
+	movl %eax, pa(swapper_pg_dir)			/* Identity map */
+	movl %eax, pa(swapper_pg_dir+page_pde_offset)	/* Kernel map */
+
+	/* Do early initialization of the fixmap area */
+	movl $pa(swapper_pg_fixmap)+PDE_ATTR,%eax
+	movl %eax,pa(swapper_pg_pmd+0xff8)
+#else	/* Not PAE */
+
+page_pde_offset = (__PAGE_OFFSET >> 20);
+	
+	movl $pa(pg0), %edi
+	movl $pa(swapper_pg_dir), %edx
+	movl $PTE_ATTR, %eax
 10:
-	leal 0x007(%edi),%ecx			/* Create PDE entry */
+	leal PDE_ATTR(%edi),%ecx		/* Create PDE entry */
 	movl %ecx,(%edx)			/* Store identity PDE entry */
 	movl %ecx,page_pde_offset(%edx)		/* Store kernel PDE entry */
 	addl $4,%edx
@@ -186,19 +244,20 @@ default_entry:
 	stosl
 	addl $0x1000,%eax
 	loop 11b
-	/* End condition: we must map up to and including INIT_MAP_BEYOND_END */
-	/* bytes beyond the end of our own page tables; the +0x007 is the attribute bits */
-	leal (INIT_MAP_BEYOND_END+0x007)(%edi),%ebp
+	/*
+	 * End condition: we must map up to and including INIT_MAP_BEYOND_END
+	 * bytes beyond the end of our own page tables; the +0x007 is
+	 * the attribute bits
+	 */
+	leal (INIT_MAP_BEYOND_END+PTE_ATTR)(%edi),%ebp
 	cmpl %ebp,%eax
 	jb 10b
-	movl %edi,(init_pg_tables_end - __PAGE_OFFSET)
-
-	/* Do an early initialization of the fixmap area */
-	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx
-	movl $(swapper_pg_pmd - __PAGE_OFFSET), %eax
-	addl $0x67, %eax			/* 0x67 == _PAGE_TABLE */
-	movl %eax, 4092(%edx)
+	movl %edi,pa(init_pg_tables_end)
 
+	/* Do early initialization of the fixmap area */
+	movl $pa(swapper_pg_fixmap)+PDE_ATTR,%eax
+	movl %eax,pa(swapper_pg_dir+0xffc)
+#endif
 	xorl %ebx,%ebx				/* This is the boot CPU (BSP) */
 	jmp 3f
 /*
@@ -237,7 +296,7 @@ ENTRY(startup_32_smp)
  *	NOTE! We have to correct for the fact that we're
  *	not yet offset PAGE_OFFSET..
  */
-#define cr4_bits mmu_cr4_features-__PAGE_OFFSET
+#define cr4_bits pa(mmu_cr4_features)
 	movl cr4_bits,%edx
 	andl %edx,%edx
 	jz 6f
@@ -278,10 +337,10 @@ ENTRY(startup_32_smp)
 /*
  * Enable paging
  */
-	movl $swapper_pg_dir-__PAGE_OFFSET,%eax
+	movl $pa(swapper_pg_dir),%eax
 	movl %eax,%cr3		/* set the page table pointer.. */
 	movl %cr0,%eax
-	orl $0x80000000,%eax
+	orl  $X86_CR0_PG,%eax
 	movl %eax,%cr0		/* ..and set paging (PG) bit */
 	ljmp $__BOOT_CS,$1f	/* Clear prefetch and normalize %eip */
 1:
@@ -556,8 +615,12 @@ ENTRY(_stext)
 	.align PAGE_SIZE_asm
 ENTRY(swapper_pg_dir)
 	.fill 1024,4,0
+#ifdef CONFIG_X86_PAE
 ENTRY(swapper_pg_pmd)
 	.fill 1024,4,0
+#endif
+ENTRY(swapper_pg_fixmap)
+	.fill 1024,4,0
 ENTRY(empty_zero_page)
 	.fill 4096,1,0
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index cbba769..14c6c41 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -43,6 +43,7 @@
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
 #include <asm/paravirt.h>
+#include <asm/setup.h>
 
 unsigned int __VMALLOC_RESERVE = 128 << 20;
 
@@ -353,44 +354,11 @@ extern void __init remap_numa_kva(void);
 
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
@@ -399,9 +367,8 @@ void __init native_pagetable_setup_done(pgd_t *base)
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

--------------000707070807060406010503--
