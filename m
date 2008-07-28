Return-Path: <linux-kernel-owner+w=401wt.eu-S1759793AbYG1CXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793AbYG1CXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 22:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbYG1CXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 22:23:37 -0400
Received: from ozlabs.org ([203.10.76.45]:52655 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbYG1CXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 22:23:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] stop_machine cleanup (and a module warning fix)
Date: Mon, 28 Jul 2008 12:23:22 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Abhishek Sagar <sagar.abhishek@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       Martin Schwidefsky <schwidefsky@googlemail.com>,
       "Akinobu Mita" <akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281223.23452.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 837b41b5de356aa67abb2cadb5eef3efc7776f91:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../ieee1394/linux1394-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Jason Baron (1):
      stop_machine: add ALL_CPUS option

Rusty Russell (5):
      Simplify stop_machine
      Hotplug CPU: don't check cpu_online after take_cpu_down
      stop_machine(): stop_machine_run() changed to use cpu mask
      stop_machine: Wean existing callers off stop_machine_run()
      stop_machine: fix up ftrace.c

WANG Cong (1):
      module: fix build warning with !CONFIG_KALLSYMS

 arch/s390/kernel/kprobes.c         |    6 +-
 drivers/char/hw_random/intel-rng.c |    6 +-
 include/linux/stop_machine.h       |   50 ++++--
 kernel/cpu.c                       |   16 +--
 kernel/module.c                    |   33 ++--
 kernel/rcuclassic.c                |    4 +-
 kernel/stop_machine.c              |  288 ++++++++++++++++--------------------
 kernel/trace/ftrace.c              |    6 +-
 mm/page_alloc.c                    |    4 +-
 9 files changed, 199 insertions(+), 214 deletions(-)

diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index 4f82e5b..569079e 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -197,7 +197,7 @@ void __kprobes arch_arm_kprobe(struct kprobe *p)
 	args.new = BREAKPOINT_INSTRUCTION;
 
 	kcb->kprobe_status = KPROBE_SWAP_INST;
-	stop_machine_run(swap_instruction, &args, NR_CPUS);
+	stop_machine(swap_instruction, &args, NULL);
 	kcb->kprobe_status = status;
 }
 
@@ -212,7 +212,7 @@ void __kprobes arch_disarm_kprobe(struct kprobe *p)
 	args.new = p->opcode;
 
 	kcb->kprobe_status = KPROBE_SWAP_INST;
-	stop_machine_run(swap_instruction, &args, NR_CPUS);
+	stop_machine(swap_instruction, &args, NULL);
 	kcb->kprobe_status = status;
 }
 
@@ -331,7 +331,7 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 		 * No kprobe at this address. The fault has not been
 		 * caused by a kprobe breakpoint. The race of breakpoint
 		 * vs. kprobe remove does not exist because on s390 we
-		 * use stop_machine_run to arm/disarm the breakpoints.
+		 * use stop_machine to arm/disarm the breakpoints.
 		 */
 		goto no_kprobe;
 
diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index 27fdc08..8a2fce0 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -241,7 +241,7 @@ static int __init intel_rng_hw_init(void *_intel_rng_hw)
 	struct intel_rng_hw *intel_rng_hw = _intel_rng_hw;
 	u8 mfc, dvc;
 
