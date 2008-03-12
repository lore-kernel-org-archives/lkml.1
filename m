Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbYCLSYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbYCLSYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYCLSYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:24:36 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11388 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbYCLSYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:24:35 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5250"; a="1063356"
Message-ID: <47D81FE1.6030205@qualcomm.com>
Date: Wed, 12 Mar 2008 11:24:33 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Paul Menage <menage@google.com>, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: boot cgroup questions
References: <47D73086.2030008@qualcomm.com>	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>	<47D7411E.1000009@qualcomm.com>	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>	<47D74595.4080100@qualcomm.com>	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com> <20080311235939.1ebee8e3.pj@sgi.com>
In-Reply-To: <20080311235939.1ebee8e3.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Paul M wrote:
>>>  they will now have to unset it in the 'boot' set as well.
>> That can break existing userspace, so I presume PaulJ isn't in favour
>> of this change.
> 
> You're right - I don't favor it.
Hmm, I think we're mixing two different threads here.
	1. How to map irq affinity handling onto cpusets.
	2. Whether and how to create in kernel 'boot' cgroup/cpuset.
They are somewhat orthogonal imho. In a sense that no mater how we decide to 
handle irqs (even if we do not do them under cpusets at all) we may still want 
'boot' group. As I mentioned at the beginning of this thread 'boot group/set 
is basically just a convenience feature. The only difference between root/top 
  group is that 'boot' group can be dynamically resized and moved.

Ok. So the rest of the email is mostly about irqs. It'd be nice if it was in 
the other thread (cpuset: irq affinity support) but I'm ok with replying here.

> Using the 'cpus' in one or more cpusets to determine both:
>  1) which CPUs can receive an irq, and
>  2) resolving conflicts in such irq placement,
> excessively overloads the cpuset hierarchy, breaking existing
> userspace, as Paul M notes.
> If you don't have any other cpuset hierarchy you need to use, and
> so don't really otherwise care what your cpuset hierarchy is, then
> I suppose this works just fine.
I'm not sure #2 is a concern. With the latest couset irq handling patches 
conflict resolution is very simple. "irq can belong to a single cpuset at a time".

> But if you also need to use the cpuset hierarchy to define nested
> subsets of CPUs and Memory Nodes, for the purposes of controlling
> which tasks can run where (the original and still primary motivation
> for cpusets) then one can only conveniently specify those trivial
> irq configurations that happen to exactly conform with that hierarchy
> (that exactly want to make use of some of the same sets of CPUs, and
> that don't depend on the hierarchy to resolve conflicts in overlapping
> irq directives).
I do not think we need overlapping irq directives.

> Almost any non-trivial use of cpusets for both irq directivity and CPU
> and Memory placement would complicate both hierarchies, forcing
> unending confusion and breakage on the existing cpuset users.
I'm not sure what breakage you're talking about. But lets talk examples I 
guess. See below.

