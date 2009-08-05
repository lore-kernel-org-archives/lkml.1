Return-Path: <linux-kernel-owner+w=401wt.eu-S934505AbZHEO0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934505AbZHEO0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934290AbZHEO0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:26:00 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:54648 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934240AbZHEOZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:25:59 -0400
Subject: [PATCH 0/3] cpu: idle state framework for offline CPUs.
To: Joel Schopp <jschopp@austin.ibm.com>, len.brown@intel.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, shaohua.li@intel.com,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Wed, 05 Aug 2009 19:55:53 +0530
Message-ID: <20090805142311.553.78286.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

**** RFC not for inclusion ****

When we perform a CPU-Offline operation today, we do not put the CPU
into the most energy efficient state. On x86, it loops in hlt as opposed to
going to one of the low-power C-states. On pSeries, we call rtas_stop_self()
and hand over the vCPU back to the resource pool, thereby deallocating
the vCPU.

Thus, when applications or platforms desire to put a particular CPU
to an extended low-power state for a short while, currently they have to
piggy-back on scheduler heuristics such as sched_mc_powersavings or play with
exclusive Cpusets. The former does a good job based on the workload, but fails
to provide any guarentee that the CPU won't be used for the next <> seconds,
while the latter might conflict with the existing CPUsets configurations.

There were efforts to alleviate these problems and various proposals have been
put forth. They include putting the CPU to the deepest possible idle-state
when offlined [1], removing the desired CPU from the topmost-cpuset [2],
a driver which forces a high-priority idle thread to run on the desired CPU
thereby putting it to idle [3].

In this patch-series, we propose to extend the CPU-Hotplug infrastructure
and allow the system administrator to choose the desired state the CPU should
go to when it is offlined. We think this approach addresses the concerns about
determinism as well as transparency, since CPU-Hotplug already provides
notification mechanism which the userspace can listen to for any change
in the configuration and correspondingly readjust any previously set
cpu-affinities. Also, approaches such as [1] can make use of this
extended infrastructure instead of putting the CPU to an arbitrary C-state
when it is offlined, thereby providing the system administrator a rope to hang
himself with should he feel the need to do so.

This patch-series tries to achieve this by implementing an architecture
independent framework that exposes sysfs tunables to allow the
system-adminstrator to choose the offline-state of a CPU.

	/sys/devices/system/cpu/cpu<number>/available_offline_states
and
	/sys/devices/system/cpu/cpu<number>/preferred_offline_states

For the purpose of proof-of-concept, we've implemented the backend for
pSeries. For pSeries, we define two available_offline_states. They are:

	deallocate: This is default behaviour which on an offline, deallocates
	the vCPU by invoking rtas_stop_self() and hands it back to
	the resource pool.

	deactivate: This calls H_CEDE, which will request the hypervisor to
	idle the vCPU in the lowest power mode and give it back as soon as
	we need it.


Any feedback on the patchset will be immensely valuable.

References:
-----------
[1] Pallipadi, Venkatesh: x86: Make offline cpus to go to deepest idle state
using mwait (URL: http://lkml.org/lkml/2009/5/22/431)

[2] Li, Shaohua: cpuset: add new API to change cpuset top group's cpus
(URL: http://lkml.org/lkml/2009/5/19/54)

[3] Li, Shaohua: new ACPI processor driver to force CPUs idle
(URL: http://www.spinics.net/lists/linux-acpi/msg22863.html)


Changelog:
---

Gautham R Shenoy (3):
      pSeries: cpu: Cede CPU during a deactivate-offline
      cpu: Implement cpu-offline-state callbacks for pSeries.
      cpu: Offline state Framework.


 arch/powerpc/platforms/pseries/hotplug-cpu.c    |  160 ++++++++++++++++++++++-
 arch/powerpc/platforms/pseries/offline_driver.h |   17 ++
 arch/powerpc/platforms/pseries/plpar_wrappers.h |    6 +
 arch/powerpc/platforms/pseries/smp.c            |   18 ++-
 drivers/base/cpu.c                              |  111 ++++++++++++++++
 include/linux/cpu.h                             |   15 ++
 6 files changed, 319 insertions(+), 8 deletions(-)
 create mode 100644 arch/powerpc/platforms/pseries/offline_driver.h

-- 
Thanks and Regards
gautham.
