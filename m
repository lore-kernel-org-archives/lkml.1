Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbYI2SL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbYI2SL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYI2SDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:31 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36504 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753894AbYI2SCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:55 -0400
Message-Id: <20080929180254.203379000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:20 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 30/31] cpumask: clean kernel files
Content-Disposition: inline; filename=clean-kernel
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/apm_32.c         |   24 ++++++++++++++----------
 arch/x86/kernel/microcode_core.c |    6 +++---
 arch/x86/kernel/nmi.c            |    4 ++--
 arch/x86/kernel/process.c        |    2 +-
 kernel/compat.c                  |   24 ++++++++++++------------
 kernel/fork.c                    |    2 +-
 kernel/kthread.c                 |    2 +-
 kernel/profile.c                 |   10 +++++-----
 kernel/stop_machine.c            |    6 +++---
 kernel/taskstats.c               |   17 ++++++++---------
 kernel/workqueue.c               |   27 +++++++++++++++------------
 11 files changed, 65 insertions(+), 59 deletions(-)

--- struct-cpumasks.orig/arch/x86/kernel/apm_32.c
+++ struct-cpumasks/arch/x86/kernel/apm_32.c
@@ -492,17 +492,17 @@ static void apm_error(char *str, int err
  */
 
 #ifdef CONFIG_SMP
-
-static cpumask_t apm_save_cpus(void)
+static void apm_save_cpus(cpumask_t x)
 {
-	cpumask_t x = current->cpus_allowed;
+	if (x)
+		cpus_copy(x, current->cpus_allowed);
 	/* Some bioses don't like being called from CPU != 0 */
 	set_cpus_allowed(current, cpumask_of_cpu(0));
 	BUG_ON(smp_processor_id() != 0);
 	return x;
 }
 
-static inline void apm_restore_cpus(cpumask_t mask)
+static inline void apm_restore_cpus(const_cpumask_t mask)
 {
 	set_cpus_allowed(current, mask);
 }
@@ -513,7 +513,11 @@ static inline void apm_restore_cpus(cpum
  *	No CPU lockdown needed on a uniprocessor
  */
 
-#define apm_save_cpus()		(current->cpus_allowed)
+static void apm_save_cpus(cpumask_t x)
+{
+	if (x)
+		cpus_copy(x, current->cpus_allowed);
+}
 #define apm_restore_cpus(x)	(void)(x)
 
 #endif
@@ -597,12 +601,12 @@ static u8 apm_bios_call(u32 func, u32 eb
 {
 	APM_DECL_SEGS
 	unsigned long		flags;
-	cpumask_t		cpus;
+	cpumask_var_t		cpus;
 	int			cpu;
 	struct desc_struct	save_desc_40;
 	struct desc_struct	*gdt;
 
-	cpus = apm_save_cpus();
+	apm_save_cpus(cpus);
 
 	cpu = get_cpu();
 	gdt = get_cpu_gdt_table(cpu);
@@ -640,12 +644,12 @@ static u8 apm_bios_call_simple(u32 func,
 	u8			error;
 	APM_DECL_SEGS
 	unsigned long		flags;
-	cpumask_t		cpus;
+	cpumask_var_t		cpus;
 	int			cpu;
 	struct desc_struct	save_desc_40;
 	struct desc_struct	*gdt;
 
-	cpus = apm_save_cpus();
+	apm_save_cpus(cpus);
 
 	cpu = get_cpu();
 	gdt = get_cpu_gdt_table(cpu);
@@ -941,7 +945,7 @@ static void apm_power_off(void)
 
 	/* Some bioses don't like being called from CPU != 0 */
 	if (apm_info.realmode_power_off) {
-		(void)apm_save_cpus();
+		(void)apm_save_cpus(NULL);
 		machine_real_restart(po_bios_call, sizeof(po_bios_call));
 	} else {
 		(void)set_system_power_state(APM_STATE_OFF);
--- struct-cpumasks.orig/arch/x86/kernel/microcode_core.c
+++ struct-cpumasks/arch/x86/kernel/microcode_core.c
@@ -130,7 +130,7 @@ static int do_microcode_update(const voi
 			microcode_ops->apply_microcode(cpu);
 	}
 out:
-	set_cpus_allowed(current, &old);
+	set_cpus_allowed(current, old);
 	return error;
 }
 
@@ -231,7 +231,7 @@ static ssize_t reload_store(struct sys_d
 					microcode_ops->apply_microcode(cpu);
 			}
 			mutex_unlock(&microcode_mutex);
-			set_cpus_allowed(current, &old);
+			set_cpus_allowed(current, old);
 		}
 		put_online_cpus();
 	}
@@ -353,7 +353,7 @@ static void microcode_init_cpu(int cpu)
 
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	microcode_update_cpu(cpu);
-	set_cpus_allowed(current, &old);
+	set_cpus_allowed(current, old);
 }
 
 static int mc_sysdev_add(struct sys_device *sys_dev)
--- struct-cpumasks.orig/arch/x86/kernel/nmi.c
+++ struct-cpumasks/arch/x86/kernel/nmi.c
@@ -41,7 +41,7 @@
 int unknown_nmi_panic;
 int nmi_watchdog_enabled;
 
-static cpumask_t backtrace_mask = CPU_MASK_NONE;
+static cpumask_map_t backtrace_mask = CPU_MASK_NONE;
 
 /* nmi_active:
  * >0: the lapic NMI watchdog is active, but can be disabled
@@ -530,7 +530,7 @@ void __trigger_all_cpu_backtrace(void)
 {
 	int i;
 
-	backtrace_mask = cpu_online_map;
+	cpus_copy(backtrace_mask, cpu_online_map);
 	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
 	for (i = 0; i < 10 * 1000; i++) {
 		if (cpus_empty(backtrace_mask))
--- struct-cpumasks.orig/arch/x86/kernel/process.c
+++ struct-cpumasks/arch/x86/kernel/process.c
@@ -246,7 +246,7 @@ static int __cpuinit check_c1e_idle(cons
 	return 1;
 }
 
-static cpumask_t c1e_mask = CPU_MASK_NONE;
+static cpumask_map_t c1e_mask = CPU_MASK_NONE;
 static int c1e_detected;
 
 void c1e_remove_cpu(int cpu)
--- struct-cpumasks.orig/kernel/compat.c
+++ struct-cpumasks/kernel/compat.c
@@ -396,16 +396,16 @@ asmlinkage long compat_sys_waitid(int wh
 }
 
 static int compat_get_user_cpu_mask(compat_ulong_t __user *user_mask_ptr,
-				    unsigned len, cpumask_t *new_mask)
+				    unsigned len, cpumask_t new_mask)
 {
 	unsigned long *k;
 
-	if (len < sizeof(cpumask_t))
-		memset(new_mask, 0, sizeof(cpumask_t));
-	else if (len > sizeof(cpumask_t))
-		len = sizeof(cpumask_t);
+	if (len < cpumask_size())
+		memset(new_mask, 0, cpumask_size());
+	else if (len > cpumask_size())
+		len = cpumask_size();
 
-	k = cpus_addr(*new_mask);
+	k = cpus_addr(new_mask);
 	return compat_get_bitmap(k, user_mask_ptr, len * 8);
 }
 
@@ -413,23 +413,23 @@ asmlinkage long compat_sys_sched_setaffi
 					     unsigned int len,
 					     compat_ulong_t __user *user_mask_ptr)
 {
-	cpumask_t new_mask;
+	cpumask_var_t new_mask;
 	int retval;
 
-	retval = compat_get_user_cpu_mask(user_mask_ptr, len, &new_mask);
+	retval = compat_get_user_cpu_mask(user_mask_ptr, len, new_mask);
 	if (retval)
 		return retval;
 
-	return sched_setaffinity(pid, &new_mask);
+	return sched_setaffinity(pid, new_mask);
 }
 
 asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid, unsigned int len,
 					     compat_ulong_t __user *user_mask_ptr)
 {
 	int ret;
-	cpumask_t mask;
+	cpumask_var_t mask;
 	unsigned long *k;
-	unsigned int min_length = sizeof(cpumask_t);
+	unsigned int min_length = cpumask_size();
 
 	if (NR_CPUS <= BITS_PER_COMPAT_LONG)
 		min_length = sizeof(compat_ulong_t);
@@ -437,7 +437,7 @@ asmlinkage long compat_sys_sched_getaffi
 	if (len < min_length)
 		return -EINVAL;
 
-	ret = sched_getaffinity(pid, &mask);
+	ret = sched_getaffinity(pid, mask);
 	if (ret < 0)
 		return ret;
 
--- struct-cpumasks.orig/kernel/fork.c
+++ struct-cpumasks/kernel/fork.c
@@ -1202,7 +1202,7 @@ static struct task_struct *copy_process(
 	 * to ensure it is on a valid CPU (and if not, just force it back to
 	 * parent's CPU). This avoids alot of nasty races.
 	 */
-	p->cpus_allowed = current->cpus_allowed;
+	cpus_copy(p->cpus_allowed, current->cpus_allowed);
 	p->rt.nr_cpus_allowed = current->rt.nr_cpus_allowed;
 	if (unlikely(!cpu_isset(task_cpu(p), p->cpus_allowed) ||
 			!cpu_online(task_cpu(p))))
--- struct-cpumasks.orig/kernel/kthread.c
+++ struct-cpumasks/kernel/kthread.c
@@ -179,7 +179,7 @@ void kthread_bind(struct task_struct *k,
 	/* Must have done schedule() in kthread() before we set_task_cpu */
 	wait_task_inactive(k, 0);
 	set_task_cpu(k, cpu);
-	k->cpus_allowed = cpumask_of_cpu(cpu);
+	cpus_copy(k->cpus_allowed, cpumask_of_cpu(cpu));
 	k->rt.nr_cpus_allowed = 1;
 	k->flags |= PF_THREAD_BOUND;
 }
--- struct-cpumasks.orig/kernel/profile.c
+++ struct-cpumasks/kernel/profile.c
@@ -43,7 +43,7 @@ static unsigned long prof_len, prof_shif
 int prof_on __read_mostly;
 EXPORT_SYMBOL_GPL(prof_on);
 
-static cpumask_t prof_cpu_mask = CPU_MASK_ALL;
+static cpumask_map_t prof_cpu_mask = CPU_MASK_ALL;
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct profile_hit *[2], cpu_profile_hits);
 static DEFINE_PER_CPU(int, cpu_profile_flip);
@@ -421,7 +421,7 @@ void profile_tick(int type)
 static int prof_cpu_mask_read_proc(char *page, char **start, off_t off,
 			int count, int *eof, void *data)
 {
-	int len = cpumask_scnprintf(page, count, *(cpumask_t *)data);
+	int len = cpumask_scnprintf(page, count, (const_cpumask_t)data);
 	if (count - len < 2)
 		return -EINVAL;
 	len += sprintf(page + len, "\n");
@@ -431,15 +431,15 @@ static int prof_cpu_mask_read_proc(char 
 static int prof_cpu_mask_write_proc(struct file *file,
 	const char __user *buffer,  unsigned long count, void *data)
 {
-	cpumask_t *mask = (cpumask_t *)data;
+	cpumask_t mask = (cpumask_t)data;
 	unsigned long full_count = count, err;
-	cpumask_t new_value;
+	cpumask_var_t new_value;
 
 	err = cpumask_parse_user(buffer, count, new_value);
 	if (err)
 		return err;
 
-	*mask = new_value;
+	cpus_copy(mask, new_value);
 	return full_count;
 }
 
--- struct-cpumasks.orig/kernel/stop_machine.c
+++ struct-cpumasks/kernel/stop_machine.c
@@ -99,7 +99,7 @@ static int chill(void *unused)
 	return 0;
 }
 
-int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
+int __stop_machine(int (*fn)(void *), void *data, const_cpumask_t cpus)
 {
 	int i, err;
 	struct stop_machine_data active, idle;
@@ -130,7 +130,7 @@ int __stop_machine(int (*fn)(void *), vo
 			if (i == cpus_first(cpu_online_map))
 				smdata = &active;
 		} else {
-			if (cpu_isset(i, *cpus))
+			if (cpu_isset(i, cpus))
 				smdata = &active;
 		}
 
@@ -175,7 +175,7 @@ kill_threads:
 	return err;
 }
 
-int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
+int stop_machine(int (*fn)(void *), void *data, const_cpumask_t cpus)
 {
 	int ret;
 
--- struct-cpumasks.orig/kernel/taskstats.c
+++ struct-cpumasks/kernel/taskstats.c
@@ -290,12 +290,11 @@ ret:
 	return;
 }
 
-static int add_del_listener(pid_t pid, cpumask_t *maskp, int isadd)
+static int add_del_listener(pid_t pid, const_cpumask_t mask, int isadd)
 {
 	struct listener_list *listeners;
 	struct listener *s, *tmp;
 	unsigned int cpu;
-	cpumask_t mask = *maskp;
 
 	if (!cpus_subset(mask, cpu_possible_map))
 		return -EINVAL;
@@ -335,7 +334,7 @@ cleanup:
 	return 0;
 }
 
-static int parse(struct nlattr *na, cpumask_t *mask)
+static int parse(struct nlattr *na, cpumask_t mask)
 {
 	char *data;
 	int len;
@@ -352,7 +351,7 @@ static int parse(struct nlattr *na, cpum
 	if (!data)
 		return -ENOMEM;
 	nla_strlcpy(data, na, len);
-	ret = cpulist_parse(data, *mask);
+	ret = cpulist_parse(data, mask);
 	kfree(data);
 	return ret;
 }
@@ -432,19 +431,19 @@ static int taskstats_user_cmd(struct sk_
 	struct sk_buff *rep_skb;
 	struct taskstats *stats;
 	size_t size;
-	cpumask_t mask;
+	cpumask_var_t mask;
 
-	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK], &mask);
+	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK], mask);
 	if (rc < 0)
 		return rc;
 	if (rc == 0)
