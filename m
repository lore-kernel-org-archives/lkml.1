Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbZCLV3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbZCLV3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 17:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbZCLV3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 17:29:47 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34880 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbZCLV3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 17:29:46 -0400
Message-ID: <49B97EC5.9050109@us.ibm.com>
Date: Thu, 12 Mar 2009 14:29:41 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Arjan van de Ven <arjan@linux.intel.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/futexes] futex: use current->time_slack_ns for rt tasks
 too
References: <20090312075559.9856.28822.stgit@Aeon> <tip-16f4993f4e9860715918efd4eeac928f8de1218b@git.kernel.org> <49B913DC.6040807@linux.intel.com> <1236866529.22914.3694.camel@twins>
In-Reply-To: <1236866529.22914.3694.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-03-12 at 06:53 -0700, Arjan van de Ven wrote:
>> Darren Hart wrote:
>>> Commit-ID:  16f4993f4e9860715918efd4eeac928f8de1218b
>>> Gitweb:     http://git.kernel.org/tip/16f4993f4e9860715918efd4eeac928f8de1218b
>>> Author:     "Darren Hart" <dvhltc@us.ibm.com>
>>> AuthorDate: Thu, 12 Mar 2009 00:55:59 -0700
>>> Commit:     Ingo Molnar <mingo@elte.hu>
>>> CommitDate: Thu, 12 Mar 2009 11:20:57 +0100
>>>
>>> futex: use current->time_slack_ns for rt tasks too
>>>
>>> RT tasks should set their timer slack to 0 on their own.  This
>>> patch removes the 'if (rt_task()) slack = 0;' block in
>>> futex_wait.
>> Hi,
>>
>> can you explain the rationale for this reasoning?
> 
> Yeah, I found it iffy as well, I think we want something like the below
> instead though..
> 
> ---
> 
> Subject: sched: adjust timer_slack_ns on scheduler policy change
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu Mar 12 15:01:02 CET 2009
> 
> Ensure RT tasks have 0 timer slack.

Fork takes care of this by setting the child's default_timer_slack_ns to 
current->timer_slack_ns.  This change takes care of tasks that are 
converted to rt by the user.

What about tasks that are demoted from RT to SCHED_NORMAL?  I'm not sure 
setting it to the default_timer_slack_ns is the right thing since that 
could have been the timer_slack_ns of the rt process it forked from. 
Perhaps heach scheduler class needs to have a default_timer_slack_ns set 
in the class?

> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -5511,10 +5511,12 @@ __setscheduler(struct rq *rq, struct tas
>  	case SCHED_NORMAL:
>  	case SCHED_BATCH:
>  	case SCHED_IDLE:
> +		p->timer_slack_ns = p->default_timer_slack_ns;
>  		p->sched_class = &fair_sched_class;
>  		break;
>  	case SCHED_FIFO:
>  	case SCHED_RR:
> +		p->timer_slack_ns = 0;
>  		p->sched_class = &rt_sched_class;
>  		break;
>  	}
> 


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
