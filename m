Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbZIXMLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbZIXMLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbZIXMLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:11:11 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:33643 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZIXMLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:11:09 -0400
Date: Thu, 24 Sep 2009 08:10:34 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090924121034.GA2797@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Li, Shaohua" <shaohua.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
	"jens.axboe@oracle.com" <jens.axboe@oracle.com>
References: <20090923002220.GA6382@localhost>
 <20090922175452.d66400dd.akpm@linux-foundation.org>
 <20090923011758.GC6382@localhost>
 <20090922182832.28e7f73a.akpm@linux-foundation.org>
 <20090923014500.GA11076@localhost>
 <20090922185941.1118e011.akpm@linux-foundation.org>
 <20090923022622.GB11918@localhost>
 <20090922193622.42c00012.akpm@linux-foundation.org>
 <20090923140058.GA2794@think>
 <20090924031508.GD6456@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924031508.GD6456@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4ABB61BD.0192:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 11:15:08AM +0800, Wu Fengguang wrote:

[ why do the bdi-writeback work? ]

> > 
> > The congestion code was the big reason I got behind Jens' patches.  When
> > working on btrfs I tried to tune the existing congestion based setup to
> > scale well.  What we had before is basically a poll interface hiding
> > behind a queue flag and a wait.  
>  
> So it's mainly about fast array writeback performance. 

You can see the difference on single disks, at least in the two writer
case w/XFS.  But, each FS has its own tweaks in there, and the bigger
arrays show it better across all the filesystems.

> 
> > The only place that actually honors the congestion flag is pdflush.
> > It's trivial to get pdflush backed up and make it sit down without
> > making any progress because once the queue congests, pdflush goes away.
> 
> Right. I guess that's more or less intentional - to give lowest priority
> to periodic/background writeback.

The problem is that when we let pdflush back off, we do all of our IO
from balance_dirty_pages(), which makes much more seeky IO patterns for
the streaming writers.

> 
> > Nothing stops other procs from keeping the queue congested forever.
> > This can only be fixed by making everyone wait for congestion, at which
> > point we might as well wait for requests.
> 
> Yes. That gives everyone somehow equal opportunity, this is a policy change
> that may lead to interesting effects, as well as present a challenge to
> get_request_wait(). That said, I'm not against the change to a wait queue
> in general.

I very much agree here, relying more on get_request_wait is going to
expose some latency differences.

> 
> > Here are some graphs comparing 2.6.31 and 2.6.31 with Jens' latest code.
> > The workload is two procs doing streaming writes to 32GB files.  I've
> > used deadline and bumped nr_requests to 2048, so pdflush should be able
> > to do a significant amount of work between congestion cycles.
> 
> The graphs show near 400MB/s throughput and about 4000-17000IO/s.
> 
> Writeback traces show that my 2Ghz laptop CPU can do IO submissions
> up to 400MB/s. It takes about 0.01s to sync 4MB (one wb_kupdate =>
> write_cache_pages traverse).
> 
> Given nr_requests=2048 and IOPS=10000, a congestion on-off cycle would
> take (2048/16)/10000 = 0.0128s
> 
> The 0.0128s vs. 0.01s means that CPU returns just in time to see a
> still congested but will soon become !congested queue. It then returns
> to do congestion_wait, and be wakeup by the io completion events when
> queue goes !congested. The return to write_cache_pages will again take
> some time. So the end result may be, queue falls to 6/8 full, much below
> the congestion off threshold 13/16.
> 
> Without congestion_wait, you get 100% full queue with get_request_wait. 
> 
> However I don't think the queue fullness can explain the performance
> gain. It's sequential IO. It will only hurt performance if the queue
> sometimes endangers starvation - which could happen when CPU is 100%
> utilized so that IO submission cannot keep up. The congestion_wait
> polls do eat more CPU power. It might impact the response to hard/soft
> interrupts.

I think you're right that queue fullness alone can't explain things,
especially with streaming writes where the requests tend to be very
large.  LVM devices are a bit strange because they go in and out of
congestion based on any of the devices in the stripe set, so
things are less predictable.

