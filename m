Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592Ab0AMWWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab0AMWWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 17:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519Ab0AMWWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 17:22:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823Ab0AMWV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 17:21:59 -0500
Date: Wed, 13 Jan 2010 17:21:49 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] cfq-iosched: rework seeky detection
Message-ID: <20100113222149.GJ6123@redhat.com>
References: <1263052757-23436-1-git-send-email-czoccolo@gmail.com> <20100112191257.GE3065@redhat.com> <4e5e476b1001121205u4fd487b7o2ee6dd42c8740955@mail.gmail.com> <20100112223638.GH3065@redhat.com> <4e5e476b1001121517y5ebdd6ebt7ade0b4ac068655b@mail.gmail.com> <20100113201042.GD6123@redhat.com> <4e5e476b1001131324t148d195cp7ad92e7edf8325fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b1001131324t148d195cp7ad92e7edf8325fb@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 10:24:14PM +0100, Corrado Zoccolo wrote:
> Hi Vivek,
> On Wed, Jan 13, 2010 at 9:10 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > Hi Corrado,
> >
> > I have run some more tests. For direct sequential I/Os I do not see BW
> > improvements as I increase number of processes. Which is kind of expected
> > as these are sync-idle workload and we will continue to drive queue depth
> > as 1.
> 
> 
> Ok. But the deadline numbers tell us what we could achieve if, for example,
> we decided that queues issuing too small requests are marked as noidle.
> 

Upon successful detection of RAID. Or if we do it irrespective of
underlying storage, then you will gain on RAIDs but can loose on single
spindle. Might see excessive seeks (direct sequential IO).

> 
> > I do see that as number of processes increase, BW goes down. Not
> > sure why. May be some readahead data in hardware gets trashed. ?
> >
> 
> Likely, when cfq switches from one process to an other, the disk's cache
> still contains some useful data. If there are too many reads before the same
> process comes back, the cache will be flushed, and you have to re-read that
> data again.
> This is why we should have a certain number of active queues, instead of
> cycling all the queues.

But then you will be starving non-active queues or will increase max
latency. I guess bigger slice for each queue should achive similar effect
but i did not see significant gains with low_latency=0.
 
> 
> vanilla (1,2,4,8,16,32,64 processses, direct=1, seq, size=4G, bs=64K)
> > =========
> > cfq
> > ---
> > aggrb=279MB/s,
> > aggrb=277MB/s,
> > aggrb=276MB/s,
> > aggrb=263MB/s,
> > aggrb=262MB/s,
> > aggrb=214MB/s,
> > aggrb=99MB/s,
> >
> > Especially look at BW drop when numjobs=64.
> >
> > deadline's numbers look a lot better.
> >
> > deadline
> > ------------
> > aggrb=271MB/s,
> > aggrb=385MB/s,
> > aggrb=386MB/s,
> > aggrb=385MB/s,
> > aggrb=384MB/s,
> > aggrb=356MB/s,
> > aggrb=257MB/s,
> >
> >
> This shows that the optimal queue depth is around 2-4.

I think much more than that. In case of deadline we saw performance 
drop in 32 processes. Till 16 processes it was just fine. So I would say
16 is the optimal queue depth in this case. This is further verified by
cfq numbers with slice_idle=0 below.

> 
> 
> > Above numbers can almost be met if slice_idle=0 with cfq
> >
> > cfq (slice_idle=0)
> > ------------------
> > aggrb=278MB/s,
> > aggrb=390MB/s,
> > aggrb=384MB/s,
> > aggrb=386MB/s,
> > aggrb=383MB/s,
> > aggrb=350MB/s,
> > aggrb=261MB/s,
> >
> >
> > >
> > > >> Until we can, we should optimize for the most common case.
> > > >
> > > > Hard to say what's the common case? Single rotational disks or
> > enterprise
> > > > storage with multiple disks behind RAID cards.
> > >
> > > I think the pattern produced by mmap 64k is uncommon for reading data,
> > while
> > > it is common for binaries. And binaries, even in enterprise machines,
> > > are usually
> > > not put on the large raids.
> > >
> >
> > Not large raids but root can very well be on small RAID (3-4 disks).
> >
>  On 3-4 disks, probably the optimal queue depth is 1.
> 
> > > >
> > > >>
> > > >> Also, does the performance drop when the number of processes
> > > >> approaches 8*number of spindles?
> > > >
> > > > I think here performance drop will be limited by queue depth. So once
> > you
> > > > have more than 32 processes driving queue depth 32, it should not
> > matter
> > > > how many processes you launch in parallel.
> > > Yes. With 12 disks it is unlikely to reach the saturation point.
> > > >
> > > > I have collected some numbers for running 1,2,4,8,32 and 64 threads in
> > > > parallel and see how throughput varies with vanilla kernel and with
> > your
> > > > patch.
> > > >
> > > > Vanilla kernel
> > > > ==============
> > > > aggrb=2,771KB/s,
> > > > aggrb=2,779KB/s,
> > > > aggrb=3,084KB/s,
> > > > aggrb=3,623KB/s,
> > > > aggrb=3,847KB/s,
> > > > aggrb=3,940KB/s,
> > > > aggrb=4,216KB/s,
> > > >
> > > > Patched kernel
> > > > ==============
> > > > aggrb=2,778KB/s,
> > > > aggrb=2,447KB/s,
> > > > aggrb=2,240KB/s,
> > > > aggrb=2,182KB/s,
> > > > aggrb=2,082KB/s,
> > > > aggrb=2,033KB/s,
> > > > aggrb=1,672KB/s,
> > > >
> > > > With vanilla kernel, output is on the rise as number of threads doing
> > IO
> > > > incrases and with patched kernel it is falling as number of threads
> > > > rise. This is not pretty.
> > > This is strange. we force the depth to be 1, but the BW should be stable.
> > > What happens if you disable low_latency?
> > > And can you compare it with 2.6.32?
> >
> > Disabling low_latency did not help much.
> >
> >
> cfq, low_latency=0
> > ------------------
> > aggrb=2,755KB/s,
> > aggrb=2,374KB/s,
> > aggrb=2,225KB/s,
> > aggrb=2,174KB/s,
> > aggrb=2,007KB/s,
> > aggrb=1,904KB/s,
> > aggrb=1,856KB/s,
> >
> > Looking at those numbers, it seems that an average seek costs you 23ms. Is
> this possible?
> (64kb / 2770 kb/s = 23ms)
> Maybe the firmware of your RAID card implements idling internally?
> 

