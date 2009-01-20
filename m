Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbZATHiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbZATHiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 02:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbZATHim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 02:38:42 -0500
Received: from brick.kernel.dk ([93.163.65.50]:15338 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbZATHil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 02:38:41 -0500
Date: Tue, 20 Jan 2009 08:37:10 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrea Arcangeli <andrea@suse.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
Message-ID: <20090120073709.GC30821@kernel.dk>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal> <20090117190437.GZ30821@kernel.dk> <20090118211234.GA4913@Krystal> <20090119182654.GT30821@kernel.dk> <20090120021055.GA6990@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120021055.GA6990@Krystal>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19 2009, Mathieu Desnoyers wrote:
> * Jens Axboe (jens.axboe@oracle.com) wrote:
> > On Sun, Jan 18 2009, Mathieu Desnoyers wrote:
> > > I looked at the "ls" behavior (while doing a dd) within my LTTng trace
> > > to create a fio job file.  The said behavior is appended below as "Part
> > > 1 - ls I/O behavior". Note that the original "ls" test case was done
> > > with the anticipatory I/O scheduler, which was active by default on my
> > > debian system with custom vanilla 2.6.28 kernel. Also note that I am
> > > running this on a raid-1, but have experienced the same problem on a
> > > standard partition I created on the same machine.
> > > 
> > > I created the fio job file appended as "Part 2 - dd+ls fio job file". It
> > > consists of one dd-like job and many small jobs reading as many data as
> > > ls did. I used the small test script to batch run this ("Part 3 - batch
> > > test").
> > > 
> > > The results for the ls-like jobs are interesting :
> > > 
> > > I/O scheduler        runt-min (msec)   runt-max (msec)
> > > noop                       41             10563
> > > anticipatory               63              8185
> > > deadline                   52             33387
> > > cfq                        43              1420
> > 
> 
> Extra note : I have a HZ=250 on my system. Changing to 100 or 1000 did
> not make much difference (also tried with NO_HZ enabled).
> 
> > Do you have queuing enabled on your drives? You can check that in
> > /sys/block/sdX/device/queue_depth. Try setting those to 1 and retest all
> > schedulers, would be good for comparison.
> > 
> 
> Here are the tests with a queue_depth of 1 :
> 
> I/O scheduler        runt-min (msec)   runt-max (msec)
> noop                       43             38235
> anticipatory               44              8728
> deadline                   51             19751
> cfq                        48               427
> 
> 
> Overall, I wouldn't say it makes much difference.

0,5 seconds vs 1,5 seconds isn't much of a difference?

> > raid personalities or dm complicates matters, since it introduces a
> > disconnect between 'ls' and the io scheduler at the bottom...
> > 
> 
> Yes, ideally I should re-run those directly on the disk partitions.

At least for comparison.

> I am also tempted to create a fio job file which acts like a ssh server
> receiving a connexion after it has been pruned from the cache while the
> system if doing heavy I/O. "ssh", in this case, seems to be doing much
> more I/O than a simple "ls", and I think we might want to see if cfq
> behaves correctly in such case. Most of this I/O is coming from page
> faults (identified as traps in the trace) probably because the ssh
> executable has been thrown out of the cache by
> 
> echo 3 > /proc/sys/vm/drop_caches
> 
> The behavior of an incoming ssh connexion after clearing the cache is
> appended below (Part 1 - LTTng trace for incoming ssh connexion). The
> job file created (Part 2) reads, for each job, a 2MB file with random
> reads each between 4k-44k. The results are very interesting for cfq :
> 
> I/O scheduler        runt-min (msec)   runt-max (msec)
> noop                       586           110242
> anticipatory               531            26942
> deadline                   561           108772
> cfq                        523            28216
> 
> So, basically, ssh being out of the cache can take 28s to answer an
> incoming ssh connexion even with the cfq scheduler. This is not exactly
> what I would call an acceptable latency.

At some point, you have to stop and consider what is acceptable
performance for a given IO pattern. Your ssh test case is purely random
IO, and neither CFQ nor AS would do any idling for that. We can make
this test case faster for sure, the hard part is making sure that we
don't regress on async throughput at the same time.

Also remember that with your raid1, it's not entirely reasonable to
blaim all performance issues on the IO scheduler as per my previous
mail. It would be a lot more fair to view the disk numbers individually.

Can you retry this job with 'quantum' set to 1 and 'slice_async_rq' set
to 1 as well?

However, I think we should be doing somewhat better at this test case.

-- 
Jens Axboe

