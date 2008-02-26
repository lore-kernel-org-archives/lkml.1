Return-Path: <linux-kernel-owner+w=401wt.eu-S1760900AbYBZCKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900AbYBZCKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 21:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbYBZCK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 21:10:28 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2925 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbYBZCK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 21:10:26 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5237"; a="907390"
Message-ID: <47C3750F.8070908@qualcomm.com>
Date: Mon, 25 Feb 2008 18:10:23 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH sched-devel 0/7] CPU isolation extensions
References: <47BE35B7.2070104@qualcomm.com> <1203680600.6242.20.camel@lappy>	 <47BF4719.9020000@qualcomm.com> <1203771926.6242.79.camel@lappy>
In-Reply-To: <1203771926.6242.79.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Sorry for delay in reply.

> Please, wrap your emails at 78 - most mailers can do this.
Done.

> On Fri, 2008-02-22 at 14:05 -0800, Max Krasnyanskiy wrote:
>> Peter Zijlstra wrote:
>>> On Thu, 2008-02-21 at 18:38 -0800, Max Krasnyanskiy wrote:
>>>
> 
>>>> List of commits
>>>>    cpuisol: Make cpu isolation configrable and export isolated map
>>>  
>>> cpu_isolated_map was a bad hack when it was introduced, I feel we should
>>> deprecate it and fully integrate the functionality into cpusets. That would
>>> give a much more flexible end-result.
>> That's not not currently possible and will introduce a lot of complexity.
>> I'm pretty sure you missied the discussion I had with Paul (you were cc'ed on that btw).
>> In fact I provided the link to that discussion in the original email.
>> Here it is again:
>> 	http://marc.info/?l=linux-kernel&m=120180692331461&w=2
> 
> I read it, I just firmly disagree.
> 
>> Basically the problem is very simple. CPU isolation needs a simple/efficient way to check 
>> if CPU N is isolated.
> 
> I'm not seeing the need for that outside of setting up the various
> states. That is, once all the affinities are set up, you'd hardly ever
> would (or should - imho) need to know if a particular CPU is isolated or not.
Unless I'm missing something that's only possible for a very static system. 
What I mean is that yes you could go and set irq affinity, apps affinity, 
workqueue thread affinity, etc not to run on the isolated cpus. It works 
_until_ something changes, at which point the system needs to know that it's 
not supposed to touch CPU N.
For example new IRQ is registered, new workqueue is created (fs mounted, net 
network interface is created, etc), new kthread is started, etc.
Sure we can introduce default affinity masks for irqs, workqueues, etc. But 
that's essentially just duplicating cpu_isolated_map.

>>  cpuset/cgroup APIs are not designed for that. In other to figure
>> out if a CPU N is isolated one has to iterate through all cpusets and checks their cpu maps.
>> That requires several levels of locking (cgroup and cpuset).
> 
>> The other issue is that cpusets are a bit too dynamic (see the thread above for more details)
>> we'd need notified mechanisms to notify subsystems when a CPUs become isolated. Again more
>> complexity. Since I integrated cpu isolation with cpu hotplug it's already addressed in a nice
>> simple way.
> 
> I guess you have another definition of nice than I do.
No, not really.
Lets talk specifics. My goal was not to introduce a bunch of new functionality 
and rewrite workqueues and stuff, instead I wanted to integrated with existing 
mechanisms. CPU maps are used everywhere and exporting cpu_isolated_map was a 
natural way to make other parts of the kernel aware of the isolated CPUs.

