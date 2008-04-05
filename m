Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbYDEBN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbYDEBN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYDEBLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:11:14 -0400
Received: from relay1.sgi.com ([192.48.171.29]:57927 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751719AbYDEBLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:11:04 -0400
Message-Id: <20080405011101.857222000@polaris-admin.engr.sgi.com>
References: <20080405011100.720014000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:11:06 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] generic: use new set_cpus_allowed_ptr function
Content-Disposition: inline; filename=generic-set_cpus_allowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Use new set_cpus_allowed_ptr() function added by previous patch,
    which instead of passing the "newly allowed cpus" cpumask_t arg
    by value,  pass it by pointer:

    -int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
    +int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t *new_mask)

  * Modify CPU_MASK_ALL 

Depends on:
	[sched-devel]: sched: add new set_cpus_allowed_ptr function

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
 drivers/acpi/processor_throttling.c |   10 +++++-----
 drivers/firmware/dcdbas.c           |    4 ++--
 drivers/pci/pci-driver.c            |    9 ++++++---
 kernel/cpu.c                        |    6 +++---
 kernel/kmod.c                       |    2 +-
 kernel/kthread.c                    |    6 +++---
 kernel/rcutorture.c                 |   15 +++++++++------
 kernel/stop_machine.c               |    2 +-
 kernel/trace/trace_sysprof.c        |    4 ++--
 9 files changed, 32 insertions(+), 26 deletions(-)

--- linux-2.6.x86.orig/drivers/acpi/processor_throttling.c
+++ linux-2.6.x86/drivers/acpi/processor_throttling.c
@@ -838,10 +838,10 @@ static int acpi_processor_get_throttling
 	 * Migrate task to the cpu pointed by pr.
 	 */
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed(current, cpumask_of_cpu(pr->id));
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
 	ret = pr->throttling.acpi_processor_get_throttling(pr);
 	/* restore the previous state */
-	set_cpus_allowed(current, saved_mask);
+	set_cpus_allowed_ptr(current, &saved_mask);
 
 	return ret;
 }
@@ -1025,7 +1025,7 @@ int acpi_processor_set_throttling(struct
 	 * it can be called only for the cpu pointed by pr.
 	 */
 	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
-		set_cpus_allowed(current, cpumask_of_cpu(pr->id));
+		set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
 		ret = p_throttling->acpi_processor_set_throttling(pr,
 						t_state.target_state);
 	} else {
@@ -1056,7 +1056,7 @@ int acpi_processor_set_throttling(struct
 				continue;
 			}
 			t_state.cpu = i;
-			set_cpus_allowed(current, cpumask_of_cpu(i));
+			set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
 			ret = match_pr->throttling.
 				acpi_processor_set_throttling(
 				match_pr, t_state.target_state);
@@ -1074,7 +1074,7 @@ int acpi_processor_set_throttling(struct
 							&t_state);
 	}
 	/* restore the previous state */
-	set_cpus_allowed(current, saved_mask);
+	set_cpus_allowed_ptr(current, &saved_mask);
 	return ret;
 }
 
--- linux-2.6.x86.orig/drivers/firmware/dcdbas.c
+++ linux-2.6.x86/drivers/firmware/dcdbas.c
@@ -265,7 +265,7 @@ static int smi_request(struct smi_cmd *s
 
 	/* SMI requires CPU 0 */
 	old_mask = current->cpus_allowed;
-	set_cpus_allowed(current, cpumask_of_cpu(0));
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(0));
 	if (smp_processor_id() != 0) {
 		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
 			__FUNCTION__);
@@ -285,7 +285,7 @@ static int smi_request(struct smi_cmd *s
 	);
 
 out:
-	set_cpus_allowed(current, old_mask);
+	set_cpus_allowed_ptr(current, &old_mask);
 	return ret;
 }
 
