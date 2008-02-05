Return-Path: <linux-kernel-owner+w=401wt.eu-S1762836AbYBEW4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762836AbYBEW4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbYBEW4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:56:23 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:50660 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbYBEW4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:56:22 -0500
Message-ID: <47A8E977.3040500@qualcomm.com>
Date: Tue, 05 Feb 2008 14:55:51 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Jackson <pj@sgi.com>
Subject: cpuisol: CPU isolation extensions (take 2)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that git-send-email for some reasons did not send an introductory email.
So I'm sending it manually. Sorry if you get it twice.

---

Following patch series extends CPU isolation support. Yes, most people want to virtuallize 
CPUs these days and I want to isolate them  :) .

The primary idea here is to be able to use some CPU cores as the dedicated engines for running
user-space code with minimal kernel overhead/intervention, think of it as an SPE in the 
Cell processor. I'd like to be able to run a CPU intensive (%100) RT task on one of the 
processors without adversely affecting or being affected by the other system activities. 
System activities here include _kernel_ activities as well. 

I'm personally using this for hard realtime purposes. With CPU isolation it's very easy to 
achieve single digit usec worst case and around 200 nsec average response times on off-the-shelf
multi- processor/core systems (vanilla kernel plus these patches) even under exteme system load. 
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
#2 is trivial one liner change to the IRQ init code. #3 is address by a couple of separate patches.

The patchset consist of 4 patches. First two are very simple. They simply make "CPU isolation" a 
configurable feature, export cpu_isolated_map and provide some helper functions to access it (just 
like cpu_online() and friends).
Last two patches add support for isolating CPUs from running workqueus and stop machine.
More details in the individual patch descriptions.

Folks involved in the scheduler/cpuset development provided a lot of feedback on the first series
of patches. I believe I managed to explain and clarify every aspect. 
Paul Jackson initially suggested to implement #2 and #3 using cpusets subsystem. Paul and I looked 
at it more closely and determined that exporting cpu_isolated_map instead is a better option. 

Last patch to the stop machine is potentially unsafe is marked as highly experimental. Unfortunately 
it's currently the only option that allows dynamic module insertion/removal for above scenarios. 
If people still feel that it's toooo ugly I can revert that change and keep it in the separate tree 
for now.

Ideally I'd like all of this to go in during this merge window. 
Linus please pull this patch set from
	git://git.kernel.org/pub/scm/linux/kernel/git/maxk/cpuisol-2.6.git

That tree is rebased against latest (as of today) Linus' tree.

Thanx
Max

 b/arch/x86/Kconfig                  |    1 
 b/arch/x86/kernel/genapic_flat_64.c |    5 ++-
 b/drivers/base/cpu.c                |   48 +++++++++++++++++++++++++++++++++++
 b/include/linux/cpumask.h           |    3 ++
 b/kernel/Kconfig.cpuisol            |   15 +++++++++++
 b/kernel/Makefile                   |    4 +-
 b/kernel/cpu.c                      |   49 ++++++++++++++++++++++++++++++++++++
 b/kernel/sched.c                    |   37 ---------------------------
 b/kernel/stop_machine.c             |    9 +++++-
 b/kernel/workqueue.c                |   31 ++++++++++++++++------
 kernel/Kconfig.cpuisol              |   26 ++++++++++++++++++-
 11 files changed, 176 insertions(+), 52 deletions(-)


 cpuisol: Make cpu isolation configrable and export isolated map
 cpuisol: Do not route IRQs to the CPUs isolated at boot
 cpuisol: Do not schedule workqueues on the isolated CPUs
 cpuisol: Do not halt isolated CPUs with Stop Machine





