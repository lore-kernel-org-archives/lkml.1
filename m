Return-Path: <linux-kernel-owner+w=401wt.eu-S937476AbXHPBL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937476AbXHPBL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 21:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbXHPBLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 21:11:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:7352 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479AbXHPBLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 21:11:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,268,1183359600"; 
   d="scan'208";a="263768483"
Date: Wed, 15 Aug 2007 18:04:26 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: mingo@elte.hu
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [patch] sched: skip updating  rq's next_balance under null SD
Message-ID: <20070816010426.GH10033@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Was playing with sched_smt_power_savings/sched_mc_power_savings and found
out that while the scheduler domains are reconstructed when sysfs settings
change, rebalance_domains() can get triggered with null domain on other cpus,
which is setting next_balance to jiffies + 60*HZ. Resulting in no idle/busy
balancing for 60 seconds.

Fix this.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index 45e17b8..74565c0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3020,6 +3020,7 @@ static inline void rebalance_domains(int cpu, enum cpu_idle_type idle)
 	struct sched_domain *sd;
 	/* Earliest time when we have to do rebalance again */
 	unsigned long next_balance = jiffies + 60*HZ;
+	int update_next_balance = 0;
 
 	for_each_domain(cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
@@ -3056,8 +3057,10 @@ static inline void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		if (sd->flags & SD_SERIALIZE)
 			spin_unlock(&balancing);
 out:
-		if (time_after(next_balance, sd->last_balance + interval))
+		if (time_after(next_balance, sd->last_balance + interval)) {
 			next_balance = sd->last_balance + interval;
+			update_next_balance = 1;
+		}
 
 		/*
 		 * Stop the load balance at this level. There is another
@@ -3067,7 +3070,14 @@ out:
 		if (!balance)
 			break;
 	}
-	rq->next_balance = next_balance;
+
+	/*
+	 * next_balance will be updated only when there is a need.
+	 * When the cpu is attached to null domain for ex, it will not be
+	 * updated.
+	 */
+	if (likely(update_next_balance))
+		rq->next_balance = next_balance;
 }
 
 /*
