Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbYF3CWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbYF3CWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 22:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYF3CWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 22:22:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35113 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbYF3CWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 22:22:45 -0400
Date: Mon, 30 Jun 2008 11:28:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: shmem_getpage release page sooner
Message-Id: <20080630112831.66b939ba.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0806290113350.20280@blonde.site>
References: <Pine.LNX.4.64.0806290108110.20280@blonde.site>
	<Pine.LNX.4.64.0806290113350.20280@blonde.site>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008 01:14:30 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> No big deal, but since mem_cgroup_shrink_usage doesn't require a page to
> operate upon, page_cache_release the swappage before calling it, so it's
> not pinned across the reclaim.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

this one is better, thanks.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
> Should follow mmotm's memcg-helper-function-for-relcaim-from-shmem.patch
> 
>  mm/shmem.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> --- mmotm/mm/shmem.c	2008-06-27 13:39:20.000000000 +0100
> +++ linux/mm/shmem.c	2008-06-27 17:25:41.000000000 +0100
> @@ -1315,16 +1315,14 @@ repeat:
>  			shmem_swp_unmap(entry);
>  			spin_unlock(&info->lock);
>  			unlock_page(swappage);
> +			page_cache_release(swappage);
>  			if (error == -ENOMEM) {
>  				/* allow reclaim from this memory cgroup */
>  				error = mem_cgroup_shrink_usage(current->mm,
> -					gfp & ~__GFP_HIGHMEM);
> -				if (error) {
> -					page_cache_release(swappage);
> +								gfp);
> +				if (error)
>  					goto failed;
> -				}
>  			}
> -			page_cache_release(swappage);
>  			goto repeat;
>  		}
>  	} else if (sgp == SGP_READ && !filepage) {
> 

