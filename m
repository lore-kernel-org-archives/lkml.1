Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbZEECqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbZEECqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 22:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZEECqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 22:46:13 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:44758 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZEECqM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 22:46:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gCv1yQEHOGq4rGdj3pZ1Oc/TqUgoMVJ5RLUzL/WrUERhA5O5crejZK2Q2jFY5xV4TI
         gs89MZUG2syaFGIXVFFnKShQBSz/9o5TABAa5RdS4zuSdO+ycB1E5PdFyqtNFi+BiEaG
         M3aaK3Jc3jFOGsxbGnL5qrWs/YZtIHHo9RLOI=
MIME-Version: 1.0
In-Reply-To: <20090504234455.GA6324@localhost>
References: <20090504234455.GA6324@localhost>
Date: Tue, 5 May 2009 11:46:10 +0900
Message-ID: <44c63dc40905041946g1b1ea5cah21b5c2882ecd90fd@mail.gmail.com>
Subject: Re: [PATCH] vmscan: ZVC updates in shrink_active_list() can be done 
	once
From: Minchan Kim <barrioskmc@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "riel@redhat.com" <riel@redhat.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

This fine-grained ZVC update in shrink_active_list was made for
determination problem of the dirty
ratio(c878538598d1e7ab41ecc0de8894e34e2fdef630).
The 32 page reclaim time in normal reclaim situation is too short to
change current VM behavior.
So I think this make sense to me.

On Tue, May 5, 2009 at 8:44 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> This effectively lifts the unit of nr_inactive_* and pgdeactivate updates
> from PAGEVEC_SIZE=14 to SWAP_CLUSTER_MAX=32.
>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/vmscan.c |   11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
>
> --- linux.orig/mm/vmscan.c
> +++ linux/mm/vmscan.c
> @@ -1228,7 +1228,6 @@ static void shrink_active_list(unsigned
>                        struct scan_control *sc, int priority, int file)
>  {
>        unsigned long pgmoved;
> -       int pgdeactivate = 0;
>        unsigned long pgscanned;
>        LIST_HEAD(l_hold);      /* The pages which were snipped off */
>        LIST_HEAD(l_inactive);
> @@ -1257,7 +1256,7 @@ static void shrink_active_list(unsigned
>                __mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
>        spin_unlock_irq(&zone->lru_lock);
>
> -       pgmoved = 0;
> +       pgmoved = 0;  /* count referenced (mapping) mapped pages */
>        while (!list_empty(&l_hold)) {
>                cond_resched();
>                page = lru_to_page(&l_hold);
> @@ -1291,7 +1290,7 @@ static void shrink_active_list(unsigned
>         */
>        reclaim_stat->recent_rotated[!!file] += pgmoved;
>
> -       pgmoved = 0;
> +       pgmoved = 0;  /* count pages moved to inactive list */
>        while (!list_empty(&l_inactive)) {
>                page = lru_to_page(&l_inactive);
>                prefetchw_prev_lru_page(page, &l_inactive, flags);
> @@ -1304,10 +1303,7 @@ static void shrink_active_list(unsigned
>                mem_cgroup_add_lru_list(page, lru);
>                pgmoved++;
>                if (!pagevec_add(&pvec, page)) {
> -                       __mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
>                        spin_unlock_irq(&zone->lru_lock);
> -                       pgdeactivate += pgmoved;
> -                       pgmoved = 0;
>                        if (buffer_heads_over_limit)
>                                pagevec_strip(&pvec);
>                        __pagevec_release(&pvec);
> @@ -1315,9 +1311,8 @@ static void shrink_active_list(unsigned
>                }
>        }
>        __mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
> -       pgdeactivate += pgmoved;
>        __count_zone_vm_events(PGREFILL, zone, pgscanned);
> -       __count_vm_events(PGDEACTIVATE, pgdeactivate);
> +       __count_vm_events(PGDEACTIVATE, pgmoved);
>        spin_unlock_irq(&zone->lru_lock);
>        if (buffer_heads_over_limit)
>                pagevec_strip(&pvec);
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Thanks,
Minchan Kim
