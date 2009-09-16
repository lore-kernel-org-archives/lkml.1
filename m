Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbZIPKUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbZIPKUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbZIPKUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:20:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:46371 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbZIPKUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:20:38 -0400
Date: Wed, 16 Sep 2009 10:20:11 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Move sched_balance_self() into sched_fair.c
Message-ID: <tip-aaee1203ca52b9db799433c33c9bffc33cdf8909@git.kernel.org>
Git-Commit-ID: aaee1203ca52b9db799433c33c9bffc33cdf8909
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:20:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aaee1203ca52b9db799433c33c9bffc33cdf8909
Gitweb:     http://git.kernel.org/tip/aaee1203ca52b9db799433c33c9bffc33cdf8909
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 10 Sep 2009 13:36:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:01:04 +0200

sched: Move sched_balance_self() into sched_fair.c

Move the sched_balance_self() code into sched_fair.c

This facilitates the merger of sched_balance_self() and
sched_fair::select_task_rq().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c      |  146 ---------------------------------------------------
 kernel/sched_fair.c |  145 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 145 insertions(+), 146 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b56d150..60400a2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2269,152 +2269,6 @@ void kick_process(struct task_struct *p)
 	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(kick_process);
-
-/*
- * find_idlest_group finds and returns the least busy CPU group within the
- * domain.
- */
-static struct sched_group *
-find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
-{
-	struct sched_group *idlest = NULL, *this = NULL, *group = sd->groups;
-	unsigned long min_load = ULONG_MAX, this_load = 0;
-	int load_idx = sd->forkexec_idx;
-	int imbalance = 100 + (sd->imbalance_pct-100)/2;
-
-	do {
-		unsigned long load, avg_load;
-		int local_group;
-		int i;
-
-		/* Skip over this group if it has no CPUs allowed */
-		if (!cpumask_intersects(sched_group_cpus(group),
-					&p->cpus_allowed))
-			continue;
-
-		local_group = cpumask_test_cpu(this_cpu,
-					       sched_group_cpus(group));
-
-		/* Tally up the load of all CPUs in the group */
-		avg_load = 0;
-
-		for_each_cpu(i, sched_group_cpus(group)) {
-			/* Bias balancing toward cpus of our domain */
-			if (local_group)
-				load = source_load(i, load_idx);
-			else
-				load = target_load(i, load_idx);
-
-			avg_load += load;
-		}
-
-		/* Adjust by relative CPU power of the group */
-		avg_load = (avg_load * SCHED_LOAD_SCALE) / group->cpu_power;
-
-		if (local_group) {
-			this_load = avg_load;
-			this = group;
-		} else if (avg_load < min_load) {
-			min_load = avg_load;
-			idlest = group;
-		}
-	} while (group = group->next, group != sd->groups);
-
-	if (!idlest || 100*this_load < imbalance*min_load)
-		return NULL;
-	return idlest;
-}
-
-/*
- * find_idlest_cpu - find the idlest cpu among the cpus in group.
- */
-static int
-find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
-{
-	unsigned long load, min_load = ULONG_MAX;
-	int idlest = -1;
-	int i;
-
-	/* Traverse only the allowed CPUs */
-	for_each_cpu_and(i, sched_group_cpus(group), &p->cpus_allowed) {
-		load = weighted_cpuload(i);
-
-		if (load < min_load || (load == min_load && i == this_cpu)) {
-			min_load = load;
-			idlest = i;
-		}
-	}
-
-	return idlest;
-}
-
-/*
- * sched_balance_self: balance the current task (running on cpu) in domains
- * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
- * SD_BALANCE_EXEC.
- *
- * Balance, ie. select the least loaded group.
- *
- * Returns the target CPU number, or the same CPU if no balancing is needed.
- *
- * preempt must be disabled.
- */
-static int sched_balance_self(int cpu, int flag)
-{
-	struct task_struct *t = current;
-	struct sched_domain *tmp, *sd = NULL;
-
-	for_each_domain(cpu, tmp) {
-		/*
-		 * If power savings logic is enabled for a domain, stop there.
-		 */
-		if (tmp->flags & SD_POWERSAVINGS_BALANCE)
-			break;
-		if (tmp->flags & flag)
-			sd = tmp;
-	}
-
-	if (sd)
-		update_shares(sd);
-
-	while (sd) {
-		struct sched_group *group;
-		int new_cpu, weight;
-
-		if (!(sd->flags & flag)) {
-			sd = sd->child;
-			continue;
-		}
-
-		group = find_idlest_group(sd, t, cpu);
-		if (!group) {
-			sd = sd->child;
-			continue;
-		}
-
-		new_cpu = find_idlest_cpu(group, t, cpu);
-		if (new_cpu == -1 || new_cpu == cpu) {
-			/* Now try balancing at a lower domain level of cpu */
-			sd = sd->child;
-			continue;
-		}
-
-		/* Now try balancing at a lower domain level of new_cpu */
-		cpu = new_cpu;
-		weight = cpumask_weight(sched_domain_span(sd));
-		sd = NULL;
-		for_each_domain(cpu, tmp) {
-			if (weight <= cpumask_weight(sched_domain_span(tmp)))
-				break;
-			if (tmp->flags & flag)
-				sd = tmp;
-		}
-		/* while loop will break here if sd == NULL */
-	}
-
-	return cpu;
-}
-
 #endif /* CONFIG_SMP */
 
 /**
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 4f6356e..a82d71d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1360,6 +1360,151 @@ static int select_task_rq_fair(struct task_struct *p, int sync)
 out:
 	return wake_idle(new_cpu, p);
 }
+
+/*
+ * find_idlest_group finds and returns the least busy CPU group within the
+ * domain.
+ */
+static struct sched_group *
+find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
+{
+	struct sched_group *idlest = NULL, *this = NULL, *group = sd->groups;
+	unsigned long min_load = ULONG_MAX, this_load = 0;
+	int load_idx = sd->forkexec_idx;
+	int imbalance = 100 + (sd->imbalance_pct-100)/2;
+
+	do {
+		unsigned long load, avg_load;
+		int local_group;
+		int i;
+
+		/* Skip over this group if it has no CPUs allowed */
+		if (!cpumask_intersects(sched_group_cpus(group),
+					&p->cpus_allowed))
+			continue;
+
+		local_group = cpumask_test_cpu(this_cpu,
+					       sched_group_cpus(group));
+
+		/* Tally up the load of all CPUs in the group */
+		avg_load = 0;
+
+		for_each_cpu(i, sched_group_cpus(group)) {
+			/* Bias balancing toward cpus of our domain */
+			if (local_group)
+				load = source_load(i, load_idx);
+			else
+				load = target_load(i, load_idx);
+
+			avg_load += load;
+		}
+
+		/* Adjust by relative CPU power of the group */
+		avg_load = (avg_load * SCHED_LOAD_SCALE) / group->cpu_power;
+
+		if (local_group) {
+			this_load = avg_load;
+			this = group;
+		} else if (avg_load < min_load) {
+			min_load = avg_load;
+			idlest = group;
+		}
+	} while (group = group->next, group != sd->groups);
+
+	if (!idlest || 100*this_load < imbalance*min_load)
+		return NULL;
+	return idlest;
+}
+
+/*
+ * find_idlest_cpu - find the idlest cpu among the cpus in group.
+ */
+static int
+find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
+{
+	unsigned long load, min_load = ULONG_MAX;
+	int idlest = -1;
+	int i;
+
+	/* Traverse only the allowed CPUs */
+	for_each_cpu_and(i, sched_group_cpus(group), &p->cpus_allowed) {
+		load = weighted_cpuload(i);
+
+		if (load < min_load || (load == min_load && i == this_cpu)) {
+			min_load = load;
+			idlest = i;
+		}
+	}
+
+	return idlest;
+}
+
+/*
+ * sched_balance_self: balance the current task (running on cpu) in domains
+ * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
+ * SD_BALANCE_EXEC.
+ *
+ * Balance, ie. select the least loaded group.
+ *
+ * Returns the target CPU number, or the same CPU if no balancing is needed.
+ *
+ * preempt must be disabled.
+ */
+static int sched_balance_self(int cpu, int flag)
+{
+	struct task_struct *t = current;
+	struct sched_domain *tmp, *sd = NULL;
+
+	for_each_domain(cpu, tmp) {
+		/*
+		 * If power savings logic is enabled for a domain, stop there.
+		 */
+		if (tmp->flags & SD_POWERSAVINGS_BALANCE)
+			break;
+		if (tmp->flags & flag)
+			sd = tmp;
+	}
+
+	if (sd)
+		update_shares(sd);
+
+	while (sd) {
+		struct sched_group *group;
+		int new_cpu, weight;
+
+		if (!(sd->flags & flag)) {
+			sd = sd->child;
+			continue;
+		}
+
+		group = find_idlest_group(sd, t, cpu);
+		if (!group) {
+			sd = sd->child;
+			continue;
+		}
+
+		new_cpu = find_idlest_cpu(group, t, cpu);
+		if (new_cpu == -1 || new_cpu == cpu) {
+			/* Now try balancing at a lower domain level of cpu */
+			sd = sd->child;
+			continue;
+		}
+
+		/* Now try balancing at a lower domain level of new_cpu */
+		cpu = new_cpu;
+		weight = cpumask_weight(sched_domain_span(sd));
+		sd = NULL;
+		for_each_domain(cpu, tmp) {
+			if (weight <= cpumask_weight(sched_domain_span(tmp)))
+				break;
+			if (tmp->flags & flag)
+				sd = tmp;
+		}
+		/* while loop will break here if sd == NULL */
+	}
+
+	return cpu;
+}
 #endif /* CONFIG_SMP */
 
 /*
