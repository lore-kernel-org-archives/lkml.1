Return-Path: <linux-kernel-owner+w=401wt.eu-S1752382AbYLYMuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbYLYMuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 07:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbYLYMu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 07:50:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38084 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbYLYMuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 07:50:22 -0500
Date: Thu, 25 Dec 2008 13:50:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler updates for v2.6.29
Message-ID: <20081225125005.GA20907@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-core-for-linus

A pretty quiet cycle for scheduler changes, with just three active topics:

   sched/core       sched/debug       sched/rt

[ There's more 'dependent' scheduler changes in the cpus4096 tree. ]

Thanks,

	Ingo

------------------>
Alexey Dobriyan (1):
      sched: move double_unlock_balance() higher

Arun R Bharadwaj (1):
      sched: add uid information to sched_debug for CONFIG_USER_SCHED

Bharata B Rao (3):
      sched: include group statistics in /proc/sched_debug
      sched: add hierarchical accounting to cpu accounting controller
      sched: use RCU variant of list traversal in for_each_leaf_rt_rq()

Dhaval Giani (1):
      sched/rt: removed unneeded defintion

Dimitri Sivanich (1):
      sched/rt: small optimization to update_curr_rt()

Heiko Carstens (2):
      sched: let arch_update_cpu_topology indicate if topology changed
      sched: add missing arch_update_cpu_topology() call

Ingo Molnar (2):
      sched: rename SCHED_NO_NO_OMIT_FRAME_POINTER => SCHED_OMIT_FRAME_POINTER
      sched: fix warning in fs/proc/base.c

Ken Chen (6):
      x86, sched: enable wchan config menu item on 64-bit
      sched: fix inconsistency when redistribute per-cpu tg->cfs_rq shares
      sched: fix sd_parent_degenerate on non-numa smp machine
      sched, cpuacct: refactoring cpuusage_read / cpuusage_write
      sched, cpuacct: export percpu cpuacct cgroup stats
      schedstat: consolidate per-task cpu runtime stats

Li Zefan (7):
      sched: cleanup for alloc_rt/fair_sched_group()
      sched: switch sched_features to seqfile
      sched debug: remove sd_level_to_string()
      sched debug: remove NULL checking in print_cfs/rt_rq()
      sched: remove redundant call to unregister_sched_domain_sysctl()
      sched: add sanity check in partition_sched_domains()
      sched: clean up SCHED_CPUMASK_ALLOC

Mike Galbraith (1):
      sched: fix wakeup preemption clock

Peter Zijlstra (2):
      sched, ftrace: trace sched.c
      sched: optimize update_curr()

Randy Dunlap (1):
      sched, documentation: update scheduler header file paths

Sripathi Kodi (1):
      sched, lockdep: inline double_unlock_balance()

Vaidyanathan Srinivasan (1):
      sched: idle_balance() does not call load_balance_newidle()

Vegard Nossum (1):
      sched: update comment for move_task_off_dead_cpu


 Documentation/controllers/cpuacct.txt  |   32 +++
 Documentation/scheduler/sched-arch.txt |    4 +-
 arch/ia64/Kconfig                      |    2 +-
 arch/m32r/Kconfig                      |    2 +-
 arch/mips/Kconfig                      |    2 +-
 arch/powerpc/Kconfig                   |    2 +-
 arch/s390/kernel/topology.c            |    5 +-
 arch/x86/Kconfig                       |    4 +-
 fs/proc/base.c                         |    4 +-
 include/asm-m32r/system.h              |    2 +-
 include/linux/sched.h                  |    6 +-
 include/linux/topology.h               |    2 +-
 kernel/Makefile                        |    3 +-
 kernel/delayacct.c                     |    2 +-
 kernel/sched.c                         |  367 +++++++++++++++++---------------
 kernel/sched_debug.c                   |   57 ++++--
 kernel/sched_fair.c                    |    9 +-
 kernel/sched_rt.c                      |    9 +-
 kernel/sched_stats.h                   |    5 +-
 kernel/user.c                          |    2 +
 20 files changed, 299 insertions(+), 222 deletions(-)
 create mode 100644 Documentation/controllers/cpuacct.txt

diff --git a/Documentation/controllers/cpuacct.txt b/Documentation/controllers/cpuacct.txt
new file mode 100644
index 0000000..bb775fb
--- /dev/null
+++ b/Documentation/controllers/cpuacct.txt
@@ -0,0 +1,32 @@
+CPU Accounting Controller
+-------------------------
+
+The CPU accounting controller is used to group tasks using cgroups and
+account the CPU usage of these groups of tasks.
+
+The CPU accounting controller supports multi-hierarchy groups. An accounting
+group accumulates the CPU usage of all of its child groups and the tasks
+directly present in its group.
+
+Accounting groups can be created by first mounting the cgroup filesystem.
+
+# mkdir /cgroups
+# mount -t cgroup -ocpuacct none /cgroups
+
+With the above step, the initial or the parent accounting group
+becomes visible at /cgroups. At bootup, this group includes all the
+tasks in the system. /cgroups/tasks lists the tasks in this cgroup.
+/cgroups/cpuacct.usage gives the CPU time (in nanoseconds) obtained by
+this group which is essentially the CPU time obtained by all the tasks
+in the system.
+
+New accounting groups can be created under the parent group /cgroups.
+
+# cd /cgroups
+# mkdir g1
+# echo $$ > g1
+
+The above steps create a new group g1 and move the current shell
+process (bash) into it. CPU time consumed by this bash and its children
+can be obtained from g1/cpuacct.usage and the same is accumulated in
+/cgroups/cpuacct.usage also.
diff --git a/Documentation/scheduler/sched-arch.txt b/Documentation/scheduler/sched-arch.txt
index 941615a..d43dbcb 100644
--- a/Documentation/scheduler/sched-arch.txt
+++ b/Documentation/scheduler/sched-arch.txt
@@ -8,7 +8,7 @@ Context switch
 By default, the switch_to arch function is called with the runqueue
 locked. This is usually not a problem unless switch_to may need to
 take the runqueue lock. This is usually due to a wake up operation in
-the context switch. See include/asm-ia64/system.h for an example.
+the context switch. See arch/ia64/include/asm/system.h for an example.
 
 To request the scheduler call switch_to with the runqueue unlocked,
 you must `#define __ARCH_WANT_UNLOCKED_CTXSW` in a header file
@@ -23,7 +23,7 @@ disabled. Interrupts may be enabled over the call if it is likely to
 introduce a significant interrupt latency by adding the line
 `#define __ARCH_WANT_INTERRUPTS_ON_CTXSW` in the same place as for
 unlocked context switches. This define also implies
-`__ARCH_WANT_UNLOCKED_CTXSW`. See include/asm-arm/system.h for an
+`__ARCH_WANT_UNLOCKED_CTXSW`. See arch/arm/include/asm/system.h for an
 example.
 
 
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 6bd91ed..7fa8f61 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -99,7 +99,7 @@ config GENERIC_IOMAP
 	bool
 	default y
 
-config SCHED_NO_NO_OMIT_FRAME_POINTER
+config SCHED_OMIT_FRAME_POINTER
 	bool
 	default y
 
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index dbaed4a..29047d5 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -273,7 +273,7 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config SCHED_NO_NO_OMIT_FRAME_POINTER
+config SCHED_OMIT_FRAME_POINTER
         bool
         default y
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index f4af967..a5255e7 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -653,7 +653,7 @@ config GENERIC_CMOS_UPDATE
 	bool
 	default y
 
-config SCHED_NO_NO_OMIT_FRAME_POINTER
+config SCHED_OMIT_FRAME_POINTER
 	bool
 	default y
 
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 525c13a..adb23ea 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -141,7 +141,7 @@ config GENERIC_NVRAM
 	bool
 	default y if PPC32
 
-config SCHED_NO_NO_OMIT_FRAME_POINTER
+config SCHED_OMIT_FRAME_POINTER
 	bool
 	default y
 
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index a947899..bf96f1b 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -212,7 +212,7 @@ static void update_cpu_core_map(void)
 		cpu_core_map[cpu] = cpu_coregroup_map(cpu);
 }
 
