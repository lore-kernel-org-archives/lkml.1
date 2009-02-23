Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZBWNim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZBWNim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 08:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZBWNid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 08:38:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58576 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005AbZBWNib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 08:38:31 -0500
Date: Mon, 23 Feb 2009 14:38:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jeremy@goop.org, cpw@sgi.com
Subject: [patch] x86: optimize __pa() to be linear again on 64-bit x86
Message-ID: <20090223133804.GA20468@elte.hu>
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <499CA834.4080208@kernel.org> <20090219110718.GK2354@elte.hu> <499E20BC.4020408@kernel.org> <20090220093234.GF24555@elte.hu> <499FA8D1.8030806@kernel.org> <499FAE55.8070801@kernel.org> <20090222193817.GC21320@elte.hu> <49A1F132.8080004@kernel.org> <20090223101741.GP9582@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223101741.GP9582@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > Are __pa()/__va() that hot paths?  Or am I over-estimating 
> > the cost of 2MB dTLB?
> 
> yes, __pa()/__va() is a very hot path - in a defconfig they 
> are used in about a thousand different places.
> 
> In fact it would be nice to get rid of the __phys_addr() 
> redirection on the 64-bit side (which is non-linear and a 
> function there, and all __pa()s go through it) and make it a 
> constant offset again.
> 
> This isnt trivial/possible to do though as .data/.bss is in 
> the high alias. (high .text aliases alone wouldnt be a big 
> issue to fix, but the data aliases are an issue.)
> 
> Moving .data/.bss into the linear space isnt feasible as we'd 
> lose RIP-relative addressing shortcuts.
> 
> Maybe we could figure out the places that do __pa() on a high 
> alias and gradually eliminate them. __pa() on .data/.bss is a 
> rare and unusal thing to do, and CONFIG_DEBUG_VIRTUAL could 
> warn about them without crashing the kernel.
> 
> Later on we could make this check unconditional, and then 
> switch over __pa() to addr-PAGE_OFFSET in the 
> !CONFIG_DEBUG_VIRTUAL case (which is the default).

Ok, i couldnt resist and using ftrace_printk() (regular printk 
in __pa() would hang during bootup) and came up with the patch 
below - which allows the second patch below that does:

 -#define __pa(x)		__phys_addr((unsigned long)(x))
 +#define __pa(x)		((unsigned long)(x)-PAGE_OFFSET)

It cuts a nice (and hotly executed) ~650 bytes chunk out of the 
x86 64-bit defconfig kernel text:

    text	   data	    bss	    dec	    hex	filename
 7999071	1137780	 843672	9980523	 984a6b	vmlinux.before
 7998414	1137780	 843672	9979866	 9847da	vmlinux.after

And it even boots.

