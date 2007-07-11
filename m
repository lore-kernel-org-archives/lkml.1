Return-Path: <linux-kernel-owner+w=401wt.eu-S1759734AbXGKRGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734AbXGKRGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbXGKRG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:06:28 -0400
Received: from www.osadl.org ([213.239.205.134]:41335 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751052AbXGKRG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:06:27 -0400
Subject: Re: [Patch RT] Fix CFS load balancing for RT tasks
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Linux RT Users <linux-rt-users@vger.kernel.org>,
       Darren Hart <dvhltc@us.ibm.com>, john stultz <johnstul@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20070711164708.48907792@frecb000686.frec.bull.fr>
References: <20070711164708.48907792@frecb000686.frec.bull.fr>
Content-Type: text/plain; charset=utf-8
Date: Wed, 11 Jul 2007 19:06:20 +0200
Message-Id: <1184173580.12353.105.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 16:47 +0200, Sébastien Dugué wrote:
>   The following patch fixes this by re-enabling the RT overload detection
> for the CFS. It may not be the right solution, maybe it should be incorporated
> into the other load balancing mechanisms. I did not digg deep enough yet
> to make that call ;-)
> 
>   P.S. Thanks to Steven Rostedt for logdev which is proving invaluable in
>        cases like this.
> 
>   Sébastien.

Nice catch. That was dropped during the CFS -> -rt merge.

	tglx

> ------------------
> 
>   The RT overload mechanism of the O(1) scheduler has not been activated
> in the new CFS.
> 
>   This patch fixes that by inserting calls to inc_rt_tasks() and dec_rt_tasks()
> in enqueue_task_rt() and dequeue_task_rt() respectively, which enables the
> balance_rt_tasks() to be run in the rt_overload case.
> 
> 
> Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>
> 
> ---
>  kernel/sched_rt.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6.21.5-rt20/kernel/sched_rt.c
> ===================================================================
> --- linux-2.6.21.5-rt20.orig/kernel/sched_rt.c	2007-07-11 10:46:26.000000000 +0200
> +++ linux-2.6.21.5-rt20/kernel/sched_rt.c	2007-07-11 10:46:50.000000000 +0200
> @@ -32,6 +32,8 @@ enqueue_task_rt(struct rq *rq, struct ta
>  
>  	list_add_tail(&p->run_list, array->queue + p->prio);
>  	__set_bit(p->prio, array->bitmap);
> +
> +	inc_rt_tasks(p, rq);
>  }
>  
>  /*
> @@ -44,6 +46,8 @@ dequeue_task_rt(struct rq *rq, struct ta
>  
>  	update_curr_rt(rq, now);
>  
> +	dec_rt_tasks(p, rq);
> +
>  	list_del(&p->run_list);
>  	if (list_empty(array->queue + p->prio))
>  		__clear_bit(p->prio, array->bitmap);

