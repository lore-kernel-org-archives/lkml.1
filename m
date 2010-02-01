Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab0BALEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 06:04:11 -0500
Received: from smtp-out.google.com ([216.239.33.17]:8232 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab0BALEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 06:04:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=jT0+8ShYmtNnQlHv0Ye7zc8jItAJolp5qwB3mob7sItce1GKwBRvuUnJp2tYihaii
	GMSd9yglm72LsEhBZjgFw==
MIME-Version: 1.0
In-Reply-To: <20100201082150.GB686@in.ibm.com>
References: <20100105075703.GE27899@in.ibm.com>
	 <loom.20100108T214459-933@post.gmane.org>
	 <344eb09a1001281949p37cd6d1awbc561937fc8f04f5@mail.gmail.com>
	 <ed628a921001282026p2f8d64c7u416e55e48a21ea79@mail.gmail.com>
	 <20100201082150.GB686@in.ibm.com>
Date: Mon, 1 Feb 2010 03:04:00 -0800
Message-ID: <ed628a921002010304p40397558lf45f53daca97e879@mail.gmail.com>
Subject: Re: [RFC v5 PATCH 0/8] CFS Hard limits - v5
From: Paul Turner <pjt@google.com>
To: bharata@linux.vnet.ibm.com
Cc: Bharata B Rao <bharata.rao@gmail.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 12:21 AM, Bharata B Rao
<bharata@linux.vnet.ibm.com> wrote:
> On Thu, Jan 28, 2010 at 08:26:08PM -0800, Paul Turner wrote:
>> On Thu, Jan 28, 2010 at 7:49 PM, Bharata B Rao <bharata.rao@gmail.com> wrote:
>> > On Sat, Jan 9, 2010 at 2:15 AM, Paul Turner <pjt@google.com> wrote:
>> >>
>> >> What are your thoughts on using a separate mechanism for the general case.  A
>> >> draft proposal follows:
>> >>
>> >> - Maintain a global run-time pool for each tg.  The runtime specified by the
>> >>  user represents the value that this pool will be refilled to each period.
>> >> - We continue to maintain the local notion of runtime/period in each cfs_rq,
>> >>  continue to accumulate locally here.
>> >>
>> >> Upon locally exceeding the period acquire new credit from the global pool
>> >> (either under lock or more likely using atomic ops).  This can either be in
>> >> fixed steppings (e.g. 10ms, could be tunable) or following some quasi-curve
>> >> variant with historical demand.
>> >>
>> >> One caveat here is that there is some over-commit in the system, the local
>> >> differences of runtime vs period represent additional over the global pool.
>> >> However it should not be possible to consistently exceed limits since the rate
>> >> of refill is gated by the runtime being input into the system via the per-tg
>> >> pool.
>> >>
>> >
>> > We borrow from what is actually available as spare (spare = unused or
>> > remaining). With global pool, I see that would be difficult.
>> > Inability/difficulty in keeping the global pool in sync with the
>> > actual available spare time is the reason for over-commit ?
>> >
>>
>> We maintain two pools, a global pool (new) and a per-cfs_rq pool
>> (similar to existing rt_bw).
>>
>> When consuming time you charge vs your local bandwidth until it is
>> expired, at this point you must either refill from the global pool, or
>> throttle.
>>
>> The "slack" in the system is the sum of unconsumed time in local pools
>> from the *previous* global pool refill.  This is bounded above by the
>> size of time you refill a local pool at each expiry.  We call the size
>> of refill a 'slice'.
>>
>> e.g.
>>
>> Task limit of 50ms, slice=10ms, 4cpus, period of 500ms
>>
>> Task A runs on cpus 0 and 1 for 5ms each, then blocks.
>>
>> When A first executes on each cpu we take slice=10ms from the global
>> pool of 50ms and apply it to the local rq.  Execution then proceeds vs
>> local pool.
>>
>> Current state is: 5 ms in local pools on {0,1}, 30ms remaining in global pool
>>
>> Upon period expiration we issue a global pool refill.  At this point we have:
>> 5 ms in local pools on {0,1}, 50ms remaining in global pool.
>>
>> That 10ms of slack time is over-commit in the system.  However it
>> should be clear that this can only be a local effect since over any
>> period of time the rate of input into the system is limited by global
>> pool refill rate.
>
> With the same setup as above consider 5 such tasks which block after
> consuming 5ms each. So now we have 25ms slack time. In the next bandwidth
> period if 5 cpu hogs start running and they would consume this 25ms and the
> 50ms from this period. So we gave 50% extra to a group in a bandwidth period.
> Just wondering how common such scenarious could be.
>

Yes within a single given period you may exceed your reservation due
to slack.  However, of note is that across any 2 successive periods
you are guaranteed to be within your reservation, i.e. 2*usage <=
2*period, as slack available means that you under-consumed your
previous period.

For those needing a hard guarantee (independent of amelioration
strategies) halving the period provided would then provide this across
their target period with the basic v1 implementation.

>>
>> There are also some strategies that we are exploring to improve
>> behavior further here.  One idea is that if we maintain a generation
>> counter then on voluntary dequeue (e.g. tasks block) we can return
>> local time to the global period pool or expire it (if generations
>> don't match), this greatly reduces the noise (via slack vs ideal
>> limit) that a busty application can induce.
>
> Why not clear the remaining runtime during bandwidth refresh ?
>

This doesn't scale with (many cpus) * (many bandwidth limits).

It is still my intuition that introducing a generation counter for
quota would allow us to handle this gracefully as that would allow
both invalidation of expired slack time and for the (potentially
fractional) returning of local quota to the global pool within a
period (upon block/voluntary yield).

Such tactics would probably seem better suited for a v2 as there are
both other possible approaches and the matter of added complexity to
the basic design.  However, if it works well it might sneak into v1 ;)