(the load_cr3() hack needs to be changed, by setting the init 
pgdir from init_level4_pgt to __va(__pa_symbol(init_level4_pgt).)

(32-bit is untested and likely wont even build.)

It's not even that bad and looks quite maintainable as a 
concept.

This also means that __va() and __pa() will be one and the same 
thing simple arithmetics again on both 32-bit and 64-bit 
kernels.

	Ingo

---
 arch/x86/include/asm/page.h          |    4 +++-
 arch/x86/include/asm/page_64_types.h |    1 +
 arch/x86/include/asm/pgalloc.h       |    4 ++--
 arch/x86/include/asm/pgtable.h       |    2 +-
 arch/x86/include/asm/processor.h     |    7 ++++++-
 arch/x86/kernel/setup.c              |   12 ++++++------
 arch/x86/mm/init_64.c                |    6 +++---
 arch/x86/mm/ioremap.c                |   12 +++++++++++-
 arch/x86/mm/pageattr.c               |   28 ++++++++++++++--------------
 arch/x86/mm/pgtable.c                |    2 +-
 10 files changed, 48 insertions(+), 30 deletions(-)

Index: linux/arch/x86/include/asm/page.h
===================================================================
--- linux.orig/arch/x86/include/asm/page.h
+++ linux/arch/x86/include/asm/page.h
@@ -34,10 +34,11 @@ static inline void copy_user_page(void *
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
 
 #define __pa(x)		__phys_addr((unsigned long)(x))
+#define __pa_slow(x)		__phys_addr_slow((unsigned long)(x))
 #define __pa_nodebug(x)	__phys_addr_nodebug((unsigned long)(x))
 /* __pa_symbol should be used for C visible symbols.
    This seems to be the official gcc blessed way to do such arithmetic. */
-#define __pa_symbol(x)	__pa(__phys_reloc_hide((unsigned long)(x)))
+#define __pa_symbol(x)	__pa_slow(__phys_reloc_hide((unsigned long)(x)))
 
 #define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
 
@@ -49,6 +50,7 @@ static inline void copy_user_page(void *
  * virt_addr_valid(kaddr) returns true.
  */
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
+#define virt_to_page_slow(kaddr) pfn_to_page(__pa_slow(kaddr) >> PAGE_SHIFT)
 #define pfn_to_kaddr(pfn)      __va((pfn) << PAGE_SHIFT)
 extern bool __virt_addr_valid(unsigned long kaddr);
 #define virt_addr_valid(kaddr)	__virt_addr_valid((unsigned long) (kaddr))
Index: linux/arch/x86/include/asm/page_64_types.h
===================================================================
--- linux.orig/arch/x86/include/asm/page_64_types.h
+++ linux/arch/x86/include/asm/page_64_types.h
@@ -67,6 +67,7 @@ extern unsigned long max_pfn;
 extern unsigned long phys_base;
 
 extern unsigned long __phys_addr(unsigned long);
+extern unsigned long __phys_addr_slow(unsigned long);
 #define __phys_reloc_hide(x)	(x)
 
 #define vmemmap ((struct page *)VMEMMAP_START)
Index: linux/arch/x86/include/asm/pgalloc.h
===================================================================
--- linux.orig/arch/x86/include/asm/pgalloc.h
+++ linux/arch/x86/include/asm/pgalloc.h
@@ -51,8 +51,8 @@ extern void __pte_free_tlb(struct mmu_ga
 static inline void pmd_populate_kernel(struct mm_struct *mm,
 				       pmd_t *pmd, pte_t *pte)
 {
-	paravirt_alloc_pte(mm, __pa(pte) >> PAGE_SHIFT);
-	set_pmd(pmd, __pmd(__pa(pte) | _PAGE_TABLE));
+	paravirt_alloc_pte(mm, __pa_symbol(pte) >> PAGE_SHIFT);
+	set_pmd(pmd, __pmd(__pa_symbol(pte) | _PAGE_TABLE));
 }
 
 static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
Index: linux/arch/x86/include/asm/pgtable.h
===================================================================
--- linux.orig/arch/x86/include/asm/pgtable.h
+++ linux/arch/x86/include/asm/pgtable.h
@@ -20,7 +20,7 @@
  * for zero-mapped memory areas etc..
  */
 extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
-#define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
+#define ZERO_PAGE(vaddr) (virt_to_page_slow(empty_zero_page))
 
 extern spinlock_t pgd_lock;
 extern struct list_head pgd_list;
Index: linux/arch/x86/include/asm/processor.h
===================================================================
--- linux.orig/arch/x86/include/asm/processor.h
+++ linux/arch/x86/include/asm/processor.h
@@ -186,9 +186,14 @@ static inline void native_cpuid(unsigned
 	    : "0" (*eax), "2" (*ecx));
 }
 
+extern pgd_t init_level4_pgt[];
+
 static inline void load_cr3(pgd_t *pgdir)
 {
-	write_cr3(__pa(pgdir));
+	if (pgdir == init_level4_pgt)
+		write_cr3((unsigned long)(pgdir) - __START_KERNEL_map);
+	else
+		write_cr3(__pa(pgdir));
 }
 
 #ifdef CONFIG_X86_32
Index: linux/arch/x86/kernel/setup.c
===================================================================
--- linux.orig/arch/x86/kernel/setup.c
+++ linux/arch/x86/kernel/setup.c
@@ -733,12 +733,12 @@ void __init setup_arch(char **cmdline_p)
 	init_mm.brk = (unsigned long) &_end;
 #endif
 
-	code_resource.start = virt_to_phys(_text);
-	code_resource.end = virt_to_phys(_etext)-1;
-	data_resource.start = virt_to_phys(_etext);
-	data_resource.end = virt_to_phys(_edata)-1;
-	bss_resource.start = virt_to_phys(&__bss_start);
-	bss_resource.end = virt_to_phys(&__bss_stop)-1;
+	code_resource.start = __pa_symbol(_text);
+	code_resource.end = __pa_symbol(_etext)-1;
+	data_resource.start = __pa_symbol(_etext);
+	data_resource.end = __pa_symbol(_edata)-1;
+	bss_resource.start = __pa_symbol(&__bss_start);
+	bss_resource.end = __pa_symbol(&__bss_stop)-1;
 
 #ifdef CONFIG_CMDLINE_BOOL
 #ifdef CONFIG_CMDLINE_OVERRIDE
Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -965,11 +965,11 @@ void free_init_pages(char *what, unsigne
 	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
 
 	for (; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
+		ClearPageReserved(virt_to_page_slow(addr));
+		init_page_count(virt_to_page_slow(addr));
 		memset((void *)(addr & ~(PAGE_SIZE-1)),
 			POISON_FREE_INITMEM, PAGE_SIZE);
-		free_page(addr);
+		free_page((unsigned long)__va(__pa_symbol(addr)));
 		totalram_pages++;
 	}
 #endif
Index: linux/arch/x86/mm/ioremap.c
===================================================================
--- linux.orig/arch/x86/mm/ioremap.c
+++ linux/arch/x86/mm/ioremap.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/mmiotrace.h>
+#include <linux/ftrace.h>
 
 #include <asm/cacheflush.h>
 #include <asm/e820.h>
@@ -29,7 +30,7 @@ static inline int phys_addr_valid(unsign
 	return addr < (1UL << boot_cpu_data.x86_phys_bits);
 }
 
-unsigned long __phys_addr(unsigned long x)
+unsigned long __phys_addr_slow(unsigned long x)
 {
 	if (x >= __START_KERNEL_map) {
 		x -= __START_KERNEL_map;
@@ -43,6 +44,15 @@ unsigned long __phys_addr(unsigned long 
 	}
 	return x;
 }
+EXPORT_SYMBOL(__phys_addr_slow);
+
+unsigned long __phys_addr(unsigned long x)
+{
+	if (x >= __START_KERNEL_map)
+		ftrace_printk("__phys_addr() done on symbol: %p\n", (void *)x);
+
+	return __phys_addr_slow(x);
+}
 EXPORT_SYMBOL(__phys_addr);
 
 bool __virt_addr_valid(unsigned long x)
Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -90,12 +90,12 @@ static inline void split_page_count(int 
 
 static inline unsigned long highmap_start_pfn(void)
 {
-	return __pa(_text) >> PAGE_SHIFT;
+	return __pa_symbol(_text) >> PAGE_SHIFT;
 }
 
 static inline unsigned long highmap_end_pfn(void)
 {
-	return __pa(roundup((unsigned long)_end, PMD_SIZE)) >> PAGE_SHIFT;
+	return __pa_symbol(roundup((unsigned long)_end, PMD_SIZE)) >> PAGE_SHIFT;
 }
 
 #endif
@@ -266,8 +266,8 @@ static inline pgprot_t static_protection
 	 * The .rodata section needs to be read-only. Using the pfn
 	 * catches all aliases.
 	 */
-	if (within(pfn, __pa((unsigned long)__start_rodata) >> PAGE_SHIFT,
-		   __pa((unsigned long)__end_rodata) >> PAGE_SHIFT))
+	if (within(pfn, __pa_symbol((unsigned long)__start_rodata) >> PAGE_SHIFT,
+		   __pa_symbol((unsigned long)__end_rodata) >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_RW;
 
 	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
@@ -555,7 +555,7 @@ static int __cpa_process_fault(struct cp
 	if (within(vaddr, PAGE_OFFSET,
 		   PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))) {
 		cpa->numpages = 1;
-		cpa->pfn = __pa(vaddr) >> PAGE_SHIFT;
+		cpa->pfn = __pa_symbol(vaddr) >> PAGE_SHIFT;
 		return 0;
 	} else {
 		WARN(1, KERN_WARNING "CPA: called for zero pte. "
@@ -901,7 +901,7 @@ int set_memory_uc(unsigned long addr, in
 	/*
 	 * for now UC MINUS. see comments in ioremap_nocache()
 	 */
-	if (reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
+	if (reserve_memtype(__pa_symbol(addr), __pa_symbol(addr) + numpages * PAGE_SIZE,
 			    _PAGE_CACHE_UC_MINUS, NULL))
 		return -EINVAL;
 
@@ -918,9 +918,9 @@ int set_memory_array_uc(unsigned long *a
 	 * for now UC MINUS. see comments in ioremap_nocache()
 	 */
 	for (i = 0; i < addrinarray; i++) {
-		start = __pa(addr[i]);
+		start = __pa_symbol(addr[i]);
 		for (end = start + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
-			if (end != __pa(addr[i + 1]))
+			if (end != __pa_symbol(addr[i + 1]))
 				break;
 			i++;
 		}
@@ -932,12 +932,12 @@ int set_memory_array_uc(unsigned long *a
 				    __pgprot(_PAGE_CACHE_UC_MINUS), 1);
 out:
 	for (i = 0; i < addrinarray; i++) {
-		unsigned long tmp = __pa(addr[i]);
+		unsigned long tmp = __pa_symbol(addr[i]);
 
 		if (tmp == start)
 			break;
 		for (end = tmp + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
-			if (end != __pa(addr[i + 1]))
+			if (end != __pa_symbol(addr[i + 1]))
 				break;
 			i++;
 		}
@@ -958,7 +958,7 @@ int set_memory_wc(unsigned long addr, in
 	if (!pat_enabled)
 		return set_memory_uc(addr, numpages);
 
-	if (reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
+	if (reserve_memtype(__pa_symbol(addr), __pa_symbol(addr) + numpages * PAGE_SIZE,
 		_PAGE_CACHE_WC, NULL))
 		return -EINVAL;
 
@@ -974,7 +974,7 @@ int _set_memory_wb(unsigned long addr, i
 
 int set_memory_wb(unsigned long addr, int numpages)
 {
-	free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
+	free_memtype(__pa_symbol(addr), __pa_symbol(addr) + numpages * PAGE_SIZE);
 
 	return _set_memory_wb(addr, numpages);
 }
@@ -985,11 +985,11 @@ int set_memory_array_wb(unsigned long *a
 	int i;
 
 	for (i = 0; i < addrinarray; i++) {
-		unsigned long start = __pa(addr[i]);
+		unsigned long start = __pa_symbol(addr[i]);
 		unsigned long end;
 
 		for (end = start + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
-			if (end != __pa(addr[i + 1]))
+			if (end != __pa_symbol(addr[i + 1]))
 				break;
 			i++;
 		}
Index: linux/arch/x86/mm/pgtable.c
===================================================================
--- linux.orig/arch/x86/mm/pgtable.c
+++ linux/arch/x86/mm/pgtable.c
@@ -77,7 +77,7 @@ static void pgd_ctor(pgd_t *pgd)
 				swapper_pg_dir + KERNEL_PGD_BOUNDARY,
 				KERNEL_PGD_PTRS);
 		paravirt_alloc_pmd_clone(__pa(pgd) >> PAGE_SHIFT,
-					 __pa(swapper_pg_dir) >> PAGE_SHIFT,
+					 __pa_symbol(swapper_pg_dir) >> PAGE_SHIFT,
 					 KERNEL_PGD_BOUNDARY,
 					 KERNEL_PGD_PTRS);
 	}

---
 arch/x86/include/asm/page.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/include/asm/page.h
===================================================================
--- linux.orig/arch/x86/include/asm/page.h
+++ linux/arch/x86/include/asm/page.h
@@ -33,7 +33,7 @@ static inline void copy_user_page(void *
 	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
 
-#define __pa(x)		__phys_addr((unsigned long)(x))
+#define __pa(x)		((unsigned long)(x)-PAGE_OFFSET)
 #define __pa_slow(x)		__phys_addr_slow((unsigned long)(x))
 #define __pa_nodebug(x)	__phys_addr_nodebug((unsigned long)(x))
 /* __pa_symbol should be used for C visible symbols.
