Return-Path: <linux-kernel-owner+w=401wt.eu-S1760749AbZCYLni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749AbZCYLni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759694AbZCYLnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:43:25 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:51584 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758823AbZCYLnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:43:24 -0400
Date: Wed, 25 Mar 2009 17:13:14 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Balbir Singh <balbir@in.ibm.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 11/11] sched: Add comments to find_busiest_group()
	function.
Message-ID: <20090325114314.GC11302@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090325091239.13992.96090.stgit@sofia.in.ibm.com> <20090325091427.13992.18933.stgit@sofia.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325091427.13992.18933.stgit@sofia.in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 02:44:27PM +0530, Gautham R Shenoy wrote:
> Add /** style comments around find_busiest_group(). Also add a few explanatory
>   */

<snip>

>  static struct sched_group *
>  find_busiest_group(struct sched_domain *sd, int this_cpu,
> @@ -3593,17 +3613,31 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
>  	update_sd_lb_stats(sd, this_cpu, idle, sd_idle, cpus,
>  					balance, &sds);
> 
> +	/* Cases where imbalance does not exist from POV of this_cpu */
> +	/* 1) this_cpu is not the appropriate cpu to perform load balancing
> +	 *    at this level.
> +	 * 2) There is no busy sibling group to pull from.
> +	 * 3) This group is the busiest group.
> +	 * 4) This group is more busy than the avg busieness at this
> +	 *    sched_domain.
> +	 * 5) The imbalance is within the specified limit.
> +	 * 6) Any rebalance would lead to ping-pong
> +	 */
>  	if (balance && !(*balance))
>  		goto ret;
> 
> -	if (!sds.busiest || sds.this_load >= sds.max_load
> -		|| sds.busiest_nr_running == 0)
> +	if (!sds.busiest || sd.busiest_nr_running == 0)
			    ^^^^^^^^^^^^^^^^^^^^
should have been sds.busiest_nr_running. Hence the build failure on tip.

I think I missed compile testing this last patch.

Ingo, could you revert commit 7b6340ef884aff69a54f8a530c73ad9da0a7c388 in
tip/balancing and commit the following patch instead?

--->
sched: Add comments to find_busiest_group() function.

From: Gautham R Shenoy <ego@in.ibm.com>

Add /** style comments around find_busiest_group(). Also add a few explanatory
comments.

This concludes the find_busiest_group() cleanup. The function is down to 72
lines from the original 313 lines.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |   50 ++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 42 insertions(+), 8 deletions(-)


diff --git a/kernel/sched.c b/kernel/sched.c
index 6404ddf..a48cf9d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3572,10 +3572,30 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 }
 /******* find_busiest_group() helpers end here *********************/
 
-/*
- * find_busiest_group finds and returns the busiest CPU group within the
- * domain. It calculates and returns the amount of weighted load which
- * should be moved to restore balance via the imbalance parameter.
+/**
+ * find_busiest_group - Returns the busiest group within the sched_domain
+ * if there is an imbalance. If there isn't an imbalance, and
+ * the user has opted for power-savings, it returns a group whose
+ * CPUs can be put to idle by rebalancing those tasks elsewhere, if
+ * such a group exists.
+ *
+ * Also calculates the amount of weighted load which should be moved
+ * to restore balance.
+ *
+ * @sd: The sched_domain whose busiest group is to be returned.
+ * @this_cpu: The cpu for which load balancing is currently being performed.
+ * @imbalance: Variable which stores amount of weighted load which should
+ *		be moved to restore balance/put a group to idle.
+ * @idle: The idle status of this_cpu.
+ * @sd_idle: The idleness of sd
+ * @cpus: The set of CPUs under consideration for load-balancing.
+ * @balance: Pointer to a variable indicating if this_cpu
+ *	is the appropriate cpu to perform load balancing at this_level.
+ *
+ * Returns:	- the busiest group if imbalance exists.
+ *		- If no imbalance and user has opted for power-savings balance,
+ *		   return the least loaded group whose CPUs can be
+ *		   put to idle by rebalancing its tasks onto our group.
  */
 static struct sched_group *
 find_busiest_group(struct sched_domain *sd, int this_cpu,
@@ -3593,17 +3613,31 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	update_sd_lb_stats(sd, this_cpu, idle, sd_idle, cpus,
 					balance, &sds);
 
+	/* Cases where imbalance does not exist from POV of this_cpu */
+	/* 1) this_cpu is not the appropriate cpu to perform load balancing
+	 *    at this level.
+	 * 2) There is no busy sibling group to pull from.
+	 * 3) This group is the busiest group.
+	 * 4) This group is more busy than the avg busieness at this
+	 *    sched_domain.
+	 * 5) The imbalance is within the specified limit.
+	 * 6) Any rebalance would lead to ping-pong
+	 */
 	if (balance && !(*balance))
 		goto ret;
 
-	if (!sds.busiest || sds.this_load >= sds.max_load
-		|| sds.busiest_nr_running == 0)
+	if (!sds.busiest || sds.busiest_nr_running == 0)
+		goto out_balanced;
+
+	if (sds.this_load >= sds.max_load)
 		goto out_balanced;
 
 	sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
 
-	if (sds.this_load >= sds.avg_load ||
-			100*sds.max_load <= sd->imbalance_pct * sds.this_load)
+	if (sds.this_load >= sds.avg_load)
+		goto out_balanced;
+
+	if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
 		goto out_balanced;
 
 	sds.busiest_load_per_task /= sds.busiest_nr_running;

-- 
Thanks and Regards
gautham
