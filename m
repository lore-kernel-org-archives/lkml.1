Return-Path: <linux-kernel-owner+w=401wt.eu-S933082AbZFQMsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbZFQMsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZFQMsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:48:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59770 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbZFQMsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:48:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lauro Salmito <laurosalmito@gmail.com>
Subject: Re: [PATCH] x86: unify power/hibernate_(32|64).
Date: Wed, 17 Jun 2009 14:48:18 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, pavel@suse.cz, x86@kernel.org, mingo@elte.hu
References: <95a78f690906170536v5399e680q9670448a08eaa35f@mail.gmail.com>
In-Reply-To: <95a78f690906170536v5399e680q9670448a08eaa35f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906171448.19277.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 June 2009, Lauro Salmito wrote:
>  x86: unify power/hibernate_(32|64).
> 
> In this step we do unify hibernate_32.c and hibernate_64.c functions.
>  The file "hibernate.c" was added.

Hmm, there's not much unification possible in there, they are almost completely
different.

> Signed-off-by: Lauro Salmito <laurosalmito@gmail.com>
> ---
>  arch/x86/power/hibernate.c |  350
> ++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 350 insertions(+), 0 deletions(-)
>  create mode 100644 arch/x86/power/hibernate.c
> 
> diff --git a/arch/x86/power/hibernate.c b/arch/x86/power/hibernate.c
> new file mode 100644
> index 0000000..998fa52
> --- /dev/null
> +++ b/arch/x86/power/hibernate.c
> @@ -0,0 +1,350 @@
> +/*
> + * Hibernation support specific for i386/x86-64 - temporary page tables
> + *
> + * Distribute under GPLv2
> + *
> + * Copyright (c) 2006 Rafael J. Wysocki <rjw@sisk.pl>
> + */
> +
> +#include <linux/suspend.h>
> +#include <linux/bootmem.h>
> +#include <asm/system.h>
> +#include <asm/page.h>
> +#include <asm/pgtable.h>
> +#include <asm/mmzone.h>
> +#include <linux/smp.h>
> +#include <asm/proto.h>
> +#include <asm/mtrr.h>
> +
> +
> +#ifdef CONFIG_X86_32
> +/* Defined in hibernate_asm_32.S */
> +extern int restore_image(void);
> +
> +/* References to section boundaries */
> +extern const void __nosave_begin, __nosave_end;
> +
> +/* Pointer to the temporary resume page tables */
> +pgd_t *resume_pg_dir;
> +

Please move the following comments next to the code they are about.

