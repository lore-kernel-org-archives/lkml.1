Return-Path: <linux-kernel-owner+w=401wt.eu-S1752066AbZL1KZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbZL1KZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbZL1KZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:25:41 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:43864 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZL1KZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:25:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NQJvjsQZtpBKDuWm6QfijKCbIaIfIUlQhxIxRv5GkDGjML3zzYCI0J2GYgy/+wDcrt
         pV7hGNGyLpXag9Bdqa/if44KeYO7a9btwkWayiBP8qhI/Z924ZJeyEY124eZnxehCcDB
         7KXnfZO838Zdrh03egRNNkwuu0avjKqwriZ24=
Message-ID: <4B38879E.3060205@gmail.com>
Date: Mon, 28 Dec 2009 19:25:34 +0900
From: Minchan Kim <minchan.kim@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 3/3 -mmotm-2009-12-10-17-19] Fix wrong rss counting of
 smap
References: <ceeec51bdc2be64416e05ca16da52a126b598e17.1258773030.git.minchan.kim@gmail.com> <ae2928fe7bb3d94a7ca18d3b3274fdfeb009803a.1258773030.git.minchan.kim@gmail.com> <ff0a209159ef985681ae071d770edd9b9cd0ecf0.1258773030.git.minchan.kim@gmail.com>
In-Reply-To: <ff0a209159ef985681ae071d770edd9b9cd0ecf0.1258773030.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I missed Hugn and Matt. 

Minchan Kim wrote:
> After return zero_page, vm_normal_page can return
> NULL if the page is zero page.
> 
> In such case, RSS and PSS can be mismatched.
> This patch fixes it.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  fs/proc/task_mmu.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 47c03f4..1a47be9 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -361,12 +361,11 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  		if (!pte_present(ptent))
>  			continue;
>  
> -		mss->resident += PAGE_SIZE;
> -
>  		page = vm_normal_page(vma, addr, ptent);
> -		if (!page)
> +		if (!page && !is_zero_pfn(pte_pfn(ptent)))
>  			continue;
>  
> +		mss->resident += PAGE_SIZE;
>  		/* Accumulate the size in pages that have been accessed. */
>  		if (pte_young(ptent) || PageReferenced(page))
>  			mss->referenced += PAGE_SIZE;
