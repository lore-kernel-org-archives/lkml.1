Return-Path: <linux-kernel-owner+w=401wt.eu-S1764285AbYBVCjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764285AbYBVCjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 21:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYBVCiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 21:38:51 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19398 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbYBVCiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 21:38:50 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5235"; a="758606"
Message-ID: <47BE35B7.2070104@qualcomm.com>
Date: Thu, 21 Feb 2008 18:38:47 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH sched-devel 0/7] CPU isolation extensions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

As you suggested I'm sending CPU isolation patches for review/inclusion into 
sched-devel tree. They are against 2.6.25-rc2.
You can also pull them from my GIT tree at
	git://git.kernel.org/pub/scm/linux/kernel/git/maxk/cpuisol-2.6.git master
 
Diffstat:
 b/Documentation/ABI/testing/sysfs-devices-system-cpu |   41 ++++++
 b/Documentation/cpu-isolation.txt                    |  114 ++++++++++++++++++-
 b/arch/x86/Kconfig                                   |    1 
 b/arch/x86/kernel/genapic_flat_64.c                  |    5 
 b/drivers/base/cpu.c                                 |   48 ++++++++
 b/include/linux/cpumask.h                            |    3 
 b/kernel/Kconfig.cpuisol                             |   15 ++
 b/kernel/Makefile                                    |    4 
 b/kernel/cpu.c                                       |   49 ++++++++
 b/kernel/sched.c                                     |   37 ------
 b/kernel/stop_machine.c                              |    9 +
 b/kernel/workqueue.c                                 |   31 +++--
 kernel/Kconfig.cpuisol                               |   56 ++++++---
 kernel/cpu.c                                         |   16 +-
 14 files changed, 356 insertions(+), 73 deletions(-)

List of commits
   cpuisol: Make cpu isolation configrable and export isolated map
   cpuisol: Do not route IRQs to the CPUs isolated at boot
   cpuisol: Do not schedule workqueues on the isolated CPUs
   cpuisol: Move on-stack array used for boot cmd parsing into __initdata
   cpuisol: Documentation updates
   cpuisol: Minor updates to the Kconfig options
   cpuisol: Do not halt isolated CPUs with Stop Machine

This patch series extends CPU isolation support.
The primary idea here is to be able to use some CPU cores as the dedicated engines for running
user-space code with minimal kernel overhead/intervention, think of it as an SPE in the 
Cell processor. I'd like to be able to run a CPU intensive (%100) RT task on one of the 
processors without adversely affecting or being affected by the other system activities. 
System activities here include _kernel_ activities as well. 

I'm personally using this for hard realtime purposes. With CPU isolation it's very easy to 
achieve single digit usec worst case and around 200 nsec average response times on off-the-shelf
multi- processor/core systems (vanilla kernel plus these patches) even under extreme system load. 
I'm working with legal folks on releasing hard RT user-space framework for that.
I believe with the current multi-core CPU trend we will see more and more applications that 
explore this capability: RT gaming engines, simulators, hard RT apps, etc.

Hence the proposal is to extend current CPU isolation feature.
The new definition of the CPU isolation would be:
---
1. Isolated CPU(s) must not be subject to scheduler load balancing
  Users must explicitly bind threads in order to run on those CPU(s).

2. By default interrupts must not be routed to the isolated CPU(s)
  User must route interrupts (if any) to those CPUs explicitly.

3. In general kernel subsystems must avoid activity on the isolated CPU(s) as much as possible
  Includes workqueues, per CPU threads, etc.
  This feature is configurable and is disabled by default.  
---

I've been maintaining this stuff since around 2.6.18 and it's been running in production
environment for a couple of years now. It's been tested on all kinds of machines, from NUMA
boxes like HP xw9300/9400 to tiny uTCA boards like Mercury AXA110.
The messiest part used to be SLAB garbage collector changes. With the new SLUB all that mess 
goes away (ie no changes necessary). Also CFS seems to handle CPU hotplug much better than O(1) 
did (ie domains are recomputed dynamically) so that isolation can be done at any time (via sysfs). 
So this seems like a good time to merge. 

We've had scheduler support for CPU isolation ever since O(1) scheduler went it. In other words
#1 is already supported. These patches do not change/affect that functionality in any way. 
#2 is trivial one liner change to the IRQ init code. 
#3 is addressed by a couple of separate patches. The main problem here is that RT thread can prevent
kernel threads from running and machine gets stuck because other CPUs are waiting for those threads
to run and report back.

Folks involved in the scheduler/cpuset development provided a lot of feedback on the first series
of patches. I believe I managed to explain and clarify every aspect. 
Paul Jackson initially suggested to implement #2 and #3 using cpusets subsystem. Paul and I looked 
at it more closely and determined that exporting cpu_isolated_map instead is a better option.
Details here
	http://marc.info/?l=linux-kernel&m=120180692331461&w=2

Last patch to the stop machine is potentially unsafe and is marked as experimental. Unfortunately 
it's currently the only option that allows dynamic module insertion/removal for above scenarios. 
>From the previous discussions it's the only controversial part.

Thanx
Max
