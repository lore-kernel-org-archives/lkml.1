Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbZJXAhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbZJXAhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 20:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbZJXAhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 20:37:05 -0400
Received: from nschwmtas01p.mx.bigpond.com ([61.9.189.137]:16721 "EHLO
	nschwmtas01p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbZJXAhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 20:37:01 -0400
Message-ID: <4AE24C2E.70208@bigpond.net.au>
Date: Sat, 24 Oct 2009 10:37:02 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Pankaj Parakh <me.pankajparakh@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       XingChao Wang <wxc200@gmail.com>
Subject: Re: How to add scheduler
References: <27a8ee1b0910100017h75579306i42463e309bd26712@mail.gmail.com>	 <27a8ee1b0910100018g1207c5b1uf742677b55f2f99b@mail.gmail.com>	 <4AD27044.7030907@bigpond.net.au> <27a8ee1b0910230810x255702eepa17734514cbf525f@mail.gmail.com>
In-Reply-To: <27a8ee1b0910230810x255702eepa17734514cbf525f@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040100020901040302010600"
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at nschwotgx03p.mx.bigpond.com from [124.177.165.249] using ID pwil3058@bigpond.net.au at Sat, 24 Oct 2009 00:37:02 +0000
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150205.4AE24C30.00A7,ss=1,fgs=0
X-SIH-MSG-ID: oxgzE9D2TECznTh522DtQVUtlUy7/yU1v8pWRYIhuRsaSFjCvsbAQsymbaFFyJ6FhXpcSUnBLmMkc6zkV4zWuNm0Mb5RWrnj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040100020901040302010600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 24/10/09 01:10, Pankaj Parakh wrote:
> Hi Peter,
>
> Thanks for showing your interest, I am student and I am working on a
> project similar to yours i.e. to have a facility where in one can swap
> scheduler in run-time, but I am in very initial state of learning so I
> wanted to try a simple RR scheduler, objective of doing it is to learn
> about different interfaces in modular design(introduced from 2.6.23
> with CFS). I do not have any constraint with version of linux. I am
> ready to take part with you provided you do not have any issue.

No.  That's good.

I've attached two patches which contain the work I've done so far.  They 
should be applied in the following order:

define_prelim_cpu_pisch_drv.patch
implement_spbrr_cpu_pisch_dvr.patch

and will result in two schedulers: the default CFS 'fair' (cfs_fair) 
scheduler and a simple priority based round robin (spbrr) scheduler; 
being available for selection at boot time and run time.

To select a scheduler at boot time just add 'cpu_pisch=cfs_fair' or 
'cpu_pisch=spbrr' to the boot command line.

To select a scheduler at run time (as root) do:

echo -n 'cfs_fair' > /sys/kernel/cpu_pisch/name

or

echo -n 'spbrr' > /sys/kernel/cpu_pisch/name

The first step in adding your own scheduler would be to make a copy of 
the file kernel/cpu_pisch_spbrr.c and then modify it.  You will also 
need to modify:

kernel/sched.c
kernel/cpu_pisch_drv.c
kernel/Kconfig.cpu_pisch

Hopefully, the required changes are obvious.  If not don't hesitate to 
ask questions.  Also if you feel the need to modify the scheduler 
interface (defined in include/linux/cpu_pisch_drv.h) feel free BUT think 
very carefully about it and try not to make things too complex.

I am working on another scheduler (a simple entitlement based round 
robin (sebrr) scheduler) which I hope to have finished before I publicly 
release the patches.

If you wish to have your scheduler included just send it to me as a 
patch which applies on top of the ones that I've attached.

Cheers
Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce

--------------040100020901040302010600
Content-Type: text/x-patch;
 name="define_prelim_cpu_pisch_drv.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="define_prelim_cpu_pisch_drv.patch"

CPU_PISCH: Define preliminary CPU Plug In SCHeduler driver interface
to allow alternate schedulers for SCHED_NORMAL/SCHED_BATCH/SCHED_IDLE
policy tasks to be used in place of CFS's "fair" scheduler. This will
be expanded as necessary as schedulers are added.

Implement interface for CFS "fair" scheduler.

Signed-off-by: Peter Williams <pwil3058@bigpond.net.au>

diff --git a/include/linux/cpu_pisch_drv.h b/include/linux/cpu_pisch_drv.h
new file mode 100644
--- /dev/null
+++ b/include/linux/cpu_pisch_drv.h
@@ -0,0 +1,50 @@
+#ifndef _LINUX_CPU_PISCH_DRV_H
+#define _LINUX_CPU_PISCH_DRV_H
+/*
+ * include/linux/cpu_pisch_drv.h
+ * This contains the definition of the CPU Plug In SCHeduler driver
+ * struct, etc.
+ */
+#ifdef CONFIG_CPU_PISCH
+#include <linux/kobject.h>
+#include <linux/sched.h>
+
+#define pisch_const __read_mostly
+
+struct cfs_rq;
+
+/*
+ * This is the main scheduler driver struct.
+ */
+struct cpu_pisch_drv {
+	const char *name;
+	struct attribute **attrs;
+
+	void (*place_entity_after)(struct sched_entity *sea, struct sched_entity *seb);
+	int (*entity_before)(struct sched_entity *a, struct sched_entity *b);
+	s64 (*entity_key)(struct cfs_rq *, struct sched_entity *s);
+	void (*place_entity)(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial);
+	void (*rq_tick)(struct rq* rq);
+	u64 (*sched_slice)(struct cfs_rq *cfs_rq, struct sched_entity *se);
+	void (*update_curr)(struct cfs_rq *cfs_rq, struct sched_entity *curr, unsigned long delta_exec);
+	void (*swap_places)(struct sched_entity *sea, struct sched_entity *seb);
+	void (*inherit_place)(struct sched_entity *sea, struct sched_entity *seb);
+	int (*wakeup_preempt_entity)(struct sched_entity *curr, struct sched_entity *se);
+	void (*change_task_cpu)(struct task_struct *p, unsigned int old_cpu, unsigned int new_cpu);
+};
+
+extern const struct cpu_pisch_drv *cpu_pisch_drvp;
+
+static inline void cpu_pisch_printk_dev_name(void)
+{
+	printk("CPU_PISCH: Running with \"%s\" CPU scheduler.\n", cpu_pisch_drvp->name);
+}
+
+extern int cpu_pisch_drv_sysfs_init(void);
+#else
+#define pisch_const const
+static inline void cpu_pisch_printk_dev_name(void) {}
+static inline int cpu_pisch_drv_sysfs_init(void) { return 0; }
+#endif
+
+#endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1212,6 +1212,11 @@ struct sched_rt_entity {
 
 struct rcu_node;
 
+#ifdef CONFIG_CPU_PISCH
+struct cpu_pisch_task_data {
+};
+#endif
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1232,6 +1237,9 @@ struct task_struct {
 	const struct sched_class *sched_class;
 	struct sched_entity se;
 	struct sched_rt_entity rt;
+#ifdef CONFIG_CPU_PISCH
+	struct cpu_pisch_task_data cpu_pisch;
+#endif
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* list of struct preempt_notifier: */
diff --git a/init/Kconfig b/init/Kconfig
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -426,6 +426,8 @@ config LOG_BUF_SHIFT
 config HAVE_UNSTABLE_SCHED_CLOCK
 	bool
 
+source "kernel/Kconfig.cpu_pisch"
+
 config GROUP_SCHED
 	bool "Group CPU scheduler"
 	depends on EXPERIMENTAL
diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -70,6 +70,7 @@
 #include <linux/sfi.h>
 #include <linux/shmem_fs.h>
 #include <trace/boot.h>
+#include <linux/cpu_pisch_drv.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -688,6 +689,8 @@ asmlinkage void __init start_kernel(void
 
 	ftrace_init();
 
+	cpu_pisch_printk_dev_name();
+
 	/* Do the rest non-__init'ed, we're now alive */
 	rest_init();
 }
@@ -786,6 +789,7 @@ static void __init do_basic_setup(void)
 	init_irq_proc();
 	do_ctors();
 	do_initcalls();
+	cpu_pisch_drv_sysfs_init();
 }
 
 static void __init do_pre_smp_initcalls(void)