>>
>> >> This would also naturally associate with an interface change that would mean the
>> >> runtime limit for a group would be the effective cpurate within the period.
>> >>
>> >> e.g. by setting a runtime of 200000us on a 100000us period it would effectively
>> >> allow you to use 2 cpus worth of wall-time on a multicore system.
>> >>
>> >> I feel this is slightly more natural than the current definition which due to
>> >> being local means that values set will not result in consistent behavior across
>> >> machines of different core counts.  It also has the benefit of being consistent
>> >> with observed exports of time consumed, e.g. rusage, (indirectly) time, etc.
>> >
>> > Though runtimes are enforced locally per-cpu, that's only the
>> > implementation. The definition of runtime and period is still
>> > system-wide/global. A runtime/period=0.25/0.5 will mean 0.25s of
>> > system wide runtime within a period of 0.5s. Talking about consistent
>> > definition, I would say this consistently defines half of system wide
>> > wall-time on all configurations :)
>>
>> This feels non-intuitive suppose you have a non-homogeneous fleet of
>> systems.  It is also difficult to express limits in terms of cores,
>> suppose I'm an admin trying to jail my users (maybe I rent out virtual
>> time ala EC2 for example).  The fractions I have to use to represent
>> integer core amounts are going to become quite small on large systems.
>>  For example, 1 core on a 64 core system would mean 3.905ms/250ms
>> period.  What's the dependency here between your time and the current
>> cpuset topology also, if I'm only allowed on half the system does this
>> fraction then refer to global resources or what I'm constrained to?
>> This seems a difficult data dependency to manage.
>>
>> My (personal) ideology is that we are metering at the cpu level as
>> opposed to the system level -- which means N seconds of cpu-time makes
>> more sense to me.  I feel it has advantages in that it can be
>> specified more directly relative to the period and is independent of
>> system partitioning.
>>
>> I'd be interested to hear other opinions on this.
>
> We need a consensus here, will wait to see what others think about this.
>
>>
>> > If it means 2 CPUs worth wall-time
>> > in 4 core machine, it would mean 4 CPUs on a 8 CPU machine.  At this
>> > point, I am inclined to go with this and let the admins/tools work out
>> > the actual CPUs part of it. However I would like to hear what others
>> > think about this interface.
>> >
>> >>
>> >> For future scalability as machine size grows this could potentially be
>> >> partitioned below the tg level along the boundaries of sched_domains (or
>> >> something similar).  However for an initial draft given current machine sizes
>> >> the contention on the global pool should hopefully be fairly low.
>> >
>> > One of the alternatives I have in mind is to be more aggressive while
>> > borrowing. While keeping the current algorithm (of iterating thro' all
>> > CPUs when borrowing) intact, we could potentially borrow more from
>> > those CPUs which don't have any running task from the given group. I
>> > just experimented with borrowing half of the available runtime from
>> > such CPUs and found that number of iterations are greatly reduced and
>> > the source runtime quickly converges to its max possible value. Do you
>> > see any issues with this ?
>> >
>>
>> I strongly believe that this is going to induce significant lock
>> contention and is not a scalable solution over time.  While using a
>> faster converging series for time may help I think there are
>> confounding factors that limit effect here.  Consider the 1 core on a
>> 64 core system example above.  With only 3.905ms per pool we are going
>> to quickly hit the case where we are borrowing not-useful periods of
>> time while thrashing locks.
>>
>> We are in the midst of an implementation for proposal above which
>> we'll have ready post to here for consideration next week.  We have
>> maintained your existing approach with respect to handling throttled
>> entities and layered on top of that the proposed alternate
>> local/global bandwidth scheme.  Initial tests show very promising
>> results!
>
> Nice. Look forward to your patches.
>
> Regards,
> Bharata.
>
