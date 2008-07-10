Return-Path: <linux-kernel-owner+w=401wt.eu-S932216AbYGJSws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbYGJSws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759192AbYGJSwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:52:39 -0400
Received: from smtp-out.google.com ([216.239.33.17]:55360 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759161AbYGJSwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:52:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=iVxULGHyHBSTRZhGCIob5TgyCCocbcUW2+/iRkrBPQZRyQBhFfiBjpuPwy3FcRE8K
	ZXl173tL0eFy++NyF1kZQ==
Message-ID: <2846be6b0807101152ya53a4e4h701fc266cde86e32@mail.gmail.com>
Date: Thu, 10 Jul 2008 11:52:26 -0700
From: "Naveen Gupta" <ngupta@google.com>
To: "Aaron Carroll" <aaronc@cse.unsw.edu.au>
Subject: Re: [PATCH] Priorities in Anticipatory I/O scheduler
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org
In-Reply-To: <487192B0.8090201@cse.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080706220551.136430000@elf.corp.google.com>
	 <20080706220612.217985000@elf.corp.google.com>
	 <487192B0.8090201@cse.unsw.edu.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Aaron

Thanks for the review.

Some of my comments are inline.

It seems a lot of confusion is regarding the mapping of various
priority levels. The maximum number of levels supported for
best-effort is 8, so the natural choice would be 8. The number (3) you
mentioned below is number of valid classes and is not number of levels
within each class so it isn't even a choice.

The current value is due to our use-case. We need the scheduler to
separate latency sensitive from background traffic. If there is i/o
which we don't care about it can be third priority level, and one
additional for anything else. Hence the default is 4. It can be
changed if needed.

The addition of a new class IOPRIO_CLASS_LATENCY is due to the way we
handle priority v/s cfq. Last I discussed with Jens, we thought we
need a new class, but weren't sure about the name. As it stands now,
if you use BE class for AS it would be effectively same. as
IOPRIO_CLASS_LATENCY. I don't have a strong preference on this.

The mapping is from
RT all levels to - BE 0 (Hence all RT traffic is highest priority)
BE levels remain same.
IDLE maps to BE 3 (Hence idle is lowest priority)

Again thanks for the comments.
-Naveen


2008/7/6 Aaron Carroll <aaronc@cse.unsw.edu.au>:
> Hi Naveen,
>
> I have a few observations after a quick read through your patch.
>
>
> ngupta@google.com wrote:
>>
>> Modifications to the Anticipatory I/O scheduler to add multiple priority
>> levels. It makes use of anticipation and batching in current
>> anticipatory scheduler to implement priorities.
>>
>> - Minimizes the latency of highest priority level.
>> - Low priority requests wait for high priority requests.
>> - Higher priority request break any anticipating low priority request.
>> - If single priority level is used the scheduler behaves as an
>>  anticipatory scheduler. So no change for existing users.
>>
>> With this change, it is possible for a latency sensitive job to coexist
>> with background job.
>>
>> Other possible use of this patch is in context of I/O subsystem
>> controller.
>> It can add another dimension to the parameters controlling a particular
>> cgroup.
>> While we can easily divide b/w among existing croups, setting a bound on
>> latency is not a feasible solution. Hence in context of storage devices
>> bandwidth and priority can be two parameters controlling I/O.
>>
>> In this patch I have added a new class IOPRIO_CLASS_LATENCY to
>> differentiate
>> notion of absolute priority over existing uses of various time-slice based
>> priority classes in cfq. Though internally within anticipatory scheduler
>> all
>> of them map to best-effort levels. Hence, one can also use various
>> best-effort
>> priority levels.
>
> I don't see the point of this new priority class; I think ``latency
> sensitive''
> is a reasonable definition of real-time.  Especially since you don't
> actually
> use it.
>
>> @@ -21,6 +21,14 @@ config IOSCHED_AS
>>          deadline I/O scheduler, it can also be slower in some cases
>>          especially some database loads.
>>  +config IOPRIO_AS_MAX
>> +       int "Number of valid i/o priority levels"
>> +       depends on IOSCHED_AS
>> +       default "4"
>> +       help
>> +         This option controls number of priority levels in anticipatory
>> +         I/O scheduler.
>
> Does this need to be configurable?  There are two ``natural'' choices for
> this
> value; the number of iopriorities (10), or the number of priority classes
> (3).
> Why is any intermediate value useful?
>
>>  /*
>>  * rb tree support functions
>>  */
>> -#define RQ_RB_ROOT(ad, rq)     (&(ad)->sort_list[rq_is_sync((rq))])
>> +static inline struct rb_root *rq_rb_root(struct as_data *ad,
>> +                                               struct request *rq)
>> +{
>> +       return
>> (&(ad)->prio_q[rq_prio_level(rq)].sort_list[rq_is_sync(rq)]);
>> +}
>
> This change (and the related ones below) is a separate patch which could
> also be applied to deadline.

Sure, minus the priority functionality.
>
>> @@ -996,6 +1074,31 @@ static void as_move_to_dispatch(struct a
>>        ad->nr_dispatched++;
>>  }
>>  +static unsigned int select_priority_level(struct as_data *ad)
>> +{
>> +       unsigned int i, best_ioprio = 0, ioprio, found_alt = 0;
>> +
>> +       for (ioprio = 0; ioprio < IOPRIO_AS_MAX; ioprio++) {
>> +               if (!as_has_request_at_priority(ad, ioprio)) {
>> +                       continue;
>> +               }
>
> Unnecessary braces.

Sure. Thanks

>
>> @@ -1022,21 +1126,32 @@ static int as_dispatch_request(struct re
>>                ad->changed_batch = 0;
>>                ad->new_batch = 0;
>>  -               while (ad->next_rq[REQ_SYNC]) {
>> -                       as_move_to_dispatch(ad, ad->next_rq[REQ_SYNC]);
>> -                       dispatched++;
>> -               }
>> -               ad->last_check_fifo[REQ_SYNC] = jiffies;
>> -
>> -               while (ad->next_rq[REQ_ASYNC]) {
>> -                       as_move_to_dispatch(ad, ad->next_rq[REQ_ASYNC]);
>> -                       dispatched++;
>> +               for (ioprio = 0; ioprio < IOPRIO_AS_MAX; ioprio++) {
>> +                       while (ad->prio_q[ioprio].next_rq[REQ_SYNC]) {
>> +                               as_move_to_dispatch(ad,
>> +                                   ad->prio_q[ioprio].next_rq[REQ_SYNC]);
>> +                               dispatched++;
>> +                       }
>> +                       ad->last_check_fifo[REQ_SYNC] = jiffies;
>> +
>> +                       while (ad->prio_q[ioprio].next_rq[REQ_ASYNC]) {
>> +                               as_move_to_dispatch(ad,
>> +
>> ad->prio_q[ioprio].next_rq[REQ_ASYNC]);
>> +                               dispatched++;
>> +                       }
>> +                       ad->last_check_fifo[REQ_ASYNC] = jiffies;
>>                }
>> -               ad->last_check_fifo[REQ_ASYNC] = jiffies;
>>                  return dispatched;
>>        }
>>  +       ioprio = select_priority_level(ad);
>> +       if (ioprio >= IOPRIO_AS_MAX)
>> +               return 0;
>
> Why should this ever happen?
>

If there is no request pending.

>> @@ -1049,14 +1164,16 @@ static int as_dispatch_request(struct re
>>                || ad->changed_batch)
>>                return 0;
>>  +       changed_ioprio = (ad->batch_ioprio != ioprio)?1:0;
>
> Redundant conditional.

Sure thanks.
>
>> @@ -1216,9 +1341,39 @@ static void as_deactivate_request(struct
>>  static int as_queue_empty(struct request_queue *q)
>>  {
>>        struct as_data *ad = q->elevator->elevator_data;
>> +       unsigned short ioprio;
>>  -       return list_empty(&ad->fifo_list[REQ_ASYNC])
>> -               && list_empty(&ad->fifo_list[REQ_SYNC]);
>> +       for (ioprio = 0; ioprio < IOPRIO_AS_MAX; ioprio++) {
>> +               if (as_has_request_at_priority(ad, ioprio))
>> +                       return 0;
>> +       }
>> +       return 1;
>> +}
>> +
>> +static unsigned short as_mapped_priority(unsigned short ioprio)
>> +{
>> +       unsigned short class = IOPRIO_PRIO_CLASS(ioprio);
>> +       unsigned short data = IOPRIO_PRIO_DATA(ioprio);
>> +
>> +       if (class == IOPRIO_CLASS_BE)
>> +               return ((data < IOPRIO_AS_MAX)? ioprio:
>
> Doesn't this mean that requests in the BE class with prio level 0 will map
> to
> the same queues as RT requests?
>
>> +                       IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE,
>> +                                               (IOPRIO_AS_MAX - 1)));
>> +       else if (class == IOPRIO_CLASS_LATENCY)
>> +               return ((data < IOPRIO_AS_MAX)?
>> +                       IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, data):
>
> Likewise.
>
>> +                       IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE,
>> +                                               (IOPRIO_AS_MAX - 1)));
>> +       else if (class == IOPRIO_CLASS_RT)
>> +               return IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 0);
>> +       else if (class == IOPRIO_CLASS_IDLE)
>> +               return IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, (IOPRIO_AS_MAX -
>> 1));
>> +       else if (class == IOPRIO_CLASS_NONE) {
>> +               return IOPRIO_AS_DEFAULT;
>> +       } else {
>> +               WARN_ON(1);
>> +               return IOPRIO_AS_DEFAULT;
>> +       }
>
> It looks like you're mapping all ioprios to a prio level in the BE class,
> and using
> that internally.  It would be simpler to use integers in [0, IOPRIO_AS_MAX)
> internally,
> and convert back to ``real'' ioprios where necessary; you do a lot of
> conversions...
> This would also be better expressed as a switch statement.
>
>> @@ -1351,10 +1512,20 @@ static void *as_init_queue(struct reques
>>        init_timer(&ad->antic_timer);
>>        INIT_WORK(&ad->antic_work, as_work_handler);
>>  -       INIT_LIST_HEAD(&ad->fifo_list[REQ_SYNC]);
>> -       INIT_LIST_HEAD(&ad->fifo_list[REQ_ASYNC]);
>> -       ad->sort_list[REQ_SYNC] = RB_ROOT;
>> -       ad->sort_list[REQ_ASYNC] = RB_ROOT;
>> +       for (i = IOPRIO_AS_MAX - 1; i >= 0; i--) {
>> +               INIT_LIST_HEAD(&ad->prio_q[i].fifo_list[REQ_SYNC]);
>> +               INIT_LIST_HEAD(&ad->prio_q[i].fifo_list[REQ_ASYNC]);
>> +               ad->prio_q[i].sort_list[REQ_SYNC] = RB_ROOT;
>> +               ad->prio_q[i].sort_list[REQ_ASYNC] = RB_ROOT;
>> +               ad->prio_q[i].serviced = 0;
>> +               if (i == 0)
>> +                       ad->prio_q[i].ioprio_wt = 100;
>> +               else if (i == 1)
>> +                       ad->prio_q[i].ioprio_wt = 5;
>> +               else
>> +                       ad->prio_q[i].ioprio_wt = 1;
>
> This seems a bit arbitrary, and means IOPRIO_AS_MAX > 3 is useless unless
> the weights are
> changed manually.

You are right. these are meant to be configurable and workload dependent.
>
>
>
> Thanks,
>  -- Aaron
>
>
