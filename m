Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZLEMla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZLEMla (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 07:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZLEMl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 07:41:29 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:39166 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754484AbZLEMl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 07:41:28 -0500
X-Trace: 297894485/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.111.197/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.111.197
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoAAOfjGUtQKW/F/2dsb2JhbAAI1Q+EMwQ
X-IronPort-AV: E=Sophos;i="4.47,346,1257120000"; 
   d="scan'208";a="297894485"
Date: Sat, 5 Dec 2009 12:41:26 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb: Acquire the i_mmap_lock before walking the
 prio_tree to unmap a page V2
In-Reply-To: <20091202222049.GC26702@csn.ul.ie>
Message-ID: <Pine.LNX.4.64.0912051237060.31181@sister.anvils>
References: <20091202222049.GC26702@csn.ul.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Dec 2009, Mel Gorman wrote:

> Changelog since V1
> o Delete stupid comment from the description
> 
> When the owner of a mapping fails  COW because a child process is holding
> a reference, the children VMAs are walked and the page is unmapped. The
> i_mmap_lock is taken for the unmapping of the page but not the walking of
> the prio_tree. In theory, that tree could be changing if the lock is not
> held. This patch takes the i_mmap_lock properly for the duration of the
> prio_tree walk.
> 
> [hugh.dickins@tiscali.co.uk: Spotted the problem in the first place]
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

(and Andrew has already put this version into mmotm, thanks)

> ---
>  mm/hugetlb.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index a952cb8..5adc284 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1906,6 +1906,12 @@ static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
>  		+ (vma->vm_pgoff >> PAGE_SHIFT);
>  	mapping = (struct address_space *)page_private(page);
>  
> +	/*
> +	 * Take the mapping lock for the duration of the table walk. As
> +	 * this mapping should be shared between all the VMAs,
> +	 * __unmap_hugepage_range() is called as the lock is already held
> +	 */
> +	spin_lock(&mapping->i_mmap_lock);
>  	vma_prio_tree_foreach(iter_vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
>  		/* Do not unmap the current VMA */
>  		if (iter_vma == vma)
> @@ -1919,10 +1925,11 @@ static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
>  		 * from the time of fork. This would look like data corruption
>  		 */
>  		if (!is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
> -			unmap_hugepage_range(iter_vma,
> +			__unmap_hugepage_range(iter_vma,
>  				address, address + huge_page_size(h),
>  				page);
>  	}
> +	spin_unlock(&mapping->i_mmap_lock);
>  
>  	return 1;
>  }
