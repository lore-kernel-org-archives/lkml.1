Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654Ab0AMULA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab0AMULA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 15:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076Ab0AMULA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 15:11:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab0AMUK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 15:10:59 -0500
Date: Wed, 13 Jan 2010 15:10:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] cfq-iosched: rework seeky detection
Message-ID: <20100113201042.GD6123@redhat.com>
References: <1263052757-23436-1-git-send-email-czoccolo@gmail.com> <20100112191257.GE3065@redhat.com> <4e5e476b1001121205u4fd487b7o2ee6dd42c8740955@mail.gmail.com> <20100112223638.GH3065@redhat.com> <4e5e476b1001121517y5ebdd6ebt7ade0b4ac068655b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b1001121517y5ebdd6ebt7ade0b4ac068655b@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 12:17:16AM +0100, Corrado Zoccolo wrote:
> On Tue, Jan 12, 2010 at 11:36 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Tue, Jan 12, 2010 at 09:05:29PM +0100, Corrado Zoccolo wrote:
> >> Hi Vivek,
> >> On Tue, Jan 12, 2010 at 8:12 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > On Sat, Jan 09, 2010 at 04:59:17PM +0100, Corrado Zoccolo wrote:
> >> >> Current seeky detection is based on average seek lenght.
> >> >> This is suboptimal, since the average will not distinguish between:
> >> >> * a process doing medium sized seeks
> >> >> * a process doing some sequential requests interleaved with larger seeks
> >> >> and even a medium seek can take lot of time, if the requested sector
> >> >> happens to be behind the disk head in the rotation (50% probability).
> >> >>
> >> >> Therefore, we change the seeky queue detection to work as follows:
> >> >> * each request can be classified as sequential if it is very close to
> >> >>   the current head position, i.e. it is likely in the disk cache (disks
> >> >>   usually read more data than requested, and put it in cache for
> >> >>   subsequent reads). Otherwise, the request is classified as seeky.
> >> >> * an history window of the last 32 requests is kept, storing the
> >> >>   classification result.
> >> >> * A queue is marked as seeky if more than 1/8 of the last 32 requests
> >> >>   were seeky.
> >> >>
> >> >> This patch fixes a regression reported by Yanmin, on mmap 64k random
> >> >> reads.
> >> >>
> >> >
> >> > Ok, I did basic testing of this patch on my hardware. I got a RAID-0
> >> > configuration and there are 12 disks behind it. I ran 8 fio mmap random
> >> > read processes with block size 64K and following are the results.
> >> >
> >> > Vanilla (3 runs)
> >> > ===============
> >> > aggrb=3,564KB/s (cfq)
> >> > aggrb=3,600KB/s (cfq)
> >> > aggrb=3,607KB/s (cfq)
> >> >
> >> > aggrb=3,992KB/s,(deadline)
> >> > aggrb=3,953KB/s (deadline)
> >> > aggrb=3,991KB/s (deadline)
> >> >
> >> > Patched kernel (3 runs)
> >> > =======================
> >> > aggrb=2,080KB/s (cfq)
> >> > aggrb=2,100KB/s (cfq)
> >> > aggrb=2,124KB/s (cfq)
> >> >
> >> > My fio script
> >> > =============
> >> > [global]
> >> > directory=/mnt/sda/fio/
> >> > size=8G
> >> > direct=0
> >> > runtime=30
> >> > ioscheduler=cfq
> >> > exec_prerun="echo 3 > /proc/sys/vm/drop_caches"
> >> > group_reporting=1
> >> > ioengine=mmap
> >> > rw=randread
> >> > bs=64K
> >> >
> >> > [randread]
> >> > numjobs=8
> >> > =================================
> >> >
> >> > There seems to be around more than 45% regression in this case.
> >> >
> >> > I have not run the blktrace, but I suspect it must be coming from the fact
> >> > that we are now treating a random queue as sync-idle hence driving queue
> >> > depth as 1. But the fact is that read ahead much not be kicking in, so
> >> > we are not using the power of parallel processing this striped set of
> >> > disks can do for us.
> >> >
> >> Yes. Those results are expected, and are the other side of the medal.
> >> If we handle those queues as sync-idle, we get better performance
> >> on single disk (and regression on RAIDs), and viceversa if we handle
> >> them as sync-noidle.
> >>
> >> Note that this is limited to mmap with large block size. Normal read/pread
> >> is not affected.
> >>
> >> > So treating this kind of cfqq as sync-idle seems to be a bad idea atleast
> >> > on configurations where multiple disks are in raid configuration.
> >>
> >> The fact is, can we reliably determine which of those two setups we
> >> have from cfq?
> >
> > I have no idea at this point of time but it looks like determining this
> > will help.
> >
> > May be something like keep a track of number of processes on "sync-noidle"
> > tree and average read times when sync-noidle tree is being served. Over a
> > period of time we need to monitor what's the number of processes
> > (threshold), after which average read time goes up. For sync-noidle we can
> > then drive "queue_depth=nr_thrshold" and once queue depth reaches that,
> > then idle on the process. So for single spindle, I guess tipping point
> > will be 2 processes and we can idle on sync-noidle process. For more
> > spindles, tipping point will be higher.
> >
> > These are just some random thoughts.
> It seems reasonable.
> Something similar to what we do to reduce depth for async writes.
> Can you see if you get similar BW improvements also for parallel
> sequential direct I/Os with block size < stripe size?
> 

