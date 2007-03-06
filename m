Return-Path: <linux-kernel-owner+w=401wt.eu-S1751052AbXCFUck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052AbXCFUck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbXCFUck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:32:40 -0500
Received: from amsfep20-int.chello.nl ([62.179.120.15]:40013 "EHLO
	amsfep20-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbXCFUcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:32:39 -0500
Subject: Re: [patch 2/8] update ctime and mtime for mmaped write
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, staubach@redhat.com, hugh@veritas.com
In-Reply-To: <20070306180549.312408559@szeredi.hu>
References: <20070306180443.669036741@szeredi.hu>
	 <20070306180549.312408559@szeredi.hu>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 21:32:31 +0100
Message-Id: <1173213151.4718.16.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 19:04 +0100, Miklos Szeredi wrote:
> plain text document attachment (mmap_mtime.patch)

> Index: linux/mm/rmap.c
> ===================================================================
> --- linux.orig/mm/rmap.c	2007-03-06 15:17:46.000000000 +0100
> +++ linux/mm/rmap.c	2007-03-06 15:17:46.000000000 +0100
> @@ -498,6 +498,43 @@ int page_mkclean(struct page *page)
>  }
>  
>  /**
> + * is_page_modified - check and clear the dirty bit for all mappings of a page
> + * @page:	the page to check
> + */
> +bool is_page_modified(struct page *page)
> +{
> +	struct address_space *mapping = page->mapping;
> +	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
> +	struct vm_area_struct *vma;
> +	struct prio_tree_iter iter;
> +	bool modified = false;
> +
> +	BUG_ON(!mapping);
> +	BUG_ON(!page_mapped(page));
> +
> +	spin_lock(&mapping->i_mmap_lock);
> +	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
> +		if (vma->vm_flags & VM_SHARED) {
> +			struct mm_struct *mm = vma->vm_mm;
> +			unsigned long addr = vma_address(page, vma);
> +			pte_t *pte;
> +			spinlock_t *ptl;
> +
> +			if (addr != -EFAULT &&
> +			    (pte = page_check_address(page, mm, addr, &ptl))) {
> +				if (ptep_clear_flush_dirty(vma, addr, pte))
> +					modified = true;
> +				pte_unmap_unlock(pte, ptl);
> +			}
> +		}
> +	}
> +	spin_unlock(&mapping->i_mmap_lock);
> +	if (page_test_and_clear_dirty(page))
> +		modified = 1;
> +	return modified;
> +}
> +
> +/**
>   * page_set_anon_rmap - setup new anonymous rmap
>   * @page:	the page to add the mapping to
>   * @vma:	the vm area in which the mapping is added

I'm not liking this, its not a constant operation as the name implies.
And it style is a bit out of line with the rest of rmap.

The thing it actually does is page_mkclean(), all it doesn't do is
setting the pte read-only.

I can understand you wanting to avoid the overhead of the minor faults
resulting from using page_mkclean(), but I'm not sure its worth it.

> Index: linux/mm/msync.c
> ===================================================================
> --- linux.orig/mm/msync.c	2007-03-06 15:17:42.000000000 +0100
> +++ linux/mm/msync.c	2007-03-06 15:17:46.000000000 +0100
> @@ -12,6 +12,86 @@
>  #include <linux/mman.h>
>  #include <linux/file.h>
>  #include <linux/syscalls.h>
> +#include <linux/pagemap.h>
> +#include <linux/rmap.h>
> +#include <linux/pagevec.h>
> +
> +/*
> + * Update ctime/mtime on msync().
> + *
> + * POSIX requires, that the times are updated between a modification
> + * of the file through a memory mapping and the next msync for a
> + * region containing the modification.  The wording implies that this
> + * must be done even if the modification was through a different
> + * address space.  Ugh.
> + *
> + * Non-linear vmas are to hard to handle and they are non-standard
> + * anyway, so they are ignored for now.
> + *
> + * The "file modified" info is collected from two places:
> + *
> + *  - AS_CMTIME flag of the mapping
> + *  - the dirty bit of the ptes
> + *
> + * For memory backed filesystems all the pages in the range need to be
> + * examined.  For non-memory backed filesystems it is enough to look
> + * at the pages with the dirty tag.
> + */
> +static void msync_update_file_time(struct vm_area_struct *vma,
> +				   unsigned long start, unsigned long end)
> +{
> +	struct file *file = vma->vm_file;
> +	struct address_space *mapping = file->f_mapping;
> +	struct pagevec pvec;
> +	pgoff_t index;
> +	pgoff_t end_index;
> +	bool modified;
> +
> +	if (!file || !(vma->vm_flags & VM_SHARED) ||
> +	    (vma->vm_flags & VM_NONLINEAR))
> +		return;
> +
> +	modified = test_and_clear_bit(AS_CMTIME, &mapping->flags);
> +
> +	pagevec_init(&pvec, 0);
> +	index = linear_page_index(vma, start);
> +	end_index = linear_page_index(vma, end);
> +	while (index < end_index) {
> +		int i;
> +		struct address_space *mapping = file->f_mapping;
> +		int nr_pages = min(end_index - index, (pgoff_t) PAGEVEC_SIZE);
> +
> +		if (mapping_cap_account_dirty(mapping))
> +			nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
> +					PAGECACHE_TAG_DIRTY, nr_pages);
> +		else
> +			nr_pages = pagevec_lookup(&pvec, mapping, index,
> +						  nr_pages);
> +		if (!nr_pages)
> +			break;
> +
> +		for (i = 0; i < nr_pages; i++) {
> +			struct page *page = pvec.pages[i];
> +
> +			/* Skip pages which are just being read */
> +			if (!PageUptodate(page))
> +				continue;
> +
> +			lock_page(page);
> +			index = page->index + 1;
> +			if (page->mapping == mapping &&
> +			    is_page_modified(page)) {
> +				set_page_dirty(page);
> +				modified = true;
> +			}
> +			unlock_page(page);
> +		}
> +		pagevec_release(&pvec);
> +	}
> +
> +	if (modified)
> +		file_update_time(file);
> +}
>  
>  /*
>   * MS_SYNC syncs the entire file - including mappings.

Something bothers me, although I'm not sure what yet..