-		return add_del_listener(info->snd_pid, &mask, REGISTER);
+		return add_del_listener(info->snd_pid, mask, REGISTER);
 
-	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK], &mask);
+	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK], mask);
 	if (rc < 0)
 		return rc;
 	if (rc == 0)
-		return add_del_listener(info->snd_pid, &mask, DEREGISTER);
+		return add_del_listener(info->snd_pid, mask, DEREGISTER);
 
 	/*
 	 * Size includes space for nested attributes
--- struct-cpumasks.orig/kernel/workqueue.c
+++ struct-cpumasks/kernel/workqueue.c
@@ -72,7 +72,7 @@ static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 
 static int singlethread_cpu __read_mostly;
-static cpumask_t cpu_singlethread_map __read_mostly;
+static cpumask_map_t cpu_singlethread_map __read_mostly;
 /*
  * _cpu_down() first removes CPU from cpu_online_map, then CPU_DEAD
  * flushes cwq->worklist. This means that flush_workqueue/wait_on_work
@@ -80,7 +80,7 @@ static cpumask_t cpu_singlethread_map __
  * use cpu_possible_map, the cpumask below is more a documentation
  * than optimization.
  */
-static cpumask_t cpu_populated_map __read_mostly;
+static cpumask_map_t cpu_populated_map __read_mostly;
 
 /* If it's single threaded, it isn't in the list of workqueues. */
 static inline int is_single_threaded(struct workqueue_struct *wq)
