Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbZKSJAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbZKSJAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 04:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZKSJAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 04:00:11 -0500
Received: from ozlabs.org ([203.10.76.45]:46525 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284AbZKSJAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 04:00:07 -0500
Cc: Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
       Tony Luck <tony.luck@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Mike Travis <travis@sgi.com>
CC: Bryan Wu <cooloney@kernel.org>
CC: Tony Luck <tony.luck@intel.com>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mundt <lethal@linux-sh.org>
CC: "David S. Miller" <davem@davemloft.net>
CC: Ingo Molnar <mingo@redhat.com>
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911191930.11038.rusty@rustcorp.com.au>
Date: Thu, 19 Nov 2009 19:30:10 +1030
Subject: [PATCH 2/6] cpumask: use tsk_cpumask() to access task_struct cpus_allowed.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to play with cpus_allowed.

We also take the chance to use modern cpumask_* operators on the
lines changed.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/arm/mach-integrator/cpu.c               |    4 +--
 arch/blackfin/kernel/process.c               |    3 +-
 arch/ia64/kernel/cpufreq/acpi-cpufreq.c      |    4 +--
 arch/ia64/kernel/mca.c                       |    2 -
 arch/ia64/kernel/salinfo.c                   |    2 -
 arch/ia64/kernel/topology.c                  |    2 -
 arch/ia64/sn/kernel/sn2/sn_hwperf.c          |    2 -
 arch/mips/include/asm/system.h               |    3 +-
 arch/mips/kernel/traps.c                     |    8 +++----
 arch/powerpc/kernel/smp.c                    |    2 -
 arch/powerpc/platforms/cell/spufs/sched.c    |    2 -
 arch/sh/kernel/cpufreq.c                     |    2 -
 arch/sparc/kernel/sysfs.c                    |    2 -
 arch/sparc/kernel/us2e_cpufreq.c             |    4 +--
 arch/sparc/kernel/us3_cpufreq.c              |    4 +--
 arch/x86/kernel/cpu/mcheck/mce_intel.c       |    2 -
 drivers/acpi/processor_throttling.c          |    4 +--
 drivers/firmware/dcdbas.c                    |    2 -
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    6 ++---
 kernel/cpu.c                                 |    2 -
 kernel/cpuset.c                              |    6 ++---
 kernel/fork.c                                |    4 +--
 kernel/sched.c                               |   28 +++++++++++++--------------
 kernel/sched_cpupri.c                        |    4 +--
 kernel/sched_fair.c                          |    6 ++---
 kernel/sched_rt.c                            |    6 ++---
 kernel/trace/trace_workqueue.c               |    6 ++---
 lib/smp_processor_id.c                       |    2 -
 28 files changed, 63 insertions(+), 61 deletions(-)

diff --git a/arch/arm/mach-integrator/cpu.c b/arch/arm/mach-integrator/cpu.c
--- a/arch/arm/mach-integrator/cpu.c
+++ b/arch/arm/mach-integrator/cpu.c
@@ -86,7 +86,7 @@ static int integrator_set_target(struct 
 	/*
 	 * Save this threads cpus_allowed mask.
 	 */
-	cpus_allowed = current->cpus_allowed;
+	cpus_allowed = *tsk_cpumask(current);
 
 	/*
 	 * Bind to the specified CPU.  When this call returns,
@@ -157,7 +157,7 @@ static unsigned int integrator_get(unsig
 	u_int cm_osc;
 	struct icst525_vco vco;
 
-	cpus_allowed = current->cpus_allowed;
+	cpus_allowed = *tsk_cpumask(current);
 
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	BUG_ON(cpu != smp_processor_id());
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -179,7 +179,8 @@ asmlinkage int bfin_clone(struct pt_regs
 
 #ifdef __ARCH_SYNC_CORE_DCACHE
 	if (current->rt.nr_cpus_allowed == num_possible_cpus()) {
-		current->cpus_allowed = cpumask_of_cpu(smp_processor_id());
+		cpumask_copy(tsk_cpumask(current),
+			     cpumask_of(smp_processor_id()));
 		current->rt.nr_cpus_allowed = 1;
 	}
 #endif
diff --git a/arch/ia64/kernel/cpufreq/acpi-cpufreq.c b/arch/ia64/kernel/cpufreq/acpi-cpufreq.c
--- a/arch/ia64/kernel/cpufreq/acpi-cpufreq.c
+++ b/arch/ia64/kernel/cpufreq/acpi-cpufreq.c
@@ -111,7 +111,7 @@ processor_get_freq (
 
 	dprintk("processor_get_freq\n");
 
-	saved_mask = current->cpus_allowed;
+	saved_mask = *tsk_cpumask(current);
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	if (smp_processor_id() != cpu)
 		goto migrate_end;
@@ -149,7 +149,7 @@ processor_set_freq (
 
 	dprintk("processor_set_freq\n");
 
-	saved_mask = current->cpus_allowed;
+	saved_mask = *tsk_cpumask(current);
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	if (smp_processor_id() != cpu) {
 		retval = -EAGAIN;
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -1814,7 +1814,7 @@ format_mca_init_stack(void *mca_data, un
 	ti->cpu = cpu;
 	p->stack = ti;
 	p->state = TASK_UNINTERRUPTIBLE;
-	cpu_set(cpu, p->cpus_allowed);
+	cpumask_set_cpu(cpu, tsk_cpumask(p));
 	INIT_LIST_HEAD(&p->tasks);
 	p->parent = p->real_parent = p->group_leader = p;
 	INIT_LIST_HEAD(&p->children);
diff --git a/arch/ia64/kernel/salinfo.c b/arch/ia64/kernel/salinfo.c
--- a/arch/ia64/kernel/salinfo.c
+++ b/arch/ia64/kernel/salinfo.c
@@ -403,7 +403,7 @@ salinfo_log_release(struct inode *inode,
 static void
 call_on_cpu(int cpu, void (*fn)(void *), void *arg)
 {
-	cpumask_t save_cpus_allowed = current->cpus_allowed;
+	cpumask_t save_cpus_allowed = *tsk_cpumask(current);
 	cpumask_t new_cpus_allowed = cpumask_of_cpu(cpu);
 	set_cpus_allowed(current, new_cpus_allowed);
 	(*fn)(arg);
diff --git a/arch/ia64/kernel/topology.c b/arch/ia64/kernel/topology.c
--- a/arch/ia64/kernel/topology.c
+++ b/arch/ia64/kernel/topology.c
@@ -359,7 +359,7 @@ static int __cpuinit cache_add_dev(struc
 	if (all_cpu_cache_info[cpu].kobj.parent)
 		return 0;
 
-	oldmask = current->cpus_allowed;
+	oldmask = *tsk_cpumask(current);
 	retval = set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	if (unlikely(retval))
 		return retval;
diff --git a/arch/ia64/sn/kernel/sn2/sn_hwperf.c b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
+++ b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -628,7 +628,7 @@ static int sn_hwperf_op_cpu(struct sn_hw
 		}
 		else {
 			/* migrate the task before calling SAL */ 
-			save_allowed = current->cpus_allowed;
+			save_allowed = *tsk_cpumask(current);
 			set_cpus_allowed(current, cpumask_of_cpu(cpu));
 			sn_hwperf_call_sal(op_info);
 			set_cpus_allowed(current, save_allowed);
diff --git a/arch/mips/include/asm/system.h b/arch/mips/include/asm/system.h
--- a/arch/mips/include/asm/system.h
+++ b/arch/mips/include/asm/system.h
@@ -57,7 +57,8 @@ do {									\
 	    test_ti_thread_flag(__prev_ti, TIF_FPUBOUND) &&		\
 	    (!(KSTK_STATUS(prev) & ST0_CU1))) {				\
 		clear_ti_thread_flag(__prev_ti, TIF_FPUBOUND);		\
-		prev->cpus_allowed = prev->thread.user_cpus_allowed;	\
+		cpumask_copy(tsk_cpumask(prev),				\
+			     &prev->thread.user_cpus_allowed);		\
 	}								\
 	next->thread.emulated_fp = 0;					\
 } while(0)
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -843,13 +843,13 @@ static void mt_ase_fp_affinity(void)
 		 * restricted the allowed set to exclude any CPUs with FPUs,
 		 * we'll skip the procedure.
 		 */
-		if (cpus_intersects(current->cpus_allowed, mt_fpu_cpumask)) {
+		if (cpumask_intersects(tsk_cpumask(current), &mt_fpu_cpumask)) {
 			cpumask_t tmask;
 
 			current->thread.user_cpus_allowed
-				= current->cpus_allowed;
-			cpus_and(tmask, current->cpus_allowed,
-				mt_fpu_cpumask);
+				= *tsk_cpumask(current);
+			cpumask_and(&tmask, tsk_cpumask(current),
+				&mt_fpu_cpumask);
 			set_cpus_allowed(current, tmask);
 			set_thread_flag(TIF_FPUBOUND);
 		}
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -557,7 +557,7 @@ void __init smp_cpus_done(unsigned int m
 	 * init thread may have been "borrowed" by another CPU in the meantime
 	 * se we pin us down to CPU 0 for a short while
 	 */
-	old_mask = current->cpus_allowed;
+	old_mask = *tsk_cpumask(current);
 	set_cpus_allowed(current, cpumask_of_cpu(boot_cpuid));
 	
 	if (smp_ops && smp_ops->setup_cpu)
diff --git a/arch/powerpc/platforms/cell/spufs/sched.c b/arch/powerpc/platforms/cell/spufs/sched.c
--- a/arch/powerpc/platforms/cell/spufs/sched.c
+++ b/arch/powerpc/platforms/cell/spufs/sched.c
@@ -140,7 +140,7 @@ void __spu_update_sched_info(struct spu_
 	 * runqueue. The context will be rescheduled on the proper node
 	 * if it is timesliced or preempted.
 	 */
-	ctx->cpus_allowed = current->cpus_allowed;
+	cpumask_copy(&ctx->cpus_allowed, tsk_cpumask(current));
 
 	/* Save the current cpu id for spu interrupt routing. */
 	ctx->last_ran = raw_smp_processor_id();
diff --git a/arch/sh/kernel/cpufreq.c b/arch/sh/kernel/cpufreq.c
--- a/arch/sh/kernel/cpufreq.c
+++ b/arch/sh/kernel/cpufreq.c
@@ -47,7 +47,7 @@ static int sh_cpufreq_target(struct cpuf
 	if (!cpu_online(cpu))
 		return -ENODEV;
 
-	cpus_allowed = current->cpus_allowed;
+	cpus_allowed = *tsk_cpumask(current);
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 
 	BUG_ON(smp_processor_id() != cpu);
diff --git a/arch/sparc/kernel/sysfs.c b/arch/sparc/kernel/sysfs.c
--- a/arch/sparc/kernel/sysfs.c
+++ b/arch/sparc/kernel/sysfs.c
@@ -103,7 +103,7 @@ static unsigned long run_on_cpu(unsigned
 			        unsigned long (*func)(unsigned long),
 				unsigned long arg)
 {
-	cpumask_t old_affinity = current->cpus_allowed;
+	cpumask_t old_affinity = *tsk_cpumask(current);
 	unsigned long ret;
 
 	/* should return -EINVAL to userspace */
diff --git a/arch/sparc/kernel/us2e_cpufreq.c b/arch/sparc/kernel/us2e_cpufreq.c
--- a/arch/sparc/kernel/us2e_cpufreq.c
+++ b/arch/sparc/kernel/us2e_cpufreq.c
@@ -237,7 +237,7 @@ static unsigned int us2e_freq_get(unsign
 	if (!cpu_online(cpu))
 		return 0;
 
-	cpus_allowed = current->cpus_allowed;
+	cpus_allowed = *tsk_cpumask(current);
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 
 	clock_tick = sparc64_get_clock_tick(cpu) / 1000;
@@ -258,7 +258,7 @@ static void us2e_set_cpu_divider_index(u
 	if (!cpu_online(cpu))
 		return;
 
-	cpus_allowed = current->cpus_allowed;
+	cpus_allowed = *tsk_cpumask(current);
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 
 	new_freq = clock_tick = sparc64_get_clock_tick(cpu) / 1000;
diff --git a/arch/sparc/kernel/us3_cpufreq.c b/arch/sparc/kernel/us3_cpufreq.c
--- a/arch/sparc/kernel/us3_cpufreq.c
+++ b/arch/sparc/kernel/us3_cpufreq.c
@@ -85,7 +85,7 @@ static unsigned int us3_freq_get(unsigne
 	if (!cpu_online(cpu))
 		return 0;
 
-	cpus_allowed = current->cpus_allowed;
+	cpus_allowed = *tsk_cpumask(current);
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 
 	reg = read_safari_cfg();
@@ -105,7 +105,7 @@ static void us3_set_cpu_divider_index(un
 	if (!cpu_online(cpu))
 		return;
 
-	cpus_allowed = current->cpus_allowed;
+	cpus_allowed = *tsk_cpumask(current);
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 
 	new_freq = sparc64_get_clock_tick(cpu) / 1000;
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -175,7 +175,7 @@ void cmci_rediscover(int dying)
 		return;
 	if (!alloc_cpumask_var(&old, GFP_KERNEL))
 		return;
-	cpumask_copy(old, &current->cpus_allowed);
+	cpumask_copy(old, tsk_cpumask(current));
 
 	for_each_online_cpu(cpu) {
 		if (cpu == dying)
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -871,7 +871,7 @@ static int acpi_processor_get_throttling
 	/*
 	 * Migrate task to the cpu pointed by pr.
 	 */
-	cpumask_copy(saved_mask, &current->cpus_allowed);
+	cpumask_copy(saved_mask, tsk_cpumask(current));
 	/* FIXME: use work_on_cpu() */
 	set_cpus_allowed_ptr(current, cpumask_of(pr->id));
 	ret = pr->throttling.acpi_processor_get_throttling(pr);
@@ -1048,7 +1048,7 @@ int acpi_processor_set_throttling(struct
 		return -ENOMEM;
 	}
 
-	cpumask_copy(saved_mask, &current->cpus_allowed);
+	cpumask_copy(saved_mask, tsk_cpumask(current));
 	t_state.target_state = state;
 	p_throttling = &(pr->throttling);
 	cpumask_and(online_throttling_cpus, cpu_online_mask,
diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -257,7 +257,7 @@ int dcdbas_smi_request(struct smi_cmd *s
 	if (!alloc_cpumask_var(&old_mask, GFP_KERNEL))
 		return -ENOMEM;
 
-	cpumask_copy(old_mask, &current->cpus_allowed);
+	cpumask_copy(old_mask, tsk_cpumask(current));
 	set_cpus_allowed_ptr(current, cpumask_of(0));
 	if (smp_processor_id() != 0) {
 		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -1688,11 +1688,11 @@ static int find_best_unit(struct file *f
 	 * information.  There may be some issues with dual core numbering
 	 * as well.  This needs more work prior to release.
 	 */
-	if (!cpumask_empty(&current->cpus_allowed) &&
-	    !cpumask_full(&current->cpus_allowed)) {
+	if (!cpumask_empty(tsk_cpumask(current)) &&
+	    !cpumask_full(tsk_cpumask(current))) {
 		int ncpus = num_online_cpus(), curcpu = -1, nset = 0;
 		for (i = 0; i < ncpus; i++)
-			if (cpumask_test_cpu(i, &current->cpus_allowed)) {
+			if (cpumask_test_cpu(i, tsk_cpumask(current))) {
 				ipath_cdbg(PROC, "%s[%u] affinity set for "
 					   "cpu %d/%d\n", current->comm,
 					   current->pid, i, ncpus);
diff --git a/kernel/cpu.c b/kernel/cpu.c
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -222,7 +222,7 @@ static int __ref _cpu_down(unsigned int 
 	}
 
 	/* Ensure that we are not runnable on dying cpu */
-	cpumask_copy(old_allowed, &current->cpus_allowed);
+	cpumask_copy(old_allowed, tsk_cpumask(current));
 	set_cpus_allowed_ptr(current,
 			     cpumask_of(cpumask_any_but(cpu_online_mask, cpu)));
 
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -798,7 +798,7 @@ void rebuild_sched_domains(void)
 static int cpuset_test_cpumask(struct task_struct *tsk,
 			       struct cgroup_scanner *scan)
 {
-	return !cpumask_equal(&tsk->cpus_allowed,
+	return !cpumask_equal(tsk_cpumask(tsk),
 			(cgroup_cs(scan->cg))->cpus_allowed);
 }
 
@@ -2540,10 +2540,10 @@ const struct file_operations proc_cpuset
 void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task)
 {
 	seq_printf(m, "Cpus_allowed:\t");
-	seq_cpumask(m, &task->cpus_allowed);
+	seq_cpumask(m, tsk_cpumask(task));
 	seq_printf(m, "\n");
 	seq_printf(m, "Cpus_allowed_list:\t");
-	seq_cpumask_list(m, &task->cpus_allowed);
+	seq_cpumask_list(m, tsk_cpumask(task));
 	seq_printf(m, "\n");
 	seq_printf(m, "Mems_allowed:\t");
 	seq_nodemask(m, &task->mems_allowed);
diff --git a/kernel/fork.c b/kernel/fork.c
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1238,9 +1238,9 @@ static struct task_struct *copy_process(
 	 * to ensure it is on a valid CPU (and if not, just force it back to
 	 * parent's CPU). This avoids alot of nasty races.
 	 */
-	p->cpus_allowed = current->cpus_allowed;
+	cpumask_copy(tsk_cpumask(p), tsk_cpumask(current));
 	p->rt.nr_cpus_allowed = current->rt.nr_cpus_allowed;
-	if (unlikely(!cpu_isset(task_cpu(p), p->cpus_allowed) ||
+	if (unlikely(!cpumask_test_cpu(task_cpu(p), tsk_cpumask(p)) ||
 			!cpu_online(task_cpu(p))))
 		set_task_cpu(p, smp_processor_id());
 
diff --git a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2017,7 +2017,7 @@ void kthread_bind(struct task_struct *p,
 
 	spin_lock_irqsave(&rq->lock, flags);
 	set_task_cpu(p, cpu);
-	p->cpus_allowed = cpumask_of_cpu(cpu);
+	cpumask_copy(tsk_cpumask(p), cpumask_of(cpu));
 	p->rt.nr_cpus_allowed = 1;
 	p->flags |= PF_THREAD_BOUND;
 	spin_unlock_irqrestore(&rq->lock, flags);
@@ -3119,7 +3119,7 @@ static void sched_migrate_task(struct ta
 	struct rq *rq;
 
 	rq = task_rq_lock(p, &flags);
-	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed)
+	if (!cpumask_test_cpu(dest_cpu, tsk_cpumask(p))
 	    || unlikely(!cpu_active(dest_cpu)))
 		goto out;
 
@@ -3185,7 +3185,7 @@ int can_migrate_task(struct task_struct 
 	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
 	 * 3) are cache-hot on their current CPU.
 	 */
-	if (!cpumask_test_cpu(this_cpu, &p->cpus_allowed)) {
+	if (!cpumask_test_cpu(this_cpu, tsk_cpumask(p))) {
 		schedstat_inc(p, se.nr_failed_migrations_affine);
 		return 0;
 	}
@@ -4204,7 +4204,7 @@ redo:
 			 * task on busiest cpu can't be moved to this_cpu
 			 */
 			if (!cpumask_test_cpu(this_cpu,
-					      &busiest->curr->cpus_allowed)) {
+					      tsk_cpumask(busiest->curr))) {
 				spin_unlock_irqrestore(&busiest->lock, flags);
 				all_pinned = 1;
 				goto out_one_pinned;
@@ -4381,7 +4381,7 @@ redo:
 		 * don't kick the migration_thread, if the curr
 		 * task on busiest cpu can't be moved to this_cpu
 		 */
-		if (!cpumask_test_cpu(this_cpu, &busiest->curr->cpus_allowed)) {
+		if (!cpumask_test_cpu(this_cpu, tsk_cpumask(busiest->curr))) {
 			double_unlock_balance(this_rq, busiest);
 			all_pinned = 1;
 			return ld_moved;
@@ -6606,7 +6606,7 @@ long sched_getaffinity(pid_t pid, struct
 	if (retval)
 		goto out_unlock;
 
-	cpumask_and(mask, &p->cpus_allowed, cpu_online_mask);
+	cpumask_and(mask, tsk_cpumask(p), cpu_online_mask);
 
 out_unlock:
 	read_unlock(&tasklist_lock);
@@ -6962,7 +6962,7 @@ void __cpuinit init_idle(struct task_str
 	idle->se.exec_start = sched_clock();
 
 	idle->prio = idle->normal_prio = MAX_PRIO;
-	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
+	cpumask_copy(tsk_cpumask(idle), cpumask_of(cpu));
 	__set_task_cpu(idle, cpu);
 
 	rq->curr = rq->idle = idle;
@@ -7060,7 +7060,7 @@ int set_cpus_allowed_ptr(struct task_str
 	}
 
 	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
-		     !cpumask_equal(&p->cpus_allowed, new_mask))) {
+		     !cpumask_equal(tsk_cpumask(p), new_mask))) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -7068,7 +7068,7 @@ int set_cpus_allowed_ptr(struct task_str
 	if (p->sched_class->set_cpus_allowed)
 		p->sched_class->set_cpus_allowed(p, new_mask);
 	else {
-		cpumask_copy(&p->cpus_allowed, new_mask);
+		cpumask_copy(tsk_cpumask(p), new_mask);
 		p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
 	}
 
@@ -7122,7 +7122,7 @@ static int __migrate_task(struct task_st
 	if (task_cpu(p) != src_cpu)
 		goto done;
 	/* Affinity changed (again). */
-	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
+	if (!cpumask_test_cpu(dest_cpu, tsk_cpumask(p)))
 		goto fail;
 
 	on_rq = p->se.on_rq;
@@ -7231,18 +7231,18 @@ static void move_task_off_dead_cpu(int d
 again:
 	/* Look for allowed, online CPU in same node. */
 	for_each_cpu_and(dest_cpu, nodemask, cpu_online_mask)
-		if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
+		if (cpumask_test_cpu(dest_cpu, tsk_cpumask(p)))
 			goto move;
 
 	/* Any allowed, online CPU? */
-	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_online_mask);
+	dest_cpu = cpumask_any_and(tsk_cpumask(p), cpu_online_mask);
 	if (dest_cpu < nr_cpu_ids)
 		goto move;
 
 	/* No more Mr. Nice Guy. */
 	if (dest_cpu >= nr_cpu_ids) {
-		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
-		dest_cpu = cpumask_any_and(cpu_online_mask, &p->cpus_allowed);
+		cpuset_cpus_allowed_locked(p, tsk_cpumask(p));
+		dest_cpu = cpumask_any_and(cpu_online_mask, tsk_cpumask(p));
 
 		/*
 		 * Don't tell them about moving exiting tasks or
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -78,11 +78,11 @@ int cpupri_find(struct cpupri *cp, struc
 		if (idx >= task_pri)
 			break;
 
-		if (cpumask_any_and(&p->cpus_allowed, vec->mask) >= nr_cpu_ids)
+		if (cpumask_any_and(tsk_cpumask(p), vec->mask) >= nr_cpu_ids)
 			continue;
 
 		if (lowest_mask) {
-			cpumask_and(lowest_mask, &p->cpus_allowed, vec->mask);
+			cpumask_and(lowest_mask, tsk_cpumask(p), vec->mask);
 
 			/*
 			 * We have to ensure that we have at least one bit
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1285,7 +1285,7 @@ find_idlest_group(struct sched_domain *s
 
 		/* Skip over this group if it has no CPUs allowed */
 		if (!cpumask_intersects(sched_group_cpus(group),
-					&p->cpus_allowed))
+					tsk_cpumask(p)))
 			continue;
 
 		local_group = cpumask_test_cpu(this_cpu,
@@ -1332,7 +1332,7 @@ find_idlest_cpu(struct sched_group *grou
 	int i;
 
 	/* Traverse only the allowed CPUs */
-	for_each_cpu_and(i, sched_group_cpus(group), &p->cpus_allowed) {
+	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpumask(p)) {
 		load = weighted_cpuload(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
@@ -1367,7 +1367,7 @@ static int select_task_rq_fair(struct ta
 
 	if (sd_flag & SD_BALANCE_WAKE) {
 		if (sched_feat(AFFINE_WAKEUPS) &&
-		    cpumask_test_cpu(cpu, &p->cpus_allowed))
+		    cpumask_test_cpu(cpu, tsk_cpumask(p)))
 			want_affine = 1;
 		new_cpu = prev_cpu;
 	}
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1112,7 +1112,7 @@ static void deactivate_task(struct rq *r
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpumask_test_cpu(cpu, &p->cpus_allowed)) &&
+	    (cpu < 0 || cpumask_test_cpu(cpu, tsk_cpumask(p))) &&
 	    (p->rt.nr_cpus_allowed > 1))
 		return 1;
 	return 0;
@@ -1242,7 +1242,7 @@ static struct rq *find_lock_lowest_rq(st
 			 */
 			if (unlikely(task_rq(task) != rq ||
 				     !cpumask_test_cpu(lowest_rq->cpu,
-						       &task->cpus_allowed) ||
+						       tsk_cpumask(task)) ||
 				     task_running(rq, task) ||
 				     !task->se.on_rq)) {
 
@@ -1541,7 +1541,7 @@ static void set_cpus_allowed_rt(struct t
 		update_rt_migration(&rq->rt);
 	}
 
-	cpumask_copy(&p->cpus_allowed, new_mask);
+	cpumask_copy(tsk_cpumask(p), new_mask);
 	p->rt.nr_cpus_allowed = weight;
 }
 
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -51,7 +51,7 @@ static void
 probe_workqueue_insertion(struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
-	int cpu = cpumask_first(&wq_thread->cpus_allowed);
+	int cpu = cpumask_first(tsk_cpumask(wq_thread));
 	struct cpu_workqueue_stats *node;
 	unsigned long flags;
 
@@ -72,7 +72,7 @@ static void
 probe_workqueue_execution(struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
-	int cpu = cpumask_first(&wq_thread->cpus_allowed);
+	int cpu = cpumask_first(tsk_cpumask(wq_thread));
 	struct cpu_workqueue_stats *node;
 	unsigned long flags;
 
@@ -116,7 +116,7 @@ static void probe_workqueue_creation(str
 static void probe_workqueue_destruction(struct task_struct *wq_thread)
 {
 	/* Workqueue only execute on one cpu */
-	int cpu = cpumask_first(&wq_thread->cpus_allowed);
+	int cpu = cpumask_first(tsk_cpumask(wq_thread));
 	struct cpu_workqueue_stats *node, *next;
 	unsigned long flags;
 
diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -22,7 +22,7 @@ notrace unsigned int debug_smp_processor
 	 * Kernel threads bound to a single CPU can safely use
 	 * smp_processor_id():
 	 */
-	if (cpumask_equal(&current->cpus_allowed, cpumask_of(this_cpu)))
+	if (cpumask_equal(tsk_cpumask(current), cpumask_of(this_cpu)))
 		goto out;
 
 	/*