> Some examples:
>     Let's say I have three cpusets defining the CPU and Memory Node
>     sets in which I want to place my tasks:
> 
> 	    /dev/cpuset/A
> 	    /dev/cpuset/B
> 	    /dev/cpuset/C
> 
>     and I want a particular set of irqs to be directed to the CPUs in A
>     and B, but not C.  Well -- guess I can duplicate the irqs settings.
> 
>     But don't tell me to use a 'boot' cpuset, as in:
> 
> 	    /dev/cpuset/boot/A
> 	    /dev/cpuset/boot/B
> 	    /dev/cpuset/C
> 
>     to accomplish this, as that intrudes in the hierarchy, breaking
>     user code.
> 
>     If my irq isolation needs don't exactly partition along the
>     'cpus' settings in A, B and C, then not even duplication helps.
> 
>     If the 'irqs' in /dev/cpuset/A/Z (where Z's cpus are a proper
>     subset of A's) don't match the 'irqs' in /dev/cpuset/A, then I
>     have further confusions resulting from conflicting irq directives.
How is that any different from tasks ? Exact same example right back at you.
Suppose I have a task that needs to run in A and B but not C. In fact if you 
look at the example that I provided in the other thread I already have such an 
app. In my current apps different threads have to run in different cpusets.

And yes I think the way to solve that is to use more complex cpuset hierarchy 
like the one you used above. I would not necessarily mix in the 'boot' set 
here. I mean if people want to subdivide it that's fine but they do not have 
to. I mean people can just nuke the 'boot' group/set and create something else.

> (If your proposal handles all the above, without forcing changes
> on the cpuset hierarchy, then I misread it - in that case, sorry.)
It does not force any changes. irqs handled just like tasks and if people have 
complex partitioning requirements they may have to use more complicated 
hierarchies.

> Paul M has already proposed pulling apart the binding of CPUs and
> Memory Nodes, in the underlying cgroups, as he apparently has cases in
> which the legacy connection of those two into a single cpuset hierarchy
> is an undesired constraint on (complication of) the hierarchy.
> That's more likely the direction in which we should be proceeding --
> making these hierarchies independent, not entwining them.
> 
> This additional overloading of the current cpuset hierarchy might
> handle the simple case you need.  But that's only because you don't
> have conflicting needs for the cpuset hierarchy.
> 
> Hopefully, Paul M will be able to view with some sense of humor that I
> am complaining that this proposal of yourself (and Peter Z's earlier
> patches) isn't general enough, even as I have complained of some of
> some other recent cgroup proposals of Paul M that their increased
> generality isn't sufficient to justify their subtle incompatibilities.
> 
> At a minimum, as in my proposal (http://lkml.org/lkml/2008/3/6/512) of
> last week, one needs some mechanism independent of the cpuset hierarchy
> to resolve conflicts in these irq directives.  As you may recall,
> that proposal named each set of irqs, let each cpuset specify which
> named set of irqs applied to its CPUs, and encoded the precedence N
> of each named list of irqs in the filename '/dev/cpuset/irqs.N.name'
> of the file listing the irqs in that named set.  Then one can specify
> irqs for each cpuset, and have some way to specify the precedence of
> these irq specifications, without overloading the cpuset hierarchy.
> 
> Even this minimum proposal might be insufficient, if one has needs
> to specify irq directives for sets of CPUs that are not otherwise
> present in the cpuset hierarchy.  Observe that this proposal does
> not handle the next to the last example case above.  I am not yet
> convinced that this deficiency is a show stopper.  It might be.
That (ie additional sets of irqs) seems like an major overkill to me.
Probably because I do not think that there are any conflicts to resolve in the 
first place. As I explained above if we treat irqs just like tasks (from 
cpuset perspective) then same exact rules and limitations apply. Irq can be 
assigned to a single cpuset at a time. Complex requirements can be solved 
either by deeper cgroup/cpuset hierarchies or worst case if there is something 
  totally wacky constraint people always have an option of assigning irq to 
the top cpuset and using /proc/irq/N/smp_affinity interface to select which 
cpus it can run on.

> The other direction considered, making this its own cgroup, -seemed-
> to fail as well, as someone, I forget whom, noted.  Cgroups attach
> tasks to sets of things.  We aren't trying to attach tasks to anything.
> We're trying to attach irqs to CPUs.  We are trying now to treat irqs
> as 'pseudo-tasks', but that forces the irq hierarchy to be a subset
> of the CPU hierarchy, due to overloading the 'cpus' set.  This is the
> problem noted above.
> 
> Paul M -- could we take a different tack here -- extend cgroups to map
> -either- tasks or irqs to the managed resources?  Then irqs would be
> managed by a cgroup hierarchy that mapped irqs to a subsystem specific
> attribute of 'cpus' (resembling the cpuset 'cpus').  If the hierarchy
> one needed for irqs was a nice subset of ones cpuset hierarchy, one
> might even mount both cgroup subsystems on the same mount, so long
> as we could work out what it means for two cgroup subsystems to share
> the same subsystem specific attribute, 'cpus' in this case.
Hold on. How does this help if at the end of the day 'cpus' are still shared 
between the irq and task groups ? We'd still have exact same constrains.

btw I'm starting to gravitate back towards my original solution (ie cpu_map 
that tells which cpus can be used by kernel and irqs). If you remember I was 
totally against using cpusets/cgroup exactly because they are designed to 
handle tasks. You guys convinced me that we can extend them and that it's a 
better way to go about. Yet after weeks of discussion we seem to be taking 
about adding more and more stuff.

Anyway, I think treating irqs as tasks and enforcing the same rules and 
constraints should handle most scenarios even complex ones at the expense of 
deeper cpuset hierarchies. Adding new 'cgroups' or 'sets' just for irqs seems 
overkill.

Max
