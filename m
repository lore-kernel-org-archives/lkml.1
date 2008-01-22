Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbYAVEjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbYAVEjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 23:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYAVEjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 23:39:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903AbYAVEjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 23:39:47 -0500
To: Anton Salikhmetov <salikhmetov@gmail.com>
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, torvalds@osdl.org
Subject: Re: [PATCH -v7 2/2] Update ctime and mtime for memory-mapped files
References: <12009619562023-git-send-email-salikhmetov@gmail.com>
	<12009619584168-git-send-email-salikhmetov@gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 22 Jan 2008 05:39:43 +0100
In-Reply-To: <12009619584168-git-send-email-salikhmetov@gmail.com>
Message-ID: <p737ii2o4mo.fsf@crumb.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Salikhmetov <salikhmetov@gmail.com> writes:

You should probably put your design document somewhere in Documentation
with a patch.

> + * Scan the PTEs for pages belonging to the VMA and mark them read-only.
> + * It will force a pagefault on the next write access.
> + */
> +static void vma_wrprotect(struct vm_area_struct *vma)
> +{
> +	unsigned long addr;
> +
> +	for (addr = vma->vm_start; addr < vma->vm_end; addr += PAGE_SIZE) {
> +		spinlock_t *ptl;
> +		pgd_t *pgd = pgd_offset(vma->vm_mm, addr);
> +		pud_t *pud = pud_offset(pgd, addr);
> +		pmd_t *pmd = pmd_offset(pud, addr);
> +		pte_t *pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);

This means on i386 with highmem ptes you will map/flush tlb/unmap each
PTE individually. You will do 512 times as much work as really needed
per PTE leaf page.

The performance critical address space walkers use a different design
pattern that avoids this.

> +		if (pte_dirty(*pte) && pte_write(*pte)) {
> +			pte_t entry = ptep_clear_flush(vma, addr, pte);

Flushing TLBs unbatched can also be very expensive because if the MM is
shared by several CPUs you'll have a inter-processor interrupt for 
each iteration. They are quite costly even on smaller systems.

It would be better if you did a single flush_tlb_range() at the end.
This means on x86 this will currently always do a full flush, but that's
still better than really slowing down in the heavily multithreaded case.

-Andi
