Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbZIVLMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbZIVLMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755998AbZIVLMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:12:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:48492 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994AbZIVLMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:12:37 -0400
Subject: Re: [PATCH] perf_counter: cleanup for __perf_event_sched_in()
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AB88F06.10900@cn.fujitsu.com>
References: <4AB88F06.10900@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 22 Sep 2009 13:12:31 +0200
Message-Id: <1253617951.7695.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 16:47 +0800, Xiao Guangrong wrote:
> It must be a group leader if event->attr.pinned is "1"

Since we already enforce that on counter creation, this seems OK.

Thanks

> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  kernel/perf_event.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 76ac4db..fdd9c94 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -1258,12 +1258,11 @@ __perf_event_sched_in(struct perf_event_context *ctx,
>  		if (event->cpu != -1 && event->cpu != cpu)
>  			continue;
>  
> -		if (event != event->group_leader)
> -			event_sched_in(event, cpuctx, ctx, cpu);
> -		else {
> -			if (group_can_go_on(event, cpuctx, 1))
> -				group_sched_in(event, cpuctx, ctx, cpu);
> -		}
> +		/* Only a group leader can be pinned */
> +		BUG_ON(event != event->group_leader);
> +
> +		if (group_can_go_on(event, cpuctx, 1))
> +			group_sched_in(event, cpuctx, ctx, cpu);
>  
>  		/*
>  		 * If this pinned group hasn't been scheduled,
