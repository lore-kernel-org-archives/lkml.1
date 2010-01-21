Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486Ab0AUNzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0AUNzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274Ab0AUNzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:55:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:46406 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab0AUNz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:55:27 -0500
Date: Thu, 21 Jan 2010 13:54:27 GMT
From: tip-bot for Gautham R Shenoy <ego@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, jschopp@austin.ibm.com, ego@in.ibm.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       jschopp@austin.ibm.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1264017764.5717.127.camel@jschopp-laptop>
References: <1264017764.5717.127.camel@jschopp-laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix the place where group powers are updated
Message-ID: <tip-871e35bc9733f273eaf5ceb69bbd0423b58e5285@git.kernel.org>
Git-Commit-ID: 871e35bc9733f273eaf5ceb69bbd0423b58e5285
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jan 2010 13:54:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  871e35bc9733f273eaf5ceb69bbd0423b58e5285
Gitweb:     http://git.kernel.org/tip/871e35bc9733f273eaf5ceb69bbd0423b58e5285
Author:     Gautham R Shenoy <ego@in.ibm.com>
AuthorDate: Wed, 20 Jan 2010 14:02:44 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jan 2010 13:40:17 +0100

sched: Fix the place where group powers are updated

We want to update the sched_group_powers when balance_cpu == this_cpu.

Currently the group powers are updated only if the balance_cpu is the
first CPU in the local group. But balance_cpu = this_cpu could also be
the first idle cpu in the group. Hence fix the place where the group
powers are updated.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Joel Schopp <jschopp@austin.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1264017764.5717.127.camel@jschopp-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0b482f5..22231cc 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2418,11 +2418,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
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
@@ -2470,6 +2467,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 		return;
 	}
 
+	update_group_power(sd, this_cpu);
+
 	/* Adjust by relative CPU power of the group */
 	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
 