> +/* The following three functions are based on the analogous code in
> + * arch/x86/mm/init_32.c
> + */
> +
> +/*
> + * Create a middle page table on a resume-safe page and put a pointer to it
> in
> + * the given global directory entry.  This only returns the gd entry
> + * in non-PAE compilation mode, since the middle layer is folded.
> + */
> +
> +#else
> +/* CONFIG_X86_64 */
> +/* References to section boundaries */
> +extern const void __nosave_begin, __nosave_end;
> +
> +/* Defined in hibernate_asm_64.S */
> +extern int restore_image(void);
> +
> +/*
> + * Address to jump to in the last phase of restore in order to get to the
> image
> + * kernel's text (this value is passed in the image header).
> + */
> +unsigned long restore_jump_address;
> +
> +/*
> + * Value of the cr3 register from before the hibernation (this value is
> passed
> + * in the image header).
> + */
> +unsigned long restore_cr3;
> +
> +pgd_t *temp_level4_pgt;
> +
> +void *relocated_restore_code;
> +
> +#endif
> +
> +#ifdef CONFIG_X86_32
> +
> +static pmd_t *resume_one_md_table_init(pgd_t *pgd)
> +{
> +    pud_t *pud;
> +    pmd_t *pmd_table;
> +
> +#ifdef CONFIG_X86_PAE
> +    pmd_table = (pmd_t *)get_safe_page(GFP_ATOMIC);
> +    if (!pmd_table)
> +        return NULL;
> +
> +    set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
> +    pud = pud_offset(pgd, 0);
> +
> +    BUG_ON(pmd_table != pmd_offset(pud, 0));
> +#else
> +    pud = pud_offset(pgd, 0);
> +    pmd_table = pmd_offset(pud, 0);
> +#endif
> +
> +    return pmd_table;
> +}
> +
> +#else
> +/* CONFIG_X86_64 */
> +
> +static int res_phys_pud_init(pud_t *pud, unsigned long address, unsigned
> long end)
> +{
> +        long i, j;
> +
> +        i = pud_index(address);
> +        pud = pud + i;
> +        for (; i < PTRS_PER_PUD; pud++, i++) {
> +                unsigned long paddr;
> +                pmd_t *pmd;
> +
> +                paddr = address + i*PUD_SIZE;
> +                if (paddr >= end)
> +                        break;
> +
> +                pmd = (pmd_t *)get_safe_page(GFP_ATOMIC);
> +                if (!pmd)
> +                        return -ENOMEM;
> +                set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
> +                for (j = 0; j < PTRS_PER_PMD; pmd++, j++, paddr +=
> PMD_SIZE) {
> +                        unsigned long pe;
> +
> +                        if (paddr >= end)
> +                                break;
> +                        pe = __PAGE_KERNEL_LARGE_EXEC | paddr;
> +                        pe &= __supported_pte_mask;
> +                        set_pmd(pmd, __pmd(pe));
> +                }
> +        }
> +        return 0;
> +}
> +
> +static int set_up_temporary_mappings(void)
> +{
> +        unsigned long start, end, next;
> +        int error;
> +
> +        temp_level4_pgt = (pgd_t *)get_safe_page(GFP_ATOMIC);
> +        if (!temp_level4_pgt)
> +                return -ENOMEM;
> +
> +        /* It is safe to reuse the original kernel mapping */
> +        set_pgd(temp_level4_pgt + pgd_index(__START_KERNEL_map),
> +                init_level4_pgt[pgd_index(__START_KERNEL_map)]);
> +
> +        /* Set up the direct mapping from scratch */
> +        start = (unsigned long)pfn_to_kaddr(0);
> +        end = (unsigned long)pfn_to_kaddr(max_pfn);
> +
> +        for (; start < end; start = next) {
> +                pud_t *pud = (pud_t *)get_safe_page(GFP_ATOMIC);
> +                if (!pud)
> +                        return -ENOMEM;
> +                next = start + PGDIR_SIZE;
> +                if (next > end)
> +                        next = end;
> +                if ((error = res_phys_pud_init(pud, __pa(start),
> __pa(next))))
> +                        return error;
> +                set_pgd(temp_level4_pgt + pgd_index(start),
> +                        mk_kernel_pgd(__pa(pud)));
> +        }
> +        return 0;
> +}
> +#endif
> +
> +#ifdef CONFIG_X86_32
> +/*
> + * Create a page table on a resume-safe page and place a pointer to it in
> + * a middle page directory entry.
> + */
> +static pte_t *resume_one_page_table_init(pmd_t *pmd)
> +{
> +    if (pmd_none(*pmd)) {
> +        pte_t *page_table = (pte_t *)get_safe_page(GFP_ATOMIC);
> +        if (!page_table)
> +            return NULL;
> +
> +        set_pmd(pmd, __pmd(__pa(page_table) | _PAGE_TABLE));
> +
> +        BUG_ON(page_table != pte_offset_kernel(pmd, 0));
> +
> +        return page_table;
> +    }
> +
> +    return pte_offset_kernel(pmd, 0);
> +}
> +
> +/*
> + * This maps the physical memory to kernel virtual address space, a total
> + * of max_low_pfn pages, by creating page tables starting from address
> + * PAGE_OFFSET.  The page tables are allocated out of resume-safe pages.
> + */
> +static int resume_physical_mapping_init(pgd_t *pgd_base)
> +{
> +    unsigned long pfn;
> +    pgd_t *pgd;
> +    pmd_t *pmd;
> +    pte_t *pte;
> +    int pgd_idx, pmd_idx;
> +
> +    pgd_idx = pgd_index(PAGE_OFFSET);
> +    pgd = pgd_base + pgd_idx;
> +    pfn = 0;
> +
> +    for (; pgd_idx < PTRS_PER_PGD; pgd++, pgd_idx++) {
> +        pmd = resume_one_md_table_init(pgd);
> +        if (!pmd)
> +            return -ENOMEM;
> +
> +        if (pfn >= max_low_pfn)
> +            continue;
> +
> +        for (pmd_idx = 0; pmd_idx < PTRS_PER_PMD; pmd++, pmd_idx++) {
> +            if (pfn >= max_low_pfn)
> +                break;
> +
> +            /* Map with big pages if possible, otherwise create
> +             * normal page tables.
> +             * NOTE: We can mark everything as executable here
> +             */
> +            if (cpu_has_pse) {
> +                set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE_EXEC));
> +                pfn += PTRS_PER_PTE;
> +            } else {
> +                pte_t *max_pte;
> +
> +                pte = resume_one_page_table_init(pmd);
> +                if (!pte)
> +                    return -ENOMEM;
> +
> +                max_pte = pte + PTRS_PER_PTE;
> +                for (; pte < max_pte; pte++, pfn++) {
> +                    if (pfn >= max_low_pfn)
> +                        break;
> +
> +                    set_pte(pte, pfn_pte(pfn, PAGE_KERNEL_EXEC));
> +                }
> +            }
> +        }
> +    }
> +
> +    resume_map_numa_kva(pgd_base);
> +
> +    return 0;
> +}
> +
> +static inline void resume_init_first_level_page_table(pgd_t *pg_dir)
> +{
> +#ifdef CONFIG_X86_PAE
> +    int i;
> +
> +    /* Init entries of the first-level page table to the zero page */
> +    for (i = 0; i < PTRS_PER_PGD; i++)
> +        set_pgd(pg_dir + i,
> +            __pgd(__pa(empty_zero_page) | _PAGE_PRESENT));
> +#endif
> +}
> +
> +int swsusp_arch_resume(void)
> +{
> +    int error;
> +
> +    resume_pg_dir = (pgd_t *)get_safe_page(GFP_ATOMIC);
> +    if (!resume_pg_dir)
> +        return -ENOMEM;
> +
> +    resume_init_first_level_page_table(resume_pg_dir);
> +    error = resume_physical_mapping_init(resume_pg_dir);
> +    if (error)
> +        return error;
> +
> +    /* We have got enough memory and from now on we cannot recover */
> +    restore_image();
> +    return 0;
> +}
> +
> +/*
> + *    pfn_is_nosave - check if given pfn is in the 'nosave' section
> + */
> +
> +int pfn_is_nosave(unsigned long pfn)
> +{
> +    unsigned long nosave_begin_pfn = __pa_symbol(&__nosave_begin) >>
> PAGE_SHIFT;
> +    unsigned long nosave_end_pfn = PAGE_ALIGN(__pa_symbol(&__nosave_end))
> >> PAGE_SHIFT;
> +    return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
> +}

