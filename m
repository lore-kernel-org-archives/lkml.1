Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbYJTRYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbYJTRYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbYJTRVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:21:23 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35500 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757746AbYJTRVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:21:22 -0400
Subject: Re: [PATCH 06/10] Introduce functions to dump mm
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrey Mirkin <major@openvz.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <1224285098-573-7-git-send-email-major@openvz.org>
References: <1224285098-573-1-git-send-email-major@openvz.org>
	 <1224285098-573-2-git-send-email-major@openvz.org>
	 <1224285098-573-3-git-send-email-major@openvz.org>
	 <1224285098-573-4-git-send-email-major@openvz.org>
	 <1224285098-573-5-git-send-email-major@openvz.org>
	 <1224285098-573-6-git-send-email-major@openvz.org>
	 <1224285098-573-7-git-send-email-major@openvz.org>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 10:21:18 -0700
Message-Id: <1224523278.1848.123.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-18 at 03:11 +0400, Andrey Mirkin wrote:
> +static void page_get_desc(struct vm_area_struct *vma, unsigned long addr,
> +                         struct page_desc *pdesc, cpt_context_t * ctx)
> +{
> +       struct mm_struct *mm = vma->vm_mm;
> +       pgd_t *pgd;
> +       pud_t *pud;
> +       pmd_t *pmd;
> +       pte_t *ptep, pte;
> +       spinlock_t *ptl;
> +       struct page *pg = NULL;
> +       pgoff_t linear_index = (addr - vma->vm_start)/PAGE_SIZE + vma->vm_pgoff;
> +
> +       pdesc->index = linear_index;
> +       pdesc->shared = 0;
> +       pdesc->mm = CPT_NULL;
> +
> +       if (vma->vm_flags & VM_IO) {
> +               pdesc->type = PD_ABSENT;
> +               return;
> +       }
> +
> +       pgd = pgd_offset(mm, addr);
> +       if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
> +               goto out_absent;
> +       pud = pud_offset(pgd, addr);
> +       if (pud_none(*pud) || unlikely(pud_bad(*pud)))
> +               goto out_absent;
> +       pmd = pmd_offset(pud, addr);
> +       if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
> +               goto out_absent;
> +#ifdef CONFIG_X86
> +       if (pmd_huge(*pmd)) {
> +               eprintk("page_huge\n");
> +               goto out_unsupported;
> +       }
> +#endif

I take it you know that this breaks with the 1GB (x86_64) and 16GB (ppc)
large pages.  

Since you have the VMA, why not use is_vm_hugetlb_page()?

-- Dave

