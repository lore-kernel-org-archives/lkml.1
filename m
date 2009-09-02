Return-Path: <linux-kernel-owner+w=401wt.eu-S1751719AbZIBL3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbZIBL3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 07:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZIBL3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 07:29:24 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:42489 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZIBL3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 07:29:24 -0400
Date: Wed, 2 Sep 2009 16:59:10 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [RFC][PATCH 7/8] sched: try to deal with low capacity
Message-ID: <20090902112910.GF3817@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090901083431.748830771@chello.nl> <20090901083826.342231003@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901083826.342231003@chello.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 10:34:38AM +0200, Peter Zijlstra wrote:
> When the capacity drops low, we want to migrate load away. Allow the
> load-balancer to remove all tasks when we hit rock bottom.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |   33 ++++++++++++++++++++++++++++-----
>  1 file changed, 28 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -3908,8 +3908,8 @@ static inline void update_sg_lb_stats(st
>  	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
>  		sgs->group_imb = 1;
> 
> -	sgs->group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;
> -
> +	sgs->group_capacity =
> +		DIV_ROUND_CLOSEST(group->__cpu_power, SCHED_LOAD_SCALE);
>  }
> 
>  /**
> @@ -3959,7 +3959,7 @@ static inline void update_sd_lb_stats(st
>  		 * and move all the excess tasks away.
>  		 */
>  		if (prefer_sibling)
> -			sgs.group_capacity = 1;
> +			sgs.group_capacity = min(sgs.group_capacity, 1UL);

Ok, this means that sgs.group_capacity can now be 0, if for some reason
group->__cpu_power happens to be less than SCHED_LOAD_SCALE/2.

In that case, we need the following hunk to make it work for
update_sd_power_savings_stats(). That's because both sum_nr_running and
group_capacity are unsigned longs.

---->
diff --git a/kernel/sched.c b/kernel/sched.c
index 12fdbb8..9952292 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3580,7 +3580,7 @@ static inline void update_sd_power_savings_stats(struct sched_group *group,
 	 * capacity but still has some space to pick up some load
 	 * from other group and save more power
 	 */
-	if (sgs->sum_nr_running > sgs->group_capacity - 1)
+	if (sgs->sum_nr_running + 1 > sgs->group_capacity)
 		return;
 
 	if (sgs->sum_nr_running > sds->leader_nr_running ||

---->


> 
>  		if (local_group) {
>  			sds->this_load = sgs.avg_load;
> @@ -4191,6 +4191,26 @@ ret:
>  	return NULL;
>  }
> 

-- 
Thanks and Regards
gautham
