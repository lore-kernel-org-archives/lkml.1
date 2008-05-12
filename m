Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbYELTUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbYELTUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYELTUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:20:35 -0400
Received: from 66-189-124-104.dhcp.oxfr.ma.charter.com ([66.189.124.104]:58180
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751141AbYELTUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:20:34 -0400
X-Greylist: delayed 2019 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2008 15:20:34 EDT
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RFC PATCH 2/3] sched: pass specific sched_balancer to functions
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org
Date: Mon, 12 May 2008 14:14:10 -0400
Message-ID: <20080512181410.5257.70010.stgit@novell1.haskins.net>
In-Reply-To: <20080512181248.5257.74801.stgit@novell1.haskins.net>
References: <20080512181248.5257.74801.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of assuming sd->group_balancer.groups is the intended group. We
will use this later in the series to introduce alternate balancers.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a8e0bd3..0bdbfe6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3288,11 +3288,12 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
  * should be moved to restore balance via the imbalance parameter.
  */
 static struct sched_group *
-find_busiest_group(struct sched_domain *sd, int this_cpu,
+find_busiest_group(struct sched_domain *sd, struct sched_balancer *balancer,
+		   int this_cpu,
 		   unsigned long *imbalance, enum cpu_idle_type idle,
 		   int *sd_idle, const cpumask_t *cpus, int *balance)
 {
-	struct sched_group *first_group = sd->group_balancer.groups;
+	struct sched_group *first_group = balancer->groups;
 	struct sched_group *busiest = NULL, *this = NULL, *group = first_group;
 	unsigned long max_load, avg_load, total_load, this_load, total_pwr;
 	unsigned long max_pull;
@@ -3630,10 +3631,11 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
  * tasks if there is an imbalance.
  */
 static int load_balance(int this_cpu, struct rq *this_rq,
-			struct sched_domain *sd, enum cpu_idle_type idle,
+			struct sched_domain *sd,
+			struct sched_balancer *balancer,
+			enum cpu_idle_type idle,
 			int *balance, cpumask_t *cpus)
 {
-	struct sched_balancer *balancer = &sd->group_balancer;
 	int ld_moved, all_pinned = 0, active_balance = 0, sd_idle = 0;
 	struct sched_group *group;
 	unsigned long imbalance;
@@ -3658,8 +3660,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	schedstat_inc(sd, lb_count[idle]);
 
 redo:
-	group = find_busiest_group(sd, this_cpu, &imbalance, idle, &sd_idle,
-				   cpus, balance);
+	group = find_busiest_group(sd, balancer, this_cpu, &imbalance, idle,
+				   &sd_idle, cpus, balance);
 
 	if (*balance == 0)
 		goto out_balanced;
@@ -3819,8 +3821,8 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd,
 
 	schedstat_inc(sd, lb_count[CPU_NEWLY_IDLE]);
 redo:
-	group = find_busiest_group(sd, this_cpu, &imbalance, CPU_NEWLY_IDLE,
-				   &sd_idle, cpus, NULL);
+	group = find_busiest_group(sd, balancer, this_cpu, &imbalance,
+				   CPU_NEWLY_IDLE, &sd_idle, cpus, NULL);
 	if (!group) {
 		schedstat_inc(sd, lb_nobusyg[CPU_NEWLY_IDLE]);
 		goto out_balanced;
@@ -4082,7 +4084,8 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		}
 
 		if (time_after_eq(jiffies, balancer->last_exec + interval)) {
-			if (load_balance(cpu, rq, sd, idle, &balance, &tmp)) {
+			if (load_balance(cpu, rq, sd, balancer,
+					 idle, &balance, &tmp)) {
 				/*
 				 * We've pulled tasks over so either we're no
 				 * longer idle, or one of our SMT siblings is

