Return-Path: <linux-kernel-owner+w=401wt.eu-S1751073AbXCYNmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073AbXCYNmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 09:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbXCYNmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 09:42:32 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:5126 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbXCYNmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 09:42:31 -0400
X-AuditID: d80ac287-91523bb000000c42-6a-46067c46d619 
Date: Sun, 25 Mar 2007 14:42:21 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Bruce Dubbs <bruce.dubbs@gmail.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add additional error check to mm/mincore.c
In-Reply-To: <4605D4EB.5060205@gmail.com>
Message-ID: <Pine.LNX.4.64.0703251416470.11785@blonde.wat.veritas.com>
References: <4605D4EB.5060205@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 25 Mar 2007 13:42:30.0414 (UTC) FILETIME=[6F1CD2E0:01C76EE3]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2007, Bruce Dubbs wrote:

> I some circumstances, mincore can succeed when it shouldn't.
> 
> Example:
>   Two files are mmapped to a process and they are adjacent in memory.
> If mincore is run with a requested length that is too large, the
> function does not differentiate between the different file pointers
> within the different vma structures and inappropriately returns success.

You've got this the wrong way round.  mincore should succeed in
these cases: just like munmap, mprotect, msync, madvise etc do.

> 
> The attached patch, against 2.6.20.3, fixes this behavior.

NAK, sorry.

> 
> This behavior was found when running the Linux Test Project's mincore01
> on an IA32 system.  Test 3 "unexpectedly" succeeds.

Please follow that up with the LTP guys: I expect they'll quickly
agree that the test is wrong and correct it.

It probably dates from when mmap addresses were commonly allocated in
ascending order, whereas now they're commonly allocated in descending
order: neither being a rule, neither to be assumed.  (Ah, I see Nick
has already suggested this memory layout issue to you.)

Another thing to keep in mind is that 2.6.21-rc fixes mincore to
succeed on anonymous areas, where before it failed for no very good
reason.  That can't be the issue here, since your report is against
earlier releases; but it is something for the test fixer to note.

Thanks,
Hugh

> 
>   -- Bruce
> 
> 
> --- mm/mincore.c.old	2007-03-24 19:55:01.000000000 -0500
> +++ mm/mincore.c	2007-03-24 20:13:43.000000000 -0500
> @@ -43,7 +43,8 @@
>   * all the arguments, we hold the mmap semaphore: we should
>   * just return the amount of info we're asked for.
>   */
> -static long do_mincore(unsigned long addr, unsigned char *vec, unsigned long pages)
> +static long do_mincore(unsigned long addr, unsigned char *vec, unsigned long pages,
> +        struct file** file_struct)
>  {
>  	unsigned long i, nr, pgoff;
>  	struct vm_area_struct *vma = find_vma(current->mm, addr);
> @@ -64,7 +65,19 @@
>  	 * this is what we've traditionally done, so we'll just
>  	 * continue doing it.
>  	 */
> -	if (!vma->vm_file)
> +
> +    /* 
> +     * Initialize file pointer to the value in the first vma structure
> +     */
> +
> +    if ( *file_struct == NULL && vma->vm_file )
> +        *file_struct = vma->vm_file;
> +
> +    /*
> +     * Return an error if the is no file mapped of the file is different
> +     */
> + 
> +	if (!vma->vm_file || vma->vm_file != *file_struct)
>  		return -ENOMEM;
>  
>  	/*
> @@ -115,6 +128,7 @@
>  	long retval;
>  	unsigned long pages;
>  	unsigned char *tmp;
> +    static struct file* file = NULL;
>  
>  	/* Check the start address: needs to be page-aligned.. */
>   	if (start & ~PAGE_CACHE_MASK)
> @@ -142,7 +156,7 @@
>  		 * the temporary buffer size.
>  		 */
>  		down_read(&current->mm->mmap_sem);
> -		retval = do_mincore(start, tmp, min(pages, PAGE_SIZE));
> +		retval = do_mincore(start, tmp, min(pages, PAGE_SIZE), &file);
>  		up_read(&current->mm->mmap_sem);
>  
>  		if (retval <= 0)
