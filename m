Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbYLaIh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbYLaIh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYLaIhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:37:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61744 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756160AbYLaIhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:37:38 -0500
Message-ID: <495B2F19.7040806@cn.fujitsu.com>
Date: Wed, 31 Dec 2008 16:36:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] cpuset: don't allocate trial cpuset on stack
References: <495B2EA6.7010808@cn.fujitsu.com> <495B2EC2.9090305@cn.fujitsu.com> <495B2EE7.4040406@cn.fujitsu.com> <495B2EFB.302@cn.fujitsu.com>
In-Reply-To: <495B2EFB.302@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanups, reduce stack usage

This patch prepares for the next patch. When we convert cpuset.cpus_allowed
to cpumask_var_t, (trialcs = *cs) no longer works.

Another result of this patch is reducing stack usage of trialcs. sizeof(*cs)
can be as large as 148 bytes on x86_64, so it's really not good to have it
on stack.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |   93 +++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 60 insertions(+), 33 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index b4c36d5..480932a 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -415,6 +415,24 @@ static int is_cpuset_subset(const struct cpuset *p, const struct cpuset *q)
 		is_mem_exclusive(p) <= is_mem_exclusive(q);
 }
 
+/**
+ * alloc_trial_cpuset - allocate a trial cpuset
+ * @cs: the cpuset that the trial cpuset duplicates
+ */
+static struct cpuset *alloc_trial_cpuset(const struct cpuset *cs)
+{
+	return kmemdup(cs, sizeof(*cs), GFP_KERNEL);
+}
+
+/**
+ * free_trial_cpuset - free the trial cpuset
+ * @trial: the trial cpuset to be freed
+ */
+static void free_trial_cpuset(struct cpuset *trial)
+{
+	kfree(trial);
+}
+
 /*
  * validate_change() - Used to validate that any proposed cpuset change
  *		       follows the structural rules for cpusets.
@@ -880,10 +898,10 @@ static void update_tasks_cpumask(struct cpuset *cs, struct ptr_heap *heap)
  * @cs: the cpuset to consider
  * @buf: buffer of cpu numbers written to this cpuset
  */
