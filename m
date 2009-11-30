Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbZK3V42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbZK3V42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZK3V41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:56:27 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:48245 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbZK3V40 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:56:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vVx1HPzhfPEn4pBnOzHXTxn+MpTzZ4nBltG7Mk5WivUOdZdD1f4ChbBraKZ8WQCwdd
         wiByaZyO08kxqRn82zQdPXchdLIlqvP8CJGVgl8pNpF6JBQXNnquGWtFKQtqbtio2/jz
         xxRlWBSeOLfxvzK5kXCJwMsGbEbFyEDtDBvjo=
MIME-Version: 1.0
In-Reply-To: <20091130164615.GF11670@redhat.com>
References: <4B0E1E2F.9080604@cn.fujitsu.com>
	 <4e5e476b0911260108s2fe4cd86lcb32c7be76b4f75c@mail.gmail.com>
	 <20091130153604.GB11670@redhat.com>
	 <4e5e476b0911300801n57078c8eicd80bdc0f4cb2a87@mail.gmail.com>
	 <20091130164615.GF11670@redhat.com>
Date: Mon, 30 Nov 2009 22:56:32 +0100
Message-ID: <4e5e476b0911301356m7d223e39h373a46d14947890c@mail.gmail.com>
Subject: Re: [PATCH] cfq: Make use of service count to estimate the rb_key 
	offset
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
On Mon, Nov 30, 2009 at 5:46 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Nov 30, 2009 at 05:01:28PM +0100, Corrado Zoccolo wrote:
>> This is a good option. I have also tested it, and it works quite well
>> (you can even have an async penalization like in deadline, so you do
>> few rounds between seq and seeky, and then one of async).
>
> Or to keep it even simpler just reduce the share of async workload per
> round. Currently you already reduce that share in the ratio of sync/async
> base slices.
Reducing the share per round can increase seekiness. Having a big enough
share every few rounds, instead, will have better throughput.
>
>> Besides a
>> more complex code, I felt it was against the spirit of CFQ, since in
>> that way, you are not providing fairness across workloads (especially
>> if you don't want low_latency).
>
> I am not sure what is the spirit of CFQ when it comes to serving the
> various workloads currently.
CFQ spirit is to be completely fair.
2.6.32 with low_latency introduced fairness also for seeky queues.
> It seems sync queues get the maximum share
> and that led to starvation of random seeky readers. Your patches of idling
> on sync-noidle tree improved that situation by increasing the disk share
> for sync-noidle workload.
Yes. But we don't want now to penalize the sequential processes. We want
workloads serviced fairly, so if the 8 sequential queues all requested service
before the seeky ones, they should be serviced first, unless we have preemption
(e.g. one seeky queue wants to read metadata). In that case, we will
start servicing
the meta data request, and then also the other seeky ones, to fill the
NCQ slots.

> When it comes to disk share for async workload, I don't think CFQ has any
> fixed formula for that. We do slice length calculation but to me it is
> of not much use most of the time as async queues are preempted by sync
> queues. Yes resid computation should help here a bit but still preempting
> queue gets to run first always (at least in old cfq). Now in new cfq, to
> me even if we preempt, we will be put at the front of the respective
> serviece tree but we might continue to dispatch from async workload as
> time slice for that workload has not expired and till then we will not
> choose a new workload.
>
> So I am not sure if old cfq had any notion of in what ratio async will get
> to use the disk. Only thing we ensured was that async queue should not
> increase the latency of sync queues and put various hooks like sync queue
> can preempt async queue, don't allow dispatch from async queue if sync
> requests are in flight or build up the async queue depth slowly etc.
Right. Async is an other story. But for sync, CFQ wants to provide fairness
in the long run, so penalizing sequential queues w.r.t. seeky ones is
not advisable.
You should note that, when loading an application, you will start being seeky,
and then become sequential. If you service seeky queues with higher priority,
your applications will complete the seeky phase quickly, and then still consume
a lot of time during the sequential part, so the perceived latency
will not improve.

> So the point is that as such old CFQ was not guranteeing anything about
> the share of type of workload. So by enforcing round robin between
> workload type we should not be breaking any gurantee.
>
>>
>> BTW, my idea how to improve the rb_key computation is:
>> * for NCQ SSD (or when sched_idle = 0):
>>   rb_key = jiffies - function(priority)
>> * for others:
>>   rb_key = jiffies - sched_resid
>>
>> Currently, sched_resid is meaningless for NCQ SSD, since we always
>> expire the queue immediately. Subtracting sched_resid would just give
>> an advantage to a queue that already dispatched over the ones that
>> didn't.
>
> In NCQ SSD, will resid be not zero most of the time? I thought resid is
> set to something only if queue is preemted. For usual expiry by
> cfq_select_queue(), timed_out=0 and resid=0. So on NCQ SSD resid should
> not be playing any role.
Good. So I still don't have an explanation for the apparent starvation
of some queues,
when many sequential queues are requesting service. Your test case
with 4k direct
reads showed it clearly, more than can be seen when passing through
the page cache
and readahead. Do you have any idea why this happened?
>
>> Priority, instead, should be used only for NCQ SSD. For the others,
>> priority already affects time slice, so having it here would cause
>> over-prioritization.
>
> What's the goal here? By doing this computation, what do we gain, Is it
> about getting better service differentation on NCQ SSDs for different prio
> processes? So providing lower rb_key for higher prio process should help
> on NCQ SSD. That's a different thing it might not be very deterministic.
Yes. It may not be deterministic, but it will provide some. Maybe it will work
better when we have autotune automatically set slice_idle=0.
However, my point is that in current formula priority is already present, but
we should remove it when disk is rotational or non NCQ, since it will give
over-prioritization.

Thanks,
Corrado
>
> Thanks
> Vivek
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
