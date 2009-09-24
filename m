Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbZIXDPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbZIXDPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 23:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbZIXDPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 23:15:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:15393 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbZIXDPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 23:15:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,442,1249282800"; 
   d="scan'208";a="191044518"
Date: Thu, 24 Sep 2009 11:15:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090924031508.GD6456@localhost>
References: <20090922155259.GL10825@think> <20090923002220.GA6382@localhost> <20090922175452.d66400dd.akpm@linux-foundation.org> <20090923011758.GC6382@localhost> <20090922182832.28e7f73a.akpm@linux-foundation.org> <20090923014500.GA11076@localhost> <20090922185941.1118e011.akpm@linux-foundation.org> <20090923022622.GB11918@localhost> <20090922193622.42c00012.akpm@linux-foundation.org> <20090923140058.GA2794@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923140058.GA2794@think>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

Thanks for this excellent write up (and the previous one to Peter).
I'm glad to learn about your experiences and rationals behind this
work. As always, comments followed.

On Wed, Sep 23, 2009 at 10:00:58PM +0800, Chris Mason wrote:
> On Tue, Sep 22, 2009 at 07:36:22PM -0700, Andrew Morton wrote:
> > On Wed, 23 Sep 2009 10:26:22 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > On Wed, Sep 23, 2009 at 09:59:41AM +0800, Andrew Morton wrote:
> > > > On Wed, 23 Sep 2009 09:45:00 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > > 
> > > > > On Wed, Sep 23, 2009 at 09:28:32AM +0800, Andrew Morton wrote:
> > > > > > On Wed, 23 Sep 2009 09:17:58 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > > > > 
> > > > > > > On Wed, Sep 23, 2009 at 08:54:52AM +0800, Andrew Morton wrote:
> > > > > > > > On Wed, 23 Sep 2009 08:22:20 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > > > > > > 
> > > > > > > > > Jens' per-bdi writeback has another improvement. In 2.6.31, when
> > > > > > > > > superblocks A and B both have 100000 dirty pages, it will first
> > > > > > > > > exhaust A's 100000 dirty pages before going on to sync B's.
> > > > > > > > 
> > > > > > > > That would only be true if someone broke 2.6.31.  Did they?
> > > > > > > > 
> > > > > > > > SYSCALL_DEFINE0(sync)
> > > > > > > > {
> > > > > > > > 	wakeup_pdflush(0);
> > > > > > > > 	sync_filesystems(0);
> > > > > > > > 	sync_filesystems(1);
> > > > > > > > 	if (unlikely(laptop_mode))
> > > > > > > > 		laptop_sync_completion();
> > > > > > > > 	return 0;
> > > > > > > > }
> > > > > > > > 
> > > > > > > > the sync_filesystems(0) is supposed to non-blockingly start IO against
> > > > > > > > all devices.  It used to do that correctly.  But people mucked with it
> > > > > > > > so perhaps it no longer does.
> > > > > > > 
> > > > > > > I'm referring to writeback_inodes(). Each invocation of which (to sync
> > > > > > > 4MB) will do the same iteration over superblocks A => B => C ... So if
> > > > > > > A has dirty pages, it will always be served first.
> > > > > > > 
> > > > > > > So if wbc->bdi == NULL (which is true for kupdate/background sync), it
> > > > > > > will have to first exhaust A before going on to B and C.
> > > > > > 
> > > > > > But that works OK.  We fill the first device's queue, then it gets
> > > > > > congested and sync_sb_inodes() does nothing and we advance to the next
> > > > > > queue.
> > > > > 
> > > > > So in common cases "exhaust" is a bit exaggerated, but A does receive
> > > > > much more opportunity than B. Computation resources for IO submission
> > > > > are unbalanced for A, and there are pointless overheads in rechecking A.
> > > > 
> > > > That's unquantified handwaving.  One CPU can do a *lot* of IO.
> > > 
> > > Yes.. I had the impression that the writeback submission can be pretty slow.
> > > It should be because of the congestion_wait. Now that it is removed,
> > > things are going faster when queue is not full.
> > 
> > What?  The wait is short.  The design intent there is that we repoll
> > all previously-congested queues well before they start to run empty.
> 
> The congestion code was the big reason I got behind Jens' patches.  When
> working on btrfs I tried to tune the existing congestion based setup to
> scale well.  What we had before is basically a poll interface hiding
> behind a queue flag and a wait.  
 
So it's mainly about fast array writeback performance. 

> The only place that actually honors the congestion flag is pdflush.
> It's trivial to get pdflush backed up and make it sit down without
> making any progress because once the queue congests, pdflush goes away.

