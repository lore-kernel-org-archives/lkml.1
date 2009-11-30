Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbZK3QqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbZK3QqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbZK3QqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:46:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbZK3QqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:46:16 -0500
Date: Mon, 30 Nov 2009 11:46:15 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq: Make use of service count to estimate the rb_key
	offset
Message-ID: <20091130164615.GF11670@redhat.com>
References: <4B0E1E2F.9080604@cn.fujitsu.com> <4e5e476b0911260108s2fe4cd86lcb32c7be76b4f75c@mail.gmail.com> <20091130153604.GB11670@redhat.com> <4e5e476b0911300801n57078c8eicd80bdc0f4cb2a87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0911300801n57078c8eicd80bdc0f4cb2a87@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 05:01:28PM +0100, Corrado Zoccolo wrote:
> On Mon, Nov 30, 2009 at 4:36 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Hi Corrado,
> >
> > currently rb_key seems to be combination of two things. busy_queues and
> > jiffies.
> >
> > In new scheme, where we decide the share of a workload and then switch to
> > new workload, dependence on busy_queues does not seem to make much sense.
> >
> > Assume, a bunch of sequential readers get backlogged and then few random
> > readers gets backlogged. Now random reader will get higher rb_key because
> > there are 8 sequential reders on sync-idle tree.
> Even if we didn't have busy_queues, we would have the same situation,
> e.g. we have the 8 seq readers at time t (jiffies), and the seeky
> readers at time t+1.
> busy_queues really doesn't add anything when all queues have the same priority.

> >
> > IIUC, with above logic, even if we expire the sync-idle workload duration
> > once, we might not switch to sync-noidle workload and start running the
> > sync-idle workload again. (Because minimum slice length restrictions or
> > if low_latency is not set).
> Yes.
> >
> > So instead of relying on rb_keys to switch the workload type, why not do
> > it in round robin manner across the workload types? So rb_key will be
> > significant only with-in service tree and not across service tree?
> This is a good option. I have also tested it, and it works quite well
> (you can even have an async penalization like in deadline, so you do
> few rounds between seq and seeky, and then one of async).

Or to keep it even simpler just reduce the share of async workload per
round. Currently you already reduce that share in the ratio of sync/async
base slices.

> Besides a
> more complex code, I felt it was against the spirit of CFQ, since in
> that way, you are not providing fairness across workloads (especially
> if you don't want low_latency).

I am not sure what is the spirit of CFQ when it comes to serving the
various workloads currently. It seems sync queues get the maximum share
and that led to starvation of random seeky readers. Your patches of idling
on sync-noidle tree improved that situation by increasing the disk share
for sync-noidle workload.

When it comes to disk share for async workload, I don't think CFQ has any
fixed formula for that. We do slice length calculation but to me it is
of not much use most of the time as async queues are preempted by sync
queues. Yes resid computation should help here a bit but still preempting
queue gets to run first always (at least in old cfq). Now in new cfq, to
me even if we preempt, we will be put at the front of the respective
serviece tree but we might continue to dispatch from async workload as
time slice for that workload has not expired and till then we will not
choose a new workload.

So I am not sure if old cfq had any notion of in what ratio async will get
to use the disk. Only thing we ensured was that async queue should not
increase the latency of sync queues and put various hooks like sync queue
can preempt async queue, don't allow dispatch from async queue if sync 
requests are in flight or build up the async queue depth slowly etc.

So the point is that as such old CFQ was not guranteeing anything about
the share of type of workload. So by enforcing round robin between
workload type we should not be breaking any gurantee.

> 
> BTW, my idea how to improve the rb_key computation is:
> * for NCQ SSD (or when sched_idle = 0):
>   rb_key = jiffies - function(priority)
> * for others:
>   rb_key = jiffies - sched_resid
> 
> Currently, sched_resid is meaningless for NCQ SSD, since we always
> expire the queue immediately. Subtracting sched_resid would just give
> an advantage to a queue that already dispatched over the ones that
> didn't.

In NCQ SSD, will resid be not zero most of the time? I thought resid is
set to something only if queue is preemted. For usual expiry by
cfq_select_queue(), timed_out=0 and resid=0. So on NCQ SSD resid should
not be playing any role. 

> Priority, instead, should be used only for NCQ SSD. For the others,
> priority already affects time slice, so having it here would cause
> over-prioritization.

What's the goal here? By doing this computation, what do we gain, Is it
about getting better service differentation on NCQ SSDs for different prio
processes? So providing lower rb_key for higher prio process should help
on NCQ SSD. That's a different thing it might not be very deterministic.

Thanks
Vivek
