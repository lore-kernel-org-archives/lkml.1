Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYLJFHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYLJFHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 00:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYLJFHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 00:07:11 -0500
Received: from mail.suse.de ([195.135.220.2]:54317 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbYLJFHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 00:07:10 -0500
Date: Wed, 10 Dec 2008 06:07:05 +0100
From: Nick Piggin <npiggin@suse.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] vmscan: skip freeing memory from zones with lots free
Message-ID: <20081210050705.GE8434@wotan.suse.de>
References: <20081129195357.813D.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081208205842.53F8.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081208220016.53FB.KOSAKI.MOTOHIRO@jp.fujitsu.com> <2f11576a0812080948k135e15c5h2bc727355235f94@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0812080948k135e15c5h2bc727355235f94@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2008 at 02:48:40AM +0900, KOSAKI Motohiro wrote:
> > example,
> >
> >  Called zone_watermark_ok(zone, 2, pages_min, 0, 0);
> >  pages_min  = 64
> >  free pages = 80
> >
> > case A.
> >
> >     order    nr_pages
> >   --------------------
> >      2         5
> >      1        10
> >      0        30
> >
> >        -> zone_watermark_ok() return 1
> >
> > case B.
> >
> >     order    nr_pages
> >   --------------------
> >      3        10
> >      2         0
> >      1         0
> >      0         0
> >
> >        -> zone_watermark_ok() return 0
> 
> Doh!
> this example is obiously buggy.
> 
> I guess Mr. KOSAKI is very silly or Idiot.
> I recommend to he get feathery blanket and good sleeping, instead
> black black coffee ;-)

:) No, actually it is always good to have people reviewing existing
code, so thank you for that.


> ...but below mesurement result still true.

And it is an interesting result. As far as I can see, your patch changes
zone_watermark_ok so that it avoids some watermark checking for higher
order page blocks? I am surprised it makes a noticable difference in
performance, however such a change would be slightly detrimental to
atomic and "emergency" allocations of higher order pages, wouldn't it?

It would be interesting to know where the higher order allocations are
coming from. Do packets over loopback device still do higher order
allocations? If so, I suspect this is a bit artificial.

> 
> > This patch change zone_watermark_ok() logic to prefer large contenious block.
> >
> >
> > Result:
> >
> >  test machine:
> >    CPU: ia64 x 8
> >    MEM: 8GB
> >
> >  benchmark:
> >    $ tbench 8  (three times mesurement)
> >
> >    tbench works between about 600sec.
> >    alloc_pages() and zone_watermark_ok() are called about 15,000,000 times.
> >
> >
> >              2.6.28-rc6                        this patch
> >
> >       throughput    max-latency       throughput       max-latency
> >        ---------------------------------------------------------
> >        1480.92         20.896          1,490.27        19.606
> >        1483.94         19.202          1,482.86        21.082
> >        1478.93         22.215          1,490.57        23.493
> >
> > avg     1,481.26        20.771          1,487.90        21.394
> > std         2.06         1.233              3.56         1.602
> > min     1,478.93        19.202          1,477.86        19.606
> > max     1,483.94        22.215          1,490.57        23.493
> >
> >
> > throughput improve about 5MB/sec. it over measurement wobbly.
