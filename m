Return-Path: <linux-kernel-owner+w=401wt.eu-S1756950AbYG3Vvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbYG3Vvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYG3Vvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:51:32 -0400
Received: from gw.goop.org ([64.81.55.164]:38231 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbYG3Vvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:51:31 -0400
Message-ID: <4890E251.1090008@goop.org>
Date: Wed, 30 Jul 2008 14:51:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Eduardo Habkost <ehabkost@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] paravirt_ops: Use unsigned long instead of u32 for alloc_p*()
 pfn args
References: <1217453547-22231-1-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1217453547-22231-1-git-send-email-ehabkost@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Habkost wrote:
> This patch changes the pfn args from 'u32' to 'unsigned long'
> on alloc_p*() functions on paravirt_ops, and the corresponding
> implementations for Xen and VMI. The prototypes for CONFIG_PARAVIRT=n
> are already using unsigned long, so paravirt.h now matches the prototypes
> on asm-x86/pgalloc.h.
>
> It shouldn't result in any changes on generated code on 32-bit, with
> or without CONFIG_PARAVIRT. On both cases, 'codiff -f' didn't show any
> change after applying this patch.
>
> On 64-bit, there are (expected) binary changes only when CONFIG_PARAVIRT
> is enabled, as the patch is really supposed to change the size of the
> pfn args.
>
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
>   
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Cc:ing Zach, since it touches vmi.

    J