-	/* interrupts disabled in stop_machine_run call */
+	/* interrupts disabled in stop_machine call */
 
 	if (!(intel_rng_hw->fwh_dec_en1_val & FWH_F8_EN_MASK))
 		pci_write_config_byte(intel_rng_hw->dev,
@@ -365,10 +365,10 @@ static int __init mod_init(void)
 	 * location with the Read ID command, all activity on the system
 	 * must be stopped until the state is back to normal.
 	 *
-	 * Use stop_machine_run because IPIs can be blocked by disabling
+	 * Use stop_machine because IPIs can be blocked by disabling
 	 * interrupts.
 	 */
-	err = stop_machine_run(intel_rng_hw_init, intel_rng_hw, NR_CPUS);
+	err = stop_machine(intel_rng_hw_init, intel_rng_hw, NULL);
 	pci_dev_put(dev);
 	iounmap(intel_rng_hw->mem);
 	kfree(intel_rng_hw);
diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 5bfc553..f1cb0ba 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -5,41 +5,43 @@
    (and more).  So the "read" side to such a lock is anything which
    diables preeempt. */
 #include <linux/cpu.h>
+#include <linux/cpumask.h>
 #include <asm/system.h>
 
 #if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
+
+/* Deprecated, but useful for transition. */
+#define ALL_CPUS ~0U
+
 /**
- * stop_machine_run: freeze the machine on all CPUs and run this function
+ * stop_machine: freeze the machine on all CPUs and run this function
  * @fn: the function to run
  * @data: the data ptr for the @fn()
- * @cpu: the cpu to run @fn() on (or any, if @cpu == NR_CPUS.
+ * @cpus: the cpus to run the @fn() on (NULL = any online cpu)
  *
- * Description: This causes a thread to be scheduled on every other cpu,
- * each of which disables interrupts, and finally interrupts are disabled
- * on the current CPU.  The result is that noone is holding a spinlock
- * or inside any other preempt-disabled region when @fn() runs.
+ * Description: This causes a thread to be scheduled on every cpu,
+ * each of which disables interrupts.  The result is that noone is
+ * holding a spinlock or inside any other preempt-disabled region when
+ * @fn() runs.
  *
  * This can be thought of as a very heavy write lock, equivalent to
  * grabbing every spinlock in the kernel. */
-int stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu);
+int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus);
 
 /**
- * __stop_machine_run: freeze the machine on all CPUs and run this function
+ * __stop_machine: freeze the machine on all CPUs and run this function
  * @fn: the function to run
  * @data: the data ptr for the @fn
- * @cpu: the cpu to run @fn on (or any, if @cpu == NR_CPUS.
+ * @cpus: the cpus to run the @fn() on (NULL = any online cpu)
  *
- * Description: This is a special version of the above, which returns the
- * thread which has run @fn(): kthread_stop will return the return value
- * of @fn().  Used by hotplug cpu.
+ * Description: This is a special version of the above, which assumes cpus
+ * won't come or go while it's being called.  Used by hotplug cpu.
  */
-struct task_struct *__stop_machine_run(int (*fn)(void *), void *data,
-				       unsigned int cpu);
-
+int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus);
 #else
 
