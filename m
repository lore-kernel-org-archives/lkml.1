Return-Path: <linux-kernel-owner+w=401wt.eu-S1751469AbZL1DAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbZL1DAs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 22:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbZL1DAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 22:00:48 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55064 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZL1DAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 22:00:47 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Dec 2009 11:57:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mmotm-2009-12-10-17-19] Prevent churning of zero page
 in LRU list.
Message-Id: <20091228115727.a1730cdf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091228115315.76b1ecd0.minchan.kim@barrios-desktop>
References: <20091228115315.76b1ecd0.minchan.kim@barrios-desktop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009 11:53:15 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> 
> VM doesn't add zero page to LRU list. 
> It means zero page's churning in LRU list is pointless. 
> 
> As a matter of fact, zero page can't be promoted by mark_page_accessed
> since it doesn't have PG_lru. 
> 
> This patch prevent unecessary mark_page_accessed call of zero page 
> alghouth caller want FOLL_TOUCH. 
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  mm/memory.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 09e4b1b..485f727 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1152,6 +1152,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
>  	spinlock_t *ptl;
>  	struct page *page;
>  	struct mm_struct *mm = vma->vm_mm;
> +	int zero_pfn = 0;
>  
>  	page = follow_huge_addr(mm, address, flags & FOLL_WRITE);
>  	if (!IS_ERR(page)) {
> @@ -1196,15 +1197,15 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
>  
>  	page = vm_normal_page(vma, address, pte);
>  	if (unlikely(!page)) {
> -		if ((flags & FOLL_DUMP) ||
> -		    !is_zero_pfn(pte_pfn(pte)))
> +		zero_pfn = is_zero_pfn(pte_pfn(pte));
> +		if ((flags & FOLL_DUMP) || !zero_pfn )
>  			goto bad_page;
>  		page = pte_page(pte);
>  	}
>  
>  	if (flags & FOLL_GET)
>  		get_page(page);
> -	if (flags & FOLL_TOUCH) {
> +	if (flags & FOLL_TOUCH && !zero_pfn) {
>  		if ((flags & FOLL_WRITE) &&
>  		    !pte_dirty(pte) && !PageDirty(page))
>  			set_page_dirty(page);
> -- 
> 1.5.6.3
> 
> 
> -- 
> Kind regards,
> Minchan Kim
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

