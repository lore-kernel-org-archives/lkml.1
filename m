Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbZJFBL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbZJFBL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 21:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZJFBL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 21:11:58 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51764 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbZJFBL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 21:11:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [rfc patch 3/3] mm: munlock COW pages on truncation unmap
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Mel Gorman <mel@csn.ul.ie>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091005193200.GA13040@cmpxchg.org>
References: <2f11576a0910030656l73c9811w18e0f224fb3d98af@mail.gmail.com> <20091005193200.GA13040@cmpxchg.org>
Message-Id: <20091006100724.5F97.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Oct 2009 10:11:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---
> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: mm: order evictable rescue in LRU putback
> 
> Isolators putting a page back to the LRU do not hold the page lock,
> and if the page is mlocked, another thread might munlock it
> concurrently.
> 
> Expecting this, the putback code re-checks the evictability of a page
> when it just moved it to the unevictable list in order to correct its
> decision.
> 
> The problem, however, is that ordering is not garuanteed between
> setting PG_lru when moving the page to the list and checking
> PG_mlocked afterwards:
> 
> 	#0 putback			#1 munlock
> 
> 	spin_lock()
> 					if (TestClearPageMlocked())
> 					  if (PageLRU())
> 					    move to evictable list
> 	SetPageLRU()
> 	spin_unlock()
> 	if (!PageMlocked())
> 	  move to evictable list
> 
> The PageMlocked() reading may get reordered before SetPageLRU() in #0,
> resulting in #0 not moving the still mlocked page, and in #1 failing
> to isolate and move the page as well.  The evictable page is now
> stranded on the unevictable list.
> 
> TestClearPageMlocked() in #1 already provides full memory barrier
> semantics.
> 
> This patch adds an explicit full barrier to force ordering between
> SetPageLRU() and PageMlocked() in #0 so that either one of the
> competitors rescues the page.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  mm/vmscan.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -544,6 +544,16 @@ redo:
>  		 */
>  		lru = LRU_UNEVICTABLE;
>  		add_page_to_unevictable_list(page);
> +		/*
> +		 * When racing with an mlock clearing (page is
> +		 * unlocked), make sure that if the other thread does
> +		 * not observe our setting of PG_lru and fails
> +		 * isolation, we see PG_mlocked cleared below and move
> +		 * the page back to the evictable list.
> +		 *
> +		 * The other side is TestClearPageMlocked().
> +		 */
> +		smp_mb();
>  	}

IA64 is most relax cpu reorder architecture. I'm usually test on it
and my test found no problem.
Then, I don't think this issue occur in the real world. but I think
this patch is right.

Hannes, you are great.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>





