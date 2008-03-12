Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbYCLOtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbYCLOtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 10:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYCLOsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 10:48:55 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:43620 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbYCLOsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 10:48:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gPA2CxewemjBMAzmkEZsfwRGNxxk77qvl/e6VQVRhqEm2KZ5gzE5t++V7IU4lkIsBZ4emES0x1KG8ndkj5BpJ/qB1C0jon/jsC7QUaoCcW/yZhiS2mNxIW4fWHLQW/gGW7F61JgJMQ4uzKybgE2Xyj+krxiiY/LV2iPmrBiU9cw=
Message-ID: <b647ffbd0803120748x2bfc8fbctda15ce3df08fcf5b@mail.gmail.com>
Date: Wed, 12 Mar 2008 15:48:49 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH] sched: fix race in schedule
Cc: "Hiroshi Shimamoto" <h-shimamoto@ct.jp.nec.com>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, hpj@urpla.net,
       stable <stable@kernel.org>
In-Reply-To: <1205328457.8514.244.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47D57770.50909@ct.jp.nec.com> <1205174197.8514.159.camel@twins>
	 <47D593A5.5060906@ct.jp.nec.com> <1205181256.6241.320.camel@lappy>
	 <47D5EA9C.1040404@ct.jp.nec.com> <1205224835.8514.183.camel@twins>
	 <47D6BD0C.6070401@ct.jp.nec.com>
	 <b647ffbd0803111638sdc92903r7faad3d4b2b6b842@mail.gmail.com>
	 <1205328457.8514.244.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2008, Peter Zijlstra <peterz@infradead.org> wrote:
>
> [ ... ]
>
>  > >  Before begin, I can tell that se->on_rq is changed at enqueue_task() or
>  > >  dequeue_task() in sched.c.
>  > >
>  > >  Here is the flow to panic which I got;
>  > >
>  > >    CPU0                               CPU1
>  > >     |                              schedule()
>  > >     |                              ->deactivate_task()
>  > >
>  > >     |                              -->dequeue_task()
>  > >     |                                  * on_rq=0
>  > >     |                              ->put_prev_task_fair()
>  > >
>  > >     |                              ->idle_balance()
>  > >     |                              -->load_balance_newidle()
>  > >
>  > > (a wakeup function)                    |
>  > >
>  > >     |                              --->double_lock_balance()
>  > >     *get lock                          *rel lock
>  > >
>  > >     * wake up target is CPU1's curr    |
>  > >  ->enqueue_task()                      |
>  > >     * on_rq=1                          |
>  > >  ->rt_mutex_setprio()                  |
>  > >     * on_rq=1, ruuning=1               |
>  > >  -->dequeue_task()!!                   |
>  > >  -->put_prev_task_fair()!!             |
>  >
>  > humm... this one should have caused the problem.
>  >
>  > ->put_prev_task() has been previously done in schedule() so we get 2
>  > consequent ->put_prev_task() without set_curr_task/pick_next_task()
>  > being called in between
>  > [ as a result, __enqueue_entitty() is called twice for CPU1's curr and
>  > that definitely corrupts an rb-tree ]
>  >
>  > your initial patch doesn't have this problem. humm... logically-wise,
>  > it looks like a change of the 'current' which can be expressed by a
>  > pair :
>  >
>  > (1) put_prev_task() + (2) pick_next_task() or set_curr_task()
>  > (both end up calling set_next_entity())
>  >
>  > has to be 'atomic' wrt the rq->lock.
>  >
>  > For schedule() that also involves a change of rq->curr.
>
>
> Right, this seems to 'rely' on rq->curr lagging behind put_prev_task().
>  So by doing something like:
>
>
>  ---
>  diff --git a/kernel/sched.c b/kernel/sched.c
>
> index a0c79e9..62d796f 100644
>
> --- a/kernel/sched.c
>  +++ b/kernel/sched.c
>
> @@ -4061,6 +4061,8 @@ need_resched_nonpreemptible:
>                 }
>                 switch_count = &prev->nvcsw;
>         }
>
> +       prev->sched_class->put_prev_task(rq, prev);
>
> +       rq->curr = rq->idle;
>
>
>   #ifdef CONFIG_SMP
>         if (prev->sched_class->pre_schedule)
>
> @@ -4070,14 +4072,13 @@ need_resched_nonpreemptible:
>
>         if (unlikely(!rq->nr_running))
>                 idle_balance(cpu, rq);
>
>  -       prev->sched_class->put_prev_task(rq, prev);
>         next = pick_next_task(rq, prev);
>
> +       rq->curr = next;
>
>
>         sched_info_switch(prev, next);
>
>
>         if (likely(prev != next)) {
>                 rq->nr_switches++;
>  -               rq->curr = next;
>                 ++*switch_count;
>
>                 context_switch(rq, prev, next); /* unlocks the rq */
>  ---

hum, I'm quite suspicious about this approach... mainly, due to the
fact that I think your next assumption is wrong:
(unless we specify 'running' wrt to whom)

>
>  We would avoid being considered running while we're not.
>

the fact is that we are (i.e. 'prev') actually running on a cpu until
some point in context_switch().

At the very least, the load balancer has to exactly know who is the
'current' on other cpus to treat such tasks differently.

With this patch, the load balancer can be confused/broken by the fact
that 'prev' is considered for migration as a "not-on-rq and
not-running" task [ from another cpu at the moment when either
pre_schedule() or idle_balance() drop a rq->lock of prev's cpu ].

well, the version of task_current() for __ARCH_WANT_UNLOCKED_CTXSW
would fix it if used by default.

But maybe there is something esle that would be exposed by the
'rq->curr = rq->idle' manipulation... I can't provide examples right
now though (I need to think on it).


-- 
Best regards,
Dmitry Adamushko