-static int update_cpumask(struct cpuset *cs, const char *buf)
+static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
+			  const char *buf)
 {
 	struct ptr_heap heap;
-	struct cpuset trialcs;
 	int retval;
 	int is_load_balanced;
 
@@ -891,8 +909,6 @@ static int update_cpumask(struct cpuset *cs, const char *buf)
 	if (cs == &top_cpuset)
 		return -EACCES;
 
-	trialcs = *cs;
-
 	/*
 	 * An empty cpus_allowed is ok only if the cpuset has no tasks.
 	 * Since cpulist_parse() fails on an empty mask, we special case
@@ -900,31 +916,31 @@ static int update_cpumask(struct cpuset *cs, const char *buf)
 	 * with tasks have cpus.
 	 */
 	if (!*buf) {
-		cpus_clear(trialcs.cpus_allowed);
+		cpus_clear(trialcs->cpus_allowed);
 	} else {
-		retval = cpulist_parse(buf, &trialcs.cpus_allowed);
+		retval = cpulist_parse(buf, &trialcs->cpus_allowed);
 		if (retval < 0)
 			return retval;
 
-		if (!cpus_subset(trialcs.cpus_allowed, cpu_online_map))
+		if (!cpus_subset(trialcs->cpus_allowed, cpu_online_map))
 			return -EINVAL;
 	}
-	retval = validate_change(cs, &trialcs);
+	retval = validate_change(cs, trialcs);
 	if (retval < 0)
 		return retval;
 
 	/* Nothing to do if the cpus didn't change */
-	if (cpus_equal(cs->cpus_allowed, trialcs.cpus_allowed))
+	if (cpus_equal(cs->cpus_allowed, trialcs->cpus_allowed))
 		return 0;
 
 	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
 	if (retval)
 		return retval;
 
-	is_load_balanced = is_sched_load_balance(&trialcs);
+	is_load_balanced = is_sched_load_balance(trialcs);
 
 	mutex_lock(&callback_mutex);
-	cs->cpus_allowed = trialcs.cpus_allowed;
+	cs->cpus_allowed = trialcs->cpus_allowed;
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -1099,9 +1115,9 @@ done:
  * lock each such tasks mm->mmap_sem, scan its vma's and rebind
  * their mempolicies to the cpusets new mems_allowed.
  */
-static int update_nodemask(struct cpuset *cs, const char *buf)
+static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
+			   const char *buf)
 {
-	struct cpuset trialcs;
 	nodemask_t oldmem;
 	int retval;
 
@@ -1112,8 +1128,6 @@ static int update_nodemask(struct cpuset *cs, const char *buf)
 	if (cs == &top_cpuset)
 		return -EACCES;
 
-	trialcs = *cs;
-
 	/*
 	 * An empty mems_allowed is ok iff there are no tasks in the cpuset.
 	 * Since nodelist_parse() fails on an empty mask, we special case
@@ -1121,27 +1135,27 @@ static int update_nodemask(struct cpuset *cs, const char *buf)
 	 * with tasks have memory.
 	 */
 	if (!*buf) {
-		nodes_clear(trialcs.mems_allowed);
+		nodes_clear(trialcs->mems_allowed);
 	} else {
-		retval = nodelist_parse(buf, trialcs.mems_allowed);
+		retval = nodelist_parse(buf, trialcs->mems_allowed);
 		if (retval < 0)
 			goto done;
 
-		if (!nodes_subset(trialcs.mems_allowed,
+		if (!nodes_subset(trialcs->mems_allowed,
 				node_states[N_HIGH_MEMORY]))
 			return -EINVAL;
 	}
 	oldmem = cs->mems_allowed;
-	if (nodes_equal(oldmem, trialcs.mems_allowed)) {
+	if (nodes_equal(oldmem, trialcs->mems_allowed)) {
 		retval = 0;		/* Too easy - nothing to do */
 		goto done;
 	}
-	retval = validate_change(cs, &trialcs);
+	retval = validate_change(cs, trialcs);
 	if (retval < 0)
 		goto done;
 
 	mutex_lock(&callback_mutex);
-	cs->mems_allowed = trialcs.mems_allowed;
+	cs->mems_allowed = trialcs->mems_allowed;
 	cs->mems_generation = cpuset_mems_generation++;
 	mutex_unlock(&callback_mutex);
 
@@ -1181,31 +1195,36 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 		       int turning_on)
 {
-	struct cpuset trialcs;
+	struct cpuset *trialcs;
 	int err;
 	int balance_flag_changed;
 
-	trialcs = *cs;
+	trialcs = alloc_trial_cpuset(cs);
+	if (!trialcs)
+		return -ENOMEM;
+
 	if (turning_on)
-		set_bit(bit, &trialcs.flags);
+		set_bit(bit, &trialcs->flags);
 	else
-		clear_bit(bit, &trialcs.flags);
+		clear_bit(bit, &trialcs->flags);
 
-	err = validate_change(cs, &trialcs);
+	err = validate_change(cs, trialcs);
 	if (err < 0)
-		return err;
+		goto out;
 
 	balance_flag_changed = (is_sched_load_balance(cs) !=
-		 			is_sched_load_balance(&trialcs));
+				is_sched_load_balance(trialcs));
 
 	mutex_lock(&callback_mutex);
-	cs->flags = trialcs.flags;
+	cs->flags = trialcs->flags;
 	mutex_unlock(&callback_mutex);
 
-	if (!cpus_empty(trialcs.cpus_allowed) && balance_flag_changed)
+	if (!cpus_empty(trialcs->cpus_allowed) && balance_flag_changed)
 		async_rebuild_sched_domains();
 
-	return 0;
+out:
+	free_trial_cpuset(trialcs);
+	return err;
 }
 
 /*
@@ -1471,21 +1490,29 @@ static int cpuset_write_resmask(struct cgroup *cgrp, struct cftype *cft,
 				const char *buf)
 {
 	int retval = 0;
+	struct cpuset *cs = cgroup_cs(cgrp);
+	struct cpuset *trialcs;
 
 	if (!cgroup_lock_live_group(cgrp))
 		return -ENODEV;
 
+	trialcs = alloc_trial_cpuset(cs);
+	if (!trialcs)
+		return -ENOMEM;
+
 	switch (cft->private) {
 	case FILE_CPULIST:
-		retval = update_cpumask(cgroup_cs(cgrp), buf);
+		retval = update_cpumask(cs, trialcs, buf);
 		break;
 	case FILE_MEMLIST:
-		retval = update_nodemask(cgroup_cs(cgrp), buf);
+		retval = update_nodemask(cs, trialcs, buf);
 		break;
 	default:
 		retval = -EINVAL;
 		break;
 	}
+
+	free_trial_cpuset(trialcs);
 	cgroup_unlock();
 	return retval;
 }
-- 
1.5.4.rc3