Hi Corrado,

I have run some more tests. For direct sequential I/Os I do not see BW
improvements as I increase number of processes. Which is kind of expected
as these are sync-idle workload and we will continue to drive queue depth
as 1. I do see that as number of processes increase, BW goes down. Not
sure why. May be some readahead data in hardware gets trashed. ?

vanilla (1,2,4,8,16,32,64 processses, direct=1, seq, size=4G, bs=64K)
=========
cfq
---
aggrb=279MB/s,
aggrb=277MB/s,
aggrb=276MB/s,
aggrb=263MB/s,
aggrb=262MB/s,
aggrb=214MB/s,
aggrb=99MB/s,

Especially look at BW drop when numjobs=64.

deadline's numbers look a lot better.

deadline
------------
aggrb=271MB/s,
aggrb=385MB/s,
aggrb=386MB/s,
aggrb=385MB/s,
aggrb=384MB/s,
aggrb=356MB/s,
aggrb=257MB/s,

Above numbers can almost be met if slice_idle=0 with cfq

cfq (slice_idle=0)
------------------
aggrb=278MB/s,
aggrb=390MB/s,
aggrb=384MB/s,
aggrb=386MB/s,
aggrb=383MB/s,
aggrb=350MB/s,
aggrb=261MB/s,

> >
> >> Until we can, we should optimize for the most common case.
> >
> > Hard to say what's the common case? Single rotational disks or enterprise
> > storage with multiple disks behind RAID cards.
> 
> I think the pattern produced by mmap 64k is uncommon for reading data, while
> it is common for binaries. And binaries, even in enterprise machines,
> are usually
> not put on the large raids.
> 

Not large raids but root can very well be on small RAID (3-4 disks).

> >
> >>
> >> Also, does the performance drop when the number of processes
> >> approaches 8*number of spindles?
> >
> > I think here performance drop will be limited by queue depth. So once you
> > have more than 32 processes driving queue depth 32, it should not matter
> > how many processes you launch in parallel.
> Yes. With 12 disks it is unlikely to reach the saturation point.
> >
> > I have collected some numbers for running 1,2,4,8,32 and 64 threads in
> > parallel and see how throughput varies with vanilla kernel and with your
> > patch.
> >
> > Vanilla kernel
> > ==============
> > aggrb=2,771KB/s,
> > aggrb=2,779KB/s,
> > aggrb=3,084KB/s,
> > aggrb=3,623KB/s,
> > aggrb=3,847KB/s,
> > aggrb=3,940KB/s,
> > aggrb=4,216KB/s,
> >
> > Patched kernel
> > ==============
> > aggrb=2,778KB/s,
> > aggrb=2,447KB/s,
> > aggrb=2,240KB/s,
> > aggrb=2,182KB/s,
> > aggrb=2,082KB/s,
> > aggrb=2,033KB/s,
> > aggrb=1,672KB/s,
> >
> > With vanilla kernel, output is on the rise as number of threads doing IO
> > incrases and with patched kernel it is falling as number of threads
> > rise. This is not pretty.
> This is strange. we force the depth to be 1, but the BW should be stable.
> What happens if you disable low_latency?
> And can you compare it with 2.6.32?

Disabling low_latency did not help much.

cfq, low_latency=0
------------------
aggrb=2,755KB/s,
aggrb=2,374KB/s,
aggrb=2,225KB/s,
aggrb=2,174KB/s,
aggrb=2,007KB/s,
aggrb=1,904KB/s,
aggrb=1,856KB/s,

On a side note, I also did some tests with multiple buffered sequential
read streams. Here are the results.

Vanilla (buffered seq reads, size=4G, bs=64K, 1,2,4,8,16,32,64 processes)
===================================================
cfq (low_latency=1)
-------------------
aggrb=372MB/s,
aggrb=326MB/s,
aggrb=319MB/s,
aggrb=272MB/s,
aggrb=250MB/s,
aggrb=200MB/s,
aggrb=186MB/s,

cfq (low_latency=0)
------------------
aggrb=370MB/s,
aggrb=325MB/s,
aggrb=330MB/s,
aggrb=311MB/s,
aggrb=206MB/s,
aggrb=264MB/s,
aggrb=157MB/s,

cfq (slice_idle=0)
------------------
aggrb=372MB/s,
aggrb=383MB/s,
aggrb=387MB/s,
aggrb=382MB/s,
aggrb=378MB/s,
aggrb=372MB/s,
aggrb=230MB/s,

deadline
--------
aggrb=380MB/s,
aggrb=381MB/s,
aggrb=386MB/s,
aggrb=383MB/s,
aggrb=382MB/s,
aggrb=370MB/s,
aggrb=234MB/s,

Notes(For this workload on this hardware):

- It is hard to beat deadline. cfq with slice_idle=0 is almost there.

- low_latency=0 is not significantly better than low_latency=1.

- driving queue depth 1, hurts on large RAIDs even for buffered sequtetial
  reads. readahead can only help this much. It does not fully compensate for
  the fact that there are more spindles and we can get more out of array if
  we drive deeper queue depths.

  This is one data point for the discussion we were having in another thread
  where I was suspecting that driving shallower queue depth might hurt on
  large arrays even with readahed.

Thanks
Vivek
