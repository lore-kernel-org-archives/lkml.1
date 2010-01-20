Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431Ab0ATUCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab0ATUCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367Ab0ATUCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:02:50 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59235 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab0ATUCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:02:49 -0500
Subject: [PATCH 1/2] sched: Fix the place where group powers are updated.
From: Joel Schopp <jschopp@austin.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: ego@in.ibm.com, linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
In-Reply-To: <1264017638.5717.121.camel@jschopp-laptop>
References: <1264017638.5717.121.camel@jschopp-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 14:02:44 -0600
Message-ID: <1264017764.5717.127.camel@jschopp-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gautham R Shenoy <ego@in.ibm.com>

We want to update the sched_group_powers when balance_cpu == this_cpu.

Currently the group powers are updated only if the balance_cpu is the first
CPU in the local group. But balance_cpu = this_cpu could also be the first
idle cpu in the group. Hence fix the place where the group powers are updated.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Joel Schopp <jschopp@austin.ibm.com>
---
 kernel/sched.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 281da29..5d2a451 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3721,11 +3721,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	unsigned long sum_avg_load_per_task;
 	unsigned long avg_load_per_task;
 
-	if (local_group) {
+	if (local_group)
 		balance_cpu = group_first_cpu(group);
-		if (balance_cpu == this_cpu)
-			update_group_power(sd, this_cpu);
-	}
 
 	/* Tally up the load of all CPUs in the group */
 	sum_avg_load_per_task = avg_load_per_task = 0;
@@ -3773,6 +3770,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 		return;
 	}
 
+	update_group_power(sd, this_cpu);
+
 	/* Adjust by relative CPU power of the group */
 	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
 



