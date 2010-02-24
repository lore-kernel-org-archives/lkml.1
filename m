Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392Ab0BXRn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 12:43:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:46683 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab0BXRnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 12:43:55 -0500
Subject: Re: change in sched cpu_power causing regressions with SCHED_MC
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>
In-Reply-To: <1266970432.11588.22.camel@sbs-t61.sc.intel.com>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
	 <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
	 <1266057388.557.59599.camel@twins>
	 <1266545807.2909.46.camel@sbs-t61.sc.intel.com>
	 <1266588316.1529.370.camel@laptop>
	 <1266604594.2814.37.camel@sbs-t61.sc.intel.com>
	 <1266608875.1529.749.camel@laptop>
	 <1266609029.4729.1.camel@sbs-t61.sc.intel.com>
	 <1266609734.1529.772.camel@laptop>
	 <1266628424.4729.23.camel@sbs-t61.sc.intel.com>
	 <1266864618.6122.472.camel@laptop>
	 <1266970432.11588.22.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Feb 2010 18:43:38 +0100
Message-ID: <1267033418.16023.326.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 16:13 -0800, Suresh Siddha wrote:
> 
> Ok. Here is the patch with complete changelog. I added "Cc stable" tag
> so that it can be picked up for 2.6.32 and 2.6.33, as we would like to
> see this regression addressed in those kernels. Peter/Ingo: Can you
> please queue this patch for -tip for 2.6.34?
> 

Have picked it up with the following changes, Thanks!


Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -2471,10 +2471,6 @@ static inline void update_sg_lb_stats(st
 	/* Adjust by relative CPU power of the group */
 	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
 
-
-	if (sgs->sum_nr_running)
-		avg_load_per_task =
-				sgs->sum_weighted_load / sgs->sum_nr_running;
 	/*
 	 * Consider the group unbalanced when the imbalance is larger
 	 * than the average weight of two tasks.
@@ -2484,6 +2480,9 @@ static inline void update_sg_lb_stats(st
 	 *      normalized nr_running number somewhere that negates
 	 *      the hierarchy?
 	 */
+	if (sgs->sum_nr_running)
+		avg_load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
+
 	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
 		sgs->group_imb = 1;
 
@@ -2642,6 +2641,13 @@ static inline void calculate_imbalance(s
 		unsigned long *imbalance)
 {
 	unsigned long max_pull, load_above_capacity = ~0UL;
+
+	sds.busiest_load_per_task /= sds.busiest_nr_running;
+	if (sds.group_imb) {
+		sds.busiest_load_per_task = 
+			min(sds.busiest_load_per_task, sds.avg_load);
+	}
+
 	/*
 	 * In the presence of smp nice balancing, certain scenarios can have
 	 * max load less than avg load(as we skip the groups at or below
@@ -2742,7 +2748,6 @@ find_busiest_group(struct sched_domain *
 	 * 4) This group is more busy than the avg busieness at this
 	 *    sched_domain.
 	 * 5) The imbalance is within the specified limit.
-	 * 6) Any rebalance would lead to ping-pong
 	 */
 	if (!(*balance))
 		goto ret;
@@ -2761,12 +2766,6 @@ find_busiest_group(struct sched_domain *
 	if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
 		goto out_balanced;
 
-	sds.busiest_load_per_task /= sds.busiest_nr_running;
-	if (sds.group_imb)
-		sds.busiest_load_per_task =
-			min(sds.busiest_load_per_task, sds.avg_load);
-
-
 	/* Looks like there is an imbalance. Compute it */
 	calculate_imbalance(&sds, this_cpu, imbalance);
 	return sds.busiest;