The interesting difference between the XFS graph and the
btrfs graph is that btrfs has removed all congestion checks from its
write_cache_pages(), so btrfs is forcing pdflush to hang around even
when the queue is initially congested so that it can write a large
portion of an extent in each call.

This is why the btrfs IO graphs look the same for the two runs, the IO
submitted is basically the same.  The bdi thread is just submitting it
more often.

> 
> > The hardware is 5 sata drives pushed into an LVM stripe set.
> > 
> > http://oss.oracle.com/~mason/seekwatcher/bdi-writeback/xfs-streaming-compare.png
> > http://oss.oracle.com/~mason/seekwatcher/bdi-writeback/btrfs-streaming-compare.png
> > 
> > In the mainline graphs, pdflush is actually doing the vast majority of
> > the IO thanks to Richard's fix:
> > 
> > http://oss.oracle.com/~mason/seekwatcher/bdi-writeback/xfs-mainline-per-process.png
> > 
> > We can see there are two different pdflush procs hopping in and out
> > of the work.
> 
> Yeah, that's expected. May eat some CPU cycles (race and locality issues).
> 
> > This isn't a huge problem, except that we're also hopping between
> > files.
> 
> Yes, this is a problem. When encountered congestion, it may happen
> that the file be synced only a dozen pages (which is very inefficient)
> and then get redirty_tail (which may further delay this inode).
> 
> > I don't think this is because anyone broke pdflush, I think this is
> > because very fast hardware goes from congested to uncongested 
> > very quickly, even when we bump nr_requests to 2048 like I did in the
> > graphs above.
> 
> What's typical CPU utilization during the test? It would be
> interesting to do a comparison on %system numbers between the
> poll/wait approaches.

XFS averages about 20-30% CPU utilization.  Btrfs is much higher because
it is checksumming.

> 
> > The pdflush congestion backoffs skip the batching optimizations done by
> > the elevator.  pdflush could easily have waited in get_request_wait,
> > been given a nice fat batch of requests and then said oh no, the queue
> > is congested, I'll just sleep for a while without submitting any more
> > IO.
> 
> I'd be surprised if the deadline batching is affected by the
> interleaveness of incoming requests. Unless there are many expired
> requests, which could happen when nr_requests is too large for the
> device, which is not in your case.
> 
> I noticed that XFS's IOPS is almost doubled. While btrfs's IOPS and
> throughput scales up by the same factor. The numbers show that the
> average IO size for btrfs is near 64KB, is this your max_sectors_kb?
> XFS's avg io size is a smaller 24kb, does that mean many small
> metadata ios?

Since the traces were done on LVM, the IOPS come from the blktrace Q
events.  This means the IOPS graph basically reflects calls to
submit_bio and does not include any merging.

Btrfs does have an internal max of 64KB, but I'm not sure why xfs is
building smaller bios.  ext4 only builds 4k bios, and it is able to
perform just as well ;)

> 
> > The congestion checks prevent any attempts from the filesystem to write
> > a whole extent (or a large portion of an extent) at a time.
> 
> Since writepage is called one by one for each page, will its
> interleaveness impact filesystem decisions? Ie. between these two
> writepage sequences.
> 
>         A1, B1, A2, B2, A3, B3, A4, B4
>         A1, A2, A3, A4, B1, B2, B3, B4
> 
> Where each An/Bn stands for one page of file A/B, n is page index.

For XFS this is the key question.  We're doing streaming writes, so the
delayed allocation code is responsible for allocating extents, and this
is triggered from writepage.  Your first example becomes:

         A1 [allocate extent A1-A50 ], submit A1
	 B1 [allocate extent B1-B50 ], submit B1 (seek)
	 A2, (seek back to A1's extent)
	 B2, (seek back to B1's extent)
	 ...

This is why the XFS graph for pdflush isn't a straight line.   When we
back off file A and switch to file B, we seek between extents created by
delalloc.

Thanks for spending time reading through all of this.  It's a ton of data
and your improvements are much appreciated!

-chris

