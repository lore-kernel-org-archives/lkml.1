Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbYE3UbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbYE3UbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbYE3UbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:31:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754158AbYE3UbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:31:04 -0400
Date: Fri, 30 May 2008 13:29:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, agl@us.ibm.com,
       wli@holomorphy.com, kenchen@google.com, dwg@au1.ibm.com,
       andi@firstfloor.org, mel@csn.ul.ie, dean@arctic.org, abh@cray.com,
       apw@shadowen.org
Subject: Re: [PATCH 1/2] huge page private reservation review cleanups
Message-Id: <20080530132903.5d6717b0.akpm@linux-foundation.org>
In-Reply-To: <1212166704.0@pinky>
References: <exportbomb.1212166524@pinky>
	<1212166704.0@pinky>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008 17:58:24 +0100
Andy Whitcroft <apw@shadowen.org> wrote:

> 
> Create some new accessors for vma private data to cut down on and contain
> the casts.  Encapsulates the huge and small page offset calculations.  Also
> adds a couple of VM_BUG_ONs for consistency.
> 

I'll stage this after Mel's
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch

> ---
>  mm/hugetlb.c |   56 +++++++++++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 43 insertions(+), 13 deletions(-)
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 729a830..7a5ac81 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -40,6 +40,26 @@ static int hugetlb_next_nid;
>   */
>  static DEFINE_SPINLOCK(hugetlb_lock);
>  
> +/*
> + * Convert the address within this vma to the page offset within
> + * the mapping, in base page units.
> + */
> +pgoff_t vma_page_offset(struct vm_area_struct *vma, unsigned long address)
> +{
> +	return ((address - vma->vm_start) >> PAGE_SHIFT) +
> +					(vma->vm_pgoff >> PAGE_SHIFT);
> +}
> +
> +/*
> + * Convert the address within this vma to the page offset within
> + * the mapping, in pagecache page units; huge pages here.
> + */
> +pgoff_t vma_pagecache_offset(struct vm_area_struct *vma, unsigned long address)
> +{
> +	return ((address - vma->vm_start) >> HPAGE_SHIFT) +
> +			(vma->vm_pgoff >> (HPAGE_SHIFT - PAGE_SHIFT));
> +}

I'll make these static.

>  #define HPAGE_RESV_OWNER    (1UL << (BITS_PER_LONG - 1))
>  #define HPAGE_RESV_UNMAPPED (1UL << (BITS_PER_LONG - 2))
>  #define HPAGE_RESV_MASK (HPAGE_RESV_OWNER | HPAGE_RESV_UNMAPPED)
> @@ -53,36 +73,48 @@ static DEFINE_SPINLOCK(hugetlb_lock);
>   * to reset the VMA at fork() time as it is not in use yet and there is no
>   * chance of the global counters getting corrupted as a result of the values.
>   */
> +static unsigned long get_vma_private_data(struct vm_area_struct *vma)
> +{
> +	return (unsigned long)vma->vm_private_data;
> +}
> +
> +static void set_vma_private_data(struct vm_area_struct *vma,
> +							unsigned long value)
> +{
> +	vma->vm_private_data = (void *)value;
> +}

Better.

>  static unsigned long vma_resv_huge_pages(struct vm_area_struct *vma)
>  {
>  	VM_BUG_ON(!is_vm_hugetlb_page(vma));
>  	if (!(vma->vm_flags & VM_SHARED))
> -		return (unsigned long)vma->vm_private_data & ~HPAGE_RESV_MASK;
> +		return get_vma_private_data(vma) & ~HPAGE_RESV_MASK;
>  	return 0;
>  }

But I wonder if helpers which manipulate a vma's HPAGE_RESV_MASK
flag(s) rather than the whole vm_provate_data would have been better.

>  static void set_vma_resv_huge_pages(struct vm_area_struct *vma,
>  							unsigned long reserve)
>  {
> -	unsigned long flags;
>  	VM_BUG_ON(!is_vm_hugetlb_page(vma));
>  	VM_BUG_ON(vma->vm_flags & VM_SHARED);
>  
> -	flags = (unsigned long)vma->vm_private_data & HPAGE_RESV_MASK;
> -	vma->vm_private_data = (void *)(reserve | flags);
> +	set_vma_private_data(vma,
> +		(get_vma_private_data(vma) & HPAGE_RESV_MASK) | reserve);
>  }
>  
>  static void set_vma_resv_flags(struct vm_area_struct *vma, unsigned long flags)
>  {
> -	unsigned long reserveflags = (unsigned long)vma->vm_private_data;
>  	VM_BUG_ON(!is_vm_hugetlb_page(vma));
> -	vma->vm_private_data = (void *)(reserveflags | flags);
> +	VM_BUG_ON(vma->vm_flags & VM_SHARED);
> +
> +	set_vma_private_data(vma, get_vma_private_data(vma) | flags);
>  }
>  
>  static int is_vma_resv_set(struct vm_area_struct *vma, unsigned long flag)
>  {
>  	VM_BUG_ON(!is_vm_hugetlb_page(vma));
> -	return ((unsigned long)vma->vm_private_data & flag) != 0;
> +
> +	return (get_vma_private_data(vma) & flag) != 0;
>  }

Oh.  We already kinda have it.  Perhaps vma_resv_huge_pages() should
have called set_vma_resv_flags().  I guess the assertions would have
busted that.

Oh well, whatever.

