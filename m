Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbZBYINt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbZBYINt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 03:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZBYINk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 03:13:40 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:27074 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZBYINj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 03:13:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PSB7WG24KT98t2HkB4xppxgi8MhgUBlm9UrNDBGJd7GmnHlsyMWcgKPhzu7vgbw+Bj
         AUmsfHCVahVGaeteWoQjYrrq2e5Fwt4surlytWkfX8C5tMDhlbYOpYbY1ietCc2xt8rf
         s6DZav6b/l+0QAwSttSK/9qOuVa0EYIZIyMP4=
MIME-Version: 1.0
In-Reply-To: <20090225023830.GA1611@cmpxchg.org>
References: <20090225023830.GA1611@cmpxchg.org>
Date: Wed, 25 Feb 2009 17:13:36 +0900
Message-ID: <28c262360902250013q7c2151c3x4bb093509b065fe0@mail.gmail.com>
Subject: Re: [patch] mm: move pagevec stripping to save unlock-relock
From: MinChan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice catch!

Reviewed-by: MinChan Kim <minchan.kim@gmail.com>

On Wed, Feb 25, 2009 at 11:38 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> In shrink_active_list() after the deactivation loop, we strip buffer
> heads from the potentially remaining pages in the pagevec.
>
> Currently, this drops the zone's lru lock for stripping, only to
> reacquire it again afterwards to update statistics.
>
> It is not necessary to strip the pages before updating the stats, so
> move the whole thing out of the protected region and save the extra
> locking.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/vmscan.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1298,14 +1298,11 @@ static void shrink_active_list(unsigned
>        }
>        __mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
>        pgdeactivate += pgmoved;
> -       if (buffer_heads_over_limit) {
> -               spin_unlock_irq(&zone->lru_lock);
> -               pagevec_strip(&pvec);
> -               spin_lock_irq(&zone->lru_lock);
> -       }
>        __count_zone_vm_events(PGREFILL, zone, pgscanned);
>        __count_vm_events(PGDEACTIVATE, pgdeactivate);
>        spin_unlock_irq(&zone->lru_lock);
> +       if (buffer_heads_over_limit)
> +               pagevec_strip(&pvec);
>        if (vm_swap_full())
>                pagevec_swap_free(&pvec);
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kinds regards,
MinChan Kim
