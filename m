Return-Path: <linux-kernel-owner+w=401wt.eu-S964788AbXGMIOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964788AbXGMIOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 04:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935680AbXGMIOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 04:14:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49347 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935600AbXGMIOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 04:14:18 -0400
Date: Fri, 13 Jul 2007 01:13:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Monakhov <dmonakhov@sw.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch] mm: recheck lock rlim after f_op->mmap() method
Message-Id: <20070713011332.2550c5e1.akpm@linux-foundation.org>
In-Reply-To: <20070709184917.GA8720@dnb.sw.ru>
References: <20070709184917.GA8720@dnb.sw.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007 22:49:17 +0400 Dmitry Monakhov <dmonakhov@sw.ru> wrote:

> Some device drivers can change vm_flags in their f_op->mmap
> method. In order to be on the safe side we have to recheck
> lock rlimit. Now we have to check lock rlimit from two places,
> let's move this common code to helper functon.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  mm/mmap.c |   33 ++++++++++++++++++++++++++-------
>  1 files changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 906ed40..5c89f1d 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -885,6 +885,18 @@ void vm_stat_account(struct mm_struct *mm, unsigned long flags,
>  }
>  #endif /* CONFIG_PROC_FS */
>  
> +static int check_lock_limit(unsigned long delta, struct mm_struct* mm)
> +{
> +	unsigned long locked, lock_limit;
> +	locked = delta >> PAGE_SHIFT;
> +	locked += mm->locked_vm;
> +	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
> +	lock_limit >>= PAGE_SHIFT;
> +	if (locked > lock_limit && !capable(CAP_IPC_LOCK))
> +		return -EAGAIN;
> +	return 0;
> +}
> +
>  /*
>   * The caller must hold down_write(current->mm->mmap_sem).
>   */
> @@ -954,13 +966,9 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
>  	}
>  	/* mlock MCL_FUTURE? */
>  	if (vm_flags & VM_LOCKED) {
> -		unsigned long locked, lock_limit;
> -		locked = len >> PAGE_SHIFT;
> -		locked += mm->locked_vm;
> -		lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
> -		lock_limit >>= PAGE_SHIFT;
> -		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
> -			return -EAGAIN;
> +		error = check_lock_limit(len, mm);
> +		if (error)
> +			return error;
>  	}
>  
>  	inode = file ? file->f_path.dentry->d_inode : NULL;
> @@ -1101,6 +1109,17 @@ munmap_back:
>  		error = file->f_op->mmap(file, vma);
>  		if (error)
>  			goto unmap_and_free_vma;
> +		
> +		if (vma->vm_flags & VM_LOCKED
> +				&& !(vm_flags & VM_LOCKED)) {
> +		/*
> +		 * VM_LOCKED was added in f_op->mmap() method,
> +		 * so we have to recheck limit.
> +		 */
> +			error = check_lock_limit(len, mm);
> +			if (error)
> +				goto unmap_and_free_vma;
> +		}

Worried.  As far as the filesytem is concerned, its mmap has succeeded.

But now we're taking the unmap_and_free_vma path _after_ ->mmap() has
"succeeded".  So we will now tell userspace that the mmap syscall has
failed, even though the fs thinks it succeeded, if you follow me.  And this
is a new thing.  

Could it cause bad things to happen?  Well, if filesystems had a
file_operations.munmap() then yeah, we should have called that in your new
code.  But filesystems don't have a ->munmap() method.

Still.  Can we think of any way in which this change could lead to resource
leaks or to any other such problems?

