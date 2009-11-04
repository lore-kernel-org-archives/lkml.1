Return-Path: <linux-kernel-owner+w=401wt.eu-S932861AbZKDWZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbZKDWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 17:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932649AbZKDWZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 17:25:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082AbZKDWZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 17:25:57 -0500
Date: Wed, 4 Nov 2009 17:25:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 02/20] blkio: Change CFQ to use CFS like queue time
	stamps
Message-ID: <20091104222529.GO2870@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-3-git-send-email-vgoyal@redhat.com> <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 10:18:15PM +0100, Corrado Zoccolo wrote:
> Hi Vivek,
> On Wed, Nov 4, 2009 at 12:43 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > o Previously CFQ had one service tree where queues of all theree prio classes
> >  were being queued. One side affect of this time stamping approach is that
> >  now single tree approach might not work and we need to keep separate service
> >  trees for three prio classes.
> >
> Single service tree is no longer true in cfq for-2.6.33.
> Now we have a matrix of service trees, with first dimension being the
> priority class, and second dimension being the workload type
> (synchronous idle, synchronous no-idle, async).
> You can have a look at the series: http://lkml.org/lkml/2009/10/26/482 .
> It may have other interesting influences on your work, as the idle
> introduced at the end of the synchronous no-idle tree, that provides
> fairness also for seeky or high-think-time queues.
> 

Thanks. I am looking at your patches right now. Got one question about 
following commit.

****************************************************************
commit a6d44e982d3734583b3b4e1d36921af8cfd61fc0
Author: Corrado Zoccolo <czoccolo@gmail.com>
Date:   Mon Oct 26 22:45:11 2009 +0100

    cfq-iosched: enable idling for last queue on priority class

    cfq can disable idling for queues in various circumstances.
    When workloads of different priorities are competing, if the higher
    priority queue has idling disabled, lower priority queues may steal
    its disk share. For example, in a scenario with an RT process
    performing seeky reads vs a BE process performing sequential reads,
    on an NCQ enabled hardware, with low_latency unset,
    the RT process will dispatch only the few pending requests every full
    slice of service for the BE process.

    The patch solves this issue by always performing idle on the last
    queue at a given priority class > idle. If the same process, or one
    that can pre-empt it (so at the same priority or higher), submits a
    new request within the idle window, the lower priority queue won't
    dispatch, saving the disk bandwidth for higher priority ones.

    Note: this doesn't touch the non_rotational + NCQ case (no hardware
    to test if this is a benefit in that case).
*************************************************************************

Not able to understand the logic of waiting for last queue in prio
class. This whole patch series seems to be about low latencies. So why
would not somebody set "low_latency" in IO scheduler? And if somebody
sets "low_latencies" then we will enable idling on random seeky reader
also. So problem will not exist.

On top of that, even if we don't idle for RT reader, we will always
preempt BE reader immediately and get the disk. The only side affect
is that on rotational media, disk head might have moved and bring the
overall throughput down.

So my concern is that with this idling on last queue, we are targetting
fairness issue for the random seeky readers with thinktime with-in 8ms.
That can be easily solved by setting low_latency=1. Why are we going
to this lenth then?

Thanks
Vivek
