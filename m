Return-Path: <linux-kernel-owner+w=401wt.eu-S1764841AbXGPX5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764841AbXGPX5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbXGPX5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:57:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:48473 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbXGPX5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:57:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,544,1175497200"; 
   d="scan'208";a="251248217"
Date: Mon, 16 Jul 2007 16:52:14 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: mingo@elte.hu, npiggin@suse.de
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch] sched: fix newly idle load balance in case of SMT
Message-ID: <20070716235214.GD3318@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the presence of SMT, newly idle balance was never happening for multi-core
and SMP domains(even when both the logical siblings are idle).

If thread 0 is already idle and when thread 1 is about to go to idle, newly
idle load balance always think that one of the threads is not idle and skips
doing the newly idle load balance for multi-core and SMP domains.

This is because of the idle_cpu() macro, which checks if the current
process on a cpu is an idle process. But this is not the case for the
thread doing the load_balance_newidle().

Fix this by using runqueue's nr_running field instead of idle_cpu(). And
also skip the logic of 'only one idle cpu in the group will be doing load
balancing' during newly idle case.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index 3332bbb..623cee9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2226,7 +2226,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 
 			rq = cpu_rq(i);
 
-			if (*sd_idle && !idle_cpu(i))
+			if (*sd_idle && rq->nr_running)
 				*sd_idle = 0;
 
 			/* Bias balancing toward cpus of our domain */
@@ -2248,9 +2248,11 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		/*
 		 * First idle cpu or the first cpu(busiest) in this sched group
 		 * is eligible for doing load balancing at this and above
-		 * domains.
+		 * domains. In the newly idle case, we will allow all the cpu's
+		 * to do the newly idle load balance.
 		 */
-		if (local_group && balance_cpu != this_cpu && balance) {
+		if (idle != CPU_NEWLY_IDLE && local_group &&
+		    balance_cpu != this_cpu && balance) {
 			*balance = 0;
 			goto ret;
 		}
