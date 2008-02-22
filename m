Return-Path: <linux-kernel-owner+w=401wt.eu-S1765874AbYBVWFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765874AbYBVWFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbYBVWFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:05:20 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4201 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbYBVWFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:05:16 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5236"; a="774832"
Message-ID: <47BF4719.9020000@qualcomm.com>
Date: Fri, 22 Feb 2008 14:05:13 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH sched-devel 0/7] CPU isolation extensions
References: <47BE35B7.2070104@qualcomm.com> <1203680600.6242.20.camel@lappy>
In-Reply-To: <1203680600.6242.20.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2008-02-21 at 18:38 -0800, Max Krasnyanskiy wrote:
> 
>> As you suggested I'm sending CPU isolation patches for review/inclusion into 
>> sched-devel tree. They are against 2.6.25-rc2.
>> You can also pull them from my GIT tree at
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/maxk/cpuisol-2.6.git master
>  
> Post patches! I can't review a git tree..
I did. But it looks like I screwed the --cc list. I just resent them.
  
>> List of commits
>>    cpuisol: Make cpu isolation configrable and export isolated map
>  
> cpu_isolated_map was a bad hack when it was introduced, I feel we should
> deprecate it and fully integrate the functionality into cpusets. That would
> give a much more flexible end-result.
That's not not currently possible and will introduce a lot of complexity.
I'm pretty sure you missied the discussion I had with Paul (you were cc'ed on that btw).
In fact I provided the link to that discussion in the original email.
Here it is again:
	http://marc.info/?l=linux-kernel&m=120180692331461&w=2

Basically the problem is very simple. CPU isolation needs a simple/efficient way to check 
if CPU N is isolated. cpuset/cgroup APIs are not designed for that. In other to figure
out if a CPU N is isolated one has to iterate through all cpusets and checks their cpu maps.
That requires several levels of locking (cgroup and cpuset).
The other issue is that cpusets are a bit too dynamic (see the thread above for more details)
we'd need notified mechanisms to notify subsystems when a CPUs become isolated. Again more
complexity. Since I integrated cpu isolation with cpu hotplug it's already addressed in a nice
simple way.
Please take a look at that discussion. I do not think it's worth the effort to put this into
cpusets. cpu_isolated_map is very clean and simple concept and integrates nicely with the 
rest of the cpu maps. ie It's very much the same concept and API as cpu_online_map, etc.

If we want to integrate this stuff with cpusets I think the best approach would be is to 
have cpusets update the cpu_isolated_map just like it currently updates scheduler domains. 
 
> CPU-sets can already isolate cpus by either creating a cpu outside of any set,
> or a set with a single cpu not shared by any other sets.
This only works for user-space. As I mentioned about for full CPU isolation various kernel 
subsystems need to be aware of that CPUs are isolated in order to avoid activities on them.
 
> This also allows for isolated groups, there are good reasons to isolate groups,
> esp. now that we have a stronger RT balancer. SMP and hard RT are not
> exclusive. A design that does not take that into account is too rigid.
You're thinking scheduling only. Paul had the same confusion ;-)
As I explained before I'm redefining (or proposing to redefine) CPU isolation to

1. Isolated CPU(s) must not be subject to scheduler load balancing
 Users must explicitly bind threads in order to run on those CPU(s).

2. By default interrupts must not be routed to the isolated CPU(s)
 User must route interrupts (if any) to those CPUs explicitly.

3. In general kernel subsystems must avoid activity on the isolated CPU(s) as much as possible
 Includes workqueues, per CPU threads, etc.
 This feature is configurable and is disabled by default.

Only #1 has to do with the scheduling. The rest has _nothing_ to do with it.
 
>>    cpuisol: Do not route IRQs to the CPUs isolated at boot
> 
>>From the diffstat you're not touching the genirq stuff, but instead hack a
> single architecture to support this feature. Sounds like an ill designed hack.
Ah, good point. This patches started before genirq was merged and I did not realize
that there is a way to set default irq affinity with genirq.
I'll definitely take a look at that.
 
