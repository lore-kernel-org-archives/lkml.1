Return-Path: <linux-kernel-owner+w=401wt.eu-S1758859AbZAVXAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbZAVXAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZAVXAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:00:06 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:53220 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571AbZAVXAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:00:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoYFAAeFeElMQWt2/2dsb2JhbACBbZMWtkSFcw
Date: Thu, 22 Jan 2009 17:59:42 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
Message-ID: <20090122225942.GA9629@Krystal>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal> <20090117190437.GZ30821@kernel.dk> <20090118211234.GA4913@Krystal> <20090119182654.GT30821@kernel.dk> <20090120021055.GA6990@Krystal> <20090120073709.GC30821@kernel.dk> <20090120122855.GF30821@kernel.dk> <20090120232748.GA10605@Krystal> <20090121002507.GA12616@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090121002507.GA12616@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:47:59 up 21 days, 18:46,  4 users,  load average: 0.86, 0.64,
	0.55
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > * Jens Axboe (jens.axboe@oracle.com) wrote:
> > > On Tue, Jan 20 2009, Jens Axboe wrote:
> > > > On Mon, Jan 19 2009, Mathieu Desnoyers wrote:
> > > > > * Jens Axboe (jens.axboe@oracle.com) wrote:
> > > > > > On Sun, Jan 18 2009, Mathieu Desnoyers wrote:
> > > > > > > I looked at the "ls" behavior (while doing a dd) within my LTTng trace
> > > > > > > to create a fio job file.  The said behavior is appended below as "Part
> > > > > > > 1 - ls I/O behavior". Note that the original "ls" test case was done
> > > > > > > with the anticipatory I/O scheduler, which was active by default on my
> > > > > > > debian system with custom vanilla 2.6.28 kernel. Also note that I am
> > > > > > > running this on a raid-1, but have experienced the same problem on a
> > > > > > > standard partition I created on the same machine.
> > > > > > > 
> > > > > > > I created the fio job file appended as "Part 2 - dd+ls fio job file". It
> > > > > > > consists of one dd-like job and many small jobs reading as many data as
> > > > > > > ls did. I used the small test script to batch run this ("Part 3 - batch
> > > > > > > test").
> > > > > > > 
> > > > > > > The results for the ls-like jobs are interesting :
> > > > > > > 
> > > > > > > I/O scheduler        runt-min (msec)   runt-max (msec)
> > > > > > > noop                       41             10563
> > > > > > > anticipatory               63              8185
> > > > > > > deadline                   52             33387
> > > > > > > cfq                        43              1420
> > > > > > 
> > > > > 
> > > > > Extra note : I have a HZ=250 on my system. Changing to 100 or 1000 did
> > > > > not make much difference (also tried with NO_HZ enabled).
> > > > > 
> > > > > > Do you have queuing enabled on your drives? You can check that in
> > > > > > /sys/block/sdX/device/queue_depth. Try setting those to 1 and retest all
> > > > > > schedulers, would be good for comparison.
> > > > > > 
> > > > > 
> > > > > Here are the tests with a queue_depth of 1 :
> > > > > 
> > > > > I/O scheduler        runt-min (msec)   runt-max (msec)
> > > > > noop                       43             38235
> > > > > anticipatory               44              8728
> > > > > deadline                   51             19751
> > > > > cfq                        48               427
> > > > > 
> > > > > 
> > > > > Overall, I wouldn't say it makes much difference.
> > > > 
> > > > 0,5 seconds vs 1,5 seconds isn't much of a difference?
> > > > 
> > > > > > raid personalities or dm complicates matters, since it introduces a
> > > > > > disconnect between 'ls' and the io scheduler at the bottom...
> > > > > > 
> > > > > 
> > > > > Yes, ideally I should re-run those directly on the disk partitions.
> > > > 
> > > > At least for comparison.
> > > > 
> > > > > I am also tempted to create a fio job file which acts like a ssh server
> > > > > receiving a connexion after it has been pruned from the cache while the
> > > > > system if doing heavy I/O. "ssh", in this case, seems to be doing much
> > > > > more I/O than a simple "ls", and I think we might want to see if cfq
> > > > > behaves correctly in such case. Most of this I/O is coming from page
> > > > > faults (identified as traps in the trace) probably because the ssh
> > > > > executable has been thrown out of the cache by
> > > > > 
> > > > > echo 3 > /proc/sys/vm/drop_caches
> > > > > 
> > > > > The behavior of an incoming ssh connexion after clearing the cache is
> > > > > appended below (Part 1 - LTTng trace for incoming ssh connexion). The
> > > > > job file created (Part 2) reads, for each job, a 2MB file with random
> > > > > reads each between 4k-44k. The results are very interesting for cfq :
> > > > > 
> > > > > I/O scheduler        runt-min (msec)   runt-max (msec)
> > > > > noop                       586           110242
> > > > > anticipatory               531            26942
> > > > > deadline                   561           108772
> > > > > cfq                        523            28216
> > > > > 
> > > > > So, basically, ssh being out of the cache can take 28s to answer an
> > > > > incoming ssh connexion even with the cfq scheduler. This is not exactly
> > > > > what I would call an acceptable latency.
> > > > 
> > > > At some point, you have to stop and consider what is acceptable
> > > > performance for a given IO pattern. Your ssh test case is purely random
> > > > IO, and neither CFQ nor AS would do any idling for that. We can make
> > > > this test case faster for sure, the hard part is making sure that we
> > > > don't regress on async throughput at the same time.
> > > > 
> > > > Also remember that with your raid1, it's not entirely reasonable to
> > > > blaim all performance issues on the IO scheduler as per my previous
> > > > mail. It would be a lot more fair to view the disk numbers individually.
> > > > 
> > > > Can you retry this job with 'quantum' set to 1 and 'slice_async_rq' set
> > > > to 1 as well?
> > > > 
> > > > However, I think we should be doing somewhat better at this test case.
> > > 
> > > Mathieu, does this improve anything for you?
> > > 
> > 
> > So, I ran the tests with my corrected patch, and the results are very
> > good !
> > 
> > "incoming ssh connexion" test
> > 
> > "config 2.6.28 cfq"
> > Linux 2.6.28
> > /sys/block/sd{a,b}/device/queue_depth = 31 (default)
> > /sys/block/sd{a,b}/queue/iosched/slice_async_rq = 2 (default)
> > /sys/block/sd{a,b}/queue/iosched/quantum = 4 (default)
> > 
> > "config 2.6.28.1-patch1"
> > Linux 2.6.28.1
> > Corrected cfq patch applied
> > echo 1 > /sys/block/sd{a,b}/device/queue_depth
> > echo 1 > /sys/block/sd{a,b}/queue/iosched/slice_async_rq
> > echo 1 > /sys/block/sd{a,b}/queue/iosched/quantum
> > 
> > On /dev/sda :
> > 
> > I/O scheduler        runt-min (msec)   runt-max (msec)
> > cfq (2.6.28 cfq)          523             6637
> > cfq (2.6.28.1-patch1)     579             2082
> > 
> > On raid1 :
> > 
> > I/O scheduler        runt-min (msec)   runt-max (msec)
> > cfq (2.6.28 cfq)           523            28216
> 
> As a side-note : I'd like to have my results confirmed by others. I just
> found out that my 2 Seagate drives are in the "defect" list
> (ST3500320AS) that exhibits the behavior to stop for about 30s when doing
> "video streaming".
> (http://www.computerworld.com/action/article.do?command=viewArticleBasic&taxonomyName=storage&articleId=9126280&taxonomyId=19&intsrc=kc_top)
> (http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=207931)
> 
> Therefore, I would not take any decision based on such known bad
> firmware. But the last results we've got are definitely interesting.
> 
> I'll upgrade my firmware as soon as Segate puts it back online so I can
> re-run more tests.
> 

After firmware upgrade :

"incoming ssh connexion" test
(ran the job file 2-3 times to get correct runt-max results)

"config 2.6.28.1 dfl"
Linux 2.6.28.1
/sys/block/sd{a,b}/device/queue_depth = 31 (default)
/sys/block/sd{a,b}/queue/iosched/slice_async_rq = 2 (default)
/sys/block/sd{a,b}/queue/iosched/quantum = 4 (default)

"config 2.6.28.1 1"
Linux 2.6.28.1
echo 1 > /sys/block/sd{a,b}/device/queue_depth
echo 1 > /sys/block/sd{a,b}/queue/iosched/slice_async_rq
echo 1 > /sys/block/sd{a,b}/queue/iosched/quantum

"config 2.6.28.1-patch dfl"
Linux 2.6.28.1
Corrected cfq patch applied
/sys/block/sd{a,b}/device/queue_depth = 31 (default)
/sys/block/sd{a,b}/queue/iosched/slice_async_rq = 2 (default)
/sys/block/sd{a,b}/queue/iosched/quantum = 4 (default)

"config 2.6.28.1-patch 1"
Linux 2.6.28.1
Corrected cfq patch applied
echo 1 > /sys/block/sd{a,b}/device/queue_depth
echo 1 > /sys/block/sd{a,b}/queue/iosched/slice_async_rq
echo 1 > /sys/block/sd{a,b}/queue/iosched/quantum

On /dev/sda :

I/O scheduler        runt-min (msec) runt-avg (msec)  runt-max (msec)
cfq (2.6.28.1 dfl)        560            4134.04         12125
cfq (2.6.28.1-patch dfl)  508            4329.75          9625
cfq (2.6.28.1 1)          535            1068.46          2622
cfq (2.6.28.1-patch 1)    511            2239.87          4117

On /dev/md1 (raid1) :

I/O scheduler        runt-min (msec) runt-avg (msec)  runt-max (msec)
cfq (2.6.28.1 dfl)        507            4053.19         26265
cfq (2.6.28.1-patch dfl)  532            3991.75         18567
cfq (2.6.28.1 1)          510            1900.14         27410
cfq (2.6.28.1-patch 1)    539            2112.60         22859


A fio output taken from the raid1 cfq (2.6.28.1-patch 1) run looks like
the following. It's a bit strange that we have readers started earlier
which seems to complete only _after_ more recent readers have.

Excerpt (full output appended after email) :

Jobs: 2 (f=1): [W________________rPPPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 3 (f=1): [W________________rrPPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 3 (f=1): [W________________rrPPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 3 (f=1): [W________________rrPPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 3 (f=1): [W________________rrPPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 4 (f=1): [W________________rrrPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 4 (f=1): [W________________rrrPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 4 (f=1): [W________________rrrPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 4 (f=1): [W________________rrrPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 5 (f=1): [W________________rrrrPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 5 (f=1): [W________________rrrrPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 5 (f=1): [W________________rrrrPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 5 (f=1): [W________________rrrrPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 6 (f=2): [W________________rrrrrPPPPPPPPPPPPPPPPPPPP] [0.0% done] [   560/
Jobs: 5 (f=1): [W________________rrrr_PPPPPPPPPPPPPPPPPPPP] [0.0% done] [  1512/
Jobs: 5 (f=1): [W________________rrrr_PPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 5 (f=1): [W________________rrrr_PPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 6 (f=2): [W________________rrrr_rPPPPPPPPPPPPPPPPPPP] [0.0% done] [   144/
Jobs: 5 (f=1): [W________________rrrr__PPPPPPPPPPPPPPPPPPP] [0.0% done] [  1932/
Jobs: 5 (f=1): [W________________rrrr__PPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 5 (f=1): [W________________rrrr__IPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 6 (f=2): [W________________rrrr__rPPPPPPPPPPPPPPPPPP] [0.0% done] [   608/
Jobs: 6 (f=2): [W________________rrrr__rPPPPPPPPPPPPPPPPPP] [0.0% done] [  1052/
Jobs: 5 (f=1): [W________________rrrr___PPPPPPPPPPPPPPPPPP] [0.0% done] [   388/
Jobs: 5 (f=1): [W________________rrrr___IPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 5 (f=1): [W________________rrrr____PPPPPPPPPPPPPPPPP] [0.0% done] [  2076/
Jobs: 5 (f=5): [W________________rrrr____PPPPPPPPPPPPPPPPP] [49.0% done] [  2936
Jobs: 2 (f=2): [W_________________r______PPPPPPPPPPPPPPPPP] [50.8% done] [  5192
Jobs: 2 (f=2): [W________________________rPPPPPPPPPPPPPPPP] [16.0% done] [   104

Given the numbers I get, I see that runt-max numbers does not appear to
be so high at each job file run, which makes it difficult to compare
them (since you never know if you've hit the worse-case yet). This could
be related to raid1, because I've seen this both with and without your
patch applied, and it only seems to appear on raid1 executions.

However, the patch you sent does not seem to improve the behavior. It
actually makes the average and max latency worse in almost every case.
Changing the queue, slice_async_rq and quantum parameters clearly helps
reducing both avg and max latency.

Mathieu


Full output :

Running cfq
Starting 42 processes

Jobs: 1 (f=1): [W_PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [5.7% done] [     0/
Jobs: 1 (f=1): [W_PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [7.7% done] [     0/
Jobs: 1 (f=1): [W_IPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [9.6% done] [     0/
Jobs: 2 (f=2): [W_rPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [11.1% done] [   979
Jobs: 1 (f=1): [W__PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [10.9% done] [  1098
Jobs: 1 (f=1): [W__PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [12.9% done] [     0
Jobs: 2 (f=2): [W__rPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [112.5% done] [     
Jobs: 2 (f=2): [W__rPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [16.1% done] [  1160
Jobs: 2 (f=1): [W__rPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [15.9% done] [   888
Jobs: 2 (f=1): [W__rPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [16.0% done] [     0
Jobs: 3 (f=2): [W__rrPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 3 (f=2): [W__rrPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 3 (f=2): [W__rrPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 3 (f=2): [W__rrPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 3 (f=3): [W___rrPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [16.7% done] [   660
Jobs: 2 (f=2): [W____rPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [18.0% done] [  2064
Jobs: 1 (f=1): [W_____PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [19.4% done] [  1392
Jobs: 1 (f=1): [W_____PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [20.6% done] [     0
Jobs: 2 (f=2): [W_____rPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [105.0% done] [     
Jobs: 2 (f=2): [W_____rPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [110.0% done] [     
Jobs: 2 (f=2): [W_____rPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [115.0% done] [     
Jobs: 2 (f=2): [W_____rPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [120.0% done] [     
Jobs: 3 (f=3): [W_____rrPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [104.2% done] [     
Jobs: 3 (f=3): [W_____rrPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [108.3% done] [     
Jobs: 3 (f=3): [W_____rrPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [112.5% done] [     
Jobs: 3 (f=3): [W_____rrPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [116.7% done] [     
Jobs: 4 (f=4): [W_____rrrPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [103.6% done] [     
Jobs: 4 (f=4): [W_____rrrPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [107.1% done] [     
Jobs: 4 (f=4): [W_____rrrPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [9.8% done] [   280/
Jobs: 3 (f=3): [W_____r_rPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [34.0% done] [  3624
Jobs: 2 (f=2): [W________rPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [34.0% done] [  2744
Jobs: 1 (f=1): [W_________PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [34.0% done] [  1620
Jobs: 1 (f=1): [W_________PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [34.0% done] [     0
Jobs: 1 (f=1): [W_________PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [34.3% done] [     0
Jobs: 2 (f=2): [W_________rPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [34.9% done] [   116
Jobs: 1 (f=1): [W__________PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [34.9% done] [  1944
Jobs: 1 (f=1): [W__________PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [35.8% done] [     0
Jobs: 1 (f=1): [W__________PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [36.4% done] [     0
Jobs: 2 (f=2): [W__________rPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [36.9% done] [   228
Jobs: 2 (f=2): [W__________rPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [37.2% done] [  1420
Jobs: 1 (f=1): [W___________PPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [37.7% done] [   400
Jobs: 1 (f=1): [W___________PPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [39.1% done] [     0
Jobs: 2 (f=2): [W___________rPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [39.3% done] [   268
Jobs: 2 (f=2): [W___________rPPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [39.5% done] [   944
Jobs: 1 (f=1): [W____________PPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [40.3% done] [   848
Jobs: 1 (f=1): [W____________IPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [40.5% done] [     0
Jobs: 2 (f=2): [W____________rPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [41.0% done] [   400
Jobs: 2 (f=2): [W____________rPPPPPPPPPPPPPPPPPPPPPPPPPPPP] [41.1% done] [  1208
Jobs: 1 (f=1): [W_____________PPPPPPPPPPPPPPPPPPPPPPPPPPPP] [41.9% done] [   456
Jobs: 2 (f=2): [W_____________rPPPPPPPPPPPPPPPPPPPPPPPPPPP] [101.9% done] [     
Jobs: 2 (f=2): [W_____________rPPPPPPPPPPPPPPPPPPPPPPPPPPP] [42.9% done] [   380
Jobs: 2 (f=2): [W_____________rPPPPPPPPPPPPPPPPPPPPPPPPPPP] [43.3% done] [   760
Jobs: 1 (f=1): [W______________PPPPPPPPPPPPPPPPPPPPPPPPPPP] [43.8% done] [   912
Jobs: 2 (f=2): [W______________rPPPPPPPPPPPPPPPPPPPPPPPPPP] [44.2% done] [    44
Jobs: 2 (f=2): [W______________rPPPPPPPPPPPPPPPPPPPPPPPPPP] [44.6% done] [  1020
Jobs: 1 (f=1): [W_______________PPPPPPPPPPPPPPPPPPPPPPPPPP] [45.4% done] [  1008
Jobs: 1 (f=1): [W_______________PPPPPPPPPPPPPPPPPPPPPPPPPP] [46.2% done] [     0
Jobs: 2 (f=2): [W_______________rPPPPPPPPPPPPPPPPPPPPPPPPP] [46.6% done] [    52
Jobs: 2 (f=2): [W_______________rPPPPPPPPPPPPPPPPPPPPPPPPP] [47.0% done] [  1248
Jobs: 1 (f=1): [W________________PPPPPPPPPPPPPPPPPPPPPPPPP] [47.4% done] [   760
Jobs: 1 (f=1): [W________________PPPPPPPPPPPPPPPPPPPPPPPPP] [48.1% done] [     0
Jobs: 2 (f=1): [W________________rPPPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 2 (f=1): [W________________rPPPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 2 (f=1): [W________________rPPPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 2 (f=1): [W________________rPPPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 3 (f=1): [W________________rrPPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 3 (f=1): [W________________rrPPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 3 (f=1): [W________________rrPPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 3 (f=1): [W________________rrPPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 4 (f=1): [W________________rrrPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 4 (f=1): [W________________rrrPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 4 (f=1): [W________________rrrPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 4 (f=1): [W________________rrrPPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 5 (f=1): [W________________rrrrPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 5 (f=1): [W________________rrrrPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 5 (f=1): [W________________rrrrPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 5 (f=1): [W________________rrrrPPPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 6 (f=2): [W________________rrrrrPPPPPPPPPPPPPPPPPPPP] [0.0% done] [   560/
Jobs: 5 (f=1): [W________________rrrr_PPPPPPPPPPPPPPPPPPPP] [0.0% done] [  1512/
Jobs: 5 (f=1): [W________________rrrr_PPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 5 (f=1): [W________________rrrr_PPPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 6 (f=2): [W________________rrrr_rPPPPPPPPPPPPPPPPPPP] [0.0% done] [   144/
Jobs: 5 (f=1): [W________________rrrr__PPPPPPPPPPPPPPPPPPP] [0.0% done] [  1932/
Jobs: 5 (f=1): [W________________rrrr__PPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 5 (f=1): [W________________rrrr__IPPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 6 (f=2): [W________________rrrr__rPPPPPPPPPPPPPPPPPP] [0.0% done] [   608/
Jobs: 6 (f=2): [W________________rrrr__rPPPPPPPPPPPPPPPPPP] [0.0% done] [  1052/
Jobs: 5 (f=1): [W________________rrrr___PPPPPPPPPPPPPPPPPP] [0.0% done] [   388/
Jobs: 5 (f=1): [W________________rrrr___IPPPPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 5 (f=1): [W________________rrrr____PPPPPPPPPPPPPPPPP] [0.0% done] [  2076/
Jobs: 5 (f=5): [W________________rrrr____PPPPPPPPPPPPPPPPP] [49.0% done] [  2936
Jobs: 2 (f=2): [W_________________r______PPPPPPPPPPPPPPPPP] [50.8% done] [  5192
Jobs: 2 (f=2): [W________________________rPPPPPPPPPPPPPPPP] [16.0% done] [   104
Jobs: 2 (f=2): [W________________________rPPPPPPPPPPPPPPPP] [54.7% done] [  1052
Jobs: 1 (f=1): [W_________________________PPPPPPPPPPPPPPPP] [56.6% done] [  1016
Jobs: 1 (f=1): [W_________________________PPPPPPPPPPPPPPPP] [58.1% done] [     0
Jobs: 2 (f=2): [W_________________________rPPPPPPPPPPPPPPP] [59.8% done] [    52
Jobs: 2 (f=2): [W_________________________rPPPPPPPPPPPPPPP] [61.1% done] [  1372
Jobs: 1 (f=1): [W__________________________PPPPPPPPPPPPPPP] [63.2% done] [   652
Jobs: 1 (f=1): [W__________________________PPPPPPPPPPPPPPP] [65.0% done] [     0
Jobs: 2 (f=1): [W__________________________rPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 2 (f=1): [W__________________________rPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 2 (f=1): [W__________________________rPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 2 (f=1): [W__________________________rPPPPPPPPPPPPPP] [0.0% done] [     0/
Jobs: 3 (f=3): [W__________________________rrPPPPPPPPPPPPP] [67.3% done] [  1224
Jobs: 2 (f=2): [W___________________________rPPPPPPPPPPPPP] [68.8% done] [  2124
Jobs: 1 (f=1): [W____________________________PPPPPPPPPPPPP] [69.8% done] [   780
Jobs: 1 (f=1): [W____________________________PPPPPPPPPPPPP] [71.3% done] [     0
Jobs: 2 (f=2): [W____________________________rPPPPPPPPPPPP] [72.9% done] [    84
Jobs: 2 (f=2): [W____________________________rPPPPPPPPPPPP] [73.1% done] [  1312
Jobs: 1 (f=1): [W_____________________________PPPPPPPPPPPP] [73.2% done] [   688
Jobs: 1 (f=1): [W_____________________________PPPPPPPPPPPP] [73.9% done] [     0
Jobs: 2 (f=2): [W_____________________________rPPPPPPPPPPP] [73.6% done] [   476
Jobs: 1 (f=1): [W_____________________________EPPPPPPPPPPP] [73.8% done] [  1608
Jobs: 1 (f=1): [W______________________________PPPPPPPPPPP] [73.9% done] [     0
Jobs: 1 (f=1): [W______________________________PPPPPPPPPPP] [74.1% done] [     0
Jobs: 2 (f=2): [W______________________________rPPPPPPPPPP] [74.7% done] [   228
Jobs: 2 (f=2): [W______________________________rPPPPPPPPPP] [74.8% done] [  1564
Jobs: 1 (f=1): [W_______________________________PPPPPPPPPP] [75.5% done] [   264
Jobs: 1 (f=1): [W_______________________________PPPPPPPPPP] [76.1% done] [     0
Jobs: 2 (f=2): [W_______________________________rPPPPPPPPP] [76.2% done] [   516
Jobs: 1 (f=1): [W________________________________PPPPPPPPP] [75.9% done] [  1532
Jobs: 1 (f=1): [W________________________________PPPPPPPPP] [76.0% done] [     0
Jobs: 1 (f=1): [W________________________________PPPPPPPPP] [76.2% done] [     0
Jobs: 2 (f=2): [W________________________________rPPPPPPPP] [76.5% done] [   768
Jobs: 1 (f=1): [W_________________________________PPPPPPPP] [76.6% done] [  1316
Jobs: 1 (f=1): [W_________________________________PPPPPPPP] [76.7% done] [     0
Jobs: 1 (f=1): [W_________________________________IPPPPPPP] [77.8% done] [     0
Jobs: 2 (f=2): [W_________________________________rPPPPPPP] [77.9% done] [   604
Jobs: 1 (f=1): [W__________________________________IPPPPPP] [78.0% done] [  1444
Jobs: 2 (f=2): [W__________________________________rPPPPPP] [78.2% done] [  1145
Jobs: 1 (f=1): [W___________________________________PPPPPP] [78.3% done] [   932
Jobs: 1 (f=1): [W___________________________________PPPPPP] [79.3% done] [     0
Jobs: 2 (f=2): [W___________________________________rPPPPP] [100.7% done] [     
Jobs: 2 (f=2): [W___________________________________rPPPPP] [80.0% done] [  1012
Jobs: 1 (f=1): [W____________________________________PPPPP] [80.6% done] [  1072
Jobs: 1 (f=1): [W____________________________________PPPPP] [81.6% done] [     0
Jobs: 2 (f=2): [W____________________________________rPPPP] [72.2% done] [    36
Jobs: 2 (f=2): [W____________________________________rPPPP] [82.3% done] [   956
Jobs: 1 (f=1): [W_____________________________________PPPP] [82.9% done] [  1076
Jobs: 1 (f=1): [W_____________________________________PPPP] [83.4% done] [     0
Jobs: 2 (f=2): [W_____________________________________rPPP] [78.2% done] [    48
Jobs: 2 (f=2): [W_____________________________________rPPP] [84.6% done] [  1060
Jobs: 1 (f=1): [W______________________________________PPP] [85.1% done] [   956
Jobs: 1 (f=1): [W______________________________________PPP] [85.7% done] [     0
Jobs: 2 (f=2): [W______________________________________rPP] [86.3% done] [    96
Jobs: 2 (f=2): [W______________________________________rPP] [86.4% done] [   756
Jobs: 1 (f=1): [W_______________________________________PP] [86.9% done] [  1212
Jobs: 1 (f=1): [W_______________________________________PP] [87.5% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [88.6% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [89.1% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [90.2% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [90.8% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [91.4% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [92.5% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [93.1% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [93.6% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [94.2% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [95.3% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [95.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [97.1% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [97.7% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.2% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.8% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.8% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [98.9% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [99.0% done] [     0
Jobs: 1 (f=1): [W_______________________________________PP] [99.0% done] [     0
Jobs: 0 (f=0) [eta 00m:02s]



Mathieu

> Mathieu
> 
> > cfq (2.6.28.1-patch1)      517             3086
> > 
> > It looks like we are getting somewhere :) Are there any specific
> > queue_depth, slice_async_rq, quantum variations you would like to be
> > tested ?
> > 
> > For reference, I attach my ssh-like job file (again) to this mail.
> > 
> > Mathieu
> > 
> > 
> > [job1]
> > rw=write
> > size=10240m
> > direct=0
> > blocksize=1024k
> > 
> > [global]
> > rw=randread
> > size=2048k
> > filesize=30m
> > direct=0
> > bsrange=4k-44k
> > 
> > [file1]
> > startdelay=0
> > 
> > [file2]
> > startdelay=4
> > 
> > [file3]
> > startdelay=8
> > 
> > [file4]
> > startdelay=12
> > 
> > [file5]
> > startdelay=16
> > 
> > [file6]
> > startdelay=20
> > 
> > [file7]
> > startdelay=24
> > 
> > [file8]
> > startdelay=28
> > 
> > [file9]
> > startdelay=32
> > 
> > [file10]
> > startdelay=36
> > 
> > [file11]
> > startdelay=40
> > 
> > [file12]
> > startdelay=44
> > 
> > [file13]
> > startdelay=48
> > 
> > [file14]
> > startdelay=52
> > 
> > [file15]
> > startdelay=56
> > 
> > [file16]
> > startdelay=60
> > 
> > [file17]
> > startdelay=64
> > 
> > [file18]
> > startdelay=68
> > 
> > [file19]
> > startdelay=72
> > 
> > [file20]
> > startdelay=76
> > 
> > [file21]
> > startdelay=80
> > 
> > [file22]
> > startdelay=84
> > 
> > [file23]
> > startdelay=88
> > 
> > [file24]
> > startdelay=92
> > 
> > [file25]
> > startdelay=96
> > 
> > [file26]
> > startdelay=100
> > 
> > [file27]
> > startdelay=104
> > 
> > [file28]
> > startdelay=108
> > 
> > [file29]
> > startdelay=112
> > 
> > [file30]
> > startdelay=116
> > 
> > [file31]
> > startdelay=120
> > 
> > [file32]
> > startdelay=124
> > 
> > [file33]
> > startdelay=128
> > 
> > [file34]
> > startdelay=132
> > 
> > [file35]
> > startdelay=134
> > 
> > [file36]
> > startdelay=138
> > 
> > [file37]
> > startdelay=142
> > 
> > [file38]
> > startdelay=146
> > 
> > [file39]
> > startdelay=150
> > 
> > [file40]
> > startdelay=200
> > 
> > [file41]
> > startdelay=260
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
