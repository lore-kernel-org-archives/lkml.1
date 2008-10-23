Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784AbYJWIpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbYJWIpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 04:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYJWIpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 04:45:43 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:5985 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbYJWIpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 04:45:41 -0400
From: Andrey Mirkin <major@openvz.org>
To: devel@openvz.org
Subject: Re: [Devel] Re: [PATCH 06/10] Introduce functions to dump mm
Date: Thu, 23 Oct 2008 12:43:41 +0400
User-Agent: KMail/1.8.2
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1224285098-573-1-git-send-email-major@openvz.org> <1224285098-573-7-git-send-email-major@openvz.org> <1224523278.1848.123.camel@nimitz>
In-Reply-To: <1224523278.1848.123.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810231243.42181.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2008 21:21 Dave Hansen wrote:
> On Sat, 2008-10-18 at 03:11 +0400, Andrey Mirkin wrote:
> > +static void page_get_desc(struct vm_area_struct *vma, unsigned long
> > addr, +                         struct page_desc *pdesc, cpt_context_t *
> > ctx) +{
> > +       struct mm_struct *mm = vma->vm_mm;
> > +       pgd_t *pgd;
> > +       pud_t *pud;
> > +       pmd_t *pmd;
> > +       pte_t *ptep, pte;
> > +       spinlock_t *ptl;
> > +       struct page *pg = NULL;
> > +       pgoff_t linear_index = (addr - vma->vm_start)/PAGE_SIZE +
> > vma->vm_pgoff; +
> > +       pdesc->index = linear_index;
> > +       pdesc->shared = 0;
> > +       pdesc->mm = CPT_NULL;
> > +
> > +       if (vma->vm_flags & VM_IO) {
> > +               pdesc->type = PD_ABSENT;
> > +               return;
> > +       }
> > +
> > +       pgd = pgd_offset(mm, addr);
> > +       if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
> > +               goto out_absent;
> > +       pud = pud_offset(pgd, addr);
> > +       if (pud_none(*pud) || unlikely(pud_bad(*pud)))
> > +               goto out_absent;
> > +       pmd = pmd_offset(pud, addr);
> > +       if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
> > +               goto out_absent;
> > +#ifdef CONFIG_X86
> > +       if (pmd_huge(*pmd)) {
> > +               eprintk("page_huge\n");
> > +               goto out_unsupported;
> > +       }
> > +#endif
>
> I take it you know that this breaks with the 1GB (x86_64) and 16GB (ppc)
> large pages.
>
> Since you have the VMA, why not use is_vm_hugetlb_page()?
Right now I'm checking VM_HUGETLB flag on VMAs in dump_one_vma().
This checks were added for sanity purpose just to throw out all unsupported 
right now cases.

Andrey
