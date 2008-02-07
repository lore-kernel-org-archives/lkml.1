Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbYBGFdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbYBGFdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 00:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbYBGFdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 00:33:08 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:46211 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbYBGFdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 00:33:07 -0500
Message-ID: <47AA9807.7090402@qualcomm.com>
Date: Wed, 06 Feb 2008 21:32:55 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [git pull] CPU isolation extensions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull CPU isolation extensions from

git://git.kernel.org/pub/scm/linux/kernel/git/maxk/cpuisol-2.6.git for-linus
 
Diffstat:

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

The patchset consist of 4 patches. 
	cpuisol: Make cpu isolation configrable and export isolated map
	cpuisol: Do not route IRQs to the CPUs isolated at boot
	cpuisol: Do not schedule workqueues on the isolated CPUs
	cpuisol: Do not halt isolated CPUs with Stop Machine

First two are very simple. They simply make "CPU isolation" a 
configurable feature, export cpu_isolated_map and provide some helper functions to access it (just 
like cpu_online() and friends).
Last two patches add support for isolating CPUs from running workqueus and stop machine. Last patch
is kind of controversial let me know if you think it's too ugly and I'll resend without it.
For more details see below.

----
This patch series extends CPU isolation support. Yes, most people want to virtuallize 
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
#2 is trivial one liner change to the IRQ init code. 
#3 is addressed by a couple of separate patches. The main problem here is that RT thread can prevent
kernel threads from running and machine gets stuck because other CPUs are waiting for those threads
to run and report back.

Folks involved in the scheduler/cpuset development provided a lot of feedback on the first series
of patches. I believe I managed to explain and clarify every aspect. 
Paul Jackson initially suggested to implement #2 and #3 using cpusets subsystem. Paul and I looked 
at it more closely and determined that exporting cpu_isolated_map instead is a better option. 

Last patch to the stop machine is potentially unsafe and is marked as highly experimental. Unfortunately 
it's currently the only option that allows dynamic module insertion/removal for above scenarios. 
If people still feel that it's toooo ugly I can revert that change and keep it in the separate tree 
for now.

Thanx
Max
