Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYFRNfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYFRNfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 09:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYFRNfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 09:35:07 -0400
Received: from in.cluded.net ([195.159.98.120]:57877 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbYFRNfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 09:35:06 -0400
X-OS: [Linux] 2.6.8 and newer (?)
Message-ID: <48590F09.7000406@uw.no>
Date: Wed, 18 Jun 2008 15:35:05 +0200
From: "Daniel K." <dk@uw.no>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, menage@google.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [BUG: NULL pointer dereference] cgroups and	RT scheduling	interact
 badly.
References: <485445AE.2010602@uw.no> <1213612447.16944.99.camel@twins>	 <4856671B.1020304@uw.no>  <1213624312.16944.104.camel@twins>	 <1213627148.16944.106.camel@twins>  <485682B0.8010805@uw.no>	 <1213629536.16944.109.camel@twins> <1213692557.16944.153.camel@twins>	 <4857AD38.2090601@uw.no>	 <1213732878.3223.95.camel@lappy.programming.kicks-ass.net>	 <48583122.7080409@uw.no> <1213789854.16944.216.camel@twins>
In-Reply-To: <1213789854.16944.216.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2008-06-17 at 21:48 +0000, Daniel K. wrote:
>> I had almost given up trying to break it, but then this happened.
>>
>> [...]
> 
> Ah, fun a race between dequeueing because of runtime quota and
> requeueing because of RR slice length.
> 
>> Yes, I realize I'm starting to sound like a broken record.
> 
> Ah, don't worry - I was just hoping there was an end to the amount of
> glaring bugs in my code :-/

:)

> Reproducing was a bit harder than for you, it took me a whole minute of
> runtime and setting the runtime limit above the RR slice length (and
> realizing you're running RR, not FIFO).
> 
> The below patch (on top of the other one) seems to not make it crash
> this case for at least 15 minutes.

I am happy to say that this nailed it squarely on the head. I no longer
see any of the Oops'es I could quite easily trigger before. I added my
Tested-by, please add it to the patch you sent yesterday as well.

I still have a few gripes with RR scheduling, but that is a topic for
another mail.

> ---
> Subject: sched: rt-group: fix RR buglet
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> In tick_task_rt() we first call update_curr_rt() which can dequeue a runqueue
> due to it running out of runtime, and then we try to requeue it, of it also 
> having exhausted its RR quota. Obviously requeueing something that is no longer
> on the runqueue will not have the expected result.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Daniel K. <dk@uw.no>

> ---
>  kernel/sched_rt.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/sched_rt.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_rt.c
> +++ linux-2.6/kernel/sched_rt.c
> @@ -549,8 +549,10 @@ static
>  void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se)
>  {
>  	struct rt_prio_array *array = &rt_rq->active;
> +	struct list_head *queue = array->queue + rt_se_prio(rt_se);
>  
> -	list_move_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
> +	if (on_rt_rq(rt_se))
> +		list_move_tail(&rt_se->run_list, queue);
>  }
>  
>  static void requeue_task_rt(struct rq *rq, struct task_struct *p)

Daniel K.
