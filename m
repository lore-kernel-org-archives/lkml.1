Return-Path: <linux-kernel-owner+w=401wt.eu-S1751547AbZL1EvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbZL1EvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 23:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbZL1EvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 23:51:07 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58864 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbZL1EvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 23:51:06 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Dec 2009 13:47:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Matt Mackall <mpm@selenic.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH -mmotm-2009-12-10-17-19] Fix wrong rss count of smaps
Message-Id: <20091228134752.44d13c34.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091228134619.92ba28f6.minchan.kim@barrios-desktop>
References: <20091228134619.92ba28f6.minchan.kim@barrios-desktop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009 13:46:19 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> 
> I am not sure we have to account zero page with file_rss. 
> Hugh and Kame's new zero page doesn't do it. 
> As side effect of this, we can prevent innocent process which have a lot
> of zero page when OOM happens. 
> (But I am not sure there is a process like this :)
> So I think not file_rss counting is not bad. 
> 
> RSS counting zero page with file_rss helps any program using smaps?
> If we have to keep the old behavior, I have to remake this patch. 
> 
> == CUT_HERE ==
> 
> Long time ago, We regards zero page as file_rss and
> vm_normal_page doesn't return NULL.
> 
> But now, we reinstated ZERO_PAGE and vm_normal_page's implementation
> can return NULL in case of zero page. Also we don't count it with
> file_rss any more.
> 
> Then, RSS and PSS can't be matched.
> For consistency, Let's ignore zero page in smaps_pte_range.
> 
> CC: Matt Mackall <mpm@selenic.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

BTW, how about counting ZERO page in smaps ? Ignoring them completely sounds
not very good.

Thanks,
-Kame

> ---
>  fs/proc/task_mmu.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 47c03f4..f277c4a 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -361,12 +361,11 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  		if (!pte_present(ptent))
>  			continue;
>  
> -		mss->resident += PAGE_SIZE;
> -
>  		page = vm_normal_page(vma, addr, ptent);
>  		if (!page)
>  			continue;
>  
> +		mss->resident += PAGE_SIZE;
>  		/* Accumulate the size in pages that have been accessed. */
>  		if (pte_young(ptent) || PageReferenced(page))
>  			mss->referenced += PAGE_SIZE;
> -- 
> 1.5.6.3
> 
> 
> 
> -- 
> Kind regards,
> Minchan Kim
> 

