Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZHZLHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZHZLHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbZHZLH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:07:29 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:48755 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbZHZLH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:07:29 -0400
Date: Wed, 26 Aug 2009 16:37:21 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [v2 PATCH 0/2]: cpuidle: Introducing cpuidle infrastructure to
	POWER
Message-ID: <20090826110721.GA29759@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



"Cpuidle" is a CPU Power Management infrastrusture which helps manage
idle CPUs in a clean and efficient manner. The architecture can register
its driver (in this case, pseries_idle driver) so that it subscribes for
cpuidle feature. Cpuidle has a set of governors (ladder and menu),
which will decide the best idle state to be chosen for the current situation,
based on heuristics, and calculates the expected residency time
for the current idle state. So based on this, the cpu is put into
the right idle state.

Currently, cpuidle infrasture is exploited by ACPI to choose between
the available ACPI C-states. This patch-set is aimed at enabling
cpuidle for powerpc and provides a sample implementation for pseries.

Currently, in the pseries_dedicated_idle_sleep(), the processor would
poll for a time period, which is called the snooze, and only then it
is ceded, which would put the processor in nap state. Cpuidle aims at
separating this into 2 different idle states. Based on the expected
residency time predicted by the cpuidle governor, the idle state is
chosen directly. So, choosing to enter the nap state directly based on
the decision made by cpuidle would avoid unnecessary snoozing before
entering nap.

This patch-set tries to achieve the above objective by introducing a
pseries processor idle driver called pseries_idle_driver in
arch/powerpc/platform/pseries/processor_idle.c, which implements the
idle loop which would replace the pseries_dedicated_idle_sleep()
when cpuidle is enabled.

Experiment conducted:
----------------------

The following experiment was conducted on a completely idle JS22 blade,
to prove that using cpuidle infrastructure, the amount of nap time increases.

Nap and snooze times were sampled for all the cpus.
For a window of 1000 samples, When cpuidle was enabled,
the total nap time was of the order of a few seconds (5-10s), whereas
the total snooze time was of the order of a few milliseconds(10-30 ms).

When cpuidle infrastructure was disabled and the regular
pseries_dedicated_idle_sleep() idle loop was used, the snooze time itself
was of the order of hundreds of milliseconds. (100 - 500 ms).
This is clearly due to unnecessary snoozing before napping even on a
completely idle system.


The previous post in this area can be found at
http://lkml.org/lkml/2009/8/19/150

Changes from the previous version:
----------------------------------

Earlier I used the the name TPMD (Thermal and Power Management Devices)
to refer to this module which hooks on to the cpuidle infrastructure.
I have renamed this to Pseries Processor Idle, in order to avoid confusion.


Patches included in this set:
------------------------------
PATCH 1/2 - Enable cpuidle for pSeries.
PATCH 2/2 - Implement Pseries Processor Idle idle module


Any feedback on the overall design and idea is immensely valuable.

--arun
