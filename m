Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYKJIuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYKJIuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 03:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbYKJIuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 03:50:04 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:44756 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbYKJIuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 03:50:01 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch] restore sched_exec load balance heuristics
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <20081106200746.GA3578@elte.hu>
References: <b040c32a0811061140u27093e4er70a43041564617f1@mail.gmail.com>
	 <20081106200746.GA3578@elte.hu>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 09:50:53 +0100
Message-Id: <1226307053.2697.3993.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-06 at 21:07 +0100, Ingo Molnar wrote:

> ok, this should be solved - but rather at the level of 
> sched_balance_self(): it should never migrate this task over to 
> another cpu, it should take away this task's load from the current 
> CPU's load when considering migration.

How's this?

(compile tested only)

---
Subject: sched: fix sched_exec
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Nov 10 09:47:54 CET 2008

When deciding placement for an execve() task, subtract the effect of the
current task.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2035,7 +2035,8 @@ static unsigned long target_load(int cpu
  * domain.
  */
 static struct sched_group *
-find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
+find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu,
+		  int org_cpu, unsigned long org_weight)
 {
 	struct sched_group *idlest = NULL, *this = NULL, *group = sd->groups;
 	unsigned long min_load = ULONG_MAX, this_load = 0;
@@ -2063,6 +2064,9 @@ find_idlest_group(struct sched_domain *s
 			else
 				load = target_load(i, load_idx);
 
+			if (i == org_cpu)
+				load -= min(org_weight, load);
+
 			avg_load += load;
 		}
 
@@ -2089,7 +2093,7 @@ find_idlest_group(struct sched_domain *s
  */
 static int
 find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu,
-		cpumask_t *tmp)
+		cpumask_t *tmp, int org_cpu, unsigned long org_weight)
 {
 	unsigned long load, min_load = ULONG_MAX;
 	int idlest = -1;
@@ -2101,6 +2105,9 @@ find_idlest_cpu(struct sched_group *grou
 	for_each_cpu_mask_nr(i, *tmp) {
 		load = weighted_cpuload(i);
 
+		if (i == org_cpu)
+			load -= org_weight;
+
 		if (load < min_load || (load == min_load && i == this_cpu)) {
 			min_load = load;
 			idlest = i;
@@ -2121,10 +2128,11 @@ find_idlest_cpu(struct sched_group *grou
  *
  * preempt must be disabled.
  */
-static int sched_balance_self(int cpu, int flag)
+static int sched_balance_self(int cpu, int flag, unsigned long org_weight)
 {
 	struct task_struct *t = current;
 	struct sched_domain *tmp, *sd = NULL;
+	int org_cpu = cpu;
 
 	for_each_domain(cpu, tmp) {
 		/*
@@ -2150,13 +2158,14 @@ static int sched_balance_self(int cpu, i
 		}
 
 		span = sd->span;
-		group = find_idlest_group(sd, t, cpu);
+		group = find_idlest_group(sd, t, cpu, org_cpu, org_weight);
 		if (!group) {
 			sd = sd->child;
 			continue;
 		}
 
-		new_cpu = find_idlest_cpu(group, t, cpu, &tmpmask);
+		new_cpu = find_idlest_cpu(group, t, cpu, &tmpmask,
+					  org_cpu, org_weight);
 		if (new_cpu == -1 || new_cpu == cpu) {
 			/* Now try balancing at a lower domain level of cpu */
 			sd = sd->child;
@@ -2365,7 +2374,7 @@ void sched_fork(struct task_struct *p, i
 	__sched_fork(p);
 
 #ifdef CONFIG_SMP
-	cpu = sched_balance_self(cpu, SD_BALANCE_FORK);
+	cpu = sched_balance_self(cpu, SD_BALANCE_FORK, 0);
 #endif
 	set_task_cpu(p, cpu);
 
@@ -2856,7 +2865,14 @@ out:
 void sched_exec(void)
 {
 	int new_cpu, this_cpu = get_cpu();
-	new_cpu = sched_balance_self(this_cpu, SD_BALANCE_EXEC);
+	struct task_group *tg;
+	long weight, eload;
+
+	tg = task_group(current);
+	weight = current->se.load.weight;
+	eload = -effective_load(tg, this_cpu, -weight, -weight);
+
+	new_cpu = sched_balance_self(this_cpu, SD_BALANCE_EXEC, eload);
 	put_cpu();
 	if (new_cpu != this_cpu)
 		sched_migrate_task(current, new_cpu);


