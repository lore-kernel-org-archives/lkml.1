Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYBJDNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYBJDNx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 22:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbYBJDNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 22:13:45 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:42688 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542AbYBJDNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 22:13:43 -0500
Message-ID: <47AE6A8B.6030908@qualcomm.com>
Date: Sat, 09 Feb 2008 19:07:55 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       gregkh@suse.de, Rusty Russell <rusty@rustcorp.com.au>
Subject: [git pull] CPU isolation extensions (updated)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull CPU isolation extensions from

git://git.kernel.org/pub/scm/linux/kernel/git/maxk/cpuisol-2.6.git for-linus
 
Diffstat:
 Documentation/ABI/testing/sysfs-devices-system-cpu |   41 +++++++
 Documentation/cpu-isolation.txt                    |  113 +++++++++++++++++++++
 arch/x86/Kconfig                                   |    1 
 arch/x86/kernel/genapic_flat_64.c                  |    4 
 drivers/base/cpu.c                                 |   48 ++++++++
 include/linux/cpumask.h                            |    3 
 kernel/Kconfig.cpuisol                             |   42 +++++++
 kernel/Makefile                                    |    4 
 kernel/cpu.c                                       |   54 ++++++++++
 kernel/sched.c                                     |   36 ------
 kernel/stop_machine.c                              |    8 +
 kernel/workqueue.c                                 |   30 ++++-
 12 files changed, 337 insertions(+), 47 deletions(-)

This addresses all Andrew's comments for the last submission. Details here:
   http://marc.info/?l=linux-kernel&m=120236394012766&w=2

There are no code changes since last time, besides minor fix for moving on-stack array 
to __initdata as suggested by Andrew. Other stuff is just documentation updates. 

List of commits
   cpuisol: Make cpu isolation configrable and export isolated map
   cpuisol: Do not route IRQs to the CPUs isolated at boot
   cpuisol: Do not schedule workqueues on the isolated CPUs
   cpuisol: Move on-stack array used for boot cmd parsing into __initdata
   cpuisol: Documentation updates
   cpuisol: Minor updates to the Kconfig options
   cpuisol: Do not halt isolated CPUs with Stop Machine

I suggested by Ingo I'm CC'ing everyone who is even remotely connected/affected ;-)
 
Ingo, Peter - Scheduler.
   There are _no_ changes in this area besides moving cpu_*_map maps from kerne/sched.c 
   to kernel/cpu.c.
    
Paul - Cpuset
   Again there are _no_ changes in this area.
   For reasons why cpuset is not the right mechanism for cpu isolation see this thread
      http://marc.info/?l=linux-kernel&m=120180692331461&w=2

Rusty - Stop machine.
   After doing a bunch of testing last three days I actually downgraded stop machine 
   changes from [highly experimental] to simply [experimental]. Pleas see this thread 
   for more info: http://marc.info/?l=linux-kernel&m=120243837206248&w=2
   Short story is that I ran several insmod/rmmod workloads on live multi-core boxes 
   with stop machine _completely_ disabled and did no see any issues. Rusty did not get
   a chance to reply yet, I hopping that we'll be able to make "stop machine" completely
   optional for some configurations.

Gerg - ABI documentation.
   Nothing interesting here. I simply added 
	Documentation/ABI/testing/sysfs-devices-system-cpu
   and documented some of the attributes exposed in there.
   Suggested by Andrew.

I believe this is ready for the inclusion and my impression is that Andrew is ok with that. 
Most changes are very simple and do not affect existing behavior. As I mentioned before I've 
been using Workqueue and StopMachine changes in production for a couple of years now and have 
high confidence in them. Yet they are marked as experimental for now, just to be safe.

My original explanation is included below.

btw I'll be out skiing/snow boarding for the next 4 days and will have sporadic email access.
Will do my best to address question/concerns (if any) during that time.

Thanx
Max

----------------------------------------------------------------------------------------------
This patch series extends CPU isolation support. Yes, most people want to virtuallize 
CPUs these days and I want to isolate them  :) .

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

Last patch to the stop machine is potentially unsafe and is marked as highly experimental. Unfortunately 
it's currently the only option that allows dynamic module insertion/removal for above scenarios. 
If people still feel that it's toooo ugly I can revert that change and keep it in the separate tree 
for now.

Thanx
Max

