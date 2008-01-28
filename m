Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbYA1Eek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbYA1Eek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 23:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbYA1Edh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 23:33:37 -0500
Received: from warlock.qualcomm.com ([129.46.50.49]:41107 "EHLO
	warlock.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbYA1Ed3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 23:33:29 -0500
X-Greylist: delayed 666 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 23:33:28 EST
From: maxk@qualcomm.com
To: linux-kernel@vger.kernel.org
Subject: [CPUISOL] CPU isolation extensions
Date: Sun, 27 Jan 2008 20:09:37 -0800
Message-Id: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Following patch series extends CPU isolation support. Yes, most people want to virtuallize 
CPUs these days and I want to isolate them :).
The primary idea here is to be able to use some CPU cores as dedicated engines for running
user-space code with minimal kernel overhead/intervention, think of it as an SPE in the 
Cell processor.

We've had scheduler support for CPU isolation ever since O(1) scheduler went it. 
I'd like to extend it further to avoid kernel activity on those CPUs as much as possible.
In fact that the primary distinction that I'm making between say "CPU sets" and 
"CPU isolation". "CPU sets" let you manage user-space load while "CPU isolation" provides
a way to isolate a CPU as much as possible (including kernel activities).

I'm personally using this for hard realtime purposes. With CPU isolation it's very easy to 
achieve single digit usec worst case and around 200 nsec average response times on off-the-shelf
multi- processor/core systems under exteme system load. I'm working with legal folks on releasing 
hard RT user-space framework for that.
I can also see other application like simulators and stuff that can benefit from this.

I've been maintaining this stuff since around 2.6.18 and it's been running in production
environment for a couple of years now. It's been tested on all kinds of machines, from NUMA
boxes like HP xw9300/9400 to tiny uTCA boards like Mercury AXA110.
The messiest part used to be SLAB garbage collector changes. With the new SLUB all that mess 
goes away (ie no changes necessary). Also CFS seems to handle CPU hotplug much better than O(1) 
did (ie domains are recomputed dynamically) so that isolation can be done at any time (via sysfs). 
So this seems like a good time to merge. 

Anyway. The patchset consist of 5 patches. First three are very simple and non-controversial.
They simply make "CPU isolation" a configurable feature, export cpu_isolated_map and provide
some helper functions to access it (just like cpu_online() and friends).
Last two patches add support for isolating CPUs from running workqueus and stop machine.
More details in the individual patch descriptions.

Ideally I'd like all of this to go in during this merge window. If people think it's acceptable 
Linus or Andrew (or whoever is more appropriate Ingo maybe) can pull this patch set from
	git://git.kernel.org/pub/scm/linux/kernel/git/maxk/cpuisol-2.6.git

That tree is rebased against latest (as of yesterday) Linus' tree.

Thanx
Max

 arch/x86/Kconfig                  |    1 
 arch/x86/kernel/genapic_flat_64.c |    5 ++--
 drivers/base/cpu.c                |   47 ++++++++++++++++++++++++++++++++++++++
 include/linux/cpumask.h           |    3 ++
 kernel/Kconfig.cpuisol            |   25 +++++++++++++++++++-
 kernel/sched.c                    |   13 ++++++----
 kernel/stop_machine.c             |    3 --
 kernel/workqueue.c                |   31 ++++++++++++++++++-------
 8 files changed, 110 insertions(+), 18 deletions(-)
