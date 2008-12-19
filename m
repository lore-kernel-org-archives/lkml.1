Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbYLSQE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbYLSQE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYLSQBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:01:55 -0500
Received: from relay2.sgi.com ([192.48.179.30]:35430 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751715AbYLSQBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:01:51 -0500
Message-Id: <20081219160145.404769000@polaris-admin.engr.sgi.com>
References: <20081219160144.697518000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 08:01:49 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Richard Henderson <rth@twiddle.net>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 5/8] cpumask: convert rest of files in kernel/
Content-Disposition: inline; filename=cpumask:convert-kernel.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Reduce stack usage, use new cpumask API.  ALPHA mod!

A couple of uses of cpumask_any_but() here to avoid temporary cpumasks
and carry the "const" modifier through the seq_cpumask() function all the
way to bitmap_scnprintf().

Note that prof_cpu_mask will be difficult to convert to a cpumask_var_t
since it needs to be ready from the first scheduler tick.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 arch/alpha/kernel/irq.c      |    3 ++-
 fs/seq_file.c                |    3 ++-
 include/linux/interrupt.h    |    2 +-
 include/linux/rcuclassic.h   |    4 ++--
 include/linux/seq_file.h     |    5 +++--
 include/linux/stop_machine.h |    6 +++---
 kernel/cpu.c                 |   40 +++++++++++++++++++++-------------------
 kernel/irq/manage.c          |   11 +++++++++--
 kernel/irq/proc.c            |   32 +++++++++++++++++++++-----------
 kernel/power/poweroff.c      |    2 +-
 kernel/profile.c             |   31 ++++++++++++++++++-------------
 kernel/rcuclassic.c          |   32 +++++++++++++++++---------------
 kernel/rcupreempt.c          |   19 ++++++++++---------
 kernel/rcutorture.c          |   27 +++++++++++++++------------
 kernel/softlockup.c          |    6 ++----
 kernel/stop_machine.c        |    8 ++++----
 kernel/taskstats.c           |   39 ++++++++++++++++++++++++---------------
 17 files changed, 155 insertions(+), 115 deletions(-)

