Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192AbZCHPkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbZCHPkY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 11:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbZCHPkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 11:40:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38547 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbZCHPkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 11:40:09 -0400
Date: Sun, 8 Mar 2009 16:39:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Balazs Scheidler <bazsi@balabit.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: scheduler oddity [bug?]
Message-ID: <20090308153956.GB19658@elte.hu>
References: <1236448069.16726.21.camel@bzorp.balabit> <1236505323.6281.57.camel@marge.simson.net> <1236506309.6972.8.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236506309.6972.8.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> The problem with your particular testcase is that while one 
> half has an avg_overlap (what we use as affinity hint for 
> synchronous wakeups) which triggers the affinity hint, the 
> other half has avg_overlap of zero, what it was born with, so 
> despite significant execution overlap, the scheduler treats 
> them as if they were truly synchronous tasks.

hm, why does it stay on zero?

>  static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
>  {
> +	u64 limit = sysctl_sched_migration_cost;
> +	u64 runtime = p->se.sum_exec_runtime - p->se.prev_sum_exec_runtime;
> +
>  	if (sleep && p->se.last_wakeup) {
>  		update_avg(&p->se.avg_overlap,
>  			   p->se.sum_exec_runtime - p->se.last_wakeup);
>  		p->se.last_wakeup = 0;
> -	}
> +	} else if (p->se.avg_overlap < limit && runtime >= limit)
> +		update_avg(&p->se.avg_overlap, runtime);
>  
>  	sched_info_dequeued(p);
>  	p->sched_class->dequeue_task(rq, p, sleep);

hm, that's weird. We want to limit avg_overlap maintenance to 
true sleeps only.

And this patch only makes a difference in the !sleep case - 
which shouldnt be that common in this workload.

What am i missing? A trace would be nice of a few millisecs of 
runtime of this workload, with a few more trace_printk()'s added 
showing how avg_overlap develops.

Maybe it's some task migration artifact? There we do a 
dequeue/enqueue with sleep=0.

	Ingo
