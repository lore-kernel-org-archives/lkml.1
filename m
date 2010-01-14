Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830Ab0ANWxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab0ANWxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757125Ab0ANWxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:53:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756671Ab0ANWxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:53:22 -0500
Date: Thu, 14 Jan 2010 14:52:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Hong <lihong.hi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 3/3] mm: remove function free_hot_page
Message-Id: <20100114145247.076430b4.akpm@linux-foundation.org>
In-Reply-To: <3a3680031001130654q1928df60pde0e3706ea2461c@mail.gmail.com>
References: <3a3680031001130654q1928df60pde0e3706ea2461c@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 22:54:50 +0800
Li Hong <lihong.hi@gmail.com> wrote:

> Now fuction 'free_hot_page' is just a wrap of ' free_hot_cold_page' with
> parameter 'cold = 0'. After adding a clear comment for 'free_hot_cold_page', it
> is reasonable to remove a level of call.
> 
> Signed-off-by: Li Hong <lihong.hi@gmail.com>
> ---
>  mm/page_alloc.c |    8 ++------
>  mm/swap.c       |    2 +-
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 175dd36..c88e03d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1073,6 +1073,7 @@ void mark_free_pages(struct zone *zone)
> 
>  /*
>   * Free a 0-order page
> + * cold == 1 ? free a cold page : free a hot page
>   */
>  static void free_hot_cold_page(struct page *page, int cold)
>  {
> @@ -1135,11 +1136,6 @@ out:
>         put_cpu();
>  }
> 
> -void free_hot_page(struct page *page)
> -{
> -       free_hot_cold_page(page, 0);
> -}
> -
>  /*
>   * split_page takes a non-compound higher-order page, and splits it into
>   * n (1<<order) sub-pages: page[0..n]
> @@ -2014,7 +2010,7 @@ void __free_pages(struct page *page, unsigned int order)
>  {
>         if (put_page_testzero(page)) {
>                 if (order == 0)
> -                       free_hot_page(page);
> +                       free_hot_cold_page(page, 0);
>                 else
>                         __free_pages_ok(page, order);
>         }
> diff --git a/mm/swap.c b/mm/swap.c
> index 308e57d..9036b89 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -55,7 +55,7 @@ static void __page_cache_release(struct page *page)
>                 del_page_from_lru(zone, page);
>                 spin_unlock_irqrestore(&zone->lru_lock, flags);
>         }
> -       free_hot_page(page);
> +       free_hot_cold_page(page, 0);
>  }

yup, it's worth removing a level of function call.

We could do that simply by making free_hot_page() an inline function -
that would be a bit neater and wouild generate the same code as your
patch will.


