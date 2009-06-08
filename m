Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZFHCFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZFHCFG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 22:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZFHCE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 22:04:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63757 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbZFHCEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 22:04:55 -0400
Message-ID: <4A2C716C.8070808@cn.fujitsu.com>
Date: Mon, 08 Jun 2009 10:03:24 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 16/20] io-controller: IO group refcounting support
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com> <1243377729-2176-17-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1243377729-2176-17-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
>  
>  /**
> @@ -436,7 +443,6 @@ static void bfq_idle_insert(struct io_service_tree *st,
>  {
>  	struct io_entity *first_idle = st->first_idle;
>  	struct io_entity *last_idle = st->last_idle;
> -	struct io_queue *ioq = io_entity_to_ioq(entity);
>  
>  	if (first_idle == NULL || bfq_gt(first_idle->finish, entity->finish))
>  		st->first_idle = entity;
> @@ -444,10 +450,6 @@ static void bfq_idle_insert(struct io_service_tree *st,
>  		st->last_idle = entity;
>  
>  	bfq_insert(&st->idle, entity);
> -
> -	/* Add this queue to idle list */
> -	if (ioq)
> -		list_add(&ioq->queue_list, &ioq->efqd->idle_list);
>  }
>  
>  /**
> @@ -723,8 +725,26 @@ int __bfq_deactivate_entity(struct io_entity *entity, int requeue)
>  void bfq_deactivate_entity(struct io_entity *entity, int requeue)
>  {
>  	struct io_sched_data *sd;
> +	struct io_group *iog;
>  	struct io_entity *parent;
>  
> +	iog = container_of(entity->sched_data, struct io_group, sched_data);
> +
> +	/*
> +	 * Hold a reference to entity's iog until we are done. This function
> +	 * travels the hierarchy and we don't want to free up the group yet
> +	 * while we are traversing the hiearchy. It is possible that this
> +	 * group's cgroup has been removed hence cgroup reference is gone.
> +	 * If this entity was active entity, then its group will not be on
> +	 * any of the trees and it will be freed up the moment queue is
> +	 * freed up in __bfq_deactivate_entity().
> +	 *
> +	 * Hence, hold a reference, deactivate the hierarhcy of entities and
> +	 * then drop the reference which should free up the whole chain of
> +	 * groups.
> +	 */
> +	elv_get_iog(iog);
> +
>  	for_each_entity_safe(entity, parent) {
>  		sd = entity->sched_data;
>  
> @@ -736,21 +756,28 @@ void bfq_deactivate_entity(struct io_entity *entity, int requeue)
>  			 */
>  			break;
>  
> -		if (sd->next_active != NULL)
> +		if (sd->next_active != NULL) {
>  			/*
>  			 * The parent entity is still backlogged and
>  			 * the budgets on the path towards the root
>  			 * need to be updated.
>  			 */
> +			elv_put_iog(iog);
>  			goto update;
> +		}
>  
>  		/*
>  		 * If we reach there the parent is no more backlogged and
>  		 * we want to propagate the dequeue upwards.
> +		 *
> +		 * If entity's group has been marked for deletion, don't
> +		 * requeue the group in idle tree so that it can be freed.
>  		 */
> -		requeue = 1;
> +		if (!iog_deleting(iog))
> +			requeue = 1;

  Hi Vivek,

  IIUC, if the iog is marked deleting, all iogs in the hierarchy don't have a chance 
  to be requeued into idle trees. So, I wonder why do it like this? Why the upper iogs 
  can't be requeued to the idle tree?

-- 
Regards
Gui Jianfeng


