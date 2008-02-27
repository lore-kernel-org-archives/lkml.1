Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbYB0Vrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbYB0Vrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbYB0Vrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:47:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57706 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbYB0Vrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:47:40 -0500
Subject: Re: [PATCH] sched: don't allow rt_runtime_us to be zero for groups
	having rt tasks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080227132459.GE15731@linux.vnet.ibm.com>
References: <20080227110829.GA15731@linux.vnet.ibm.com>
	 <1204116417.6242.383.camel@lappy>
	 <20080227132459.GE15731@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 22:47:19 +0100
Message-Id: <1204148840.6242.413.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-27 at 18:54 +0530, Dhaval Giani wrote:

> This patch checks if we can set the rt_runtime_us to 0. If there is a
> realtime task in the group, we don't want to set the rt_runtime_us as 0
> or bad things will happen.
> 
> Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> ---
>  kernel/sched.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+)
> 
> Index: linux-2.6.25-rc3/kernel/sched.c
> ===================================================================
> --- linux-2.6.25-rc3.orig/kernel/sched.c
> +++ linux-2.6.25-rc3/kernel/sched.c
> @@ -7960,6 +7960,17 @@ static int __rt_schedulable(struct task_
>  	return total + to_ratio(period, runtime) < global_ratio;
>  }
>  
> +/* Must be called with tasklist_lock held */
> +static inline int tg_has_rt_tasks(struct task_group *tg)
> +{
> +	struct task_struct *p;
> +	for_each_process(p) {
> +		if (rt_task(p) && rt_rq_of_se(&p->rt)->tg == tg)
> +			return 1;
> +	}

This should be a do_each_thread() { } while_each_thread(); iteration
loop;

cgroups are thread oriented, not task.

Sorry for missing this earlier.

> +	return 0;
> +}
> +
>  int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
>  {
>  	u64 rt_runtime, rt_period;
> @@ -7971,6 +7982,11 @@ int sched_group_set_rt_runtime(struct ta
>  		rt_runtime = rt_period;
>  
>  	mutex_lock(&rt_constraints_mutex);
> +	read_lock(&tasklist_lock);
> +	if (rt_runtime_us == 0 && tg_has_rt_tasks(tg)) {
> +		err = -EINVAL;
> +		goto unlock;
> +	}
>  	if (!__rt_schedulable(tg, rt_period, rt_runtime)) {
>  		err = -EINVAL;
>  		goto unlock;
> @@ -7979,6 +7995,7 @@ int sched_group_set_rt_runtime(struct ta
>  		rt_runtime = RUNTIME_INF;
>  	tg->rt_runtime = rt_runtime;
>   unlock:
> +	read_unlock(&tasklist_lock);
>  	mutex_unlock(&rt_constraints_mutex);
>  
>  	return err;

