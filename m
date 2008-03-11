Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYCKVbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYCKVbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYCKVbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:31:44 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44517 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYCKVbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:31:43 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5249"; a="1044399"
Message-ID: <47D6FA31.6010801@qualcomm.com>
Date: Tue, 11 Mar 2008 14:31:29 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com
Subject: Re: [PATCH 1/2] cpuset: cpuset irq affinities
References: <1205215046-27085-1-git-send-email-maxk@qualcomm.com>	<1205215046-27085-2-git-send-email-maxk@qualcomm.com>	<20080311015711.9c4615a6.pj@sgi.com>	<47D6C08E.9040701@qualcomm.com> <20080311140858.d0ecd47f.pj@sgi.com>
In-Reply-To: <20080311140858.d0ecd47f.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Jackson wrote:
> Max wrote:
>> Please take a look at
>> 	[PATCH 2/2] cpusets: Improved irq affinity handling
>> I'm treating irqs just like tasks (at least I think I'm :).
> 
> Well, I see the one comment in your Patch 2/2 noting you're unsure
> of the locking in one place.
> 
> I don't see any further comments on or additional code involving
> locking.
I did not think they were need. I'll take another look at it.
Do have anything in particular where you think that locking needs to be
clarified/explained ?

> I don't see where you respond to my discussion with Peter of March
> 6 and 7, where I expressed some doubts about Peters patch (which you
> built on in your patch 1/2 in this series).
> 
> I see only a little bit of additional comments in your patch 2/2
> regarding handling of moving irqs to higher non-empty cpusets if a
> cpuset is emptied of its CPUs.
> 
> I don't see any explanation of what you mean by "desired semantics."
> 
> I don't see any response to the alternatives to Peter's earlier patch
> (your Patch 1/2 here) that Peter and I discussed in that discussion of
> March 6 and 7.
Ok. I must admit that I tuned out of that discussion. I read it again just now
and my impression is that you guys went a bit off road :). I mean it seems to
me that we're making it more complicated that it needs to be.
I'm thinking of irqs as tasks (in the cpuset context). Think of an irq number
as task pid. Just like we assign a task to a cpuset we can (with this patch)
assign an irq to a cpuset.

Yes, some HW may not map nicely into that kind of view, but so far nobody has
provided any real examples of such hw. I'm sure it exists but as I suggested
before (I believe Ingo suggested that too) we can just return an error if irq
move failed. The patches already handle this scenarios (for example you won't
be able to assign an irq to the cpuset if irq_set_affinity(irq,
cs->cpus_allowed) fails, and if move to parent fails we move it all the way up).

I think this simple concept works for most use cases and is familiar for
people who deal with /proc/irq/N/smp_affinity. Currently we assign each
individual irq to a list of cpus (represented by a mask). With the patch we
can now assign an irq to a list of cpus represented by the cpuset.

So the "desired semantics" in my mind is to be able assign an IRQ to a cpuset
in the same way we do that we the tasks.

> And, in particular, could you respond to the question in my last
> message:
> 
>> What semantics to you impose on irqs in overlapping cpusets,
>> which would seem to lead to conflicting directives as to
>> whether one set or another of irqs was to be applied to the
>> CPUs in the overlap?
I thought I did, respond that is. That's what I meant by "I treat them just
like tasks". A task can be assigned to only one cpuset, so is the irq. If the
cpuset that it's assigned to is overlapping with some other cpuset it does not
change that task's behavior. It's still constrained to the cpus allotted for
that cpuset. Same exact thing for the irq.
To give you an example. Lets say we have:
	/dev/cpuset/set0
		cpus=0-1
		cpu_exclusive=0
	/dev/cpuset/set1
		cpus=1-2
		cpu_exclusive=0

Tasks assigned to set0 will only run on cpu0 and cpu1, so will the irqs. It
does not matter that set1 is overlapping with set0.

----
My personal use case for the cpu isolation goes like this:
2way box
	/dev/cpuset/
		cpuset.sched_load_balance=0
		/boot
			cpus=0
			cpu_exclusive=0
			irqs=(all irqs)
			tasks=(all user and kernel tasks)
		/myapp0
			cpus=0,1
			cpu_exclusive=0
			irqs=(rt irqs)
			tasks=(myapp tasks)

The patches have been tested on that exact 2way setup and a couple of other
different combination with child cpusets under myapp0 for testing irq
migration due to hotplug events.

4way box
	/dev/cpuset/
		cpuset.sched_load_balance=0
		/boot
			cpus=0,1
			cpu_exclusive=0
			sched_load_balance=1
			irqs=(all irqs)
			tasks=(all user and kernel tasks)
		/myapp0
			cpus=0,1,2,3
			cpu_exclusive=0
			sched_load_balance=0
			irqs=(none)
			tasks=(myapp tasks)
		/myapp1
			cpus=2,3
			cpu_exclusive=0
			sched_load_balance=0
			irqs=(rt irqs)
			tasks=(none)
Disclaimer: I have not tried the 4way setup above yet. I do not see why it
would not work though.
			
In case you're wondering why I'm assigning all cpus to '/myapp0' is because as
I mentioned before in my case some threads need to run along with other
regular apps on the cpus that provide full kernel services and other threads
must run on the isolated cpus. '/myapp1' is used only for (rt irqs).

Max
