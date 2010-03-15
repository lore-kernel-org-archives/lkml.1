Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936011Ab0COJNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 05:13:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935996Ab0COJM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 05:12:29 -0400
Date: Mon, 15 Mar 2010 10:10:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Ben Blum <bblum@google.com>, Jiri Slaby <jirislaby@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] _cpu_down: don't play with current->cpus_allowed
Message-ID: <20100315091023.GA9148@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    1 +
 kernel/sched.c        |    2 +-
 kernel/cpu.c          |   18 ++++++------------
 3 files changed, 8 insertions(+), 13 deletions(-)

--- 34-rc1/include/linux/sched.h~4_CPU_DOWN_AFFINITY	2010-03-15 09:37:46.000000000 +0100
+++ 34-rc1/include/linux/sched.h	2010-03-15 09:41:51.000000000 +0100
@@ -1843,6 +1843,7 @@ extern void sched_clock_idle_sleep_event
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
 
 #ifdef CONFIG_HOTPLUG_CPU
+extern void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p);
 extern void idle_task_exit(void);
 #else
 static inline void idle_task_exit(void) {}
--- 34-rc1/kernel/sched.c~4_CPU_DOWN_AFFINITY	2010-03-15 09:41:28.000000000 +0100
+++ 34-rc1/kernel/sched.c	2010-03-15 09:41:51.000000000 +0100
@@ -5503,7 +5503,7 @@ static int migration_thread(void *data)
 /*
  * Figure out where task on dead CPU should go, use force if necessary.
  */
-static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
+void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
 	struct rq *rq = cpu_rq(dead_cpu);
 	int needs_cpu, dest_cpu;
--- 34-rc1/kernel/cpu.c~4_CPU_DOWN_AFFINITY	2010-03-15 09:37:46.000000000 +0100
+++ 34-rc1/kernel/cpu.c	2010-03-15 09:41:51.000000000 +0100
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
 	set_cpu_active(cpu, false);
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
@@ -224,10 +225,6 @@ static int __ref _cpu_down(unsigned int 
 		goto out_release;
 	}
 
-	/* Ensure that we are not runnable on dying cpu */
-	cpumask_copy(old_allowed, &current->cpus_allowed);
-	set_cpus_allowed_ptr(current, cpu_active_mask);
-
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
 		set_cpu_active(cpu, true);
@@ -236,7 +233,7 @@ static int __ref _cpu_down(unsigned int 
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 
-		goto out_allowed;
+		goto out_release;
 	}
 	BUG_ON(cpu_online(cpu));
 
@@ -254,8 +251,6 @@ static int __ref _cpu_down(unsigned int 
 
 	check_for_tasks(cpu);
 
-out_allowed:
-	set_cpus_allowed_ptr(current, old_allowed);
 out_release:
 	cpu_hotplug_done();
 	if (!err) {
@@ -263,7 +258,6 @@ out_release:
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 	}
-	free_cpumask_var(old_allowed);
 	return err;
 }
 

