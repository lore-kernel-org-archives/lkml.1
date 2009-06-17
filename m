Return-Path: <linux-kernel-owner+w=401wt.eu-S1763470AbZFQCfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763470AbZFQCfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 22:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbZFQCfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 22:35:23 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:31953 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbZFQCfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 22:35:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aIAAZpzpzD/qihHiB86sc01f+Uv7hw/3VepuVdvSvQCaFuRdG19K1N2/xefoJSTGqQ
         E+shrmoAt9ImfPTNK5DN+4kfPLbkjQ5RwbN/a4IjF5artWn7l0K94MOsdBLWTj8QuhvZ
         d81Xx4LUE05HXYlt+xLSnCw5B6Nemi05GqmtE=
MIME-Version: 1.0
In-Reply-To: <4A33A835.901@gmail.com>
References: <4A33A835.901@gmail.com>
Date: Tue, 16 Jun 2009 19:35:24 -0700
Message-ID: <6934efce0906161935x65c2a31br4bf1d35493e7b77c@mail.gmail.com>
Subject: Re: [PATCH 13/14] Pramfs: Write protection
From: Jared Hulbert <jaredeh@gmail.com>
To: Marco <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* init_mm.page_table_lock must be held before calling! */
> +static void pram_page_writeable(unsigned long addr, int rw)
> +{
> +       pgd_t *pgdp;
> +       pud_t *pudp;
> +       pmd_t *pmdp;
> +       pte_t *ptep;
> +
> +       pgdp = pgd_offset_k(addr);
> +       if (!pgd_none(*pgdp)) {
> +               pudp = pud_offset(pgdp, addr);
> +               if (!pud_none(*pudp)) {
> +                       pmdp = pmd_offset(pudp, addr);
> +                       if (!pmd_none(*pmdp)) {
> +                               pte_t pte;
> +                               ptep = pte_offset_kernel(pmdp, addr);
> +                               pte = *ptep;
> +                               if (pte_present(pte)) {
> +                                       pte = rw ? pte_mkwrite(pte) :
> +                                               pte_wrprotect(pte);
> +                                       set_pte(ptep, pte);
> +                               }
> +                       }
> +               }
> +       }
> +}

Wow.  Don't we want to do this pte walking in mm/ someplace?

Do you really intend to protect just the PTE in question rather than
the entire physical page, regardless of which PTE is talking to it?
Maybe I'm missing something.

> +/* init_mm.page_table_lock must be held before calling! */
> +void pram_writeable(void *vaddr, unsigned long size, int rw)
> +{
> +       unsigned long addr = (unsigned long)vaddr & PAGE_MASK;
> +       unsigned long end = (unsigned long)vaddr + size;
> +       unsigned long start = addr;
> +
> +       do {
> +               pram_page_writeable(addr, rw);
> +               addr += PAGE_SIZE;
> +       } while (addr && (addr < end));
> +
> +
> +       /*
> +        * NOTE: we will always flush just one page (one TLB
> +        * entry) except possibly in one case: when a new
> +        * filesystem is initialized at mount time, when pram_read_super
> +        * calls pram_lock_range to make the super block, inode
> +        * table, and bitmap writeable.
> +        */
> +#if defined(CONFIG_ARM) || defined(CONFIG_M68K) || defined(CONFIG_H8300) || \
> +       defined(CONFIG_BLACKFIN)
> +       /*
> +        * FIXME: so far only these archs have flush_tlb_kernel_page(),
> +        * for the rest just use flush_tlb_kernel_range(). Not ideal
> +        * to use _range() because many archs just flush the whole TLB.
> +        */
> +       if (end <= start + PAGE_SIZE)
> +               flush_tlb_kernel_page(start);
> +       else
> +#endif
> +               flush_tlb_kernel_range(start, end);
> +}

Why not just fix flush_tlb_range()?

If an arch has a flush_tlb_kernel_page() that works then it stands to
reason that the flush_tlb_kernel_range() shouldn't work with minimal
effort, no?