Actually, pfn_is_nosave() looks the same in both cases.  Why don't you unify it?

> +#else
> +/* CONFIG_X86_64 */
> +
> +int swsusp_arch_resume(void)
> +{
> +        int error;
> +
> +        /* We have got enough memory and from now on we cannot recover */
> +        if ((error = set_up_temporary_mappings()))
> +                return error;
> +
> +        relocated_restore_code = (void *)get_safe_page(GFP_ATOMIC);
> +        if (!relocated_restore_code)
> +                return -ENOMEM;
> +        memcpy(relocated_restore_code, &core_restore_code,
> +               &restore_registers - &core_restore_code);
> +
> +        restore_image();
> +        return 0;
> +}
> +
> +/*
> + *      pfn_is_nosave - check if given pfn is in the 'nosave' section
> + */
> +
> +int pfn_is_nosave(unsigned long pfn)
> +{
> +        unsigned long nosave_begin_pfn = __pa_symbol(&__nosave_begin) >>
> PAGE_SHIFT;
> +        unsigned long nosave_end_pfn =
> PAGE_ALIGN(__pa_symbol(&__nosave_end)) >> PAGE_SHIFT;
> +        return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
> +}
> +
> +struct restore_data_record {
> +        unsigned long jump_address;
> +        unsigned long cr3;
> +        unsigned long magic;
> +};
> +
> +#define RESTORE_MAGIC   0x0123456789ABCDEFUL
> +
> +/**
> + *      arch_hibernation_header_save - populate the architecture specific
> part
> + *              of a hibernation image header
> + *      @addr: address to save the data at
> + */
> +int arch_hibernation_header_save(void *addr, unsigned int max_size)
> +{
> +        struct restore_data_record *rdr = addr;
> +
> +        if (max_size < sizeof(struct restore_data_record))
> +                return -EOVERFLOW;
> +        rdr->jump_address = restore_jump_address;
> +        rdr->cr3 = restore_cr3;
> +        rdr->magic = RESTORE_MAGIC;
> +        return 0;
> +}
> +
> +/**
> + *      arch_hibernation_header_restore - read the architecture specific
> data
> + *              from the hibernation image header
> + *      @addr: address to read the data from
> + */
> +int arch_hibernation_header_restore(void *addr)
> +{
> +        struct restore_data_record *rdr = addr;
> +
> +        restore_jump_address = rdr->jump_address;
> +        restore_cr3 = rdr->cr3;
> +        return (rdr->magic == RESTORE_MAGIC) ? 0 : -EINVAL;
> +
> +
> +#endif

Best,
Rafael