@@ -88,10 +88,11 @@ static inline int is_single_threaded(str
 	return wq->singlethread;
 }
 
-static const cpumask_t *wq_cpu_map(struct workqueue_struct *wq)
+static const_cpumask_t wq_cpu_map(struct workqueue_struct *wq)
 {
 	return is_single_threaded(wq)
-		? &cpu_singlethread_map : &cpu_populated_map;
+		? (const_cpumask_t)cpu_singlethread_map
+		: (const_cpumask_t)cpu_populated_map;
 }
 
 static
@@ -409,13 +410,15 @@ static int flush_cpu_workqueue(struct cp
  */
 void flush_workqueue(struct workqueue_struct *wq)
 {
-	const cpumask_t *cpu_map = wq_cpu_map(wq);
+	cpumask_var_t cpu_map;	/* XXX - if wq_cpu_map(wq) changes? */
+				/* XXX - otherwise can be const_cpumask_t */
 	int cpu;
 
+	cpus_copy(cpu_map, wq_cpu_map(wq));
 	might_sleep();
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
-	for_each_cpu(cpu, *cpu_map)
+	for_each_cpu(cpu, cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
@@ -531,7 +534,7 @@ static void wait_on_work(struct work_str
 {
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
-	const cpumask_t *cpu_map;
+	const_cpumask_t cpu_map;
 	int cpu;
 
 	might_sleep();
@@ -546,7 +549,7 @@ static void wait_on_work(struct work_str
 	wq = cwq->wq;
 	cpu_map = wq_cpu_map(wq);
 
-	for_each_cpu(cpu, *cpu_map)
+	for_each_cpu(cpu, cpu_map)
 		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
 
@@ -898,7 +901,7 @@ static void cleanup_workqueue_thread(str
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
-	const cpumask_t *cpu_map = wq_cpu_map(wq);
+	const_cpumask_t cpu_map = wq_cpu_map(wq);
 	int cpu;
 
 	cpu_maps_update_begin();
@@ -906,7 +909,7 @@ void destroy_workqueue(struct workqueue_
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
-	for_each_cpu(cpu, *cpu_map)
+	for_each_cpu(cpu, cpu_map)
 		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
  	cpu_maps_update_done();
 
@@ -967,9 +970,9 @@ undo:
 
 void __init init_workqueues(void)
 {
-	cpu_populated_map = cpu_online_map;
+	cpus_copy(cpu_populated_map, cpu_online_map);
 	singlethread_cpu = cpus_first(cpu_possible_map);
-	cpu_singlethread_map = cpumask_of_cpu(singlethread_cpu);
+	cpus_copy(cpu_singlethread_map, cpumask_of_cpu(singlethread_cpu));
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);

-- 
