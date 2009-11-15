Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbZKOWhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbZKOWhj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 17:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbZKOWhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 17:37:39 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:7453 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357AbZKOWhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 17:37:38 -0500
X-Trace: 290927737/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.56.48/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.56.48
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoAAFoRAEtPRTgw/2dsb2JhbAAI0nmCOYIDBA
X-IronPort-AV: E=Sophos;i="4.44,747,1249254000"; 
   d="scan'208";a="290927737"
Date: Sun, 15 Nov 2009 22:37:33 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/6] mm: mlocking in try_to_unmap_one
In-Reply-To: <20091113143930.33BF.A69D9226@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0911152217030.29917@sister.anvils>
References: <20091111102400.FD36.A69D9226@jp.fujitsu.com>
 <Pine.LNX.4.64.0911111048170.12126@sister.anvils> <20091113143930.33BF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009, KOSAKI Motohiro wrote:
> if so, following additional patch makes more consistent?
> ----------------------------------
> From 3fd3bc58dc6505af73ecf92c981609ecf8b6ac40 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Fri, 13 Nov 2009 16:52:03 +0900
> Subject: [PATCH] [RFC] mm: non linear mapping page don't mark as PG_mlocked
> 
> Now, try_to_unmap_file() lost the capability to treat VM_NONLINEAR.

Now?
Genuine try_to_unmap_file() deals with VM_NONLINEAR (including VM_LOCKED)
much as it always did, I think.  But try_to_munlock() on a VM_NONLINEAR
has not being doing anything useful, I assume ever since it was added,
but haven't checked the history.

But so what?  try_to_munlock() has those down_read_trylock()s which make
it never quite reliable.  In the VM_NONLINEAR case it has simply been
giving up rather more easily.

> Then, mlock() shouldn't mark the page of non linear mapping as
> PG_mlocked. Otherwise the page continue to drinker walk between
> evictable and unevictable lru.

I do like your phrase "drinker walk".  But is it really worse than
the lazy discovery of the page being locked, which is how I thought
this stuff was originally supposed to work anyway.  I presume cases
were found in which the counts got so far out that it was a problem?

I liked the lazy discovery much better than trying to keep count;
can we just accept that VM_NONLINEAR may leave the counts further
away from exactitude?

I don't think this patch makes things more consistent, really.
It does make sys_remap_file_pages on an mlocked area inconsistent
with mlock on a sys_remap_file_pages area, doesn't it?

Hugh

> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/mlock.c |   37 +++++++++++++++++++++++--------------
>  1 files changed, 23 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 48691fb..4187f9c 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -266,25 +266,34 @@ long mlock_vma_pages_range(struct vm_area_struct *vma,
>  	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
>  		goto no_mlock;
>  
> -	if (!((vma->vm_flags & (VM_DONTEXPAND | VM_RESERVED)) ||
> +	if ((vma->vm_flags & (VM_DONTEXPAND | VM_RESERVED)) ||
>  			is_vm_hugetlb_page(vma) ||
> -			vma == get_gate_vma(current))) {
> +			vma == get_gate_vma(current)) {
> +
> +		/*
> +		 * User mapped kernel pages or huge pages:
> +		 * make these pages present to populate the ptes, but
> +		 * fall thru' to reset VM_LOCKED--no need to unlock, and
> +		 * return nr_pages so these don't get counted against task's
> +		 * locked limit.  huge pages are already counted against
> +		 * locked vm limit.
> +		 */
> +		make_pages_present(start, end);
> +		goto no_mlock;
> +	}
>  
> +	if (vma->vm_flags & VM_NONLINEAR)
> +		/*
> +		 * try_to_munmap() doesn't treat VM_NONLINEAR. let's make
> +		 * consist.
> +		 */
> +		make_pages_present(start, end);
> +	else
>  		__mlock_vma_pages_range(vma, start, end);
>  
> -		/* Hide errors from mmap() and other callers */
> -		return 0;
> -	}
> +	/* Hide errors from mmap() and other callers */
> +	return 0;
>  
> -	/*
> -	 * User mapped kernel pages or huge pages:
> -	 * make these pages present to populate the ptes, but
> -	 * fall thru' to reset VM_LOCKED--no need to unlock, and
> -	 * return nr_pages so these don't get counted against task's
> -	 * locked limit.  huge pages are already counted against
> -	 * locked vm limit.
> -	 */
> -	make_pages_present(start, end);
>  
>  no_mlock:
>  	vma->vm_flags &= ~VM_LOCKED;	/* and don't come back! */
> -- 
> 1.6.2.5
