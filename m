Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbZJZHKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbZJZHKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbZJZHKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:10:36 -0400
Received: from smtp-out.google.com ([216.239.33.17]:47532 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbZJZHKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:10:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=QVWhE2gei+v/ryDsiDYzJHxme3dqXUwgQXMpRwGwpE2/r20hwR+lJZu9EJQfuXB6N
	hmr4dCXoC082uNhm0EppA==
Date: Mon, 26 Oct 2009 00:10:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/5] page allocator: Always wake kswapd when restarting
 an allocation attempt after direct reclaim failed
In-Reply-To: <20091026100019.2F4A.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0910260005500.15361@chino.kir.corp.google.com>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <1256221356-26049-2-git-send-email-mel@csn.ul.ie> <20091026100019.2F4A.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009, KOSAKI Motohiro wrote:

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index bf72055..5a27896 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1899,6 +1899,12 @@ rebalance:
>  	if (should_alloc_retry(gfp_mask, order, pages_reclaimed)) {
>  		/* Wait for some write requests to complete then retry */
>  		congestion_wait(BLK_RW_ASYNC, HZ/50);
> +
> +		/*
> +		 * While we wait congestion wait, Amount of free memory can
> +		 * be changed dramatically. Thus, we kick kswapd again.
> +		 */
> +		wake_all_kswapd(order, zonelist, high_zoneidx);
>  		goto rebalance;
>  	}
>  

We're blocking to finish writeback of the directly reclaimed memory, why 
do we need to wake kswapd afterwards?
