Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592Ab0AYLfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab0AYLfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 06:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064Ab0AYLfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 06:35:48 -0500
Received: from mail.gmx.net ([213.165.64.20]:53430 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751335Ab0AYLfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 06:35:47 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/y2Xhp5JnynYCg0EGmLdqBhd27T4gbk0CiG/GxF4
	H/tCcXxvFLdZQq
Subject: Re: netperf ~50% regression with 2.6.33-rc1, bisect to 1b9508f
From: Mike Galbraith <efault@gmx.de>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1264413826.3642.88.camel@minggr.sh.intel.com>
References: <1264413826.3642.88.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Mon, 25 Jan 2010 12:35:42 +0100
Message-Id: <1264419342.5888.42.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.56000000000000005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 18:03 +0800, Lin Ming wrote:

> With above commit, the idle balance was rate limited, so CPU 15(server,
> waiting data from client) is idle at most time.
> 
> CPU0(client) executes as below,
> 
> try_to_wake_up
>    check_preempt_curr_idle
>       resched_task
>          smp_send_reschedule
> 
> This causes a lot of rescheduling IPI.
> 
> This commit can't be reverted due to conflict, so I just add below code
> to disable "Rate-limit newidle" and the performance was recovered.
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 18cceee..588fdef 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4421,9 +4421,6 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
>  
>  	this_rq->idle_stamp = this_rq->clock;
>  
> -	if (this_rq->avg_idle < sysctl_sched_migration_cost)
> -		return;
> -
>  	for_each_domain(this_cpu, sd) {
>  		unsigned long interval;
>  

Heh, so you should see the same thing with newidle disabled, as it was
in .31 and many kernels prior.  Do you?

So.  Rummaging around doing absolutely _nothing_ useful, there being
zero movable tasks in this load, prevents us switching to the idle
thread before the scheduling task is requeued.  Oh joy.

Hm.... <imagines Peter's reaction to a busy wait> :)  OTOH, that's what
it's _doing_ with above patch.

	-Mike



