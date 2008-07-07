Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYGGD54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYGGD54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 23:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYGGD5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 23:57:48 -0400
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:35716 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754021AbYGGD5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 23:57:48 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jul 2008 23:57:47 EDT
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
To: ngupta@google.com
Date: Mon, 07 Jul 2008 13:51:12 +1000
Message-ID: <487192B0.8090201@cse.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.14 (X11/20080618)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Priorities in Anticipatory I/O scheduler
References: <20080706220551.136430000@elf.corp.google.com> <20080706220612.217985000@elf.corp.google.com>
In-Reply-To: <20080706220612.217985000@elf.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

I have a few observations after a quick read through your patch.


ngupta@google.com wrote:
> Modifications to the Anticipatory I/O scheduler to add multiple priority
> levels. It makes use of anticipation and batching in current
> anticipatory scheduler to implement priorities.
> 
> - Minimizes the latency of highest priority level.
> - Low priority requests wait for high priority requests.
> - Higher priority request break any anticipating low priority request.
> - If single priority level is used the scheduler behaves as an
>   anticipatory scheduler. So no change for existing users.
> 
> With this change, it is possible for a latency sensitive job to coexist
> with background job.
> 
> Other possible use of this patch is in context of I/O subsystem controller.
> It can add another dimension to the parameters controlling a particular cgroup.
> While we can easily divide b/w among existing croups, setting a bound on
> latency is not a feasible solution. Hence in context of storage devices
> bandwidth and priority can be two parameters controlling I/O.
> 
> In this patch I have added a new class IOPRIO_CLASS_LATENCY to differentiate
> notion of absolute priority over existing uses of various time-slice based
> priority classes in cfq. Though internally within anticipatory scheduler all
> of them map to best-effort levels. Hence, one can also use various best-effort
> priority levels.

I don't see the point of this new priority class; I think ``latency sensitive''
is a reasonable definition of real-time.  Especially since you don't actually
use it.

> @@ -21,6 +21,14 @@ config IOSCHED_AS
>  	  deadline I/O scheduler, it can also be slower in some cases
>  	  especially some database loads.
>  
> +config IOPRIO_AS_MAX
> +	int "Number of valid i/o priority levels"
> +	depends on IOSCHED_AS
> +	default "4"
> +	help
> +	  This option controls number of priority levels in anticipatory
> +	  I/O scheduler.

Does this need to be configurable?  There are two ``natural'' choices for this
value; the number of iopriorities (10), or the number of priority classes (3).
Why is any intermediate value useful?

>  /*
>   * rb tree support functions
>   */
> -#define RQ_RB_ROOT(ad, rq)	(&(ad)->sort_list[rq_is_sync((rq))])
> +static inline struct rb_root *rq_rb_root(struct as_data *ad,
> +						struct request *rq)
> +{
> +	return (&(ad)->prio_q[rq_prio_level(rq)].sort_list[rq_is_sync(rq)]);
> +}

This change (and the related ones below) is a separate patch which could
also be applied to deadline.