-void arch_update_cpu_topology(void)
+int arch_update_cpu_topology(void)
 {
 	struct tl_info *info = tl_info;
 	struct sys_device *sysdev;
@@ -221,7 +221,7 @@ void arch_update_cpu_topology(void)
 	if (!machine_has_topology) {
 		update_cpu_core_map();
 		topology_update_polarization_simple();
-		return;
+		return 0;
 	}
 	stsi(info, 15, 1, 2);
 	tl_to_cores(info);
@@ -230,6 +230,7 @@ void arch_update_cpu_topology(void)
 		sysdev = get_cpu_sysdev(cpu);
 		kobject_uevent(&sysdev->kobj, KOBJ_CHANGE);
 	}
+	return 1;
 }
 
 static void topology_work_fn(struct work_struct *work)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ac22bb7..7b7d276 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -367,10 +367,10 @@ config X86_RDC321X
 	  as R-8610-(G).
 	  If you don't have one of these chips, you should say N here.
 
-config SCHED_NO_NO_OMIT_FRAME_POINTER
+config SCHED_OMIT_FRAME_POINTER
 	def_bool y
 	prompt "Single-depth WCHAN output"
-	depends on X86_32
+	depends on X86
 	help
 	  Calculate simpler /proc/<PID>/wchan values. If this option
 	  is disabled then wchan values will recurse back to the
diff --git a/fs/proc/base.c b/fs/proc/base.c
index d467760..a48200c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -347,8 +347,8 @@ static int proc_pid_wchan(struct task_struct *task, char *buffer)
 static int proc_pid_schedstat(struct task_struct *task, char *buffer)
 {
 	return sprintf(buffer, "%llu %llu %lu\n",
-			task->sched_info.cpu_time,
-			task->sched_info.run_delay,
+			(unsigned long long)task->se.sum_exec_runtime,
+			(unsigned long long)task->sched_info.run_delay,
 			task->sched_info.pcount);
 }
 #endif
diff --git a/include/asm-m32r/system.h b/include/asm-m32r/system.h
index 70a57c8..c980f5b 100644
--- a/include/asm-m32r/system.h
+++ b/include/asm-m32r/system.h
@@ -23,7 +23,7 @@
  */
 
 #if defined(CONFIG_FRAME_POINTER) || \
