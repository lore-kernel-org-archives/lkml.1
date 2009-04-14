Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbZDNJ0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbZDNJ0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZDNJZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:25:56 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:26489 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750883AbZDNJZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:25:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=Zet67QhwITRLSV60vhVDPqznzGj8TF7QYIjx+O9L0F6uPOOe19t3ETnN+egSOCFhiph31oGBQvX5E3ZbxaxzzWMB5vTt89GWv9l57n3vWdFyzXzFOn1szhe41T22c7jfw5lU4/NosoZziv8LsJFLtpOeXH/9xdZeyozWrwHK3tk=  ;
X-YMail-OSG: ueFRm1oVM1mxgfRVRqklkei14h4ps6J3K3luMYMPtwKS0clu7jQSw0zaJqd7cfotklZN12xGcUzA6Mvt3tG98jFl_qZ32B1Xwqgf2EgVVCtrXKfzkEoI8YxXlE.4PoRqiSYknfoPA8W2kR4rs0XgMYIeoCpL9Bc9pfiD5JH_CX8xnf7JD5mNUfKNmZ95YFwWcKbM9KFEfinUTUbEHH_gjBhobWsKlInYhS9VCSEuzq4VWPUhmlZKuieO0b9BRfC.Xh6oyyTxtY9e2vYnZpViSCyxE3wgjFcHYin7cA9Jkg9LXLs9pmAXSUuew5J_nLzT36LBGHsoOWZygqyfNbo-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH v3 1/6] mm: Don't unmap gup()ed page
Date: Tue, 14 Apr 2009 19:25:44 +1000
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Andrea Arcangeli <aarcange@redhat.com>,
       Jeff Moyer <jmoyer@redhat.com>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
References: <20090414151204.C647.A69D9226@jp.fujitsu.com> <20090414151554.C64A.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090414151554.C64A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904141925.46012.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 April 2009 16:16:52 KOSAKI Motohiro wrote:

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Sugessted-by: Linus Torvalds <torvalds@osdl.org>

"Suggested-by:" ;)

> Cc: Hugh Dickins <hugh@veritas.com>
> Cc: Andrew Morton <akpm@osdl.org>
> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: linux-mm@kvack.org
> ---
>  mm/rmap.c     |   21 +++++++++++++++++++++
>  mm/swapfile.c |   10 +++++++++-
>  2 files changed, 30 insertions(+), 1 deletion(-)
> 
> Index: b/mm/swapfile.c
> ===================================================================
> --- a/mm/swapfile.c	2009-04-11 21:38:33.000000000 +0900
> +++ b/mm/swapfile.c	2009-04-11 21:38:45.000000000 +0900
> @@ -533,6 +533,8 @@ static inline int page_swapcount(struct 
>   * to it.  And as a side-effect, free up its swap: because the old content
>   * on disk will never be read, and seeking back there to write new content
>   * later would only waste time away from clustering.
> + * Caller must hold pte_lock. try_to_unmap() decrement page::_mapcount
> + * and get_user_pages() increment page::_count under pte_lock.
>   */
>  int reuse_swap_page(struct page *page)
>  {
> @@ -547,7 +549,13 @@ int reuse_swap_page(struct page *page)
>  			SetPageDirty(page);
>  		}
>  	}
> -	return count == 1;
> +
> +	/*
> +	 * If we can re-use the swap page _and_ the end
> +	 * result has only one user (the mapping), then
> +	 * we reuse the whole page
> +	 */
> +	return count + page_count(page) == 2;
>  }

I guess this patch does work to close the read-side race, but I slightly don't
like using page_count for things like this. page_count can be temporarily
raised for reasons other than access through their user mapping. Swapcache,
page reclaim, LRU pagevecs, concurrent do_wp_page, etc.


>  /*
> Index: b/mm/rmap.c
> ===================================================================
> --- a/mm/rmap.c	2009-04-11 21:38:33.000000000 +0900
> +++ b/mm/rmap.c	2009-04-12 00:58:58.000000000 +0900
> @@ -773,6 +773,27 @@ static int try_to_unmap_one(struct page 
>  		goto out;
>  
>  	/*
> +	 * Don't pull an anonymous page out from under get_user_pages.
> +	 * GUP carefully breaks COW and raises page count (while holding
> +	 * pte_lock, as we have here) to make sure that the page
> +	 * cannot be freed.  If we unmap that page here, a user write
> +	 * access to the virtual address will bring back the page, but
> +	 * its raised count will (ironically) be taken to mean it's not
> +	 * an exclusive swap page, do_wp_page will replace it by a copy
> +	 * page, and the user never get to see the data GUP was holding
> +	 * the original page for.
> +	 *
> +	 * This test is also useful for when swapoff (unuse_process) has
> +	 * to drop page lock: its reference to the page stops existing
> +	 * ptes from being unmapped, so swapoff can make progress.
> +	 */
> +	if (PageSwapCache(page) &&
> +	    page_count(page) != page_mapcount(page) + 2) {
> +		ret = SWAP_FAIL;
> +		goto out_unmap;
> +	}

I guess it does add another constraint to the VM, ie. not allowed to
unmap an anonymous page with elevated refcount. Maybe not a big deal
now, but I think it is enough that it should be noted. If you squint,
this could actually be more complex/intrusive to the wider VM than my
copy on fork (which is basically exactly like a manual do_wp_page at
fork time).

And.... I don't think this is safe against a concurrent gup_fast()
(which helps my point).
