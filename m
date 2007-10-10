Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbXJJQW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbXJJQW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 12:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbXJJQWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 12:22:19 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:32902 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbXJJQWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 12:22:18 -0400
Date: Wed, 10 Oct 2007 09:22:48 -0700
From: mike kravetz <kravetz@us.ibm.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, peterz@infradead.org, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RT: Fix special-case exception for preempting the local CPU
Message-ID: <20071010162248.GB5049@monkey.ibm.com>
References: <20071010144824.21333.52155.stgit@novell1.haskins.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071010144824.21333.52155.stgit@novell1.haskins.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2007 at 10:49:35AM -0400, Gregory Haskins wrote:
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 3e75c62..b7f7a96 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1869,7 +1869,8 @@ out_activate:
>  		 * extra locking in this particular case, because
>  		 * we are on the current CPU.)
>  		 */
> -		if (TASK_PREEMPTS_CURR(p, this_rq))
> +		if (TASK_PREEMPTS_CURR(p, this_rq)
> +		    && cpu_isset(this_cpu, p->cpus_allowed))
>  			set_tsk_need_resched(this_rq->curr);
>  		else
>  			/*

I wonder if it might better to explicitly take the rq lock and try to
put the task on this_rq in this situation?  Rather than waiting for
schedule to pull it from a remote rq as part of balance_rt_tasks.

A question that has passed through my head a few times is:  When waking
a RT task is it better to:
1) run on current CPU if possible
2) run on CPU task previously ran on

I think #1 may result in lower latency.  But, if the task has lots of
cache warmth the lower wakeup latency may be negated by running on a
'remote' cpu.
-- 
Mike
