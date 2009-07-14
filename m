Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbZGNIrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbZGNIrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 04:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZGNIrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 04:47:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62371 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbZGNIrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 04:47:05 -0400
Message-ID: <4A5C4626.8000000@cn.fujitsu.com>
Date: Tue, 14 Jul 2009 16:47:34 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpu_hotplug: don't affect current task's affinity
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


_cpu_down() changes current task's affinity and then
recovers it at the end.

It brings two defects:

1) The recovering will failed in some condition.

# grep Cpus_allowed_list /proc/$$/status
Cpus_allowed_list:      0-3

# taskset -pc 2 $$
pid 29075's current affinity list: 0-3
pid 29075's new affinity list: 2

# grep Cpus_allowed_list /proc/$$/status
Cpus_allowed_list:      2

# echo 0 > /sys/devices/system/cpu/cpu2/online

# grep Cpus_allowed_list /proc/$$/status
Cpus_allowed_list:      0

In linux, tasks' "Cpus_allowed_list" which are "2" originally
will become "0-1,3" after the cpu#2 is offlined.

This "Cpus_allowed_list:      0" is suspicionful.

2) current task is a userspace task, the user may change
its cpu-affinity at the same time. The user may get unexpected
result if _cpu_down() changes current task's affinity.

Actually, we don't have to change the affinity.
We create a kernel thread to do the works.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 8ce1004..901caeb 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -162,15 +162,17 @@ static inline void check_for_tasks(int cpu)
 	write_unlock_irq(&tasklist_lock);
 }
 
-struct take_cpu_down_param {
+struct cpu_down_param {
 	unsigned long mod;
-	void *hcpu;
+	unsigned int cpu;
+	int ret;
+	struct completion done;
 };
 
 /* Take this CPU down. */
 static int __ref take_cpu_down(void *_param)
 {
-	struct take_cpu_down_param *param = _param;
+	struct cpu_down_param *param = _param;
 	int err;
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
@@ -179,7 +181,7 @@ static int __ref take_cpu_down(void *_param)
 		return err;
 
 	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
-				param->hcpu);
+				(void *)(long)param->cpu);
 
 	/* Force idle task to run as soon as we yield: it should
 	   immediately notice cpu is offline and die quickly. */
@@ -187,26 +189,13 @@ static int __ref take_cpu_down(void *_param)
 	return 0;
 }
 
-/* Requires cpu_add_remove_lock to be held */
-static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
+static int __ref _cpu_down_thread(void *_param)
 {
+	struct cpu_down_param *param = _param;
 	int err, nr_calls = 0;
-	cpumask_var_t old_allowed;
+	unsigned long mod = param->mod;
+	unsigned int cpu = param->cpu;
 	void *hcpu = (void *)(long)cpu;
-	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
-	struct take_cpu_down_param tcd_param = {
-		.mod = mod,
-		.hcpu = hcpu,
-	};
-
-	if (num_online_cpus() == 1)
-		return -EBUSY;
-
-	if (!cpu_online(cpu))
-		return -EINVAL;
-
-	if (!alloc_cpumask_var(&old_allowed, GFP_KERNEL))
-		return -ENOMEM;
 
 	cpu_hotplug_begin();
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
@@ -222,18 +211,16 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	}
 
 	/* Ensure that we are not runnable on dying cpu */
-	cpumask_copy(old_allowed, &current->cpus_allowed);
-	set_cpus_allowed_ptr(current,
-			     cpumask_of(cpumask_any_but(cpu_online_mask, cpu)));
+	set_cpus_allowed_ptr(current, cpu_active_mask);
 
-	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
+	err = __stop_machine(take_cpu_down, param, cpumask_of(cpu));
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 
-		goto out_allowed;
+		goto out_release;
 	}
 	BUG_ON(cpu_online(cpu));
 
@@ -251,8 +238,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 
 	check_for_tasks(cpu);
 
-out_allowed:
-	set_cpus_allowed_ptr(current, old_allowed);
 out_release:
 	cpu_hotplug_done();
 	if (!err) {
@@ -260,8 +245,35 @@ out_release:
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 	}
-	free_cpumask_var(old_allowed);
-	return err;
+	param->ret = err;
+	complete(&param->done);
+
+	return 0;
+}
+
+/* Requires cpu_add_remove_lock to be held */
+static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
+{
+	struct task_struct *k;
+	struct cpu_down_param param = {
+		.mod = tasks_frozen ? CPU_TASKS_FROZEN : 0,
+		.cpu = cpu,
+		.ret = 0,
+	};
+
+	if (num_online_cpus() == 1)
+		return -EBUSY;
+
+	if (!cpu_online(cpu))
+		return -EINVAL;
+
+	init_completion(&param.done);
+	k = kthread_run(_cpu_down_thread, &param, "kcpu_down");
+	if (IS_ERR(k))
+		return PTR_ERR(k);
+	wait_for_completion(&param.done);
+
+	return param.ret;
 }
 
 int __ref cpu_down(unsigned int cpu)