-static inline int stop_machine_run(int (*fn)(void *), void *data,
-				   unsigned int cpu)
+static inline int stop_machine(int (*fn)(void *), void *data,
+			       const cpumask_t *cpus)
 {
 	int ret;
 	local_irq_disable();
@@ -48,4 +50,18 @@ static inline int stop_machine_run(int (*fn)(void *), void *data,
 	return ret;
 }
 #endif /* CONFIG_SMP */
+
+static inline int __deprecated stop_machine_run(int (*fn)(void *), void *data,
+						unsigned int cpu)
+{
+	/* If they don't care which cpu fn runs on, just pick one. */
+	if (cpu == NR_CPUS)
+		return stop_machine(fn, data, NULL);
+	else if (cpu == ~0U)
+		return stop_machine(fn, data, &cpu_possible_map);
+	else {
+		cpumask_t cpus = cpumask_of_cpu(cpu);
+		return stop_machine(fn, data, &cpus);
+	}
+}
 #endif /* _LINUX_STOP_MACHINE */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 10ba5f1..29510d6 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -216,7 +216,6 @@ static int __ref take_cpu_down(void *_param)
 static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err, nr_calls = 0;
-	struct task_struct *p;
 	cpumask_t old_allowed, tmp;
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
@@ -249,21 +248,18 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	cpus_setall(tmp);
 	cpu_clear(cpu, tmp);
 	set_cpus_allowed_ptr(current, &tmp);
+	tmp = cpumask_of_cpu(cpu);
 
-	p = __stop_machine_run(take_cpu_down, &tcd_param, cpu);
-
-	if (IS_ERR(p) || cpu_online(cpu)) {
+	err = __stop_machine(take_cpu_down, &tcd_param, &tmp);
+	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 
-		if (IS_ERR(p)) {
-			err = PTR_ERR(p);
-			goto out_allowed;
-		}
-		goto out_thread;
+		goto out_allowed;
 	}
+	BUG_ON(cpu_online(cpu));
 
 	/* Wait for it to sleep (leaving idle task). */
 	while (!idle_cpu(cpu))
@@ -279,8 +275,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 
 	check_for_tasks(cpu);
 
-out_thread:
-	err = kthread_stop(p);
 out_allowed:
 	set_cpus_allowed_ptr(current, &old_allowed);
 out_release:
diff --git a/kernel/module.c b/kernel/module.c
index d8b5605..61d2121 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -325,18 +325,6 @@ static unsigned long find_symbol(const char *name,
 	return -ENOENT;
 }
 
-/* lookup symbol in given range of kernel_symbols */
-static const struct kernel_symbol *lookup_symbol(const char *name,
-	const struct kernel_symbol *start,
-	const struct kernel_symbol *stop)
-{
-	const struct kernel_symbol *ks = start;
-	for (; ks < stop; ks++)
-		if (strcmp(ks->name, name) == 0)
-			return ks;
-	return NULL;
-}
-
 /* Search for module by name: must hold module_mutex. */
 static struct module *find_module(const char *name)
 {
@@ -690,7 +678,7 @@ static int try_stop_module(struct module *mod, int flags, int *forced)
 	if (flags & O_NONBLOCK) {
 		struct stopref sref = { mod, flags, forced };
 
-		return stop_machine_run(__try_stop_module, &sref, NR_CPUS);
+		return stop_machine(__try_stop_module, &sref, NULL);
 	} else {
 		/* We don't need to stop the machine for this. */
 		mod->state = MODULE_STATE_GOING;
@@ -1428,7 +1416,7 @@ static int __unlink_module(void *_mod)
 static void free_module(struct module *mod)
 {
 	/* Delete from various lists */
-	stop_machine_run(__unlink_module, mod, NR_CPUS);
+	stop_machine(__unlink_module, mod, NULL);
 	remove_notes_attrs(mod);
 	remove_sect_attrs(mod);
 	mod_kobject_remove(mod);
@@ -1703,6 +1691,19 @@ static void setup_modinfo(struct module *mod, Elf_Shdr *sechdrs,
 }
 
 #ifdef CONFIG_KALLSYMS
+
+/* lookup symbol in given range of kernel_symbols */
+static const struct kernel_symbol *lookup_symbol(const char *name,
+	const struct kernel_symbol *start,
+	const struct kernel_symbol *stop)
+{
+	const struct kernel_symbol *ks = start;
+	for (; ks < stop; ks++)
+		if (strcmp(ks->name, name) == 0)
+			return ks;
+	return NULL;
+}
+
 static int is_exported(const char *name, const struct module *mod)
 {
 	if (!mod && lookup_symbol(name, __start___ksymtab, __stop___ksymtab))
@@ -2196,7 +2197,7 @@ static struct module *load_module(void __user *umod,
 	/* Now sew it into the lists so we can get lockdep and oops
          * info during argument parsing.  Noone should access us, since
          * strong_try_module_get() will fail. */
-	stop_machine_run(__link_module, mod, NR_CPUS);
+	stop_machine(__link_module, mod, NULL);
 
 	/* Size of section 0 is 0, so this works well if no params */
 	err = parse_args(mod->name, mod->args,
@@ -2230,7 +2231,7 @@ static struct module *load_module(void __user *umod,
 	return mod;
 
  unlink:
-	stop_machine_run(__unlink_module, mod, NR_CPUS);
+	stop_machine(__unlink_module, mod, NULL);
 	module_arch_cleanup(mod);
  cleanup:
 	kobject_del(&mod->mkobj.kobj);
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 6f8696c..aad93cd 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -91,8 +91,8 @@ static void force_quiescent_state(struct rcu_data *rdp,
 		 * rdp->cpu is the current cpu.
 		 *
 		 * cpu_online_map is updated by the _cpu_down()
-		 * using stop_machine_run(). Since we're in irqs disabled
-		 * section, stop_machine_run() is not exectuting, hence
+		 * using __stop_machine(). Since we're in irqs disabled
+		 * section, __stop_machine() is not exectuting, hence
 		 * the cpu_online_map is stable.
 		 *
 		 * However,  a cpu might have been offlined _just_ before
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 738b411..e446c7c 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -1,4 +1,4 @@
-/* Copyright 2005 Rusty Russell rusty@rustcorp.com.au IBM Corporation.
+/* Copyright 2008, 2005 Rusty Russell rusty@rustcorp.com.au IBM Corporation.
  * GPL v2 and any later version.
  */
 #include <linux/cpu.h>
@@ -13,204 +13,178 @@
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 
-/* Since we effect priority and affinity (both of which are visible
- * to, and settable by outside processes) we do indirection via a
- * kthread. */
-
-/* Thread to stop each CPU in user context. */
+/* This controls the threads on each CPU. */
 enum stopmachine_state {
-	STOPMACHINE_WAIT,
+	/* Dummy starting state for thread. */
+	STOPMACHINE_NONE,
+	/* Awaiting everyone to be scheduled. */
 	STOPMACHINE_PREPARE,
+	/* Disable interrupts. */
 	STOPMACHINE_DISABLE_IRQ,
+	/* Run the function */
+	STOPMACHINE_RUN,
+	/* Exit */
 	STOPMACHINE_EXIT,
 };
+static enum stopmachine_state state;
 
-static enum stopmachine_state stopmachine_state;
-static unsigned int stopmachine_num_threads;
-static atomic_t stopmachine_thread_ack;
-
-static int stopmachine(void *cpu)
-{
-	int irqs_disabled = 0;
-	int prepared = 0;
-	cpumask_of_cpu_ptr(cpumask, (int)(long)cpu);
-
-	set_cpus_allowed_ptr(current, cpumask);
-
-	/* Ack: we are alive */
-	smp_mb(); /* Theoretically the ack = 0 might not be on this CPU yet. */
-	atomic_inc(&stopmachine_thread_ack);
-
-	/* Simple state machine */
-	while (stopmachine_state != STOPMACHINE_EXIT) {
-		if (stopmachine_state == STOPMACHINE_DISABLE_IRQ 
-		    && !irqs_disabled) {
-			local_irq_disable();
-			hard_irq_disable();
-			irqs_disabled = 1;
-			/* Ack: irqs disabled. */
-			smp_mb(); /* Must read state first. */
-			atomic_inc(&stopmachine_thread_ack);
-		} else if (stopmachine_state == STOPMACHINE_PREPARE
-			   && !prepared) {
-			/* Everyone is in place, hold CPU. */
-			preempt_disable();
-			prepared = 1;
-			smp_mb(); /* Must read state first. */
-			atomic_inc(&stopmachine_thread_ack);
-		}
-		/* Yield in first stage: migration threads need to
-		 * help our sisters onto their CPUs. */
-		if (!prepared && !irqs_disabled)
-			yield();
-		cpu_relax();
-	}
-
-	/* Ack: we are exiting. */
-	smp_mb(); /* Must read state first. */
-	atomic_inc(&stopmachine_thread_ack);
-
-	if (irqs_disabled)
-		local_irq_enable();
-	if (prepared)
-		preempt_enable();
+struct stop_machine_data {
+	int (*fn)(void *);
+	void *data;
+	int fnret;
+};
 
-	return 0;
-}
+/* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
+static unsigned int num_threads;
+static atomic_t thread_ack;
+static struct completion finished;
+static DEFINE_MUTEX(lock);
 
-/* Change the thread state */
-static void stopmachine_set_state(enum stopmachine_state state)
+static void set_state(enum stopmachine_state newstate)
 {
-	atomic_set(&stopmachine_thread_ack, 0);
+	/* Reset ack counter. */
+	atomic_set(&thread_ack, num_threads);
 	smp_wmb();
-	stopmachine_state = state;
-	while (atomic_read(&stopmachine_thread_ack) != stopmachine_num_threads)
-		cpu_relax();
+	state = newstate;
 }
 
-static int stop_machine(void)
+/* Last one to ack a state moves to the next state. */
+static void ack_state(void)
 {
-	int i, ret = 0;
-
-	atomic_set(&stopmachine_thread_ack, 0);
-	stopmachine_num_threads = 0;
-	stopmachine_state = STOPMACHINE_WAIT;
-
-	for_each_online_cpu(i) {
-		if (i == raw_smp_processor_id())
-			continue;
-		ret = kernel_thread(stopmachine, (void *)(long)i,CLONE_KERNEL);
-		if (ret < 0)
-			break;
-		stopmachine_num_threads++;
-	}
-
-	/* Wait for them all to come to life. */
-	while (atomic_read(&stopmachine_thread_ack) != stopmachine_num_threads) {
-		yield();
-		cpu_relax();
+	if (atomic_dec_and_test(&thread_ack)) {
+		/* If we're the last one to ack the EXIT, we're finished. */
+		if (state == STOPMACHINE_EXIT)
+			complete(&finished);
+		else
+			set_state(state + 1);
 	}
+}
 
-	/* If some failed, kill them all. */
-	if (ret < 0) {
-		stopmachine_set_state(STOPMACHINE_EXIT);
-		return ret;
-	}
+/* This is the actual thread which stops the CPU.  It exits by itself rather
+ * than waiting for kthread_stop(), because it's easier for hotplug CPU. */
+static int stop_cpu(struct stop_machine_data *smdata)
+{
+	enum stopmachine_state curstate = STOPMACHINE_NONE;
+	int uninitialized_var(ret);
 
-	/* Now they are all started, make them hold the CPUs, ready. */
-	preempt_disable();
-	stopmachine_set_state(STOPMACHINE_PREPARE);
+	/* Simple state machine */
+	do {
+		/* Chill out and ensure we re-read stopmachine_state. */
+		cpu_relax();
+		if (state != curstate) {
+			curstate = state;
+			switch (curstate) {
+			case STOPMACHINE_DISABLE_IRQ:
+				local_irq_disable();
+				hard_irq_disable();
+				break;
+			case STOPMACHINE_RUN:
+				/* |= allows error detection if functions on
+				 * multiple CPUs. */
+				smdata->fnret |= smdata->fn(smdata->data);
+				break;
+			default:
+				break;
+			}
+			ack_state();
+		}
+	} while (curstate != STOPMACHINE_EXIT);
 
-	/* Make them disable irqs. */
-	local_irq_disable();
-	hard_irq_disable();
-	stopmachine_set_state(STOPMACHINE_DISABLE_IRQ);
+	local_irq_enable();
+	do_exit(0);
+}
 
+/* Callback for CPUs which aren't supposed to do anything. */
+static int chill(void *unused)
+{
 	return 0;
 }
 
-static void restart_machine(void)
+int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
 {
-	stopmachine_set_state(STOPMACHINE_EXIT);
-	local_irq_enable();
-	preempt_enable_no_resched();
-}
+	int i, err;
+	struct stop_machine_data active, idle;
+	struct task_struct **threads;
+
+	active.fn = fn;
+	active.data = data;
+	active.fnret = 0;
+	idle.fn = chill;
+	idle.data = NULL;
+
+	/* This could be too big for stack on large machines. */
+	threads = kcalloc(NR_CPUS, sizeof(threads[0]), GFP_KERNEL);
+	if (!threads)
+		return -ENOMEM;
+
+	/* Set up initial state. */
+	mutex_lock(&lock);
+	init_completion(&finished);
+	num_threads = num_online_cpus();
+	set_state(STOPMACHINE_PREPARE);
 
-struct stop_machine_data {
-	int (*fn)(void *);
-	void *data;
-	struct completion done;
-};
+	for_each_online_cpu(i) {
+		struct stop_machine_data *smdata = &idle;
+		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
-static int do_stop(void *_smdata)
-{
-	struct stop_machine_data *smdata = _smdata;
-	int ret;
+		if (!cpus) {
+			if (i == first_cpu(cpu_online_map))
+				smdata = &active;
+		} else {
+			if (cpu_isset(i, *cpus))
+				smdata = &active;
+		}
 
-	ret = stop_machine();
-	if (ret == 0) {
-		ret = smdata->fn(smdata->data);
-		restart_machine();
-	}
+		threads[i] = kthread_create((void *)stop_cpu, smdata, "kstop%u",
+					    i);
+		if (IS_ERR(threads[i])) {
+			err = PTR_ERR(threads[i]);
+			threads[i] = NULL;
+			goto kill_threads;
+		}
 
-	/* We're done: you can kthread_stop us now */
-	complete(&smdata->done);
+		/* Place it onto correct cpu. */
+		kthread_bind(threads[i], i);
 
-	/* Wait for kthread_stop */
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
-		schedule();
-		set_current_state(TASK_INTERRUPTIBLE);
+		/* Make it highest prio. */
+		if (sched_setscheduler_nocheck(threads[i], SCHED_FIFO, &param))
+			BUG();
 	}
-	__set_current_state(TASK_RUNNING);
-	return ret;
-}
 
-struct task_struct *__stop_machine_run(int (*fn)(void *), void *data,
-				       unsigned int cpu)
-{
-	static DEFINE_MUTEX(stopmachine_mutex);
-	struct stop_machine_data smdata;
-	struct task_struct *p;
+	/* We've created all the threads.  Wake them all: hold this CPU so one
+	 * doesn't hit this CPU until we're ready. */
+	get_cpu();
+	for_each_online_cpu(i)
+		wake_up_process(threads[i]);
 
-	smdata.fn = fn;
-	smdata.data = data;
-	init_completion(&smdata.done);
+	/* This will release the thread on our CPU. */
+	put_cpu();
+	wait_for_completion(&finished);
+	mutex_unlock(&lock);
 
-	mutex_lock(&stopmachine_mutex);
+	kfree(threads);
 
-	/* If they don't care which CPU fn runs on, bind to any online one. */
-	if (cpu == NR_CPUS)
-		cpu = raw_smp_processor_id();
+	return active.fnret;
 
-	p = kthread_create(do_stop, &smdata, "kstopmachine");
-	if (!IS_ERR(p)) {
-		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+kill_threads:
+	for_each_online_cpu(i)
+		if (threads[i])
+			kthread_stop(threads[i]);
+	mutex_unlock(&lock);
 
-		/* One high-prio thread per cpu.  We'll do this one. */
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
-		kthread_bind(p, cpu);
-		wake_up_process(p);
-		wait_for_completion(&smdata.done);
-	}
-	mutex_unlock(&stopmachine_mutex);
-	return p;
+	kfree(threads);
+	return err;
 }
 
-int stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu)
+int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
 {
-	struct task_struct *p;
 	int ret;
 
 	/* No CPUs can come up or down during this. */
 	get_online_cpus();
-	p = __stop_machine_run(fn, data, cpu);
-	if (!IS_ERR(p))
-		ret = kthread_stop(p);
-	else
-		ret = PTR_ERR(p);
+	ret = __stop_machine(fn, data, cpus);
 	put_online_cpus();
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(stop_machine_run);
+EXPORT_SYMBOL_GPL(stop_machine);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4231a3d..f6e3af3 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -587,7 +587,7 @@ static int __ftrace_modify_code(void *data)
 
 static void ftrace_run_update_code(int command)
 {
-	stop_machine_run(__ftrace_modify_code, &command, NR_CPUS);
+	stop_machine(__ftrace_modify_code, &command, NULL);
 }
 
 void ftrace_disable_daemon(void)
@@ -787,7 +787,7 @@ static int ftrace_update_code(void)
 	    !ftrace_enabled || !ftraced_trigger)
 		return 0;
 
-	stop_machine_run(__ftrace_update_code, NULL, NR_CPUS);
+	stop_machine(__ftrace_update_code, NULL, NULL);
 
 	return 1;
 }
@@ -1564,7 +1564,7 @@ static int __init ftrace_dynamic_init(void)
 
 	addr = (unsigned long)ftrace_record_ip;
 
-	stop_machine_run(ftrace_dyn_arch_init, &addr, NR_CPUS);
+	stop_machine(ftrace_dyn_arch_init, &addr, NULL);
 
 	/* ftrace_dyn_arch_init places the return code in addr */
 	if (addr) {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6da6672..3cf3d05 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2372,7 +2372,7 @@ static void build_zonelist_cache(pg_data_t *pgdat)
 
 #endif	/* CONFIG_NUMA */
 
-/* return values int ....just for stop_machine_run() */
+/* return values int ....just for stop_machine() */
 static int __build_all_zonelists(void *dummy)
 {
 	int nid;
@@ -2397,7 +2397,7 @@ void build_all_zonelists(void)
 	} else {
 		/* we have to stop all cpus to guarantee there is no user
 		   of zonelist */
-		stop_machine_run(__build_all_zonelists, NULL, NR_CPUS);
+		stop_machine(__build_all_zonelists, NULL, NULL);
 		/* cpuset refresh routine should be here */
 	}
 	vm_total_pages = nr_free_pagecache_pages();