>> Please take a look at that discussion. I do not think it's worth the effort to put this into
>> cpusets. cpu_isolated_map is very clean and simple concept and integrates nicely with the 
>> rest of the cpu maps. ie It's very much the same concept and API as cpu_online_map, etc.
> 
> I'm thinking cpu_isolated_map is a very dirty hack.
> 
>> If we want to integrate this stuff with cpusets I think the best approach would be is to 
>> have cpusets update the cpu_isolated_map just like it currently updates scheduler domains. 
>>  
>>> CPU-sets can already isolate cpus by either creating a cpu outside of any set,
>>> or a set with a single cpu not shared by any other sets.
>> This only works for user-space. As I mentioned about for full CPU isolation various kernel 
>> subsystems need to be aware of that CPUs are isolated in order to avoid activities on them.
> 
> Yes, hence the proposed system flag to handle the kernel bits like
> unbounded kernel threads and IRQs.
I do not see a specific proposals here. The funny part that we're not even 
disagreeing on the high level. Yes It'd be nice to have such a flag ;-)
But how will genirq subsystem, for example, be aware of that flag ?
ie How would it know that by default it is not supposed to route irqs to the 
CPUs in the cpusets with that flag ?
As I explained above setting affinity for existing irqs is not enough.
Same for workqueus or any other susbsytem that wants to run per-cpu threads 
and stuff.

>>> This also allows for isolated groups, there are good reasons to isolate groups,
>>> esp. now that we have a stronger RT balancer. SMP and hard RT are not
>>> exclusive. A design that does not take that into account is too rigid.
> 
>> You're thinking scheduling only. Paul had the same confusion ;-)
> 
> I'm not, I'm thinking it ought to allow for it.
One way I can think of how to support groups and allow for RT balancer is 
this: Make scheduler ignore cpu_isolated_map and give cpusets full control of 
the scheduler domains. Use cpu_isolated_map to only for hw irq and other 
kernel sub-systems. That way cpusets could mark cpus in the group as isolated 
to get rid of the  kernel activity and build sched domain such that tasks get 
balanced in it.
The thing I do not like about it is that there is no way to boot the system 
with CPU N isolated from the beginning. Also dynamic isolation currently 
relies on the cpu hotplug to clear pending irqs, softirqs, kernel timers and 
threads. So cpusets would have to simulate the cpu hotplug event I guess.

>> As I explained before I'm redefining (or proposing to redefine) CPU isolation to
>>
>> 1. Isolated CPU(s) must not be subject to scheduler load balancing
>>  Users must explicitly bind threads in order to run on those CPU(s).
> 
> I'm thinking that should be optional, load-balancing might make sense
> under some scenarios.
It's still optional. It's the sane default though. I mean users are welcome to 
change affinity mask of an active IRQ.
btw You definitely want to start with that as default for complete isolation, 
because some drivers, E1000 for example, schedule timers and stuff on the CPU 
they handle IRQ on. The timer gets restarted from then on (until iface is 
brought down). Which means that the timer sticks with the CPU even if IRQ is 
moved.
Please do not tell me that I need to fix E1000 instead ;-). It's just an 
example. I'm sure there are other drivers and friends. For the full isolation 
you want to bring the cpu down to get everything off of it and then bring it 
up such that things are not started on it by default. Only then you get a 
truly clean isolated state.

>> 2. By default interrupts must not be routed to the isolated CPU(s)
>>  User must route interrupts (if any) to those CPUs explicitly.
> 
> That is what I allowed for by the system flag.
> 
>> 3. In general kernel subsystems must avoid activity on the isolated CPU(s) as much as possible
>>  Includes workqueues, per CPU threads, etc.
>>  This feature is configurable and is disabled by default.
> 
> How am I refuting any of these points? I'm very clear on what you want,
> I'm just saying I want to get there differently.
I guess maybe you're not refuting them. But you're not giving me concrete 
examples of how low level stuff would work. Lets talks specifics. I'm not 
stuck on the cpu_isolated_map, if there are better options I'm all for it.
I'm willing to prototype it and see if it works for my usecase. But I need 
more details than "system flag in cpuset".