> A better approach would be to add a flag to the cpuset infrastructure that says
> whether its a system set or not. A system set would be one that services the
> general purpose OS and would include things like the IRQ affinity and unbound
> kernel threads (including unbound workqueues - or single workqueues). This flag
> would default to on, and by switching it off for the root set, and a select
> subset you would push the System away from those cpus, thereby isolating them.
You're talking about very high level API. I'm totally all for it. What the patches deal 
with is actual low level stuff that is needed to do the "push the system away from those cpus".
As I mentioned above we can have cpuset update cpu_isolated_map for example.

>>    cpuisol: Do not schedule workqueues on the isolated CPUs
>  
> (per-cpu workqueues, the single ones are treated in the previous section)
> 
> I still strongly disagree with this approach. Workqueues are passive, they
> don't do anything unless work is provided to them. By blindly not starting them
> you handicap the system and services that rely on them.
Oh boy, back to square one. I covered this already.
I even started a thread on that and explained what this is and why its needed.
	http://marc.info/?l=linux-kernel&m=120217173001671&w=2
You guys never replied.
Anyway. Workqueues are indeed passive for the most part. But there are several conditions
when _every_ work queue thread is expected to report back. Look for example at how workqueues
are flushed (see thread above for the code example). In short it schedules dummy work on each
online CPU and _waits_ for it to report back. 
As I mentioned before I also thought that they are passive. They are _not_. They way I noticed 
problems in first place is when systems started hanging while unmounting NFS mounts because
workqueue threads could not run due to higher priority user-space threads.

You last statement above (about handicap) does not make much sense with respect to the CPU 
isolation. I mean we cannot have it both ways, for isolated CPUs not to run kernel subsystems
and at the same time say that we must not impact the system. Of course it impacts the system,
in a predictable and controlled way. Non-isolated CPUs are not affected at all. And app threads 
that need full system services should not be running on the isolated CPUs. 

> (you even acknowledged this problem, by saying it breaks oprofile for instance
> - still trying to push a change that knowingly breaks a lot of stuff is bad
> manners on lkml and not acceptable for mainline)
Uh, hold on. How did "it breaks oprofile" translated into "breaks a lot of stuff" ?
As far as I know it only affects oprofile. And I did test the heck out of this. As I mentioned
we're running our full fledged production systems with these patches. Surely I may have missed
some other feature that may break. But saying that it breaks a lot of things is a major 
overstatement.
Most subsystems start workqueue threads on each CPU purely for load balancing. And like I said 
above we cannot have it both ways, either the CPU is isolated and does not participate in load
balancing or it's not.

>>    cpuisol: Do not halt isolated CPUs with Stop Machine
> 
> Very strong NACK on this one, it breaks a lot of functionality in non-obvious
> ways, as has been pointed out to you numerous times. Such patches are just not
> acceptable for mainline - full stop.
Ok Peter. You're not participating in stop machine discussions yet you're ok with making statements
like that. I did mark this as experimental and explained that at this point it's the only way to
support module loading/unloading with the usecase I described. We're thinking about ways to make
module load/unload not use stopmachine. In which case the patch will not be necessary. For now I'd
rather give users an option, than no options.
Anyway I'm ok if this particular patch does not go in at this point. I'll drop it from the next 
submissions for now, until we figure out how to not use stopmachine or something like that.

> Please, the ideas are not bad and have been suggested in the context of -rt a
> number of times, its just the execution. Design features so that they are
> flexible and can be used in ways you never imagined them. But more
> importantly so that they don't knowingly break tons of stuff.
"breaks a lot of stuff" is now "breaks a ton of stuff" ;-).
I agree about the stop machine thing. Everything else though I believe is very clean. Hopefully
my explanation above clarified the design choices better this time.
I'm open to suggestions. 

Max
