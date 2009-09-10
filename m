Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbZIJTRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbZIJTRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZIJTRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:17:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbZIJTRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:17:45 -0400
Date: Thu, 10 Sep 2009 21:13:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] cpusets: introduce cpuset->cpumask_lock
Message-ID: <20090910191348.GA32643@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparation for the next patch.

Introduce cpuset->cpumask_lock. From now ->cpus_allowed of the "active"
cpuset is always changed under this spinlock_t.

A separate patch to simplify the review/fixing, in case I missed some
places where ->cpus_allowed is updated.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/cpuset.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- CPUHP/kernel/cpuset.c~1_ADD_CPUMASK_LOCK	2009-09-10 19:35:16.000000000 +0200
+++ CPUHP/kernel/cpuset.c	2009-09-10 20:06:39.000000000 +0200
@@ -92,6 +92,7 @@ struct cpuset {
 	struct cgroup_subsys_state css;
 
 	unsigned long flags;		/* "unsigned long" so bitops work */
+	spinlock_t cpumask_lock;	/* protects ->cpus_allowed */
 	cpumask_var_t cpus_allowed;	/* CPUs allowed to tasks in cpuset */
 	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
 
@@ -891,7 +892,9 @@ static int update_cpumask(struct cpuset 
 	is_load_balanced = is_sched_load_balance(trialcs);
 
 	mutex_lock(&callback_mutex);
+	spin_lock(&cs->cpumask_lock);
 	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
+	spin_unlock(&cs->cpumask_lock);
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -1781,6 +1784,8 @@ static struct cgroup_subsys_state *cpuse
 	cs = kmalloc(sizeof(*cs), GFP_KERNEL);
 	if (!cs)
 		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&cs->cpumask_lock);
 	if (!alloc_cpumask_var(&cs->cpus_allowed, GFP_KERNEL)) {
 		kfree(cs);
 		return ERR_PTR(-ENOMEM);
@@ -1981,8 +1986,10 @@ static void scan_for_empty_cpusets(struc
 
 		/* Remove offline cpus and mems from this cpuset. */
 		mutex_lock(&callback_mutex);
+		spin_lock(&cp->cpumask_lock);
 		cpumask_and(cp->cpus_allowed, cp->cpus_allowed,
 			    cpu_online_mask);
+		spin_unlock(&cp->cpumask_lock);
 		nodes_and(cp->mems_allowed, cp->mems_allowed,
 						node_states[N_HIGH_MEMORY]);
 		mutex_unlock(&callback_mutex);
@@ -2030,7 +2037,9 @@ static int cpuset_track_online_cpus(stru
 
 	cgroup_lock();
 	mutex_lock(&callback_mutex);
+	spin_lock(&top_cpuset.cpumask_lock);
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_online_mask);
+	spin_unlock(&top_cpuset.cpumask_lock);
 	mutex_unlock(&callback_mutex);
 	scan_for_empty_cpusets(&top_cpuset);
 	ndoms = generate_sched_domains(&doms, &attr);

