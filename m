Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbZGPHiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbZGPHiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 03:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZGPHiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 03:38:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58302 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbZGPHiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 03:38:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: Warn once when a page is freed with PG_mlocked set V2
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <20090715220445.GA1823@cmpxchg.org>
References: <alpine.DEB.1.10.0907151027410.23643@gentwo.org> <20090715220445.GA1823@cmpxchg.org>
Message-Id: <20090716163537.9D3D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Jul 2009 16:37:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From eee677ddea61b1331a3bd8e402a0d02437fe872a Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Wed, 15 Jul 2009 23:40:28 +0200
> Subject: [patch] mm: non-atomic test-clear of PG_mlocked on free
> 
> By the time PG_mlocked is cleared in the page freeing path, nobody
> else is looking at our page->flags anymore.
> 
> It is thus safe to make the test-and-clear non-atomic and thereby
> removing an unnecessary and expensive operation from a hotpath.

I like this patch. but can you please separate two following patches?
  - introduce __TESTCLEARFLAG()
  - non-atomic test-clear of PG_mlocked on free



> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/page-flags.h |   12 +++++++++---
>  mm/page_alloc.c            |    4 ++--
>  2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index e2e5ce5..10e6011 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -158,6 +158,9 @@ static inline int TestSetPage##uname(struct page *page)			\
>  static inline int TestClearPage##uname(struct page *page)		\
>  		{ return test_and_clear_bit(PG_##lname, &page->flags); }
>  
> +#define __TESTCLEARFLAG(uname, lname)					\
> +static inline int __TestClearPage##uname(struct page *page)		\
> +		{ return __test_and_clear_bit(PG_##lname, &page->flags); }
>  
>  #define PAGEFLAG(uname, lname) TESTPAGEFLAG(uname, lname)		\
>  	SETPAGEFLAG(uname, lname) CLEARPAGEFLAG(uname, lname)
> @@ -184,6 +187,9 @@ static inline void __ClearPage##uname(struct page *page) {  }
>  #define TESTCLEARFLAG_FALSE(uname)					\
>  static inline int TestClearPage##uname(struct page *page) { return 0; }
>  
> +#define __TESTCLEARFLAG_FALSE(uname)					\
> +static inline int __TestClearPage##uname(struct page *page) { return 0; }
> +
>  struct page;	/* forward declaration */
>  
>  TESTPAGEFLAG(Locked, locked) TESTSETFLAG(Locked, locked)
> @@ -250,11 +256,11 @@ PAGEFLAG(Unevictable, unevictable) __CLEARPAGEFLAG(Unevictable, unevictable)
>  #ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
>  #define MLOCK_PAGES 1
>  PAGEFLAG(Mlocked, mlocked) __CLEARPAGEFLAG(Mlocked, mlocked)
> -	TESTSCFLAG(Mlocked, mlocked)
> +	TESTSCFLAG(Mlocked, mlocked) __TESTCLEARFLAG(Mlocked, mlocked)
>  #else
>  #define MLOCK_PAGES 0
> -PAGEFLAG_FALSE(Mlocked)
> -	SETPAGEFLAG_NOOP(Mlocked) TESTCLEARFLAG_FALSE(Mlocked)
> +PAGEFLAG_FALSE(Mlocked) SETPAGEFLAG_NOOP(Mlocked)
> +	TESTCLEARFLAG_FALSE(Mlocked) __TESTCLEARFLAG_FALSE(Mlocked)
>  #endif
>  
>  #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index caa9268..b0c8758 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -557,7 +557,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
>  	unsigned long flags;
>  	int i;
>  	int bad = 0;
> -	int wasMlocked = TestClearPageMlocked(page);
> +	int wasMlocked = __TestClearPageMlocked(page);
>  
>  	kmemcheck_free_shadow(page, order);
>  
> @@ -1021,7 +1021,7 @@ static void free_hot_cold_page(struct page *page, int cold)
>  	struct zone *zone = page_zone(page);
>  	struct per_cpu_pages *pcp;
>  	unsigned long flags;
> -	int wasMlocked = TestClearPageMlocked(page);
> +	int wasMlocked = __TestClearPageMlocked(page);
>  
>  	kmemcheck_free_shadow(page, 0);
>  
> -- 
> 1.6.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



