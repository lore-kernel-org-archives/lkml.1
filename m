Return-Path: <linux-kernel-owner+w=401wt.eu-S1760014AbZJMO2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014AbZJMO2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759992AbZJMO2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:28:11 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:23044 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759990AbZJMO2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:28:09 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC v2 PATCH 2/8] sched: Maintain aggregated tasks count in
 cfs_rq at each hierarchy level
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
In-Reply-To: <20090930125124.GC19951@in.ibm.com>
References: <20090930124919.GA19951@in.ibm.com>
	 <20090930125124.GC19951@in.ibm.com>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 16:27:01 +0200
Message-Id: <1255444021.8392.364.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-30 at 18:21 +0530, Bharata B Rao wrote:

> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 652e8bd..eeeddb8 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -243,6 +243,27 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
>  
>  #endif	/* CONFIG_FAIR_GROUP_SCHED */
>  
> +static void add_cfs_rq_tasks_running(struct sched_entity *se,
> +		unsigned long count)
> +{
> +	struct cfs_rq *cfs_rq;
> +
> +	for_each_sched_entity(se) {
> +		cfs_rq = cfs_rq_of(se);
> +		cfs_rq->nr_tasks_running += count;
> +	}
> +}
> +
> +static void sub_cfs_rq_tasks_running(struct sched_entity *se,
> +		unsigned long count)
> +{
> +	struct cfs_rq *cfs_rq;
> +
> +	for_each_sched_entity(se) {
> +		cfs_rq = cfs_rq_of(se);
> +		cfs_rq->nr_tasks_running -= count;
> +	}
> +}
>  
>  /**************************************************************
>   * Scheduling class tree data structure manipulation methods:
> @@ -969,6 +990,7 @@ static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
>  		wakeup = 1;
>  	}
>  
> +	add_cfs_rq_tasks_running(&p->se, 1);
>  	hrtick_update(rq);
>  }
>  
> @@ -991,6 +1013,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep)
>  		sleep = 1;
>  	}
>  
> +	sub_cfs_rq_tasks_running(&p->se, 1);
>  	hrtick_update(rq);
>  }

This seems daft, why not add the incement to the for_each_sched_entity()
loop already present in both functions?