> ---
>  arch/x86/kernel/vmi_32.c   |   10 +++++-----
>  arch/x86/xen/enlighten.c   |   20 ++++++++++----------
>  include/asm-x86/paravirt.h |   30 +++++++++++++++---------------
>  3 files changed, 30 insertions(+), 30 deletions(-)
>
> diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
> index 6832228..c6a758b 100644
> --- a/arch/x86/kernel/vmi_32.c
> +++ b/arch/x86/kernel/vmi_32.c
> @@ -394,13 +394,13 @@ static void *vmi_kmap_atomic_pte(struct page *page, enum km_type type)
>  }
>  #endif
>  
> -static void vmi_allocate_pte(struct mm_struct *mm, u32 pfn)
> +static void vmi_allocate_pte(struct mm_struct *mm, unsigned long pfn)
>  {
>  	vmi_set_page_type(pfn, VMI_PAGE_L1);
>  	vmi_ops.allocate_page(pfn, VMI_PAGE_L1, 0, 0, 0);
>  }
>  
> -static void vmi_allocate_pmd(struct mm_struct *mm, u32 pfn)
> +static void vmi_allocate_pmd(struct mm_struct *mm, unsigned long pfn)
>  {
>   	/*
>  	 * This call comes in very early, before mem_map is setup.
> @@ -411,20 +411,20 @@ static void vmi_allocate_pmd(struct mm_struct *mm, u32 pfn)
>  	vmi_ops.allocate_page(pfn, VMI_PAGE_L2, 0, 0, 0);
>  }
>  
> -static void vmi_allocate_pmd_clone(u32 pfn, u32 clonepfn, u32 start, u32 count)
> +static void vmi_allocate_pmd_clone(unsigned long pfn, unsigned long clonepfn, unsigned long start, unsigned long count)
>  {
>   	vmi_set_page_type(pfn, VMI_PAGE_L2 | VMI_PAGE_CLONE);
>  	vmi_check_page_type(clonepfn, VMI_PAGE_L2);
>  	vmi_ops.allocate_page(pfn, VMI_PAGE_L2 | VMI_PAGE_CLONE, clonepfn, start, count);
>  }
>  
> -static void vmi_release_pte(u32 pfn)
> +static void vmi_release_pte(unsigned long pfn)
>  {
>  	vmi_ops.release_page(pfn, VMI_PAGE_L1);
>  	vmi_set_page_type(pfn, VMI_PAGE_NORMAL);
>  }
>  
> -static void vmi_release_pmd(u32 pfn)
> +static void vmi_release_pmd(unsigned long pfn)
>  {
>  	vmi_ops.release_page(pfn, VMI_PAGE_L2);
>  	vmi_set_page_type(pfn, VMI_PAGE_NORMAL);
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 4b50c0a..33f9559 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -908,7 +908,7 @@ static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
>  
>  /* Early in boot, while setting up the initial pagetable, assume
>     everything is pinned. */
> -static __init void xen_alloc_pte_init(struct mm_struct *mm, u32 pfn)
> +static __init void xen_alloc_pte_init(struct mm_struct *mm, unsigned long pfn)
>  {
>  #ifdef CONFIG_FLATMEM
>  	BUG_ON(mem_map);	/* should only be used early */
> @@ -918,7 +918,7 @@ static __init void xen_alloc_pte_init(struct mm_struct *mm, u32 pfn)
>  
>  /* Early release_pte assumes that all pts are pinned, since there's
>     only init_mm and anything attached to that is pinned. */
> -static void xen_release_pte_init(u32 pfn)
> +static void xen_release_pte_init(unsigned long pfn)
>  {
>  	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
>  }
> @@ -934,7 +934,7 @@ static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
>  
>  /* This needs to make sure the new pte page is pinned iff its being
>     attached to a pinned pagetable. */
> -static void xen_alloc_ptpage(struct mm_struct *mm, u32 pfn, unsigned level)
> +static void xen_alloc_ptpage(struct mm_struct *mm, unsigned long pfn, unsigned level)
>  {
>  	struct page *page = pfn_to_page(pfn);
>  
> @@ -952,12 +952,12 @@ static void xen_alloc_ptpage(struct mm_struct *mm, u32 pfn, unsigned level)
>  	}
>  }
>  
> -static void xen_alloc_pte(struct mm_struct *mm, u32 pfn)
> +static void xen_alloc_pte(struct mm_struct *mm, unsigned long pfn)
>  {
>  	xen_alloc_ptpage(mm, pfn, PT_PTE);
>  }
>  
> -static void xen_alloc_pmd(struct mm_struct *mm, u32 pfn)
> +static void xen_alloc_pmd(struct mm_struct *mm, unsigned long pfn)
>  {
>  	xen_alloc_ptpage(mm, pfn, PT_PMD);
>  }
> @@ -1005,7 +1005,7 @@ static void xen_pgd_free(struct mm_struct *mm, pgd_t *pgd)
>  }
>  
>  /* This should never happen until we're OK to use struct page */
> -static void xen_release_ptpage(u32 pfn, unsigned level)
> +static void xen_release_ptpage(unsigned long pfn, unsigned level)
>  {
>  	struct page *page = pfn_to_page(pfn);
>  
> @@ -1019,23 +1019,23 @@ static void xen_release_ptpage(u32 pfn, unsigned level)
>  	}
>  }
>  
> -static void xen_release_pte(u32 pfn)
> +static void xen_release_pte(unsigned long pfn)
>  {
>  	xen_release_ptpage(pfn, PT_PTE);
>  }
>  
> -static void xen_release_pmd(u32 pfn)
> +static void xen_release_pmd(unsigned long pfn)
>  {
>  	xen_release_ptpage(pfn, PT_PMD);
>  }
>  
>  #if PAGETABLE_LEVELS == 4
> -static void xen_alloc_pud(struct mm_struct *mm, u32 pfn)
> +static void xen_alloc_pud(struct mm_struct *mm, unsigned long pfn)
>  {
>  	xen_alloc_ptpage(mm, pfn, PT_PUD);
>  }
>  
> -static void xen_release_pud(u32 pfn)
> +static void xen_release_pud(unsigned long pfn)
>  {
>  	xen_release_ptpage(pfn, PT_PUD);
>  }
> diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
> index e40691c..eca8c4f 100644
> --- a/include/asm-x86/paravirt.h
> +++ b/include/asm-x86/paravirt.h
> @@ -255,13 +255,13 @@ struct pv_mmu_ops {
>  	 * Hooks for allocating/releasing pagetable pages when they're
>  	 * attached to a pagetable
>  	 */
> -	void (*alloc_pte)(struct mm_struct *mm, u32 pfn);
> -	void (*alloc_pmd)(struct mm_struct *mm, u32 pfn);
> -	void (*alloc_pmd_clone)(u32 pfn, u32 clonepfn, u32 start, u32 count);
> -	void (*alloc_pud)(struct mm_struct *mm, u32 pfn);
> -	void (*release_pte)(u32 pfn);
> -	void (*release_pmd)(u32 pfn);
> -	void (*release_pud)(u32 pfn);
> +	void (*alloc_pte)(struct mm_struct *mm, unsigned long pfn);
> +	void (*alloc_pmd)(struct mm_struct *mm, unsigned long pfn);
> +	void (*alloc_pmd_clone)(unsigned long pfn, unsigned long clonepfn, unsigned long start, unsigned long count);
> +	void (*alloc_pud)(struct mm_struct *mm, unsigned long pfn);
> +	void (*release_pte)(unsigned long pfn);
> +	void (*release_pmd)(unsigned long pfn);
> +	void (*release_pud)(unsigned long pfn);
>  
>  	/* Pagetable manipulation functions */
>  	void (*set_pte)(pte_t *ptep, pte_t pteval);
> @@ -988,35 +988,35 @@ static inline void paravirt_pgd_free(struct mm_struct *mm, pgd_t *pgd)
>  	PVOP_VCALL2(pv_mmu_ops.pgd_free, mm, pgd);
>  }
>  
> -static inline void paravirt_alloc_pte(struct mm_struct *mm, unsigned pfn)
> +static inline void paravirt_alloc_pte(struct mm_struct *mm, unsigned long pfn)
>  {
>  	PVOP_VCALL2(pv_mmu_ops.alloc_pte, mm, pfn);
>  }
> -static inline void paravirt_release_pte(unsigned pfn)
> +static inline void paravirt_release_pte(unsigned long pfn)
>  {
>  	PVOP_VCALL1(pv_mmu_ops.release_pte, pfn);
>  }
>  
> -static inline void paravirt_alloc_pmd(struct mm_struct *mm, unsigned pfn)
> +static inline void paravirt_alloc_pmd(struct mm_struct *mm, unsigned long pfn)
>  {
>  	PVOP_VCALL2(pv_mmu_ops.alloc_pmd, mm, pfn);
>  }
>  
> -static inline void paravirt_alloc_pmd_clone(unsigned pfn, unsigned clonepfn,
> -					    unsigned start, unsigned count)
> +static inline void paravirt_alloc_pmd_clone(unsigned long pfn, unsigned long clonepfn,
> +					    unsigned long start, unsigned long count)
>  {
>  	PVOP_VCALL4(pv_mmu_ops.alloc_pmd_clone, pfn, clonepfn, start, count);
>  }
> -static inline void paravirt_release_pmd(unsigned pfn)
> +static inline void paravirt_release_pmd(unsigned long pfn)
>  {
>  	PVOP_VCALL1(pv_mmu_ops.release_pmd, pfn);
>  }
>  
> -static inline void paravirt_alloc_pud(struct mm_struct *mm, unsigned pfn)
> +static inline void paravirt_alloc_pud(struct mm_struct *mm, unsigned long pfn)
>  {
>  	PVOP_VCALL2(pv_mmu_ops.alloc_pud, mm, pfn);
>  }
> -static inline void paravirt_release_pud(unsigned pfn)
> +static inline void paravirt_release_pud(unsigned long pfn)
>  {
>  	PVOP_VCALL1(pv_mmu_ops.release_pud, pfn);
>  }
>   

