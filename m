Return-Path: <linux-kernel-owner+w=401wt.eu-S932705AbXGPX7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbXGPX7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbXGPX70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:59:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:59214 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158AbXGPX70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:59:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,544,1175497200"; 
   d="scan'208";a="251248774"
Date: Mon, 16 Jul 2007 16:54:02 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: mingo@elte.hu, nickpiggin@yahoo.com.au
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, clameter@sgi.com
Subject: [patch] sched: fix the all pinned logic in load_balance_newidle()
Message-ID: <20070716235402.GE3318@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nr_moved is not the correct check for triggering all pinned logic. Fix the
all pinned logic in the case of load_balance_newidle().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index 3332bbb..0cdac9c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2668,6 +2668,7 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
 	unsigned long imbalance;
 	int nr_moved = 0;
 	int sd_idle = 0;
+	int all_pinned = 0;
 	cpumask_t cpus = CPU_MASK_ALL;
 
 	/*
@@ -2706,10 +2707,10 @@ redo:
 		double_lock_balance(this_rq, busiest);
 		nr_moved = move_tasks(this_rq, this_cpu, busiest,
 					minus_1_or_zero(busiest->nr_running),
-					imbalance, sd, CPU_NEWLY_IDLE, NULL);
+					imbalance, sd, CPU_NEWLY_IDLE, &all_pinned);
 		spin_unlock(&busiest->lock);
 
-		if (!nr_moved) {
+		if (unlikely(all_pinned)) {
 			cpu_clear(cpu_of(busiest), cpus);
 			if (!cpus_empty(cpus))
 				goto redo;
