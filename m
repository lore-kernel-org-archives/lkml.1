Return-Path: <linux-kernel-owner+w=401wt.eu-S1751193AbXCOKQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193AbXCOKQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 06:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXCOKQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 06:16:31 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:58570 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbXCOKQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 06:16:30 -0400
Date: Thu, 15 Mar 2007 10:16:25 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm1
Message-ID: <20070315101625.GA16974@skynet.ie>
References: <20070307201839.6f45735b.akpm@linux-foundation.org> <200703142006.04547.m.kozlowski@tuxland.pl> <20070314170738.d5d35c06.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070314170738.d5d35c06.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (14/03/07 17:07), Andrew Morton didst pronounce:
> > On Wed, 14 Mar 2007 20:06:02 +0100 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
> > Hello,
> > 
> > 	Today after +- 24h of uptime I found some more page allocation
> > failures ('eth1: Can't allocate skb for Rx'). You'll find more here:
> > 
> > http://tuxland.pl/misc/2.6.21-rc3-mm1-page-allocation-failure.txt
> > 
> > System wasn't doing anything unusual, as usual ;-) X, some p2p 
> > software, firefox+flash playing music.
> > 
> 
> Do other kernels do this, or is 2.6.21-rc3-mm1 worse?
> 
> It is of course a non-fatal problem and will inevitably happen sometimes,
> but we would like the VM to be able to minimise the occurrence of this
> problem.
> 

I'm looking at this now. In the vanilla allocator, min_free_kbytes has the
effect of keeping largest blocks free for as long as possible. This means
that if high-order allocations are rare, they'll tend to succeed up to a point.

In the case of the earlier report on HID failing the order-5 allocation, it's
because we didn't reclaim for long enough because the order was too high. It
would need to reclaim for quite a long time before it would get an order-5
block free. That is what Andy's lumpy-reclaim patches address - reclaiming
intelligently when we know it has a chance of succeeding instead of giving up.

> I think we were rather hoping that Mel's anti-fragmentation work would
> improve things.

I'm still optimistic it will. This is the widest it's been tested so far
so there were going to be bases

In this case, the order is high but GFP_ATOMIC. These allocations get grouped
together but with a low min_free_kbytes, as is the case on this machine,
the high-order atomic blocks eventually get used by others. I had assumed
that if high-order atomic allocations were important (e.g. e1000) that the
machine would be configured with min_free_kbytes of at least 16384 i.e.
1 MAX_ORDER_NR_PAGES per MIGRATE_TYPE.

Mariusz, I would be interested in finding out if this problem still occurs when
you set min_free_kbytes to 16384 via /proc/sys/vm/min_free_kbytes. I understand
that the problem is not easily reproduced and requiring configuration changes
is far from ideal but it'd allow me to find out if options 2 or 3 below make
sense in advance.

I'm looking at three ways of addressing this;

1. Anti-fragmentation currently favours breaking larger blocks to
   group-by-mobility as opposed to the vanilla allocator which always favours
   using the smallest possible block no matter where it is.  I'm looking
   at preserving the behaviour of the vanilla allocator to keeping larger
   blocks free as much as possible to see how adverse an effect that
   subsequently has on fragmentation.

2. Set min_free_kbytes higher automatically at boot time when
   CONFIG_PAGE_GROUP_BY_MOBILITY is set.

3. Disable PAGE_GROUP_BY_MOBILITY when min_free_kbytes is set too low
   and print KERN_INFO messages when it's disabled or enabled based on
   min_free_kbytes

I'm testing patches for 1 at the moment even though I think it will
lower success rates for superpage allocations because of increased
fragmentation. Benchmarking will tell me for sure.

Thanks Mariusz for the report.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
