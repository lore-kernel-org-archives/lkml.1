Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbZDHJNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbZDHJNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbZDHJNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:13:14 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60821 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602AbZDHJNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:13:13 -0400
Date: Wed, 8 Apr 2009 11:13:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jos Houtman <jos@hyves.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads
Message-ID: <20090408091311.GY5178@kernel.dk>
References: <20090408062056.GP5178@kernel.dk> <C60233A2.EEB9%jos@hyves.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C60233A2.EEB9%jos@hyves.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08 2009, Jos Houtman wrote:
> >> 
> >> Hi Jos, you said that this simple patch solved the problem, however you
> >> mentioned somehow suboptimal performance. Can you elaborate that?  So
> >> that I can push or improve it.
> >> 
> >> Thanks,
> >> Fengguang
> >> ---
> >>  fs/fs-writeback.c |    3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >> 
> >> --- mm.orig/fs/fs-writeback.c
> >> +++ mm/fs/fs-writeback.c
> >> @@ -325,7 +325,8 @@ __sync_single_inode(struct inode *inode,
> >>                                * soon as the queue becomes uncongested.
> >>                                */
> >>                               inode->i_state |= I_DIRTY_PAGES;
> >> -                             if (wbc->nr_to_write <= 0) {
> >> +                             if (wbc->nr_to_write <= 0 ||
> >> +                                 wbc->encountered_congestion) {
> >>                                       /*
> >>                                        * slice used up: queue for next turn
> >>                                        */
> >> 
> >>> But the second problem seen in that thread, a write-starve-read problem does
> >>> not seem to solved. In this problem the writes of the writeback algorithm
> >>> starve the ongoing reads, no matter what io-scheduler is picked.
> > 
> > What kind of SSD drive are you using? Does it support queuing or not?
> 
> First Jens his question: We use the MTRON PRO 7500 ( MTRON MSP-SATA75 ) with
> 64GB and 128GB and I don't know whether it supports queuing or not. How can
> I check? The data-sheet doesn't mention NCQ, if you meant that.

They do not. The MTRONs are in the "crap" ssd category, irregardless of
their (seemingly undeserved) high price tag. I tested a few of them some
months ago and was less than impressed. It still sits behind a crap pata
bridge and its random write performance was abysmal.

So in general I find it quite weird that the writeback cannot keep up,
there's not that much to keep up with. I'm guessing it's because of the
quirky nature of the device when it comes to writes.

As to the other problem, we usually do quite well on read-vs-write
workloads. CFQ performs great for those, if I test the current
2.6.30-rc1 kernel, a read goes at > 90% of full performance with a

dd if=/dev/zero of=foo bs=1M

running in the background. On both NCQ and non-NCQ drives. Could you try
2.6.30-rc1, just in case it works better for you? At least CFQ will
behave better there in any case. AS should work fine for that as well,
but don't expect very good read-vs-write performance with deadline or
noop. Doing some sort of anticipation is crucial to get that right.

What kind of read workload are you running? May small files, big files,
one big file, or?

> Background: 
> The machines that have these problems are databases, with large datasets
> that need to read quite a lot of data from disk (as it won't fit in
> filecache). These write-bursts lock queries that normally take only a few ms
> up to a several seconds. As a result of this lockup a backlog is created,
> and in our current database setup the backlog is actively purged. Forcing a
> reconnect to the same set of suffering database servers, further increasing
> the load. 

OK, so I'm guessing it's bursty smallish reads. That is the hardest
case. If your MTRON has a write cache, it's very possible that by the
time we stop the writes and issue the read, the device takes a long time
to service that read. And if we then mix reads and writes, it's
basically impossible to get any sort of interactiveness out of it. With
the second rate SSD devices, you probably need to tweak the IO
scheduling a bit to make that work well. If you try 2.6.30-rc1, you
could try and set 'slice_async_rq' to 1 and slice_async to 5 in
/sys/block/sda/queue/iosched/ (or sdX whatever is your device) with CFQ
and see if that makes a difference. If the device is really slow,
perhaps try and increase slice_idle as well.

> But I would be really glad if I could just use the deadline scheduler to do
> 1 write for every 10 reads and make the write-expire timeout very high.

It wont help a lot because of the dependent nature of the reads you are
doing. By the time you issue 1 read and it completes and until you issue
the next read, you could very well have sent enough writes to the device
that the next read will take equally long to complete.

-- 
Jens Axboe

