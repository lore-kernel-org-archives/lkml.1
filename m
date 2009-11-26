Return-Path: <linux-kernel-owner+w=401wt.eu-S1760845AbZKZQpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845AbZKZQpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760836AbZKZQpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:45:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50217 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759245AbZKZQps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:45:48 -0500
Subject: Re: Missing recalculation of scheduler tunables in case of cpu hot
 add/remove
From: Peter Zijlstra <peterz@infradead.org>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Holger.Wolf@de.ibm.com, epasch@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <4B0EAD7B.90601@linux.vnet.ibm.com>
References: <4B0EA88E.3030205@linux.vnet.ibm.com>
	 <1259252382.31676.207.camel@laptop>  <4B0EAC06.3010407@linux.vnet.ibm.com>
	 <1259252892.31676.220.camel@laptop>  <4B0EAD7B.90601@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 17:45:50 +0100
Message-ID: <1259253950.31676.249.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 17:31 +0100, Christian Ehrhardt wrote:
> Peter Zijlstra wrote:
> > On Thu, 2009-11-26 at 17:25 +0100, Christian Ehrhardt wrote:
> >   
> >>> Aside from that, we probably should put an upper limit in place, as I
> >>> guess large cpu count machines get silly large values
> >>>       
> >> I agree to that, but in the code is already an upper limit of 
> >> 200.000.000 - well we might discuss if that is too low/high.
> >>     
> >
> > Yeah, I think we should cap it around the 8-16 CPUs.
> >
> >   
> ok for me, driven by that finding I think I have to measure different 
> kind of scalings anyway, but as usually that takes some time :-/
> At least too time much for the discussion & solution of that bug I guess.
> 
> The question for now is what we do on cpu hot add/remove?
> Would hooking somewhere in kernel/cpu.c be the right approach - I'm not 
> quite sure about my own suggestion yet :-).

Something like the below might work I suppose, just needs a cleanup and
such.


diff --git a/kernel/sched.c b/kernel/sched.c
index 0cbf2ef..210365f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -814,6 +814,7 @@ const_debug unsigned int sysctl_sched_nr_migrate = 32;
  * default: 0.25ms
  */
 unsigned int sysctl_sched_shares_ratelimit = 250000;
+unsigned int default_sysctl_sched_shares_ratelimit = 250000;
 
 /*
  * Inject some fuzzyness into changing the per-cpu group shares
@@ -1810,6 +1811,7 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 #endif
 
 static void calc_load_account_active(struct rq *this_rq);
+static void update_sysctl(void);
 
 #include "sched_stats.h"
 #include "sched_idletask.c"
@@ -7019,22 +7021,24 @@ cpumask_var_t nohz_cpu_mask;
  *
  * This idea comes from the SD scheduler of Con Kolivas:
  */
-static inline void sched_init_granularity(void)
+#define SET_SYSCTL(name, factor) \
+	sysctl_##name = (factor) * default_sysctl_##name
+
+static void update_sysctl(void)
 {
-	unsigned int factor = 1 + ilog2(num_online_cpus());
+	unsigned int cpus = max(num_active_cpus(), 8);
+	unsigned int factor = 1 + ilog2(cpus);
 	const unsigned long limit = 200000000;
 
-	sysctl_sched_min_granularity *= factor;
-	if (sysctl_sched_min_granularity > limit)
-		sysctl_sched_min_granularity = limit;
-
-	sysctl_sched_latency *= factor;
-	if (sysctl_sched_latency > limit)
-		sysctl_sched_latency = limit;
-
-	sysctl_sched_wakeup_granularity *= factor;
+	SET_SYSCTL(sched_min_granularity);
+	SET_SYSCTL(sched_latency);
+	SET_SYSCTL(sched_wakeup_granularity);
+	SET_SYSCTL(sched_shares_ratelimit);
+}
 
-	sysctl_sched_shares_ratelimit *= factor;
+static inline void sched_init_granularity(void)
+{
+	update_sysctl();
 }
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0ff21af..4d429b8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -35,12 +35,14 @@
  *  run vmstat and monitor the context-switches (cs) field)
  */
 unsigned int sysctl_sched_latency = 5000000ULL;
+unsigned int default_sysctl_sched_latency = 5000000ULL;
 
 /*
  * Minimal preemption granularity for CPU-bound tasks:
  * (default: 1 msec * (1 + ilog(ncpus)), units: nanoseconds)
  */
 unsigned int sysctl_sched_min_granularity = 1000000ULL;
+unsigned int default_sysctl_sched_min_granularity = 1000000ULL;
 
 /*
  * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
@@ -70,6 +72,7 @@ unsigned int __read_mostly sysctl_sched_compat_yield;
  * have immediate wakeup/sleep latencies.
  */
 unsigned int sysctl_sched_wakeup_granularity = 1000000UL;
+unsigned int default_sysctl_sched_wakeup_granularity = 1000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
@@ -1905,6 +1908,17 @@ move_one_task_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 
 	return 0;
 }
+
+static void rq_online_fair(struct rq *rq)
+{
+	update_sysctl();
+}
+
+static void rq_offline_fair(struct rq *rq)
+{
+	update_sysctl();
+}
+
 #endif /* CONFIG_SMP */
 
 /*
@@ -2052,6 +2066,8 @@ static const struct sched_class fair_sched_class = {
 
 	.load_balance		= load_balance_fair,
 	.move_one_task		= move_one_task_fair,
+	.rq_online		= rq_online_fair,
+	.rq_offline		= rq_offline_fair,
 #endif
 
 	.set_curr_task          = set_curr_task_fair,


