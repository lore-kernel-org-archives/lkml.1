Return-Path: <linux-kernel-owner+w=401wt.eu-S1762266AbZATNqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbZATNqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762063AbZATNpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:45:43 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:36656 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762051AbZATNpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:45:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAPJfdUlMQWt2/2dsb2JhbACBbMk3hXM
Date: Tue, 20 Jan 2009 08:45:39 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       Andrea Arcangeli <andrea@suse.de>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [ltt-dev] [RFC PATCH] block: Fix bio merge induced high I/O
	latency
Message-ID: <20090120134539.GC22421@Krystal>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal> <20090117190437.GZ30821@kernel.dk> <20090118211234.GA4913@Krystal> <20090119182654.GT30821@kernel.dk> <20090120021055.GA6990@Krystal> <20090120073709.GC30821@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090120073709.GC30821@kernel.dk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:15:27 up 19 days, 13:13,  2 users,  load average: 0.18, 0.40,
	0.50
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe (jens.axboe@oracle.com) wrote:
> On Mon, Jan 19 2009, Mathieu Desnoyers wrote:
> > * Jens Axboe (jens.axboe@oracle.com) wrote:
> > > On Sun, Jan 18 2009, Mathieu Desnoyers wrote:
> > > > I looked at the "ls" behavior (while doing a dd) within my LTTng trace
> > > > to create a fio job file.  The said behavior is appended below as "Part
> > > > 1 - ls I/O behavior". Note that the original "ls" test case was done
> > > > with the anticipatory I/O scheduler, which was active by default on my
> > > > debian system with custom vanilla 2.6.28 kernel. Also note that I am
> > > > running this on a raid-1, but have experienced the same problem on a
> > > > standard partition I created on the same machine.
> > > > 
> > > > I created the fio job file appended as "Part 2 - dd+ls fio job file". It
> > > > consists of one dd-like job and many small jobs reading as many data as
> > > > ls did. I used the small test script to batch run this ("Part 3 - batch
> > > > test").
> > > > 
> > > > The results for the ls-like jobs are interesting :
> > > > 
> > > > I/O scheduler        runt-min (msec)   runt-max (msec)
> > > > noop                       41             10563
> > > > anticipatory               63              8185
> > > > deadline                   52             33387
> > > > cfq                        43              1420
> > > 
> > 
> > Extra note : I have a HZ=250 on my system. Changing to 100 or 1000 did
> > not make much difference (also tried with NO_HZ enabled).
> > 
> > > Do you have queuing enabled on your drives? You can check that in
> > > /sys/block/sdX/device/queue_depth. Try setting those to 1 and retest all
> > > schedulers, would be good for comparison.
> > > 
> > 
> > Here are the tests with a queue_depth of 1 :
> > 
> > I/O scheduler        runt-min (msec)   runt-max (msec)
> > noop                       43             38235
> > anticipatory               44              8728
> > deadline                   51             19751
> > cfq                        48               427
> > 
> > 
> > Overall, I wouldn't say it makes much difference.
> 
> 0,5 seconds vs 1,5 seconds isn't much of a difference?
> 

threefold.. yes, that's significant, but not in term of usability in
that specific case.

> > > raid personalities or dm complicates matters, since it introduces a
> > > disconnect between 'ls' and the io scheduler at the bottom...
> > > 
> > 
> > Yes, ideally I should re-run those directly on the disk partitions.
> 
> At least for comparison.
> 

Here it is. ssh test done on /dev/sda directly

queue_depth=31 (default)
/sys/block/sda/queue/iosched/slice_async_rq = 2 (default)
/sys/block/sda/queue/iosched/quantum = 4 (default)

I/O scheduler        runt-min (msec)   runt-max (msec)
noop                      612            205684
anticipatory              562              5555 
deadline                  505            113153          
cfq                       523              6637

> > I am also tempted to create a fio job file which acts like a ssh server
> > receiving a connexion after it has been pruned from the cache while the
> > system if doing heavy I/O. "ssh", in this case, seems to be doing much
> > more I/O than a simple "ls", and I think we might want to see if cfq
> > behaves correctly in such case. Most of this I/O is coming from page
> > faults (identified as traps in the trace) probably because the ssh
> > executable has been thrown out of the cache by
> > 
> > echo 3 > /proc/sys/vm/drop_caches
> > 
> > The behavior of an incoming ssh connexion after clearing the cache is
> > appended below (Part 1 - LTTng trace for incoming ssh connexion). The
> > job file created (Part 2) reads, for each job, a 2MB file with random
> > reads each between 4k-44k. The results are very interesting for cfq :
> > 
> > I/O scheduler        runt-min (msec)   runt-max (msec)
> > noop                       586           110242
> > anticipatory               531            26942
> > deadline                   561           108772
> > cfq                        523            28216
> > 
> > So, basically, ssh being out of the cache can take 28s to answer an
> > incoming ssh connexion even with the cfq scheduler. This is not exactly
> > what I would call an acceptable latency.
> 
> At some point, you have to stop and consider what is acceptable
> performance for a given IO pattern. Your ssh test case is purely random
> IO, and neither CFQ nor AS would do any idling for that. We can make
> this test case faster for sure, the hard part is making sure that we
> don't regress on async throughput at the same time.
> 
> Also remember that with your raid1, it's not entirely reasonable to
> blaim all performance issues on the IO scheduler as per my previous
> mail. It would be a lot more fair to view the disk numbers individually.
> 
> Can you retry this job with 'quantum' set to 1 and 'slice_async_rq' set
> to 1 as well?
> 

Sure, ssh test done on /dev/sda

queue_depth=31 (default)
/sys/block/sda/queue/iosched/slice_async_rq = 1
/sys/block/sda/queue/iosched/quantum = 1

I/O scheduler        runt-min (msec)   runt-max (msec)
cfq (default)             523              6637
cfq (s_rq=1,q=1)          503              6743

It did not do much difference.

Mathieu


> However, I think we should be doing somewhat better at this test case.
> 
> -- 
> Jens Axboe
> 
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
