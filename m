Return-Path: <linux-kernel-owner+w=401wt.eu-S1762378AbYAaTNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762378AbYAaTNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 14:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932113AbYAaTNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 14:13:17 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:36081 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765676AbYAaTNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 14:13:14 -0500
Message-ID: <47A21C53.2010502@qualcomm.com>
Date: Thu, 31 Jan 2008 11:06:59 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, mingo@elte.hu,
       srostedt@redhat.com, ghaskins@novell.com
Subject: Integrating cpusets and cpu isolation [was Re: [CPUISOL] CPU isolation
 extensions]
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>	<1201511305.6149.30.camel@lappy>	<20080128085910.7d38e9f5.pj@sgi.com>	<479E20DA.2080403@qualcomm.com> <20080128130637.60db148e.pj@sgi.com>
In-Reply-To: <20080128130637.60db148e.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max wrote:
>> So far it seems that extending cpu_isolated_map
>> is more natural way of propagating this notion to the rest of the kernel.
>> Since it's very similar to the cpu_online_map concept and it's easy to integrated
>> with the code that already uses it. 
> 
> If it were just realtime support, then I suspect I'd agree that
> extending cpu_isolated_map makes more sense.
> 
> But some people use realtime on systems that are also heavily
> managed using cpusets.  The two have to work together.  I have
> customers with systems running realtime on a few CPUs, at the
> same time that they have a large batch scheduler (which is layered
> on top of cpusets) managing jobs on a few hundred other CPUs.
> Hence with the cpuset 'sched_load_balance' flag I think I've already
> done what I think is one part of what your patches achieve by extending
> the cpu_isolated_map.
> 
> This is a common situation with "resource management" mechanisms such
> as cpusets (and more recently cgroups and the subsystem modules it
> supports.)  They cut across existing core kernel code that manages such
> key resources as CPUs and memory.  As best we can, they have to work
> with each other.

Hi Paul,

I thought some more about your proposal to use sched_load_balance flag in cpusets instead
of extending cpu_isolated_map. I looked at the cpusets, cgroups, latest thread started by
Peter (about sched domains and stuff) and here are my thoughts on this.

Here is the list of things of issues with sched_load_balance flag from CPU isolation 
perspective:
--
(1) Boot time isolation is not possible. There is currently no way to setup a cpuset at
boot time. For example we won't be able to isolate cpus from irqs and workqueues at boot.
Not a major issue but still an inconvenience.

--
(2) There is currently no easy way to figure out what cpuset a cpu belongs to in order 
to query it's sched_load_balance flag. In order to do that we need a method that iterates
all active cpusets and checks their cpus_allowed masks. This implies holding cgroup and 
cpuset mutexes. It's not clear whether it's ok to do that from the the contexts CPU 
isolation happens in (apic, sched, workqueue). It seems that cgroup/cpuset api is designed
from top down access. ie adding a cpu to a set and then recomputing domains. Which makes
perfect sense for the common cpuset usecase but is not what cpu isolation needs.
In other words I think it's much simpler and cleaner to use the cpu_isolated_map for isolation
purposes.

--
(3) cpusets are a bit too dynamic :). What I mean by this is that sched_load_balance flag
can be changed at any time without bringing a CPU offline. What that means is that we'll
need some notifier mechanisms for killing and restarting workqueue threads when that flag 
changes. Also we'd need some logic that makes sure that a user does not disable load balancing 
on all cpus because that effectively will kill workqueues on all the cpus.
This particular case is already handled very nicely in my patches. Isolated bit can be set
only when cpu is offline and it cannot be set on the first online cpu. Workqueus and other
subsystems already handle cpu hotplug events nicely and can easily ignore isolated cpus when
they come online.

-----

#1 is probably unfixable. #2 and #3 can be fixed but at the expense of extra complexity across
the board. I seriously doubt that I'll be able to push that through the reviews ;-). 

Also personally I still think cpusets and cpu isolation attack two different problems. cpusets 
is about partitioning cpus and memory nodes, and managing tasks. Most of the cgroups/cpuset APIs 
are designed to deal with tasks. CPU isolation is much simpler and is at the lower layer. It deals 
with IRQs, kernel per cpu threads, etc. The only intersection I see is that both features affect 
scheduling domains (cpu isolation is again simple here it just puts cpus into null domains and
that's an existing logic in sched.c nothing new here).
So here are some proposal on how we can make them play nicely with each other. 

--
(A) Make cpusets aware of isolated cpus.
All we have to do here is to change 
	guarantee_online_cpus()
	common_cpu_mem_hotplug_unplug()
to exclude cpu_isolated_map from cpu_online_map before using it.
And we'd need to change 
	update_cpumasks()
to simply ignore isolated cpus.

That way if a cpu is isolated it'll be ignored by the cpusets logic. Which I believe would be
correct behavior. 
We're talking trivial ~5 liner patch which will be noop if cpu isolation is disabled.

(B) Ignore isolated map in cpuset. That's the current state of affairs with my patches applied.
Looks like your customers are happy with what they have now so they will probably not enable 
cpu isolation anyway :).

(C) Introduce cpu_usable_map. That map will be recomputed on hotplug events. Essentially it'd be
cpu_online_map AND ~cpu_isolated_map. Convert things like cpusets to use that map instead of 
online map.

We can probably come up with other options. My preference would be option (A).
I can kook up a patch for this and re-send the patch series. 
What do you think ?

btw My impression is that we're talking about very different use cases here. You're talking big
machines with lots of cpus and I'm thinking your probably talking soft RT here, probably RT 
networking services or something like that.

Use case I'm talking about is a dedicated machine for a certain task. Like HW simulator, wireless 
base station with SW MAC, etc. For this in any foreseeable future most common configuration will
be 2-8 cores. cpusets is probably an overkill here because apps will want to manage thread affinities
themselves anyways (for example right now we bind soft-RT threads to CPU0 and hard-RT thread to CPU1).

Sorry for the typos :)
Max