> @@ -996,6 +1074,31 @@ static void as_move_to_dispatch(struct a
>  	ad->nr_dispatched++;
>  }
>  
> +static unsigned int select_priority_level(struct as_data *ad)
> +{
> +	unsigned int i, best_ioprio = 0, ioprio, found_alt = 0;
> +
> +	for (ioprio = 0; ioprio < IOPRIO_AS_MAX; ioprio++) {
> +		if (!as_has_request_at_priority(ad, ioprio)) {
> +			continue;
> +		}

Unnecessary braces.

> @@ -1022,21 +1126,32 @@ static int as_dispatch_request(struct re
>  		ad->changed_batch = 0;
>  		ad->new_batch = 0;
>  
> -		while (ad->next_rq[REQ_SYNC]) {
> -			as_move_to_dispatch(ad, ad->next_rq[REQ_SYNC]);
> -			dispatched++;
> -		}
> -		ad->last_check_fifo[REQ_SYNC] = jiffies;
> -
> -		while (ad->next_rq[REQ_ASYNC]) {
> -			as_move_to_dispatch(ad, ad->next_rq[REQ_ASYNC]);
> -			dispatched++;
> +		for (ioprio = 0; ioprio < IOPRIO_AS_MAX; ioprio++) {
> +			while (ad->prio_q[ioprio].next_rq[REQ_SYNC]) {
> +				as_move_to_dispatch(ad,
> +				    ad->prio_q[ioprio].next_rq[REQ_SYNC]);
> +				dispatched++;
> +			}
> +			ad->last_check_fifo[REQ_SYNC] = jiffies;
> +
> +			while (ad->prio_q[ioprio].next_rq[REQ_ASYNC]) {
> +				as_move_to_dispatch(ad,
> +				    ad->prio_q[ioprio].next_rq[REQ_ASYNC]);
> +				dispatched++;
> +			}
> +			ad->last_check_fifo[REQ_ASYNC] = jiffies;
>  		}
> -		ad->last_check_fifo[REQ_ASYNC] = jiffies;
>  
>  		return dispatched;
>  	}
>  
> +	ioprio = select_priority_level(ad);
> +	if (ioprio >= IOPRIO_AS_MAX)
> +		return 0;

Why should this ever happen?

> @@ -1049,14 +1164,16 @@ static int as_dispatch_request(struct re
>  		|| ad->changed_batch)
>  		return 0;
>  
> +	changed_ioprio = (ad->batch_ioprio != ioprio)?1:0;

Redundant conditional.

> @@ -1216,9 +1341,39 @@ static void as_deactivate_request(struct
>  static int as_queue_empty(struct request_queue *q)
>  {
>  	struct as_data *ad = q->elevator->elevator_data;
> +	unsigned short ioprio;
>  
> -	return list_empty(&ad->fifo_list[REQ_ASYNC])
> -		&& list_empty(&ad->fifo_list[REQ_SYNC]);
> +	for (ioprio = 0; ioprio < IOPRIO_AS_MAX; ioprio++) {
> +		if (as_has_request_at_priority(ad, ioprio))
> +			return 0;
> +	}
> +	return 1;
> +}
> +
> +static unsigned short as_mapped_priority(unsigned short ioprio)
> +{
> +	unsigned short class = IOPRIO_PRIO_CLASS(ioprio);
> +	unsigned short data = IOPRIO_PRIO_DATA(ioprio);
> +
> +	if (class == IOPRIO_CLASS_BE)
> +		return ((data < IOPRIO_AS_MAX)? ioprio:

Doesn't this mean that requests in the BE class with prio level 0 will map to
the same queues as RT requests?

> +			IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE,
> +						(IOPRIO_AS_MAX - 1)));
> +	else if (class == IOPRIO_CLASS_LATENCY)
> +		return ((data < IOPRIO_AS_MAX)?
> +			IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, data):

Likewise.

> +			IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE,
> +						(IOPRIO_AS_MAX - 1)));
> +	else if (class == IOPRIO_CLASS_RT)
> +		return IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 0);
> +	else if (class == IOPRIO_CLASS_IDLE)
> +		return IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, (IOPRIO_AS_MAX - 1));
> +	else if (class == IOPRIO_CLASS_NONE) {
> +		return IOPRIO_AS_DEFAULT;
> +	} else {
> +		WARN_ON(1);
> +		return IOPRIO_AS_DEFAULT;
> +	}

It looks like you're mapping all ioprios to a prio level in the BE class, and using
that internally.  It would be simpler to use integers in [0, IOPRIO_AS_MAX) internally,
and convert back to ``real'' ioprios where necessary; you do a lot of conversions...
This would also be better expressed as a switch statement.

> @@ -1351,10 +1512,20 @@ static void *as_init_queue(struct reques
>  	init_timer(&ad->antic_timer);
>  	INIT_WORK(&ad->antic_work, as_work_handler);
>  
> -	INIT_LIST_HEAD(&ad->fifo_list[REQ_SYNC]);
> -	INIT_LIST_HEAD(&ad->fifo_list[REQ_ASYNC]);
> -	ad->sort_list[REQ_SYNC] = RB_ROOT;
> -	ad->sort_list[REQ_ASYNC] = RB_ROOT;
> +	for (i = IOPRIO_AS_MAX - 1; i >= 0; i--) {
> +		INIT_LIST_HEAD(&ad->prio_q[i].fifo_list[REQ_SYNC]);
> +		INIT_LIST_HEAD(&ad->prio_q[i].fifo_list[REQ_ASYNC]);
> +		ad->prio_q[i].sort_list[REQ_SYNC] = RB_ROOT;
> +		ad->prio_q[i].sort_list[REQ_ASYNC] = RB_ROOT;
> +		ad->prio_q[i].serviced = 0;
> +		if (i == 0)
> +			ad->prio_q[i].ioprio_wt = 100;
> +		else if (i == 1)
> +			ad->prio_q[i].ioprio_wt = 5;
> +		else
> +			ad->prio_q[i].ioprio_wt = 1;

This seems a bit arbitrary, and means IOPRIO_AS_MAX > 3 is useless unless the weights are
changed manually.



Thanks,
  -- Aaron

