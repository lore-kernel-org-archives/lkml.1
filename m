Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbZG0U5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbZG0U5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbZG0U5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:57:46 -0400
Received: from smtp-out.google.com ([216.239.45.13]:4586 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbZG0U5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:57:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=M7/YTPD46wL1XAcQFaYR3hWpoLFdqabRhGJN6kzhID7b0HZeXtDYt4uCYL8NRLekz
	dbw9wUjgR/9x3G9uC+vcw==
Date: Mon, 27 Jul 2009 13:57:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Moussa A. Ba" <moussa.a.ba@gmail.com>
cc: linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Matt Mackall <mpm@selenic.com>,
       Mel Gorman <mel@csn.ul.ie>, Ying Han <yinghan@google.com>,
       Nick Piggin <npiggin@suse.de>, jaredeh@gmail.com
Subject: Re: [PATCH 1/1] pagemap clear_refs: modify to specify anon or mapped
 vma clearing
In-Reply-To: <4A6E0BD6.50102@gmail.com>
Message-ID: <alpine.DEB.2.00.0907271339070.17425@chino.kir.corp.google.com>
References: <4A693122.6060503@gmail.com> <20090724083926.GA6372@cr0.nay.redhat.com> <4A6E0BD6.50102@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009, Moussa A. Ba wrote:

> This patch makes the clear_refs proc interface a bit more versatile.
> It adds support  for clearing anonymous pages, file mapped pages or both.
> 

It already has support for clearing both, so you're only adding anonymous 
and file-backed filters.

> The clear_refs entry is used to reset the Referenced bits on virtual and
> physical pages associated with a process.
> echo 1 > /proc/PID/clear_refs clears all pages associated with the process
> echo 2 > /proc/PID/clear_refs clears anonymous pages only
> echo 3 > /proc/PID/clear_refs clears file mapped pages only
> Any other value written to the proc entry will clear all pages.
> 

clear_refs currently accepts any non-zero value, so it's possible that 
this will break user scripts that, for whatever reason, write '2' or '3'.  
I think that's acceptable, but it would be helpful to make all other 
values a no-op similar to drop_caches at this point to avoid the potential 
for breakage if this is ever extended any further.

> Selective clearing the pages has a measurable impact on performance as it
> limits the number of page walks.  We have been using this interface and  this
> adds flexibility to the user user space application implementing the reference
> clearing.
> 
> Signed-off-by: Jared Hulbert (jaredeh@gmail.com)
> Signed-off-by: Moussa A. Ba (moussa.a.ba@gmail.com)

Email addresses in < > braces, please.

The first sign-off line normally indicates who wrote the patch, but your 
submission lacks a From: line, so git would indicate you wrote it.  If 
that's incorrect, please add a From: line as described in 
Documentation/SubmittingPatches.  If it's correct, please reorder your 
sign-off lines.

> -------
> Documentation/filesystems/proc.txt |    7 +++++++
> fs/proc/task_mmu.c                 |   29 +++++++++++++++++++++++++----
> 2 files changed, 32 insertions(+), 4 deletions(-)
> 
> --- a/fs/proc/task_mmu.c	2009-07-21 14:30:01.000000000 -0700
> +++ b/fs/proc/task_mmu.c	2009-07-27 11:46:05.000000000 -0700
> @@ -462,6 +462,27 @@
>  	return 0;
>  }
> 
> +static void walk_vma_area(struct mm_walk *this_walk,
> +			  struct vm_area_struct *vma, int type)
> +{

This is a very generic name for something that is only applicable to 
clear_refs, so please name it accordingly.  This will also avoid having to 
pass the struct mm_walk * in since its only user is clear_refs_walk.

> +
> +	/* Writing 2 to /proc/pid/clear_refs will clear all Anonymous
> +	 * pages.
> +	 *
> +	 * Writing 3 to /proc/pid/clear_refs will clear all file mapped
> +	 * pages.
> +	 *
> +	 * Writing any other value including 1 will clear all pages
> +	 */

Documentation/CodingStyle would suggest this format:

	/*
	 * Multi-line kernel comments always start ..
	 * with an empty first line.
	 */

> +	if (is_vm_hugetlb_page(vma))
> +		return;
> +	if (type == 2 && vma->vm_file)
> +		return;
> +	if (type == 3 && !vma->vm_file)
> +		return;
> +	walk_page_range(vma->vm_start, vma->vm_end, this_walk);
> +}

K&R would suggest #define's (or enums) for those hard-coded values.  I 
think that's already been suggested for this patch, actually.

> +
>  static ssize_t clear_refs_write(struct file *file, const char __user * buf,
>  				size_t count, loff_t * ppos)
>  {
> @@ -469,13 +490,15 @@
>  	char buffer[PROC_NUMBUF], *end;
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
> +	int type;
> 
>  	memset(buffer, 0, sizeof(buffer));
>  	if (count > sizeof(buffer) - 1)
>  		count = sizeof(buffer) - 1;
>  	if (copy_from_user(buffer, buf, count))
>  		return -EFAULT;
> -	if (!simple_strtol(buffer, &end, 0))
> +	type = strict_strtol(buffer, &end, 0);
> +	if (!type)
>  		return -EINVAL;
>  	if (*end == '\n')
>  		end++;
> @@ -491,9 +514,7 @@
>  		down_read(&mm->mmap_sem);
>  		for (vma = mm->mmap; vma; vma = vma->vm_next) {
>  			clear_refs_walk.private = vma;
> -			if (!is_vm_hugetlb_page(vma))
> -				walk_page_range(vma->vm_start, vma->vm_end,
> -						&clear_refs_walk);
> +			walk_vma_area(&clear_refs_walk, vma, type);
>  		}
>  		flush_tlb_mm(mm);
>  		up_read(&mm->mmap_sem);
> --- a/Documentation/filesystems/proc.txt	2009-07-20 17:29:11.000000000
> -0700
> +++ b/Documentation/filesystems/proc.txt	2009-07-27 12:08:34.000000000
> -0700
> @@ -375,6 +375,13 @@
>  This file is only present if the CONFIG_MMU kernel configuration option is
>  enabled.
> 
> +The clear_refs entry is used to reset the Referenced bits on virtual and physical
> +pages associated with a process.
> +echo 1 > /proc/PID/clear_refs clears all pages associated with the process
> +echo 2 > /proc/PID/clear_refs clears anonymous pages only
> +echo 3 > /proc/PID/clear_refs clears file mapped pages only
> +Any other value written to the proc entry will clear all pages.
> +

Please follow the format in this document for how other /proc/PID/* 
entries are described.

That format could really be improved here, perhaps you could clean 
proc.txt up a little bit while you're here?


Also, as the author of clear_refs, please cc me on future revisions of 
this patch.
