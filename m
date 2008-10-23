Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbYJWHYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbYJWHYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 03:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbYJWHYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 03:24:30 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:34845 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYJWHYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 03:24:30 -0400
Date: Thu, 23 Oct 2008 12:52:13 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, travis@sgi.com, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 1/7] work_on_cpu: helper for doing task on a CPU.
Message-ID: <20081023072213.GL5255@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20081023005751.53973DDEFE@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023005751.53973DDEFE@ozlabs.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 01:01:28AM +0000, Rusty Russell wrote:
> 
> Several places in the kernel do the following:
> 
> 	saved_mask = current->cpus_allowed;
> 	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
> 	somefunc();
> 	/* restore the previous state */
> 	set_cpus_allowed_ptr(current, &saved_mask);
> 
> This is bad, because a process's cpumask is observable and
> manipulatable by userspace and should not be toyed with.
> 
> We have the infrastructure, this just creates a nice wrapper to
> encourage its use.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/workqueue.h |    8 +++++++
>  kernel/workqueue.c        |   48 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+)
> 
> diff -r b72e0cbdd249 include/linux/workqueue.h
> --- a/include/linux/workqueue.h	Thu Oct 23 00:39:36 2008 +1100
> +++ b/include/linux/workqueue.h	Thu Oct 23 10:53:51 2008 +1100
> @@ -240,4 +240,12 @@ void cancel_rearming_delayed_work(struct
>  	cancel_delayed_work_sync(work);
> 

<snip>
> + */
> +long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
> +{
> +	struct work_for_cpu wfc;
> +
> +	INIT_WORK(&wfc.work, do_work_for_cpu);
> +	init_completion(&wfc.done);
> +	wfc.fn = fn;
> +	wfc.arg = arg;
> +	get_online_cpus();
> +	if (unlikely(!cpu_online(cpu))) {
> +		wfc.ret = -EINVAL;
> +		complete(&wfc.done);
> +	} else
> +		schedule_work_on(cpu, &wfc.work);

Won't this cause priority inversion in case of real-time tasks ?

> +	put_online_cpus();
> +	wait_for_completion(&wfc.done);
> +
> +	return wfc.ret;
> +}
> +EXPORT_SYMBOL_GPL(work_on_cpu);
> +#endif /* CONFIG_SMP */
> +
>  void __init init_workqueues(void)
>  {
>  	cpu_populated_map = cpu_online_map;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Thanks and Regards
gautham
