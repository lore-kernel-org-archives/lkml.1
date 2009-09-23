Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZIWIkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZIWIkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZIWIkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:40:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57166 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbZIWIkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:40:20 -0400
Subject: Re: [PATCH 1/2] perf_counter: cleanup for __perf_event_sched_*()
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AB9D7FA.5040707@cn.fujitsu.com>
References: <4AB88F06.10900@cn.fujitsu.com>
	 <19128.39768.149110.673711@cargo.ozlabs.ibm.com>
	 <4AB98BB0.6020202@cn.fujitsu.com>
	 <19129.38627.94363.857137@cargo.ozlabs.ibm.com>
	 <4AB9D7FA.5040707@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Sep 2009 10:40:30 +0200
Message-Id: <1253695230.7695.122.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 16:10 +0800, Xiao Guangrong wrote:
> Paul Mackerras says:
> 
> "Actually, looking at this more closely, it has to be a group leader
> anyway since it's at the top level of ctx->group_list.  In fact I see
> four places where we do:
> 
>   list_for_each_entry(event, &ctx->group_list, group_entry) {
> 	if (event == event->group_leader)
> 		...
> 
> or the equivalent, three of which appear to have been introduced by
> afedadf2 ("perf_counter: Optimize sched in/out of counters") back in
> May by Peter Z.
> 
> As far as I can see the if () is superfluous in each case (a singleton
> event will be a group of 1 and will have its group_leader pointing to
> itself)."
> 
> [Can be found at http://marc.info/?l=linux-kernel&m=125361238901442&w=2]
> 
> So, this patch fix it.

Hrm.. I think its not just a cleanup, but an actual bugfix.

The intent was to call event_sched_{in,out}() for single counter groups
because that's cheaper than group_sched_{in,out}(), however..

 - as you noticed, I got the condition wrong, it should have read:

     list_empty(&event->sibling_list)

 - it failed to call group_can_go_on() which deals with ->exclusive.

 - it also doesn't call hw_perf_group_sched_in() which might break
   power.

Also, I'm not sure I like the comments and WARN_ON bits, the changelog
should be sufficient.

> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  kernel/perf_event.c |   41 +++++++++++++++++++++++------------------
>  1 files changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 76ac4db..9ca975a 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -1032,10 +1032,13 @@ void __perf_event_sched_out(struct perf_event_context *ctx,
>  	perf_disable();
>  	if (ctx->nr_active) {
>  		list_for_each_entry(event, &ctx->group_list, group_entry) {
> -			if (event != event->group_leader)
> -				event_sched_out(event, cpuctx, ctx);
> -			else
> -				group_sched_out(event, cpuctx, ctx);
> +
> +			/*
> +			 * It has to be a group leader since it's at the top
> +			 * level of ctx->group_list
> +			 */
> +			WARN_ON_ONCE(event != event->group_leader);
> +			group_sched_out(event, cpuctx, ctx);
>  		}
>  	}
>  	perf_enable();
> @@ -1258,12 +1261,14 @@ __perf_event_sched_in(struct perf_event_context *ctx,
>  		if (event->cpu != -1 && event->cpu != cpu)
>  			continue;
>  
> -		if (event != event->group_leader)
> -			event_sched_in(event, cpuctx, ctx, cpu);
> -		else {
> -			if (group_can_go_on(event, cpuctx, 1))
> -				group_sched_in(event, cpuctx, ctx, cpu);
> -		}
> +		/*
> +		 * It has to be a group leader since it's at the top
> +		 * level of ctx->group_list
> +		 */
> +		WARN_ON_ONCE(event != event->group_leader);
> +
> +		if (group_can_go_on(event, cpuctx, 1))
> +			group_sched_in(event, cpuctx, ctx, cpu);
>  
>  		/*
>  		 * If this pinned group hasn't been scheduled,
> @@ -1291,15 +1296,15 @@ __perf_event_sched_in(struct perf_event_context *ctx,
>  		if (event->cpu != -1 && event->cpu != cpu)
>  			continue;
>  
> -		if (event != event->group_leader) {
> -			if (event_sched_in(event, cpuctx, ctx, cpu))
> +		/*
> +		 * It has to be a group leader since it's at the top
> +		 * level of ctx->group_list
> +		 */
> +		WARN_ON_ONCE(event != event->group_leader);
> +
> +		if (group_can_go_on(event, cpuctx, can_add_hw))
> +			if (group_sched_in(event, cpuctx, ctx, cpu))
>  				can_add_hw = 0;
> -		} else {
> -			if (group_can_go_on(event, cpuctx, can_add_hw)) {
> -				if (group_sched_in(event, cpuctx, ctx, cpu))
> -					can_add_hw = 0;
> -			}
> -		}
>  	}
>  	perf_enable();
>   out:
