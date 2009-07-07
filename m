Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbZGGXjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbZGGXjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 19:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757030AbZGGXjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 19:39:14 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:44678 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987AbZGGXjO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 19:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CRbMdlJBko0wm4qhDruzTUzGLh0F9N5/iAZ0A07w1N6xNfoIefXlC3+oAiE9MpGViE
         2fiTWtnQSEPzHJOCmn0tLhDSOzzp0nM9t8IHpizB+YNrrIrKmZ4p54Qf+np6nvbHNhmc
         f+teNu3iSbMSEMwEifbbgTdEJYcWHIayCQVxU=
MIME-Version: 1.0
In-Reply-To: <20090707184034.0C70.A69D9226@jp.fujitsu.com>
References: <20090707182947.0C6D.A69D9226@jp.fujitsu.com>
	 <20090707184034.0C70.A69D9226@jp.fujitsu.com>
Date: Wed, 8 Jul 2009 08:39:12 +0900
Message-ID: <28c262360907071639g4877b2c2w59a8eae8559557f7@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] vmscan don't isolate too many pages
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 7, 2009 at 6:47 PM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
> Subject: [PATCH] vmscan don't isolate too many pages
>
> If the system have plenty threads or processes, concurrent reclaim can
> isolate very much pages.
>
> And if other processes isolate _all_ pages on lru, the reclaimer can't find
> any reclaimable page and it makes accidental OOM.
>
> The solusion is, we should restrict maximum number of isolated pages.
> (this patch use inactive_page/2)
>
>
> FAQ
> -------
> Q: Why do you compared zone accumulate pages, not individual zone pages?
> A: If we check individual zone, #-of-reclaimer is restricted by smallest zone.
>   it mean decreasing the performance of the system having small dma zone.
>
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/page_alloc.c |   27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>
> Index: b/mm/page_alloc.c
> ===================================================================
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1721,6 +1721,28 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
>        return alloc_flags;
>  }
>
> +static bool too_many_isolated(struct zonelist *zonelist,
> +                             enum zone_type high_zoneidx, nodemask_t *nodemask)
> +{
> +       unsigned long nr_inactive = 0;
> +       unsigned long nr_isolated = 0;
> +       struct zoneref *z;
> +       struct zone *zone;
> +
> +       for_each_zone_zonelist_nodemask(zone, z, zonelist,
> +                                       high_zoneidx, nodemask) {
> +               if (!populated_zone(zone))
> +                       continue;
> +
> +               nr_inactive += zone_page_state(zone, NR_INACTIVE_ANON);
> +               nr_inactive += zone_page_state(zone, NR_INACTIVE_FILE);
> +               nr_isolated += zone_page_state(zone, NR_ISOLATED_ANON);
> +               nr_isolated += zone_page_state(zone, NR_ISOLATED_FILE);
> +       }
> +
> +       return nr_isolated > nr_inactive;
> +}
> +
>  static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>        struct zonelist *zonelist, enum zone_type high_zoneidx,
> @@ -1789,6 +1811,11 @@ rebalance:
>        if (p->flags & PF_MEMALLOC)
>                goto nopage;
>
> +       if (too_many_isolated(gfp_mask, zonelist, high_zoneidx, nodemask)) {

too_many_isolated(zonelist, high_zoneidx, nodemask)

-- 
Kind regards,
Minchan Kim
