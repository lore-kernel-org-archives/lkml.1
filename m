Return-Path: <linux-kernel-owner+w=401wt.eu-S1757768AbYARJvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768AbYARJvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbYARJv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:51:28 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48649 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbYARJv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:51:27 -0500
To: salikhmetov@gmail.com
CC: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, miklos@szeredi.hu,
       r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com, hch@infradead.org
In-reply-to: <12006091211208-git-send-email-salikhmetov@gmail.com> (message
	from Anton Salikhmetov on Fri, 18 Jan 2008 01:31:58 +0300)
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped files
References: <12006091182260-git-send-email-salikhmetov@gmail.com> <12006091211208-git-send-email-salikhmetov@gmail.com>
Message-Id: <E1JFnsg-0008UU-LU@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 Jan 2008 10:51:22 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Updating file times at write references to memory-mapped files and
> forcing file times update at the next write reference after
> calling the msync() system call with the MS_ASYNC flag.
> 
> Signed-off-by: Anton Salikhmetov <salikhmetov@gmail.com>
> ---
>  mm/memory.c |    6 ++++++
>  mm/msync.c  |   52 +++++++++++++++++++++++++++++++++++++++-------------
>  2 files changed, 45 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 4bf0b6d..13d5bbf 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1668,6 +1668,9 @@ gotten:
>  unlock:
>  	pte_unmap_unlock(page_table, ptl);
>  	if (dirty_page) {
> +		if (vma->vm_file)
> +			file_update_time(vma->vm_file);
> +
>  		/*
>  		 * Yes, Virginia, this is actually required to prevent a race
>  		 * with clear_page_dirty_for_io() from clearing the page dirty
> @@ -2341,6 +2344,9 @@ out_unlocked:
>  	if (anon)
>  		page_cache_release(vmf.page);
>  	else if (dirty_page) {
> +		if (vma->vm_file)
> +			file_update_time(vma->vm_file);
> +
>  		set_page_dirty_balance(dirty_page, page_mkwrite);
>  		put_page(dirty_page);
>  	}
> diff --git a/mm/msync.c b/mm/msync.c
> index a4de868..a49af28 100644
> --- a/mm/msync.c
> +++ b/mm/msync.c
> @@ -13,11 +13,33 @@
>  #include <linux/syscalls.h>
>  
>  /*
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
> +
> +		if (pte_dirty(*pte) && pte_write(*pte))
> +			*pte = pte_wrprotect(*pte);
> +		pte_unmap_unlock(pte, ptl);
> +	}
> +}

What about ram based filesystems?  They don't start out with read-only
pte's, so I think they don't want them read-protected now either.
Unless this is essential for correct mtime/ctime accounting on these
filesystems (I don't think it really is).  But then the mapping should
start out read-only as well, otherwise the time update will only work
after an msync(MS_ASYNC).

> +
> +/*
>   * MS_SYNC syncs the entire file - including mappings.
>   *
> - * MS_ASYNC does not start I/O (it used to, up to 2.5.67).
> - * Nor does it mark the relevant pages dirty (it used to up to 2.6.17).
> - * Now it doesn't do anything, since dirty pages are properly tracked.
> + * MS_ASYNC does not start I/O. Instead, it marks the relevant pages
> + * read-only by calling vma_wrprotect(). This is needed to catch the next
> + * write reference to the mapped region and update the file times
> + * accordingly.
>   *
>   * The application may now run fsync() to write out the dirty pages and
>   * wait on the writeout and check the result. Or the application may run
> @@ -77,16 +99,20 @@ asmlinkage long sys_msync(unsigned long start, size_t len, int flags)
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
> +			if (flags & MS_ASYNC)
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
