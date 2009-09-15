Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbZIOMHC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbZIOMHC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 08:07:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbZIOMG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 08:06:59 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:45347 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZIOMG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 08:06:58 -0400
Subject: [PATCH v3 0/3] cpu: pseries: Cpu offline states framework
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Arun R Bharadwaj <arun@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>
Date: Tue, 15 Sep 2009 17:36:56 +0530
Message-ID: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

**** RFC not for inclusion ****

This is the version 3 of the patch series to provide a cpu-offline framework
that enables the administrators choose the state of a CPU when it is
offlined, when multiple such states are exposed by the underlying
architecture.

Changes from Version 2:(can be found here: http://lkml.org/lkml/2009/8/28/102)
- Addressed Andrew Morton's review comments regarding names of global
  variables, handling of error conditions and documentation of the interfaces.

- Implemented a patch to provide helper functions to set the cede latency
  specifier value in the VPA indicating latency expectation of the guest OS
  when the vcpu is ceded from a subsequent H_CEDE hypercall. Hypervisor may
  use this for better energy savings.

- Renamed of the cpu-hotplug states. "deallocate" is renamed
  as "offline" and "deactivate" is renamed as "inactive".

The patch-series exposes the following sysfs tunables to
allow the system-adminstrator to choose the state of a CPU:

To query the available hotplug states, one needs to read the sysfs tunable:
	/sys/devices/system/cpu/cpu<number>/available_hotplug_states
To query or set the current state, on needs to read/write the sysfs tunable:
	/sys/devices/system/cpu/cpu<number>/current_hotplug_state

The patchset ensures that the writes to the "current_hotplug_state" sysfs file are
serialized against the writes to the "online" file.

This patchset contains the offline state driver implemented for
pSeries. For pSeries, we define three available_hotplug_states. They are:

	online: The processor is online.

	offline: This is the the default behaviour when the cpu is offlined
	even in the absense of this driver. The CPU would call make an
	rtas_stop_self() call and hand over the CPU back to the resource pool,
	thereby effectively deallocating that vCPU from the LPAR.
	NOTE: This would result in a configuration change to the LPAR
	which is visible to the outside world.

	inactive: This cedes the vCPU to the hypervisor with a cede latency
	specifier value 2.
	NOTE: This option does not result in a configuration change
	and the vCPU would be still entitled to the LPAR to which it earlier
	belong to.

Any feedback on the patchset will be immensely valuable.
---

Arun R Bharadwaj (1):
      pSeries: cede latency specifier helper function.

Gautham R Shenoy (2):
      cpu: Implement cpu-offline-state callbacks for pSeries.
      cpu: Offline state Framework.


 Documentation/cpu-hotplug.txt                   |   22 +++
 arch/powerpc/include/asm/lppaca.h               |    9 +
 arch/powerpc/platforms/pseries/Makefile         |    2 
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |   88 ++++++++++-
 arch/powerpc/platforms/pseries/offline_driver.c |  148 +++++++++++++++++++
 arch/powerpc/platforms/pseries/offline_driver.h |   20 +++
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   17 ++
 arch/powerpc/platforms/pseries/smp.c            |   17 ++
 arch/powerpc/xmon/xmon.c                        |    3 
 drivers/base/cpu.c                              |  181 ++++++++++++++++++++++-
 include/linux/cpu.h                             |   10 +
 11 files changed, 498 insertions(+), 19 deletions(-)
 create mode 100644 arch/powerpc/platforms/pseries/offline_driver.c
 create mode 100644 arch/powerpc/platforms/pseries/offline_driver.h

-- 
Thanks and Regards
gautham.
