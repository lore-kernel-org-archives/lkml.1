Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYJDLRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYJDLRr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 07:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbYJDLRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 07:17:38 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:10799 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752294AbYJDLRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 07:17:38 -0400
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] sched_rt.c: resch needed in rt_rq_enqueue() for the
	root rt_rq
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dario Faggioli <raistlin@linux.it>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Trimarchi <trimarchimichael@yahoo.it>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1223048447.6714.46.camel@Palanthas>
References: <1223048447.6714.46.camel@Palanthas>
Content-Type: text/plain
Date: Sat, 04 Oct 2008 13:17:45 +0200
Message-Id: <1223119065.28938.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-03 at 17:40 +0200, Dario Faggioli wrote:
> Hi all,
> 
> While working on the new version of the code for SCHED_SPORADIC I
> noticed something strange in the present throttling mechanism. More
> specifically in the throttling timer handler in sched_rt.c
> (do_sched_rt_period_timer()) and in rt_rq_enqueue().
> 
> The problem is that, when unthrottling a runqueue, rt_rq_enqueue() only
> asks for rescheduling if the runqueue has a sched_entity associated to
> it (i.e., rt_rq->rt_se != NULL).
> Now, if the runqueue is the root rq (which has a rt_se = NULL)
> rescheduling does not take place, and it is delayed to some undefined
> instant in the future.
> 
> This imply some random bandwidth usage by the RT tasks under throttling.
> For instance, setting rt_runtime_us/rt_period_us = 950ms/1000ms an RT
> task will get less than 95%. In our tests we got something varying
> between 70% to 95%.
> Using smaller time values, e.g., 95ms/100ms, things are even worse, and
> I can see values also going down to 20-25%!!
> 
> The tests we performed are simply running 'yes' as a SCHED_FIFO task,
> and checking the CPU usage with top, but we can investigate thoroughly
> if you think it is needed.
> 
> Things go much better, for us, with the attached patch... Don't know if
> it is the best approach, but it solved the issue for us.

Its consistent with John Blackwood's change to the !group case
(f3ade837), and looks good.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Ingo, please pickup (might be 27.1 material as well).

Thanks Dario!

> 
> ---
> Signed-off-by: Dario Faggioli <raistlin@linux.it>
> Signed-off-by: Michael Trimarchi <trimarchimichael@yahoo.it>
> ---
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 1113157..37f0721 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -102,12 +102,12 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se);
>  
>  static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
>  {
> +	struct task_struct *curr = rq_of_rt_rq(rt_rq)->curr;
>  	struct sched_rt_entity *rt_se = rt_rq->rt_se;
>  
> -	if (rt_se && !on_rt_rq(rt_se) && rt_rq->rt_nr_running) {
> -		struct task_struct *curr = rq_of_rt_rq(rt_rq)->curr;
> -
> -		enqueue_rt_entity(rt_se);
> +	if (rt_rq->rt_nr_running) {
> +		if (rt_se && !on_rt_rq(rt_se))
> +			enqueue_rt_entity(rt_se);
>  		if (rt_rq->highest_prio < curr->prio)
>  			resched_task(curr);
>  	}
> 

