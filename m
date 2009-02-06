Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbZBFDjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbZBFDjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 22:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZBFDj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 22:39:27 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57598 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZBFDj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 22:39:26 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 3/3][RFC] swsusp: shrink file cache first
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20090206031324.004715023@cmpxchg.org>
References: <20090206031125.693559239@cmpxchg.org> <20090206031324.004715023@cmpxchg.org>
Message-Id: <20090206122129.79CC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri,  6 Feb 2009 12:39:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have some comment.

> File cache pages are saved to disk either through normal writeback by
> reclaim or by including them in the suspend image written to a
> swapfile.
> 
> Writing them either way should take the same amount of time but doing
> normal writeback and unmap changes the fault behaviour on resume from
> prefault to on-demand paging, smoothening out resume and giving
> previously cached pages the chance to stay out of memory completely if
> they are not used anymore.
> 
> Another reason for preferring file page eviction is that the locality
> principle is visible in fault patterns and swap might perform really
> bad with subsequent faulting of contiguously mapped pages.
> 
> Since anon and file pages now live on different lists, selectively
> scanning one type only is straight-forward.

I don't understand your point.
Which do you want to improve suspend performance or resume performance?

if we think suspend performance, we should consider swap device and file-backed device
are different block device.
the interleave of file-backed page out and swap out can improve total write out performce.

if we think resume performance, we shold how think the on-disk contenious of the swap consist
process's virtual address contenious.
it cause to reduce unnecessary seek.
but your patch doesn't this.

Could you explain this patch benefit?
and, I think you should mesure performence result.


<snip>


> @@ -2134,17 +2144,17 @@ unsigned long shrink_all_memory(unsigned
>  
>  	/*
>  	 * We try to shrink LRUs in 5 passes:
> -	 * 0 = Reclaim from inactive_list only
> -	 * 1 = Reclaim from active list but don't reclaim mapped
> -	 * 2 = 2nd pass of type 1
> -	 * 3 = Reclaim mapped (normal reclaim)
> -	 * 4 = 2nd pass of type 3
> +	 * 0 = Reclaim unmapped inactive file pages
> +	 * 1 = Reclaim unmapped file pages

I think your patch reclaim mapped file at priority 0 and 1 too.


> +	 * 2 = Reclaim file and inactive anon pages
> +	 * 3 = Reclaim file and anon pages
> +	 * 4 = Second pass 3
>  	 */
>  	for (pass = 0; pass < 5; pass++) {
>  		int prio;
>  
> -		/* Force reclaiming mapped pages in the passes #3 and #4 */
> -		if (pass > 2)
> +		/* Reclaim mapped pages in higher passes */
> +		if (pass > 1)
>  			sc.may_swap = 1;

Why need this line?
If you reclaim only file backed lru, may_swap isn't effective.
So, Can't we just remove this line and always set may_swap=1 ?


