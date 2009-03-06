Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbZCFHq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbZCFHq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 02:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZCFHqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 02:46:48 -0500
Received: from brick.kernel.dk ([93.163.65.50]:40551 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbZCFHqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 02:46:47 -0500
Date: Fri, 6 Mar 2009 08:46:39 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jim Paris <jim@jtan.com>, Vivien Chappelier <vivien.chappelier@free.fr>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH/RFC] ps3/block: Add ps3vram-ng driver for accessing
	video    RAM as block device
Message-ID: <20090306074639.GN11787@kernel.dk>
References: <alpine.LRH.2.00.0903041444300.32279@vixen.sonytel.be> <20090305083701.GQ11787@kernel.dk> <alpine.LRH.2.00.0903051146440.2618@vixen.sonytel.be> <20090305110940.GY11787@kernel.dk> <alpine.LRH.2.00.0903051325450.2618@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0903051325450.2618@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05 2009, Geert Uytterhoeven wrote:
> On Thu, 5 Mar 2009, Jens Axboe wrote:
> > On Thu, Mar 05 2009, Geert Uytterhoeven wrote:
> > > On Thu, 5 Mar 2009, Jens Axboe wrote:
> > > > On Wed, Mar 04 2009, Geert Uytterhoeven wrote:
> > > > > Below is the rewrite of the PS3 Video RAM Storage Driver as a plain block
> > > > > device, as requested by Arnd Bergmann.
> 
> > > > I'd rewrite this as a ->make_request_fn handler instead. Then you can
> > > > get rid of the kernel thread. IOW, change
> > > >
> > > > queue = blk_init_queue(ps3vram_request, &priv->lock);
> > > >
> > > > to
> > > >
> > > > queue = blk_alloc_queue(GFP_KERNEL);
> > > > blk_queue_make_request(queue, ps3vram_make_request);
> > >
> > > Thanks, I didn't know that part...
> > >
> > > > Add error handling of course, and call blk_queue_max_*() to set your
> > > > limits for this device.
> > >
> > > I took out the blk_queue_max_*() calls (compared to ps3disk.c), as
> > > none of the limits apply, and the defaults are fine.
> > >
> > > Is that OK, or is it better to make it explicit?
> >
> > I think it's always good to make it explicit. Plus for this case you
> > definitely need it, as blk_init_queue() wont do it for you anymore.
> 
> blk_queue_make_request() does it for me, too:
> 
> void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
> {
> 	...
> 	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
> 	blk_queue_max_hw_segments(q, MAX_HW_SEGMENTS);
> 	...
> 	blk_queue_max_segment_size(q, MAX_SEGMENT_SIZE);
> 	...
> 	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
> 	...
> }
> 
> struct request_queue *
> blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
> {
> 	...
> 	blk_queue_max_segment_size(q, MAX_SEGMENT_SIZE);
> 
> 	blk_queue_max_hw_segments(q, MAX_HW_SEGMENTS);
> 	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
> 	...
> }

Indeed, there's some duplicated code in blk_init_queue_node(), I'll make
sure to get rid of that!

> > > > Then add a ps3vram_make_request() ala:
> > >
> > > > static void ps3vram_do_request(struct request_queue *q, struct bio *bio)
> > > > {
> 
> > > > }
> > > >
> > > > I just typed it here, so if it doesn't compile you get to keep the
> > > > pieces :-)
> > >
> > > OK, I'll give it a try...
> > >
> > > BTW, does this mean the `simple' way, which I used based on LDD3, is
> > > deprecated?
> >
> > Depends.. It's obviously not a very effective approach, since you punt
> > to a thread for each request. But if you need the IO scheduler helping
> > you with merging and sorting (for a rotational device), it still has
> > some merit. For this particular case, the ->make_request_fn approach is
> > much better.
> 
> Without the thread, performance indeed increased.
> 
> But then I noticed ps3vram_make_request() may be called concurrently,
> so I had to add a mutex to avoid data corruption. This slows the
> driver down, and in the end, the version with a thread turns out to be
> ca. 1% faster. The version without a thread is about 50 lines less
> code, though.

That is correct, ->make_request_fn may get reentered. I'm not surprised
that performance dropped if you just shoved everything under a mutex.
You could be a little more smart and queue concurrent bio's for
processing when the current one is complete though, there are several
approaches there that be a lot faster than going all the way through the
IO stack and scheduler just to avoid concurrency.

-- 
Jens Axboe

