Return-Path: <linux-kernel-owner+w=401wt.eu-S932105AbZKMKb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbZKMKb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbZKMKbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:31:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:58251 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbZKMKbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:31:22 -0500
Subject: Re: -next: Nov 12 - kernel BUG at kernel/sched.c:7359!
From: Peter Zijlstra <peterz@infradead.org>
To: ego@in.ibm.com
Cc: Sachin Sant <sachinp@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <1258107368.4039.1149.camel@laptop>
References: <20091112195101.63263490.sfr@canb.auug.org.au>
	 <4AFBF73B.5040500@in.ibm.com> <1258027820.4039.129.camel@laptop>
	 <4AFBFE3D.80507@in.ibm.com> <1258028831.4039.152.camel@laptop>
	 <1258045831.4039.736.camel@laptop>  <20091113095801.GA29977@in.ibm.com>
	 <1258107368.4039.1149.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 11:31:21 +0100
Message-ID: <1258108281.22655.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 11:16 +0100, Peter Zijlstra wrote:
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2376,7 +2376,15 @@ static int try_to_wake_up(struct task_st
>         p->state = TASK_WAKING;
>         __task_rq_unlock(rq);
>  
> +again:
>         cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
> +       if (!cpu_online(cpu))
> +               cpu = cpumask_any_and(&p->cpus_allowed, cpu_online_mask);
> +       if (cpu >= nr_cpu_ids) {
> +               cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
> +               goto again;
> +       }
> +
>         if (cpu != orig_cpu) {
>                 rq = cpu_rq(cpu);
>                 update_rq_clock(rq);
> 
> is what I stuck in and am compiling now.. we'll see what that does. 

Well, it boots for me, but then, I've not been able to reproduce any
issues anyway :/

/me goes try a PREEMPT=n kernel, since that is what Mike reports boot
funnies with..

Full running diff against -tip:

---
diff --git a/kernel/sched.c b/kernel/sched.c
index 1f2e99d..7089063 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2374,17 +2374,24 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 	p->state = TASK_WAKING;
-	task_rq_unlock(rq, &flags);
+	__task_rq_unlock(rq);
 
+again:
 	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
+	if (!cpu_online(cpu))
+		cpu = cpumask_any_and(&p->cpus_allowed, cpu_online_mask);
+	if (cpu >= nr_cpu_ids) {
+		printk(KERN_ERR "Breaking affinity on %d/%s\n", p->pid, p->comm);
+		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
+		goto again;
+	}
+
 	if (cpu != orig_cpu) {
-		local_irq_save(flags);
 		rq = cpu_rq(cpu);
 		update_rq_clock(rq);
 		set_task_cpu(p, cpu);
-		local_irq_restore(flags);
 	}
-	rq = task_rq_lock(p, &flags);
+	rq = __task_rq_lock(p);
 
 	WARN_ON(p->state != TASK_WAKING);
 	cpu = task_cpu(p);
@@ -7620,6 +7627,8 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	unsigned long flags;
 	struct rq *rq;
 
+	printk(KERN_ERR "migration call\n");
+
 	switch (action) {
 
 	case CPU_UP_PREPARE:
@@ -9186,6 +9195,8 @@ int __init sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
 static int update_sched_domains(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
+	printk(KERN_ERR "update_sched_domains\n");
+
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5488a5d..0ff21af 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1345,6 +1345,37 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 }
 
 /*
+ * Try and locate an idle CPU in the sched_domain.
+ */
+static int
+select_idle_sibling(struct task_struct *p, struct sched_domain *sd, int target)
+{
+	int cpu = smp_processor_id();
+	int prev_cpu = task_cpu(p);
+	int i;
+
+	/*
+	 * If this domain spans both cpu and prev_cpu (see the SD_WAKE_AFFINE
+	 * test in select_task_rq_fair) and the prev_cpu is idle then that's
+	 * always a better target than the current cpu.
+	 */
+	if (target == cpu && !cpu_rq(prev_cpu)->cfs.nr_running)
+		return prev_cpu;
+
+	/*
+	 * Otherwise, iterate the domain and find an elegible idle cpu.
+	 */
+	for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
+		if (!cpu_rq(i)->cfs.nr_running) {
+			target = i;
+			break;
+		}
+	}
+
+	return target;
+}
+
+/*
  * sched_balance_self: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
  * SD_BALANCE_EXEC.
@@ -1398,37 +1429,34 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 				want_sd = 0;
 		}
 
-		if (want_affine && (tmp->flags & SD_WAKE_AFFINE)) {
-			int candidate = -1, i;
+		/*
+		 * While iterating the domains looking for a spanning
+		 * WAKE_AFFINE domain, adjust the affine target to any idle cpu
+		 * in cache sharing domains along the way.
+		 */
+		if (want_affine) {
+			int target = -1;
 
+			/*
+			 * If both cpu and prev_cpu are part of this domain,
+			 * cpu is a valid SD_WAKE_AFFINE target.
+			 */
 			if (cpumask_test_cpu(prev_cpu, sched_domain_span(tmp)))
-				candidate = cpu;
+				target = cpu;
 
 			/*
-			 * Check for an idle shared cache.
+			 * If there's an idle sibling in this domain, make that
+			 * the wake_affine target instead of the current cpu.
 			 */
-			if (tmp->flags & SD_PREFER_SIBLING) {
-				if (candidate == cpu) {
-					if (!cpu_rq(prev_cpu)->cfs.nr_running)
-						candidate = prev_cpu;
-				}
+			if (tmp->flags & SD_PREFER_SIBLING)
+				target = select_idle_sibling(p, tmp, target);
 
-				if (candidate == -1 || candidate == cpu) {
-					for_each_cpu(i, sched_domain_span(tmp)) {
-						if (!cpumask_test_cpu(i, &p->cpus_allowed))
-							continue;
-						if (!cpu_rq(i)->cfs.nr_running) {
-							candidate = i;
-							break;
-						}
-					}
+			if (target >= 0) {
+				if (tmp->flags & SD_WAKE_AFFINE) {
+					affine_sd = tmp;
+					want_affine = 0;
 				}
-			}
-
-			if (candidate >= 0) {
-				affine_sd = tmp;
-				want_affine = 0;
-				cpu = candidate;
+				cpu = target;
 			}
 		}
 


