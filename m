Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbZJ3FWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbZJ3FWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 01:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbZJ3FWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 01:22:44 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:34201 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbZJ3FWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 01:22:44 -0400
Subject: [PATCH v5 0/4] pseries: Add cede support for cpu-offline
To: Nathan Fontenot <nfont@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Balbir Singh <balbir@in.ibm.com>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>
Date: Fri, 30 Oct 2009 10:52:43 +0530
Message-ID: <20091030052106.25493.42109.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is version 5 of patch series that provides a framework to choose the
state a pseries CPU must be put to when it is offlined.

Previous versions can be found here:
Version 4: http://lkml.org/lkml/2009/10/9/59
Version 3: http://lkml.org/lkml/2009/9/15/164
Version 2: http://lkml.org/lkml/2009/8/28/102
Version 1: http://lkml.org/lkml/2009/8/6/236

Changes from the previous version include:
- Rebased against Nathan Fontenot's latest "pseries kernel handling of dynamic
  logical paritioning v4" patches found here:
  http://lkml.org/lkml/2009/10/21/98

- Added boot-time option to disable putting the offlined vcpus into an
  extended H_CEDE state.

- Addressed Ben's comments regarding the if-else sequencing in
  pseries_mach_cpu_die().

- Addition of comments for pseries_cpu_die() to distinguish it from
  pseries_mach_cpu_die()

Also,

- This approach addresses Peter Z's objections regarding layering
  violations. The user simply offlines the cpu and doesn't worry about what
  state the CPU should be put into. That part is automatically handled by the
  kernel.

- It does not add any additional sysfs interface instead uses the existing
  sysfs interface to offline CPUs.

- On platforms which do not have support for ceding the vcpu with a
  latency specifier value, the offlining mechanism defaults to the current
  method of calling rtas_stop_self().

The patchset has been tested on the available pseries platforms and it works
as per the expectations. I believe that the patch set is ready for inclusion.
---

Gautham R Shenoy (4):
      pseries: Serialize cpu hotplug operations during deactivate Vs deallocate
      pseries: Add code to online/offline CPUs of a DLPAR node.
      pSeries: Add hooks to put the CPU into an appropriate offline state
      pSeries: extended_cede_processor() helper function.


 Documentation/cpu-hotplug.txt                   |    6 +
 arch/powerpc/include/asm/lppaca.h               |    9 +
 arch/powerpc/platforms/pseries/dlpar.c          |  129 ++++++++++++++++
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |  182 ++++++++++++++++++++++-
 arch/powerpc/platforms/pseries/offline_states.h |   18 ++
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   22 +++
 arch/powerpc/platforms/pseries/smp.c            |   19 ++
 arch/powerpc/xmon/xmon.c                        |    3 
 drivers/base/cpu.c                              |    2 
 include/linux/cpu.h                             |   13 ++
 10 files changed, 387 insertions(+), 16 deletions(-)
 create mode 100644 arch/powerpc/platforms/pseries/offline_states.h

-- 
Thanks and Regards
gautham.