-	!defined(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER)
+	!defined(CONFIG_SCHED_OMIT_FRAME_POINTER)
 #define M32R_PUSH_FP "	push fp\n"
 #define M32R_POP_FP  "	pop  fp\n"
 #else
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 55e30d1..2d1e840 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -259,8 +259,6 @@ static inline int select_nohz_load_balancer(int cpu)
 }
 #endif
 
-extern unsigned long rt_needs_cpu(int cpu);
-
 /*
  * Only dump TASK_* tasks. (0 for all tasks)
  */
@@ -672,8 +670,7 @@ struct reclaim_state;
 struct sched_info {
 	/* cumulative counters */
 	unsigned long pcount;	      /* # of times run on this cpu */
-	unsigned long long cpu_time,  /* time spent on the cpu */
-			   run_delay; /* time spent waiting on a runqueue */
+	unsigned long long run_delay; /* time spent waiting on a runqueue */
 
 	/* timestamps */
 	unsigned long long last_arrival,/* when we last ran on a cpu */
@@ -2224,6 +2221,7 @@ extern void normalize_rt_tasks(void);
 extern struct task_group init_task_group;
 #ifdef CONFIG_USER_SCHED
 extern struct task_group root_task_group;
+extern void set_tg_uid(struct user_struct *user);
 #endif
 
 extern struct task_group *sched_create_group(struct task_group *parent);
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 117f1b7..0c5b5ac 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -49,7 +49,7 @@
 	for_each_online_node(node)			\
 		if (nr_cpus_node(node))
 
-void arch_update_cpu_topology(void);
+int arch_update_cpu_topology(void);
 
 /* Conform to ACPI 2.0 SLIT distance definitions */
 #define LOCAL_DISTANCE		10
diff --git a/kernel/Makefile b/kernel/Makefile
index 19fad00..6a212b8 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -19,7 +19,6 @@ CFLAGS_REMOVE_mutex-debug.o = -pg
 CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
-CFLAGS_REMOVE_sched.o = -pg
 endif
 
 obj-$(CONFIG_FREEZER) += freezer.o
@@ -90,7 +89,7 @@ obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 
-ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
+ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
 # needed for x86 only.  Why this used to be enabled for all architectures is beyond
 # me.  I suspect most platforms don't need this, but until we know that for sure
diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index b3179da..abb6e17 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -127,7 +127,7 @@ int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 	 */
 	t1 = tsk->sched_info.pcount;
 	t2 = tsk->sched_info.run_delay;
-	t3 = tsk->sched_info.cpu_time;
+	t3 = tsk->se.sum_exec_runtime;
 
 	d->cpu_count += t1;
 
diff --git a/kernel/sched.c b/kernel/sched.c
index e4bb1dd..fd835fc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -261,6 +261,10 @@ struct task_group {
 	struct cgroup_subsys_state css;
 #endif
 
+#ifdef CONFIG_USER_SCHED
+	uid_t uid;
+#endif
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* schedulable entities of this group on each cpu */
 	struct sched_entity **se;
@@ -286,6 +290,12 @@ struct task_group {
 
 #ifdef CONFIG_USER_SCHED
 
+/* Helper function to pass uid information to create_sched_user() */
+void set_tg_uid(struct user_struct *user)
+{
+	user->tg->uid = user->uid;
+}
+
 /*
  * Root task group.
  * 	Every UID task group (including init_task_group aka UID-0) will
@@ -586,6 +596,8 @@ struct rq {
 #ifdef CONFIG_SCHEDSTATS
 	/* latency stats */
 	struct sched_info rq_sched_info;
+	unsigned long long rq_cpu_time;
+	/* could above be rq->cfs_rq.exec_clock + rq->rt_rq.rt_runtime ? */
 
 	/* sys_sched_yield() stats */
 	unsigned int yld_exp_empty;
@@ -703,45 +715,18 @@ static __read_mostly char *sched_feat_names[] = {
 
 #undef SCHED_FEAT
 
-static int sched_feat_open(struct inode *inode, struct file *filp)
-{
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
-static ssize_t
-sched_feat_read(struct file *filp, char __user *ubuf,
-		size_t cnt, loff_t *ppos)
+static int sched_feat_show(struct seq_file *m, void *v)
 {
-	char *buf;
-	int r = 0;
-	int len = 0;
 	int i;
 
 	for (i = 0; sched_feat_names[i]; i++) {
-		len += strlen(sched_feat_names[i]);
-		len += 4;
-	}
-
-	buf = kmalloc(len + 2, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	for (i = 0; sched_feat_names[i]; i++) {
-		if (sysctl_sched_features & (1UL << i))
-			r += sprintf(buf + r, "%s ", sched_feat_names[i]);
-		else
-			r += sprintf(buf + r, "NO_%s ", sched_feat_names[i]);
+		if (!(sysctl_sched_features & (1UL << i)))
+			seq_puts(m, "NO_");
+		seq_printf(m, "%s ", sched_feat_names[i]);
 	}
+	seq_puts(m, "\n");
 
-	r += sprintf(buf + r, "\n");
-	WARN_ON(r >= len + 2);
-
-	r = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
-
-	kfree(buf);
-
-	return r;
+	return 0;
 }
 
 static ssize_t
@@ -786,10 +771,17 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static int sched_feat_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, sched_feat_show, NULL);
+}
+
 static struct file_operations sched_feat_fops = {
-	.open	= sched_feat_open,
-	.read	= sched_feat_read,
-	.write	= sched_feat_write,
+	.open		= sched_feat_open,
+	.write		= sched_feat_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
 };
 
 static __init int sched_init_debug(void)
@@ -1474,27 +1466,13 @@ static void
 update_group_shares_cpu(struct task_group *tg, int cpu,
 			unsigned long sd_shares, unsigned long sd_rq_weight)
 {
-	int boost = 0;
 	unsigned long shares;
 	unsigned long rq_weight;
 
 	if (!tg->se[cpu])
 		return;
 
-	rq_weight = tg->cfs_rq[cpu]->load.weight;
-
-	/*
-	 * If there are currently no tasks on the cpu pretend there is one of
-	 * average load so that when a new task gets to run here it will not
-	 * get delayed by group starvation.
-	 */
-	if (!rq_weight) {
-		boost = 1;
-		rq_weight = NICE_0_LOAD;
-	}
-
-	if (unlikely(rq_weight > sd_rq_weight))
-		rq_weight = sd_rq_weight;
+	rq_weight = tg->cfs_rq[cpu]->rq_weight;
 
 	/*
 	 *           \Sum shares * rq_weight
@@ -1502,7 +1480,7 @@ update_group_shares_cpu(struct task_group *tg, int cpu,
 	 *               \Sum rq_weight
 	 *
 	 */
-	shares = (sd_shares * rq_weight) / (sd_rq_weight + 1);
+	shares = (sd_shares * rq_weight) / sd_rq_weight;
 	shares = clamp_t(unsigned long, shares, MIN_SHARES, MAX_SHARES);
 
 	if (abs(shares - tg->se[cpu]->load.weight) >
@@ -1511,11 +1489,7 @@ update_group_shares_cpu(struct task_group *tg, int cpu,
 		unsigned long flags;
 
 		spin_lock_irqsave(&rq->lock, flags);
-		/*
-		 * record the actual number of shares, not the boosted amount.
-		 */
-		tg->cfs_rq[cpu]->shares = boost ? 0 : shares;
-		tg->cfs_rq[cpu]->rq_weight = rq_weight;
+		tg->cfs_rq[cpu]->shares = shares;
 
 		__set_se_shares(tg->se[cpu], shares);
 		spin_unlock_irqrestore(&rq->lock, flags);
@@ -1529,13 +1503,23 @@ update_group_shares_cpu(struct task_group *tg, int cpu,
  */
 static int tg_shares_up(struct task_group *tg, void *data)
 {
-	unsigned long rq_weight = 0;
+	unsigned long weight, rq_weight = 0;
 	unsigned long shares = 0;
 	struct sched_domain *sd = data;
 	int i;
 
 	for_each_cpu_mask(i, sd->span) {
-		rq_weight += tg->cfs_rq[i]->load.weight;
+		/*
+		 * If there are currently no tasks on the cpu pretend there
+		 * is one of average load so that when a new task gets to
+		 * run here it will not get delayed by group starvation.
+		 */
+		weight = tg->cfs_rq[i]->load.weight;
+		if (!weight)
+			weight = NICE_0_LOAD;
+
+		tg->cfs_rq[i]->rq_weight = weight;
+		rq_weight += weight;
 		shares += tg->cfs_rq[i]->shares;
 	}
 
@@ -1545,9 +1529,6 @@ static int tg_shares_up(struct task_group *tg, void *data)
 	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
 		shares = tg->shares;
 
-	if (!rq_weight)
-		rq_weight = cpus_weight(sd->span) * NICE_0_LOAD;
-
 	for_each_cpu_mask(i, sd->span)
 		update_group_shares_cpu(tg, i, shares, rq_weight);
 
@@ -1612,6 +1593,39 @@ static inline void update_shares_locked(struct rq *rq, struct sched_domain *sd)
 
 #endif
 
+/*
+ * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
+ */
+static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
+	__releases(this_rq->lock)
+	__acquires(busiest->lock)
+	__acquires(this_rq->lock)
+{
+	int ret = 0;
+
+	if (unlikely(!irqs_disabled())) {
+		/* printk() doesn't work good under rq->lock */
+		spin_unlock(&this_rq->lock);
+		BUG_ON(1);
+	}
+	if (unlikely(!spin_trylock(&busiest->lock))) {
+		if (busiest < this_rq) {
+			spin_unlock(&this_rq->lock);
+			spin_lock(&busiest->lock);
+			spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
+			ret = 1;
+		} else
+			spin_lock_nested(&busiest->lock, SINGLE_DEPTH_NESTING);
+	}
+	return ret;
+}
+
+static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
+	__releases(busiest->lock)
+{
+	spin_unlock(&busiest->lock);
+	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
+}
 #endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -2254,6 +2268,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 
 	smp_wmb();
 	rq = task_rq_lock(p, &flags);
+	update_rq_clock(rq);
 	old_state = p->state;
 	if (!(old_state & state))
 		goto out;
@@ -2311,7 +2326,6 @@ out_activate:
 		schedstat_inc(p, se.nr_wakeups_local);
 	else
 		schedstat_inc(p, se.nr_wakeups_remote);
-	update_rq_clock(rq);
 	activate_task(rq, p, 1);
 	success = 1;
 
@@ -2812,40 +2826,6 @@ static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
 }
 
 /*
- * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
- */
-static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(this_rq->lock)
-	__acquires(busiest->lock)
-	__acquires(this_rq->lock)
-{
-	int ret = 0;
-
-	if (unlikely(!irqs_disabled())) {
-		/* printk() doesn't work good under rq->lock */
-		spin_unlock(&this_rq->lock);
-		BUG_ON(1);
-	}
-	if (unlikely(!spin_trylock(&busiest->lock))) {
-		if (busiest < this_rq) {
-			spin_unlock(&this_rq->lock);
-			spin_lock(&busiest->lock);
-			spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
-			ret = 1;
-		} else
-			spin_lock_nested(&busiest->lock, SINGLE_DEPTH_NESTING);
-	}
-	return ret;
-}
-
-static void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(busiest->lock)
-{
-	spin_unlock(&busiest->lock);
-	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
-}
-
-/*
  * If dest_cpu is allowed for this process, migrate the task to it.
  * This is accomplished by forcing the cpu_allowed mask to only
  * allow dest_cpu, which will force the cpu onto dest_cpu. Then
@@ -3707,7 +3687,7 @@ out_balanced:
 static void idle_balance(int this_cpu, struct rq *this_rq)
 {
 	struct sched_domain *sd;
-	int pulled_task = -1;
+	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
 	cpumask_t tmpmask;
 
@@ -6126,7 +6106,6 @@ static int __migrate_task_irq(struct task_struct *p, int src_cpu, int dest_cpu)
 
 /*
  * Figure out where task on dead CPU should go, use force if necessary.
- * NOTE: interrupts should be disabled by the caller
  */
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
@@ -6638,28 +6617,6 @@ early_initcall(migration_init);
 
 #ifdef CONFIG_SCHED_DEBUG
 
-static inline const char *sd_level_to_string(enum sched_domain_level lvl)
-{
-	switch (lvl) {
-	case SD_LV_NONE:
-			return "NONE";
-	case SD_LV_SIBLING:
-			return "SIBLING";
-	case SD_LV_MC:
-			return "MC";
-	case SD_LV_CPU:
-			return "CPU";
-	case SD_LV_NODE:
-			return "NODE";
-	case SD_LV_ALLNODES:
-			return "ALLNODES";
-	case SD_LV_MAX:
-			return "MAX";
-
-	}
-	return "MAX";
-}
-
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 				  cpumask_t *groupmask)
 {
@@ -6679,8 +6636,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		return -1;
 	}
 
-	printk(KERN_CONT "span %s level %s\n",
-		str, sd_level_to_string(sd->level));
+	printk(KERN_CONT "span %s level %s\n", str, sd->name);
 
 	if (!cpu_isset(cpu, sd->span)) {
 		printk(KERN_ERR "ERROR: domain->span does not contain "
@@ -6816,6 +6772,8 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 				SD_BALANCE_EXEC |
 				SD_SHARE_CPUPOWER |
 				SD_SHARE_PKG_RESOURCES);
+		if (nr_node_ids == 1)
+			pflags &= ~SD_SERIALIZE;
 	}
 	if (~cflags & pflags)
 		return 0;
@@ -7336,13 +7294,21 @@ struct allmasks {
 };
 
 #if	NR_CPUS > 128
-#define	SCHED_CPUMASK_ALLOC		1
-#define	SCHED_CPUMASK_FREE(v)		kfree(v)
-#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks *v
+#define SCHED_CPUMASK_DECLARE(v)	struct allmasks *v
+static inline void sched_cpumask_alloc(struct allmasks **masks)
+{
+	*masks = kmalloc(sizeof(**masks), GFP_KERNEL);
+}
+static inline void sched_cpumask_free(struct allmasks *masks)
+{
+	kfree(masks);
+}
 #else
-#define	SCHED_CPUMASK_ALLOC		0
-#define	SCHED_CPUMASK_FREE(v)
-#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks _v, *v = &_v
+#define SCHED_CPUMASK_DECLARE(v)	struct allmasks _v, *v = &_v
+static inline void sched_cpumask_alloc(struct allmasks **masks)
+{ }
+static inline void sched_cpumask_free(struct allmasks *masks)
+{ }
 #endif
 
 #define	SCHED_CPUMASK_VAR(v, a) 	cpumask_t *v = (cpumask_t *) \
@@ -7418,9 +7384,8 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		return -ENOMEM;
 	}
 
-#if SCHED_CPUMASK_ALLOC
 	/* get space for all scratch cpumask variables */
-	allmasks = kmalloc(sizeof(*allmasks), GFP_KERNEL);
+	sched_cpumask_alloc(&allmasks);
 	if (!allmasks) {
 		printk(KERN_WARNING "Cannot alloc cpumask array\n");
 		kfree(rd);
@@ -7429,7 +7394,7 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 #endif
 		return -ENOMEM;
 	}
-#endif
+
 	tmpmask = (cpumask_t *)allmasks;
 
 
@@ -7683,13 +7648,13 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		cpu_attach_domain(sd, rd, i);
 	}
 
-	SCHED_CPUMASK_FREE((void *)allmasks);
+	sched_cpumask_free(allmasks);
 	return 0;
 
 #ifdef CONFIG_NUMA
 error:
 	free_sched_groups(cpu_map, tmpmask);
-	SCHED_CPUMASK_FREE((void *)allmasks);
+	sched_cpumask_free(allmasks);
 	kfree(rd);
 	return -ENOMEM;
 #endif
@@ -7712,8 +7677,14 @@ static struct sched_domain_attr *dattr_cur;
  */
 static cpumask_t fallback_doms;
 
-void __attribute__((weak)) arch_update_cpu_topology(void)
+/*
+ * arch_update_cpu_topology lets virtualized architectures update the
+ * cpu core maps. It is supposed to return 1 if the topology changed
+ * or 0 if it stayed the same.
+ */
+int __attribute__((weak)) arch_update_cpu_topology(void)
 {
+	return 0;
 }
 
 /*
@@ -7753,8 +7724,6 @@ static void detach_destroy_domains(const cpumask_t *cpu_map)
 	cpumask_t tmpmask;
 	int i;
 
-	unregister_sched_domain_sysctl();
-
 	for_each_cpu_mask_nr(i, *cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
 	synchronize_sched();
@@ -7807,17 +7776,21 @@ void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
 			     struct sched_domain_attr *dattr_new)
 {
 	int i, j, n;
+	int new_topology;
 
 	mutex_lock(&sched_domains_mutex);
 
 	/* always unregister in case we don't destroy any domains */
 	unregister_sched_domain_sysctl();
 
+	/* Let architecture update cpu core mappings. */
+	new_topology = arch_update_cpu_topology();
+
 	n = doms_new ? ndoms_new : 0;
 
 	/* Destroy deleted domains */
 	for (i = 0; i < ndoms_cur; i++) {
-		for (j = 0; j < n; j++) {
+		for (j = 0; j < n && !new_topology; j++) {
 			if (cpus_equal(doms_cur[i], doms_new[j])
 			    && dattrs_equal(dattr_cur, i, dattr_new, j))
 				goto match1;
@@ -7832,12 +7805,12 @@ match1:
 		ndoms_cur = 0;
 		doms_new = &fallback_doms;
 		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
-		dattr_new = NULL;
+		WARN_ON_ONCE(dattr_new);
 	}
 
 	/* Build new domains */
 	for (i = 0; i < ndoms_new; i++) {
-		for (j = 0; j < ndoms_cur; j++) {
+		for (j = 0; j < ndoms_cur && !new_topology; j++) {
 			if (cpus_equal(doms_new[i], doms_cur[j])
 			    && dattrs_equal(dattr_new, i, dattr_cur, j))
 				goto match2;
@@ -8492,7 +8465,7 @@ static
 int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	struct cfs_rq *cfs_rq;
-	struct sched_entity *se, *parent_se;
+	struct sched_entity *se;
 	struct rq *rq;
 	int i;
 
@@ -8508,18 +8481,17 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
 
-		cfs_rq = kmalloc_node(sizeof(struct cfs_rq),
-				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
+		cfs_rq = kzalloc_node(sizeof(struct cfs_rq),
+				      GFP_KERNEL, cpu_to_node(i));
 		if (!cfs_rq)
 			goto err;
 
-		se = kmalloc_node(sizeof(struct sched_entity),
-				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
+		se = kzalloc_node(sizeof(struct sched_entity),
+				  GFP_KERNEL, cpu_to_node(i));
 		if (!se)
 			goto err;
 
-		parent_se = parent ? parent->se[i] : NULL;
-		init_tg_cfs_entry(tg, cfs_rq, se, i, 0, parent_se);
+		init_tg_cfs_entry(tg, cfs_rq, se, i, 0, parent->se[i]);
 	}
 
 	return 1;
@@ -8580,7 +8552,7 @@ static
 int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	struct rt_rq *rt_rq;
-	struct sched_rt_entity *rt_se, *parent_se;
+	struct sched_rt_entity *rt_se;
 	struct rq *rq;
 	int i;
 
@@ -8597,18 +8569,17 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
 
-		rt_rq = kmalloc_node(sizeof(struct rt_rq),
-				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
+		rt_rq = kzalloc_node(sizeof(struct rt_rq),
+				     GFP_KERNEL, cpu_to_node(i));
 		if (!rt_rq)
 			goto err;
 
-		rt_se = kmalloc_node(sizeof(struct sched_rt_entity),
-				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
+		rt_se = kzalloc_node(sizeof(struct sched_rt_entity),
+				     GFP_KERNEL, cpu_to_node(i));
 		if (!rt_se)
 			goto err;
 
-		parent_se = parent ? parent->rt_se[i] : NULL;
-		init_tg_rt_entry(tg, rt_rq, rt_se, i, 0, parent_se);
+		init_tg_rt_entry(tg, rt_rq, rt_se, i, 0, parent->rt_se[i]);
 	}
 
 	return 1;
@@ -9251,11 +9222,12 @@ struct cgroup_subsys cpu_cgroup_subsys = {
  * (balbir@in.ibm.com).
  */
 
-/* track cpu usage of a group of tasks */
+/* track cpu usage of a group of tasks and its child groups */
 struct cpuacct {
 	struct cgroup_subsys_state css;
 	/* cpuusage holds pointer to a u64-type object on every cpu */
 	u64 *cpuusage;
+	struct cpuacct *parent;
 };
 
 struct cgroup_subsys cpuacct_subsys;
@@ -9289,6 +9261,9 @@ static struct cgroup_subsys_state *cpuacct_create(
 		return ERR_PTR(-ENOMEM);
 	}
 
+	if (cgrp->parent)
+		ca->parent = cgroup_ca(cgrp->parent);
+
 	return &ca->css;
 }
 
@@ -9302,6 +9277,41 @@ cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 	kfree(ca);
 }
 
+static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu)
+{
+	u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
+	u64 data;
+
+#ifndef CONFIG_64BIT
+	/*
+	 * Take rq->lock to make 64-bit read safe on 32-bit platforms.
+	 */
+	spin_lock_irq(&cpu_rq(cpu)->lock);
+	data = *cpuusage;
+	spin_unlock_irq(&cpu_rq(cpu)->lock);
+#else
+	data = *cpuusage;
+#endif
+
+	return data;
+}
+
+static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu, u64 val)
+{
+	u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
+
+#ifndef CONFIG_64BIT
+	/*
+	 * Take rq->lock to make 64-bit write safe on 32-bit platforms.
+	 */
+	spin_lock_irq(&cpu_rq(cpu)->lock);
+	*cpuusage = val;
+	spin_unlock_irq(&cpu_rq(cpu)->lock);
+#else
+	*cpuusage = val;
+#endif
+}
+
 /* return total cpu usage (in nanoseconds) of a group */
 static u64 cpuusage_read(struct cgroup *cgrp, struct cftype *cft)
 {
@@ -9309,17 +9319,8 @@ static u64 cpuusage_read(struct cgroup *cgrp, struct cftype *cft)
 	u64 totalcpuusage = 0;
 	int i;
 
-	for_each_possible_cpu(i) {
-		u64 *cpuusage = percpu_ptr(ca->cpuusage, i);
-
-		/*
-		 * Take rq->lock to make 64-bit addition safe on 32-bit
-		 * platforms.
-		 */
-		spin_lock_irq(&cpu_rq(i)->lock);
-		totalcpuusage += *cpuusage;
-		spin_unlock_irq(&cpu_rq(i)->lock);
-	}
+	for_each_present_cpu(i)
+		totalcpuusage += cpuacct_cpuusage_read(ca, i);
 
 	return totalcpuusage;
 }
@@ -9336,23 +9337,39 @@ static int cpuusage_write(struct cgroup *cgrp, struct cftype *cftype,
 		goto out;
 	}
 
-	for_each_possible_cpu(i) {
-		u64 *cpuusage = percpu_ptr(ca->cpuusage, i);
+	for_each_present_cpu(i)
+		cpuacct_cpuusage_write(ca, i, 0);
 
-		spin_lock_irq(&cpu_rq(i)->lock);
-		*cpuusage = 0;
-		spin_unlock_irq(&cpu_rq(i)->lock);
-	}
 out:
 	return err;
 }
 
+static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
+				   struct seq_file *m)
+{
+	struct cpuacct *ca = cgroup_ca(cgroup);
+	u64 percpu;
+	int i;
+
+	for_each_present_cpu(i) {
+		percpu = cpuacct_cpuusage_read(ca, i);
+		seq_printf(m, "%llu ", (unsigned long long) percpu);
+	}
+	seq_printf(m, "\n");
+	return 0;
+}
+
 static struct cftype files[] = {
 	{
 		.name = "usage",
 		.read_u64 = cpuusage_read,
 		.write_u64 = cpuusage_write,
 	},
+	{
+		.name = "usage_percpu",
+		.read_seq_string = cpuacct_percpu_seq_read,
+	},
+
 };
 
 static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
@@ -9368,14 +9385,16 @@ static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
 static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 {
 	struct cpuacct *ca;
+	int cpu;
 
 	if (!cpuacct_subsys.active)
 		return;
 
+	cpu = task_cpu(tsk);
 	ca = task_ca(tsk);
-	if (ca) {
-		u64 *cpuusage = percpu_ptr(ca->cpuusage, task_cpu(tsk));
 
+	for (; ca; ca = ca->parent) {
+		u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
 		*cpuusage += cputime;
 	}
 }
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 26ed8e3..4293cfa 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -53,6 +53,40 @@ static unsigned long nsec_low(unsigned long long nsec)
 
 #define SPLIT_NS(x) nsec_high(x), nsec_low(x)
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static void print_cfs_group_stats(struct seq_file *m, int cpu,
+		struct task_group *tg)
+{
+	struct sched_entity *se = tg->se[cpu];
+	if (!se)
+		return;
+
+#define P(F) \
+	SEQ_printf(m, "  .%-30s: %lld\n", #F, (long long)F)
+#define PN(F) \
+	SEQ_printf(m, "  .%-30s: %lld.%06ld\n", #F, SPLIT_NS((long long)F))
+
+	PN(se->exec_start);
+	PN(se->vruntime);
+	PN(se->sum_exec_runtime);
+#ifdef CONFIG_SCHEDSTATS
+	PN(se->wait_start);
+	PN(se->sleep_start);
+	PN(se->block_start);
+	PN(se->sleep_max);
+	PN(se->block_max);
+	PN(se->exec_max);
+	PN(se->slice_max);
+	PN(se->wait_max);
+	PN(se->wait_sum);
+	P(se->wait_count);
+#endif
+	P(se->load.weight);
+#undef PN
+#undef P
+}
+#endif
+
 static void
 print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 {
@@ -121,20 +155,19 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 
 #if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
 	char path[128] = "";
-	struct cgroup *cgroup = NULL;
 	struct task_group *tg = cfs_rq->tg;
 
-	if (tg)
-		cgroup = tg->css.cgroup;
-
-	if (cgroup)
-		cgroup_path(cgroup, path, sizeof(path));
+	cgroup_path(tg->css.cgroup, path, sizeof(path));
 
 	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
+#elif defined(CONFIG_USER_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
+	{
+		uid_t uid = cfs_rq->tg->uid;
+		SEQ_printf(m, "\ncfs_rq[%d] for UID: %u\n", cpu, uid);
+	}
 #else
 	SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
 #endif
-
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "exec_clock",
 			SPLIT_NS(cfs_rq->exec_clock));
 
@@ -168,6 +201,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 #ifdef CONFIG_SMP
 	SEQ_printf(m, "  .%-30s: %lu\n", "shares", cfs_rq->shares);
 #endif
+	print_cfs_group_stats(m, cpu, cfs_rq->tg);
 #endif
 }
 
@@ -175,14 +209,9 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 {
 #if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_RT_GROUP_SCHED)
 	char path[128] = "";
-	struct cgroup *cgroup = NULL;
 	struct task_group *tg = rt_rq->tg;
 
-	if (tg)
-		cgroup = tg->css.cgroup;
-
-	if (cgroup)
-		cgroup_path(cgroup, path, sizeof(path));
+	cgroup_path(tg->css.cgroup, path, sizeof(path));
 
 	SEQ_printf(m, "\nrt_rq[%d]:%s\n", cpu, path);
 #else
@@ -272,7 +301,7 @@ static int sched_debug_show(struct seq_file *m, void *v)
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Sched Debug Version: v0.07, %s %.*s\n",
+	SEQ_printf(m, "Sched Debug Version: v0.08, %s %.*s\n",
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 98345e4..5ad4440 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -492,6 +492,8 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	 * overflow on 32 bits):
 	 */
 	delta_exec = (unsigned long)(now - curr->exec_start);
+	if (!delta_exec)
+		return;
 
 	__update_curr(cfs_rq, curr, delta_exec);
 	curr->exec_start = now;
@@ -1345,12 +1347,11 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 {
 	struct task_struct *curr = rq->curr;
 	struct sched_entity *se = &curr->se, *pse = &p->se;
+	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 
-	if (unlikely(rt_prio(p->prio))) {
-		struct cfs_rq *cfs_rq = task_cfs_rq(curr);
+	update_curr(cfs_rq);
 
-		update_rq_clock(rq);
-		update_curr(cfs_rq);
+	if (unlikely(rt_prio(p->prio))) {
 		resched_task(curr);
 		return;
 	}
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index d9ba9d5..51d2af3 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -77,7 +77,7 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 }
 
 #define for_each_leaf_rt_rq(rt_rq, rq) \
-	list_for_each_entry(rt_rq, &rq->leaf_rt_rq_list, leaf_rt_rq_list)
+	list_for_each_entry_rcu(rt_rq, &rq->leaf_rt_rq_list, leaf_rt_rq_list)
 
 static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 {
@@ -537,13 +537,13 @@ static void update_curr_rt(struct rq *rq)
 	for_each_sched_rt_entity(rt_se) {
 		rt_rq = rt_rq_of_se(rt_se);
 
-		spin_lock(&rt_rq->rt_runtime_lock);
 		if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
+			spin_lock(&rt_rq->rt_runtime_lock);
 			rt_rq->rt_time += delta_exec;
 			if (sched_rt_runtime_exceeded(rt_rq))
 				resched_task(curr);
+			spin_unlock(&rt_rq->rt_runtime_lock);
 		}
-		spin_unlock(&rt_rq->rt_runtime_lock);
 	}
 }
 
@@ -909,9 +909,6 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 /* Only try algorithms three times */
 #define RT_MAX_TRIES 3
 
-static int double_lock_balance(struct rq *this_rq, struct rq *busiest);
-static void double_unlock_balance(struct rq *this_rq, struct rq *busiest);
-
 static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep);
 
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 7dbf72a..3b01098 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -31,7 +31,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
 		    rq->yld_act_empty, rq->yld_exp_empty, rq->yld_count,
 		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
 		    rq->ttwu_count, rq->ttwu_local,
-		    rq->rq_sched_info.cpu_time,
+		    rq->rq_cpu_time,
 		    rq->rq_sched_info.run_delay, rq->rq_sched_info.pcount);
 
 		seq_printf(seq, "\n");
@@ -123,7 +123,7 @@ static inline void
 rq_sched_info_depart(struct rq *rq, unsigned long long delta)
 {
 	if (rq)
-		rq->rq_sched_info.cpu_time += delta;
+		rq->rq_cpu_time += delta;
 }
 
 static inline void
@@ -236,7 +236,6 @@ static inline void sched_info_depart(struct task_struct *t)
 	unsigned long long delta = task_rq(t)->clock -
 					t->sched_info.last_arrival;
 
-	t->sched_info.cpu_time += delta;
 	rq_sched_info_depart(task_rq(t), delta);
 
 	if (t->state == TASK_RUNNING)
diff --git a/kernel/user.c b/kernel/user.c
index 39d6159..cec2224 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -101,6 +101,8 @@ static int sched_create_user(struct user_struct *up)
 	if (IS_ERR(up->tg))
 		rc = -ENOMEM;
 
+	set_tg_uid(up);
+
 	return rc;
 }
 
