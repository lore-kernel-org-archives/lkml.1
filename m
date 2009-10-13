Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbZJMO2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbZJMO2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759946AbZJMO2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:28:06 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:8458 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbZJMO2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:28:05 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC v2 PATCH 4/8] sched: Enforce hard limits by throttling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
In-Reply-To: <20090930125252.GE19951@in.ibm.com>
References: <20090930124919.GA19951@in.ibm.com>
	 <20090930125252.GE19951@in.ibm.com>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 16:27:00 +0200
Message-Id: <1255444020.8392.362.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-30 at 18:22 +0530, Bharata B Rao wrote:

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 0f1ea4a..77ace43 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1024,7 +1024,7 @@ struct sched_domain;
>  struct sched_class {
>  	const struct sched_class *next;
>  
> -	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
> +	int (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
>  	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
>  	void (*yield_task) (struct rq *rq);
>  

I really hate this, it uglfies all the enqueue code in a horrid way
(which is most of this patch).

Why can't we simply enqueue the task on a throttled group just like rt?

> @@ -3414,6 +3443,18 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
>  	}
>  
>  	/*
> +	 * Don't migrate the task if it belongs to a
> +	 * - throttled group on its current cpu
> +	 * - throttled group on this_cpu
> +	 * - group whose hierarchy is throttled on this_cpu
> +	 */
> +	if (cfs_rq_throttled(cfs_rq_of(&p->se)) ||
> +		task_group_throttled(task_group(p), this_cpu)) {
> +		schedstat_inc(p, se.nr_failed_migrations_throttled);
> +		return 0;
> +	}
> +
> +	/*
>  	 * Aggressive migration if:
>  	 * 1) task is cache cold, or
>  	 * 2) too many balance attempts have failed.

Simply don't iterate throttled groups?


