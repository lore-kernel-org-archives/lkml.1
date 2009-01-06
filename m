Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbZAFQQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbZAFQQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZAFQQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:16:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37478 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbZAFQQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:16:36 -0500
Date: Tue, 6 Jan 2009 17:16:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: [git pull] scheduler fixes
Message-ID: <20090106161629.GA17487@elte.hu>
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

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Jaswinder Singh Rajput (1):
      sched: sched.c declare variables before they get used

KOSAKI Motohiro (1):
      getrusage: RUSAGE_THREAD should return ru_utime and ru_stime

Li Zefan (4):
      sched: mark sched_create_sysfs_power_savings_entries() as __init
      sched: clean up arch_reinit_sched_domains()
      sched: fix double kfree in failure path
      sched: fix section mismatch

Mike Galbraith (1):
      sched: fix sched_slice()

Thomas Gleixner (1):
      sched_clock: prevent scd->clock from moving backwards, take #2


 include/linux/sched.h     |    7 +++----
 include/linux/time.h      |    1 +
 kernel/sched.c            |   18 +++++++-----------
 kernel/sched_clock.c      |    5 ++++-
 kernel/sched_cpupri.c     |    2 +-
 kernel/sched_fair.c       |   30 ++++++++++++------------------
 kernel/sys.c              |    2 ++
 kernel/time/timekeeping.c |    7 +++++--
 8 files changed, 35 insertions(+), 37 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 38a3f4b..c8a90be 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -912,7 +912,6 @@ static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
 
 extern void partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
 				    struct sched_domain_attr *dattr_new);
-extern int arch_reinit_sched_domains(void);
 
 /* Test a flag in parent sched domain */
 static inline int test_sd_parent(struct sched_domain *sd, int flag)
@@ -1704,16 +1703,16 @@ extern void wake_up_idle_cpu(int cpu);
 static inline void wake_up_idle_cpu(int cpu) { }
 #endif
 
-#ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_latency;
 extern unsigned int sysctl_sched_min_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
+extern unsigned int sysctl_sched_shares_ratelimit;
+extern unsigned int sysctl_sched_shares_thresh;
+#ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
-extern unsigned int sysctl_sched_shares_ratelimit;
-extern unsigned int sysctl_sched_shares_thresh;
 
 int sched_nr_latency_handler(struct ctl_table *table, int write,
 		struct file *file, void __user *buffer, size_t *length,
diff --git a/include/linux/time.h b/include/linux/time.h
index ce321ac..fbbd2a1 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -105,6 +105,7 @@ extern unsigned long read_persistent_clock(void);
 extern int update_persistent_clock(struct timespec now);
 extern int no_sync_cmos_clock __read_mostly;
 void timekeeping_init(void);
+extern int timekeeping_suspended;
 
 unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
diff --git a/kernel/sched.c b/kernel/sched.c
index 545c6fc..2e3545f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6957,7 +6957,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	spin_unlock_irqrestore(&rq->lock, flags);
 }
 
-static int init_rootdomain(struct root_domain *rd, bool bootmem)
+static int __init_refok init_rootdomain(struct root_domain *rd, bool bootmem)
 {
 	memset(rd, 0, sizeof(*rd));
 
@@ -6970,7 +6970,7 @@ static int init_rootdomain(struct root_domain *rd, bool bootmem)
 	}
 
 	if (!alloc_cpumask_var(&rd->span, GFP_KERNEL))
-		goto free_rd;
+		goto out;
 	if (!alloc_cpumask_var(&rd->online, GFP_KERNEL))
 		goto free_span;
 	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
@@ -6986,8 +6986,7 @@ free_online:
 	free_cpumask_var(rd->online);
 free_span:
 	free_cpumask_var(rd->span);
-free_rd:
-	kfree(rd);
+out:
 	return -ENOMEM;
 }
 
@@ -7987,7 +7986,7 @@ match2:
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-int arch_reinit_sched_domains(void)
+static void arch_reinit_sched_domains(void)
 {
 	get_online_cpus();
 
@@ -7996,13 +7995,10 @@ int arch_reinit_sched_domains(void)
 
 	rebuild_sched_domains();
 	put_online_cpus();
-
-	return 0;
 }
 
 static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 {
-	int ret;
 	unsigned int level = 0;
 
 	if (sscanf(buf, "%u", &level) != 1)
@@ -8023,9 +8019,9 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 	else
 		sched_mc_power_savings = level;
 
-	ret = arch_reinit_sched_domains();
+	arch_reinit_sched_domains();
 
-	return ret ? ret : count;
+	return count;
 }
 
 #ifdef CONFIG_SCHED_MC
