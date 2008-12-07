Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbYLGCvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbYLGCvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 21:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbYLGCu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 21:50:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbYLGCu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 21:50:56 -0500
Date: Sat, 6 Dec 2008 18:50:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH] No get_user/put_user while holding mmap_sem in
 do_pages_stat?
Message-Id: <20081206185050.544f67fc.akpm@linux-foundation.org>
In-Reply-To: <493B3179.7030204@inria.fr>
References: <493B3179.7030204@inria.fr>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Dec 2008 03:14:17 +0100 Brice Goglin <Brice.Goglin@inria.fr> wrote:

> Hello,
> 
> I have been seeing some deadlocks that seem to be related to do_pages_stat()
> page-faulting while holding the mmap_sem. Part of my sys_move_pages() rework
> has been applied to 2.6.28-rc. So do_pages_stat() now gets page addresses
> from user-space (and puts the result back to user-space) while holding the
> mmap_sem for read. If there's a page-fault there, the page-fault handler
> grabs the mmap_sem for read again. But if another thread took it for write
> in the meantime (for instance in mprotect), it deadlocks since rwsem readers
> are blocked if a writer is already waiting.
> 
> Reading the archives, I see some similar deadlocks a couple years ago but
> I can't find the final answer/fix. From what I understand, the mmap_sem
> fairness could not be changed easily. So I am not sure whether accessing
> user-space while holding mmap_sem for read is still valid/recommended today.
> But the behavior of do_pages_stat() changed between 2.6.27 and 2.6.28-rc
> because of my patch, and this deadlock seems to be happening for real.

Yes, that's still a bug.

Was lockdep able to tell you about this in any way?

> So I would like to fix this small regression in 2.6.28.

s/small/fairly large/:)

> The patch below seems
> to make my do_pages_stat() deadlock disappear here.
> 
> Brice
> 
> 
> 
> [PATCH] No get_user/put_user while holding mmap_sem in do_pages_stat
>    
> Since commit 2f007e74bb85b9fc4eab28524052161703300f1a, do_pages_stat()
> gets the page address from user-space and puts the corresponding status
> back while holding the mmap_sem for read. There is no need to hold
> mmap_sem there while some page-faults may occur.
> 
> This patch adds a temporary address and status buffer so as to only hold
> mmap_sem while working on these kernel buffers. This is implemented by
> extracting do_pages_stat_array() out of do_pages_stat().
> 
> Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 1e0d6b2..4350101 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -987,25 +987,18 @@ out:
>  /*
>   * Determine the nodes of an array of pages and store it in an array of status.
>   */
> -static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
> -			 const void __user * __user *pages,
> -			 int __user *status)
> +static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
> +				const void * __user *pages, int *status)
>  {
>  	unsigned long i;
> -	int err;
>  
>  	down_read(&mm->mmap_sem);
>  
> -	for (i = 0; i < nr_pages; i++) {
> -		const void __user *p;
> -		unsigned long addr;
> +	for (i = 0; i < nr_pages; i++, pages++, status++) {
> +		unsigned long addr = (unsigned long)(*pages);

Directly dereferencing a user pointer is very bad.  Fortunately, it's
just that the above __user annotation is now wrong.

>  		struct vm_area_struct *vma;
>  		struct page *page;
> -
> -		err = -EFAULT;
> -		if (get_user(p, pages+i))
> -			goto out;
> -		addr = (unsigned long) p;
> +		int err;
>  
>  		vma = find_vma(mm, addr);
>  		if (!vma)
> @@ -1024,12 +1017,59 @@ static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
>  
>  		err = page_to_nid(page);
>  set_status:
> -		put_user(err, status+i);
> +		*status = err;
> +	}
> +
> +	up_read(&mm->mmap_sem);
> +}
> +
> +/*
> + * Determine the nodes of a user array of pages and store it in
> + * a user array of status.
> + */
> +static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
> +			 const void __user * __user *pages,
> +			 int __user *status)
> +{
> +	const void * __user *chunk_pages;

This is not a userspace pointer.

> +	int *chunk_status;
> +	unsigned long i,chunk_nr;
> +	int err;
> +
> +	err = -ENOMEM;
> +	chunk_pages = (const void * __user *)__get_free_page(GFP_KERNEL);
> +	if (!chunk_pages)
> +		goto out;
> +	chunk_status = (int *)__get_free_page(GFP_KERNEL);
> +	if (!chunk_status)
> +		goto out_with_chunk_pages;

Given that this code use to perform acceptably (presumably) doing one
page at a time, I suspect that you could have retained that behaviour,
avoiding the complexity of those two arrays.  Would an additional
down_read()/up_read() per page have been unacceptably costly?

The arrays could have been allocated on the stack, I expect.  16 slots
is enough?

> +	chunk_nr = PAGE_SIZE/max(sizeof(*chunk_pages), sizeof(*chunk_status));
> +	for(i = 0; i < nr_pages; i += chunk_nr, pages += chunk_nr, status += chunk_nr) {

Please try to make this more checkpatch-friendly.  Moving the
alteration of `pages' and `status' to the end of the loop would fix
that, and would result in clearer (IMO) code.

And simply using pages[chunk_nr] everywhere would clean stuff up (IMO).

> +		if (chunk_nr + i > nr_pages)
> +			chunk_nr = nr_pages - i;
> +
> +		err = copy_from_user(chunk_pages, pages, chunk_nr * sizeof(*chunk_pages));
> +		if (err) {
> +			err = -EFAULT;
> +			goto out_with_chunk_status;
> +		}
> +
> +		do_pages_stat_array(mm, chunk_nr, chunk_pages, chunk_status);
> +
> +		err = copy_to_user(status, chunk_status, chunk_nr * sizeof(*chunk_status));
> +		if (err) {
> +			err = -EFAULT;
> +			goto out_with_chunk_status;
> +		}
>  	}
>  	err = 0;
>  
> +out_with_chunk_status:
> +	free_page((unsigned long)chunk_status);
> +out_with_chunk_pages:
> +	free_page((unsigned long)chunk_pages);
>  out:
> -	up_read(&mm->mmap_sem);
>  	return err;
>  }

It's a small semantic change, isn't it?  We release the semaphore in
the middle of the operation, thus presenting possibly
non-internally-consistent results to userspace.  Why does this not matter?

Given the number of __user errors this patch added, I'd recommend that
v2 be checked with sparse, please.
