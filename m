Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbZJVOlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbZJVOlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbZJVOlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:41:51 -0400
Received: from mail-qy0-f194.google.com ([209.85.221.194]:52750 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbZJVOlt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:41:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jwHzuAHBZVShBgNXK0ypHd79a1JuO+OcRpoJJ4wAZlFOLG4Gwm8b06WIHIr9sOG6Je
         KN7gTfANqO7N62+VmYnxKmqvbYIs81hySnVMeYXHo+l6/w8PFf2MMYUZRScdo+dn5D3r
         K1XB5jF7IjvMBH8/5PcMTmlxYkx7SaTMMY6Po=
MIME-Version: 1.0
In-Reply-To: <1256221356-26049-2-git-send-email-mel@csn.ul.ie>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
	 <1256221356-26049-2-git-send-email-mel@csn.ul.ie>
Date: Thu, 22 Oct 2009 17:41:53 +0300
X-Google-Sender-Auth: 42e22da61dccfb89
Message-ID: <84144f020910220741o51c7e3dajcfd7b78d6dbbc4eb@mail.gmail.com>
Subject: Re: [PATCH 1/5] page allocator: Always wake kswapd when restarting an 
	allocation attempt after direct reclaim failed
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 5:22 PM, Mel Gorman <mel@csn.ul.ie> wrote:
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

You seem to have dropped the Reviewed-by tags from me and Christoph
for this patch.

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