>>>>    cpuisol: Do not route IRQs to the CPUs isolated at boot
>>> >From the diffstat you're not touching the genirq stuff, but instead hack a
>>> single architecture to support this feature. Sounds like an ill designed hack.
>> Ah, good point. This patches started before genirq was merged and I did not realize
>> that there is a way to set default irq affinity with genirq.
>> I'll definitely take a look at that.
> 
> I said so before, but good to see you've picked this up. I didn't know
> if there was a genirq way to set smp affinities - but if there wasn't
> this was a good moment to introduce that.
"Default" affinity was the keyword here. Genirq definitely deals with 
affinities in general. Anyway, as you saw I rewrote it on top of genirq.
Waiting for review feedback from Thomas.

>>> A better approach would be to add a flag to the cpuset infrastructure that says
>>> whether its a system set or not. A system set would be one that services the
>>> general purpose OS and would include things like the IRQ affinity and unbound
>>> kernel threads (including unbound workqueues - or single workqueues). This flag
>>> would default to on, and by switching it off for the root set, and a select
>>> subset you would push the System away from those cpus, thereby isolating them.
>> You're talking about very high level API. I'm totally all for it. What the patches deal 
>> with is actual low level stuff that is needed to do the "push the system away from those cpus".
>> As I mentioned above we can have cpuset update cpu_isolated_map for example.
> 
> I'm not wanting to extend cpu_isolated_map - I'm wanting to get rid of
> it entirely.
Please be specific. Lets say we get rid of the cpu_isolated_map. How would 
that "system" flag be propagated to the lowest layers like genirq, workqueue, 
etc ?

>>>>    cpuisol: Do not schedule workqueues on the isolated CPUs
>>>  
>>> (per-cpu workqueues, the single ones are treated in the previous section)
>>>
>>> I still strongly disagree with this approach. Workqueues are passive, they
>>> don't do anything unless work is provided to them. By blindly not starting them
>>> you handicap the system and services that rely on them.
>> Oh boy, back to square one. I covered this already.
>> I even started a thread on that and explained what this is and why its needed.
>> 	http://marc.info/?l=linux-kernel&m=120217173001671&w=2
>> You guys never replied.
> 
> Right, sorry, I did indeed miss that one (might still be in my inbox -
> I'm having trouble getting to 0 unread these days).
> 
> I'm thinking moving away from flush would be a good idea. Often there is
> no need for a full flush but just wait for completion of all 'your'
> worklets - as opposed by all worklets.
> 
> I've ran into this in -rt in another context but managed to work around
> it. It might be time to look at it again.
I think there were other cases besides flushing that wanted all threads to 
report back. But I do not remember exact scenario of the top of my head.

> (fwiw, workqueues in -rt are priority aware)
That does not help me because I need full isolation.

>> You last statement above (about handicap) does not make much sense with respect to the CPU 
>> isolation. I mean we cannot have it both ways, for isolated CPUs not to run kernel subsystems
>> and at the same time say that we must not impact the system. Of course it impacts the system,
>> in a predictable and controlled way. Non-isolated CPUs are not affected at all. And app threads 
>> that need full system services should not be running on the isolated CPUs. 
> 
> I'm saying we should remove the generation of work, not the execution of
> work when its needed. By keeping the workqueues around you might even
> allow routing a single non custom IRQ to an isolated CPU. One that uses
> softirqs for instance.
> 
> Its all about allowing other scenarios than the one you need, while
> serving your needs equally well.
I agree in general. From my experience though it is kind of hard and the 
system might be a bit fragile.
Also I can give you another example. In some cases it's preferable if 
workqueues and stuff triggered as the result of the syscalls on the isolated 
cpus ran on the non-isolated cpus. Same for the IRQ. Workqueues are generally 
a background activity. It may make sense to handle IRQ/softirq on the isolated 
CPU and off-load the rest to the non-isoalted one. In which case you'd want 
exactly what my patch does, ie pro-active rerouting of work scheduled on the 
isolated CPU.

To sum it up. Lets talk details.
How the "system" flag you suggested would be propagated to the genirq, 
workqueue, etc ? How do we avoid work being scheduled on those CPUs ?

Max
