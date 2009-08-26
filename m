Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbZHZKRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbZHZKRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbZHZKRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:17:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38260 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619AbZHZKRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:17:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH mmotm] mm: introduce page_lru_base_type fix
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0908261050080.18633@sister.anvils>
References: <Pine.LNX.4.64.0908261050080.18633@sister.anvils>
Message-Id: <20090826190233.3977.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 26 Aug 2009 19:17:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My usual tmpfs swapping loads on recent mmotms have oddly
> aroused the OOM killer after an hour or two.  Bisection led to
> mm-return-boolean-from-page_is_file_cache.patch, but really it's
> the prior mm-introduce-page_lru_base_type.patch that's at fault.
> 
> It converted page_lru() to use page_lru_base_type(), but forgot
> to convert del_page_from_lru() - which then decremented the wrong
> stats once page_is_file_cache() was changed to a boolean.
> 
> Fix that, move page_lru_base_type() before del_page_from_lru(),
> and mark it "inline" like the other mm_inline.h functions.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

I'm sorry vmscan related patch bother you.
this is definitely right fix, thak you.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> ---
> 
>  include/linux/mm_inline.h |   34 +++++++++++++++++-----------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
> 
> --- mmotm/include/linux/mm_inline.h	2009-08-21 12:12:42.000000000 +0100
> +++ linux/include/linux/mm_inline.h	2009-08-26 00:39:38.000000000 +0100
> @@ -35,42 +35,42 @@ del_page_from_lru_list(struct zone *zone
>  	mem_cgroup_del_lru_list(page, l);
>  }
>  
> +/**
> + * page_lru_base_type - which LRU list type should a page be on?
> + * @page: the page to test
> + *
> + * Used for LRU list index arithmetic.
> + *
> + * Returns the base LRU type - file or anon - @page should be on.
> + */
> +static inline enum lru_list page_lru_base_type(struct page *page)
> +{
> +	if (page_is_file_cache(page))
> +		return LRU_INACTIVE_FILE;
> +	return LRU_INACTIVE_ANON;
> +}
> +
>  static inline void
>  del_page_from_lru(struct zone *zone, struct page *page)
>  {
> -	enum lru_list l = LRU_BASE;
> +	enum lru_list l;
>  
>  	list_del(&page->lru);
>  	if (PageUnevictable(page)) {
>  		__ClearPageUnevictable(page);
>  		l = LRU_UNEVICTABLE;
>  	} else {
> +		l = page_lru_base_type(page);
>  		if (PageActive(page)) {
>  			__ClearPageActive(page);
>  			l += LRU_ACTIVE;
>  		}
> -		l += page_is_file_cache(page);
>  	}
>  	__dec_zone_state(zone, NR_LRU_BASE + l);
>  	mem_cgroup_del_lru_list(page, l);
>  }
>  
>  /**
> - * page_lru_base_type - which LRU list type should a page be on?
> - * @page: the page to test
> - *
> - * Used for LRU list index arithmetic.
> - *
> - * Returns the base LRU type - file or anon - @page should be on.
> - */
> -static enum lru_list page_lru_base_type(struct page *page)
> -{
> -	if (page_is_file_cache(page))
> -		return LRU_INACTIVE_FILE;
> -	return LRU_INACTIVE_ANON;
> -}
> -
> -/**
>   * page_lru - which LRU list should a page be on?
>   * @page: the page to test
>   *



