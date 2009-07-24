Return-Path: <linux-kernel-owner+w=401wt.eu-S1752006AbZGXIhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbZGXIhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 04:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZGXIhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 04:37:20 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:58067 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbZGXIhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 04:37:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jYC3qhc484cI9ds1ied4mxkAigY2Ku4iXI00ixF6cQYGnncMQhuN1D0RLO9A14dspS
         pWDG4P+aEbboDVpHyX9hX7pD46oZkauRlvx6MIeZ5BvFeFSuhUHioX/X5eLvJFdFvwQ1
         MR0V/1Lu1kfb/Lq5YxNFBxQiK0k0k7VQ7VMD0=
Date: Fri, 24 Jul 2009 16:39:26 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: "Moussa A. Ba" <moussa.a.ba@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       adobriyan@gmail.com, mpm@selenic.com, mel@csn.ul.ie, yinghan@google.com,
       npiggin@suse.de, jaredeh@gmail.com
Subject: Re: [PATCH 1/1] pagemap clear_refs: modify to specify anon or
	mapped vma clearing
Message-ID: <20090724083926.GA6372@cr0.nay.redhat.com>
References: <4A693122.6060503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A693122.6060503@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 08:57:22PM -0700, Moussa A. Ba wrote:
>
> Signed-off-by: Jared E. Hulbert <jaredeh@gmail.com>
> Signed-off-by: Moussa Ba <moussa.a.ba@gmail.com>
> --- a/fs/proc/task_mmu.c	2009-07-21 14:30:01.000000000 -0700
> +++ b/fs/proc/task_mmu.c	2009-07-21 14:32:56.000000000 -0700
> @@ -461,6 +461,33 @@
>  	cond_resched();
>  	return 0;
>  }
> +static void walk_vma_area(struct mm_walk *this_walk, struct  
> vm_area_struct *vma,
> +						int type)
> +{
> +	switch (type) {
> +		/* Clear Anon VMAs only */
> +	case 1:
> +		if (!is_vm_hugetlb_page(vma) && !vma->vm_file)
> +			walk_page_range(vma->vm_start,
> +					vma->vm_end,
> +					this_walk);
> +		break;
> +		/* Clear Mapped VMAs only */
> +	case 2:
> +		if (!is_vm_hugetlb_page(vma) && vma->vm_file)
> +			walk_page_range(vma->vm_start,
> +					vma->vm_end,
> +					this_walk);
> +		break;
> +		/* Clear All VMAs */
> +	default:
> +		if (!is_vm_hugetlb_page(vma))
> +			walk_page_range(vma->vm_start,
> +					vma->vm_end,
> +					this_walk);
> +		break;
> +	}
> +}
>


First, can you make these plain numbers as macros or enum types?

Second, I believe the above code can be simiplified, how about below?

{
    if (!is_vm_hugetlb_page(vma)) {
        if (type == 1 && vma->vm_file)
             return;
        if (type == 2 && !vma->vm_file)
             return;
        walk_page_range(vma->vm_start, vma->end, this_walk);
    }
}



>  static ssize_t clear_refs_write(struct file *file, const char __user *  
> buf,
>  				size_t count, loff_t * ppos)
> @@ -469,13 +496,15 @@
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
> +	type = simple_strtol(buffer, &end, 0);
> +	if (!type)
>  		return -EINVAL;
>  	if (*end == '\n')
>  		end++;
> @@ -491,9 +520,7 @@
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
