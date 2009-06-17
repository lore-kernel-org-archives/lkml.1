Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbZFQSgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbZFQSgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760266AbZFQSgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:36:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:39370 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760155AbZFQSgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:36:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,239,1243839600"; 
   d="scan'208";a="700268327"
Message-Id: <20090617182649.604970000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 17 Jun 2009 11:26:49 -0700
From: venkatesh.pallipadi@intel.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Gautham R Shenoy <ego@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 0/2] RFC sched: Change nohz ilb logic from poll to push model
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Existing nohz idle load balance (ilb) logic uses the pull model, with one
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
mode and busy CPU kicks one of the idle CPUs to take care of idle balancing
on behalf of a group of idle CPUs.

Following patches tries that approach. There are still some rough edges
in the patches related to use of #defines around the code. But, wanted
to get opinion on this approach as an RFC (not for inclusion into the
tree yet).

Thanks,
Venki

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

-- 
-- 

