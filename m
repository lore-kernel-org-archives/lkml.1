Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbZIPAIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbZIPAIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 20:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZIPAIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 20:08:18 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52252 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbZIPAIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 20:08:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 1/4] mm: m(un)lock avoid ZERO_PAGE
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0909152130260.22199@sister.anvils>
References: <Pine.LNX.4.64.0909152127240.22199@sister.anvils> <Pine.LNX.4.64.0909152130260.22199@sister.anvils>
Message-Id: <20090916090348.DB89.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 16 Sep 2009 09:08:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm still reluctant to clutter __get_user_pages() with another flag,
> just to avoid touching ZERO_PAGE count in mlock(); though we can add
> that later if it shows up as an issue in practice.
> 
> But when mlocking, we can test page->mapping slightly earlier, to avoid
> the potentially bouncy rescheduling of lock_page on ZERO_PAGE - mlock
> didn't lock_page in olden ZERO_PAGE days, so we might have regressed.
> 
> And when munlocking, it turns out that FOLL_DUMP coincidentally does
> what's needed to avoid all updates to ZERO_PAGE, so use that here also.
> Plus add comment suggested by KAMEZAWA Hiroyuki.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
> 
>  mm/mlock.c |   49 ++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 36 insertions(+), 13 deletions(-)
> 
> --- mm0/mm/mlock.c	2009-09-14 16:34:37.000000000 +0100
> +++ mm1/mm/mlock.c	2009-09-15 17:32:03.000000000 +0100
> @@ -198,17 +198,26 @@ static long __mlock_vma_pages_range(stru
>  		for (i = 0; i < ret; i++) {
>  			struct page *page = pages[i];
>  
> -			lock_page(page);
> -			/*
> -			 * Because we lock page here and migration is blocked
> -			 * by the elevated reference, we need only check for
> -			 * file-cache page truncation.  This page->mapping
> -			 * check also neatly skips over the ZERO_PAGE(),
> -			 * though if that's common we'd prefer not to lock it.
> -			 */
> -			if (page->mapping)
> -				mlock_vma_page(page);
> -			unlock_page(page);
> +			if (page->mapping) {
> +				/*
> +				 * That preliminary check is mainly to avoid
> +				 * the pointless overhead of lock_page on the
> +				 * ZERO_PAGE: which might bounce very badly if
> +				 * there is contention.  However, we're still
> +				 * dirtying its cacheline with get/put_page:
> +				 * we'll add another __get_user_pages flag to
> +				 * avoid it if that case turns out to matter.
> +				 */
> +				lock_page(page);
> +				/*
> +				 * Because we lock page here and migration is
> +				 * blocked by the elevated reference, we need
> +				 * only check for file-cache page truncation.
> +				 */
> +				if (page->mapping)
> +					mlock_vma_page(page);
> +				unlock_page(page);
> +			}
>  			put_page(page);	/* ref from get_user_pages() */
>  		}

Yes, I have similar patch :-)
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




