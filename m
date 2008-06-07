Return-Path: <linux-kernel-owner+w=401wt.eu-S1759826AbYFGBHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826AbYFGBHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbYFGBFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:05:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755693AbYFGBFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:05:16 -0400
Date: Fri, 6 Jun 2008 18:04:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, mbligh@mbligh.org
Subject: Re: [PATCH -mm 09/25] fix pagecache reclaim referenced bit check
Message-Id: <20080606180451.31f01e70.akpm@linux-foundation.org>
In-Reply-To: <20080606202858.867179392@redhat.com>
References: <20080606202838.390050172@redhat.com>
	<20080606202858.867179392@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2008 16:28:47 -0400
Rik van Riel <riel@redhat.com> wrote:

> From: Rik van Riel <riel@redhat.com>
> 
> The -mm tree contains the patch
> vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
> which gives referenced pagecache pages another trip around
> the active list.  This seems to help keep frequently accessed
> pagecache pages in memory.
> 
> However, it means that pagecache pages that get moved to the
> inactive list do not have their referenced bit set, and a
> reference to the page will not get it moved back to the active
> list

Should that be "the next reference"?  Because two references _will_ cause
the page to be activated?

>.  This patch sets the referenced bit on pagecache pages
> that get deactivated, so the next access to the page will promote
> it back to the active list.
> 
> ---
>  mm/vmscan.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6.26-rc2-mm1/mm/vmscan.c
> ===================================================================
> --- linux-2.6.26-rc2-mm1.orig/mm/vmscan.c	2008-05-28 12:11:51.000000000 -0400
> +++ linux-2.6.26-rc2-mm1/mm/vmscan.c	2008-05-28 12:14:34.000000000 -0400
> @@ -1062,8 +1062,13 @@ static void shrink_active_list(unsigned 
>  				list_add(&page->lru, &l_inactive);
>  				pgmoved++;
>  			}
> -		} else
> +		} else {
>  			list_add(&page->lru, &l_inactive);
> +			if (file && !page_mapped(page))
> +				/* Bypass use-once, make the next access count.
> +				 * See mark_page_accessed. */
> +				SetPageReferenced(page);
> +		}
>  	}

Will this change also cause these pages to get a second trip around the
inactive list?  Or do we at the end of the patch series end up
reclaiming pagecache regardless of their PageReferenced()?  If so, it
seems that we're making the pagecache pages a _lot_ stickier with this
change and my one - an additional trip around the active list and an
additional one around the inactive list.

Changelog should spell all this out, I guess.
