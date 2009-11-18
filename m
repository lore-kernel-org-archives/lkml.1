Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbZKRQfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbZKRQfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757773AbZKRQe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:34:59 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:37437 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757713AbZKRQe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:34:58 -0500
X-Trace: 292194961/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.56.48/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.56.48
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjUBAKuwA0tPRTgw/2dsb2JhbAAI1k2CPIF/BA
X-IronPort-AV: E=Sophos;i="4.44,766,1249254000"; 
   d="scan'208";a="292194961"
Date: Wed, 18 Nov 2009 16:34:51 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH]  [for mmotm-1113] mm: Simplify try_to_unmap_one()
In-Reply-To: <20091117173759.3DF6.A69D9226@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0911181633120.29205@sister.anvils>
References: <20091117173759.3DF6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009, KOSAKI Motohiro wrote:

> SWAP_MLOCK mean "We marked the page as PG_MLOCK, please move it to
> unevictable-lru". So, following code is easy confusable.
> 
>         if (vma->vm_flags & VM_LOCKED) {
>                 ret = SWAP_MLOCK;
>                 goto out_unmap;
>         }
> 
> Plus, if the VMA doesn't have VM_LOCKED, We don't need to check
> the needed of calling mlock_vma_page().
> 
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

> ---
>  mm/rmap.c |   26 +++++++++++++-------------
>  1 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 82e31fb..70dec01 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -779,10 +779,9 @@ static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
>  	 * skipped over this mm) then we should reactivate it.
>  	 */
>  	if (!(flags & TTU_IGNORE_MLOCK)) {
> -		if (vma->vm_flags & VM_LOCKED) {
> -			ret = SWAP_MLOCK;
> -			goto out_unmap;
> -		}
> +		if (vma->vm_flags & VM_LOCKED)
> +			goto out_mlock;
> +
>  		if (TTU_ACTION(flags) == TTU_MUNLOCK)
>  			goto out_unmap;
>  	}
> @@ -855,18 +854,19 @@ static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
>  
>  out_unmap:
>  	pte_unmap_unlock(pte, ptl);
> +out:
> +	return ret;
>  
> -	if (ret == SWAP_MLOCK) {
> -		ret = SWAP_AGAIN;
> -		if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
> -			if (vma->vm_flags & VM_LOCKED) {
> -				mlock_vma_page(page);
> -				ret = SWAP_MLOCK;
> -			}
> -			up_read(&vma->vm_mm->mmap_sem);
> +out_mlock:
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
