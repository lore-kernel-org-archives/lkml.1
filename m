Return-Path: <linux-kernel-owner+w=401wt.eu-S1761207AbXHNLvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761207AbXHNLvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 07:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760065AbXHNLvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 07:51:14 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:44369 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759639AbXHNLvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 07:51:10 -0400
Date: Tue, 14 Aug 2007 15:50:38 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Daniel Phillips <phillips@phunq.net>
Cc: Jens Axboe <jens.axboe@oracle.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Block device throttling [Re: Distributed storage.]
Message-ID: <20070814115037.GA2958@2ka.mipt.ru>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708140413.12530.phillips@phunq.net> <20070814113039.GA20780@2ka.mipt.ru> <200708140435.44979.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708140435.44979.phillips@phunq.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 04:35:43AM -0700, Daniel Phillips (phillips@phunq.net) wrote:
> On Tuesday 14 August 2007 04:30, Evgeniy Polyakov wrote:
> > > And it will not solve the deadlock problem in general.  (Maybe it
> > > works for your virtual device, but I wonder...)  If the virtual
> > > device allocates memory during generic_make_request then the memory
> > > needs to be throttled.
> >
> > Daniel, if device process bio by itself, it has a limit and thus it
> > will wait in generic_make_request()
> 
> What will make it wait?

gneric_make_request() for given block device.

Example:

   virt_device -> do_smth_with_bio ->bio_endio().
       |
      / \
 phys0   phys1

Each of three devices above works with bio, each one eventually calls
bio_endio() and bio->bi_bdev will be one of the three above devices.

Thus, when system calls generic_make_request(bio->bi_bdev == virt_device),
one of the three limits will be charged, depending on the fact, that
virtual device forward bio to physical devices or not. Actually virtual
device limit will be charged too first, but if bio is forwarded, its 
portion will be reduced from virtual device's limit.

Now, if virtual device allocates bio itself (like device mapper), then
this new bio will be forwarded to physical devices via
gneric_make_request() and thus it will sleep in the physical device's
queue, if it is filled.

So, if each of three devices has a limit of 10 bios, then actual number
of bios in flight is maximum 3 * 10, since each device will be charged
up to _its_ maximum limit, not limit for the first device in the chain.

So, you set 10 to virtual device and its can process bio itself (like
send it to network), then this is number of bios in flight, which are
processed by _this_ device and not forwarded further. Actual number of
bios you can flush into virtual device is its own limit plus limits of
all physical devices atached to it.

-- 
	Evgeniy Polyakov