--- linux-2.6-for-ingo.orig/arch/alpha/kernel/irq.c
+++ linux-2.6-for-ingo/arch/alpha/kernel/irq.c
@@ -50,7 +50,8 @@ int irq_select_affinity(unsigned int irq
 	if (!irq_desc[irq].chip->set_affinity || irq_user_affinity[irq])
 		return 1;
 
-	while (!cpu_possible(cpu) || !cpu_isset(cpu, irq_default_affinity))
+	while (!cpu_possible(cpu) ||
+	       !cpumask_test_cpu(cpu, irq_default_affinity))
 		cpu = (cpu < (NR_CPUS-1) ? cpu + 1 : 0);
 	last_cpu = cpu;
 
--- linux-2.6-for-ingo.orig/fs/seq_file.c
+++ linux-2.6-for-ingo/fs/seq_file.c
@@ -462,7 +462,8 @@ int seq_dentry(struct seq_file *m, struc
 	return -1;
 }
 
-int seq_bitmap(struct seq_file *m, unsigned long *bits, unsigned int nr_bits)
+int seq_bitmap(struct seq_file *m, const unsigned long *bits,
+				   unsigned int nr_bits)
 {
 	if (m->count < m->size) {
 		int len = bitmap_scnprintf(m->buf + m->count,
--- linux-2.6-for-ingo.orig/include/linux/interrupt.h
+++ linux-2.6-for-ingo/include/linux/interrupt.h
@@ -109,7 +109,7 @@ extern void enable_irq(unsigned int irq)
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
 
-extern cpumask_t irq_default_affinity;
+extern cpumask_var_t irq_default_affinity;
 
 extern int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask);
 extern int irq_can_set_affinity(unsigned int irq);
--- linux-2.6-for-ingo.orig/include/linux/rcuclassic.h
+++ linux-2.6-for-ingo/include/linux/rcuclassic.h
@@ -59,8 +59,8 @@ struct rcu_ctrlblk {
 	int	signaled;
 
 	spinlock_t	lock	____cacheline_internodealigned_in_smp;
-	cpumask_t	cpumask; /* CPUs that need to switch in order    */
-				 /* for current batch to proceed.        */
+	DECLARE_BITMAP(cpumask, NR_CPUS); /* CPUs that need to switch for */
+					  /* current batch to proceed.     */
 } ____cacheline_internodealigned_in_smp;
 
 /* Is batch a before batch b ? */
--- linux-2.6-for-ingo.orig/include/linux/seq_file.h
+++ linux-2.6-for-ingo/include/linux/seq_file.h
@@ -50,8 +50,9 @@ int seq_path(struct seq_file *, struct p
 int seq_dentry(struct seq_file *, struct dentry *, char *);
 int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
 		  char *esc);
-int seq_bitmap(struct seq_file *m, unsigned long *bits, unsigned int nr_bits);
-static inline int seq_cpumask(struct seq_file *m, cpumask_t *mask)
+int seq_bitmap(struct seq_file *m, const unsigned long *bits,
+				   unsigned int nr_bits);
+static inline int seq_cpumask(struct seq_file *m, const struct cpumask *mask)
 {
 	return seq_bitmap(m, mask->bits, NR_CPUS);
 }
--- linux-2.6-for-ingo.orig/include/linux/stop_machine.h
+++ linux-2.6-for-ingo/include/linux/stop_machine.h
@@ -23,7 +23,7 @@
  *
  * This can be thought of as a very heavy write lock, equivalent to
  * grabbing every spinlock in the kernel. */
-int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus);
+int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
 
 /**
  * __stop_machine: freeze the machine on all CPUs and run this function
@@ -34,11 +34,11 @@ int stop_machine(int (*fn)(void *), void
  * Description: This is a special version of the above, which assumes cpus
  * won't come or go while it's being called.  Used by hotplug cpu.
  */
-int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus);
+int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
 #else
 
 static inline int stop_machine(int (*fn)(void *), void *data,
-			       const cpumask_t *cpus)
+			       const struct cpumask *cpus)
 {
 	int ret;
 	local_irq_disable();
--- linux-2.6-for-ingo.orig/kernel/cpu.c
+++ linux-2.6-for-ingo/kernel/cpu.c
@@ -218,7 +218,7 @@ static int __ref take_cpu_down(void *_pa
 static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err, nr_calls = 0;
-	cpumask_t old_allowed, tmp;
+	cpumask_var_t old_allowed;
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct take_cpu_down_param tcd_param = {
@@ -232,6 +232,9 @@ static int __ref _cpu_down(unsigned int 
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
+	if (!alloc_cpumask_var(&old_allowed, GFP_KERNEL))
+		return -ENOMEM;
+
 	cpu_hotplug_begin();
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
@@ -246,13 +249,11 @@ static int __ref _cpu_down(unsigned int 
 	}
 
 	/* Ensure that we are not runnable on dying cpu */
-	old_allowed = current->cpus_allowed;
-	cpus_setall(tmp);
-	cpu_clear(cpu, tmp);
-	set_cpus_allowed_ptr(current, &tmp);
-	tmp = cpumask_of_cpu(cpu);
+	cpumask_copy(old_allowed, &current->cpus_allowed);
+	set_cpus_allowed_ptr(current,
+			     cpumask_of(cpumask_any_but(cpu_online_mask, cpu)));
 
-	err = __stop_machine(take_cpu_down, &tcd_param, &tmp);
+	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
@@ -278,7 +279,7 @@ static int __ref _cpu_down(unsigned int 
 	check_for_tasks(cpu);
 
 out_allowed:
-	set_cpus_allowed_ptr(current, &old_allowed);
+	set_cpus_allowed_ptr(current, old_allowed);
 out_release:
 	cpu_hotplug_done();
 	if (!err) {
@@ -286,6 +287,7 @@ out_release:
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 	}
+	free_cpumask_var(old_allowed);
 	return err;
 }
 
@@ -304,7 +306,7 @@ int __ref cpu_down(unsigned int cpu)
 
 	/*
 	 * Make sure the all cpus did the reschedule and are not
-	 * using stale version of the cpu_active_map.
+	 * using stale version of the cpu_active_mask.
 	 * This is not strictly necessary becuase stop_machine()
 	 * that we run down the line already provides the required
 	 * synchronization. But it's really a side effect and we do not
@@ -368,7 +370,7 @@ out_notify:
 int __cpuinit cpu_up(unsigned int cpu)
 {
 	int err = 0;
-	if (!cpu_isset(cpu, cpu_possible_map)) {
+	if (!cpu_possible(cpu)) {
 		printk(KERN_ERR "can't online cpu %d because it is not "
 			"configured as may-hotadd at boot time\n", cpu);
 #if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
@@ -393,25 +395,25 @@ out:
 }
 
 #ifdef CONFIG_PM_SLEEP_SMP
-static cpumask_t frozen_cpus;
+static DECLARE_BITMAP(frozen_cpus, CONFIG_NR_CPUS);
 
 int disable_nonboot_cpus(void)
 {
 	int cpu, first_cpu, error = 0;
 
 	cpu_maps_update_begin();
-	first_cpu = first_cpu(cpu_online_map);
+	first_cpu = cpumask_first(cpu_online_mask);
 	/* We take down all of the non-boot CPUs in one shot to avoid races
 	 * with the userspace trying to use the CPU hotplug at the same time
 	 */
-	cpus_clear(frozen_cpus);
+	cpumask_clear(to_cpumask(frozen_cpus));
 	printk("Disabling non-boot CPUs ...\n");
 	for_each_online_cpu(cpu) {
 		if (cpu == first_cpu)
 			continue;
 		error = _cpu_down(cpu, 1);
 		if (!error) {
-			cpu_set(cpu, frozen_cpus);
+			cpumask_set_cpu(cpu, to_cpumask(frozen_cpus));
 			printk("CPU%d is down\n", cpu);
 		} else {
 			printk(KERN_ERR "Error taking CPU%d down: %d\n",
@@ -437,11 +439,11 @@ void __ref enable_nonboot_cpus(void)
 	/* Allow everyone to use the CPU hotplug again */
 	cpu_maps_update_begin();
 	cpu_hotplug_disabled = 0;
-	if (cpus_empty(frozen_cpus))
+	if (cpumask_empty(to_cpumask(frozen_cpus)))
 		goto out;
 
 	printk("Enabling non-boot CPUs ...\n");
-	for_each_cpu_mask_nr(cpu, frozen_cpus) {
+	for_each_cpu(cpu, to_cpumask(frozen_cpus)) {
 		error = _cpu_up(cpu, 1);
 		if (!error) {
 			printk("CPU%d is up\n", cpu);
@@ -449,7 +451,7 @@ void __ref enable_nonboot_cpus(void)
 		}
 		printk(KERN_WARNING "Error taking CPU%d up: %d\n", cpu, error);
 	}
-	cpus_clear(frozen_cpus);
+	cpumask_clear(to_cpumask(frozen_cpus));
 out:
 	cpu_maps_update_done();
 }
@@ -468,7 +470,7 @@ void __cpuinit notify_cpu_starting(unsig
 	unsigned long val = CPU_STARTING;
 
 #ifdef CONFIG_PM_SLEEP_SMP
-	if (cpu_isset(cpu, frozen_cpus))
+	if (cpumask_test_cpu(cpu, to_cpumask(frozen_cpus)))
 		val = CPU_STARTING_FROZEN;
 #endif /* CONFIG_PM_SLEEP_SMP */
 	raw_notifier_call_chain(&cpu_chain, val, (void *)(long)cpu);
@@ -480,7 +482,7 @@ void __cpuinit notify_cpu_starting(unsig
  * cpu_bit_bitmap[] is a special, "compressed" data structure that
  * represents all NR_CPUS bits binary values of 1<<nr.
  *
- * It is used by cpumask_of_cpu() to get a constant address to a CPU
+ * It is used by cpumask_of() to get a constant address to a CPU
  * mask value that has a single bit set only.
  */
 
--- linux-2.6-for-ingo.orig/kernel/irq/manage.c
+++ linux-2.6-for-ingo/kernel/irq/manage.c
@@ -16,8 +16,15 @@
 #include "internals.h"
 
 #ifdef CONFIG_SMP
+cpumask_var_t irq_default_affinity;
 
-cpumask_t irq_default_affinity = CPU_MASK_ALL;
+static int init_irq_default_affinity(void)
+{
+	alloc_cpumask_var(&irq_default_affinity, GFP_KERNEL);
+	cpumask_setall(irq_default_affinity);
+	return 0;
+}
+core_initcall(init_irq_default_affinity);
 
 /**
  *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
@@ -127,7 +134,7 @@ int do_irq_select_affinity(unsigned int 
 			desc->status &= ~IRQ_AFFINITY_SET;
 	}
 
-	cpumask_and(&desc->affinity, cpu_online_mask, &irq_default_affinity);
+	cpumask_and(&desc->affinity, cpu_online_mask, irq_default_affinity);
 set_affinity:
 	desc->chip->set_affinity(irq, &desc->affinity);
 
--- linux-2.6-for-ingo.orig/kernel/irq/proc.c
+++ linux-2.6-for-ingo/kernel/irq/proc.c
@@ -20,7 +20,7 @@ static struct proc_dir_entry *root_irq_d
 static int irq_affinity_proc_show(struct seq_file *m, void *v)
 {
 	struct irq_desc *desc = irq_to_desc((long)m->private);
-	cpumask_t *mask = &desc->affinity;
+	const struct cpumask *mask = &desc->affinity;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PENDING)
@@ -93,7 +93,7 @@ static const struct file_operations irq_
 
 static int default_affinity_show(struct seq_file *m, void *v)
 {
-	seq_cpumask(m, &irq_default_affinity);
+	seq_cpumask(m, irq_default_affinity);
 	seq_putc(m, '\n');
 	return 0;
 }
@@ -101,27 +101,37 @@ static int default_affinity_show(struct 
 static ssize_t default_affinity_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *ppos)
 {
-	cpumask_t new_value;
+	cpumask_var_t new_value;
 	int err;
 
-	err = cpumask_parse_user(buffer, count, &new_value);
+	if (!alloc_cpumask_var(&new_value, GFP_KERNEL))
+		return -ENOMEM;
+
+	err = cpumask_parse_user(buffer, count, new_value);
 	if (err)
-		return err;
+		goto out;
 
-	if (!is_affinity_mask_valid(new_value))
-		return -EINVAL;
+	if (!is_affinity_mask_valid(new_value)) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	/*
 	 * Do not allow disabling IRQs completely - it's a too easy
 	 * way to make the system unusable accidentally :-) At least
 	 * one online CPU still has to be targeted.
 	 */
-	if (!cpus_intersects(new_value, cpu_online_map))
-		return -EINVAL;
+	if (!cpumask_intersects(new_value, cpu_online_mask)) {
+		err = -EINVAL;
+		goto out;
+	}
 
-	irq_default_affinity = new_value;
+	cpumask_copy(irq_default_affinity, new_value);
+	err = count;
 
-	return count;
+out:
+	free_cpumask_var(new_value);
+	return err;
 }
 
 static int default_affinity_open(struct inode *inode, struct file *file)
--- linux-2.6-for-ingo.orig/kernel/power/poweroff.c
+++ linux-2.6-for-ingo/kernel/power/poweroff.c
@@ -27,7 +27,7 @@ static DECLARE_WORK(poweroff_work, do_po
 static void handle_poweroff(int key, struct tty_struct *tty)
 {
 	/* run sysrq poweroff on boot cpu */
-	schedule_work_on(first_cpu(cpu_online_map), &poweroff_work);
+	schedule_work_on(cpumask_first(cpu_online_mask), &poweroff_work);
 }
 
 static struct sysrq_key_op	sysrq_poweroff_op = {
--- linux-2.6-for-ingo.orig/kernel/profile.c
+++ linux-2.6-for-ingo/kernel/profile.c
@@ -45,7 +45,7 @@ static unsigned long prof_len, prof_shif
 int prof_on __read_mostly;
 EXPORT_SYMBOL_GPL(prof_on);
 
-static cpumask_t prof_cpu_mask = CPU_MASK_ALL;
+static DECLARE_BITMAP(prof_cpu_mask, CONFIG_NR_CPUS) = CPU_BITS_ALL;
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct profile_hit *[2], cpu_profile_hits);
 static DEFINE_PER_CPU(int, cpu_profile_flip);
@@ -386,13 +386,13 @@ out_free:
 		return NOTIFY_BAD;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		cpu_set(cpu, prof_cpu_mask);
+		cpumask_set_cpu(cpu, to_cpumask(prof_cpu_mask));
 		break;
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		cpu_clear(cpu, prof_cpu_mask);
+		cpumask_clear_cpu(cpu, to_cpumask(prof_cpu_mask));
 		if (per_cpu(cpu_profile_hits, cpu)[0]) {
 			page = virt_to_page(per_cpu(cpu_profile_hits, cpu)[0]);
 			per_cpu(cpu_profile_hits, cpu)[0] = NULL;
@@ -430,7 +430,8 @@ void profile_tick(int type)
 
 	if (type == CPU_PROFILING && timer_hook)
 		timer_hook(regs);
-	if (!user_mode(regs) && cpu_isset(smp_processor_id(), prof_cpu_mask))
+	if (!user_mode(regs) &&
+	    cpumask_test_cpu(smp_processor_id(), to_cpumask(prof_cpu_mask)))
 		profile_hit(type, (void *)profile_pc(regs));
 }
 
@@ -442,7 +443,7 @@ void profile_tick(int type)
 static int prof_cpu_mask_read_proc(char *page, char **start, off_t off,
 			int count, int *eof, void *data)
 {
-	int len = cpumask_scnprintf(page, count, (cpumask_t *)data);
+	int len = cpumask_scnprintf(page, count, data);
 	if (count - len < 2)
 		return -EINVAL;
 	len += sprintf(page + len, "\n");
@@ -452,16 +453,20 @@ static int prof_cpu_mask_read_proc(char 
 static int prof_cpu_mask_write_proc(struct file *file,
 	const char __user *buffer,  unsigned long count, void *data)
 {
-	cpumask_t *mask = (cpumask_t *)data;
+	struct cpumask *mask = data;
 	unsigned long full_count = count, err;
-	cpumask_t new_value;
+	cpumask_var_t new_value;
 
-	err = cpumask_parse_user(buffer, count, &new_value);
-	if (err)
-		return err;
+	if (!alloc_cpumask_var(&new_value, GFP_KERNEL))
+		return -ENOMEM;
 
-	*mask = new_value;
-	return full_count;
+	err = cpumask_parse_user(buffer, count, new_value);
+	if (!err) {
+		cpumask_copy(mask, new_value);
+		err = full_count;
+	}
+	free_cpumask_var(new_value);
+	return err;
 }
 
 void create_prof_cpu_mask(struct proc_dir_entry *root_irq_dir)
@@ -472,7 +477,7 @@ void create_prof_cpu_mask(struct proc_di
 	entry = create_proc_entry("prof_cpu_mask", 0600, root_irq_dir);
 	if (!entry)
 		return;
-	entry->data = (void *)&prof_cpu_mask;
+	entry->data = prof_cpu_mask;
 	entry->read_proc = prof_cpu_mask_read_proc;
 	entry->write_proc = prof_cpu_mask_write_proc;
 }
--- linux-2.6-for-ingo.orig/kernel/rcuclassic.c
+++ linux-2.6-for-ingo/kernel/rcuclassic.c
@@ -63,14 +63,14 @@ static struct rcu_ctrlblk rcu_ctrlblk = 
 	.completed = -300,
 	.pending = -300,
 	.lock = __SPIN_LOCK_UNLOCKED(&rcu_ctrlblk.lock),
-	.cpumask = CPU_MASK_NONE,
+	.cpumask = CPU_BITS_NONE,
 };
 static struct rcu_ctrlblk rcu_bh_ctrlblk = {
 	.cur = -300,
 	.completed = -300,
 	.pending = -300,
 	.lock = __SPIN_LOCK_UNLOCKED(&rcu_bh_ctrlblk.lock),
-	.cpumask = CPU_MASK_NONE,
+	.cpumask = CPU_BITS_NONE,
 };
 
 DEFINE_PER_CPU(struct rcu_data, rcu_data) = { 0L };
@@ -85,7 +85,6 @@ static void force_quiescent_state(struct
 			struct rcu_ctrlblk *rcp)
 {
 	int cpu;
-	cpumask_t cpumask;
 	unsigned long flags;
 
 	set_need_resched();
@@ -96,10 +95,10 @@ static void force_quiescent_state(struct
 		 * Don't send IPI to itself. With irqs disabled,
 		 * rdp->cpu is the current cpu.
 		 *
-		 * cpu_online_map is updated by the _cpu_down()
+		 * cpu_online_mask is updated by the _cpu_down()
 		 * using __stop_machine(). Since we're in irqs disabled
 		 * section, __stop_machine() is not exectuting, hence
-		 * the cpu_online_map is stable.
+		 * the cpu_online_mask is stable.
 		 *
 		 * However,  a cpu might have been offlined _just_ before
 		 * we disabled irqs while entering here.
@@ -107,13 +106,14 @@ static void force_quiescent_state(struct
 		 * notification, leading to the offlined cpu's bit
 		 * being set in the rcp->cpumask.
 		 *
-		 * Hence cpumask = (rcp->cpumask & cpu_online_map) to prevent
+		 * Hence cpumask = (rcp->cpumask & cpu_online_mask) to prevent
 		 * sending smp_reschedule() to an offlined CPU.
 		 */
-		cpus_and(cpumask, rcp->cpumask, cpu_online_map);
-		cpu_clear(rdp->cpu, cpumask);
-		for_each_cpu_mask_nr(cpu, cpumask)
-			smp_send_reschedule(cpu);
+		for_each_cpu_and(cpu,
+				  to_cpumask(rcp->cpumask), cpu_online_mask) {
+			if (cpu != rdp->cpu)
+				smp_send_reschedule(cpu);
+		}
 	}
 	spin_unlock_irqrestore(&rcp->lock, flags);
 }
@@ -193,7 +193,7 @@ static void print_other_cpu_stall(struct
 
 	printk(KERN_ERR "INFO: RCU detected CPU stalls:");
 	for_each_possible_cpu(cpu) {
-		if (cpu_isset(cpu, rcp->cpumask))
+		if (cpumask_test_cpu(cpu, to_cpumask(rcp->cpumask)))
 			printk(" %d", cpu);
 	}
 	printk(" (detected by %d, t=%ld jiffies)\n",
@@ -221,7 +221,8 @@ static void check_cpu_stall(struct rcu_c
 	long delta;
 
 	delta = jiffies - rcp->jiffies_stall;
-	if (cpu_isset(smp_processor_id(), rcp->cpumask) && delta >= 0) {
+	if (cpumask_test_cpu(smp_processor_id(), to_cpumask(rcp->cpumask)) &&
+		delta >= 0) {
 
 		/* We haven't checked in, so go dump stack. */
 		print_cpu_stall(rcp);
@@ -393,7 +394,8 @@ static void rcu_start_batch(struct rcu_c
 		 * unnecessarily.
 		 */
 		smp_mb();
-		cpumask_andnot(&rcp->cpumask, cpu_online_mask, nohz_cpu_mask);
+		cpumask_andnot(to_cpumask(rcp->cpumask),
+			       cpu_online_mask, nohz_cpu_mask);
 
 		rcp->signaled = 0;
 	}
@@ -406,8 +408,8 @@ static void rcu_start_batch(struct rcu_c
  */
 static void cpu_quiet(int cpu, struct rcu_ctrlblk *rcp)
 {
-	cpu_clear(cpu, rcp->cpumask);
-	if (cpus_empty(rcp->cpumask)) {
+	cpumask_clear_cpu(cpu, to_cpumask(rcp->cpumask));
+	if (cpumask_empty(to_cpumask(rcp->cpumask))) {
 		/* batch completed ! */
 		rcp->completed = rcp->cur;
 		rcu_start_batch(rcp);
--- linux-2.6-for-ingo.orig/kernel/rcupreempt.c
+++ linux-2.6-for-ingo/kernel/rcupreempt.c
@@ -164,7 +164,8 @@ static char *rcu_try_flip_state_names[] 
 	{ "idle", "waitack", "waitzero", "waitmb" };
 #endif /* #ifdef CONFIG_RCU_TRACE */
 
-static cpumask_t rcu_cpu_online_map __read_mostly = CPU_MASK_NONE;
+static DECLARE_BITMAP(rcu_cpu_online_map, CONFIG_NR_CPUS) __read_mostly
+	= CPU_BITS_NONE;
 
 /*
  * Enum and per-CPU flag to determine when each CPU has seen
@@ -748,7 +749,7 @@ rcu_try_flip_idle(void)
 
 	/* Now ask each CPU for acknowledgement of the flip. */
 
-	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map) {
+	for_each_cpu(cpu, to_cpumask(rcu_cpu_online_map)) {
 		per_cpu(rcu_flip_flag, cpu) = rcu_flipped;
 		dyntick_save_progress_counter(cpu);
 	}
@@ -766,7 +767,7 @@ rcu_try_flip_waitack(void)
 	int cpu;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_a1);
-	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
+	for_each_cpu(cpu, to_cpumask(rcu_cpu_online_map))
 		if (rcu_try_flip_waitack_needed(cpu) &&
 		    per_cpu(rcu_flip_flag, cpu) != rcu_flip_seen) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_ae1);
@@ -798,7 +799,7 @@ rcu_try_flip_waitzero(void)
 	/* Check to see if the sum of the "last" counters is zero. */
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_z1);
-	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
+	for_each_cpu(cpu, to_cpumask(rcu_cpu_online_map))
 		sum += RCU_DATA_CPU(cpu)->rcu_flipctr[lastidx];
 	if (sum != 0) {
 		RCU_TRACE_ME(rcupreempt_trace_try_flip_ze1);
@@ -813,7 +814,7 @@ rcu_try_flip_waitzero(void)
 	smp_mb();  /*  ^^^^^^^^^^^^ */
 
 	/* Call for a memory barrier from each CPU. */
-	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map) {
+	for_each_cpu(cpu, to_cpumask(rcu_cpu_online_map)) {
 		per_cpu(rcu_mb_flag, cpu) = rcu_mb_needed;
 		dyntick_save_progress_counter(cpu);
 	}
@@ -833,7 +834,7 @@ rcu_try_flip_waitmb(void)
 	int cpu;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_m1);
-	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
+	for_each_cpu(cpu, to_cpumask(rcu_cpu_online_map))
 		if (rcu_try_flip_waitmb_needed(cpu) &&
 		    per_cpu(rcu_mb_flag, cpu) != rcu_mb_done) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_me1);
@@ -1022,7 +1023,7 @@ void rcu_offline_cpu(int cpu)
 	RCU_DATA_CPU(cpu)->rcu_flipctr[0] = 0;
 	RCU_DATA_CPU(cpu)->rcu_flipctr[1] = 0;
 
-	cpu_clear(cpu, rcu_cpu_online_map);
+	cpumask_clear_cpu(cpu, to_cpumask(rcu_cpu_online_map));
 
 	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
 
@@ -1062,7 +1063,7 @@ void __cpuinit rcu_online_cpu(int cpu)
 	struct rcu_data *rdp;
 
 	spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
-	cpu_set(cpu, rcu_cpu_online_map);
+	cpumask_set_cpu(cpu, to_cpumask(rcu_cpu_online_map));
 	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
 
 	/*
@@ -1420,7 +1421,7 @@ void __init __rcu_init(void)
 	 * We don't need protection against CPU-Hotplug here
 	 * since
 	 * a) If a CPU comes online while we are iterating over the
-	 *    cpu_online_map below, we would only end up making a
+	 *    cpu_online_mask below, we would only end up making a
 	 *    duplicate call to rcu_online_cpu() which sets the corresponding
 	 *    CPU's mask in the rcu_cpu_online_map.
 	 *
--- linux-2.6-for-ingo.orig/kernel/rcutorture.c
+++ linux-2.6-for-ingo/kernel/rcutorture.c
@@ -843,49 +843,52 @@ static int rcu_idle_cpu;	/* Force all to
  */
 static void rcu_torture_shuffle_tasks(void)
 {
-	cpumask_t tmp_mask;
+	cpumask_var_t tmp_mask;
 	int i;
 
-	cpus_setall(tmp_mask);
+	if (!alloc_cpumask_var(&tmp_mask, GFP_KERNEL))
+		BUG();
+
+	cpumask_setall(tmp_mask);
 	get_online_cpus();
 
 	/* No point in shuffling if there is only one online CPU (ex: UP) */
-	if (num_online_cpus() == 1) {
-		put_online_cpus();
-		return;
-	}
+	if (num_online_cpus() == 1)
+		goto out;
 
 	if (rcu_idle_cpu != -1)
-		cpu_clear(rcu_idle_cpu, tmp_mask);
+		cpumask_clear_cpu(rcu_idle_cpu, tmp_mask);
 
-	set_cpus_allowed_ptr(current, &tmp_mask);
+	set_cpus_allowed_ptr(current, tmp_mask);
 
 	if (reader_tasks) {
 		for (i = 0; i < nrealreaders; i++)
 			if (reader_tasks[i])
 				set_cpus_allowed_ptr(reader_tasks[i],
-						     &tmp_mask);
+						     tmp_mask);
 	}
 
 	if (fakewriter_tasks) {
 		for (i = 0; i < nfakewriters; i++)
 			if (fakewriter_tasks[i])
 				set_cpus_allowed_ptr(fakewriter_tasks[i],
-						     &tmp_mask);
+						     tmp_mask);
 	}
 
 	if (writer_task)
-		set_cpus_allowed_ptr(writer_task, &tmp_mask);
+		set_cpus_allowed_ptr(writer_task, tmp_mask);
 
 	if (stats_task)
-		set_cpus_allowed_ptr(stats_task, &tmp_mask);
+		set_cpus_allowed_ptr(stats_task, tmp_mask);
 
 	if (rcu_idle_cpu == -1)
 		rcu_idle_cpu = num_online_cpus() - 1;
 	else
 		rcu_idle_cpu--;
 
+out:
 	put_online_cpus();
+	free_cpumask_var(tmp_mask);
 }
 
 /* Shuffle tasks across CPUs, with the intent of allowing each CPU in the
--- linux-2.6-for-ingo.orig/kernel/softlockup.c
+++ linux-2.6-for-ingo/kernel/softlockup.c
@@ -310,10 +310,8 @@ cpu_callback(struct notifier_block *nfb,
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		if (hotcpu == check_cpu) {
-			cpumask_t temp_cpu_online_map = cpu_online_map;
-
-			cpu_clear(hotcpu, temp_cpu_online_map);
-			check_cpu = any_online_cpu(temp_cpu_online_map);
+			/* Pick any other online cpu. */
+			check_cpu = cpumask_any_but(cpu_online_mask, hotcpu);
 		}
 		break;
 
--- linux-2.6-for-ingo.orig/kernel/stop_machine.c
+++ linux-2.6-for-ingo/kernel/stop_machine.c
@@ -69,10 +69,10 @@ static void stop_cpu(struct work_struct 
 	int err;
 
 	if (!active_cpus) {
-		if (cpu == first_cpu(cpu_online_map))
+		if (cpu == cpumask_first(cpu_online_mask))
 			smdata = &active;
 	} else {
-		if (cpu_isset(cpu, *active_cpus))
+		if (cpumask_test_cpu(cpu, active_cpus))
 			smdata = &active;
 	}
 	/* Simple state machine */
@@ -109,7 +109,7 @@ static int chill(void *unused)
 	return 0;
 }
 
-int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
+int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 {
 	struct work_struct *sm_work;
 	int i, ret;
@@ -142,7 +142,7 @@ int __stop_machine(int (*fn)(void *), vo
 	return ret;
 }
 
-int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
+int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 {
 	int ret;
 
--- linux-2.6-for-ingo.orig/kernel/taskstats.c
+++ linux-2.6-for-ingo/kernel/taskstats.c
@@ -290,18 +290,17 @@ ret:
 	return;
 }
 
-static int add_del_listener(pid_t pid, cpumask_t *maskp, int isadd)
+static int add_del_listener(pid_t pid, const struct cpumask *mask, int isadd)
 {
 	struct listener_list *listeners;
 	struct listener *s, *tmp;
 	unsigned int cpu;
-	cpumask_t mask = *maskp;
 
-	if (!cpus_subset(mask, cpu_possible_map))
+	if (!cpumask_subset(mask, cpu_possible_mask))
 		return -EINVAL;
 
 	if (isadd == REGISTER) {
-		for_each_cpu_mask_nr(cpu, mask) {
+		for_each_cpu(cpu, mask) {
 			s = kmalloc_node(sizeof(struct listener), GFP_KERNEL,
 					 cpu_to_node(cpu));
 			if (!s)
@@ -320,7 +319,7 @@ static int add_del_listener(pid_t pid, c
 
 	/* Deregister or cleanup */
 cleanup:
-	for_each_cpu_mask_nr(cpu, mask) {
+	for_each_cpu(cpu, mask) {
 		listeners = &per_cpu(listener_array, cpu);
 		down_write(&listeners->sem);
 		list_for_each_entry_safe(s, tmp, &listeners->list, list) {
@@ -335,7 +334,7 @@ cleanup:
 	return 0;
 }
 
-static int parse(struct nlattr *na, cpumask_t *mask)
+static int parse(struct nlattr *na, struct cpumask *mask)
 {
 	char *data;
 	int len;
@@ -428,23 +427,33 @@ err:
 
 static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
 {
-	int rc = 0;
+	int rc;
 	struct sk_buff *rep_skb;
 	struct taskstats *stats;
 	size_t size;
-	cpumask_t mask;
+	cpumask_var_t mask;
+
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		return -ENOMEM;
 
-	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK], &mask);
+	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK], mask);
 	if (rc < 0)
-		return rc;
-	if (rc == 0)
-		return add_del_listener(info->snd_pid, &mask, REGISTER);
+		goto free_return_rc;
+	if (rc == 0) {
+		rc = add_del_listener(info->snd_pid, mask, REGISTER);
+		goto free_return_rc;
+	}
 
-	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK], &mask);
+	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK], mask);
 	if (rc < 0)
+		goto free_return_rc;
+	if (rc == 0) {
+		rc = add_del_listener(info->snd_pid, mask, DEREGISTER);
+free_return_rc:
+		free_cpumask_var(mask);
 		return rc;
-	if (rc == 0)
-		return add_del_listener(info->snd_pid, &mask, DEREGISTER);
+	}
+	free_cpumask_var(mask);
 
 	/*
 	 * Size includes space for nested attributes

-- 
