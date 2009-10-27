Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbZJ0CnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbZJ0CnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 22:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbZJ0Cm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 22:42:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48483 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZJ0Cmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 22:42:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/5] page allocator: Always wake kswapd when restarting an allocation attempt after direct reclaim failed
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
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
In-Reply-To: <alpine.DEB.2.00.0910260005500.15361@chino.kir.corp.google.com>
References: <20091026100019.2F4A.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0910260005500.15361@chino.kir.corp.google.com>
Message-Id: <20091026222159.2F72.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 27 Oct 2009 11:42:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 26 Oct 2009, KOSAKI Motohiro wrote:
> 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index bf72055..5a27896 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1899,6 +1899,12 @@ rebalance:
> >  	if (should_alloc_retry(gfp_mask, order, pages_reclaimed)) {
> >  		/* Wait for some write requests to complete then retry */
> >  		congestion_wait(BLK_RW_ASYNC, HZ/50);
> > +
> > +		/*
> > +		 * While we wait congestion wait, Amount of free memory can
> > +		 * be changed dramatically. Thus, we kick kswapd again.
> > +		 */
> > +		wake_all_kswapd(order, zonelist, high_zoneidx);
> >  		goto rebalance;
> >  	}
> >  
> 
> We're blocking to finish writeback of the directly reclaimed memory, why 
> do we need to wake kswapd afterwards?

the same reason of "goto restart" case. that's my intention.
if following scenario occur, it is equivalent that we didn't call wake_all_kswapd().

  1. call congestion_wait()
  2. kswapd reclaimed lots memory and sleep
  3. another task consume lots memory
  4. wakeup from congestion_wait()

IOW, if we falled into __alloc_pages_slowpath(), we naturally expect
next page_alloc() don't fall into slowpath. however if kswapd end to
its work too early, this assumption isn't true.

Is this too pessimistic assumption?





