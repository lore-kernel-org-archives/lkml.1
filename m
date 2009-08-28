Return-Path: <linux-kernel-owner+w=401wt.eu-S1751922AbZH1PEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbZH1PEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 11:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbZH1PEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 11:04:48 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:37380 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZH1PEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 11:04:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J/2Pg0mn+FLGwhMgpRgwMYJ+R+nS1WRIhFwQs8NBcuVh9AiXNi479GHJiOzg35Vp1N
         DJ0mRCDFOwFkQwYg8FsKuYOnmwxHShIYaCNLTvEKBydHqL0rqOxaYTvksgB6wsyzvSQS
         smp3jnToBI4LG9r23Ka1QfY3TM0+kDRZLyXPU=
MIME-Version: 1.0
In-Reply-To: <1251449067-3109-3-git-send-email-mel@csn.ul.ie>
References: <1251449067-3109-1-git-send-email-mel@csn.ul.ie>
	 <1251449067-3109-3-git-send-email-mel@csn.ul.ie>
Date: Sat, 29 Aug 2009 00:04:48 +0900
Message-ID: <28c262360908280804r4c40c7baw7bb535dd8c275960@mail.gmail.com>
Subject: Re: [PATCH 2/2] page-allocator: Maintain rolling count of pages to 
	free from the PCP
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mel.

On Fri, Aug 28, 2009 at 5:44 PM, Mel Gorman<mel@csn.ul.ie> wrote:
> When round-robin freeing pages from the PCP lists, empty lists may be
> encountered. In the event one of the lists has more pages than another,
> there may be numerous checks for list_empty() which is undesirable. This
> patch maintains a count of pages to free which is incremented when empty
> lists are encountered. The intention is that more pages will then be freed
> from fuller lists than the empty ones reducing the number of empty list
> checks in the free path.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/page_alloc.c |   23 ++++++++++++++---------
>  1 files changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 65eedb5..9b86977 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -536,32 +536,37 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>                                        struct per_cpu_pages *pcp)
>  {
>        int migratetype = 0;
> +       int batch_free = 0;
>
>        spin_lock(&zone->lock);
>        zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
>        zone->pages_scanned = 0;
>
>        __mod_zone_page_state(zone, NR_FREE_PAGES, count);
> -       while (count--) {
> +       while (count) {
>                struct page *page;
>                struct list_head *list;
>
>                /*
> -                * Remove pages from lists in a round-robin fashion. This spinning
> -                * around potentially empty lists is bloody awful, alternatives that
> -                * don't suck are welcome
> +                * Remove pages from lists in a round-robin fashion. A batch_free
> +                * count is maintained that is incremented when an empty list is
> +                * encountered. This is so more pages are freed off fuller lists
> +                * instead of spinning excessively around empty lists
>                 */
>                do {
> +                       batch_free++;
>                        if (++migratetype == MIGRATE_PCPTYPES)
>                                migratetype = 0;
>                        list = &pcp->lists[migratetype];
>                } while (list_empty(list));

How about increasing the weight by batch_free ?

batch_free = 1 << (batch_free - 1);

It's assumed that if batch_free is big, it means
there are contiguous empty lists.
Then it is likely to need more time to refill empty lists than
one list refill. So I think it can decrease spinning empty list
a little more.

>
> -               page = list_entry(list->prev, struct page, lru);
> -               /* have to delete it as __free_one_page list manipulates */
> -               list_del(&page->lru);
> -               trace_mm_page_pcpu_drain(page, 0, migratetype);
> -               __free_one_page(page, zone, 0, migratetype);
> +               do {
> +                       page = list_entry(list->prev, struct page, lru);
> +                       /* must delete as __free_one_page list manipulates */
> +                       list_del(&page->lru);
> +                       __free_one_page(page, zone, 0, migratetype);
> +                       trace_mm_page_pcpu_drain(page, 0, migratetype);
> +               } while (--count && --batch_free && !list_empty(list));
>        }
>        spin_unlock(&zone->lock);
>  }
> --
> 1.6.3.3
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kind regards,
Minchan Kim
