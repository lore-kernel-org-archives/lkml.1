Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbYAWIrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbYAWIrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 03:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYAWIrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 03:47:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35346 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbYAWIre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 03:47:34 -0500
Subject: Re: [PATCH -v8 3/4] Enable the MS_ASYNC functionality in
	sys_msync()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anton Salikhmetov <salikhmetov@gmail.com>
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       protasnb@gmail.com, miklos@szeredi.hu, r.e.wolff@bitwizard.nl,
       hidave.darkstar@gmail.com, hch@infradead.org
In-Reply-To: <1201044083504-git-send-email-salikhmetov@gmail.com>
References: <12010440803930-git-send-email-salikhmetov@gmail.com>
	 <1201044083504-git-send-email-salikhmetov@gmail.com>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 09:47:15 +0100
Message-Id: <1201078035.6341.45.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-23 at 02:21 +0300, Anton Salikhmetov wrote:

> +static void vma_wrprotect_pmd_range(struct vm_area_struct *vma, pmd_t *pmd,
> +		unsigned long start, unsigned long end)
> +{
> +	while (start < end) {
> +		spinlock_t *ptl;
> +		pte_t *pte = pte_offset_map_lock(vma->vm_mm, pmd, start, &ptl);
> +
> +		if (pte_dirty(*pte) && pte_write(*pte)) {
> +			pte_t entry = ptep_clear_flush(vma, start, pte);
> +
> +			entry = pte_wrprotect(entry);
> +			set_pte_at(vma->vm_mm, start, pte, entry);
> +		}
> +
> +		pte_unmap_unlock(pte, ptl);
> +		start += PAGE_SIZE;
> +	}
> +}

You've had two examples on how to write this loop, one from git commit
204ec841fbea3e5138168edbc3a76d46747cc987, and one from my draft, but
this one looks like neither and is much less efficient. Take the lock
only once per pmd, not once per pte please.

> +static void vma_wrprotect_pud_range(struct vm_area_struct *vma, pud_t *pud,
> +		unsigned long start, unsigned long end)
> +{
> +	pmd_t *pmd = pmd_offset(pud, start);
> +
> +	while (start < end) {
> +		unsigned long next = pmd_addr_end(start, end);
> +
> +		if (!pmd_none_or_clear_bad(pmd))
> +			vma_wrprotect_pmd_range(vma, pmd, start, next);
> +
> +		++pmd;
> +		start = next;
> +	}
> +}
> +
> +static void vma_wrprotect_pgd_range(struct vm_area_struct *vma, pgd_t *pgd,
> +		unsigned long start, unsigned long end)
> +{
> +	pud_t *pud = pud_offset(pgd, start);
> +
> +	while (start < end) {
> +		unsigned long next = pud_addr_end(start, end);
> +
> +		if (!pud_none_or_clear_bad(pud))
> +			vma_wrprotect_pud_range(vma, pud, start, next);
> +
> +		++pud;
> +		start = next;
> +	}
> +}
> +
> +static void vma_wrprotect(struct vm_area_struct *vma)
> +{
> +	unsigned long addr = vma->vm_start;
> +	pgd_t *pgd = pgd_offset(vma->vm_mm, addr);
> +
> +	while (addr < vma->vm_end) {
> +		unsigned long next = pgd_addr_end(addr, vma->vm_end);
> +
> +		if (!pgd_none_or_clear_bad(pgd))
> +			vma_wrprotect_pgd_range(vma, pgd, addr, next);
> +
> +		++pgd;
> +		addr = next;
> +	}
> +}

I think you want to pass start, end here too, you might not need to
sweep the whole vma.


