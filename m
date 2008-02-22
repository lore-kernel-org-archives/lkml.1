Return-Path: <linux-kernel-owner+w=401wt.eu-S934719AbYBVNlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934719AbYBVNlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 08:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755874AbYBVNlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 08:41:14 -0500
Received: from mx2.compro.net ([216.54.166.4]:32981 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651AbYBVNlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 08:41:14 -0500
X-IronPort-AV: E=Sophos;i="4.25,391,1199682000"; 
   d="scan'208";a="1744312"
Message-ID: <47BED03A.5070707@compro.net>
Date: Fri, 22 Feb 2008 08:38:02 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Max Krasnyanskiy <maxk@qualcomm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH sched-devel 0/7] CPU isolation extensions
References: <47BE35B7.2070104@qualcomm.com> <1203680600.6242.20.camel@lappy>
In-Reply-To: <1203680600.6242.20.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
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
>  

Max, could you also post them for 2.6.24.2 stable please. Thanks


>> Diffstat:
>>  b/Documentation/ABI/testing/sysfs-devices-system-cpu |   41 ++++++
>>  b/Documentation/cpu-isolation.txt                    |  114 ++++++++++++++++++-
>>  b/arch/x86/Kconfig                                   |    1 
>>  b/arch/x86/kernel/genapic_flat_64.c                  |    5 
>>  b/drivers/base/cpu.c                                 |   48 ++++++++
>>  b/include/linux/cpumask.h                            |    3 
>>  b/kernel/Kconfig.cpuisol                             |   15 ++
>>  b/kernel/Makefile                                    |    4 
>>  b/kernel/cpu.c                                       |   49 ++++++++
>>  b/kernel/sched.c                                     |   37 ------
>>  b/kernel/stop_machine.c                              |    9 +
>>  b/kernel/workqueue.c                                 |   31 +++--
>>  kernel/Kconfig.cpuisol                               |   56 ++++++---
>>  kernel/cpu.c                                         |   16 +-
>>  14 files changed, 356 insertions(+), 73 deletions(-)
>>
>> List of commits
>>    cpuisol: Make cpu isolation configrable and export isolated map
>  
> cpu_isolated_map was a bad hack when it was introduced, I feel we should
> deprecate it and fully integrate the functionality into cpusets. That would
> give a much more flexible end-result.
> 
> CPU-sets can already isolate cpus by either creating a cpu outside of any set,
> or a set with a single cpu not shared by any other sets.
> 

Peter, what about when I am NOT using cpusets and are disabled in my config but
I still want to use this?

> This also allows for isolated groups, there are good reasons to isolate groups,
> esp. now that we have a stronger RT balancer. SMP and hard RT are not
> exclusive. A design that does not take that into account is too rigid.
> 
>>    cpuisol: Do not route IRQs to the CPUs isolated at boot
> 
>>From the diffstat you're not touching the genirq stuff, but instead hack a
> single architecture to support this feature. Sounds like an ill designed hack.
> 
> A better approach would be to add a flag to the cpuset infrastructure that says
> whether its a system set or not. A system set would be one that services the
> general purpose OS and would include things like the IRQ affinity and unbound
> kernel threads (including unbound workqueues - or single workqueues). This flag
> would default to on, and by switching it off for the root set, and a select
> subset you would push the System away from those cpus, thereby isolating them.
> 
>>    cpuisol: Do not schedule workqueues on the isolated CPUs
>  
> (per-cpu workqueues, the single ones are treated in the previous section)
> 
> I still strongly disagree with this approach. Workqueues are passive, they
> don't do anything unless work is provided to them. By blindly not starting them
> you handicap the system and services that rely on them.
> 

Have things changed since since my first bad encounter with Workqueues.
I am referring to this thread. 

http://kerneltrap.org/mailarchive/linux-kernel/2007/5/29/97039 

> (you even acknowledged this problem, by saying it breaks oprofile for instance
> - still trying to push a change that knowingly breaks a lot of stuff is bad
> manners on lkml and not acceptable for mainline)
> 
> The way to do this is to avoid the generation of work, not the execution of it.
> 
>>    cpuisol: Move on-stack array used for boot cmd parsing into __initdata
>>    cpuisol: Documentation updates
>>    cpuisol: Minor updates to the Kconfig options
>  
> No idea about these patches,... 
> 
>>    cpuisol: Do not halt isolated CPUs with Stop Machine
> 
> Very strong NACK on this one, it breaks a lot of functionality in non-obvious
> ways, as has been pointed out to you numerous times. Such patches are just not
> acceptable for mainline - full stop.
> 
> 

Mark
