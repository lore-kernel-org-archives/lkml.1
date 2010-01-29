Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699Ab0A2E0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab0A2E0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 23:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657Ab0A2E0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 23:26:17 -0500
Received: from smtp-out.google.com ([216.239.33.17]:18210 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab0A2E0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 23:26:16 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=s+2slfdh3bEe1kL9CEENZasZtfHq3h/mE0RY81yZm5JasBzkG9RHd9nNYjp5yzrmL
	4OpNwJ+jfaiIH0XhgUGhQ==
MIME-Version: 1.0
In-Reply-To: <344eb09a1001281949p37cd6d1awbc561937fc8f04f5@mail.gmail.com>
References: <20100105075703.GE27899@in.ibm.com>
	 <loom.20100108T214459-933@post.gmane.org>
	 <344eb09a1001281949p37cd6d1awbc561937fc8f04f5@mail.gmail.com>
Date: Thu, 28 Jan 2010 20:26:08 -0800
Message-ID: <ed628a921001282026p2f8d64c7u416e55e48a21ea79@mail.gmail.com>
Subject: Re: [RFC v5 PATCH 0/8] CFS Hard limits - v5
From: Paul Turner <pjt@google.com>
To: Bharata B Rao <bharata.rao@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval.giani@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>, bharata <bharata@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 7:49 PM, Bharata B Rao <bharata.rao@gmail.com> wrote:
> On Sat, Jan 9, 2010 at 2:15 AM, Paul Turner <pjt@google.com> wrote:
>>
>> Hi Bharata,
>
> Hi Paul,
>
> Sorry for the late reply. Since you removed the CC-list, I didn't get
> this mail in my inbox and hence didn't notice this at all until this
> time!
>
> [Putting back the original CC list in this mail]

Sorry! I replied through GMane since I didn't have the headers from
the original mail, I didn't realize it breaks the cc list!

>
>>
>> Thanks for the updated patchset.  As discussed the other day briefly I have some
>> concerns with the usage of the current RT bandwidth rate-limiting code as there
>> are some assumptions made that I feel don't fit the general case well.
>>
>> The reason for this is that the borrowing logic in bandwidth rebalance appears
>> to make the assumption that we wil will be able to converge rapidly to the
>> period.  Indeed, in each iteration of redistribution we take only
>> 1/weight(nrcpus) [assuming no cpuset partitions] of the time remaining.  This is
>> a decreasing series, and if we can't exceed the period our convergence looks
>> pretty slow [geometric series].
>>
>> In general it appears the following relation be satisfied for efficient
>> execution:  (weight(nr_cpus) * runtime) >> period
>>
>> This assumption is well satisfied in the RT case since the available bandwidth
>> is very high.  However I fear for the general case of user limits on tg usage
>> lie at the other end of the spectrum.  Especially for those trying to partition
>> large machines into many smaller well provisioned fractions, e.g. 0-2 cores out
>> of a total 64.  The lock and re-distribution cost for each iteration is also
>> going to be quite high in this case which will potentially compound on the
>> number of iterations required above.
>
> I see your point. Having a runtime which is much lesser than the
> period will result in a lot of iterations of borrowing from every CPU
> before the source CPU accumulates the maximum possible runtime.
>
> Apart from this, I also see that after accumulating the maximum
> possible runtime from all CPUs, the task sometimes moves to another
> CPU due to load balancing. When this happens, the new CPU starts the
> borrowing iterations all over again!

Yes, we later confirmed this with some benchmarks that showed the cost
to be quite high indeed!  (e.g. try a while(1) thread with a provision
of 1-core on a larger (16+ core)  machine).

>
> As you observe, borrowing just 1/n th (n = number of CPUs) of the
> spare runtime from each CPU is not ideal for CFS if runtimes are going
> to be much lesser than period unlike RT. This would involve iterating
> through all the CPUs and acquiring/releasing a spinlock in each
> iteration.
>
>>
>> What are your thoughts on using a separate mechanism for the general case.  A
>> draft proposal follows:
>>
>> - Maintain a global run-time pool for each tg.  The runtime specified by the
>>  user represents the value that this pool will be refilled to each period.
>> - We continue to maintain the local notion of runtime/period in each cfs_rq,
>>  continue to accumulate locally here.
>>
>> Upon locally exceeding the period acquire new credit from the global pool
>> (either under lock or more likely using atomic ops).  This can either be in
>> fixed steppings (e.g. 10ms, could be tunable) or following some quasi-curve
>> variant with historical demand.
>>
>> One caveat here is that there is some over-commit in the system, the local
>> differences of runtime vs period represent additional over the global pool.
>> However it should not be possible to consistently exceed limits since the rate
>> of refill is gated by the runtime being input into the system via the per-tg
>> pool.
>>
>
> We borrow from what is actually available as spare (spare = unused or
> remaining). With global pool, I see that would be difficult.
> Inability/difficulty in keeping the global pool in sync with the
> actual available spare time is the reason for over-commit ?
>

We maintain two pools, a global pool (new) and a per-cfs_rq pool
(similar to existing rt_bw).

When consuming time you charge vs your local bandwidth until it is
expired, at this point you must either refill from the global pool, or
throttle.

The "slack" in the system is the sum of unconsumed time in local pools
from the *previous* global pool refill.  This is bounded above by the
size of time you refill a local pool at each expiry.  We call the size
of refill a 'slice'.

e.g.

Task limit of 50ms, slice=10ms, 4cpus, period of 500ms

Task A runs on cpus 0 and 1 for 5ms each, then blocks.

When A first executes on each cpu we take slice=10ms from the global
pool of 50ms and apply it to the local rq.  Execution then proceeds vs
local pool.

Current state is: 5 ms in local pools on {0,1}, 30ms remaining in global pool

Upon period expiration we issue a global pool refill.  At this point we have:
5 ms in local pools on {0,1}, 50ms remaining in global pool.

That 10ms of slack time is over-commit in the system.  However it
should be clear that this can only be a local effect since over any
period of time the rate of input into the system is limited by global
pool refill rate.

There are also some strategies that we are exploring to improve
behavior further here.  One idea is that if we maintain a generation
counter then on voluntary dequeue (e.g. tasks block) we can return
local time to the global period pool or expire it (if generations
don't match), this greatly reduces the noise (via slack vs ideal
limit) that a busty application can induce.

>> This would also naturally associate with an interface change that would mean the
>> runtime limit for a group would be the effective cpurate within the period.
>>
>> e.g. by setting a runtime of 200000us on a 100000us period it would effectively
>> allow you to use 2 cpus worth of wall-time on a multicore system.
>>
>> I feel this is slightly more natural than the current definition which due to
>> being local means that values set will not result in consistent behavior across
>> machines of different core counts.  It also has the benefit of being consistent
>> with observed exports of time consumed, e.g. rusage, (indirectly) time, etc.
>
> Though runtimes are enforced locally per-cpu, that's only the
> implementation. The definition of runtime and period is still
> system-wide/global. A runtime/period=0.25/0.5 will mean 0.25s of
> system wide runtime within a period of 0.5s. Talking about consistent
> definition, I would say this consistently defines half of system wide
> wall-time on all configurations :)

This feels non-intuitive suppose you have a non-homogeneous fleet of
systems.  It is also difficult to express limits in terms of cores,
suppose I'm an admin trying to jail my users (maybe I rent out virtual
time ala EC2 for example).  The fractions I have to use to represent
integer core amounts are going to become quite small on large systems.
 For example, 1 core on a 64 core system would mean 3.905ms/250ms
period.  What's the dependency here between your time and the current
cpuset topology also, if I'm only allowed on half the system does this
fraction then refer to global resources or what I'm constrained to?
This seems a difficult data dependency to manage.

My (personal) ideology is that we are metering at the cpu level as
opposed to the system level -- which means N seconds of cpu-time makes
more sense to me.  I feel it has advantages in that it can be
specified more directly relative to the period and is independent of
system partitioning.

I'd be interested to hear other opinions on this.

> If it means 2 CPUs worth wall-time
> in 4 core machine, it would mean 4 CPUs on a 8 CPU machine.  At this
> point, I am inclined to go with this and let the admins/tools work out
> the actual CPUs part of it. However I would like to hear what others
> think about this interface.
>
>>
>> For future scalability as machine size grows this could potentially be
>> partitioned below the tg level along the boundaries of sched_domains (or
>> something similar).  However for an initial draft given current machine sizes
>> the contention on the global pool should hopefully be fairly low.
>
> One of the alternatives I have in mind is to be more aggressive while
> borrowing. While keeping the current algorithm (of iterating thro' all
> CPUs when borrowing) intact, we could potentially borrow more from
> those CPUs which don't have any running task from the given group. I
> just experimented with borrowing half of the available runtime from
> such CPUs and found that number of iterations are greatly reduced and
> the source runtime quickly converges to its max possible value. Do you
> see any issues with this ?
>

I strongly believe that this is going to induce significant lock
contention and is not a scalable solution over time.  While using a
faster converging series for time may help I think there are
confounding factors that limit effect here.  Consider the 1 core on a
64 core system example above.  With only 3.905ms per pool we are going
to quickly hit the case where we are borrowing not-useful periods of
time while thrashing locks.

We are in the midst of an implementation for proposal above which
we'll have ready post to here for consideration next week.  We have
maintained your existing approach with respect to handling throttled
entities and layered on top of that the proposed alternate
local/global bandwidth scheme.  Initial tests show very promising
results!

Thank-you!

- Paul

> Thanks for your note.
>
> Regards,
> Bharata.
> --
> http://bharata.sulekha.com/blog/posts.htm, http://raobharata.wordpress.com/
>
