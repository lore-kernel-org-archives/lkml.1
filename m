Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab0BICoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 21:44:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:41083 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab0BICoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 21:44:09 -0500
Subject: Re: [CFT] MM: Pass a PTE pointer to update_mmu_cache() rather than
 the PTE itself
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100120135202.GA20937@flint.arm.linux.org.uk>
References: <20100120135202.GA20937@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Feb 2010 13:43:16 +1100
Message-ID: <1265683396.8287.269.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 13:52 +0000, Russell King wrote:
> On VIVT ARM, when we have multiple shared mappings of the same file
> in the same MM, we need to ensure that we have coherency across all
> copies.  We do this via make_coherent() by making the pages
> uncacheable.

 .../...

> So, pass in the mapped page table pointer into update_mmu_cache(), and
> remove the PTE value, updating all implementations and call sites to
> suit.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Tested and seems to work fine on powerpc.

Cheers,
Ben.

> ---
>  Documentation/cachetlb.txt             |    6 +++---
>  arch/alpha/include/asm/pgtable.h       |    2 +-
>  arch/arm/include/asm/tlbflush.h        |    3 ++-
>  arch/arm/mm/fault-armv.c               |    5 +++--
>  arch/avr32/include/asm/pgtable.h       |    2 +-
>  arch/avr32/mm/tlb.c                    |    4 ++--
>  arch/cris/include/asm/pgtable.h        |    2 +-
>  arch/frv/include/asm/pgtable.h         |    2 +-
>  arch/ia64/include/asm/pgtable.h        |    2 +-
>  arch/m32r/include/asm/tlbflush.h       |    2 +-
>  arch/m32r/mm/fault-nommu.c             |    2 +-
>  arch/m32r/mm/fault.c                   |    6 +++---
>  arch/m68k/include/asm/pgtable_mm.h     |    2 +-
>  arch/microblaze/include/asm/tlbflush.h |    2 +-
>  arch/mips/include/asm/pgtable.h        |    3 ++-
>  arch/mn10300/include/asm/pgtable.h     |    2 +-
>  arch/mn10300/mm/mmu-context.c          |    3 ++-
>  arch/parisc/include/asm/pgtable.h      |    2 +-
>  arch/parisc/kernel/cache.c             |    4 ++--
>  arch/powerpc/include/asm/pgtable.h     |    2 +-
>  arch/powerpc/mm/mem.c                  |    4 ++--
>  arch/s390/include/asm/pgtable.h        |    2 +-
>  arch/score/include/asm/pgtable.h       |    3 ++-
>  arch/sh/include/asm/pgtable.h          |    3 ++-
>  arch/sh/mm/fault_32.c                  |    2 +-
>  arch/sparc/include/asm/pgtable_32.h    |    4 ++--
>  arch/sparc/include/asm/pgtable_64.h    |    2 +-
>  arch/sparc/mm/fault_32.c               |    4 ++--
>  arch/sparc/mm/init_64.c                |    3 ++-
>  arch/sparc/mm/nosun4c.c                |    2 +-
>  arch/sparc/mm/srmmu.c                  |    6 +++---
>  arch/sparc/mm/sun4c.c                  |    2 +-
>  arch/um/include/asm/pgtable.h          |    2 +-
>  arch/x86/include/asm/pgtable_32.h      |    2 +-
>  arch/x86/include/asm/pgtable_64.h      |    2 +-
>  arch/xtensa/include/asm/pgtable.h      |    2 +-
>  arch/xtensa/mm/cache.c                 |    4 ++--
>  mm/hugetlb.c                           |    4 ++--
>  mm/memory.c                            |   14 +++++++-------
>  mm/migrate.c                           |    2 +-
>  40 files changed, 67 insertions(+), 60 deletions(-)
> 
> diff --git a/Documentation/cachetlb.txt b/Documentation/cachetlb.txt
> index da42ab4..74a8b6f 100644
> --- a/Documentation/cachetlb.txt
> +++ b/Documentation/cachetlb.txt
> @@ -88,12 +88,12 @@ changes occur:
>  	This is used primarily during fault processing.
>  
>  5) void update_mmu_cache(struct vm_area_struct *vma,
> -			 unsigned long address, pte_t pte)
> +			 unsigned long address, pte_t *ptep)
>  
>  	At the end of every page fault, this routine is invoked to
>  	tell the architecture specific code that a translation
> -	described by "pte" now exists at virtual address "address"
> -	for address space "vma->vm_mm", in the software page tables.
> +	now exists at virtual address "address" for address space
> +	"vma->vm_mm", in the software page tables.
>  
>  	A port may use this information in any way it so chooses.
>  	For example, it could use this event to pre-load TLB
> diff --git a/arch/alpha/include/asm/pgtable.h b/arch/alpha/include/asm/pgtable.h
> index 3f0c59f..71a2432 100644
> --- a/arch/alpha/include/asm/pgtable.h
> +++ b/arch/alpha/include/asm/pgtable.h
> @@ -329,7 +329,7 @@ extern pgd_t swapper_pg_dir[1024];
>   * tables contain all the necessary information.
>   */
>  extern inline void update_mmu_cache(struct vm_area_struct * vma,
> -	unsigned long address, pte_t pte)
> +	unsigned long address, pte_t *ptep)
>  {
>  }
>  
> diff --git a/arch/arm/include/asm/tlbflush.h b/arch/arm/include/asm/tlbflush.h
> index c2f1605..e085e2c 100644
> --- a/arch/arm/include/asm/tlbflush.h
> +++ b/arch/arm/include/asm/tlbflush.h
> @@ -529,7 +529,8 @@ extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
>   * cache entries for the kernels virtual memory range are written
>   * back to the page.
>   */
> -extern void update_mmu_cache(struct vm_area_struct *vma, unsigned long addr, pte_t pte);
> +extern void update_mmu_cache(struct vm_area_struct *vma, unsigned long addr,
> +	pte_t *ptep);
>  
>  #endif
>  
> diff --git a/arch/arm/mm/fault-armv.c b/arch/arm/mm/fault-armv.c
> index ae88f2c..c45f9bb 100644
> --- a/arch/arm/mm/fault-armv.c
> +++ b/arch/arm/mm/fault-armv.c
> @@ -149,9 +149,10 @@ make_coherent(struct address_space *mapping, struct vm_area_struct *vma, unsigne
>   *
>   * Note that the pte lock will be held.
>   */
> -void update_mmu_cache(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
> +void update_mmu_cache(struct vm_area_struct *vma, unsigned long addr,
> +	pte_t *ptep)
>  {
> -	unsigned long pfn = pte_pfn(pte);
> +	unsigned long pfn = pte_pfn(*ptep);
>  	struct address_space *mapping;
>  	struct page *page;
>  
> diff --git a/arch/avr32/include/asm/pgtable.h b/arch/avr32/include/asm/pgtable.h
> index fecdda1..a9ae30c 100644
> --- a/arch/avr32/include/asm/pgtable.h
> +++ b/arch/avr32/include/asm/pgtable.h
> @@ -325,7 +325,7 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
>  
>  struct vm_area_struct;
>  extern void update_mmu_cache(struct vm_area_struct * vma,
> -			     unsigned long address, pte_t pte);
> +			     unsigned long address, pte_t *ptep);
>  
>  /*
>   * Encode and decode a swap entry
> diff --git a/arch/avr32/mm/tlb.c b/arch/avr32/mm/tlb.c
> index 06677be..0da2310 100644
> --- a/arch/avr32/mm/tlb.c
> +++ b/arch/avr32/mm/tlb.c
> @@ -101,7 +101,7 @@ static void update_dtlb(unsigned long address, pte_t pte)
>  }
>  
>  void update_mmu_cache(struct vm_area_struct *vma,
> -		      unsigned long address, pte_t pte)
> +		      unsigned long address, pte_t *ptep)
>  {
>  	unsigned long flags;
>  
> @@ -110,7 +110,7 @@ void update_mmu_cache(struct vm_area_struct *vma,
>  		return;
>  
>  	local_irq_save(flags);
> -	update_dtlb(address, pte);
> +	update_dtlb(address, *ptep);
>  	local_irq_restore(flags);
>  }
>  
> diff --git a/arch/cris/include/asm/pgtable.h b/arch/cris/include/asm/pgtable.h
> index 1fcce00..99ea6cd 100644
> --- a/arch/cris/include/asm/pgtable.h
> +++ b/arch/cris/include/asm/pgtable.h
> @@ -270,7 +270,7 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD]; /* defined in head.S */
>   * Actually I am not sure on what this could be used for.
>   */
>  static inline void update_mmu_cache(struct vm_area_struct * vma,
> -	unsigned long address, pte_t pte)
> +	unsigned long address, pte_t *ptep)
>  {
>  }
>  
> diff --git a/arch/frv/include/asm/pgtable.h b/arch/frv/include/asm/pgtable.h
> index 22c6069..c18b0d3 100644
> --- a/arch/frv/include/asm/pgtable.h
> +++ b/arch/frv/include/asm/pgtable.h
> @@ -505,7 +505,7 @@ static inline int pte_file(pte_t pte)
>  /*
>   * preload information about a newly instantiated PTE into the SCR0/SCR1 PGE cache
>   */
> -static inline void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t pte)
> +static inline void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *ptep)
>  {
>  	struct mm_struct *mm;
>  	unsigned long ampr;
> diff --git a/arch/ia64/include/asm/pgtable.h b/arch/ia64/include/asm/pgtable.h
> index 69bf138..c3286f4 100644
> --- a/arch/ia64/include/asm/pgtable.h
> +++ b/arch/ia64/include/asm/pgtable.h
> @@ -462,7 +462,7 @@ pte_same (pte_t a, pte_t b)
>  	return pte_val(a) == pte_val(b);
>  }
>  
> -#define update_mmu_cache(vma, address, pte) do { } while (0)
> +#define update_mmu_cache(vma, address, ptep) do { } while (0)
>  
>  extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
>  extern void paging_init (void);
> diff --git a/arch/m32r/include/asm/tlbflush.h b/arch/m32r/include/asm/tlbflush.h
> index 0ef9530..92614b0 100644
> --- a/arch/m32r/include/asm/tlbflush.h
> +++ b/arch/m32r/include/asm/tlbflush.h
> @@ -92,6 +92,6 @@ static __inline__ void __flush_tlb_all(void)
>  	);
>  }
>  
> -extern void update_mmu_cache(struct vm_area_struct *, unsigned long, pte_t);
> +extern void update_mmu_cache(struct vm_area_struct *, unsigned long, pte_t *);
>  
>  #endif	/* _ASM_M32R_TLBFLUSH_H */
> diff --git a/arch/m32r/mm/fault-nommu.c b/arch/m32r/mm/fault-nommu.c
> index 8846917..888aab1 100644
> --- a/arch/m32r/mm/fault-nommu.c
> +++ b/arch/m32r/mm/fault-nommu.c
> @@ -95,7 +95,7 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long error_code,
>   * update_mmu_cache()
>   *======================================================================*/
>  void update_mmu_cache(struct vm_area_struct *vma, unsigned long addr,
> -	pte_t pte)
> +	pte_t *ptep)
>  {
>  	BUG();
>  }
> diff --git a/arch/m32r/mm/fault.c b/arch/m32r/mm/fault.c
> index 7274b47..28ee389 100644
> --- a/arch/m32r/mm/fault.c
> +++ b/arch/m32r/mm/fault.c
> @@ -336,7 +336,7 @@ vmalloc_fault:
>  
>  		addr = (address & PAGE_MASK);
>  		set_thread_fault_code(error_code);
> -		update_mmu_cache(NULL, addr, *pte_k);
> +		update_mmu_cache(NULL, addr, pte_k);
>  		set_thread_fault_code(0);
>  		return;
>  	}
> @@ -349,7 +349,7 @@ vmalloc_fault:
>  #define ITLB_END	(unsigned long *)(ITLB_BASE + (NR_TLB_ENTRIES * 8))
>  #define DTLB_END	(unsigned long *)(DTLB_BASE + (NR_TLB_ENTRIES * 8))
>  void update_mmu_cache(struct vm_area_struct *vma, unsigned long vaddr,
> -	pte_t pte)
> +	pte_t *ptep)
>  {
>  	volatile unsigned long *entry1, *entry2;
>  	unsigned long pte_data, flags;
> @@ -365,7 +365,7 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long vaddr,
>  
>  	vaddr = (vaddr & PAGE_MASK) | get_asid();
>  
> -	pte_data = pte_val(pte);
> +	pte_data = pte_val(*ptep);
>  
>  #ifdef CONFIG_CHIP_OPSP
>  	entry1 = (unsigned long *)ITLB_BASE;
> diff --git a/arch/m68k/include/asm/pgtable_mm.h b/arch/m68k/include/asm/pgtable_mm.h
> index aca0e28..87174c9 100644
> --- a/arch/m68k/include/asm/pgtable_mm.h
> +++ b/arch/m68k/include/asm/pgtable_mm.h
> @@ -115,7 +115,7 @@ extern void kernel_set_cachemode(void *addr, unsigned long size, int cmode);
>   * they are updated on demand.
>   */
>  static inline void update_mmu_cache(struct vm_area_struct *vma,
> -				    unsigned long address, pte_t pte)
> +				    unsigned long address, pte_t *ptep)
>  {
>  }
>  
> diff --git a/arch/microblaze/include/asm/tlbflush.h b/arch/microblaze/include/asm/tlbflush.h
> index eb31a0e..10ec70c 100644
> --- a/arch/microblaze/include/asm/tlbflush.h
> +++ b/arch/microblaze/include/asm/tlbflush.h
> @@ -38,7 +38,7 @@ static inline void local_flush_tlb_range(struct vm_area_struct *vma,
>  
>  #define flush_tlb_kernel_range(start, end)	do { } while (0)
>  
> -#define update_mmu_cache(vma, addr, pte)	do { } while (0)
> +#define update_mmu_cache(vma, addr, ptep)	do { } while (0)
>  
>  #define flush_tlb_all local_flush_tlb_all
>  #define flush_tlb_mm local_flush_tlb_mm
> diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
> index 1854336..c56bf8a 100644
> --- a/arch/mips/include/asm/pgtable.h
> +++ b/arch/mips/include/asm/pgtable.h
> @@ -362,8 +362,9 @@ extern void __update_cache(struct vm_area_struct *vma, unsigned long address,
>  	pte_t pte);
>  
>  static inline void update_mmu_cache(struct vm_area_struct *vma,
> -	unsigned long address, pte_t pte)
> +	unsigned long address, pte_t *ptep)
>  {
> +	pte_t pte = *ptep;
>  	__update_tlb(vma, address, pte);
>  	__update_cache(vma, address, pte);
>  }
> diff --git a/arch/mn10300/include/asm/pgtable.h b/arch/mn10300/include/asm/pgtable.h
> index 6dc30fc..16d8857 100644
> --- a/arch/mn10300/include/asm/pgtable.h
> +++ b/arch/mn10300/include/asm/pgtable.h
> @@ -466,7 +466,7 @@ static inline int set_kernel_exec(unsigned long vaddr, int enable)
>   * the kernel page tables containing the necessary information by tlb-mn10300.S
>   */
>  extern void update_mmu_cache(struct vm_area_struct *vma,
> -			     unsigned long address, pte_t pte);
> +			     unsigned long address, pte_t *ptep);
>  
>  #endif /* !__ASSEMBLY__ */
>  
> diff --git a/arch/mn10300/mm/mmu-context.c b/arch/mn10300/mm/mmu-context.c
> index 31c9d27..36ba021 100644
> --- a/arch/mn10300/mm/mmu-context.c
> +++ b/arch/mn10300/mm/mmu-context.c
> @@ -51,9 +51,10 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
>  /*
>   * preemptively set a TLB entry
>   */
> -void update_mmu_cache(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
> +void update_mmu_cache(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
>  {
>  	unsigned long pteu, ptel, cnx, flags;
> +	pte_t pte = *ptep;
>  
>  	addr &= PAGE_MASK;
>  	ptel = pte_val(pte) & ~(xPTEL_UNUSED1 | xPTEL_UNUSED2);
> diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
> index a27d2e2..01c1503 100644
> --- a/arch/parisc/include/asm/pgtable.h
> +++ b/arch/parisc/include/asm/pgtable.h
> @@ -410,7 +410,7 @@ extern void paging_init (void);
>  
>  #define PG_dcache_dirty         PG_arch_1
>  
> -extern void update_mmu_cache(struct vm_area_struct *, unsigned long, pte_t);
> +extern void update_mmu_cache(struct vm_area_struct *, unsigned long, pte_t *);
>  
>  /* Encode and de-code a swap entry */
>  
> diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
> index b6ed34d..1054baa 100644
> --- a/arch/parisc/kernel/cache.c
> +++ b/arch/parisc/kernel/cache.c
> @@ -68,9 +68,9 @@ flush_cache_all_local(void)
>  EXPORT_SYMBOL(flush_cache_all_local);
>  
>  void
> -update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t pte)
> +update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *ptep)
>  {
> -	struct page *page = pte_page(pte);
> +	struct page *page = pte_page(*ptep);
>  
>  	if (pfn_valid(page_to_pfn(page)) && page_mapping(page) &&
>  	    test_bit(PG_dcache_dirty, &page->flags)) {
> diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
> index 21207e5..89f1587 100644
> --- a/arch/powerpc/include/asm/pgtable.h
> +++ b/arch/powerpc/include/asm/pgtable.h
> @@ -209,7 +209,7 @@ extern void paging_init(void);
>   * corresponding HPTE into the hash table ahead of time, instead of
>   * waiting for the inevitable extra hash-table miss exception.
>   */
> -extern void update_mmu_cache(struct vm_area_struct *, unsigned long, pte_t);
> +extern void update_mmu_cache(struct vm_area_struct *, unsigned long, pte_t *);
>  
>  extern int gup_hugepd(hugepd_t *hugepd, unsigned pdshift, unsigned long addr,
>  		      unsigned long end, int write, struct page **pages, int *nr);
> diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
> index b9b1525..311224c 100644
> --- a/arch/powerpc/mm/mem.c
> +++ b/arch/powerpc/mm/mem.c
> @@ -494,13 +494,13 @@ EXPORT_SYMBOL(flush_icache_user_range);
>   * This must always be called with the pte lock held.
>   */
>  void update_mmu_cache(struct vm_area_struct *vma, unsigned long address,
> -		      pte_t pte)
> +		      pte_t *ptep)
>  {
>  #ifdef CONFIG_PPC_STD_MMU
>  	unsigned long access = 0, trap;
>  
>  	/* We only want HPTEs for linux PTEs that have _PAGE_ACCESSED set */
> -	if (!pte_young(pte) || address >= TASK_SIZE)
> +	if (!pte_young(*ptep) || address >= TASK_SIZE)
>  		return;
>  
>  	/* We try to figure out if we are coming from an instruction
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index e2fa79c..9b5b918 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -43,7 +43,7 @@ extern void vmem_map_init(void);
>   * The S390 doesn't have any external MMU info: the kernel page
>   * tables contain all the necessary information.
>   */
> -#define update_mmu_cache(vma, address, pte)     do { } while (0)
> +#define update_mmu_cache(vma, address, ptep)     do { } while (0)
>  
>  /*
>   * ZERO_PAGE is a global shared page that is always zero: used
> diff --git a/arch/score/include/asm/pgtable.h b/arch/score/include/asm/pgtable.h
> index 674934b..ccf38f0 100644
> --- a/arch/score/include/asm/pgtable.h
> +++ b/arch/score/include/asm/pgtable.h
> @@ -272,8 +272,9 @@ extern void __update_cache(struct vm_area_struct *vma,
>  	unsigned long address,	pte_t pte);
>  
>  static inline void update_mmu_cache(struct vm_area_struct *vma,
> -	unsigned long address, pte_t pte)
> +	unsigned long address, pte_t *ptep)
>  {
> +	pte_t pte = *ptep;
>  	__update_tlb(vma, address, pte);
>  	__update_cache(vma, address, pte);
>  }
> diff --git a/arch/sh/include/asm/pgtable.h b/arch/sh/include/asm/pgtable.h
> index ba3046e..1ff93ac 100644
> --- a/arch/sh/include/asm/pgtable.h
> +++ b/arch/sh/include/asm/pgtable.h
> @@ -165,8 +165,9 @@ extern void __update_tlb(struct vm_area_struct *vma,
>  			 unsigned long address, pte_t pte);
>  
>  static inline void
> -update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t pte)
> +update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *ptep)
>  {
> +	pte_t pte = *ptep;
>  	__update_cache(vma, address, pte);
>  	__update_tlb(vma, address, pte);
>  }
> diff --git a/arch/sh/mm/fault_32.c b/arch/sh/mm/fault_32.c
> index 4753010..1677b5e 100644
> --- a/arch/sh/mm/fault_32.c
> +++ b/arch/sh/mm/fault_32.c
> @@ -371,7 +371,7 @@ handle_tlbmiss(struct pt_regs *regs, unsigned long writeaccess,
>  		local_flush_tlb_one(get_asid(), address & PAGE_MASK);
>  #endif
>  
> -	update_mmu_cache(NULL, address, entry);
> +	update_mmu_cache(NULL, address, pte);
>  
>  	return 0;
>  }
> diff --git a/arch/sparc/include/asm/pgtable_32.h b/arch/sparc/include/asm/pgtable_32.h
> index e0cabe7..77f906d 100644
> --- a/arch/sparc/include/asm/pgtable_32.h
> +++ b/arch/sparc/include/asm/pgtable_32.h
> @@ -330,9 +330,9 @@ BTFIXUPDEF_CALL(void, mmu_info, struct seq_file *)
>  #define FAULT_CODE_WRITE    0x2
>  #define FAULT_CODE_USER     0x4
>  
> -BTFIXUPDEF_CALL(void, update_mmu_cache, struct vm_area_struct *, unsigned long, pte_t)
> +BTFIXUPDEF_CALL(void, update_mmu_cache, struct vm_area_struct *, unsigned long, pte_t *)
>  
> -#define update_mmu_cache(vma,addr,pte) BTFIXUP_CALL(update_mmu_cache)(vma,addr,pte)
> +#define update_mmu_cache(vma,addr,ptep) BTFIXUP_CALL(update_mmu_cache)(vma,addr,ptep)
>  
>  BTFIXUPDEF_CALL(void, sparc_mapiorange, unsigned int, unsigned long,
>      unsigned long, unsigned int)
> diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
> index f3cb790..f5b5fa7 100644
> --- a/arch/sparc/include/asm/pgtable_64.h
> +++ b/arch/sparc/include/asm/pgtable_64.h
> @@ -706,7 +706,7 @@ extern unsigned long find_ecache_flush_span(unsigned long size);
>  #define mmu_unlockarea(vaddr, len)		do { } while(0)
>  
>  struct vm_area_struct;
> -extern void update_mmu_cache(struct vm_area_struct *, unsigned long, pte_t);
> +extern void update_mmu_cache(struct vm_area_struct *, unsigned long, pte_t *);
>  
>  /* Encode and de-code a swap entry */
>  #define __swp_type(entry)	(((entry).val >> PAGE_SHIFT) & 0xffUL)
> diff --git a/arch/sparc/mm/fault_32.c b/arch/sparc/mm/fault_32.c
> index b99f81c..43e20ef 100644
> --- a/arch/sparc/mm/fault_32.c
> +++ b/arch/sparc/mm/fault_32.c
> @@ -370,7 +370,7 @@ asmlinkage void do_sun4c_fault(struct pt_regs *regs, int text_fault, int write,
>  			       unsigned long address)
>  {
>  	extern void sun4c_update_mmu_cache(struct vm_area_struct *,
> -					   unsigned long,pte_t);
> +					   unsigned long,pte_t *);
>  	extern pte_t *sun4c_pte_offset_kernel(pmd_t *,unsigned long);
>  	struct task_struct *tsk = current;
>  	struct mm_struct *mm = tsk->mm;
> @@ -447,7 +447,7 @@ asmlinkage void do_sun4c_fault(struct pt_regs *regs, int text_fault, int write,
>  		 *       on the CPU and doing a shrink_mmap() on this vma.
>  		 */
>  		sun4c_update_mmu_cache (find_vma(current->mm, address), address,
> -					*ptep);
> +					ptep);
>  	else
>  		do_sparc_fault(regs, text_fault, write, address);
>  }
> diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> index 1886d37..9245a82 100644
> --- a/arch/sparc/mm/init_64.c
> +++ b/arch/sparc/mm/init_64.c
> @@ -289,12 +289,13 @@ static void flush_dcache(unsigned long pfn)
>  	}
>  }
>  
> -void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t pte)
> +void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *ptep)
>  {
>  	struct mm_struct *mm;
>  	struct tsb *tsb;
>  	unsigned long tag, flags;
>  	unsigned long tsb_index, tsb_hash_shift;
> +	pte_t pte = *ptep;
>  
>  	if (tlb_type != hypervisor) {
>  		unsigned long pfn = pte_pfn(pte);
> diff --git a/arch/sparc/mm/nosun4c.c b/arch/sparc/mm/nosun4c.c
> index 196263f..4e62c27 100644
> --- a/arch/sparc/mm/nosun4c.c
> +++ b/arch/sparc/mm/nosun4c.c
> @@ -62,7 +62,7 @@ pte_t *sun4c_pte_offset_kernel(pmd_t *dir, unsigned long address)
>  	return NULL;
>  }
>  
> -void sun4c_update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t pte)
> +void sun4c_update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *ptep)
>  {
>  }
>  
> diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
> index 367321a..df49b20 100644
> --- a/arch/sparc/mm/srmmu.c
> +++ b/arch/sparc/mm/srmmu.c
> @@ -694,7 +694,7 @@ extern void tsunami_setup_blockops(void);
>   * The following code is a deadwood that may be necessary when
>   * we start to make precise page flushes again. --zaitcev
>   */
> -static void swift_update_mmu_cache(struct vm_area_struct * vma, unsigned long address, pte_t pte)
> +static void swift_update_mmu_cache(struct vm_area_struct * vma, unsigned long address, pte_t *ptep)
>  {
>  #if 0
>  	static unsigned long last;
> @@ -703,10 +703,10 @@ static void swift_update_mmu_cache(struct vm_area_struct * vma, unsigned long ad
>  
>  	if (address == last) {
>  		val = srmmu_hwprobe(address);
> -		if (val != 0 && pte_val(pte) != val) {
> +		if (val != 0 && pte_val(*ptep) != val) {
>  			printk("swift_update_mmu_cache: "
>  			    "addr %lx put %08x probed %08x from %p\n",
> -			    address, pte_val(pte), val,
> +			    address, pte_val(*ptep), val,
>  			    __builtin_return_address(0));
>  			srmmu_flush_whole_tlb();
>  		}
> diff --git a/arch/sparc/mm/sun4c.c b/arch/sparc/mm/sun4c.c
> index a89baf0..171f823 100644
> --- a/arch/sparc/mm/sun4c.c
> +++ b/arch/sparc/mm/sun4c.c
> @@ -1887,7 +1887,7 @@ static void sun4c_check_pgt_cache(int low, int high)
>  /* An experiment, turn off by default for now... -DaveM */
>  #define SUN4C_PRELOAD_PSEG
>  
> -void sun4c_update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t pte)
> +void sun4c_update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *ptep)
>  {
>  	unsigned long flags;
>  	int pseg;
> diff --git a/arch/um/include/asm/pgtable.h b/arch/um/include/asm/pgtable.h
> index 9ce3f16..a9f7251 100644
> --- a/arch/um/include/asm/pgtable.h
> +++ b/arch/um/include/asm/pgtable.h
> @@ -345,7 +345,7 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
>  struct mm_struct;
>  extern pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr);
>  
> -#define update_mmu_cache(vma,address,pte) do ; while (0)
> +#define update_mmu_cache(vma,address,ptep) do ; while (0)
>  
>  /* Encode and de-code a swap entry */
>  #define __swp_type(x)			(((x).val >> 4) & 0x3f)
> diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
> index 01fd946..a286683 100644
> --- a/arch/x86/include/asm/pgtable_32.h
> +++ b/arch/x86/include/asm/pgtable_32.h
> @@ -80,7 +80,7 @@ do {						\
>   * The i386 doesn't have any external MMU info: the kernel page
>   * tables contain all the necessary information.
>   */
> -#define update_mmu_cache(vma, address, pte) do { } while (0)
> +#define update_mmu_cache(vma, address, ptep) do { } while (0)
>  
>  #endif /* !__ASSEMBLY__ */
>  
> diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
> index c57a301..181be52 100644
> --- a/arch/x86/include/asm/pgtable_64.h
> +++ b/arch/x86/include/asm/pgtable_64.h
> @@ -129,7 +129,7 @@ static inline int pgd_large(pgd_t pgd) { return 0; }
>  #define pte_unmap(pte) /* NOP */
>  #define pte_unmap_nested(pte) /* NOP */
>  
> -#define update_mmu_cache(vma, address, pte) do { } while (0)
> +#define update_mmu_cache(vma, address, ptep) do { } while (0)
>  
>  /* Encode and de-code a swap entry */
>  #if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
> diff --git a/arch/xtensa/include/asm/pgtable.h b/arch/xtensa/include/asm/pgtable.h
> index a138770..76bf355 100644
> --- a/arch/xtensa/include/asm/pgtable.h
> +++ b/arch/xtensa/include/asm/pgtable.h
> @@ -394,7 +394,7 @@ ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
>  #define kern_addr_valid(addr)	(1)
>  
>  extern  void update_mmu_cache(struct vm_area_struct * vma,
> -			      unsigned long address, pte_t pte);
> +			      unsigned long address, pte_t *ptep);
>  
>  /*
>   * remap a physical page `pfn' of size `size' with page protection `prot'
> diff --git a/arch/xtensa/mm/cache.c b/arch/xtensa/mm/cache.c
> index 3ba990c..85df465 100644
> --- a/arch/xtensa/mm/cache.c
> +++ b/arch/xtensa/mm/cache.c
> @@ -147,9 +147,9 @@ void flush_cache_page(struct vm_area_struct* vma, unsigned long address,
>  #endif
>  
>  void
> -update_mmu_cache(struct vm_area_struct * vma, unsigned long addr, pte_t pte)
> +update_mmu_cache(struct vm_area_struct * vma, unsigned long addr, pte_t *ptep)
>  {
> -	unsigned long pfn = pte_pfn(pte);
> +	unsigned long pfn = pte_pfn(*ptep);
>  	struct page *page;
>  
>  	if (!pfn_valid(pfn))
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index e91b81b..94cd94d 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2088,7 +2088,7 @@ static void set_huge_ptep_writable(struct vm_area_struct *vma,
>  
>  	entry = pte_mkwrite(pte_mkdirty(huge_ptep_get(ptep)));
>  	if (huge_ptep_set_access_flags(vma, address, ptep, entry, 1)) {
> -		update_mmu_cache(vma, address, entry);
> +		update_mmu_cache(vma, address, ptep);
>  	}
>  }
>  
> @@ -2559,7 +2559,7 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  	entry = pte_mkyoung(entry);
>  	if (huge_ptep_set_access_flags(vma, address, ptep, entry,
>  						flags & FAULT_FLAG_WRITE))
> -		update_mmu_cache(vma, address, entry);
> +		update_mmu_cache(vma, address, ptep);
>  
>  out_page_table_lock:
>  	spin_unlock(&mm->page_table_lock);
> diff --git a/mm/memory.c b/mm/memory.c
> index 09e4b1b..72fb5f3 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1593,7 +1593,7 @@ static int insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>  	/* Ok, finally just insert the thing.. */
>  	entry = pte_mkspecial(pfn_pte(pfn, prot));
>  	set_pte_at(mm, addr, pte, entry);
> -	update_mmu_cache(vma, addr, entry); /* XXX: why not for insert_page? */
> +	update_mmu_cache(vma, addr, pte); /* XXX: why not for insert_page? */
>  
>  	retval = 0;
>  out_unlock:
> @@ -2116,7 +2116,7 @@ reuse:
>  		entry = pte_mkyoung(orig_pte);
>  		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
>  		if (ptep_set_access_flags(vma, address, page_table, entry,1))
> -			update_mmu_cache(vma, address, entry);
> +			update_mmu_cache(vma, address, page_table);
>  		ret |= VM_FAULT_WRITE;
>  		goto unlock;
>  	}
> @@ -2185,7 +2185,7 @@ gotten:
>  		 * new page to be mapped directly into the secondary page table.
>  		 */
>  		set_pte_at_notify(mm, address, page_table, entry);
> -		update_mmu_cache(vma, address, entry);
> +		update_mmu_cache(vma, address, page_table);
>  		if (old_page) {
>  			/*
>  			 * Only after switching the pte to the new page may
> @@ -2629,7 +2629,7 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  	}
>  
>  	/* No need to invalidate - it was non-present before */
> -	update_mmu_cache(vma, address, pte);
> +	update_mmu_cache(vma, address, page_table);
>  unlock:
>  	pte_unmap_unlock(page_table, ptl);
>  out:
> @@ -2694,7 +2694,7 @@ setpte:
>  	set_pte_at(mm, address, page_table, entry);
>  
>  	/* No need to invalidate - it was non-present before */
> -	update_mmu_cache(vma, address, entry);
> +	update_mmu_cache(vma, address, page_table);
>  unlock:
>  	pte_unmap_unlock(page_table, ptl);
>  	return 0;
> @@ -2855,7 +2855,7 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  		set_pte_at(mm, address, page_table, entry);
>  
>  		/* no need to invalidate: a not-present page won't be cached */
> -		update_mmu_cache(vma, address, entry);
> +		update_mmu_cache(vma, address, page_table);
>  	} else {
>  		if (charged)
>  			mem_cgroup_uncharge_page(page);
> @@ -2992,7 +2992,7 @@ static inline int handle_pte_fault(struct mm_struct *mm,
>  	}
>  	entry = pte_mkyoung(entry);
>  	if (ptep_set_access_flags(vma, address, pte, entry, flags & FAULT_FLAG_WRITE)) {
> -		update_mmu_cache(vma, address, entry);
> +		update_mmu_cache(vma, address, pte);
>  	} else {
>  		/*
>  		 * This is needed only for protection faults but the arch code
> diff --git a/mm/migrate.c b/mm/migrate.c
> index efddbf0..e58e5da 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -134,7 +134,7 @@ static int remove_migration_pte(struct page *new, struct vm_area_struct *vma,
>  		page_add_file_rmap(new);
>  
>  	/* No need to invalidate - it was non-present before */
> -	update_mmu_cache(vma, addr, pte);
> +	update_mmu_cache(vma, addr, ptep);
>  unlock:
>  	pte_unmap_unlock(ptep, ptl);
>  out:
> -- 
> 1.6.2.5
> 
> 


