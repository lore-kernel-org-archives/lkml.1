Return-Path: <linux-kernel-owner+w=401wt.eu-S1762239AbZLKBj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762239AbZLKBj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933348AbZLKBjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:39:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:59767 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761741AbZLKBjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:39:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,378,1257148800"; 
   d="scan'208";a="521838164"
Message-Id: <20091211012748.267627000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Dec 2009 17:27:48 -0800
From: venkatesh.pallipadi@intel.com
To: Peter Zijlstra <peterz@infradead.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 0/2] sched: Change nohz ilb logic from pull to push model
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a followup to the RFC here:
http://lkml.indiana.edu/hypermail/linux/kernel/0906.2/01163.html

We have few cleanups since that RFC and also have some data
showing the impact of this change.

Description:
Existing nohz idle load balance logic uses the pull model, with one
idle load balancer CPU nominated on any partially idle system and that
balancer CPU not going into nohz mode. With the periodic tick, the
balancer does the idle balancing on behalf of all the CPUs in nohz mode.

This is not very optimal and has few issues:
* the balancer will continue to have periodic ticks and wakeup
  frequently (HZ rate), even though it may not have any rebalancing to do on
  behalf of any of the idle CPUs.
* On x86 and CPUs that have APIC timer stoppage on idle CPUs, this periodic
  wakeup can result in an additional interrupt on a CPU doing the timer
  broadcast.
* The balancer may end up spending a lot of time doing the balancing on
  behalf of nohz CPUs, especially with increasing number of sockets and
  cores in the platform.

The alternative is to have a push model, where all idle CPUs can enter nohz
mode and any busy CPU kicks one of the idle CPUs to take care of idle
balancing on behalf of a group of idle CPUs.

Following patches switches idle load balancer to this push approach.

Data:
1) Running a bunzip2 of a big file (which happened to be kernel tar ball),
on a netbook with HZ=1000.

Before the change
57.44user 12.36system 1:12.17elapsed

After the change
47.89user 10.31system 0:59.99elapsed

That is ~10 seconds (17%) savings in user time for this task. This is
coming from the idle SMT sibling thread being woken up 1000 times a second
and doing unnecessary idle load balancing, resulting in
slowdown of the thread running the load.

2) Running bzip2 of a big file (which happened to be kernel tar ball),
on a dual socket server with HZ=1000

No change in performance, but there is a noticable (1% - 1.5% range)
reduction in energy consumption. This is due to idle load balancer
that un necessarily gets woken up on second socket with the earlier pull
model. With new push model, second socket will not get woken up often
and can get into low power idle state.

3) We also measured SpecJBB workload with varying number of warehouses
and did not see any noticable change in performance with this patch.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

-- 