Right. I guess that's more or less intentional - to give lowest priority
to periodic/background writeback.

> Nothing stops other procs from keeping the queue congested forever.
> This can only be fixed by making everyone wait for congestion, at which
> point we might as well wait for requests.

Yes. That gives everyone somehow equal opportunity, this is a policy change
that may lead to interesting effects, as well as present a challenge to
get_request_wait(). That said, I'm not against the change to a wait queue
in general.

> Here are some graphs comparing 2.6.31 and 2.6.31 with Jens' latest code.
> The workload is two procs doing streaming writes to 32GB files.  I've
> used deadline and bumped nr_requests to 2048, so pdflush should be able
> to do a significant amount of work between congestion cycles.

The graphs show near 400MB/s throughput and about 4000-17000IO/s.

Writeback traces show that my 2Ghz laptop CPU can do IO submissions
up to 400MB/s. It takes about 0.01s to sync 4MB (one wb_kupdate =>
write_cache_pages traverse).

Given nr_requests=2048 and IOPS=10000, a congestion on-off cycle would
take (2048/16)/10000 = 0.0128s

The 0.0128s vs. 0.01s means that CPU returns just in time to see a
still congested but will soon become !congested queue. It then returns
to do congestion_wait, and be wakeup by the io completion events when
queue goes !congested. The return to write_cache_pages will again take
some time. So the end result may be, queue falls to 6/8 full, much below
the congestion off threshold 13/16.

Without congestion_wait, you get 100% full queue with get_request_wait. 

However I don't think the queue fullness can explain the performance
gain. It's sequential IO. It will only hurt performance if the queue
sometimes endangers starvation - which could happen when CPU is 100%
utilized so that IO submission cannot keep up. The congestion_wait
polls do eat more CPU power. It might impact the response to hard/soft
interrupts.

> The hardware is 5 sata drives pushed into an LVM stripe set.
> 
> http://oss.oracle.com/~mason/seekwatcher/bdi-writeback/xfs-streaming-compare.png
> http://oss.oracle.com/~mason/seekwatcher/bdi-writeback/btrfs-streaming-compare.png
> 
> In the mainline graphs, pdflush is actually doing the vast majority of
> the IO thanks to Richard's fix:
> 
> http://oss.oracle.com/~mason/seekwatcher/bdi-writeback/xfs-mainline-per-process.png
> 
> We can see there are two different pdflush procs hopping in and out
> of the work.

Yeah, that's expected. May eat some CPU cycles (race and locality issues).

> This isn't a huge problem, except that we're also hopping between
> files.

Yes, this is a problem. When encountered congestion, it may happen
that the file be synced only a dozen pages (which is very inefficient)
and then get redirty_tail (which may further delay this inode).

> I don't think this is because anyone broke pdflush, I think this is
> because very fast hardware goes from congested to uncongested 
> very quickly, even when we bump nr_requests to 2048 like I did in the
> graphs above.

What's typical CPU utilization during the test? It would be
interesting to do a comparison on %system numbers between the
poll/wait approaches.

> The pdflush congestion backoffs skip the batching optimizations done by
> the elevator.  pdflush could easily have waited in get_request_wait,
> been given a nice fat batch of requests and then said oh no, the queue
> is congested, I'll just sleep for a while without submitting any more
> IO.

I'd be surprised if the deadline batching is affected by the
interleaveness of incoming requests. Unless there are many expired
requests, which could happen when nr_requests is too large for the
device, which is not in your case.

I noticed that XFS's IOPS is almost doubled. While btrfs's IOPS and
throughput scales up by the same factor. The numbers show that the
average IO size for btrfs is near 64KB, is this your max_sectors_kb?
XFS's avg io size is a smaller 24kb, does that mean many small
metadata ios?

> The congestion checks prevent any attempts from the filesystem to write
> a whole extent (or a large portion of an extent) at a time.

Since writepage is called one by one for each page, will its
interleaveness impact filesystem decisions? Ie. between these two
writepage sequences.

        A1, B1, A2, B2, A3, B3, A4, B4
        A1, A2, A3, A4, B1, B2, B3, B4

Where each An/Bn stands for one page of file A/B, n is page index.

> The pdflush system tried to be async, but at the end of the day it
> wasn't async enough to effectively drive the hardware.  Threads did get
> tied up in FS locking, metadata reads and get_request_wait.  The end
> result is that not enough time was spent keeping all the drives on the
> box busy.

Yes, too much processing overheads with congestion_wait may be enough
to kill performance of fast arrays.

> This isn't handwaving, my harddrive is littered with pdflush patches
> trying to make it scale well, and I just couldn't work it out.

Thanks,
Fengguang
