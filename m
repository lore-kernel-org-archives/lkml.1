Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbZFTRA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbZFTRA2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 13:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbZFTRAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 13:00:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39872 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926AbZFTRAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 13:00:16 -0400
Date: Sat, 20 Jun 2009 19:00:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20090620170011.GA1676@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
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
Christian Engelmayer (1):
      sched: Fix out of scope variable access in sched_slice()

Hitoshi Mitake (1):
      sched: Hide runqueues from direct refer at source code level

Li Zefan (1):
      sched: Remove unneeded __ref tag

Peter Zijlstra (1):
      sched, x86: Fix cpufreq + sched_clock() TSC scaling


 arch/x86/include/asm/timer.h |    6 +++++-
 arch/x86/kernel/tsc.c        |    8 ++++++--
 kernel/sched.c               |    2 +-
 kernel/sched_cpupri.c        |    2 +-
 kernel/sched_debug.c         |    6 +++---
 kernel/sched_fair.c          |    3 ++-
 6 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index bd37ed4..20ca9c4 100644
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -45,12 +45,16 @@ extern int no_timer_check;
  */
 
 DECLARE_PER_CPU(unsigned long, cyc2ns);
+DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
 
 #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
 static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
 {
-	return cyc * per_cpu(cyc2ns, smp_processor_id()) >> CYC2NS_SCALE_FACTOR;
+	int cpu = smp_processor_id();
+	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
+	ns += cyc * per_cpu(cyc2ns, cpu) >> CYC2NS_SCALE_FACTOR;
+	return ns;
 }
 
 static inline unsigned long long cycles_2_ns(unsigned long long cyc)
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 3e1c057..ef4dac5 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -589,22 +589,26 @@ EXPORT_SYMBOL(recalibrate_cpu_khz);
  */
 
 DEFINE_PER_CPU(unsigned long, cyc2ns);
+DEFINE_PER_CPU(unsigned long long, cyc2ns_offset);
 
 static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
-	unsigned long long tsc_now, ns_now;
+	unsigned long long tsc_now, ns_now, *offset;
 	unsigned long flags, *scale;
 
 	local_irq_save(flags);
 	sched_clock_idle_sleep_event();
 
 	scale = &per_cpu(cyc2ns, cpu);
+	offset = &per_cpu(cyc2ns_offset, cpu);
 
 	rdtscll(tsc_now);
 	ns_now = __cycles_2_ns(tsc_now);
 
-	if (cpu_khz)
+	if (cpu_khz) {
 		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
+		*offset = ns_now - (tsc_now * *scale >> CYC2NS_SCALE_FACTOR);
+	}
 
 	sched_clock_idle_wakeup_event(0);
 	local_irq_restore(flags);
diff --git a/kernel/sched.c b/kernel/sched.c
index 8fb88a9..0056795 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7828,7 +7828,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 		free_rootdomain(old_rd);
 }
 
-static int __init_refok init_rootdomain(struct root_domain *rd, bool bootmem)
+static int init_rootdomain(struct root_domain *rd, bool bootmem)
 {
 	gfp_t gfp = GFP_KERNEL;
 
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 7deffc9..e6c2517 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -152,7 +152,7 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
  *
  * Returns: -ENOMEM if memory fails.
  */
-int __init_refok cpupri_init(struct cpupri *cp, bool bootmem)
+int cpupri_init(struct cpupri *cp, bool bootmem)
 {
 	gfp_t gfp = GFP_KERNEL;
 	int i;
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 467ca72..70c7e0b 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -162,7 +162,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 {
 	s64 MIN_vruntime = -1, min_vruntime, max_vruntime = -1,
 		spread, rq0_min_vruntime, spread0;
-	struct rq *rq = &per_cpu(runqueues, cpu);
+	struct rq *rq = cpu_rq(cpu);
 	struct sched_entity *last;
 	unsigned long flags;
 
@@ -191,7 +191,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	if (last)
 		max_vruntime = last->vruntime;
 	min_vruntime = cfs_rq->min_vruntime;
-	rq0_min_vruntime = per_cpu(runqueues, 0).cfs.min_vruntime;
+	rq0_min_vruntime = cpu_rq(0)->cfs.min_vruntime;
 	spin_unlock_irqrestore(&rq->lock, flags);
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "MIN_vruntime",
 			SPLIT_NS(MIN_vruntime));
@@ -248,7 +248,7 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 
 static void print_cpu(struct seq_file *m, int cpu)
 {
-	struct rq *rq = &per_cpu(runqueues, cpu);
+	struct rq *rq = cpu_rq(cpu);
 
 #ifdef CONFIG_X86
 	{
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5f9650e..ba7fd6e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -430,12 +430,13 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 	for_each_sched_entity(se) {
 		struct load_weight *load;
+		struct load_weight lw;
 
 		cfs_rq = cfs_rq_of(se);
 		load = &cfs_rq->load;
 
 		if (unlikely(!se->on_rq)) {
-			struct load_weight lw = cfs_rq->load;
+			lw = cfs_rq->load;
 
 			update_load_add(&lw, se->load.weight);
 			load = &lw;
