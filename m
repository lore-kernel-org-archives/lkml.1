Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbZKOWRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbZKOWRA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 17:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZKOWQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 17:16:59 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:28049 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752085AbZKOWQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 17:16:58 -0500
X-Trace: 290433774/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.56.48/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.56.48
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoAAOcMAEtPRTgw/2dsb2JhbAAI0nmCPIIABA
X-IronPort-AV: E=Sophos;i="4.44,747,1249254000"; 
   d="scan'208";a="290433774"
Date: Sun, 15 Nov 2009 22:16:54 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/6] mm: mlocking in try_to_unmap_one
In-Reply-To: <20091113151554.33C2.A69D9226@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0911152209350.29917@sister.anvils>
References: <Pine.LNX.4.64.0911102142570.2272@sister.anvils>
 <Pine.LNX.4.64.0911102151500.2816@sister.anvils> <20091113151554.33C2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009, KOSAKI Motohiro wrote:
> 
> Very small nit. How about this?

Yes, that takes it a stage further, I prefer that, thanks: but better
redo against mmotm, I removed the "MLOCK_PAGES && " in a later patch.

Hugh

> 
> 
> ------------------------------------------------------------
> From 9d4b507572eccf88dcaa02e650df59874216528c Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Fri, 13 Nov 2009 15:00:04 +0900
> Subject: [PATCH] Simplify try_to_unmap_one()
> 
> SWAP_MLOCK mean "We marked the page as PG_MLOCK, please move it to
> unevictable-lru". So, following code is easy confusable.
> 
> 	if (vma->vm_flags & VM_LOCKED) {
> 		ret = SWAP_MLOCK;
> 		goto out_unmap;
> 	}
> 
> Plus, if the VMA doesn't have VM_LOCKED, We don't need to check
> the needed of calling mlock_vma_page().
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/rmap.c |   25 ++++++++++++-------------
>  1 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 4440a86..81a168c 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -784,10 +784,8 @@ static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
>  	 * skipped over this mm) then we should reactivate it.
>  	 */
>  	if (!(flags & TTU_IGNORE_MLOCK)) {
> -		if (vma->vm_flags & VM_LOCKED) {
> -			ret = SWAP_MLOCK;
> -			goto out_unmap;
> -		}
> +		if (vma->vm_flags & VM_LOCKED)
> +			goto out_unlock;
>  		if (MLOCK_PAGES && TTU_ACTION(flags) == TTU_MUNLOCK)
>  			goto out_unmap;
>  	}
> @@ -856,18 +854,19 @@ static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
>  
>  out_unmap:
>  	pte_unmap_unlock(pte, ptl);
> +out:
> +	return ret;
>  
> -	if (MLOCK_PAGES && ret == SWAP_MLOCK) {
> -		ret = SWAP_AGAIN;
> -		if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
> -			if (vma->vm_flags & VM_LOCKED) {
> -				mlock_vma_page(page);
> -				ret = SWAP_MLOCK;
> -			}
> -			up_read(&vma->vm_mm->mmap_sem);
> +out_unlock:
> +	pte_unmap_unlock(pte, ptl);
> +
> +	if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
> +		if (vma->vm_flags & VM_LOCKED) {
> +			mlock_vma_page(page);
> +			ret = SWAP_MLOCK;
>  		}
> +		up_read(&vma->vm_mm->mmap_sem);
>  	}
> -out:
>  	return ret;
>  }
>  
> -- 
> 1.6.2.5
