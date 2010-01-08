Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878Ab0AHSyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab0AHSyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 13:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994Ab0AHSyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 13:54:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901Ab0AHSyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 13:54:01 -0500
Date: Fri, 8 Jan 2010 13:53:39 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Kirill Afonshin <kirill_nnov@mail.ru>, Jeff Moyer <jmoyer@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need read queue
	merging
Message-ID: <20100108185339.GF22219@redhat.com>
References: <4e5e476b1001051348y4637986epb9b56958c738061a@mail.gmail.com> <E1NSq2i-0000wY-00.kirill_nnov-mail-ru@foot.mail.ru> <4e5e476b1001070538y35143cc8me7443f3eb0d377@mail.gmail.com> <20100107143640.GB7664@redhat.com> <4e5e476b1001070900y4428644bse06d8304cde1a86c@mail.gmail.com> <20100107183710.GC14686@redhat.com> <4e5e476b1001071216k2da28c4awc91c5d0c89013035@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b1001071216k2da28c4awc91c5d0c89013035@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 09:16:30PM +0100, Corrado Zoccolo wrote:
> On Thu, Jan 7, 2010 at 7:37 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Jan 07, 2010 at 06:00:54PM +0100, Corrado Zoccolo wrote:
> >> On Thu, Jan 7, 2010 at 3:36 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > Hi Corrado,
> >> >
> >> > How does idle time value relate to flash card being slower for writes? If
> >> > flash card is slow and we choose to idle on queue (because of direct
> >> > writes), idle time value does not even kick in. We just continue to remain
> >> > on same cfqq and don't do dispatch from next cfqq.
> >> >
> >> > Idle time value will matter only if there was delay from cpu side or from
> >> > workload side in issuing next request after completion of previous one.
> >> >
> >> > Thanks
> >> > Vivek
> >> Hi Vivek,
> >> for me, the optimal idle value should approximate the cost of
> >> switching to an other queue.
> >> So, for reads, if we are waiting for more than 1 ms, then we are
> >> wasting bandwidth.
> >> But if we switch from reads to writes (since the reader thought
> >> slightly more than 1ms), and the write is really slow, we can have a
> >> really long latency before the reader can complete its new request.
> >
> > What workload do you have where reader is thinking more than a 1ms?
> My representative workload is booting my netbook. I found that if I
> let cfq autotune to a lower slice idle, boot slows down, and bootchart
> clearly shows that I/O wait increases and I/O bandwidth decreases.
> This tells me that the writes are getting into the picture earlier
> than with 8ms idle, and causing a regression.
> Note that the reader doesn't need to be one. I could have a set of
> readers, and I want to switch between them in 1ms, but idle up to 10ms
> or more before switching to async writes.

Ok, so booting on your netbook where write cost is high is the case. So
in this particular case you prefer to delay writes a bit to reduce the
read latency and writes can catch up little later.

> >
> > To me one issue probably is that for sync queues we drive shallow (1-2)
> > queue depths and this can be an issue on high end storage where there
> > can be multiple disks behind the array and this sync queue is just
> > not keeping array fully utilized. Buffered sequential reads mitigate
> > this issue up to some extent as requests size is big.
> I think for sequential queues, you should tune your readahead to hit
> all the disks of the raid. In that case, idling makes sense, because
> all the disks will now be ready to serve the new request immediately.
> 
> >
> > Idling on the queue helps in providing differentiated service for higher
> > priority queue and also helps to get more out of disk on rotational media
> > with single disk. But I suspect that on big arrays, this idling on sync
> > queues and not driving deeper queue depths might hurt.
> We should have some numbers to support. In all tests I saw, setting
> slice idle to 0 causes regression also on decently sized arrays, at
> least when the number of concurrent processes is big enough that 2 of
> them likely will make requests to the same disk (and by the birthday
> paradox, this can be a quite small number, even with very large
> arrays: e.g. with 365-disk raids, 23 concurrent processes have 50%
> probability of colliding on the same disk at every single request
> sent).

I will do some tests and see if there are cases where driving shallower
depths hurts.

Vivek

> 
> >
> > So if we had a way to detect that we got a big storage array underneath,
> > may be we can get more throughput by not idling at all. But we will also
> > loose the service differentiation between various ioprio queues. I guess
> > your patches of monitoring service times might be useful here.
> It might, but we need to identify an hardware in which not idling is
> beneficial, measure its behaviour and see which measurable parameter
> can clearly distinguish it from other hardware where idling is
> required. If we are speaking of raid of rotational disks, seek time
> (which I was measuring) is not a good parameter, because it can be
> still high.
> >
> >> So the optimal choice would be to have two different idle times, one
> >> for switch between readers, and one when switching from readers to
> >> writers.
> >
> > Sounds like read and write batches. With you workload type, we are already
> > doing it. Idle per service tree. At least it solves the problem for
> > sync-noidle queues where we don't idle between read queues but do idle
> > between read and buffered write (async queues).
> >
> In fact those changes improved my netbook boot time a lot, and I'm not
> even using sreadahead. But if autotuning reduces the slice idle, then
> I see again the huge penalty of small writes.
> 
> > In my testing so far, I have not encountered the workloads where readers
> > are thinking a lot. Think time has been very small.
> Sometimes real workloads have more variable think times than our
> syntetic benchmarks.
> 
> >
> > Thanks
> > Vivek
> >
> Thanks,
> Corrado
