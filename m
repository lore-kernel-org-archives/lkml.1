Return-Path: <linux-kernel-owner+w=401wt.eu-S1946350AbXBQCiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946350AbXBQCiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 21:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946363AbXBQCiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 21:38:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:42233 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946350AbXBQCiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 21:38:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,182,1170662400"; 
   d="scan'208"; a="47433373:sNHT20869686"
Date: Fri, 16 Feb 2007 18:03:35 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, rostedt@goodmis.org
Subject: [patch 1/2] sched: fix idle load balancing in softirqd context
Message-ID: <20070216180335.A8744@unix-os.sc.intel.com>
References: <20061211155304.A31760@unix-os.sc.intel.com> <20061213224317.GA2986@elte.hu> <20061213231316.GA13849@elte.hu> <20061213150314.B12795@unix-os.sc.intel.com> <20061213233157.GA20470@elte.hu> <20061213151926.C12795@unix-os.sc.intel.com> <20061219201247.GA12648@elte.hu> <20061219131223.E23105@unix-os.sc.intel.com> <20070116113505.GA6294@elte.hu> <20070130135709.B32010@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <20070130135709.B32010@unix-os.sc.intel.com>; from suresh.b.siddha@intel.com on Tue, Jan 30, 2007 at 01:57:09PM -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Periodic load balancing in recent kernels happen in the softirq.
In certain -rt configurations, these softirqs are handled in softirqd
context. And hence the check for idle processor was always returning
busy (as nr_running > 1).

This patch captures the idle information at the tick and passes this info
to softirq context through an element 'idle_at_tick' in rq.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff -pNru linux-2.6.20.x86_64/kernel/sched.c linux/kernel/sched.c
--- linux-2.6.20.x86_64/kernel/sched.c	2007-02-10 03:41:27.000000000 -0800
+++ linux/kernel/sched.c	2007-02-16 16:22:44.000000000 -0800
@@ -240,6 +240,7 @@ struct rq {
 	unsigned long raw_weighted_load;
 #ifdef CONFIG_SMP
 	unsigned long cpu_load[3];
+	unsigned char idle_at_tick;
 #endif
 	unsigned long long nr_switches;
 
@@ -3350,12 +3351,7 @@ static void run_rebalance_domains(struct
 	struct rq *this_rq = cpu_rq(this_cpu);
 	unsigned long interval;
 	struct sched_domain *sd;
-	/*
-	 * We are idle if there are no processes running. This
-	 * is valid even if we are the idle process (SMT).
-	 */
-	enum idle_type idle = !this_rq->nr_running ?
-				SCHED_IDLE : NOT_IDLE;
+	enum idle_type idle = this_rq->idle_at_tick ? SCHED_IDLE : NOT_IDLE;
 	/* Earliest time when we have to call run_rebalance_domains again */
 	unsigned long next_balance = jiffies + 60*HZ;
 
@@ -3651,20 +3647,21 @@ void scheduler_tick(void)
 {
 	unsigned long long now = sched_clock();
 	struct task_struct *p = current;
-	int cpu = smp_processor_id();
+	int cpu = smp_processor_id(), idle_at_tick = idle_cpu(cpu);
 	struct rq *rq = cpu_rq(cpu);
 
 	BUG_ON(!irqs_disabled());
 
 	update_cpu_clock(p, rq, now);
 
-	if (p == rq->idle)
+	if (idle_at_tick)
 		/* Task on the idle queue */
 		wake_priority_sleeper(rq);
 	else
 		task_running_tick(rq, p);
 #ifdef CONFIG_SMP
 	update_load(rq);
+	rq->idle_at_tick = idle_at_tick;
 	if (time_after_eq(jiffies, rq->next_balance))
 		raise_softirq(SCHED_SOFTIRQ);
 #endif
