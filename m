Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbZJPKwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbZJPKwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 06:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZJPKwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 06:52:49 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:39723 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbZJPKws convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 06:52:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OewgOfqyup4SBT4SzxOuQ2p19OY1C5qtmWj1/C7TCazBsG0G7u1nVhl27oL+/TywzY
         M4O3apuoWjSfGUoD06//WXPMK3fPY5WlQLqEOmuKCTbKjCKaJb8RH66ZA+ukKCgkH4gY
         nbevPL1pfHqCqvHCc3pY53+AUtQ5Xtoy1SD/w=
MIME-Version: 1.0
In-Reply-To: <1255689446-3858-2-git-send-email-mel@csn.ul.ie>
References: <1255689446-3858-1-git-send-email-mel@csn.ul.ie>
	 <1255689446-3858-2-git-send-email-mel@csn.ul.ie>
Date: Fri, 16 Oct 2009 13:52:09 +0300
X-Google-Sender-Auth: fb7d1fca61eebb1d
Message-ID: <84144f020910160352n3a334e84hd248b78e0093716d@mail.gmail.com>
Subject: Re: [PATCH 1/2] page allocator: Always wake kswapd when restarting an 
	allocation attempt after direct reclaim failed
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable <stable@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       Frans Pop <elendil@planet.nl>,
       reinette chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>,
       "John W. Linville" <linville@tuxdriver.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 1:37 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> If a direct reclaim makes no forward progress, it considers whether it
> should go OOM or not. Whether OOM is triggered or not, it may retry the
> application afterwards. In times past, this would always wake kswapd as well
> but currently, kswapd is not woken up after direct reclaim fails. For order-0
> allocations, this makes little difference but if there is a heavy mix of
> higher-order allocations that direct reclaim is failing for, it might mean
> that kswapd is not rewoken for higher orders as much as it did previously.
>
> This patch wakes up kswapd when an allocation is being retried after a direct
> reclaim failure. It would be expected that kswapd is already awake, but
> this has the effect of telling kswapd to reclaim at the higher order as well.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  mm/page_alloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index bf72055..dfa4362 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1817,9 +1817,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>        if (NUMA_BUILD && (gfp_mask & GFP_THISNODE) == GFP_THISNODE)
>                goto nopage;
>
> +restart:
>        wake_all_kswapd(order, zonelist, high_zoneidx);
>
> -restart:
>        /*
>         * OK, we're below the kswapd watermark and have kicked background
>         * reclaim. Now things get more complex, so set up alloc_flags according
> --
> 1.6.3.3
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