--- linux-2.6.x86.orig/drivers/pci/pci-driver.c
+++ linux-2.6.x86/drivers/pci/pci-driver.c
@@ -182,15 +182,18 @@ static int pci_call_probe(struct pci_dri
 	struct mempolicy *oldpol;
 	cpumask_t oldmask = current->cpus_allowed;
 	int node = dev_to_node(&dev->dev);
-	if (node >= 0)
-	    set_cpus_allowed(current, node_to_cpumask(node));
+
+	if (node >= 0) {
+		node_to_cpumask_ptr(nodecpumask, node);
+		set_cpus_allowed_ptr(current, nodecpumask);
+	}
 	/* And set default memory allocation policy */
 	oldpol = current->mempolicy;
 	current->mempolicy = NULL;	/* fall back to system default policy */
 #endif
 	error = drv->probe(dev, id);
 #ifdef CONFIG_NUMA
-	set_cpus_allowed(current, oldmask);
+	set_cpus_allowed_ptr(current, &oldmask);
 	current->mempolicy = oldpol;
 #endif
 	return error;
--- linux-2.6.x86.orig/kernel/cpu.c
+++ linux-2.6.x86/kernel/cpu.c
@@ -232,9 +232,9 @@ static int _cpu_down(unsigned int cpu, i
 
 	/* Ensure that we are not runnable on dying cpu */
 	old_allowed = current->cpus_allowed;
-	tmp = CPU_MASK_ALL;
+	cpus_setall(tmp);
 	cpu_clear(cpu, tmp);
-	set_cpus_allowed(current, tmp);
+	set_cpus_allowed_ptr(current, &tmp);
 
 	p = __stop_machine_run(take_cpu_down, &tcd_param, cpu);
 
@@ -268,7 +268,7 @@ static int _cpu_down(unsigned int cpu, i
 out_thread:
 	err = kthread_stop(p);
 out_allowed:
-	set_cpus_allowed(current, old_allowed);
+	set_cpus_allowed_ptr(current, &old_allowed);
 out_release:
 	cpu_hotplug_done();
 	return err;
--- linux-2.6.x86.orig/kernel/kmod.c
+++ linux-2.6.x86/kernel/kmod.c
@@ -165,7 +165,7 @@ static int ____call_usermodehelper(void 
 	}
 
 	/* We can run anywhere, unlike our parent keventd(). */
-	set_cpus_allowed(current, CPU_MASK_ALL);
+	set_cpus_allowed_ptr(current, CPU_MASK_ALL_PTR);
 
 	/*
 	 * Our parent is keventd, which runs with elevated scheduling priority.
--- linux-2.6.x86.orig/kernel/kthread.c
+++ linux-2.6.x86/kernel/kthread.c
@@ -109,7 +109,7 @@ static void create_kthread(struct kthrea
 		 */
 		sched_setscheduler(create->result, SCHED_NORMAL, &param);
 		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
-		set_cpus_allowed(create->result, cpu_system_map);
+		set_cpus_allowed_ptr(create->result, &cpu_system_map);
 	}
 	complete(&create->done);
 }
@@ -235,7 +235,7 @@ int kthreadd(void *unused)
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
 	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
-	set_cpus_allowed(tsk, cpu_system_map);
+	set_cpus_allowed_ptr(tsk, &cpu_system_map);
 
 	current->flags |= PF_NOFREEZE;
 
@@ -284,7 +284,7 @@ again:
 			 */
 			get_task_struct(t);
 			rcu_read_unlock();
-			set_cpus_allowed(t, *new_system_map);
+			set_cpus_allowed_ptr(t, new_system_map);
 			put_task_struct(t);
 			goto again;
 		}
--- linux-2.6.x86.orig/kernel/rcutorture.c
+++ linux-2.6.x86/kernel/rcutorture.c
@@ -723,9 +723,10 @@ static int rcu_idle_cpu;	/* Force all to
  */
 static void rcu_torture_shuffle_tasks(void)
 {
-	cpumask_t tmp_mask = CPU_MASK_ALL;
+	cpumask_t tmp_mask;
 	int i;
 
+	cpus_setall(tmp_mask);
 	get_online_cpus();
 
 	/* No point in shuffling if there is only one online CPU (ex: UP) */
@@ -737,25 +738,27 @@ static void rcu_torture_shuffle_tasks(vo
 	if (rcu_idle_cpu != -1)
 		cpu_clear(rcu_idle_cpu, tmp_mask);
 
-	set_cpus_allowed(current, tmp_mask);
+	set_cpus_allowed_ptr(current, &tmp_mask);
 
 	if (reader_tasks) {
 		for (i = 0; i < nrealreaders; i++)
 			if (reader_tasks[i])
-				set_cpus_allowed(reader_tasks[i], tmp_mask);
+				set_cpus_allowed_ptr(reader_tasks[i],
+						     &tmp_mask);
 	}
 
 	if (fakewriter_tasks) {
 		for (i = 0; i < nfakewriters; i++)
 			if (fakewriter_tasks[i])
-				set_cpus_allowed(fakewriter_tasks[i], tmp_mask);
+				set_cpus_allowed_ptr(fakewriter_tasks[i],
+						     &tmp_mask);
 	}
 
 	if (writer_task)
-		set_cpus_allowed(writer_task, tmp_mask);
+		set_cpus_allowed_ptr(writer_task, &tmp_mask);
 
 	if (stats_task)
-		set_cpus_allowed(stats_task, tmp_mask);
+		set_cpus_allowed_ptr(stats_task, &tmp_mask);
 
 	if (rcu_idle_cpu == -1)
 		rcu_idle_cpu = num_online_cpus() - 1;
--- linux-2.6.x86.orig/kernel/stop_machine.c
+++ linux-2.6.x86/kernel/stop_machine.c
@@ -35,7 +35,7 @@ static int stopmachine(void *cpu)
 	int irqs_disabled = 0;
 	int prepared = 0;
 
-	set_cpus_allowed(current, cpumask_of_cpu((int)(long)cpu));
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu((int)(long)cpu));
 
 	/* Ack: we are alive */
 	smp_mb(); /* Theoretically the ack = 0 might not be on this CPU yet. */
--- linux-2.6.x86.orig/kernel/trace/trace_sysprof.c
+++ linux-2.6.x86/kernel/trace/trace_sysprof.c
@@ -205,10 +205,10 @@ static void start_stack_timers(void)
 	int cpu;
 
 	for_each_online_cpu(cpu) {
-		set_cpus_allowed(current, cpumask_of_cpu(cpu));
+		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 		start_stack_timer(cpu);
 	}
-	set_cpus_allowed(current, saved_mask);
+	set_cpus_allowed_ptr(current, &saved_mask);
 }
 
 static void stop_stack_timer(int cpu)

-- 
