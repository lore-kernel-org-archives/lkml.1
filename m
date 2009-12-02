Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZLBUNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZLBUNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbZLBUNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:13:40 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:36046 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754611AbZLBUNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:13:40 -0500
X-Trace: 300521349/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.111.197/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.111.197
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkoBAGFZFktQKW/F/2dsb2JhbAAI2AOEMQQ
X-IronPort-AV: E=Sophos;i="4.47,330,1257120000"; 
   d="scan'208";a="300521349"
Date: Wed, 2 Dec 2009 20:13:39 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb: Acquire the i_mmap_lock before walking the
 prio_tree to unmap a page
In-Reply-To: <20091202141930.GF1457@csn.ul.ie>
Message-ID: <Pine.LNX.4.64.0912022003100.8113@sister.anvils>
References: <20091202141930.GF1457@csn.ul.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Dec 2009, Mel Gorman wrote:

> When the owner of a mapping fails COW because a child process is holding a
> reference and no pages are available, the children VMAs are walked and the
> page is unmapped. The i_mmap_lock is taken for the unmapping of the page but
> not the walking of the prio_tree. In theory, that tree could be changing
> while the lock is released although in practice it is protected by the
> hugetlb_instantiation_mutex. This patch takes the i_mmap_lock properly for
> the duration of the prio_tree walk in case the hugetlb_instantiation_mutex
> ever goes away.
> 
> [hugh.dickins@tiscali.co.uk: Spotted the problem in the first place]
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

The patch looks good - thanks for taking care of that, Mel.

But the comment seems wrong to me: hugetlb_instantiation_mutex
guards against concurrent hugetlb_fault()s; but the structure of
the prio_tree shifts as vmas based on that inode are inserted into
(mmap'ed) and removed from (munmap'ed) that tree (always while
holding i_mmap_lock).  I don't see hugetlb_instantiation_mutex
giving us any protection against this at present.

Hugh

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
