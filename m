Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbYAWJlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbYAWJlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 04:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYAWJlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 04:41:07 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46113 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbYAWJlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 04:41:06 -0500
To: salikhmetov@gmail.com
CC: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, miklos@szeredi.hu,
       r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com, hch@infradead.org
In-reply-to: <1201044083504-git-send-email-salikhmetov@gmail.com> (message
	from Anton Salikhmetov on Wed, 23 Jan 2008 02:21:19 +0300)
Subject: Re: [PATCH -v8 3/4] Enable the MS_ASYNC functionality in sys_msync()
References: <12010440803930-git-send-email-salikhmetov@gmail.com> <1201044083504-git-send-email-salikhmetov@gmail.com>
Message-Id: <E1JHc6Q-00028V-5w@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 Jan 2008 10:41:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Force file times update at the next write reference after
> calling the msync() system call with the MS_ASYNC flag.
> 
> Signed-off-by: Anton Salikhmetov <salikhmetov@gmail.com>
> ---
>  mm/msync.c |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
>  1 files changed, 82 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/msync.c b/mm/msync.c
> index 60efa36..87f990e 100644
> --- a/mm/msync.c
> +++ b/mm/msync.c
> @@ -5,6 +5,7 @@
>   * Copyright (C) 2008 Anton Salikhmetov <salikhmetov@gmail.com>
>   */
>  
> +#include <asm/tlbflush.h>
>  #include <linux/file.h>
>  #include <linux/fs.h>
>  #include <linux/mm.h>
> @@ -12,6 +13,73 @@
>  #include <linux/sched.h>
>  #include <linux/syscalls.h>
>  
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

Why can't the pte_offset_map_lock/unlock be moved outside the loop, as
in Peter's example?  My guess is, it could have some impact on
performance.

> +
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

Need to check mapping_cap_account_dirty().  Otherwise we would be
inconsistent with write protecting ram-backed filesystems.

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
> +
>  /*
>   * MS_SYNC syncs the entire file - including mappings.
>   *
> @@ -78,16 +146,20 @@ asmlinkage long sys_msync(unsigned long start, size_t len, int flags)
>  		error = 0;
>  		start = vma->vm_end;
>  		file = vma->vm_file;
> -		if (file && (vma->vm_flags & VM_SHARED) && (flags & MS_SYNC)) {
> -			get_file(file);
> -			up_read(&mm->mmap_sem);
> -			error = do_fsync(file, 0);
> -			fput(file);
> -			if (error || start >= end)
> -				goto out;
> -			down_read(&mm->mmap_sem);
> -			vma = find_vma(mm, start);
> -			continue;
> +		if (file && (vma->vm_flags & VM_SHARED)) {
> +			if ((flags & MS_ASYNC))
> +				vma_wrprotect(vma);
> +			if (flags & MS_SYNC) {
> +				get_file(file);
> +				up_read(&mm->mmap_sem);
> +				error = do_fsync(file, 0);
> +				fput(file);
> +				if (error || start >= end)
> +					goto out;
> +				down_read(&mm->mmap_sem);
> +				vma = find_vma(mm, start);
> +				continue;
> +			}
>  		}
>  
>  		vma = vma->vm_next;
> -- 
> 1.4.4.4
> 
> 
