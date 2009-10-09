Return-Path: <linux-kernel-owner+w=401wt.eu-S1760278AbZJIIbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278AbZJIIbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758700AbZJIIbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:31:40 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:50577 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbZJIIbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:31:38 -0400
Subject: [PATCH v4 0/4] pseries: Add cede support for cpu-offline
To: Nathan Fontenot <nfont@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>
Date: Fri, 09 Oct 2009 14:00:45 +0530
Message-ID: <20091009082952.32381.32794.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is version 4 of patch series that provides a framework to choose the
state a pseries CPU must be put to when it is offlined.

Previous versions can be found here:
Version 3: http://lkml.org/lkml/2009/9/15/164
Version 2: http://lkml.org/lkml/2009/8/28/102
Version 1: http://lkml.org/lkml/2009/8/6/236

This patch series differs considerably from the previous iterations in that:
- It is based on top of Nathan Fontenot's
  "pseries kernel handling of dynamic logical partitioning v2" patches
  found here: http://lkml.org/lkml/2009/9/18/173

- It does away with the sysfs tunables "available_hotplug_states" and
  "currrent_hotplug_state", thereby refraining from exposing any platform
  specific option to the userspace.

- It provides a framework that discovers the support for ceding the vcpu
  to the hypervisor with a latency specifier value. When such a support is
  present, it would put the offlined CPUs into a ceded state while
  setting the cede   latency specifier value in the VPA indicating
  the latency expectation of the   guest OS. Hypervisor may use this for
  better energy savings.

- On platforms which don't have support for ceding with a latency specifier
  hint, it puts the offlined CPUs into the rtas_stop_self() state.

- Currently, Nathan's patches have provided sysfs interfaces
	/sys/devices/system/cpu/{probe, release}
  to dynamically allocate and deallocate resources respectively. The current
  process of allocating and deallocating CPUs would require two steps,
  namely:
	- Write to the "probe/release" file
	- Write to the "online" file.

  This patch-series combines these two operations such that when the user
  writes to the "probe", the CPUs would not only get allocated to the
  partition but also onlined. Similarly, when the user writes to "release",
  the CPUs would be offlined before they are deallocated.

  Thus, the user will now have to play with only one set of sysfs tunables
  for performing deallocate and the sysfs tunable "online" can be used for
  the purpose of deactivating the CPU while still letting the LPAR own it.

- It provides serializations for handling the writes the the "online" file
  against the writes to "probe/release" pair so that at any given instant,
  the user could either be deallocating the CPUs or deactivating it, but
  not both.

With this approach, I hope that the objection regarding the layering
violation that was raised by Peter for previous approaches is
addressed, while also providing clean interfaces for the userspace tools
to distinguish between the deallocation and deactivation without exposing
any platform specific details.

The patchset has been tested on the available pseries platforms and it
works as per the expectations.

Comments are very much appreciated.
---

Gautham R Shenoy (4):
      pseries: Serialize cpu hotplug operations during deactivate Vs deallocate
      pseries: Add code to online/offline CPUs of a DLPAR node.
      pSeries: Add hooks to put the CPU into an appropriate offline state
      pSeries: extended_cede_processor() helper function.


 arch/powerpc/include/asm/lppaca.h               |    9 +
 arch/powerpc/platforms/pseries/dlpar.c          |  129 ++++++++++++++++++-
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |  157 ++++++++++++++++++++++-
 arch/powerpc/platforms/pseries/offline_states.h |   18 +++
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   22 +++
 arch/powerpc/platforms/pseries/smp.c            |   19 +++
 arch/powerpc/xmon/xmon.c                        |    3 
 drivers/base/cpu.c                              |    2 
 include/linux/cpu.h                             |   13 ++
 9 files changed, 356 insertions(+), 16 deletions(-)
 create mode 100644 arch/powerpc/platforms/pseries/offline_states.h

-- 
Thanks and Regards
gautham.
