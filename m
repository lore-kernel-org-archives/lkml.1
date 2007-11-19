Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbXKSUu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbXKSUu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 15:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbXKSUuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 15:50:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42007 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbXKSUuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 15:50:13 -0500
Date: Mon, 19 Nov 2007 21:50:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David <david@livux.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3,
	v2.6.23.8,v2.6.22.13, v2.6.21.7
Message-ID: <20071119205000.GB25142@elte.hu>
References: <200711191925.12072.david@livux.com> <20071119185759.GA12117@elte.hu> <200711192051.44095.david@livux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711192051.44095.david@livux.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David <david@livux.com> wrote:

> I have removed all other patches, and applied only cfs v24 above 
> 2.6.23.8, and the compiler ran into (with CONFIG_FAIR_GROUP_SCHED 
> enabled):

does the patch below help?

	Ingo

Index: linux-cfs-2.6.23.8.q/kernel/sched.c
===================================================================
--- linux-cfs-2.6.23.8.q.orig/kernel/sched.c
+++ linux-cfs-2.6.23.8.q/kernel/sched.c
@@ -221,11 +221,14 @@ static struct cfs_rq *init_cfs_rq_p[NR_C
 
 static DEFINE_MUTEX(doms_cur_mutex); /* serialize access to doms_curr[] array */
 
+#ifdef CONFIG_SMP
 /* kernel thread that runs rebalance_shares() periodically */
 static struct task_struct *lb_monitor_task;
 
-static void set_se_shares(struct sched_entity *se, unsigned long shares);
 static int load_balance_monitor(void *unused);
+#endif
+
+static void set_se_shares(struct sched_entity *se, unsigned long shares);
 
 /* Default task group.
  *	Every task in system belong to this group at bootup.
@@ -5178,6 +5181,8 @@ static int migration_thread(void *data)
 		struct migration_req *req;
 		struct list_head *head;
 
+		try_to_freeze();
+
 		spin_lock_irq(&rq->lock);
 
 		if (cpu_is_offline(cpu)) {
@@ -5595,6 +5600,7 @@ migration_call(struct notifier_block *nf
 		p = kthread_create(migration_thread, hcpu, "migration/%d", cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
+		p->flags |= PF_NOFREEZE;
 		kthread_bind(p, cpu);
 		/* Must be high prio: stop_machine expects to yield to it. */
 		rq = task_rq_lock(p, &flags);
@@ -6050,7 +6056,7 @@ static int cpu_to_core_group(int cpu, co
 			     struct sched_group **sg)
 {
 	int group;
-	cpumask_t mask = per_cpu(cpu_sibling_map, cpu);
+	cpumask_t mask = cpu_sibling_map(cpu);
 	cpus_and(mask, mask, *cpu_map);
 	group = first_cpu(mask);
 	if (sg)
@@ -6079,7 +6085,7 @@ static int cpu_to_phys_group(int cpu, co
 	cpus_and(mask, mask, *cpu_map);
 	group = first_cpu(mask);
 #elif defined(CONFIG_SCHED_SMT)
-	cpumask_t mask = per_cpu(cpu_sibling_map, cpu);
+	cpumask_t mask = cpu_sibling_map(cpu);
 	cpus_and(mask, mask, *cpu_map);
 	group = first_cpu(mask);
 #else
@@ -6313,7 +6319,7 @@ static int build_sched_domains(const cpu
 		p = sd;
 		sd = &per_cpu(cpu_domains, i);
 		*sd = SD_SIBLING_INIT;
-		sd->span = per_cpu(cpu_sibling_map, i);
+		sd->span = cpu_sibling_map(i);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
@@ -6324,7 +6330,7 @@ static int build_sched_domains(const cpu
 #ifdef CONFIG_SCHED_SMT
 	/* Set up CPU (sibling) groups */
 	for_each_cpu_mask(i, *cpu_map) {
-		cpumask_t this_sibling_map = per_cpu(cpu_sibling_map, i);
+		cpumask_t this_sibling_map = cpu_sibling_map(i);
 		cpus_and(this_sibling_map, this_sibling_map, *cpu_map);
 		if (i != first_cpu(this_sibling_map))
 			continue;
@@ -6742,7 +6748,7 @@ void __init sched_init_smp(void)
 		BUG();
 	sched_init_granularity();
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
 	lb_monitor_task = kthread_create(load_balance_monitor, NULL,
 					 "load_balance_monitor");
 	if (!IS_ERR(lb_monitor_task))
@@ -7006,7 +7012,7 @@ void set_curr_task(int cpu, struct task_
 
 #endif
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
 
 /* distribute shares of all task groups among their schedulable entities,
  * to reflect load distrbution across cpus.
@@ -7138,6 +7144,9 @@ static int load_balance_monitor(void *un
 	return 0;
 }
 
+#endif
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
 /* allocate runqueue etc for a new task group */
 struct task_group *sched_create_group(void)
 {

