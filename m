Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbYIYJOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbYIYJOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 05:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYIYJOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 05:14:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:42978 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYIYJOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 05:14:38 -0400
Subject: Re: sched:
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080925042108.GA3663@in.ibm.com>
References: <20080925042108.GA3663@in.ibm.com>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 11:14:27 +0200
Message-Id: <1222334067.16700.190.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-25 at 09:51 +0530, Bharata B Rao wrote:
> Hi,
> 
> sched: Maintain only task entities in cfs_rq->tasks list.
> 
> cfs_rq->tasks list is used by the load balancer to iterate
> over all the tasks. Currently it holds all the entities
> (both task and group entities) because of which there is
> a need to check for group entities explicitly during load
> balancing. This patch changes the cfs_rq->tasks list to
> hold only task entities.

Looks fine. Thanks Bharata!

> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/sched_fair.c |   26 +++++++++-----------------
>  1 file changed, 9 insertions(+), 17 deletions(-)
> 
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -586,11 +586,12 @@ account_entity_enqueue(struct cfs_rq *cf
>  	update_load_add(&cfs_rq->load, se->load.weight);
>  	if (!parent_entity(se))
>  		inc_cpu_load(rq_of(cfs_rq), se->load.weight);
> -	if (entity_is_task(se))
> +	if (entity_is_task(se)) {
>  		add_cfs_task_weight(cfs_rq, se->load.weight);
> +		list_add(&se->group_node, &cfs_rq->tasks);
> +	}
>  	cfs_rq->nr_running++;
>  	se->on_rq = 1;
> -	list_add(&se->group_node, &cfs_rq->tasks);
>  }
>  
>  static void
> @@ -599,11 +600,12 @@ account_entity_dequeue(struct cfs_rq *cf
>  	update_load_sub(&cfs_rq->load, se->load.weight);
>  	if (!parent_entity(se))
>  		dec_cpu_load(rq_of(cfs_rq), se->load.weight);
> -	if (entity_is_task(se))
> +	if (entity_is_task(se)) {
>  		add_cfs_task_weight(cfs_rq, -se->load.weight);
> +		list_del_init(&se->group_node);
> +	}
>  	cfs_rq->nr_running--;
>  	se->on_rq = 0;
> -	list_del_init(&se->group_node);
>  }
>  
>  static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
> @@ -1445,19 +1447,9 @@ __load_balance_iterator(struct cfs_rq *c
>  	if (next == &cfs_rq->tasks)
>  		return NULL;
>  
> -	/* Skip over entities that are not tasks */
> -	do {
> -		se = list_entry(next, struct sched_entity, group_node);
> -		next = next->next;
> -	} while (next != &cfs_rq->tasks && !entity_is_task(se));
> -
> -	if (next == &cfs_rq->tasks)
> -		return NULL;
> -
> -	cfs_rq->balance_iterator = next;
> -
> -	if (entity_is_task(se))
> -		p = task_of(se);
> +	se = list_entry(next, struct sched_entity, group_node);
> +	p = task_of(se);
> +	cfs_rq->balance_iterator = next->next;
>  
>  	return p;
>  }
> 
> Regards,
> Bharata.

