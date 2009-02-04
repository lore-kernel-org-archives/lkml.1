Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbZBDC3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbZBDC3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 21:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZBDC3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 21:29:16 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:56296 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbZBDC3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 21:29:15 -0500
Date: Wed, 4 Feb 2009 11:29:07 +0900
From: Simon Horman <horms@verge.net.au>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH resend] kexec/x86_64: Use one page table in x86_64
	machine_kexec
Message-ID: <20090204022905.GM7199@verge.net.au>
References: <1233642168.19806.74.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233642168.19806.74.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 02:22:48PM +0800, Huang Ying wrote:
> Impact: reduce kernel BSS size by 7 pages, improve code readability
> 
> Two page tables are used in current x86_64 kexec implementation. One
> is used to jump from kernel virtual address to identity map address,
> the other is used to map all physical memory. In fact, on x86_64,
> there is no conflict between kernel virtual address space and physical
> memory space, so just one page table is sufficient. The page table
> pages used to map control page are dynamically allocated to save
> memory if kexec image is not loaded. ASM code used to map control page
> is replaced by C code too.

Hi Huang,

this patch looks quite nice to me. I am CCing my former colleague Magnus
Damm for comment. He did some work in this area a little while ago.

> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  arch/x86/include/asm/kexec.h         |   27 ++-----
>  arch/x86/kernel/machine_kexec_64.c   |   82 +++++++++++++++-------
>  arch/x86/kernel/relocate_kernel_64.S |  125 -----------------------------------
>  3 files changed, 67 insertions(+), 167 deletions(-)
> 
> --- a/arch/x86/include/asm/kexec.h
> +++ b/arch/x86/include/asm/kexec.h
> @@ -9,23 +9,8 @@
>  # define PAGES_NR		4
>  #else
>  # define PA_CONTROL_PAGE	0
> -# define VA_CONTROL_PAGE	1
> -# define PA_PGD			2
> -# define VA_PGD			3
> -# define PA_PUD_0		4
> -# define VA_PUD_0		5
> -# define PA_PMD_0		6
> -# define VA_PMD_0		7
> -# define PA_PTE_0		8
> -# define VA_PTE_0		9
> -# define PA_PUD_1		10
> -# define VA_PUD_1		11
> -# define PA_PMD_1		12
> -# define VA_PMD_1		13
> -# define PA_PTE_1		14
> -# define VA_PTE_1		15
> -# define PA_TABLE_PAGE		16
> -# define PAGES_NR		17
> +# define PA_TABLE_PAGE		1
> +# define PAGES_NR		2
>  #endif
>  
>  #ifdef CONFIG_X86_32
> @@ -157,9 +142,9 @@ relocate_kernel(unsigned long indirectio
>  		unsigned long start_address) ATTRIB_NORET;
>  #endif
>  
> -#ifdef CONFIG_X86_32
>  #define ARCH_HAS_KIMAGE_ARCH
>  
> +#ifdef CONFIG_X86_32
>  struct kimage_arch {
>  	pgd_t *pgd;
>  #ifdef CONFIG_X86_PAE
> @@ -169,6 +154,12 @@ struct kimage_arch {
>  	pte_t *pte0;
>  	pte_t *pte1;
>  };
> +#else
> +struct kimage_arch {
> +	pud_t *pud;
> +	pmd_t *pmd;
> +	pte_t *pte;
> +};
>  #endif
>  
>  #endif /* __ASSEMBLY__ */
> --- a/arch/x86/kernel/machine_kexec_64.c
> +++ b/arch/x86/kernel/machine_kexec_64.c
> @@ -18,15 +18,6 @@
>  #include <asm/mmu_context.h>
>  #include <asm/io.h>
>  
> -#define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
> -static u64 kexec_pgd[512] PAGE_ALIGNED;
> -static u64 kexec_pud0[512] PAGE_ALIGNED;
> -static u64 kexec_pmd0[512] PAGE_ALIGNED;
> -static u64 kexec_pte0[512] PAGE_ALIGNED;
> -static u64 kexec_pud1[512] PAGE_ALIGNED;
> -static u64 kexec_pmd1[512] PAGE_ALIGNED;
> -static u64 kexec_pte1[512] PAGE_ALIGNED;
> -
>  static void init_level2_page(pmd_t *level2p, unsigned long addr)
>  {
>  	unsigned long end_addr;
> @@ -107,12 +98,65 @@ out:
>  	return result;
>  }
>  
> +static void free_transition_pgtable(struct kimage *image)
> +{
> +	free_page((unsigned long)image->arch.pud);
> +	free_page((unsigned long)image->arch.pmd);
> +	free_page((unsigned long)image->arch.pte);
> +}
> +
> +static int init_transition_pgtable(struct kimage *image, pgd_t *pgd)
> +{
> +	pud_t *pud;
> +	pmd_t *pmd;
> +	pte_t *pte;
> +	unsigned long vaddr, paddr;
> +	int result = -ENOMEM;
> +
> +	vaddr = (unsigned long)relocate_kernel;
> +	paddr = __pa(page_address(image->control_code_page)+PAGE_SIZE);
> +	pgd += pgd_index(vaddr);
> +	if (!pgd_present(*pgd)) {
> +		pud = (pud_t *)get_zeroed_page(GFP_KERNEL);
> +		if (!pud)
> +			goto err;
> +		image->arch.pud = pud;
> +		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
> +	}
> +	pud = pud_offset(pgd, vaddr);
> +	if (!pud_present(*pud)) {
> +		pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
> +		if (!pmd)
> +			goto err;
> +		image->arch.pmd = pmd;
> +		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
> +	}
> +	pmd = pmd_offset(pud, vaddr);
> +	if (!pmd_present(*pmd)) {
> +		pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
> +		if (!pte)
> +			goto err;
> +		image->arch.pte = pte;
> +		set_pmd(pmd, __pmd(__pa(pte) | _KERNPG_TABLE));
> +	}
> +	pte = pte_offset_kernel(pmd, vaddr);
> +	set_pte(pte, pfn_pte(paddr >> PAGE_SHIFT, PAGE_KERNEL_EXEC));
> +	return 0;
> +err:
> +	free_transition_pgtable(image);
> +	return result;
> +}
> +
>  
>  static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
>  {
>  	pgd_t *level4p;
> +	int result;
>  	level4p = (pgd_t *)__va(start_pgtable);
> -	return init_level4_page(image, level4p, 0, max_pfn << PAGE_SHIFT);
> +	result = init_level4_page(image, level4p, 0, max_pfn << PAGE_SHIFT);
> +	if (result)
> +		return result;
> +	return init_transition_pgtable(image, level4p);
>  }
>  
>  static void set_idt(void *newidt, u16 limit)
> @@ -174,7 +218,7 @@ int machine_kexec_prepare(struct kimage 
>  
>  void machine_kexec_cleanup(struct kimage *image)
>  {
> -	return;
> +	free_transition_pgtable(image);
>  }
>  
>  /*
> @@ -195,22 +239,6 @@ void machine_kexec(struct kimage *image)
>  	memcpy(control_page, relocate_kernel, PAGE_SIZE);
>  
>  	page_list[PA_CONTROL_PAGE] = virt_to_phys(control_page);
> -	page_list[VA_CONTROL_PAGE] = (unsigned long)relocate_kernel;
> -	page_list[PA_PGD] = virt_to_phys(&kexec_pgd);
> -	page_list[VA_PGD] = (unsigned long)kexec_pgd;
> -	page_list[PA_PUD_0] = virt_to_phys(&kexec_pud0);
> -	page_list[VA_PUD_0] = (unsigned long)kexec_pud0;
> -	page_list[PA_PMD_0] = virt_to_phys(&kexec_pmd0);
> -	page_list[VA_PMD_0] = (unsigned long)kexec_pmd0;
> -	page_list[PA_PTE_0] = virt_to_phys(&kexec_pte0);
> -	page_list[VA_PTE_0] = (unsigned long)kexec_pte0;
> -	page_list[PA_PUD_1] = virt_to_phys(&kexec_pud1);
> -	page_list[VA_PUD_1] = (unsigned long)kexec_pud1;
> -	page_list[PA_PMD_1] = virt_to_phys(&kexec_pmd1);
> -	page_list[VA_PMD_1] = (unsigned long)kexec_pmd1;
> -	page_list[PA_PTE_1] = virt_to_phys(&kexec_pte1);
> -	page_list[VA_PTE_1] = (unsigned long)kexec_pte1;
> -
>  	page_list[PA_TABLE_PAGE] =
>  	  (unsigned long)__pa(page_address(image->control_code_page));
>  
> --- a/arch/x86/kernel/relocate_kernel_64.S
> +++ b/arch/x86/kernel/relocate_kernel_64.S
> @@ -29,122 +29,6 @@ relocate_kernel:
>  	 * %rdx start address
>  	 */
>  
> -	/* map the control page at its virtual address */
> -
> -	movq	$0x0000ff8000000000, %r10        /* mask */
> -	mov	$(39 - 3), %cl                   /* bits to shift */
> -	movq	PTR(VA_CONTROL_PAGE)(%rsi), %r11 /* address to map */
> -
> -	movq	%r11, %r9
> -	andq	%r10, %r9
> -	shrq	%cl, %r9
> -
> -	movq	PTR(VA_PGD)(%rsi), %r8
> -	addq	%r8, %r9
> -	movq	PTR(PA_PUD_0)(%rsi), %r8
> -	orq	$PAGE_ATTR, %r8
> -	movq	%r8, (%r9)
> -
> -	shrq	$9, %r10
> -	sub	$9, %cl
> -
> -	movq	%r11, %r9
> -	andq	%r10, %r9
> -	shrq	%cl, %r9
> -
> -	movq	PTR(VA_PUD_0)(%rsi), %r8
> -	addq	%r8, %r9
> -	movq	PTR(PA_PMD_0)(%rsi), %r8
> -	orq	$PAGE_ATTR, %r8
> -	movq	%r8, (%r9)
> -
> -	shrq	$9, %r10
> -	sub	$9, %cl
> -
> -	movq	%r11, %r9
> -	andq	%r10, %r9
> -	shrq	%cl, %r9
> -
> -	movq	PTR(VA_PMD_0)(%rsi), %r8
> -	addq	%r8, %r9
> -	movq	PTR(PA_PTE_0)(%rsi), %r8
> -	orq	$PAGE_ATTR, %r8
> -	movq	%r8, (%r9)
> -
> -	shrq	$9, %r10
> -	sub	$9, %cl
> -
> -	movq	%r11, %r9
> -	andq	%r10, %r9
> -	shrq	%cl, %r9
> -
> -	movq	PTR(VA_PTE_0)(%rsi), %r8
> -	addq	%r8, %r9
> -	movq	PTR(PA_CONTROL_PAGE)(%rsi), %r8
> -	orq	$PAGE_ATTR, %r8
> -	movq	%r8, (%r9)
> -
> -	/* identity map the control page at its physical address */
> -
> -	movq	$0x0000ff8000000000, %r10        /* mask */
> -	mov	$(39 - 3), %cl                   /* bits to shift */
> -	movq	PTR(PA_CONTROL_PAGE)(%rsi), %r11 /* address to map */
> -
> -	movq	%r11, %r9
> -	andq	%r10, %r9
> -	shrq	%cl, %r9
> -
> -	movq	PTR(VA_PGD)(%rsi), %r8
> -	addq	%r8, %r9
> -	movq	PTR(PA_PUD_1)(%rsi), %r8
> -	orq	$PAGE_ATTR, %r8
> -	movq	%r8, (%r9)
> -
> -	shrq	$9, %r10
> -	sub	$9, %cl
> -
> -	movq	%r11, %r9
> -	andq	%r10, %r9
> -	shrq	%cl, %r9
> -
> -	movq	PTR(VA_PUD_1)(%rsi), %r8
> -	addq	%r8, %r9
> -	movq	PTR(PA_PMD_1)(%rsi), %r8
> -	orq	$PAGE_ATTR, %r8
> -	movq	%r8, (%r9)
> -
> -	shrq	$9, %r10
> -	sub	$9, %cl
> -
> -	movq	%r11, %r9
> -	andq	%r10, %r9
> -	shrq	%cl, %r9
> -
> -	movq	PTR(VA_PMD_1)(%rsi), %r8
> -	addq	%r8, %r9
> -	movq	PTR(PA_PTE_1)(%rsi), %r8
> -	orq	$PAGE_ATTR, %r8
> -	movq	%r8, (%r9)
> -
> -	shrq	$9, %r10
> -	sub	$9, %cl
> -
> -	movq	%r11, %r9
> -	andq	%r10, %r9
> -	shrq	%cl, %r9
> -
> -	movq	PTR(VA_PTE_1)(%rsi), %r8
> -	addq	%r8, %r9
> -	movq	PTR(PA_CONTROL_PAGE)(%rsi), %r8
> -	orq	$PAGE_ATTR, %r8
> -	movq	%r8, (%r9)
> -
> -relocate_new_kernel:
> -	/* %rdi indirection_page
> -	 * %rsi page_list
> -	 * %rdx start address
> -	 */
> -
>  	/* zero out flags, and disable interrupts */
>  	pushq $0
>  	popfq
> @@ -156,9 +40,8 @@ relocate_new_kernel:
>  	/* get physical address of page table now too */
>  	movq	PTR(PA_TABLE_PAGE)(%rsi), %rcx
>  
> -	/* switch to new set of page tables */
> -	movq	PTR(PA_PGD)(%rsi), %r9
> -	movq	%r9, %cr3
> +	/* Switch to the identity mapped page tables */
> +	movq	%rcx, %cr3
>  
>  	/* setup a new stack at the end of the physical control page */
>  	lea	PAGE_SIZE(%r8), %rsp
> @@ -194,9 +77,7 @@ identity_mapped:
>  	jmp 1f
>  1:
>  
> -	/* Switch to the identity mapped page tables,
> -	 * and flush the TLB.
> -	*/
> +	/* Flush the TLB (needed?) */
>  	movq	%rcx, %cr3
>  
>  	/* Do the copies */
> 



-- 
Simon Horman
  VA Linux Systems Japan K.K., Sydney, Australia Satellite Office
  H: www.vergenet.net/~horms/             W: www.valinux.co.jp/en

