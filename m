Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYGHIB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYGHIB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 04:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYGHIBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 04:01:50 -0400
Received: from ozlabs.org ([203.10.76.45]:36304 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbYGHIBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 04:01:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] stop_machine: use cpu mask rather than magic numbers
Date: Tue, 8 Jul 2008 18:01:37 +1000
User-Agent: KMail/1.9.9
Cc: Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
References: <200807081750.55536.rusty@rustcorp.com.au> <200807081756.02838.rusty@rustcorp.com.au> <200807081756.47140.rusty@rustcorp.com.au>
In-Reply-To: <200807081756.47140.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081801.38026.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of a "cpu" arg with magic values NR_CPUS (any cpu) and ~0 (all
cpus), pass a cpumask_t.  Allow NULL for the common case (where we
don't care which CPU the function is run on): temporary cpumask_t's
are usually considered bad for stack space.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 277c5fb41d25 arch/s390/kernel/kprobes.c
--- a/arch/s390/kernel/kprobes.c	Tue Jul 08 12:57:33 2008 +1000
+++ b/arch/s390/kernel/kprobes.c	Tue Jul 08 17:31:41 2008 +1000
@@ -199,7 +199,7 @@ void __kprobes arch_arm_kprobe(struct kp
 	args.new = BREAKPOINT_INSTRUCTION;
 
 	kcb->kprobe_status = KPROBE_SWAP_INST;
-	stop_machine_run(swap_instruction, &args, NR_CPUS);
+	stop_machine_run(swap_instruction, &args, NULL);
 	kcb->kprobe_status = status;
 }
 
@@ -214,7 +214,7 @@ void __kprobes arch_disarm_kprobe(struct
 	args.new = p->opcode;
 
 	kcb->kprobe_status = KPROBE_SWAP_INST;
-	stop_machine_run(swap_instruction, &args, NR_CPUS);
+	stop_machine_run(swap_instruction, &args, NULL);
 	kcb->kprobe_status = status;
 }
 
diff -r 277c5fb41d25 drivers/char/hw_random/intel-rng.c
--- a/drivers/char/hw_random/intel-rng.c	Tue Jul 08 12:57:33 2008 +1000
+++ b/drivers/char/hw_random/intel-rng.c	Tue Jul 08 17:31:41 2008 +1000
@@ -368,7 +368,7 @@ static int __init mod_init(void)
 	 * Use stop_machine_run because IPIs can be blocked by disabling
 	 * interrupts.
 	 */
-	err = stop_machine_run(intel_rng_hw_init, intel_rng_hw, NR_CPUS);
+	err = stop_machine_run(intel_rng_hw_init, intel_rng_hw, NULL);
 	pci_dev_put(dev);
 	iounmap(intel_rng_hw->mem);
 	kfree(intel_rng_hw);
diff -r 277c5fb41d25 include/linux/stop_machine.h
--- a/include/linux/stop_machine.h	Tue Jul 08 12:57:33 2008 +1000
+++ b/include/linux/stop_machine.h	Tue Jul 08 17:31:41 2008 +1000
@@ -5,19 +5,19 @@
    (and more).  So the "read" side to such a lock is anything which
    diables preeempt. */
 #include <linux/cpu.h>
+#include <linux/cpumask.h>
 #include <asm/system.h>
 
 #if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
 
-#define ALL_CPUS ~0U
+/* Deprecated, but useful for transition. */
+#define ALL_CPUS CPU_MASK_ALL_PTR
 
 /**
  * stop_machine_run: freeze the machine on all CPUs and run this function
  * @fn: the function to run
  * @data: the data ptr for the @fn()
- * @cpu: if @cpu == n, run @fn() on cpu n
- *       if @cpu == NR_CPUS, run @fn() on any cpu
- *       if @cpu == ALL_CPUS, run @fn() on every online CPU.
+ * @cpus: the cpus to run the @fn() on (NULL = any online cpu)
  *
  * Description: This causes a thread to be scheduled on every cpu,
  * each of which disables interrupts.  The result is that noone is
@@ -26,22 +26,22 @@
  *
  * This can be thought of as a very heavy write lock, equivalent to
  * grabbing every spinlock in the kernel. */
-int stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu);
+int stop_machine_run(int (*fn)(void *), void *data, const cpumask_t *cpus);
 
 /**
  * __stop_machine_run: freeze the machine on all CPUs and run this function
  * @fn: the function to run
  * @data: the data ptr for the @fn
- * @cpu: the cpu to run @fn on (or any, if @cpu == NR_CPUS.
+ * @cpus: the cpus to run the @fn() on (NULL = any online cpu)
  *
  * Description: This is a special version of the above, which assumes cpus
  * won't come or go while it's being called.  Used by hotplug cpu.
  */
