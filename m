Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbYHGMuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbYHGMuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbYHGMtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:49:42 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:47483 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbYHGMtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:49:41 -0400
Date: Thu, 7 Aug 2008 13:14:05 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 9/7] mm: fix mm_take_all_locks() locking order
In-Reply-To: <1218108349.8625.25.camel@twins>
Message-ID: <Pine.LNX.4.64.0808071257200.4594@blonde.site>
References: <20080804130317.994042639@chello.nl> <1218108349.8625.25.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008, Peter Zijlstra wrote:
> 
> Which the locking hierarchy in mm/rmap.c confirms as 'valid'.
> 
> Although I don't think there are any users of these two locks that don't
> hold the mmap_sem, therefore the nesting is strictly ok, but since we
> already have an established order, we might as well respect it.

Yes, I agree.

> Fix this by first taking all the mapping->i_mmap_lock instances and then
> take all anon_vma->lock instances.

Okay.  I'd have preferred taking anon_vma lock after i_mmap_lock
each time around the loop, but imagine that's just as problematic
for lockdep as the original.

> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Hugh Dickins <hugh@veritas.com>

> ---
>  mm/mmap.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/mm/mmap.c
> ===================================================================
> --- linux-2.6.orig/mm/mmap.c
> +++ linux-2.6/mm/mmap.c
> @@ -2358,11 +2358,17 @@ int mm_take_all_locks(struct mm_struct *
>  	for (vma = mm->mmap; vma; vma = vma->vm_next) {
>  		if (signal_pending(current))
>  			goto out_unlock;
> -		if (vma->anon_vma)
> -			vm_lock_anon_vma(mm, vma->anon_vma);
>  		if (vma->vm_file && vma->vm_file->f_mapping)
>  			vm_lock_mapping(mm, vma->vm_file->f_mapping);
>  	}
> +
> +	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> +		if (signal_pending(current))
> +			goto out_unlock;
> +		if (vma->anon_vma)
> +			vm_lock_anon_vma(mm, vma->anon_vma);
> +	}
> +
>  	ret = 0;
>  
>  out_unlock:
