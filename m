Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbYGQCrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbYGQCrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 22:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYGQCrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 22:47:07 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:23951 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbYGQCrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 22:47:06 -0400
Message-Id: <487E7B6C.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 16 Jul 2008 20:51:24 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <dmitry.adamushko@gmail.com>,
       <torvalds@linux-foundation.org>, <pj@sgi.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpu hotplug, sched: Introduce cpu_active_map
	and	redosched domain managment (take 2)
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
 <487DAD86.BA47.005A.0@novell.com> <487E6BD7.3020006@qualcomm.com>
In-Reply-To: <487E6BD7.3020006@qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Wed, Jul 16, 2008 at  5:44 PM, in message <487E6BD7.3020006@qualcomm.com>,
Max Krasnyansky <maxk@qualcomm.com> wrote: 
> Gregory Haskins wrote:
>>>>> On Tue, Jul 15, 2008 at  7:43 AM, in message
>> <1216122229-4865-1-git-send-email-maxk@qualcomm.com>, Max Krasnyansky
>> <maxk@qualcomm.com> wrote: 
>> 
>>> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
>>> index 47ceac9..5166080 100644
>>> --- a/kernel/sched_rt.c
>>> +++ b/kernel/sched_rt.c
>>> @@ -922,6 +922,13 @@ static int find_lowest_rq(struct task_struct *task)
>>>  		return -1; /* No targets found */
>>>  
>>>  	/*
>>> +	 * Only consider CPUs that are usable for migration.
>>> +	 * I guess we might want to change cpupri_find() to ignore those
>>> +	 * in the first place.
>>> +	 */ 
>>> +	cpus_and(*lowest_mask, *lowest_mask, cpu_active_map);
>>> +
>>> +	/*
>>>  	 * At this point we have built a mask of cpus representing the
>>>  	 * lowest priority tasks in the system.  Now we want to elect
>>>  	 * the best one based on our affinity and topology.
>> 
>> Hi Max,
>>   Its still early in the morning, and I havent had my coffee yet, so what I 
> am about to
>> say may be totally bogus ;)
>> 
>> ..but, I am not sure we need to do this mask here.  If the hotcpu_notifiier 
> is still
>> running (and it appears that it is) the runqueue that is taken offline will 
> be removed
>> from cpupri as well.
>> 
>> Or perhaps I am misunderstanding the intention of "active" verses "online".  
> If I
>> understand correctly, active and online mean more or less the same thing, 
> but
>> splitting it out like this allows us  to skip rebuilding the domains on 
> every hotplug.
>> Is that correct?
>
> Basically with the cpu_active_map we're saying that sched domain masks may
> contain cpus that are going down, and the scheduler is supposed to ignore
> those (by checking cpu_active_map).

Well, admittedly I am not entirely clear on what problem is being solved as
I was not part of the original thread with Linus.  My impression of what you
were trying to solve was to eliminate the need to rebuild the domains for a
hotplug event (which I think is a good problem to solve), thus eliminating
some complexity and (iiuc) races there.

However, based on what you just said, I am not sure I've got that entirely
right anymore.  Can you clarify the intent (or point me at the original thread)
so we are on the same page?

> ie The idea was to simplify cpu hotplug
> handling. My impression was that cpupri updates are similar to the sched
> domains in that respect.

Well, not quite.  cpupri ends up hanging off of a root-domain, so its more
closely related to the global cpu_XXX_maps than it is to the domains.  As
you know, to clear a bit from the domains means walking each RQ and each
domain within that runqueue since the domain structures are per-cpu.  This
is why historically the domains have been rebuilt when a cpu is plugged in
(iiuc). 

However, with cpupri (and root-domains in general) the structure is shared
among all member RQs.  Therefore, taking a cpu online/offline is simply a
matter of updating a single cpumap_t.  This happens today (in sched-devel,
anyway) via the set_rq_online/offline() routines.

> 
>> Assuming that the above is true, and assuming that the hotcpu_notifier is
>> still invoked when the online status changes, cpupri will be properly 
> updated
>> to exclude the offline core.  That will save an extra cpus_and (which the 
> big-iron
>> guys will be happy about ;)
> Ah, now I see what you mean by the hotplug handler is still running. You're
> talking about set_rq_online()/set_rq_offline() calls from migration_call().
> Yes did not know what they were for and did not touch that path.
> btw I'm definitely with you on the cpus_and() thing. When I added it in both
> balancers I thought that it quite an overhead on bigger boxes.
> 
> So I'm not sure what the best way to handle this. If we say we're relying on
> hotplug event sequence to ensure that rt balancer state is consistent then 
> we
> kind of back to square one. ie Might as do the same for the sched domains.

Im not following you here (but again, it might be because of my
misunderstanding of what it is you are actually solving).  I see the cleanup
that you did to not require rebuilding domains on hotplug as a really good thing.
However, I don't see the problem with updating cpupri in the manner I mentioned
either.  The rq_offline routine is invoked on the DYING event (pre-offline), and
the rq_online on the ONLINE event. This means that it will effectively disable the
runqueue at the earliest possible moment in the hotplug processing, thereby
removing the possibility that we will route to that core.

My gut tells me that if this is not adequate, there there is something wrong with
the hotplug notifier infrastructure and we should fix that, not put some more
infrastructure on top of it.  :)

Don't get me wrong.  I am not nacking your concept.  As ive said I like decoupling
the hotplug from the cpuset stuff (assuming that is what you were trying to do).
But I am also not convinced that part of what you are doing is already handled
properly, so why duplicate it when you can just tie into the existing logic.

On this topic, (and assuming I am right in my cpupri online/offline theory above), FYI
you can probably use rq->rd->online instead of cpu_active_map in many places.  This
mask is updated according to the hotplug state in a similar manner as cpupri and should
effectively be a cached version of cpus_active_map & rq->rd->span.

I guess the point here really is that it would be best (IMO) to not introduce another
map (at least to the scheduler) if it can be helped at all.  If you could somehow tie your
cpuset/hotplug decoupling logic with rq->rd->online, et. al., I would be very enthused :)

If you want to retain the cpu_active_map for other code (e.g. cpusets/hotplug) to use, I
see no problem with that.  It just seems the scheduler already has the hooks in place
to play nice here, so Id like to see them used if possible ;)

Regards,
-Greg