I have no idea about firmware implementation. I ran mmap, bs=64K testcase
with deadline also on same hardware.

deadline
========
aggrb=2,754KB/s,
aggrb=3,212KB/s,
aggrb=3,838KB/s,
aggrb=4,017KB/s,
aggrb=3,974KB/s,
aggrb=4,628KB/s,
aggrb=6,124KB/s,

Look with even 64 processes, BW is on the rise. So I guess there is no
idling in firmware otherwise we would have seen BW kind of stablized. But
you never know.

This is also baffeling that why I am not getting same result with CFQ.
Currently CFQ will mark mmap queues as sync-noidle and then we should be
driving queue depth 32 like deadline and should have got same numbers. But
does not seem to be happeing. CFQ is bit behind especially in the case of
64 processes.

> On a side note, I also did some tests with multiple buffered sequential
> > read streams. Here are the results.
> >
> > Vanilla (buffered seq reads, size=4G, bs=64K, 1,2,4,8,16,32,64 processes)
> > ===================================================
> > cfq (low_latency=1)
> > -------------------
> > aggrb=372MB/s,
> > aggrb=326MB/s,
> > aggrb=319MB/s,
> > aggrb=272MB/s,
> > aggrb=250MB/s,
> > aggrb=200MB/s,
> > aggrb=186MB/s,
> >
> > cfq (low_latency=0)
> > ------------------
> > aggrb=370MB/s,
> > aggrb=325MB/s,
> > aggrb=330MB/s,
> > aggrb=311MB/s,
> > aggrb=206MB/s,
> > aggrb=264MB/s,
> > aggrb=157MB/s,
> >
> > cfq (slice_idle=0)
> > ------------------
> > aggrb=372MB/s,
> > aggrb=383MB/s,
> > aggrb=387MB/s,
> > aggrb=382MB/s,
> > aggrb=378MB/s,
> > aggrb=372MB/s,
> > aggrb=230MB/s,
> >
> > deadline
> > --------
> > aggrb=380MB/s,
> > aggrb=381MB/s,
> > aggrb=386MB/s,
> > aggrb=383MB/s,
> > aggrb=382MB/s,
> > aggrb=370MB/s,
> > aggrb=234MB/s,
> >
> > Notes(For this workload on this hardware):
> >
> > - It is hard to beat deadline. cfq with slice_idle=0 is almost there.
> >
> 
> When slice_idle = 0, cfq works much more like noop (just with better control
> of write depth).
> 
> - low_latency=0 is not significantly better than low_latency=1.
> >
> 
> Good. At least it doesn't introduce regression in those workloads.
> 
> 
> > - driving queue depth 1, hurts on large RAIDs even for buffered sequtetial
> >  reads. readahead can only help this much. It does not fully compensate for
> >  the fact that there are more spindles and we can get more out of array if
> >  we drive deeper queue depths.
> >
> >  This is one data point for the discussion we were having in another thread
> >  where I was suspecting that driving shallower queue depth might hurt on
> >  large arrays even with readahed.
> >
> 
> Well, it is just a 2% improvement (look at deadline numbers, 1:380,
> best:386), so I think readahead is enough for the buffered case.

But in cfq as number of processes increase, throughput drops. But does not
happen with deadline. So driving deeper queue depths on RAIDs is good for
throughput. What amuses me is that with 16 processes, deadline is still
clocking 382MB/s and cfq is 250MB/s. Why this difference of 130MB/s. Can
you think of anything else apart from shallower queue depths in cfq. Even
low_latency=0 did not help. In fact for 16 processes throughput dropped to
206MB/s. So somehow giving bigger time slices did not help.

> In case of small requests, though, we are paying too much.
> I think that simply marking queues with too small requests as no-idle should
> be a win here (when we can identify RAIDs reliably).
> 
> Thanks,
> Corrado
> 
> Thanks
> > Vivek
> >