diff --git a/kernel/Kconfig.cpu_pisch b/kernel/Kconfig.cpu_pisch
new file mode 100644
--- /dev/null
+++ b/kernel/Kconfig.cpu_pisch
@@ -0,0 +1,55 @@
+
+menu "CPU schedulers"
+
+config CPU_PISCH
+	bool "Support multiple CPU schedulers"
+	default y
+	---help---
+	  Say y here if you wish to be able to make a boot time selection
+	  of which CPU scheduler to use.  The CPU scheduler to be used may
+	  then be selected with the boot parameter "cpu_pisch=".  In the
+          absence of such a command line parameter, the scheduler selected
+          at "Default CPU scheduler" will be used.
+
+	  The choice of which schedulers should be compiled into the
+	  kernel (and be available for boot time selection) can be made
+	  be enabling "Select which CPU schedulers to build in".
+
+	  If you say n here the single scheduler to be built into the
+	  kernel may be selected at "Default CPU scheduler".
+
+config CPU_PISCH_CHOOSE_BUILTINS
+	bool "Select which CPU schedulers to build in" if CPU_PISCH
+	default n
+	---help---
+	  Say y here if you want to be able to select which CPU schedulers
+	  are built into the kernel (for selection at boot time).
+
+config CPU_PISCH_CFS_FAIR
+	bool "'Completely Fair Scheduler' CPU scheduler" if CPU_PISCH_CHOOSE_BUILTINS
+	depends on CPU_PISCH
+	default CPU_PISCH
+	---help---
+	  This is the standard CPU scheduler which purports to model an
+	  "ideal, precise multi-tasking CPU".
+	  To boot this CPU scheduler, if it is not the default, use the
+	  boot parameter "cpu_pisch=cfs_fair".
+
+choice
+	prompt "Default CPU scheduler"
+	depends on CPU_PISCH
+	---help---
+	  This option allows you to choose which CPU scheduler shall be
+	  booted by default at startup if you have enabled CPU_PISCH,
+	  or it will select the only scheduler to be built in otherwise.
+
+config CPU_PISCH_DEFAULT_CFS_FAIR
+	bool "CFS Fair CPU scheduler"
+	select CPU_PISCH_CFS_FAIR
+	---help---
+	  This is the default CPU scheduler which is an O(1) model of an
+	  "ideal, precise multi-tasking CPU"..
+
+endchoice
+
+endmenu
diff --git a/kernel/cpu_pisch_drv.c b/kernel/cpu_pisch_drv.c
new file mode 100644
--- /dev/null
+++ b/kernel/cpu_pisch_drv.c
@@ -0,0 +1,120 @@
+/*
+ *  kernel/cpu_pisch_drv.c
+ *
+ *  Kernel CPU Plug In SCHeduler device implementation
+ */
+
+const struct cpu_pisch_drv *cpu_pisch_drvp =
+#if defined(CONFIG_CPU_PISCH_DEFAULT_CFS_FAIR)
+	&cfs_fair_cpu_pisch_drv;
+#else
+	NULL;
+#error "You must have at least 1 CPU scheduler selected"
+#endif
+
+const struct cpu_pisch_drv *cpu_pisch_drvs[] = {
+#if defined(CONFIG_CPU_PISCH_CFS_FAIR)
+	&cfs_fair_cpu_pisch_drv,
+#endif
+	NULL,
+};
+
+static const struct cpu_pisch_drv *cpu_pisch_get_drv(const char *str)
+{
+	int i;
+	const struct cpu_pisch_drv *drvp;
+
+	for (i = 0; (drvp = cpu_pisch_drvs[i]); i++)
+		if (!strcmp(str, drvp->name)) {
+			cpu_pisch_drvp = drvp;
+			return drvp;
+		}
+
+	return NULL;
+}
+
+static int __init cpu_pisch_drv_setup(char *str)
+{
+	const struct cpu_pisch_drv *drvp = cpu_pisch_get_drv(str);
+
+	if (drvp) {
+		cpu_pisch_drvp = drvp;
+		return 1;
+	}
+
+	printk("CPU_PISCH: Unknown scheduler: \"%s\"\n", str);
+
+	return 1;
+}
+
+__setup ("cpu_pisch=", cpu_pisch_drv_setup);
+
+/* Set up sysfs structures for CPU_PISCH data */
+
+static struct attribute_group cpu_pisch_attr_group = {
+	.name = "parameters",
+};
+
+static struct kobject *cpu_pisch_kobj;
+
+static ssize_t
+show_cpu_pisch_name(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n", cpu_pisch_drvp->name);
+}
+
+static ssize_t
+store_cpu_pisch_name(struct kobject *kobj, struct kobj_attribute *attr,
+			 const char *buf, size_t count)
+{
+	const struct cpu_pisch_drv *drvp = cpu_pisch_get_drv(buf);
+
+	if (drvp) {
+		int retval = 0;
+
+		sysfs_remove_group(cpu_pisch_kobj, &cpu_pisch_attr_group);
+		cpu_pisch_drvp = drvp;
+		cpu_pisch_attr_group.attrs = cpu_pisch_drvp->attrs;
+		retval = sysfs_create_group(cpu_pisch_kobj, &cpu_pisch_attr_group);
+		if (retval)
+			printk("CPU_PISCH: ERROR(%d): \"%s\"\n", retval, cpu_pisch_drvp->name);
+		printk("CPU_PISCH: Set scheduler: \"%s\"\n", cpu_pisch_drvp->name);
+		return count;
+	}
+
+	printk("CPU_PISCH: Unknown scheduler: \"%s\"\n", buf);
+
+	return count;
+}
+
+static struct kobj_attribute cpu_pisch_name_attribute =
+	__ATTR(name, S_IRUGO | S_IWUSR, show_cpu_pisch_name, store_cpu_pisch_name);
+
+int __init cpu_pisch_drv_sysfs_init(void)
+{
+	int retval = 0;
+
+	/*
+	 * Create a simple kobject with the name of "cpu_pisch",
+	 * located under /sys/kernel/
+	 */
+	cpu_pisch_kobj = kobject_create_and_add("cpu_pisch", kernel_kobj);
+	if (!cpu_pisch_kobj)
+		return -ENOMEM;
+
+	/* Create a file containing the name of the current scheduler */
+	retval = sysfs_create_file(cpu_pisch_kobj, &cpu_pisch_name_attribute.attr);
+
+	/* Create the files associated with the scheduler's parameters
+	 * in a subdirectory named "parameters"
+	 */
+	if (!retval && (cpu_pisch_drvp->attrs != NULL)) {
+		cpu_pisch_attr_group.attrs = cpu_pisch_drvp->attrs;
+		retval = sysfs_create_group(cpu_pisch_kobj, &cpu_pisch_attr_group);
+	}
+
+	if (retval)
+		kobject_put(cpu_pisch_kobj);
+
+	return retval;
+}
diff --git a/kernel/cpu_pisch_pvt.h b/kernel/cpu_pisch_pvt.h
new file mode 100644
--- /dev/null
+++ b/kernel/cpu_pisch_pvt.h
@@ -0,0 +1,50 @@
+#ifndef _LINUX_CPU_PISCH_PVT_H
+#define _LINUX_CPU_PISCH_PVT_H
+/*
+ * kernel/cpu_pisch_pvt.h
+ * This contains the code for use by CPU Plug In SCHedulers
+ */
+
+/*
+ * sysfs helper macros for scheduler attributes
+ */
+#define to_llu(a) ((unsigned long long)(a))
+#define to_lu(a) ((unsigned long)(a))
+#define to_u(a) ((unsigned int)(a))
+
+#define __CPU_PISCH_SYSFS_SHOW_UNSIGNED(aname, vname, convert_out) \
+static ssize_t \
+show_cpu_pisch_ ## aname(struct kobject *kobj, struct kobj_attribute* attr, char *buf) \
+{ \
+	return sprintf(buf, "%llu\n", convert_out(vname)); \
+}
+
+#define __CPU_PISCH_SYSFS_STORE_UNSIGNED(aname, vname, convert_in) \
+static ssize_t \
+store_cpu_pisch_ ## aname(struct kobject *kobj, struct kobj_attribute* attr, \
+			   const char *buf, size_t count) \
+{ \
+	unsigned long long var; \
+ \
+	sscanf(buf, "%llu", &var); \
+ \
+	vname = convert_in(var); \
+ \
+	return count; \
+}
+
+#define CPU_PISCH_SYSFS_DEFINE_UNSIGNED_RW(aname, vname, convert_out, convert_in) \
+__CPU_PISCH_SYSFS_SHOW_UNSIGNED(aname, vname, convert_out) \
+__CPU_PISCH_SYSFS_STORE_UNSIGNED(aname, vname, convert_in) \
+static struct kobj_attribute cpu_pisch_sysfs_ ## aname = \
+	__ATTR(aname, (S_IRUGO | S_IWUSR), show_cpu_pisch_ ## aname, store_cpu_pisch_ ## aname)
+
+#define CPU_PISCH_SYSFS_DEFINE_UNSIGNED_RO(aname, vname, convert_out) \
+__CPU_PISCH_SYSFS_SHOW_UNSIGNED(aname, vname, convert_out) \
+static struct kobj_attribute cpu_pisch_sysfs_ ## aname = \
+	__ATTR(aname, S_IRUGO, show_cpu_pisch_ ## aname, NULL)
+
+#define CPU_PISCH_SYSFS_ATTR(aname) \
+	(&((cpu_pisch_sysfs_ ## aname).attr))
+
+#endif
diff --git a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -515,6 +515,11 @@ static struct root_domain def_root_domai
 
 #endif
 
+#ifdef CONFIG_CPU_PISCH
+struct cpu_pisch_rq_data {
+};
+#endif
+
 /*
  * This is the main, per-CPU runqueue data structure.
  *
@@ -544,6 +549,9 @@ struct rq {
 	u64 nr_migrations_in;
 
 	struct cfs_rq cfs;
+#ifdef CONFIG_CPU_PISCH
+	struct cpu_pisch_rq_data cpu_pisch;
+#endif
 	struct rt_rq rt;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -1813,10 +1821,17 @@ static void cfs_rq_set_shares(struct cfs
 
 static void calc_load_account_active(struct rq *this_rq);
 
+#include <linux/cpu_pisch_drv.h>
 #include "sched_stats.h"
 #include "sched_idletask.c"
+#ifdef CONFIG_CPU_PISCH
+#include "cpu_pisch_pvt.h"
+#endif
 #include "sched_fair.c"
 #include "sched_rt.c"
+#ifdef CONFIG_CPU_PISCH
+#include "cpu_pisch_drv.c"
+#endif
 #ifdef CONFIG_SCHED_DEBUG
 # include "sched_debug.c"
 #endif
@@ -2030,8 +2045,10 @@ void set_task_cpu(struct task_struct *p,
 {
 	int old_cpu = task_cpu(p);
 	struct rq *old_rq = cpu_rq(old_cpu), *new_rq = cpu_rq(new_cpu);
+#ifndef CONFIG_CPU_PISCH
 	struct cfs_rq *old_cfsrq = task_cfs_rq(p),
 		      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
+#endif
 	u64 clock_offset;
 
 	clock_offset = old_rq->clock - new_rq->clock;
@@ -2056,8 +2073,13 @@ void set_task_cpu(struct task_struct *p,
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS,
 				     1, 1, NULL, 0);
 	}
+
+#ifdef CONFIG_CPU_PISCH
+	cpu_pisch_drvp->change_task_cpu(p, old_cpu, new_cpu);
+#else
 	p->se.vruntime -= old_cfsrq->min_vruntime -
 					 new_cfsrq->min_vruntime;
+#endif
 
 	__set_task_cpu(p, new_cpu);
 }
@@ -5200,6 +5222,10 @@ void scheduler_tick(void)
 	spin_lock(&rq->lock);
 	update_rq_clock(rq);
 	update_cpu_load(rq);
+#ifdef CONFIG_CPU_PISCH
+	if (cpu_pisch_drvp->rq_tick)
+		cpu_pisch_drvp->rq_tick(rq);
+#endif
 	curr->sched_class->task_tick(rq, curr, 0);
 	spin_unlock(&rq->lock);
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -276,11 +276,26 @@ static inline u64 min_vruntime(u64 min_v
 
 static inline int entity_before(struct sched_entity *a,
 				struct sched_entity *b)
+#ifdef CONFIG_CPU_PISCH
+{
+	return cpu_pisch_drvp->entity_before(a, b);
+}
+
+static inline int cfs_fair_entity_before(struct sched_entity *a,
+				struct sched_entity *b)
+#endif
 {
 	return (s64)(a->vruntime - b->vruntime) < 0;
 }
 
 static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
+#ifdef CONFIG_CPU_PISCH
+{
+	return cpu_pisch_drvp->entity_key(cfs_rq, se);
+}
+
+static inline s64 cfs_fair_entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
+#endif
 {
 	return se->vruntime - cfs_rq->min_vruntime;
 }
@@ -439,6 +454,13 @@ static u64 __sched_period(unsigned long 
  * s = p*P[w/rw]
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
+#ifdef CONFIG_CPU_PISCH
+{
+	return cpu_pisch_drvp->sched_slice(cfs_rq, se);
+}
+
+static u64 cfs_fair_sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
+#endif
 {
 	u64 slice = __sched_period(cfs_rq->nr_running + !se->on_rq);
 
@@ -478,12 +500,25 @@ static inline void
 __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 	      unsigned long delta_exec)
 {
+#ifndef CONFIG_CPU_PISCH
 	unsigned long delta_exec_weighted;
+#endif
 
 	schedstat_set(curr->exec_max, max((u64)delta_exec, curr->exec_max));
 
 	curr->sum_exec_runtime += delta_exec;
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
+#ifdef CONFIG_CPU_PISCH
+	cpu_pisch_drvp->update_curr(cfs_rq, curr, delta_exec);
+}
+
+static inline void
+cfs_fair_update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
+	      unsigned long delta_exec)
+{
+	unsigned long delta_exec_weighted;
+#endif
+
 	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
 	curr->vruntime += delta_exec_weighted;
 	update_min_vruntime(cfs_rq);
@@ -698,6 +733,14 @@ static void check_spread(struct cfs_rq *
 
 static void
 place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
+#ifdef CONFIG_CPU_PISCH
+{
+	cpu_pisch_drvp->place_entity(cfs_rq, se, initial);
+}
+
+static void
+cfs_fair_place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
+#endif
 {
 	u64 vruntime = cfs_rq->min_vruntime;
 
@@ -1064,9 +1107,20 @@ static void yield_task_fair(struct rq *r
 	 * Upon rescheduling, sched_class::put_prev_task() will place
 	 * 'current' within the tree based on its new key value.
 	 */
+#ifdef CONFIG_CPU_PISCH
+	cpu_pisch_drvp->place_entity_after(se, rightmost);
+#else
 	se->vruntime = rightmost->vruntime + 1;
+#endif
 }
 
+#ifdef CONFIG_CPU_PISCH
+static inline void cfs_fair_place_entity_after(struct sched_entity *sea, struct sched_entity *seb)
+{
+	sea->vruntime = seb->vruntime + 1;
+}
+#endif
+
 #ifdef CONFIG_SMP
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -1530,6 +1584,14 @@ wakeup_gran(struct sched_entity *curr, s
  */
 static int
 wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
+#ifdef CONFIG_CPU_PISCH
+{
+	return cpu_pisch_drvp->wakeup_preempt_entity(curr, se);
+}
+
+static int
+cfs_fair_wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
+#endif
 {
 	s64 gran, vdiff = curr->vruntime - se->vruntime;
 
@@ -1863,7 +1925,11 @@ static void task_new_fair(struct rq *rq,
 
 	update_curr(cfs_rq);
 	if (curr)
+#ifdef CONFIG_CPU_PISCH
+		cpu_pisch_drvp->inherit_place(se, curr);
+#else
 		se->vruntime = curr->vruntime;
+#endif
 	place_entity(cfs_rq, se, 1);
 
 	/* 'curr' will be NULL if the child belongs to a different group */
@@ -1873,13 +1939,29 @@ static void task_new_fair(struct rq *rq,
 		 * Upon rescheduling, sched_class::put_prev_task() will place
 		 * 'current' within the tree based on its new key value.
 		 */
+#ifdef CONFIG_CPU_PISCH
+		cpu_pisch_drvp->swap_places(curr, se);
+#else
 		swap(curr->vruntime, se->vruntime);
+#endif
 		resched_task(rq->curr);
 	}
 
 	enqueue_task_fair(rq, p, 0);
 }
 
+#ifdef CONFIG_CPU_PISCH
+static inline void cfs_fair_inherit_place(struct sched_entity *sea, struct sched_entity *seb)
+{
+	sea->vruntime = seb->vruntime;
+}
+
+static inline void cfs_fair_swap_places(struct sched_entity *sea, struct sched_entity *seb)
+{
+	swap(sea->vruntime, seb->vruntime);
+}
+#endif
+
 /*
  * Priority of the task has changed. Check to see if we preempt
  * the current task.
@@ -2004,3 +2086,35 @@ static void print_cfs_stats(struct seq_f
 	rcu_read_unlock();
 }
 #endif
+
+#ifdef CONFIG_CPU_PISCH
+#ifdef CONFIG_CPU_PISCH_CFS_FAIR
+static inline void
+cfs_fair_change_task_cpu(struct task_struct *p, unsigned int old_cpu, unsigned int new_cpu)
+{
+	struct cfs_rq *old_cfsrq = task_cfs_rq(p),
+		      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
+
+	p->se.vruntime -= old_cfsrq->min_vruntime -
+					 new_cfsrq->min_vruntime;
+}
+
+static struct attribute *cpu_pisch_cfs_fair_attrs[] = {
+	NULL,
+};
+
+static const struct cpu_pisch_drv cfs_fair_cpu_pisch_drv = {
+	.name = "cfs_fair",
+	.attrs = cpu_pisch_cfs_fair_attrs,
+	.entity_before = cfs_fair_entity_before,
+	.entity_key = cfs_fair_entity_key,
+	.place_entity = cfs_fair_place_entity,
+	.sched_slice = cfs_fair_sched_slice,
+	.update_curr = cfs_fair_update_curr,
+	.swap_places = cfs_fair_swap_places,
+	.inherit_place = cfs_fair_inherit_place,
+	.wakeup_preempt_entity = cfs_fair_wakeup_preempt_entity,
+	.change_task_cpu = cfs_fair_change_task_cpu,
+};
+#endif
+#endif

--------------040100020901040302010600
Content-Type: text/x-patch;
 name="implement_spbrr_cpu_pisch_dvr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="implement_spbrr_cpu_pisch_dvr.patch"

CPU_PISCH: Implement Simple Priority Based Round Robin (SPBRR) scheduler

Signed-off-by: Peter Williams <pwil3058@bigpond.net.au>

diff --git a/include/linux/sched.h b/include/linux/sched.h
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1214,6 +1214,9 @@ struct rcu_node;
 
 #ifdef CONFIG_CPU_PISCH
 struct cpu_pisch_task_data {
+#ifdef CONFIG_CPU_PISCH_SPBRR
+	s64 rq_key;
+#endif
 };
 #endif
 
diff --git a/kernel/Kconfig.cpu_pisch b/kernel/Kconfig.cpu_pisch
--- a/kernel/Kconfig.cpu_pisch
+++ b/kernel/Kconfig.cpu_pisch
@@ -35,6 +35,17 @@ config CPU_PISCH_CFS_FAIR
 	  To boot this CPU scheduler, if it is not the default, use the
 	  boot parameter "cpu_pisch=cfs_fair".
 
+config CPU_PISCH_SPBRR
+	bool "'Simple Priority Based Round Robin' CPU scheduler" if CPU_PISCH_CHOOSE_BUILTINS
+	depends on CPU_PISCH
+	default CPU_PISCH
+	---help---
+	  This is a simple priority based CPU scheduler where "nice"
+	  determines priority and tasks with the same priority round
+	  robin with each other with fixed time slices.
+	  To boot this CPU scheduler, if it is not the default, use the
+	  boot parameter "cpu_pisch=spbrr".
+
 choice
 	prompt "Default CPU scheduler"
 	depends on CPU_PISCH
@@ -50,6 +61,14 @@ config CPU_PISCH_DEFAULT_CFS_FAIR
 	  This is the default CPU scheduler which is an O(1) model of an
 	  "ideal, precise multi-tasking CPU"..
 
+config CPU_PISCH_DEFAULT_SPBRR
+	bool "Simple Priority Based Round Robin CPU scheduler"
+	select CPU_PISCH_SPBRR
+	---help---
+	  This is a simple priority based CPU scheduler where "nice"
+	  determines priority and tasks with the same priority round
+	  robin with each other with fixed time slices.
+
 endchoice
 
 endmenu
diff --git a/kernel/cpu_pisch_drv.c b/kernel/cpu_pisch_drv.c
--- a/kernel/cpu_pisch_drv.c
+++ b/kernel/cpu_pisch_drv.c
@@ -7,6 +7,8 @@
 const struct cpu_pisch_drv *cpu_pisch_drvp =
 #if defined(CONFIG_CPU_PISCH_DEFAULT_CFS_FAIR)
 	&cfs_fair_cpu_pisch_drv;
+#elif defined(CONFIG_CPU_PISCH_DEFAULT_SPBRR)
+	&spbrr_cpu_pisch_drv;
 #else
 	NULL;
 #error "You must have at least 1 CPU scheduler selected"
@@ -16,6 +18,9 @@ const struct cpu_pisch_drv *cpu_pisch_dr
 #if defined(CONFIG_CPU_PISCH_CFS_FAIR)
 	&cfs_fair_cpu_pisch_drv,
 #endif
+#if defined(CONFIG_CPU_PISCH_SPBRR)
+	&spbrr_cpu_pisch_drv,
+#endif
 	NULL,
 };
 
diff --git a/kernel/cpu_pisch_spbrr.c b/kernel/cpu_pisch_spbrr.c
new file mode 100644
--- /dev/null
+++ b/kernel/cpu_pisch_spbrr.c
@@ -0,0 +1,167 @@
+/*
+ * Simple Priority Based Round Robin (SPBRR) Scheduling Class
+ * (SCHED_NORMAL/SCHED_BATCH)
+ *
+ *  Copyright (C) 2009 Peter Williams <pwil3058@bigpond.net.au>
+ */
+
+/*
+ * Time slice for round robinning of SCHED_NORMAL/SCHED_BATCH tasks
+ * default: 20ms (units: nanoseconds)
+ */
+unsigned int spbrr_time_slice = 20000000ULL;
+
+/*
+ * Extra amount to add to nr_running when mustiplying spbrr_time_slice
+ * to determine the interval between anti starvation boosts
+ * default : 2
+ */
+unsigned int spbrr_as_factor = 2;
+
+static const struct sched_class spbrr_sched_class;
+
+static inline
+void spbrr_set_task_rq_key(struct task_struct *p, struct rq *rq)
+{
+	p->cpu_pisch.rq_key = p->prio * 2 + rq->cpu_pisch.key_offset +
+		(p->policy != SCHED_NORMAL);
+}
+
+static inline
+void spbrr_set_se_rq_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	spbrr_set_task_rq_key(task_of(se), rq_of(cfs_rq));
+}
+
+static inline
+void spbrr_place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
+{
+	if (entity_is_task(se))
+		spbrr_set_se_rq_key(cfs_rq, se);
+	else
+		cfs_fair_place_entity(cfs_rq, se, initial);
+}
+
+static inline
+void spbrr_place_entity_after(struct sched_entity *sea, struct sched_entity *seb)
+{
+	if (entity_is_task(sea))
+		task_of(sea)->cpu_pisch.rq_key = task_of(seb)->cpu_pisch.rq_key + 1;
+	else
+		cfs_fair_place_entity_after(sea, seb);
+}
+
+static inline
+int spbrr_entity_before(struct sched_entity *a, struct sched_entity *b)
+{
+	/* only ever used on tasks so no need for complications */
+	return task_of(a)->cpu_pisch.rq_key < task_of(b)->cpu_pisch.rq_key;
+}
+
+static inline
+s64 spbrr_entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	if (entity_is_task(se))
+		return task_of(se)->cpu_pisch.rq_key;
+	else
+		return cfs_fair_entity_key(cfs_rq, se);
+}
+
+static inline
+void spbrr_rq_tick(struct rq* rq)
+{
+	if (rq->nr_running < 2) {
+		rq->cpu_pisch.key_offset_last_update = rq->clock;
+		rq->cpu_pisch.key_offset = 0;
+	}
+	else {
+		u64 difftime = rq->clock - rq->cpu_pisch.key_offset_last_update;
+
+		if (difftime > spbrr_time_slice * (rq->nr_running + spbrr_as_factor) / 2) {
+			rq->cpu_pisch.key_offset_last_update = rq->clock;
+			rq->cpu_pisch.key_offset++;
+		}
+	}
+}
+
+static inline
+u64 spbrr_sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	if (entity_is_task(se))
+		return spbrr_time_slice;
+	else
+		return cfs_fair_sched_slice(cfs_rq, se);
+}
+
+static inline void
+spbrr_update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
+	      unsigned long delta_exec)
+{
+	if (!entity_is_task(curr))
+		cfs_fair_update_curr(cfs_rq, curr, delta_exec);
+
+	spbrr_set_se_rq_key(cfs_rq, curr);
+}
+
+static inline
+void spbrr_swap_places(struct sched_entity *sea, struct sched_entity *seb)
+{
+	if (entity_is_task(sea))
+		swap(task_of(sea)->cpu_pisch.rq_key, task_of(seb)->cpu_pisch.rq_key);
+	else
+		cfs_fair_swap_places(sea, seb);
+}
+
+static inline
+void spbrr_inherit_place(struct sched_entity *sea, struct sched_entity *seb)
+{
+	if (entity_is_task(sea))
+		task_of(sea)->cpu_pisch.rq_key = task_of(seb)->cpu_pisch.rq_key;
+	else
+		cfs_fair_inherit_place(sea, seb);
+}
+
+static inline int
+spbrr_wakeup_preempt_entity(struct sched_entity *sea, struct sched_entity *seb)
+{
+	if (!entity_is_task(sea))
+		return cfs_fair_wakeup_preempt_entity(sea, seb);
+
+	if (task_of(sea)->cpu_pisch.rq_key <= task_of(seb)->cpu_pisch.rq_key)
+		return -1;
+
+	return 1;
+}
+
+static inline void
+spbrr_change_task_cpu(struct task_struct *p, unsigned int old_cpu, unsigned int new_cpu)
+{
+	spbrr_set_task_rq_key(p, cpu_rq(new_cpu));
+}
+
+#define asis(x) ((unsigned long long)x)
+
+CPU_PISCH_SYSFS_DEFINE_UNSIGNED_RW(time_slice_ns, spbrr_time_slice, asis, asis);
+CPU_PISCH_SYSFS_DEFINE_UNSIGNED_RW(as_factor, spbrr_as_factor, asis, asis);
+
+static struct attribute *cpu_pisch_spbrr_attrs[] = {
+	CPU_PISCH_SYSFS_ATTR(time_slice_ns),
+	CPU_PISCH_SYSFS_ATTR(as_factor),
+	NULL,
+};
+
+static const struct cpu_pisch_drv spbrr_cpu_pisch_drv = {
+	.name = "spbrr",
+	.attrs = cpu_pisch_spbrr_attrs,
+	.place_entity_after = spbrr_place_entity_after,
+	.entity_before = spbrr_entity_before,
+	.entity_key = spbrr_entity_key,
+	.place_entity = spbrr_place_entity,
+	.sched_slice = spbrr_sched_slice,
+	.update_curr = spbrr_update_curr,
+	.rq_tick = spbrr_rq_tick,
+	.swap_places = spbrr_swap_places,
+	.inherit_place = spbrr_inherit_place,
+	.wakeup_preempt_entity = spbrr_wakeup_preempt_entity,
+	.change_task_cpu = spbrr_change_task_cpu,
+};
diff --git a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -517,6 +517,10 @@ static struct root_domain def_root_domai
 
 #ifdef CONFIG_CPU_PISCH
 struct cpu_pisch_rq_data {
+#ifdef CONFIG_CPU_PISCH_SPBRR
+	s64 key_offset;
+	u64 key_offset_last_update;
+#endif
 };
 #endif
 
@@ -1830,6 +1834,9 @@ static void calc_load_account_active(str
 #include "sched_fair.c"
 #include "sched_rt.c"
 #ifdef CONFIG_CPU_PISCH
+#ifdef CONFIG_CPU_PISCH_SPBRR
+#include "cpu_pisch_spbrr.c"
+#endif
 #include "cpu_pisch_drv.c"
 #endif
 #ifdef CONFIG_SCHED_DEBUG

--------------040100020901040302010600--
