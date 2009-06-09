Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbZFIKJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbZFIKJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbZFIKJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:09:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbZFIKJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:09:21 -0400
Date: Tue, 9 Jun 2009 12:09:22 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: hugh.dickins@tiscali.co.uk, riel@redhat.com, chris.mason@oracle.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v5
Message-ID: <20090609100922.GF14820@wotan.suse.de>
References: <20090603846.816684333@firstfloor.org> <20090603184648.2E2131D028F@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603184648.2E2131D028F@basil.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 08:46:47PM +0200, Andi Kleen wrote:

Why not have this in rmap.c and not export the locking?
I don't know.. does Hugh care?

> +/*
> + * Collect processes when the error hit an anonymous page.
> + */
> +static void collect_procs_anon(struct page *page, struct list_head *to_kill,
> +			      struct to_kill **tkc)
> +{
> +	struct vm_area_struct *vma;
> +	struct task_struct *tsk;
> +	struct anon_vma *av = page_lock_anon_vma(page);
> +
> +	if (av == NULL)	/* Not actually mapped anymore */
> +		return;
> +
> +	read_lock(&tasklist_lock);
> +	for_each_process (tsk) {
> +		if (!tsk->mm)
> +			continue;
> +		list_for_each_entry (vma, &av->head, anon_vma_node) {
> +			if (vma->vm_mm == tsk->mm)
> +				add_to_kill(tsk, page, vma, to_kill, tkc);
> +		}
> +	}
> +	page_unlock_anon_vma(av);
> +	read_unlock(&tasklist_lock);
> +}
> +
> +/*
> + * Collect processes when the error hit a file mapped page.
> + */
> +static void collect_procs_file(struct page *page, struct list_head *to_kill,
> +			      struct to_kill **tkc)
> +{
> +	struct vm_area_struct *vma;
> +	struct task_struct *tsk;
> +	struct prio_tree_iter iter;
> +	struct address_space *mapping = page_mapping(page);
> +
> +	/*
> +	 * A note on the locking order between the two locks.
> +	 * We don't rely on this particular order.
> +	 * If you have some other code that needs a different order
> +	 * feel free to switch them around. Or add a reverse link
> +	 * from mm_struct to task_struct, then this could be all
> +	 * done without taking tasklist_lock and looping over all tasks.
> +	 */
> +
> +	read_lock(&tasklist_lock);
> +	spin_lock(&mapping->i_mmap_lock);

This still has my original complaint that it nests tasklist lock inside
anon vma lock and outside inode mmap lock (and anon_vma nests inside i_mmap).
I guess the property of our current rw locks means that does not matter,
but it could if we had "fair" rw locks, or some tree (-rt tree maybe)
changed rw lock to a plain exclusive lock.


> +	for_each_process(tsk) {
> +		pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
> +
> +		if (!tsk->mm)
> +			continue;
> +
> +		vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff,
> +				      pgoff)
> +			if (vma->vm_mm == tsk->mm)
> +				add_to_kill(tsk, page, vma, to_kill, tkc);
> +	}
> +	spin_unlock(&mapping->i_mmap_lock);
> +	read_unlock(&tasklist_lock);
> +}
> +
> +/*
> + * Collect the processes who have the corrupted page mapped to kill.
> + * This is done in two steps for locking reasons.
> + * First preallocate one tokill structure outside the spin locks,
> + * so that we can kill at least one process reasonably reliable.
> + */
> +static void collect_procs(struct page *page, struct list_head *tokill)
> +{
> +	struct to_kill *tk;
> +
> +	tk = kmalloc(sizeof(struct to_kill), GFP_KERNEL);
> +	/* memory allocation failure is implicitly handled */
> +	if (PageAnon(page))
> +		collect_procs_anon(page, tokill, &tk);
> +	else
> +		collect_procs_file(page, tokill, &tk);
> +	kfree(tk);
> +}

> Index: linux/mm/filemap.c
> ===================================================================
> --- linux.orig/mm/filemap.c	2009-06-03 19:37:38.000000000 +0200
> +++ linux/mm/filemap.c	2009-06-03 20:13:43.000000000 +0200
> @@ -105,6 +105,10 @@
>   *
>   *  ->task->proc_lock
>   *    ->dcache_lock		(proc_pid_lookup)
> + *
> + *  (code doesn't rely on that order, so you could switch it around)
> + *  ->tasklist_lock             (memory_failure, collect_procs_ao)
> + *    ->i_mmap_lock
>   */
>  
>  /*
> Index: linux/mm/rmap.c
> ===================================================================
> --- linux.orig/mm/rmap.c	2009-06-03 19:37:38.000000000 +0200
> +++ linux/mm/rmap.c	2009-06-03 20:13:43.000000000 +0200
> @@ -36,6 +36,10 @@
>   *                 mapping->tree_lock (widely used, in set_page_dirty,
>   *                           in arch-dependent flush_dcache_mmap_lock,
>   *                           within inode_lock in __sync_single_inode)
> + *
> + * (code doesn't rely on that order so it could be switched around)
> + * ->tasklist_lock
> + *   anon_vma->lock      (memory_failure, collect_procs_anon)
>   */
>  
>  #include <linux/mm.h>
