Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbYBFUXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbYBFUXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 15:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbYBFUXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 15:23:08 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:52692 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbYBFUXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 15:23:06 -0500
Date: Wed, 6 Feb 2008 20:22:31 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <mszeredi@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmap_region: cleanup, remove unneeded file != NULL check
In-Reply-To: <20080203180122.GA5819@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0802062013210.32204@blonde.site>
References: <20080203180122.GA5819@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Feb 2008, Oleg Nesterov wrote:

> mmap_region() checks "file != NULL" when we know "file && vma_merge() == T".
> Also, swap these if/else branches, imho make the code a bit more readable.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-with-a-but-by: Hugh Dickins <hugh@veritas.com>

That's a great little improvement, Oleg: my difficulty in understanding
the patch is all due to the obscurity of the original you're improving.

But my but is this: you can go one step further, it's silly to be
repeating the "if (correct_wcount) atomic_inc..." in both the if
and the else clauses.

For several minutes I thought that must indicate we already had a
bug there.  Eventually I realized not: we need deny_write_access()
above to test and deny atomically, then once we've merged or linked
the vma it's securely denying in the vma itself: so before returning
we need to undo our temporary denial.  A brief comment might be
worthwhile, perhaps something like

	/* Once vma denies write, undo our temporary denial count */
	if (correct_wcount)
		atomic_inc(&inode->i_writecount);

Hugh

> 
> --- MM/mm/mmap.c~1_MMAP	2008-01-27 17:09:47.000000000 +0300
> +++ MM/mm/mmap.c	2008-02-03 20:49:39.000000000 +0300
> @@ -1189,22 +1189,20 @@ munmap_back:
>  	if (vma_wants_writenotify(vma))
>  		vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
>  
> -	if (!file || !vma_merge(mm, prev, addr, vma->vm_end,
> +	if (file && vma_merge(mm, prev, addr, vma->vm_end,
>  			vma->vm_flags, NULL, file, pgoff, vma_policy(vma))) {
> +		mpol_free(vma_policy(vma));
> +		kmem_cache_free(vm_area_cachep, vma);
> +		if (correct_wcount)
> +			atomic_inc(&inode->i_writecount);
> +		fput(file);
> +	} else {
>  		file = vma->vm_file;
>  		vma_link(mm, vma, prev, rb_link, rb_parent);
>  		if (correct_wcount)
>  			atomic_inc(&inode->i_writecount);
> -	} else {
> -		if (file) {
> -			if (correct_wcount)
> -				atomic_inc(&inode->i_writecount);
> -			fput(file);
> -		}
> -		mpol_free(vma_policy(vma));
> -		kmem_cache_free(vm_area_cachep, vma);
>  	}
> -out:	
> +out:
>  	mm->total_vm += len >> PAGE_SHIFT;
>  	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
>  	if (vm_flags & VM_LOCKED) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
