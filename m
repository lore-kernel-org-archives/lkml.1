Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbZG2Cgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbZG2Cgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 22:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbZG2Cgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 22:36:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60193 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbZG2Cgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 22:36:53 -0400
Date: Wed, 29 Jul 2009 04:33:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: + cpu_hotplug-dont-affect-current-tasks-affinity.patch added
	to -mm tree
Message-ID: <20090729023302.GA8899@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed this patch by accident...

> Subject: cpu_hotplug: don't affect current task's affinity
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
>
> _cpu_down() changes the current task's affinity and then recovers it at
> the end.
>
> It has two problems:

Yes.

But can't we make a much more simple patch ?

Why should we play with set_cpus_allowed() at all? We can just migrate
the caller of _cpu_down() before other tasks, right after take_cpu_down()
does __cpu_disable()->remove_cpu_from_maps().

No?

Oleg.

------------------------------------------------------------------------
Uncompiled, and we need to export move_task_off_dead_cpu(). Just to
explain what I mean.

 kernel/cpu.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -163,6 +163,7 @@ static inline void check_for_tasks(int c
 }
 
 struct take_cpu_down_param {
+	struct task_struct *caller;
 	unsigned long mod;
 	void *hcpu;
 };
@@ -181,6 +182,8 @@ static int __ref take_cpu_down(void *_pa
 	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
 				param->hcpu);
 
+	move_task_off_dead_cpu(param->hcpu, param->caller);
+
 	/* Force idle task to run as soon as we yield: it should
 	   immediately notice cpu is offline and die quickly. */
 	sched_idle_next();
@@ -191,10 +194,10 @@ static int __ref take_cpu_down(void *_pa
 static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err, nr_calls = 0;
-	cpumask_var_t old_allowed;
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct take_cpu_down_param tcd_param = {
+		.caller = current,
 		.mod = mod,
 		.hcpu = hcpu,
 	};
@@ -205,9 +208,6 @@ static int __ref _cpu_down(unsigned int 
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&old_allowed, GFP_KERNEL))
-		return -ENOMEM;
-
 	cpu_hotplug_begin();
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
@@ -221,11 +221,6 @@ static int __ref _cpu_down(unsigned int 
 		goto out_release;
 	}
 
-	/* Ensure that we are not runnable on dying cpu */
-	cpumask_copy(old_allowed, &current->cpus_allowed);
-	set_cpus_allowed_ptr(current,
-			     cpumask_of(cpumask_any_but(cpu_online_mask, cpu)));
-
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
@@ -233,7 +228,7 @@ static int __ref _cpu_down(unsigned int 
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 
-		goto out_allowed;
+		goto out_release;
 	}
 	BUG_ON(cpu_online(cpu));
 
@@ -251,8 +246,6 @@ static int __ref _cpu_down(unsigned int 
 
 	check_for_tasks(cpu);
 
-out_allowed:
-	set_cpus_allowed_ptr(current, old_allowed);
 out_release:
 	cpu_hotplug_done();
 	if (!err) {
@@ -260,7 +253,6 @@ out_release:
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 	}
-	free_cpumask_var(old_allowed);
 	return err;
 }
 

