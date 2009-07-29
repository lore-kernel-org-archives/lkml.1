Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbZG2VrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbZG2VrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 17:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZG2VrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 17:47:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60203 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbZG2VrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:47:10 -0400
Date: Wed, 29 Jul 2009 23:43:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH 1/1] cpu_hotplug: don't play with current->cpus_allowed
Message-ID: <20090729214310.GB24631@redhat.com>
References: <20090729023302.GA8899@redhat.com> <20090729212125.GA16970@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729212125.GA16970@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_cpu_down() changes the current task's affinity and then recovers it at
the end. The problems are well known: we can't restore old_allowed if it
was bound to the now-dead-cpu, and we can race with the userspace which
can change cpu-affinity during unplug.

_cpu_down() should not play with current->cpus_allowed at all. Instead,
take_cpu_down() can migrate the caller of _cpu_down() after __cpu_disable()
removes the dying cpu from cpu_online_mask.

Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    1 +
 kernel/sched.c        |    2 +-
 kernel/cpu.c          |   19 ++++++-------------
 3 files changed, 8 insertions(+), 14 deletions(-)

--- CPUHP/include/linux/sched.h~CPU_DOWN_AFF	2009-07-23 17:06:39.000000000 +0200
+++ CPUHP/include/linux/sched.h	2009-07-29 23:27:44.000000000 +0200
@@ -1794,6 +1794,7 @@ extern void sched_clock_idle_sleep_event
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
 
 #ifdef CONFIG_HOTPLUG_CPU
+extern void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p);
 extern void idle_task_exit(void);
 #else
 static inline void idle_task_exit(void) {}
--- CPUHP/kernel/sched.c~CPU_DOWN_AFF	2009-07-29 22:18:33.000000000 +0200
+++ CPUHP/kernel/sched.c	2009-07-29 23:27:44.000000000 +0200
@@ -7118,7 +7118,7 @@ static int __migrate_task_irq(struct tas
 /*
  * Figure out where task on dead CPU should go, use force if necessary.
  */
-static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
+void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
 	int dest_cpu;
 	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(dead_cpu));
--- CPUHP/kernel/cpu.c~CPU_DOWN_AFF	2009-06-23 14:23:52.000000000 +0200
+++ CPUHP/kernel/cpu.c	2009-07-29 23:27:44.000000000 +0200
@@ -163,6 +163,7 @@ static inline void check_for_tasks(int c
 }
 
 struct take_cpu_down_param {
+	struct task_struct *caller;
 	unsigned long mod;
 	void *hcpu;
 };
@@ -171,6 +172,7 @@ struct take_cpu_down_param {
 static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
+	unsigned int cpu = (unsigned long)param->hcpu;
 	int err;
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
@@ -181,6 +183,8 @@ static int __ref take_cpu_down(void *_pa
 	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
 				param->hcpu);
 
+	if (task_cpu(param->caller) == cpu)
+		move_task_off_dead_cpu(cpu, param->caller);
 	/* Force idle task to run as soon as we yield: it should
 	   immediately notice cpu is offline and die quickly. */
 	sched_idle_next();
@@ -191,10 +195,10 @@ static int __ref take_cpu_down(void *_pa
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
@@ -205,9 +209,6 @@ static int __ref _cpu_down(unsigned int 
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&old_allowed, GFP_KERNEL))
-		return -ENOMEM;
-
 	cpu_hotplug_begin();
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
@@ -221,11 +222,6 @@ static int __ref _cpu_down(unsigned int 
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
@@ -233,7 +229,7 @@ static int __ref _cpu_down(unsigned int 
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 
-		goto out_allowed;
+		goto out_release;
 	}
 	BUG_ON(cpu_online(cpu));
 
@@ -251,8 +247,6 @@ static int __ref _cpu_down(unsigned int 
 
 	check_for_tasks(cpu);
 
-out_allowed:
-	set_cpus_allowed_ptr(current, old_allowed);
 out_release:
 	cpu_hotplug_done();
 	if (!err) {
@@ -260,7 +254,6 @@ out_release:
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 	}
-	free_cpumask_var(old_allowed);
 	return err;
 }
 