@@ -8060,7 +8056,7 @@ static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644,
 		   sched_smt_power_savings_store);
 #endif
 
-int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
+int __init sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
 {
 	int err = 0;
 
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index e8ab096..a0b0852 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -124,7 +124,7 @@ static u64 __update_sched_clock(struct sched_clock_data *scd, u64 now)
 
 	clock = scd->tick_gtod + delta;
 	min_clock = wrap_max(scd->tick_gtod, scd->clock);
-	max_clock = scd->tick_gtod + TICK_NSEC;
+	max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
 
 	clock = wrap_max(clock, min_clock);
 	clock = wrap_min(clock, max_clock);
@@ -227,6 +227,9 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_sleep_event);
  */
 void sched_clock_idle_wakeup_event(u64 delta_ns)
 {
+	if (timekeeping_suspended)
+		return;
+
 	sched_clock_tick();
 	touch_softlockup_watchdog();
 }
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 018b7be..1e00bfa 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -151,7 +151,7 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
  *
  * Returns: -ENOMEM if memory fails.
  */
-int cpupri_init(struct cpupri *cp, bool bootmem)
+int __init_refok cpupri_init(struct cpupri *cp, bool bootmem)
 {
 	int i;
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 56c0efe..e0c0b4b 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -386,20 +386,6 @@ int sched_nr_latency_handler(struct ctl_table *table, int write,
 #endif
 
 /*
- * delta *= P[w / rw]
- */
-static inline unsigned long
-calc_delta_weight(unsigned long delta, struct sched_entity *se)
-{
-	for_each_sched_entity(se) {
-		delta = calc_delta_mine(delta,
-				se->load.weight, &cfs_rq_of(se)->load);
-	}
-
-	return delta;
-}
-
-/*
  * delta /= w
  */
 static inline unsigned long
@@ -440,12 +426,20 @@ static u64 __sched_period(unsigned long nr_running)
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	unsigned long nr_running = cfs_rq->nr_running;
+	u64 slice = __sched_period(cfs_rq->nr_running + !se->on_rq);
 
-	if (unlikely(!se->on_rq))
-		nr_running++;
+	for_each_sched_entity(se) {
+		struct load_weight *load = &cfs_rq->load;
 
-	return calc_delta_weight(__sched_period(nr_running), se);
+		if (unlikely(!se->on_rq)) {
+			struct load_weight lw = cfs_rq->load;
+
+			update_load_add(&lw, se->load.weight);
+			load = &lw;
+		}
+		slice = calc_delta_mine(slice, se->load.weight, load);
+	}
+	return slice;
 }
 
 /*
diff --git a/kernel/sys.c b/kernel/sys.c
index d356d79..61dbfd4 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1627,6 +1627,8 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 	utime = stime = cputime_zero;
 
 	if (who == RUSAGE_THREAD) {
+		utime = task_utime(current);
+		stime = task_stime(current);
 		accumulate_thread_rusage(p, r);
 		goto out;
 	}
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fa05e88..900f1b6 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -46,6 +46,9 @@ struct timespec xtime __attribute__ ((aligned (16)));
 struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
 static unsigned long total_sleep_time;		/* seconds */
 
+/* flag for if timekeeping is suspended */
+int __read_mostly timekeeping_suspended;
+
 static struct timespec xtime_cache __attribute__ ((aligned (16)));
 void update_xtime_cache(u64 nsec)
 {
@@ -92,6 +95,8 @@ void getnstimeofday(struct timespec *ts)
 	unsigned long seq;
 	s64 nsecs;
 
+	WARN_ON(timekeeping_suspended);
+
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
@@ -299,8 +304,6 @@ void __init timekeeping_init(void)
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 }
 
-/* flag for if timekeeping is suspended */
-static int timekeeping_suspended;
 /* time in seconds when suspend began */
 static unsigned long timekeeping_suspend_time;
 
