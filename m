Return-Path: <linux-kernel-owner+w=401wt.eu-S1760506AbXGVQoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760506AbXGVQoJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 12:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbXGVQn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 12:43:57 -0400
Received: from brick.kernel.dk ([80.160.20.94]:8161 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbXGVQn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 12:43:56 -0400
Date: Sun, 22 Jul 2007 18:44:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 3/3] readahead: scale max readahead size depending on
	memory size
Message-ID: <20070722164403.GU11657@kernel.dk>
References: <20070721210005.000228000@chello.nl> <20070721210052.497469000@chello.nl> <20070722082434.GR11657@kernel.dk> <1185093405.20032.205.camel@twins> <20070722085041.GS11657@kernel.dk> <1185095852.20032.229.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185095852.20032.229.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22 2007, Peter Zijlstra wrote:
> On Sun, 2007-07-22 at 10:50 +0200, Jens Axboe wrote:
> > On Sun, Jul 22 2007, Peter Zijlstra wrote:
> > > On Sun, 2007-07-22 at 10:24 +0200, Jens Axboe wrote:
> > > > On Sat, Jul 21 2007, Peter Zijlstra wrote:
> > > 
> > > > > +static __init int readahead_init(void)
> > > > > +{
> > > > > +	/*
> > > > > +	 * Scale the max readahead window with system memory
> > > > > +	 *
> > > > > +	 *   64M:   128K
> > > > > +	 *  128M:   180K
> > > > > +	 *  256M:   256K
> > > > > +	 *  512M:   360K
> > > > > +	 *    1G:   512K
> > > > > +	 *    2G:   724K
> > > > > +	 *    4G:  1024K
> > > > > +	 *    8G:  1448K
> > > > > +	 *   16G:  2048K
> > > > > +	 */
> > > > > +	ra_pages = int_sqrt(totalram_pages/16);
> > > > > +	if (ra_pages > (2 << (20 - PAGE_SHIFT)))
> > > > > +		ra_pages = 2 << (20 - PAGE_SHIFT);
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > > 
> > > > How did you come up with these numbers?
> > > 
> > > Well, most other places in the kernel where we scale by memory size we
> > > use the a sqrt curve, and the specific scale was the result of some
> > > fiddling, these numbers looked sane to me, nothing special.
> > > 
> > > Would you suggest a different set, and if so, do you have any rationale
> > > for them?
> > 
> > I just wish you had a rationale behind them, I don't think it's that
> > great of a series.
> 
> Well, I was quite ignorant of the issues you just pointed out. Thanks
> those do indeed provide basis for a more solid set.
> 
> >  I agree with the low point of 128k.
> 
> Perhaps that should be enforced then, because currently a system with
> <64M will get less.

I think it should remain the low point.

> >  Then it'd be sane
> > to try and determine what the upper limit of ra window size goodness is,
> > which is probably impossible since it depends on the hardware a lot. But
> > lets just say the upper value is 2mb, then I think it's pretty silly
> > _not_ to use 2mb on a 1g machine for instance. So more aggressive
> > scaling.
> 
> Right, I was being a little conservative here.
> 
> > Then there's the relationship between nr of requests and ra size. When
> > you leave everything up to a simple sqrt of total_ram type thing, then
> > you are sure to hit stupid values that cause a queue size of a number of
> > full requests, plus a small one at the end. Clearly not optimal!
> 
> And this is where Wu's point of power of two series comes into play,
> right?
> 
> So something like:
> 
>   roundup_pow_of_two(int_sqrt((totalram_pages << (PAGE_SHIFT-10))))
> 
> 
> 		memory in MB		RA window in KB
>                             64                            128
>                            128                            256
>                            256                            256
>                            512                            512
>                           1024                            512
>                           2048                           1024
>                           4096                           1024
>                           8192                           2048
>                          16384                           2048
>                          32768                           4096
>                          65536                           4096

Only if you assume that max request size is always a power of 2. That's
usually true, but there are cases where it's 124kb for instance.

And there's still an issue when max_sectors isn't the deciding factor,
if we end up having to stop merging on a request because we hit other
limitations.

So there's definitely room for improvement! Even today, btw, it's not
all because of these changes.

-- 
Jens Axboe

