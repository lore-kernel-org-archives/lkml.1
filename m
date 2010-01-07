Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426Ab0AGShc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0AGShc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317Ab0AGShb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:37:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab0AGSha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:37:30 -0500
Date: Thu, 7 Jan 2010 13:37:10 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Kirill Afonshin <kirill_nnov@mail.ru>, Jeff Moyer <jmoyer@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need read queue
	merging
Message-ID: <20100107183710.GC14686@redhat.com>
References: <4e5e476b1001051348y4637986epb9b56958c738061a@mail.gmail.com> <E1NSq2i-0000wY-00.kirill_nnov-mail-ru@foot.mail.ru> <4e5e476b1001070538y35143cc8me7443f3eb0d377@mail.gmail.com> <20100107143640.GB7664@redhat.com> <4e5e476b1001070900y4428644bse06d8304cde1a86c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b1001070900y4428644bse06d8304cde1a86c@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 06:00:54PM +0100, Corrado Zoccolo wrote:
> On Thu, Jan 7, 2010 at 3:36 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Hi Corrado,
> >
> > How does idle time value relate to flash card being slower for writes? If
> > flash card is slow and we choose to idle on queue (because of direct
> > writes), idle time value does not even kick in. We just continue to remain
> > on same cfqq and don't do dispatch from next cfqq.
> >
> > Idle time value will matter only if there was delay from cpu side or from
> > workload side in issuing next request after completion of previous one.
> >
> > Thanks
> > Vivek
> Hi Vivek,
> for me, the optimal idle value should approximate the cost of
> switching to an other queue.
> So, for reads, if we are waiting for more than 1 ms, then we are
> wasting bandwidth.
> But if we switch from reads to writes (since the reader thought
> slightly more than 1ms), and the write is really slow, we can have a
> really long latency before the reader can complete its new request.

What workload do you have where reader is thinking more than a 1ms?

To me one issue probably is that for sync queues we drive shallow (1-2)
queue depths and this can be an issue on high end storage where there
can be multiple disks behind the array and this sync queue is just
not keeping array fully utilized. Buffered sequential reads mitigate
this issue up to some extent as requests size is big.

Idling on the queue helps in providing differentiated service for higher
priority queue and also helps to get more out of disk on rotational media
with single disk. But I suspect that on big arrays, this idling on sync
queues and not driving deeper queue depths might hurt.

So if we had a way to detect that we got a big storage array underneath,
may be we can get more throughput by not idling at all. But we will also
loose the service differentiation between various ioprio queues. I guess
your patches of monitoring service times might be useful here.

> So the optimal choice would be to have two different idle times, one
> for switch between readers, and one when switching from readers to
> writers.

Sounds like read and write batches. With you workload type, we are already
doing it. Idle per service tree. At least it solves the problem for
sync-noidle queues where we don't idle between read queues but do idle
between read and buffered write (async queues).

In my testing so far, I have not encountered the workloads where readers
are thinking a lot. Think time has been very small.

Thanks
Vivek