-int __stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu);
+int __stop_machine_run(int (*fn)(void *), void *data, const cpumask_t *cpus);
 #else
 
 static inline int stop_machine_run(int (*fn)(void *), void *data,
-				   unsigned int cpu)
+				   const cpumask_t *cpus)
 {
 	int ret;
 	local_irq_disable();
diff -r 277c5fb41d25 kernel/cpu.c
--- a/kernel/cpu.c	Tue Jul 08 12:57:33 2008 +1000
+++ b/kernel/cpu.c	Tue Jul 08 17:31:41 2008 +1000
@@ -224,8 +224,9 @@ static int __ref _cpu_down(unsigned int 
 	cpus_setall(tmp);
 	cpu_clear(cpu, tmp);
 	set_cpus_allowed_ptr(current, &tmp);
+	tmp = cpumask_of_cpu(cpu);
 
-	err = __stop_machine_run(take_cpu_down, &tcd_param, cpu);
+	err = __stop_machine_run(take_cpu_down, &tcd_param, &tmp);
 
 	if (err || cpu_online(cpu)) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
diff -r 277c5fb41d25 kernel/module.c
--- a/kernel/module.c	Tue Jul 08 12:57:33 2008 +1000
+++ b/kernel/module.c	Tue Jul 08 17:31:41 2008 +1000
@@ -689,7 +689,7 @@ static int try_stop_module(struct module
 {
 	struct stopref sref = { mod, flags, forced };
 
-	return stop_machine_run(__try_stop_module, &sref, NR_CPUS);
+	return stop_machine_run(__try_stop_module, &sref, NULL);
 }
 
 unsigned int module_refcount(struct module *mod)
@@ -1421,7 +1421,7 @@ static void free_module(struct module *m
 static void free_module(struct module *mod)
 {
 	/* Delete from various lists */
-	stop_machine_run(__unlink_module, mod, NR_CPUS);
+	stop_machine_run(__unlink_module, mod, NULL);
 	remove_notes_attrs(mod);
 	remove_sect_attrs(mod);
 	mod_kobject_remove(mod);
@@ -2189,7 +2189,7 @@ static struct module *load_module(void _
 	/* Now sew it into the lists so we can get lockdep and oops
          * info during argument parsing.  Noone should access us, since
          * strong_try_module_get() will fail. */
-	stop_machine_run(__link_module, mod, NR_CPUS);
+	stop_machine_run(__link_module, mod, NULL);
 
 	/* Size of section 0 is 0, so this works well if no params */
 	err = parse_args(mod->name, mod->args,
@@ -2223,7 +2223,7 @@ static struct module *load_module(void _
 	return mod;
 
  unlink:
-	stop_machine_run(__unlink_module, mod, NR_CPUS);
+	stop_machine_run(__unlink_module, mod, NULL);
 	module_arch_cleanup(mod);
  cleanup:
 	kobject_del(&mod->mkobj.kobj);
diff -r 277c5fb41d25 kernel/stop_machine.c
--- a/kernel/stop_machine.c	Tue Jul 08 12:57:33 2008 +1000
+++ b/kernel/stop_machine.c	Tue Jul 08 17:31:41 2008 +1000
@@ -100,7 +100,7 @@ static int chill(void *unused)
 	return 0;
 }
 
-int __stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu)
+int __stop_machine_run(int (*fn)(void *), void *data, const cpumask_t *cpus)
 {
 	int i, err;
 	struct stop_machine_data active, idle;
@@ -111,10 +111,6 @@ int __stop_machine_run(int (*fn)(void *)
 	active.fnret = 0;
 	idle.fn = chill;
 	idle.data = NULL;
-
-	/* If they don't care which cpu fn runs on, just pick one. */
-	if (cpu == NR_CPUS)
-		cpu = any_online_cpu(cpu_online_map);
 
 	/* This could be too big for stack on large machines. */
 	threads = kcalloc(NR_CPUS, sizeof(threads[0]), GFP_KERNEL);
@@ -128,13 +124,16 @@ int __stop_machine_run(int (*fn)(void *)
 	set_state(STOPMACHINE_PREPARE);
 
 	for_each_online_cpu(i) {
-		struct stop_machine_data *smdata;
+		struct stop_machine_data *smdata = &idle;
 		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
-		if (cpu == ALL_CPUS || i == cpu)
-			smdata = &active;
-		else
-			smdata = &idle;
+		if (!cpus) {
+			if (i == first_cpu(cpu_online_map))
+				smdata = &active;
+		} else {
+			if (cpu_isset(i, *cpus))
+				smdata = &active;
+		}
 
 		threads[i] = kthread_create(stop_cpu, smdata, "kstop%u", i);
 		if (IS_ERR(threads[i])) {
@@ -153,7 +152,7 @@ int __stop_machine_run(int (*fn)(void *)
 
 	/* We've created all the threads.  Wake them all: hold this CPU so one
 	 * doesn't hit this CPU until we're ready. */
-	cpu = get_cpu();
+	get_cpu();
 	for_each_online_cpu(i)
 		wake_up_process(threads[i]);
 
@@ -176,13 +175,13 @@ kill_threads:
 	return err;
 }
 
-int stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu)
+int stop_machine_run(int (*fn)(void *), void *data, const cpumask_t *cpus)
 {
 	int ret;
 
 	/* No CPUs can come up or down during this. */
 	get_online_cpus();
-	ret = __stop_machine_run(fn, data, cpu);
+	ret = __stop_machine_run(fn, data, cpus);
 	put_online_cpus();
 
 	return ret;
diff -r 277c5fb41d25 mm/page_alloc.c
--- a/mm/page_alloc.c	Tue Jul 08 12:57:33 2008 +1000
+++ b/mm/page_alloc.c	Tue Jul 08 17:31:41 2008 +1000
@@ -2356,7 +2356,7 @@ void build_all_zonelists(void)
 	} else {
 		/* we have to stop all cpus to guarantee there is no user
 		   of zonelist */
-		stop_machine_run(__build_all_zonelists, NULL, NR_CPUS);
+		stop_machine_run(__build_all_zonelists, NULL, NULL);
 		/* cpuset refresh routine should be here */
 	}
 	vm_total_pages = nr_free_pagecache_pages();
