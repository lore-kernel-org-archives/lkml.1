Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259Ab0AGJAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab0AGJAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821Ab0AGJAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:00:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:24237 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646Ab0AGJAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:00:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,231,1262592000"; 
   d="scan'208";a="762107152"
Subject: Re: [RFC PATCH] sched: Pass affine target cpu into wake_affine
From: Lin Ming <ming.m.lin@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262673817.9534.37.camel@marge.simson.net>
References: <1262595827.22471.108.camel@minggr.sh.intel.com>
	 <1262659686.22471.121.camel@minggr.sh.intel.com>
	 <1262663058.5748.32.camel@marge.simson.net>
	 <1262673817.9534.37.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 07 Jan 2010 16:45:03 +0800
Message-Id: <1262853903.18931.17.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-05 at 14:43 +0800, Mike Galbraith wrote:
> On Tue, 2010-01-05 at 04:44 +0100, Mike Galbraith wrote:
> > On Tue, 2010-01-05 at 10:48 +0800, Lin Ming wrote:
> > > On Mon, 2010-01-04 at 17:03 +0800, Lin Ming wrote:
> > > > commit a03ecf08d7bbdd979d81163ea13d194fe21ad339
> > > > Author: Lin Ming <ming.m.lin@intel.com>
> > > > Date:   Mon Jan 4 14:14:50 2010 +0800
> > > > 
> > > >     sched: Pass affine target cpu into wake_affine
> > > >     
> > > >     Since commit a1f84a3(sched: Check for an idle shared cache in select_task_rq_fair()),
> > > >     the affine target maybe adjusted to any idle cpu in cache sharing domains
> > > >     instead of current cpu.
> > > >     But wake_affine still use current cpu to calculate load which is wrong.
> > > >     
> > > >     This patch passes affine cpu into wake_affine.
> > > >     
> > > >     Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > > 
> > > Mike,
> > > 
> > > Any comment of this patch?
> > 
> > The patch definitely looks like the right thing to do, but when I tried
> > this, it didn't work out well.  Since I can't seem to recall precise
> > details, I'll let my box either remind me or give it's ack.
> 
> Unfortunately, box reminded me.  mysql+oltp peak throughput with
> nr_clients == nr_cpus

Did you test with your vmark regression fix patch also applied?

I tested on below 2 machines with the 2 patches both applied and the
oltp(sysbench+mysql) data shows good.
Tigerton x86_64 machine: 16cpus(4P/4Cores), 40G mem
IA64 machine: 32cpus(4P/4Cores/HT), 16G mem

Compared with upstream 2.6.33-rc2, IA64 improves ~15% and Tigerton
improves ~3%.

The 2 patches are merged as below,

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 57e6357..5b81156 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -99,7 +99,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
-				| 0*SD_SHARE_PKG_RESOURCES		\
+				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
 				,					\
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 42ac3c9..cbf4bd2 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1237,11 +1237,11 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
 
 #endif
 
-static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
+static int wake_affine(struct sched_domain *sd, struct task_struct *p, int affine_cpu, int sync)
 {
 	struct task_struct *curr = current;
-	unsigned long this_load, load;
-	int idx, this_cpu, prev_cpu;
+	unsigned long affine_load, load;
+	int idx, prev_cpu;
 	unsigned long tl_per_task;
 	unsigned int imbalance;
 	struct task_group *tg;
@@ -1249,10 +1249,9 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	int balanced;
 
 	idx	  = sd->wake_idx;
-	this_cpu  = smp_processor_id();
 	prev_cpu  = task_cpu(p);
 	load	  = source_load(prev_cpu, idx);
-	this_load = target_load(this_cpu, idx);
+	affine_load = target_load(affine_cpu, idx);
 
 	if (sync) {
 	       if (sched_feat(SYNC_LESS) &&
@@ -1275,7 +1274,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 		tg = task_group(current);
 		weight = current->se.load.weight;
 
-		this_load += effective_load(tg, this_cpu, -weight, -weight);
+		affine_load += effective_load(tg, affine_cpu, -weight, -weight);
 		load += effective_load(tg, prev_cpu, 0, -weight);
 	}
 
@@ -1285,16 +1284,16 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	imbalance = 100 + (sd->imbalance_pct - 100) / 2;
 
 	/*
-	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
-	 * due to the sync cause above having dropped this_load to 0, we'll
+	 * In low-load situations, where prev_cpu is idle and affine_cpu is idle
+	 * due to the sync cause above having dropped affine_load to 0, we'll
 	 * always have an imbalance, but there's really nothing you can do
 	 * about that, so that's good too.
 	 *
 	 * Otherwise check if either cpus are near enough in load to allow this
-	 * task to be woken on this_cpu.
+	 * task to be woken on affine_cpu.
 	 */
-	balanced = !this_load ||
-		100*(this_load + effective_load(tg, this_cpu, weight, weight)) <=
+	balanced = !affine_load ||
+		100*(affine_load + effective_load(tg, affine_cpu, weight, weight)) <=
 		imbalance*(load + effective_load(tg, prev_cpu, 0, weight));
 
 	/*
@@ -1306,11 +1305,11 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 		return 1;
 
 	schedstat_inc(p, se.nr_wakeups_affine_attempts);
-	tl_per_task = cpu_avg_load_per_task(this_cpu);
+	tl_per_task = cpu_avg_load_per_task(affine_cpu);
 
 	if (balanced ||
-	    (this_load <= load &&
-	     this_load + target_load(prev_cpu, idx) <= tl_per_task)) {
+	    (affine_load <= load &&
+	     affine_load + target_load(prev_cpu, idx) <= tl_per_task)) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and
@@ -1508,7 +1507,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 			 * If there's an idle sibling in this domain, make that
 			 * the wake_affine target instead of the current cpu.
 			 */
-			if (tmp->flags & SD_PREFER_SIBLING)
+			if (tmp->flags & SD_SHARE_PKG_RESOURCES)
 				target = select_idle_sibling(p, tmp, target);
 
 			if (target >= 0) {
@@ -1544,7 +1543,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 			update_shares(tmp);
 	}
 
-	if (affine_sd && wake_affine(affine_sd, p, sync))
+	if (affine_sd && wake_affine(affine_sd, p, cpu, sync))
 		return cpu;
 
 	while (sd) {



