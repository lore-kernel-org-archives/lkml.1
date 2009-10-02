Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbZJBQeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbZJBQeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756673AbZJBQeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:34:12 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:54442 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756665AbZJBQeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:34:09 -0400
X-Trace: 268840732/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.120.155/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.120.155
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au0AABvIxUpPRXib/2dsb2JhbAAI2FWELAQ
X-IronPort-AV: E=Sophos;i="4.44,495,1249254000"; 
   d="scan'208";a="268840732"
Date: Fri, 2 Oct 2009 17:34:03 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Mel Gorman <mel@csn.ul.ie>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [121/136] mm: fix anonymous dirtying
In-Reply-To: <20091002012426.168639081@mini.kroah.org>
Message-ID: <Pine.LNX.4.64.0910021731230.20933@sister.anvils>
References: <20091002011548.335611824@mini.kroah.org> <20091002012426.168639081@mini.kroah.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009, Greg KH wrote:
> 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> commit 1ac0cb5d0e22d5e483f56b2bc12172dec1cf7536 upstream.
> 
> do_anonymous_page() has been wrong to dirty the pte regardless.
> If it's not going to mark the pte writable, then it won't help
> to mark it dirty here, and clogs up memory with pages which will
> need swap instead of being thrown away.  Especially wrong if no
> overcommit is chosen, and this vma is not yet VM_ACCOUNTed -
> we could exceed the limit and OOM despite no overcommit.

Thanks a lot for including this little fix in 2.6.31.2.
It is equally relevant to both 2.6.27.36 and 2.6.30.9,
so if not too late, please consider adding it into those too.

Thanks,
Hugh

> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Acked-by: Rik van Riel <riel@redhat.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  mm/memory.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2638,7 +2638,8 @@ static int do_anonymous_page(struct mm_s
>  		goto oom_free_page;
>  
>  	entry = mk_pte(page, vma->vm_page_prot);
> -	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> +	if (vma->vm_flags & VM_WRITE)
> +		entry = pte_mkwrite(pte_mkdirty(entry));
>  
>  	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
>  	if (!pte_none(*page_table))
