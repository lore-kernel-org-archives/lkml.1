Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbZJ1DyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbZJ1DyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757291AbZJ1DyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:54:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34593 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258AbZJ1DyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:54:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] vmscan: Force kswapd to take notice faster when high-order watermarks are being hit
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <20091027131905.410ec04a.akpm@linux-foundation.org>
References: <1256650833-15516-4-git-send-email-mel@csn.ul.ie> <20091027131905.410ec04a.akpm@linux-foundation.org>
Message-Id: <20091028115505.FD88.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 28 Oct 2009 12:54:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 27 Oct 2009 13:40:33 +0000
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > When a high-order allocation fails, kswapd is kicked so that it reclaims
> > at a higher-order to avoid direct reclaimers stall and to help GFP_ATOMIC
> > allocations. Something has changed in recent kernels that affect the timing
> > where high-order GFP_ATOMIC allocations are now failing with more frequency,
> > particularly under pressure. This patch forces kswapd to notice sooner that
> > high-order allocations are occuring.
> 
> "something has changed"?  Shouldn't we find out what that is?

if kswapd_max_order was changed, kswapd quickly change its own reclaim
order.

old:
  1. happen order-0 allocation
  2. kick kswapd
  3. happen high-order allocation
  4. change kswapd_max_order, but kswapd continue order-0 reclaim.
  5. kswapd end order-0 reclaim and exit balance_pgdat
  6. kswapd() restart balance_pdgat() with high-order

new:
  1. happen order-0 allocation
  2. kick kswapd
  3. happen high-order allocation
  4. change kswapd_max_order
  5. kswapd notice it and quickly exit balance_pgdat()
  6. kswapd() restart balance_pdgat() with high-order

> 
> > ---
> >  mm/vmscan.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 64e4388..7eceb02 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2016,6 +2016,15 @@ loop_again:
> >  					priority != DEF_PRIORITY)
> >  				continue;
> >  
> > +			/*
> > +			 * Exit the function now and have kswapd start over
> > +			 * if it is known that higher orders are required
> > +			 */
> > +			if (pgdat->kswapd_max_order > order) {
> > +				all_zones_ok = 1;
> > +				goto out;
> > +			}
> > +
> >  			if (!zone_watermark_ok(zone, order,
> >  					high_wmark_pages(zone), end_zone, 0))
> >  				all_zones_ok = 0;
> 
> So this handles the case where some concurrent thread or interrupt
> increases pgdat->kswapd_max_order while kswapd was running
> balance_pgdat(), yes?

Yes.

> Does that actually happen much?  Enough for this patch to make any
> useful difference?

In typical use-case, it doesn't have so much improvement. However some
driver use high-order allocation on interrupt context.
It mean we need quickly reclaim before GFP_ATOMIC allocation failure.

I agree these driver is ill. but...
We can't ignore enduser bug report.


> 
> If one where to whack a printk in that `if' block, how often would it
> trigger, and under what circumstances?
> 
> 
> If the -stable maintainers were to ask me "why did you send this" then
> right now my answer would have to be "I have no idea".  Help.





