Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbYIXQOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbYIXQOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYIXQOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:14:22 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:51553 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbYIXQOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:14:21 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v1 1/5] Load calculation for each group
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 24 Sep 2008 21:47:21 +0530
Message-ID: <20080924161721.31581.79099.stgit@drishya.in.ibm.com>
In-Reply-To: <20080924161228.31581.57651.stgit@drishya.in.ibm.com>
References: <20080924161228.31581.57651.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add data structures for per group stats, and function
to calculate the required stats.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 kernel/sched.c |  114 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9889080..abf60ea 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3064,6 +3064,120 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	return 0;
 }
 
+/* Helper functions for find_busiest_group */
+
+int get_load_idx(struct sched_domain *sd, enum cpu_idle_type idle)
+{
+	if (idle == CPU_NOT_IDLE)
+		return sd->busy_idx;
+	else if (idle == CPU_NEWLY_IDLE)
+		return sd->newidle_idx;
+	else
+		return sd->idle_idx;
+}
+
+/* Struct to return group stats */
+
+struct group_loads {
+	struct sched_group *group;
+	unsigned long nr_running;
+	unsigned long load;
+	unsigned long load_per_cpu;
+	unsigned long weighted_load;
+	unsigned long avg_load_per_task;
+	unsigned int group_imbalance;
+	int local_group;
+	int balance_cpu;
+};
+
+/* Helper function to calculate basic group level stats */
+
+int get_group_loads(struct sched_group *group, int this_cpu,
+		    const cpumask_t *valid_cpus, enum cpu_idle_type idle,
+		    int load_idx,
+		    struct group_loads *gl)
+{
+	struct rq *rq;
+	unsigned long load, min_load, max_load, avg_load_per_task_per_cpu;
+	int cpu;
+	int local_group = 0;
+	int first_idle_cpu = -1;
+	int need_balance = 1;
+
+	gl->group = group;
+	gl->nr_running = 0;
+	gl->load = 0;
+	gl->weighted_load = 0;
+	gl->avg_load_per_task = 0;
+	gl->group_imbalance = 0;
+	gl->balance_cpu = -1;
+	max_load = 0;
+	min_load = ~0UL;
+
+	gl->local_group = cpu_isset(this_cpu, group->cpumask);
+
+	for_each_cpu_mask_nr(cpu, group->cpumask) {
+		if (!cpu_isset(cpu, *valid_cpus))
+			continue;
+
+		rq = cpu_rq(cpu);
+
+		/* Bias balancing toward cpus of our domain */
+		if (gl->local_group) {
+			if (idle_cpu(cpu) && first_idle_cpu == -1)
+				first_idle_cpu = cpu;
+
+			load = target_load(cpu, load_idx);
+		} else {
+			load = source_load(cpu, load_idx);
+			if (load > max_load)
+				max_load = load;
+			if (load < min_load)
+				min_load = load;
+		}
+		gl->nr_running += rq->nr_running;
+		gl->load += load;
+		gl->weighted_load += weighted_cpuload(cpu);
+		gl->avg_load_per_task += cpu_avg_load_per_task(cpu);
+	}
+
+	/*
+	 * Consider the group unbalanced when the imbalance is larger
+	 * than the average weight of two tasks.
+	 *
+	 * APZ: with cgroup the avg task weight can vary wildly and
+	 *      might not be a suitable number - should we keep a
+	 *      normalized nr_running number somewhere that negates
+	 *      the hierarchy?
+	 */
+
+	avg_load_per_task_per_cpu = sg_div_cpu_power(group,
+				gl->avg_load_per_task * SCHED_LOAD_SCALE);
+
+	if (!gl->local_group &&
+	    ((max_load - min_load) > 2*avg_load_per_task_per_cpu))
+			gl->group_imbalance = 1;
+
+	if (local_group) {
+		if (first_idle_cpu != -1)
+			gl->balance_cpu = first_idle_cpu;
+		else
+			gl->balance_cpu = first_cpu(group->cpumask);
+
+		/*
+		 * First idle cpu or the first cpu(busiest) in this sched group
+		 * is eligible for doing load balancing at this and above
+		 * domains. In the newly idle case, we will allow all the cpu's
+		 * to do the newly idle load balance.
+		 */
+		if (idle != CPU_NEWLY_IDLE && gl->balance_cpu != this_cpu)
+			need_balance = 0;
+	}
+	gl->load_per_cpu = sg_div_cpu_power(group, gl->load * SCHED_LOAD_SCALE);
+
+	return need_balance;
+}
+
 /*
  * find_busiest_group finds and returns the busiest CPU group within the
  * domain. It calculates and returns the amount of weighted load which

