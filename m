Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbZIVFdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbZIVFdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbZIVFdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:33:37 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59533 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbZIVFdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:33:37 -0400
Date: Tue, 22 Sep 2009 11:03:14 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [v5 RFC PATCH 0/7]: cpuidle/x86/POWER (REDESIGN): Cleanup idle
	power management code in x86, cleanup drivers/cpuidle/cpuidle.c and
	introduce cpuidle to POWER.
Message-ID: <20090922053314.GA6417@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

******** This is an RFC, not for inclusion **********

This patchset introduces cpuidle infrastructure to POWER, prototyping
for pSeries, and also does a major refactoring of current x86 idle
power management and a cleanup of cpuidle infrastructure.

My earlier iterations can be found at:

v4 --> http://lkml.org/lkml/2009/9/1/133
v3 --> http://lkml.org/lkml/2009/8/27/124
v2 --> http://lkml.org/lkml/2009/8/26/233
v1 --> http://lkml.org/lkml/2009/8/19/150

Major Changes in this iteration:
------------------------------------------

* Refactoring x86 idle power management code
        Remove all instances of pm_idle and make cpuidle_idle_call as
        _the_ idle routine in x86. So, cpuidle_idle_call will be
        called from the main idle loop, cpu_idle instead of the
        function pointer pm_idle. Also, pm_idle was used by apm module
        and xen. Change those instances such that they register to
        cpuidle instead.

* Cleanup drivers/cpuidle/cpuidle.c
        Currently, the cpuidle implementation has weakness in the
        framework where an exported pm_idle function pointer is
        manipulated by various subsystem. The proposed framework has
        a registration mechanism to cleanly add and remove new idle
        routines from different subsystems.

* Implement cpuidle for pSeries
        Implement the processor_idle module for pseries, which
        registers idle loops to cpuidle and also cleanup
        arch/powerpc/platforms/pseries/setup.c and remove the
        redundant pseries_dedicated/shared_idle_sleep which is
        implemented in processor_idle.c
        Also, remove all instances of ppc_md.power_save, for the same
        reason as that given for pm_idle.

TODO:
---------------------------------------------

* Currently, the list based approach that I'm using here is not
  working in a clean way on a few x86 platforms which have multiple
  sleep states, leading to kernel panics. So working on resolving
  that.

* ppc_md.power_save has been replaced by cpuidle_idle_call only for
  pseries. So this needs to be done for all POWER platforms so that
  ppc_md.power_save is completely removed.

Patches included in this series:
---------------------------------------------

1/7 - cleanup drivers/cpuidle/cpuidle.c
2/7 - implement a list based approach to register a set of idle
      routines.
3/7 - refactor x86 idle power management code and remove all instances
      of pm_idle.
4/7 - enable cpuidle for POWER.
5/7 - remove dedicate/shared idle loops, which will be moved to
      arch/powerpc/platforms/pseries/processor_idle.c
6/7 - add a default_idle idle loop for POWER.
7/7 - implement pSeries processor idle module.

Any comments on the design is welcome.

--arun
